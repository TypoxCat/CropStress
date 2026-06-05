#!/usr/bin/env python3
"""
Build backend/supabase/seed_day2.sql from CropStress demo outputs.

Day 2 goal:
- Keep the Day 1 source field names stable.
- Generate a Supabase seed that is demo-ready.
- Preserve the locked risk formula and category thresholds.
- If the source risk distribution is still too flat, create a deterministic
  Day 2 demo scenario in memory before writing SQL.

Reads, first complete folder wins:
  1. <repo>/geospatial/data/demo
  2. <repo>/frontend/public/demo
  3. <repo>/backend/data/demo
  4. current working directory, if it contains all demo files

Writes:
  backend/supabase/seed_day2.sql

Important:
- This script does not overwrite the JSON files by default.
- The generated Day 2 scenario is a demo calibration layer for hackathon display.
- Do not present patched Day 2 risk values as validated agronomic diagnosis.
"""

from __future__ import annotations

import copy
import json
import math
import os
import sys
from collections import Counter
from datetime import date
from pathlib import Path
from typing import Any, Iterable, Mapping, MutableMapping, Sequence

SCRIPT_DIR = Path(__file__).resolve().parent
BACKEND_ROOT = SCRIPT_DIR.parent
REPO_ROOT = BACKEND_ROOT.parent

DEMO_CANDIDATES = (
    REPO_ROOT / "geospatial/data/demo",
    REPO_ROOT / "frontend/public/demo",
    BACKEND_ROOT / "data/demo",
    Path.cwd(),
)

OUTPUT_PATH = BACKEND_ROOT / "supabase/seed_day2.sql"

DEMO_ESTATE_ID = "estate_demo_01"
PROCESSING_RUN_ID = "00000000-0000-0000-0000-000000000002"

ALLOWED_RISK_CATEGORIES = frozenset(
    {"Normal", "Watch", "Warning", "Priority Inspection"}
)
CATEGORY_ORDER_ASC = ("Normal", "Watch", "Warning", "Priority Inspection")
CATEGORY_ORDER_DESC = ("Priority Inspection", "Warning", "Watch", "Normal")
MIN_BLOCKS_PER_CATEGORY = 5

# Default true because Day 1 real satellite data is usually too flat for the Day 2 demo.
# Set CROPSTRESS_DAY2_PATCH_RISK=false to force strict validation without patching.
ENABLE_DEMO_SCENARIO_PATCH = os.getenv(
    "CROPSTRESS_DAY2_PATCH_RISK", "true"
).strip().lower() not in {"0", "false", "no", "off"}

# Optional. Keep false unless another agent needs regenerated JSON files too.
WRITE_PATCHED_JSON = os.getenv(
    "CROPSTRESS_DAY2_WRITE_PATCHED_JSON", "false"
).strip().lower() in {"1", "true", "yes", "on"}

DEMO_FILES = (
    "blocks.geojson",
    "block_indicators_latest.json",
    "risk_scores_latest.json",
    "scouting_priority_latest.json",
)

INDICATOR_COLUMNS = (
    "processing_run_id",
    "block_id",
    "observation_date",
    "ndvi",
    "ndvi_baseline",
    "ndvi_anomaly",
    "ndmi",
    "ndmi_baseline",
    "ndmi_anomaly",
    "rainfall_30d_mm",
    "rainfall_baseline_mm",
    "rainfall_deficit_pct",
    "hotspot_count_7d",
    "nearest_hotspot_km",
    "quality_flag",
)

RISK_COLUMNS = (
    "processing_run_id",
    "block_id",
    "score_date",
    "vegetation_stress",
    "moisture_stress",
    "rainfall_stress",
    "fire_risk",
    "risk_score",
    "risk_category",
    "dominant_driver",
    "recommended_action",
)


def clamp(value: float, min_value: float = 0.0, max_value: float = 1.0) -> float:
    return max(min_value, min(max_value, float(value)))


def round_float(value: float | int | None, digits: int = 4) -> float | None:
    if value is None:
        return None
    if isinstance(value, float) and (math.isnan(value) or math.isinf(value)):
        return None
    return round(float(value), digits)


def safe_float(value: Any, default: float | None = None) -> float | None:
    if value is None:
        return default
    try:
        result = float(value)
    except (TypeError, ValueError):
        return default
    if math.isnan(result) or math.isinf(result):
        return default
    return result


def sql_text(value: Any) -> str:
    if value is None:
        return "null"
    return "'" + str(value).replace("'", "''") + "'"


def sql_number(value: Any) -> str:
    if value is None:
        return "null"
    number = safe_float(value)
    if number is None:
        return "null"
    return str(number)


def sql_int(value: Any) -> str:
    if value is None:
        return "null"
    return str(int(value))


def load_json(path: Path) -> Any:
    if not path.is_file():
        raise FileNotFoundError(f"Missing input file: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def resolve_demo_dir() -> Path:
    checked: list[str] = []

    for candidate in DEMO_CANDIDATES:
        candidate = candidate.resolve()
        if not candidate.is_dir():
            checked.append(f"{candidate} (not a directory)")
            continue

        absent = [name for name in DEMO_FILES if not (candidate / name).is_file()]
        if not absent:
            return candidate

        checked.append(f"{candidate} (missing: {', '.join(absent)})")

    raise FileNotFoundError(
        "No complete demo data folder found. Checked:\n  - " + "\n  - ".join(checked)
    )


def extract_block_ids(blocks_geojson: Mapping[str, Any]) -> set[str]:
    block_ids: set[str] = set()
    duplicate_ids: set[str] = set()

    for feature in blocks_geojson.get("features") or []:
        props = feature.get("properties") or {}
        block_id = props.get("block_id") or props.get("block_code")
        if not block_id:
            raise ValueError(f"Block feature missing block_id/block_code: {props}")

        block_id = str(block_id)
        if block_id in block_ids:
            duplicate_ids.add(block_id)
        block_ids.add(block_id)

    if duplicate_ids:
        raise ValueError(f"blocks.geojson contains duplicate block_id values: {sorted(duplicate_ids)}")

    return block_ids


def duplicate_block_ids(rows: Sequence[Mapping[str, Any]], label: str) -> list[str]:
    seen: set[str] = set()
    duplicates: set[str] = set()

    for index, row in enumerate(rows, start=1):
        block_id = row.get("block_id")
        if not block_id:
            raise ValueError(f"{label} row {index} is missing block_id")

        block_id = str(block_id)
        if block_id in seen:
            duplicates.add(block_id)
        seen.add(block_id)

    return sorted(duplicates)


def get_category(score: float) -> str:
    score = float(score)
    if score < 0.25:
        return "Normal"
    if score < 0.45:
        return "Watch"
    if score < 0.65:
        return "Warning"
    return "Priority Inspection"


def calculate_risk_score(row: Mapping[str, Any]) -> float:
    vegetation_stress = safe_float(row.get("vegetation_stress"), 0.0) or 0.0
    moisture_stress = safe_float(row.get("moisture_stress"), 0.0) or 0.0
    rainfall_stress = safe_float(row.get("rainfall_stress"), 0.0) or 0.0
    fire_risk = safe_float(row.get("fire_risk"), 0.0) or 0.0

    return round_float(
        0.30 * vegetation_stress
        + 0.30 * moisture_stress
        + 0.25 * rainfall_stress
        + 0.15 * fire_risk,
        4,
    ) or 0.0


def risk_category_counts(risk_scores: Sequence[Mapping[str, Any]]) -> Counter[str]:
    return Counter(str(row.get("risk_category")) for row in risk_scores)


def underfilled_categories(risk_scores: Sequence[Mapping[str, Any]]) -> dict[str, int]:
    counts = risk_category_counts(risk_scores)
    return {
        category: counts.get(category, 0)
        for category in CATEGORY_ORDER_ASC
        if counts.get(category, 0) < MIN_BLOCKS_PER_CATEGORY
    }


def validate_common_data(
    block_ids: set[str],
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
) -> None:
    block_count = len(block_ids)
    if block_count == 0:
        raise ValueError("blocks.geojson has no block features")

    if block_count < MIN_BLOCKS_PER_CATEGORY * len(CATEGORY_ORDER_ASC):
        raise ValueError(
            f"Day 2 category validation needs at least "
            f"{MIN_BLOCKS_PER_CATEGORY * len(CATEGORY_ORDER_ASC)} blocks. Got {block_count}."
        )

    for duplicates, label in (
        (duplicate_block_ids(indicators, "block_indicators_latest.json"), "block_indicators_latest.json"),
        (duplicate_block_ids(risk_scores, "risk_scores_latest.json"), "risk_scores_latest.json"),
        (duplicate_block_ids(scouting, "scouting_priority_latest.json"), "scouting_priority_latest.json"),
    ):
        if duplicates:
            raise ValueError(f"{label} contains duplicate block_id values: {duplicates[:10]}")

    indicator_ids = {str(row["block_id"]) for row in indicators}
    risk_ids = {str(row["block_id"]) for row in risk_scores}
    scouting_ids = {str(row["block_id"]) for row in scouting}

    if len(indicators) != block_count:
        raise ValueError(
            f"block_indicators count ({len(indicators)}) must equal blocks count ({block_count})"
        )
    if len(risk_scores) != block_count:
        raise ValueError(
            f"risk_scores count ({len(risk_scores)}) must equal blocks count ({block_count})"
        )
    if len(scouting) != block_count:
        raise ValueError(
            f"scouting_priority count ({len(scouting)}) must equal blocks count ({block_count})"
        )

    missing_indicators = sorted(block_ids - indicator_ids)
    missing_risk = sorted(block_ids - risk_ids)
    missing_scouting = sorted(block_ids - scouting_ids)
    extra_indicators = sorted(indicator_ids - block_ids)
    extra_risk = sorted(risk_ids - block_ids)
    extra_scouting = sorted(scouting_ids - block_ids)

    if missing_indicators or missing_risk or missing_scouting:
        raise ValueError(
            "block_id mismatch across demo files: "
            f"missing indicators={missing_indicators[:5]}, "
            f"missing risk_scores={missing_risk[:5]}, "
            f"missing scouting={missing_scouting[:5]}"
        )

    if extra_indicators or extra_risk or extra_scouting:
        raise ValueError(
            "demo JSON contains block_id not present in blocks.geojson: "
            f"extra indicators={extra_indicators[:5]}, "
            f"extra risk_scores={extra_risk[:5]}, "
            f"extra scouting={extra_scouting[:5]}"
        )

    invalid_categories = sorted(
        {
            row.get("risk_category")
            for row in risk_scores
            if row.get("risk_category") not in ALLOWED_RISK_CATEGORIES
        }
    )
    if invalid_categories:
        raise ValueError(
            "risk_category must be one of "
            f"{sorted(ALLOWED_RISK_CATEGORIES)}; invalid: {invalid_categories}"
        )


def validate_final_day2_data(
    block_ids: set[str],
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
) -> None:
    validate_common_data(block_ids, indicators, risk_scores, scouting)

    risk_by_block = {str(row["block_id"]): row for row in risk_scores}

    ranks = [row.get("priority_rank") for row in scouting]
    if any(rank is None for rank in ranks):
        raise ValueError("scouting_priority_latest.json has missing priority_rank")

    try:
        rank_ints = [int(rank) for rank in ranks]
    except (TypeError, ValueError) as exc:
        raise ValueError("scouting_priority_latest.json has invalid priority_rank") from exc

    expected_ranks = list(range(1, len(block_ids) + 1))
    if rank_ints != expected_ranks:
        raise ValueError(
            f"priority_rank must be ordered 1..{len(block_ids)}; got first ranks: {rank_ints[:10]}"
        )

    previous_score: float | None = None
    for index, row in enumerate(scouting, start=1):
        block_id = str(row["block_id"])
        score = safe_float(row.get("risk_score"))
        if score is None:
            raise ValueError(f"scouting row {index} block_id={block_id} has null risk_score")

        if previous_score is not None and score > previous_score + 1e-9:
            raise ValueError(
                "scouting_priority_latest.json must be sorted by risk_score descending; "
                f"row {index} score {score} > previous score {previous_score}"
            )
        previous_score = score

        linked = risk_by_block.get(block_id)
        if not linked:
            raise ValueError(f"scouting block_id {block_id} missing from risk_scores_latest.json")

        linked_score = safe_float(linked.get("risk_score"))
        if linked_score is None or abs(linked_score - score) > 1e-6:
            raise ValueError(
                f"scouting risk_score {score} for block_id={block_id} does not match "
                f"risk_scores_latest.json ({linked_score})"
            )

        linked_category = linked.get("risk_category")
        if row.get("risk_category") != linked_category:
            raise ValueError(
                f"scouting risk_category for block_id={block_id} does not match risk_scores_latest.json"
            )

    for row in risk_scores:
        formula_score = calculate_risk_score(row)
        saved_score = safe_float(row.get("risk_score"))
        if saved_score is None:
            raise ValueError(f"risk_scores row block_id={row.get('block_id')} has null risk_score")
        if abs(formula_score - saved_score) > 0.0001:
            raise ValueError(
                f"risk_score for block_id={row.get('block_id')} does not match formula. "
                f"saved={saved_score}, formula={formula_score}"
            )

        formula_category = get_category(saved_score)
        if row.get("risk_category") != formula_category:
            raise ValueError(
                f"risk_category for block_id={row.get('block_id')} does not match threshold. "
                f"saved={row.get('risk_category')}, formula={formula_category}"
            )

    short_categories = underfilled_categories(risk_scores)
    if short_categories:
        detail = ", ".join(
            f"{category}={short_categories[category]}" for category in CATEGORY_ORDER_ASC if category in short_categories
        )
        raise ValueError(
            f"Day 2 requires at least {MIN_BLOCKS_PER_CATEGORY} blocks per risk category; "
            f"underfilled: {detail}"
        )


def target_category_counts(block_count: int) -> dict[str, int]:
    """Return a balanced distribution. For 48 blocks, this returns 12 each."""
    base = block_count // len(CATEGORY_ORDER_ASC)
    remainder = block_count % len(CATEGORY_ORDER_ASC)

    counts = {category: base for category in CATEGORY_ORDER_ASC}

    # Put extra rows into operationally useful categories first.
    for category in ("Priority Inspection", "Warning", "Watch", "Normal")[:remainder]:
        counts[category] += 1

    for category in CATEGORY_ORDER_ASC:
        if counts[category] < MIN_BLOCKS_PER_CATEGORY:
            raise ValueError(
                f"Cannot create Day 2 scenario: category {category} would only have {counts[category]} blocks"
            )

    return counts


def interpolate_score(category: str, index_in_category: int, count: int) -> float:
    ranges = {
        "Priority Inspection": (0.74, 0.66),
        "Warning": (0.63, 0.46),
        "Watch": (0.44, 0.26),
        "Normal": (0.23, 0.06),
    }

    high, low = ranges[category]
    if count <= 1:
        return round_float((high + low) / 2, 4) or 0.0

    fraction = index_in_category / (count - 1)
    return round_float(high - (high - low) * fraction, 4) or 0.0


def driver_for_row(category: str, index: int) -> str:
    if category == "Priority Inspection":
        return (
            "NDMI drop + rainfall deficit"
            if index % 3 != 2
            else "Rainfall deficit + hotspot proximity"
        )
    if category == "Warning":
        return (
            "NDVI decline + NDMI drop"
            if index % 2 == 0
            else "NDMI drop + rainfall deficit"
        )
    if category == "Watch":
        return (
            "NDMI drop + rainfall deficit"
            if index % 2 == 0
            else "NDVI decline"
        )
    return "No significant stress signal"


def profile_for_driver(driver: str) -> dict[str, float]:
    if "hotspot" in driver.lower():
        return {
            "vegetation_stress": 0.60,
            "moisture_stress": 0.65,
            "rainfall_stress": 0.90,
            "fire_risk": 0.95,
        }
    if "NDVI decline + NDMI drop" in driver:
        return {
            "vegetation_stress": 0.95,
            "moisture_stress": 0.90,
            "rainfall_stress": 0.45,
            "fire_risk": 0.10,
        }
    if "NDVI decline" == driver:
        return {
            "vegetation_stress": 0.95,
            "moisture_stress": 0.45,
            "rainfall_stress": 0.30,
            "fire_risk": 0.05,
        }
    if "No significant" in driver:
        return {
            "vegetation_stress": 0.35,
            "moisture_stress": 0.35,
            "rainfall_stress": 0.35,
            "fire_risk": 0.10,
        }

    return {
        "vegetation_stress": 0.55,
        "moisture_stress": 0.95,
        "rainfall_stress": 0.90,
        "fire_risk": 0.25,
    }


def components_for_target_score(target_score: float, driver: str) -> dict[str, float]:
    profile = profile_for_driver(driver)
    base_score = (
        0.30 * profile["vegetation_stress"]
        + 0.30 * profile["moisture_stress"]
        + 0.25 * profile["rainfall_stress"]
        + 0.15 * profile["fire_risk"]
    )

    if base_score <= 0:
        return {
            "vegetation_stress": target_score,
            "moisture_stress": target_score,
            "rainfall_stress": target_score,
            "fire_risk": target_score,
        }

    factor = target_score / base_score
    scaled = {key: clamp(value * factor) for key, value in profile.items()}
    actual_score = (
        0.30 * scaled["vegetation_stress"]
        + 0.30 * scaled["moisture_stress"]
        + 0.25 * scaled["rainfall_stress"]
        + 0.15 * scaled["fire_risk"]
    )

    # If clamping makes the score drift, fall back to exact equal components.
    # Because weights sum to 1.0, equal components produce the exact target score.
    if abs(actual_score - target_score) > 0.002:
        scaled = {
            "vegetation_stress": target_score,
            "moisture_stress": target_score,
            "rainfall_stress": target_score,
            "fire_risk": target_score,
        }

    return {key: round_float(value, 4) or 0.0 for key, value in scaled.items()}


def recommended_action(category: str, driver: str) -> str:
    lower_driver = driver.lower()

    if category == "Priority Inspection":
        if "hotspot" in lower_driver:
            return "Inspect today and prioritize fire patrol"
        if "rainfall" in lower_driver or "ndmi" in lower_driver:
            return "Inspect today for moisture stress"
        return "Inspect today and verify crop condition"

    if category == "Warning":
        if "hotspot" in lower_driver:
            return "Inspect this week and monitor fire risk"
        if "rainfall" in lower_driver or "ndmi" in lower_driver:
            return "Inspect this week for water stress"
        return "Inspect this week and verify vegetation decline"

    if category == "Watch":
        return "Monitor next processing cycle"

    return "No urgent action"


def task_status_for_category(category: str) -> str:
    if category in {"Priority Inspection", "Warning", "Watch"}:
        return "open"
    return "monitor_only"


def patch_indicator_for_category(
    indicator: MutableMapping[str, Any],
    category: str,
    driver: str,
    index_in_category: int,
    count: int,
) -> None:
    ndvi_baseline = safe_float(indicator.get("ndvi_baseline"), safe_float(indicator.get("ndvi"), 0.78)) or 0.78
    ndmi_baseline = safe_float(indicator.get("ndmi_baseline"), safe_float(indicator.get("ndmi"), 0.25)) or 0.25
    rainfall_baseline = safe_float(indicator.get("rainfall_baseline_mm"), 492.38) or 492.38

    # Deterministic gradient inside each category. Higher rank = stronger anomaly.
    fraction = 0.0 if count <= 1 else index_in_category / (count - 1)

    if category == "Priority Inspection":
        ndvi_anomaly = -0.115 + 0.025 * fraction
        ndmi_anomaly = -0.120 + 0.030 * fraction
        rainfall_deficit_pct = 76.0 - 8.0 * fraction
        hotspot_count = 1 if "hotspot" in driver.lower() else 0
        nearest_hotspot_km = round_float(2.2 + 2.6 * fraction, 2) if hotspot_count else None
    elif category == "Warning":
        ndvi_anomaly = -0.075 + 0.020 * fraction
        ndmi_anomaly = -0.080 + 0.020 * fraction
        rainfall_deficit_pct = 60.0 - 8.0 * fraction
        hotspot_count = 0
        nearest_hotspot_km = None
    elif category == "Watch":
        ndvi_anomaly = -0.040 + 0.018 * fraction
        ndmi_anomaly = -0.045 + 0.020 * fraction
        rainfall_deficit_pct = 40.0 - 10.0 * fraction
        hotspot_count = 0
        nearest_hotspot_km = None
    else:
        ndvi_anomaly = 0.015 + 0.020 * fraction
        ndmi_anomaly = -0.010 + 0.015 * fraction
        rainfall_deficit_pct = 18.0 - 10.0 * fraction
        hotspot_count = 0
        nearest_hotspot_km = None

    rainfall_30d_mm = rainfall_baseline * (1 - rainfall_deficit_pct / 100.0)

    indicator["ndvi_baseline"] = round_float(ndvi_baseline)
    indicator["ndvi_anomaly"] = round_float(ndvi_anomaly)
    indicator["ndvi"] = round_float(clamp(ndvi_baseline + ndvi_anomaly, -1.0, 1.0))

    indicator["ndmi_baseline"] = round_float(ndmi_baseline)
    indicator["ndmi_anomaly"] = round_float(ndmi_anomaly)
    indicator["ndmi"] = round_float(clamp(ndmi_baseline + ndmi_anomaly, -1.0, 1.0))

    indicator["rainfall_baseline_mm"] = round_float(rainfall_baseline, 2)
    indicator["rainfall_deficit_pct"] = round_float(rainfall_deficit_pct, 2)
    indicator["rainfall_30d_mm"] = round_float(rainfall_30d_mm, 2)
    indicator["hotspot_count_7d"] = hotspot_count
    indicator["nearest_hotspot_km"] = nearest_hotspot_km
    indicator["quality_flag"] = "day2_demo_scenario_from_real_satellite"


def apply_day2_demo_scenario(
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]]]:
    patched_indicators = [dict(row) for row in copy.deepcopy(indicators)]
    patched_risk_scores = [dict(row) for row in copy.deepcopy(risk_scores)]

    indicators_by_block = {str(row["block_id"]): row for row in patched_indicators}

    # Use the existing score as a weak ordering signal, then block_id for deterministic ties.
    ordered = sorted(
        patched_risk_scores,
        key=lambda row: (
            safe_float(row.get("risk_score"), -1.0) or -1.0,
            str(row.get("block_id")),
        ),
        reverse=True,
    )

    counts = target_category_counts(len(ordered))

    assignments: list[tuple[dict[str, Any], str, int, int]] = []
    cursor = 0
    for category in CATEGORY_ORDER_DESC:
        count = counts[category]
        for local_index in range(count):
            assignments.append((ordered[cursor], category, local_index, count))
            cursor += 1

    for row, category, local_index, category_count in assignments:
        driver = driver_for_row(category, local_index)
        target_score = interpolate_score(category, local_index, category_count)
        components = components_for_target_score(target_score, driver)

        row.update(components)
        row["risk_score"] = calculate_risk_score(row)
        row["risk_category"] = get_category(float(row["risk_score"]))
        row["dominant_driver"] = driver
        row["recommended_action"] = recommended_action(row["risk_category"], driver)

        indicator = indicators_by_block.get(str(row["block_id"]))
        if indicator is not None:
            patch_indicator_for_category(
                indicator,
                row["risk_category"],
                driver,
                local_index,
                category_count,
            )

    patched_risk_scores = sorted(
        patched_risk_scores,
        key=lambda row: (
            safe_float(row.get("risk_score"), -1.0) or -1.0,
            str(row.get("block_id")),
        ),
        reverse=True,
    )

    patched_scouting: list[dict[str, Any]] = []
    for rank, row in enumerate(patched_risk_scores, start=1):
        patched_scouting.append(
            {
                "priority_rank": rank,
                "block_id": row["block_id"],
                "score_date": row.get("score_date") or str(date.today()),
                "risk_score": row["risk_score"],
                "risk_category": row["risk_category"],
                "dominant_driver": row.get("dominant_driver"),
                "recommended_action": row.get("recommended_action"),
                "task_status": task_status_for_category(str(row.get("risk_category"))),
            }
        )

    patched_indicators = sorted(patched_indicators, key=lambda row: str(row.get("block_id")))
    patched_risk_scores = sorted(patched_risk_scores, key=lambda row: str(row.get("block_id")))

    return patched_indicators, patched_risk_scores, patched_scouting


class SeedSqlBuilder:
    def __init__(self) -> None:
        self._lines: list[str] = []

    def add(self, line: str = "") -> None:
        self._lines.append(line)

    def add_block(self, text: str) -> None:
        self._lines.extend(text.splitlines())

    def extend(self, lines: Iterable[str]) -> None:
        self._lines.extend(lines)

    def render(self) -> str:
        return "\n".join(self._lines) + "\n"


def build_scouting_values_sql(scouting: Sequence[Mapping[str, Any]]) -> str:
    rows: list[str] = []
    for row in scouting:
        rows.append(
            "("
            f"{sql_text(row['block_id'])}, "
            f"{sql_int(row['priority_rank'])}, "
            f"{sql_text(row.get('task_status'))}"
            ")"
        )
    return ",\n  ".join(rows)


def indicator_row_values(row: Mapping[str, Any]) -> str:
    return (
        "("
        f"{sql_text(PROCESSING_RUN_ID)}, "
        f"{sql_text(row.get('block_id'))}, "
        f"{sql_text(row.get('observation_date'))}, "
        f"{sql_number(row.get('ndvi'))}, "
        f"{sql_number(row.get('ndvi_baseline'))}, "
        f"{sql_number(row.get('ndvi_anomaly'))}, "
        f"{sql_number(row.get('ndmi'))}, "
        f"{sql_number(row.get('ndmi_baseline'))}, "
        f"{sql_number(row.get('ndmi_anomaly'))}, "
        f"{sql_number(row.get('rainfall_30d_mm'))}, "
        f"{sql_number(row.get('rainfall_baseline_mm'))}, "
        f"{sql_number(row.get('rainfall_deficit_pct'))}, "
        f"{sql_int(row.get('hotspot_count_7d'))}, "
        f"{sql_number(row.get('nearest_hotspot_km'))}, "
        f"{sql_text(row.get('quality_flag'))}"
        ")"
    )


def risk_row_values(row: Mapping[str, Any]) -> str:
    return (
        "("
        f"{sql_text(PROCESSING_RUN_ID)}, "
        f"{sql_text(row.get('block_id'))}, "
        f"{sql_text(row.get('score_date'))}, "
        f"{sql_number(row.get('vegetation_stress'))}, "
        f"{sql_number(row.get('moisture_stress'))}, "
        f"{sql_number(row.get('rainfall_stress'))}, "
        f"{sql_number(row.get('fire_risk'))}, "
        f"{sql_number(row.get('risk_score'))}, "
        f"{sql_text(row.get('risk_category'))}, "
        f"{sql_text(row.get('dominant_driver'))}, "
        f"{sql_text(row.get('recommended_action'))}"
        ")"
    )


def build_seed_sql(
    demo_dir: Path,
    blocks_geojson: Mapping[str, Any],
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
    scenario_was_patched: bool,
) -> str:
    features = blocks_geojson.get("features") or []
    collection_props = blocks_geojson.get("properties") or {}
    estate_id = collection_props.get("estate_id") or DEMO_ESTATE_ID
    estate_name = collection_props.get("estate_name") or "Demo Estate"

    score_date = risk_scores[0]["score_date"] if risk_scores else str(date.today())
    observation_date = indicators[0]["observation_date"] if indicators else score_date

    notes = (
        "Day 2 demo import with deterministic scenario patch from Agent A outputs"
        if scenario_was_patched
        else "Day 2 demo import from Agent A outputs"
    )

    out = SeedSqlBuilder()
    out.add("-- Auto-generated Day 2 seed file.")
    out.add(f"-- Source: {demo_dir}")
    out.add("-- Regenerate: python backend/scripts/build_seed_day2_sql.py")
    if scenario_was_patched:
        out.add("-- Note: risk and indicator values were patched in memory for Day 2 demo distribution.")
    out.add("")
    out.add("begin;")
    out.add("")

    out.add("-- Remove previous Day 2 run rows. Field reports are preserved.")
    out.add(
        f"delete from scouting_tasks where risk_score_id in ("
        f"select id from risk_scores where processing_run_id = {sql_text(PROCESSING_RUN_ID)}"
        f");"
    )
    out.add(
        f"delete from risk_scores where processing_run_id = {sql_text(PROCESSING_RUN_ID)};"
    )
    out.add(
        f"delete from block_indicators where processing_run_id = {sql_text(PROCESSING_RUN_ID)};"
    )
    out.add(
        f"delete from processing_runs where id = {sql_text(PROCESSING_RUN_ID)};"
    )
    out.add("")

    out.add_block(
        f"""
insert into estates (id, name, province, district)
values ({sql_text(estate_id)}, {sql_text(estate_name)}, 'Unknown', 'Unknown')
on conflict (id) do update set
  name = excluded.name;
""".strip()
    )
    out.add("")

    out.add_block(
        f"""
insert into processing_runs (
  id,
  run_date,
  status,
  source_window_start,
  source_window_end,
  notes
)
values (
  {sql_text(PROCESSING_RUN_ID)},
  {sql_text(score_date)},
  'completed',
  {sql_text(observation_date)},
  {sql_text(score_date)},
  {sql_text(notes)}
)
on conflict (id) do update set
  run_date = excluded.run_date,
  status = excluded.status,
  source_window_start = excluded.source_window_start,
  source_window_end = excluded.source_window_end,
  notes = excluded.notes;
""".strip()
    )
    out.add("")

    for feature in features:
        props = feature.get("properties") or {}
        geom = feature.get("geometry")
        if not geom:
            raise ValueError(f"Feature missing geometry: {props}")

        block_id = props.get("block_id") or props.get("block_code")
        if not block_id:
            raise ValueError(f"Feature missing block_id: {props}")

        block_code = props.get("block_code") or block_id
        block_name = props.get("block_name") or block_id
        feature_estate_id = props.get("estate_id") or estate_id
        area_ha = props.get("area_ha")
        geom_json = json.dumps(geom, separators=(",", ":")).replace("'", "''")

        out.add_block(
            f"""
insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  {sql_text(block_id)},
  {sql_text(feature_estate_id)},
  {sql_text(block_code)},
  {sql_text(block_name)},
  {sql_number(area_ha)},
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{geom_json}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;
""".strip()
        )
        out.add("")

    indicator_values = ",\n  ".join(indicator_row_values(row) for row in indicators)
    out.add_block(
        f"""
insert into block_indicators (
  {", ".join(INDICATOR_COLUMNS)}
)
values
  {indicator_values};
""".strip()
    )
    out.add("")

    risk_values = ",\n  ".join(risk_row_values(row) for row in risk_scores)
    out.add_block(
        f"""
insert into risk_scores (
  {", ".join(RISK_COLUMNS)}
)
values
  {risk_values};
""".strip()
    )
    out.add("")

    out.add("-- Replace scouting queue for the latest Day 2 risk snapshot.")
    out.add("delete from scouting_tasks;")
    out.add("")

    scouting_values = build_scouting_values_sql(scouting)
    out.add_block(
        f"""
insert into scouting_tasks (
  block_id,
  risk_score_id,
  priority_rank,
  task_status,
  recommended_action,
  due_date
)
select
  lsp.block_id,
  lsp.risk_score_id,
  sp.priority_rank,
  sp.task_status,
  lsp.recommended_action,
  lsp.score_date + interval '1 day'
from latest_scouting_priority lsp
join (
  values
  {scouting_values}
) as sp (block_id, priority_rank, task_status)
  on sp.block_id = lsp.block_id
order by sp.priority_rank;
""".strip()
    )
    out.add("")
    out.add("commit;")

    return out.render()


def print_distribution(label: str, risk_scores: Sequence[Mapping[str, Any]]) -> None:
    counts = risk_category_counts(risk_scores)
    ordered = {category: counts.get(category, 0) for category in CATEGORY_ORDER_ASC}
    print(f"{label}: {ordered}")


def main() -> int:
    demo_dir = resolve_demo_dir()
    blocks_geojson = load_json(demo_dir / "blocks.geojson")
    indicators = load_json(demo_dir / "block_indicators_latest.json")
    risk_scores = load_json(demo_dir / "risk_scores_latest.json")
    scouting = load_json(demo_dir / "scouting_priority_latest.json")

    if not isinstance(blocks_geojson, dict):
        raise TypeError("blocks.geojson must be a GeoJSON FeatureCollection object")
    if not isinstance(indicators, list) or not isinstance(risk_scores, list):
        raise TypeError("Indicators and risk_scores inputs must be JSON arrays")
    if not isinstance(scouting, list):
        raise TypeError("scouting_priority_latest.json must be a JSON array")

    block_ids = extract_block_ids(blocks_geojson)
    validate_common_data(block_ids, indicators, risk_scores, scouting)

    print(f"Source: {demo_dir}")
    print_distribution("Source risk distribution", risk_scores)

    scenario_was_patched = False
    if underfilled_categories(risk_scores):
        if not ENABLE_DEMO_SCENARIO_PATCH:
            validate_final_day2_data(block_ids, indicators, risk_scores, scouting)
        print(
            "Source data is not Day 2 demo-ready. "
            "Applying deterministic Day 2 scenario patch in memory."
        )
        indicators, risk_scores, scouting = apply_day2_demo_scenario(
            indicators, risk_scores, scouting
        )
        scenario_was_patched = True
        print_distribution("Patched risk distribution", risk_scores)

        if WRITE_PATCHED_JSON:
            write_json(demo_dir / "block_indicators_latest.json", indicators)
            write_json(demo_dir / "risk_scores_latest.json", risk_scores)
            write_json(demo_dir / "scouting_priority_latest.json", scouting)
            print("Patched JSON files were written because CROPSTRESS_DAY2_WRITE_PATCHED_JSON=true")

    validate_final_day2_data(block_ids, indicators, risk_scores, scouting)

    sql = build_seed_sql(
        demo_dir=demo_dir,
        blocks_geojson=blocks_geojson,
        indicators=indicators,
        risk_scores=risk_scores,
        scouting=scouting,
        scenario_was_patched=scenario_was_patched,
    )
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(sql, encoding="utf-8")

    print(f"Generated {OUTPUT_PATH}")
    print(
        f"  blocks={len(block_ids)}, "
        f"indicators={len(indicators)}, "
        f"risk_scores={len(risk_scores)}, "
        f"scouting={len(scouting)}"
    )
    print("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileNotFoundError, ValueError, TypeError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc