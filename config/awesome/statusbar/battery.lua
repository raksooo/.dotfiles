local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local battery = {}
local notification = {}
local options = {
    battery = "BAT0",
    interval = 10,
    width = 14,
    margin = 5,
    margin_right = 40,
    text = {
        text = "B:",
        opacity = 0.6,
        color = "#ffffff"
    },
    percentage = {
        high = 90,
        normal = 50,
        low = 15,
        critical = 0
    },
    color = {
        charging = "#7aa5e6",
        high = "#ddb76f",
        normal = "#83b879",
        low = "#ddb76f",
        critical = "#dd6880",
        background = "#00000000"
    }
}

function battery.create()
    battery.progressbar = createProgressbar()
    local widget = wrap(battery.progressbar.merged)
    awful.tooltip({
        objects = { widget },
        timer_function = function()
            return "B: " .. battery.percentage .. "\nC: " .. battery.current
        end,
    })

    battery.poll()
    gears.timer.start_new(options.interval, battery.poll)
    return wibox.widget {
        widget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin + 1,
        bottom   = options.margin,
        layout  = wibox.container.margin
    }
end

function wrap(widget)
    return wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            wibox.widget {
                markup = "<span color=\"" .. options.text.color .. "\">" .. options.text.text .. "</span>",
                opacity = options.text.opacity,
                font = options.text.font,
                widget = wibox.widget.textbox
            },
            right   = 6,
            top   = 2,
            layout  = wibox.container.margin
        },
        widget
    }
end

function createProgressbar()
    local batterybar = wibox.widget {
            max_value        = 1,
            background_color = options.color.background,
            widget           = wibox.widget.progressbar,
    }
    local currentbar = wibox.widget {
            max_value        = 1,
            background_color = options.color.background,
            widget           = wibox.widget.progressbar,
    }

    local merged = wibox.widget {
        {
            batterybar,
            direction     = 'east',
            forced_width  = options.width - 4,
            layout        = wibox.container.rotate
        },
        {
            currentbar,
            direction     = 'east',
            forced_width  = 4,
            layout        = wibox.container.rotate
        },
        layout = wibox.layout.fixed.horizontal
    }

    return { battery = batterybar, current = currentbar, merged = merged }
end

function battery.poll()
    local now = "/sys/class/power_supply/" .. options.battery .. "/charge_now"
    local full = "/sys/class/power_supply/" .. options.battery .. "/charge_full_design"
    local current = "/sys/class/power_supply/" .. options.battery .. "/current_now"
    local charging = "/sys/class/power_supply/AC/online"
    local cmd = "cat " .. now .." " .. full .. " " .. charging .. " " .. current
    awful.spawn.easy_async(cmd, update)
    return true
end

function update(stdout)
    local data = split(stdout, "\n")
    battery.percentage_raw = math.floor(tonumber(data[1]) * 100 / tonumber(data[2]))
    battery.percentage = tostring(battery.percentage_raw) .. "%"
    battery.charging = data[3] == "1"

    battery.progressbar.battery:set_value(battery.percentage_raw / 100)
    if not battery.charging then
        local current = (tonumber(data[4]) - 1000000) / 27500
        battery.current_raw = math.max(0, math.min(100, current))
        battery.current = math.floor(tostring(battery.current_raw)) .. "%"
        battery.progressbar.current:set_value(battery.current_raw / 100)
        battery.progressbar.current:set_color(options.color.low)
    else
        battery.progressbar.current:set_value(1)
        battery.progressbar.current:set_color(options.color.charging)
    end
    pickColor()

    notify()
end

function pickColor()
    local color
    if battery.charging then
        color = options.color.charging
    else
        if battery.percentage_raw >= options.percentage.high then
            color = options.color.high
        elseif battery.percentage_raw >= options.percentage.normal then
            color = options.color.normal
        elseif battery.percentage_raw >= options.percentage.low then
            color = options.color.low
        elseif battery.percentage_raw >= options.percentage.critical then
            color = options.color.critical
        end
    end
    battery.progressbar.battery:set_color(color)
end

function notify()
    if notification.notification ~= nil and battery.charging then
        naughty.destroy(notification.notification, naughty.notificationClosedReason.dismissedByCommmand)
        notification.notification = nil
    end
    if not battery.charging and battery.percentage_raw < options.percentage.low then
        local title = "Low battery! " .. battery.percentage
        local text = "Charge it!"
        if notification.notification == nil then
            notification.notification = naughty.notify({
                title = title,
                text = text,
                timeout = 0,
                destroy = function () notification.notification = nil end
            })
        else
            naughty.replace_text(notification.notification, title, text)
        end
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

return battery

