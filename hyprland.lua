-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

local env = {
	HOME = os.getenv("HOME"),
}

local function p(path)
	return path:gsub("%$(%w+)", function(var)
		return env[var] or "$" .. var
		--
	end)
	--
end

local function safe_require(module)
	local status, value = pcall(require, module)

	if status then
		return value
	end

	return nil
end

------------------
---- MONITORS ----
------------------

safe_require("./machine/monitor.lua")

------------------
--- WORSKPACES ---
------------------
safe_require("./workspaces.lua")

-- deactivate ps4 touchpad:

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "kitty tmux"
local browser = "~/.local/bin/zen"
local fileManager = "dolphin"
local menu = "~/.config/rofi/launchers/type-6/launcher.sh"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("kanata")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("kded5")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("ironbar")
	hl.exec_cmd("$HOME/.config/waybar/waybar_toggle.sh")

	hl.exec_cmd('kitty tmux new-session -c "$HOME/Documents/zzz__PersonalProjects/ESP32/myProject/src/" -s Editor', {
		workspace = "1",
		silent = true,
	})

	if Location == Locations.DAD then
		hl.exec_cmd('kitty tmux new-session -c "$HOME/Documents/zzz__PersonalProjects/ESP32/myProject/" -s Runner', {
			workspace = "12",
			silent = true,
		})
	elseif Location == Locations.MOM then
		hl.exec_cmd('kitty tmux new-session -c "$HOME/Documents/zzz__PersonalProjects/ESP32/myProject/" -s Runner', {
			workspace = "21",
			silent = true,
		})
	end

	hl.exec_cmd('kitty tmux new-session -c "$HOME/Documents/zzz__PersonalProjects/ESP32/myProject/" -s Debugger', {
		workspace = "11",
		silent = true,
	})

	hl.exec_cmd("$browser", {
		workspace = "13",
		silent = true,
	})

	hl.exec_cmd("youtube-music", {
		workspace = "20",
		silent = true,
	})

	hl.dispatch(hl.dsp.workspace("13"))
	hl.dispatch(hl.dsp.workspace("21"))
	hl.dispatch(hl.dsp.workspace("1"))
end)

-- Simple execs:
hl.exec_cmd("$HOME/.config/hypr/scripts/refresh_layout.sh")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 6,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = {
				colors = {
					"rgba(ff0000aa)",
					"rgba(ff69b4aa)",
				},
				angle = -90,
			},
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "slave",
	},

	animations = {
		enabled = true,
	},

	render = {
		cm_enabled = true,
		cm_auto_hdr = 1,
		use_fp16 = 2,
	},
	scrolling = {
		fullscreen_on_one_column = true,
	},
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "ca",
		kb_variant = "fr",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
			tap_to_click = true,
			middle_button_emulation = true,
			scroll_factor = 0.8,
			disable_while_typing = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 4,
	direction = "left",
	action = "close",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local mainModShift = "SUPER + Shift"
local altMod = "ALT"

---- Niche keybinds ----
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/log_keys_for_buggy_keyboard.sh"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("bash -c 'timeout 10s wev --log-level debug > /tmp/wev_keys.txt'"))
hl.bind(mainModShift .. " + E", hl.dsp.exec_cmd("python3 $HOME/QolScripts/screen_placer/screen_placer.py"))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.exec_cmd("python3 $HOME/QolScripts/screen_placer/screen_placer_better.py"))
hl.bind(altMod .. " + R", hl.dsp.exec_cmd("/home/francois/.config/hypr/scripts/reset_wallpaper.sh"))
hl.bind(mainModShift .. " + F", hl.dsp.exec_cmd("$HOME/.config/hypr/machine/free_space.sh"))
hl.bind(
	mainMod .. " + MINUS",
	hl.dsp.exec_cmd([[bash -c 'tmux kill-server; tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "$HYPRLAND_INSTANCE_SIGNATURE"']])
)

-- Toggle between master and dwindle layouts
-- hl.bind(mainMod .. " + M", hl.dsp.layout("swapwithmaster"))

-- Tabbed layout
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())

-- Switch layout script
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/change_layout.sh"))

-- Dwindle layout bindings
hl.bind(mainMod .. " + J", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + K", hl.dsp.window.cycle_next({ prev = true }))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + LESS", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + SHIFT + LESS", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SEMICOLON", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + ALT + SHIFT + W", hl.dsp.exec_cmd("google-chrome-stable --incognito"))

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/rofi/applets/bin/powermenu.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.config/rofi/applets/bin/screenshot-wayland.sh"))
hl.bind(altMod .. " + M", hl.dsp.exec_cmd("~/.config/rofi/applets/bin/mpd.sh"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainModShift .. " + Y", hl.dsp.exec_cmd("youtube-music"))

-- Night light
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/QolScripts/toggle_nightlight.sh"))

-- Eww / Conky toggles
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("$HOME/.config/eww/eww_toggle.sh"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("$HOME/.config/conky/conky_toggle"))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.exec_cmd("$HOME/.config/conky/show_all/shuffle_x.sh"))

-- Bar toggles
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("$HOME/.config/ironbar/ironbar_toggle_top_bar.sh"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/waybar/waybar_toggle_bottom_desktop.sh"))

safe_require("./machine/alt_sound.lua")

hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(altMod .. " + F10", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("hyprctl dispatch dpms off"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("hyprctl dispatch dpms on"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + LEFT", hl.dsp.focus("l"))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus("r"))
hl.bind(mainMod .. " + UP", hl.dsp.focus("u"))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus("d"))

-- Move the windows
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move("l"))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move("r"))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move("u"))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move("d"))

-- Move focus with altMod + vim keys
hl.bind(altMod .. " + J", hl.dsp.focus("l"))
hl.bind(altMod .. " + L", hl.dsp.focus("r"))
hl.bind(altMod .. " + I", hl.dsp.focus("u"))
hl.bind(altMod .. " + K", hl.dsp.focus("d"))

-- Move the windows
hl.bind(altMod .. " + SHIFT + J", hl.dsp.window.move("l"))
hl.bind(altMod .. " + SHIFT + L", hl.dsp.window.move("r"))
hl.bind(altMod .. " + SHIFT + I", hl.dsp.window.move("u"))
hl.bind(altMod .. " + SHIFT + K", hl.dsp.window.move("d"))

hl.bind(mainMod .. " + TAB", hl.dsp.window.alter_zorder("top"))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.alter_zorder("bottom"))

hl.bind(mainMod .. " + A", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Z", hl.dsp.window.cycle_next({ prev = true }))
hl.bind(mainMod .. " + A", hl.dsp.window.alter_zorder("top"))

hl.bind(mainMod .. " + TAB", hl.dsp.window.alter_zorder("top"))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.alter_zorder("bottom"))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.move("special:magic"))

-- Main workspace (1-10)
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Alt workspace (11-20)
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(altMod .. " + " .. key, hl.dsp.focus({ workspace = i + 10 }))
	hl.bind(altMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i + 10 }))
end

-- Main + Alt workspace (21-30)
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. altMod .. " + " .. key, hl.dsp.focus({ workspace = i + 20 }))
	hl.bind(mainMod .. " + " .. altMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i + 20 }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
