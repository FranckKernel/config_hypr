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
---- MACHINE -----
------------------
local mach = require("luaScripts.get_machine")
-- This require doesn't do any hyprland stuff, it just gets us the current machine
Machine = mach.Machine
local machine = mach.machine

-- safe_require("luaScripts.get_monitor_properties")
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
	if machine == Machine.Desktop then
		hl.exec_cmd("$HOME/.config/waybar/waybar_toggle_bottom_desktop.sh")
	elseif machine == Machine.Laptop then
		hl.exec_cmd("$HOME/.config/waybar/waybar_toggle_bottom_laptop.sh")
	end

	local x86ProjectLocation = "$HOME/Documents/zzz__PersonalProjects/MapleKernel/src"
	local espProjectLocation = "$HOME/Documents/zzz__PersonalProjects/ESP32/myProject/src"
	local stmProjectLocation = "$HOME/Documents/zzz__PersonalProjects/STM32/STMKernel/src"

	local mainProjectLocation = stmProjectLocation

	hl.exec_cmd('kitty tmux new-session -c "' .. mainProjectLocation .. '" -s Editor', {
		workspace = "1",
	})

	if Location == Locations.DAD then
		hl.exec_cmd('kitty tmux new-session -c "' .. mainProjectLocation .. '/.." -s Runner', {
			workspace = "12",
		})
	elseif Location == Locations.MOM then
		hl.exec_cmd('kitty tmux new-session -c "' .. mainProjectLocation .. '/.." -s Runner', {
			workspace = "21",
		})
	end

	hl.exec_cmd('kitty tmux new-session -c "' .. mainProjectLocation .. '/.." -s Debugger', {
		workspace = "11",
	})

	hl.exec_cmd(browser, {
		workspace = "13",
	})

	hl.exec_cmd("youtube-music", {
		workspace = "20",
	})

	hl.dispatch(hl.dsp.focus({ workspace = 13 }))
	hl.dispatch(hl.dsp.focus({ workspace = 21 }))
	hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)

-- Simple execs:
-- hl.exec_cmd("$HOME/.config/hypr/scripts/refresh_layout.sh")

local Layouts = {
	DWINDLE = "dwindle",
	MASTER = "master",
	SCROLLING = "scrolling",
	MONOCLE = "monocle",
}

local current_layout = Layouts.DWINDLE

local function change_layout_bindings()
	if current_layout == Layouts.MASTER then
		current_layout = Layouts.DWINDLE
		hl.config({
			general = {
				layout = current_layout,
			},
		})

		hl.unbind("SUPER + E")
		hl.unbind("SUPER + R")
		hl.unbind("SUPER + U")
		hl.unbind("SUPER + I")

		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.unbind("SUPER + SHIFT + J")
		hl.unbind("SUPER + SHIFT + K")
		hl.unbind("SUPER + M")
		hl.unbind("SUPER + SHIFT + M")
		hl.unbind("SUPER + PERIOD")
		hl.unbind("SUPER + COMMA")

		hl.bind("SUPER + J", hl.dsp.window.cycle_next())
		hl.bind("SUPER + K", hl.dsp.window.cycle_next({ prev = true }))
		hl.bind("SUPER + V", hl.dsp.layout("togglesplit"))
		hl.bind("SUPER + O", hl.dsp.window.pseudo())
		hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allpseudo"))
	elseif current_layout == Layouts.DWINDLE then
		current_layout = Layouts.MASTER
		hl.config({

			general = {
				layout = current_layout,
			},
		})
		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.unbind("SUPER + V")
		hl.unbind("SUPER + O")
		hl.unbind("SUPER + SHIFT + O")

		hl.bind("SUPER + E", hl.dsp.layout("mfact -0.025"))
		hl.bind("SUPER + R", hl.dsp.layout("mfact +0.025"))
		hl.bind("SUPER + U", hl.dsp.layout("rollprev"))
		hl.bind("SUPER + I", hl.dsp.layout("rollnext"))

		hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))
		hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))
		hl.bind("SUPER + SHIFT + J", hl.dsp.layout("swapnext"))
		hl.bind("SUPER + SHIFT + K", hl.dsp.layout("swapprev"))
		hl.bind("SUPER + M", hl.dsp.layout("focusmaster"))
		hl.bind("SUPER + SHIFT + M", hl.dsp.layout("swapwithmaster"))
		hl.bind("SUPER + PERIOD", hl.dsp.layout("orientationnext"))
		hl.bind("SUPER + COMMA", hl.dsp.layout("orientationprev"))
	end
end

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

		layout = current_layout,
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

	debug = {
		disable_logs = false,
		enable_stdout_logs = true,
	},

	layout = {},
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
local mainModShift = "SUPER + SHIFT"
local altMod = "ALT"

---- Niche keybinds ----
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/log_keys_for_buggy_keyboard.sh"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("wdisplays"))
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
hl.bind(mainMod .. " + L", change_layout_bindings)

-- Dwindle layout bindings
hl.bind(mainMod .. " + J", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + K", hl.dsp.window.cycle_next({ prev = true }))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"))

-- Program binding
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

-- Menus binding
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/rofi/applets/bin/powermenu.sh"), { locked = true })
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

hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/Screenshots"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Pictures/Screenshots"))

hl.bind(altMod .. " + F10", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("hyprctl dispatch dpms off"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("hyprctl dispatch dpms on"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

-- Move the windows
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))

-- Move focus with altMod + vim keys
hl.bind(altMod .. " + J", hl.dsp.focus({ direction = "left" }))
hl.bind(altMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(altMod .. " + I", hl.dsp.focus({ direction = "up" }))
hl.bind(altMod .. " + K", hl.dsp.focus({ direction = "down" }))

-- Move the windows
hl.bind(altMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "left" }))
hl.bind(altMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(altMod .. " + SHIFT + I", hl.dsp.window.move({ direction = "up" }))
hl.bind(altMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + TAB", hl.dsp.window.alter_zorder({ mode = "top" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.alter_zorder({ mode = "bottom" }))

hl.bind(mainMod .. " + A", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Z", hl.dsp.window.cycle_next({ prev = true }))
hl.bind(mainMod .. " + A", hl.dsp.window.alter_zorder({ mode = "top" }))

hl.bind(mainMod .. " + TAB", hl.dsp.window.alter_zorder({ mode = "top" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.alter_zorder({ mode = "bottom" }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

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
