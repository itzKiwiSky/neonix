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

function EditorState:init()
    PlayState:init()
end

function EditorState:enter()
    PlayState:enter()
end

function EditorState:draw()
    PlayState:draw()
    love.graphics.draw(PlayState.viewport, 0, 0, 0, 0.25 * PlayState.viewport:getWidth())
end

function EditorState:update(elapsed)
    PlayState:update(elapsed)
end

function EditorState:keypressed(k)
    PlayState:keypressed(k)
end


return EditorState