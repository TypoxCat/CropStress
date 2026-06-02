#!/usr/bin/env python3
"""
Build supabase/seed_day1.sql from Agent A demo outputs in data/demo/.

Reads:
  - blocks.geojson
  - block_indicators_latest.json
  - risk_scores_latest.json
  - scouting_priority_latest.json

Writes:
  - supabase/seed_day1.sql
"""

from __future__ import annotations

import json
import sys
from datetime import date
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

ROOT = Path(__file__).resolve().parents[1]
DEMO_DIR = ROOT / "data/demo"
BLOCKS_PATH = DEMO_DIR / "blocks.geojson"
INDICATORS_PATH = DEMO_DIR / "block_indicators_latest.json"
RISK_SCORES_PATH = DEMO_DIR / "risk_scores_latest.json"
SCOUTING_PATH = DEMO_DIR / "scouting_priority_latest.json"
OUTPUT_PATH = ROOT / "supabase/seed_day1.sql"

DEMO_ESTATE_ID = "estate_demo_01"
PROCESSING_RUN_ID = "00000000-0000-0000-0000-000000000001"

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


def sql_text(value: Any) -> str:
    if value is None:
        return "null"
    return "'" + str(value).replace("'", "''") + "'"


def sql_number(value: Any) -> str:
    if value is None:
        return "null"
    return str(value)


def sql_int(value: Any) -> str:
    if value is None:
        return "null"
    return str(int(value))


def load_json(path: Path) -> Any:
    if not path.is_file():
        raise FileNotFoundError(f"Missing input file: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def validate_demo_data(
    block_ids: set[str],
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
) -> None:
    indicator_ids = {row["block_id"] for row in indicators}
    risk_ids = {row["block_id"] for row in risk_scores}
    scouting_ids = {row["block_id"] for row in scouting}

    missing_indicators = block_ids - indicator_ids
    missing_risk = block_ids - risk_ids
    missing_scouting = block_ids - scouting_ids

    if missing_indicators or missing_risk or missing_scouting:
        raise ValueError(
            "block_id mismatch across demo files: "
            f"indicators={len(missing_indicators)}, "
            f"risk={len(missing_risk)}, "
            f"scouting={len(missing_scouting)}"
        )

    extra_scouting = scouting_ids - block_ids
    if extra_scouting:
        raise ValueError(
            f"scouting_priority_latest.json has unknown block_ids: {sorted(extra_scouting)[:5]}"
        )


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
    blocks_geojson: Mapping[str, Any],
    indicators: Sequence[Mapping[str, Any]],
    risk_scores: Sequence[Mapping[str, Any]],
    scouting: Sequence[Mapping[str, Any]],
) -> str:
    features = blocks_geojson.get("features") or []
    collection_props = blocks_geojson.get("properties") or {}
    estate_id = collection_props.get("estate_id") or DEMO_ESTATE_ID
    estate_name = collection_props.get("estate_name") or "Demo Estate"

    block_ids = {
        (feature.get("properties") or {}).get("block_id")
        or (feature.get("properties") or {}).get("block_code")
        for feature in features
    }
    block_ids.discard(None)

    validate_demo_data(block_ids, indicators, risk_scores, scouting)

    score_date = risk_scores[0]["score_date"] if risk_scores else str(date.today())
    observation_date = (
        indicators[0]["observation_date"] if indicators else score_date
    )

    out = SeedSqlBuilder()
    out.add("-- Auto-generated Day 1 seed file.")
    out.add("-- Generated from data/demo/*.json and blocks.geojson")
    out.add("-- Regenerate: python scripts/build_seed_day1_sql.py")
    out.add("")
    out.add("begin;")
    out.add("")

    out.add("-- Remove previous demo data (child tables first)")
    out.add("delete from field_reports;")
    out.add("delete from scouting_tasks;")
    out.add("delete from risk_scores;")
    out.add("delete from block_indicators;")
    out.add("delete from processing_runs;")
    out.add("delete from blocks;")
    out.add("delete from estates;")
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
  'Day 1 demo import from Agent A outputs'
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


def main() -> int:
    blocks_geojson = load_json(BLOCKS_PATH)
    indicators = load_json(INDICATORS_PATH)
    risk_scores = load_json(RISK_SCORES_PATH)
    scouting = load_json(SCOUTING_PATH)

    if not isinstance(indicators, list) or not isinstance(risk_scores, list):
        raise TypeError("Indicators and risk_scores inputs must be JSON arrays")
    if not isinstance(scouting, list):
        raise TypeError("scouting_priority_latest.json must be a JSON array")

    sql = build_seed_sql(blocks_geojson, indicators, risk_scores, scouting)
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(sql, encoding="utf-8")

    feature_count = len(blocks_geojson.get("features") or [])
    print(f"Generated {OUTPUT_PATH}")
    print(
        f"  blocks={feature_count}, "
        f"indicators={len(indicators)}, "
        f"risk_scores={len(risk_scores)}, "
        f"scouting={len(scouting)}"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileNotFoundError, ValueError, TypeError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc
