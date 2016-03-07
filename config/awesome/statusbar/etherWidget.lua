local ether = {}
function ether.widget()
    etherWidget = wibox.layout.fixed.horizontal()
    ether.value = wibox.widget.textbox()
    ether.tooltip = awful.tooltip({ objects = { etherWidget } })

    ether.value:set_markup("Ξ")
    etherWidget:add(ether.value)

    etherWidget:buttons(awful.util.table.join(
        awful.button({}, 1, ether.update)
    ))

    tools.initInterval(ether.update, 180, true)

    return etherWidget
end

function ether.update()
    tools.connected(function()
        ether.tooltip:set_markup("...")
        getEtherValue(function(eth)
            usdToSek(function(sek)
                usd = round2(eth)
                sek = round2(eth * sek)
                ether.tooltip:set_markup("$" .. usd .. "\n" .. sek .. "kr")
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

return ether

