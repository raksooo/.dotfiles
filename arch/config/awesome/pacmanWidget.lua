local wibox = require("wibox")
local awful = require("awful")

function pacmanWidget()
    local data
    pacmanWidget = wibox.widget.textbox()
    pacmanWidgetTimer = timer({ timeout = 900 })
    pacmanWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("checkupdates")
        data = split(fh:read("*a"), "\n")
        text = #data
        pacmanWidget:set_markup("pacman:  " .. text)
        fh:close()
      end
    )
    pacmanWidgetTimer:emit_signal("timeout")
    pacmanWidgetTimer:start()
    return pacmanWidget
end

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

