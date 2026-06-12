import { createClient } from "@supabase/supabase-js";
import {
  DEMO_ESTATE_ID,
  isDay2JuryReadyRiskData,
  mergeDemoData,
  sortScoutingPriority,
  type BlockFeatureCollection,
  type BlockIndicator,
  type LatestBlockRisk,
  type RiskCategory,
  type RiskScore,
  type ScoutingPriorityRow,
} from "./demoData";

export { DEMO_ESTATE_ID };
export type { LatestBlockRisk, RiskCategory, ScoutingPriorityRow };
export type DataMode = "live" | "demo";
export type DataSourcePreference = "auto" | "live" | "demo";

export type StressConfirmed = "Yes" | "No" | "Unclear";
export type StressType =
  | "Drought"
  | "Waterlogging"
  | "Pest"
  | "Disease"
  | "Fire Risk"
  | "Unknown";
export type Severity = "Low" | "Medium" | "High";

export type FieldReportPayload = {
  block_id: string;
  stress_confirmed: StressConfirmed;
  stress_type: StressType;
  severity: Severity;
  scouting_task_id?: string | null;
  observer_name?: string | null;
  gps_lat?: number | null;
  gps_lng?: number | null;
  soil_condition?: string | null;
  drainage_condition?: string | null;
  notes?: string | null;
  photo_url?: string | null;
};

export type FieldReportRow = FieldReportPayload & {
  id: string;
  observed_at: string;
  created_at: string;
};

const DATA_SOURCE_STORAGE_KEY = "cropstress:data-source";
const FORCE_DEMO_DATA = process.env.NEXT_PUBLIC_USE_DEMO_DATA === "true";
const HAS_SUPABASE_CONFIG = Boolean(
  process.env.NEXT_PUBLIC_SUPABASE_URL &&
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);
let liveUnavailable = FORCE_DEMO_DATA || !HAS_SUPABASE_CONFIG;
let dataSourcePreference: DataSourcePreference = "auto";
let currentDataMode: DataMode = liveUnavailable ? "demo" : "live";

function isDataSourcePreference(value: unknown): value is DataSourcePreference {
  return value === "auto" || value === "live" || value === "demo";
}

function readStoredDataSourcePreference(): DataSourcePreference {
  if (typeof window === "undefined") {
    return dataSourcePreference;
  }

  const storedValue = window.localStorage.getItem(DATA_SOURCE_STORAGE_KEY);
  return isDataSourcePreference(storedValue) ? storedValue : "auto";
}

function getEffectiveDataSourcePreference(): DataSourcePreference {
  dataSourcePreference = readStoredDataSourcePreference();
  return dataSourcePreference;
}

function shouldUseDemoData(): boolean {
  const preference = getEffectiveDataSourcePreference();

  return (
    preference === "demo" ||
    FORCE_DEMO_DATA ||
    !HAS_SUPABASE_CONFIG ||
    (preference === "live" && liveUnavailable) ||
    (preference === "auto" && liveUnavailable)
  );
}

function shouldValidateJuryData(): boolean {
  return getEffectiveDataSourcePreference() !== "live";
}

export function getDataMode(): DataMode {
  return currentDataMode;
}

export function getDataSourcePreference(): DataSourcePreference {
  return getEffectiveDataSourcePreference();
}

export function setDataSourcePreference(preference: DataSourcePreference): void {
  dataSourcePreference = preference;
  liveUnavailable = FORCE_DEMO_DATA || !HAS_SUPABASE_CONFIG;
  currentDataMode = shouldUseDemoData() ? "demo" : "live";

  if (typeof window !== "undefined") {
    window.localStorage.setItem(DATA_SOURCE_STORAGE_KEY, preference);
  }
}

export function getDataSourceStatus() {
  return {
    mode: currentDataMode,
    preference: getDataSourcePreference(),
    hasSupabaseConfig: HAS_SUPABASE_CONFIG,
    forceDemoData: FORCE_DEMO_DATA,
  };
}

function useDemoFallback(error: unknown): void {
  liveUnavailable = true;
  console.warn("Supabase unavailable; using local demo fallback.", error);
}

const LATEST_BLOCK_RISK_COLUMNS = `
  estate_id,
  block_id,
  block_code,
  block_name,
  area_ha,
  geometry,
  observation_date,
  ndvi,
  ndvi_baseline,
  ndvi_anomaly,
  ndmi,
  ndmi_baseline,
  ndmi_anomaly,
  rainfall_30d_mm,
  rainfall_baseline_mm,
  rainfall_deficit_pct,
  hotspot_count_7d,
  nearest_hotspot_km,
  quality_flag,
  score_date,
  vegetation_stress,
  moisture_stress,
  rainfall_stress,
  fire_risk,
  risk_score,
  risk_category,
  dominant_driver,
  recommended_action
`;

const SCOUTING_PRIORITY_COLUMNS = `
  priority_rank,
  estate_id,
  block_id,
  block_code,
  block_name,
  risk_score_id,
  score_date,
  risk_score,
  risk_category,
  dominant_driver,
  recommended_action
`;

type SupabaseClientInstance = ReturnType<typeof createClient>;

let supabaseClient: SupabaseClientInstance | null = null;

function getSupabase(): SupabaseClientInstance {
  if (supabaseClient) {
    return supabaseClient;
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || !anonKey) {
    throw new Error("Missing Supabase public environment variables");
  }

  supabaseClient = createClient(url, anonKey);
  return supabaseClient;
}

async function fetchJson<T>(path: string): Promise<T> {
  const response = await fetch(path);

  if (!response.ok) {
    throw new Error(`Failed to load ${path}`);
  }

  return (await response.json()) as T;
}

async function getDemoBlockRisk(): Promise<LatestBlockRisk[]> {
  const [blocks, indicators, riskScores] = await Promise.all([
    fetchJson<BlockFeatureCollection>("/demo/blocks.geojson"),
    fetchJson<BlockIndicator[]>("/demo/block_indicators_latest.json"),
    fetchJson<RiskScore[]>("/demo/risk_scores_latest.json"),
  ]);

  return mergeDemoData(blocks, indicators, riskScores);
}

async function getDemoScoutingPriority(
  estateId: string
): Promise<ScoutingPriorityRow[]> {
  const [priorityRows, latestRisk] = await Promise.all([
    fetchJson<ScoutingPriorityRow[]>("/demo/scouting_priority_latest.json"),
    getDemoBlockRisk(),
  ]);
  const blocksById = new Map(latestRisk.map((row) => [row.block_id, row]));

  return sortScoutingPriority(
    priorityRows.map((row) => {
      const block = blocksById.get(row.block_id);

      return {
        ...row,
        estate_id: block?.estate_id ?? estateId,
        block_code: block?.block_code ?? row.block_id,
        block_name: block?.block_name ?? null,
      };
    })
  ).filter((row) => row.estate_id === estateId);
}

function createDemoFieldReport(payload: FieldReportPayload): FieldReportRow {
  const now = new Date().toISOString();

  return {
    ...payload,
    id: `demo-report-${Date.now()}`,
    observed_at: now,
    created_at: now,
  };
}

export async function getLatestBlockRisk(
  estateId: string
): Promise<LatestBlockRisk[]> {
  if (shouldUseDemoData()) {
    currentDataMode = "demo";
    return (await getDemoBlockRisk()).filter((row) => row.estate_id === estateId);
  }

  try {
    const { data, error } = await getSupabase()
      .from("latest_block_risk")
      .select(LATEST_BLOCK_RISK_COLUMNS)
      .eq("estate_id", estateId)
      .order("risk_score", { ascending: false });

    if (error) {
      throw error;
    }

    if (!data?.length) {
      throw new Error("Supabase returned no latest block risk rows");
    }

    if (
      shouldValidateJuryData() &&
      !isDay2JuryReadyRiskData(data as unknown as LatestBlockRisk[])
    ) {
      throw new Error("Supabase risk data is not Day 2 jury-ready");
    }

    currentDataMode = "live";
    return data as unknown as LatestBlockRisk[];
  } catch (error) {
    useDemoFallback(error);
    currentDataMode = "demo";
    return (await getDemoBlockRisk()).filter((row) => row.estate_id === estateId);
  }
}

export async function getScoutingPriority(
  estateId: string
): Promise<ScoutingPriorityRow[]> {
  if (shouldUseDemoData()) {
    currentDataMode = "demo";
    return getDemoScoutingPriority(estateId);
  }

  try {
    const { data, error } = await getSupabase()
      .from("latest_scouting_priority")
      .select(SCOUTING_PRIORITY_COLUMNS)
      .eq("estate_id", estateId)
      .order("risk_score", { ascending: false });

    if (error) {
      throw error;
    }

    if (!data?.length) {
      throw new Error("Supabase returned no scouting priority rows");
    }

    if (
      shouldValidateJuryData() &&
      !isDay2JuryReadyRiskData(data as unknown as ScoutingPriorityRow[])
    ) {
      throw new Error("Supabase scouting data is not Day 2 jury-ready");
    }

    currentDataMode = "live";
    return sortScoutingPriority(data as unknown as ScoutingPriorityRow[]);
  } catch (error) {
    useDemoFallback(error);
    currentDataMode = "demo";
    return getDemoScoutingPriority(estateId);
  }
}

export async function getBlockDetail(blockId: string): Promise<LatestBlockRisk> {
  if (shouldUseDemoData()) {
    currentDataMode = "demo";
    const block = (await getDemoBlockRisk()).find((row) => row.block_id === blockId);

    if (!block) {
      throw new Error(`Block not found: ${blockId}`);
    }

    return block;
  }

  try {
    const { data, error } = await getSupabase()
      .from("latest_block_risk")
      .select(LATEST_BLOCK_RISK_COLUMNS)
      .eq("block_id", blockId)
      .maybeSingle();

    if (error) {
      throw error;
    }

    if (!data) {
      throw new Error(`Block not found: ${blockId}`);
    }

    currentDataMode = "live";
    return data as unknown as LatestBlockRisk;
  } catch (error) {
    useDemoFallback(error);
    currentDataMode = "demo";
    const block = (await getDemoBlockRisk()).find((row) => row.block_id === blockId);

    if (!block) {
      throw new Error(`Block not found: ${blockId}`);
    }

    return block;
  }
}

export async function submitFieldReport(
  payload: FieldReportPayload
): Promise<FieldReportRow> {
  if (shouldUseDemoData()) {
    currentDataMode = "demo";
    return createDemoFieldReport(payload);
  }

  const insertPayload = {
    block_id: payload.block_id,
    scouting_task_id: payload.scouting_task_id ?? null,
    observer_name: payload.observer_name ?? null,
    gps_lat: payload.gps_lat ?? null,
    gps_lng: payload.gps_lng ?? null,
    stress_confirmed: payload.stress_confirmed,
    stress_type: payload.stress_type,
    severity: payload.severity,
    soil_condition: payload.soil_condition ?? null,
    drainage_condition: payload.drainage_condition ?? null,
    notes: payload.notes ?? null,
    photo_url: payload.photo_url ?? null,
  };

  try {
    const { data, error } = await getSupabase()
      .from("field_reports")
      .insert(insertPayload as never)
      .select()
      .single();

    if (error) {
      throw error;
    }

    if (!data) {
      throw new Error("Field report insert returned no row");
    }

    currentDataMode = "live";
    return data as unknown as FieldReportRow;
  } catch (error) {
    useDemoFallback(error);
    currentDataMode = "demo";
    return createDemoFieldReport(payload);
  }
}
