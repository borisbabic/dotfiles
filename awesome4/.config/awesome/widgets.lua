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
        local widget
        if w.icon and w.widget then
            -- widget = icon_then_widget_horizontal(w)
            widget =
                wibox.widget {
                {widget = w.icon},
                {widget = w.widget},
                layout = wibox.layout.fixed.horizontal()
            }
        else
            widget = w
        end
        if current.light_background then
            widget = wibox.container.background(widget, light_background)
        end
        table.insert(right_widgets, widget)
    end
    return right_widgets
end
return M
