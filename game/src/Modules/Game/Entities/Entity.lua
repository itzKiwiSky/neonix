local Entity = class:extend("Entity")

function Entity:__construct(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 32
    self.h = h or 32
end

function Entity:update(elapsed)
    
end

function Entity:draw()
    
end

function Entity:checkCollision(e)
    return self.x + self.w > e.x
    and self.x < e.x + e.w
    and self.y + self.h > e.y
    and self.y < e.y + e.h
end

return Entity