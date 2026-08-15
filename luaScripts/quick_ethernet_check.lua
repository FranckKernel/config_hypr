local M = {}

local HOME = os.getenv("HOME")

local CURRENT_LOCATION_FILE = HOME .. "/.config/hypr/ignore/current_location.txt"

local ETHERNET_CARRIER_FILE = "/sys/class/net/enp14s0/carrier"

local function ethernet_connected()
	local file = io.open(ETHERNET_CARRIER_FILE, "r")

	if not file then
		return false
	end

	local carrier = file:read("*a")
	file:close()

	return carrier:gsub("%s+", "") == "1"
end

function M.find_location()
	if ethernet_connected() then
		return "Mom"
	end

	return "Dad"
end

function M.main()
	local location = M.find_location()

	local directory = CURRENT_LOCATION_FILE:match("(.+)/[^/]+$")

	if directory then
		os.execute('mkdir -p "' .. directory .. '"')
	end

	local file = io.open(CURRENT_LOCATION_FILE, "w")

	if not file then
		return nil, "Could not open location file for writing"
	end

	file:write(location)
	file:close()

	print(location)

	return location
end

return M
