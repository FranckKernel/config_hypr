local M = {}

M.PRINT_CUSTOM_DEBUG = true

function M.send_notification(msg)
	local cmd = string.format("notify-send -t 5000 '[Debug]' '%s'", msg)
	os.execute(cmd)
	M.print_custom("🟢 Debug: " .. msg)
end

function M.print_custom(...)
	if not M.PRINT_CUSTOM_DEBUG then
		return
	end

	local parts = {}
	for _, v in ipairs({ ... }) do
		table.insert(parts, tostring(v))
	end

	local msg = table.concat(parts, "\t")
	print(msg)
end

function M.table_to_string(tbl, config, indent, seen)
	config = config or {}
	indent = indent or 0
	seen = seen or {}

	local max_depth = config.max_depth or 5
	local indent_str = string.rep("  ", indent)
	local lines = {}

	local function add(line) table.insert(lines, line) end

	if type(tbl) ~= "table" then
		add(indent_str .. tostring(tbl) .. " (" .. type(tbl) .. ")")
		return table.concat(lines, "\n")
	end

	if seen[tbl] then
		add(indent_str .. "<cycle>")
		return table.concat(lines, "\n")
	end

	seen[tbl] = true

	if indent >= max_depth then
		add(indent_str .. "{ ... }")
		return table.concat(lines, "\n")
	end

	add(indent_str .. "{")

	for k, v in pairs(tbl) do
		local key = "[" .. tostring(k) .. "]"
		local value_type = type(v)

		if value_type == "table" then
			add(indent_str .. "  " .. key .. " = table")
			local nested = M.table_to_string(v, config, indent + 1, seen)
			add(nested)
		elseif value_type == "function" then
			add(indent_str .. "  " .. key .. " = function")
		elseif value_type == "userdata" then
			add(indent_str .. "  " .. key .. " = userdata")
		else
			add(indent_str .. "  " .. key .. " = " .. tostring(v) .. " (" .. value_type .. ")")
		end
	end

	add(indent_str .. "}")

	return table.concat(lines, "\n")
end

function M.dump_table(tbl, config)
	local msg = M.table_to_string(tbl, config)
	M.print_custom(msg)
end

function M.notify_table(tbl, config)
	local msg = M.table_to_string(tbl, config)

	-- Escape characters that would interfere with the shell command.
	msg = msg:gsub("'", "'\\''")

	local cmd = string.format("notify-send -t 5000 '[Debug]' '%s'", msg)
	os.execute(cmd)
end

function M.read_file(path)
	local file = io.open(path, "r")

	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	return content:gsub("%s+$", "")
end

function M.write_file(path, content)
	local file = io.open(path, "w")

	if not file then
		return false
	end

	file:write(content)
	file:close()

	return true
end

function M.run(command)
	local handle = io.popen(command .. " 2>&1")

	if not handle then
		return nil, 1
	end

	local output = handle:read("*a")
	local success, _, code = handle:close()

	if success then
		return output, 0
	end

	return output, code or 1
end

local USER_ID = io.popen("id -u"):read("*a"):gsub("%s+$", "")
local XDG_RUNTIME_DIR = os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. USER_ID)
local hypr_instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")

if not hypr_instance or hypr_instance == "" then
	local handle = io.popen("ls -t '" .. XDG_RUNTIME_DIR .. "/hypr' 2>/dev/null | head -n1")

	if handle then
		hypr_instance = handle:read("*a"):gsub("%s+$", "")
		handle:close()
	end
end

if not hypr_instance or hypr_instance == "" then
	print("Cannot find Hyprland instance signature!")

	M.run_hyprctl = function() M.send_notification("run_hyprctl command not gonna work!") end

	return M
end

function M.run_hyprctl(command)
	local dbus_address = "unix:path=" .. XDG_RUNTIME_DIR .. "/bus"

	return M.run("HYPRLAND_INSTANCE_SIGNATURE='" .. hypr_instance .. "' DBUS_SESSION_BUS_ADDRESS='" .. dbus_address .. "' hyprctl " .. command)
end

return M
