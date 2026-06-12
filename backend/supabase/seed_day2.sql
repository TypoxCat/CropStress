-- Auto-generated Day 2 seed file.
-- Source: /home/fazli/Desktop/lomba/aerospace/CropStress/geospatial/data/demo
-- Regenerate: python backend/scripts/build_seed_day2_sql.py

begin;

-- Remove previous Day 2 run rows. Field reports are preserved.
delete from scouting_tasks where risk_score_id in (select id from risk_scores where processing_run_id = '00000000-0000-0000-0000-000000000002');
delete from risk_scores where processing_run_id = '00000000-0000-0000-0000-000000000002';
delete from block_indicators where processing_run_id = '00000000-0000-0000-0000-000000000002';
delete from processing_runs where id = '00000000-0000-0000-0000-000000000002';

insert into estates (id, name, province, district)
values ('estate_demo_01', 'Real Oil Palm Estate', 'Unknown', 'Unknown')
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
  '2026-06-12',
  'completed',
  '2026-06-12',
  '2026-06-12',
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.498801,-0.597065],[102.507428,-0.597089],[102.507435,-0.598853],[102.4988,-0.598838],[102.498801,-0.597065]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.507567,-0.597054],[102.515466,-0.597081],[102.515479,-0.598867],[102.507567,-0.59884],[102.507567,-0.597054]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.515592,-0.597078],[102.524914,-0.597155],[102.524948,-0.598839],[102.515549,-0.598848],[102.515592,-0.597078]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52486801,-0.59734454],[102.53495588,-0.59734454],[102.53495588,-0.59866166],[102.52486801,-0.59866166],[102.52486801,-0.59734454]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53527397,-0.59716287],[102.54381686,-0.59716287],[102.54381686,-0.59875249],[102.53527397,-0.59875249],[102.53527397,-0.59716287]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.544189,-0.597118],[102.551752,-0.596971],[102.551853,-0.598854],[102.544143,-0.599024],[102.544189,-0.597118]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.551838,-0.596855],[102.560817,-0.597101],[102.560852,-0.59896],[102.551906,-0.598865],[102.551838,-0.596855]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49869405,-0.59907042],[102.50760047,-0.59907042],[102.50760047,-0.60084172],[102.49869405,-0.60084172],[102.49869405,-0.59907042]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50773679,-0.59907042],[102.51532542,-0.59907042],[102.51532542,-0.60070546],[102.50773679,-0.60070546],[102.50773679,-0.59907042]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51564351,-0.59907042],[102.52473168,-0.59907042],[102.52473168,-0.60056921],[102.51564351,-0.60056921],[102.51564351,-0.59907042]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52504977,-0.59907042],[102.53491044,-0.59907042],[102.53491044,-0.60047837],[102.52504977,-0.60047837],[102.52504977,-0.59907042]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53527397,-0.59916125],[102.54381686,-0.59916125],[102.54381686,-0.60043295],[102.53527397,-0.60043295],[102.53527397,-0.59916125]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.544187,-0.599084],[102.551835,-0.59894],[102.551902,-0.601201],[102.544139,-0.601316],[102.544187,-0.599084]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55191,-0.598921],[102.560905,-0.599007],[102.560876,-0.601056],[102.551987,-0.601201],[102.55191,-0.598921]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49883038,-0.60179549],[102.50732782,-0.60179549],[102.50732782,-0.60324886],[102.49883038,-0.60324886],[102.49883038,-0.60179549]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50773679,-0.60115964],[102.51532542,-0.60115964],[102.51532542,-0.60324886],[102.50773679,-0.60324886],[102.50773679,-0.60115964]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51568895,-0.60102339],[102.52477713,-0.60102339],[102.52477713,-0.60320345],[102.51568895,-0.60320345],[102.51568895,-0.60102339]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52509521,-0.60070546],[102.53504677,-0.60070546],[102.53504677,-0.60370304],[102.52509521,-0.60370304],[102.52509521,-0.60070546]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53522853,-0.6007963],[102.54404406,-0.6007963],[102.54404406,-0.6038393],[102.53522853,-0.6038393],[102.53522853,-0.6007963]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.544136,-0.601394],[102.551937,-0.601278],[102.552034,-0.603424],[102.544,-0.603627],[102.544136,-0.601394]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55213254,-0.60134131],[102.56090263,-0.60134131],[102.56090263,-0.6033397],[102.55213254,-0.6033397],[102.55213254,-0.60134131]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49883038,-0.60365763],[102.50760047,-0.60365763],[102.50760047,-0.6056106],[102.49883038,-0.6056106],[102.49883038,-0.60365763]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50773679,-0.60365763],[102.5154163,-0.60365763],[102.5154163,-0.6058831],[102.50773679,-0.6058831],[102.50773679,-0.60365763]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51577983,-0.6038393],[102.52482257,-0.6038393],[102.52482257,-0.60615561],[102.51577983,-0.60615561],[102.51577983,-0.6038393]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52514065,-0.60406639],[102.53491044,-0.60406639],[102.53491044,-0.60660979],[102.52514065,-0.60660979],[102.52514065,-0.60406639]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53522853,-0.60424806],[102.54345333,-0.60424806],[102.54345333,-0.60701855],[102.53522853,-0.60701855],[102.53522853,-0.60424806]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54399862,-0.60379388],[102.5518599,-0.60379388],[102.5518599,-0.60565601],[102.54399862,-0.60565601],[102.54399862,-0.60379388]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55222342,-0.60365763],[102.56099351,-0.60365763],[102.56099351,-0.60565601],[102.55222342,-0.60565601],[102.55222342,-0.60365763]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49883038,-0.60597394],[102.50728238,-0.60597394],[102.50728238,-0.60792691],[102.49883038,-0.60792691],[102.49883038,-0.60597394]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50778223,-0.60592852],[102.51550718,-0.60592852],[102.51550718,-0.60792691],[102.50778223,-0.60792691],[102.50778223,-0.60592852]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51587071,-0.60642812],[102.52486801,-0.60642812],[102.52486801,-0.608154],[102.51587071,-0.608154],[102.51587071,-0.60642812]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.525002,-0.606615],[102.534972,-0.607107],[102.534933,-0.609437],[102.525091,-0.608955],[102.525002,-0.606615]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53522853,-0.60747273],[102.54322613,-0.60747273],[102.54322613,-0.60938028],[102.53522853,-0.60938028],[102.53522853,-0.60747273]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.5438623,-0.60597394],[102.55195078,-0.60597394],[102.55195078,-0.60797233],[102.5438623,-0.60797233],[102.5438623,-0.60597394]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.5523143,-0.60601936],[102.56103896,-0.60601936],[102.56103896,-0.60797233],[102.5523143,-0.60797233],[102.5523143,-0.60601936]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49883038,-0.60833567],[102.50760047,-0.60833567],[102.50760047,-0.61051573],[102.49883038,-0.61051573],[102.49883038,-0.60833567]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50778223,-0.60883527],[102.51559807,-0.60883527],[102.51559807,-0.61051573],[102.50778223,-0.61051573],[102.50778223,-0.60883527]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51596159,-0.60897152],[102.52377743,-0.60897152],[102.52377743,-0.6106974],[102.51596159,-0.6106974],[102.51596159,-0.60897152]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.525074,-0.609011],[102.534935,-0.609503],[102.5349,-0.611096],[102.525167,-0.611002],[102.525074,-0.609011]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.535064,-0.609509],[102.543319,-0.609879],[102.543216,-0.611275],[102.535023,-0.61108],[102.535064,-0.609509]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54372598,-0.60838109],[102.55204166,-0.60838109],[102.55204166,-0.61028864],[102.54372598,-0.61028864],[102.54372598,-0.60838109]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55235975,-0.60838109],[102.56112984,-0.60838109],[102.56112984,-0.61024322],[102.55235975,-0.61024322],[102.55235975,-0.60838109]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49914846,-0.61074282],[102.50710062,-0.61074282],[102.50710062,-0.61269579],[102.49914846,-0.61269579],[102.49914846,-0.61074282]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50778223,-0.61087907],[102.51564351,-0.61087907],[102.51564351,-0.61278662],[102.50778223,-0.61278662],[102.50778223,-0.61087907]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51600703,-0.61124242],[102.52495889,-0.61124242],[102.52495889,-0.61328622],[102.51600703,-0.61328622],[102.51600703,-0.61124242]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.525108,-0.611064],[102.534923,-0.611166],[102.534913,-0.614021],[102.525211,-0.613785],[102.525108,-0.611064]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53522853,-0.61146951],[102.54331701,-0.61146951],[102.54331701,-0.6137404],[102.53522853,-0.6137404],[102.53522853,-0.61146951]]]}'), 4326))
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
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54354421,-0.6106974],[102.55213254,-0.6106974],[102.55213254,-0.61260495],[102.54354421,-0.61260495],[102.54354421,-0.6106974]]]}'), 4326))
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
  'B-049',
  'estate_demo_01',
  'B-049',
  'Block B-049',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55245063,-0.61056115],[102.56122072,-0.61056115],[102.56122072,-0.61251412],[102.55245063,-0.61251412],[102.55245063,-0.61056115]]]}'), 4326))
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
  'B-050',
  'estate_demo_01',
  'B-050',
  'Block B-050',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.4991939,-0.61314997],[102.50700974,-0.61314997],[102.50700974,-0.61510294],[102.4991939,-0.61510294],[102.4991939,-0.61314997]]]}'), 4326))
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
  'B-051',
  'estate_demo_01',
  'B-051',
  'Block B-051',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50732782,-0.61333164],[102.51573439,-0.61333164],[102.51573439,-0.61523919],[102.50732782,-0.61523919],[102.50732782,-0.61333164]]]}'), 4326))
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
  'B-052',
  'estate_demo_01',
  'B-052',
  'Block B-052',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51609792,-0.61378582],[102.52500433,-0.61378582],[102.52500433,-0.61578421],[102.51609792,-0.61578421],[102.51609792,-0.61378582]]]}'), 4326))
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
  'B-053',
  'estate_demo_01',
  'B-053',
  'Block B-053',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.525183,-0.613831],[102.534897,-0.61415],[102.534811,-0.616256],[102.525232,-0.616011],[102.525183,-0.613831]]]}'), 4326))
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
  'B-054',
  'estate_demo_01',
  'B-054',
  'Block B-054',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53513765,-0.61437625],[102.54299892,-0.61437625],[102.54299892,-0.61623839],[102.53513765,-0.61623839],[102.53513765,-0.61437625]]]}'), 4326))
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
  'B-055',
  'estate_demo_01',
  'B-055',
  'Block B-055',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54340789,-0.61292288],[102.55217798,-0.61292288],[102.55217798,-0.61487585],[102.54340789,-0.61487585],[102.54340789,-0.61292288]]]}'), 4326))
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
  'B-056',
  'estate_demo_01',
  'B-056',
  'Block B-056',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55254151,-0.61292288],[102.5613116,-0.61292288],[102.5613116,-0.61519377],[102.55254151,-0.61519377],[102.55254151,-0.61292288]]]}'), 4326))
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
  'B-057',
  'estate_demo_01',
  'B-057',
  'Block B-057',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49910302,-0.61555712],[102.5069643,-0.61555712],[102.5069643,-0.61737383],[102.49910302,-0.61737383],[102.49910302,-0.61555712]]]}'), 4326))
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
  'B-058',
  'estate_demo_01',
  'B-058',
  'Block B-058',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50732782,-0.61555712],[102.51582527,-0.61555712],[102.51582527,-0.61746467],[102.50732782,-0.61746467],[102.50732782,-0.61555712]]]}'), 4326))
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
  'B-059',
  'estate_demo_01',
  'B-059',
  'Block B-059',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51614336,-0.61605671],[102.52391375,-0.61605671],[102.52391375,-0.61769176],[102.51614336,-0.61769176],[102.51614336,-0.61605671]]]}'), 4326))
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
  'B-060',
  'estate_demo_01',
  'B-060',
  'Block B-060',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52522,-0.61606],[102.534872,-0.616367],[102.534909,-0.618265],[102.525244,-0.618069],[102.52522,-0.61606]]]}'), 4326))
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
  'B-061',
  'estate_demo_01',
  'B-061',
  'Block B-061',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53513765,-0.61669256],[102.54299892,-0.61669256],[102.54299892,-0.61823677],[102.53513765,-0.61823677],[102.53513765,-0.61669256]]]}'), 4326))
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
  'B-062',
  'estate_demo_01',
  'B-062',
  'Block B-062',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54331701,-0.61533003],[102.55226886,-0.61533003],[102.55226886,-0.61719216],[102.54331701,-0.61719216],[102.54331701,-0.61533003]]]}'), 4326))
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
  'B-063',
  'estate_demo_01',
  'B-063',
  'Block B-063',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55263239,-0.61537545],[102.56135704,-0.61537545],[102.56135704,-0.61673798],[102.55263239,-0.61673798],[102.55263239,-0.61537545]]]}'), 4326))
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
  'B-064',
  'estate_demo_01',
  'B-064',
  'Block B-064',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49883038,-0.61778259],[102.50750959,-0.61778259],[102.50750959,-0.61969015],[102.49883038,-0.61969015],[102.49883038,-0.61778259]]]}'), 4326))
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
  'B-065',
  'estate_demo_01',
  'B-065',
  'Block B-065',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50769135,-0.61810052],[102.51591615,-0.61810052],[102.51591615,-0.6198264],[102.50769135,-0.6198264],[102.50769135,-0.61810052]]]}'), 4326))
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
  'B-066',
  'estate_demo_01',
  'B-066',
  'Block B-066',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51623424,-0.61846386],[102.52386831,-0.61846386],[102.52386831,-0.61987182],[102.51623424,-0.61987182],[102.51623424,-0.61846386]]]}'), 4326))
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
  'B-067',
  'estate_demo_01',
  'B-067',
  'Block B-067',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52523153,-0.6185547],[102.53477412,-0.6185547],[102.53477412,-0.62023516],[102.52523153,-0.62023516],[102.52523153,-0.6185547]]]}'), 4326))
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
  'B-068',
  'estate_demo_01',
  'B-068',
  'Block B-068',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53513765,-0.61873637],[102.5426354,-0.61873637],[102.5426354,-0.62037142],[102.53513765,-0.62037142],[102.53513765,-0.61873637]]]}'), 4326))
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
  'B-069',
  'estate_demo_01',
  'B-069',
  'Block B-069',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54390774,-0.61764634],[102.55235975,-0.61764634],[102.55235975,-0.61946306],[102.54390774,-0.61946306],[102.54390774,-0.61764634]]]}'), 4326))
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
  'B-070',
  'estate_demo_01',
  'B-070',
  'Block B-070',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55267783,-0.61760092],[102.56144792,-0.61760092],[102.56144792,-0.61964473],[102.55267783,-0.61964473],[102.55267783,-0.61760092]]]}'), 4326))
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
  'B-071',
  'estate_demo_01',
  'B-071',
  'Block B-071',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.4989667,-0.62009891],[102.50750959,-0.62009891],[102.50750959,-0.62200646],[102.4989667,-0.62200646],[102.4989667,-0.62009891]]]}'), 4326))
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
  'B-072',
  'estate_demo_01',
  'B-072',
  'Block B-072',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50769135,-0.62028058],[102.51591615,-0.62028058],[102.51591615,-0.6220973],[102.50769135,-0.6220973],[102.50769135,-0.62028058]]]}'), 4326))
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
  'B-073',
  'estate_demo_01',
  'B-073',
  'Block B-073',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.516154,-0.620218],[102.525235,-0.620364],[102.525278,-0.622516],[102.516197,-0.622335],[102.516154,-0.620218]]]}'), 4326))
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
  'B-074',
  'estate_demo_01',
  'B-074',
  'Block B-074',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52527697,-0.6205985],[102.53477412,-0.6205985],[102.53477412,-0.62250606],[102.52527697,-0.62250606],[102.52527697,-0.6205985]]]}'), 4326))
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
  'B-075',
  'estate_demo_01',
  'B-075',
  'Block B-075',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.534983,-0.620558],[102.543126,-0.620765],[102.543195,-0.622943],[102.534932,-0.622762],[102.534983,-0.620558]]]}'), 4326))
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
  'B-076',
  'estate_demo_01',
  'B-076',
  'Block B-076',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54290804,-0.62000807],[102.55258695,-0.62000807],[102.55258695,-0.62177937],[102.54290804,-0.62177937],[102.54290804,-0.62000807]]]}'), 4326))
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
  'B-077',
  'estate_demo_01',
  'B-077',
  'Block B-077',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.552558,-0.61985],[102.561699,-0.61985],[102.561811,-0.622157],[102.552653,-0.622157],[102.552558,-0.61985]]]}'), 4326))
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
  'B-078',
  'estate_demo_01',
  'B-078',
  'Block B-078',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.4989667,-0.62246064],[102.50750959,-0.62246064],[102.50750959,-0.62450444],[102.4989667,-0.62450444],[102.4989667,-0.62246064]]]}'), 4326))
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
  'B-079',
  'estate_demo_01',
  'B-079',
  'Block B-079',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50787311,-0.62250606],[102.51596159,-0.62250606],[102.51596159,-0.62445903],[102.50787311,-0.62445903],[102.50787311,-0.62250606]]]}'), 4326))
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
  'B-080',
  'estate_demo_01',
  'B-080',
  'Block B-080',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51609792,-0.62264231],[102.52518609,-0.62264231],[102.52518609,-0.62441361],[102.51609792,-0.62441361],[102.51609792,-0.62264231]]]}'), 4326))
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
  'B-081',
  'estate_demo_01',
  'B-081',
  'Block B-081',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52532242,-0.6228694],[102.53472868,-0.6228694],[102.53472868,-0.62436819],[102.52532242,-0.62436819],[102.52532242,-0.6228694]]]}'), 4326))
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
  'B-082',
  'estate_demo_01',
  'B-082',
  'Block B-082',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.534966,-0.622822],[102.543221,-0.623037],[102.543264,-0.624354],[102.534992,-0.624492],[102.534966,-0.622822]]]}'), 4326))
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
  'B-083',
  'estate_demo_01',
  'B-083',
  'Block B-083',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.543328,-0.62216],[102.552603,-0.622219],[102.552662,-0.624604],[102.543436,-0.624506],[102.543328,-0.62216]]]}'), 4326))
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
  'B-084',
  'estate_demo_01',
  'B-084',
  'Block B-084',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.5528596,-0.62246064],[102.56172057,-0.62246064],[102.56172057,-0.62473153],[102.5528596,-0.62473153],[102.5528596,-0.62246064]]]}'), 4326))
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
  'B-085',
  'estate_demo_01',
  'B-085',
  'Block B-085',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.62477695],[102.50750959,-0.62477695],[102.50750959,-0.62677534],[102.49878494,-0.62677534],[102.49878494,-0.62477695]]]}'), 4326))
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
  'B-086',
  'estate_demo_01',
  'B-086',
  'Block B-086',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50791855,-0.62486779],[102.51600703,-0.62486779],[102.51600703,-0.62682076],[102.50791855,-0.62682076],[102.50791855,-0.62486779]]]}'), 4326))
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
  'B-087',
  'estate_demo_01',
  'B-087',
  'Block B-087',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51614336,-0.62486779],[102.52523153,-0.62486779],[102.52523153,-0.62695701],[102.51614336,-0.62695701],[102.51614336,-0.62486779]]]}'), 4326))
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
  'B-088',
  'estate_demo_01',
  'B-088',
  'Block B-088',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52536786,-0.62482237],[102.53472868,-0.62482237],[102.53472868,-0.62704785],[102.52536786,-0.62704785],[102.52536786,-0.62482237]]]}'), 4326))
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
  'B-089',
  'estate_demo_01',
  'B-089',
  'Block B-089',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53513765,-0.62454986],[102.5430898,-0.62454986],[102.5430898,-0.62695701],[102.53513765,-0.62695701],[102.53513765,-0.62454986]]]}'), 4326))
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
  'B-090',
  'estate_demo_01',
  'B-090',
  'Block B-090',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54322613,-0.62477695],[102.55254151,-0.62477695],[102.55254151,-0.62682076],[102.54322613,-0.62682076],[102.54322613,-0.62477695]]]}'), 4326))
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
  'B-091',
  'estate_demo_01',
  'B-091',
  'Block B-091',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.5528596,-0.62491321],[102.56176601,-0.62491321],[102.56176601,-0.62691159],[102.5528596,-0.62691159],[102.5528596,-0.62491321]]]}'), 4326))
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
  'B-092',
  'estate_demo_01',
  'B-092',
  'Block B-092',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.62713868],[102.50755503,-0.62713868],[102.50755503,-0.62913707],[102.49878494,-0.62913707],[102.49878494,-0.62713868]]]}'), 4326))
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
  'B-093',
  'estate_demo_01',
  'B-093',
  'Block B-093',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50791855,-0.62722952],[102.51605247,-0.62722952],[102.51605247,-0.62904624],[102.50791855,-0.62904624],[102.50791855,-0.62722952]]]}'), 4326))
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
  'B-094',
  'estate_demo_01',
  'B-094',
  'Block B-094',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51650688,-0.62736577],[102.52527697,-0.62736577],[102.52527697,-0.62904624],[102.51650688,-0.62904624],[102.51650688,-0.62736577]]]}'), 4326))
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
  'B-095',
  'estate_demo_01',
  'B-095',
  'Block B-095',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52545874,-0.62741119],[102.53472868,-0.62741119],[102.53472868,-0.62913707],[102.52545874,-0.62913707],[102.52545874,-0.62741119]]]}'), 4326))
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
  'B-096',
  'estate_demo_01',
  'B-096',
  'Block B-096',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53513765,-0.62741119],[102.5430898,-0.62741119],[102.5430898,-0.62900082],[102.53513765,-0.62900082],[102.53513765,-0.62741119]]]}'), 4326))
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
  'B-097',
  'estate_demo_01',
  'B-097',
  'Block B-097',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54363509,-0.62700243],[102.55272327,-0.62700243],[102.55272327,-0.62909165],[102.54363509,-0.62909165],[102.54363509,-0.62700243]]]}'), 4326))
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
  'B-098',
  'estate_demo_01',
  'B-098',
  'Block B-098',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55290504,-0.62732035],[102.56190233,-0.62732035],[102.56190233,-0.62931874],[102.55290504,-0.62931874],[102.55290504,-0.62732035]]]}'), 4326))
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
  'B-099',
  'estate_demo_01',
  'B-099',
  'Block B-099',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.62931874],[102.50755503,-0.62931874],[102.50755503,-0.6314988],[102.49878494,-0.6314988],[102.49878494,-0.62931874]]]}'), 4326))
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
  'B-100',
  'estate_demo_01',
  'B-100',
  'Block B-100',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50791855,-0.629455],[102.51609792,-0.629455],[102.51609792,-0.63145338],[102.50791855,-0.63145338],[102.50791855,-0.629455]]]}'), 4326))
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
  'B-101',
  'estate_demo_01',
  'B-101',
  'Block B-101',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51650688,-0.629455],[102.52527697,-0.629455],[102.52527697,-0.63122629],[102.51650688,-0.63122629],[102.51650688,-0.629455]]]}'), 4326))
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
  'B-102',
  'estate_demo_01',
  'B-102',
  'Block B-102',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52545874,-0.62950041],[102.53472868,-0.62950041],[102.53472868,-0.63077212],[102.52545874,-0.63077212],[102.52545874,-0.62950041]]]}'), 4326))
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
  'B-103',
  'estate_demo_01',
  'B-103',
  'Block B-103',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.534976,-0.629337],[102.543402,-0.629075],[102.543437,-0.630025],[102.53495,-0.630539],[102.534976,-0.629337]]]}'), 4326))
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
  'B-104',
  'estate_demo_01',
  'B-104',
  'Block B-104',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.543541,-0.629335],[102.5501,-0.629316],[102.550096,-0.631667],[102.543605,-0.631614],[102.543541,-0.629335]]]}'), 4326))
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
  'B-105',
  'estate_demo_01',
  'B-105',
  'Block B-105',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55022402,-0.62940958],[102.56199321,-0.62940958],[102.56199321,-0.63145338],[102.55022402,-0.63145338],[102.55022402,-0.62940958]]]}'), 4326))
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
  'B-106',
  'estate_demo_01',
  'B-106',
  'Block B-106',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.63190756],[102.50664621,-0.63190756],[102.50664621,-0.63381512],[102.49878494,-0.63381512],[102.49878494,-0.63190756]]]}'), 4326))
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
  'B-107',
  'estate_demo_01',
  'B-107',
  'Block B-107',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50791855,-0.63186215],[102.51614336,-0.63186215],[102.51614336,-0.63381512],[102.50791855,-0.63381512],[102.50791855,-0.63186215]]]}'), 4326))
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
  'B-108',
  'estate_demo_01',
  'B-108',
  'Block B-108',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51655232,-0.63145338],[102.52532242,-0.63145338],[102.52532242,-0.6337697],[102.51655232,-0.6337697],[102.51655232,-0.63145338]]]}'), 4326))
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
  'B-109',
  'estate_demo_01',
  'B-109',
  'Block B-109',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52550418,-0.63113546],[102.53472868,-0.63113546],[102.53472868,-0.63372428],[102.52550418,-0.63372428],[102.52550418,-0.63113546]]]}'), 4326))
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
  'B-110',
  'estate_demo_01',
  'B-110',
  'Block B-110',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53509221,-0.63049961],[102.54327157,-0.63049961],[102.54327157,-0.63336094],[102.53509221,-0.63336094],[102.53509221,-0.63049961]]]}'), 4326))
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
  'B-111',
  'estate_demo_01',
  'B-111',
  'Block B-111',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.543605,-0.631678],[102.550092,-0.631715],[102.550097,-0.633943],[102.54364,-0.634025],[102.543605,-0.631678]]]}'), 4326))
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
  'B-112',
  'estate_demo_01',
  'B-112',
  'Block B-112',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55022402,-0.63181673],[102.5620841,-0.63181673],[102.5620841,-0.63381512],[102.55022402,-0.63381512],[102.55022402,-0.63181673]]]}'), 4326))
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
  'B-113',
  'estate_demo_01',
  'B-113',
  'Block B-113',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.63417846],[102.50660077,-0.63417846],[102.50660077,-0.6358135],[102.49878494,-0.6358135],[102.49878494,-0.63417846]]]}'), 4326))
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
  'B-114',
  'estate_demo_01',
  'B-114',
  'Block B-114',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50787311,-0.63426929],[102.51627968,-0.63426929],[102.51627968,-0.6358135],[102.50787311,-0.6358135],[102.50787311,-0.63426929]]]}'), 4326))
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
  'B-115',
  'estate_demo_01',
  'B-115',
  'Block B-115',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51664321,-0.63417846],[102.5254133,-0.63417846],[102.5254133,-0.63590434],[102.51664321,-0.63590434],[102.51664321,-0.63417846]]]}'), 4326))
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
  'B-116',
  'estate_demo_01',
  'B-116',
  'Block B-116',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52554962,-0.6340422],[102.53468324,-0.6340422],[102.53468324,-0.63617685],[102.52554962,-0.63617685],[102.52554962,-0.6340422]]]}'), 4326))
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
  'B-117',
  'estate_demo_01',
  'B-117',
  'Block B-117',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53509221,-0.63358803],[102.54358965,-0.63358803],[102.54358965,-0.63613143],[102.53509221,-0.63613143],[102.53509221,-0.63358803]]]}'), 4326))
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
  'B-118',
  'estate_demo_01',
  'B-118',
  'Block B-118',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54372598,-0.63422388],[102.54990594,-0.63422388],[102.54990594,-0.63617685],[102.54372598,-0.63617685],[102.54372598,-0.63422388]]]}'), 4326))
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
  'B-119',
  'estate_demo_01',
  'B-119',
  'Block B-119',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.55022402,-0.6340422],[102.56222042,-0.6340422],[102.56222042,-0.63604059],[102.55022402,-0.63604059],[102.55022402,-0.6340422]]]}'), 4326))
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
  'B-120',
  'estate_demo_01',
  'B-120',
  'Block B-120',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.49878494,-0.63622226],[102.50746415,-0.63622226],[102.50746415,-0.63831149],[102.49878494,-0.63831149],[102.49878494,-0.63622226]]]}'), 4326))
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
  'B-121',
  'estate_demo_01',
  'B-121',
  'Block B-121',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.50787311,-0.63617685],[102.51632512,-0.63617685],[102.51632512,-0.63835691],[102.50787311,-0.63835691],[102.50787311,-0.63617685]]]}'), 4326))
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
  'B-122',
  'estate_demo_01',
  'B-122',
  'Block B-122',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.51668865,-0.63626768],[102.52545874,-0.63626768],[102.52545874,-0.63844774],[102.51668865,-0.63844774],[102.51668865,-0.63626768]]]}'), 4326))
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
  'B-123',
  'estate_demo_01',
  'B-123',
  'Block B-123',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.52582227,-0.63649477],[102.53468324,-0.63649477],[102.53468324,-0.63881108],[102.52582227,-0.63881108],[102.52582227,-0.63649477]]]}'), 4326))
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
  'B-124',
  'estate_demo_01',
  'B-124',
  'Block B-124',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.53504677,-0.63667644],[102.54345333,-0.63667644],[102.54345333,-0.638584],[102.53504677,-0.638584],[102.53504677,-0.63667644]]]}'), 4326))
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
  'B-125',
  'estate_demo_01',
  'B-125',
  'Block B-125',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.54381686,-0.63667644],[102.54990594,-0.63667644],[102.54990594,-0.638584],[102.54381686,-0.638584],[102.54381686,-0.63667644]]]}'), 4326))
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
  'B-126',
  'estate_demo_01',
  'B-126',
  'Block B-126',
  0.0,
  ST_Multi(ST_SetSRID(ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[102.550139,-0.636432],[102.562347,-0.636173],[102.562419,-0.638356],[102.550068,-0.638672],[102.550139,-0.636432]]]}'), 4326))
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
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-12', 0.7533, 0.7736, -0.0203, 0.1748, 0.2366, -0.0618, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-12', 0.7498, 0.7745, -0.0247, 0.231, 0.2525, -0.0215, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-12', 0.7289, 0.7653, -0.0364, 0.1576, 0.2545, -0.0969, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-12', 0.6949, 0.785, -0.0901, 0.1255, 0.2203, -0.0947, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-12', 0.7882, 0.7774, 0.0108, 0.2543, 0.2678, -0.0136, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-12', 0.5736, 0.8171, -0.2435, 0.1966, 0.3003, -0.1038, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-12', 0.6791, 0.7944, -0.1153, 0.2086, 0.2928, -0.0842, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-12', 0.7752, 0.7959, -0.0206, 0.2122, 0.2723, -0.0601, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-12', 0.7914, 0.7887, 0.0027, 0.2519, 0.2744, -0.0225, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-12', 0.7355, 0.7734, -0.038, 0.1514, 0.2717, -0.1203, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-12', 0.6879, 0.7474, -0.0595, 0.1715, 0.1963, -0.0248, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-12', 0.8115, 0.819, -0.0075, 0.2999, 0.3041, -0.0042, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-12', 0.7812, 0.8335, -0.0524, 0.2476, 0.3189, -0.0713, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-12', 0.7352, 0.8153, -0.0801, 0.261, 0.3178, -0.0568, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-12', 0.7614, 0.7694, -0.008, 0.2112, 0.2658, -0.0545, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-12', 0.7767, 0.8013, -0.0245, 0.2417, 0.3087, -0.0671, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-12', 0.7021, 0.7989, -0.0968, 0.1557, 0.2637, -0.108, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-12', 0.7441, 0.7884, -0.0443, 0.1955, 0.2317, -0.0362, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-12', 0.8107, 0.8131, -0.0024, 0.3082, 0.2931, 0.0151, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-12', 0.7337, 0.8358, -0.1021, 0.206, 0.3228, -0.1168, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-12', 0.7926, 0.8286, -0.036, 0.2967, 0.3284, -0.0318, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-12', 0.7805, 0.7686, 0.0119, 0.2608, 0.2887, -0.028, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-12', 0.7592, 0.8041, -0.0449, 0.2406, 0.2913, -0.0507, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-12', 0.716, 0.8092, -0.0932, 0.1396, 0.2763, -0.1367, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-12', 0.7966, 0.8114, -0.0148, 0.2489, 0.2818, -0.0329, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-12', 0.8287, 0.835, -0.0063, 0.3103, 0.3133, -0.003, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-12', 0.7446, 0.8654, -0.1208, 0.2027, 0.3509, -0.1481, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-12', 0.7893, 0.826, -0.0368, 0.2926, 0.3163, -0.0236, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-12', 0.7978, 0.7871, 0.0107, 0.2436, 0.2697, -0.0261, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-12', 0.761, 0.8063, -0.0453, 0.2401, 0.2899, -0.0498, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-12', 0.7443, 0.8113, -0.067, 0.1527, 0.2796, -0.1268, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-12', 0.7928, 0.8122, -0.0195, 0.2564, 0.2741, -0.0178, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-12', 0.8216, 0.8345, -0.0129, 0.3062, 0.3131, -0.0068, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-12', 0.8161, 0.8527, -0.0366, 0.3051, 0.3367, -0.0316, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-12', 0.8157, 0.8321, -0.0164, 0.2787, 0.3252, -0.0465, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-12', 0.7548, 0.7707, -0.0159, 0.1842, 0.2466, -0.0624, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-12', 0.7775, 0.8059, -0.0284, 0.2182, 0.2849, -0.0667, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-12', 0.8012, 0.8201, -0.0189, 0.2303, 0.2955, -0.0651, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-12', 0.7711, 0.7964, -0.0253, 0.2442, 0.2774, -0.0331, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-12', 0.7569, 0.8036, -0.0467, 0.2624, 0.3006, -0.0382, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-12', 0.7958, 0.8466, -0.0507, 0.3063, 0.3289, -0.0226, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-12', 0.8152, 0.837, -0.0218, 0.3005, 0.3373, -0.0367, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-12', 0.7818, 0.7995, -0.0177, 0.202, 0.2594, -0.0574, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-12', 0.7714, 0.7967, -0.0253, 0.1864, 0.2753, -0.0889, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-12', 0.7878, 0.8109, -0.023, 0.2128, 0.2781, -0.0652, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-12', 0.7651, 0.8172, -0.0522, 0.226, 0.2718, -0.0459, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-12', 0.7757, 0.8195, -0.0438, 0.2953, 0.325, -0.0297, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-12', 0.7811, 0.8412, -0.0601, 0.2864, 0.3273, -0.0409, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-049', '2026-06-12', 0.8209, 0.8469, -0.0261, 0.3209, 0.3493, -0.0284, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-050', '2026-06-12', 0.7946, 0.8027, -0.0081, 0.2448, 0.254, -0.0093, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-051', '2026-06-12', 0.7706, 0.8057, -0.0351, 0.2027, 0.2689, -0.0662, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-052', '2026-06-12', 0.7571, 0.7977, -0.0406, 0.2112, 0.2715, -0.0603, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-053', '2026-06-12', 0.7532, 0.8189, -0.0657, 0.2351, 0.2861, -0.051, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-054', '2026-06-12', 0.8079, 0.8385, -0.0306, 0.3052, 0.3268, -0.0216, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-055', '2026-06-12', 0.8371, 0.8333, 0.0038, 0.316, 0.3273, -0.0113, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-056', '2026-06-12', 0.8103, 0.8285, -0.0182, 0.3183, 0.3358, -0.0175, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-057', '2026-06-12', 0.7942, 0.811, -0.0168, 0.2508, 0.2501, 0.0007, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-058', '2026-06-12', 0.7606, 0.8021, -0.0415, 0.2062, 0.2721, -0.0659, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-059', '2026-06-12', 0.7797, 0.816, -0.0362, 0.2415, 0.2946, -0.0531, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-060', '2026-06-12', 0.7896, 0.8285, -0.0389, 0.2486, 0.2917, -0.0431, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-061', '2026-06-12', 0.8179, 0.8343, -0.0163, 0.3268, 0.3005, 0.0262, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-062', '2026-06-12', 0.7872, 0.8489, -0.0618, 0.298, 0.3423, -0.0443, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-063', '2026-06-12', 0.8122, 0.8214, -0.0092, 0.3234, 0.3287, -0.0052, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-064', '2026-06-12', 0.8104, 0.825, -0.0146, 0.2908, 0.2546, 0.0362, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-065', '2026-06-12', 0.7842, 0.8208, -0.0367, 0.2263, 0.2826, -0.0562, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-066', '2026-06-12', 0.7679, 0.8096, -0.0417, 0.2161, 0.2761, -0.06, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-067', '2026-06-12', 0.7897, 0.8291, -0.0394, 0.2276, 0.3035, -0.0759, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-068', '2026-06-12', 0.8147, 0.8401, -0.0253, 0.3126, 0.32, -0.0074, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-069', '2026-06-12', 0.8346, 0.8504, -0.0159, 0.3369, 0.3526, -0.0157, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-070', '2026-06-12', 0.7831, 0.8247, -0.0416, 0.2809, 0.3185, -0.0377, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-071', '2026-06-12', 0.8113, 0.8241, -0.0128, 0.2881, 0.2583, 0.0299, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-072', '2026-06-12', 0.7584, 0.8206, -0.0622, 0.1949, 0.2856, -0.0907, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-073', '2026-06-12', 0.719, 0.7674, -0.0483, 0.1717, 0.2422, -0.0705, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-074', '2026-06-12', 0.7834, 0.8284, -0.0451, 0.2355, 0.3118, -0.0763, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-075', '2026-06-12', 0.8054, 0.8293, -0.0239, 0.2876, 0.3158, -0.0282, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-076', '2026-06-12', 0.8061, 0.8396, -0.0335, 0.3213, 0.34, -0.0187, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-077', '2026-06-12', 0.7927, 0.8091, -0.0164, 0.2328, 0.2839, -0.0511, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-078', '2026-06-12', 0.7751, 0.7888, -0.0137, 0.2723, 0.2441, 0.0282, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-079', '2026-06-12', 0.7889, 0.8187, -0.0297, 0.2501, 0.2939, -0.0437, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-080', '2026-06-12', 0.7569, 0.8033, -0.0464, 0.1927, 0.2946, -0.1019, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-081', '2026-06-12', 0.7777, 0.8078, -0.0301, 0.273, 0.3162, -0.0432, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-082', '2026-06-12', 0.8065, 0.8304, -0.0239, 0.307, 0.3244, -0.0175, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-083', '2026-06-12', 0.7034, 0.8171, -0.1137, 0.2389, 0.3158, -0.0769, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-084', '2026-06-12', 0.7771, 0.7565, 0.0206, 0.2395, 0.2398, -0.0003, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-085', '2026-06-12', 0.8102, 0.8406, -0.0303, 0.2915, 0.3207, -0.0292, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-086', '2026-06-12', 0.7887, 0.8148, -0.0261, 0.2645, 0.2954, -0.0309, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-087', '2026-06-12', 0.7509, 0.8207, -0.0698, 0.1928, 0.3047, -0.1119, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-088', '2026-06-12', 0.7891, 0.8361, -0.0469, 0.2914, 0.3219, -0.0305, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-089', '2026-06-12', 0.7485, 0.8341, -0.0857, 0.2946, 0.3467, -0.0521, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-090', '2026-06-12', 0.793, 0.842, -0.049, 0.2851, 0.3469, -0.0618, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-091', '2026-06-12', 0.7843, 0.8045, -0.0202, 0.2418, 0.2695, -0.0276, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-092', '2026-06-12', 0.8066, 0.8329, -0.0263, 0.2994, 0.3122, -0.0128, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-093', '2026-06-12', 0.7732, 0.8156, -0.0424, 0.2601, 0.2955, -0.0354, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-094', '2026-06-12', 0.7679, 0.8075, -0.0397, 0.2349, 0.2906, -0.0557, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-095', '2026-06-12', 0.7738, 0.8324, -0.0586, 0.287, 0.3152, -0.0282, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-096', '2026-06-12', 0.8018, 0.823, -0.0212, 0.2876, 0.3438, -0.0562, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-097', '2026-06-12', 0.8225, 0.8373, -0.0148, 0.3097, 0.3378, -0.0281, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-098', '2026-06-12', 0.7768, 0.8074, -0.0306, 0.2483, 0.2581, -0.0097, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-099', '2026-06-12', 0.7614, 0.7743, -0.0129, 0.2572, 0.2768, -0.0196, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-100', '2026-06-12', 0.7723, 0.8235, -0.0512, 0.2457, 0.2975, -0.0518, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-101', '2026-06-12', 0.7772, 0.8058, -0.0286, 0.2584, 0.302, -0.0436, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-102', '2026-06-12', 0.7984, 0.8237, -0.0254, 0.2929, 0.3037, -0.0108, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-103', '2026-06-12', 0.7972, 0.7919, 0.0053, 0.2898, 0.3103, -0.0205, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-104', '2026-06-12', 0.7958, 0.8174, -0.0216, 0.2418, 0.3246, -0.0829, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-105', '2026-06-12', 0.782, 0.8147, -0.0327, 0.2621, 0.2616, 0.0005, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-106', '2026-06-12', 0.8097, 0.8091, 0.0006, 0.302, 0.2813, 0.0207, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-107', '2026-06-12', 0.8048, 0.8296, -0.0248, 0.2803, 0.3112, -0.0309, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-108', '2026-06-12', 0.7748, 0.8006, -0.0259, 0.2482, 0.3035, -0.0553, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-109', '2026-06-12', 0.8111, 0.8273, -0.0162, 0.3059, 0.3078, -0.0019, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-110', '2026-06-12', 0.8117, 0.8443, -0.0326, 0.2883, 0.3371, -0.0488, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-111', '2026-06-12', 0.8085, 0.8026, 0.0059, 0.2695, 0.3221, -0.0526, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-112', '2026-06-12', 0.8234, 0.8201, 0.0033, 0.3245, 0.2635, 0.061, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-113', '2026-06-12', 0.8028, 0.8094, -0.0066, 0.3008, 0.2844, 0.0164, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-114', '2026-06-12', 0.8221, 0.8325, -0.0104, 0.3028, 0.329, -0.0262, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-115', '2026-06-12', 0.7955, 0.7964, -0.001, 0.2548, 0.2969, -0.0421, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-116', '2026-06-12', 0.8041, 0.818, -0.0139, 0.3106, 0.3032, 0.0074, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-117', '2026-06-12', 0.7685, 0.8429, -0.0744, 0.251, 0.3149, -0.0639, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-118', '2026-06-12', 0.8299, 0.828, 0.0019, 0.3083, 0.3292, -0.0209, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-119', '2026-06-12', 0.8041, 0.8207, -0.0166, 0.3123, 0.267, 0.0453, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-120', '2026-06-12', 0.8087, 0.7864, 0.0223, 0.294, 0.2841, 0.0099, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-121', '2026-06-12', 0.8042, 0.8187, -0.0145, 0.3086, 0.3131, -0.0045, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-122', '2026-06-12', 0.7963, 0.7933, 0.003, 0.2552, 0.2824, -0.0272, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-123', '2026-06-12', 0.7454, 0.802, -0.0566, 0.2835, 0.2569, 0.0266, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-124', '2026-06-12', 0.7434, 0.7984, -0.0551, 0.2285, 0.2728, -0.0443, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-125', '2026-06-12', 0.8252, 0.8236, 0.0016, 0.2729, 0.296, -0.0232, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid'),
  ('00000000-0000-0000-0000-000000000002', 'B-126', '2026-06-12', 0.8229, 0.812, 0.0109, 0.3102, 0.2594, 0.0508, 989.15, 416.09, 0.0, 0, null, 'real_satellite_valid');

insert into risk_scores (
  processing_run_id, block_id, score_date, vegetation_stress, moisture_stress, rainfall_stress, fire_risk, risk_score, risk_category, dominant_driver, recommended_action
)
values
  ('00000000-0000-0000-0000-000000000002', 'B-001', '2026-06-12', 0.1128, 0.2809, 0.0, 0.0, 0.1181, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-002', '2026-06-12', 0.1372, 0.0977, 0.0, 0.0, 0.0705, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-003', '2026-06-12', 0.2022, 0.4405, 0.0, 0.0, 0.1928, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-004', '2026-06-12', 0.5006, 0.4305, 0.0, 0.0, 0.2793, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-005', '2026-06-12', 0.0, 0.0618, 0.0, 0.0, 0.0185, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-006', '2026-06-12', 1.0, 0.4718, 0.0, 0.0, 0.4415, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-007', '2026-06-12', 0.6406, 0.3827, 0.0, 0.0, 0.307, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-008', '2026-06-12', 0.1144, 0.2732, 0.0, 0.0, 0.1163, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-009', '2026-06-12', 0.0, 0.1023, 0.0, 0.0, 0.0307, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-010', '2026-06-12', 0.2111, 0.5468, 0.0, 0.0, 0.2274, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-011', '2026-06-12', 0.3306, 0.1127, 0.0, 0.0, 0.133, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-012', '2026-06-12', 0.0417, 0.0191, 0.0, 0.0, 0.0182, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-013', '2026-06-12', 0.2911, 0.3241, 0.0, 0.0, 0.1846, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-014', '2026-06-12', 0.445, 0.2582, 0.0, 0.0, 0.211, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-015', '2026-06-12', 0.0444, 0.2477, 0.0, 0.0, 0.0877, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-016', '2026-06-12', 0.1361, 0.305, 0.0, 0.0, 0.1323, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-017', '2026-06-12', 0.5378, 0.4909, 0.0, 0.0, 0.3086, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-018', '2026-06-12', 0.2461, 0.1645, 0.0, 0.0, 0.1232, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-019', '2026-06-12', 0.0133, 0.0, 0.0, 0.0, 0.004, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-020', '2026-06-12', 0.5672, 0.5309, 0.0, 0.0, 0.3294, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-021', '2026-06-12', 0.2, 0.1445, 0.0, 0.0, 0.1034, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-022', '2026-06-12', 0.0, 0.1273, 0.0, 0.0, 0.0382, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-023', '2026-06-12', 0.2494, 0.2305, 0.0, 0.0, 0.144, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-024', '2026-06-12', 0.5178, 0.6214, 0.0, 0.0, 0.3417, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-025', '2026-06-12', 0.0822, 0.1495, 0.0, 0.0, 0.0695, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-026', '2026-06-12', 0.035, 0.0136, 0.0, 0.0, 0.0146, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-027', '2026-06-12', 0.6711, 0.6732, 0.0, 0.0, 0.4033, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-028', '2026-06-12', 0.2044, 0.1073, 0.0, 0.0, 0.0935, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-029', '2026-06-12', 0.0, 0.1186, 0.0, 0.0, 0.0356, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-030', '2026-06-12', 0.2517, 0.2264, 0.0, 0.0, 0.1434, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-031', '2026-06-12', 0.3722, 0.5764, 0.0, 0.0, 0.2846, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-032', '2026-06-12', 0.1083, 0.0809, 0.0, 0.0, 0.0568, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-033', '2026-06-12', 0.0717, 0.0309, 0.0, 0.0, 0.0308, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-034', '2026-06-12', 0.2033, 0.1436, 0.0, 0.0, 0.1041, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-035', '2026-06-12', 0.0911, 0.2114, 0.0, 0.0, 0.0907, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-036', '2026-06-12', 0.0883, 0.2836, 0.0, 0.0, 0.1116, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-037', '2026-06-12', 0.1578, 0.3032, 0.0, 0.0, 0.1383, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-038', '2026-06-12', 0.105, 0.2959, 0.0, 0.0, 0.1203, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-039', '2026-06-12', 0.1406, 0.1505, 0.0, 0.0, 0.0873, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-040', '2026-06-12', 0.2594, 0.1736, 0.0, 0.0, 0.1299, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-041', '2026-06-12', 0.2817, 0.1027, 0.0, 0.0, 0.1153, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-042', '2026-06-12', 0.1211, 0.1668, 0.0, 0.0, 0.0864, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-043', '2026-06-12', 0.0983, 0.2609, 0.0, 0.0, 0.1078, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-044', '2026-06-12', 0.1406, 0.4041, 0.0, 0.0, 0.1634, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-045', '2026-06-12', 0.1278, 0.2964, 0.0, 0.0, 0.1272, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-046', '2026-06-12', 0.29, 0.2086, 0.0, 0.0, 0.1496, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-047', '2026-06-12', 0.2433, 0.135, 0.0, 0.0, 0.1135, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-048', '2026-06-12', 0.3339, 0.1859, 0.0, 0.0, 0.1559, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-049', '2026-06-12', 0.145, 0.1291, 0.0, 0.0, 0.0822, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-050', '2026-06-12', 0.045, 0.0423, 0.0, 0.0, 0.0262, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-051', '2026-06-12', 0.195, 0.3009, 0.0, 0.0, 0.1488, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-052', '2026-06-12', 0.2256, 0.2741, 0.0, 0.0, 0.1499, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-053', '2026-06-12', 0.365, 0.2318, 0.0, 0.0, 0.179, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-054', '2026-06-12', 0.17, 0.0982, 0.0, 0.0, 0.0805, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-055', '2026-06-12', 0.0, 0.0514, 0.0, 0.0, 0.0154, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-056', '2026-06-12', 0.1011, 0.0795, 0.0, 0.0, 0.0542, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-057', '2026-06-12', 0.0933, 0.0, 0.0, 0.0, 0.028, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-058', '2026-06-12', 0.2306, 0.2995, 0.0, 0.0, 0.159, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-059', '2026-06-12', 0.2011, 0.2414, 0.0, 0.0, 0.1327, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-060', '2026-06-12', 0.2161, 0.1959, 0.0, 0.0, 0.1236, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-061', '2026-06-12', 0.0906, 0.0, 0.0, 0.0, 0.0272, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-062', '2026-06-12', 0.3433, 0.2014, 0.0, 0.0, 0.1634, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-063', '2026-06-12', 0.0511, 0.0236, 0.0, 0.0, 0.0224, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-064', '2026-06-12', 0.0811, 0.0, 0.0, 0.0, 0.0243, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-065', '2026-06-12', 0.2039, 0.2555, 0.0, 0.0, 0.1378, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-066', '2026-06-12', 0.2317, 0.2727, 0.0, 0.0, 0.1513, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-067', '2026-06-12', 0.2189, 0.345, 0.0, 0.0, 0.1692, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-068', '2026-06-12', 0.1406, 0.0336, 0.0, 0.0, 0.0523, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-069', '2026-06-12', 0.0883, 0.0714, 0.0, 0.0, 0.0479, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-070', '2026-06-12', 0.2311, 0.1714, 0.0, 0.0, 0.1207, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-071', '2026-06-12', 0.0711, 0.0, 0.0, 0.0, 0.0213, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-072', '2026-06-12', 0.3456, 0.4123, 0.0, 0.0, 0.2273, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-073', '2026-06-12', 0.2683, 0.3205, 0.0, 0.0, 0.1766, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-074', '2026-06-12', 0.2506, 0.3468, 0.0, 0.0, 0.1792, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-075', '2026-06-12', 0.1328, 0.1282, 0.0, 0.0, 0.0783, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-076', '2026-06-12', 0.1861, 0.085, 0.0, 0.0, 0.0813, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-077', '2026-06-12', 0.0911, 0.2323, 0.0, 0.0, 0.097, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-078', '2026-06-12', 0.0761, 0.0, 0.0, 0.0, 0.0228, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-079', '2026-06-12', 0.165, 0.1986, 0.0, 0.0, 0.1091, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-080', '2026-06-12', 0.2578, 0.4632, 0.0, 0.0, 0.2163, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-081', '2026-06-12', 0.1672, 0.1964, 0.0, 0.0, 0.1091, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-082', '2026-06-12', 0.1328, 0.0795, 0.0, 0.0, 0.0637, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-083', '2026-06-12', 0.6317, 0.3495, 0.0, 0.0, 0.2944, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-084', '2026-06-12', 0.0, 0.0014, 0.0, 0.0, 0.0004, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-085', '2026-06-12', 0.1683, 0.1327, 0.0, 0.0, 0.0903, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-086', '2026-06-12', 0.145, 0.1405, 0.0, 0.0, 0.0856, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-087', '2026-06-12', 0.3878, 0.5086, 0.0, 0.0, 0.2689, 'Watch', 'NDVI decline + NDMI drop', 'Monitor next processing cycle'),
  ('00000000-0000-0000-0000-000000000002', 'B-088', '2026-06-12', 0.2606, 0.1386, 0.0, 0.0, 0.1198, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-089', '2026-06-12', 0.4761, 0.2368, 0.0, 0.0, 0.2139, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-090', '2026-06-12', 0.2722, 0.2809, 0.0, 0.0, 0.1659, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-091', '2026-06-12', 0.1122, 0.1255, 0.0, 0.0, 0.0713, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-092', '2026-06-12', 0.1461, 0.0582, 0.0, 0.0, 0.0613, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-093', '2026-06-12', 0.2356, 0.1609, 0.0, 0.0, 0.1189, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-094', '2026-06-12', 0.2206, 0.2532, 0.0, 0.0, 0.1421, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-095', '2026-06-12', 0.3256, 0.1282, 0.0, 0.0, 0.1361, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-096', '2026-06-12', 0.1178, 0.2555, 0.0, 0.0, 0.112, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-097', '2026-06-12', 0.0822, 0.1277, 0.0, 0.0, 0.063, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-098', '2026-06-12', 0.17, 0.0441, 0.0, 0.0, 0.0642, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-099', '2026-06-12', 0.0717, 0.0891, 0.0, 0.0, 0.0482, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-100', '2026-06-12', 0.2844, 0.2355, 0.0, 0.0, 0.156, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-101', '2026-06-12', 0.1589, 0.1982, 0.0, 0.0, 0.1071, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-102', '2026-06-12', 0.1411, 0.0491, 0.0, 0.0, 0.0571, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-103', '2026-06-12', 0.0, 0.0932, 0.0, 0.0, 0.028, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-104', '2026-06-12', 0.12, 0.3768, 0.0, 0.0, 0.149, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-105', '2026-06-12', 0.1817, 0.0, 0.0, 0.0, 0.0545, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-106', '2026-06-12', 0.0, 0.0, 0.0, 0.0, 0.0, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-107', '2026-06-12', 0.1378, 0.1405, 0.0, 0.0, 0.0835, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-108', '2026-06-12', 0.1439, 0.2514, 0.0, 0.0, 0.1186, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-109', '2026-06-12', 0.09, 0.0086, 0.0, 0.0, 0.0296, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-110', '2026-06-12', 0.1811, 0.2218, 0.0, 0.0, 0.1209, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-111', '2026-06-12', 0.0, 0.2391, 0.0, 0.0, 0.0717, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-112', '2026-06-12', 0.0, 0.0, 0.0, 0.0, 0.0, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-113', '2026-06-12', 0.0367, 0.0, 0.0, 0.0, 0.011, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-114', '2026-06-12', 0.0578, 0.1191, 0.0, 0.0, 0.0531, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-115', '2026-06-12', 0.0056, 0.1914, 0.0, 0.0, 0.0591, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-116', '2026-06-12', 0.0772, 0.0, 0.0, 0.0, 0.0232, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-117', '2026-06-12', 0.4133, 0.2905, 0.0, 0.0, 0.2111, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-118', '2026-06-12', 0.0, 0.095, 0.0, 0.0, 0.0285, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-119', '2026-06-12', 0.0922, 0.0, 0.0, 0.0, 0.0277, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-120', '2026-06-12', 0.0, 0.0, 0.0, 0.0, 0.0, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-121', '2026-06-12', 0.0806, 0.0205, 0.0, 0.0, 0.0303, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-122', '2026-06-12', 0.0, 0.1236, 0.0, 0.0, 0.0371, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-123', '2026-06-12', 0.3144, 0.0, 0.0, 0.0, 0.0943, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-124', '2026-06-12', 0.3061, 0.2014, 0.0, 0.0, 0.1522, 'Normal', 'NDVI decline + NDMI drop', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-125', '2026-06-12', 0.0, 0.1055, 0.0, 0.0, 0.0316, 'Normal', 'No significant stress signal', 'No urgent action'),
  ('00000000-0000-0000-0000-000000000002', 'B-126', '2026-06-12', 0.0, 0.0, 0.0, 0.0, 0.0, 'Normal', 'No significant stress signal', 'No urgent action');

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
  ('B-006', 1, 'open'),
  ('B-027', 2, 'open'),
  ('B-024', 3, 'open'),
  ('B-020', 4, 'open'),
  ('B-017', 5, 'open'),
  ('B-007', 6, 'open'),
  ('B-083', 7, 'open'),
  ('B-031', 8, 'open'),
  ('B-004', 9, 'open'),
  ('B-087', 10, 'open'),
  ('B-010', 11, 'monitor_only'),
  ('B-072', 12, 'monitor_only'),
  ('B-080', 13, 'monitor_only'),
  ('B-089', 14, 'monitor_only'),
  ('B-117', 15, 'monitor_only'),
  ('B-014', 16, 'monitor_only'),
  ('B-003', 17, 'monitor_only'),
  ('B-013', 18, 'monitor_only'),
  ('B-074', 19, 'monitor_only'),
  ('B-053', 20, 'monitor_only'),
  ('B-073', 21, 'monitor_only'),
  ('B-067', 22, 'monitor_only'),
  ('B-090', 23, 'monitor_only'),
  ('B-044', 24, 'monitor_only'),
  ('B-062', 25, 'monitor_only'),
  ('B-058', 26, 'monitor_only'),
  ('B-100', 27, 'monitor_only'),
  ('B-048', 28, 'monitor_only'),
  ('B-124', 29, 'monitor_only'),
  ('B-066', 30, 'monitor_only'),
  ('B-052', 31, 'monitor_only'),
  ('B-046', 32, 'monitor_only'),
  ('B-104', 33, 'monitor_only'),
  ('B-051', 34, 'monitor_only'),
  ('B-023', 35, 'monitor_only'),
  ('B-030', 36, 'monitor_only'),
  ('B-094', 37, 'monitor_only'),
  ('B-037', 38, 'monitor_only'),
  ('B-065', 39, 'monitor_only'),
  ('B-095', 40, 'monitor_only'),
  ('B-011', 41, 'monitor_only'),
  ('B-059', 42, 'monitor_only'),
  ('B-016', 43, 'monitor_only'),
  ('B-040', 44, 'monitor_only'),
  ('B-045', 45, 'monitor_only'),
  ('B-060', 46, 'monitor_only'),
  ('B-018', 47, 'monitor_only'),
  ('B-110', 48, 'monitor_only'),
  ('B-070', 49, 'monitor_only'),
  ('B-038', 50, 'monitor_only'),
  ('B-088', 51, 'monitor_only'),
  ('B-093', 52, 'monitor_only'),
  ('B-108', 53, 'monitor_only'),
  ('B-001', 54, 'monitor_only'),
  ('B-008', 55, 'monitor_only'),
  ('B-041', 56, 'monitor_only'),
  ('B-047', 57, 'monitor_only'),
  ('B-096', 58, 'monitor_only'),
  ('B-036', 59, 'monitor_only'),
  ('B-079', 60, 'monitor_only'),
  ('B-081', 61, 'monitor_only'),
  ('B-043', 62, 'monitor_only'),
  ('B-101', 63, 'monitor_only'),
  ('B-034', 64, 'monitor_only'),
  ('B-021', 65, 'monitor_only'),
  ('B-077', 66, 'monitor_only'),
  ('B-123', 67, 'monitor_only'),
  ('B-028', 68, 'monitor_only'),
  ('B-035', 69, 'monitor_only'),
  ('B-085', 70, 'monitor_only'),
  ('B-015', 71, 'monitor_only'),
  ('B-039', 72, 'monitor_only'),
  ('B-042', 73, 'monitor_only'),
  ('B-086', 74, 'monitor_only'),
  ('B-107', 75, 'monitor_only'),
  ('B-049', 76, 'monitor_only'),
  ('B-076', 77, 'monitor_only'),
  ('B-054', 78, 'monitor_only'),
  ('B-075', 79, 'monitor_only'),
  ('B-111', 80, 'monitor_only'),
  ('B-091', 81, 'monitor_only'),
  ('B-002', 82, 'monitor_only'),
  ('B-025', 83, 'monitor_only'),
  ('B-098', 84, 'monitor_only'),
  ('B-082', 85, 'monitor_only'),
  ('B-097', 86, 'monitor_only'),
  ('B-092', 87, 'monitor_only'),
  ('B-115', 88, 'monitor_only'),
  ('B-102', 89, 'monitor_only'),
  ('B-032', 90, 'monitor_only'),
  ('B-105', 91, 'monitor_only'),
  ('B-056', 92, 'monitor_only'),
  ('B-114', 93, 'monitor_only'),
  ('B-068', 94, 'monitor_only'),
  ('B-099', 95, 'monitor_only'),
  ('B-069', 96, 'monitor_only'),
  ('B-022', 97, 'monitor_only'),
  ('B-122', 98, 'monitor_only'),
  ('B-029', 99, 'monitor_only'),
  ('B-125', 100, 'monitor_only'),
  ('B-033', 101, 'monitor_only'),
  ('B-009', 102, 'monitor_only'),
  ('B-121', 103, 'monitor_only'),
  ('B-109', 104, 'monitor_only'),
  ('B-118', 105, 'monitor_only'),
  ('B-057', 106, 'monitor_only'),
  ('B-103', 107, 'monitor_only'),
  ('B-119', 108, 'monitor_only'),
  ('B-061', 109, 'monitor_only'),
  ('B-050', 110, 'monitor_only'),
  ('B-064', 111, 'monitor_only'),
  ('B-116', 112, 'monitor_only'),
  ('B-078', 113, 'monitor_only'),
  ('B-063', 114, 'monitor_only'),
  ('B-071', 115, 'monitor_only'),
  ('B-005', 116, 'monitor_only'),
  ('B-012', 117, 'monitor_only'),
  ('B-055', 118, 'monitor_only'),
  ('B-026', 119, 'monitor_only'),
  ('B-113', 120, 'monitor_only'),
  ('B-019', 121, 'monitor_only'),
  ('B-084', 122, 'monitor_only'),
  ('B-106', 123, 'monitor_only'),
  ('B-112', 124, 'monitor_only'),
  ('B-120', 125, 'monitor_only'),
  ('B-126', 126, 'monitor_only')
) as sp (block_id, priority_rank, task_status)
  on sp.block_id = rs.block_id
where rs.processing_run_id = '00000000-0000-0000-0000-000000000002'
order by sp.priority_rank;

commit;
