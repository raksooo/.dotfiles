local wibox = require("wibox")
local awful = require("awful")

function etherWidget()
    etherWidget = wibox.layout.fixed.horizontal()
    value = wibox.widget.textbox()
    etherWidget:add(value)
    value:set_text("Ξ")

    etherWidgetTimer = timer({ timeout = 1200 })
    etherWidgetTimer:connect_signal("timeout", function() updateEtherWidget(value) end)
    etherWidgetTimer:start()

    etherWidgetStartTimer = timer({ timeout = 10 })
    etherWidgetStartTimer:connect_signal("timeout",
        function()
            updateEtherWidget(value)
            etherWidgetStartTimer:stop()
        end)
    etherWidgetStartTimer:start()

    return etherWidget
end

function updateEtherWidget(textbox)
    ether = getEtherValue()
    ether = round2(ether)

    text = "Ξ: $" .. ether
    textbox:set_text(text)
end

function round2(n)
    return round(n * 100) / 100
end

function getEtherValue()
    fh = io.popen("curl -q -s https://coinmarketcap-nexuist.rhcloud.com/api/eth | sed -n '13 p'")
    data = fh:read("*a")
    fh:close()
    data = split(data, ":")
    data = split(data[2], "\"")
    return tonumber(data[2])
end

