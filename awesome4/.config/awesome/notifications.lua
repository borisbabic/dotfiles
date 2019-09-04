local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")

local notification_history = {}

naughty.connect_signal('added', function (n)
    table.insert(notification_history, n)
end)


local function showPopup()
    awful.popup {
        widget = naughty.list.notifications,
        screen = screen[1],
        style = {
            shape = gears.shape.rounded_rect
        }
        -- widget = awful.widget.tasklist {
        --     screen = screen[1],
        --     style = {
        --         shape = gears.shape.rounded_rect
        --     }

        -- }
    }
end


-- local wibox     = require("wibox") --DOC_HIDE
-- local beautiful = require("beautiful") --DOC_HIDE

-- for i=1, 3 do --DOC_HIDE
--     naughty.notification { --DOC_HIDE
--         title = "A notification "..i, --DOC_HIDE
--         text = "Be notified! "..i, --DOC_HIDE
--         icon = i%2 == 1 and beautiful.awesome_icon, --DOC_HIDE
--         timeout = 999, --DOC_HIDE
--         actions = { --DOC_HIDE
--             naughty.action { --DOC_HIDE
--                 name = "Accept "..i, --DOC_HIDE
--                 icon = beautiful.awesome_icon, --DOC_HIDE
--             }, --DOC_HIDE
--             naughty.action { --DOC_HIDE
--                 name = "Refuse", --DOC_HIDE
--                 icon = beautiful.awesome_icon, --DOC_HIDE
--             }, --DOC_HIDE
--         } --DOC_HIDE
--     } --DOC_HIDE
-- end --DOC_HIDE
-- for _, n in ipairs(notification_history) do
    -- naughty.notification(n)
-- end
-- showPopup()


-- beautiful.notification_icon_size         = 48   --DOC_HIDE
-- beautiful.notification_action_label_only = true --DOC_HIDE

-- --DOC_NEWLINE

--    -- This awful.wibar will be placed at the bottom and contain the notifications.
--     local notif_wb = awful.wibar {
--         position = "right",
--         width = 100,
--         visible  = #naughty.active > 0,
--     }

-- --DOC_NEWLINE

--     notif_wb:setup {
--         nil,
--         {
--             base_layout = wibox.widget {
--                 spacing_widget = wibox.widget {
--                     orientation = "horizontal",
--                     span_ratio  = 0.5,
--                     widget      = wibox.widget.separator,
--                 },
--                 -- forced_height = 30,
--                 spacing       = 3,
--                 layout        = wibox.layout.flex.vertical
--             },
--             widget_template = {
--                 {
--                     naughty.widget.icon,
--                     {
--                         naughty.widget.title,
--                         naughty.widget.message,
--                         {
--                             layout = wibox.widget {
--                                 -- Adding the `wibox.widget` allows to share a
--                                 -- single instance for all spacers.
--                                 spacing_widget = wibox.widget {
--                                     orientation = "vertical",
--                                     span_ratio  = 0.9,
--                                     widget      = wibox.widget.separator,
--                                 },
--                                 spacing = 3,
--                                 layout  = wibox.layout.flex.vertical
--                             },
--                             widget = naughty.list.widgets,
--                         },
--                         layout = wibox.layout.align.vertical
--                     },
--                     spacing = 10,
--                     fill_space = true,
--                     layout  = wibox.layout.fixed.vertical
--                 },
--                 margins = 5,
--                 widget  = wibox.container.margin
--             },
--             widget = naughty.list.notifications,
--         },
--         -- Add a button to dismiss all notifications, because why not.
--         {
--             {
--                 text   = "Dismiss all",
--                 align  = "center",
--                 valign = "center",
--                 widget = wibox.widget.textbox
--             },
--             buttons = gears.table.join(
--                 awful.button({ }, 1, function() naughty.destroy_all_notifications() end)
--             ),
--             forced_width       = 75,
--             shape              = gears.shape.rounded_bar,
--             shape_border_width = 1,
--             shape_border_color = beautiful.bg_highlight,
--             widget = wibox.container.background
--         },
--         layout = wibox.layout.align.vertical
--     }

-- --DOC_NEWLINE

--     -- We don't want to have that bar all the time, only when there is content.
--     naughty.connect_signal("property::active", function()
--         notif_wb.visible = #naughty.active > 0
--     end)


-- --DOC_HIDE The delayed make sure the legacy popup gets disabled in time
-- gears.timer.run_delayed_calls_now()--DOC_HIDE

