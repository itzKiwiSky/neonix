local Entity = require 'src.Modules.Game.Entities.Entity'
local Tile = Entity:extend()

function Tile:__construct(_x, _y, _w, _h)
    Tile.super.__construct(self, _x, _y, _w, _h)

    self.strength = 10000000
end

function Tile:draw()
    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Tile