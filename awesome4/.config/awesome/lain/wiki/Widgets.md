# Usage

Every lain widget is a table.

A lain widget is generated by a `function`.

The `function` signature, input and output arguments can be found in the [related wiki entry](https://github.com/lcpz/lain/wiki/Widgets#index).

Every lain widget contains a `wibox.widget`, which is updated by a timed function. To access the widget, use the field `widget`, while to access the timed function, use the field `update`. Some lain widgets may also have an `icon` field, which is a `wibox.widget.imagebox`, and/or a `timer` field, which is the `gears.timer` on `update`.

Every `function` may take either a table or a list of variables as input.

If the input is a table, you must define a function variable called `settings` in it. There you will be able to define `widget` appearance.

For instance, if `widget` is a textbox, to markup it call `widget:set_markup(...)` within `settings`.

In the scope of `settings` you can use predefined arguments, which are specified in the wiki entries.

Example of a lain widget:

```lua
local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("Cpu " .. cpu_now.usage)
    end
}
-- to access the widget: cpu.widget
```

If you want to see some applications, check [awesome-copycats](https://github.com/lcpz/awesome-copycats).

# Index

- [alsa](https://github.com/lcpz/lain/wiki/alsa)
- [alsabar](https://github.com/lcpz/lain/wiki/alsabar)
- [bat](https://github.com/lcpz/lain/wiki/bat)
- [cal](https://github.com/lcpz/lain/wiki/cal)
- [cpu](https://github.com/lcpz/lain/wiki/cpu)
- [fs](https://github.com/lcpz/lain/wiki/fs)
- [imap](https://github.com/lcpz/lain/wiki/imap)
- [mem](https://github.com/lcpz/lain/wiki/mem)
- [mpd](https://github.com/lcpz/lain/wiki/mpd)
- [net](https://github.com/lcpz/lain/wiki/net)
- [pulse](https://github.com/lcpz/lain/wiki/pulse)
- [pulsebar](https://github.com/lcpz/lain/wiki/pulsebar)
- [sysload](https://github.com/lcpz/lain/wiki/sysload)
- [temp](https://github.com/lcpz/lain/wiki/temp)
- [weather](https://github.com/lcpz/lain/wiki/weather)

## Users contributed

- [moc](https://github.com/lcpz/lain/wiki/moc)
- [redshift](https://github.com/lcpz/lain/wiki/redshift)
- [task](https://github.com/lcpz/lain/wiki/task)
- [tpbat](https://github.com/lcpz/lain/wiki/tpbat)
