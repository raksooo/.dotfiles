systemUsage = {}
systemUsage.colors = {
    low = "#859900",
    medium = "#b58900",
    high = "#cb4b16",
    background = "#494B4F"
}
function systemUsage.widget()
    local systemUsageWidget = wibox.layout.fixed.horizontal()
    local label = wibox.widget.textbox()
    label:set_text("S: ")
    systemUsage.tooltip = awful.tooltip ({ objects = { systemUsageWidget } })

    systemUsage.ram = awful.widget.progressbar()
    systemUsage.ram:set_vertical(true)
    systemUsage.ram:set_width(7)
    systemUsage.ram:set_background_color(systemUsage.colors.background)

    systemUsage.cpu = awful.widget.progressbar()
    systemUsage.cpu:set_vertical(true)
    systemUsage.cpu:set_width(7)
    systemUsage.cpu:set_background_color(systemUsage.colors.background)

    tools.initInterval(systemUsage.update, 5)

    systemUsageWidget:add(label)
    systemUsageWidget:add(systemUsage.ram)
    systemUsageWidget:add(systemUsage.cpu)
    return systemUsageWidget
end

function systemUsage.update()
    systemUsage.tooltipText = ""
    updateCpu(function()
        updateRam(function()
            systemUsage.tooltip:set_text(systemUsage.tooltipText)
        end)
    end)
end

function updateCpu(callback)
    asyncshell.request("top -bn2 | grep '^%Cpu' | tail -4 | tr -s ' ' | cut -d ' ' -f 4 | sed 's/[^0-9]*//g'",
        function(data)
            local lines = split(data, "\n")

            local sum = 0
            for k,v in pairs(lines) do
                sum = sum + tonumber(v)
            end
            percentageh = sum/#lines
            percentage = percentageh/100

            local color = percentageToColor(percentage, 0.25, 0.5)
            systemUsage.cpu:set_color(color)
            systemUsage.cpu:set_value(percentage)

            local text = "CPU: " .. sum .. "% (" .. percentageh .. "%)"
            systemUsage.tooltipText = systemUsage.tooltipText .. text

            if callback ~= nil then
                callback()
            end
        end)
end

function updateRam(callback)
    asyncshell.request("ramdata",
        function(data)
            local lines = split(data, "\n")
            local free = tonumber(lines[1])
            local total = tonumber(lines[2])
            local freeh = lines[3]
            local totalh = lines[4]

            local percentage = free / total
            local percentageh = round(100 * percentage)

            local text = "RAM: " .. percentageh .. "% in use ("
                .. freeh .. "/" .. totalh .. ")"
            systemUsage.tooltipText = systemUsage.tooltipText .. "\n" .. text

            local color = percentageToColor(percentage, 0.5, 0.75)
            systemUsage.ram:set_color(color)
            systemUsage.ram:set_value(percentage)

            if callback ~= nil then
                callback()
            end
        end)
end

function percentageToColor(percentage, limit1, limit2)
    if percentage < limit1 then
        return systemUsage.colors.low
    elseif percentage < limit2 then
        return systemUsage.colors.medium
    else
        return systemUsage.colors.high
    end
end

return systemUsage

