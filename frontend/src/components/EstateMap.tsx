"use client";

import { useMemo, useState } from "react";
import { getRiskColor, RISK_CATEGORIES } from "@/lib/riskColors";
import type { LatestBlockRisk } from "@/lib/queries";

type EstateMapProps = {
  blocks: LatestBlockRisk[];
  selectedBlockId: string | null;
  onSelectBlock: (blockId: string) => void;
};

type Point = [number, number];

type MapLayer = "risk" | "real" | "ndvi" | "ndmi";

const MAP_LAYERS: { id: MapLayer; label: string }[] = [
  { id: "risk", label: "Risk" },
  { id: "real", label: "Satellite" },
  { id: "ndvi", label: "NDVI" },
  { id: "ndmi", label: "NDMI" },
];

const IMAGE_WIDTH = 1600;
const IMAGE_HEIGHT = 1313;
const IMAGE_PADDING_METERS = 500;

function getPolygons(block: LatestBlockRisk): Point[][] {
  if (!block.geometry) {
    return [];
  }

  if (block.geometry.type === "Polygon") {
    const rings = block.geometry.coordinates as Point[][];
    return rings[0] ? [rings[0]] : [];
  }

  if (block.geometry.type === "MultiPolygon") {
    const polygons = block.geometry.coordinates as Point[][][];
    return polygons.flatMap((rings) => (rings[0] ? [rings[0]] : []));
  }

  return [];
}

function getBounds(blocks: LatestBlockRisk[]) {
  const points = blocks.flatMap((block) => getPolygons(block).flat());

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

function getImageBounds(blocks: LatestBlockRisk[]) {
  const bounds = getBounds(blocks);
  const centerLat = (bounds.minLat + bounds.maxLat) / 2;
  const latPadding = IMAGE_PADDING_METERS / 111_320;
  const lngPadding =
    IMAGE_PADDING_METERS / (111_320 * Math.cos((centerLat * Math.PI) / 180));

  return {
    minLng: bounds.minLng - lngPadding,
    maxLng: bounds.maxLng + lngPadding,
    minLat: bounds.minLat - latPadding,
    maxLat: bounds.maxLat + latPadding,
  };
}

function getObservationDate(blocks: LatestBlockRisk[]) {
  return blocks.reduce((latest, block) => {
    const date = block.observation_date ?? block.score_date ?? "";
    return date > latest ? date : latest;
  }, "");
}

export function EstateMap({
  blocks,
  selectedBlockId,
  onSelectBlock,
}: EstateMapProps) {
  const [layer, setLayer] = useState<MapLayer>("risk");
  const bounds = useMemo(() => getImageBounds(blocks), [blocks]);
  const observationDate = useMemo(() => getObservationDate(blocks), [blocks]);
  const width = IMAGE_WIDTH;
  const height = IMAGE_HEIGHT;
  const lngSpan = bounds.maxLng - bounds.minLng || 1;
  const latSpan = bounds.maxLat - bounds.minLat || 1;
  const imagePath =
    layer === "risk" || !observationDate
      ? null
      : `/geospatial/${layer}_map_${observationDate}.png`;

  function project([lng, lat]: Point) {
    const x = ((lng - bounds.minLng) / lngSpan) * width;
    const y = ((bounds.maxLat - lat) / latSpan) * height;

    return `${x},${y}`;
  }

  return (
    <section className="flex h-full min-h-[28rem] flex-col bg-white">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-crop-line px-4 py-3">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-crop-ink">
          Estate Map
        </h2>
        <div aria-label="Map layer" className="flex rounded border border-crop-line bg-crop-panel p-0.5">
          {MAP_LAYERS.map((mapLayer) => (
            <button
              key={mapLayer.id}
              aria-pressed={layer === mapLayer.id}
              className={`rounded px-2.5 py-1 text-xs font-semibold transition-colors ${
                layer === mapLayer.id
                  ? "bg-crop-field text-white"
                  : "text-slate-600 hover:bg-white"
              }`}
              type="button"
              onClick={() => setLayer(mapLayer.id)}
            >
              {mapLayer.label}
            </button>
          ))}
        </div>
      </div>
      <div className="flex flex-wrap items-center justify-between gap-2 border-b border-crop-line px-4 py-2 text-xs text-slate-600">
        <div className="flex flex-wrap items-center gap-2">
          {layer !== "risk" ? (
            <span className="font-medium">
              {layer === "real"
                ? "Sentinel-2 true color"
                : `${layer.toUpperCase()} satellite index`}
              {" · Risk overlay 50%"}
            </span>
          ) : null}
          {RISK_CATEGORIES.map((category) => {
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
          })}
        </div>
        <span>{observationDate || "Date unavailable"}</span>
      </div>
      <div className="flex min-h-0 flex-1 items-center justify-center bg-[#dfe8e2] p-4">
        <svg
          aria-label={`${MAP_LAYERS.find((item) => item.id === layer)?.label} estate map`}
          className="h-full max-h-[34rem] w-full rounded bg-[#edf3ef] shadow-inner"
          preserveAspectRatio="xMidYMid meet"
          viewBox={`0 0 ${width} ${height}`}
        >
          <rect fill="#edf3ef" height={height} rx="8" width={width} />
          {imagePath ? (
            <image
              height={height}
              href={imagePath}
              preserveAspectRatio="none"
              width={width}
            />
          ) : null}
          {blocks.map((block) => {
            const polygons = getPolygons(block);
            const selected = block.block_id === selectedBlockId;
            const color = getRiskColor(block.risk_category);
            const overlayOpacity =
              layer === "risk" ? (selected ? 1 : 0.78) : 0.5;
            const stroke =
              layer === "risk"
                ? selected
                  ? "#10251d"
                  : "#ffffff"
                : selected
                  ? "#facc15"
                  : "transparent";

            return (
              <g key={block.block_id}>
                <title>{`${block.block_code}: ${color.label}`}</title>
                {polygons.map((points, polygonIndex) => (
                  <g key={`${block.block_id}-${polygonIndex}`}>
                    <polygon
                      data-risk-overlay="true"
                      fill={color.hex}
                      opacity={overlayOpacity}
                      points={points.map(project).join(" ")}
                      stroke={stroke}
                      strokeWidth={selected ? 8 : 3}
                      vectorEffect="non-scaling-stroke"
                    />
                    <polygon
                      aria-label={`Select ${block.block_code}${
                        polygons.length > 1 ? ` part ${polygonIndex + 1}` : ""
                      }`}
                      className="cursor-pointer"
                      fill="transparent"
                      points={points.map(project).join(" ")}
                      role="button"
                      stroke="transparent"
                      strokeWidth="12"
                      tabIndex={0}
                      onClick={() => onSelectBlock(block.block_id)}
                      onKeyDown={(event) => {
                        if (event.key === "Enter" || event.key === " ") {
                          event.preventDefault();
                          onSelectBlock(block.block_id);
                        }
                      }}
                    />
                  </g>
                ))}
              </g>
            );
          })}
        </svg>
      </div>
    </section>
  );
}
