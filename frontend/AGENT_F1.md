AGENT.md - Day 1 - Frontend and Demo Experience Agent
Role
You own the dashboard, user flow, map experience, and demo clarity.
Your job is to make the MVP understandable within 30 seconds.
Mission
By the end of Day 1, deliver a working dashboard shell that shows:
Plantation blocks on a map.
Risk colors per block.
A ranked scouting priority list.
A block detail panel.
A field verification form.
A clean demo flow.
The dashboard may use local JSON first. Replace with Supabase when backend data is ready.
Day 1 Scope
Must Do
Build four screens or sections:
Estate Overview
Scouting Priority List
Block Detail
Field Verification Form
Optional
Only do these if the must-do items are done:
PDF export mock button.
CSV export.
Landing page.
Login page.
Animation.
Dark mode.
Recommended Stack
Use:
Next.js
React
TypeScript
Tailwind CSS
MapLibre GL JS
TanStack Query
Supabase client

If MapLibre takes too long, use a simpler map library temporarily. But keep the final architecture note as MapLibre.
Required Files
Create these files or equivalent:
/src/app/page.tsx
/src/components/EstateMap.tsx
/src/components/ScoutingPriorityList.tsx
/src/components/BlockDetailPanel.tsx
/src/components/FieldVerificationForm.tsx
/src/components/RiskBadge.tsx
/src/lib/riskColors.ts
/src/lib/demoData.ts
/src/lib/queries.ts
/public/demo/blocks.geojson
/public/demo/risk_scores_latest.json
/docs/frontend_day1.md

Main User Flow
The demo must follow this story:
Manager opens dashboard.
Manager sees risky blocks on map.
Manager sees ranked scouting priority list.
Manager clicks the highest-risk block.
Manager sees why the block is risky.
Manager submits field verification feedback.

Visual Rules
Use clear risk colors:
Normal = green
Watch = yellow
Warning = orange
Priority Inspection = red

Use exact category names:
Normal
Watch
Warning
Priority Inspection

Do not rename categories.
Dashboard Layout
Create this layout:
Top Bar:
CropStress Insight | Demo Estate | Last processed date

Left Panel:
Scouting Priority List

Main Area:
Block Risk Map

Right Panel:
Selected Block Detail

Bottom or Modal:
Field Verification Form

Estate Overview Metrics
Show these cards:
Total Blocks
Priority Inspection
Warning
Watch
Normal
Last Processed

Block Detail Panel
When a block is selected, show:
Block code
Risk category
Risk score
Dominant driver
Recommended action
NDVI value
NDMI value
Rainfall deficit
Nearest hotspot distance
Quality flag

Use simple labels. The jury should not need technical explanation to understand it.
Scouting Priority List Columns
Use these columns:
Rank
Block
Risk
Driver
Action

Clicking a row must select the block on the map.
Field Verification Form
Fields:
Observer name
Stress confirmed: Yes / No / Unclear
Stress type: Drought / Waterlogging / Pest / Disease / Fire Risk / Unknown
Severity: Low / Medium / High
Soil condition
Drainage condition
Field note
Photo upload placeholder
Submit

On Day 1, photo upload can be a placeholder. But the form must feel real.
Data Loading Strategy
Use this order:
Load from local JSON first.
Switch to Supabase when backend is ready.
Keep local JSON fallback for demo safety.
Create a fallback like:
const USE_DEMO_DATA = process.env.NEXT_PUBLIC_USE_DEMO_DATA === "true";

Hour-by-Hour Work Plan
Hour 0-1
Join architecture sync.
Confirm data contract.
Confirm exact field names with backend and geospatial agents.
Sketch final dashboard layout.
Hour 1-3
Create Next.js project.
Install Tailwind.
Create base layout.
Create placeholder components.
Add demo title and metric cards.
Hour 3-5
Render blocks from local GeoJSON.
Apply risk colors.
Add map legend.
Make block click update selected block state.
Hour 5-7
Build scouting priority list.
Sort blocks by risk score.
Connect row click to selected block.
Build block detail panel.
Hour 7-8
Integration sync.
Check whether backend data is available.
If not, continue with local JSON fallback.
Hour 8-10
Add field verification form.
If Supabase insert is ready, connect submit.
If not ready, save locally and show success message.
Hour 10-12
Polish spacing, labels, and demo copy.
Add loading states.
Add empty states.
Write /docs/frontend_day1.md.
Day 1 Demo Script
Prepare this script inside the app or notes:
This dashboard answers one operational question:
Which oil palm blocks should the field team inspect first today?

The map shows all plantation blocks by risk category.
The left panel ranks blocks by inspection urgency.
When we click the top block, the system explains the dominant stress driver.
The field team can submit verification feedback, which will later calibrate thresholds.

Quality Checklist
Before ending Day 1, confirm:
App runs locally.
Map renders blocks.
Risk colors appear correctly.
Priority list is sorted.
Clicking a block updates detail panel.
Clicking a list row updates map selection.
Field form opens and submits.
Local JSON fallback works.
Supabase integration is started or ready.
UI is clean enough for a jury preview.
Do Not Do
Do not build login on Day 1.
Do not overdesign animations.
Do not wait for perfect backend data.
Do not create more than four screens.
Do not hide the priority list. It is the main product.
Do not use vague labels like “high risk” without the official category name.

