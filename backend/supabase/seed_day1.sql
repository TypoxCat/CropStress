-- Auto-generated Day 1 seed file.
-- Generated from data/demo/*.json and blocks.geojson
-- Regenerate: python scripts/build_seed_day1_sql.py

begin;

-- Remove previous demo data (child tables first)
delete from field_reports;
delete from scouting_tasks;
delete from risk_scores;
delete from block_indicators;
delete from processing_runs;
delete from blocks;
delete from estates;

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
  '00000000-0000-0000-0000-000000000001',
  '2026-05-30',
  'completed',
  '2026-05-30',
  '2026-05-30',
  'Day 1 demo import from Agent A outputs'
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
  ('00000000-0000-0000-0000-000000000001', 'B-001', '2026-05-30', 0.7482, 0.6765, 0.0717, 0.1952, 0.2239, -0.0286, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-002', '2026-05-30', 0.8127, 0.6902, 0.1225, 0.2462, 0.2277, 0.0184, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-003', '2026-05-30', 0.8249, 0.7377, 0.0872, 0.2685, 0.2814, -0.0129, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-004', '2026-05-30', 0.7973, 0.6858, 0.1115, 0.2365, 0.2299, 0.0066, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-005', '2026-05-30', 0.7837, 0.6785, 0.1052, 0.2378, 0.2352, 0.0026, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-006', '2026-05-30', 0.7833, 0.7077, 0.0755, 0.2645, 0.2429, 0.0215, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-007', '2026-05-30', 0.8245, 0.7317, 0.0928, 0.2651, 0.2553, 0.0098, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-008', '2026-05-30', 0.8167, 0.7438, 0.073, 0.2496, 0.2491, 0.0005, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-009', '2026-05-30', 0.7768, 0.6984, 0.0784, 0.2127, 0.2409, -0.0282, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-010', '2026-05-30', 0.778, 0.7322, 0.0458, 0.2185, 0.2465, -0.028, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-011', '2026-05-30', 0.8178, 0.7072, 0.1105, 0.2339, 0.2459, -0.0119, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-012', '2026-05-30', 0.8037, 0.6921, 0.1116, 0.2453, 0.2327, 0.0127, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-013', '2026-05-30', 0.7885, 0.6591, 0.1294, 0.2684, 0.2479, 0.0204, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-014', '2026-05-30', 0.8093, 0.6956, 0.1138, 0.2563, 0.2359, 0.0204, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-015', '2026-05-30', 0.8189, 0.7295, 0.0894, 0.2349, 0.2327, 0.0022, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-016', '2026-05-30', 0.8326, 0.7161, 0.1165, 0.2749, 0.2636, 0.0113, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-017', '2026-05-30', 0.835, 0.7504, 0.0846, 0.2902, 0.2775, 0.0127, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-018', '2026-05-30', 0.7558, 0.6571, 0.0987, 0.2116, 0.2064, 0.0052, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-019', '2026-05-30', 0.7463, 0.6396, 0.1067, 0.2229, 0.2068, 0.0162, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-020', '2026-05-30', 0.7651, 0.6306, 0.1345, 0.244, 0.2179, 0.0261, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-021', '2026-05-30', 0.8159, 0.6884, 0.1275, 0.26, 0.2516, 0.0084, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-022', '2026-05-30', 0.8117, 0.6792, 0.1326, 0.2735, 0.2343, 0.0391, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-023', '2026-05-30', 0.7992, 0.6821, 0.1171, 0.2351, 0.2056, 0.0295, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-024', '2026-05-30', 0.7791, 0.6662, 0.1129, 0.2184, 0.2151, 0.0033, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-025', '2026-05-30', 0.7898, 0.7283, 0.0615, 0.2255, 0.2377, -0.0122, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-026', '2026-05-30', 0.7231, 0.6209, 0.1021, 0.1811, 0.1691, 0.012, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-027', '2026-05-30', 0.5373, 0.4414, 0.0959, 0.145, 0.1187, 0.0264, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-028', '2026-05-30', 0.7898, 0.6468, 0.143, 0.2521, 0.2204, 0.0318, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-029', '2026-05-30', 0.6937, 0.5788, 0.115, 0.2017, 0.1939, 0.0078, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-030', '2026-05-30', 0.7463, 0.6144, 0.1319, 0.2262, 0.1993, 0.0269, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-031', '2026-05-30', 0.8106, 0.7053, 0.1053, 0.2638, 0.2356, 0.0282, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-032', '2026-05-30', 0.7869, 0.6639, 0.123, 0.2587, 0.2284, 0.0303, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-033', '2026-05-30', 0.6986, 0.6789, 0.0197, 0.1722, 0.2242, -0.0519, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-034', '2026-05-30', 0.5767, 0.535, 0.0417, 0.1551, 0.152, 0.0031, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-035', '2026-05-30', 0.4505, 0.3744, 0.0761, 0.1431, 0.1289, 0.0143, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-036', '2026-05-30', 0.651, 0.5219, 0.1291, 0.167, 0.1481, 0.0189, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-037', '2026-05-30', 0.8105, 0.6944, 0.1161, 0.2672, 0.2407, 0.0266, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-038', '2026-05-30', 0.8373, 0.748, 0.0894, 0.3052, 0.2779, 0.0273, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-039', '2026-05-30', 0.8157, 0.7335, 0.0822, 0.2585, 0.244, 0.0145, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-040', '2026-05-30', 0.8217, 0.7141, 0.1076, 0.2682, 0.24, 0.0282, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-041', '2026-05-30', 0.5593, 0.5842, -0.0249, 0.1065, 0.1691, -0.0626, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-042', '2026-05-30', 0.6439, 0.6017, 0.0421, 0.1515, 0.1783, -0.0268, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-043', '2026-05-30', 0.5598, 0.5203, 0.0395, 0.1591, 0.1605, -0.0014, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-044', '2026-05-30', 0.7319, 0.6666, 0.0653, 0.2017, 0.2017, 0.0001, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-045', '2026-05-30', 0.7948, 0.7423, 0.0525, 0.2663, 0.2467, 0.0196, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-046', '2026-05-30', 0.8156, 0.7492, 0.0664, 0.256, 0.2548, 0.0012, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-047', '2026-05-30', 0.8114, 0.7427, 0.0687, 0.2412, 0.2489, -0.0077, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000001', 'B-048', '2026-05-30', 0.8062, 0.6951, 0.1112, 0.2206, 0.2141, 0.0064, 379.96, 556.68, 31.75, 0, null, 'real_satellite_valid');

insert into risk_scores (
  processing_run_id, block_id, score_date, vegetation_stress, moisture_stress, rainfall_stress, fire_risk, risk_score, risk_category, dominant_driver, recommended_action
)
values
  ('00000000-0000-0000-0000-000000000001', 'B-001', '2026-05-30', 0.0, 0.13, 0.5292, 0.0, 0.1713, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-002', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-003', '2026-05-30', 0.0, 0.0586, 0.5292, 0.0, 0.1499, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-004', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-005', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-006', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-007', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-008', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-009', '2026-05-30', 0.0, 0.1282, 0.5292, 0.0, 0.1707, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-010', '2026-05-30', 0.0, 0.1273, 0.5292, 0.0, 0.1705, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-011', '2026-05-30', 0.0, 0.0541, 0.5292, 0.0, 0.1485, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-012', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-013', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-014', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-015', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-016', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-017', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-018', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-019', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-020', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-021', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-022', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-023', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-024', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-025', '2026-05-30', 0.0, 0.0555, 0.5292, 0.0, 0.1489, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-026', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-027', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-028', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-029', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-030', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-031', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-032', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-033', '2026-05-30', 0.0, 0.2359, 0.5292, 0.0, 0.2031, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-034', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-035', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-036', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-037', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-038', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-039', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-040', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-041', '2026-05-30', 0.1383, 0.2845, 0.5292, 0.0, 0.2592, 'Watch', 'NDMI drop + rainfall deficit', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000001', 'B-042', '2026-05-30', 0.0, 0.1218, 0.5292, 0.0, 0.1688, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-043', '2026-05-30', 0.0, 0.0064, 0.5292, 0.0, 0.1342, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-044', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-045', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-046', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-047', '2026-05-30', 0.0, 0.035, 0.5292, 0.0, 0.1428, 'Normal', 'NDMI drop + rainfall deficit', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000001', 'B-048', '2026-05-30', 0.0, 0.0, 0.5292, 0.0, 0.1323, 'Normal', 'Rainfall deficit', 'No urgent action');

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
  ('B-033', 2, 'monitor_only'),
  ('B-001', 3, 'monitor_only'),
  ('B-009', 4, 'monitor_only'),
  ('B-010', 5, 'monitor_only'),
  ('B-042', 6, 'monitor_only'),
  ('B-003', 7, 'monitor_only'),
  ('B-025', 8, 'monitor_only'),
  ('B-011', 9, 'monitor_only'),
  ('B-047', 10, 'monitor_only'),
  ('B-043', 11, 'monitor_only'),
  ('B-002', 12, 'monitor_only'),
  ('B-004', 13, 'monitor_only'),
  ('B-005', 14, 'monitor_only'),
  ('B-006', 15, 'monitor_only'),
  ('B-007', 16, 'monitor_only'),
  ('B-008', 17, 'monitor_only'),
  ('B-012', 18, 'monitor_only'),
  ('B-013', 19, 'monitor_only'),
  ('B-014', 20, 'monitor_only'),
  ('B-015', 21, 'monitor_only'),
  ('B-016', 22, 'monitor_only'),
  ('B-017', 23, 'monitor_only'),
  ('B-018', 24, 'monitor_only'),
  ('B-019', 25, 'monitor_only'),
  ('B-020', 26, 'monitor_only'),
  ('B-021', 27, 'monitor_only'),
  ('B-022', 28, 'monitor_only'),
  ('B-023', 29, 'monitor_only'),
  ('B-024', 30, 'monitor_only'),
  ('B-026', 31, 'monitor_only'),
  ('B-027', 32, 'monitor_only'),
  ('B-028', 33, 'monitor_only'),
  ('B-029', 34, 'monitor_only'),
  ('B-030', 35, 'monitor_only'),
  ('B-031', 36, 'monitor_only'),
  ('B-032', 37, 'monitor_only'),
  ('B-034', 38, 'monitor_only'),
  ('B-035', 39, 'monitor_only'),
  ('B-036', 40, 'monitor_only'),
  ('B-037', 41, 'monitor_only'),
  ('B-038', 42, 'monitor_only'),
  ('B-039', 43, 'monitor_only'),
  ('B-040', 44, 'monitor_only'),
  ('B-044', 45, 'monitor_only'),
  ('B-045', 46, 'monitor_only'),
  ('B-046', 47, 'monitor_only'),
  ('B-048', 48, 'monitor_only')
) as sp (block_id, priority_rank, task_status)
  on sp.block_id = lsp.block_id
order by sp.priority_rank;

commit;
