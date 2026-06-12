import { RiskBadge } from "./RiskBadge";
import type { LatestBlockRisk } from "@/lib/queries";

type BlockDetailPanelProps = {
  block: LatestBlockRisk | null;
  onVerifyField?: () => void;
};

function formatNumber(value: number | null, digits = 2): string {
  if (value === null || Number.isNaN(value)) {
    return "Unavailable";
  }

  return value.toFixed(digits);
}

function DetailRow({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="grid grid-cols-[8rem_1fr] gap-3 border-b border-crop-line py-2 text-sm">
      <dt className="text-slate-500">{label}</dt>
      <dd className="font-medium text-crop-ink">{value}</dd>
    </div>
  );
}

export function BlockDetailPanel({ block, onVerifyField }: BlockDetailPanelProps) {
  if (!block) {
    return (
      <section className="p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
          Selected Block Detail
        </h2>
        <p className="mt-3 text-sm text-slate-600">Select a block to inspect.</p>
      </section>
    );
  }

  return (
    <section className="p-4">
      <div className="rounded-lg bg-crop-ink p-4 text-white">
        <p className="text-xs font-semibold uppercase tracking-wider text-emerald-100">
          Selected inspection target
        </p>
        <div className="mt-2 flex items-center justify-between gap-3">
          <h2 className="text-2xl font-bold">{block.block_code}</h2>
          <RiskBadge
            category={block.risk_category}
            dominantDriver={block.dominant_driver}
            recommendedAction={block.recommended_action}
            score={block.risk_score}
          />
        </div>
        <p className="mt-3 text-sm text-emerald-50">
          {block.recommended_action ?? "No action recommended"}
        </p>
      </div>
      <dl className="mt-3">
        <DetailRow label="Block code" value={block.block_code} />
        <DetailRow
          label="Risk category"
          value={
            <RiskBadge
              category={block.risk_category}
              dominantDriver={block.dominant_driver}
              recommendedAction={block.recommended_action}
              score={block.risk_score}
            />
          }
        />
        <DetailRow label="Risk score" value={formatNumber(block.risk_score, 3)} />
        <DetailRow
          label="Dominant driver"
          value={block.dominant_driver ?? "No signal"}
        />
        <DetailRow
          label="Recommended action"
          value={block.recommended_action ?? "No action"}
        />
        <DetailRow label="NDVI value" value={formatNumber(block.ndvi)} />
        <DetailRow label="NDMI value" value={formatNumber(block.ndmi)} />
        <DetailRow
          label="Hotspots (7d)"
          value={block.hotspot_count_7d ?? "Unavailable"}
        />
        <DetailRow
          label="Rainfall deficit"
          value={
            block.rainfall_deficit_pct === null
              ? "Unavailable"
              : `${formatNumber(block.rainfall_deficit_pct, 1)}%`
          }
        />
        <DetailRow
          label="Nearest hotspot distance"
          value={
            block.nearest_hotspot_km === null
              ? "No hotspot nearby"
              : `${formatNumber(block.nearest_hotspot_km, 1)} km`
          }
        />
        <DetailRow label="Quality flag" value={block.quality_flag ?? "Unknown"} />
      </dl>
      <button
        onClick={onVerifyField}
        className="mt-4 w-full rounded bg-crop-field px-3 py-2 text-sm font-semibold text-white hover:opacity-90"
      >
        Verify Field
      </button>
    </section>
  );
}
