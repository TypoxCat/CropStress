import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import {
  RISK_CATEGORIES,
  getEstateMetrics,
  getRiskColor,
  isDay2JuryReadyRiskData,
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
    expect(first?.risk_category).toBe("Priority Inspection");
    expect(first?.dominant_driver).toContain("rainfall");

    const blockIds = new Set(
      blocksGeojson.features.map(
        (feature: { properties: { block_id: string } }) =>
          feature.properties.block_id
      )
    );
    expect(indicators.every((row: { block_id: string }) => blockIds.has(row.block_id))).toBe(
      true
    );
    expect(riskScores.every((row: { block_id: string }) => blockIds.has(row.block_id))).toBe(
      true
    );
    expect(priorityRows.every((row: { block_id: string }) => blockIds.has(row.block_id))).toBe(
      true
    );
    expect(isDay2JuryReadyRiskData(riskScores)).toBe(true);
    expect(isDay2JuryReadyRiskData(riskScores.slice(0, 3))).toBe(false);
  });

  it("keeps at least five blocks in every category for the jury story", () => {
    const rows = mergeDemoData(blocksGeojson, indicators, riskScores);
    const metrics = getEstateMetrics(rows);

    expect(metrics.totalBlocks).toBe(48);
    for (const category of RISK_CATEGORIES) {
      expect(metrics.categoryCounts[category]).toBeGreaterThanOrEqual(5);
    }
    expect(metrics.lastProcessed).toBe("2026-06-05");
  });

  it("sorts scouting priorities by risk score and reranks them", () => {
    const sorted = sortScoutingPriority(priorityRows);

    expect(sorted[0].priority_rank).toBe(1);
    expect(sorted[0].block_id).toBe("B-037");
    expect(sorted[1].priority_rank).toBe(2);
    expect(sorted[0].risk_score).toBeGreaterThanOrEqual(sorted[1].risk_score);
    expect(
      sorted.slice(0, 3).every((row) =>
        ["Warning", "Priority Inspection"].includes(row.risk_category)
      )
    ).toBe(true);
  });
});
