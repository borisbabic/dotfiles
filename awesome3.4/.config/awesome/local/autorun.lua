local awful = require("awful")
-- {{{ Custom functions
function spawn_once(command, class,screen,tag)
    local callback
    callback = function (c)
        if c.class == class then
            awful.client.movetoscreen(c,screen)
            awful.client.movetotag(tags[screen][tag],c)
            client.remove_signal("manage",callback)
        end
    end
    client.add_signal("manage", callback)
    local findme = command
    local firstspace = findme:find(" ")
    if firstspace then
        findme = findme:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -x " .. findme .. "> /dev/null || (" .. command ..")")
end
-- }}}

awful.util.spawn_with_shell('xrandr --output DVI-0 --auto --left-of VGA-0')
awful.util.spawn_with_shell('xfce4-session')
--awful.util.spawn_with_shell('lxqt-session')
spawn_once('chromium-browser','Chromium-browser', 1,1)
spawn_once('firefox', 'Firefox', 2, 1)
--spawn_once('xfce4-terminal', 'xfce4-terminal', 2, 2)
awful.util.spawn_with_shell('/usr/bin/gvim')
awful.util.spawn_with_shell('/home/boris/bin/capsesc')
--awful.util.spawn_with_shell('lockexec --daemon')
    --awful.util.spawn_with_shell('xscreensaver -nosplash')
--awful.util.spawn_with_shell('/home/boris/bin/startstop --daemon')
awful.util.spawn_with_shell('/home/boris/bin/capsesc')
--awful.util.spawn_with_shell('nmanager --start')


