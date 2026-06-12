import { readFileSync } from "node:fs";
import { join } from "node:path";
import { afterEach, describe, expect, it, vi } from "vitest";

const demoPath = (...parts: string[]) =>
  join(process.cwd(), "public", "demo", ...parts);

vi.mock("@supabase/supabase-js", () => ({
  createClient: vi.fn(() => ({
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({
          order: vi.fn(async () => ({
            data: null,
            error: new Error("Supabase offline"),
          })),
        })),
      })),
      insert: vi.fn(() => ({
        select: vi.fn(() => ({
          single: vi.fn(async () => ({
            data: null,
            error: new Error("Supabase insert offline"),
          })),
        })),
      })),
    })),
  })),
}));

describe("live query fallback", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
    vi.unstubAllGlobals();
    vi.restoreAllMocks();
    vi.resetModules();
  });

  it("automatically uses local JSON when Supabase fails", async () => {
    vi.stubEnv("NEXT_PUBLIC_USE_DEMO_DATA", "false");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", "https://example.supabase.co");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY", "demo-anon-key");
    vi.stubGlobal(
      "fetch",
      vi.fn(async (url: string | URL | Request) => {
        const fileName = String(url).split("/").pop();

        return {
          ok: true,
          json: async () =>
            JSON.parse(readFileSync(demoPath(fileName ?? ""), "utf8")),
        } as Response;
      })
    );
    const warn = vi.spyOn(console, "warn").mockImplementation(() => undefined);
    const queries = await import("./queries");

    const rows = await queries.getLatestBlockRisk(queries.DEMO_ESTATE_ID);

    expect(rows).toHaveLength(48);
    expect(queries.getDataMode()).toBe("demo");
    expect(warn).toHaveBeenCalled();
  });

  it("simulates a local field report when a live insert fails", async () => {
    vi.stubEnv("NEXT_PUBLIC_USE_DEMO_DATA", "false");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", "https://example.supabase.co");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY", "demo-anon-key");
    vi.spyOn(console, "warn").mockImplementation(() => undefined);
    const queries = await import("./queries");

    const report = await queries.submitFieldReport({
      block_id: "B-037",
      observer_name: "Mira",
      stress_confirmed: "Yes",
      stress_type: "Drought",
      severity: "High",
    });

    expect(report.id).toMatch(/^demo-report-/);
    expect(queries.getDataMode()).toBe("demo");
  });
});
