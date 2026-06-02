# CropStress Insight — Day 1 Database

**Audience:** Agent C (frontend) and hackathon teammates.

This document explains how Day 1 data gets into Supabase, what to query, and what to expect from the demo dataset.

---

## Purpose

The Day 1 database is a **Supabase (PostgreSQL + PostGIS)** store for one demo estate. It holds:

- plantation block boundaries (map polygons)
- satellite-derived indicators per block
- risk scores and scouting priority
- optional field verification reports from the dashboard

**Do not read `data/demo/*.json` in the frontend** once Supabase is loaded. Use the views below via the Supabase client.

Pipeline overview:

```text
Agent A  →  data/demo/*.json + blocks.geojson
Agent B  →  supabase/schema.sql + seed_day1.sql  →  Supabase
Agent C  →  Next.js dashboard (frontend_contract/queries.ts)
```

---

## Source files (Agent A)

Agent A’s pipeline (`scripts/generate_day1_real_satellite_data.py`) produces:

| File | Contents |
|------|----------|
| `data/demo/blocks.geojson` | 48 block polygons + metadata (`block_id`, `estate_id`, `area_ha`, …) |
| `data/demo/block_indicators_latest.json` | NDVI, NDMI, rainfall, hotspot fields per block |
| `data/demo/risk_scores_latest.json` | Stress components + `risk_score` + `risk_category` |
| `data/demo/scouting_priority_latest.json` | `priority_rank`, `task_status`, recommended actions |

Agent B converts these into SQL with:

```bash
python scripts/build_seed_day1_sql.py
```

Output: `supabase/seed_day1.sql`

---

## Table overview

| Table | Role |
|-------|------|
| `estates` | Demo estate row (`estate_demo_01`) |
| `blocks` | Block boundaries (`geometry`) and metadata; `id` = `block_id` from GeoJSON |
| `processing_runs` | One demo pipeline run linking indicators and risk rows |
| `block_indicators` | Satellite indicators (one row per block per run) |
| `risk_scores` | Risk components and category (one row per block per run) |
| `scouting_tasks` | Generated scouting queue (from view + Agent A scouting JSON) |
| `field_reports` | User-submitted field checks from the dashboard |

**Demo estate id:** `estate_demo_01`  
**Demo block ids:** `B-001` … `B-048` (48 blocks)

Key JSON-aligned columns:

- **block_indicators:** `observation_date`, `ndvi`, `ndvi_baseline`, `ndvi_anomaly`, `ndmi`, `ndmi_baseline`, `ndmi_anomaly`, `rainfall_30d_mm`, `rainfall_baseline_mm`, `rainfall_deficit_pct`, `hotspot_count_7d`, `nearest_hotspot_km`, `quality_flag`
- **risk_scores:** `score_date`, `vegetation_stress`, `moisture_stress`, `rainfall_stress`, `fire_risk`, `risk_score`, `risk_category`, `dominant_driver`, `recommended_action`

Schema definition: `supabase/schema.sql`

---

## View overview (use these in the app)

### `latest_block_risk`

**Use for:** map layer, choropleth coloring, block popup, block detail page.

One row per block: geometry + latest indicators + latest risk.

| Column | Notes |
|--------|--------|
| `estate_id`, `block_id`, `block_code`, `block_name`, `area_ha` | Block identity |
| `geometry` | **GeoJSON** (`json`) — pass directly to map libraries |
| `observation_date`, NDVI/NDMI/rainfall/hotspot fields | From latest `block_indicators` |
| `score_date`, stress fields, `risk_score`, `risk_category`, `dominant_driver`, `recommended_action` | From latest `risk_scores` |

Filter in the app: `.eq("estate_id", "estate_demo_01")`

### `latest_scouting_priority`

**Use for:** priority table, “top risky blocks”, scouting list.

Sorted by `risk_score` descending. `priority_rank` = 1 is highest risk.

| Column | Notes |
|--------|--------|
| `priority_rank` | 1 … 48 |
| `estate_id`, `block_id` | Filters |
| `score_date`, `risk_score`, `risk_category`, `dominant_driver`, `recommended_action` | Match scouting JSON |
| `task_status` | `open` or `monitor_only` (from seeded `scouting_tasks`) |
| `risk_score_id` | Internal UUID; optional link to a task |

Filter in the app: `.eq("estate_id", "estate_demo_01")`

---

## Import steps (Supabase)

Prerequisites: Supabase project created; PostGIS available (enabled in `schema.sql`).

1. **Apply schema** — Supabase Dashboard → SQL Editor → run entire file:
   ```
   supabase/schema.sql
   ```

2. **Generate seed** (after any Agent A refresh of `data/demo/`):
   ```bash
   python scripts/build_seed_day1_sql.py
   ```

3. **Load data** — SQL Editor → run entire file:
   ```
   supabase/seed_day1.sql
   ```
   This deletes previous demo rows, then inserts estate, run, blocks, indicators, risk, and scouting tasks.

4. **Run validation queries** (below). Expect **48** blocks everywhere.

5. **Share with frontend:** project URL + anon key (see environment variables).

More detail: `supabase/import_day1_notes.md`

**Refresh after new satellite run:** repeat steps 2–4 only (schema usually unchanged).

---

## Validation SQL queries

Run in Supabase SQL Editor after import.

**Row counts**

```sql
select 'estates' as tbl, count(*) from estates
union all select 'blocks', count(*) from blocks
union all select 'block_indicators', count(*) from block_indicators
union all select 'risk_scores', count(*) from risk_scores
union all select 'scouting_tasks', count(*) from scouting_tasks;
```

Expected: `blocks` = 48; indicators, risk, scouting = 48; `estates` = 1.

**Estate filter**

```sql
select count(*) from latest_block_risk where estate_id = 'estate_demo_01';
-- expect 48
```

**Geometry present**

```sql
select block_id, geometry is not null as has_geometry
from latest_block_risk
where estate_id = 'estate_demo_01'
  and geometry is null;
-- expect 0 rows
```

**Top 5 risky blocks**

```sql
select priority_rank, block_id, risk_score, risk_category, task_status
from latest_scouting_priority
where estate_id = 'estate_demo_01'
order by priority_rank
limit 5;
```

**Risk category distribution**

```sql
select risk_category, count(*) 
from latest_block_risk 
where estate_id = 'estate_demo_01'
group by risk_category
order by count(*) desc;
```

**Single block detail**

```sql
select block_id, risk_score, risk_category, ndvi, ndmi, quality_flag
from latest_block_risk
where block_id = 'B-001';
```

---

## Frontend query contract

Copy or adapt from:

```
frontend_contract/queries.ts
```

Recommended Next.js layout (see `frontend_contract/note.txt`):

- `src/lib/supabaseClient.ts` — client setup
- `src/lib/queries.ts` — query functions below

| Function | Source | Purpose |
|----------|--------|---------|
| `getLatestBlockRisk(estateId)` | `latest_block_risk` | Map + estate overview |
| `getScoutingPriority(estateId)` | `latest_scouting_priority` | Priority / scouting table |
| `getBlockDetail(blockId)` | `latest_block_risk` | Block detail (`.single()`) |
| `submitFieldReport(payload)` | `field_reports` | Field verification form |

**Demo `estateId`:** `"estate_demo_01"`

**`submitFieldReport` payload fields:** `block_id` (required), `scouting_task_id`, `observer_name`, `gps_lat`, `gps_lng`, `stress_confirmed`, `stress_type`, `severity`, `soil_condition`, `drainage_condition`, `notes`, `photo_url`

> **Note:** RLS policies are not configured in Day 1 schema. If Supabase blocks reads/writes, Agent B must add grants/RLS before the dashboard works with the anon key.

---

## Environment variables

Frontend (`.env.local` in the Next.js app):

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
```

Get both from: Supabase Dashboard → Project Settings → API.

Agent A pipeline (repo root `.env`, separate from Supabase):

```env
GOOGLE_CLOUD_PROJECT=your-gcp-project-id
```

Do not commit keys. `.env` is gitignored.

---

## Known limitation: risk category distribution

Current demo data (after real satellite processing) is **heavily skewed**:

| `risk_category` | Blocks (typical) |
|-----------------|------------------|
| Normal | 47 |
| Watch | 1 |
| Warning / Priority Inspection | 0 |

Matching scouting tasks:

| `task_status` | Count (typical) |
|---------------|-----------------|
| `monitor_only` | 47 |
| `open` | 1 |

**What this means for the UI**

- Category badges and filters will look almost flat; most blocks appear “Normal”.
- Only one block (currently **B-041**, rank 1) stands out as `Watch` / `open`.
- Sorting by `risk_score` still works; use the numeric score for map color scales, not only category labels.
- Do not treat Day 1 categories as calibrated agronomic thresholds—they are a prototype prioritization signal.

If the pipeline is re-run, counts may change slightly, but skew is expected until scoring thresholds are tuned.

---

## Quick reference

| Item | Value |
|------|--------|
| Demo estate | `estate_demo_01` |
| Block count | 48 |
| Schema | `supabase/schema.sql` |
| Seed | `supabase/seed_day1.sql` |
| Query contract | `frontend_contract/queries.ts` |
