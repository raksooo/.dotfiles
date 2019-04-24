local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
local modes = require("awffvim.modes")

local awffvim = {}

function awffvim.run(c)
  --setKeys(c, modes.normal())
end

function setKeys(c, keys)
  return c:keys(awful.util.table.join(clientkeys, unpack(keys)))
end

function continue()
  local grabber
  c:connect_signal("focus", function()
    grabber = awful.keygrabber.run(function(mod, key, event)
      if event == "release" then return end
      if key == "i" then awful.keygrabber.stop(grabber) end
    end)
  end)

  c:connect_signal("unfocus", function()
  end)
end

function doAction(actions, mode)
  return function(c)
    if actions ~= nil then
      local actionlist
      if type(actions) == "string" then
        actionlist = { actions }
      else
        actionlist = actions
      end

      local keys = c:keys()
      setKeys(c, {})
      for i,v in ipairs(actionlist) do
        gears.timer.start_new(0.07*i, function ()
          awful.spawn.easy_async('xdotool key --clearmodifiers "' .. v .. '" &', function() end)
          if i == #actionlist then
            if mode ~= nil then
              setKeys(c, mode())
            else
              c:keys(keys)
            end
          end
        end)
      end
    elseif mode ~= nil then
      setKeys(c, mode())
    end
  end
end

function joinActions(actions)
  if type(actions) == "string" then return '"' .. actions .. '"' end

  local joined = '"'
  for k,a in ipairs(actions) do
    joined = joined .. a .. '" '
  end
  return joined
end

return awffvim

