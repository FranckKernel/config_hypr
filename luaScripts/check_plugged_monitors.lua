local M = {}

local file = io.open(os.getenv("HOME") .. "/.config/hypr/ignore/plugged_monitors.txt", "r")

if not file then
	M.monitors = {}
	M.monitor_count = 0
	return M
end

-- First line is the monitor count
M.monitor_count = tonumber(file:read("*l")) or 0

M.monitors = {}

for line in file:lines() do
	if line ~= "" then
		table.insert(M.monitors, line)
	end
end

file:close()

function M.has_monitor(name)
	for _, monitor in ipairs(M.monitors) do
		if monitor == name then
			return true
		end
	end

	return false
end

return M
