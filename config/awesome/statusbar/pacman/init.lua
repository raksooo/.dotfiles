local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local pacman = {}
local options = {
    image = gears.filesystem.get_configuration_dir()
        .. "statusbar/pacman/pacman_quantum.png",
    opacity = 0.7,
    margin = 3,
    margin_right = 40
}

function pacman.create()
    pacman.textbox = wibox.widget.textbox()
    local widget = wibox.widget {
        {
            opacity = options.opacity,
            widget = pacman.textbox,
        },
        {
            image = options.image,
            widget = wibox.widget.imagebox
        },
        layout = wibox.layout.fixed.horizontal,
        buttons = awful.util.table.join(awful.button ({}, 1, function() pacman.update() end)),
    }

    awful.tooltip({
        objects = { widget },
        timer_function = function() return pacman.tooltip end,
    })

    pacman.update()
    gears.timer.start_new(300, pacman.update)

    return wibox.widget {
        widget,
        left    = options.margin,
        right   = options.margin_right,
        top   = options.margin,
        bottom   = options.margin,
        layout  = wibox.container.margin
    }
end

function pacman.update()
    awful.spawn.easy_async("checkupdates", function(stdout)
            lines = split(stdout, "\n")
            dots = ""
            for i = 1, math.min(#lines, 55) do
                dots = dots .. ((i-1) % 20 == 0 and "⚫" or "•")
            end
            pacman.textbox:set_markup(dots)

            local tooltip = stdout:gsub("^%s*(.-)%s*$", "%1")
            pacman.tooltip = "Updates: " .. #lines .. "\n\n" .. tooltip
        end)
    return true
end

return pacman

