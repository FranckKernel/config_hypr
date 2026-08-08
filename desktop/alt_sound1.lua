local gu = require("luaScripts.general_utils")

local mach = require("luaScripts.get_machine")
local Machine = mach.Machine
local machine = mach.machine

local mainMod = "SUPER"
local altMod = "ALT"

local youtube_controller = "$HOME/.config/hypr/scripts/youtube_music_controller.sh"

-- =========================================================
-- Shared
-- =========================================================

-- Volume helper
local function bind_volume(mod, key, amount)
	--
	hl.bind(mod .. " + " .. key, hl.dsp.exec_cmd("swayosd-client --output-volume " .. amount))
end

-- MPC volume Helper
local function bind_mpc_volume(mod, key, amount)
	--
	hl.bind(mod .. " + " .. key, hl.dsp.exec_cmd("mpc volume " .. amount))
end

-- Hardware media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(youtube_controller .. " video play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(youtube_controller .. " video next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(youtube_controller .. " video previous"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute"), { locked = true })

-- MPC media controls
hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.exec_cmd("mpc next"), { locked = true })
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.exec_cmd("mpc prev"), { locked = true })
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.exec_cmd("mpc toggle"), { locked = true })
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.exec_cmd("mpc stop"), { locked = true })

-- YouTube Music controls
hl.bind(altMod .. " + CTRL + LEFT", hl.dsp.exec_cmd(youtube_controller .. " music previous"), { locked = true })
hl.bind(altMod .. " + CTRL + RIGHT", hl.dsp.exec_cmd(youtube_controller .. " music next"), { locked = true })
hl.bind(altMod .. " + CTRL + UP", hl.dsp.exec_cmd(youtube_controller .. " music play-pause"), { locked = true })
hl.bind(altMod .. " + CTRL + DOWN", hl.dsp.exec_cmd(youtube_controller .. " music stop"), { locked = true })

-- =========================================================
-- Desktop
-- =========================================================

if machine == Machine.DESKTOP then
	-- Block hardware volume keys
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("echo Blocked > /dev/null"))
	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("echo Blocked > /dev/null"))

	-- Volume
	bind_volume(altMod, "END", "-1")
	bind_volume(altMod .. " + SHIFT", "END", "-5")
	bind_volume(altMod, "HOME", "+1")
	bind_volume(altMod .. " + SHIFT", "HOME", "+5")

	bind_mpc_volume(altMod, "NEXT", "-1")
	bind_mpc_volume(altMod .. " + SHIFT", "NEXT", "-5")
	bind_mpc_volume(altMod, "PRIOR", "+1")
	bind_mpc_volume(altMod .. " + SHIFT", "PRIOR", "+5")
end

-- =========================================================
-- Laptop
-- =========================================================

if machine == Machine.LAPTOP then
	-- Hardware volume keys
	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"))
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"))

	-- Volume
	bind_volume(mainMod, "HOME", "-1")
	bind_volume(mainMod .. " + SHIFT", "HOME", "-5")
	bind_volume(mainMod, "END", "+1")
	bind_volume(mainMod .. " + SHIFT", "END", "+5")

	bind_mpc_volume(mainMod, "NEXT", "-1")
	bind_mpc_volume(mainMod .. " + SHIFT", "NEXT", "-5")
	bind_mpc_volume(mainMod, "PRIOR", "+1")
	bind_mpc_volume(mainMod .. " + SHIFT", "PRIOR", "+5")

	-- Brightness
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

	-- Keyboard backlight
	hl.bind(altMod .. " + SPACE", hl.dsp.exec_cmd("brightnessctl --device='*::kbd_backlight' set +50%"))
	hl.bind(altMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("brightnessctl --device='*::kbd_backlight' set 50%-"))
end
