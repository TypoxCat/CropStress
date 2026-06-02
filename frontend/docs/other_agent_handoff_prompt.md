# Handoff Prompt For Backend/Geospatial Owner

You are helping CropStress Insight reach the Day 1 dashboard goal: a manager opens the frontend and immediately sees which plantation blocks need field inspection first.

Please check the backend/geospatial side for these requirements:

1. Keep these files stable or regenerate them with the same field names:
   - `geospatial/data/demo/blocks.geojson`
   - `geospatial/data/demo/block_indicators_latest.json`
   - `geospatial/data/demo/risk_scores_latest.json`
   - `geospatial/data/demo/scouting_priority_latest.json`

2. Confirm each file links by `block_id`. The frontend merges block geometry, indicators, risk scores, and scouting priority through that field.

3. Keep risk category names exactly:
   - `Normal`
   - `Watch`
   - `Warning`
   - `Priority Inspection`

4. Confirm Supabase views expose the frontend contract:
   - `latest_block_risk`: geometry, block identity, indicators, risk score, risk category, dominant driver, recommended action.
   - `latest_scouting_priority`: priority rank, estate id, block id, score date, risk score, risk category, dominant driver, recommended action.
   - `field_reports`: accepts observer name, stress confirmation, stress type, severity, soil condition, drainage condition, notes, and optional photo URL.

5. Resolve or confirm the `task_status` mismatch. The database docs mention it, but the frontend contract warns not to depend on it unless the view exposes it. The Day 1 UI does not require `task_status`, so either expose it consistently or leave it out of the frontend contract.

6. Provide only browser-safe Supabase values to frontend:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

Do not provide `SUPABASE_SERVICE_ROLE_KEY` to the frontend.

Desired result: the frontend can switch from local JSON fallback to Supabase without component changes, only by setting environment variables and keeping the query contract stable.
