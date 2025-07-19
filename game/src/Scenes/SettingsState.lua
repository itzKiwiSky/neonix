SettingsState = {}

function SettingsState:enter()
    
end

function SettingsState:draw()
    love.graphics.setBlendMode("add")
    love.graphics.draw(self.MenuBGP, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2)
    love.graphics.draw(self.sunGlow, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2, 0, self.sunBG:getWidth() / self.sunGlow:getWidth(), self.sunBG:getHeight() / self.sunGlow:getHeight(), self.sunGlow:getWidth() / 2, self.sunGlow:getHeight() / 2)
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(self.sunBG, shove.getViewportWidth() / 2, shove.getViewportHeight() / 2, 0, 0.55, 0.55, self.sunBG:getWidth() / 2, self.sunBG:getHeight() / 2)
end

function SettingsState:update(elapsed)
    
end

return SettingsState