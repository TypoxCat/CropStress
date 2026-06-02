#!/usr/bin/env python3
"""
generate_day1_data.py

Generate Day 1 demo geospatial data for CropStress Insight MVP.

Outputs:
- data/demo/blocks.geojson
- data/demo/block_indicators_latest.json
- data/demo/risk_scores_latest.json
- data/demo/scouting_priority_latest.json
- docs/data_generation_day1.md

This script intentionally creates realistic synthetic demo data for a "Demo Estate".
Do not present the generated values as real plantation field observations.
"""

from __future__ import annotations

import json
import math
import random
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any, Dict, List, Tuple


# ---------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------

RANDOM_SEED = 42
OBSERVATION_DATE = date.today().isoformat()

ESTATE_ID = "estate_demo_01"
ESTATE_NAME = "Demo Estate"

# Approximate plantation-like AOI in Indonesia.
# Coordinates are synthetic and used only for demo visualization.
# Format: lon, lat
AOI_MIN_LON = 101.3600
AOI_MIN_LAT = -0.5300
AOI_MAX_LON = 101.4600
AOI_MAX_LAT = -0.4500

ROWS = 6
COLS = 8
TOTAL_BLOCKS = ROWS * COLS

OUTPUT_DIR = Path("data/demo")
DOCS_DIR = Path("docs")


# ---------------------------------------------------------------------
# Data models
# ---------------------------------------------------------------------

@dataclass
class Block:
    block_id: str
    block_code: str
    block_name: str
    estate_id: str
    area_ha: float
    polygon: List[List[float]]


# ---------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------

def ensure_dirs() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_DIR.mkdir(parents=True, exist_ok=True)


def clamp(value: float, min_value: float = 0.0, max_value: float = 1.0) -> float:
    return max(min_value, min(value, max_value))


def round_float(value: float, ndigits: int = 4) -> float:
    return round(float(value), ndigits)


def polygon_area_ha_rough(polygon: List[List[float]]) -> float:
    """
    Rough polygon area in hectares for small lat/lon rectangles.

    This approximation is sufficient for synthetic MVP demo blocks.
    For real production data, calculate area using an equal-area projection.
    """
    min_lon = min(point[0] for point in polygon)
    max_lon = max(point[0] for point in polygon)
    min_lat = min(point[1] for point in polygon)
    max_lat = max(point[1] for point in polygon)

    center_lat = (min_lat + max_lat) / 2.0
    meters_per_degree_lat = 111_320
    meters_per_degree_lon = 111_320 * math.cos(math.radians(center_lat))

    width_m = (max_lon - min_lon) * meters_per_degree_lon
    height_m = (max_lat - min_lat) * meters_per_degree_lat

    area_m2 = abs(width_m * height_m)
    return round(area_m2 / 10_000, 2)


def category_from_score(score: float) -> str:
    if score < 0.25:
        return "Normal"
    if score < 0.45:
        return "Watch"
    if score < 0.65:
        return "Warning"
    return "Priority Inspection"


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


def dominant_driver_from_components(
    vegetation_stress: float,
    moisture_stress: float,
    rainfall_stress: float,
    fire_risk: float,
) -> str:
    components = [
        ("NDVI decline", vegetation_stress),
        ("NDMI drop", moisture_stress),
        ("Rainfall deficit", rainfall_stress),
        ("Hotspot proximity", fire_risk),
    ]
    components.sort(key=lambda item: item[1], reverse=True)

    top_name, top_value = components[0]
    second_name, second_value = components[1]

    # If there is no strong signal, use the leading single driver.
    if top_value < 0.35:
        return top_name

    # Use allowed combined labels where possible.
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


# ---------------------------------------------------------------------
# Block generation
# ---------------------------------------------------------------------

def generate_blocks() -> List[Block]:
    random.seed(RANDOM_SEED)

    lon_step = (AOI_MAX_LON - AOI_MIN_LON) / COLS
    lat_step = (AOI_MAX_LAT - AOI_MIN_LAT) / ROWS

    blocks: List[Block] = []
    block_number = 1

    for row in range(ROWS):
        for col in range(COLS):
            min_lon = AOI_MIN_LON + col * lon_step
            max_lon = min_lon + lon_step
            min_lat = AOI_MIN_LAT + row * lat_step
            max_lat = min_lat + lat_step

            # Add tiny jitter while keeping block rectangles valid.
            jitter_lon = lon_step * 0.04
            jitter_lat = lat_step * 0.04

            min_lon_j = min_lon + random.uniform(-jitter_lon, jitter_lon)
            max_lon_j = max_lon + random.uniform(-jitter_lon, jitter_lon)
            min_lat_j = min_lat + random.uniform(-jitter_lat, jitter_lat)
            max_lat_j = max_lat + random.uniform(-jitter_lat, jitter_lat)

            polygon = [
                [round_float(min_lon_j, 6), round_float(min_lat_j, 6)],
                [round_float(max_lon_j, 6), round_float(min_lat_j, 6)],
                [round_float(max_lon_j, 6), round_float(max_lat_j, 6)],
                [round_float(min_lon_j, 6), round_float(max_lat_j, 6)],
                [round_float(min_lon_j, 6), round_float(min_lat_j, 6)],
            ]

            block_id = f"B-{block_number:03d}"

            blocks.append(
                Block(
                    block_id=block_id,
                    block_code=block_id,
                    block_name=f"Block {block_id}",
                    estate_id=ESTATE_ID,
                    area_ha=polygon_area_ha_rough(polygon),
                    polygon=polygon,
                )
            )
            block_number += 1

    return blocks


def blocks_to_geojson(blocks: List[Block]) -> Dict[str, Any]:
    features = []

    for block in blocks:
        features.append(
            {
                "type": "Feature",
                "properties": {
                    "block_id": block.block_id,
                    "block_code": block.block_code,
                    "block_name": block.block_name,
                    "estate_id": block.estate_id,
                    "area_ha": block.area_ha,
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [block.polygon],
                },
            }
        )

    return {
        "type": "FeatureCollection",
        "name": "blocks",
        "properties": {
            "estate_id": ESTATE_ID,
            "estate_name": ESTATE_NAME,
            "data_type": "synthetic_demo",
            "crs": "EPSG:4326",
        },
        "features": features,
    }


# ---------------------------------------------------------------------
# Indicator and risk generation
# ---------------------------------------------------------------------

def generate_indicator_for_block(index: int, block: Block) -> Dict[str, Any]:
    """
    Generate realistic synthetic indicator values.

    The pattern intentionally creates a mix of:
    - Normal
    - Watch
    - Warning
    - Priority Inspection

    so the MVP dashboard can demonstrate meaningful map colors and a scouting list.
    """
    random.seed(RANDOM_SEED + index)

    # Assign stress pattern by index to guarantee category diversity.
    group = index % 12

    if group in [0, 1]:
        # Priority: moisture + rainfall stress
        ndvi_baseline = random.uniform(0.70, 0.82)
        ndmi_baseline = random.uniform(0.32, 0.42)
        ndvi = ndvi_baseline - random.uniform(0.09, 0.18)
        ndmi = ndmi_baseline - random.uniform(0.13, 0.22)
        rainfall_baseline_mm = random.uniform(75, 105)
        rainfall_30d_mm = rainfall_baseline_mm * random.uniform(0.35, 0.55)
        hotspot_count_7d = random.choice([0, 1, 1, 2])
        nearest_hotspot_km = random.uniform(2.5, 7.0)

    elif group in [2, 3]:
        # Warning: NDVI decline or rainfall stress
        ndvi_baseline = random.uniform(0.68, 0.80)
        ndmi_baseline = random.uniform(0.28, 0.40)
        ndvi = ndvi_baseline - random.uniform(0.07, 0.14)
        ndmi = ndmi_baseline - random.uniform(0.05, 0.12)
        rainfall_baseline_mm = random.uniform(70, 100)
        rainfall_30d_mm = rainfall_baseline_mm * random.uniform(0.50, 0.70)
        hotspot_count_7d = random.choice([0, 0, 1])
        nearest_hotspot_km = random.uniform(5.0, 12.0)

    elif group in [4, 5, 6]:
        # Watch: early anomaly
        ndvi_baseline = random.uniform(0.66, 0.78)
        ndmi_baseline = random.uniform(0.28, 0.38)
        ndvi = ndvi_baseline - random.uniform(0.02, 0.08)
        ndmi = ndmi_baseline - random.uniform(0.02, 0.07)
        rainfall_baseline_mm = random.uniform(70, 95)
        rainfall_30d_mm = rainfall_baseline_mm * random.uniform(0.65, 0.85)
        hotspot_count_7d = random.choice([0, 0, 0, 1])
        nearest_hotspot_km = random.uniform(8.0, 18.0)

    else:
        # Normal: low anomaly
        ndvi_baseline = random.uniform(0.65, 0.79)
        ndmi_baseline = random.uniform(0.27, 0.39)
        ndvi = ndvi_baseline - random.uniform(-0.01, 0.035)
        ndmi = ndmi_baseline - random.uniform(-0.01, 0.035)
        rainfall_baseline_mm = random.uniform(70, 95)
        rainfall_30d_mm = rainfall_baseline_mm * random.uniform(0.85, 1.10)
        hotspot_count_7d = 0
        nearest_hotspot_km = random.uniform(15.0, 35.0)

    ndvi_anomaly = ndvi - ndvi_baseline
    ndmi_anomaly = ndmi - ndmi_baseline
    rainfall_deficit_pct = max(0.0, (rainfall_baseline_mm - rainfall_30d_mm) / rainfall_baseline_mm * 100)

    return {
        "block_id": block.block_id,
        "observation_date": OBSERVATION_DATE,
        "ndvi": round_float(ndvi, 4),
        "ndvi_baseline": round_float(ndvi_baseline, 4),
        "ndvi_anomaly": round_float(ndvi_anomaly, 4),
        "ndmi": round_float(ndmi, 4),
        "ndmi_baseline": round_float(ndmi_baseline, 4),
        "ndmi_anomaly": round_float(ndmi_anomaly, 4),
        "rainfall_30d_mm": round_float(rainfall_30d_mm, 2),
        "rainfall_baseline_mm": round_float(rainfall_baseline_mm, 2),
        "rainfall_deficit_pct": round_float(rainfall_deficit_pct, 2),
        "hotspot_count_7d": int(hotspot_count_7d),
        "nearest_hotspot_km": round_float(nearest_hotspot_km, 2),
        "quality_flag": "demo_valid",
    }


def stress_scores_from_indicator(indicator: Dict[str, Any]) -> Tuple[float, float, float, float]:
    """
    Convert raw indicators to normalized stress components from 0 to 1.
    """
    ndvi_anomaly = float(indicator["ndvi_anomaly"])
    ndmi_anomaly = float(indicator["ndmi_anomaly"])
    rainfall_deficit_pct = float(indicator["rainfall_deficit_pct"])
    hotspot_count_7d = int(indicator["hotspot_count_7d"])
    nearest_hotspot_km = float(indicator["nearest_hotspot_km"])

    # Negative anomaly means the current value is lower than baseline.
    vegetation_stress = clamp(abs(min(0.0, ndvi_anomaly)) / 0.18)
    moisture_stress = clamp(abs(min(0.0, ndmi_anomaly)) / 0.22)
    rainfall_stress = clamp(rainfall_deficit_pct / 60.0)

    # Fire risk combines proximity and count.
    # Nearer hotspot means higher proximity score.
    proximity_score = clamp((15.0 - nearest_hotspot_km) / 15.0)
    count_score = clamp(hotspot_count_7d / 3.0)
    fire_risk = clamp(0.65 * proximity_score + 0.35 * count_score)

    return (
        round_float(vegetation_stress, 4),
        round_float(moisture_stress, 4),
        round_float(rainfall_stress, 4),
        round_float(fire_risk, 4),
    )


def generate_risk_score(indicator: Dict[str, Any]) -> Dict[str, Any]:
    vegetation_stress, moisture_stress, rainfall_stress, fire_risk = stress_scores_from_indicator(indicator)

    risk_score = (
        0.30 * vegetation_stress
        + 0.30 * moisture_stress
        + 0.25 * rainfall_stress
        + 0.15 * fire_risk
    )
    risk_score = round_float(risk_score, 4)

    risk_category = category_from_score(risk_score)

    dominant_driver = dominant_driver_from_components(
        vegetation_stress=vegetation_stress,
        moisture_stress=moisture_stress,
        rainfall_stress=rainfall_stress,
        fire_risk=fire_risk,
    )

    return {
        "block_id": indicator["block_id"],
        "score_date": OBSERVATION_DATE,
        "vegetation_stress": vegetation_stress,
        "moisture_stress": moisture_stress,
        "rainfall_stress": rainfall_stress,
        "fire_risk": fire_risk,
        "risk_score": risk_score,
        "risk_category": risk_category,
        "dominant_driver": dominant_driver,
        "recommended_action": recommended_action_from_category(risk_category, dominant_driver),
    }


def generate_scouting_priority(risk_scores: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    sorted_scores = sorted(risk_scores, key=lambda row: row["risk_score"], reverse=True)

    tasks = []
    for rank, score in enumerate(sorted_scores, start=1):
        if score["risk_category"] == "Normal":
            task_status = "monitor_only"
        else:
            task_status = "open"

        tasks.append(
            {
                "priority_rank": rank,
                "block_id": score["block_id"],
                "score_date": score["score_date"],
                "risk_score": score["risk_score"],
                "risk_category": score["risk_category"],
                "dominant_driver": score["dominant_driver"],
                "recommended_action": score["recommended_action"],
                "task_status": task_status,
            }
        )

    return tasks


# ---------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------

def validate_outputs(
    blocks: List[Block],
    indicators: List[Dict[str, Any]],
    risk_scores: List[Dict[str, Any]],
) -> None:
    block_ids = {block.block_id for block in blocks}
    indicator_ids = {row["block_id"] for row in indicators}
    risk_ids = {row["block_id"] for row in risk_scores}

    if len(block_ids) != len(blocks):
        raise ValueError("Duplicate block_id detected in blocks.")

    if block_ids != indicator_ids:
        missing = block_ids.symmetric_difference(indicator_ids)
        raise ValueError(f"Indicator block IDs do not match blocks: {missing}")

    if block_ids != risk_ids:
        missing = block_ids.symmetric_difference(risk_ids)
        raise ValueError(f"Risk score block IDs do not match blocks: {missing}")

    category_counts = {}
    for row in risk_scores:
        category_counts[row["risk_category"]] = category_counts.get(row["risk_category"], 0) + 1

    required_categories = ["Normal", "Watch", "Warning", "Priority Inspection"]
    missing_categories = [cat for cat in required_categories if category_counts.get(cat, 0) == 0]

    if missing_categories:
        raise ValueError(f"Missing risk categories in generated demo data: {missing_categories}")


# ---------------------------------------------------------------------
# Documentation
# ---------------------------------------------------------------------

def write_data_generation_doc(
    blocks: List[Block],
    risk_scores: List[Dict[str, Any]],
) -> None:
    category_counts: Dict[str, int] = {}
    for row in risk_scores:
        category_counts[row["risk_category"]] = category_counts.get(row["risk_category"], 0) + 1

    doc = f"""# Day 1 Data Generation Documentation

## Dataset status

This dataset is **synthetic demo data** for the CropStress Insight MVP.

Estate name: `{ESTATE_NAME}`  
Estate ID: `{ESTATE_ID}`  
Observation date: `{OBSERVATION_DATE}`  
Number of blocks: `{len(blocks)}`  

The generated data is intended for MVP development and demo validation only. It should not be presented as real plantation monitoring data.

## Files generated

- `data/demo/blocks.geojson`
- `data/demo/block_indicators_latest.json`
- `data/demo/risk_scores_latest.json`
- `data/demo/scouting_priority_latest.json`

## Data generation method

The script creates a synthetic grid of plantation blocks in EPSG:4326 coordinates. Each block receives realistic demo indicator values for:

- NDVI
- NDMI
- 30-day rainfall
- Rainfall deficit percentage
- 7-day hotspot count
- Nearest hotspot distance

The indicator values are intentionally distributed across normal, early anomaly, warning, and priority inspection cases so the frontend can demonstrate map colors and scouting prioritization.

## Risk formula

The MVP risk score uses the following weighted rule-based formula:

```text
RiskScore =
0.30 * vegetation_stress +
0.30 * moisture_stress +
0.25 * rainfall_stress +
0.15 * fire_risk
```

## Risk categories

```text
0.00 - 0.24 = Normal
0.25 - 0.44 = Watch
0.45 - 0.64 = Warning
0.65 - 1.00 = Priority Inspection
```

## Generated category distribution

```json
{json.dumps(category_counts, indent=2)}
```

## Limitations

1. The block boundaries are synthetic.
2. The satellite, rainfall, and hotspot indicators are simulated.
3. The risk score is rule-based and has not been calibrated with real field verification.
4. Area calculation uses a rough small-area latitude/longitude approximation.
5. The dataset is designed for software integration testing and demo storytelling, not agronomic decision-making.

## How to regenerate

Run:

```bash
python scripts/generate_day1_data.py
```

The script will overwrite the generated files in `data/demo/`.
"""

    (DOCS_DIR / "data_generation_day1.md").write_text(doc, encoding="utf-8")


# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

def write_json(path: Path, data: Any) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")


def main() -> None:
    random.seed(RANDOM_SEED)
    ensure_dirs()

    blocks = generate_blocks()
    indicators = [generate_indicator_for_block(index, block) for index, block in enumerate(blocks)]
    risk_scores = [generate_risk_score(indicator) for indicator in indicators]
    scouting_priority = generate_scouting_priority(risk_scores)

    validate_outputs(blocks, indicators, risk_scores)

    write_json(OUTPUT_DIR / "blocks.geojson", blocks_to_geojson(blocks))
    write_json(OUTPUT_DIR / "block_indicators_latest.json", indicators)
    write_json(OUTPUT_DIR / "risk_scores_latest.json", risk_scores)
    write_json(OUTPUT_DIR / "scouting_priority_latest.json", scouting_priority)

    write_data_generation_doc(blocks, risk_scores)

    print("Day 1 demo data generated successfully.")
    print(f"- {OUTPUT_DIR / 'blocks.geojson'}")
    print(f"- {OUTPUT_DIR / 'block_indicators_latest.json'}")
    print(f"- {OUTPUT_DIR / 'risk_scores_latest.json'}")
    print(f"- {OUTPUT_DIR / 'scouting_priority_latest.json'}")
    print(f"- {DOCS_DIR / 'data_generation_day1.md'}")

    category_counts: Dict[str, int] = {}
    for row in risk_scores:
        category_counts[row["risk_category"]] = category_counts.get(row["risk_category"], 0) + 1

    print("Risk category distribution:")
    for category in ["Normal", "Watch", "Warning", "Priority Inspection"]:
        print(f"  {category}: {category_counts.get(category, 0)}")


if __name__ == "__main__":
    main()
