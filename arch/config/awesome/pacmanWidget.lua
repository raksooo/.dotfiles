local wibox = require("wibox")
local awful = require("awful")

function pacmanWidget()
    local data
    pacmanWidget = wibox.widget.textbox()
    pacmanWidgetTooltip = awful.tooltip ({ objects = { pacmanWidget } })
    pacmanWidgetTimer = timer({ timeout = 900 })
    pacmanWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("checkupdates")
        data = fh:read("*a"), "\n"
        lines = split(data)
        text = #lines
        pacmanWidget:set_markup("pacman:  " .. text)
        tooltip = data:gsub("^%s*(.-)%s*$", "%1")
        pacmanWidgetTooltip:set_text (tooltip)
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

