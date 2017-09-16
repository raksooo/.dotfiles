local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local messenger = {
  unread = nil,
  timer = nil
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

function messenger.titleChange(c)
  local unread = tonumber(c.name:match("%d"))
  if unread ~= nil then
    if messenger.timer ~= nil then
      messenger.timer:stop()
      messenger.timer = nil
    end
    if messenger.unread == nil or messenger.unread < unread then
      messenger.unread = unread
      messenger.widget.forced_width = nil

      local text = unread .. " new message"
      if unread > 1 then
        text = text .. "s"
      end
      naughty.notify({ title = "Facebook Messenger",
        text = text,
        icon = options.image,
        timout = 0,
        icon_size = 90
      })
    end
  elseif unread == nil and messenger.timer == nil then
    messenger.timer = gears.timer.start_new(4, function ()
      messenger.widget.forced_width = 0
      messenger.unread = nil
      messenger.timer = nil
    end)
  end
end

return messenger

