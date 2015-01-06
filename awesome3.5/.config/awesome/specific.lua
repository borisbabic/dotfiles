local mywidgets = require("mywidgets")
local M = {}
right_widgets = {
    mywidgets.volumewidget,
    mywidgets.memwidget,
    mywidgets.cpuwidget,
    mywidgets.tempwidget,
    mywidgets.batwidget,
    mywidgets.netwidget,
    mywidgets.clockwidget,
}
commands_once =
    {
        'lxqt-session',
    }
commands_always = {
        'setxkbmap -option "caps:escape"',
    }

M.right_widgets = right_widgets
M.commands_always = commands_always
M.commands_once = commands_once

return M
