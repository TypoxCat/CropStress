import { copyFile, mkdir, readdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const frontendDir = join(dirname(fileURLToPath(import.meta.url)), "..");
const geospatialDir = join(frontendDir, "..", "geospatial", "data");
const publicDir = join(frontendDir, "public");

const demoFiles = [
  "blocks.geojson",
  "block_indicators_latest.json",
  "risk_scores_latest.json",
  "scouting_priority_latest.json",
];

await mkdir(join(publicDir, "demo"), { recursive: true });
await mkdir(join(publicDir, "geospatial"), { recursive: true });

await Promise.all(
  demoFiles.map((fileName) =>
    copyFile(
      join(geospatialDir, "demo", fileName),
      join(publicDir, "demo", fileName)
    )
  )
);

const imageFiles = (await readdir(join(geospatialDir, "images"))).filter(
  (fileName) => /^(real|ndvi|ndmi)_map_\d{4}-\d{2}-\d{2}\.png$/.test(fileName)
);

await Promise.all(
  imageFiles.map((fileName) =>
    copyFile(
      join(geospatialDir, "images", fileName),
      join(publicDir, "geospatial", fileName)
    )
  )
);

console.log(
  `Synced ${demoFiles.length} data files and ${imageFiles.length} map images from geospatial.`
);
