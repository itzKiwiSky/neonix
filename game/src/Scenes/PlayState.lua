PlayState = {}

function PlayState:enter()
    self.gameCam = camera(shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    self.Player = require 'src.Modules.Game.Entities.Player'
    self.Tile = require 'src.Modules.Game.Entities.Tile'
    self.Exploder = require 'src.Modules.Game.Entities.Hazards.Exploder'

    self.assets = {
        ["platform"] = love.graphics.newImage("assets/images/game/platform.png")
    }

    self.tiles = {}
    self.objects = {}
    
    self.player = self.Player:new(shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    self.platformTile = self.Tile:new(128, shove.getViewportHeight() / 2 + 200, shove.getViewportWidth() - 256, 32)

end

function PlayState:draw()
    self.gameCam:attach(0, 0, shove.getViewportWidth(), shove.getViewportHeight(), true)
    self.player:draw()
    for i, v in ipairs(self.tiles) do
        v:draw()
    end

    self.platformTile:draw()
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
end

function PlayState:update(elapsed)
    self.player:update(elapsed)
    for i, v in ipairs(self.tiles) do
        v:update(elapsed)
    end

    for i, v in ipairs(self.objects) do
        v:update(elapsed)
    end
    
    local loop = true
    local limit = 0

    while loop do
        loop = false

        limit = limit + 1
        if limit > 100 then
            break
        end

        for _, b in ipairs(self.tiles) do
            local c = b:resolveCollision(self.player) or self.platformTile:resolveCollision(self.player)
            if c then
                loop = true
            end
        end

        for _, b in ipairs(self.tiles) do
            local c = self.player:resolveCollision(b) or self.player:resolveCollision(self.platformTile)
            if c then
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

return PlayState