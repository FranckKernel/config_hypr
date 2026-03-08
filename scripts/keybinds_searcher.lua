local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")

local Job = require("plenary.job")

local function modmask_to_modifiers(modmask)
	local MODIFIER_MAP = {
		[1] = "Shift",
		[4] = "Control",
		[8] = "Alt",
		[64] = "Super",
	}
	local mods = {}
	local mm = tonumber(modmask) or 0
	for bit, name in pairs(MODIFIER_MAP) do
		if (mm & bit) == bit then
			table.insert(mods, name)
		end
	end
	return mods
end

local function parse_binds(output)
	local binds = {}
	for block in output:gmatch("bind\n(.-)\n\n") do
		local modmask = block:match("modmask:%s*(%d+)")
		local key = block:match("key:%s*(%S+)")
		local dispatcher = block:match("dispatcher:%s*(%S+)")
		local arg = block:match("arg:%s*(.-)\n") or ""

		if modmask and key and dispatcher then
			local mods = modmask_to_modifiers(modmask)
			table.insert(mods, key)
			local combo = table.concat(mods, " + ")
			local line = combo .. " = " .. dispatcher .. (arg ~= "" and (" " .. arg) or "")
			table.insert(binds, line)
		end
	end
	return binds
end

local function hyprland_keybinds_picker(opts)
	opts = opts or {}
	Job:new({
		command = "hyprctl",
		args = { "binds" },
		on_exit = function(j, return_val)
			if return_val ~= 0 then
				print("Failed to run hyprctl binds")
				return
			end
			local result = table.concat(j:result(), "\n")
			local items = parse_binds(result)
			pickers
				.new(opts, {
					prompt_title = "Hyprland Keybinds",
					finder = finders.new_table({
						results = items,
					}),
					sorter = conf.generic_sorter(opts),
					previewer = previewers.new_buffer_previewer({
						define_preview = function(self, entry, status)
							-- preview just shows the line for now
							vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { entry.value })
						end,
					}),
				})
				:find()
		end,
	}):start()
end

return {
	hyprland_keybinds_picker = hyprland_keybinds_picker,
}
