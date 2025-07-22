SettingsState = {}

function SettingsState:enter()
    local MenuBGParticles = require 'src.Modules.Game.Graphics.MenuParticleSystem'
    self.MenuBGP = MenuBGParticles()
    self.sunBG = love.graphics.newImage("assets/images/menus/sun.png")
    self.sunGlow = love.graphics.newImage("assets/images/menus/lightDot.png")

    
end

function SettingsState:draw()
    love.graphics.setBlendMode("add")
    love.graphics.draw(self.MenuBGP, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    love.graphics.draw(self.sunGlow, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2, 0, self.sunBG:getWidth() / self.sunGlow:getWidth(), self.sunBG:getHeight() / self.sunGlow:getHeight(), self.sunGlow:getWidth() / 2, self.sunGlow:getHeight() / 2)
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(self.sunBG, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2, 0, 0.55, 0.55, self.sunBG:getWidth() / 2, self.sunBG:getHeight() / 2)
    
end

function SettingsState:update(elapsed)
    self.MenuBGP:update(elapsed)
end

return SettingsState