#!/usr/bin/env python3

from pathlib import Path
from datetime import date, timedelta
import cv2
import json
import ee
import os
from dotenv import load_dotenv
import urllib.request

# ==================================================
# CONFIG
# ==================================================

BASE_DIR = Path(__file__).resolve().parents[1]

BLOCKS_PATH = BASE_DIR / "data" / "real" / "blocks.geojson"
IMAGE_DIR = BASE_DIR / "data" / "images"

IMAGE_PADDING_METERS = 500
IMAGE_DIMENSIONS = 1600

OBSERVATION_DATE = date.today()

CURRENT_END = OBSERVATION_DATE
CURRENT_START_S2 = OBSERVATION_DATE - timedelta(days=180)

date_tag = (
    OBSERVATION_DATE
    .isoformat()
)

# ==================================================
# EE INIT
# ==================================================
def ee_init():
    load_dotenv()
    PROJECT_ID = os.getenv(
        "GOOGLE_CLOUD_PROJECT"
    )

    if not PROJECT_ID:
        raise RuntimeError(
            "Missing GOOGLE_CLOUD_PROJECT in .env"
        )

    try:

        ee.Initialize(
            project=PROJECT_ID
        )

    except:

        ee.Authenticate()

        ee.Initialize(
            project=PROJECT_ID
        )

# ==================================================
# SENTINEL
# ==================================================

def get_s2_sr_cld_col(
    aoi,
    start_date,
    end_date
):

    s2_sr_col = (
        ee.ImageCollection(
            "COPERNICUS/S2_SR_HARMONIZED"
        )
        .filterBounds(aoi)
        .filterDate(
            start_date,
            end_date
        )
        .filter(
            ee.Filter.lte(
                "CLOUDY_PIXEL_PERCENTAGE",
                80
            )
        )
    )

    s2_cloudless_col = (
        ee.ImageCollection(
            "COPERNICUS/S2_CLOUD_PROBABILITY"
        )
        .filterBounds(aoi)
        .filterDate(
            start_date,
            end_date
        )
    )

    return ee.ImageCollection(
        ee.Join.saveFirst(
            "s2cloudless"
        ).apply(
            primary=s2_sr_col,
            secondary=s2_cloudless_col,
            condition=ee.Filter.equals(
                leftField="system:index",
                rightField="system:index"
            )
        )
    )

# ==================================================
# CLOUD MASK
# ==================================================

def add_cloud_bands(img):

    cld_prb = (
        ee.Image(
            img.get(
                "s2cloudless"
            )
        )
        .select(
            "probability"
        )
    )

    is_cloud = (
        cld_prb
        .gt(40)
        .rename("clouds")
    )

    return img.addBands(
        ee.Image(
            [cld_prb, is_cloud]
        )
    )

def apply_cld_mask(img):

    not_cld = (
        img.select("clouds")
        .Not()
    )

    return (
        img.select("B.*")
        .updateMask(not_cld)
    )

# ==================================================
# AOI
# ==================================================

def padded_aoi(
    aoi,
    padding_meters
):

    return (
        aoi
        .bounds(maxError=1)
        .buffer(padding_meters)
        .bounds(maxError=1)
    )

# ==================================================
# GEOJSON BOUNDS
# ==================================================

def get_bounds_from_geojson(
    blocks_geojson
):

    all_lon = []
    all_lat = []

    for feature in blocks_geojson["features"]:

        coords = (
            feature["geometry"]
            ["coordinates"][0]
        )

        for lon, lat in coords:

            all_lon.append(lon)
            all_lat.append(lat)

    return {
        "min_lon": min(all_lon),
        "max_lon": max(all_lon),
        "min_lat": min(all_lat),
        "max_lat": max(all_lat)
    }

# ==================================================
# EE RECTANGLE -> BOUNDS
# ==================================================

def get_rectangle_bounds(
    rect
):

    coords = (
        rect.coordinates()
        .getInfo()[0]
    )

    lons = [
        p[0]
        for p in coords
    ]

    lats = [
        p[1]
        for p in coords
    ]

    return {
        "min_lon": min(lons),
        "max_lon": max(lons),
        "min_lat": min(lats),
        "max_lat": max(lats)
    }

# ==================================================
# SAVE IMAGE
# ==================================================

def save_ee_png(
    image,
    path,
    region,
    dimensions
):

    url = image.getThumbURL({
        "region": region,
        "dimensions": dimensions,
        "format": "png"
    })

    path.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    urllib.request.urlretrieve(
        url,
        path
    )

    print(
        f"  ✓ {path.name}"
    )

# ==================================================
# download padded
# ==================================================

def download_padded_images():

    if not BLOCKS_PATH.exists():

        print(
            f"ERROR: {BLOCKS_PATH} not found"
        )

        return

    with open(
        BLOCKS_PATH,
        "r",
        encoding="utf-8"
    ) as f:

        blocks_geojson = json.load(f)

    bounds = (
        blocks_geojson["properties"]["bounds"]
    )

    print()
    print("EXACT BOUNDS")
    print(bounds)

    blocks_fc = ee.FeatureCollection([
        ee.Feature(
            ee.Geometry(
                f["geometry"]
            ),
            f["properties"]
        )
        for f in blocks_geojson["features"]
    ])

    aoi = ee.Geometry.Rectangle(
        [
            bounds["min_lon"],
            bounds["min_lat"],
            bounds["max_lon"],
            bounds["max_lat"]
        ],
        proj="EPSG:4326",
        geodesic=False
    )

    region_padded = aoi

    region_exact = padded_aoi(
        aoi,
        -IMAGE_PADDING_METERS
    )

    exact_bounds = (
        get_rectangle_bounds(
            region_exact
        )
    )

    padded_bounds = (
        get_rectangle_bounds(
            region_padded
        )
    )

    print()
    print("PADDED BOUNDS")
    print(padded_bounds)

    print()
    print(
        f"Generating imagery for "
        f"{len(blocks_geojson['features'])} blocks..."
    )

    # ==========================================
    # FETCH SENTINEL ONCE
    # ==========================================

    col = get_s2_sr_cld_col(
        aoi,
        CURRENT_START_S2.isoformat(),
        CURRENT_END.isoformat()
    )

    col = (
        col
        .map(add_cloud_bands)
        .map(apply_cld_mask)
    )

    n_images = (
        col.size()
        .getInfo()
    )

    if n_images == 0:

        print(
            "ERROR: No imagery found"
        )

        return

    print(
        f"✓ Using {n_images} images"
    )

    comp = col.median()

    # ==========================================
    # PRODUCTS
    # ==========================================

    rgb = comp.select(
        ["B4","B3","B2"]
    )

    ndvi = (
        comp.normalizedDifference(
            ["B8","B4"]
        )
        .rename("ndvi")
    )

    ndmi = (
        comp.normalizedDifference(
            ["B8","B11"]
        )
        .rename("ndmi")
    )

    real_map = rgb.visualize(
        bands=["B4","B3","B2"],
        min=0,
        max=2500,
        gamma=1.1
    )

    ndvi_map = ndvi.visualize(
        min=0.0,
        max=0.9,
        palette=[
            "8b0000",
            "d73027",
            "fee08b",
            "d9ef8b",
            "1a9850",
            "006400"
        ]
    )

    ndmi_map = ndmi.visualize(
        min=-0.4,
        max=0.6,
        palette=[
            "8c510a",
            "d8b365",
            "f6e8c3",
            "c7eae5",
            "5ab4ac",
            "01665e"
        ]
    )

    # ==========================================
    # SAVE BOUNDS
    # ==========================================

    bounds_json = {
        "exact": exact_bounds,
        "padded": padded_bounds,
        "padding_meters":
            IMAGE_PADDING_METERS
    }

    with open(
        IMAGE_DIR /
        f"bounds_{date_tag}.json",
        "w"
    ) as f:

        json.dump(
            bounds_json,
            f,
            indent=2
        )

    # ==========================================
    # SAVE IMAGES
    # ==========================================

    print()
    # print("Saving exact images...")

    # save_ee_png(
    #     real_map,
    #     IMAGE_DIR /
    #     f"real_map_{date_tag}.png",
    #     region_exact,
    #     IMAGE_DIMENSIONS
    # )

    # save_ee_png(
    #     ndvi_map,
    #     IMAGE_DIR /
    #     f"ndvi_map_{date_tag}.png",
    #     region_exact,
    #     IMAGE_DIMENSIONS
    # )

    # save_ee_png(
    #     ndmi_map,
    #     IMAGE_DIR /
    #     f"ndmi_map_{date_tag}.png",
    #     region_exact,
    #     IMAGE_DIMENSIONS
    # )

    print()
    print("Saving padded images...")

    save_ee_png(
        real_map,
        IMAGE_DIR /
        f"real_map_padded_{date_tag}.png",
        region_padded,
        IMAGE_DIMENSIONS
    )

    save_ee_png(
        ndvi_map,
        IMAGE_DIR /
        f"ndvi_map_padded_{date_tag}.png",
        region_padded,
        IMAGE_DIMENSIONS
    )

    save_ee_png(
        ndmi_map,
        IMAGE_DIR /
        f"ndmi_map_padded_{date_tag}.png",
        region_padded,
        IMAGE_DIMENSIONS
    )

    print()
    print(
        f"Images saved to {IMAGE_DIR}"
    )

    print(
        f"Bounds saved to "
        f"{IMAGE_DIR / 'image_bounds.json'}"
    )
def geo_to_pixel(
    lon,
    lat,
    bounds,
    W,
    H
):

    px = (
        (lon - bounds["min_lon"])
        /
        (bounds["max_lon"] - bounds["min_lon"])
        * W
    )

    py = (
        (bounds["max_lat"] - lat)
        /
        (bounds["max_lat"] - bounds["min_lat"])
        * H
    )

    return (
        int(round(px)),
        int(round(py))
    )

def crop_from_bounds(
    src_path,
    dst_path,
    padded_bounds,
    exact_bounds
):

    img = cv2.imread(
        str(src_path)
    )

    if img is None:

        print(
            f"Cannot open {src_path}"
        )
        return

    H, W = img.shape[:2]

    x1, y1 = geo_to_pixel(
        exact_bounds["min_lon"],
        exact_bounds["max_lat"],
        padded_bounds,
        W,
        H
    )

    x2, y2 = geo_to_pixel(
        exact_bounds["max_lon"],
        exact_bounds["min_lat"],
        padded_bounds,
        W,
        H
    )

    x1 = max(0, min(W, x1))
    x2 = max(0, min(W, x2))

    y1 = max(0, min(H, y1))
    y2 = max(0, min(H, y2))

    crop = img[
        y1:y2,
        x1:x2
    ]

    cv2.imwrite(
        str(dst_path),
        crop
    )

    print(
        f"✓ {dst_path.name}"
    )

def crop_existing_images():
    bounds_file = (
        IMAGE_DIR /
        f"bounds_{date_tag}.json"
    )

    if not bounds_file.exists():

        print(
            "Bounds file not found"
        )
        return

    with open(bounds_file) as f:

        bounds = json.load(f)

    exact_bounds = (
        bounds["exact"]
    )

    padded_bounds = (
        bounds["padded"]
    )

    image_names = [
        "real_map",
        "ndvi_map",
        "ndmi_map"
    ]

    for name in image_names:

        src = (
            IMAGE_DIR /
            f"{name}_padded_{date_tag}.png"
        )

        dst = (
            IMAGE_DIR /
            f"{name}_{date_tag}.png"
        )

        if not src.exists():

            print(
                f"Skip: {src.name}"
            )
            continue

        crop_from_bounds(
            src,
            dst,
            padded_bounds,
            exact_bounds
        )

    print()
    print("Done")

# ==================================================
# MAIN
# ==================================================

def main():

    print()
    print(
        "1. Download padded imagery"
    )
    print(
        "2. Crop existing padded imagery"
    )

    choice = input(
        "\nChoice: "
    ).strip()

    if choice == "2":

        crop_existing_images()
        return

    if choice == "1":
        ee_init()
        download_padded_images()
        return

    print(
        "Invalid choice"
    )


if __name__ == "__main__":
    main()