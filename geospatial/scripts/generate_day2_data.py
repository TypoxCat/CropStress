#!/usr/bin/env python3
"""
generate_day2_data.py

CropStress Insight MVP - Agent A Day 2 generator.

Purpose:
- Generate frontend-ready Day 2 geospatial demo data.
- Ensure at least 5 blocks per risk category:
  Normal, Watch, Warning, Priority Inspection.
- Keep the exact Day 2 risk formula:
  0.30 * vegetation_stress
+ 0.30 * moisture_stress
+ 0.25 * rainfall_stress
+ 0.15 * fire_risk
- Validate block IDs, geometry, category distribution, and top 3 priority blocks.
- Sync outputs to frontend/public/demo.
- Generate docs/data_generation_day2.md.

Inputs:
- data/demo/blocks.geojson

Outputs:
- data/demo/blocks.geojson
- data/demo/block_indicators_latest.json
- data/demo/risk_scores_latest.json
- data/demo/scouting_priority_latest.json
- docs/data_generation_day2.md
- frontend/public/demo/*
"""

from __future__ import annotations

import json
import os
import shutil
from collections import Counter
from datetime import date
from pathlib import Path
from typing import Any, Dict, Iterable, List, Tuple

from shapely.geometry import MultiPolygon, Polygon, shape


# ---------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------

BASE_DIR = Path(__file__).resolve().parents[1]  # geospatial/
DATA_DEMO_DIR = BASE_DIR / "data" / "demo"
DOCS_DIR = BASE_DIR / "docs"

BLOCKS_PATH = DATA_DEMO_DIR / "blocks.geojson"
BLOCK_INDICATORS_PATH = DATA_DEMO_DIR / "block_indicators_latest.json"
RISK_SCORES_PATH = DATA_DEMO_DIR / "risk_scores_latest.json"
SCOUTING_PRIORITY_PATH = DATA_DEMO_DIR / "scouting_priority_latest.json"
DAY2_DOC_PATH = DOCS_DIR / "data_generation_day2.md"


def resolve_frontend_demo_dir() -> Path:
    """
    Default expected structure:

    project-root/
    ├── geospatial/
    └── frontend/
        └── public/
            └── demo/

    You can override with:
    FRONTEND_DEMO_DIR=/custom/path python scripts/generate_day2_data.py
    """
    env_path = os.getenv("FRONTEND_DEMO_DIR")
    if env_path:
        return Path(env_path)

    return BASE_DIR.parent / "frontend" / "public" / "demo"


FRONTEND_DEMO_DIR = resolve_frontend_demo_dir()


# ---------------------------------------------------------------------
# Day 2 constants
# ---------------------------------------------------------------------

OBSERVATION_DATE = date.today().isoformat()

MIN_BLOCKS_PER_CATEGORY = 5

RISK_FORMULA_WEIGHTS = {
    "vegetation_stress": 0.30,
    "moisture_stress": 0.30,
    "rainfall_stress": 0.25,
    "fire_risk": 0.15,
}

CATEGORY_THRESHOLDS = {
    "Normal": (0.00, 0.25),
    "Watch": (0.25, 0.45),
    "Warning": (0.45, 0.65),
    "Priority Inspection": (0.65, 1.01),
}

CATEGORY_ORDER = [
    "Normal",
    "Watch",
    "Warning",
    "Priority Inspection",
]


# Components are deterministic and intentionally varied for demo clarity.
# Tuple format:
# vegetation_stress, moisture_stress, rainfall_stress, fire_risk, scenario_note
CATEGORY_COMPONENT_TEMPLATES: Dict[str, List[Tuple[float, float, float, float, str]]] = {
    "Normal": [
        (0.05, 0.04, 0.03, 0.00, "Stable canopy and moisture condition"),
        (0.10, 0.08, 0.06, 0.00, "Very low stress signal"),
        (0.15, 0.10, 0.08, 0.00, "Minor natural variability"),
        (0.18, 0.15, 0.10, 0.00, "Low stress, continue routine monitoring"),
        (0.20, 0.18, 0.12, 0.00, "Healthy block with small anomaly"),
        (0.12, 0.20, 0.15, 0.00, "Moisture still within normal monitoring range"),
    ],
    "Watch": [
        (0.35, 0.30, 0.25, 0.00, "Early vegetation decline"),
        (0.40, 0.32, 0.30, 0.05, "Moderate canopy and rainfall signal"),
        (0.45, 0.35, 0.35, 0.00, "Watch for continuing dry trend"),
        (0.50, 0.38, 0.38, 0.05, "Sustained mild canopy-moisture stress"),
        (0.52, 0.42, 0.40, 0.05, "Approaching warning threshold"),
        (0.42, 0.46, 0.42, 0.08, "Moisture stress becoming visible"),
    ],
    "Warning": [
        (0.62, 0.55, 0.50, 0.05, "Canopy decline with rainfall deficit"),
        (0.68, 0.60, 0.55, 0.10, "Clear vegetation and moisture stress"),
        (0.70, 0.65, 0.58, 0.10, "Inspection recommended this week"),
        (0.75, 0.62, 0.60, 0.15, "Strong NDVI decline and dry signal"),
        (0.64, 0.72, 0.66, 0.10, "Moisture-driven warning condition"),
        (0.72, 0.68, 0.62, 0.18, "Mixed stress signal requiring field check"),
    ],
    "Priority Inspection": [
        (0.82, 0.78, 0.72, 0.35, "High canopy decline with moisture stress"),
        (0.88, 0.82, 0.78, 0.45, "Priority inspection due to multi-factor stress"),
        (0.92, 0.88, 0.82, 0.55, "Severe vegetation and moisture anomaly"),
        (0.86, 0.90, 0.85, 0.60, "Strong moisture stress and hotspot proximity"),
        (0.95, 0.86, 0.80, 0.70, "Critical scouting priority"),
        (0.90, 0.92, 0.88, 0.80, "Highest priority fire-moisture stress"),
    ],
}


# ---------------------------------------------------------------------
# Generic helpers
# ---------------------------------------------------------------------

def read_json(path: Path) -> Any:
    if not path.exists():
        raise FileNotFoundError(f"Missing required input: {path}")

    with path.open("r", encoding="utf-8") as file:
        return json.load(file)


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(data, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )


def clamp(value: float, min_value: float = 0.0, max_value: float = 1.0) -> float:
    return max(min_value, min(value, max_value))


def round4(value: float) -> float:
    return round(float(value) + 1e-12, 4)


def round2(value: float) -> float:
    return round(float(value) + 1e-12, 2)


def risk_category_from_score(score: float) -> str:
    if score < 0.25:
        return "Normal"
    if score < 0.45:
        return "Watch"
    if score < 0.65:
        return "Warning"
    return "Priority Inspection"


def calculate_risk_score(
    vegetation_stress: float,
    moisture_stress: float,
    rainfall_stress: float,
    fire_risk: float,
) -> float:
    score = (
        RISK_FORMULA_WEIGHTS["vegetation_stress"] * vegetation_stress
        + RISK_FORMULA_WEIGHTS["moisture_stress"] * moisture_stress
        + RISK_FORMULA_WEIGHTS["rainfall_stress"] * rainfall_stress
        + RISK_FORMULA_WEIGHTS["fire_risk"] * fire_risk
    )

    return round4(score)


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

    if top_value < 0.15:
        return "No significant stress signal"

    pair = {top_name, second_name}

    if second_value >= 0.50:
        if pair == {"NDVI decline", "NDMI drop"}:
            return "NDVI decline + NDMI drop"
        if pair == {"NDMI drop", "Rainfall deficit"}:
            return "NDMI drop + rainfall deficit"
        if pair == {"NDVI decline", "Rainfall deficit"}:
            return "NDVI decline + rainfall deficit"
        if pair == {"Rainfall deficit", "Hotspot proximity"}:
            return "Rainfall deficit + hotspot proximity"
        if pair == {"NDMI drop", "Hotspot proximity"}:
            return "NDMI drop + hotspot proximity"
        if pair == {"NDVI decline", "Hotspot proximity"}:
            return "NDVI decline + hotspot proximity"

        return "Mixed stress signal"

    return top_name


def recommended_action_from_category(category: str, dominant_driver: str) -> str:
    driver_lower = dominant_driver.lower()

    if category == "Priority Inspection":
        if "hotspot" in driver_lower:
            return "Inspect today and prioritize fire patrol"
        if "rainfall" in driver_lower or "ndmi" in driver_lower:
            return "Inspect today for moisture stress"
        if "ndvi" in driver_lower:
            return "Inspect today and verify canopy condition"
        return "Inspect today and verify crop condition"

    if category == "Warning":
        if "hotspot" in driver_lower:
            return "Inspect this week and monitor fire risk"
        if "rainfall" in driver_lower or "ndmi" in driver_lower:
            return "Inspect this week for water stress"
        if "ndvi" in driver_lower:
            return "Inspect this week for canopy decline"
        return "Inspect this week"

    if category == "Watch":
        return "Monitor next processing cycle"

    return "No urgent action"


# ---------------------------------------------------------------------
# Geometry and block validation
# ---------------------------------------------------------------------

def iter_coordinates(geometry: Dict[str, Any]) -> Iterable[Tuple[float, float]]:
    geom_type = geometry.get("type")
    coordinates = geometry.get("coordinates", [])

    if geom_type == "Polygon":
        for ring in coordinates:
            for lon, lat in ring:
                yield float(lon), float(lat)

    elif geom_type == "MultiPolygon":
        for polygon in coordinates:
            for ring in polygon:
                for lon, lat in ring:
                    yield float(lon), float(lat)


def validate_blocks_geojson(blocks_geojson: Dict[str, Any]) -> List[Dict[str, Any]]:
    if blocks_geojson.get("type") != "FeatureCollection":
        raise ValueError("blocks.geojson must be a GeoJSON FeatureCollection.")

    features = blocks_geojson.get("features", [])
    if not features:
        raise ValueError("blocks.geojson has no features.")

    block_ids = []

    for index, feature in enumerate(features):
        properties = feature.get("properties", {})
        geometry = feature.get("geometry")

        block_id = properties.get("block_id")
        if not block_id:
            raise ValueError(f"Feature index {index} is missing properties.block_id.")

        if block_id in block_ids:
            raise ValueError(f"Duplicate block_id found: {block_id}")

        block_ids.append(block_id)

        if not geometry:
            raise ValueError(f"Block {block_id} is missing geometry.")

        geom_type = geometry.get("type")
        if geom_type not in ["Polygon", "MultiPolygon"]:
            raise ValueError(
                f"Block {block_id} geometry must be Polygon or MultiPolygon, got {geom_type}."
            )

        shapely_geom = shape(geometry)
        if not isinstance(shapely_geom, (Polygon, MultiPolygon)):
            raise ValueError(f"Block {block_id} is not a valid Polygon/MultiPolygon.")

        if shapely_geom.is_empty:
            raise ValueError(f"Block {block_id} geometry is empty.")

        if not shapely_geom.is_valid:
            raise ValueError(f"Block {block_id} geometry is invalid.")

        for lon, lat in iter_coordinates(geometry):
            if not (-180.0 <= lon <= 180.0 and -90.0 <= lat <= 90.0):
                raise ValueError(
                    f"Block {block_id} has coordinates outside EPSG:4326 range: "
                    f"lon={lon}, lat={lat}"
                )

    if len(features) < MIN_BLOCKS_PER_CATEGORY * len(CATEGORY_ORDER):
        raise ValueError(
            f"Need at least {MIN_BLOCKS_PER_CATEGORY * len(CATEGORY_ORDER)} blocks "
            f"to guarantee {MIN_BLOCKS_PER_CATEGORY} per category. "
            f"Found only {len(features)}."
        )

    return features


def normalize_blocks_geojson(blocks_geojson: Dict[str, Any]) -> Dict[str, Any]:
    """
    Preserve geometry while adding Day 2 provenance metadata.
    """
    properties = blocks_geojson.get("properties", {})
    if not isinstance(properties, dict):
        properties = {}

    properties.setdefault("crs", "EPSG:4326")
    properties.setdefault("data_type", "existing_demo_geometry")
    properties["day2_usage"] = "geometry_source_for_demo_risk_generation"
    properties["day2_generated_at"] = OBSERVATION_DATE

    blocks_geojson["properties"] = properties

    for feature in blocks_geojson.get("features", []):
        feature.setdefault("properties", {})
        feature["properties"].setdefault("geometry_provenance", properties.get("data_type"))
        feature["properties"]["day2_included"] = True

    return blocks_geojson


# ---------------------------------------------------------------------
# Scenario generation
# ---------------------------------------------------------------------

def assign_categories(features: List[Dict[str, Any]]) -> Dict[str, str]:
    """
    Assign categories deterministically and evenly.

    With 48 blocks:
    12 Normal, 12 Watch, 12 Warning, 12 Priority Inspection.
    """
    sorted_features = sorted(
        features,
        key=lambda feature: str(feature.get("properties", {}).get("block_id", "")),
    )

    assignments = {}

    for index, feature in enumerate(sorted_features):
        block_id = feature["properties"]["block_id"]
        category = CATEGORY_ORDER[index % len(CATEGORY_ORDER)]
        assignments[block_id] = category

    counts = Counter(assignments.values())

    for category in CATEGORY_ORDER:
        if counts[category] < MIN_BLOCKS_PER_CATEGORY:
            raise ValueError(
                f"Category assignment failed. {category} has {counts[category]} blocks, "
                f"expected at least {MIN_BLOCKS_PER_CATEGORY}."
            )

    return assignments


def template_for_block(category: str, sequence_number: int) -> Tuple[float, float, float, float, str]:
    templates = CATEGORY_COMPONENT_TEMPLATES[category]
    return templates[sequence_number % len(templates)]


def derive_indicator_values(
    vegetation_stress: float,
    moisture_stress: float,
    rainfall_stress: float,
    fire_risk: float,
    sequence_number: int,
) -> Dict[str, Any]:
    """
    Convert stress components back into plausible block indicators.

    These values are synthetic but constrained to realistic oil palm demo ranges.
    """
    ndvi_baseline = 0.78 + ((sequence_number % 5) * 0.015)
    ndmi_baseline = 0.38 + ((sequence_number % 4) * 0.025)

    # Existing Day 1 stress formula:
    # vegetation_stress = abs(min(0, ndvi_anomaly)) / 0.18
    # moisture_stress   = abs(min(0, ndmi_anomaly)) / 0.22
    ndvi_anomaly = -vegetation_stress * 0.18
    ndmi_anomaly = -moisture_stress * 0.22

    ndvi = clamp(ndvi_baseline + ndvi_anomaly, 0.25, 0.90)
    ndmi = clamp(ndmi_baseline + ndmi_anomaly, -0.20, 0.60)

    rainfall_baseline_mm = 180.0 + ((sequence_number % 6) * 8.0)

    # Existing Day 1 stress formula:
    # rainfall_stress = rainfall_deficit_pct / 60
    rainfall_deficit_pct = clamp(rainfall_stress * 60.0, 0.0, 100.0)
    rainfall_30d_mm = rainfall_baseline_mm * (1.0 - rainfall_deficit_pct / 100.0)

    # Fire risk is represented both as count and approximate proximity.
    # This is demo data, not a true FIRMS distance calculation.
    hotspot_count_7d = int(round(fire_risk * 3))

    if fire_risk <= 0.0:
        nearest_hotspot_km = None
    else:
        nearest_hotspot_km = round2(max(0.4, 12.0 * (1.0 - fire_risk)))

    return {
        "ndvi": round4(ndvi),
        "ndvi_baseline": round4(ndvi_baseline),
        "ndvi_anomaly": round4(ndvi - ndvi_baseline),
        "ndmi": round4(ndmi),
        "ndmi_baseline": round4(ndmi_baseline),
        "ndmi_anomaly": round4(ndmi - ndmi_baseline),
        "rainfall_30d_mm": round2(rainfall_30d_mm),
        "rainfall_baseline_mm": round2(rainfall_baseline_mm),
        "rainfall_deficit_pct": round2(rainfall_deficit_pct),
        "hotspot_count_7d": hotspot_count_7d,
        "nearest_hotspot_km": nearest_hotspot_km,
        "hotspot_proximity_score": round4(fire_risk),
    }


def generate_day2_rows(
    features: List[Dict[str, Any]],
    category_assignments: Dict[str, str],
) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]], List[Dict[str, Any]]]:
    indicators: List[Dict[str, Any]] = []
    risk_scores: List[Dict[str, Any]] = []

    category_sequence = Counter()

    sorted_features = sorted(
        features,
        key=lambda feature: str(feature.get("properties", {}).get("block_id", "")),
    )

    for global_index, feature in enumerate(sorted_features):
        props = feature["properties"]
        block_id = props["block_id"]
        assigned_category = category_assignments[block_id]

        category_index = category_sequence[assigned_category]
        category_sequence[assigned_category] += 1

        (
            vegetation_stress,
            moisture_stress,
            rainfall_stress,
            fire_risk,
            scenario_note,
        ) = template_for_block(assigned_category, category_index)

        risk_score = calculate_risk_score(
            vegetation_stress=vegetation_stress,
            moisture_stress=moisture_stress,
            rainfall_stress=rainfall_stress,
            fire_risk=fire_risk,
        )

        calculated_category = risk_category_from_score(risk_score)

        if calculated_category != assigned_category:
            raise ValueError(
                f"Scenario template category mismatch for {block_id}. "
                f"Assigned={assigned_category}, calculated={calculated_category}, "
                f"risk_score={risk_score}"
            )

        dominant_driver = dominant_driver_from_components(
            vegetation_stress=vegetation_stress,
            moisture_stress=moisture_stress,
            rainfall_stress=rainfall_stress,
            fire_risk=fire_risk,
        )

        indicator_values = derive_indicator_values(
            vegetation_stress=vegetation_stress,
            moisture_stress=moisture_stress,
            rainfall_stress=rainfall_stress,
            fire_risk=fire_risk,
            sequence_number=global_index,
        )

        indicator_row = {
            "block_id": block_id,
            "observation_date": OBSERVATION_DATE,
            **indicator_values,
            "scenario_category": assigned_category,
            "scenario_note": scenario_note,
            "quality_flag": "synthetic_demo_day2",
            "data_provenance": "synthetic_demo",
            "indicator_sources": {
                "ndvi": "synthetic_day2_scenario",
                "ndmi": "synthetic_day2_scenario",
                "rainfall": "synthetic_day2_scenario",
                "hotspot": "synthetic_day2_scenario",
            },
        }

        risk_row = {
            "block_id": block_id,
            "score_date": OBSERVATION_DATE,
            "vegetation_stress": round4(vegetation_stress),
            "moisture_stress": round4(moisture_stress),
            "rainfall_stress": round4(rainfall_stress),
            "fire_risk": round4(fire_risk),
            "risk_score": risk_score,
            "risk_category": calculated_category,
            "dominant_driver": dominant_driver,
            "recommended_action": recommended_action_from_category(
                calculated_category,
                dominant_driver,
            ),
            "formula": "0.30*vegetation_stress + 0.30*moisture_stress + 0.25*rainfall_stress + 0.15*fire_risk",
            "data_provenance": "synthetic_demo",
            "scenario_note": scenario_note,
        }

        indicators.append(indicator_row)
        risk_scores.append(risk_row)

    scouting_priority = generate_scouting_priority(risk_scores)

    return indicators, risk_scores, scouting_priority


def generate_scouting_priority(risk_scores: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    sorted_scores = sorted(
        risk_scores,
        key=lambda row: (row["risk_score"], row["block_id"]),
        reverse=True,
    )

    priority_rows = []

    for index, row in enumerate(sorted_scores):
        priority_rows.append(
            {
                "priority_rank": index + 1,
                "block_id": row["block_id"],
                "score_date": row["score_date"],
                "risk_score": row["risk_score"],
                "risk_category": row["risk_category"],
                "dominant_driver": row["dominant_driver"],
                "recommended_action": row["recommended_action"],
                "task_status": "monitor_only"
                if row["risk_category"] == "Normal"
                else "open",
                "data_provenance": row.get("data_provenance", "synthetic_demo"),
            }
        )

    return priority_rows


# ---------------------------------------------------------------------
# Output validation
# ---------------------------------------------------------------------

def validate_id_consistency(
    features: List[Dict[str, Any]],
    indicators: List[Dict[str, Any]],
    risk_scores: List[Dict[str, Any]],
    scouting_priority: List[Dict[str, Any]],
) -> None:
    block_ids = {feature["properties"]["block_id"] for feature in features}
    indicator_ids = {row["block_id"] for row in indicators}
    risk_ids = {row["block_id"] for row in risk_scores}
    priority_ids = {row["block_id"] for row in scouting_priority}

    if block_ids != indicator_ids:
        raise ValueError("Block IDs mismatch between blocks.geojson and indicators.")

    if block_ids != risk_ids:
        raise ValueError("Block IDs mismatch between blocks.geojson and risk scores.")

    if block_ids != priority_ids:
        raise ValueError("Block IDs mismatch between blocks.geojson and priority list.")


def validate_risk_distribution(risk_scores: List[Dict[str, Any]]) -> Counter:
    counts = Counter(row["risk_category"] for row in risk_scores)

    for category in CATEGORY_ORDER:
        count = counts.get(category, 0)
        if count < MIN_BLOCKS_PER_CATEGORY:
            raise ValueError(
                f"Risk distribution failed. {category} has {count} blocks; "
                f"expected at least {MIN_BLOCKS_PER_CATEGORY}."
            )

    return counts


def validate_formula_consistency(risk_scores: List[Dict[str, Any]]) -> None:
    for row in risk_scores:
        expected_score = calculate_risk_score(
            vegetation_stress=float(row["vegetation_stress"]),
            moisture_stress=float(row["moisture_stress"]),
            rainfall_stress=float(row["rainfall_stress"]),
            fire_risk=float(row["fire_risk"]),
        )

        if expected_score != row["risk_score"]:
            raise ValueError(
                f"Formula mismatch for {row['block_id']}: "
                f"stored={row['risk_score']}, expected={expected_score}"
            )

        expected_category = risk_category_from_score(row["risk_score"])
        if expected_category != row["risk_category"]:
            raise ValueError(
                f"Category mismatch for {row['block_id']}: "
                f"stored={row['risk_category']}, expected={expected_category}"
            )


def validate_top3_priority(scouting_priority: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    top3 = scouting_priority[:3]

    if len(top3) < 3:
        raise ValueError("Scouting priority must contain at least 3 rows.")

    for row in top3:
        if row["risk_category"] not in ["Warning", "Priority Inspection"]:
            raise ValueError(
                f"Top 3 priority block {row['block_id']} is not Warning/Priority. "
                f"Got {row['risk_category']}."
            )

        if not row["dominant_driver"] or row["dominant_driver"] == "No significant stress signal":
            raise ValueError(
                f"Top 3 priority block {row['block_id']} has unclear dominant driver."
            )

    return top3


def validate_outputs(
    features: List[Dict[str, Any]],
    indicators: List[Dict[str, Any]],
    risk_scores: List[Dict[str, Any]],
    scouting_priority: List[Dict[str, Any]],
) -> Tuple[Counter, List[Dict[str, Any]]]:
    validate_id_consistency(features, indicators, risk_scores, scouting_priority)
    validate_formula_consistency(risk_scores)
    category_counts = validate_risk_distribution(risk_scores)
    top3 = validate_top3_priority(scouting_priority)

    return category_counts, top3


# ---------------------------------------------------------------------
# Sync and documentation
# ---------------------------------------------------------------------

def sync_outputs_to_frontend() -> None:
    FRONTEND_DEMO_DIR.mkdir(parents=True, exist_ok=True)

    files_to_copy = [
        BLOCKS_PATH,
        BLOCK_INDICATORS_PATH,
        RISK_SCORES_PATH,
        SCOUTING_PRIORITY_PATH,
    ]

    for source in files_to_copy:
        if not source.exists():
            raise FileNotFoundError(f"Cannot sync missing file: {source}")

        target = FRONTEND_DEMO_DIR / source.name
        shutil.copy2(source, target)

    print("Frontend demo files synced:")
    for source in files_to_copy:
        print(f"- {FRONTEND_DEMO_DIR / source.name}")


def format_category_counts(counts: Counter) -> str:
    lines = [
        "| Risk Category | Count | Minimum Required | Status |",
        "|---|---:|---:|---|",
    ]

    for category in CATEGORY_ORDER:
        count = counts.get(category, 0)
        status = "PASS" if count >= MIN_BLOCKS_PER_CATEGORY else "FAIL"
        lines.append(f"| {category} | {count} | {MIN_BLOCKS_PER_CATEGORY} | {status} |")

    return "\n".join(lines)


def format_top3(top3: List[Dict[str, Any]]) -> str:
    lines = [
        "| Rank | Block ID | Risk Score | Category | Dominant Driver | Recommended Action |",
        "|---:|---|---:|---|---|---|",
    ]

    for row in top3:
        lines.append(
            f"| {row['priority_rank']} | {row['block_id']} | {row['risk_score']:.4f} | "
            f"{row['risk_category']} | {row['dominant_driver']} | "
            f"{row['recommended_action']} |"
        )

    return "\n".join(lines)

def write_day2_documentation(
    blocks_geojson: Dict[str, Any],
    risk_scores: List[Dict[str, Any]],
    category_counts: Counter,
    top3: List[Dict[str, Any]],
) -> None:
    DOCS_DIR.mkdir(parents=True, exist_ok=True)

    total_blocks = len(blocks_geojson.get("features", []))
    geometry_data_type = blocks_geojson.get("properties", {}).get("data_type", "unknown")

    min_score = min(row["risk_score"] for row in risk_scores)
    max_score = max(row["risk_score"] for row in risk_scores)

    lines = []

    lines.append("# CropStress Insight MVP - Day 2 Data Generation")
    lines.append("")
    lines.append(f"Generated at: `{OBSERVATION_DATE}`")
    lines.append("")
    lines.append("## Purpose")
    lines.append("")
    lines.append(
        "This document describes how the Day 2 demo data was generated for Agent A."
    )
    lines.append("")
    lines.append(
        "The Day 2 objective is to produce geospatial demo data that supports a clear jury story: "
        "which oil palm blocks should be inspected first and why."
    )
    lines.append("")
    lines.append("## Input Geometry")
    lines.append("")
    lines.append("- Source file: `data/demo/blocks.geojson`")
    lines.append(f"- Number of blocks: `{total_blocks}`")
    lines.append(f"- Geometry source label: `{geometry_data_type}`")
    lines.append("- Expected CRS: `EPSG:4326`")
    lines.append("- Required geometry type: `Polygon` or `MultiPolygon`")
    lines.append("- Validation: block IDs are unique and coordinates are within lon/lat range.")
    lines.append("")
    lines.append("## Indicator Source and Provenance")
    lines.append("")
    lines.append("Day 2 uses `synthetic_demo` indicators.")
    lines.append("")
    lines.append(
        "This is intentional. Real satellite data can produce a narrow risk distribution "
        "when the selected estate is spatially uniform or when some variables, such as rainfall, "
        "are computed at estate level. For the Day 2 jury demo, the requirement is to show all "
        "risk categories clearly, including Normal, Watch, Warning, and Priority Inspection."
    )
    lines.append("")
    lines.append("The synthetic values are constrained to plausible oil palm monitoring ranges:")
    lines.append("")
    lines.append("- NDVI baseline: approximately 0.78-0.84")
    lines.append("- NDVI anomaly: derived from vegetation stress")
    lines.append("- NDMI baseline: approximately 0.38-0.46")
    lines.append("- NDMI anomaly: derived from moisture stress")
    lines.append("- Rainfall deficit: derived from rainfall stress")
    lines.append("- Hotspot proximity score: derived from demo fire-risk scenario")
    lines.append("")
    lines.append("The generated files include provenance labels:")
    lines.append("")
    lines.append("- `data_provenance`: `synthetic_demo`")
    lines.append("- `quality_flag`: `synthetic_demo_day2`")
    lines.append("")
    lines.append("## Risk Formula")
    lines.append("")
    lines.append("The exact formula used is:")
    lines.append("")
    lines.append("    RiskScore =")
    lines.append("      0.30 * vegetation_stress")
    lines.append("    + 0.30 * moisture_stress")
    lines.append("    + 0.25 * rainfall_stress")
    lines.append("    + 0.15 * fire_risk")
    lines.append("")
    lines.append(
        "The script validates that every stored `risk_score` matches this formula "
        "after rounding to four decimals."
    )
    lines.append("")
    lines.append("## Risk Thresholds")
    lines.append("")
    lines.append("| Risk Score Range | Category |")
    lines.append("|---:|---|")
    lines.append("| 0.00-0.24 | Normal |")
    lines.append("| 0.25-0.44 | Watch |")
    lines.append("| 0.45-0.64 | Warning |")
    lines.append("| 0.65-1.00 | Priority Inspection |")
    lines.append("")
    lines.append("## Category Distribution")
    lines.append("")
    lines.append(format_category_counts(category_counts))
    lines.append("")
    lines.append("Risk score range:")
    lines.append("")
    lines.append(f"- Minimum: `{min_score:.4f}`")
    lines.append(f"- Maximum: `{max_score:.4f}`")
    lines.append("")
    lines.append("## Top 3 Priority Blocks")
    lines.append("")
    lines.append(format_top3(top3))
    lines.append("")
    lines.append(
        "The script validates that all top 3 priority blocks are either `Warning` "
        "or `Priority Inspection` and that each has a clear dominant driver."
    )
    lines.append("")
    lines.append("## Output Files")
    lines.append("")
    lines.append("Generated to `data/demo/`:")
    lines.append("")
    lines.append("- `blocks.geojson`")
    lines.append("- `block_indicators_latest.json`")
    lines.append("- `risk_scores_latest.json`")
    lines.append("- `scouting_priority_latest.json`")
    lines.append("")
    lines.append("Synced to frontend path:")
    lines.append("")
    lines.append(f"- `{FRONTEND_DEMO_DIR}`")
    lines.append("")
    lines.append("## Assumptions and Limitations")
    lines.append("")
    lines.append("1. Day 2 values are synthetic demo data, not field-verified agronomic diagnosis.")
    lines.append("2. The purpose is to support a clear MVP demonstration, not to claim real operational stress detection.")
    lines.append("3. Real satellite generation remains available separately through the Earth Engine pipeline.")
    lines.append(
        "4. For production, risk scores should be calibrated using real block boundaries, "
        "yield history, rainfall gauges, scouting logs, soil data, and validated hotspot distance calculations."
    )
    lines.append("")

    DAY2_DOC_PATH.write_text("\n".join(lines), encoding="utf-8")

# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

def main() -> None:
    print("Generating CropStress Day 2 demo data...")
    print(f"Base directory: {BASE_DIR}")
    print(f"Input blocks: {BLOCKS_PATH}")

    DATA_DEMO_DIR.mkdir(parents=True, exist_ok=True)

    blocks_geojson = read_json(BLOCKS_PATH)
    features = validate_blocks_geojson(blocks_geojson)
    blocks_geojson = normalize_blocks_geojson(blocks_geojson)

    write_json(BLOCKS_PATH, blocks_geojson)

    category_assignments = assign_categories(features)

    indicators, risk_scores, scouting_priority = generate_day2_rows(
        features=features,
        category_assignments=category_assignments,
    )

    category_counts, top3 = validate_outputs(
        features=features,
        indicators=indicators,
        risk_scores=risk_scores,
        scouting_priority=scouting_priority,
    )

    write_json(BLOCK_INDICATORS_PATH, indicators)
    write_json(RISK_SCORES_PATH, risk_scores)
    write_json(SCOUTING_PRIORITY_PATH, scouting_priority)

    write_day2_documentation(
        blocks_geojson=blocks_geojson,
        risk_scores=risk_scores,
        category_counts=category_counts,
        top3=top3,
    )

    sync_outputs_to_frontend()

    print("\nDay 2 data generated successfully.")
    print("\nCategory distribution:")
    for category in CATEGORY_ORDER:
        print(f"- {category}: {category_counts.get(category, 0)} blocks")

    print("\nTop 3 priority blocks:")
    for row in top3:
        print(
            f"- #{row['priority_rank']} {row['block_id']} | "
            f"{row['risk_score']:.4f} | "
            f"{row['risk_category']} | "
            f"{row['dominant_driver']} | "
            f"{row['recommended_action']}"
        )

    print("\nGenerated files:")
    print(f"- {BLOCKS_PATH}")
    print(f"- {BLOCK_INDICATORS_PATH}")
    print(f"- {RISK_SCORES_PATH}")
    print(f"- {SCOUTING_PRIORITY_PATH}")
    print(f"- {DAY2_DOC_PATH}")
    print(f"- {FRONTEND_DEMO_DIR}")


if __name__ == "__main__":
    main()