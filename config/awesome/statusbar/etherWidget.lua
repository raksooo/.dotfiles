function etherWidget()
    etherWidget = wibox.layout.fixed.horizontal()
    value = wibox.widget.textbox()
    etherWidget:add(value)
    value:set_text("Ξ")

    tools.initInterval(function() updateEtherWidget(value) end, 1200, true)

    return etherWidget
end

function updateEtherWidget(textbox)
    tools.connected(function()
        getEtherValue(function(ether)
            usdToSek(function(sek)
                usd = round2(ether)
                sek = round2(ether * sek)
                text = "Ξ: $" .. usd .. " (" .. sek .. "kr)"
                textbox:set_markup(text)
            end)
        end)
    end)
end

function round2(n)
    return round(n * 100) / 100
end

function getEtherValue(callback)
    asyncshell.request("curl -q -s https://coinmarketcap-nexuist.rhcloud.com/api/eth | sed -n '13 p'",
        function(data)
            data = split(data, ":")
            data = split(data[2], "\"")
            callback(tonumber(data[2]))
        end)
end

function usdToSek(callback)
    asyncshell.request("curl -q -s http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml | grep -i -E 'sek|usd'",
        function(data)
            data = split(data, "\n")
            for i=1,2 do
                data[i] = split(data[i], "'")
                data[i] = data[i][4]
                data[i] = tonumber(data[i])
            end

            callback(data[2]/data[1])
        end)
end

