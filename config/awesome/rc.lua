local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
local wibox = require("wibox")
naughty = require("naughty")
beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

lock = require("lock")

local warnings = require("errorHandling")

tagnames = { "1", "2", "3", "4", "5", "6", "7", "8" }

local statusbar = require("statusbar")
local keys = require("keys")
local rules = require("rules")
--local notifications = require("notifications")

terminal = "termite"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating
}

local function createTags(s)
    local selected = awful.tag.add(tagnames[1], {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "master_width_factor",
        gap                = 50,
        screen             = s,
    })
    awful.tag.add(tagnames[2], {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "master_width_factor",
        gap                = 50,
        screen             = s,
    })
    awful.tag({ tagnames[3], tagnames[4], tagnames[5] }, s, awful.layout.layouts[1])
    awful.tag.add(tagnames[6], {
        layout             = awful.layout.layouts[2],
        gap                 = 50,
        screen             = s,
    })
    awful.tag.add(tagnames[7], {
        layout              = awful.layout.layouts[1],
        master_fill_policy  = "master_width_factor",
        gap                 = 50,
        screen              = s,
    })
    awful.tag.add(tagnames[8], {
        screen              = s,
    })

    selected:view_only()
end

local gray = wibox {
  height = 1800,
  width = 3200,
  visible = true,
  bg = "#212121",
  ontop = false,
  opacity = 1,
}

tag.connect_signal("property::selected", function(t) 
  if t.selected then
    if t.index == 1 then
      gray.opacity = 1
    else
      gray.opacity = 0
    end
  end
end)

awful.screen.connect_for_each_screen(function(s)
    createTags(s)
    statusbar.new(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s)
end)

