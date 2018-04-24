local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local battery = require("statusbar.battery")
netctl = require("statusbar.netctl")
volume = require("statusbar.volume")
pacman = require("statusbar.pacman")
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
      },
      { right = 40, top = 1 })

    statusbar.volume = margin(volume.create(), { top = 8, bottom = 6, left = 40, right = 40 })
    statusbar.netctl = margin(netctl.create(), { top = 8, bottom = 6, right = 40 })
    statusbar.battery = margin(battery.create(), { top = 10, bottom = 8, right = 40 })
    statusbar.messenger = messenger.create()
end

function statusbar.new(s)
    if statusbar.clock == nil then
      statusbar.init()
    end

    local geometry = awful.screen.focused().geometry

    if false then
    local left = wibox {
      x = 70,
      height = 40,
      width = 380,
      bg = "#00000000",
      type = "dock",
      ontop = true
    }
    left:setup {
      widget = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    }

    tag.connect_signal("property::selected", function(t) 
      if t.selected then
        left.visible = true
        gears.timer.start_new(1, function() left.visible = false end)
      end
    end)
    end

    local rwidth = 344
    local right = wibox {
      x = geometry.width - rwidth - 100,
      height = 40,
      width = rwidth,
      visible = true,
      bg = "#00000000",
      type = "dock",
    }
    right:setup {
        layout = wibox.layout.fixed.horizontal,
        statusbar.volume,
        statusbar.netctl,
        statusbar.battery,
        --statusbar.messenger,
        statusbar.clock
    }

    local hover = wibox {
      x = geometry.width - rwidth - 100,
      y = 0,
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
      end
    end)
end

return statusbar

