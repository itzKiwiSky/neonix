EditorState = {}

local function _drawStaticGrid(camera, cellSize)
    local screenW, screenH = shove.getViewportDimensions()
    local scale = camera.scale
    local camX, camY = camera:position()

    -- Ajusta o tamanho da célula ao zoom (opcional)
    local step = cellSize * scale

    -- Offset da câmera para mover a grid
    local offsetX = (camX * scale) % step
    local offsetY = (camY * scale) % step

    love.graphics.setColor(1, 1, 1, 0.35)

    -- Linhas verticais
    for x = -offsetX, screenW, step do
        love.graphics.line(x, 0, x, screenH)
    end

    -- Linhas horizontais
    for y = -offsetY, screenH, step do
        love.graphics.line(0, y, screenW, y)
    end
end

function EditorState:enter()
    self.interface = {
        menubar = require 'src.Modules.Game.Views.Slab.EditorMenuBar',
        editorToolkit = require 'src.Modules.Game.Views.Slab.EditorToolkit'
    }


    love.graphics.push("all")
    slab.Initialize({"NoDocks"})
    love.graphics.pop()

    self.Editor = {
        components = {
            createLevel = require 'src.Modules.Game.Functions.CreateLevel'
        },
        objects = {},
        data = {

        },
        flags = {
            swipeMode = false,
            showHitbox = false
        },
    }

    self.editorLevelData = self.Editor.components.createLevel()

    self.mouse = {
        x = 0,
        y = 0,
    }


    self.assets = {
        tile = {},
        hazard = {},
        trigger = {},
        objects = {},
        bgs = {},
    }

    self.assets.tile.img, self.assets.tile.quads = love.graphics.getQuads("assets/images/game/blocks")
    self.assets.hazard.img, self.assets.hazard.quads = love.graphics.getQuads("assets/images/game/spike")
    self.assets.trigger.img, self.assets.trigger.quads = love.graphics.getQuads("assets/images/game/triggers")
    self.assets.objects["vehiclePortal"] = {}
    self.assets.objects["vehiclePortal"].img, self.assets.objects["vehiclePortal"].quads = love.graphics.getQuads("assets/images/game/portal_vehicle")
    --self.assets.objects["vehiclePortal"].img, self.assets.objects["vehiclePortal"].quads = love.graphics.getQuads("assets/images/game/portal_vehicle")
    --self.assets.backbutton = love.graphics.newImage("assets/images/game/backbtn.png")

    local bgs = love.filesystem.getDirectoryItems("assets/images/backgrounds")
    for b = 1, #bgs, 1 do
        table.insert(self.assets.bgs, love.graphics.newImage("assets/images/backgrounds/" .. bgs[b]))
    end

    self.editorCamera = camera()
    self.editorCamera.targetZoom = 1
end

function EditorState:draw()
    local curBG = self.assets.bgs[self.editorLevelData.level.bgID]
    local bgOffsetX = self.editorCamera.x * self.editorLevelData.meta.bgConfig.bgFactor.x + self.editorLevelData.meta.bgConfig.bgOffsetX
    local bgOffsetY = self.editorCamera.y * self.editorLevelData.meta.bgConfig.bgFactor.y + self.editorLevelData.meta.bgConfig.bgOffsetY

    -- Calcula o início e o fim do grid de texturas que precisam ser desenhadas
    local startX = math.floor(bgOffsetX / curBG:getWidth()) * curBG:getWidth()
    local startY = math.floor(bgOffsetY / curBG:getHeight()) * curBG:getHeight()

    local endX = startX + shove.getViewportWidth() + curBG:getWidth()
    local endY = startY + shove.getViewportHeight() + curBG:getHeight()

    for x = startX, endX, curBG:getWidth() do
        for y = startY, endY, curBG:getHeight() do
            local color = self.editorLevelData.level.colorChannels["bg"]
            love.graphics.setColor(self.editorLevelData.level.colorChannels["bg"])
                love.graphics.draw(curBG, x - bgOffsetX, y - bgOffsetY)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
    _drawStaticGrid(self.editorCamera, 64)
    self.editorCamera:attach()
    self.editorCamera:detach()

    slab.Draw()
end

function EditorState:update(elapsed)
    slab.Update(elapsed)

    self.interface.menubar()
    self.interface.editorToolkit()

    local inside, mx, my = shove.mouseToViewport()
    local mx, my = self.editorCamera:worldCoords(mx, my)
    self.mouse.x = math.floor(mx / 32) * 32
    self.mouse.y = math.floor(my / 32) * 32

    self.editorCamera.scale = math.lerp(self.editorCamera.scale, self.editorCamera.targetZoom, 0.0075)
    if self.editorCamera.scale > 3 then
        self.editorCamera.targetZoom = 3
    end
    if self.editorCamera.scale < 0.5 then
        self.editorCamera.targetZoom = 0.5
    end
end

function EditorState:mousemoved(x, y, dx, dy)
    -- mouse scroll --
    if love.mouse.isDown(3) then
        self.editorCamera.x = self.editorCamera.x - dx / self.editorCamera.scale
        self.editorCamera.y = self.editorCamera.y - dy / self.editorCamera.scale
    end
end

function EditorState:wheelmoved(x, y)
    if y < 0 then
        self.editorCamera.targetZoom = self.editorCamera.targetZoom - 0.05
    elseif y > 0 then
        self.editorCamera.targetZoom = self.editorCamera.targetZoom + 0.05
    end
end

return EditorState