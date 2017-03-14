local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local netctl = {
    colors = {
        high = "#83b879",
        low = "#ddb76f",
        none = "#dd6880",
        background = "#00000000"
    },
    levels = {
        high = 40,
        low = 80
    }
}

local options = {
    width = 12,
    margin = 5,
    margin_right = 40
}

function netctl.create()
    netctl.bar = wibox.widget {
        background_color = netctl.colors.background,
        widget           = wibox.widget.progressbar,
    }

    local widget = wibox.widget {
        {
            {
                text = "W:",
                opacity = 0.6,
                widget = wibox.widget.textbox
            },
            right   = 6,
            top   = 2,
            layout  = wibox.container.margin
        },
        {
            netctl.bar,
            forced_width = options.width,
            direction = 'east',
            layout = wibox.container.rotate
        },
        layout = wibox.layout.fixed.horizontal
    }

    awful.tooltip({
        objects = { widget },
        timer_function = function() return netctl.tooltip end,
    })

    netctl.update()
    gears.timer.start_new(10, netctl.update)

    return wibox.widget {
        widget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin + 1,
        bottom   = options.margin,
        layout  = wibox.container.margin
    }
end

function netctl.update()
    awful.spawn.easy_async('cat /proc/net/wireless', function(stdin)
        local data = split(stdin, '\n')
        local color, value
        if #data == 3 then
            local numbers = split(data[3], '-')
            local level = split(numbers[2], '.')
            value = math.max(0, math.min(1, (netctl.levels.low - level[1]) * (100/(netctl.levels.low - netctl.levels.high)) / 100))
            color = netctl.colors.high
            updateTooltip(level[1])
        else
            value = 1
            color = netctl.colors.none
            netctl.tooltip = 'Not connected'
        end
        netctl.bar:set_value(value)
        netctl.bar:set_color(color)
    end)
    return true
end

function updateTooltip(level)
    awful.spawn.easy_async('sudo netctl-auto list', function(stdin)
        local list = split(stdin, '\n')
        for i, network in pairs(list) do
            if string.sub(network, 1, 1) == '*' then
                local n = split(network, '-')
                netctl.tooltip = n[2] .. ' (-' .. level .. 'dB)'
            end
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

return netctl

