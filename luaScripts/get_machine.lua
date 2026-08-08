local Machine = {
	Laptop = "Laptop",
	Desktop = "Desktop",
	Unknown = "Unknown",
}

local function get_machine()
	local handle = io.popen("hostname")

	if not handle then
		return Machine.Unknown
	end

	local hostname = handle:read("*l")
	handle:close()

	if hostname == "ArchBTW" then
		return Machine.Laptop
	elseif hostname == "DesktopArchBTW" then
		return Machine.Desktop
	end

	return Machine.Unknown
end

M = {}
M.machine = get_machine()
M.get_machine = get_machine()
M.Machine = Machine

return M
