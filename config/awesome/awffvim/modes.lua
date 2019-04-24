local naughty = require("naughty")
local awful = require("awful")

local super = "Mod4"
local alt = "Mod1"
local control = "Control"
local shift = "Shift"

local modes = { }

function modes.normal()
  return {
    awful.key({ }, "i", doAction(nil, modes.insert)),
    awful.key({ }, "j", doAction("Down")),
    awful.key({ }, "k", doAction("Up")),
    awful.key({ }, "h", doAction("Left")),
    awful.key({ }, "l", doAction("Right")),
    awful.key({ }, "d", doAction("ctrl+w")),
    awful.key({ }, "r", doAction("ctrl+r")),
    awful.key({ shift }, "h", doAction("alt+Left")),
    awful.key({ shift }, "l", doAction("alt+Right")),
    awful.key({ shift }, "r", doAction("ctrl+shift+r")),
    awful.key({ shift }, "j", doAction("ctrl+Tab")),
    awful.key({ shift }, "k", doAction("ctrl+shift+Tab")),
    awful.key({ }, "o", doAction("ctrl+l", modes.open)),
    awful.key({ control }, "l", doAction("ctrl+l", modes.open)),
    awful.key({ shift }, "o", doAction("ctrl+t", modes.openNew)),
    awful.key({ control }, "t", doAction("ctrl+t", modes.openNew)),
    awful.key({ }, "p", doAction({ "ctrl+l", "ctrl+v", "Return" })),
    awful.key({ shift }, "p", doAction({ "ctrl+t", "ctrl+v", "Return" })),
  }
end

function modes.insert()
  return {
    awful.key({ }, "Escape", doAction("Tab", modes.normal))
  }
end

function modes.open()
  return {
    -- TODO
    awful.key({ }, "Escape", doAction({ "Escape", "Escape", "Escape", "Tab" }, modes.normal)),
    awful.key({ }, "Return", doAction("Return", modes.normal))
  }
end

function modes.openNew()
  return {
    awful.key({ }, "Escape", doAction("ctrl+w", modes.normal)),
    awful.key({ }, "Return", doAction("Return", modes.normal))
  }
end

return modes

