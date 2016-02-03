local wibox = require("wibox")
local awful = require("awful")
local vicious = require("vicious")

function weatherWidget()
    weatherwidget = wibox.widget.textbox()
    weather_t = awful.tooltip({ objects = { weatherwidget },})

    vicious.register(weatherwidget, vicious.widgets.weather,
        function (widget, args)
            weather_t:set_text("City: " .. args["{city}"] .."\nWind: " ..
                args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " ..
                args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
            return "<span color=\"#888888\">" .. args["{tempc}"] ..
                        "</span><span color=\"#666666\">°C</span>"
        end, 1800, "ESGP"
    )

    return weatherwidget
end

