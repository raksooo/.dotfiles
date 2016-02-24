function pacmanWidget()
    pacmanWidget = wibox.layout.fixed.horizontal()
    image = wibox.widget.imagebox()
    image:set_image("/home/rascal/.config/awesome/resources/pacman.png")
    count = wibox.widget.textbox()
    pacmanWidget:add(count)
    pacmanWidget:add(image)
    pacmanWidgetTooltip = awful.tooltip({ objects = { pacmanWidget } })

    tools.initInterval(function()
            updatePacmanWidget(count, pacmanWidgetTooltip)
        end, 1800, true)

    return pacmanWidget
end

function updatePacmanWidget(count, pacmanWidgetTooltip)
    tools.connected(function()
        asyncshell.request("checkupdates",
            function(data)
                lines = split(data, "\n")
                dots = ""
                for i = 1, math.min(#lines, 120) do
                    dots = dots .. (i == 1 and "⚫" or "•")
                end
                count:set_markup(dots .. " ")

                tooltip = data:gsub("^%s*(.-)%s*$", "%1")
                tooltip = "Updates: " .. #lines .. "\n\n" .. tooltip
                pacmanWidgetTooltip:set_text(tooltip)
            end)
    end)
end

