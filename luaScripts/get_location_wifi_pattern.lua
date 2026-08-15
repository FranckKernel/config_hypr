local M = {}

local gu = require("luaScripts.general_utils")

local HOME = os.getenv("HOME")

local CSV_FILE = HOME .. "/.config/hypr/ignore/locations_wifi_patterns.csv"

local CURRENT_LOCATION_FILE = HOME .. "/.config/hypr/ignore/current_location.txt"

--------------------------------------------------
-- WiFi
--------------------------------------------------

local function get_wifi_networks()
	local networks = {}

	local handle = io.popen("nmcli -t -f SSID device wifi list 2>/dev/null")

	if not handle then
		return networks
	end

	for ssid in handle:lines() do
		if ssid ~= "" then
			table.insert(networks, ssid)
		end
	end

	handle:close()

	return networks
end

--------------------------------------------------
-- Location patterns
--------------------------------------------------

local function load_locations()
	local locations = {}

	local file = io.open(CSV_FILE, "r")

	if not file then
		return locations
	end

	-- Skip CSV header.
	file:read("*line")

	for line in file:lines() do
		local location, pattern = line:match("^([^,]+),([^,]+)$")

		if location and pattern then
			table.insert(locations, {
				location = location,
				pattern = pattern,
			})
		end
	end

	file:close()

	return locations
end

--------------------------------------------------
-- Location detection
--------------------------------------------------

function M.find_location()
	local wifi_networks = get_wifi_networks()
	local locations = load_locations()

	for _, location in ipairs(locations) do
		for _, wifi in ipairs(wifi_networks) do
			if wifi:find(location.pattern, 1, true) then
				return location.location
			end
		end
	end

	return "Unknown"
end

--------------------------------------------------
-- Main
--------------------------------------------------

function M.main()
	local location = M.find_location()

	if not gu.write_file(CURRENT_LOCATION_FILE, location) then
		return nil, "Could not write location file"
	end

	print(location)

	return location
end

return M
