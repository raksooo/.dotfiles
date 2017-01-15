local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

systemUsage = {}
systemUsage.tooltip = {}
local options = {
    width = 7,
    margin = 5,
    margin_right = 40
}
systemUsage.colors = {
    low = "#83b879",
    medium = "#ddb76f",
    high = "#dd6880",
    background = "#00000000"
}

function systemUsage.create()
    systemUsage.ram = wibox.widget {
        max_value        = 1,
        background_color = systemUsage.colors.background,
        widget           = wibox.widget.progressbar,
    }

    systemUsage.cpu = wibox.widget {
        max_value        = 1,
        background_color = systemUsage.colors.background,
        widget           = wibox.widget.progressbar,
    }

    local systemUsageWidget = wibox.widget {
        {
            {
                text = "S:",
                opacity = 0.6,
                widget = wibox.widget.textbox
            },
            right   = 6,
            top   = 2,
            layout  = wibox.container.margin
        },
        {
            systemUsage.ram,
            forced_width = options.width,
            direction = 'east',
            layout = wibox.container.rotate
        },
        {
            systemUsage.cpu,
            forced_width = options.width,
            direction = 'east',
            layout = wibox.container.rotate
        },
        layout = wibox.layout.fixed.horizontal
    }

    awful.tooltip({
        objects = { systemUsageWidget },
        timer_function = function()
            return systemUsage.tooltip.ram .. "\n" .. systemUsage.tooltip.cpu
        end,
    })

    systemUsage.update()

    return wibox.widget {
        systemUsageWidget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin + 1,
        bottom   = options.margin,
        layout  = wibox.container.margin
    }
end

function systemUsage.update()
    updateCpu()
    updateRam()
    gears.timer.start_new(2, updateCpu)
    gears.timer.start_new(5, updateRam)
end

function updateCpu()
    awful.spawn.easy_async("cpudata", function(stdout)
        local lines = split(stdout, "\n")

        local sum = 0
        for k,v in pairs(lines) do
            sum = sum + tonumber(v)
        end
        percentageh = sum/#lines
        percentage = percentageh/100

        local color = percentageToColor(percentage, 0.33, 0.66)
        systemUsage.cpu:set_color(color)
        systemUsage.cpu:set_value(percentage)

        systemUsage.tooltip.cpu = "CPU: " .. sum .. "% ("
            .. percentageh .. "%)"
    end)
    return true
end

function updateRam()
    awful.spawn.easy_async("ramdata", function(stdout)
        local lines = split(stdout, "\n")
        local free = tonumber(lines[1])
        local total = tonumber(lines[2])
        local freeh = lines[3]
        local totalh = lines[4]

        local percentage = free / total
        local percentageh = math.ceil(100 * percentage)

        systemUsage.tooltip.ram = "RAM: " .. percentageh .. "% in use ("
            .. freeh .. "/" .. totalh .. ")"

        local color = percentageToColor(percentage, 0.5, 0.75)
        systemUsage.ram:set_color(color)
        systemUsage.ram:set_value(percentage)
    end)
    return true
end

function percentageToColor(percentage, limit1, limit2)
    if percentage < limit1 then
        return systemUsage.colors.low
    elseif percentage < limit2 then
        return systemUsage.colors.medium
    else
        return systemUsage.colors.high
    end
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

return systemUsage

