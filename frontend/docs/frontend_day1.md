# Frontend Day 1 Notes

## Demo Script

This dashboard answers one operational question:

Which oil palm blocks should the field team inspect first today?

The map shows all plantation blocks by official risk category. The left panel ranks blocks by inspection urgency. Selecting the top row highlights the same block on the map and opens its explanation in the detail panel. The field team can submit verification feedback, which can later calibrate thresholds and validate the stress signals.

## Local Data Fallback

The Day 1 frontend uses local demo data first:

- `/public/demo/blocks.geojson`
- `/public/demo/block_indicators_latest.json`
- `/public/demo/risk_scores_latest.json`
- `/public/demo/scouting_priority_latest.json`

The data files were copied from `geospatial/data/demo`. The frontend does not modify the geospatial source directory.

Run `npm run sync:geospatial` from `frontend/` to refresh the local JSON files
and generated map images. The command also runs automatically before
`npm run dev` and `npm run build`.

For the Day 2 jury demo, risk JSON is replaced only when the incoming
geospatial dataset has matching block IDs, at least five blocks in every risk
category, and three urgent top-ranked blocks. Images and block boundaries still
sync when incoming risk data is not jury-ready.

`src/lib/queries.ts` keeps the backend-compatible function names:

- `getLatestBlockRisk(estateId)`
- `getScoutingPriority(estateId)`
- `getBlockDetail(blockId)`
- `submitFieldReport(payload)`

Demo mode is used when `NEXT_PUBLIC_USE_DEMO_DATA=true` or when Supabase public environment variables are missing.

## Supabase Readiness

When backend data is ready, set:

```env
NEXT_PUBLIC_USE_DEMO_DATA=false
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

Never expose `SUPABASE_SERVICE_ROLE_KEY` to the frontend.

The frontend does not depend on `task_status` in `latest_scouting_priority`, because the backend query contract warns that this column may not be present in the view.

## Quality Checklist

- App runs locally.
- Local JSON fallback loads 48 blocks.
- Risk colors use exact official categories: Normal, Watch, Warning, Priority Inspection.
- Priority list is sorted by rank.
- Clicking a priority row updates the selected block.
- Clicking a map block updates the selected block.
- Detail panel shows risk explanation and indicator values.
- Field verification form submits in demo mode.
- Supabase function names are ready for backend credentials.

## Current Architecture Note

`EstateMap.tsx` uses SVG polygons from GeoJSON for block selection and supports
four layers: risk category, Sentinel-2 true color, NDVI, and NDMI. The satellite
images come from `geospatial/data/images`. Satellite, NDVI, and NDMI layers show
the block risk categories as a 50% opacity SVG overlay and retain interactive
block selection.
