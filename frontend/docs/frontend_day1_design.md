# Frontend Day 1 Design

## Goal

Build a Day 1 demo dashboard that answers one operational question within 30 seconds: which oil palm blocks should the field team inspect first today?

## Scope

The frontend will live entirely inside `frontend`. It will not modify `backend`, `geospatial`, root docs, or shared repository configuration. It will read and integrate outputs from those folders by copying compatible demo data and adapting the backend query contract into the frontend.

The dashboard must include:

- Estate Overview
- Scouting Priority List
- Block Detail
- Field Verification Form

Optional features such as login, landing page, dark mode, export, and animation are out of scope unless the required dashboard is complete.

## Architecture

The app will be a single-page Next.js dashboard at `src/app/page.tsx`. The layout will use a top bar, left priority list, central block map, right detail panel, and bottom verification form. The first screen will show operational state rather than marketing content.

Local JSON is the primary Day 1 data source. The app will copy these generated files into `frontend/public/demo`:

- `geospatial/data/demo/blocks.geojson`
- `geospatial/data/demo/risk_scores_latest.json`
- `geospatial/data/demo/block_indicators_latest.json`
- `geospatial/data/demo/scouting_priority_latest.json`

The query layer will adapt `backend/frontend_contract/queries.ts` and expose stable functions:

- `getLatestBlockRisk(estateId)`
- `getScoutingPriority(estateId)`
- `getBlockDetail(blockId)`
- `submitFieldReport(payload)`

`NEXT_PUBLIC_USE_DEMO_DATA === "true"` will force local data. Local data remains the fallback if Supabase environment variables are not configured.

## Integration Notes

The backend contract defines the Supabase shape for `latest_block_risk`, `latest_scouting_priority`, and `field_reports`. The frontend should reuse the type names and payload names where practical so switching from local JSON to Supabase is contained in `src/lib/queries.ts`.

The geospatial data already has the required Day 1 files. `scouting_priority_latest.json` includes `task_status`, but the backend frontend contract intentionally warns not to depend on that field unless the Supabase view exposes it. The UI will not require `task_status`.

The current generated risk distribution may contain mostly `Normal` blocks and a small number of `Watch` blocks. The UI will still render all required official categories in metrics and legend:

- Normal
- Watch
- Warning
- Priority Inspection

## Components

`src/components/EstateMap.tsx` renders the estate blocks from GeoJSON, colors each block by official risk category, and supports block selection. MapLibre GL JS is the target library. If MapLibre setup becomes too slow for the demo environment, the component may use an SVG polygon map as a temporary implementation while keeping the same component API.

`src/components/ScoutingPriorityList.tsx` renders rank, block, risk, driver, and action. Rows are sorted by `priority_rank` when available and by `risk_score` as fallback. Clicking a row selects the block.

`src/components/BlockDetailPanel.tsx` shows block code, risk category, risk score, dominant driver, recommended action, NDVI, NDMI, rainfall deficit, nearest hotspot distance, and quality flag.

`src/components/FieldVerificationForm.tsx` captures observer name, stress confirmation, stress type, severity, soil condition, drainage condition, field note, and a photo upload placeholder. Submit stores locally in demo mode and shows a success state.

`src/components/RiskBadge.tsx` and `src/lib/riskColors.ts` enforce exact official category names and colors.

## Testing And Verification

Tests should cover:

- risk color/category mapping
- local data merge from GeoJSON, indicators, and scores
- scouting priority sorting
- selected block updates from list clicks
- field report submit state

Final verification must include:

- install succeeds
- tests pass
- app builds or runs locally
- dashboard renders with copied demo data

## Handoff Needs For Other Owners

Backend should confirm whether `latest_scouting_priority` exposes `task_status`. If it does, the frontend can optionally display it later. If not, no change is needed because the Day 1 UI does not depend on it.

Backend should also confirm Supabase URL and anon key when ready. The frontend must never receive or use `SUPABASE_SERVICE_ROLE_KEY`.

Geospatial should keep producing the four Day 1 demo files with stable field names. If risk thresholds change, the frontend does not need code changes as long as `risk_category` remains one of the official category names.
