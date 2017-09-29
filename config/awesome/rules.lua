local awful = require("awful")
local gears = require("gears")
local poppin = require("poppin")

local notifyclass = false

function isTerminal(c)
  return c.class ~= nil and c.class:lower() == terminal
end

function floatingToggled(c, manage)
  if beautiful.border_color_floating ~= nil then
    if c.floating then
      c.border_width = c.border_width_floating or beautiful.border_width_floating
      c.border_color = beautiful.border_color_floating
      awful.placement.no_offscreen(c)
    elseif not manage or not isTerminal(c) then
      c.border_width = beautiful.border_width
      c.border_color = beautiful.border_normal
    end
  end
end

function changeOpacity(c, opacity)
  if isTerminal(c) then
    c.opacity = 0.9 * opacity
  elseif c.class ~= "mpv" then
    c.opacity = opacity
  end
end

function changeBorder(c, border_properties)
  if not c.floating then
    for k, v in pairs(border_properties) do
      c[k] = v
    end
  end
end

function messengerCallback(c)
  c:connect_signal("property::name", messenger.titleChange)
  gears.timer.start_new(0.2, function ()
    awful.key.execute({ "Control", "Mod1" }, "b")
  end)
end

awful.rules.rules = {
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen } },
  { rule = { class = "URxvt" },
    properties = {
      size_hints_honor = false,
      border_width = 14 } },
  { rule = {
    class = "URxvt",
    name = "qutebrowser"
  },
    properties = { floating = true } },
  { rule = { class = "mpv" },
    properties = {
      floating = true,
      width = 1920,
      height = 1080,
      opacity = 1 } },
  { rule = { class = "qutebrowser" },
    properties = { tag = "4" } },
  { rule = { class = "Chromium" },
    properties = { tag = "5" } },
  { rule = { class = "Spotify" },
    properties = {
      tag = "6",
      floating = true,
      fullscreen = true,
      keys = awful.util.table.join( clientkeys,
          awful.key( { "Mod4", "Shift" }, "c", function (c)
            c:kill()
            awful.spawn("killall spotify")
          end)
        ) } },
  { rule = { class = "Messenger for Desktop" },
    callback = messengerCallback },
  { rule = { class = "Pinentry" },
    properties = { floating = true } }
  }

  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c)
    if notifyclass then
      naughty.notify({ title = "Class of new window", text = c.class })
    end

    if c.class == nil then
      c:connect_signal("property::class", awful.rules.apply)
    end

    floatingToggled(c, true)

    if c.floating and not poppin.isPoppin(c) then
      awful.placement.centered(c)
    end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end)

  client.connect_signal("focus", function(c)
    changeOpacity(c, beautiful.opacity_focus)
    changeBorder(c, { border_color = beautiful.border_focus })
  end)

  client.connect_signal("unfocus", function(c)
    changeOpacity(c, beautiful.opacity_normal)
    changeBorder(c, { border_color = beautiful.border_normal })
  end)

  client.connect_signal("property::floating", floatingToggled)

  client.connect_signal("property::fullscreen", function(c)
    awful.placement.no_offscreen(c)
  end)

