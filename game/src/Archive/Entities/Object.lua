local Entity = require 'src.Modules.Game.Entities.Entity'

local Object = Entity:extend("Object")

function Object:__construct(type, x, y)
    self.hitbox = {}
end

return Object