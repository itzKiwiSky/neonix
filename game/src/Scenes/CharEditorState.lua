CharEditorState = {}

function CharEditorState:enter()
    
end

function CharEditorState:draw()
    
end

function CharEditorState:update(elapsed)
    if Controller:pressed("ui_back") then
        gamestate.pop()
    end
end

return CharEditorState