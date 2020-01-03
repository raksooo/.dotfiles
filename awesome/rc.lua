local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
local wibox = require("wibox")
naughty = require("naughty")
beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local warnings = require("errorHandling")

tagnames = { "1", "2", "3", "4", "5", "6" }

local statusbar = require("statusbar")
local keys = require("keys")
local rules = require("rules")

terminal = "termite"

awful.layout.layouts = {
    awful.layout.suit.tile,
}

local defaultTag = {
    layout             = awful.layout.layouts[1],
    master_fill_policy = "master_width_factor",
    --gap                = 50,
    screen             = s,
}

local function copy(t)
  local t2 = {}
  for k,v in pairs(t) do t2[k] = v end
  return t2
end

local function createTags(s)
    local selected = awful.tag.add(tagnames[1], copy(defaultTag))
    awful.tag.add(tagnames[2], copy(defaultTag))
    awful.tag({ tagnames[3], tagnames[4], tagnames[5], tagnames[6] }, s, awful.layout.layouts[1])
    awful.tag.add(tagnames[7], copy(defaultTag))
    awful.tag.add(tagnames[8], { screen = s })

    selected:view_only()
end

awful.screen.connect_for_each_screen(function(s)
    createTags(s)
    statusbar.new(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s)
end)

