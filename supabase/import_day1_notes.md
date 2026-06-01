# Day 1 Supabase Import Notes

## Purpose

This folder contains the database setup for CropStress Insight Day 1.

Agent A generates satellite-derived demo outputs in:

- data/demo/blocks.geojson
- data/demo/block_indicators_latest.json
- data/demo/risk_scores_latest.json
- data/demo/scouting_priority_latest.json

Agent B imports those outputs into Supabase PostgreSQL + PostGIS so Agent C can build the dashboard.

## Import Steps

1. Open Supabase SQL Editor.
2. Run `supabase/schema.sql`.
3. Run:

```bash
python scripts/build_seed_day1_sql.py