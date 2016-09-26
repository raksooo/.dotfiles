messengerW = {}
function messengerW.widget()
    messengerWidget = wibox.layout.fixed.horizontal()
    messengerW.text = wibox.widget.textbox()
    messengerWidget:add(messengerW.text)
    tools.initInterval(messengerW.update, 5, true)
    return messengerWidget
end

function messengerW.update()
    if messengerWindow ~= nil and messengerWindow:find("Messenger") then
        messengerW.text:set_text(messengerWindow.name)
    else
        messengerW.text:set_text('')
    end
end

return messengerW

