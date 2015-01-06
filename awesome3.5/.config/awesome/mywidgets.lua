local lain      = require("lain")
local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")

-- {{{ Wibox
markup = lain.util.markup

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker/theme.lua")

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

 --calendar
--lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

---- Mail IMAP check
--mailicon = wibox.widget.imagebox(beautiful.widget_mail)
--mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
--mailwidget = wibox.widget.background(lain.widgets.imap({
    --timeout  = 180,
    --server   = "server",
    --mail     = "mail",
    --password = "keyring get mail",
    --settings = function()
        --if mailcount > 0 then
            --widget:set_text(" " .. mailcount .. " ")
            --mailicon:set_image(beautiful.widget_mail_on)
        --else
            --widget:set_text("")
            --mailicon:set_image(beautiful.widget_mail)
        --end
    --end
--}), "#313131")

-- MPD
mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpdwidget = lain.widgets.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(beautiful.widget_music_on)
        elseif mpd_now.state == "pause" then
            artist = " mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mpdicon:set_image(beautiful.widget_music)
        end

        widget:set_markup(markup("#EA6F81", artist) .. title)
    end
})

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_text(" " .. fs_now.used .. "% ")
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            widget:set_markup(" AC ")
            baticon:set_image(beautiful.widget_ac)
            return
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(beautiful.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(beautiful.widget_battery_low)
        else
            baticon:set_image(beautiful.widget_battery)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(beautiful.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(beautiful.widget_vol_low)
        else
            volicon:set_image(beautiful.widget_vol)
        end

        widget:set_text(" " .. volume_now.level .. "% ")
    end
})

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
netwidget = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                          .. " " ..
                          markup("#46A8C3", " " .. net_now.sent .. " "))
    end
})

function getLayoutBox(s)
    local ret = awful.widget.layoutbox(s)
    ret:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    return ret

end

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

local M = {}
M.memwidget = {memicon, memwidget}
M.volumewidget = {volicon, volumewidget}
M.tempwidget = {tempicon, tempwidget}
M.fswidget = {fsicon, fswidget}
M.batwidget = {baticon, batwidget}
M.cpuwidget = {cpuicon, cpuwidget}
M.netwidget = {neticon, netwidget}
M.clockwidget = {clockicon, mytextclock}
--M.mpdwidget = {mpdicon, mpdwidget}

lightbackground = "#313131" -- if changed change the color in the arrow icons
M.getRightLayout = function(widgetList, s)
    layout = wibox.layout.fixed.horizontal()
    if s == 1 then layout:add(wibox.widget.systray()) end
    function getArrowType(currentTurn)
        if (currentTurn == 0) then
            return arrl_ld
        else
            return arrl_dl
        end
    end
    function needsLightBackground(currentTurn)
        return 0 == currentTurn
    end
    turn = {
        curr = 0,
        getTurn = function()
            turn.curr = (turn.curr + 1) % 2
            return (turn.curr + 1) % 2
        end
    }
    layout:add(spr)
    function addWidget(w)
        currentTurn = turn.getTurn()
        layout:add(getArrowType(currentTurn))
        for i, widget in ipairs(w) do
            if (needsLightBackground(currentTurn)) then
                widget = wibox.widget.background(widget, lightbackground)
            end
            layout:add(widget)
        end
    end
    for _, w in ipairs(widgetList) do
        addWidget(w)
    end
    if (not(s == nil)) then
        addWidget({getLayoutBox(s)})
    end
    return layout
end
return M
