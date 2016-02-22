local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")
local tools = require("../tools")

function batteryWidget()
    batteryWidget = wibox.layout.fixed.horizontal()
    batteryText = wibox.widget.textbox()
    batteryTooltip = awful.tooltip ({ objects = { batteryWidget } })

    battery = awful.widget.progressbar()
    battery:set_vertical(true)
    battery:set_width(7)
    battery:set_background_color("#494B4F")

    initInterval(function()
            updateBatteryWidget(battery, batteryText, batteryTooltip)
        end, 15, 1)

    batteryWidget:add(batteryText)
    batteryWidget:add(tools.spacing)
    batteryWidget:add(battery)
    return batteryWidget
end

function updateBatteryWidget(battery, batteryText, batteryTooltip)
    getBatteryData(function(data)
        timeleft = ""
        if #data[2] >= 5 then
            timeleft = data[2][4] .. " " .. data[2][5]
        end

        state = data[1][#data[1]]
        capacity = data[4][#data[4]]
        capacity = split(capacity, "%%")[1]
        capacity = tonumber(capacity)
        percentage = data[3][#data[3]]
        percentage = percentage:gsub("%W", "")
        percentage = tonumber(percentage)
        percentage = math.min(round((percentage / capacity) * 100), 100)

        formatBatteryContent(state, percentage, timeleft)

        batteryNotification(percentage, timeleft)
    end)
end

function getBatteryData(callback)
    asyncshell.request("upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage|time to|capacity'",
        function(data)
            data = split(data, "\n")

            local timeleft
            if data[4] == nil then
                data[4] = data[3]
                data[3] = data[2]
                data[2] = ""
            end

            data[1] = split(data[1], " ")
            data[2] = split(data[2], " ")
            data[3] = split(data[3], " ")
            data[4] = split(data[4], " ")

            callback(data)
        end)
end

function formatBatteryContent(state, percentage, timeleft)
    local text = ""
    local color
    local tooltip
    if state == "fully-charged" then
        tooltip = "Fully charged"
        color = "#AECF96"
    elseif state == "charging" then
        tooltip = "Charging: " .. timeleft .. " until full"
        color = "#B0E0E6"
        text = "⚡"
    elseif percentage <= 10 then
        tooltip = timeleft .. " until empty"
        color = "#FF5656"
        text = "Battery low: "
    elseif percentage <= 30 then
        tooltip = timeleft .. " until empty"
        color = "#FFFF77"
    else
        tooltip = timeleft .. " until empty"
        color = "#AECF96"
    end
    text = "<span color=\"" .. color .. "\">" .. text .. percentage .. "%</span>"
    batteryText:set_markup(text)
    batteryTooltip:set_text("  " .. tooltip .. "  ")
    battery:set_color(color)
    battery:set_value(percentage/100)
end

local lowbattery = false
function batteryNotification(percentage, timeleft)
    if percentage <= 10 and not(lowbattery) then
        lowbattery = true
        naughty.notify({ preset = {
            title = "Low battery",
            text = "Only " .. percentage .. "% (" .. timeleft .. ") left",
            timeout = 120
        } })
    elseif percentage > 10 then
        lowbattery = false
    end
end

