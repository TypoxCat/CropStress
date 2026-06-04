"""
Generate real maps, NDVI maps, and NDMI maps for plantation blocks.

This script reads block boundaries from blocks.geojson, computes bounding boxes with padding,
and uses Google Earth Engine to fetch satellite imagery and calculate spectral indices.

Maps are saved to: geospatial/data/images/{block_id}/

Usage:
    python generate_map_images.py
    
    Set PADDING_DEGREES for map expansion (default: 0.01 degrees ≈ 1.1 km)
    Set DATE_RANGE to select imagery period (default: latest available)
"""

import json
import os
import sys
import warnings
from pathlib import Path
from datetime import datetime, timedelta

try:
    import ee
    import geemap
    import numpy as np
    from PIL import Image
    import requests
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install with: pip install earthengine-api geemap pillow requests")
    sys.exit(1)

# Configuration
PADDING_DEGREES = 0.01  # ~1.1 km padding around blocks
DATE_RANGE_DAYS = 365  # Look back 1 year for imagery
OUTPUT_DIR = Path(__file__).parent.parent / "data" / "images"
BLOCKS_GEOJSON = Path(__file__).parent.parent / "data" / "demo" / "blocks.geojson"

# Sentinel-2 cloud cover threshold (0-100)
CLOUD_COVER_MAX = 20

# Image resolution (meters per pixel)
IMAGE_RESOLUTION = 20  # Sentinel-2 native resolution

PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT")

def initialize_earth_engine():
    """Initialize Google Earth Engine with authentication."""
    try:
        ee.Authenticate()
        print("✓ Authenticated with Google Earth Engine")
    except Exception as e:
        print(f"Warning: Earth Engine auth may be needed. Error: {e}")
    
    try:
        ee.Initialize(project=PROJECT_ID)
        print("✓ Initialized Earth Engine")
    except Exception:
        try:
            ee.Initialize()
            print("✓ Initialized Earth Engine (default project)")
        except Exception as e:
            print(f"✗ Failed to initialize Earth Engine: {e}")
            print("Run: earthengine authenticate")
            return False
    return True


def load_blocks_geojson():
    """Load block boundaries from GeoJSON."""
    if not BLOCKS_GEOJSON.exists():
        raise FileNotFoundError(f"blocks.geojson not found at {BLOCKS_GEOJSON}")
    
    with open(BLOCKS_GEOJSON) as f:
        data = json.load(f)
    
    print(f"✓ Loaded {len(data['features'])} blocks from {BLOCKS_GEOJSON.name}")
    return data["features"]


def get_bounds_with_padding(polygon_coords, padding=PADDING_DEGREES):
    """
    Extract bounding box from polygon coordinates with padding.
    
    Args:
        polygon_coords: List of [lon, lat] pairs
        padding: Degrees to expand bounds
    
    Returns:
        dict with keys: min_lon, max_lon, min_lat, max_lat
    """
    lons = [coord[0] for coord in polygon_coords]
    lats = [coord[1] for coord in polygon_coords]
    
    bounds = {
        "min_lon": min(lons) - padding,
        "max_lon": max(lons) + padding,
        "min_lat": min(lats) - padding,
        "max_lat": max(lats) + padding,
    }
    return bounds


def create_ee_geometry(bounds):
    """Create Earth Engine geometry from bounds."""
    return ee.Geometry.Rectangle([
        bounds["min_lon"],
        bounds["min_lat"],
        bounds["max_lon"],
        bounds["max_lat"]
    ])


def get_sentinel2_collection(geometry, start_date, end_date):
    """
    Get filtered Sentinel-2 image collection.
    
    Returns the most recent cloud-free composite.
    """
    collection = (
        ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
        .filterBounds(geometry)
        .filterDate(start_date, end_date)
        .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", CLOUD_COVER_MAX))
        .sort("CLOUD_PIXEL_PERCENTAGE")
    )
    
    if collection.size().getInfo() == 0:
        print(f"    ⚠ No cloud-free Sentinel-2 images found for date range")
        return None
    
    return collection.first()


def create_ndvi_layer(image):
    """Calculate NDVI (Normalized Difference Vegetation Index)."""
    nir = image.select("B8")   # NIR band
    red = image.select("B4")   # Red band
    ndvi = nir.subtract(red).divide(nir.add(red)).rename("NDVI")
    return ndvi


def create_ndmi_layer(image):
    """Calculate NDMI (Normalized Difference Moisture Index)."""
    nir = image.select("B8")   # NIR band
    swir = image.select("B11")  # SWIR band
    ndmi = nir.subtract(swir).divide(nir.add(swir)).rename("NDMI")
    return ndmi


def create_rgb_layer(image):
    """Extract RGB bands (B4=Red, B3=Green, B2=Blue) for true color composite."""
    rgb = image.select(["B4", "B3", "B2"]).rename(["red", "green", "blue"])
    return rgb


def save_map_image(image_layer, geometry, block_id, map_type, block_dir):
    """
    Download and save an image from Earth Engine.
    
    Args:
        image_layer: ee.Image to download
        geometry: ee.Geometry for the area
        block_id: Block identifier
        map_type: "rgb" | "ndvi" | "ndmi"
        block_dir: Output directory for this block
    """
    filename = f"{block_id}_{map_type}.tif"
    filepath = block_dir / filename
    
    try:
        # Prepare download parameters
        if map_type == "rgb":
            # For RGB, scale to 0-255 and keep as 3 bands
            image_layer = image_layer.unitScale(0, 3000).multiply(255).uint8()
        else:
            # For indices, scale to 0-255 (indices range from -1 to 1)
            image_layer = image_layer.unitScale(-1, 1).multiply(255).uint8()
        
        # Get download URL
        url = image_layer.getDownloadURL({
            "scale": IMAGE_RESOLUTION,
            "region": geometry,
            "format": "GEO_TIFF",
            "maxPixels": 1e9
        })
        
        # Download the file
        response = requests.get(url, timeout=60)
        response.raise_for_status()
        
        with open(filepath, "wb") as f:
            f.write(response.content)
        
        print(f"    ✓ {map_type.upper()}: {filename}")
        return True
        
    except Exception as e:
        print(f"    ✗ {map_type.upper()}: {str(e)[:60]}")
        return False


def process_block(feature, start_date, end_date):
    """
    Process a single block: generate real map, NDVI, and NDMI.
    
    Args:
        feature: GeoJSON feature (block)
        start_date: ee.Date for start of imagery period
        end_date: ee.Date for end of imagery period
    """
    block_id = feature["properties"]["block_id"]
    block_dir = OUTPUT_DIR / block_id
    block_dir.mkdir(parents=True, exist_ok=True)
    
    # Extract bounds with padding
    polygon_coords = feature["geometry"]["coordinates"][0]
    bounds = get_bounds_with_padding(polygon_coords, PADDING_DEGREES)
    geometry = create_ee_geometry(bounds)
    
    # Get Sentinel-2 imagery
    s2_image = get_sentinel2_collection(geometry, start_date, end_date)
    if s2_image is None:
        print(f"  {block_id}: Skipped (no imagery available)")
        return
    
    print(f"  {block_id}:")
    
    # Generate layers
    rgb = create_rgb_layer(s2_image)
    ndvi = create_ndvi_layer(s2_image)
    ndmi = create_ndmi_layer(s2_image)
    
    # Save maps
    save_map_image(rgb, geometry, block_id, "rgb", block_dir)
    save_map_image(ndvi, geometry, block_id, "ndvi", block_dir)
    save_map_image(ndmi, geometry, block_id, "ndmi", block_dir)


def main():
    """Main execution."""
    print("\n" + "=" * 60)
    print("CropStress Map Generator")
    print("=" * 60 + "\n")
    
    # Initialize
    if not initialize_earth_engine():
        sys.exit(1)
    
    # Load blocks
    features = load_blocks_geojson()
    
    # Set date range
    end_date = datetime.now()
    start_date = end_date - timedelta(days=DATE_RANGE_DAYS)
    
    print(f"\nDate range: {start_date.date()} to {end_date.date()}")
    print(f"Output directory: {OUTPUT_DIR}")
    print(f"Padding: {PADDING_DEGREES}° (~{PADDING_DEGREES * 111:.1f} km)\n")
    
    # Process each block
    ee_start = ee.Date(start_date.isoformat())
    ee_end = ee.Date(end_date.isoformat())
    
    for i, feature in enumerate(features, 1):
        print(f"[{i}/{len(features)}]", end=" ")
        process_block(feature, ee_start, ee_end)
    
    print("\n" + "=" * 60)
    print(f"✓ Complete. Maps saved to: {OUTPUT_DIR}")
    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
