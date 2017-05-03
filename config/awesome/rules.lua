local awful = require("awful")

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
          gears.timer.start_new(0.2, function ()
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

    if c.floating then
        c.border_width = beautiful.border_width_floating
        c.border_color = beautiful.border_color_floating
        awful.placement.no_offscreen(c)
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
    if not c.floating then
        c.border_color = beautiful.border_focus
    end
end)

client.connect_signal("unfocus", function(c)
    if c.class ~= nil and c.class:lower() == terminal then
        c.opacity = 0.75
    else
        c.opacity = beautiful.opacity_normal
    end
    if not c.floating then
        c.border_color = beautiful.border_normal
    end
end)

client.connect_signal("property::floating", function(c)
    if c.floating then
        c.border_width = beautiful.border_width_floating
        c.border_color = beautiful.border_color_floating
        awful.placement.no_offscreen(c)
    else
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_normal
    end
end)

