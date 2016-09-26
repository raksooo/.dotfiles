messengerW = {}
function messengerW.widget()
    messengerWidget = wibox.layout.fixed.horizontal()
    messengerW.text = wibox.widget.textbox()
    messengerWidget:add(messengerW.text)
    tools.initInterval(messengerW.update, 3, true)
    return messengerWidget
end

function messengerW.update()
    if messengerWindow ~= nil and messengerWindow.name:len() > 12 and not messengerWindow.name:find("messenger.com/t/") then
        messengerW.text:set_text(messengerWindow.name)
    else
        messengerW.text:set_text('')
    end
end

return messengerW

