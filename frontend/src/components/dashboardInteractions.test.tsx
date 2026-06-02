import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { BlockDetailPanel } from "./BlockDetailPanel";
import { FieldVerificationForm } from "./FieldVerificationForm";
import { ScoutingPriorityList } from "./ScoutingPriorityList";
import type { LatestBlockRisk, ScoutingPriorityRow } from "@/lib/queries";

const block: LatestBlockRisk = {
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

const priorityRows: ScoutingPriorityRow[] = [
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
];

describe("dashboard components", () => {
  it("renders priority columns and selects a row", async () => {
    const onSelectBlock = vi.fn();
    const user = userEvent.setup();

    render(
      <ScoutingPriorityList
        rows={priorityRows}
        selectedBlockId="B-001"
        onSelectBlock={onSelectBlock}
      />
    );

    expect(screen.getByText("Rank")).toBeTruthy();
    expect(screen.getByText("Block")).toBeTruthy();
    expect(screen.getByText("Risk")).toBeTruthy();
    expect(screen.getByText("Driver")).toBeTruthy();
    expect(screen.getByText("Action")).toBeTruthy();

    await user.click(screen.getByRole("button", { name: /select B-041/i }));

    expect(onSelectBlock).toHaveBeenCalledWith("B-041");
  });

  it("shows required block detail labels", () => {
    render(<BlockDetailPanel block={block} />);

    expect(screen.getByText("Block code")).toBeTruthy();
    expect(screen.getByText("Risk category")).toBeTruthy();
    expect(screen.getByText("Risk score")).toBeTruthy();
    expect(screen.getByText("Dominant driver")).toBeTruthy();
    expect(screen.getByText("Recommended action")).toBeTruthy();
    expect(screen.getByText("NDVI value")).toBeTruthy();
    expect(screen.getByText("NDMI value")).toBeTruthy();
    expect(screen.getByText("Rainfall deficit")).toBeTruthy();
    expect(screen.getByText("Nearest hotspot distance")).toBeTruthy();
    expect(screen.getByText("Quality flag")).toBeTruthy();
  });

  it("submits a field verification payload", async () => {
    const onSubmit = vi.fn(async () => undefined);
    const user = userEvent.setup();

    render(<FieldVerificationForm block={block} onSubmit={onSubmit} />);

    await user.type(screen.getByLabelText("Observer name"), "Mira");
    await user.click(screen.getByLabelText("Yes"));
    await user.selectOptions(screen.getByLabelText("Stress type"), "Drought");
    await user.selectOptions(screen.getByLabelText("Severity"), "High");
    await user.type(screen.getByLabelText("Soil condition"), "Dry topsoil");
    await user.type(screen.getByLabelText("Drainage condition"), "Normal");
    await user.type(screen.getByLabelText("Field note"), "Inspect tomorrow");
    await user.click(screen.getByRole("button", { name: "Submit" }));

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith(
        expect.objectContaining({
          block_id: "B-041",
          observer_name: "Mira",
          stress_confirmed: "Yes",
          stress_type: "Drought",
          severity: "High",
          soil_condition: "Dry topsoil",
          drainage_condition: "Normal",
          notes: "Inspect tomorrow",
        })
      );
    });
  });
});
