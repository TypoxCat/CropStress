# Frontend Day 2 Implementation

## Jury Story

The dashboard now opens with the operational question:

> Which blocks should the field team inspect first today?

The highest-risk block is selected automatically and repeated in the
`Inspect first` callout. The priority list is ordered by `risk_score`
descending, and the selected block panel explains the dominant driver and
recommended action.

## Data Modes

- **Live Supabase** is used when browser-safe credentials are configured and
  queries succeed with Day 2 jury-ready data.
- **Synthetic demo fallback** is used when credentials are missing or any live
  query fails, returns empty data, or returns a stale Normal-only distribution.

The fallback dataset uses the repository's existing deterministic synthetic
generator and unchanged risk formula/thresholds. Its distribution is:

| Category | Blocks |
| --- | ---: |
| Normal | 26 |
| Watch | 7 |
| Warning | 7 |
| Priority Inspection | 8 |

The top three blocks are all `Priority Inspection`.

`npm run sync:geospatial` validates Agent A output before replacing the jury
fallback. It requires matching IDs, at least five blocks in each category, and
three urgent top-ranked blocks. Images and block boundaries still sync when
risk data fails that validation.

## Day 2 Coverage

- Polygon and MultiPolygon map rendering.
- Interactive risk, Satellite, NDVI, and NDMI layers.
- 50% risk overlay on all satellite imagery.
- Risk-score-first scouting priority ranking.
- Dynamic block detail with NDVI, NDMI, rainfall deficit, hotspot count, and
  nearest hotspot distance.
- Field verification modal and standalone route.
- Automatic local fallback for reads and field-report submission.
- Metric cards for total blocks, every category, and last processed date.

## Verification

Run from `frontend/`:

```bash
npm test
npm run build
```

The Day 2 regression tests validate category distribution, matching IDs,
urgent top-three ranking, MultiPolygon selection, imagery risk overlay, field
submission, and automatic live-query fallback.
