SplashState = {}

function SplashState:enter()
    self.splashTimer = timer.new()

    self.kiwiLogo = love.graphics.newImage("assets/images/system/kiwi.png")
    self.whaleLogo = love.graphics.newImage("assets/images/system/whaleLove.png")
    self.whaleLogo:setFilter("linear", "linear")
    self.fnt_logoText = fontcache.getFont("compaqthin", 25)
    self.fnt_loveLogo = fontcache.getFont("compaqthin", 18)

    self.snd_logosnd = love.audio.newSource("assets/sounds/logoSplash.ogg", "static")

    self.kiwiLogoPos = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
    }
    self.textProps = {
        alpha = 0,
        y = love.graphics.getHeight() / 2
    }

    self.logoPowered = {
        alpha = 0,
        y = love.graphics.getHeight(),
    }

    self.fadeConfig = {
        alpha = 1
    }

    self.logoMoveTween = flux.group()
    self.logoTextMoveTween = flux.group()
    self.fadeTween = flux.group()
    self.loveLogoTween = flux.group()

    self.fadeTween:to(self.fadeConfig, 0.4, { alpha = 0 }):ease("sineinout")

    self.splashTimer:script(function(sleep)
        sleep(1)
            self.fadeTween:to(self.fadeConfig, 0.25, { alpha = 0 }):ease("sineinout")
        sleep(1)
            self.logoMoveTween:to(self.kiwiLogoPos, 0.5, { y = self.kiwiLogoPos.y - 50 }):ease("sineinout")
            self.logoTextMoveTween:to(self.textProps, 0.5, { y = self.textProps.y + 50, alpha = 1 }):ease("sineinout")
        sleep(1)
            self.snd_logosnd:play()
        sleep(1.2)
            self.loveLogoTween:to(self.logoPowered, 0.7, { alpha = 1, y = love.graphics.getHeight() - 200 }):ease("backinout")
        sleep(1.5)
            self.fadeTween:to(self.fadeConfig, 0.8, { alpha = 1 }):ease("sineinout"):oncomplete(function()
                gamestate.switch(TitleState)
            end)
    end)

end

function SplashState:draw()
    love.graphics.draw(self.kiwiLogo, self.kiwiLogoPos.x, self.kiwiLogoPos.y, 0, 0.2, 0.2, self.kiwiLogo:getWidth() / 2, self.kiwiLogo:getHeight() / 2)

    love.graphics.setColor(1, 1, 1, self.textProps.alpha)
        love.graphics.printf("KiwiStation\nStudios", self.fnt_logoText, 0, self.textProps.y, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, self.logoPowered.alpha)
        love.graphics.draw(self.whaleLogo, love.graphics.getWidth() / 2, self.logoPowered.y, 0, 0.4, 0.4, self.whaleLogo:getWidth() / 2, self.whaleLogo:getHeight() / 2)
        love.graphics.printf("Powered with LÖVE", self.fnt_loveLogo, 0, self.logoPowered.y + 64, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)  

    love.graphics.setColor(0, 0, 0, self.fadeConfig.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function SplashState:update(elapsed)
    self.splashTimer:update(elapsed)

    self.logoMoveTween:update(elapsed)
    self.logoTextMoveTween:update(elapsed)

    self.fadeTween:update(elapsed)
    self.loveLogoTween:update(elapsed)
end

function SplashState:leave()
    self.kiwiLogo:release()
    self.whaleLogo:release()
    self.snd_logosnd:release()
end

return SplashState