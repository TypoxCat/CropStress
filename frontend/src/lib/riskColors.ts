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

export type RiskThreshold = {
  category: RiskCategory;
  range: string;
  explanation: string;
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

export const RISK_THRESHOLDS: RiskThreshold[] = [
  {
    category: "Normal",
    range: "0.00-0.24",
    explanation: "low combined stress signal",
  },
  {
    category: "Watch",
    range: "0.25-0.44",
    explanation: "early stress signal worth monitoring",
  },
  {
    category: "Warning",
    range: "0.45-0.64",
    explanation: "clear stress signal that should be checked soon",
  },
  {
    category: "Priority Inspection",
    range: "0.65-1.00",
    explanation: "urgent stress signal for field inspection",
  },
];

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

export function getRiskThreshold(
  category: RiskCategory | string | null
): RiskThreshold {
  const label = getRiskColor(category).label;
  return (
    RISK_THRESHOLDS.find((threshold) => threshold.category === label) ??
    RISK_THRESHOLDS[0]
  );
}

export function getRiskFormulaLabel(): string {
  return "Risk score = 30% vegetation + 30% moisture + 25% rainfall + 15% fire";
}
