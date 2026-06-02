import { render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import Page from "./page";

vi.mock("@/lib/queries", async () => {
  const block = {
    estate_id: "estate_demo_01",
    block_id: "B-041",
    block_code: "B-041",
    block_name: "Block B-041",
    area_ha: 198.4,
    geometry: null,
    observation_date: "2026-05-30",
    ndvi: 0.72,
    ndvi_baseline: 0.75,
    ndvi_anomaly: -0.03,
    ndmi: 0.18,
    ndmi_baseline: 0.24,
    ndmi_anomaly: -0.06,
    rainfall_30d_mm: 379.96,
    rainfall_baseline_mm: 556.68,
    rainfall_deficit_pct: 31.75,
    hotspot_count_7d: 0,
    nearest_hotspot_km: null,
    quality_flag: "real_satellite_valid",
    score_date: "2026-05-30",
    vegetation_stress: 0.1,
    moisture_stress: 0.4,
    rainfall_stress: 0.5,
    fire_risk: 0,
    risk_score: 0.2592,
    risk_category: "Watch",
    dominant_driver: "NDMI drop + rainfall deficit",
    recommended_action: "Monitor next processing cycle",
  };

  return {
    DEMO_ESTATE_ID: "estate_demo_01",
    getLatestBlockRisk: vi.fn(async () => [block]),
    getScoutingPriority: vi.fn(async () => [
      {
        priority_rank: 1,
        estate_id: "estate_demo_01",
        block_id: "B-041",
        block_code: "B-041",
        block_name: "Block B-041",
        score_date: "2026-05-30",
        risk_score: 0.2592,
        risk_category: "Watch",
        dominant_driver: "NDMI drop + rainfall deficit",
        recommended_action: "Monitor next processing cycle",
      },
    ]),
    submitFieldReport: vi.fn(async () => ({
      id: "demo-report-1",
      block_id: "B-041",
      stress_confirmed: "Unclear",
      stress_type: "Unknown",
      severity: "Medium",
      created_at: "2026-06-02T00:00:00.000Z",
      observed_at: "2026-06-02T00:00:00.000Z",
    })),
  };
});

describe("dashboard page", () => {
  it("renders the Day 1 dashboard shell from query data", async () => {
    render(<Page />);

    await waitFor(() => {
      expect(screen.getByText("CropStress Insight")).toBeTruthy();
    });

    expect(screen.getByText("Demo Estate")).toBeTruthy();
    expect(screen.getByText("Scouting Priority List")).toBeTruthy();
    expect(screen.getByText("Block Risk Map")).toBeTruthy();
    expect(screen.getByText("Selected Block Detail")).toBeTruthy();
    expect(screen.getByText("Field Verification Form")).toBeTruthy();
    expect(screen.getByText("Last processed date")).toBeTruthy();
  });
});
