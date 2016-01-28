local wibox = require("wibox")
local awful = require("awful")

function pacmanWidget()
    pacmanWidget = wibox.widget.textbox()
    pacmanWidgetTooltip = awful.tooltip({ objects = { pacmanWidget } })

    pacmanWidgetTimer = timer({ timeout = 900 })
    pacmanWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("checkupdates")
        data = fh:read("*a")
        fh:close()

        lines = split(data, "\n")
        pacmanWidget:set_markup("pacman:  " .. #lines)

        tooltip = data:gsub("^%s*(.-)%s*$", "%1")
        pacmanWidgetTooltip:set_text(tooltip)
      end
    )
    pacmanWidgetTimer:emit_signal("timeout")
    pacmanWidgetTimer:start()
    return pacmanWidget
end

