local wibox = require("wibox")
local awful = require("awful")

function pacmanWidget()
    pacmanWidget = wibox.layout.fixed.horizontal()
    image = wibox.widget.imagebox()
    image:set_image("/home/rascal/.config/awesome/statusbar/pacman.png")
    count = wibox.widget.textbox()
    pacmanWidget:add(count)
    pacmanWidget:add(image)
    pacmanWidgetTooltip = awful.tooltip({ objects = { pacmanWidget } })

    pacmanWidgetTimer = timer({ timeout = 900 })
    pacmanWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("checkupdates")
        data = fh:read("*a")
        fh:close()

        lines = split(data, "\n")
        dots = ""
        for i = 1, #lines do
            dots = dots .. "•"
        end
        count:set_markup(dots .. " ")

        tooltip = data:gsub("^%s*(.-)%s*$", "%1")
        pacmanWidgetTooltip:set_text(tooltip)
      end
    )
    pacmanWidgetTimer:emit_signal("timeout")
    pacmanWidgetTimer:start()
    return pacmanWidget
end

