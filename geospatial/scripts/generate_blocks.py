#!/usr/bin/env python3
"""
detect_real_blocks.py

Generate block grid for real plantation area using simple math.
Divides area into 18 (vertical) × 7 (horizontal) = 126 blocks.
"""

import json
from pathlib import Path
from datetime import date

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data" / "real"
BLOCKS_OUT = DATA_DIR / "blocks.geojson"

# Area bounds (top-left, bottom-right)
MIN_LON, MAX_LAT = 102.498786, -0.596848
MAX_LON, MIN_LAT = 102.562492, -0.638490

ESTATE_ID = "estate_demo_01"
ESTATE_NAME = "Real Oil Palm Estate"
ROWS = 18  # vertical divisions
COLS = 7   # horizontal divisions

def generate_block_grid():
    """Generate 18×7 = 126 block grid using simple math."""
    lon_range = MAX_LON - MIN_LON
    lat_range = MAX_LAT - MIN_LAT
    
    block_width = lon_range / COLS
    block_height = lat_range / ROWS
    
    features = []
    block_num = 1
    
    # Iterate top to bottom (row), left to right (col)
    for row in range(ROWS):
        for col in range(COLS):
            # Block corners
            lon1 = MIN_LON + col * block_width
            lon2 = lon1 + block_width
            lat1 = MAX_LAT - row * block_height
            lat2 = lat1 - block_height
            
            # Create polygon (counter-clockwise)
            coords = [
                [lon1, lat1],  # top-left
                [lon2, lat1],  # top-right
                [lon2, lat2],  # bottom-right
                [lon1, lat2],  # bottom-left
                [lon1, lat1]   # close ring
            ]
            
            area_ha = (block_width * 111) * (block_height * 111) / 100  # approximate ha
            
            features.append({
                "type": "Feature",
                "properties": {
                    "block_id": f"B-{block_num:03d}",
                    "block_code": f"B-{block_num:03d}",
                    "block_name": f"Block B-{block_num:03d}",
                    "estate_id": ESTATE_ID,
                    "area_ha": round(area_ha, 2),
                    "geometry_provenance": "grid_division_18x7"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [coords]
                }
            })
            block_num += 1
    
    return features

def write_geojson(features):
    """Write blocks.geojson."""
    fc = {
        "type": "FeatureCollection",
        "name": "blocks",
        "properties": {
            "estate_id": ESTATE_ID,
            "estate_name": ESTATE_NAME,
            "data_type": "grid_division_18x7",
            "crs": "EPSG:4326",
            "detection_method": "grid_based",
            "generated_at": date.today().isoformat(),
            "bounds": {
                "min_lon": MIN_LON,
                "max_lon": MAX_LON,
                "min_lat": MIN_LAT,
                "max_lat": MAX_LAT
            }
        },
        "features": features
    }
    
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with open(BLOCKS_OUT, "w", encoding="utf-8") as f:
        json.dump(fc, f, indent=2, ensure_ascii=False)
    
    print(f"✓ Generated {len(features)} blocks → {BLOCKS_OUT}")

def main():
    print(f"Area: LON {MIN_LON}-{MAX_LON}, LAT {MAX_LAT}-{MIN_LAT}")
    print(f"Expected: {ROWS*COLS} blocks ({ROWS} vertical × {COLS} horizontal)")
    
    features = generate_block_grid()
    write_geojson(features)
    print(f"\nResult: {len(features)} blocks generated")

if __name__ == "__main__":
    main()
