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
        <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
          Scouting Priority List
        </h2>
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

              return (
                <tr
                  key={row.block_id}
                  className={
                    selected ? "bg-emerald-50" : "border-t border-crop-line"
                  }
                >
                  <td className="px-3 py-2 font-semibold">
                    {row.priority_rank}
                  </td>
                  <td className="px-3 py-2">
                    <button
                      aria-label={`Select ${row.block_code ?? row.block_id}`}
                      className="font-semibold text-crop-field underline-offset-2 hover:underline"
                      type="button"
                      onClick={() => onSelectBlock(row.block_id)}
                    >
                      {row.block_code ?? row.block_id}
                    </button>
                  </td>
                  <td className="px-3 py-2">
                    <RiskBadge category={row.risk_category} />
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
