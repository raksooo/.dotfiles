local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local volume = {
    colors = {
        unmute = "#83b879",
        mute = "#ddb76f"
    }
}

function volume.create()
    volume.bar = wibox.widget {
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = 3,
        bar_color           = "#ffffff66",
        handle_shape        = gears.shape.circle,
        handle_border_color = "#ffffff66",
        handle_border_width = 1,
        widget              = wibox.widget.slider,
    }


    local widget = wibox.widget {
        {
            volume.bar,
            forced_width = 22,
            direction = 'east',
            layout = wibox.container.rotate
        },
        layout = wibox.layout.fixed.horizontal
    }

    awful.tooltip({
        objects = { widget },
        timer_function = function() return volume.tooltip end,
    })

    volume.update()

    return widget
end

function volume.update()
    awful.spawn.easy_async("volumedata", function(stdin)
            local data = split(stdin, "\n")

            volume.tooltip = data[1] .. "%"
            volume.bar:set_value(tonumber(data[1]))
            if data[3] == "off" then
                volume.tooltip = volume.tooltip .. " [Muted]"
                volume.bar.handle_color = volume.colors.mute
            else
                volume.bar.handle_color = volume.colors.unmute
            end
        end)
end

function split(inputstr, sep)
        if inputstr == nil then
            return nil
        end
        if sep == nil then
            sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

return volume

