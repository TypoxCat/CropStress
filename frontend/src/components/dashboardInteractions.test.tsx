import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { BlockDetailPanel } from "./BlockDetailPanel";
import { EstateMap } from "./EstateMap";
import { FieldVerificationForm } from "./FieldVerificationForm";
import { RiskBadge } from "./RiskBadge";
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
  it("keeps the risk explanation tooltip inside the viewport", async () => {
    const user = userEvent.setup();
    const originalInnerWidth = window.innerWidth;

    Object.defineProperty(window, "innerWidth", {
      configurable: true,
      value: 320,
    });

    render(<RiskBadge category="Watch" score={0.2592} />);

    const badge = screen.getByLabelText(/Watch risk/i);
    vi.spyOn(badge, "getBoundingClientRect").mockReturnValue({
      bottom: 40,
      height: 24,
      left: 290,
      right: 320,
      top: 16,
      width: 30,
      x: 290,
      y: 16,
      toJSON: () => ({}),
    });

    await user.hover(badge);

    const tooltip = await screen.findByRole("tooltip");
    expect(tooltip.style.left).toBe("20px");

    Object.defineProperty(window, "innerWidth", {
      configurable: true,
      value: originalInnerWidth,
    });
  });

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
    expect(
      screen.getByLabelText(/Watch risk.*score range 0.25-0.44/i)
    ).toBeTruthy();
    expect(
      screen.getByLabelText(/30% vegetation.*25% rainfall/i)
    ).toBeTruthy();

    await user.click(screen.getByRole("button", { name: /select B-041/i }));

    expect(onSelectBlock).toHaveBeenCalledWith("B-041");
  });

  it("shows required block detail labels", () => {
    render(<BlockDetailPanel block={block} />);

    expect(screen.getByText("Block code")).toBeTruthy();
    expect(screen.getByText("Risk category")).toBeTruthy();
    expect(screen.getAllByLabelText(/Watch risk/i).length).toBeGreaterThan(0);
    expect(screen.getByText("Risk score")).toBeTruthy();
    expect(screen.getByText("Dominant driver")).toBeTruthy();
    expect(screen.getByText("Recommended action")).toBeTruthy();
    expect(screen.getByText("NDVI value")).toBeTruthy();
    expect(screen.getByText("NDMI value")).toBeTruthy();
    expect(screen.getByText("Hotspots (7d)")).toBeTruthy();
    expect(screen.getByText("Rainfall deficit")).toBeTruthy();
    expect(screen.getByText("Nearest hotspot distance")).toBeTruthy();
    expect(screen.getByText("Quality flag")).toBeTruthy();
  });

  it("switches from risk polygons to generated satellite imagery", async () => {
    const user = userEvent.setup();
    const onSelectBlock = vi.fn();
    const blockWithGeometry: LatestBlockRisk = {
      ...block,
      observation_date: "2026-06-05",
      geometry: {
        type: "Polygon",
        coordinates: [
          [
            [101.38, -0.52],
            [101.39, -0.52],
            [101.39, -0.51],
            [101.38, -0.51],
            [101.38, -0.52],
          ],
        ],
      },
    };

    const { container } = render(
      <EstateMap
        blocks={[blockWithGeometry]}
        selectedBlockId={blockWithGeometry.block_id}
        onSelectBlock={onSelectBlock}
      />
    );

    await user.click(screen.getByRole("button", { name: "NDVI" }));

    expect(screen.getByLabelText("NDVI estate map")).toBeTruthy();
    expect(container.querySelector("image")?.getAttribute("href")).toBe(
      "/geospatial/ndvi_map_2026-06-05.png"
    );
    expect(
      container
        .querySelector('polygon[data-risk-overlay="true"]')
        ?.getAttribute("opacity")
    ).toBe("0.5");
    expect(screen.getByText("NDVI satellite index · Risk overlay 50%")).toBeTruthy();

    await user.click(screen.getByRole("button", { name: "Select B-041" }));
    expect(onSelectBlock).toHaveBeenCalledWith("B-041");
  });

  it("renders and selects every part of a MultiPolygon block", async () => {
    const onSelectBlock = vi.fn();
    const user = userEvent.setup();
    const multiPolygonBlock: LatestBlockRisk = {
      ...block,
      geometry: {
        type: "MultiPolygon",
        coordinates: [
          [
            [
              [101.38, -0.52],
              [101.39, -0.52],
              [101.39, -0.51],
              [101.38, -0.51],
              [101.38, -0.52],
            ],
          ],
          [
            [
              [101.4, -0.5],
              [101.41, -0.5],
              [101.41, -0.49],
              [101.4, -0.49],
              [101.4, -0.5],
            ],
          ],
        ],
      },
    };

    const { container } = render(
      <EstateMap
        blocks={[multiPolygonBlock]}
        selectedBlockId={multiPolygonBlock.block_id}
        onSelectBlock={onSelectBlock}
      />
    );

    expect(
      container.querySelectorAll('polygon[data-risk-overlay="true"]')
    ).toHaveLength(2);

    await user.click(
      screen.getByRole("button", { name: "Select B-041 part 2" })
    );
    expect(onSelectBlock).toHaveBeenCalledWith("B-041");
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
