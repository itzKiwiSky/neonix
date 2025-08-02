return function()
    if Slab.BeginMainMenuBar() then
        if Slab.BeginMenu("File") then
            Slab.MenuItem("New level")

            Slab.MenuItem("Open")
            Slab.MenuItem("Save")
            Slab.MenuItem("Save As")

            Slab.Separator()

            if Slab.MenuItem("Quit") then
                love.event.quit()
            end

            Slab.EndMenu()
        end

        SlabDebug.Menu()

        Slab.EndMainMenuBar()
    end

    SlabDebug.Begin()
end