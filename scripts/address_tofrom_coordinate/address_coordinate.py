#!/usr/bin/env python3

import requests


class Geocoder:
    def __init__(self):
        self.base_url = "https://nominatim.openstreetmap.org"
        self.headers = {"User-Agent": "hypr-location-script"}

    def address_to_coordinates(self, address):
        """
        Convert an address into latitude/longitude.

        Returns:
            tuple: (latitude, longitude)

        Raises:
            ValueError if no result is found.
        """

        url = f"{self.base_url}/search"

        params = {"q": address, "format": "json", "limit": 1}

        response = requests.get(url, params=params, headers=self.headers, timeout=10)

        response.raise_for_status()

        data = response.json()

        if not data:
            raise ValueError(f"Could not find address: {address}")

        return (float(data[0]["lat"]), float(data[0]["lon"]))

    def coordinates_to_address(self, latitude, longitude):
        """
        Convert coordinates into an address.

        Returns:
            str: formatted address

        Raises:
            ValueError if no address is found.
        """

        url = f"{self.base_url}/reverse"

        params = {"lat": latitude, "lon": longitude, "format": "json"}

        response = requests.get(url, params=params, headers=self.headers, timeout=10)

        response.raise_for_status()

        data = response.json()

        if "display_name" not in data:
            raise ValueError(f"Could not find address for {latitude}, {longitude}")

        return data["display_name"]


if __name__ == "__main__":
    geo = Geocoder()

    address = "Polytechnique Montréal"
    lat, lon = geo.address_to_coordinates(address)
    lat, lon = 45.55599617477278, -73.2006229
    lat = 45.550415
    lon = -73.200620

    print(f"Coordinates({address})\n = {lat}, {lon}\n")

    address = geo.coordinates_to_address(lat, lon)

    print(f"Address({lat}, {lon}) = \n{address}\n")
