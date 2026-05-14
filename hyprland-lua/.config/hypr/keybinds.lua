
---------------------
---- KEYBINDINGS ----
---------------------

local variables = require("variables")
local shieldIP = variables.shieldIP
local mainMod = variables.mainMod
local terminal    = variables.terminal
local fileManager = variables.fileManager
local menu        = variables.menu

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT +  F", hl.dsp.window.float({ action = "toggle", internal = true }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
-- MIGHT NOT WORK:
-- hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen_state({internal = false, client = "0 2"}))
hl.bind(mainMod .. " + SHIFT + P", function ()
  hl.dispatch(hl.dsp.window.float({action = "toggle"}))
  hl.dispatch(hl.dsp.window.pin())
end)


-- Directional keybinds
for _, dir in ipairs({"left", "right", "up", "down"}) do
  hl.bind(mainMod .. " + " .. dir, hl.dsp.focus({direction = dir}))
  hl.bind(mainMod .. " + SHIFT + " .. dir, hl.dsp.window.move({direction = dir}))
end



local function move_window_to(workspace)
  return function()
    local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local follow = ws ~= nil and ws.windows < 2
    hl.dispatch(HS.dsp.window.move({workspace = workspace, follow = follow}))
  end
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
--
for i = 1, 9 do
    local key = i % 10 -- 10 maps to key 0
    -- hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    -- hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + " .. key,             HS.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     move_window_to(i))
end


hl.bind("SUPER + " .. "g", HS.dsp.grab_rogue_windows())
hl.bind("SUPER + " .. "d", HS.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))


hl.bind("ALT + ALT_R + C", hl.dsp.exec_cmd("chatterino"), {release = true})
-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", move_window_to("special:magic"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
-- hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


-----SHIELD
local shieldBase = "adb connect " .. shieldIP .. " && adb shell "
for keys, keyevent in pairs({
  ["XF86AudioPause"] = "85",
  ["XF86AudioPlay"] = "85",
  ["XF86AudioNext"] = "87",
  ["XF86AudioRaiseVolume"] = "24",
  ["XF86AudioLowerVolume"] = "25"
}) do
  hl.bind(mainMod ..  " + "  .. keys, hl.dsp.exec_cmd(shieldBase .. "input keyevent " .. keyevent), {locked = true})
end

for keys, keyevent in pairs({
  ["up"] = "19",
  ["down"] = "20",
  ["left"] = "21",
  ["right"] = "22",
  -- dpad center
  ["return"] = "23",
  ["backspace"] = "4",
  ["kp_home"] = "3",
  ["home"] = "3",
  -- app switcer
  ["kp_end"] = "187",
  ["end"] = "187",
  ["tab"] = "61",
  ["SHIFT + tab"]  = "143"
}) do
  hl.bind(mainMod .. " + ALT + "  .. keys, hl.dsp.exec_cmd(shieldBase .. "input keyevent " .. keyevent))
end

-- opens url from clipboard on shield's browser
hl.bind(mainMod .. " + ALT  + b", hl.dsp.exec_cmd(shieldBase .. "am start -a android.intent.action.VIEW -d \"$(wl-paste | tr -d '[:space:]')\""))
for keys, keyevent in pairs({
  ["s"] = "com.stremio.one",
  ["y"] = "io.gh.reisxd.tizentube.cobalt",
}) do
  hl.bind(mainMod ..  " + "  .. keys, hl.dsp.exec_cmd(shieldBase .. "monkey -p " .. keyevent .. " -c android.intent.category.LAUNCHER 1"))
end
