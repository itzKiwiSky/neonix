local Editor = require 'src.Scenes.EditorState'

return function()
    if slab.BeginMainMenuBar() then
        if slab.BeginMenu("File") then
            if slab.MenuItem("New level") then
                
            end
            if slab.MenuItem("Open level") then
                registers.system.editor.fileDialogOpen = true
            end
            if slab.MenuItem("Save level") then
                if Editor.data.levelPath == "" then
                    registers.system.editor.fileDialogSave = true
                else
                    love.filesystem.write(Editor.data.levelPath, love.data.compress("string", "zlib", json.encode(editorLevelData)))
                end
            end
            if slab.MenuItem("Save and test") then
                
            end
            slab.Separator()
            if slab.MenuItem("Exit") then
                
            end
            slab.EndMenu()
        end

        if slab.BeginMenu("Edit") then
            if slab.MenuItem("Undo") then
                
            end
            if slab.MenuItem("Redo") then
                
            end
            slab.Separator()
            if slab.MenuItem("Rotate left") then
                Editor.data.angle = Editor.data.angle + 90
            end
            if slab.MenuItem("Rotate right") then
                Editor.data.angle = Editor.data.angle - 90
            end
            if slab.MenuItem("Swipe" .. (Editor.flags.swipeMode and " [ON]" or " [OFF]")) then
                Editor.flags.swipeMode = not Editor.flags.swipeMode
            end
            slab.EndMenu()
        end

        if slab.BeginMenu("Tools") then
            if slab.MenuItem("Metadata settings") then
                registers.system.editor.metaDataWindow = true
            end
            if slab.MenuItem("Show hitbox" .. (Editor.flags.showHitbox and " [ON]" or " [OFF]")) then
                Editor.flags.showHitbox = not Editor.flags.showHitbox
            end
            slab.Separator()
            if slab.MenuItem("clear above ground") then
                
            end
            if slab.MenuItem("Clear all") then
                
            end
            slab.EndMenu()
        end
        slab.EndMainMenuBar()
    end
end