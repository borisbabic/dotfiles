local wibox = require("wibox")

local M = {}
M.get_right_widgets = function(widget_list, arrl_dl, arrl_ld, light_background)
    local Alternator = {curr = 0}
    function Alternator.get_current()
        local ret = {
            arrow = Alternator.curr == 0 and arrl_ld or arrl_dl,
            light_background = Alternator.curr == 0
        }
        Alternator.curr = 1 - Alternator.curr
        return ret
    end

    local right_widgets = {
        layout = wibox.layout.fixed.horizontal(),
        wibox.widget.systray()
    }
    for _, w in ipairs(widget_list) do
        local current = Alternator.get_current()
        table.insert(right_widgets, current.arrow)
        for _, widget in ipairs(w) do
            if current.light_background then
                widget = wibox.container.background(widget, light_background)
            end
            table.insert(right_widgets, widget)
        end
    end
    return right_widgets
end
function icon_then_widget(wwi, layout) 
    return {
        { widget = wwi.icon },
        { widget = wwi.widget},
        layout = layout
    }
end
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
end
return M
