PlayState = {}

function PlayState:enter()
    local player = require 'src.Modules.Game.Entities.Player'
    local tile = require 'src.Modules.Game.Entities.Tile'

    self.tiles = {}
    self.objects = {}
    
    self.player = player:new(shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    --print(inspect.s)
    table.insert(self.tiles, tile:new(128, shove.getViewportHeight() / 2 + 200, shove.getViewportWidth() - 256, 32))
end

function PlayState:draw()
    self.player:draw()
    for i, v in ipairs(self.tiles) do
        v:draw()
    end
end

function PlayState:update(elapsed)
    self.player:update(elapsed)
    for i, v in ipairs(self.tiles) do
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
            local c = b:resolveCollision(self.player)
            if c then
                loop = true
            end
        end

        for _, b in ipairs(self.tiles) do
            local c = self.player:resolveCollision(b)
            if c then
                loop = true
            end
        end
    end
end

return PlayState