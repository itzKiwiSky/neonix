SplashState = {}

function SplashState:enter()
    self.introVideo = love.graphics.newVideo("assets/videos/intro.ogv")
    self.splashSkipped = false


end

function SplashState:draw()
 
end

function SplashState:update(elapsed)


    --if Controller:pressed("ui_accept") then
    --    self.splashSkipped = true
    --    gamestate.switch(TitleState)
    --end
end

function SplashState:leave()
    self.kiwiLogo:release()
    self.whaleLogo:release()
    self.snd_logosnd:release()
    collectgarbage("collect")
end

return SplashState