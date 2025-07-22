SplashState = {}

function SplashState:enter()
    self.introVideo = love.graphics.newVideo("assets/videos/intro.ogv")
    self.lineDeco = love.graphics.newGradient("horizontal", 
        {0, 0, 0, 0}, 
        {255, 255, 255, 255}, 
        {255, 255, 255, 255}, 
        {255, 255, 255, 255},
        {0, 0, 0, 0}
    )
    self.warnTitle = fontcache.getFont("comfortaa_semibold", 40)
    self.warnText = fontcache.getFont("comfortaa_light", 25)
    self.VIDEO = 0
    self.WARN = 1
    self.STATE = 2
    self.splashState = {
        timer = 5,
        state = self.VIDEO,
    }

    self.introVideo:play()
end

function SplashState:draw()
    if self.splashState.state == self.VIDEO then
        love.graphics.draw(self.introVideo, 0, 0, 0, shove.getViewportWidth() / self.introVideo:getWidth(), shove.getViewportHeight() / self.introVideo:getHeight())
    elseif self.splashState.state == self.WARN then
        love.graphics.draw(self.lineDeco, 0, shove.getViewportHeight() / 4, 0, shove.getViewportWidth(), 2)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf(languageService["splash_photosensitive_warning_title"], self.warnTitle, 0, 
            shove.getViewportHeight() * 0.15, shove.getViewportWidth(), "center"
        )
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(languageService["splash_photosensitive_warning_text"], self.warnText, 0, 
            shove.getViewportHeight() * 0.3, shove.getViewportWidth(), "center"
        )
    end
    love.graphics.print(self.splashState.state, 96, 96)
    love.graphics.print(tostring(Controller:pressed("ui_accept")), 96, 128)
end

function SplashState:update(elapsed)

    if not self.introVideo:isPlaying() and self.splashState.state == self.VIDEO then
        self.introVideo:pause()
        self.introVideo:rewind()
        self.splashState.state = self.WARN
    end

    if self.splashState.state == self.WARN then
        self.splashState.timer = self.splashState.timer - elapsed
        if self.splashState.timer <= 0 then
            self.splashState.state = self.STATE
        end
    end
    if self.splashState.state == self.STATE then
        gamestate.switch(TitleState)
    end


    if Controller:pressed("ui_accept") then
        if self.splashState.state == self.VIDEO then
            self.introVideo:pause()
        end
        if self.splashState.state == self.WARN then
            self.splashState.state = self.STATE
        end
    end
end

function SplashState:leave()
    self.introVideo:release()
    collectgarbage("collect")
end

return SplashState