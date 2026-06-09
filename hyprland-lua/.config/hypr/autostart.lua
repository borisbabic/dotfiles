local function exec(cmd, workspace)
  hl.exec_cmd("uwsm app -- " .. cmd, {workspace = workspace or 1})
end

-- hl.on("monitor.added", function(monitor) 
--   UTIL.notify("MONITOR ADDED" .. tostring(monitor), 20000)
-- end)
-- hl.on("hyprland.start", function() 
--   local monitors = hl.get_monitors()
--   local monitor_text = "Total Monitors: " .. #monitors
--   for _, v in ipairs(monitors) do
--     monitor_text = monitor_text .. tostring(v) .. "\n"
--   end
--   UTIL.notify(monitor_text, 20000)
-- end)
--
local function auto_start_ids_from_monitors()

  local edp1 = hl.get_monitor("eDP-1")
  local dp2 = hl.get_monitor("DP-2")
  local hdmi = hl.get_monitor("HDMI-A-2")
  local laptop_id = edp1 and edp1.id or 0
  return {
    laptop = laptop_id,
    vertical= dp2 and dp2.id or laptop_id,
    hdmi = hdmi and hdmi.id or laptop_id
  }
end
local function auto_start_ids()
  local monitors = hl.get_monitors()
  local ids  = {
    laptop = 0,
    vertical = 0,
    hdmi = 0
  }
  local source = "default"
  if #monitors > 1 then
    ids = auto_start_ids_from_monitors()
    source = "hl.monitors"
  else
    local f = io.popen("grep -H '^connected' /sys/class/drm/card*-*/status")

    if f then
      local outputs = f:read("*a") or ""
      UTIL.notify(outputs)
      if string.find(outputs, "HDMI-A-2/status:connected", 1, true) then
        ids.hdmi = ids.laptop + 1
      end
      if string.find(outputs, "DP-2/status:connected", 1, true) then
        ids.vertical = ids.hdmi + 1
      end
      source = "/sys/class/drm/card*-*:"
      f:close()
    else
      ids = auto_start_ids_from_monitors()
      source ="hl.monitors"
    end
  end
  UTIL.notify("Monitor IDs from " .. source, 20000)
  UTIL.notify(ids, 20000)
  return ids
end

local function auto_start()
  local ids = auto_start_ids()

  exec("chatterino", ids.vertical .. "5 silent")
  exec("whatsapp-electron", ids.vertical .. "5 silent")
  exec("env LUTRIS_SKIP_INIT=1 lutris lutris:rungameid/3", ids.vertical .. "5 silent")
  exec("vesktop", ids.vertical .. "3")
  exec("kitty -d ~/dotfiles direnv exec ~/dotfiles nvim", ids.hdmi .. "4 silent")
  exec("kitty -d ~/projects/hsguru direnv exec ~/projects/hsguru nvim", ids.hdmi .. "2 silent")
  exec("firefox", ids.hdmi .. "1")
  exec("spotify", ids.vertical .. "3 silent")

end


hl.on("hyprland.start", auto_start)

return {
  exec = exec,
  auto_start = auto_start,
  auto_start_ids =  auto_start_ids
}
