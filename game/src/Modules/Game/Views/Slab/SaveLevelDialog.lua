return function()
    if registers.system.editor.fileDialogSave then
        slab.BeginWindow("saveLevelWindow", {Title = "Save level", AllowResize = false})
            slab.Text("Level filename")
            if slab.Input("saveLevelNameInput", {Text = registers.system.editor.saveName}) then
                registers.system.editor.saveName = slab.GetInputText()
            end
            if slab.Button("Cancel") then
                registers.system.editor.fileDialogSave = false
            end
            slab.SameLine()
            if slab.Button("OK") then
                if registers.system.editor.saveName ~= "" then
                    local lvltext = lume.trim(registers.system.editor.saveName)
                    lvltext = lvltext:gsub("%.[^.]+$", "")

                    local lvlFile = love.filesystem.newFile("user/editor/" .. lvltext .. ".wlf", "w")
                    lvlFile:write(love.data.compress("string", "zlib", json.encode(editorLevelData)))
                    lvlFile:close()
                    Editor.data.levelPath = "user/editor/" .. lvltext .. ".wlf"
                    registers.system.editor.fileDialogSave = false
                end
            end
        slab.EndWindow()
    end
end