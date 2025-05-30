return function()
    if registers.system.editor.fileDialogOpen then
        slab.BeginWindow("openLevelWindow", {Title = "Open level", AllowResize = false})
            slab.BeginListBox("openLevelListBox")
                local lvls = love.filesystem.getDirectoryItems("user/editor")
                for l = 1, #lvls, 1 do
                    if lvls[l]:match("[^.]+$") == "wlf" then
                        slab.BeginListBoxItem("openLevelListBoxItem" .. l, {Selected = registers.system.editor.currentSelectedLevelID == l})
                            slab.Text(lvls[l])
                            if slab.IsListBoxItemClicked() then
                                registers.system.editor.currentSelectedLevelID = l
                                Editor.data.levelPath = "user/editor/" .. lvls[l]
                            end
                        slab.EndListBoxItem()
                    end
                end
            slab.EndListBox()
            if slab.Button("Cancel") then
                registers.system.editor.fileDialogOpen = false
            end
            slab.SameLine()
            if slab.Button("Open") then
                editorLevelData = json.decode(love.data.decompress("string", "zlib", love.filesystem.read(Editor.data.levelPath)))
                registers.system.editor.fileDialogOpen = false
            end
        slab.EndWindow()
    end
end