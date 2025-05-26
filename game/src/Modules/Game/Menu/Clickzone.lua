local Clickzone = class:extend("Clickzone")

function Clickzone:__construct(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 32
    self.h = h or 32
    self.mx = 0
    self.my = 0
end

function Clickzone:hovered()
    if self.mx >= self.x and self.mx <= self.x + self.w and self.my >= self.y and self.my <= self.y + self.h then
        return true
    end
    return false
end

function Clickzone:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Clickzone