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

    pacmanWidgetTimer = timer({ timeout = 1800 })
    pacmanWidgetTimer:connect_signal("timeout", function()
            updatePacmanWidget(count, pacmanWidgetTooltip)
        end)
    pacmanWidgetTimer:start()

    pacmanWidgetStartTimer = timer({ timeout = 15 })
    pacmanWidgetStartTimer:connect_signal("timeout", function()
            updatePacmanWidget(count, pacmanWidgetTooltip)
            pacmanWidgetStartTimer:stop()
        end)
    pacmanWidgetStartTimer:start()

    return pacmanWidget
end

function updatePacmanWidget(count, pacmanWidgetTooltip)
    fh = io.popen("checkupdates")
    data = fh:read("*a")
    fh:close()

    lines = split(data, "\n")
    dots = ""
    for i = 1, math.min(#lines, 120) do
        dots = dots .. (i == 1 and "⚫" or "•")
    end
    count:set_markup(dots .. " ")

    tooltip = data:gsub("^%s*(.-)%s*$", "%1")
    tooltip = "Updates: " .. #lines .. "\n\n" .. tooltip
    pacmanWidgetTooltip:set_text(tooltip)
end

