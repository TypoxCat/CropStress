# CropStress

CropStress is a geospatial data pipeline project for generating plantation block-level crop stress indicators from satellite data. The current repository focuses on the data processing side of the project, especially preparing block boundary data, extracting satellite-based indicators, calculating risk scores, and producing scouting priority outputs.

The project is currently built as a lightweight prototype for learning and experimentation with remote sensing, Google Earth Engine, and geospatial data processing. It is not a production system and is not intended for commercial use.

## Project Overview

The main objective of this project is to process plantation block data and combine it with satellite-derived environmental indicators to support early crop stress monitoring.

The intended workflow is:

```text
Plantation block boundaries
        ↓
Google Earth Engine satellite processing
        ↓
Block-level indicators
        ↓
Risk score calculation
        ↓
Scouting priority ranking
        ↓
Data output for dashboard or backend integration
```

The project currently produces structured GeoJSON and JSON files that can later be used by a frontend map dashboard or backend database.

## Current Repository Structure

The current repository mainly consists of two important folders:

```text
CropStress/
├── data/
│   └── demo/
│       ├── blocks.geojson
│       ├── block_indicators_latest.json
│       ├── risk_scores_latest.json
│       └── scouting_priority_latest.json
│
├── scripts/
│   └── generate_day1_real_satellite_data.py
│
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## Main Script

The main script in this repository is:

```text
scripts/generate_day1_real_satellite_data.py
```

This script is responsible for generating satellite-derived block-level data. It loads plantation block geometries from `data/demo/blocks.geojson`, sends the block geometries to Google Earth Engine, extracts satellite indicators, calculates risk scores, and writes the output files back into `data/demo/`.

The script is designed to process:

* Sentinel-2 data for vegetation and canopy moisture indicators
* Rainfall data for rainfall deficit estimation
* FIRMS hotspot data for fire-risk signal
* Block-level risk score calculation
* Scouting priority ranking

## Local Environment File

This project uses a local `.env` file that is not included in the repository.

The `.env` file contains:

```env
GOOGLE_CLOUD_PROJECT=your-google-cloud-project-id
```

The `GOOGLE_CLOUD_PROJECT` value is the Google Cloud project ID that has already been connected to Google Earth Engine and is used to access satellite data.

This file is intentionally not pushed to GitHub because it contains local configuration. Although a Google Cloud project ID is not a private key, storing it in `.env` keeps the script cleaner and prevents hardcoding project-specific configuration inside the Python script.

## Data Folder

The `data/demo/` folder contains the generated data outputs used by the project.

### `blocks.geojson`

This file stores plantation block boundaries and block metadata.

It contains the coordinate geometry of each block. Other files do not duplicate the coordinates. Instead, all files are linked using the `block_id` field.

Example structure:

```json
{
  "type": "Feature",
  "properties": {
    "block_id": "B-001",
    "block_code": "B-001",
    "block_name": "Block B-001",
    "estate_id": "estate_demo_01",
    "area_ha": 25.4
  },
  "geometry": {
    "type": "Polygon",
    "coordinates": []
  }
}
```

### `block_indicators_latest.json`

This file stores satellite-derived indicators for each block.

Example fields:

```json
{
  "block_id": "B-001",
  "observation_date": "2026-05-30",
  "ndvi": 0.7482,
  "ndvi_baseline": 0.6765,
  "ndvi_anomaly": 0.0717,
  "ndmi": 0.1952,
  "ndmi_baseline": 0.2239,
  "ndmi_anomaly": -0.0286,
  "rainfall_30d_mm": null,
  "rainfall_baseline_mm": null,
  "rainfall_deficit_pct": null,
  "hotspot_count_7d": 0,
  "nearest_hotspot_km": null,
  "quality_flag": "real_satellite_partial"
}
```

The main indicators are:

* `ndvi`: vegetation greenness indicator
* `ndvi_baseline`: historical or seasonal NDVI reference
* `ndvi_anomaly`: difference between current NDVI and baseline NDVI
* `ndmi`: canopy moisture indicator
* `ndmi_baseline`: historical or seasonal NDMI reference
* `ndmi_anomaly`: difference between current NDMI and baseline NDMI
* `rainfall_30d_mm`: recent 30-day rainfall
* `rainfall_baseline_mm`: baseline rainfall
* `rainfall_deficit_pct`: rainfall deficit percentage
* `hotspot_count_7d`: recent hotspot count
* `nearest_hotspot_km`: nearest hotspot distance, not yet fully implemented
* `quality_flag`: data quality status

### `risk_scores_latest.json`

This file stores the calculated risk components and final risk category for each block.

Example fields:

```json
{
  "block_id": "B-001",
  "score_date": "2026-05-30",
  "vegetation_stress": 0.0,
  "moisture_stress": 0.13,
  "rainfall_stress": 0.0,
  "fire_risk": 0.0,
  "risk_score": 0.039,
  "risk_category": "Normal",
  "dominant_driver": "No significant stress signal",
  "recommended_action": "No urgent action"
}
```

### `scouting_priority_latest.json`

This file stores the ranked list of blocks for scouting or field inspection.

Example fields:

```json
{
  "priority_rank": 1,
  "block_id": "B-041",
  "score_date": "2026-05-30",
  "risk_score": 0.1269,
  "risk_category": "Normal",
  "dominant_driver": "NDVI decline + NDMI drop",
  "recommended_action": "No urgent action",
  "task_status": "monitor_only"
}
```

## Data Relationship

The files are connected using `block_id`.

```text
blocks.geojson
        ↓ block_id
block_indicators_latest.json
        ↓ block_id
risk_scores_latest.json
        ↓ block_id
scouting_priority_latest.json
```

The block coordinates are stored only in:

```text
data/demo/blocks.geojson
```

The indicator, risk score, and scouting files only store tabular data linked by `block_id`.

## Satellite Indicators

### NDVI

NDVI stands for Normalized Difference Vegetation Index. It is used to estimate vegetation greenness and crop condition.

```text
NDVI = (NIR - Red) / (NIR + Red)
```

For Sentinel-2:

```text
NDVI = (B8 - B4) / (B8 + B4)
```

### NDMI

NDMI stands for Normalized Difference Moisture Index. It is used to estimate vegetation or canopy moisture condition.

```text
NDMI = (NIR - SWIR) / (NIR + SWIR)
```

For Sentinel-2:

```text
NDMI = (B8 - B11) / (B8 + B11)
```

### Rainfall Deficit

Rainfall deficit compares recent rainfall with a baseline rainfall value.

```text
rainfall_deficit_pct =
max(0, (rainfall_baseline_mm - rainfall_30d_mm) / rainfall_baseline_mm * 100)
```

For this prototype, rainfall may be processed at estate level instead of block level because rainfall products usually have coarser spatial resolution than plantation blocks.

### Hotspot Count

Hotspot count represents recent fire hotspot signals around or within plantation blocks. This is used as a basic fire-risk indicator.

## Risk Scoring

The project uses a simple rule-based MVP risk scoring formula:

```text
RiskScore =
0.30 * vegetation_stress +
0.30 * moisture_stress +
0.25 * rainfall_stress +
0.15 * fire_risk
```

Risk categories:

```text
0.00 - 0.24 = Normal
0.25 - 0.44 = Watch
0.45 - 0.64 = Warning
0.65 - 1.00 = Priority Inspection
```

The risk score is intended as a prototype prioritization signal, not as a validated agronomic diagnosis.

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/TypoxCat/CropStress.git
cd CropStress
```

### 2. Create a virtual environment

```bash
python -m venv .venv
```

Activate the environment:

```bash
# macOS / Linux
source .venv/bin/activate
```

```bash
# Windows PowerShell
.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

If needed, install the Earth Engine Python API:

```bash
pip install earthengine-api
```

### 4. Create `.env`

Create a `.env` file in the project root:

```env
GOOGLE_CLOUD_PROJECT=your-google-cloud-project-id
```

The Google Cloud project ID must be connected to Google Earth Engine so the script can access satellite datasets.

### 5. Authenticate Earth Engine

Run:

```bash
earthengine authenticate
```

After authentication, the script can initialize Earth Engine using the project ID from `.env`.

## Running the Pipeline

Run the main script:

```bash
python scripts/generate_day1_real_satellite_data.py
```

The script will generate or update:

```text
data/demo/block_indicators_latest.json
data/demo/risk_scores_latest.json
data/demo/scouting_priority_latest.json
```

The block geometry is read from:

```text
data/demo/blocks.geojson
```

## Output Validation

After running the script, the outputs can be checked using:

```bash
python - <<'PY'
import json
from collections import Counter

ind = json.load(open("data/demo/block_indicators_latest.json"))
risk = json.load(open("data/demo/risk_scores_latest.json"))
scout = json.load(open("data/demo/scouting_priority_latest.json"))

print("Indicators:", len(ind))
print("Risk scores:", len(risk))
print("Scouting:", len(scout))

print("Rainfall null:", sum(r["rainfall_30d_mm"] is None for r in ind), "/", len(ind))
print("Rainfall baseline null:", sum(r["rainfall_baseline_mm"] is None for r in ind), "/", len(ind))
print("Rainfall deficit null:", sum(r["rainfall_deficit_pct"] is None for r in ind), "/", len(ind))

print("Risk categories:", Counter(r["risk_category"] for r in risk))

print("\nTop 10 priorities:")
for r in scout[:10]:
    print(
        r["priority_rank"],
        r["block_id"],
        r["risk_score"],
        r["risk_category"],
        r["dominant_driver"],
        r["recommended_action"]
    )
PY
```

## Current Status

The current repository already contains generated demo output files in `data/demo/` and one main processing script in `scripts/`.

Current development status:

* Block geometry is stored in `blocks.geojson`.
* The main script reads the block geometry and processes satellite-based indicators.
* NDVI and NDMI indicators are generated from Sentinel-2.
* Risk score and scouting priority outputs are generated.
* Rainfall extraction is being adjusted to work reliably at estate level.
* Hotspot distance is not fully implemented yet.
* The current output should be treated as a prototype dataset.

## Important Notes

1. The `.env` file is required locally but should not be committed.
2. The Google Cloud project ID must already be connected to Earth Engine.
3. Geometry is stored only in `blocks.geojson`.
4. JSON output files are linked by `block_id`.
5. The risk score is rule-based and has not been validated with field observations.
6. This project is currently focused on data generation, not frontend or backend development.