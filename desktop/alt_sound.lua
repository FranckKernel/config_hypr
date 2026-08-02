local mainMod = "SUPER"
local altMod = "ALT"

local youtube_controller = "$HOME/.config/hypr/scripts/youtube_music_controller.sh"

-- ============== Hardware media keys ===================
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(youtube_controller .. " video play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(youtube_controller .. " video next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(youtube_controller .. " video previous"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })

-- Block broken keyboard volume keys

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("echo Blocked > /dev/null"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("echo Blocked > /dev/null"))

-- ============= SWAYOSD =============

local function bind_volume(mod, key, amount) hl.bind(mod .. " + " .. key, hl.dsp.exec_cmd("swayosd-client --output-volume " .. amount)) end

-- Main mod volume
bind_volume(mainMod, "END", "-1")
bind_volume(mainMod .. " + SHIFT", "END", "-5")

bind_volume(mainMod, "HOME", "+1")
bind_volume(mainMod .. " + SHIFT", "HOME", "+5")

-- Alt mod volume
bind_volume(altMod, "END", "-1")
bind_volume(altMod .. " + SHIFT", "END", "-5")

bind_volume(altMod, "HOME", "+1")
bind_volume(altMod .. " + SHIFT", "HOME", "+5")

-- ============= MPC =============

local function bind_mpc_volume(mod, key, amount) hl.bind(mod .. " + " .. key, hl.dsp.exec_cmd("mpc volume " .. amount)) end

-- MPC volume
bind_mpc_volume(altMod, "NEXT", "-1")
bind_mpc_volume(altMod .. " + SHIFT", "NEXT", "-5")

bind_mpc_volume(altMod, "PRIOR", "+1")
bind_mpc_volume(altMod .. " + SHIFT", "PRIOR", "+5")

-- MPC media controls
hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.exec_cmd("mpc next"), { locked = true })
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.exec_cmd("mpc prev"), { locked = true })
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.exec_cmd("mpc toggle"), { locked = true })
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.exec_cmd("mpc stop"), { locked = true })

-- ============= YouTube Music controls =============

hl.bind(altMod .. " + CTRL + LEFT", hl.dsp.exec_cmd(youtube_controller .. " music previous"), { locked = true })
hl.bind(altMod .. " + CTRL + RIGHT", hl.dsp.exec_cmd(youtube_controller .. " music next"), { locked = true })
hl.bind(altMod .. " + CTRL + UP", hl.dsp.exec_cmd(youtube_controller .. " music play-pause"), { locked = true })
hl.bind(altMod .. " + CTRL + DOWN", hl.dsp.exec_cmd(youtube_controller .. " music stop"), { locked = true })
