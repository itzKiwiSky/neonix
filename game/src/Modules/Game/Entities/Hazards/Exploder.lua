local Entity = require 'src.Modules.Game.Entities.Entity'
local Bullet = require 'src.Modules.Game.Entities.Hazards.Bullet'

local Exploder = Entity:extend("Exploder")

function Exploder:__construct(x, y, targetX, targetY, speed, prepareTime, bulletCount)
    Exploder.super.__construct(self, x, y, 32, 32)
    self.targetX = targetX
    self.targetY = targetY
    self.speed = speed or 0.045
    self.prepareTime = prepareTime or 3
    self.bulletCount = bulletCount or 16
end

function Exploder:draw()
    if self.exploded then return end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end


function Exploder:update(elapsed)
    self.x = math.lerp(self.x, self.targetX, self.speed)
    self.y = math.lerp(self.y, self.targetY, self.speed)
    self.prepareTime = self.prepareTime - elapsed
    if self.prepareTime < 0 and not self.exploded then
        self.exploded = true
        -- explode: criar balas em círculo --
        local bullets = {}
        local angleStep = (2 * math.pi) / self.bulletCount
        for i = 1, self.bulletCount do
            local angle = (i - 1) * angleStep
            local bullet = Bullet:new(self.x + 16, self.y + 16, 200, angle) -- 200 é a velocidade, ajuste se quiser
            table.insert(PlayState.objects, bullet)
            -- Se você tem um sistema global de entidades, adicione o bullet nele aqui
            -- Por exemplo: table.insert(gameObjects, bullet)
        end
        --self.bulletsSpawned = bullets -- só para debug, remova se não precisar
    end
    Exploder.super.update(self, elapsed)
end

return Exploder