"use client";

import { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { FieldVerificationForm } from "@/components/FieldVerificationForm";
import {
  getBlockDetail,
  submitFieldReport,
  type FieldReportPayload,
  type LatestBlockRisk,
} from "@/lib/queries";

function FieldVerificationContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const blockId = searchParams.get("blockId");
  const [block, setBlock] = useState<LatestBlockRisk | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    async function loadBlock() {
      if (!blockId) {
        setErrorMessage("Choose a block from the dashboard before verifying it.");
        return;
      }

      try {
        const detail = await getBlockDetail(blockId);
        if (active) {
          setBlock(detail);
        }
      } catch (error) {
        if (active) {
          setErrorMessage(
            error instanceof Error ? error.message : "Block detail failed to load"
          );
        }
      }
    }

    loadBlock();

    return () => {
      active = false;
    };
  }, [blockId]);

  async function handleFieldSubmit(payload: FieldReportPayload) {
    await submitFieldReport(payload);
    router.push("/");
  }

  return (
    <main className="min-h-screen bg-[#eef3ed] text-crop-ink">
      <div className="sticky top-0 z-10 border-b border-crop-line bg-white px-5 py-4">
        <button
          className="mb-4 text-sm font-semibold text-crop-ink hover:text-slate-600"
          type="button"
          onClick={() => router.back()}
        >
          Back to Dashboard
        </button>
        <h1 className="text-xl font-bold">Field Verification</h1>
      </div>

      <section className="p-5">
        {errorMessage ? (
          <p className="mb-4 rounded border border-red-200 bg-red-50 p-3 text-sm text-red-800">
            {errorMessage}
          </p>
        ) : null}
        <FieldVerificationForm block={block} onSubmit={handleFieldSubmit} />
      </section>
    </main>
  );
}

export default function FieldVerificationPage() {
  return (
    <Suspense
      fallback={
        <main className="min-h-screen bg-[#eef3ed] p-5 text-crop-ink">
          Loading field verification...
        </main>
      }
    >
      <FieldVerificationContent />
    </Suspense>
  );
}
