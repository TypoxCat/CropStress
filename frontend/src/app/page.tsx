"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { BlockDetailPanel } from "@/components/BlockDetailPanel";
import { DeveloperMenu } from "@/components/DeveloperMenu";
import { EstateMap } from "@/components/EstateMap";
import { FieldVerificationForm } from "@/components/FieldVerificationForm";
import { ScoutingPriorityList } from "@/components/ScoutingPriorityList";
import { RiskBadge } from "@/components/RiskBadge";
import { getEstateMetrics } from "@/lib/demoData";
import {
  DEMO_ESTATE_ID,
  getDataMode,
  getDataSourceStatus,
  getLatestBlockRisk,
  getScoutingPriority,
  setDataSourcePreference,
  submitFieldReport,
  type DataMode,
  type DataSourcePreference,
  type FieldReportPayload,
  type LatestBlockRisk,
  type ScoutingPriorityRow,
} from "@/lib/queries";

type LoadState = "loading" | "ready" | "error";

const METRIC_CATEGORIES = [
  "Priority Inspection",
  "Warning",
  "Watch",
  "Normal",
] as const;

function MetricCard({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="border-r border-crop-line bg-white px-4 py-3 last:border-r-0">
      <div className="text-xs uppercase text-slate-500">{label}</div>
      <div className="mt-1 text-lg font-semibold text-crop-ink">{value}</div>
    </div>
  );
}

export default function Page() {
  const [loadState, setLoadState] = useState<LoadState>("loading");
  const [blocks, setBlocks] = useState<LatestBlockRisk[]>([]);
  const [priorityRows, setPriorityRows] = useState<ScoutingPriorityRow[]>([]);
  const [selectedBlockId, setSelectedBlockId] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [showFieldVerification, setShowFieldVerification] = useState(false);
  const [dataMode, setDataMode] = useState<DataMode>("demo");
  const [dataSourcePreference, setDataSourcePreferenceState] =
    useState<DataSourcePreference>("auto");
  const [hasSupabaseConfig, setHasSupabaseConfig] = useState(false);
  const [forceDemoData, setForceDemoData] = useState(false);
  const [submissionMessage, setSubmissionMessage] = useState<string | null>(null);

  const refreshDashboard = useCallback(
    async (isActive: () => boolean = () => true) => {
      try {
        setLoadState("loading");
        setErrorMessage(null);
        const initialDataMode = getDataMode();
        let latestRisk = await getLatestBlockRisk(DEMO_ESTATE_ID);
        let priority = await getScoutingPriority(DEMO_ESTATE_ID);

        if (initialDataMode === "live" && getDataMode() === "demo") {
          [latestRisk, priority] = await Promise.all([
            getLatestBlockRisk(DEMO_ESTATE_ID),
            getScoutingPriority(DEMO_ESTATE_ID),
          ]);
        }

        if (!isActive()) {
          return;
        }

        const status = getDataSourceStatus();

        setBlocks(latestRisk);
        setPriorityRows(priority);
        setSelectedBlockId(priority[0]?.block_id ?? latestRisk[0]?.block_id ?? null);
        setDataMode(status.mode);
        setDataSourcePreferenceState(status.preference);
        setHasSupabaseConfig(status.hasSupabaseConfig);
        setForceDemoData(status.forceDemoData);
        setLoadState("ready");
      } catch (error) {
        if (!isActive()) {
          return;
        }

        setErrorMessage(
          error instanceof Error ? error.message : "Dashboard data failed to load"
        );
        setLoadState("error");
      }
    },
    []
  );

  useEffect(() => {
    let active = true;

    refreshDashboard(() => active);

    return () => {
      active = false;
    };
  }, [refreshDashboard]);

  const selectedBlock = useMemo(
    () => blocks.find((block) => block.block_id === selectedBlockId) ?? null,
    [blocks, selectedBlockId]
  );
  const metrics = useMemo(() => getEstateMetrics(blocks), [blocks]);
  const topPriority = priorityRows[0] ?? null;

  async function handleFieldSubmit(payload: FieldReportPayload) {
    await submitFieldReport(payload);
    const status = getDataSourceStatus();
    setDataMode(status.mode);
    setDataSourcePreferenceState(status.preference);
    setHasSupabaseConfig(status.hasSupabaseConfig);
    setForceDemoData(status.forceDemoData);
    setSubmissionMessage(
      status.mode === "live"
        ? "Field verification saved to Supabase."
        : "Field verification saved in demo mode."
    );
    setShowFieldVerification(false);
  }

  async function handleDataSourcePreferenceChange(
    preference: DataSourcePreference
  ) {
    setDataSourcePreference(preference);
    setDataSourcePreferenceState(preference);
    await refreshDashboard();
  }

  return (
    <main className="min-h-screen bg-[#eef3ed] text-crop-ink">
      <div className="sticky top-0 z-10 shadow-sm">
        <header className="flex flex-wrap items-center justify-between gap-3 border-b border-crop-line bg-white px-5 py-4">
          <div>
            <h1 className="text-xl font-bold">CropStress Insight</h1>
            <p className="text-sm text-slate-600">
              Which blocks should the field team inspect first today?
            </p>
          </div>
          <div className="flex items-center gap-4 text-right text-sm">
            <span
              className={`rounded-full px-3 py-1 text-xs font-semibold ${
                dataMode === "live"
                  ? "bg-emerald-100 text-emerald-800"
                  : "bg-amber-100 text-amber-900"
              }`}
            >
              {dataMode === "live" ? "Live Supabase" : "Synthetic demo fallback"}
            </span>
            <div>
              <div className="text-slate-500">Last processed date</div>
              <div className="font-semibold">{metrics.lastProcessed}</div>
            </div>
          </div>
        </header>

        <section className="grid border-b border-crop-line sm:grid-cols-2 lg:grid-cols-6">
          <MetricCard label="Total Blocks" value={metrics.totalBlocks} />
          {METRIC_CATEGORIES.map((category) => (
            <MetricCard
              key={category}
              label={category}
              value={
                <span className="inline-flex items-center gap-2">
                  {metrics.categoryCounts[category]}
                  <RiskBadge category={category} />
                </span>
              }
            />
          ))}
          <MetricCard label="Last Processed" value={metrics.lastProcessed} />
        </section>
      </div>

      {loadState === "error" ? (
        <section className="m-5 border border-red-300 bg-red-50 p-4 text-red-800">
          {errorMessage}
        </section>
      ) : null}

      {loadState === "loading" ? (
        <section className="m-5 border border-crop-line bg-white p-4">
          Loading dashboard data...
        </section>
      ) : null}

      {submissionMessage ? (
        <div className="fixed right-4 top-4 z-[60] flex items-center gap-3 rounded border border-emerald-300 bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-900 shadow-lg">
          {submissionMessage}
          <button
            aria-label="Dismiss submission message"
            className="font-bold text-emerald-700"
            type="button"
            onClick={() => setSubmissionMessage(null)}
          >
            Close
          </button>
        </div>
      ) : null}

      {topPriority ? (
        <section className="flex flex-wrap items-center justify-between gap-3 border-b border-red-200 bg-red-50 px-5 py-3 text-sm">
          <div>
            <span className="font-bold text-red-800">Inspect first: </span>
            <button
              className="font-bold text-red-900 underline decoration-red-300 underline-offset-2"
              type="button"
              onClick={() => setSelectedBlockId(topPriority.block_id)}
            >
              {topPriority.block_code ?? topPriority.block_id}
            </button>
            <span className="ml-2 text-red-800">
              {topPriority.dominant_driver ?? "Stress signal detected"}
            </span>
          </div>
          <span className="font-semibold text-red-900">
            {topPriority.recommended_action}
          </span>
        </section>
      ) : null}

      <section className="grid min-h-[42rem] gap-px bg-crop-line lg:h-[calc(100vh-13rem)] lg:grid-cols-[minmax(20rem,28rem)_1fr_minmax(20rem,26rem)]">
        <div className="overflow-y-auto bg-white">
          <ScoutingPriorityList
            rows={priorityRows}
            selectedBlockId={selectedBlockId}
            onSelectBlock={setSelectedBlockId}
          />
        </div>
        <EstateMap
          blocks={blocks}
          selectedBlockId={selectedBlockId}
          onSelectBlock={setSelectedBlockId}
        />
        <div className="overflow-y-auto bg-white">
          <BlockDetailPanel
            block={selectedBlock}
            onVerifyField={() => setShowFieldVerification(true)}
          />
        </div>
      </section>

      {showFieldVerification ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
          <div className="flex max-h-[90vh] w-full max-w-4xl flex-col overflow-hidden rounded-lg bg-white shadow-lg">
            <div className="flex items-center justify-between border-b border-crop-line px-6 py-4">
              <h2 className="text-lg font-bold">Field Verification</h2>
              <button
                aria-label="Close field verification"
                className="text-sm font-semibold text-slate-500 hover:text-slate-700"
                type="button"
                onClick={() => setShowFieldVerification(false)}
              >
                Close
              </button>
            </div>
            <div className="min-h-0 flex-1 overflow-y-auto p-6">
              <FieldVerificationForm
                block={selectedBlock}
                onSubmit={handleFieldSubmit}
              />
            </div>
          </div>
        </div>
      ) : null}

      <DeveloperMenu
        dataMode={dataMode}
        forceDemoData={forceDemoData}
        hasSupabaseConfig={hasSupabaseConfig}
        preference={dataSourcePreference}
        onPreferenceChange={handleDataSourcePreferenceChange}
      />
    </main>
  );
}
