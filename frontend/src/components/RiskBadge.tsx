import { getRiskColor, type RiskCategory } from "@/lib/riskColors";

type RiskBadgeProps = {
  category: RiskCategory | string | null;
};

export function RiskBadge({ category }: RiskBadgeProps) {
  const color = getRiskColor(category);

  return (
    <span
      className={`inline-flex items-center rounded border px-2 py-1 text-xs font-semibold ${color.bgClass} ${color.textClass} ${color.borderClass}`}
    >
      {color.label}
    </span>
  );
}
