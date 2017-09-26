local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
naughty = require("naughty")
beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local warnings = require("errorHandling")
local statusbar = require("statusbar")
--local wallpaper = require("wallpaper")
local keys = require("keys")
local rules = require("rules")
local notifications = require("notifications")

terminal = "urxvt"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating
}

awful.screen.connect_for_each_screen(function(s)
    statusbar.new(s, "bottom", 35)
    gears.wallpaper.fit(beautiful.wallpaper, s)
end)

