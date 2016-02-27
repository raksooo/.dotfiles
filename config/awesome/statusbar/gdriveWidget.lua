gdrive = {}
gdrive.image = nil
gdrive.padding = nil
function gdrive.widget()
    gdriveWidget = wibox.layout.fixed.horizontal()
    gdrive.image = wibox.widget.imagebox()
    gdrive.padding = wibox.widget.textbox()
    gdriveWidget:add(gdrive.padding)
    gdriveWidget:add(gdrive.image)
    gdriveWidget:add(gdrive.padding)

    return gdriveWidget
end

function gdrive.update()
    tools.setTimeout(function()
        fh = io.popen("pidof grive")
        data = fh:read("*a")
        fh:close()

        if data == "" then
            gdrive.image:set_image("/home/rascal/.config/awesome/resources/transparent.png")
            gdrive.padding:set_text("")
        else
            gdrive.image:set_image("/home/rascal/.config/awesome/resources/gdrive.png")
            gdrive.padding:set_text("   ")
        end
    end, 3)
end

return gdrive

