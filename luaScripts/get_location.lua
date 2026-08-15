local Locations = {
	MOM = "Mom",
	DAD = "Dad",
	UNKOWN = "unknown",
}

local location_file = os.getenv("HOME") .. "/.config/hypr/ignore/current_location.txt"

local function get_location()
	local f = io.open(location_file, "r")
	if not f then
		return Locations.OTHER
	end

	local raw = f:read("*a")
	f:close()

	-- trim whitespace/newline
	raw = raw:gsub("^%s+", ""):gsub("%s+$", "")
	raw = raw:lower()

	for _, value in pairs(Locations) do
		if value:lower() == raw then
			return value
		end
	end

	return Locations.OTHER
end

Location = get_location()

return {
	Locations = Locations,
	Location = Location,
	get_location = get_location,
}
