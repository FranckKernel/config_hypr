#!/usr/bin/env python3
import csv
import json
import math
import time
from pathlib import Path

from typing import Tuple

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

LOCATIONS = Path.home() / ".config/hypr/ignore/locations.csv"
CACHE = Path.home() / ".cache/hypr-location.json"
GOOD_ENOUGH_ACCURACY = 100  # meters; stop early once we're this precise
MAX_WAIT = 120  # seconds; ceiling, rarely hit in practice
CACHE_MAX_AGE = 3600  # seconds; treat cache older than this as stale
CURRENT_LOCATION_FILE = Path.home() / ".config/hypr/ignore/current_location.txt"

DBusGMainLoop(set_as_default=True)
result = {}


def location_updated(old_path, new_path):
    bus = dbus.SystemBus()
    loc = dbus.Interface(
        bus.get_object("org.freedesktop.GeoClue2", new_path),
        "org.freedesktop.DBus.Properties",
    )
    lat = float(loc.Get("org.freedesktop.GeoClue2.Location", "Latitude"))
    lon = float(loc.Get("org.freedesktop.GeoClue2.Location", "Longitude"))
    acc = float(loc.Get("org.freedesktop.GeoClue2.Location", "Accuracy"))
    desc = str(loc.Get("org.freedesktop.GeoClue2.Location", "Description"))
    result["fix"] = (lat, lon, acc, desc)
    print(f"  got fix: {desc} acc={acc}m")  # temporary, for debugging
    if desc in ("WiFi", "GPS") and acc <= GOOD_ENOUGH_ACCURACY:
        loop.quit()


def get_location_live() -> Tuple[float, float, float, str] | None:
    bus = dbus.SystemBus()
    manager = dbus.Interface(
        bus.get_object("org.freedesktop.GeoClue2", "/org/freedesktop/GeoClue2/Manager"),
        "org.freedesktop.GeoClue2.Manager",
    )
    client_path = manager.GetClient()
    client_obj = bus.get_object("org.freedesktop.GeoClue2", client_path)
    client = dbus.Interface(client_obj, "org.freedesktop.GeoClue2.Client")
    props = dbus.Interface(client_obj, "org.freedesktop.DBus.Properties")
    props.Set("org.freedesktop.GeoClue2.Client", "DesktopId", "hypr-location-script")
    props.Set("org.freedesktop.GeoClue2.Client", "RequestedAccuracyLevel", dbus.UInt32(8))

    client.connect_to_signal("LocationUpdated", location_updated)
    client.Start()

    GLib.timeout_add_seconds(MAX_WAIT, loop.quit)
    loop.run()

    if "fix" not in result:
        return None
    return result["fix"]


def load_cache():
    try:
        data = json.loads(CACHE.read_text())
        if time.time() - data["ts"] <= CACHE_MAX_AGE:
            return (data["lat"], data["lon"], data["accuracy"], data["desc"])
    except (FileNotFoundError, KeyError, ValueError):
        pass
    return None


def save_cache(lat, lon, accuracy, desc):
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(
        json.dumps(
            {
                "lat": lat,
                "lon": lon,
                "accuracy": accuracy,
                "desc": desc,
                "ts": time.time(),
            }
        )
    )


def get_location():
    fix = get_location_live()

    if fix is not None:
        lat, lon, accuracy, desc = fix
        save_cache(lat, lon, accuracy, desc)
        return fix
    cached = load_cache()
    if cached is not None:
        return cached
    raise RuntimeError("No location fix received and no usable cache")


def distance(lat1, lon1, lat2, lon2):
    R = 6371000
    p1 = math.radians(lat1)
    p2 = math.radians(lat2)
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dlon / 2) ** 2
    return R * 2 * math.asin(math.sqrt(a))


def find_name(lat, lon):
    with open(LOCATIONS) as f:
        for row in csv.DictReader(f):
            d = distance(lat, lon, float(row["latitude"]), float(row["longitude"]))
            if d <= float(row["radius"]):
                return row["name"]
    return "Unknown"


loop = GLib.MainLoop()
lat, lon, accuracy, desc = get_location()
print(lat, lon, accuracy)
if accuracy > 1000:
    print("Location unreliable:", accuracy, "m")
    exit(1)

location_enum_name = find_name(lat, lon)
CURRENT_LOCATION_FILE.parent.mkdir(parents=True, exist_ok=True)
CURRENT_LOCATION_FILE.write_text(location_enum_name)
print(location_enum_name)
