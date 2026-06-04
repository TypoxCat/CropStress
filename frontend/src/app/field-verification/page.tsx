"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { FieldVerificationForm } from "@/components/FieldVerificationForm";
import { getLatestBlockRisk, submitFieldReport, type FieldReportPayload, type LatestBlockRisk } from "@/lib/queries";
import { useEffect, useState } from "react";

export default function FieldVerificationPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const blockId = searchParams.get("blockId");
  const [block, setBlock] = useState<LatestBlockRisk | null>(null);

  useEffect(() => {
    if (blockId) {
      // In a real scenario, you'd fetch this from the database
      // For now, we'll pass it through state or fetch it
    }
  }, [blockId]);

  async function handleFieldSubmit(payload: FieldReportPayload) {
    await submitFieldReport(payload);
    router.push("/");
  }

  return (
    <main className="min-h-screen bg-[#eef3ed] text-crop-ink">
      <div className="sticky top-0 z-10 border-b border-crop-line bg-white px-5 py-4">
        <button
          onClick={() => router.back()}
          className="mb-4 text-sm font-semibold text-crop-ink hover:text-slate-600"
        >
          ← Back to Dashboard
        </button>
        <h1 className="text-xl font-bold">Field Verification</h1>
      </div>

      <section className="p-5">
        <FieldVerificationForm block={block} onSubmit={handleFieldSubmit} />
      </section>
    </main>
  );
}
