import { useEffect, useId, useRef, useState } from "react";
import {
  getRiskColor,
  getRiskFormulaLabel,
  getRiskThreshold,
  type RiskCategory,
} from "@/lib/riskColors";

type RiskBadgeProps = {
  category: RiskCategory | string | null;
  dominantDriver?: string | null;
  recommendedAction?: string | null;
  score?: number | null;
};

type TooltipPosition = {
  top: number;
  left: number;
};

const TOOLTIP_WIDTH = 288;
const TOOLTIP_MARGIN = 12;

function formatScore(score: number | null | undefined): string {
  if (score === null || score === undefined || Number.isNaN(score)) {
    return "unavailable";
  }

  return score.toFixed(3);
}

export function RiskBadge({
  category,
  dominantDriver,
  recommendedAction,
  score,
}: RiskBadgeProps) {
  const tooltipId = useId();
  const badgeRef = useRef<HTMLSpanElement>(null);
  const [showTooltip, setShowTooltip] = useState(false);
  const [tooltipPosition, setTooltipPosition] = useState<TooltipPosition>({
    top: 0,
    left: 0,
  });
  const color = getRiskColor(category);
  const threshold = getRiskThreshold(category);
  const explanation = [
    `${color.label}: score range ${threshold.range}, ${threshold.explanation}.`,
    `This block score is ${formatScore(score)}.`,
    dominantDriver ? `Main driver: ${dominantDriver}.` : null,
    recommendedAction ? `Action: ${recommendedAction}.` : null,
    getRiskFormulaLabel() + ".",
  ]
    .filter(Boolean)
    .join(" ");

  useEffect(() => {
    if (!showTooltip || !badgeRef.current) {
      return;
    }

    const updatePosition = () => {
      const rect = badgeRef.current?.getBoundingClientRect();

      if (!rect) {
        return;
      }

      const maxLeft = window.innerWidth - TOOLTIP_WIDTH - TOOLTIP_MARGIN;
      const preferredLeft = rect.left;
      const left = Math.max(
        TOOLTIP_MARGIN,
        Math.min(preferredLeft, Math.max(TOOLTIP_MARGIN, maxLeft))
      );
      const top = Math.min(
        rect.bottom + 8,
        window.innerHeight - TOOLTIP_MARGIN
      );

      setTooltipPosition({ top, left });
    };

    updatePosition();
    window.addEventListener("resize", updatePosition);
    window.addEventListener("scroll", updatePosition, true);

    return () => {
      window.removeEventListener("resize", updatePosition);
      window.removeEventListener("scroll", updatePosition, true);
    };
  }, [showTooltip]);

  return (
    <span
      ref={badgeRef}
      className={`relative inline-flex items-center gap-1 rounded border px-2 py-1 text-xs font-semibold ${color.bgClass} ${color.textClass} ${color.borderClass}`}
      title={explanation}
      aria-label={`${color.label} risk. ${explanation}`}
      aria-describedby={showTooltip ? tooltipId : undefined}
      onMouseEnter={() => setShowTooltip(true)}
      onMouseLeave={() => setShowTooltip(false)}
      onFocus={() => setShowTooltip(true)}
      onBlur={() => setShowTooltip(false)}
      tabIndex={0}
    >
      {color.label}
      <span
        aria-hidden="true"
        className="inline-flex h-4 w-4 items-center justify-center rounded-full bg-white/70 text-[10px]"
      >
        ?
      </span>
      {showTooltip ? (
        <span
          id={tooltipId}
          role="tooltip"
          className="pointer-events-none fixed z-50 w-72 rounded border border-slate-200 bg-white p-3 text-left text-xs font-normal leading-relaxed text-slate-700 shadow-xl"
          style={{
            left: tooltipPosition.left,
            top: tooltipPosition.top,
          }}
        >
          {explanation}
        </span>
      ) : null}
    </span>
  );
}
