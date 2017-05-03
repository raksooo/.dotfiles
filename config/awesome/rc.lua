local awful = require("awful")
require("awful.autofocus")
beautiful = require("beautiful")
local gears = require("gears")
naughty = require("naughty")
local statusbar = require("statusbar")
local wallpaper = require("wallpaper")
local keys = require("keys")
local warnings = require("errorHandling")
local rules = require("rules")

terminal = "urxvt"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating
}

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
wallpaper.init(beautiful.wallpaper)

awful.screen.connect_for_each_screen(function(s)
    statusbar.new(s, "bottom", 35)
end)

