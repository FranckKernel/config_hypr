local CURRENT_LOCATION_FILE = os.getenv("HOME") .. "/.config/hypr/ignore/current_location.txt"

local function ethernet_connected()
	local file = io.open("/sys/class/net/enp14s0/carrier", "r")

	if not file then
		return false
	end

	local state = file:read("*l")
	file:close()

	return state == "1"
end

local function find_location()
	if ethernet_connected() then
		return "Mom"
	end

	return "Unknown"
end

local location = find_location()

os.execute('mkdir -p "' .. os.getenv("HOME") .. '/.config/hypr/ignore"')

local file = io.open(CURRENT_LOCATION_FILE, "w")

if file then
	file:write(location)
	file:close()
end

print(location)

return {}
