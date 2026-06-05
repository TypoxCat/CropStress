-- Auto-generated Day 2 seed file.
-- Source: /home/fazli/Desktop/lomba/aerospace/CropStress/geospatial/data/demo
-- Regenerate: python backend/scripts/build_seed_day2_sql.py
-- Note: risk and indicator values were patched in memory for Day 2 demo distribution.

begin;

-- Remove previous Day 2 run rows. Field reports are preserved.
delete from scouting_tasks where risk_score_id in (select id from risk_scores where processing_run_id = '00000000-0000-0000-0000-000000000002');
delete from risk_scores where processing_run_id = '00000000-0000-0000-0000-000000000002';
delete from block_indicators where processing_run_id = '00000000-0000-0000-0000-000000000002';
delete from processing_runs where id = '00000000-0000-0000-0000-000000000002';

insert into estates (id, name, province, district)
values ('estate_demo_01', 'Demo Estate', 'Unknown', 'Unknown')
on conflict (id) do update set
  name = excluded.name;

insert into processing_runs (
  id,
  run_date,
  status,
  source_window_start,
  source_window_end,
  notes
)
values (
  '00000000-0000-0000-0000-000000000002',
  '2026-06-05',
  'completed',
  '2026-06-05',
  '2026-06-05',
  'Day 2 demo import with deterministic scenario patch from Agent A outputs'
)
on conflict (id) do update set
  run_date = excluded.run_date,
  status = excluded.status,
  source_window_start = excluded.source_window_start,
  source_window_end = excluded.source_window_end,
  notes = excluded.notes;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-001',
  'estate_demo_01',
  'B-001',
  'Block B-001',
  195.57,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.360139,-0.53024],[101.372025,-0.53024],[101.372025,-0.516962],[101.360139,-0.516962],[101.360139,-0.53024]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-002',
  'estate_demo_01',
  'B-002',
  'Block B-002',
  192.32,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.372736,-0.529582],[101.385177,-0.529582],[101.385177,-0.517107],[101.372736,-0.517107],[101.372736,-0.529582]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-003',
  'estate_demo_01',
  'B-003',
  'Block B-003',
  204.64,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.384922,-0.5303],[101.39703,-0.5303],[101.39703,-0.516661],[101.384922,-0.516661],[101.384922,-0.5303]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-004',
  'estate_demo_01',
  'B-004',
  'Block B-004',
  207.6,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.397027,-0.52984],[101.409699,-0.52984],[101.409699,-0.516619],[101.397027,-0.516619],[101.397027,-0.52984]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-005',
  'estate_demo_01',
  'B-005',
  'Block B-005',
  198.97,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.40972,-0.52967],[101.422589,-0.52967],[101.422589,-0.517193],[101.40972,-0.517193],[101.40972,-0.52967]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-006',
  'estate_demo_01',
  'B-006',
  'Block B-006',
  201.71,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422806,-0.53017],[101.435198,-0.53017],[101.435198,-0.517034],[101.422806,-0.517034],[101.422806,-0.53017]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-007',
  'estate_demo_01',
  'B-007',
  'Block B-007',
  196.34,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.435457,-0.530434],[101.447337,-0.530434],[101.447337,-0.517097],[101.435457,-0.517097],[101.435457,-0.530434]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-008',
  'estate_demo_01',
  'B-008',
  'Block B-008',
  201.25,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.447847,-0.529672],[101.460104,-0.529672],[101.460104,-0.516422],[101.447847,-0.516422],[101.447847,-0.529672]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-009',
  'estate_demo_01',
  'B-009',
  'Block B-009',
  216.71,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.360036,-0.516796],[101.372973,-0.516796],[101.372973,-0.503278],[101.360036,-0.503278],[101.360036,-0.516796]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-010',
  'estate_demo_01',
  'B-010',
  'Block B-010',
  198.44,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.372829,-0.516281],[101.385119,-0.516281],[101.385119,-0.503251],[101.372829,-0.503251],[101.372829,-0.516281]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-011',
  'estate_demo_01',
  'B-011',
  'Block B-011',
  196.6,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.385205,-0.516957],[101.397046,-0.516957],[101.397046,-0.503558],[101.385205,-0.503558],[101.385205,-0.516957]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-012',
  'estate_demo_01',
  'B-012',
  'Block B-012',
  212.01,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.39708,-0.517092],[101.409733,-0.517092],[101.409733,-0.50357],[101.39708,-0.50357],[101.39708,-0.517092]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-013',
  'estate_demo_01',
  'B-013',
  'Block B-013',
  199.45,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.410136,-0.516805],[101.422365,-0.516805],[101.422365,-0.503643],[101.410136,-0.503643],[101.410136,-0.516805]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-014',
  'estate_demo_01',
  'B-014',
  'Block B-014',
  216.92,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422267,-0.516509],[101.435437,-0.516509],[101.435437,-0.503217],[101.422267,-0.503217],[101.422267,-0.516509]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-015',
  'estate_demo_01',
  'B-015',
  'Block B-015',
  219.48,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.434671,-0.517026],[101.447729,-0.517026],[101.447729,-0.503462],[101.434671,-0.503462],[101.434671,-0.517026]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-016',
  'estate_demo_01',
  'B-016',
  'Block B-016',
  202.8,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.44799,-0.516606],[101.46014,-0.516606],[101.46014,-0.503136],[101.44799,-0.503136],[101.44799,-0.516606]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-017',
  'estate_demo_01',
  'B-017',
  'Block B-017',
  202.18,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.360343,-0.503622],[101.372776,-0.503622],[101.372776,-0.490499],[101.360343,-0.490499],[101.360343,-0.503622]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-018',
  'estate_demo_01',
  'B-018',
  'Block B-018',
  217.8,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.372315,-0.503642],[101.384768,-0.503642],[101.384768,-0.489528],[101.372315,-0.489528],[101.372315,-0.503642]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-019',
  'estate_demo_01',
  'B-019',
  'Block B-019',
  193.17,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.385376,-0.503168],[101.397315,-0.503168],[101.397315,-0.490111],[101.385376,-0.490111],[101.385376,-0.503168]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-020',
  'estate_demo_01',
  'B-020',
  'Block B-020',
  198.71,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.397915,-0.503584],[101.409959,-0.503584],[101.409959,-0.49027],[101.397915,-0.49027],[101.397915,-0.503584]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-021',
  'estate_demo_01',
  'B-021',
  'Block B-021',
  206.65,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.410061,-0.503243],[101.422263,-0.503243],[101.422263,-0.489576],[101.410061,-0.489576],[101.410061,-0.503243]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-022',
  'estate_demo_01',
  'B-022',
  'Block B-022',
  195.61,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422399,-0.502803],[101.434719,-0.502803],[101.434719,-0.48999],[101.422399,-0.48999],[101.422399,-0.502803]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-023',
  'estate_demo_01',
  'B-023',
  'Block B-023',
  214.33,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.434591,-0.50375],[101.447047,-0.50375],[101.447047,-0.489864],[101.434591,-0.489864],[101.434591,-0.50375]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-024',
  'estate_demo_01',
  'B-024',
  'Block B-024',
  205.52,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.447792,-0.503799],[101.459922,-0.503799],[101.459922,-0.490126],[101.447792,-0.490126],[101.447792,-0.503799]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-025',
  'estate_demo_01',
  'B-025',
  'Block B-025',
  197.06,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.360496,-0.489498],[101.372529,-0.489498],[101.372529,-0.476282],[101.360496,-0.476282],[101.360496,-0.489498]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-026',
  'estate_demo_01',
  'B-026',
  'Block B-026',
  215.73,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.372011,-0.489806],[101.385221,-0.489806],[101.385221,-0.476627],[101.372011,-0.476627],[101.372011,-0.489806]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-027',
  'estate_demo_01',
  'B-027',
  'Block B-027',
  218.21,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.384767,-0.490414],[101.397641,-0.490414],[101.397641,-0.476736],[101.384767,-0.476736],[101.384767,-0.490414]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-028',
  'estate_demo_01',
  'B-028',
  'Block B-028',
  204.26,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.397454,-0.489599],[101.410454,-0.489599],[101.410454,-0.476919],[101.397454,-0.476919],[101.397454,-0.489599]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-029',
  'estate_demo_01',
  'B-029',
  'Block B-029',
  200.54,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.410001,-0.48956],[101.422179,-0.48956],[101.422179,-0.476271],[101.410001,-0.476271],[101.410001,-0.48956]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-030',
  'estate_demo_01',
  'B-030',
  'Block B-030',
  204.42,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422298,-0.489884],[101.435139,-0.489884],[101.435139,-0.477037],[101.422298,-0.477037],[101.422298,-0.489884]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-031',
  'estate_demo_01',
  'B-031',
  'Block B-031',
  198.81,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.435263,-0.489703],[101.447539,-0.489703],[101.447539,-0.476634],[101.435263,-0.476634],[101.435263,-0.489703]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-032',
  'estate_demo_01',
  'B-032',
  'Block B-032',
  227.29,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.447001,-0.490513],[101.459824,-0.490513],[101.459824,-0.476209],[101.447001,-0.476209],[101.447001,-0.490513]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-033',
  'estate_demo_01',
  'B-033',
  'Block B-033',
  201.64,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.360379,-0.476872],[101.372832,-0.476872],[101.372832,-0.463805],[101.360379,-0.463805],[101.360379,-0.476872]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-034',
  'estate_demo_01',
  'B-034',
  'Block B-034',
  214.33,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.372878,-0.477109],[101.385447,-0.477109],[101.385447,-0.463348],[101.372878,-0.463348],[101.372878,-0.477109]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-035',
  'estate_demo_01',
  'B-035',
  'Block B-035',
  206.84,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.384569,-0.476383],[101.397761,-0.476383],[101.397761,-0.46373],[101.384569,-0.46373],[101.384569,-0.476383]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-036',
  'estate_demo_01',
  'B-036',
  'Block B-036',
  217.86,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.397475,-0.476917],[101.41005,-0.476917],[101.41005,-0.462936],[101.397475,-0.462936],[101.397475,-0.476917]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-037',
  'estate_demo_01',
  'B-037',
  'Block B-037',
  206.14,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.409923,-0.476625],[101.422212,-0.476625],[101.422212,-0.463088],[101.409923,-0.463088],[101.409923,-0.476625]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-038',
  'estate_demo_01',
  'B-038',
  'Block B-038',
  202.62,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422201,-0.476139],[101.434812,-0.476139],[101.434812,-0.463173],[101.422201,-0.463173],[101.422201,-0.476139]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-039',
  'estate_demo_01',
  'B-039',
  'Block B-039',
  209.58,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.434938,-0.477071],[101.447518,-0.477071],[101.447518,-0.463627],[101.434938,-0.463627],[101.434938,-0.477071]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-040',
  'estate_demo_01',
  'B-040',
  'Block B-040',
  210.5,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.447338,-0.476955],[101.460088,-0.476955],[101.460088,-0.463632],[101.447338,-0.463632],[101.447338,-0.476955]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-041',
  'estate_demo_01',
  'B-041',
  'Block B-041',
  227.44,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.359571,-0.463622],[101.372631,-0.463622],[101.372631,-0.449568],[101.359571,-0.449568],[101.359571,-0.463622]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-042',
  'estate_demo_01',
  'B-042',
  'Block B-042',
  200.16,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.37286,-0.463613],[101.384571,-0.463613],[101.384571,-0.44982],[101.37286,-0.44982],[101.37286,-0.463613]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-043',
  'estate_demo_01',
  'B-043',
  'Block B-043',
  199.2,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.384714,-0.462869],[101.397132,-0.462869],[101.397132,-0.449924],[101.384714,-0.449924],[101.384714,-0.462869]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-044',
  'estate_demo_01',
  'B-044',
  'Block B-044',
  201.23,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.397473,-0.463005],[101.410285,-0.463005],[101.410285,-0.45033],[101.397473,-0.45033],[101.397473,-0.463005]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-045',
  'estate_demo_01',
  'B-045',
  'Block B-045',
  212.79,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.409597,-0.463415],[101.422431,-0.463415],[101.422431,-0.450035],[101.409597,-0.450035],[101.409597,-0.463415]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-046',
  'estate_demo_01',
  'B-046',
  'Block B-046',
  191.04,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.422729,-0.462817],[101.435173,-0.462817],[101.435173,-0.450428],[101.422729,-0.450428],[101.422729,-0.462817]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-047',
  'estate_demo_01',
  'B-047',
  'Block B-047',
  195.4,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.434903,-0.462948],[101.447339,-0.462948],[101.447339,-0.450268],[101.434903,-0.450268],[101.434903,-0.462948]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into blocks (
  id,
  estate_id,
  block_code,
  block_name,
  area_ha,
  geometry
)
values (
  'B-048',
  'estate_demo_01',
  'B-048',
  'Block B-048',
  208.4,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[101.44719,-0.463417],[101.459949,-0.463417],[101.459949,-0.450236],[101.44719,-0.450236],[101.44719,-0.463417]]]}'), 4326))
)
on conflict (id) do update set
  estate_id = excluded.estate_id,
  block_code = excluded.block_code,
  block_name = excluded.block_name,
  area_ha = excluded.area_ha,
  geometry = excluded.geometry;

insert into block_indicators (
  processing_run_id, block_id, observation_date, ndvi, ndvi_baseline, ndvi_anomaly, ndmi, ndmi_baseline, ndmi_anomaly, rainfall_30d_mm, rainfall_baseline_mm, rainfall_deficit_pct, hotspot_count_7d, nearest_hotspot_km, quality_flag
)
values
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-05', 0.6377, 0.7436, -0.1059, 0.1225, 0.2316, -0.1091, 132.49, 492.38, 73.09, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-05', 0.7264, 0.7664, -0.04, 0.2061, 0.2511, -0.045, 295.43, 492.38, 40.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-05', 0.7021, 0.8126, -0.1105, 0.1914, 0.3059, -0.1145, 125.33, 492.38, 74.55, 1, 2.67, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-05', 0.6982, 0.7696, -0.0714, 0.1736, 0.25, -0.0764, 204.11, 492.38, 58.55, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-05', 0.6721, 0.7471, -0.075, 0.1713, 0.2513, -0.08, 196.95, 492.38, 60.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-05', 0.7116, 0.75, -0.0384, 0.2243, 0.2675, -0.0432, 299.9, 492.38, 39.09, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-05', 0.739, 0.7976, -0.0586, 0.2077, 0.2713, -0.0636, 229.18, 492.38, 53.45, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-05', 0.7233, 0.7874, -0.0641, 0.192, 0.2611, -0.0691, 218.44, 492.38, 55.64, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-05', 0.6493, 0.7529, -0.1036, 0.1385, 0.2449, -0.1064, 136.08, 492.38, 72.36, 1, 3.38, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-05', 0.6672, 0.7754, -0.1082, 0.1439, 0.2557, -0.1118, 128.91, 492.38, 73.82, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-05', 0.6888, 0.7902, -0.1014, 0.1551, 0.2587, -0.1036, 139.66, 492.38, 71.64, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-05', 0.7287, 0.7622, -0.0335, 0.2091, 0.2468, -0.0377, 313.33, 492.38, 36.36, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-05', 0.7751, 0.7401, 0.035, 0.2644, 0.2594, 0.005, 452.99, 492.38, 8.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-05', 0.7006, 0.7629, -0.0623, 0.1998, 0.2671, -0.0673, 222.02, 492.38, 54.91, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-05', 0.6824, 0.7815, -0.0991, 0.1566, 0.2575, -0.1009, 143.24, 492.38, 70.91, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-05', 0.697, 0.787, -0.09, 0.1983, 0.2883, -0.09, 157.56, 492.38, 68.0, 1, 4.8, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-05', 0.751, 0.7861, -0.0351, 0.2524, 0.2919, -0.0395, 308.86, 492.38, 37.27, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-05', 0.6633, 0.7601, -0.0968, 0.1285, 0.2267, -0.0982, 146.82, 492.38, 70.18, 1, 4.09, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-05', 0.6598, 0.7521, -0.0923, 0.1389, 0.2316, -0.0927, 153.98, 492.38, 68.73, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-05', 0.7212, 0.688, 0.0332, 0.237, 0.2334, 0.0036, 448.51, 492.38, 8.91, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-05', 0.7168, 0.7845, -0.0677, 0.1991, 0.2718, -0.0727, 211.28, 492.38, 57.09, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-05', 0.7875, 0.7561, 0.0314, 0.2611, 0.2588, 0.0023, 444.04, 492.38, 9.82, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-05', 0.7622, 0.7327, 0.0295, 0.22, 0.2191, 0.0009, 439.56, 492.38, 10.73, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-05', 0.7583, 0.7306, 0.0277, 0.2173, 0.2178, -0.0005, 435.08, 492.38, 11.64, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-05', 0.6992, 0.7651, -0.0659, 0.1661, 0.237, -0.0709, 214.86, 492.38, 56.36, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-05', 0.7061, 0.6802, 0.0259, 0.177, 0.1788, -0.0018, 430.61, 492.38, 12.55, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-05', 0.5328, 0.5087, 0.0241, 0.1276, 0.1308, -0.0032, 426.13, 492.38, 13.45, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-05', 0.7519, 0.7296, 0.0223, 0.2374, 0.2419, -0.0045, 421.66, 492.38, 14.36, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-05', 0.6263, 0.6868, -0.0605, 0.1443, 0.2098, -0.0655, 225.6, 492.38, 54.18, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-05', 0.7264, 0.7059, 0.0205, 0.2038, 0.2097, -0.0059, 417.18, 492.38, 15.27, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-05', 0.7839, 0.7653, 0.0186, 0.2532, 0.2605, -0.0073, 412.7, 492.38, 16.18, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-05', 0.7572, 0.7404, 0.0168, 0.2365, 0.2451, -0.0086, 408.23, 492.38, 17.09, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-05', 0.593, 0.7057, -0.1127, 0.1147, 0.232, -0.1173, 121.75, 492.38, 75.27, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-05', 0.5677, 0.5527, 0.015, 0.1428, 0.1528, -0.01, 403.75, 492.38, 18.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-05', 0.3875, 0.4095, -0.022, 0.1026, 0.1276, -0.025, 344.67, 492.38, 30.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-05', 0.5748, 0.5984, -0.0236, 0.1287, 0.1555, -0.0268, 340.19, 492.38, 30.91, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-05', 0.7376, 0.7629, -0.0253, 0.2277, 0.2563, -0.0286, 335.71, 492.38, 31.82, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-05', 0.777, 0.8039, -0.0269, 0.2687, 0.2992, -0.0305, 331.24, 492.38, 32.73, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-05', 0.7391, 0.7676, -0.0285, 0.2251, 0.2574, -0.0323, 326.76, 492.38, 33.64, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-05', 0.7472, 0.7774, -0.0302, 0.2192, 0.2533, -0.0341, 322.29, 492.38, 34.55, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-05', 0.4939, 0.6089, -0.115, 0.0474, 0.1674, -0.12, 118.17, 492.38, 76.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-05', 0.5025, 0.597, -0.0945, 0.0738, 0.1693, -0.0955, 150.4, 492.38, 69.45, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-05', 0.4863, 0.5413, -0.055, 0.1045, 0.1645, -0.06, 236.34, 492.38, 52.0, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-05', 0.6545, 0.6912, -0.0367, 0.1628, 0.2042, -0.0414, 304.38, 492.38, 38.18, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-05', 0.7323, 0.7641, -0.0318, 0.2145, 0.2504, -0.0359, 317.81, 492.38, 35.45, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-05', 0.7308, 0.7876, -0.0568, 0.2001, 0.2619, -0.0618, 232.76, 492.38, 52.73, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-05', 0.7066, 0.7761, -0.0695, 0.1791, 0.2536, -0.0745, 207.69, 492.38, 57.82, 0, null, 'day2_demo_scenario_from_real_satellite'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-05', 0.7029, 0.7761, -0.0732, 0.1558, 0.234, -0.0782, 200.53, 492.38, 59.27, 0, null, 'day2_demo_scenario_from_real_satellite');

insert into risk_scores (
  processing_run_id, block_id, score_date, vegetation_stress, moisture_stress, rainfall_stress, fire_risk, risk_score, risk_category, dominant_driver, recommended_action
)
values
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-05', 0.5488, 0.9479, 0.898, 0.2494, 0.7109, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-05', 0.3396, 0.5867, 0.5558, 0.1544, 0.44, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-05', 0.5863, 0.6351, 0.8794, 0.9282, 0.7255, 'Priority Inspection', 'Rainfall deficit + hotspot proximity', 'Inspect today and prioritize fire patrol'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-05', 0.8339, 0.79, 0.395, 0.0878, 0.5991, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-05', 0.8769, 0.8308, 0.4154, 0.0923, 0.63, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-05', 0.8008, 0.3793, 0.2529, 0.0421, 0.4236, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-05', 0.3789, 0.6545, 0.6201, 0.1722, 0.4909, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-05', 0.7479, 0.7085, 0.3543, 0.0787, 0.5373, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-05', 0.5686, 0.6159, 0.8528, 0.9002, 0.7036, 'Priority Inspection', 'Rainfall deficit + hotspot proximity', 'Inspect today and prioritize fire patrol'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-05', 0.5544, 0.9576, 0.9072, 0.252, 0.7182, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-05', 0.5376, 0.9285, 0.8797, 0.2444, 0.6964, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-05', 0.2891, 0.4993, 0.4731, 0.1314, 0.3745, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-05', 0.0672, 0.0672, 0.0672, 0.0192, 0.06, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-05', 0.4028, 0.6957, 0.6591, 0.1831, 0.5218, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-05', 0.5319, 0.9188, 0.8704, 0.2418, 0.6891, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-05', 0.5333, 0.5778, 0.8, 0.8444, 0.66, 'Priority Inspection', 'Rainfall deficit + hotspot proximity', 'Inspect today and prioritize fire patrol'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-05', 0.739, 0.3501, 0.2334, 0.0389, 0.3909, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-05', 0.5509, 0.5969, 0.8264, 0.8723, 0.6818, 'Priority Inspection', 'Rainfall deficit + hotspot proximity', 'Inspect today and prioritize fire patrol'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-05', 0.5151, 0.8897, 0.8429, 0.2341, 0.6673, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-05', 0.0846, 0.0846, 0.0846, 0.0242, 0.0755, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-05', 0.7909, 0.7493, 0.3746, 0.0833, 0.5682, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-05', 0.1018, 0.1018, 0.1018, 0.0291, 0.0909, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-05', 0.1192, 0.1192, 0.1192, 0.034, 0.1064, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-05', 0.1364, 0.1364, 0.1364, 0.039, 0.1218, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-05', 0.4266, 0.7369, 0.6981, 0.1939, 0.5527, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-05', 0.1538, 0.1538, 0.1538, 0.0439, 0.1373, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-05', 0.171, 0.171, 0.171, 0.0489, 0.1527, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-05', 0.1884, 0.1884, 0.1884, 0.0538, 0.1682, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-05', 0.7049, 0.6678, 0.3339, 0.0742, 0.5064, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-05', 0.2056, 0.2056, 0.2056, 0.0588, 0.1836, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-05', 0.223, 0.223, 0.223, 0.0637, 0.1991, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-05', 0.2402, 0.2402, 0.2402, 0.0686, 0.2145, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-05', 0.5656, 0.9769, 0.9255, 0.2571, 0.7327, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-05', 0.2576, 0.2576, 0.2576, 0.0736, 0.23, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-05', 0.4915, 0.2328, 0.1552, 0.0259, 0.26, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-05', 0.2134, 0.3685, 0.3491, 0.097, 0.2764, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-05', 0.5534, 0.2621, 0.1747, 0.0291, 0.2927, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-05', 0.2386, 0.4121, 0.3904, 0.1085, 0.3091, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-05', 0.6154, 0.2915, 0.1943, 0.0324, 0.3255, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-05', 0.2638, 0.4557, 0.4317, 0.1199, 0.3418, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-05', 0.5712, 0.9867, 0.9347, 0.2596, 0.74, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-05', 0.5207, 0.8993, 0.852, 0.2367, 0.6745, 'Priority Inspection', 'NDMI drop + rainfall deficit', 'Inspect today for moisture stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-05', 0.3551, 0.6133, 0.5811, 0.1614, 0.46, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-05', 0.3144, 0.5431, 0.5145, 0.1429, 0.4073, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-05', 0.6772, 0.3208, 0.2139, 0.0356, 0.3582, 'Watch', 'NDVI decline', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-05', 0.6619, 0.627, 0.3135, 0.0697, 0.4755, 'Warning', 'NDVI decline + NDMI drop', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-05', 0.4505, 0.7781, 0.7372, 0.2048, 0.5836, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-05', 0.4744, 0.8193, 0.7762, 0.2156, 0.6145, 'Warning', 'NDMI drop + rainfall deficit', 'Inspect this week for water stress');

-- Replace scouting queue for the latest Day 2 risk snapshot.
delete from scouting_tasks;

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
  ('B-041', 1, 'open'),
  ('B-033', 2, 'open'),
  ('B-003', 3, 'open'),
  ('B-010', 4, 'open'),
  ('B-001', 5, 'open'),
  ('B-009', 6, 'open'),
  ('B-011', 7, 'open'),
  ('B-015', 8, 'open'),
  ('B-018', 9, 'open'),
  ('B-042', 10, 'open'),
  ('B-019', 11, 'open'),
  ('B-016', 12, 'open'),
  ('B-005', 13, 'open'),
  ('B-048', 14, 'open'),
  ('B-004', 15, 'open'),
  ('B-047', 16, 'open'),
  ('B-021', 17, 'open'),
  ('B-025', 18, 'open'),
  ('B-008', 19, 'open'),
  ('B-014', 20, 'open'),
  ('B-029', 21, 'open'),
  ('B-007', 22, 'open'),
  ('B-046', 23, 'open'),
  ('B-043', 24, 'open'),
  ('B-002', 25, 'open'),
  ('B-006', 26, 'open'),
  ('B-044', 27, 'open'),
  ('B-017', 28, 'open'),
  ('B-012', 29, 'open'),
  ('B-045', 30, 'open'),
  ('B-040', 31, 'open'),
  ('B-039', 32, 'open'),
  ('B-038', 33, 'open'),
  ('B-037', 34, 'open'),
  ('B-036', 35, 'open'),
  ('B-035', 36, 'open'),
  ('B-034', 37, 'monitor_only'),
  ('B-032', 38, 'monitor_only'),
  ('B-031', 39, 'monitor_only'),
  ('B-030', 40, 'monitor_only'),
  ('B-028', 41, 'monitor_only'),
  ('B-027', 42, 'monitor_only'),
  ('B-026', 43, 'monitor_only'),
  ('B-024', 44, 'monitor_only'),
  ('B-023', 45, 'monitor_only'),
  ('B-022', 46, 'monitor_only'),
  ('B-020', 47, 'monitor_only'),
  ('B-013', 48, 'monitor_only')
) as sp (block_id, priority_rank, task_status)
  on sp.block_id = lsp.block_id
order by sp.priority_rank;

commit;
