LoadingState = {}

function LoadingState:enter()
    self.logo = love.graphics.newImage("assets/images/menus/logo_thingy.png")
    self.f_loading = fontcache.getFont("comfortaa_semibold", 30)
end

function LoadingState:draw()
    love.graphics.draw(self.logo, shove.getViewportWidth() / 2, 128, 0, 0.25, 0.25, self.logo:getWidth() / 2, self.logo:getHeight() / 2)
    love.graphics.printf("Loading audio...", self.f_loading, 0, shove.getViewportHeight() / 2, shove.getViewportWidth(), "center")

    love.graphics.rectangle("line", shove.getViewportWidth() / 2 - 128, shove.getViewportHeight() - 200, 256, 32)

    love.graphics.rectangle("fill", 
        shove.getViewportWidth() / 2 - 128, 
        shove.getViewportHeight() - 200, 
        math.floor(256 * ((loveloader.loadedCount / loveloader.resourceCount) * 100 / 100)),
        32
    )
end

function LoadingState:update(elapsed)
    if not AUDIO_LOADED then
        loveloader.update()
    else
        gamestate.switch(EditorState)
    end
end

return LoadingState