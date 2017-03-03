local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local statusbar = require("statusbar/statusbar")
local wallpaper = require("wallpaper")
local keys = require("keys")

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
                         text = tostring(err) })
        in_error = false
    end)
end

awesome.connect_signal("debug::deprecation", function (hint)
    naughty.notify({ title = "Deprecation warning", text = hint })
end)

beautiful.init("/home/oskar/.config/awesome/theme.lua")

terminal = "urxvt"
editor = "nvim"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
}

local statusbar_height = 35

awful.screen.connect_for_each_screen(function(s)
    statusbar.new(s, "bottom", statusbar_height)
end)

awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false,
                     border_width = 14 } },
    { rule = { class = "qutebrowser" },
      properties = { tag = "2" } },
    { rule = { class = "Chromium" },
      properties = { tag = "4" } },
    { rule = { class = "Spotify" },
      properties = { tag = "6" } },
    { rule = { class = "Messenger for Desktop" },
      callback = function (c)
          gears.timer.start_new(0.1, function ()
              awful.key.execute({ "Control", "Mod1" }, "b")
          end)
      end },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if c.class == nil then
        c:connect_signal("property::class", function ()
            awful.rules.apply(c)
        end)
    end

    if c.floating and not c.sticky then
        awful.placement.centered(c)
        c.y = math.max(0, c.y - 200)
    end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c)
    if c.class ~= nil and c.class:lower() == terminal then
        c.opacity = 0.9
    else
        c.opacity = beautiful.opacity_focus
    end
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    if c.class ~= nil and c.class:lower() == terminal then
        c.opacity = 0.75
    else
        c.opacity = beautiful.opacity_normal
    end
    c.border_color = beautiful.border_normal
end)

wallpaper.show(beautiful.wallpaper)

