#!/usr/bin/env python3
"""
generate_images.py

Generate single satellite RGB, NDVI, NDMI map covering all blocks with overlay.
"""

from pathlib import Path
from datetime import date, timedelta
import json
import ee
import os
from dotenv import load_dotenv
import urllib.request

BASE_DIR = Path(__file__).resolve().parents[1]
BLOCKS_PATH = BASE_DIR / "data" / "real" / "blocks.geojson"
IMAGE_DIR = BASE_DIR / "data" / "images"

IMAGE_PADDING_METERS = 500
IMAGE_DIMENSIONS = 1600
OBSERVATION_DATE = date.today()
CURRENT_END = OBSERVATION_DATE
CURRENT_START_S2 = OBSERVATION_DATE - timedelta(days=180)

load_dotenv()
PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT")
if not PROJECT_ID:
    raise RuntimeError("Missing GOOGLE_CLOUD_PROJECT in .env")

try:
    ee.Initialize(project=PROJECT_ID)
except:
    ee.Authenticate()
    ee.Initialize(project=PROJECT_ID)

def get_s2_sr_cld_col(aoi, start_date, end_date):
    """Build S2 SR collection with S2Cloudless joined (official method)."""
    s2_sr_col = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")\
        .filterBounds(aoi)\
        .filterDate(start_date, end_date)\
        .filter(ee.Filter.lte("CLOUDY_PIXEL_PERCENTAGE", 80))
    
    s2_cloudless_col = ee.ImageCollection("COPERNICUS/S2_CLOUD_PROBABILITY")\
        .filterBounds(aoi)\
        .filterDate(start_date, end_date)
    
    return ee.ImageCollection(ee.Join.saveFirst("s2cloudless").apply(
        primary=s2_sr_col,
        secondary=s2_cloudless_col,
        condition=ee.Filter.equals(leftField="system:index", rightField="system:index")
    ))

def add_cloud_bands(img):
    """Add cloud probability and binary cloud mask."""
    cld_prb = ee.Image(img.get("s2cloudless")).select("probability")
    is_cloud = cld_prb.gt(40).rename("clouds")
    return img.addBands(ee.Image([cld_prb, is_cloud]))

def apply_cld_mask(img):
    """Apply cloud mask to image."""
    not_cld = img.select("clouds").Not()
    return img.select("B.*").updateMask(not_cld)

def padded_aoi(aoi, padding_meters=IMAGE_PADDING_METERS):
    return aoi.bounds(maxError=1).buffer(padding_meters).bounds(maxError=1)

def block_outline(blocks_fc, width=3):
    """Create white outline of block boundaries."""
    return ee.Image().byte().paint(featureCollection=blocks_fc, color=1, width=width).visualize(palette=["ffffff"])

def save_ee_png(image, path, region, dimensions=IMAGE_DIMENSIONS):
    url = image.getThumbURL({"region": region, "dimensions": dimensions, "format":"png"})
    path.parent.mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, path)
    print(f"  ✓ {path.name}")

def main():
    if not BLOCKS_PATH.exists():
        print(f"ERROR: {BLOCKS_PATH} not found. Run generate_blocks.py first.")
        return
    
    with open(BLOCKS_PATH, "r", encoding="utf-8") as f:
        blocks_geojson = json.load(f)
    
    blocks_fc = ee.FeatureCollection([
        ee.Feature(ee.Geometry(f["geometry"]), f["properties"])
        for f in blocks_geojson["features"]
    ])
    aoi = blocks_fc.geometry()
    region = padded_aoi(aoi)
    
    print(f"Generating RGB, NDVI, NDMI maps for {len(blocks_geojson['features'])} blocks...")
    
    # Get S2 SR + S2Cloudless joined collection (official method)
    col = get_s2_sr_cld_col(aoi, CURRENT_START_S2.isoformat(), CURRENT_END.isoformat())
    col = col.map(add_cloud_bands).map(apply_cld_mask)
    
    if col.size().getInfo() == 0:
        print("ERROR: No Sentinel-2 imagery found")
        return
    
    comp = col.median()
    print(f"✓ Using composite from {col.size().getInfo()} cloud-free images")
    
    rgb = comp.select(["B4","B3","B2"])
    ndvi = comp.normalizedDifference(["B8","B4"]).rename("ndvi")
    ndmi = comp.normalizedDifference(["B8","B11"]).rename("ndmi")
    
    # Create outlines
    outline = block_outline(blocks_fc)
    
    # Visualize with proper ranges (B4,B3,B2 are 0-10000 range)
    real_map = rgb.visualize(bands=["B4","B3","B2"], min=0, max=2500, gamma=1.1).blend(outline)
    ndvi_map = ndvi.visualize(min=0.0, max=0.9, palette=["8b0000","d73027","fee08b","d9ef8b","1a9850","006400"]).blend(outline)
    ndmi_map = ndmi.visualize(min=-0.4, max=0.6, palette=["8c510a","d8b365","f6e8c3","c7eae5","5ab4ac","01665e"]).blend(outline)
    
    date_tag = OBSERVATION_DATE.isoformat()
    save_ee_png(real_map, IMAGE_DIR / f"real_map_{date_tag}.png", region)
    save_ee_png(ndvi_map, IMAGE_DIR / f"ndvi_map_{date_tag}.png", region)
    save_ee_png(ndmi_map, IMAGE_DIR / f"ndmi_map_{date_tag}.png", region)
    
    print(f"Maps saved to {IMAGE_DIR}")

if __name__ == "__main__":
    main()