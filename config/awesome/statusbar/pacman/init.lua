local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local pacman = {}

function pacman.create(dotOpacity)
  local widget = wibox.widget {
    {
      awful.widget.watch("checkupdates", 180, pacman.update),
      opacity = dotOpacity,
      layout = wibox.layout.fixed.horizontal
    },
    {
      image = gears.filesystem.get_configuration_dir()
        .. "statusbar/pacman/pacman.png",
      widget = wibox.widget.imagebox
    },
    layout = wibox.layout.fixed.horizontal,
  }

  awful.tooltip({
    objects = { widget },
    timer_function = function() return pacman.tooltip end,
  })

  return widget
end

function pacman.update(widget, stdout)
  lines = #split(stdout, "\n")
  dots = ""
  for i = 1, math.min(lines, 55) do
    dots = dots .. ((i-1) % 20 == 0 and "⚫" or "•")
  end
  widget:set_markup(dots)

  local tooltip = stdout:gsub("^%s*(.-)%s*$", "%1")
  pacman.tooltip = "Updates: " .. lines .. "\n\n" .. tooltip
end

return pacman

