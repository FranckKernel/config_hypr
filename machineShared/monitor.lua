-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local gu = require("luaScripts.general_utils")
------------------
---- MACHINE -----
------------------
local mach = require("luaScripts.get_machine")
-- This require doesn't do any hyprland stuff, it just gets us the current machine
Machine = mach.Machine
local machine = mach.machine

gu.send_notification(machine)

-- Locations is updated by reading a file (current_location.csv)
-- The file is updated at boot by user systemd.
-- $HOME/.config/systemd/user/hypr-location.service
-- $HOME/.config/hypr/scripts/get_locations/quick_ethernet_check.py (currently the file that's being runned to check/get my location.)
-- I could just use the lua version:
-- require("luaScripts.get_location_ethernet_check") -- This line must be commented out.
local location_getter = require("luaScripts.get_location")

Locations = location_getter.Locations

Location = location_getter.Location

gu.send_notification(Location)

-- gu.send_notification(Location)

if machine == Machine.Desktop then
	if Location == Locations.DAD then
		Monitor = {
			LEFT = "HDMI-A-2",
			MAIN = "DP-1",
			RIGHT = "HDMI-A-1",
		}
	elseif Location == Locations.MOM then
		Monitor = {
			LEFT = "DP-2",
			MAIN = "DP-1",
			RIGHT = "HDMI-A-1",
		}
	end
elseif machine == Machine.Laptop then
	Monitor = {
		LEFT = "DP-1",
		MAIN = "eDP-1",
		RIGHT = "HDMI-A-1",
	}
end

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

if machine == Machine.Desktop then
	if Location == Locations.DAD then
		gu.send_notification("dad location")

		hl.monitor({
			output = Monitor.MAIN,
			mode = "1920x1080@144",
			position = "0x0",
			scale = 1,
			transform = 0,
		})

		hl.monitor({
			output = Monitor.RIGHT,
			mode = "1920x1080@60",
			position = "1920x0",
			scale = 1,
			transform = 0,
		})

		hl.monitor({
			output = Monitor.LEFT,
			mode = "1920x1080@60",
			position = "-1920x180",
			scale = 1,
			transform = 0,
		})
	elseif Location == Locations.MOM then
		gu.send_notification("mom location")
		hl.monitor({
			output = Monitor.MAIN,
			mode = "2560x1440@180",
			position = "0x0",
			scale = 1,
			transform = 0,
			bitdepth = 10,
			cm = "hdr",
			sdrbrightness = 1.2,
			sdrsaturation = 0.95,
		})

		hl.monitor({
			output = Monitor.LEFT,
			mode = "1920x1080@144",
			position = "-1920x180",
			scale = 1,
			transform = 0,
		})

		hl.monitor({
			output = Monitor.RIGHT,
			mode = "1920x1080@75",
			position = "2560x124",
			scale = 1,
			transform = 0,
		})
	elseif Location == Locations.OTHER then
		-- nothing to do here
	end
elseif machine == Machine.Laptop then
	hl.monitor({
		output = Monitor.MAIN,
		mode = "1920x1200@60",
		position = "0x0",
		scale = 1,
		transform = 0,
	})

	hl.monitor({
		output = Monitor.RIGHT,
		mode = "1920x1080@60",
		position = "1920x60",
		scale = 1,
		transform = 0,
	})

	hl.monitor({
		output = Monitor.LEFT,
		mode = "1920x1080@60",
		position = "-1920x60",
		scale = 1,
		transform = 0,
	})
elseif machine == Machine.Unknown then
	-- nothing to do here
end

for i = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = Monitor.MAIN,
	})
end

for i = 11, 20 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = Monitor.RIGHT,
	})
end

for i = 21, 30 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = Monitor.LEFT,
	})
end
