local mywidgets = require("mywidgets")
local M = {}

local right_widgets = {
    mywidgets.clockwidget,
}
local commands_once = {
}
local commands_always = {
        'setxkbmap -option "caps:escape"',
}

M.right_widgets = right_widgets
M.commands_always = commands_always
M.commands_once = commands_once

return M
