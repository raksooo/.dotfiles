local awful = require("awful")
local gears = require("gears")
local poppin = require("poppin")
local awffvim = require("awffvim")

local notifyclass = false

function isTerminal(c)
  return c.class ~= nil and c.class:lower() == terminal
end

function changeOpacity(c, opacity)
  if isTerminal(c) then
    c.opacity = 0.9 * opacity
  elseif c.class ~= "mpv" then
    c.opacity = opacity
  end
end

function messengerCallback(c)
  awful.client.setslave(c)
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
  { rule = { class = "Termite" },
    properties = {
      size_hints_honor = false,
      border_width = 30 } },
  { rule = { class = "mpv" },
    properties = {
      floating = true,
      width = 1920,
      height = 1080,
      opacity = 1 } },
  { rule = { class = "Firefox" },
    properties = { tags = { tagnames[4], tagnames[5] } },
    callback = awffvim.run },
  { rule = { class = "Chromium" },
    properties = { tag = tagnames[6] } },
  { rule = { class = "Spotify" },
    properties = {
      tag = tagnames[8],
      floating = true,
      fullscreen = true,
      keys = awful.util.table.join( clientkeys,
          awful.key( { "Mod4", "Shift" }, "c", function (c)
            c:kill()
            awful.spawn("killall spotify")
          end)
        ) } },
  { rule = { class = "Messenger for Desktop" },
    properties = { tag = tagnames[7] },
    callback = messengerCallback },
  { rule = { class = "Slack" },
    properties = { tag = tagnames[7] } },
  { rule = { class = "brunocast-client" },
    properties = { floating = true,
                   width = 1410,
                   height = 575 } },
  { rule = { class = "Zathura" },
    callback = awful.client.setslave },
  { rule = { class = "Pinentry" },
    properties = { floating = true } }
  }

  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c)
    if notifyclass then
      naughty.notify({ title = "Class of new window", text = c.class })
    end

    if c.class == nil then
      c.minimized = true
      c:connect_signal("property::class", function ()
        c.minimized = false
        awful.rules.apply(c)
      end)
    end

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
  end)

  client.connect_signal("unfocus", function(c)
    changeOpacity(c, beautiful.opacity_normal)
  end)

  client.connect_signal("property::fullscreen", function(c)
    awful.placement.no_offscreen(c)
  end)

