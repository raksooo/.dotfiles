local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local battery = require("statusbar.battery")
local notificationBar = require("statusbar.notificationBar")
connectivity = require("statusbar.connectivity")
volume = require("statusbar.volume")
messenger = require("statusbar.messenger")

statusbar = {}

function margin(widget, margins)
  local w = {
    widget,
    layout = wibox.container.margin
  }
  return wibox.widget (gears.table.join(w, margins))
end

function statusbar.init()
    statusbar.textclock = wibox.widget.textclock("%H:%M")
    statusbar.clock = margin({
        font = "Helvetica Thin 11",
        widget = statusbar.textclock
      }, { right = 40, top = 7 })

    statusbar.volume = margin(volume.create(), { top = 8, bottom = 6, left = 40, right = 40 })
    statusbar.connectivity = margin(connectivity.create(), { top = 8, bottom = 6, right = 40 })
    statusbar.battery = margin(battery.create(), { top = 10, bottom = 8, right = 40 })
    statusbar.notificationBar = notificationBar.create()
end

function statusbar.new(s)
    if statusbar.clock == nil then
      statusbar.init()
    end

    local geometry = awful.screen.focused().geometry
    local rwidth = 344

    local left = wibox {
      x = 100,
      height = 40,
      width = geometry.width * 0.6,
      visible = true,
      bg = beautiful.transparent,
      type = "dock"
    }
    left:setup {
      layout = wibox.layout.fixed.horizontal,
      statusbar.notificationBar
    }

    local right = wibox {
      x = geometry.width - rwidth - 100,
      height = 40,
      width = rwidth,
      visible = true,
      bg = beautiful.transparent,
      type = "dock",
    }
    right:setup {
        layout = wibox.layout.fixed.horizontal,
        statusbar.volume,
        statusbar.connectivity,
        statusbar.battery,
        statusbar.clock
    }

    local hover = wibox {
      x = geometry.width - rwidth - 100,
      height = 3,
      width = rwidth,
      visible = true,
      bg = "#ffffff66",
      type = "dock",
    }

    tag.connect_signal("property::selected", function(t)
      if t.selected then
        right.x = geometry.width - rwidth - 2 * t.gap
        hover.x = geometry.width - rwidth - 2 * t.gap
        left.x = 2 * t.gap
      end
    end)
end

return statusbar

