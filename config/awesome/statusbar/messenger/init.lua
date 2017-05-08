local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local messenger = {}
local options = {
    image = gears.filesystem.get_configuration_dir()
        .. "statusbar/messenger/icon_quantum.png",
    margin = 7,
    margin_top = 8,
    margin_right = 40
}

function messenger.create()
    local widget = wibox.widget {
        image = options.image,
        widget = wibox.widget.imagebox
    }

    messenger.widget = wibox.widget {
        widget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin_top,
        bottom   = options.margin,
        layout  = wibox.container.margin,
        forced_width = 0
    }

    return messenger.widget
end

function messenger.titleChange()
    messenger.widget.forced_width = nil
    if messenger.timer ~= nil then
        messenger.timer:stop()
    end
    messenger.timer = gears.timer.start_new(5, function()
        messenger.widget.forced_width = 0
    end)
end

return messenger

