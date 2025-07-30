PlayState = {}
PlayState.isEditor = false
PlayState.assets = {}
PlayState.tiles = {}
PlayState.objects = {}

function PlayState:init()
    self.conductor = require 'src.Modules.Game.Conductor'
    self.Player = require 'src.Modules.Game.Entities.Player'
    self.Tile = require 'src.Modules.Game.Entities.Tile'
    self.Exploder = require 'src.Modules.Game.Entities.Hazards.Exploder'
    self.viewport = love.graphics.newCanvas(shove.getViewportDimensions())
    self.gameCam = camera(shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
end

function PlayState:enter()
    for k, rsc in pairs(self.assets) do
        rsc:release()
    end

    self.assets = {
        ["platform"] = love.graphics.newImage("assets/images/game/platform.png")
    }

    self.player = self.Player:new(shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    self.platformTile = self.Tile:new(128, shove.getViewportHeight() / 2 + 200, shove.getViewportWidth() - 256, 32)

end

function PlayState:draw()
    if PlayState.isEditor then love.graphics.setCanvas(self.viewport) end
    if PlayState.isEditor then love.graphics.clear() end
    self.gameCam:attach(0, 0, shove.getViewportWidth(), shove.getViewportHeight(), true)
    self.player:draw()
    for i, v in ipairs(self.tiles) do
        v:draw()
    end

    --self.platformTile:draw()
    love.graphics.draw(self.assets["platform"], self.platformTile.x, self.platformTile.y, 0, self.platformTile.w / self.assets["platform"]:getWidth())

    for i, v in ipairs(self.objects) do
        if v.draw then
            v:draw()
        end
    end

    local viewportW = shove.getViewportWidth()
    local viewportH = shove.getViewportHeight()
    local viewLeft   = self.gameCam.x - viewportW / 2
    local viewTop    = self.gameCam.y - viewportH / 2
    local viewRight  = self.gameCam.x + viewportW / 2
    local viewBottom = self.gameCam.y + viewportH / 2

    love.graphics.rectangle("line", viewLeft, viewTop, viewRight, viewBottom)

    self.gameCam:detach()
    if PlayState.isEditor then love.graphics.setCanvas() end
end

function PlayState:update(elapsed)
    self.player:update(elapsed)

    self.platformTile:resolveCollision(self.player)
    self.player:resolveCollision(self.platformTile)

    for i, v in ipairs(self.objects) do
        v:update(elapsed)
    end
    
    local loop = true
    local limit = 0

    while loop do
        loop = false

        limit = limit + 1
        if limit > 50 then
            break
        end

        for _, b in ipairs(self.objects) do
            if b:resolveCollision(self.player) or self.player:resolveCollision(b) then
                loop = true
            end
        end

    end
end

function PlayState:keypressed(k)
    if k == "g" then
        table.insert(self.objects, 
                self.Exploder:new(
                math.random(-64, shove.getViewportWidth() + 128), 
                math.random(-64, shove.getViewportHeight() + 128), 
                math.random(128, shove.getViewportWidth() - 256), 
                math.random(128, shove.getViewportHeight() - 256),
                0.045, 3, 16
            )
        )
    
    --print(inspect(self.objects))
    end
end

function PlayState:leave()
    for k, rsc in pairs(self.assets) do
        rsc:release()
    end

    self.viewport:release()
end

return PlayState