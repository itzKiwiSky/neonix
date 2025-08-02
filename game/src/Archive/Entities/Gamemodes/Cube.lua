local Cube = {}

local function _jump(self)
    if self.canJump then
        self.yVelocity = (self.flipped and self.jumpForce or -self.jumpForce)
        self.canJump = false
    end
end

local function _updateHitboxes(self)
    self.hitbox["spikeBox"].x, self.hitbox["spikeBox"].y = self.last.x + 4, self.last.y + 4
    self.hitbox["actionBox"].x, self.hitbox["actionBox"].y = self.last.x + 2, self.last.y + 2
end

function Cube.draw(self)
    --love.graphics.print("canJump " .. tostring(self.canJump) .. " " .. "yVelocity " .. tostring(self.yVelocity), 20, 20)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Cube.update(self, elapsed)
    if Controller:down("jump") then
        _jump(self)
    end

    self.super.update(self, elapsed)

    if Controller:down("move_left") then
        self.x = self.x - self.moveSpeed * elapsed
    end
    if Controller:down("move_right") then
        self.x = self.x + self.moveSpeed * elapsed
    end 

    _updateHitboxes(self)

    self.yVelocity = self.yVelocity + self.gravity * elapsed

    self.y = self.y + self.yVelocity * elapsed


    if self.last.y ~= self.y then
        self.canJump = false
    end
end

function Cube.collide(self, e, dir)
    self.super.collide(self, e, dir)
    if dir == "bottom" then
        self.yVelocity = 0
        self.canJump = true
    end
end

return Cube