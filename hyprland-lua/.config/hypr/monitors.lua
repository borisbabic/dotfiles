-- OVERRIDEN BY dms.outputs
-- hl.monitor({
--   output = "eDP-1",
--   mode = "2560x1600@165.000",
--   scale = "1.6",
--   position = "520x1440",
--   vrr = 1,
--   bitdepth = 10,
--   sdrsaturation = 1.5
-- })
-- hl.monitor({
--   output = "HDMI-A-2",
--   mode = "3840x2160@120.00Hz",
--   scale = "1.5",
--   position = "0x0",
--   vrr = 1,
--   bitdepth = 10,
--   sdrsaturation = 1.5
-- })
-- hl.monitor({
--   output = "DP-2",
--   mode = "preferred",
--   scale = "2",
--   transform = 1,
--   position = "2560x0",
--   vrr = 0
-- })

require("dms.outputs")

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.workspace_rule({
  workspace ="25",
  monitor = "DP-2",
  layout_opts = {
    orientation = "bottom"
  }
})
local function set_dp2_options()
  local monitor = hl.get_monitor("DP-2")
  if monitor and monitor.id then
    for i = 1, 9 do
      hl.workspace_rule({
        workspace = monitor.id  .. i,
        monitor = "DP-2",
        layout_opts = {
          orientation = "bottom",
        }
      })
    end
  end

end
set_dp2_options()

-- for xwayland stuff
-- primarily for steam games
hl.on("monitor.added", function(monitor)
  set_dp2_options()
  UTIL.notify(monitor.name)
  if "HDMI-A-2" == monitor.name then
    hl.exec_cmd("sleep 10 && xrandr --output HDMI-A-2 --primary")
  end
end)
hl.on("monitor.removed", function(monitor)
  set_dp2_options()
  UTIL.notify(monitor.name)
  local laptop_monitor = hl.get_monitor("eDP-1")
  if "HDMI-A-2" == monitor.name and laptop_monitor and laptop_monitor.id == 0 then
    hl.exec_cmd("sleep 10 && xrandr --output eDP-1 --primary")
  end
end)

