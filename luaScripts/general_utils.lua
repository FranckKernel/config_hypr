local M = {}

function M.send_notification(msg)
	local cmd = string.format("notify-send -t 5000 '[Debug]' '%s'", msg)
	os.execute(cmd)
	M.print_custom("🟢 Debug: " .. msg)
end

M.PRINT_CUSTOM_DEBUG = true

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

function M.dump_table(tbl, config, indent, seen)
	config = config or {}
	indent = indent or 0
	seen = seen or {}

	local out = M.print_custom
	local max_depth = config.max_depth or 5
	local indent_str = string.rep("  ", indent)

	if type(tbl) ~= "table" then
		out(indent_str .. tostring(tbl) .. " (" .. type(tbl) .. ")")
		return
	end

	if seen[tbl] then
		out(indent_str .. "<cycle>")
		return
	end
	seen[tbl] = true

	if indent >= max_depth then
		out(indent_str .. "{ ... }")
		return
	end

	out(indent_str .. "{")

	for k, v in pairs(tbl) do
		local key = "[" .. tostring(k) .. "]"
		local value_type = type(v)

		if value_type == "table" then
			out(indent_str .. "  " .. key .. " = table")
			M.dump_table(v, config, indent + 1, seen)
		elseif value_type == "function" then
			out(indent_str .. "  " .. key .. " = function")
		elseif value_type == "userdata" then
			out(indent_str .. "  " .. key .. " = userdata")
		else
			out(indent_str .. "  " .. key .. " = " .. tostring(v) .. " (" .. value_type .. ")")
		end
	end

	out(indent_str .. "}")
end

return M
