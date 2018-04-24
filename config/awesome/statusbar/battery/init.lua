local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local battery = {}
local notification = {}
local options = {
    battery = "BAT0",
    interval = 10,
    width = 35,
    percentage = {
        high = 90,
        normal = 50,
        low = 15,
        critical = 0
    },
    color = {
        charging = "#7aa5e6",
        high = "#83b879",
        normal = "#83b879",
        low = "#ddb76f",
        critical = "#dd6880",
        background = "#00000000"
    }
}

function battery.create()
    battery.progressbar = createProgressbar()
    awful.tooltip({
        objects = { battery.progressbar },
        timer_function = function()
            return battery.percentage
        end,
    })

    battery.poll()
    gears.timer.start_new(options.interval, battery.poll)

    return wibox.widget {
      battery.progressbar,
      {
        {
          wibox.widget { forced_width = 3 },
          bg = "#ffffff66",
          layout = wibox.container.background
        },
        top = 6,
        bottom = 6,
        layout = wibox.container.margin
      },
      layout = wibox.layout.fixed.horizontal
    }
end

function createProgressbar()
    return wibox.widget {
      max_value        = 1,
      background_color = options.color.background,
      widget           = wibox.widget.progressbar,
      forced_width     = options.width,
      paddings         = 3,
      border_width     = 2,
      border_color     = "#ffffff66"
    }
end

function battery.poll()
    local now = "/sys/class/power_supply/" .. options.battery .. "/charge_now"
    local full = "/sys/class/power_supply/" .. options.battery .. "/charge_full_design"
    local charging = "/sys/class/power_supply/AC/online"
    local cmd = "cat " .. now .." " .. full .. " " .. charging
    awful.spawn.easy_async(cmd, update)
    return true
end

function update(stdout)
    local data = split(stdout, "\n")
    battery.percentage_raw = math.floor(tonumber(data[1]) * 100 / tonumber(data[2]))
    battery.percentage = tostring(battery.percentage_raw) .. "%"
    battery.charging = data[3] == "1"

    battery.progressbar:set_value(battery.percentage_raw / 100)
    pickColor()

    notify()
end

function pickColor()
    local color
    if battery.charging then
        color = options.color.charging
    elseif battery.percentage_raw >= options.percentage.high then
        color = options.color.high
    elseif battery.percentage_raw >= options.percentage.normal then
        color = options.color.normal
    elseif battery.percentage_raw >= options.percentage.low then
        color = options.color.low
    elseif battery.percentage_raw >= options.percentage.critical then
        color = options.color.critical
    end
    battery.progressbar:set_color(color)
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
                icon =  gears.filesystem.get_configuration_dir()
                    .. "statusbar/battery/lowbattery.png",
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

