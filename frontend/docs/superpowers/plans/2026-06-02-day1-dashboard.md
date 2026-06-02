# Day 1 Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a working CropStress Insight Day 1 frontend dashboard inside `frontend`.

**Architecture:** Scaffold a Next.js TypeScript app with Tailwind, local demo data fallback, and focused components for the map, priority list, block detail, and field verification form. Keep Supabase integration behind `src/lib/queries.ts` so the demo works without backend credentials.

**Tech Stack:** Next.js, React, TypeScript, Tailwind CSS, MapLibre GL JS target architecture, Vitest/Testing Library for behavior tests.

---

## File Structure

- Create `frontend/package.json`: scripts and dependencies.
- Create `frontend/tsconfig.json`, `frontend/next.config.ts`, `frontend/postcss.config.mjs`, `frontend/tailwind.config.ts`: app configuration.
- Create `frontend/src/app/layout.tsx`, `frontend/src/app/page.tsx`, `frontend/src/app/globals.css`: app shell and dashboard.
- Create `frontend/src/components/EstateMap.tsx`: block map and selected block interactions.
- Create `frontend/src/components/ScoutingPriorityList.tsx`: ranked list.
- Create `frontend/src/components/BlockDetailPanel.tsx`: selected block explanation.
- Create `frontend/src/components/FieldVerificationForm.tsx`: field feedback capture.
- Create `frontend/src/components/RiskBadge.tsx`: risk category presentation.
- Create `frontend/src/lib/riskColors.ts`: official category names and color helpers.
- Create `frontend/src/lib/demoData.ts`: local data types, data merge, metrics, and sorting.
- Create `frontend/src/lib/queries.ts`: local-first query contract with Supabase-ready names.
- Copy demo data into `frontend/public/demo`.
- Create focused tests under `frontend/src/**/*.test.ts(x)`.
- Create `frontend/docs/frontend_day1.md`: demo notes and integration status.

## Tasks

### Task 1: Scaffold Frontend App

**Files:**
- Create: `frontend/package.json`
- Create: `frontend/tsconfig.json`
- Create: `frontend/next.config.ts`
- Create: `frontend/postcss.config.mjs`
- Create: `frontend/tailwind.config.ts`
- Create: `frontend/src/app/layout.tsx`
- Create: `frontend/src/app/globals.css`

- [ ] **Step 1: Create project configuration**

Write package scripts for `dev`, `build`, `test`, and `lint`. Include Next.js, React, Tailwind, MapLibre GL, Supabase, Vitest, jsdom, and Testing Library dependencies.

- [ ] **Step 2: Create app shell**

Add a root layout with `CropStress Insight` metadata and import `globals.css`.

- [ ] **Step 3: Verify scaffold**

Run: `npm install`

Expected: dependencies install and `package-lock.json` is created inside `frontend`.

### Task 2: Add Demo Data And Data Utilities

**Files:**
- Copy: `geospatial/data/demo/*.json` to `frontend/public/demo`
- Copy: `geospatial/data/demo/blocks.geojson` to `frontend/public/demo/blocks.geojson`
- Create: `frontend/src/lib/riskColors.ts`
- Create: `frontend/src/lib/demoData.ts`
- Test: `frontend/src/lib/demoData.test.ts`

- [ ] **Step 1: Write failing tests**

Test that official category colors exist, demo rows merge by `block_id`, metrics include all four categories, and scouting priority sorts by `priority_rank`.

- [ ] **Step 2: Run tests to verify failure**

Run: `npm test -- src/lib/demoData.test.ts`

Expected: FAIL because utilities do not exist yet.

- [ ] **Step 3: Implement utilities**

Define `RiskCategory`, `RISK_CATEGORIES`, `getRiskColor`, `mergeDemoData`, `getEstateMetrics`, and `sortScoutingPriority`.

- [ ] **Step 4: Run tests to verify pass**

Run: `npm test -- src/lib/demoData.test.ts`

Expected: PASS.

### Task 3: Add Query Contract

**Files:**
- Create: `frontend/src/lib/queries.ts`
- Test: `frontend/src/lib/queries.test.ts`

- [ ] **Step 1: Write failing tests**

Test that `getLatestBlockRisk("estate_demo_01")` returns merged block data and `getScoutingPriority("estate_demo_01")` returns rows ordered by rank.

- [ ] **Step 2: Run tests to verify failure**

Run: `npm test -- src/lib/queries.test.ts`

Expected: FAIL because query functions do not exist yet.

- [ ] **Step 3: Implement local-first query functions**

Use browser `fetch` against `/demo/*.json` for runtime and static imports or file fixtures for testable logic where needed. Include `submitFieldReport` demo behavior returning a generated local row.

- [ ] **Step 4: Run tests to verify pass**

Run: `npm test -- src/lib/queries.test.ts`

Expected: PASS.

### Task 4: Build Dashboard Components

**Files:**
- Create: `frontend/src/components/RiskBadge.tsx`
- Create: `frontend/src/components/EstateMap.tsx`
- Create: `frontend/src/components/ScoutingPriorityList.tsx`
- Create: `frontend/src/components/BlockDetailPanel.tsx`
- Create: `frontend/src/components/FieldVerificationForm.tsx`
- Test: `frontend/src/components/dashboardInteractions.test.tsx`

- [ ] **Step 1: Write failing component tests**

Test that the priority list renders rank/block/risk/driver/action, clicking a row calls `onSelectBlock`, block detail displays required labels, and field form submits a payload.

- [ ] **Step 2: Run tests to verify failure**

Run: `npm test -- src/components/dashboardInteractions.test.tsx`

Expected: FAIL because components do not exist yet.

- [ ] **Step 3: Implement components**

Build accessible, compact components using Tailwind. Keep the map component robust by rendering an SVG block map from GeoJSON coordinates if MapLibre is not practical during Day 1.

- [ ] **Step 4: Run tests to verify pass**

Run: `npm test -- src/components/dashboardInteractions.test.tsx`

Expected: PASS.

### Task 5: Assemble Page And Documentation

**Files:**
- Create: `frontend/src/app/page.tsx`
- Create: `frontend/docs/frontend_day1.md`

- [ ] **Step 1: Implement page**

Load latest risk and priority data, select the first priority block by default, show overview metrics, map, priority list, detail panel, and verification form.

- [ ] **Step 2: Write frontend demo docs**

Document local data fallback, Supabase readiness, demo script, and verification checklist in `frontend/docs/frontend_day1.md`.

- [ ] **Step 3: Run full verification**

Run:

```bash
npm test
npm run build
```

Expected: tests pass and Next.js build succeeds.

### Task 6: Handoff Prompt

**Files:**
- Create: `frontend/docs/other_agent_handoff_prompt.md`

- [ ] **Step 1: Write handoff prompt**

Create a concise prompt for backend/geospatial owners explaining what needs to stay stable or change to support the desired dashboard goal.

- [ ] **Step 2: Verify docs exist**

Run: `find frontend/docs -maxdepth 3 -type f`

Expected: includes design, plan, frontend Day 1 notes, and handoff prompt.

## Self-Review

Spec coverage: the plan covers the required four sections, local JSON fallback, backend query contract alignment, copied geospatial demo data, Supabase readiness, tests, docs, and final handoff prompt.

Placeholder scan: no task relies on undefined future requirements.

Type consistency: tasks use the same `RiskCategory`, `LatestBlockRisk`, `ScoutingPriorityRow`, and field report concepts from the approved design.
