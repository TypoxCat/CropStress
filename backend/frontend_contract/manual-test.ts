// only for manual testing (skip)

import {
  DEMO_ESTATE_ID,
  getLatestBlockRisk,
  getScoutingPriority,
  getBlockDetail,
  submitFieldReport,
} from "./queries";

async function main() {
  const risks = await getLatestBlockRisk(DEMO_ESTATE_ID);
  console.log("latest_block_risk:", risks.length);
  console.log("top risk:", risks[0]);

  const priority = await getScoutingPriority(DEMO_ESTATE_ID);
  console.log("scouting priority:", priority.length);
  console.log("rank 1:", priority[0]);

  const detail = await getBlockDetail("B-001");
  console.log("block detail:", detail.block_id, detail.risk_category);

  const report = await submitFieldReport({
    block_id: "B-001",
    observer_name: "Agent B Test",
    stress_confirmed: "Unclear",
    stress_type: "Unknown",
    severity: "Low",
    soil_condition: "Not checked",
    drainage_condition: "Not checked",
    notes: "Manual contract test from Agent B",
  });

  console.log("field report inserted:", report.id);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});