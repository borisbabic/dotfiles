--[[

     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local widgets = require("widgets")
local theme = require("theme_selection")

local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local markup = lain.util.markup
local separators = lain.util.separators
local fontfg = function(text)
    return markup.fontfg(theme.font, theme.xcolor1, text) --markup(theme.xcolor1, text))
end

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock =
    awful.widget.watch(
    "date +'%a %d %b %T'",
    1,
    function(widget, stdout)
        widget:set_markup(fontfg(" " .. stdout))
    end
)
clock.icon = clockicon

-- Calendar
theme.cal =
    lain.widget.cal(
    {
        attach_to = {clock},
        notification_preset = {
            font = "xos4 Terminus 10",
            fg = theme.fg_normal,
            bg = theme.bg_normal
        }
    }
)

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem =
    lain.widget.mem(
    {
        settings = function()
            widget:set_markup(fontfg(" " .. mem_now.used .. "MB "))
        end
    }
)
mem.icon = memicon

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu =
    lain.widget.cpu(
    {
        settings = function()
            widget:set_markup(fontfg(" " .. cpu_now.usage .. "% "))
        end
    }
)
cpu.icon = cpuicon

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp =
    lain.widget.temp(
    {
        settings = function()
            widget:set_markup(fontfg(" " .. coretemp_now .. "°C "))
        end
    }
)
temp.icon = tempicon

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat =
    lain.widget.bat(
    {
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    if (not bat_now.perc) then
                        widget:set_markup(fontfg(" AC "))
                    else
                        widget:set_markup(fontfg(" " .. bat_now.perc .. "% "))
                    end
                    baticon:set_image(theme.widget_ac)
                    return
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                    baticon:set_image(theme.widget_battery_empty)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                    baticon:set_image(theme.widget_battery_low)
                else
                    baticon:set_image(theme.widget_battery)
                end
                widget:set_markup(fontfg(" " .. bat_now.perc .. "% " .. bat_now.watt .. "W " .. bat_now.time))
            else
                widget:set_markup()
                baticon:set_image(theme.widget_ac)
            end
        end,
        timeout = 1
    }
)
bat.icon = baticon

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume =
    lain.widget.alsa(
    {
        settings = function()
            if volume_now.status == "off" then
                volicon:set_image(theme.widget_vol_mute)
            elseif tonumber(volume_now.level) == 0 then
                volicon:set_image(theme.widget_vol_no)
            elseif tonumber(volume_now.level) <= 50 then
                volicon:set_image(theme.widget_vol_low)
            else
                volicon:set_image(theme.widget_vol)
            end

            widget:set_markup(fontfg(" " .. volume_now.level .. "% "))
        end,
        timeout = 1
    }
)
theme.volume.icon = volicon

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net =
    lain.widget.net(
    {
        settings = function()
            widget:set_markup(
                markup.font(
                    theme.font,
                    markup("#7AC82E", " " .. net_now.received) .. " " .. markup("#46A8C3", " " .. net_now.sent .. " ")
                )
            )
        end
    }
)
net.icon = neticon

-- Separators
local spr = wibox.widget.textbox(" ")
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({app = awful.util.terminal})

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        my_table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                2,
                function()
                    awful.layout.set(awful.layout.layouts[1])
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s, height = 23, bg = theme.bg_normal, fg = theme.fg_normal})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr
        },
        s.mytasklist, -- Middle widget
        widgets.get_right_widgets(
            {
                theme.volume,
                mem,
                cpu,
                temp,
                bat,
                net,
                clock,
                s.mylayoutbox
            },
            arrl_dl,
            arrl_ld,
            theme.bg_focus
        )
    }
end

return theme
