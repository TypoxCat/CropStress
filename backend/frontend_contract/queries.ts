/**
 * CropStress Insight Day 2 — Supabase query contract.
 *
 * Copy into a Next.js app as `src/lib/queries.ts` when Agent C creates the frontend.
 *
 * Required package:
 *   npm install @supabase/supabase-js
 *
 * Required public env vars:
 *   NEXT_PUBLIC_SUPABASE_URL
 *   NEXT_PUBLIC_SUPABASE_ANON_KEY
 *
 * Never expose:
 *   SUPABASE_SERVICE_ROLE_KEY
 */

import { createClient } from "@supabase/supabase-js";

/**
 * Demo estate id used in Day 2 seed data.
 */
export const DEMO_ESTATE_ID = "estate_demo_01";

export type RiskCategory =
  | "Normal"
  | "Watch"
  | "Warning"
  | "Priority Inspection";

export type StressConfirmed = "Yes" | "No" | "Unclear";

export type StressType =
  | "Drought"
  | "Waterlogging"
  | "Pest"
  | "Disease"
  | "Fire Risk"
  | "Unknown";

export type Severity = "Low" | "Medium" | "High";

/**
 * GeoJSON geometry returned by latest_block_risk.geometry.
 * The database view should return this using:
 * ST_AsGeoJSON(geometry)::json
 */
export type BlockGeometry = {
  type: string;
  coordinates: unknown;
};

export type LatestBlockRisk = {
  estate_id: string;
  block_id: string;
  block_code: string;
  block_name: string | null;
  area_ha: number | null;
  geometry: BlockGeometry | null;

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

export type ScoutingPriorityRow = {
  priority_rank: number;
  estate_id: string;
  block_id: string;
  block_code: string;
  block_name: string | null;
  risk_score_id: string;
  scouting_task_id: string | null;
  score_date: string;
  risk_score: number | null;
  risk_category: RiskCategory | string | null;
  dominant_driver: string | null;
  recommended_action: string | null;
  task_status: string | null;
};

/**
 * Payload sent by frontend field verification form.
 */
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

/**
 * Row returned after inserting a field report.
 */
export type FieldReportRow = FieldReportPayload & {
  id: string;
  observed_at: string;
  created_at: string;
};

/**
 * Columns from the latest_block_risk view.
 */
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

/**
 * Columns from the latest_scouting_priority view.
 *
 * Important:
 * Do not include task_status here unless your Supabase view actually exposes it.
 */
const SCOUTING_PRIORITY_COLUMNS = `
  priority_rank,
  estate_id,
  block_id,
  block_code,
  block_name,
  risk_score_id,
  scouting_task_id,
  score_date,
  risk_score,
  risk_category,
  dominant_driver,
  recommended_action,
  task_status
`;

type SupabaseClientInstance = ReturnType<typeof createClient>;

let supabaseClient: SupabaseClientInstance | null = null;

function getSupabase(): SupabaseClientInstance {
  if (supabaseClient) {
    return supabaseClient;
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url) {
    throw new Error("Missing NEXT_PUBLIC_SUPABASE_URL");
  }

  if (!anonKey) {
    throw new Error("Missing NEXT_PUBLIC_SUPABASE_ANON_KEY");
  }

  supabaseClient = createClient(url, anonKey);
  return supabaseClient;
}

function assertNoError(error: unknown): void {
  if (error) {
    throw error;
  }
}

/**
 * Get all blocks for an estate with latest indicators, risk score, and GeoJSON geometry.
 *
 * Used by:
 * - estate map
 * - map popup
 * - block coloring
 */
export async function getLatestBlockRisk(
  estateId: string
): Promise<LatestBlockRisk[]> {
  const { data, error } = await getSupabase()
    .from("latest_block_risk")
    .select(LATEST_BLOCK_RISK_COLUMNS)
    .eq("estate_id", estateId)
    .order("risk_score", { ascending: false });

  assertNoError(error);

  return (data ?? []) as unknown as LatestBlockRisk[];
}

/**
 * Get scouting priority list for an estate.
 *
 * Rank 1 means highest inspection priority.
 */
export async function getScoutingPriority(
  estateId: string
): Promise<ScoutingPriorityRow[]> {
  const { data, error } = await getSupabase()
    .from("latest_scouting_priority")
    .select(SCOUTING_PRIORITY_COLUMNS)
    .eq("estate_id", estateId)
    .order("priority_rank", { ascending: true });

  assertNoError(error);

  return (data ?? []) as unknown as ScoutingPriorityRow[];
}

/**
 * Get a single block detail.
 *
 * Used by:
 * - block detail page
 * - map popup detail
 */
export async function getBlockDetail(blockId: string): Promise<LatestBlockRisk> {
  const { data, error } = await getSupabase()
    .from("latest_block_risk")
    .select(LATEST_BLOCK_RISK_COLUMNS)
    .eq("block_id", blockId)
    .maybeSingle();

  assertNoError(error);

  if (!data) {
    throw new Error(`Block not found: ${blockId}`);
  }

  return data as unknown as LatestBlockRisk;
}

/**
 * Submit a field verification report from the dashboard.
 *
 * Used by:
 * - field verification form
 * - future threshold calibration workflow
 */
export async function submitFieldReport(
    payload: FieldReportPayload
  ): Promise<FieldReportRow> {
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
  
    const { data, error } = await getSupabase()
      .from("field_reports")
      .insert(insertPayload as never)
      .select()
      .single();
  
    assertNoError(error);
  
    if (!data) {
      throw new Error("Field report insert returned no row");
    }
  
    return data as unknown as FieldReportRow;
  }