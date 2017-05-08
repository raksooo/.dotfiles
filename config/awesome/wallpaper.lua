local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local geometry = awful.screen.focused().geometry
local wallpaper = {
    widgets = {},
    wibox = wibox {
        x = 0,
        y = 0,
        width = geometry.width,
        height = geometry.height,
        visible = true,
    }
}

function wallpaper.set(i)
    wallpaper.wibox:setup {
        layout = wibox.layout.fixed.horizontal,
        wallpaper.widgets[i]
    }
end

function createWidgets(wallpaper_fn)
    local screen = awful.screen.focused()
    for i, v in pairs(screen.tags) do
        wallpaper.widgets[i] = wibox.widget {
            image = wallpaper_fn(i),
            widget = wibox.widget.imagebox
        }
    end
end

function init_()
    local wp = beautiful.wallpaper
    local screen = awful.screen.focused()

    createWidgets(wp)

    wallpaper.set(1)
    awful.tag.attached_connect_signal(screen, "property::selected", function()
        if screen.selected_tag ~= nil then
            wallpaper.set(screen.selected_tag.index)
        end
    end)
end

function init()
    if awesome.startup then
        awesome.connect_signal("startup", init_)
    else
        init_()
    end
end

init()
return wallpaper

