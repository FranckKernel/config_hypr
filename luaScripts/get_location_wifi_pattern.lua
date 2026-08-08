local csv_file = os.getenv("HOME") .. "/.config/hypr/ignore/locations_wifi_patterns.csv"

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

local function load_locations()
	local locations = {}

	local file = io.open(csv_file, "r")

	if not file then
		return locations
	end

	-- Skip CSV header
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

local function find_location()
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

local locationString = find_location()
local current_location_file = os.getenv("HOME") .. "/.config/hypr/ignore/current_location.txt"
os.execute('mkdir -p "' .. os.getenv("HOME") .. '/.config/hypr/ignore"')

local file = io.open(current_location_file, "w")

if file then
	file:write(locationString)
	file:close()
end

print(locationString)
