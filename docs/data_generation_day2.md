# Day 2 Data Generation Documentation

## Overview

Day 2 data generation extends the CropStress pipeline to process real satellite imagery with manual polygon-based block calibration and detection. This document describes three key Python scripts and their integration workflow.

---

## Executive Summary

The Day 2 workflow involves:

1. **`generate_images.py`** - Download and preprocess satellite imagery
2. **`generate_blocks.py`** - Detect plantation block boundaries from imagery using polygon calibration
3. **`generate_day2_data.py`** - Calculate indicators and risk scores from detected blocks

**Current Status**: Block detection per oil palm block is not yet accurate. Manual polygon labeling of plantation blocks is required to calibrate and validate detection algorithms.

---

## Script 1: `generate_images.py`

### Purpose

Download and preprocess satellite imagery for a given area of interest (AOI).

### Responsibilities

- Fetch Sentinel-2 or other satellite data from Google Earth Engine
- Preprocess imagery (cloud masking, band selection, resampling)
- Compute derived indices (NDVI, NDMI, etc.)
- Save preprocessed imagery as GeoTIFF or other raster formats
- Generate quick-look PNG images for manual inspection

### Key Inputs

- **AOI geometry** (from `blocks.geojson` or estate boundary)
- **Date range** (observation period)
- **Cloud cover threshold** (filtering)

### Key Outputs

- `data/day2/satellite_raw/sentinel2_<date>.tif` - Raw Sentinel-2 bands
- `data/day2/satellite_processed/indices_<date>.tif` - Computed NDVI, NDMI
- `data/day2/quicklook/visual_<date>.png` - RGB preview for inspection

### Implementation Notes

- Should support multiple satellite sources (Sentinel-2, Planet Labs, etc.)
- Include cloud masking and data quality flags
- Store metadata (acquisition date, cloud cover %, data gaps) in JSON

---

## Script 2: `generate_blocks.py`

### Purpose

Detect plantation block boundaries from satellite imagery using calibration with manually labeled polygon regions.

### Motivation for Manual Calibration

**Current Problem**: Automated block detection is not accurate enough per oil palm block. This is because:

- Oil palm blocks are small, uniform patches with subtle spectral differences
- Block boundaries may not align cleanly with sharp spectral transitions
- Adjacent blocks often have similar phenology and spectral signatures
- Automated segmentation produces fragmented or over-merged regions

**Solution**: Use manual polygon labeling to establish calibration samples that train or constrain the detection algorithm.

### Responsibilities

- Load preprocessed satellite imagery from `generate_images.py`
- Load manually labeled polygon calibration dataset
- Segment imagery using spectral + morphological methods
- Match detected segments to known block labels (via spatial overlap)
- Validate detection accuracy against labeled samples
- Output refined block polygons with confidence scores

### Key Inputs

- **Preprocessed imagery** (`data/day2/satellite_processed/indices_<date>.tif`)
- **Manual calibration polygons** (`data/day2/calibration/labeled_blocks.geojson`)
  - GeoJSON file with polygon features
  - Each feature has properties:
    - `block_id`: unique identifier
    - `block_code`: human-readable code
    - `manual_label`: "oil_palm" | "other_vegetation" | "non_vegetation"
    - `confidence`: 1.0 (manually verified)
    - `date_labeled`: ISO date of manual labeling

### Key Outputs

- `data/day2/detected_blocks_<date>.geojson` - Detected block polygons with confidence scores
- `data/day2/detection_report.json` - Accuracy metrics against calibration labels
  - Precision, recall, F1-score per block
  - Overall segmentation accuracy
  - False positive / false negative counts

### Implementation Approach

1. **Segmentation**
   - Use spectral clustering or watershed segmentation on vegetation indices
   - Filter by area (keep patches 0.5–10 ha, typical for oil palm blocks)

2. **Calibration Matching**
   - For each manually labeled polygon:
     - Find detected segments with >50% spatial overlap
     - Collect spectral statistics (mean NDVI, NDMI, texture, etc.) for true blocks
   - Build a decision model to distinguish true blocks from noise

3. **Detection Refinement**
   - Apply spectral thresholds learned from calibration
   - Filter out undersized or over-segmented regions
   - Smooth polygon boundaries using morphological operations

4. **Validation**
   - Compute precision/recall against manually labeled regions
   - Flag low-confidence detections for manual review
   - Generate visual comparison maps

### Example Calibration GeoJSON

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "block_id": "B-001-CAL",
        "block_code": "BLK-001",
        "manual_label": "oil_palm",
        "confidence": 1.0,
        "date_labeled": "2026-06-01",
        "notes": "Uniform palm stand, healthy condition"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[[101.360, -0.530], [101.365, -0.530], [101.365, -0.535], [101.360, -0.535], [101.360, -0.530]]]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "block_id": "B-002-CAL",
        "block_code": "BLK-002",
        "manual_label": "oil_palm",
        "confidence": 1.0,
        "date_labeled": "2026-06-01",
        "notes": "Block with stress patch in SE corner"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[[101.365, -0.530], [101.370, -0.530], [101.370, -0.535], [101.365, -0.535], [101.365, -0.530]]]
      }
    }
  ]
}
```

---

## Script 3: `generate_day2_data.py`

### Purpose

Calculate block-level crop stress indicators and risk scores using detected blocks from Day 2.

### Responsibilities

- Load detected block polygons from `generate_blocks.py`
- Load preprocessed satellite imagery
- Calculate zonal statistics (mean, std, min, max) for each block:
  - NDVI (vegetation greenness)
  - NDMI (canopy moisture)
  - Texture features (GLCM contrast, dissimilarity)
- Extract rainfall data (from external sources or preprocessed)
- Extract hotspot data (fire risk signals)
- Calculate risk score using the Day 1 formula
- Rank blocks by priority for field scouting
- Output JSON and GeoJSON results

### Key Inputs

- **Detected blocks** (`data/day2/detected_blocks_<date>.geojson`)
- **Satellite indices** (`data/day2/satellite_processed/indices_<date>.tif`)
- **Rainfall data** (external: Climate Hazards Group, NOAA, etc.)
- **Hotspot data** (FIRMS via Google Earth Engine or download)

### Key Outputs

- `data/day2/block_indicators_day2_<date>.json` - Per-block satellite indicators
- `data/day2/risk_scores_day2_<date>.json` - Risk components and final scores
- `data/day2/scouting_priority_day2_<date>.json` - Ranked scouting list
- `data/day2/blocks_with_risk_day2_<date>.geojson` - GeoJSON with risk scores

### Example Output Structure

#### `block_indicators_day2_<date>.json`

```json
{
  "block_id": "B-001-DET",
  "detection_source": "generate_blocks.py",
  "detection_confidence": 0.92,
  "observation_date": "2026-06-01",
  "ndvi": 0.7241,
  "ndvi_std": 0.0521,
  "ndvi_min": 0.6120,
  "ndvi_max": 0.8450,
  "ndvi_baseline": 0.7100,
  "ndvi_anomaly": 0.0141,
  "ndmi": 0.3852,
  "ndmi_std": 0.0381,
  "ndmi_baseline": 0.3900,
  "ndmi_anomaly": -0.0048,
  "texture_contrast": 0.0542,
  "rainfall_30d_mm": 82.3,
  "rainfall_baseline_mm": 95.0,
  "rainfall_deficit_pct": 13.4,
  "hotspot_count_7d": 0,
  "nearest_hotspot_km": 18.5,
  "quality_flag": "day2_detected_polygon"
}
```

#### `risk_scores_day2_<date>.json`

```json
{
  "block_id": "B-001-DET",
  "score_date": "2026-06-01",
  "vegetation_stress": 0.08,
  "moisture_stress": 0.02,
  "rainfall_stress": 0.22,
  "fire_risk": 0.0,
  "risk_score": 0.110,
  "risk_category": "Watch",
  "dominant_driver": "Rainfall deficit",
  "recommended_action": "Monitor next processing cycle",
  "detection_confidence_adjusted": 0.92
}
```

---

## Data Flow Diagram

```
                      ┌─────────────────────┐
                      │ Satellite Imagery   │
                      │ (Sentinel-2, etc.)  │
                      └──────────┬──────────┘
                                 │
                   ┌─────────────▼──────────────┐
                   │ generate_images.py         │
                   │ (preprocess, indices)      │
                   └──────────┬────────────────┘
                              │
        ┌─────────────────────┴──────────────────────┐
        │                                            │
        │         Preprocessed Imagery               │
        │    (satellite_processed/indices_<date>.tif)
        │                                            │
        ├────────────────────────┬───────────────────┤
        │                        │                   │
        │              ┌─────────▼───────────┐       │
        │              │ Manual Calibration  │       │
        │              │ Polygon Labels      │       │
        │              │ (labeled_blocks.    │       │
        │              │  geojson)           │       │
        │              └──────────┬──────────┘       │
        │                         │                  │
        │      ┌──────────────────▼────────┐         │
        │      │ generate_blocks.py        │         │
        │      │ (detect blocks)           │         │
        │      └──────────────┬─────────────┘         │
        │                    │                      │
        │    Detected Blocks │                      │
        │ (detected_blocks_  │                      │
        │  <date>.geojson)   │                      │
        │                    │                      │
        │      ┌─────────────▼────────────┐         │
        │      │ generate_day2_data.py    │         │
        │      │ (zonal stats, risk calc) │         │
        │      └──────────┬───────────────┘         │
        │                 │                        │
        └─────────────────┼────────────────────────┘
                          │
              ┌───────────┴──────────┐
              │                      │
        ┌─────▼───────┐        ┌────▼──────┐
        │ Indicators  │        │ Risk      │
        │ JSON        │        │ Scores    │
        │             │        │ JSON      │
        └─────────────┘        └───────────┘
```

---

## Workflow and Integration

### Step 1: Generate Images

```bash
python geospatial/scripts/generate_images.py \
  --aoi data/demo/blocks.geojson \
  --date-start 2026-05-15 \
  --date-end 2026-06-05 \
  --cloud-threshold 20
```

**Outputs**:
- `data/day2/satellite_raw/sentinel2_2026-06-05.tif`
- `data/day2/satellite_processed/indices_2026-06-05.tif`
- `data/day2/quicklook/visual_2026-06-05.png`

### Step 2: Manual Calibration (Interactive / GIS Tool)

Using QGIS or a web GIS tool:

1. Load `data/day2/quicklook/visual_<date>.png` as background
2. Load `data/day2/satellite_processed/indices_<date>.tif` for inspection
3. Manually digitize 10–20 sample plantation blocks (representative of AOI)
4. Label each polygon with properties (block_code, label, confidence)
5. Save as `data/day2/calibration/labeled_blocks.geojson`

**Calibration sample strategy**:
- Cover different parts of the AOI (corners, center)
- Include blocks with different stress levels (if visible)
- Include healthy, watch, and warning blocks

### Step 3: Detect Blocks

```bash
python geospatial/scripts/generate_blocks.py \
  --imagery data/day2/satellite_processed/indices_2026-06-05.tif \
  --calibration data/day2/calibration/labeled_blocks.geojson \
  --output-dir data/day2
```

**Outputs**:
- `data/day2/detected_blocks_2026-06-05.geojson`
- `data/day2/detection_report.json`

**Validation**:
```bash
cat data/day2/detection_report.json
# Check precision, recall, F1-score
# If accuracy < 80%, refine calibration samples
```

### Step 4: Calculate Indicators and Risk

```bash
python geospatial/scripts/generate_day2_data.py \
  --blocks data/day2/detected_blocks_2026-06-05.geojson \
  --imagery data/day2/satellite_processed/indices_2026-06-05.tif \
  --output-dir data/day2
```

**Outputs**:
- `data/day2/block_indicators_day2_2026-06-05.json`
- `data/day2/risk_scores_day2_2026-06-05.json`
- `data/day2/scouting_priority_day2_2026-06-05.json`
- `data/day2/blocks_with_risk_day2_2026-06-05.geojson`

---

## Calibration and Validation

### Calibration Requirements

**Minimum**: 10–15 manually labeled block polygons
**Recommended**: 20–30 polygons covering ~10% of total block count

#### Labeling Checklist

For each calibration polygon, verify:

- [ ] Polygon boundary aligns with visible block boundary in quicklook
- [ ] Polygon is labeled as "oil_palm" (or appropriate type)
- [ ] Confidence is set to 1.0 (manual verification)
- [ ] Date labeled is current or recent
- [ ] Polygon has no self-intersections or slivers
- [ ] Polygon area is within expected range (0.5–10 ha)

#### Accuracy Targets

After detection, aim for:

- **Precision ≥ 80%**: Detected polygons are real blocks
- **Recall ≥ 80%**: Most true blocks are detected
- **F1-Score ≥ 80%**: Balanced performance

If metrics fall below 80%:
1. Review false positives (detected regions that are not blocks)
2. Review false negatives (blocks missed by detector)
3. Adjust segmentation parameters or add more calibration samples
4. Re-run detection

---

## Current Known Issues and Future Work

### Known Issues

1. **Block detection is not yet per-block accurate**
   - Detected polygons may be undersegmented (multiple blocks merged) or oversegmented (blocks split)
   - Requires calibration refinement and parameter tuning

2. **Manual labeling is labor-intensive**
   - Scaling to large estates (1000+ blocks) requires semi-automated tools
   - Consider interactive labeling tools or crowdsourcing

3. **Seasonal and stress variations affect detection**
   - Blocks under stress may have different spectral signatures
   - Calibration may need seasonal updates

### Recommended Next Steps

1. **Implement interactive labeling tool**
   - Web-based polygon digitizer with quick-look feedback
   - Allow rapid correction of auto-detected boundaries

2. **Develop baseline detection models**
   - Train machine learning models (e.g., Random Forest) on calibration samples
   - Use spectral, textural, and morphological features

3. **Multi-temporal detection**
   - Use time series of satellite imagery to improve block delineation
   - Track block boundaries across seasons

4. **Integrate object detection (deep learning)**
   - Train CNN models on manually labeled blocks
   - Automate boundary refinement

5. **Field validation workflow**
   - Compare detected blocks with GPS ground truth from scouting teams
   - Iteratively improve detection model

---

## File Organization

```
geospatial/
├── scripts/
│   ├── generate_day1_data.py                    (existing)
│   ├── generate_day1_real_satellite_data.py     (existing)
│   ├── generate_images.py                       (Day 2 - download & preprocess)
│   ├── generate_blocks.py                       (Day 2 - detect blocks)
│   └── generate_day2_data.py                    (Day 2 - indicators & risk)
│
├── data/
│   ├── demo/                                    (Day 1 demo data)
│   │   ├── blocks.geojson
│   │   ├── block_indicators_latest.json
│   │   ├── risk_scores_latest.json
│   │   └── scouting_priority_latest.json
│   │
│   └── day2/                                    (Day 2 data)
│       ├── satellite_raw/
│       │   └── sentinel2_2026-06-05.tif
│       ├── satellite_processed/
│       │   └── indices_2026-06-05.tif
│       ├── quicklook/
│       │   └── visual_2026-06-05.png
│       ├── calibration/
│       │   └── labeled_blocks.geojson           (manual labels)
│       ├── detected_blocks_2026-06-05.geojson
│       ├── detection_report.json
│       ├── block_indicators_day2_2026-06-05.json
│       ├── risk_scores_day2_2026-06-05.json
│       ├── scouting_priority_day2_2026-06-05.json
│       └── blocks_with_risk_day2_2026-06-05.geojson
│
└── docs/
    ├── data_generation_day1.md                  (existing)
    ├── database_day1.md                         (existing)
    └── data_generation_day2.md                  (this file)
```

---

## Performance and Optimization

### Memory and Processing

- **Satellite imagery**: 1–10 GB per scene (depending on resolution)
- **Block detection**: O(n) segmentation complexity on pixel count
- **Zonal statistics**: O(b × p) where b = blocks, p = pixels per block

### Recommendations

- Process imagery in tiles if AOI is large (>100 km²)
- Use parallel processing for multi-date processing
- Cache preprocessed indices to avoid recomputation

---

## References and Resources

- **Google Earth Engine**: https://developers.google.com/earth-engine
- **Sentinel-2 Bands**: https://earth.esa.int/web/sentinel/user-guides/sentinel-2-msi/resolutions/radiometric
- **NDVI Formula**: https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index
- **NDMI Formula**: https://en.wikipedia.org/wiki/Normalized_difference_moisture_index
- **Rasterio** (for GeoTIFF processing): https://rasterio.readthedocs.io/
- **Fiona** (for GeoJSON): https://fiona.readthedocs.io/

---

## Summary Table

| Script | Input | Key Process | Output | Status |
|--------|-------|-------------|--------|--------|
| `generate_images.py` | Satellite source, AOI | Download, preprocess indices | GeoTIFF, quicklook PNG | Design phase |
| `generate_blocks.py` | Imagery, calibration polygons | Segment + match to labels | Detected blocks GeoJSON, accuracy report | Design phase |
| `generate_day2_data.py` | Detected blocks, imagery | Zonal stats, risk calc | Indicators, risk scores JSON | Design phase |

---

**Document Status**: Draft  
**Last Updated**: 2026-06-05  
**Next Review**: After pilot implementation of Day 2 scripts
