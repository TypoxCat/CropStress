"use client";

import { useState } from "react";
import type { DataMode, DataSourcePreference } from "@/lib/queries";

type DeveloperMenuProps = {
  dataMode: DataMode;
  forceDemoData: boolean;
  hasSupabaseConfig: boolean;
  preference: DataSourcePreference;
  onPreferenceChange: (preference: DataSourcePreference) => void;
};

export function DeveloperMenu({
  dataMode,
  forceDemoData,
  hasSupabaseConfig,
  preference,
  onPreferenceChange,
}: DeveloperMenuProps) {
  const [isOpen, setIsOpen] = useState(true);
  const liveDisabledReason = forceDemoData
    ? "NEXT_PUBLIC_USE_DEMO_DATA=true"
    : !hasSupabaseConfig
      ? "Missing Supabase public env vars"
      : null;

  return (
    <aside className="fixed bottom-4 right-4 z-40 w-72 rounded-lg border border-slate-300 bg-white p-4 text-sm shadow-xl">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h2 className="font-bold text-crop-ink">Developer Menu</h2>
          <p className="text-xs text-slate-500">Data source switcher</p>
        </div>
        <div className="flex items-center gap-2">
          <span
            className={`rounded-full px-2 py-1 text-xs font-semibold ${
              dataMode === "live"
                ? "bg-emerald-100 text-emerald-800"
                : "bg-amber-100 text-amber-900"
            }`}
          >
            {dataMode === "live" ? "Real" : "Dummy"}
          </span>
          <button
            type="button"
            className="rounded border border-crop-line px-2 py-1 text-xs font-semibold text-slate-700 hover:bg-slate-50"
            aria-expanded={isOpen}
            aria-controls="developer-menu-panel"
            onClick={() => setIsOpen((current) => !current)}
          >
            {isOpen ? "Close" : "Open"}
          </button>
        </div>
      </div>

      {isOpen ? (
        <div id="developer-menu-panel" className="mt-3">
          <label className="flex flex-col gap-1">
            Source
            <select
              className="rounded border border-crop-line px-3 py-2"
              value={preference}
              onChange={(event) =>
                onPreferenceChange(event.target.value as DataSourcePreference)
              }
            >
              <option value="auto">Auto fallback</option>
              <option value="live">Real data (Supabase)</option>
              <option value="demo">Dummy data (local JSON)</option>
            </select>
          </label>

          <p className="mt-3 text-xs text-slate-600">
            Auto uses Supabase when configured and jury-ready, then falls back
            to dummy data.
          </p>

          {liveDisabledReason ? (
            <p className="mt-2 rounded bg-amber-50 p-2 text-xs text-amber-900">
              Real data needs attention: {liveDisabledReason}.
            </p>
          ) : null}
        </div>
      ) : null}
    </aside>
  );
}
