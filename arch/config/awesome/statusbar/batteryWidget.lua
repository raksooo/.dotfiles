local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")

lowbattery = false

function batteryWidget()
    batteryWidget = wibox.widget.textbox()
    finalWidget = wibox.layout.fixed.horizontal()
    batteryWidgetTooltip = awful.tooltip ({ objects = { finalWidget } })

    battery = awful.widget.progressbar()
    battery:set_vertical(true)
    battery:set_width(7)
    battery:set_background_color("#494B4F")

    batteryWidgettimer = timer({ timeout = 20 })
    batteryWidgettimer:connect_signal("timeout",
      function()
        fh = io.popen("upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage|time to|capacity'")
        data = split(fh:read("*a"), "\n")
        fh:close()

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

        local timeleft = ""
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
        text = text ..  "<span color=\"" .. color .. "\">" .. percentage .. "%</span>"
        batteryWidget:set_markup(text)
        batteryWidgetTooltip:set_text("  " .. tooltip .. "  ")
        battery:set_color(color)
        battery:set_value(percentage/100)

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
    )
    batteryWidgettimer:emit_signal("timeout")
    batteryWidgettimer:start()

    finalWidget:add(batteryWidget)
    seperator = wibox.widget.textbox()
    seperator:set_text("  ")
    finalWidget:add(seperator)
    margin = wibox.layout.margin(battery, 0, 0, 2, 1)
    finalWidget:add(margin)
    return finalWidget
end

