local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

function createImagebox(image)
    local image_bg = beautiful.transparent
    if image ~= nil then
        image_bg = beautiful.notification_bg
    end

    return {
        {
            {
                image = image,
                widget = wibox.widget.imagebox
            },
            halign = "center",
            valign = "center",
            forced_width = beautiful.notification_height,
            forced_height = beautiful.notification_height,
            layout = wibox.container.place
        },
        bg = image_bg,
        layout = wibox.container.background
    }
end

function createTextboxes(title, text)
    return {
        {
            {
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            markup = "<b>" .. title .. "</b>",
                            font = beautiful.notification_font,
                        },
                        bottom = 20,
                        layout = wibox.container.margin
                    },
                    {
                        widget = wibox.widget.textbox,
                        text = text,
                        font = beautiful.notification_font,
                    },
                    layout = wibox.layout.fixed.vertical
                },
                left = beautiful.notification_margin,
                right = beautiful.notification_margin,
                top = 25,
                bottom = 25,
                layout = wibox.container.margin
            },
            forced_width = 1000,
            bg = beautiful.notification_bg,
            layout = wibox.container.background
        },
        left = beautiful.notification_margin,
        layout = wibox.container.margin
    }
end

function fixNotification(notification, title, text, image)
    local widget = wibox.widget {
        {
            createImagebox(image),
            createTextboxes(title, text),
            layout = wibox.layout.fixed.horizontal
        },
        top = beautiful.notification_margin,
        right = beautiful.notification_margin,
        layout = wibox.container.margin
    }

    notification.box.border_width = beautiful.notification_border_width
    notification.box.opacity = 1
    notification.box.bg = beautiful.transparent
    notification.box:set_widget(widget)
end

function checkNotifications(title, text, image)
    local allNotifications = naughty.notifications[awful.screen.focused()]
    local notifications = awful.util.table.join(
        allNotifications["top_right"],
        allNotifications["bottom_right"]
    )
    for _, notification in pairs(notifications) do
        if not notification.opacity then
            fixNotification(notification, title, text, image)
        end
    end
end

naughty.config.notify_callback = function(args)
    gears.timer.start_new(0, function()
        checkNotifications(args.title, args.text, args.icon)
    end)
    return args
end

