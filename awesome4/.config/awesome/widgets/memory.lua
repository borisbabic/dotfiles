local wibox = require("wibox")
local wu = require("widgets_util")
local lain = require("lain")
local memicon = wibox.widget.imagebox('path')
local markup = lain.util.markup
local mem = lain.widget.mem(
    {
        settings = function()
            widget:set_markup(markup.font(theme.font), " " .. mem_now.used .. "MB "))
        end
    }
)

local ret = {
    icon = memicon,
    widget = mem,
}
ret.horizontal = wu.icon_then_widget_horizontal(ret)

M.icon_then_widget_horizonal = function(wwi)
    icon_then_widget(wwi, wibox.layout.fixed.horizontal())
end

M.widget_with_icon_r = function(widget_with_icon, optional_layout)
    return function (wwi, layout)
        layout = layout or wibox.layout.fixed.horizontal()
        return {
            {
                widget = wwi.icon,
            }
        }
    end
return ret