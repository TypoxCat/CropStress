import { readFileSync } from "node:fs";
import { join } from "node:path";
import { beforeEach, describe, expect, it, vi } from "vitest";
import {
  DEMO_ESTATE_ID,
  getBlockDetail,
  getLatestBlockRisk,
  getScoutingPriority,
  submitFieldReport,
} from "./queries";

const demoPath = (...parts: string[]) =>
  join(process.cwd(), "public", "demo", ...parts);

function readDemoJson(fileName: string) {
  return JSON.parse(readFileSync(demoPath(fileName), "utf8"));
}

describe("query contract", () => {
  beforeEach(() => {
    vi.restoreAllMocks();

    vi.stubGlobal(
      "fetch",
      vi.fn(async (url: string | URL | Request) => {
        const path = String(url);
        const fileName = path.split("/").pop();

        if (!fileName) {
          throw new Error(`Unexpected URL: ${path}`);
        }

        return {
          ok: true,
          json: async () => readDemoJson(fileName),
        } as Response;
      })
    );
  });

  it("returns merged latest block risk rows for the demo estate", async () => {
    const rows = await getLatestBlockRisk(DEMO_ESTATE_ID);

    expect(rows.length).toBeGreaterThan(0);
    expect(rows[0].estate_id).toBe(DEMO_ESTATE_ID);
    expect(rows.find((row) => row.block_id === "B-041")?.risk_category).toBeTruthy();
  });

  it("returns scouting priority rows ordered by risk score", async () => {
    const rows = await getScoutingPriority(DEMO_ESTATE_ID);

    expect(rows[0].priority_rank).toBe(1);
    expect(rows[0].risk_score).toBeGreaterThanOrEqual(rows[1].risk_score);
  });

  it("returns a single block detail from latest risk rows", async () => {
    const block = await getBlockDetail("B-001");

    expect(block.block_code).toBe("B-001");
    expect(block.ndvi).toBeTypeOf("number");
  });

  it("submits a demo field report without requiring Supabase", async () => {
    const row = await submitFieldReport({
      block_id: "B-041",
      observer_name: "Mira",
      stress_confirmed: "Yes",
      stress_type: "Drought",
      severity: "Medium",
      soil_condition: "Dry surface",
      drainage_condition: "Normal",
      notes: "Check again in 48 hours",
    });

    expect(row.id).toMatch(/^demo-report-/);
    expect(row.block_id).toBe("B-041");
    expect(row.observer_name).toBe("Mira");
    expect(row.created_at).toBeTruthy();
  });
});
