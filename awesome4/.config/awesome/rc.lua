--[[

     Awesome WM configuration template
     github.com/lcpz

--]]
if os.getenv("DESKTOP_SESSION") and string.match(os.getenv("DESKTOP_SESSION"), "plasma") then
    -- hack to disable notification if in plasma session
    dbus = nil
end
-- {{{ Required libraries
local awesome, client, root, screen = awesome, client, root, screen
-- local ipairs, string, os, tostring, type = ipairs, string, os, tostring, type

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
--local menubar       = require("menubar")
-- local freedesktop   = require("freedesktop")
-- local hotkeys_popup = require("awful.hotkeys_popup").widget
--                       require("awful.hotkeys_popup.keys")
local keybindings = require("keybindings")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' E> /dev/null || (%s)", cmd, cmd))
    end
end

run_once({"urxvtd", "unclutter -root", "xscreensaver -nosplash", "copyq"}) -- entries must be separated by commas

-- This function implements the XDG autostart specification
-- awful.spawn.with_shell(
--     'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
--     'xrdb -merge <<< "awesome.started:true";' ..
--     -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
--     'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"'
--     -- https://github.com/jceb/dex
-- )

-- }}}

-- {{{ Variable definitions

local modkey = "Mod4"
local terminal = "terminator"

awful.util.terminal = terminal
awful.util.tagnames = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}
naughty.config.defaults["icon_size"] = 100

awful.util.taglist_buttons =
    my_table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

awful.util.tasklist_buttons =
    my_table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ),
    awful.button(
        {},
        2,
        function(c)
            c:kill()
        end
    ),
    awful.button(
        {},
        3,
        function()
            local instance = nil

            return function()
                if instance and instance.wibox.visible then
                    instance:hide()
                    instance = nil
                else
                    instance = awful.menu.clients({theme = {width = 250}})
                end
            end
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

beautiful.init(string.format("%s/.config/awesome/theme.lua", os.getenv("HOME")))
-- }}}

-- {{{ Menu
-- local myawesomemenu = {
--     { "hotkeys", function() return false, hotkeys_popup.show_help end },
--     { "manual", terminal .. " -e man awesome" },
--     { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
--     { "restart", awesome.restart },
    --     { "quit", function() awesome.quit() end }
-- }
-- awful.util.mymainmenu = freedesktop.menu.build({
--     icon_size = beautiful.menu_height or 16,
--     before = {
--         { "Awesome", myawesomemenu, beautiful.awesome_icon },
--         -- other triads can be put here
--     },
--     after = {
--         { "Open terminal", terminal },
--         -- other triads can be put here
--     }
-- })
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal(
    "property::geometry",
    function(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
    function(s)
        beautiful.at_screen_connect(s)
    end
)
-- }}}
--
--awful.screen.set_auto_dpi_enabled( true )

-- {{{ Mouse bindings
root.buttons(
    my_table.join(
        -- awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- Set keys
root.keys(keybindings.globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keybindings.clientkeys,
            buttons = keybindings.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- { rule = { class = "Plasma" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },

    -- { rule = { class = "plasma-desktop" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },

    -- { rule = { class = "win7" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },

    -- { rule = { class = "Kmix" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },

    -- { rule = { class = "Klipper" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },

    -- { rule = { class = "Plasmoidviewer" },
    --     -- properties = { floating = true,screen = 1 } },
    --     properties = { floating = true } },
    { rule = { class = "yakuake" },
        -- properties = { floating = true,screen = 1 } },
        properties = { floating = true } },
    { rule = { class = "plasmashell", type = "notification"},
        -- properties = { floating = true,screen = 1 } },
        properties = { ontop = true } },

    {
        rule = {class = "plasmashell", type="normal"},
        properties = {
            floating = true,
            height = 600,
            width = 600,
        },
        callback = function (c)
            local f = awful.placement.under_mouse + awful.placement.closest_corner
            f(c, {honor_workarea=true})
            -- c:unmanage()
        end
        -- callback = function(c)
            -- c:geometry( { width = 600 , height = 600 } )
            -- awful.placement.next_to(c, {preferred_positions = {"top"}, preferred_anchors= {"middle"} })
            -- local mc = mouse.coords()
            -- c:geometry( { width = 100 , height = 100 } )
            -- awful.placement.top_left(c, {honor_workarea = true})
            -- -- naughty.notify({text = table.tostring(mc)})
            -- local curr_screen_number = awful.screen.getbycoord(mc.x, mc.y)
            -- local curr_screen = screen[curr_screen_number]
            -- -- naughty.notify({text = table.tostring(curr_screen)})
            -- awful.placement.top_right(c, {honor_workarea = true})
            -- if not curr_screen then
            --     naughty.notify({text=curr_screen_number})
            -- else
            --     naughty.notify({text=string.format("mc.y: %d, mc.x: %d, s.g.y: %d, s.g.x: %d, s.w.y: %d, s.w.x: %d, csn: %d", mc.y, mc.x, curr_screen.geometry.y, curr_screen.geometry.x, curr_screen.workarea.y, curr_screen.workarea.x, curr_screen_number )})
            -- end
            -- if curr_screen and mc.y < curr_screen.workarea.y then
            --     -- bottom on the panel
            --     if mc.x < curr_screen.geometry.x /2 then
            --         -- left side, so probably launcher
            --         c:geometry( { width = 600 , height = 900 } )
            --         awful.placement.bottom_left(c, {honor_workarea = true})
            --     else
            --         -- right side
            --         c:geometry( { width = 600 , height = 600 } )
            --         awful.placement.bottom_right(c, {honor_workarea = true})
            --     end
            -- else
            --     c:geometry( { width = 600 , height = 600 } )
            --     awful.placement.top(c, {honor_workarea = true})
            -- end
            -- naughty.notify({text = "test"})
            -- naughty.notify({text = mouse.screen})
            -- naughty.notify({text = awful.mouse.screen})
            -- -- if mouse.coords().y < mouse.screen.workarea.y then
            --     -- clicked something on the lower panel
            --     c:geometry( { width = 600 , height = 600 } )
            --     awful.placement.bottom(c, {honor_workarea = true})
            --     local mouse_x = mouse.coords().x;
            --     awful.placement.top(c, {honor_workarea = true})
            --     local screen_x = mouse.screen.geometry.x;
            --     awful.placement.top_left(c, {honor_workarea = true})
            --     if mouse_x < (screen_x / 2 ) then -- it's on the left, so likely application launcher
            --         c:geometry( { width = 600 , height = 900 } )
            --         awful.placement.bottom_left(c, {honor_workarea = true})
            --     else
            --         c:geometry( { width = 600 , height = 600 } )
            --         awful.placement.bottom_right(c, {honor_workarea = true})
            --     end
            -- -- end
        -- end,
    },
    -- { rule = { class = "plasmashell", name="Desktop" },
    --     properties = { minimized = true, focusable = false },
    -- },
    -- {
    --     rule = {class = "krunner"},
    --     properties = {floating = true}
    -- },
    { rule = { class = "krunner" },
        properties = { floating = true },
        callback = function (c)
            -- awful.placement.offset(c, nil)
            -- local client_geometry = c:geometry()
            -- local screen_geometry = screen[c.screen].geometry
            -- return c:geometry({
            --     y = screen_geometry.y, x = screen_geometry.x + (screen_geometry.width  - client_geometry.width) / 2 })
            awful.placement.top(c, nil)
        end
    },

    -- Titlebars
    {
        rule_any = {type = {"dialog", "normal"}},
        properties = {titlebars_enabled = false}
    },
    -- Set Firefox to always map on the first tag on screen 1.
    --    { rule = { class = "Firefox" },
    --      properties = { screen = 1, tag = awful.util.tagnames[1] } },

    {
        rule = {class = "Gimp", role = "gimp-image-window"},
        properties = {maximized = true}
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- Custom
        if beautiful.titlebar_fun then
            beautiful.titlebar_fun(c)
            return
        end

        -- Default
        -- outtons for the titlebar
        local buttons =
            my_table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                2,
                function()
                    c:kill()
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c, {size = 16}):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = true})
    end
)

-- No border for maximized clients
local border_adjust
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", border_adjust)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)
-- }}}
