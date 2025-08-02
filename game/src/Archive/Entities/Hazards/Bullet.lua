local Entity = require 'src.Modules.Game.Entities.Entity'

local Bullet = Entity:extend("Bullet")

function Bullet:__construct(x, y, speed, angle)
    Bullet.super.__construct(self, x, y, 8, 8)
    self.speed = speed
    self.angle = angle or 0
end

function Bullet:draw()
    if self.dead then return end

    --love.graphics.setColor(1, 0, 0)
    --love.graphics.rectangle("line", self.last.x, self.last.y, self.w, self.h)
    --love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end


function Bullet:update(elapsed)
    if self.dead then return end
    local dx = math.cos(self.angle) * self.speed * elapsed
    local dy = math.sin(self.angle) * self.speed * elapsed
    self.x = self.x + dx
    self.y = self.y + dy
    Bullet.super.update(self, elapsed)
end

return Bullet