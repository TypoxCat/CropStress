# CropStress Geospatial - Day 2 Data Generation Documentation

**Last Updated:** 2026-06-05  
**Status:** Day 2 MVP with Calibration and Block Detection Roadmap

---

## Table of Contents

1. [Overview](#overview)
2. [Current Implementation](#current-implementation)
3. [Data Generation Pipeline](#data-generation-pipeline)
4. [Sources of Each Indicator](#sources-of-each-indicator)
5. [Category Adjustment Methodology](#category-adjustment-methodology)
6. [Risk Formula & Threshold Verification](#risk-formula--threshold-verification)
7. [Synthetic vs. Real Data Labeling](#synthetic-vs-real-data-labeling)
8. [Known Limitations & Calibration Roadmap](#known-limitations--calibration-roadmap)

---

## Overview

### Purpose

The Day 2 data generation pipeline produces geospatial risk assessment data for oil palm block-level scouting prioritization. The system analyzes vegetation health, soil moisture, rainfall patterns, and fire risk to generate actionable inspection schedules.

**Current Status:**
- ✅ Synthetic demo data generation working
- ⚠️ Per-block calibration NOT YET IMPLEMENTED
- ⚠️ Automated block detection NOT YET IMPLEMENTED
- ✅ Polygon-based manual block labeling supported (GeoJSON format)

### Key Constraint

**Current block detection is grid-based (18×7 = 126 uniform blocks).** This does not match actual oil palm plantation block boundaries shown in satellite imagery and manual polygon labeling. **Manual calibration is currently required.**

---

## Current Implementation

### Files Overview

| File | Role | Status |
|------|------|--------|
| `generate_blocks.py` | Creates uniform grid blocks | Current: hardcoded 18×7 grid |
| `generate_images.py` | Fetches satellite RGB/NDVI/NDMI maps | Working with Earth Engine |
| `generate_day2_data.py` | Generates indicators & risk scores | Synthetic demo only |

### Data Pipeline Flow

```
1. generate_blocks.py
   └─→ Uniform grid (18×7)
       └─→ blocks.geojson

2. generate_images.py
   ├─ Fetch Sentinel-2 imagery (180-day median)
   ├─ Cloud masking
   ├─ Compute RGB, NDVI, NDMI
   └─→ PNG map visualizations

3. generate_day2_data.py
   ├─ Input: blocks.geojson
   ├─ Assign risk categories
   ├─ Generate indicator values (synthetic)
   ├─ Calculate risk scores
   └─→ JSON outputs (indicators, scores, priority list)
```

### Output Data Files

**Location:** `geospatial/data/demo/`

```json
{
  "blocks.geojson": "Block boundaries with metadata",
  "block_indicators_latest.json": [
    {
      "block_id": "B-001",
      "observation_date": "2026-06-05",
      "ndvi": 0.75,
      "ndmi": 0.42,
      "rainfall_30d_mm": 156.0,
      "hotspot_count_7d": 0,
      "scenario_category": "Normal",
      "data_provenance": "synthetic_demo"
    }
  ],
  "risk_scores_latest.json": [
    {
      "block_id": "B-001",
      "vegetation_stress": 0.05,
      "moisture_stress": 0.04,
      "rainfall_stress": 0.03,
      "fire_risk": 0.00,
      "risk_score": 0.0415,
      "risk_category": "Normal",
      "dominant_driver": "No significant stress signal",
      "recommended_action": "No urgent action"
    }
  ],
  "scouting_priority_latest.json": [
    {
      "priority_rank": 1,
      "block_id": "B-042",
      "risk_score": 0.7825,
      "risk_category": "Priority Inspection",
      "task_status": "open"
    }
  ]
}
```

---

## Data Generation Pipeline

### Phase 1: Block Geometry Definition

#### Current Approach: Uniform Grid

```python
# generate_blocks.py
ROWS = 18  # vertical divisions
COLS = 7   # horizontal divisions
# Result: 18 × 7 = 126 equal rectangular blocks
```

**Limitations:**
- Does not match actual plantation layout
- Ignores roads, water bodies, and non-plantation areas
- Equal-sized blocks assume uniform management zones
- Cannot reflect true block boundaries visible in satellite imagery

#### Roadmap: Manual Polygon-Based Blocks

**Next Phase:** Import manually digitized block polygons from GIS software.

**Required Input Format:**
```json
{
  "type": "FeatureCollection",
  "properties": {
    "estate_id": "estate_demo_01",
    "crs": "EPSG:4326"
  },
  "features": [
    {
      "type": "Feature",
      "properties": {
        "block_id": "B-001",
        "block_name": "Block A1",
        "area_ha": 12.5
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[
          [102.50, -0.60],
          [102.51, -0.60],
          [102.51, -0.61],
          [102.50, -0.61],
          [102.50, -0.60]
        ]]
      }
    }
  ]
}
```

**Input Methods:**
- Manual digitization in QGIS / ArcGIS
- Polygon export from plantation GIS database
- Manual labeling tool (future web interface)

---

### Phase 2: Satellite Data Acquisition

#### Sentinel-2 Multispectral Imagery

**Source:** Google Earth Engine - COPERNICUS/S2_SR_HARMONIZED

| Band | Wavelength | Use Case | Resolution |
|------|-----------|----------|-----------|
| B2 (Blue) | 490 nm | RGB composite | 10m |
| B3 (Green) | 560 nm | RGB composite | 10m |
| B4 (Red) | 665 nm | NDVI calculation | 10m |
| B8 (NIR) | 842 nm | NDVI, NDMI calculation | 10m |
| B11 (SWIR) | 1610 nm | NDMI calculation | 20m → resampled to 10m |

#### Cloud Masking

**Strategy:** S2Cloudless probability layer

```python
# generate_images.py (lines 37-66)
- Filter cloudy_pixel_percentage ≤ 80%
- Join S2 SR with S2 Cloud Probability
- Apply binary mask for probability > 40%
```

**Composite Generation:** 180-day median composite

```python
CURRENT_START_S2 = date.today() - timedelta(days=180)
CURRENT_END = date.today()
# Multi-temporal median reduces noise and anomalies
```

---

### Phase 3: Indicator Derivation

#### 3.1 Vegetation Stress (NDVI)

**Normalized Difference Vegetation Index**

```
NDVI = (NIR - Red) / (NIR + Red)
     = (B8 - B4) / (B8 + B4)
```

**Baseline for healthy oil palm:** ~0.78-0.84

**Derivation:**
```python
# generate_day2_data.py (lines 421-443)
ndvi_baseline = 0.78 + ((sequence_number % 5) * 0.015)

# Vegetation stress is percentage reduction from baseline
vegetation_stress_component ∈ [0.0, 1.0]
  where 0 = no stress, 1 = severe decline

# Back-calculate observed NDVI from stress
ndvi_anomaly = -vegetation_stress * 0.18
ndvi_observed = clamp(ndvi_baseline + ndvi_anomaly, 0.25, 0.90)
```

**Stress Interpretation:**

| NDVI | Condition |
|------|-----------|
| 0.80+ | Excellent health |
| 0.75-0.79 | Good condition |
| 0.70-0.74 | Watch - early stress |
| 0.60-0.69 | Warning - moderate stress |
| 0.40-0.59 | Priority - significant decline |
| <0.40 | Critical - severe stress or non-vegetated |

**Sources:**
- Primary: Sentinel-2 B4, B8
- Secondary: Landsat for longer historical trends (optional future)
- Real calibration: Field phenology photos, LAI measurements

#### 3.2 Moisture Stress (NDMI)

**Normalized Difference Moisture Index**

```
NDMI = (NIR - SWIR) / (NIR + SWIR)
     = (B8 - B11) / (B8 + B11)
```

**Baseline for healthy oil palm:** ~0.38-0.46

**Derivation:**
```python
ndmi_baseline = 0.38 + ((sequence_number % 4) * 0.025)

# Moisture stress is percentage reduction from baseline
moisture_stress_component ∈ [0.0, 1.0]
  where 0 = adequate moisture, 1 = severe drought

# Back-calculate observed NDMI from stress
ndmi_anomaly = -moisture_stress * 0.22
ndmi_observed = clamp(ndmi_baseline + ndmi_anomaly, -0.20, 0.60)
```

**Moisture Interpretation:**

| NDMI | Condition |
|------|-----------|
| 0.45+ | Excellent moisture |
| 0.35-0.44 | Good moisture status |
| 0.25-0.34 | Watch - dry trend |
| 0.15-0.24 | Warning - moisture stress |
| <0.15 | Critical - severe drought |

**Sources:**
- Primary: Sentinel-2 B8, B11
- Secondary: Soil moisture models (optional future)
- Real calibration: Soil water content sensors, plant water potential measurements

#### 3.3 Rainfall Stress

**30-Day Accumulated Precipitation**

**Baseline:** ~180 mm (typical tropical monthly rainfall)

**Derivation:**
```python
rainfall_baseline_mm = 180.0 + ((sequence_number % 6) * 8.0)

# Rainfall stress is percentage deficit from baseline
rainfall_stress_component ∈ [0.0, 1.0]
  where 0 = normal rainfall, 1 = extreme drought (0% of normal)

rainfall_deficit_pct = rainfall_stress * 60.0  # Normalized to 0-60%
rainfall_observed_mm = rainfall_baseline_mm * (1.0 - rainfall_deficit_pct / 100.0)
```

**Rainfall Interpretation:**

| 30-Day Rainfall | Condition |
|-----------------|-----------|
| >150 mm | Normal - no water stress |
| 100-150 mm | Watch - dry trend |
| 50-100 mm | Warning - below normal |
| <50 mm | Critical - severe drought |

**Sources:**
- Primary: CHIRPS (Climate Hazards Group InfraRed Precipitation with Station data)
- Secondary: PERSIANN, MERRA-2
- Real calibration: Ground rain gauge network

#### 3.4 Fire Risk (Hotspot Proximity)

**FIRMS Hotspot Detection & Proximity Scoring**

**Source:** NASA FIRMS (Fire Information for Resource Management System)
- Active fire detections within 7 days
- Distance to nearest hotspot

**Derivation:**
```python
fire_risk_component ∈ [0.0, 1.0]
  where 0 = no hotspots, 1 = immediate fire threat

# Demo fire risk to hotspot count mapping
hotspot_count_7d = int(round(fire_risk * 3))

# Demo proximity modeling (NOT a true distance calculation)
if fire_risk > 0:
    nearest_hotspot_km = max(0.4, 12.0 * (1.0 - fire_risk))
else:
    nearest_hotspot_km = None
```

**Fire Risk Interpretation:**

| Fire Risk Score | Hotspots | Proximity | Action |
|---|---|---|---|
| 0.00 | 0 | None | Monitor |
| 0.15-0.35 | 0-1 | 9-11 km | Elevated alert |
| 0.35-0.55 | 1-2 | 5-9 km | Prepare response |
| >0.55 | 2-3 | <5 km | Active patrol |

**Sources:**
- Primary: NASA FIRMS MODIS/VIIRS
- Secondary: Sentinel-1 SAR backscatter changes (optional)
- Real calibration: Verified fire reports, ground truth surveys

---

## Category Adjustment Methodology

### Risk Score Formula

```
RiskScore = 0.30 × vegetation_stress
          + 0.30 × moisture_stress
          + 0.25 × rainfall_stress
          + 0.15 × fire_risk
```

**Weight Justification:**

| Component | Weight | Rationale |
|-----------|--------|-----------|
| NDVI (Vegetation) | 0.30 | Direct proxy for crop health |
| NDMI (Moisture) | 0.30 | Critical for oil palm development |
| Rainfall | 0.25 | Upstream indicator of water availability |
| Fire Risk | 0.15 | Localized but critical threat |

### Risk Thresholds

| Risk Score | Category | Recommended Action |
|---|---|---|
| 0.00-0.24 | **Normal** | Continue routine monitoring |
| 0.25-0.44 | **Watch** | Monitor next processing cycle |
| 0.45-0.64 | **Warning** | Inspect within one week |
| 0.65-1.00 | **Priority Inspection** | Inspect within 24-48 hours |

**Threshold Derivation:**

```python
# generate_day2_data.py (lines 98-103, 184-191)
CATEGORY_THRESHOLDS = {
    "Normal": (0.00, 0.25),
    "Watch": (0.25, 0.45),
    "Warning": (0.45, 0.65),
    "Priority Inspection": (0.65, 1.01),
}

def risk_category_from_score(score: float) -> str:
    if score < 0.25:
        return "Normal"
    if score < 0.45:
        return "Watch"
    if score < 0.65:
        return "Warning"
    return "Priority Inspection"
```

### Category Distribution (Demo Data)

**Minimum:** 5 blocks per category (required for MVP demo)

With 48 blocks:
- 12 blocks = Normal
- 12 blocks = Watch
- 12 blocks = Warning
- 12 blocks = Priority Inspection

**Validation:** Script enforces distribution with `validate_risk_distribution()`.

---

## Risk Formula & Threshold Verification

### Formula Consistency Validation

**All generated risk scores are validated:**

```python
# generate_day2_data.py (lines 649-670)
def validate_formula_consistency(risk_scores: List[Dict[str, Any]]) -> None:
    for row in risk_scores:
        expected_score = calculate_risk_score(
            vegetation_stress=float(row["vegetation_stress"]),
            moisture_stress=float(row["moisture_stress"]),
            rainfall_stress=float(row["rainfall_stress"]),
            fire_risk=float(row["fire_risk"]),
        )
        
        if expected_score != row["risk_score"]:
            raise ValueError(f"Formula mismatch for {row['block_id']}")
```

### Threshold Verification

**All category assignments are verified against thresholds:**

```python
def validate_outputs(...) -> Tuple[Counter, List[Dict[str, Any]]]:
    validate_id_consistency(...)
    validate_formula_consistency(...)              # ← Formula check
    category_counts = validate_risk_distribution(...)  # ← Threshold check
    top3 = validate_top3_priority(...)
```

**Top 3 Priority Blocks Must Be:**
- Risk category: "Warning" or "Priority Inspection"
- Clear dominant driver (not "No significant stress signal")

### Dominant Driver Classification

**Logic:** Identify primary stress factor(s)

```python
# generate_day2_data.py (lines 210-249)
Components ranked by stress value:
1. NDVI decline (vegetation_stress)
2. NDMI drop (moisture_stress)
3. Rainfall deficit (rainfall_stress)
4. Hotspot proximity (fire_risk)

If top_value < 0.15:
    → "No significant stress signal"
Else if second_value ≥ 0.50:
    → "X + Y" (dual stress)
Else:
    → top driver name
```

**Examples:**
- (0.80, 0.10, 0.05, 0.00) → "NDVI decline"
- (0.65, 0.55, 0.50, 0.05) → "NDVI decline + NDMI drop"
- (0.40, 0.35, 0.35, 0.00) → "Mixed stress signal"

---

## Synthetic vs. Real Data Labeling

### Data Provenance Tracking

**All outputs include provenance labels:**

```json
{
  "block_indicators_latest.json": {
    "data_provenance": "synthetic_demo",
    "quality_flag": "synthetic_demo_day2",
    "indicator_sources": {
      "ndvi": "synthetic_day2_scenario",
      "ndmi": "synthetic_day2_scenario",
      "rainfall": "synthetic_day2_scenario",
      "hotspot": "synthetic_day2_scenario"
    }
  },
  "risk_scores_latest.json": {
    "data_provenance": "synthetic_demo",
    "scenario_note": "Early vegetation decline"
  }
}
```

### Why Synthetic Data for MVP?

**Reason:** Real satellite data can be **too uniform** for demonstration.

**Problem with real data:**
- Estate may be spatially homogeneous → all blocks fall into 1-2 risk categories
- Rainfall computed at estate level → no spatial variation
- Fire risk spatially sparse → mostly zeros in low-threat areas

**Solution:** Use synthetic data constrained to realistic ranges:
- NDVI: 0.25-0.90 (plausible oil palm range)
- NDMI: -0.20-0.60 (drought to excess moisture)
- Rainfall: 50-200 mm/month (tropical variability)
- Hotspot: 0-3 per 7 days (low-to-moderate fire season)

### Component Value Ranges

All stress components are **normalized to [0.0, 1.0]** where:
- 0 = no stress / ideal condition
- 1 = severe stress / critical condition

**Scenario Templates** ensure consistent distribution across categories:

```python
# generate_day2_data.py (lines 113-149)
CATEGORY_COMPONENT_TEMPLATES = {
    "Normal": [
        (0.05, 0.04, 0.03, 0.00, "Stable canopy and moisture"),
        (0.10, 0.08, 0.06, 0.00, "Very low stress signal"),
        ...
    ],
    "Watch": [
        (0.35, 0.30, 0.25, 0.00, "Early vegetation decline"),
        (0.40, 0.32, 0.30, 0.05, "Moderate canopy and rainfall"),
        ...
    ],
    ...
}
```

---

## Known Limitations & Calibration Roadmap

### Current Limitations

#### 1. Block Detection

| Issue | Impact | Workaround |
|-------|--------|-----------|
| Grid-based blocks (18×7) don't match real boundaries | Meaningless block-level statistics | Manual digitization required |
| No multi-polygon support for non-contiguous blocks | Can't represent fragmented zones | Update GeoJSON schema |
| No automated boundary detection from satellite imagery | Manual effort required | Plan machine learning model |

#### 2. Indicator Calibration

| Issue | Impact | Workaround |
|-------|--------|-----------|
| NDVI thresholds not validated against ground truth | False positives/negatives in stress detection | Collect field phenology data |
| NDMI sensitive to atmospheric conditions & sensor drift | Unreliable moisture proxy alone | Multi-source fusion (soil moisture models) |
| Rainfall sourced at large grid cells (coarse resolution) | Block-level variation lost | Install ground gauge network |
| Fire risk based on detected hotspots only | Misses slow-burn or underground fires | Add synthetic aperture radar (SAR) |

#### 3. Risk Formula Calibration

| Issue | Impact | Workaround |
|-------|--------|-----------|
| Weights (0.30, 0.30, 0.25, 0.15) not empirically derived | Categories may not align with scouting reality | Conduct on-site validation campaign |
| Thresholds (0.25, 0.45, 0.65) are illustrative | Block priority may be incorrect | Calibrate using yield losses, pest/disease reports |
| No regional/seasonal adjustment | One formula for all conditions | Develop regional adjustment factors |

#### 4. Data Sources

| Indicator | Current | Gap |
|-----------|---------|-----|
| Vegetation (NDVI) | Sentinel-2 (~10 m, 5-day) | Historical trends, field validation |
| Moisture (NDMI) | Sentinel-2 (~20 m, 5-day) | Soil moisture sensors, water balance models |
| Rainfall | Future: CHIRPS (~5 km monthly) | Ground gauge network, sub-monthly resolution |
| Fire Risk | Future: FIRMS (hotspot detections) | SAR hotspot mapping, field patrols |

### Calibration Roadmap

#### Phase 1: Manual Block Digitization (Q2 2026)

**Objective:** Replace grid with real block boundaries

**Steps:**
1. Collect high-resolution satellite imagery (Sentinel-2, Planet Labs)
2. Manual digitization in QGIS:
   - Identify block boundaries from field roads, canopy texture discontinuities
   - Create polygon GeoJSON with `block_id`, `block_name`, `area_ha`
3. Import into `data/real/blocks.geojson`
4. Update `generate_blocks.py` to read from file instead of generating grid

**Output:**
```python
# New generate_blocks.py
def load_manual_blocks(geojson_path):
    """Load pre-digitized block polygons."""
    with open(geojson_path) as f:
        return json.load(f)
```

#### Phase 2: Field Validation Campaign (Q3 2026)

**Objective:** Collect ground truth data for calibration

**Data Collection:**
- **Phenology photos** at 10-15 sites per block:
  - GPS coordinates, date, NDVI-equivalent visual assessment
  - Canopy density, leaf color, pest/disease symptoms
- **Soil moisture sensors** (10 blocks):
  - Volumetric water content at 10, 30, 60 cm depth
  - Compare NDMI vs. sensor data
- **Scouting logs** (all blocks):
  - Pest/disease presence, yield estimates, intervention records
  - Correlate with risk categories

**Analysis:**
```python
# New script: calibrate_formula.py
def compute_correlation(satellite_data, ground_truth):
    """Calculate NDVI, NDMI, rainfall stress vs. field conditions."""
    # Output: updated weights, thresholds, confidence intervals
```

#### Phase 3: Machine Learning Block Detection (Q4 2026)

**Objective:** Automate block boundary detection

**Approach:**
1. Train CNN on satellite imagery + manual annotations
2. Use spectral discontinuities, texture patterns, road networks as features
3. Deployed model: segments raw satellite into block candidates
4. Manual review layer for edge cases

**Framework:**
```python
# New script: detect_blocks_ml.py
from tensorflow import keras
model = keras.models.load_model("block_detector_model.h5")
candidates = model.predict(sentinel2_composite)
```

#### Phase 4: Real-Time Pipeline Integration (Q1 2027)

**Objective:** Operational Day 2 data production

**Workflow:**
```
1. Sentinel-2 API → Check for new imagery daily
2. Cloud-mask → Generate latest RGB/NDVI/NDMI
3. Earth Engine export → GeoTIFF for each indicator
4. Block statistics → Mean/std per block
5. Risk calculation → Apply formula
6. Alert generation → Email/SMS to scouts
7. Dashboard update → Real-time risk maps
```

**File:**
```python
# New: operational_day2_pipeline.py
def main_scheduled():
    latest_s2 = fetch_sentinel2_latest()
    rgb, ndvi, ndmi = generate_indices(latest_s2)
    block_stats = summarize_by_block(blocks_geojson, rgb, ndvi, ndmi)
    risk_scores = calculate_risk_scores(block_stats)
    alert_scouts(priority_blocks=risk_scores[:5])
```

---

## Assumptions and Limitations (Summary)

1. **Synthetic demo data:**
   - Not field-verified; for MVP demonstration only
   - Real satellite pipeline available separately
   - Provenance explicitly labeled

2. **Grid-based blocks (current):**
   - Do NOT reflect real plantation layout
   - Manual calibration required before operational use
   - Roadmap: manual digitization → ML detection

3. **Risk formula:**
   - Weights (0.30, 0.30, 0.25, 0.15) are illustrative
   - Thresholds (0.25, 0.45, 0.65) not empirically calibrated
   - Must be validated against scouting outcomes

4. **Indicator constraints:**
   - NDVI/NDMI: optical indices; sensitive to clouds, atmospheric effects
   - Rainfall: future data source (CHIRPS); estate-level aggregation loses spatial detail
   - Fire risk: hotspot-based; misses slow-burn events

5. **Temporal resolution:**
   - Composite: 180-day median (seasonal smoothing, not near-real-time)
   - Demo updates: manual runs only
   - Roadmap: daily automatic updates

6. **Spatial resolution:**
   - Sentinel-2: 10 m (vegetation, true color)
   - Sentinel-2: 20 m → 10 m resampling (SWIR for moisture)
   - Block size: ~12-15 ha average → several pixels per block ✓

---

## References

### Remote Sensing
- Rouse, J. W., et al. (1973). "Monitoring vegetation systems in the Great Plains with ERTS." NASA Spec. Publ. 353.
- Hunt Jr, E. R., et al. (2011). "A visible band index for remote sensing leaf chlorophyll content at the canopy scale." International Journal of Applied Earth Observation and Geoinformation.

### Sentinel-2
- Copernicus Data Hub: https://scihub.copernicus.eu
- Google Earth Engine: https://earthengine.google.com
- Sentinel-2 bands: https://en.wikipedia.org/wiki/Sentinel-2

### Fire Detection
- NASA FIRMS: https://firms.modaps.eosdis.nasa.gov
- FIRMS data guide: https://www.earthdata.nasa.gov/learn/find-data/near-real-time-data/firms

### Rainfall Data
- CHIRPS: https://www.chc.ucsb.edu/research/chirps
- Climate Engine: https://climateengine.org

### Oil Palm Monitoring
- FAO Remote Sensing for Agricultural Monitoring: http://www.fao.org

---

## Contact & Support

**For questions or calibration requests:**
- Open issue: `CropStress/geospatial/issues`
- Tag: `data-generation`, `calibration`

**Maintenance:** CropStress Geospatial Team
