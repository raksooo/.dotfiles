battery = {}
battery.colors = {
    charging = "#2aa198",
    high = "#859900",
    low = "#b58900",
    critical = "#cb4b16",
    background = "#494B4F"
}
function battery.widget()
    batteryWidget = wibox.layout.fixed.horizontal()
    battery.text = wibox.widget.textbox()
    battery.tooltip = awful.tooltip ({ objects = { batteryWidget } })

    battery.battery = awful.widget.progressbar()
    battery.battery:set_vertical(true)
    battery.battery:set_width(7)
    battery.battery:set_background_color(battery.colors.background)

    tools.initInterval(battery.update, 15)

    batteryWidget:add(battery.text)
    batteryWidget:add(tools.spacing)
    batteryWidget:add(battery.battery)
    return batteryWidget
end

function battery.update()
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

        batteryNotification(percentage, timeleft, state)
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

    color = battery.colors.high
    tooltip = timeleft .. " until empty"
    if state == "fully-charged" then
        tooltip = "Fully charged"
    elseif state == "charging" then
        tooltip = "Charging: " .. timeleft .. " until full"
        color = battery.colors.charging
        text = "⚡"
    elseif percentage <= 10 then
        color = batter.colors.critical
        text = "Battery low: "
    elseif percentage <= 30 then
        color = battery.colors.low
    end

    text = "<span color=\"" .. color .. "\">" .. text .. percentage .. "%</span>"
    battery.text:set_markup(text)
    battery.tooltip:set_text("  " .. tooltip .. "  ")
    battery.battery:set_color(color)
    battery.battery:set_value(percentage/100)
end

local lowbattery = false
function batteryNotification(percentage, timeleft, state)
    if percentage <= 10 and not(lowbattery) and state ~= "charging" then
        lowbattery = true
        battery.notification = naughty.notify({ preset = {
            title = "Low battery",
            text = "Only " .. percentage .. "% (" .. timeleft .. ") left",
            timeout = 120
        } })
    elseif percentage > 10 or state == "charging" then
        lowbattery = false
        naughty.destroy(battery.notification,
            naughty.notificationClosedReason.dismissedByCommand)
    end
end

return battery

