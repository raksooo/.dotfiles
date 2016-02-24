-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
wibox = require("wibox")
tools = require("tools")
asyncshell = require("asyncshell")
drop  = require("scratchdrop")

-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
vicious = require("vicious")

require("layouts")
require("keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/rascal/.config/awesome/theme.lua")

naughty.config.defaults.height = 60
naughty.config.defaults.width = 250
naughty.config.defaults.margin = 7
naughty.config.defaults.spacing = 3

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
webbrowser = "qutebrowser"
launcher = "rofiHistory"
screenshot = "maim /home/rascal/documents/Bilder/screenshots/$(date +%F-%T).png"
titlebars_enabled = false
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Statusbar
require("statusbar/statusbar")
-- }}}

-- {{{ Key bindings
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
function mpvStart(c)
    local tag = awful.tag.getidx()
    if tag == 4 and client.focus then
        awful.client.setslave(c)
        c:tags({ tags[1][1], tags[1][4], tags[1][5] })
    end
end

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = "#303030", -- beautiful.border_color,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[1][9] } },
    { rule = { class = "qutebrowser" },
      properties = { tag = tags[1][4] },
      callback = awful.client.setslave },
    { rule = { class = "http___messenger_com" },
      properties = { tag = tags[1][4] },
      callback = awful.client.setmaster },
    { rule = { class = "chromium" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "mpv" },
      callback = mpvStart },
}
-- }}}

-- {{{ Startup
awful.layout.set(awful.layout.suit.tile.left, tags[1][4])
awful.tag.setmwfact(0.25, tags[1][4])
awful.tag.setgap(1, tags[1][4])
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.maximizedbutton(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c)
    if c.class == "XTerm" then
        c.opacity = 0.95
    else
        c.opacity = 1
    end
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    if c.class ~= "mpv" then
        c.opacity = 0.75
    end
    c.border_color = "#303030" -- theme.border_normal
end)
-- }}}


client.connect_signal("focus",
        function(c)
                if c.maximized_horizontal == true and c.maximized_vertical == true then
                        c.border_width = "0"
                        c.border_color = beautiful.border_focus
                else
                        c.border_width = beautiful.border_width
                        c.border_color = beautiful.border_focus
                end
        end)

client.connect_signal("unfocus",
        function(c)
                c.border_width = beautiful.border_width
                c.border_color = beautiful.border_focus
        end)

