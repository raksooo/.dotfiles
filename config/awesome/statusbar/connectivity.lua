local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local connectivity = {
    colors = {
        high = "#83b879",
        low = "#ddb76f",
        none = "#dd6880",
    },
    levels = {
        high = -50,
        low = -80
    }
}

function connectivity.create()
    connectivity.widget = wibox.widget {
        paddings      = 3,
        border_width  = 2,
        shape         = gears.shape.circle,
        widget        = wibox.widget.checkbox
    }

    awful.tooltip({
        objects = { connectivity.widget },
        timer_function = function() return connectivity.tooltip end,
    })

    connectivity.update()
    gears.timer.start_new(10, connectivity.update)

    return connectivity.widget
end

function connectivity.update()
    awful.spawn.easy_async('iw dev wlp58s0 link ', function(stdout)
        local color, checked
        if stdout ~= "Not connected.\n" then
            local data = gears.string.split(stdout, '\n')
            local ssid = gears.string.split(data[2], ' ')[2]
            local signal = gears.string.split(data[6], ' ')[2]
            local percentage = (signal - connectivity.levels.low) /
                (connectivity.levels.high - connectivity.levels.low)
            local limited = math.max(0, math.min(1, percentage))
            local padding = 10 - (limited * 7)

            connectivity.widget.paddings = padding
            checked = true
            color = connectivity.colors.high
            connectivity.tooltip = ssid .. ' (' .. signal .. 'dB)'
        else
            checked = false
            color = connectivity.colors.none
            connectivity.tooltip = 'Not connected'
        end
        connectivity.widget:set_checked(checked)
        connectivity.widget:set_color(color)

        awful.spawn.easy_async('vpn', function(stdout)
          if #stdout > 0 then
            connectivity.widget.border_color = "#ffffff66"
          else
            connectivity.widget.border_color = connectivity.colors.none
          end
        end)
    end)
    return true
end

return connectivity

