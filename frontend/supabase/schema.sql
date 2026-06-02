-- CropStress Insight Day 1 — PostgreSQL + PostGIS schema
-- Column names align with data/demo/*.json and blocks.geojson feature properties.

create extension if not exists postgis;
create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Views (drop first; depend on tables)
-- ---------------------------------------------------------------------------

drop view if exists latest_scouting_priority;
drop view if exists latest_block_risk;

-- ---------------------------------------------------------------------------
-- Core tables
-- ---------------------------------------------------------------------------

-- estates: seeded from blocks.geojson collection metadata (estate_id, estate_name)
create table if not exists estates (
  id text primary key, -- estate_id, e.g. estate_demo_01
  name text not null,
  province text,
  district text,
  geometry geometry(MultiPolygon, 4326),
  created_at timestamptz not null default now()
);

-- blocks: blocks.geojson feature properties + geometry
create table if not exists blocks (
  id text primary key, -- block_id, e.g. B-001
  estate_id text not null references estates (id) on delete cascade,
  block_code text not null,
  block_name text,
  area_ha numeric,
  geometry geometry(MultiPolygon, 4326),
  planting_year int,
  soil_type text,
  drainage_class text,
  created_at timestamptz not null default now()
);

-- processing_runs: pipeline run metadata (links indicators and risk_scores)
create table if not exists processing_runs (
  id uuid primary key default gen_random_uuid(),
  run_date date not null,
  status text not null,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  source_window_start date,
  source_window_end date,
  notes text
);

-- block_indicators: block_indicators_latest.json
create table if not exists block_indicators (
  id uuid primary key default gen_random_uuid(),
  processing_run_id uuid references processing_runs (id) on delete set null,
  block_id text not null references blocks (id) on delete cascade,
  observation_date date not null,
  ndvi numeric,
  ndvi_baseline numeric,
  ndvi_anomaly numeric,
  ndmi numeric,
  ndmi_baseline numeric,
  ndmi_anomaly numeric,
  rainfall_30d_mm numeric,
  rainfall_baseline_mm numeric,
  rainfall_deficit_pct numeric,
  hotspot_count_7d int,
  nearest_hotspot_km numeric,
  quality_flag text,
  created_at timestamptz not null default now()
);

-- risk_scores: risk_scores_latest.json
create table if not exists risk_scores (
  id uuid primary key default gen_random_uuid(),
  processing_run_id uuid references processing_runs (id) on delete set null,
  block_id text not null references blocks (id) on delete cascade,
  score_date date not null,
  vegetation_stress numeric,
  moisture_stress numeric,
  rainfall_stress numeric,
  fire_risk numeric,
  risk_score numeric,
  risk_category text,
  dominant_driver text,
  recommended_action text,
  created_at timestamptz not null default now()
);

-- scouting_tasks: derived from scouting_priority_latest.json (+ risk_score_id FK)
create table if not exists scouting_tasks (
  id uuid primary key default gen_random_uuid(),
  block_id text not null references blocks (id) on delete cascade,
  risk_score_id uuid references risk_scores (id) on delete set null,
  priority_rank int,
  task_status text not null default 'open',
  assigned_to text,
  recommended_action text,
  due_date date,
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

-- field_reports: frontend submitFieldReport payload
create table if not exists field_reports (
  id uuid primary key default gen_random_uuid(),
  scouting_task_id uuid references scouting_tasks (id) on delete set null,
  block_id text not null references blocks (id) on delete cascade,
  observer_name text,
  observed_at timestamptz not null default now(),
  gps_lat numeric,
  gps_lng numeric,
  stress_confirmed text,
  stress_type text,
  severity text,
  soil_condition text,
  drainage_condition text,
  notes text,
  photo_url text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------

create index if not exists idx_blocks_estate_id
  on blocks (estate_id);

create index if not exists idx_blocks_geometry
  on blocks using gist (geometry);

create index if not exists idx_block_indicators_block_observation
  on block_indicators (block_id, observation_date desc);

create index if not exists idx_risk_scores_block_score_date
  on risk_scores (block_id, score_date desc);

create index if not exists idx_risk_scores_score_date
  on risk_scores (score_date desc);

create index if not exists idx_scouting_tasks_block_id
  on scouting_tasks (block_id);

create index if not exists idx_scouting_tasks_risk_score_id
  on scouting_tasks (risk_score_id);

create index if not exists idx_field_reports_block_id
  on field_reports (block_id);

-- ---------------------------------------------------------------------------
-- Views
-- ---------------------------------------------------------------------------

-- Latest indicator + risk per block, with GeoJSON geometry for the map.
create or replace view latest_block_risk as
with latest_indicators as (
  select distinct on (block_id)
    block_id,
    observation_date,
    ndvi,
    ndvi_baseline,
    ndvi_anomaly,
    ndmi,
    ndmi_baseline,
    ndmi_anomaly,
    rainfall_30d_mm,
    rainfall_baseline_mm,
    rainfall_deficit_pct,
    hotspot_count_7d,
    nearest_hotspot_km,
    quality_flag
  from block_indicators
  order by block_id, observation_date desc, created_at desc
),
latest_risk as (
  select distinct on (block_id)
    id as risk_score_id,
    block_id,
    score_date,
    vegetation_stress,
    moisture_stress,
    rainfall_stress,
    fire_risk,
    risk_score,
    risk_category,
    dominant_driver,
    recommended_action
  from risk_scores
  order by block_id, score_date desc, created_at desc
)
select
  b.estate_id,
  b.id as block_id,
  b.block_code,
  b.block_name,
  b.area_ha,
  st_asgeojson(b.geometry)::json as geometry,

  bi.observation_date,
  bi.ndvi,
  bi.ndvi_baseline,
  bi.ndvi_anomaly,
  bi.ndmi,
  bi.ndmi_baseline,
  bi.ndmi_anomaly,
  bi.rainfall_30d_mm,
  bi.rainfall_baseline_mm,
  bi.rainfall_deficit_pct,
  bi.hotspot_count_7d,
  bi.nearest_hotspot_km,
  bi.quality_flag,

  rs.score_date,
  rs.vegetation_stress,
  rs.moisture_stress,
  rs.rainfall_stress,
  rs.fire_risk,
  rs.risk_score,
  rs.risk_category,
  rs.dominant_driver,
  rs.recommended_action
from blocks b
left join latest_indicators bi
  on bi.block_id = b.id
left join latest_risk rs
  on rs.block_id = b.id;

-- Scouting priority list; column names match scouting_priority_latest.json.
-- estate_id and risk_score_id are included for filtering and task linkage.
create or replace view latest_scouting_priority as
with latest_risk as (
  select distinct on (block_id)
    id,
    block_id,
    score_date,
    risk_score,
    risk_category,
    dominant_driver,
    recommended_action
  from risk_scores
  order by block_id, score_date desc, created_at desc
)
select
  row_number() over (
    order by rs.risk_score desc nulls last, rs.block_id
  )::int as priority_rank,
  b.estate_id,
  b.id as block_id,
  rs.score_date,
  rs.risk_score,
  rs.risk_category,
  rs.dominant_driver,
  rs.recommended_action,
  coalesce(st.task_status, 'monitor_only') as task_status,
  rs.id as risk_score_id
from latest_risk rs
join blocks b
  on b.id = rs.block_id
left join lateral (
  select st.task_status
  from scouting_tasks st
  where st.risk_score_id = rs.id
  order by st.created_at desc
  limit 1
) st on true
order by rs.risk_score desc nulls last, rs.block_id;
