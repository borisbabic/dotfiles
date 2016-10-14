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
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M", 1)

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

--MINE

function getNumberWidget()
    numberwidget = {}
    numberwidget.widget = wibox.widget.textbox()
    numberwidget.basetext = ('Git: <span color =%q>%d</span>')
    numberwidget.color = "yellow"
    numberwidget.emptycolor = "white"
    numberwidget.value = 0
    numberwidget.settext = function ()
        if(numberwidget.value <1) then
            color = numberwidget.emptycolor
        else
            color = numberwidget.color
        end
        numberwidget.widget:set_markup(string.format(numberwidget.basetext, color, numberwidget.value))
    end
    numberwidget.clientupdate = function (value)
        numberwidget.value = value
        numberwidget:settext()
    end
    numberwidget.settext()
    return numberwidget
end
gitwidget = getNumberWidget()

function getBasicTextWidget()
    local basic = {}
    basic.widget = wibox.widget.textbox()
    basic.basetext = "<span color =%q>%s</span>"
    basic.update = function(text, color)
        color = color or 'white'
        basic.widget:set_markup(string.format(basic.basetext, color, text))
    end
    return basic
end


function getTimeStartStopWidget()
    local startstop ={}
    startstop.widget = wibox.widget.textbox() --
    --startstop.timeoutminutes = 1 --in minutes
    startstop.timeout = 1
    startstop.seconds = true
    startstop.running = false --(whether it is running or not)
    startstop.status = "0"
    startstop.basetext = "<span color =%q>%s</span>"
    startstop.currenttime = {["hour"] = 0, ["minute"] = 0, ["seconds"] = 0}
    startstop.settext = function()
        local color = startstop.getColor()

        local time_string = string.format("%d:%02d", startstop.currenttime.hour, startstop.currenttime.minute)
        if (startstop.seconds) then
            time_string = time_string .. string.format(":%02d", startstop.currenttime.seconds)
        end
        startstop.widget:set_markup(string.format(startstop.basetext, color, time_string))
    end
    startstop.getColor = function()
        if (startstop.status ==0) then
            return "#EB1B28"
        end
        if (startstop.status ==1) then
            return "#00923D"
        end
        if (startstop.status ==2) then
            return "#0389CE"
        end
        if (startstop.status ==3) then
            return "#F9A81F"
        end
        if (startstop.status ==4) then
            return "#A8095E"
        end
        return "white"
    end

    startstop.isRunning = function()
        if (startstop.status ==0) then
            return false
        end
        if (startstop.status ==1) then
            return true
        end
        if (startstop.status ==2) then
            return true
        end
        if (startstop.status ==3) then
            return true
        end
        if (startstop.status ==4) then
            return true
        end
        return false
    end
    startstop.clientupdate = function(hour, minute, seconds, running)
        startstop.currenttime.hour=hour
        startstop.currenttime.minute=minute
        startstop.currenttime.seconds=seconds
        startstop.status = "0"
        if (running) then
            startstop.status = "1"
        end
        startstop.running=running
        startstop.settext()
    end

    startstop.newclientupdate = function(hour, minute, seconds, status)
        startstop.currenttime.hour=hour
        startstop.currenttime.minute=minute
        startstop.currenttime.seconds=seconds
        startstop.status = status
        startstop.running = startstop.isRunning()
        startstop.settext()
    end
    startstop.update = function()
        if (startstop.running) then
            local seconds = startstop.currenttime.seconds + startstop.timeout
            local minute = startstop.currenttime.minute + math.floor(seconds / 60)
            startstop.currenttime.minute = minute % 60
            startstop.currenttime.hour = startstop.currenttime.hour + math.floor(minute/60)
            startstop.currenttime.seconds = seconds % 60
            startstop.settext()
        end
    end
    startstop.timer= timer({timeout = startstop.timeout})
    startstop.timer:connect_signal("timeout",startstop.update)
    startstop.timer:start()
    startstop.settext()
    return startstop
end
nmanagerwidget = getTimeStartStopWidget()

function keepAliveWidget(errorLimit, warningLimit, preText, postText)
    local keepAlive ={}
    keepAlive.widget = wibox.widget.textbox() --
    keepAlive.errorLimit = errorLimit or 60;
    keepAlive.warningLimit = warningLimit or 10;
    keepAlive.preText = preText or "";
    keepAlive.postText = postText or "";
    keepAlive.timeout = 1;
    keepAlive.seconds = 0;
    keepAlive.running = false;
    keepAlive.warningColor = 'yellow';
    keepAlive.errorColor = 'red';
    keepAlive.normalColor = 'white';
    keepAlive.update = function()
        if (keepAlive.running) then
            keepAlive.seconds = keepAlive.seconds + keepAlive.timeout
            keepAlive.setCurrent()
        end
    end
    keepAlive.basetext = "<span color =%q>%s%s%s</span>"
    keepAlive.setCurrent = function ()
        if (keepAlive.errorLimit and keepAlive.seconds >= keepAlive.errorLimit) then
            color = keepAlive.errorColor
        elseif (keepAlive.warningLimit and keepAlive.seconds >= keepAlive.warningLimit) then
            color = keepAlive.warningColor
        else 
            color = keepAlive.normalColor
        end
        keepAlive.updateText(keepAlive.seconds, color);
    end
    keepAlive.updateText = function(text, color)
        color = color or 'white'
        keepAlive.widget:set_markup(string.format(keepAlive.basetext, color, keepAlive.preText, text, keepAlive.postText))
    end
    keepAlive.reset = function () 
        keepAlive.running = true;
        keepAlive.seconds = 0;
    end
    keepAlive.timer= timer({timeout = keepAlive.timeout})
    keepAlive.timer:connect_signal("timeout", keepAlive.update)
    keepAlive.timer:start()
    return keepAlive
end

liveKeepAlive = keepAliveWidget(60,15, "nab-dev: ");
ncmPlatformAlive = keepAliveWidget(60,15, "platform: ");

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)


nabdnswidget = getBasicTextWidget()
lastPhabricatorTask = getBasicTextWidget()
cpuSpeed = getBasicTextWidget()
local M = {}
M.memwidget = {memicon, memwidget}
M.volumewidget = {volicon, volumewidget}
M.tempwidget = {tempicon, tempwidget}
M.fswidget = {fsicon, fswidget}
M.batwidget = {baticon, batwidget}
M.cpuwidget = {cpuicon, cpuwidget}
M.netwidget = {neticon, netwidget}
M.clockwidget = {clockicon, mytextclock}
M.gitwidget = {gitwidget.widget}
M.nmanagerwidget = {nmanagerwidget.widget}
M.nabdnswidget = {nabdnswidget.widget}
M.lastPhabricatorTask = {lastPhabricatorTask.widget}
M.liveKeepAlive = {liveKeepAlive.widget}
M.ncmPlatformAlive = {ncmPlatformAlive.widget}
M.cpuspeedwidget = {cpuSpeed.widget}
M.updaters = {
    gitwidget = gitwidget.clientupdate,
    nmanager = nmanagerwidget.newclientupdate,
    nabdnswidget = nabdnswidget.update,
    lastPhabricatorTask = lastPhabricatorTask.update,
    cpuSpeed = cpuSpeed.update,
    liveKeepAlive = liveKeepAlive.reset,
    ncmPlatformAlive = ncmPlatformAlive.reset,
}
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
