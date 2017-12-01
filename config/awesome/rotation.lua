local awful = require("awful")
local naughty = require("naughty")

local rotation = { }

function init()
  rotation.inited = true
  for _, tag in pairs(root.tags()) do
    tag:connect_signal("property::selected", function()
      local r = tag.rotation or "normal"
      if not tag.selected then
        rotation.previousRotation = r
      elseif r ~= rotation.previousRotation then
        rotation.rotate(r)
      end
    end)
  end
end

function rotation.rotate(rotationString)
  if not rotation.inited then init() end

  awful.screen.focused().selected_tag.rotation = rotationString
  awful.spawn("rotate_desktop " .. rotationString)
end

return rotation

