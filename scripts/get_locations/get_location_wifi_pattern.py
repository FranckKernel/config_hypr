#!/usr/bin/env python3

import csv
import os
import subprocess
from pathlib import Path

CSV_FILE = os.path.expandvars("$HOME/.config/hypr/ignore/locations_wifi_patterns.csv")


def get_wifi_networks():
    result = subprocess.run(
        ["nmcli", "-t", "-f", "SSID", "device", "wifi", "list"],
        capture_output=True,
        text=True,
        check=True,
    )

    return {line.strip() for line in result.stdout.splitlines() if line.strip()}


def load_locations():
    locations = []

    with open(CSV_FILE, newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        for row in reader:
            locations.append(
                {
                    "location": row["location"],
                    "pattern": row["pattern"],
                }
            )

    return locations


def find_location():
    wifi_networks = get_wifi_networks()
    print(wifi_networks)

    a = load_locations()
    print(f"a = {a}")

    for location in load_locations():
        pattern = location["pattern"]

        for wifi in wifi_networks:
            if pattern in wifi:
                return location["location"]

    return "Unknown"


if __name__ == "__main__":

    location_enum_name = find_location()
    CURRENT_LOCATION_FILE = Path.home() / ".config/hypr/ignore/current_location.txt"
    CURRENT_LOCATION_FILE.parent.mkdir(parents=True, exist_ok=True)
    CURRENT_LOCATION_FILE.write_text(location_enum_name)
    print(location_enum_name)
