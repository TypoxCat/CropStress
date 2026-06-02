"use client";

import { useEffect, useMemo, useState } from "react";
import { BlockDetailPanel } from "@/components/BlockDetailPanel";
import { EstateMap } from "@/components/EstateMap";
import { FieldVerificationForm } from "@/components/FieldVerificationForm";
import { ScoutingPriorityList } from "@/components/ScoutingPriorityList";
import { RiskBadge } from "@/components/RiskBadge";
import { getEstateMetrics, RISK_CATEGORIES } from "@/lib/demoData";
import {
  DEMO_ESTATE_ID,
  getLatestBlockRisk,
  getScoutingPriority,
  submitFieldReport,
  type FieldReportPayload,
  type LatestBlockRisk,
  type ScoutingPriorityRow,
} from "@/lib/queries";

type LoadState = "loading" | "ready" | "error";

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

  useEffect(() => {
    let active = true;

    async function loadDashboard() {
      try {
        const [latestRisk, priority] = await Promise.all([
          getLatestBlockRisk(DEMO_ESTATE_ID),
          getScoutingPriority(DEMO_ESTATE_ID),
        ]);

        if (!active) {
          return;
        }

        setBlocks(latestRisk);
        setPriorityRows(priority);
        setSelectedBlockId(priority[0]?.block_id ?? latestRisk[0]?.block_id ?? null);
        setLoadState("ready");
      } catch (error) {
        if (!active) {
          return;
        }

        setErrorMessage(
          error instanceof Error ? error.message : "Dashboard data failed to load"
        );
        setLoadState("error");
      }
    }

    loadDashboard();

    return () => {
      active = false;
    };
  }, []);

  const selectedBlock = useMemo(
    () => blocks.find((block) => block.block_id === selectedBlockId) ?? null,
    [blocks, selectedBlockId]
  );
  const metrics = useMemo(() => getEstateMetrics(blocks), [blocks]);

  async function handleFieldSubmit(payload: FieldReportPayload) {
    await submitFieldReport(payload);
  }

  return (
    <main className="min-h-screen bg-[#eef3ed] text-crop-ink">
      <header className="flex flex-wrap items-center justify-between gap-3 border-b border-crop-line bg-white px-5 py-4">
        <div>
          <h1 className="text-xl font-bold">CropStress Insight</h1>
          <p className="text-sm text-slate-600">Demo Estate</p>
        </div>
        <div className="text-right text-sm">
          <div className="text-slate-500">Last processed date</div>
          <div className="font-semibold">{metrics.lastProcessed}</div>
        </div>
      </header>

      <section className="grid border-b border-crop-line sm:grid-cols-2 lg:grid-cols-6">
        <MetricCard label="Total Blocks" value={metrics.totalBlocks} />
        {RISK_CATEGORIES.map((category) => (
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

      <section className="grid min-h-[34rem] gap-px bg-crop-line lg:grid-cols-[minmax(20rem,28rem)_1fr_minmax(20rem,26rem)]">
        <div className="min-h-[24rem] bg-white">
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
        <div className="bg-white">
          <BlockDetailPanel block={selectedBlock} />
        </div>
      </section>

      <FieldVerificationForm block={selectedBlock} onSubmit={handleFieldSubmit} />
    </main>
  );
}
