local M = {}

--------------------------------------------------
-- Configuration
--------------------------------------------------

local HOME = os.getenv("HOME")

local LOCATION_FILE = HOME .. "/.config/hypr/ignore/current_location.txt"

local MONITOR_FILE = HOME .. "/.config/hypr/ignore/plugged_monitors.txt"

local NOTIFY_APP_NAME = "Location Script"
local NOTIFY_DURATION_MS = 5000

--------------------------------------------------
-- Modules
--------------------------------------------------

local gu = require("luaScripts.general_utils")

-- local geoclue_location = require("luaScripts.get_location")
-- local wifi_name_location = require("luaScripts.get_location_wifi_pattern")
local quick_ethernet_check = require("luaScripts.quick_ethernet_check")

local usedLocationScript = quick_ethernet_check

--------------------------------------------------
-- Notifications
--------------------------------------------------

local function notify_msg(content, title2)
	title2 = title2 or ""

	-- One day, if the notification daemon displays the application
	-- name separately, remove this and use title2 instead.
	local display_title2 = NOTIFY_APP_NAME

	os.execute(
		"notify-send "
			.. '-a "'
			.. NOTIFY_APP_NAME
			.. '" '
			.. "-t "
			.. NOTIFY_DURATION_MS
			.. " "
			.. '"'
			.. display_title2
			.. '" '
			.. '"'
			.. content
			.. '"'
	)
end

--------------------------------------------------
-- Main
--------------------------------------------------

function M.main()
	--------------------------------------------------
	-- Read location before update
	--------------------------------------------------

	local pre_change_location = gu.read_file(LOCATION_FILE)

	--------------------------------------------------
	-- Detect location
	--------------------------------------------------

	local post_change_location = usedLocationScript.main()

	if not post_change_location then
		notify_msg("Location detection failed", "Error")

		return 3
	end

	--------------------------------------------------
	-- Always update monitor information
	--------------------------------------------------

	local monitors, monitor_code = gu.run_hyprctl("monitors -j | jq -r '.[].name'")
	gu.notify_table(monitors)
	gu.send_notification("monitor_code = " .. monitor_code)

	if monitor_code ~= 0 or not monitors then
		notify_msg("Failed to get monitor information", "Error")
		return 4
	end

	monitors = monitors:gsub("%s+$", "")

	local monitor_count = 0

	for _ in monitors:gmatch("[^\r\n]+") do
		monitor_count = monitor_count + 1
	end

	local monitor_file_contents = tostring(monitor_count) .. "\n" .. monitors .. "\n"

	if not gu.write_file(MONITOR_FILE, monitor_file_contents) then
		notify_msg("Failed to write monitor information", "Error")

		return 4
	end

	--------------------------------------------------
	-- Reload Hyprland if location changed
	--------------------------------------------------

	if pre_change_location ~= post_change_location then
		local _, reload_code = gu.run_hyprctl("reload")

		if reload_code ~= 0 then
			notify_msg("Hyprland reload failed (check config syntax)", "Error")

			return 4
		end

		notify_msg("Reloading")

		--------------------------------------------------
		-- Fix workspace/monitor assignment
		--------------------------------------------------

		os.execute("sleep 2")

		local workspace_fix_script = HOME .. "/.config/hypr/scripts/" .. "bind_workspaces_to_good_monitor.py"

		local _, workspace_code = gu.run('python "' .. workspace_fix_script .. '"')

		if workspace_code ~= 0 then
			notify_msg("Workspace monitor fix script failed", "Error")

			return 5
		end
	end

	--------------------------------------------------
	-- Done
	--------------------------------------------------

	notify_msg("Script has run fully")

	return 0
end

return M
