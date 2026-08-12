local function serializeTable(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)
	hl.dispatch(hl.dsp.dpms())

	if name then
		tmp = tmp .. name .. " = "
	end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp = tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. '"[inserializeable datatype:' .. type(val) .. ']"'
	end

	return tmp
end
local notif = function(text_or_table, duration)
	local text = text_or_table
	if type(text_or_table) == "table" then
		text = serializeTable(text_or_table)
	end
	text = text or "Empty Notification"
	hl.notification.create({ duration = duration or 5000, text = text, timeout = duration or 5000 })
end

local function disableMonitors(monitor_names)
	for _, v in ipairs(monitor_names) do
		print(v)
		hl.monitor({ output = v, disabled = true })
	end
end
local function enableMonitors(monitor_names)
	for _, v in ipairs(monitor_names) do
		print(v)
		hl.monitor({ output = v, disabled = false })
	end
end
local function monitorDisabler(monitor_names)
	return function()
		disableMonitors(monitor_names)
	end
end
local function monitorEnabler(monitor_names)
	return function()
		enableMonitors(monitor_names)
	end
end
local function prioritizeMonitor(name)
	local monitors = hl.get_monitors()
	local preceding = {}
	local monitor_enabled = false
	for _, v in ipairs(monitors) do
		if v["name"] == name then
			monitor_enabled = true
		elseif not monitor_enabled then
			table.insert(preceding, v["name"])
		end
	end
	print(preceding)
	print(monitor_enabled)
	if monitor_enabled then
		-- if we don't dispatch nothing happens
		hl.dispatch(monitorDisabler(preceding))
		hl.dispatch(monitorEnabler(preceding))
	end
end

local function test(name)
	hl.monitor({ output = name or "DP-2", disabled = true })
	-- hl.monitor({ output = name or "DP-2", disabled = false })
end

return {
	notif = notif,
	notify = notif,
	scratch = test,
	prioritizeMonitor = prioritizeMonitor,
	enableMonitors = enableMonitors,
	disableMonitors = disableMonitors,
	serializeTable = serializeTable,
}
