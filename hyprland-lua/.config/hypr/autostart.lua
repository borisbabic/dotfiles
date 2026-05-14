local function exec(cmd, workspace)
  hl.exec_cmd("uwsm app -- " .. cmd, {workspace = workspace})
end
hl.on("hyprland.start", function () 
  local edp1 = hl.get_monitor("eDP-1")
  local dp2 = hl.get_monitor("DP-2")
  local hdmi = hl.get_monitor("HDMI-A-2")
  local laptop_id = edp1 and edp1.id or 0
  local vertical_id = dp2 and dp2.id or laptop_id
  local hdmi_id = hdmi and hdmi.id or laptop_id

  exec("chatterino", vertical_id .. "5 silent")
  exec("whatsapp-electron", vertical_id .. "5 silent")
  exec("spotify", vertical_id .. "3 silent")
  exec("webcord", vertical_id .. "3")
  exec("kitty -d ~/dotfiles nvim", hdmi_id .. "4 silent")
  exec("kitty -d ~/projects/hsguru nvim", hdmi_id .. "2 silent")
  exec("firefox", hdmi_id .. "1")
  -- if hdmi_id ~= laptop_id then
  --   exec("firefox --new-window", laptop_id .. "1")
  -- end
end)
