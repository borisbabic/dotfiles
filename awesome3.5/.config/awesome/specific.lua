local mywidgets = require("mywidgets")
local M = {}
M.right_widgets = mywidgets.createList{
    mywidgets.volumewidget,
    mywidgets.memwidget,
    mywidgets.cpuwidget,
    mywidgets.tempwidget,
    mywidgets.batwidget,
    mywidgets.netwidget,
    --mywidgets.clockwidget
}
return M
