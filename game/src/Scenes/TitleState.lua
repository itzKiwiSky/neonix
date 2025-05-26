TitleState = {}

function TitleState:enter()
    self.Conductor = require 'src.Modules.Game.Conductor'
    self.SpectrumVisualizer = require 'src.Modules.Game.Graphics.SpecVisualizer'
    self.Expander = require 'src.Modules.Game.Graphics.Expander'
    self.Fog = require 'src.Modules.Game.Graphics.Fog'

    self.nxLogo = love.graphics.newImage("assets/images/menus/logo_thingy.png")
    self.nxLogoFX = love.graphics.newImage("assets/images/menus/logo_fx.png")
    self.sun = love.graphics.newImage("assets/images/menus/sun.png")
    self.hills = love.graphics.newImage("assets/images/menus/hills.png")
    self.grid = love.graphics.newImage("assets/images/menus/grid.png")
    self.titleText = love.graphics.newImage("assets/images/menus/menuText.png")
    self.gradientBG = love.graphics.newGradient("vertical", 
        {11 / 255, 11 / 255, 11 / 255, 255}, 
        {11 / 255, 11 / 255, 11 / 255, 255}, 
        {100 / 255, 100 / 255, 100 / 255, 255}, 
        {11 / 255, 11 / 255, 11 / 255, 255}, 
        {11 / 255, 11 / 255, 11 / 255, 255}
    )
    self.gridGradientBG = love.graphics.newGradient("horizontal", 
        {11 / 255, 11 / 255, 11 / 255, 255}, 
        {45 / 255, 45 / 255, 45 / 255, 255}, 
        {100 / 255, 100 / 255, 100 / 255, 255}, 
        {45 / 255, 45 / 255, 45 / 255, 255}, 
        {11 / 255, 11 / 255, 11 / 255, 255}
    )

    self.gridGradient = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {0, 0, 0, 0})

    self.Conductor.bpm = 91 / 2

    --[[
    if not self.futureBaseTheme then
        self.futureBaseTheme = love.audio.newSource("assets/sounds/Tracks/future_base.ogg", "stream")
    end
    self.futureBaseTheme:setVolume(gameSave.save.user.settings.audio.musicVolume)
    self.futureBaseTheme:setLooping(true)
    if not self.futureBaseTheme:isPlaying() then
        self.futureBaseTheme:play()
    end
    ]]--

    self.song = SoundManager.newChannel("mainMenu")
    self.song:loadSource("future_base")
    if not self.song.source:isPlaying() then
        self.song:play()
        self.song:setLooping(true)
        self.song:setVolume(gameSave.save.user.settings.audio.musicVolume)
    end

    self.spvzmenu = self.SpectrumVisualizer:new("assets/sounds/Tracks/future_base.ogg", 1024, 32)
    
    self.fogGlowFx = self.Fog(love.graphics.newImage("assets/images/menus/glow.png"))

    self.menuCam = camera()
    self.menuCam.y = self.menuCam.y - 96

    event.hook(self.Conductor, { "beatHit" })

    self.glowSize = 0
    self.logoBumpSize = 0.3

    self.alphaText = 1
    self.enterPressed = false
    self.flash = 0

    self.camTween = flux.to(self.menuCam, 3, {y = self.menuCam.y + love.graphics.getHeight()})
    self.camTween:delay(1.8)
    self.camTween:ease("backin")
    self.camTween:oncomplete(function()
        gamestate.switch(MenuState)
    end)

    self.time = 0

    event.on("beatHit", function()
        self.logoBumpSize = 0.35
        self.glowSize = 512
        self.Expander.add(self.nxLogoFX, 0.3, 0.3, 1.66, 0.03, 0.5)
    end)
end

function TitleState:draw()
    self.menuCam:attach()
        love.graphics.draw(self.gradientBG, 0, -256, 0, 1280, 768 + 512)
        love.graphics.draw(self.sun, love.graphics.getWidth() / 2, 256, 0, 1, 1, self.sun:getWidth() / 2, self.sun:getHeight() / 2)

        love.graphics.draw(self.fogGlowFx, 0, love.graphics.getHeight() / 2)

        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setBlendMode("add")
        love.graphics.draw(self.gridGradient, 0, 376, 0, 1280, -self.glowSize)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, 1)

        self.spvzmenu:draw(0, love.graphics.getHeight() / 2, 64, 0.3)
        love.graphics.draw(self.hills, love.graphics.getWidth() / 2, 64, 0, 0.6, 0.7, self.hills:getWidth() / 2)
        love.graphics.draw(self.hills, -love.graphics.getWidth() / 2 + 96, 64, 0, 0.6, 0.7, self.hills:getWidth() / 2)
        love.graphics.draw(self.gridGradientBG, 0, 376, 0, 1280, 460)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setBlendMode("add")
        love.graphics.draw(self.gridGradient, 0, 376, 0, 1280, 256)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.grid, 0, 376, 0, 1280 / self.grid:getWidth(), 0.9)

        love.graphics.draw(self.nxLogo, love.graphics.getWidth() / 2, 128, 0, self.logoBumpSize, self.logoBumpSize, self.nxLogo:getWidth() / 2 , self.nxLogo:getHeight() / 2)
        self.Expander.draw(love.graphics.getWidth() / 2, 128, 0)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 128, love.graphics.getWidth(), 512)
        love.graphics.draw(self.gridGradient, 0, love.graphics.getHeight() - 128, 0, 1280, -128)
        love.graphics.setColor(1, 1, 1, 1)
    self.menuCam:detach()
    love.graphics.setColor(1, 1, 1, self.alphaText)
    love.graphics.draw(self.titleText, love.graphics.getWidth() / 2, 600, 0, 0.45, 0.45, self.titleText:getWidth() / 2, self.titleText:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1, self.flash)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function TitleState:update(elapsed)
    self.time = self.time + elapsed
    self.Conductor.songPos = (self.song.source:tell() * 1000)
    self.Conductor:update(elapsed)

    if self.song.source:isPlaying() then
        self.spvzmenu:update(elapsed, self.song.source)
    end

    self.menuCam.y = self.menuCam.y + math.cos(self.time) / 2 + 0.1 * elapsed
    --menuCam.y = math.cos(time) / 1.5 + 0.07 * elapsed

    self.glowSize = math.lerp(self.glowSize, 0, 0.1)
    self.logoBumpSize = math.lerp(self.logoBumpSize, 0.3, 0.3)

    if self.flash > 0 then
        self.flash = self.flash - 1.5 * elapsed
    end

    self.Expander.update(elapsed)

    if self.enterPressed then        
        flux.update(elapsed)
        if self.flash <= 0 then
            if self.alphaText > 0 then
                self.alphaText = self.alphaText - 3.2 * elapsed
            end
        end
    end

    self.fogGlowFx:update(elapsed)
end

function TitleState:keypressed(k)
    if k == "return" then
        if not self.enterPressed then
            self.enterPressed = true
            self.flash = 1
        end
    end
end

return TitleState