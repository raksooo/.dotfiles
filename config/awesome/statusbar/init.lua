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
      { right = 20, top = 1 })

    statusbar.battery = battery.create()
    statusbar.netctl = netctl.create()
    statusbar.volume = volume.create()
    statusbar.messenger = messenger.create()
end

function statusbar.new(s)
    if statusbar.clock == nil then
      statusbar.init()
    end

    local left = wibox {
      x = 70,
      y = -35,
      height = 50,
      width = 380,
      visible = true,
      bg = "#00000000",
      type = "dock",
      ontop = true
    }
    left:setup {
      widget = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    }
    left:connect_signal("mouse::enter", function() left:geometry({ y = 20 }) end)
    left:connect_signal("mouse::leave", function() left:geometry({ y = -35 }) end)

    local geometry = awful.screen.focused().geometry
    rwidth = 350
    local right = wibox {
      x = geometry.width - rwidth - 100,
      y = 20,
      height = 50,
      width = rwidth,
      visible = true,
      bg = "#00000000",
      type = "dock",
      ontop = true
    }

    local right_content = {
        layout = wibox.layout.fixed.horizontal,
        statusbar.volume,
        statusbar.battery,
        statusbar.netctl,
        statusbar.messenger,
        statusbar.clock
    }

    --local children = right:get_children()
    --for k, v in ipairs(right_content[1]) do
      --naughty.notify({ title = k, text = type(v) })
    --end

    right:setup {
      margin(right_content, { bottom = 10 }),
      bottom = 3,
      color = "#dddddd",
      widget = wibox.container.margin
    }

    tag.connect_signal("property::selected", function(t) 
      right.x = geometry.width - rwidth - (t.gap * 2)
      if t.gap > 20 then
        right.y = 20
        right.widget.bottom = 3
      else
        right.y = 0
        right.widget.bottom = 0
      end
    end)
end

return statusbar

