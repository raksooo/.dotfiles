local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")

lowbattery = false

function batteryWidget()
    batteryWidget = wibox.widget.textbox()
    finalWidget = wibox.layout.fixed.horizontal()
    batteryWidgetTooltip = awful.tooltip ({ objects = { finalWidget } })

    battery = awful.widget.progressbar ()
    battery:set_vertical (true)
    battery:set_width (7)
    battery:set_background_color ("#494B4F")

    batteryWidgettimer = timer({ timeout = 20 })
    batteryWidgettimer:connect_signal("timeout",
      function()
        fh = io.popen("upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage|time to'")
        data = split(fh:read("*a"), "\n")
        data[1] = split(data[1], " ")
        data[2] = split(data[2], " ")
        data[3] = split(data[3], " ")
        state = data[1][#data[1]]
        percentage = data[3][#data[3]]
        percentage = percentage:gsub("%W", "")
        percentage = tonumber(percentage)
        percentage = round((percentage / 95) * 100)
        local text = ""
        local color
        local tooltip
        if state == "fully-charged" then
            tooltip = "Fully charged"
            color = "#AECF96"
            text = "<span color=\"lightgreen\">" .. percentage .. "%</span>"
        elseif state == "charging" then
            tooltip = "Charging: " .. data[2][4] .. " " .. data[2][5] .. " until full"
            color = "#B0E0E6"
            text = "<span color=\"lightblue\">⚡" .. percentage .. "%</span>"
        elseif percentage <= 10 then
            tooltip = data[2][4] .. " " .. data[2][5] .. " until empty"
            color = "#FF5656"
            text = "<span color=\"#FFBBBB\">Battery low: " .. percentage .. "%</span>"
        elseif percentage <= 25 then
            tooltip = data[2][4] .. " " .. data[2][5] .. " until empty"
            color = "#FFFF77"
            text = "<span color=\"#FFFF77\">" .. percentage .. "%</span>"
        else
            tooltip = data[2][4] .. " " .. data[2][5] .. " until empty"
            color = "#AECF96"
            text = percentage .. "%"
        end
        batteryWidget:set_markup(text)

        batteryWidgetTooltip:set_text(tooltip)

        fh:close()

        battery:set_color (color)
        battery:set_value (percentage/100)

        if percentage <= 10 and not(lowbattery) then
            lowbattery = true
            naughty.notify({ preset = {
                title = "Low battery",
                text = "Only " .. percentage .. "% left",
                timeout = 120
            } })
        elseif percentage > 10 then
            lowbattery = false
        end
      end
    )
    batteryWidgettimer:emit_signal("timeout")
    batteryWidgettimer:start()

    seperator = wibox.widget.textbox()
    seperator:set_text("  ")
    finalWidget:add(batteryWidget)
    finalWidget:add(seperator)
    margin = wibox.layout.margin(battery, 0, 0, 2, 1)
    finalWidget:add(margin)
    return finalWidget
end

