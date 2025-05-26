local Entity = require 'src.Modules.Game.Entities.Entity'

local Player = Entity:extend("Player")

function Player:__construct(x, y)
    Player.super.new(self, x, y, 64, 64)
    self.img = love.graphics.newImage()
end

return Player