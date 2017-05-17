local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local messenger = {
    unread = false
}
local options = {
    image = gears.filesystem.get_configuration_dir()
        .. "statusbar/messenger/icon_quantum.png",
    margin = 7,
    margin_top = 8,
    margin_right = 40
}

function messenger.create()
    messenger.widget = wibox.widget {
        {
            image = options.image,
            widget = wibox.widget.imagebox
        },
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
    if not messenger.unread then
        messenger.unread = true
        messenger.widget.forced_width = nil
        naughty.notify({ title = "Facebook Messenger",
                         text = "New message(s)",
                         icon = options.image,
                         icon_size = 90 })
    end
end

function messenger.opened()
    messenger.widget.forced_width = 0
    gears.timer.start_new(0.5, function()
        messenger.unread = false
        messenger.widget.forced_width = 0
    end)
end

return messenger

