local alsawidget

function volumeWidget(terminal)
    alsawidget = {
        channel = "Master",
        step = "5%",
        colors = {
            unmute = "#AECF96",
            mute = "#FF5656"
        },
        mixer = terminal .. " -e alsamixer", -- or whatever your preferred sound mixer is
    }
    -- widget
    alsawidget.bar = awful.widget.progressbar ()
    volumeWidget = wibox.layout.fixed.horizontal()
    alsawidget.bar:set_width (30)
    alsawidget.bar:set_ticks (true)
    alsawidget.bar:set_ticks_gap (1)
    alsawidget.bar:set_background_color ("#222222")
    alsawidget.bar:set_color (alsawidget.colors.unmute)
    alsawidget.bar:buttons (awful.util.table.join (
        awful.button ({}, 1, function()
            awful.util.spawn (alsawidget.mixer)
        end)
    ))
    -- tooltip
    alsawidget.tooltip = awful.tooltip ({ objects = { volumeWidget } })

    alsawidget._current_level = 0
    alsawidget._muted = false
    -- register the widget through vicious
    vicious.register (alsawidget.bar, vicious.widgets.volume, function (widget, args)
        alsawidget._current_level = args[1]
        if args[2] == "♩"
        then
            alsawidget._muted = true
            alsawidget.tooltip:set_text (" [Muted] ")
            widget:set_color (alsawidget.colors.mute)
            return 100
        end
        alsawidget._muted = false
        alsawidget.tooltip:set_text (" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
        widget:set_color (alsawidget.colors.unmute)
        return args[1]
    end, 5, alsawidget.channel) -- relatively high update time, use of keys/mouse will force update

    volumeText = wibox.widget.textbox()
    volumeText:set_markup("<span color=\"#666666\">A:</span><span color=\"#333333\">[</span>")
    volumeWidget:add(volumeText)
    volumeWidget:add(tools.margin(alsawidget.bar, 6))
    rightBracket = wibox.widget.textbox()
    rightBracket:set_markup(" <span color=\"#333333\">]</span>")
    volumeWidget:add(rightBracket)
    return volumeWidget
end

function volumekeys(globalkeys)
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioRaiseVolume", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
        vicious.force({ alsawidget.bar })
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioLowerVolume", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
        vicious.force({ alsawidget.bar })
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioMute", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " toggle")
        -- The 2 following lines were needed at least on my configuration, otherwise it would get stuck muted
        -- However, if the channel you're using is "Speaker" or "Headpphone"
        -- instead of "Master", you'll have to comment out their corresponding line below.
        awful.util.spawn("amixer sset " .. "Speaker" .. " unmute")
        awful.util.spawn("amixer sset " .. "Headphone" .. " unmute")
        vicious.force({ alsawidget.bar })
    end))

    return globalkeys
end

