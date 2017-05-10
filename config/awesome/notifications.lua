local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

function fixNotification(notification, image)
    local image_bg = beautiful.notification_bg
    if image ~= nil then
        image_bg = beautiful.notification_inner_bg
    end

    local widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            {
                image = image,
                forced_width = beautiful.notification_height,
                widget = wibox.widget.imagebox
            },
            bg = image_bg,
            layout = wibox.container.background
        },
        {
            {
                {
                    {
                        widget = notification.textbox,
                        font = beautiful.base_font .. " 12",
                        forced_width = 1000,
                    },
                    left = beautiful.notification_margin,
                    right = beautiful.notification_margin,
                    top = 20,
                    bottom = 20,
                    layout = wibox.container.margin
                },
                bg = beautiful.notification_inner_bg,
                layout = wibox.container.background
            },
            left = beautiful.notification_margin,
            layout = wibox.container.margin
        },
    }

    notification.box.border_width = beautiful.notification_border_width
    notification.box.type = "dock" -- To prevent shaddow
    notification.box:set_widget(widget)
    notification.fixed = true
end

function checkNotifications(image)
    local notifications = naughty.notifications[awful.screen.focused()]["top_right"]
    for _, notification in pairs(notifications) do
        if not notification.fixed then
            fixNotification(notification, image)
        end
    end
end

naughty.config.notify_callback = function(args)
    gears.timer.start_new(0, function()
        checkNotifications(args.icon)
    end)
    args.text = "\n" .. args.text
    return args
end

