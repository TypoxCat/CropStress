"use client";

import { getRiskColor } from "@/lib/riskColors";
import type { LatestBlockRisk } from "@/lib/queries";

type EstateMapProps = {
  blocks: LatestBlockRisk[];
  selectedBlockId: string | null;
  onSelectBlock: (blockId: string) => void;
};

type Point = [number, number];

function getPolygon(block: LatestBlockRisk): Point[] {
  if (!block.geometry || block.geometry.type !== "Polygon") {
    return [];
  }

  const rings = block.geometry.coordinates as Point[][];
  return rings[0] ?? [];
}

function getBounds(blocks: LatestBlockRisk[]) {
  const points = blocks.flatMap(getPolygon);

  if (points.length === 0) {
    return {
      minLng: 0,
      maxLng: 1,
      minLat: 0,
      maxLat: 1,
    };
  }

  const lngs = points.map(([lng]) => lng);
  const lats = points.map(([, lat]) => lat);

  return {
    minLng: Math.min(...lngs),
    maxLng: Math.max(...lngs),
    minLat: Math.min(...lats),
    maxLat: Math.max(...lats),
  };
}

export function EstateMap({
  blocks,
  selectedBlockId,
  onSelectBlock,
}: EstateMapProps) {
  const bounds = getBounds(blocks);
  const width = 720;
  const height = 460;
  const padding = 24;
  const lngSpan = bounds.maxLng - bounds.minLng || 1;
  const latSpan = bounds.maxLat - bounds.minLat || 1;

  function project([lng, lat]: Point) {
    const x = padding + ((lng - bounds.minLng) / lngSpan) * (width - padding * 2);
    const y =
      padding + ((bounds.maxLat - lat) / latSpan) * (height - padding * 2);

    return `${x},${y}`;
  }

  return (
    <section className="flex h-full min-h-[28rem] flex-col bg-white">
      <div className="flex items-center justify-between border-b border-crop-line px-4 py-3">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
          Block Risk Map
        </h2>
        <div className="flex flex-wrap gap-2 text-xs">
          {["Normal", "Watch", "Warning", "Priority Inspection"].map(
            (category) => {
              const color = getRiskColor(category);

              return (
                <span key={category} className="flex items-center gap-1">
                  <span
                    className="h-3 w-3 rounded-sm"
                    style={{ backgroundColor: color.hex }}
                  />
                  {color.label}
                </span>
              );
            }
          )}
        </div>
      </div>
      <div className="flex min-h-0 flex-1 items-center justify-center p-4">
        <svg
          aria-label="Estate block risk map"
          className="h-full max-h-[34rem] w-full"
          preserveAspectRatio="xMidYMid meet"
          viewBox={`0 0 ${width} ${height}`}
        >
          <rect fill="#edf3ef" height={height} rx="8" width={width} />
          {blocks.map((block) => {
            const points = getPolygon(block);
            const selected = block.block_id === selectedBlockId;
            const color = getRiskColor(block.risk_category);

            return (
              <g key={block.block_id}>
                <polygon
                  fill={color.hex}
                  opacity={selected ? 1 : 0.78}
                  points={points.map(project).join(" ")}
                  stroke={selected ? "#10251d" : "#ffffff"}
                  strokeWidth={selected ? 4 : 1.5}
                />
                <title>{`${block.block_code}: ${color.label}`}</title>
                <button
                  aria-label={`Select ${block.block_code}`}
                  className="cursor-pointer"
                  type="button"
                  onClick={() => onSelectBlock(block.block_id)}
                >
                  <polygon
                    fill="transparent"
                    points={points.map(project).join(" ")}
                  />
                </button>
              </g>
            );
          })}
        </svg>
      </div>
    </section>
  );
}
