EditorState = {}

local function _drawStaticGrid(camera, cellSize)
    local screenWidth, screenHeight = shove.getViewportDimensions()

    local adjustedCellSize = cellSize * camera.scale

    local startX = math.floor(camera.x / adjustedCellSize) * adjustedCellSize
    local startY = math.floor(camera.y / adjustedCellSize) * adjustedCellSize

    love.graphics.setColor(1, 1, 1, 0.3)

    for x = startX, camera.x + screenWidth, adjustedCellSize do
        love.graphics.line(x - camera.x, 0, x - camera.x, screenHeight)
    end

    for y = startY, camera.y + screenHeight, adjustedCellSize do
        love.graphics.line(0, y - camera.y, screenWidth, y - camera.y)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

local function _isHover(this, x, y)
    for _, o in pairs(this.editorLevelData.objects) do
        if o.x == x then
            if o.y == y then
                return true
            end
        end
    end
    return false
end

local function _removeAt(this, x, y)
    for _, o in pairs(this.editorLevelData.objects) do
        if o.x == x then
            if o.y == y then
                table.remove(this.editorLevelData.objects, _)
            end
        end
    end
end

local function _selectAt(this, x, y)
    for _, o in pairs(this.editorLevelData.objects) do
        if o.x == x then
            if o.y == y then
                o.meta.selected = true
            end
        end
    end
end

function EditorState:enter()
    imgui.love.Init()
end

function EditorState:draw()
    --selectable version
    imgui.ShowDemoWindow()
    
    -- code to render imgui
    imgui.Render()
    imgui.love.RenderDrawLists()
end

function EditorState:update(elapsed)
    imgui.love.Update(elapsed)
    imgui.NewFrame()
end


function EditorState:mousemoved(x, y, ...)
    local inside, vx, vy = shove.mouseToViewport()
    imgui.love.MouseMoved(vx, vy)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here
    end
end


function EditorState:mousepressed(x, y, button, ...)
    imgui.love.MousePressed(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end


function EditorState:mousereleased(x, y, button, ...)
    imgui.love.MouseReleased(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end


function EditorState:wheelmoved(x, y)
    imgui.love.WheelMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end


function EditorState:keypressed(k, ...)
    imgui.love.KeyPressed(k)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end


function EditorState:keyreleased(k, ...)
    imgui.love.KeyReleased(k)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

function EditorState:focus(f)
    imgui.love.Focus(f)
end


function EditorState:textinput(t)
    imgui.love.TextInput(t)
    if imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

return EditorState