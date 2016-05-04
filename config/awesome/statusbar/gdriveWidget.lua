gdrive = {}
function gdrive.widget()
    gdrive.gdriveWidget = wibox.layout.fixed.horizontal()
    gdrive.image = wibox.widget.imagebox()
    gdrive.image:set_image("/home/oskar/.config/awesome/resources/gdrive.png")
    gdrive.padding = wibox.widget.textbox()
    gdrive.padding:set_text("    ")

    gdrive.update()

    return gdrive.gdriveWidget
end

function gdrive.update()
    fh = io.popen("pidof grive")
    data = fh:read("*a")
    fh:close()

    if data == "" then
        gdrive.gdriveWidget:remove_widgets(gdrive.padding, gdrive.image)
    else
        gdrive.gdriveWidget:add(gdrive.image, gdrive.padding)
    end
end

return gdrive

