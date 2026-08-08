from pathlib import Path

CURRENT_LOCATION_FILE = Path.home() / ".config/hypr/ignore/current_location.txt"


def ethernet_connected():
    try:
        return Path("/sys/class/net/enp14s0/carrier").read_text().strip() == "1"
    except (FileNotFoundError, OSError):
        return False


def find_location():
    if ethernet_connected():
        return "Mom"

    return "Unknown"


if __name__ == "__main__":
    location = find_location()

    CURRENT_LOCATION_FILE.parent.mkdir(parents=True, exist_ok=True)
    CURRENT_LOCATION_FILE.write_text(location)

    print(location)
