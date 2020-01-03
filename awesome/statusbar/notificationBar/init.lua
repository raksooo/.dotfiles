local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local timeout = 10
naughty.config.defaults.timeout = timeout
naughty.config.presets.low.timeout = timeout
naughty.config.presets.info.timeout = timeout

function naughty.replace_text(notification, new_title, new_text)
  local new = getNewByOld(notification)
  local markup = (new_title or "") .. (new_text and " - <i>" .. new_text .. "</i>" or "")
  new.textbox:set_markup_silently(markup)
end

local notificationBar = {
  notificationQueue = {},
  notifications = {}
}

function notificationBar.create()
    notificationBar.widget = wibox.widget {
      layout = wibox.layout.fixed.horizontal
    }

    return notificationBar.widget
end

function createNotification(i, args)
  local textbox = wibox.widget {
    widget = wibox.widget.textbox,
    markup = (args.title or "") .. (args.text and " - <i>" .. args.text .. "</i>" or ""),
  }

  local notification = wibox.widget {
    {
      {
        {
          image = args.icon or gears.filesystem.get_configuration_dir()
                    .. "statusbar/notificationBar/icon.png",
          widget = wibox.widget.imagebox
        },
        top = 8,
        bottom = 8,
        right = 16,
        layout = wibox.container.margin
      },
      textbox,
      layout = wibox.layout.fixed.horizontal
    },
    left = 40,
    right = 40,
    layout = wibox.container.margin
  }

  notification:buttons(gears.table.join(
    awful.button({ }, 1, function()
      naughty.destroy(notificationBar.notifications[i].notification,
        naughty.notificationClosedReason.dismissedByUser)
    end)
  ))

  return { notification = notification, textbox = textbox }
end

function removeNotification(i)
  notificationBar.widget:remove_widgets(notificationBar.notifications[i].bar.notification)
  --table.remove(notificationBar.notifications, i)
end

function removeById(id)
  for k, v in ipairs(notificationBar.notifications) do
    if v.notification.id == id then
      removeNotification(k)
    end
  end
end

function getNewByOld(notification)
  for k, v in ipairs(notificationBar.notifications) do
    if v.notification == notification then
      return v.bar
    end
  end
end

function fixNotification(notification, args)
  notification.handled = true

  local new = createNotification(args.i, args.args)
  notificationBar.widget:add(new.notification)

  notificationBar.notifications[args.i] = {
    bar = new,
    notification = notification,
    args = args.args
  }
end

function handleNotifications()
  local notifications = naughty.notifications[awful.screen.focused()]["top_right"]
  for _, notification in pairs(notifications) do
    if not notification.handled then
      local args = table.remove(notificationBar.notificationQueue, 1)
      fixNotification(notification, args)
    end
  end
end

naughty.config.notify_callback = function(args)
  if args.replaces_id ~= nil then
    removeById(args.replaces_id)
  end

  local i = #notificationBar.notifications + 1
  table.insert(notificationBar.notificationQueue, {
    i = i,
    args = args
  })
  gears.timer.start_new(0, handleNotifications)

  local prev = args.destroy
  args.destroy = function()
    if prev ~= nil then prev() end
    removeNotification(i)
  end

  return args
end

return notificationBar

