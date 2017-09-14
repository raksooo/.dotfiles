local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local timeout = 7
naughty.config.defaults.timeout = timeout
naughty.config.presets.low.timeout = timeout
naughty.config.presets.info.timeout = timeout

local notificationQueue = {}

function createImagebox(image, size)
  local image_bg = beautiful.transparent
  if image ~= nil then
    image_bg = beautiful.notification_bg
  end

  return {
    {
      {
        image = image,
        forced_height = size,
        forced_width = size,
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
          layout = wibox.layout.flex.vertical
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

function fixNotification(notification, args)
  local widget = wibox.widget {
    {
      createImagebox(args.icon, args.icon_size),
      createTextboxes(args.title, args.text),
      layout = wibox.layout.fixed.horizontal
    },
    top = beautiful.notification_margin,
    right = beautiful.notification_margin,
    layout = wibox.container.margin
  }

  widget:buttons(gears.table.join(
    widget:buttons(),
    awful.button({}, 1,
      function()
        notification.die(naughty.notificationClosedReason.dismissedByUser)
      end)
  ))

  notification.box.border_width = beautiful.notification_border_width
  notification.box.opacity = 1
  notification.box.bg = beautiful.transparent
  notification.box:set_widget(widget)
end

function checkNotifications()
  local allNotifications = naughty.notifications[awful.screen.focused()]
  local notifications = awful.util.table.join(
    allNotifications["top_right"],
    allNotifications["bottom_right"]
  )
  for _, notification in pairs(notifications) do
    if not notification.opacity then
      local args = table.remove(notificationQueue, 1)
      fixNotification(notification, args)
    end
  end
end

naughty.config.notify_callback = function(args)
  table.insert(notificationQueue, args)
  gears.timer.start_new(0, checkNotifications)
  return args
end

