local wibox = require("wibox")

function pacmanWidget()
    pacmanWidget = wibox.widget.textbox()
    pacmanWidgetTimer = timer({ timeout = 900 })
    pacmanWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("checkupdates | wc -l")
        text = fh:read("*a")
        pacmanWidget:set_markup("pacman:  " .. text)
        fh:close()
      end
    )
    pacmanWidgetTimer:emit_signal("timeout")
    pacmanWidgetTimer:start()
    return pacmanWidget
end

