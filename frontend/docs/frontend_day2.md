Here’s a detailed Day 2 plan for Agent C – Frontend/Demo, scoped for the jury-ready MVP:

AGENT_C_DAY2.md – CropStress Insight MVP
Role
Agent C is responsible for dashboard rendering, UI interactions, and jury-ready demo presentation. Your job is to make the regenerated data from Agent A and live queries from Agent B visible and actionable in the frontend.

Primary Objectives – Day 2
Display the updated demo data with correct risk distribution (≥5 per category).
Ensure the map shows all blocks with correct risk colors.
Ensure the priority list ranks blocks correctly by risk_score and top 3 blocks reflect Warning/Priority Inspection.
Ensure block detail panel explains dominant driver and recommended action.
Verify field verification form submission works with Supabase live insert or local fallback.
Maintain local JSON fallback for reliability.
Polish dashboard story and visuals for jury demo impact.

Required Outputs
Component
Purpose
Notes
EstateMap.tsx
Render blocks on map
Use SVG initially; MapLibre optional for full interactivity
ScoutingPriorityList.tsx
Show ranked blocks
Sorted by risk_score descending
BlockDetailPanel.tsx
Show selected block info
Include risk score, category, driver, recommended action, NDVI, NDMI, Rainfall deficit, hotspot
FieldVerificationForm.tsx
Collect field input
Should insert into Supabase or simulate locally
RiskBadge.tsx
Show risk colors
Green=Normal, Yellow=Watch, Orange=Warning, Red=Priority Inspection
demoData.ts
Local JSON fallback
Ensure fallback works when Supabase unavailable
queries.ts
Live query wrapper
Frontend functions: getLatestBlockRisk(), getScoutingPriority(), getBlockDetail(), submitFieldReport()


Detailed Tasks
1. Integrate regenerated data
Pull Day 2 JSON data from Agent A.
Verify all four risk categories are represented.
Ensure IDs match blocks.geojson.
Confirm top 3 priority blocks reflect true high-risk scores.
2. Map Rendering
Render block polygons with correct risk colors.
Ensure map supports:
Selecting a block
Highlighting selected block
Updating the block detail panel
Ensure map geometry supports Polygons and MultiPolygons.
3. Scouting Priority List
Sort blocks by risk_score descending.
Ensure top blocks are Warning or Priority Inspection.
Clicking a row selects the corresponding block on the map.
4. Block Detail Panel
Display:
Block code
Risk category & risk score
Dominant driver
Recommended action
NDVI, NDMI, rainfall deficit
Nearest hotspot
Update dynamically when block selected from map or list.
5. Field Verification Form
Ensure all required fields exist:
Observer name
Stress confirmed: Yes/No/Unclear
Stress type: Drought/Waterlogging/Pest/Disease/Fire Risk/Unknown
Severity: Low/Medium/High
Soil condition
Drainage condition
Notes
Photo upload (placeholder accepted)
Test submission:
Live Supabase insert if available
Local JSON fallback if Supabase fails
6. Query Integration
Ensure frontend functions match Agent B live queries:
getLatestBlockRisk(estateId)
getScoutingPriority(estateId)
getBlockDetail(blockId)
submitFieldReport(payload)
Local JSON fallback must be used automatically if Supabase fails.
7. Demo Polish
Ensure dashboard tells the jury story clearly:
Top-risk block visually obvious
Dominant driver explanation
Scouting priority actionable
Confirm UX and layout:
Map and list visible simultaneously
Detail panel updates correctly
Field form submission flow intuitive
Add metric cards:
Total Blocks
Priority Inspection
Warning
Watch
Normal
Last Processed
8. Verification & Testing
Open npm run dev and confirm:
Map renders all blocks
Risk colors correct
Priority list sorted
Block detail updates on selection
Field form submits (real or fallback)
Check top 3 priority blocks correspond to regenerated Warning/Priority Inspection blocks.

Notes for Jury Demo
Priority story must be compelling: top-risk blocks should look and feel urgent.
Avoid showing Normal-only or single-category data.
Map, list, and detail panel should be immediately understandable without explanation.
Use local JSON fallback as a safety net in case live Supabase has delays.

Constraints
Do not add new dashboards, authentication, SMS/WhatsApp integration, ML models, or yield prediction.
Keep risk categories, formula, and thresholds unchanged.
Ignore directory structure; assume paths to frontend/public/demo are correct.

Success Criteria for Day 2
Dashboard renders all blocks with correct risk colors.
Scouting priority list correctly ranked and top 3 blocks are high-risk.
Block detail panel explains dominant driver and action.
Field verification form works (live or fallback).
Demo story is coherent and jury-ready.
Local JSON fallback is functional.

This ensures Agent C has a fully scoped, detailed, Day 2 plan, aligned with Agent A regenerated data and Agent B Supabase backend.
After executing this plan, the MVP vertical slice should be jury-ready, supporting the “risky blocks first” story with clear actionable outputs.

