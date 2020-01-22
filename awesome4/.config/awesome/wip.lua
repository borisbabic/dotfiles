-- stuff thats work in progress
local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")

local notification_history = {}

naughty.connect_signal(
    "added",
    function(n)
        table.insert(notification_history, n)
    end
)

local apppopup = require("awful.hotkeys_popup.widget").new()
-- apppopup.add_hotkeys({["TEST: TEST"] = {{modifiers = {}, keys = {["0"] = "HELLO WORLD"}}}})

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

return { test = apppopup.show_help }