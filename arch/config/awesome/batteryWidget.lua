local wibox = require("wibox")
local naughty = require("naughty")

lowbattery = false

function batterywidget()
    batterywidget = wibox.widget.textbox()
    batterywidgettimer = timer({ timeout = 20 })
    batterywidgettimer:connect_signal("timeout",
      function()
        fh = io.popen("upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage'")
        data = split(fh:read("*a"), "\n")
        data[1] = split(data[1], " ")
        data[2] = split(data[2], " ")
        state = data[1][#data[1]]
        percentage = data[2][#data[2]]
        percentage = percentage:gsub("%W", "")
        percentage = tonumber(percentage)
        percentage = round((percentage / 95) * 100)
        local text = ""
        if state == "fully-charged" then
            text = "<span color=\"lightgreen\">" .. percentage .. "%</span>"
        elseif state == "charging" then
            text = "<span color=\"lightblue\">⚡" .. percentage .. "%</span>"
        elseif percentage <= 10 then
            text = "<span color=\"#FFBBBB\">Battery low: " .. percentage .. "%</span>"
        elseif percentage <= 25 then
            text = "<span color=\"#FFFF77\">" .. percentage .. "%</span>"
        else
            text = percentage .. "%"
        end
        batterywidget:set_markup(text)
        fh:close()

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
    batterywidgettimer:emit_signal("timeout")
    batterywidgettimer:start()
    return batterywidget
end

