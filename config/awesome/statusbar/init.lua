local wibox = require("wibox")
local awful = require("awful")

local battery = require("statusbar.battery")
local system = require("statusbar.system")
netctl = require("statusbar.netctl")
volume = require("statusbar.volume")
pacman = require("statusbar.pacman")

local statusbar = {}
textclock = {}

function statusbar.init(height)
    statusbar.height = height
    textclock = wibox.widget.textclock()
    statusbar.textclock = textclock

    statusbar.battery = battery.create()
    statusbar.system = system.create()
    statusbar.netctl = netctl.create()
    statusbar.volume = volume.create()
    statusbar.pacman = pacman.create()
end

function statusbar.new(s, placement, height)
    if statusbar.height == nil then
        statusbar.init(height)
    end

    local t1 = awful.tag.add("1", {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "master_width_factor",
        gap                = 50,
        screen             = s,
    })
    awful.tag.add("2", {
        layout             = awful.layout.layouts[1],
        --gap_single_client  = false,
        screen             = s,
    })
    awful.tag({ "3", "4", "5", "6" }, s, awful.layout.layouts[1])
    t1:view_only()

    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    s.mywibox = awful.wibar({ position = placement, screen = s, height = statusbar.height, bg = beautiful.bg_statusbar })

    s.mywibox:setup {
        layout = wibox.layout.flex.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist
        },
        {
            layout = wibox.layout.flex.horizontal,
            {
                align = "center",
                font = "DejaVu 11",
                widget = statusbar.textclock
            }
        },
        {
            layout = wibox.layout.align.horizontal,
            { layout = wibox.layout.fixed.horizontal },
            { layout = wibox.layout.fixed.horizontal },
            {
                layout = wibox.layout.fixed.horizontal,
                statusbar.pacman,
                statusbar.volume,
                statusbar.system,
                statusbar.battery,
                statusbar.netctl,
                wibox.widget.systray()
            }
        }
    }
end

return statusbar

