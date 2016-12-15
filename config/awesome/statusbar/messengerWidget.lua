messengerW = {}
function messengerW.widget()
    messengerW.messengerWidget = wibox.layout.fixed.horizontal()
    messengerW.icon = wibox.widget.imagebox()
    messengerW.icon:set_image("/home/oskar/.config/awesome/resources/messenger.png")
    messengerW.padding = wibox.widget.textbox()
    messengerW.padding:set_text("     ")
    messengerW.active = false
    tools.initInterval(messengerW.update, 3, true)
    return messengerW.messengerWidget
end

function messengerW.update()
    if messengerWindow ~= nil and messengerWindow.name:len() > 12 and not messengerWindow.name:find("messenger.com/t/") and not messengerWindow.name:find("messenger.com/new") then
        if not messengerW.active then
            messengerW.active = true
            messengerW.messengerWidget:add(messengerW.icon, messengerW.padding)
        end
    else
        messengerW.active = false
        messengerW.messengerWidget:remove_widgets(messengerW.padding, messengerW.icon)
    end
end

return messengerW

