-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
Monitor = {
	LEFT = "DP-2",
	MAIN = "DP-1",
	RIGHT = "HDMI-A-1",
	LAPTOP = "eDP-1", -- not used on desktop.
}

Locations = {
	MOM = "mom",
	DAD = "dad",
	OTHER = "other",
}

Location = Locations.DAD

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

if Location == Locations.DAD then
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
elseif Location == Locations.MOM then
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
