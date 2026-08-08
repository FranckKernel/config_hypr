local gu = require("luaScripts.general_utils")
-- local gu = require("general_utils")

local function get_max_resolution(monitor_name)
	-- This will 100% fail if loaded from the hyprland config script
	local handle = io.popen("hyprctl monitors -j | jq -r '.[] | select(.name == \"" .. monitor_name .. "\") | .availableModes[]'")

	if not handle then
		return 1920, 1080
	end

	local max_width = 1920
	local max_height = 1080

	for mode in handle:lines() do
		local width, height = mode:match("^(%d+)x(%d+)@")

		width = tonumber(width)
		height = tonumber(height)

		if width and height and width * height > max_width * max_height then
			max_width = width
			max_height = height
		end
	end

	handle:close()

	return max_width, max_height
end

local max_width, max_height = get_max_resolution("DP-1")
gu.send_notification("DP-1 maximum resolution: " .. max_width .. "x" .. max_height)
