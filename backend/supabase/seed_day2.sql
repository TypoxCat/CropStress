-- Auto-generated Day 2 seed file.
-- Source: D:\Coding\CropStress\geospatial\data\demo
-- Regenerate: python backend/scripts/build_seed_day2_sql.py

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
  'Day 2 demo import from Agent A outputs'
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
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-05', 0.7482, 0.7436, 0.0046, 0.1952, 0.2316, -0.0363, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-05', 0.8127, 0.7664, 0.0464, 0.2462, 0.2511, -0.0049, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-05', 0.8249, 0.8126, 0.0123, 0.2685, 0.3059, -0.0375, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-05', 0.7973, 0.7696, 0.0276, 0.2365, 0.25, -0.0134, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-05', 0.7837, 0.7471, 0.0365, 0.2378, 0.2513, -0.0135, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-05', 0.7833, 0.75, 0.0333, 0.2645, 0.2675, -0.003, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-05', 0.8245, 0.7976, 0.0269, 0.2651, 0.2713, -0.0063, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-05', 0.8167, 0.7874, 0.0293, 0.2496, 0.2611, -0.0115, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-05', 0.7768, 0.7529, 0.024, 0.2127, 0.2449, -0.0321, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-05', 0.778, 0.7754, 0.0026, 0.2185, 0.2557, -0.0372, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-05', 0.8178, 0.7902, 0.0276, 0.2339, 0.2587, -0.0248, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-05', 0.8037, 0.7622, 0.0415, 0.2453, 0.2468, -0.0015, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-05', 0.7885, 0.7401, 0.0484, 0.2684, 0.2594, 0.009, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-05', 0.8093, 0.7629, 0.0465, 0.2563, 0.2671, -0.0108, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-05', 0.8189, 0.7815, 0.0374, 0.2349, 0.2575, -0.0226, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-05', 0.8326, 0.787, 0.0456, 0.2749, 0.2883, -0.0135, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-05', 0.835, 0.7861, 0.0489, 0.2902, 0.2919, -0.0018, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-05', 0.7558, 0.7601, -0.0043, 0.2116, 0.2267, -0.0151, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-05', 0.7463, 0.7521, -0.0058, 0.2229, 0.2316, -0.0087, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-05', 0.7651, 0.688, 0.0771, 0.244, 0.2334, 0.0106, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-05', 0.8159, 0.7845, 0.0315, 0.26, 0.2718, -0.0119, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-05', 0.8117, 0.7561, 0.0556, 0.2735, 0.2588, 0.0146, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-05', 0.7992, 0.7327, 0.0665, 0.2351, 0.2191, 0.0159, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-05', 0.7791, 0.7306, 0.0485, 0.2184, 0.2178, 0.0007, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-05', 0.7898, 0.7651, 0.0248, 0.2255, 0.237, -0.0116, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-05', 0.7231, 0.6802, 0.0429, 0.1811, 0.1788, 0.0023, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-05', 0.5373, 0.5087, 0.0286, 0.145, 0.1308, 0.0142, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-05', 0.7898, 0.7296, 0.0602, 0.2521, 0.2419, 0.0103, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-05', 0.6937, 0.6868, 0.0069, 0.2017, 0.2098, -0.0081, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-05', 0.7463, 0.7059, 0.0404, 0.2262, 0.2097, 0.0165, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-05', 0.8106, 0.7653, 0.0453, 0.2638, 0.2605, 0.0033, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-05', 0.7869, 0.7404, 0.0465, 0.2587, 0.2451, 0.0136, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-05', 0.6986, 0.7057, -0.0071, 0.1722, 0.232, -0.0597, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-05', 0.5767, 0.5527, 0.024, 0.1551, 0.1528, 0.0023, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-05', 0.4505, 0.4095, 0.041, 0.1431, 0.1276, 0.0155, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-05', 0.651, 0.5984, 0.0527, 0.167, 0.1555, 0.0115, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-05', 0.8105, 0.7629, 0.0476, 0.2672, 0.2563, 0.0109, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-05', 0.8373, 0.8039, 0.0334, 0.3052, 0.2992, 0.006, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-05', 0.8157, 0.7676, 0.0481, 0.2585, 0.2574, 0.0012, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-05', 0.8217, 0.7774, 0.0443, 0.2682, 0.2533, 0.0149, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-05', 0.5593, 0.6089, -0.0495, 0.1065, 0.1674, -0.0609, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-05', 0.6439, 0.597, 0.0468, 0.1515, 0.1693, -0.0178, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-05', 0.5598, 0.5413, 0.0185, 0.1591, 0.1645, -0.0054, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-05', 0.7319, 0.6912, 0.0407, 0.2017, 0.2042, -0.0025, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-05', 0.7948, 0.7641, 0.0308, 0.2663, 0.2504, 0.016, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-05', 0.8156, 0.7876, 0.028, 0.256, 0.2619, -0.0059, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-05', 0.8114, 0.7761, 0.0353, 0.2412, 0.2536, -0.0124, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-05', 0.8062, 0.7761, 0.0301, 0.2206, 0.234, -0.0134, 315.51, 492.38, 35.92, 0, null, 'real_satellite_valid');

insert into risk_scores (
  processing_run_id, block_id, score_date, vegetation_stress, moisture_stress, rainfall_stress, fire_risk, risk_score, risk_category, dominant_driver, recommended_action
)
values
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-05', 0.0, 0.165, 0.5987, 0.0, 0.1992, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-05', 0.0, 0.0223, 0.5987, 0.0, 0.1563, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-05', 0.0, 0.1705, 0.5987, 0.0, 0.2008, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-05', 0.0, 0.0609, 0.5987, 0.0, 0.1679, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-05', 0.0, 0.0614, 0.5987, 0.0, 0.1681, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-05', 0.0, 0.0136, 0.5987, 0.0, 0.1538, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-05', 0.0, 0.0286, 0.5987, 0.0, 0.1583, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-05', 0.0, 0.0523, 0.5987, 0.0, 0.1653, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-05', 0.0, 0.1459, 0.5987, 0.0, 0.1934, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-05', 0.0, 0.1691, 0.5987, 0.0, 0.2004, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-05', 0.0, 0.1127, 0.5987, 0.0, 0.1835, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-05', 0.0, 0.0068, 0.5987, 0.0, 0.1517, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-05', 0.0, 0.0491, 0.5987, 0.0, 0.1644, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-05', 0.0, 0.1027, 0.5987, 0.0, 0.1805, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-05', 0.0, 0.0614, 0.5987, 0.0, 0.1681, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-05', 0.0, 0.0082, 0.5987, 0.0, 0.1521, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-05', 0.0239, 0.0686, 0.5987, 0.0, 0.1774, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-05', 0.0322, 0.0395, 0.5987, 0.0, 0.1712, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-05', 0.0, 0.0541, 0.5987, 0.0, 0.1659, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-05', 0.0, 0.0527, 0.5987, 0.0, 0.1655, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-05', 0.0, 0.0368, 0.5987, 0.0, 0.1607, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-05', 0.0394, 0.2714, 0.5987, 0.0, 0.2429, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-05', 0.275, 0.2768, 0.5987, 0.0, 0.3152, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-05', 0.0, 0.0809, 0.5987, 0.0, 0.1739, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-05', 0.0, 0.0245, 0.5987, 0.0, 0.157, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-05', 0.0, 0.0114, 0.5987, 0.0, 0.1531, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-05', 0.0, 0.0, 0.5987, 0.0, 0.1497, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-05', 0.0, 0.0268, 0.5987, 0.0, 0.1577, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-05', 0.0, 0.0564, 0.5987, 0.0, 0.1666, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-05', 0.0, 0.0609, 0.5987, 0.0, 0.1679, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action');

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
  rs.block_id,
  rs.id,
  sp.priority_rank,
  sp.task_status,
  rs.recommended_action,
  rs.score_date + interval '1 day'
from risk_scores rs
join (
  values
  ('B-041', 1, 'open'),
  ('B-033', 2, 'monitor_only'),
  ('B-003', 3, 'monitor_only'),
  ('B-010', 4, 'monitor_only'),
  ('B-001', 5, 'monitor_only'),
  ('B-009', 6, 'monitor_only'),
  ('B-011', 7, 'monitor_only'),
  ('B-015', 8, 'monitor_only'),
  ('B-018', 9, 'monitor_only'),
  ('B-042', 10, 'monitor_only'),
  ('B-019', 11, 'monitor_only'),
  ('B-005', 12, 'monitor_only'),
  ('B-016', 13, 'monitor_only'),
  ('B-004', 14, 'monitor_only'),
  ('B-048', 15, 'monitor_only'),
  ('B-047', 16, 'monitor_only'),
  ('B-021', 17, 'monitor_only'),
  ('B-025', 18, 'monitor_only'),
  ('B-008', 19, 'monitor_only'),
  ('B-014', 20, 'monitor_only'),
  ('B-029', 21, 'monitor_only'),
  ('B-007', 22, 'monitor_only'),
  ('B-046', 23, 'monitor_only'),
  ('B-043', 24, 'monitor_only'),
  ('B-002', 25, 'monitor_only'),
  ('B-006', 26, 'monitor_only'),
  ('B-044', 27, 'monitor_only'),
  ('B-017', 28, 'monitor_only'),
  ('B-012', 29, 'monitor_only'),
  ('B-013', 30, 'monitor_only'),
  ('B-020', 31, 'monitor_only'),
  ('B-022', 32, 'monitor_only'),
  ('B-023', 33, 'monitor_only'),
  ('B-024', 34, 'monitor_only'),
  ('B-026', 35, 'monitor_only'),
  ('B-027', 36, 'monitor_only'),
  ('B-028', 37, 'monitor_only'),
  ('B-030', 38, 'monitor_only'),
  ('B-031', 39, 'monitor_only'),
  ('B-032', 40, 'monitor_only'),
  ('B-034', 41, 'monitor_only'),
  ('B-035', 42, 'monitor_only'),
  ('B-036', 43, 'monitor_only'),
  ('B-037', 44, 'monitor_only'),
  ('B-038', 45, 'monitor_only'),
  ('B-039', 46, 'monitor_only'),
  ('B-040', 47, 'monitor_only'),
  ('B-045', 48, 'monitor_only')
) as sp (block_id, priority_rank, task_status)
  on sp.block_id = rs.block_id
where rs.processing_run_id = '00000000-0000-0000-0000-000000000002'
order by sp.priority_rank;

commit;
