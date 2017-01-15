local wibox = require("wibox")
local awful = require("awful")

local volume = {
    colors = {
        unmute = "#83b879",
        mute = "#ddb76f",
        background = "#00000000"
    }
}

local options = {
    width = 12,
    margin = 5,
    margin_right = 40
}

function volume.create()
    volume.bar = wibox.widget {
        max_value        = 100,
        background_color = volume.colors.background,
        widget           = wibox.widget.progressbar,
    }

    local widget = wibox.widget {
        {
            {
                text = "A:",
                opacity = 0.6,
                widget = wibox.widget.textbox
            },
            right   = 6,
            top   = 2,
            layout  = wibox.container.margin
        },
        {
            volume.bar,
            forced_width = options.width,
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

    return wibox.widget {
        widget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin + 1,
        bottom   = options.margin,
        layout  = wibox.container.margin
    }
end

function volume.update()
    awful.spawn.easy_async("volumedata", function(stdin)
            local data = split(stdin, "\n")

            volume.tooltip = data[1] .. "%"
            volume.bar:set_value(tonumber(data[1]))
            if data[3] == "off" then
                volume.tooltip = volume.tooltip .. " [Muted]"
                volume.bar:set_color(volume.colors.mute)
            else
                volume.bar:set_color(volume.colors.unmute)
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

