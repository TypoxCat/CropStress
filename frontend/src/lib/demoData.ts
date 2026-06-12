import {
  RISK_CATEGORIES,
  getRiskColor,
  isRiskCategory,
  type RiskCategory,
} from "./riskColors";

export { RISK_CATEGORIES, getRiskColor };
export type { RiskCategory };

export const DEMO_ESTATE_ID = "estate_demo_01";

export type BlockGeometry = {
  type: string;
  coordinates: unknown;
};

export type BlockFeature = {
  type: "Feature";
  properties: {
    block_id: string;
    block_code: string;
    block_name?: string | null;
    estate_id: string;
    area_ha?: number | null;
  };
  geometry: BlockGeometry | null;
};

export type BlockFeatureCollection = {
  type: "FeatureCollection";
  properties?: {
    estate_id?: string;
    estate_name?: string;
  };
  features: BlockFeature[];
};

export type BlockIndicator = {
  block_id: string;
  observation_date: string | null;
  ndvi: number | null;
  ndvi_baseline: number | null;
  ndvi_anomaly: number | null;
  ndmi: number | null;
  ndmi_baseline: number | null;
  ndmi_anomaly: number | null;
  rainfall_30d_mm: number | null;
  rainfall_baseline_mm: number | null;
  rainfall_deficit_pct: number | null;
  hotspot_count_7d: number | null;
  nearest_hotspot_km: number | null;
  quality_flag: string | null;
};

export type RiskScore = {
  block_id: string;
  score_date: string | null;
  vegetation_stress: number | null;
  moisture_stress: number | null;
  rainfall_stress: number | null;
  fire_risk: number | null;
  risk_score: number | null;
  risk_category: RiskCategory | string | null;
  dominant_driver: string | null;
  recommended_action: string | null;
};

export type LatestBlockRisk = BlockIndicator &
  RiskScore & {
    estate_id: string;
    block_code: string;
    block_name: string | null;
    area_ha: number | null;
    geometry: BlockGeometry | null;
  };

export type ScoutingPriorityRow = {
  priority_rank: number;
  estate_id?: string;
  block_id: string;
  block_code?: string;
  block_name?: string | null;
  risk_score_id?: string;
  score_date: string | null;
  risk_score: number | null;
  risk_category: RiskCategory | string | null;
  dominant_driver: string | null;
  recommended_action: string | null;
};

export type EstateMetrics = {
  totalBlocks: number;
  categoryCounts: Record<RiskCategory, number>;
  lastProcessed: string;
};

const EMPTY_INDICATOR: Omit<BlockIndicator, "block_id"> = {
  observation_date: null,
  ndvi: null,
  ndvi_baseline: null,
  ndvi_anomaly: null,
  ndmi: null,
  ndmi_baseline: null,
  ndmi_anomaly: null,
  rainfall_30d_mm: null,
  rainfall_baseline_mm: null,
  rainfall_deficit_pct: null,
  hotspot_count_7d: null,
  nearest_hotspot_km: null,
  quality_flag: null,
};

const EMPTY_RISK: Omit<RiskScore, "block_id"> = {
  score_date: null,
  vegetation_stress: null,
  moisture_stress: null,
  rainfall_stress: null,
  fire_risk: null,
  risk_score: null,
  risk_category: "Normal",
  dominant_driver: null,
  recommended_action: null,
};

export function mergeDemoData(
  blocks: BlockFeatureCollection,
  indicators: BlockIndicator[],
  riskScores: RiskScore[]
): LatestBlockRisk[] {
  const indicatorsByBlock = new Map(
    indicators.map((indicator) => [indicator.block_id, indicator])
  );
  const riskByBlock = new Map(riskScores.map((risk) => [risk.block_id, risk]));

  return blocks.features.map((feature) => {
    const blockId = feature.properties.block_id;
    const indicator = indicatorsByBlock.get(blockId) ?? {
      block_id: blockId,
      ...EMPTY_INDICATOR,
    };
    const risk = riskByBlock.get(blockId) ?? {
      block_id: blockId,
      ...EMPTY_RISK,
    };

    return {
      ...indicator,
      ...risk,
      estate_id: feature.properties.estate_id,
      block_id: blockId,
      block_code: feature.properties.block_code,
      block_name: feature.properties.block_name ?? null,
      area_ha: feature.properties.area_ha ?? null,
      geometry: feature.geometry,
    };
  });
}

export function getEstateMetrics(blocks: LatestBlockRisk[]): EstateMetrics {
  const categoryCounts = RISK_CATEGORIES.reduce(
    (counts, category) => ({ ...counts, [category]: 0 }),
    {} as Record<RiskCategory, number>
  );

  let lastProcessed = "";

  for (const block of blocks) {
    const category = isRiskCategory(block.risk_category)
      ? block.risk_category
      : "Normal";
    categoryCounts[category] += 1;

    const date = block.score_date ?? block.observation_date ?? "";
    if (date > lastProcessed) {
      lastProcessed = date;
    }
  }

  return {
    totalBlocks: blocks.length,
    categoryCounts,
    lastProcessed: lastProcessed || "Unavailable",
  };
}

export function isDay2JuryReadyRiskData(
  rows: Pick<RiskScore, "block_id" | "risk_category" | "risk_score">[]
): boolean {
  const uniqueIds = new Set(rows.map((row) => row.block_id));
  const categoryCounts = RISK_CATEGORIES.reduce(
    (counts, category) => ({ ...counts, [category]: 0 }),
    {} as Record<RiskCategory, number>
  );

  for (const row of rows) {
    if (isRiskCategory(row.risk_category)) {
      categoryCounts[row.risk_category] += 1;
    }
  }

  const topThree = [...rows]
    .sort((left, right) => (right.risk_score ?? -1) - (left.risk_score ?? -1))
    .slice(0, 3);

  return (
    uniqueIds.size === rows.length &&
    RISK_CATEGORIES.every((category) => categoryCounts[category] >= 5) &&
    topThree.length === 3 &&
    topThree.every((row) =>
      ["Warning", "Priority Inspection"].includes(row.risk_category ?? "")
    )
  );
}

export function sortScoutingPriority<T extends ScoutingPriorityRow>(
  rows: T[]
): T[] {
  return [...rows]
    .sort((left, right) => {
      const scoreDifference =
        (right.risk_score ?? -1) - (left.risk_score ?? -1);

      if (scoreDifference !== 0) {
        return scoreDifference;
      }

      return left.block_id.localeCompare(right.block_id);
    })
    .map((row, index) => ({ ...row, priority_rank: index + 1 }));
}
