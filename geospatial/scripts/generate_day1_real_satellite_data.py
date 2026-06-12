#!/usr/bin/env python3
"""
generate_day1_real_satellite_data.py

Generate real satellite-derived Day 1 block indicators using Google Earth Engine.

Inputs:
- data/demo/blocks.geojson

Outputs:
- data/demo/block_indicators_latest.json
- data/demo/risk_scores_latest.json
- data/demo/scouting_priority_latest.json

Satellite sources:
- Sentinel-2 SR Harmonized for NDVI and NDMI
- GPM IMERG V07 for rainfall
- FIRMS for hotspot signal
"""

from __future__ import annotations

import json
import math
from datetime import date, timedelta
from pathlib import Path
from typing import Any, Dict, List, Tuple

import os
import ee
from dotenv import load_dotenv

import urllib.request

BLOCKS_PATH = Path("data/demo/blocks.geojson")
OUTPUT_DIR = Path("data/demo")
IMAGE_DIR = Path("data/images")
IMAGE_PADDING_METERS = 500
IMAGE_DIMENSIONS = 1600

load_dotenv()

PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT")

if not PROJECT_ID:
    raise RuntimeError(
        "Missing GOOGLE_CLOUD_PROJECT. Add it to .env or set it as an environment variable."
    )

OBSERVATION_DATE = date.today()
CURRENT_END = OBSERVATION_DATE
CURRENT_START_S2 = OBSERVATION_DATE - timedelta(days=14)
CURRENT_START_RAIN = OBSERVATION_DATE - timedelta(days=30)
CURRENT_START_FIRE = OBSERVATION_DATE - timedelta(days=7)

# Use the same month in previous years as a simple seasonal baseline.
BASELINE_YEARS = [2021, 2022, 2023, 2024, 2025]


def initialize_earth_engine() -> None:
    try:
        ee.Initialize(project=PROJECT_ID)
    except Exception:
        ee.Authenticate()
        ee.Initialize(project=PROJECT_ID)


def load_blocks_geojson() -> Dict[str, Any]:
    with BLOCKS_PATH.open("r", encoding="utf-8") as file:
        return json.load(file)


def geojson_feature_to_ee_feature(feature: Dict[str, Any]) -> ee.Feature:
    geometry = ee.Geometry(feature["geometry"])
    properties = feature["properties"]
    return ee.Feature(geometry, properties)


def blocks_to_feature_collection(blocks_geojson: Dict[str, Any]) -> ee.FeatureCollection:
    features = [
        geojson_feature_to_ee_feature(feature)
        for feature in blocks_geojson["features"]
    ]
    return ee.FeatureCollection(features)


def mask_sentinel2_clouds(image: ee.Image) -> ee.Image:
    """
    Sentinel-2 cloud mask using Scene Classification Layer.

    SCL classes removed:
    3 = cloud shadow
    8 = cloud medium probability
    9 = cloud high probability
    10 = thin cirrus
    11 = snow/ice
    """
    scl = image.select("SCL")
    mask = (
        scl.neq(3)
        .And(scl.neq(8))
        .And(scl.neq(9))
        .And(scl.neq(10))
        .And(scl.neq(11))
    )

    return image.updateMask(mask).divide(10000)


def sentinel2_index_composite(start_date: date, end_date: date, aoi: ee.Geometry) -> ee.Image:
    collection = (
        ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
        .filterBounds(aoi)
        .filterDate(start_date.isoformat(), end_date.isoformat())
        .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 80))
        .map(mask_sentinel2_clouds)
    )

    composite = collection.median()

    ndvi = composite.normalizedDifference(["B8", "B4"]).rename("ndvi")
    ndmi = composite.normalizedDifference(["B8", "B11"]).rename("ndmi")

    return ndvi.addBands(ndmi)

def sentinel2_rgb_composite(start_date: date, end_date: date, aoi: ee.Geometry) -> ee.Image:
    collection = (
        ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
        .filterBounds(aoi)
        .filterDate(start_date.isoformat(), end_date.isoformat())
        .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 80))
        .map(mask_sentinel2_clouds)
    )

    return collection.median().select(["B4", "B3", "B2"])


def padded_aoi(aoi: ee.Geometry, padding_meters: int = IMAGE_PADDING_METERS) -> ee.Geometry:
    """
    Membuat bounding box yang menutup semua koordinat blocks.geojson,
    lalu ditambah padding dalam meter.
    """
    return aoi.bounds(maxError=1).buffer(padding_meters).bounds(maxError=1)


def block_outline(blocks_fc: ee.FeatureCollection, width: int = 3) -> ee.Image:
    """
    Membuat outline putih untuk batas block agar terlihat di atas map.
    """
    return (
        ee.Image()
        .byte()
        .paint(featureCollection=blocks_fc, color=1, width=width)
        .visualize(palette=["ffffff"])
    )


def save_ee_png(image: ee.Image, output_path: Path, region: ee.Geometry, dimensions: int = IMAGE_DIMENSIONS) -> None:
    """
    Simpan ee.Image yang sudah divisualisasikan sebagai PNG lokal.
    """
    url = image.getThumbURL(
        {
            "region": region,
            "dimensions": dimensions,
            "format": "png",
        }
    )

    urllib.request.urlretrieve(url, output_path)


def save_map_images(
    rgb_image: ee.Image,
    index_image: ee.Image,
    blocks_fc: ee.FeatureCollection,
    aoi: ee.Geometry,
) -> None:
    IMAGE_DIR.mkdir(parents=True, exist_ok=True)

    region = padded_aoi(aoi)
    outline = block_outline(blocks_fc)

    real_map = (
        rgb_image.visualize(
            bands=["B4", "B3", "B2"],
            min=0.02,
            max=0.35,
            gamma=1.2,
        )
        .blend(outline)
    )

    ndvi_map = (
        index_image.select("ndvi")
        .visualize(
            min=0.0,
            max=0.9,
            palette=[
                "8b0000",  # very low vegetation
                "d73027",
                "fee08b",
                "d9ef8b",
                "1a9850",  # high vegetation
                "006400",
            ],
        )
        .blend(outline)
    )

    ndmi_map = (
        index_image.select("ndmi")
        .visualize(
            min=-0.4,
            max=0.6,
            palette=[
                "8c510a",  # dry
                "d8b365",
                "f6e8c3",
                "c7eae5",
                "5ab4ac",
                "01665e",  # wetter
            ],
        )
        .blend(outline)
    )

    date_tag = OBSERVATION_DATE.isoformat()

    save_ee_png(real_map, IMAGE_DIR / f"real_map_{date_tag}.png", region)
    save_ee_png(ndvi_map, IMAGE_DIR / f"ndvi_map_{date_tag}.png", region)
    save_ee_png(ndmi_map, IMAGE_DIR / f"ndmi_map_{date_tag}.png", region)

    print("Map images generated.")
    print(f"- {IMAGE_DIR / 'real_map_latest.png'}")
    print(f"- {IMAGE_DIR / 'ndvi_map_latest.png'}")
    print(f"- {IMAGE_DIR / 'ndmi_map_latest.png'}")

def baseline_sentinel2_composite(target_date: date, aoi: ee.Geometry) -> ee.Image:
    monthly_images = []

    for year in BASELINE_YEARS:
        start = date(year, target_date.month, 1)

        if target_date.month == 12:
            end = date(year + 1, 1, 1)
        else:
            end = date(year, target_date.month + 1, 1)

        monthly_images.append(sentinel2_index_composite(start, end, aoi))

    return ee.ImageCollection(monthly_images).median().rename(
        ["ndvi_baseline", "ndmi_baseline"]
    )


def rainfall_sum(start_date: date, end_date: date, aoi: ee.Geometry) -> ee.Image:
    rain = (
        ee.ImageCollection("NASA/GPM_L3/IMERG_V07")
        .filterBounds(aoi)
        .filterDate(start_date.isoformat(), end_date.isoformat())
        .select("precipitation")
        .sum()
        .rename("rainfall_30d_mm")
    )

    return rain


def baseline_rainfall(target_date: date, aoi: ee.Geometry) -> ee.Image:
    baseline_images = []

    for year in BASELINE_YEARS:
        end = date(year, target_date.month, target_date.day)
        start = end - timedelta(days=30)

        baseline_images.append(rainfall_sum(start, end, aoi))

    return ee.ImageCollection(baseline_images).mean().rename("rainfall_baseline_mm")


def hotspot_image(start_date: date, end_date: date, aoi: ee.Geometry) -> ee.Image:
    firms = (
        ee.ImageCollection("FIRMS")
        .filterBounds(aoi)
        .filterDate(start_date.isoformat(), end_date.isoformat())
        .select("T21")
    )

    # Count fire detections per pixel during the last 7 days.
    return firms.count().rename("hotspot_count_7d")


def reduce_block_stats(image: ee.Image, blocks_fc: ee.FeatureCollection, scale: int) -> List[Dict[str, Any]]:
    reduced = image.reduceRegions(
        collection=blocks_fc,
        reducer=ee.Reducer.mean(),
        scale=scale,
        tileScale=4,
    )

    return reduced.getInfo()["features"]


def reduce_hotspot_stats(image: ee.Image, blocks_fc: ee.FeatureCollection) -> List[Dict[str, Any]]:
    reduced = image.reduceRegions(
        collection=blocks_fc,
        reducer=ee.Reducer.sum(),
        scale=1000,
        tileScale=4,
    )

    return reduced.getInfo()["features"]


def safe_float(value: Any, default: float | None = None) -> float | None:
    if value is None:
        return default
    try:
        if isinstance(value, float) and math.isnan(value):
            return default
        return float(value)
    except Exception:
        return default


def clamp(value: float, min_value: float = 0.0, max_value: float = 1.0) -> float:
    return max(min_value, min(value, max_value))


def round_float(value: float | None, digits: int = 4) -> float | None:
    if value is None:
        return None
    return round(float(value), digits)


def category_from_score(score: float) -> str:
    if score < 0.25:
        return "Normal"
    if score < 0.45:
        return "Watch"
    if score < 0.65:
        return "Warning"
    return "Priority Inspection"


def dominant_driver_from_components(
    vegetation_stress: float,
    moisture_stress: float,
    rainfall_stress: float,
    fire_risk: float,
) -> str:
    if max(vegetation_stress, moisture_stress, rainfall_stress, fire_risk) < 0.15:
        return "No significant stress signal"
    components = [
        ("NDVI decline", vegetation_stress),
        ("NDMI drop", moisture_stress),
        ("Rainfall deficit", rainfall_stress),
        ("Hotspot proximity", fire_risk),
    ]

    components.sort(key=lambda item: item[1], reverse=True)

    top_name, top_value = components[0]
    second_name, second_value = components[1]
    pair = {top_name, second_name}

    if pair == {"NDVI decline", "NDMI drop"}:
        return "NDVI decline + NDMI drop"
    if pair == {"NDMI drop", "Rainfall deficit"}:
        return "NDMI drop + rainfall deficit"
    if pair == {"Rainfall deficit", "Hotspot proximity"}:
        return "Rainfall deficit + hotspot proximity"

    if second_value >= 0.55:
        return "Mixed stress signal"

    return top_name


def recommended_action_from_category(category: str, dominant_driver: str) -> str:
    if category == "Priority Inspection":
        if "hotspot" in dominant_driver.lower():
            return "Inspect today and prioritize fire patrol"
        if "rainfall" in dominant_driver.lower() or "NDMI" in dominant_driver:
            return "Inspect today for moisture stress"
        return "Inspect today and verify crop condition"

    if category == "Warning":
        if "hotspot" in dominant_driver.lower():
            return "Inspect this week and monitor fire risk"
        if "rainfall" in dominant_driver.lower() or "NDMI" in dominant_driver:
            return "Inspect this week for water stress"
        return "Inspect this week"

    if category == "Watch":
        return "Monitor next processing cycle"

    return "No urgent action"


def stress_scores_from_indicator(indicator: Dict[str, Any]) -> Tuple[float, float, float, float]:
    ndvi_anomaly = safe_float(indicator["ndvi_anomaly"], 0.0) or 0.0
    ndmi_anomaly = safe_float(indicator["ndmi_anomaly"], 0.0) or 0.0
    rainfall_deficit_pct = safe_float(indicator["rainfall_deficit_pct"], 0.0) or 0.0
    hotspot_count_7d = safe_float(indicator["hotspot_count_7d"], 0.0) or 0.0

    vegetation_stress = clamp(abs(min(0.0, ndvi_anomaly)) / 0.18)
    moisture_stress = clamp(abs(min(0.0, ndmi_anomaly)) / 0.22)
    rainfall_stress = clamp(rainfall_deficit_pct / 60.0)

    # MVP fire risk from count only.
    # You can improve this later with distance-to-nearest-hotspot vector processing.
    fire_risk = clamp(hotspot_count_7d / 3.0)

    return vegetation_stress, moisture_stress, rainfall_stress, fire_risk


def generate_risk_score(indicator: Dict[str, Any]) -> Dict[str, Any]:
    vegetation_stress, moisture_stress, rainfall_stress, fire_risk = stress_scores_from_indicator(indicator)

    risk_score = (
        0.30 * vegetation_stress
        + 0.30 * moisture_stress
        + 0.25 * rainfall_stress
        + 0.15 * fire_risk
    )

    risk_score = round(risk_score, 4)
    risk_category = category_from_score(risk_score)

    dominant_driver = dominant_driver_from_components(
        vegetation_stress,
        moisture_stress,
        rainfall_stress,
        fire_risk,
    )

    return {
        "block_id": indicator["block_id"],
        "score_date": indicator["observation_date"],
        "vegetation_stress": round(vegetation_stress, 4),
        "moisture_stress": round(moisture_stress, 4),
        "rainfall_stress": round(rainfall_stress, 4),
        "fire_risk": round(fire_risk, 4),
        "risk_score": risk_score,
        "risk_category": risk_category,
        "dominant_driver": dominant_driver,
        "recommended_action": recommended_action_from_category(risk_category, dominant_driver),
    }


def generate_scouting_priority(risk_scores: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    sorted_scores = sorted(risk_scores, key=lambda row: row["risk_score"], reverse=True)

    return [
        {
            "priority_rank": index + 1,
            "block_id": row["block_id"],
            "score_date": row["score_date"],
            "risk_score": row["risk_score"],
            "risk_category": row["risk_category"],
            "dominant_driver": row["dominant_driver"],
            "recommended_action": row["recommended_action"],
            "task_status": "monitor_only" if row["risk_category"] == "Normal" else "open",
        }
        for index, row in enumerate(sorted_scores)
    ]


def merge_stats_to_indicators(
    s2_current_features: List[Dict[str, Any]],
    s2_baseline_features: List[Dict[str, Any]],
    estate_rainfall_30d_mm: float | None,
    estate_rainfall_baseline_mm: float | None,  
    hotspot_features: List[Dict[str, Any]],
) -> List[Dict[str, Any]]:
    by_block: Dict[str, Dict[str, Any]] = {}

    def ensure(block_id: str) -> Dict[str, Any]:
        if block_id not in by_block:
            by_block[block_id] = {
                "block_id": block_id,
                "observation_date": OBSERVATION_DATE.isoformat(),
            }
        return by_block[block_id]

    for feature in s2_current_features:
        props = feature["properties"]
        block_id = props["block_id"]
        row = ensure(block_id)
        row["ndvi"] = safe_float(props.get("ndvi"))
        row["ndmi"] = safe_float(props.get("ndmi"))

    for feature in s2_baseline_features:
        props = feature["properties"]
        block_id = props["block_id"]
        row = ensure(block_id)
        row["ndvi_baseline"] = safe_float(props.get("ndvi_baseline"))
        row["ndmi_baseline"] = safe_float(props.get("ndmi_baseline"))

    for feature in hotspot_features:
        props = feature["properties"]
        block_id = props["block_id"]
        row = ensure(block_id)
        row["hotspot_count_7d"] = int(safe_float(props.get("hotspot_count_7d"), 0) or 0)

    indicators = []

    for block_id, row in sorted(by_block.items()):
        ndvi = safe_float(row.get("ndvi"))
        ndvi_baseline = safe_float(row.get("ndvi_baseline"))
        ndmi = safe_float(row.get("ndmi"))
        ndmi_baseline = safe_float(row.get("ndmi_baseline"))
        rainfall_30d_mm = safe_float(estate_rainfall_30d_mm)
        rainfall_baseline_mm = safe_float(estate_rainfall_baseline_mm)

        ndvi_anomaly = None if ndvi is None or ndvi_baseline is None else ndvi - ndvi_baseline
        ndmi_anomaly = None if ndmi is None or ndmi_baseline is None else ndmi - ndmi_baseline

        if rainfall_30d_mm is None or rainfall_baseline_mm in [None, 0]:
            rainfall_deficit_pct = None
        else:
            rainfall_deficit_pct = max(
                0.0,
                (rainfall_baseline_mm - rainfall_30d_mm) / rainfall_baseline_mm * 100,
            )

        indicators.append(
            {
                "block_id": block_id,
                "observation_date": row["observation_date"],
                "ndvi": round_float(ndvi, 4),
                "ndvi_baseline": round_float(ndvi_baseline, 4),
                "ndvi_anomaly": round_float(ndvi_anomaly, 4),
                "ndmi": round_float(ndmi, 4),
                "ndmi_baseline": round_float(ndmi_baseline, 4),
                "ndmi_anomaly": round_float(ndmi_anomaly, 4),
                "rainfall_30d_mm": round_float(rainfall_30d_mm, 2),
                "rainfall_baseline_mm": round_float(rainfall_baseline_mm, 2),
                "rainfall_deficit_pct": round_float(rainfall_deficit_pct, 2),
                "hotspot_count_7d": int(row.get("hotspot_count_7d", 0)),
                "nearest_hotspot_km": None,
                "quality_flag": "real_satellite_partial" if None in [ndvi, ndmi, rainfall_30d_mm] else "real_satellite_valid",
            }
        )

    return indicators


def write_json(path: Path, data: Any) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")

def reduce_estate_mean(image: ee.Image, aoi: ee.Geometry, band_name: str, scale: int = 10000) -> float | None:
    result = image.reduceRegion(
        reducer=ee.Reducer.mean(),
        geometry=aoi,
        scale=scale,
        bestEffort=True,
        maxPixels=1e9,
        tileScale=4,
    ).getInfo()

    value = result.get(band_name)

    if value is None:
        return None

    return float(value)

def main() -> None:
    initialize_earth_engine()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    blocks_geojson = load_blocks_geojson()
    blocks_fc = blocks_to_feature_collection(blocks_geojson)
    aoi = blocks_fc.geometry()

    print("Extracting Sentinel-2 current NDVI/NDMI...")
    s2_current = sentinel2_index_composite(CURRENT_START_S2, CURRENT_END, aoi)
    s2_current_features = reduce_block_stats(s2_current, blocks_fc, scale=10)

    print("Generating real RGB, NDVI, and NDMI map images...")
    s2_rgb = sentinel2_rgb_composite(CURRENT_START_S2, CURRENT_END, aoi)

    save_map_images(
        rgb_image=s2_rgb,
        index_image=s2_current,
        blocks_fc=blocks_fc,
        aoi=aoi,
    )

    print("Extracting Sentinel-2 baseline NDVI/NDMI...")
    s2_baseline = baseline_sentinel2_composite(OBSERVATION_DATE, aoi)
    s2_baseline_features = reduce_block_stats(s2_baseline, blocks_fc, scale=10)

    print("Extracting estate-level GPM IMERG current 30-day rainfall...")
    rain_current = rainfall_sum(CURRENT_START_RAIN, CURRENT_END, aoi)
    estate_rainfall_30d_mm = reduce_estate_mean(
        image=rain_current,
        aoi=aoi,
        band_name="rainfall_30d_mm",
        scale=10000,
    )

    print("Extracting estate-level GPM IMERG rainfall baseline...")
    rain_base = baseline_rainfall(OBSERVATION_DATE, aoi)
    estate_rainfall_baseline_mm = reduce_estate_mean(
        image=rain_base,
        aoi=aoi,
        band_name="rainfall_baseline_mm",
        scale=10000,
    )

    print("Extracting FIRMS hotspot count...")
    hotspot = hotspot_image(CURRENT_START_FIRE, CURRENT_END, aoi)
    hotspot_features = reduce_hotspot_stats(hotspot, blocks_fc)

    indicators = merge_stats_to_indicators(
        s2_current_features=s2_current_features,
        s2_baseline_features=s2_baseline_features,
        estate_rainfall_30d_mm=estate_rainfall_30d_mm,
        estate_rainfall_baseline_mm=estate_rainfall_baseline_mm,
        hotspot_features=hotspot_features,
    )

    risk_scores = [generate_risk_score(row) for row in indicators]
    scouting_priority = generate_scouting_priority(risk_scores)

    write_json(OUTPUT_DIR / "block_indicators_latest.json", indicators)
    write_json(OUTPUT_DIR / "risk_scores_latest.json", risk_scores)
    write_json(OUTPUT_DIR / "scouting_priority_latest.json", scouting_priority)

    print("Real satellite-derived data generated.")
    print(f"- {OUTPUT_DIR / 'block_indicators_latest.json'}")
    print(f"- {OUTPUT_DIR / 'risk_scores_latest.json'}")
    print(f"- {OUTPUT_DIR / 'scouting_priority_latest.json'}")


if __name__ == "__main__":
    main()