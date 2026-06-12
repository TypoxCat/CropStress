"use client";

import { RiskBadge } from "./RiskBadge";
import type { ScoutingPriorityRow } from "@/lib/queries";

type ScoutingPriorityListProps = {
  rows: ScoutingPriorityRow[];
  selectedBlockId: string | null;
  onSelectBlock: (blockId: string) => void;
};

export function ScoutingPriorityList({
  rows,
  selectedBlockId,
  onSelectBlock,
}: ScoutingPriorityListProps) {
  return (
    <section className="flex min-h-0 flex-col">
      <div className="border-b border-crop-line px-4 py-3">
        <div className="flex items-center justify-between gap-3">
          <div>
            <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
              Scouting Priority List
            </h2>
            <p className="mt-1 text-xs text-slate-500">
              Highest risk score first
            </p>
          </div>
          <span className="rounded-full bg-red-50 px-2 py-1 text-xs font-semibold text-red-700">
            {rows.filter((row) => row.risk_category === "Priority Inspection").length} urgent
          </span>
        </div>
      </div>
      <div className="min-h-0 overflow-auto">
        <table className="w-full border-collapse text-left text-sm">
          <thead className="sticky top-0 bg-white text-xs uppercase text-slate-500">
            <tr>
              <th className="px-3 py-2">Rank</th>
              <th className="px-3 py-2">Block</th>
              <th className="px-3 py-2">Risk</th>
              <th className="px-3 py-2">Driver</th>
              <th className="px-3 py-2">Action</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => {
              const selected = row.block_id === selectedBlockId;
              const urgent = row.risk_category === "Priority Inspection";
              const warning = row.risk_category === "Warning";

              return (
                <tr
                  key={row.block_id}
                  aria-label={`Select ${row.block_code ?? row.block_id}`}
                  role="button"
                  tabIndex={0}
                  onClick={() => onSelectBlock(row.block_id)}
                  onKeyDown={(event) => {
                    if (event.key === "Enter" || event.key === " ") {
                      event.preventDefault();
                      onSelectBlock(row.block_id);
                    }
                  }}
                  className={`cursor-pointer border-l-4 transition-colors ${
                    urgent
                      ? "border-l-red-500"
                      : warning
                        ? "border-l-orange-400"
                        : "border-l-transparent"
                  } ${
                    selected
                      ? "bg-emerald-50 ring-1 ring-inset ring-crop-field"
                      : "border-t border-crop-line hover:bg-crop-panel"
                  }`}
                >
                  <td className="px-3 py-2 font-semibold">
                    <span
                      className={
                        row.priority_rank <= 3
                          ? "inline-flex h-6 w-6 items-center justify-center rounded-full bg-crop-ink text-xs text-white"
                          : ""
                      }
                    >
                      {row.priority_rank}
                    </span>
                  </td>
                  <td className="px-3 py-2">
                    <span className="font-semibold text-crop-field">
                      {row.block_code ?? row.block_id}
                    </span>
                  </td>
                  <td className="px-3 py-2">
                    <RiskBadge category={row.risk_category} />
                    <div className="mt-1 font-mono text-xs text-slate-500">
                      Score {(row.risk_score ?? 0).toFixed(3)}
                    </div>
                  </td>
                  <td className="max-w-[12rem] px-3 py-2 text-slate-700">
                    {row.dominant_driver ?? "No signal"}
                  </td>
                  <td className="max-w-[12rem] px-3 py-2 text-slate-700">
                    {row.recommended_action ?? "No action"}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </section>
  );
}
