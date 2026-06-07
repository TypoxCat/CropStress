"""
edit_blocks.py

Edit blocks

Input:
- detection/blocks.geojson

This script allows edit the blocks coordinates:
1. Edit block
2. Add block
3. Delete block
4. Save & Exit
"""
import json
from pathlib import Path

BLOCKS_FILE = "geospatial/detection/blocks.geojson"


# =====================================
# LOAD
# =====================================

with open(BLOCKS_FILE, "r") as f:
    geojson = json.load(f)

features = geojson["features"]


# =====================================
# HELPERS
# =====================================

def renumber_blocks():

    for i, feature in enumerate(features, start=1):

        block_id = f"B-{i:03d}"

        feature["properties"]["block_id"] = block_id
        feature["properties"]["block_code"] = block_id
        feature["properties"]["block_name"] = f"Block {block_id}"


def get_block_index(block_number):

    idx = block_number - 1

    if idx < 0 or idx >= len(features):
        return None

    return idx


def input_polygon():

    print()
    print("Input polygon coordinates.")
    print("One coordinate per line:")
    print("lat,lon")
    print("Example:")
    print("-0.60,102.51")
    print()
    print("Empty line = finish")
    print()

    coords = []

    while True:

        line = input("> ").strip()

        if line == "":
            break

        lat, lon = map(float, line.split(","))

        coords.append([lon, lat])

    if len(coords) < 3:
        raise ValueError("Polygon needs at least 3 points")

    if coords[0] != coords[-1]:
        coords.append(coords[0])

    return coords


def print_blocks():

    print()
    print("Current blocks:")
    print()

    for i, feature in enumerate(features, start=1):

        print(f"{i:3d} -> {feature['properties']['block_id']}")

    print()


# =====================================
# MENU
# =====================================

while True:

    print()
    print("=" * 40)
    print("BLOCK EDITOR")
    print("=" * 40)

    print("1. Edit block")
    print("2. Add block")
    print("3. Delete block")
    print("4. Swap block numbers")
    print("5. Save & Exit")

    choice = input("\nChoose: ").strip()

    # =================================
    # EDIT
    # =================================

    if choice == "1":

        # print_blocks()

        block_number = int(
            input("Block number to edit: ")
        )

        idx = get_block_index(block_number)

        if idx is None:

            print("Block not found")
            continue

        print()
        print(
            f"Editing {features[idx]['properties']['block_id']}"
        )

        coords = input_polygon()

        features[idx]["geometry"]["coordinates"] = [
            coords
        ]

        print("Updated")

    # =================================
    # ADD
    # =================================

    elif choice == "2":

        # print_blocks()

        insert_after = int(
            input(
                "Insert AFTER block number: "
            )
        )

        idx = get_block_index(insert_after)

        if idx is None:

            print("Invalid block")
            continue

        print()
        print(
            f"New block will be inserted between "
            f"{insert_after} and {insert_after+1}"
        )

        coords = input_polygon()

        new_feature = {
            "type": "Feature",
            "properties": {
                "block_id": "",
                "block_code": "",
                "block_name": "",
                "estate_id": "estate_demo_01",
                "area_ha": 0.0,
                "geometry_provenance": "manual_edit"
            },
            "geometry": {
                "type": "Polygon",
                "coordinates": [
                    coords
                ]
            }
        }

        features.insert(
            idx + 1,
            new_feature
        )

        print(
            "Total features setelah insert:",
            len(features)
        )

        renumber_blocks()

        print("Block inserted")

    # =================================
    # DELETE
    # =================================

    elif choice == "3":

        # print_blocks()

        block_number = int(
            input(
                "Block number to delete: "
            )
        )

        idx = get_block_index(
            block_number
        )

        if idx is None:

            print("Invalid block")
            continue

        deleted = (
            features[idx]["properties"]["block_id"]
        )

        del features[idx]

        renumber_blocks()

        print(
            f"Deleted {deleted}"
        )

    # =================================
    # SWAP
    # =================================

    elif choice == "4":

        # print_blocks()

        block_a = int(
            input("First block number: ")
        )

        block_b = int(
            input("Second block number: ")
        )

        idx_a = get_block_index(block_a)
        idx_b = get_block_index(block_b)

        if idx_a is None or idx_b is None:

            print("Invalid block")
            continue

        features[idx_a], features[idx_b] = (
            features[idx_b],
            features[idx_a]
        )

        renumber_blocks()

        print(
            f"Swapped block {block_a} and {block_b}"
        )
        
    # =================================
    # SAVE
    # =================================

    elif choice == "5":

        renumber_blocks()

        with open(
            BLOCKS_FILE,
            "w"
        ) as f:

            json.dump(
                geojson,
                f,
                indent=2
            )

        print()
        print("Saved blocks.geojson")
        print(
            f"Total blocks = {len(features)}"
        )

        break

    else:

        print("Invalid choice")