local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local battery = require("statusbar/battery")
local system = require("statusbar/system")
volume = require("statusbar/volume")
pacman = require("statusbar/pacman/pacman")

beautiful.init("/home/oskar/.config/awesome/theme.lua")

local statusbar = {}

function statusbar.init(height)
    statusbar.height = height
    statusbar.textclock = wibox.widget.textclock()
    statusbar.taglist_buttons = awful.util.table.join( awful.button({ }, 1, function(t) t:view_only() end) )

    statusbar.battery = battery.create()
    statusbar.system = system.create()
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
        gap_single_client  = true,
        gap                = 50,
        screen             = s,
    })
    awful.tag({ "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
    t1:view_only()

    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, statusbar.taglist_buttons)
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
                wibox.widget.systray()
            }
        }
    }
end

return statusbar

