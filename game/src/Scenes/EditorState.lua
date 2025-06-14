EditorState = {}

local function _drawStaticGrid(camera, cellSize)
    -- Obter dimensões da tela
    local screenWidth, screenHeight = love.graphics.getDimensions()

    -- Ajustar o tamanho das células da grade com base no zoom
    local adjustedCellSize = cellSize * camera.scale

    -- Calcular a posição inicial da grade para o alinhamento com a câmera
    local startX = math.floor(camera.x / adjustedCellSize) * adjustedCellSize
    local startY = math.floor(camera.y / adjustedCellSize) * adjustedCellSize

    -- Definir a cor da grade (RGBA)
    love.graphics.setColor(1, 1, 1, 0.3)

    -- Desenhar as linhas verticais
    for x = startX, camera.x + screenWidth, adjustedCellSize do
        love.graphics.line(x - camera.x, 0, x - camera.x, screenHeight)
    end

    -- Desenhar as linhas horizontais
    for y = startY, camera.y + screenHeight, adjustedCellSize do
        love.graphics.line(0, y - camera.y, screenWidth, y - camera.y)
    end

    -- Resetar cor para o padrão
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

local function _onScreen(obj, cam)
    local camX, camY = cam.x, cam.y
    viewportW, viewportH = shove.getViewportDimensions()
    local viewLeft   = camX - viewportW / 2
    local viewTop    = camY - viewportH / 2
    local viewRight  = camX + viewportW / 2
    local viewBottom = camY + viewportH / 2

    local objRight  = (obj.x) + obj.hitbox.w
    local objBottom = (obj.y) + obj.hitbox.h

end

function EditorState:enter()
    love.graphics.push("all")
    slab.Initialize({"NoDocks"})
    love.graphics.pop()

    loveframes.SetActiveSkin("Dark blue")

    self.Editor = {
        components = {
            createLevel = require 'src.Modules.Game.Functions.CreateLevel',
            viewManager = require 'src.Modules.System.Utils.ViewManager',
        },
        objects = {
            tile = require 'src.Modules.Game.Objects.Tiles',
            hazard = require 'src.Modules.Game.Objects.Hazards',
            trigger = require 'src.Modules.Game.Objects.Triggers',
        },
        data = {},
        flags = {
            swipeMode = false,
            showHitbox = false,
        },
    }

    self.editorLevelData = self.Editor.components.createLevel()
    self.editorCamera = camera()
    self.editorCamera.targetZoom = 1

    self.editorCamera.visibleArea = {
        x = 0,
        y = 0,
        w = shove.getViewportWidth(),
        h = shove.getViewportHeight(),
    }

    self.Editor.data.objects = {}
    self.Editor.data.levelPath = ""
    self.Editor.data.canEdit = false
    self.Editor.data.objType = "tile"
    self.Editor.data.currentEditorMode = "build"
    self.Editor.data.objID = 1
    self.Editor.data.angle = 0
    self.Editor.data.selectionArea = {
        mode = "build",
        visible = false,
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        normalizedW = 0,
        normalizedH = 0,
        storedObjectsIndexes = {}
    }

    self.Editor.data.mouse = {
        x = 0,
        y = 0
    }

    self.Editor.data.toolboxState = {
        currentTab = 1
    }

    self.mouse = {
        x = 0,
        y = 0,
    }

    self.assets = {
        tile = {},
        hazard = {},
        trigger = {},
        portals = {},
        bgs = {},
    }

    self.assets.tile.img, self.assets.tile.quads = love.graphics.getQuads("assets/images/game/blocks")
    self.assets.hazard.img, self.assets.hazard.quads = love.graphics.getQuads("assets/images/game/spike")
    self.assets.trigger.img, self.assets.trigger.quads = love.graphics.getQuads("assets/images/game/triggers")
    self.assets.portals["vehiclePortal"] = {}
    self.assets.portals["vehiclePortal"].img, self.assets.portals["vehiclePortal"].quads = love.graphics.getQuads("assets/images/game/portal_vehicle")
    

    local bgs = love.filesystem.getDirectoryItems("assets/images/backgrounds")
    for b = 1, #bgs, 1 do
        table.insert(self.assets.bgs, love.graphics.newImage("assets/images/backgrounds/" .. bgs[b]))
    end

    self.Editor.components.viewManager.load("src/Modules/Game/Views/Static/EditorToolkit.lua")
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
    _drawStaticGrid(self.editorCamera, 32)
    self.editorCamera:attach()
        for _, o in pairs(self.editorLevelData.objects) do
            if o.meta.selected then
                love.graphics.setColor(0, 1, 0, 1)
            else
                love.graphics.setColor(self.editorLevelData.level.colorChannels["obj"])
            end
            switch(o.type, {
                ["tile"] = function()
                    local qx, qy, qw, qh = self.assets[o.type].quads[o.id]:getViewport()
                    love.graphics.draw(
                        self.assets[o.type].img, self.assets[o.type].quads[o.id], 
                        o.x, o.y, math.rad(o.angle), 1, 1, qw / 2, qh / 2
                    )
                end,
                ["hazard"] = function()
                    local qx, qy, qw, qh = self.assets[o.type].quads[o.id]:getViewport()
                    love.graphics.draw(
                        self.assets[o.type].img, self.assets[o.type].quads[o.id], 
                        o.x, o.y, math.rad(o.angle), 0.5, 0.5, qw / 2, qh / 2
                    )
                end,
                ["trigger"] = function()
                    local qx, qy, qw, qh = self.assets[o.type].quads[o.id]:getViewport()
                    love.graphics.draw(
                        self.assets[o.type].img, self.assets[o.type].quads[o.id], 
                        o.x, o.y, math.rad(o.angle), 1, 1, qw / 2, qh / 2
                    )
                end,
            })
            love.graphics.setColor(1, 1, 1, 1)
            
            if o.hitbox then
                switch(o.hitbox.type, {
                    ["solid"] = function()
                        if self.Editor.flags.showHitbox then
                            love.graphics.setColor(0, 0, 1, 0.6)
                                love.graphics.rectangle("fill", o.hitbox.x, o.hitbox.y, o.hitbox.w, o.hitbox.h)
                            love.graphics.setColor(0, 0, 1, 1)
                                love.graphics.rectangle("line", o.hitbox.x, o.hitbox.y, o.hitbox.w, o.hitbox.h)
                            love.graphics.setColor(1, 1, 1, 1)
                        end
                    end,
                    ["hazard"] = function()
                        if self.Editor.flags.showHitbox then
                            love.graphics.setColor(1, 0, 0, 0.6)
                                love.graphics.rectangle("fill", o.hitbox.x, o.hitbox.y, o.hitbox.w, o.hitbox.h)
                            love.graphics.setColor(1, 0, 0, 1)
                                love.graphics.rectangle("line", o.hitbox.x, o.hitbox.y, o.hitbox.w, o.hitbox.h)
                            love.graphics.setColor(1, 1, 1, 1)
                        end
                    end
                })
            end
        end

        local qx, qy, qw, qh = self.assets["trigger"].quads[10]:getViewport()
        love.graphics.draw(
            self.assets["trigger"].img, self.assets["trigger"].quads[10], 
            self.editorLevelData.level.startPos[1], 
            self.editorLevelData.level.startPos[2],
            0, 1, 1, qw / 2, qh / 2
        )

        local qx, qy, qw, qh = self.assets["trigger"].quads[11]:getViewport()
        love.graphics.draw(
            self.assets["trigger"].img, self.assets["trigger"].quads[11], 
            self.editorLevelData.level.endPos[1], 
            self.editorLevelData.level.endPos[2],
            0, 1, 1, qw / 2, qh / 2
        )


        love.graphics.setColor(1, 0, 1)
            love.graphics.setLineWidth(8)
                love.graphics.rectangle("line", self.Editor.data.mouse.x, self.Editor.data.mouse.y, 32, 32)
        love.graphics.setColor(0, 1, 1)
            love.graphics.setLineWidth(3)
                love.graphics.rectangle("line", self.Editor.data.mouse.x, self.Editor.data.mouse.y, 32, 32)
            love.graphics.setLineWidth(1)
        love.graphics.setColor(1, 1, 1)
    self.editorCamera:detach()

    love.graphics.print(([[
    CurrentState: %s
    swipeMode: %s
    ]]):format(self.Editor.data.currentEditorMode, self.Editor.flags.swipeMode), 10, 32)

    self.Editor.components.viewManager.draw()
end

local function _action(self)
    if self.Editor.data.canEdit and self.Editor.data.objType ~= "none" then
        if love.mouse.isDown(1) and self.Editor.data.currentEditorMode == "build" then
            if not _isHover(self, self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16) then
                if self.Editor.data.objType == "trigger" and self.Editor.data.objID == 10 or self.Editor.data.objID == 11 then
                    if self.Editor.data.objID == 10 then
                        self.editorLevelData.level.startPos = { self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16 }
                        return
                    end
                    if self.Editor.data.objID == 11 then
                        self.editorLevelData.level.endPos = { self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16 }
                        return
                    end
                else
                    if self.Editor.objects[self.Editor.data.objType] then
                        table.insert(self.editorLevelData.objects, self.Editor.objects[self.Editor.data.objType](
                            self.Editor.data.objID, self.Editor.data.mouse.x + 16, 
                            self.Editor.data.mouse.y + 16, self.Editor.data.angle, true
                        ))
                    end
                end
            end
        elseif love.mouse.isDown(1) then
            if self.Editor.data.currentEditorMode == "delete" then
                if _isHover(self, self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16) then
                    _removeAt(self, self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16)
                end
            end
        elseif love.mouse.isDown(1) and not self.Editor.data.swipeMode then
            if self.Editor.data.currentEditorMode == "edit" then
                if _isHover(self, self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16) then
                    for _, o in pairs(this.editorLevelData.objects) do
                        o.meta.selected = false
                    end
                    _selectAt(self, self.Editor.data.mouse.x + 16, self.Editor.data.mouse.y + 16)
                end
            end
        end
    end
end

function EditorState:update(elapsed)
    self.Editor.components.viewManager.update()
    self.Editor.components.viewManager.reloadViews()

    local inside, mx, my = shove.mouseToViewport()
    local mx, my = self.editorCamera:worldCoords(mx, my)
    self.Editor.data.mouse.x = math.floor(mx / 32) * 32
    self.Editor.data.mouse.y = math.floor(my / 32) * 32

    self.editorCamera.scale = math.lerp(self.editorCamera.scale, self.editorCamera.targetZoom, 0.075)
    if self.editorCamera.scale > 3 then
        self.editorCamera.targetZoom = 3
    end
    if self.editorCamera.scale < 0.5 then
        self.editorCamera.targetZoom = 0.5
    end

    self.Editor.data.canEdit = not loveframes.GetHover()

    --self.Editor.data.selectionArea.visible = love.mouse.isDown(1)
    if self.Editor.flags.swipeMode then
        _action(self)
    end
end


function EditorState:mousepressed(x, y, button)
    self.Editor.components.viewManager.mousepressed(x, y, button)
    if not self.Editor.flags.swipeMode then
        _action(self)
    end
end

function EditorState:mousereleased(x, y, button)
    self.Editor.components.viewManager.mousereleased(x, y, button)
end

function EditorState:keypressed(k)
    local modes = {"build", "edit", "delete"}
    self.Editor.components.viewManager.keypressed(k)
    if k == "q" then
        self.Editor.data.angle = self.Editor.data.angle - 90
    elseif k == "e" then
        self.Editor.data.angle = self.Editor.data.angle + 90
    elseif k == "t" then
        self.Editor.flags.swipeMode = not self.Editor.flags.swipeMode
    else
        if modes[tonumber(k)] then
            self.Editor.data.currentEditorMode = modes[tonumber(k)]
        end
    end

    --[[if k == "delete" then
        if Editor.data.currentEditorMode == "edit" then
            for i = #editorLevelData.objects, 1, -1 do
                local o = editorLevelData.objects[i]
                if o and o.meta.selected then
                    table.remove(editorLevelData.objects, i)
                end
            end
        end
    end]]--
end

function EditorState:keyreleased(k)
    self.Editor.components.viewManager.keyreleased(k)
end

function EditorState:mousemoved(x, y, dx, dy)
    -- mouse scroll --
    if love.mouse.isDown(2, 3) then
        self.editorCamera.x = self.editorCamera.x - dx / self.editorCamera.scale
        self.editorCamera.y = self.editorCamera.y - dy / self.editorCamera.scale
    end
end

function EditorState:textinput(t)
    self.Editor.components.viewManager.textinput(t)
end

function EditorState:wheelmoved(x, y)
    --if y < 0 then
    --    self.editorCamera.targetZoom = self.editorCamera.targetZoom - 0.05
    --elseif y > 0 then
    --    self.editorCamera.targetZoom = self.editorCamera.targetZoom + 0.05
    --end
end

return EditorState