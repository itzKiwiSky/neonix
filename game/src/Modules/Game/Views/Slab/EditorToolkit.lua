local EditorState = require 'src.Scenes.EditorState'

local types = {
    "tile", "hazard", "trigger"
}

return function()
    --local x, y, w, h = shove.getViewport()
    slab.BeginWindow("toolboxWindow", { Title = "Toolbox", X = 0, Y = shove.getViewportHeight() - 128, W = shove.getViewportWidth(), H = 128, AutoSizeWindow = false, AllowResize = false, AllowMove = false })
        slab.BeginLayout("toolboxLayoutItems", { AnchorX = true, Columns = 2 })
            slab.SetLayoutColumn(1)
            if slab.Button("Build mode") then
                EditorState.Editor.data.currentEditorMode = "append"
            end
            if slab.Button("Edit mode") then
                EditorState.Editor.data.currentEditorMode = "edit"
            end
            slab.SetLayoutColumn(2)
            if EditorState.Editor.data.objType == "none" then 
                for t = 1, #types, 1 do
                    if EditorState.assets[types[t]] then
                        if EditorState.assets[types[t]].quads[1] then
                            local qx, qy, qw, qh = EditorState.assets[types[t]].quads[1]:getViewport()
                            slab.Image("tileCatDisp" .. t, {
                                Image = EditorState.assets[types[t]].img,
                                SubX = qx,
                                SubY = qy,
                                SubW = qw,
                                SubH = qh,
                                W = 32,
                                H = 32,
                            })
        
                            if t % 32 ~= 0 then
                                slab.SameLine()
                            end
        
                            if slab.IsControlClicked() then
                                EditorState.Editor.data.objType = types[t]
                            end
                        end
                    end
                end
            else
                if slab.Button("<<<", { W = 32, H = 32 }) then
                    EditorState.Editor.data.objID = 1
                    EditorState.Editor.data.objType = "none"
                end
                if EditorState.assets[EditorState.Editor.data.objType] then
                    for o = 1, #EditorState.assets[EditorState.Editor.data.objType].quads, 1 do
                        local qx, qy, qw, qh = EditorState.assets[EditorState.Editor.data.objType].quads[o]:getViewport()
                        slab.Image("tileCatDisp" .. o, {
                            Image = EditorState.assets[EditorState.Editor.data.objType].img,
                            SubX = qx,
                            SubY = qy,
                            SubW = qw,
                            SubH = qh,
                            W = 32,
                            H = 32,
                            Color = EditorState.Editor.data.objID == o and {0.45, 0.45, 0.45, 1} or {1, 1, 1, 1}
                        })
        
                        if o % 32 ~= 0 then
                            slab.SameLine()
                        end
        
                        if slab.IsControlClicked() then
                            EditorState.Editor.data.objID = o
                            EditorState.Editor.data.angle = 0
                        end
                    end
                end
            end
        slab.EndLayout()
    slab.EndWindow()
end