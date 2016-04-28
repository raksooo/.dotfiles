local alsawidget

function volumeWidget(terminal)
    alsawidget = {
        channel = "Master",
        step = "5%",
        colors = {
            unmute = "#859900",
            mute = "#dc322f"
        },
        mixer = "pavucontrol",
    }
    -- widget
    alsawidget.bar = awful.widget.progressbar()
    volumeWidget = wibox.layout.fixed.horizontal()
    alsawidget.bar:set_vertical(true)
    alsawidget.bar:set_width (15)
    alsawidget.bar:set_background_color ("#002b36")
    alsawidget.bar:set_color (alsawidget.colors.unmute)
    volumeWidget:buttons (awful.util.table.join (
        awful.button ({}, 1, function()
            os.execute(alsawidget.mixer .. " &")
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
    volumeText:set_markup("A: ")
    volumeWidget:add(volumeText)
    volumeWidget:add(alsawidget.bar)
    return volumeWidget
end

function updateVolumeWidget()
    vicious.force({ alsawidget.bar })
end

