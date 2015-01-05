local awful = require("awful")

awful.util.spawn_with_shell('/usr/bin/setxkbmap -option "caps:escape"')
awful.util.spawn_with_shell('lxqt-session')
