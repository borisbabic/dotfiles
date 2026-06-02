hl.on("hyprland.start", function() 
  hl.exec_cmd("systemctl --user start dms")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user start hyprland-session.target")
end)


hl.layer_rule({
     name  = "dms-layer-rule",
     match = { namespace = "^(dms)" },
     no_anim = true,
})

local mainMod = require("variables").mainMod

for keys, exec in pairs({
  ["SUPER_L"] = "spotlight toggle",
  ["space"] = "spotlight toggle",
  ["V"] = "clipboard toggle",
  ["P"] = "processlist toggle",
  ["comma"] = "settings toggle",
  ["N"] = "widget toggle notificationButton",
  ["TAB"] = "hypr toggleOverview",
  ["W"] = "widget toggle weather",
  ["O"] = "hypr toggle overview",
  ["L"] = "lock lock",
}) do
  hl.bind(mainMod .. " + " .. keys, hl.dsp.exec_cmd("dms ipc call " .. exec))
end
for keys, exec in pairs({
  ["XF86AudioRaiseVolume"] = "audio increment 3",
  ["XF86AudioLowerVolume"] = "audio decrement 3",
  ["XF86AudioMute"] = "audio mute",
  ["XF86MonBrightnessUp"] = "brightness increment 5 backlight:intel_backlight",
  ["XF86MonBrightnessDown"] = "brightness decrement 5 backlight:intel_backlight",
}) do
  hl.bind(keys, hl.dsp.exec_cmd("dms ipc call " .. exec))
end

hl.bind("XF86AudioMute",  hl.dsp.exec_cmd("dms ipc call audio mute"), {locked = true})
for keys, exec in pairs({
  ["XF86AudioRaiseVolume"] = "audio increment 3",
  ["XF86AudioLowerVolume"] = "audio decrement 3",
  ["XF86MonBrightnessUp"] = "brightness increment 5 backlight:intel_backlight",
  ["XF86MonBrightnessDown"] = "brightness decrement 5 backlight:intel_backlight",
}) do
  hl.bind(keys, hl.dsp.exec_cmd("dms ipc call " .. exec), {locked = true, repeating = true})
end

for keys, exec in pairs({
  Print = "",
  [mainMod .. " + Print"] = "window",
  ["CONTROL + PRINT"] = "full",
  ["CONTROL + SHIFT + PRINT"] = "all"
}) do
  hl.bind(keys, hl.dsp.exec_cmd("dms screenshot " .. exec))
end
