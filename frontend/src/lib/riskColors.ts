export type RiskCategory =
  | "Normal"
  | "Watch"
  | "Warning"
  | "Priority Inspection";

export type RiskColor = {
  label: RiskCategory;
  hex: string;
  bgClass: string;
  textClass: string;
  borderClass: string;
};

export const RISK_CATEGORIES: RiskCategory[] = [
  "Normal",
  "Watch",
  "Warning",
  "Priority Inspection",
];

export const RISK_COLORS: Record<RiskCategory, RiskColor> = {
  Normal: {
    label: "Normal",
    hex: "#2f8f5b",
    bgClass: "bg-emerald-100",
    textClass: "text-emerald-800",
    borderClass: "border-emerald-300",
  },
  Watch: {
    label: "Watch",
    hex: "#e0c229",
    bgClass: "bg-yellow-100",
    textClass: "text-yellow-900",
    borderClass: "border-yellow-300",
  },
  Warning: {
    label: "Warning",
    hex: "#e57a21",
    bgClass: "bg-orange-100",
    textClass: "text-orange-900",
    borderClass: "border-orange-300",
  },
  "Priority Inspection": {
    label: "Priority Inspection",
    hex: "#cf3434",
    bgClass: "bg-red-100",
    textClass: "text-red-800",
    borderClass: "border-red-300",
  },
};

export function isRiskCategory(value: unknown): value is RiskCategory {
  return (
    typeof value === "string" &&
    RISK_CATEGORIES.includes(value as RiskCategory)
  );
}

export function getRiskColor(category: RiskCategory | string | null): RiskColor {
  if (isRiskCategory(category)) {
    return RISK_COLORS[category];
  }

  return RISK_COLORS.Normal;
}
