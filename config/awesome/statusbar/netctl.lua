local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local netctl = {
    colors = {
        high = "#83b879",
        low = "#ddb76f",
        none = "#dd6880",
    },
    levels = {
        high = 50,
        low = 80
    }
}

function netctl.create()
    netctl.widget = wibox.widget {
        paddings      = 3,
        border_width  = 2,
        border_color  = "#ffffff66",
        shape         = gears.shape.circle,
        widget        = wibox.widget.checkbox
    }

    awful.tooltip({
        objects = { netctl.widget },
        timer_function = function() return netctl.tooltip end,
    })

    netctl.update()
    gears.timer.start_new(10, netctl.update)

    return netctl.widget
end

function netctl.update()
    awful.spawn.easy_async('cat /proc/net/wireless', function(stdin)
        local data = split(stdin, '\n')
        local color, checked
        if #data == 3 then
            local numbers = split(data[3], '-')
            local level = split(numbers[2], '.')
            netctl.widget.paddings = 3 + ((1 - math.max(0, math.min(1, (netctl.levels.low - level[1]) * (100/(netctl.levels.low - netctl.levels.high)) / 100))) * 7)
            checked = true
            color = netctl.colors.high
            updateTooltip(level[1])
        else
            checked = false
            color = netctl.colors.none
            netctl.tooltip = 'Not connected'
        end
        netctl.widget:set_checked(checked)
        netctl.widget:set_color(color)
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

