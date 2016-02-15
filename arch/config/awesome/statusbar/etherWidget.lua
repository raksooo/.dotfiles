local wibox = require("wibox")
local awful = require("awful")

function etherWidget()
    etherWidget = wibox.layout.fixed.horizontal()
    value = wibox.widget.textbox()
    etherWidget:add(value)
    value:set_text("Ξ")

    setInterval(function() updateEtherWidget(value) end, 1200, 2)

    return etherWidget
end

function updateEtherWidget(textbox)
    ether = getEtherValue()
    usd = round2(ether)
    sek = round2(ether * usdToSek(1))

    text = "Ξ: $" .. usd .. " (" .. sek .. "kr)"
    textbox:set_markup(text)
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

function usdToSek(usd)
    fh = io.popen("curl -q -s http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml | grep -i -E 'sek|usd'")
    data = fh:read("*a")
    fh:close()
    data = split(data, "\n")
    for i=1,2 do
        data[i] = split(data[i], "'")
        data[i] = data[i][4]
        data[i] = tonumber(data[i])
    end

    return data[2]/data[1]
end

