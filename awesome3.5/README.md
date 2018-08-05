# Installation
After cloning this repo you need to fetch the lain submodule:

`git submodule init awesome3.5/.config/awesome/lain; git submodule update awesome3.5/.config/awesome/lain`

After running `git stow awesomewm3.5` you must create a specific.lua file, you can copy the basic skeleton `cp ~/.config/awesome/specific.lua.skel ~/.config/awesome/specific.lua.skel` or use the following example:

```lua
local mywidgets = require("mywidgets")
local M = {}

local right_widgets = {
    mywidgets.volumewidget,
    mywidgets.memwidget,
    mywidgets.cpuwidget,
    mywidgets.tempwidget,
    mywidgets.batwidget,
    mywidgets.netwidget,
    mywidgets.clockwidget,
}
local commands_once = {
    'xscreensaver -nosplash', #if you want to use xscreensaver
    'xbindkeys',
}
local commands_always = {
        'setxkbmap -option "caps:escape"',
}

M.right_widgets = right_widgets
M.commands_always = commands_always
M.commands_once = commands_once

return M
```

## Future plans
- Migrate to version 4 or to [way-cooler](https://github.com/way-cooler/way-cooler) when it becomes compatible
