EditorState = {}

function EditorState:init()
    PlayState:init()
end

function EditorState:enter()
    Slab.Initialize({"NoDocks"})

    PlayState.isEditor = true
    PlayState:enter()
end

function EditorState:draw()
    local prevX = shove.getViewportWidth() * 0.52
    love.graphics.setColor(0.2, 0.1, 0.4)
    love.graphics.rectangle("fill", 0, 0, shove.getViewportDimensions())
    love.graphics.setColor(1, 1, 1, 1)
    local prevX = shove.getViewportWidth() - (PlayState.viewport:getWidth() * 0.5)
    love.graphics.draw(PlayState.viewport, prevX, 0, 0, 0.5, 0.5)
    love.graphics.rectangle("line", prevX, 0, PlayState.viewport:getWidth() * 0.5, PlayState.viewport:getHeight() * 0.5)
    Slab.Draw()
    PlayState:draw()
end

function EditorState:update(elapsed)
    PlayState:update(elapsed)
    Slab.Update(elapsed)

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

        Slab.EndMainMenuBar()
    end
end

function EditorState:keypressed(k)
    --PlayState:keypressed(k)
end


return EditorState