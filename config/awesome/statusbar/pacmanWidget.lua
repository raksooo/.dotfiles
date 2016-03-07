pacman = {}
function pacman.widget()
    pacmanWidget = wibox.layout.fixed.horizontal()
    image = wibox.widget.imagebox()
    image:set_image("/home/rascal/.config/awesome/resources/pacman.png")
    pacman.count = wibox.widget.textbox()
    pacmanWidget:add(pacman.count)
    pacmanWidget:add(image)
    pacman.tooltip = awful.tooltip({ objects = { pacmanWidget } })

    pacmanWidget:buttons(awful.util.table.join(
        awful.button ({}, 1, function() pacman.update(value) end)
    ))

    tools.initInterval(pacman.update, 1800, true)

    return pacmanWidget
end

function pacman.update()
    tools.connected(function()
        asyncshell.request("checkupdates",
            function(data)
                lines = split(data, "\n")
                dots = ""
                for i = 1, math.min(#lines, 35) do
                    dots = dots .. ((i-1) % 20 == 0 and "⚫" or "•")
                end
                pacman.count:set_markup(dots .. " ")

                tooltip = data:gsub("^%s*(.-)%s*$", "%1")
                tooltip = "Updates: " .. #lines .. "\n\n" .. tooltip
                pacman.tooltip:set_text(tooltip)
            end)
    end)
end

return pacman

