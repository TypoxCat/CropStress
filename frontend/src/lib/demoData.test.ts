import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import {
  RISK_CATEGORIES,
  getEstateMetrics,
  getRiskColor,
  mergeDemoData,
  sortScoutingPriority,
} from "./demoData";

const demoPath = (...parts: string[]) =>
  join(process.cwd(), "public", "demo", ...parts);

const blocksGeojson = JSON.parse(
  readFileSync(demoPath("blocks.geojson"), "utf8")
);
const indicators = JSON.parse(
  readFileSync(demoPath("block_indicators_latest.json"), "utf8")
);
const riskScores = JSON.parse(
  readFileSync(demoPath("risk_scores_latest.json"), "utf8")
);
const priorityRows = JSON.parse(
  readFileSync(demoPath("scouting_priority_latest.json"), "utf8")
);

describe("demo data utilities", () => {
  it("defines exact official risk categories and colors", () => {
    expect(RISK_CATEGORIES).toEqual([
      "Normal",
      "Watch",
      "Warning",
      "Priority Inspection",
    ]);

    expect(getRiskColor("Normal").label).toBe("Normal");
    expect(getRiskColor("Watch").hex).toMatch(/^#/);
    expect(getRiskColor("Warning").label).toBe("Warning");
    expect(getRiskColor("Priority Inspection").label).toBe(
      "Priority Inspection"
    );
  });

  it("merges GeoJSON blocks with indicators and risk scores by block_id", () => {
    const rows = mergeDemoData(blocksGeojson, indicators, riskScores);
    const first = rows.find((row) => row.block_id === "B-001");

    expect(rows).toHaveLength(48);
    expect(first?.block_code).toBe("B-001");
    expect(first?.geometry?.type).toBe("Polygon");
    expect(first?.ndvi).toBeTypeOf("number");
    expect(first?.risk_category).toBe("Normal");
    expect(first?.dominant_driver).toContain("rainfall");
  });

  it("keeps metrics for all official categories even when counts are zero", () => {
    const rows = mergeDemoData(blocksGeojson, indicators, riskScores);
    const metrics = getEstateMetrics(rows);

    expect(metrics.totalBlocks).toBe(48);
    expect(metrics.categoryCounts.Normal).toBeGreaterThan(0);
    expect(metrics.categoryCounts.Watch).toBeGreaterThanOrEqual(0);
    expect(metrics.categoryCounts.Warning).toBeGreaterThanOrEqual(0);
    expect(metrics.categoryCounts["Priority Inspection"]).toBeGreaterThanOrEqual(
      0
    );
    expect(metrics.lastProcessed).toBe("2026-06-05");
  });

  it("sorts scouting priorities by priority rank", () => {
    const sorted = sortScoutingPriority(priorityRows);

    expect(sorted[0].priority_rank).toBe(1);
    expect(sorted[0].block_id).toBe("B-041");
    expect(sorted[1].priority_rank).toBe(2);
  });
});
