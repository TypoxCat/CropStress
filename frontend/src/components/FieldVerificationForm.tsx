"use client";

import { useState } from "react";
import type {
  FieldReportPayload,
  LatestBlockRisk,
  Severity,
  StressConfirmed,
  StressType,
} from "@/lib/queries";

type FieldVerificationFormProps = {
  block: LatestBlockRisk | null;
  onSubmit: (payload: FieldReportPayload) => Promise<void>;
};

const stressTypes: StressType[] = [
  "Drought",
  "Waterlogging",
  "Pest",
  "Disease",
  "Fire Risk",
  "Unknown",
];

const severities: Severity[] = ["Low", "Medium", "High"];

export function FieldVerificationForm({
  block,
  onSubmit,
}: FieldVerificationFormProps) {
  const [stressConfirmed, setStressConfirmed] =
    useState<StressConfirmed>("Unclear");
  const [stressType, setStressType] = useState<StressType>("Unknown");
  const [severity, setSeverity] = useState<Severity>("Medium");
  const [observerName, setObserverName] = useState("");
  const [soilCondition, setSoilCondition] = useState("");
  const [drainageCondition, setDrainageCondition] = useState("");
  const [notes, setNotes] = useState("");
  const [status, setStatus] = useState<"idle" | "submitting" | "success">(
    "idle"
  );

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();

    if (!block) {
      return;
    }

    setStatus("submitting");
    await onSubmit({
      block_id: block.block_id,
      observer_name: observerName,
      stress_confirmed: stressConfirmed,
      stress_type: stressType,
      severity,
      soil_condition: soilCondition,
      drainage_condition: drainageCondition,
      notes,
      photo_url: null,
    });
    setStatus("success");
  }

  return (
    <section className="border-t border-crop-line bg-white p-4">
      <div className="mb-3 flex items-center justify-between gap-3">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
          Field Verification Form
        </h2>
        <span className="text-sm text-slate-600">
          {block ? block.block_code : "No block selected"}
        </span>
      </div>
      <form className="grid gap-3 lg:grid-cols-6" onSubmit={handleSubmit}>
        <label className="flex flex-col gap-1 text-sm lg:col-span-2">
          Observer name
          <input
            className="rounded border border-crop-line px-3 py-2"
            value={observerName}
            onChange={(event) => setObserverName(event.target.value)}
          />
        </label>
        <fieldset className="lg:col-span-2">
          <legend className="text-sm">Stress confirmed</legend>
          <div className="mt-1 flex gap-3 text-sm">
            {(["Yes", "No", "Unclear"] as StressConfirmed[]).map((option) => (
              <label key={option} className="flex items-center gap-1">
                <input
                  checked={stressConfirmed === option}
                  name="stress_confirmed"
                  type="radio"
                  onChange={() => setStressConfirmed(option)}
                />
                {option}
              </label>
            ))}
          </div>
        </fieldset>
        <label className="flex flex-col gap-1 text-sm">
          Stress type
          <select
            className="rounded border border-crop-line px-3 py-2"
            value={stressType}
            onChange={(event) => setStressType(event.target.value as StressType)}
          >
            {stressTypes.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        </label>
        <label className="flex flex-col gap-1 text-sm">
          Severity
          <select
            className="rounded border border-crop-line px-3 py-2"
            value={severity}
            onChange={(event) => setSeverity(event.target.value as Severity)}
          >
            {severities.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        </label>
        <label className="flex flex-col gap-1 text-sm lg:col-span-2">
          Soil condition
          <input
            className="rounded border border-crop-line px-3 py-2"
            value={soilCondition}
            onChange={(event) => setSoilCondition(event.target.value)}
          />
        </label>
        <label className="flex flex-col gap-1 text-sm lg:col-span-2">
          Drainage condition
          <input
            className="rounded border border-crop-line px-3 py-2"
            value={drainageCondition}
            onChange={(event) => setDrainageCondition(event.target.value)}
          />
        </label>
        <label className="flex flex-col gap-1 text-sm lg:col-span-2">
          Photo upload placeholder
          <input className="rounded border border-crop-line px-3 py-2" type="file" />
        </label>
        <label className="flex flex-col gap-1 text-sm lg:col-span-5">
          Field note
          <textarea
            className="min-h-20 rounded border border-crop-line px-3 py-2"
            value={notes}
            onChange={(event) => setNotes(event.target.value)}
          />
        </label>
        <div className="flex items-end">
          <button
            className="w-full rounded bg-crop-field px-4 py-2 font-semibold text-white disabled:cursor-not-allowed disabled:bg-slate-400"
            disabled={!block || status === "submitting"}
            type="submit"
          >
            {status === "submitting" ? "Submitting" : "Submit"}
          </button>
        </div>
        {status === "success" ? (
          <p className="text-sm font-medium text-crop-field lg:col-span-6">
            Field verification saved for demo review.
          </p>
        ) : null}
      </form>
    </section>
  );
}
