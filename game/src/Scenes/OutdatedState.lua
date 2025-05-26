OutdatedState = {}

function OutdatedState:enter()
    self.textEffect = moonshine(moonshine.effects.glow)
    self.textEffect.glow.strength = 9
    self.f_logo = love.graphics.newImage("assets/images/logo_thingy.png")
    self.f_warn = fontcache.getFont("dsdigi", 25)

    self.placeholderWarnText = [[
        Heyo! Your game seems to be outdated!

        You can download the new version at any time, is recommended now.

        Go to the page [ENTER]
        Proceed anyway [ESCAPE]



        Thanks for playing Neonix!
    ]]
        
    self.sTimer = timer.new()
    self.ignored = false

    self.sTimer:after(2, function()
        gamestate.switch(SplashState)
    end)

    self.nxlogo = love.graphics.newImage("assets/images/logoTransparent.png")
end

function OutdatedState:draw()
    self.textEffect(function()
        --love.graphics.printf("Neonix!", self.f_logo, 0, 120, love.graphics.getWidth(), "center")
        love.graphics.draw(self.f_logo, love.graphics.getWidth() / 2 - self.f_logo:getWidth() / 2, 128, 0, 0.5, 0.5)
        love.graphics.printf(self.placeholderWarnText, self.f_warn, 0, 400, love.graphics.getWidth(), "center")

        love.graphics.draw(self.nxlogo, 30, (love.graphics.getHeight() - 156), 0, 128 / self.nxlogo:getWidth(), 128 / self.nxlogo:getHeight())
    end)
end

function OutdatedState:update(elapsed)
    if self.ignored then
        self.sTimer:update(elapsed)
    end
end

function OutdatedState:keypressed(k)
    if k == "return" then
        love.system.openURL("https://github.com/Doge2Dev/OpenNeonix/releases")
        love.event.quit()
    end
    if k == "escape" then
        self.placeholderWarnText = "\n\nPlease wait..."
        self.ignored = true
    end
end

return OutdatedState