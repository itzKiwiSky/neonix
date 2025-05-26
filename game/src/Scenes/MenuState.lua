MenuState = {}

function MenuState:enter()
    local MenuBGParticles = require 'src.Modules.Game.Graphics.MenuParticleSystem'
    local Clickzone = require 'src.Modules.Game.Menu.Clickzone'
    self.MenuBGP = MenuBGParticles()

    self.song = SoundManager.newChannel("mainMenu")
    self.song:loadSource("future_base")
    if not self.song.source:isPlaying() then
        self.song:play()
        self.song:setLooping(true)
        self.song:setVolume(gameSave.save.user.settings.audio.musicVolume)
    end

    self.scroll = 0
    self.scrollTarget = 1         -- alvo para onde o scroll vai
    self.scrollSpeed = 10         -- maior = mais rápido

    self.userIconImage, self.userIconQuads = love.graphics.getQuadsFromHash("assets/images/menus/menuIcons")

    self.sunBG = love.graphics.newImage("assets/images/menus/sun.png")
    self.sunGlow = love.graphics.newImage("assets/images/menus/lightDot.png")
    self.lockIcon = self.userIconQuads["lock"]

    self.userUI = {
        userIcon = self.userIconQuads["userIcon"],
        error = self.userIconQuads["errorIcon"],
        sucess = self.userIconQuads["sucessIcon"],
        sizeMulti = 0,
        textAlpha = 0,
        hovered = false,
        uiActive = false,
        bgUIAlpha = 0,
        sysDetails = {
            username = "",
            token = ""
        },
        clickzone = Clickzone:new(32, 32, 64, 64),
        dialogStatusOpen = false,
        panel = {
            signOffConfirmDialog = false,
            backupRunning = false,
            loadingRunning = false,
        }
    }

    self.menuCam = camera(love.graphics.getWidth() / 2, -love.graphics.getHeight() - 512)

    self.menuIcons = {
        normal = love.graphics.newImage("assets/images/menus/selectionNormal.png"),
        editor = love.graphics.newImage("assets/images/menus/editorHubEditor.png"),
        customize = love.graphics.newImage("assets/images/menus/selectionPlayerEditor.png"),
        browseHub = love.graphics.newImage("assets/images/menus/editorHubBrowse.png"),
        savedLevels = love.graphics.newImage("assets/images/menus/editorHubSaved.png"),
    }

    self.mouseData = {x = 0, y = 0}
    self.mouseData.x, self.mouseData.y = love.mouse.getPosition()

    self.menuContent = {
        {
            icon = self.menuIcons.editor,
            name = "editor",
            title = languageService["menu_selection_editor_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = EditorMenuState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = self.menuIcons.normal,
            name = "freeplay",
            title = languageService["menu_selection_normal_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = FreeplayState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = self.menuIcons.customize,
            name = "customize",
            title = languageService["menu_selection_char_editor_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = CharEditorState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        }
    }

    self.sunRotation = 0
    self.optionSelected = 0
    --MenuController.addItem()

    self.f_menuSelection = fontcache.getFont("comfortaa_regular", 32)
    self.f_optionDesc = fontcache.getFont("comfortaa_light", 24)

    self.enterCamAnimTransitionRunning = true
    self.leaveCamAnimTransitionRunning = false

    self.enterCamTweenGroup = flux.group()
    self.enterCamTween = self.enterCamTweenGroup:to(self.menuCam, 3, {y = love.graphics.getHeight() / 2})
    self.enterCamTween:ease("backout")
    self.enterCamTween:oncomplete(function()
        self.enterCamAnimTransitionRunning = false
    end)


    self.leaveCamTweenGroup = flux.group()
    self.leaveCamTween = self.leaveCamTweenGroup:to(self.menuCam, 1.6, {x = -(love.graphics.getWidth() + 512)})
    self.leaveCamTween:ease("backin")
    self.leaveCamTween:oncomplete(function()
        self.leaveCamAnimTransitionRunning = false
        gamestate.switch(self.menuContent[self.optionSelected].changeState)
    end)
end

function MenuState:draw()
    self.menuCam:attach()
        love.graphics.setBlendMode("add")
        love.graphics.draw(self.MenuBGP, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        love.graphics.draw(self.sunGlow, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, self.sunBG:getWidth() / self.sunGlow:getWidth(), self.sunBG:getHeight() / self.sunGlow:getHeight(), self.sunGlow:getWidth() / 2, self.sunGlow:getHeight() / 2)
        love.graphics.setBlendMode("alpha")
        love.graphics.draw(self.sunBG, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.55, 0.55, self.sunBG:getWidth() / 2, self.sunBG:getHeight() / 2)

        love.graphics.printf(languageService["menu_selection_title"], self.f_menuSelection, 0, 96, love.graphics.getWidth(), "center")

        local centerX = shove.getViewportWidth() / 2
        local centerY = shove.getViewportHeight() / 2
        local spacing = 256

        for i = 1, #self.menuContent, 1 do
            local dist = i - 1 - self.scroll

            -- posição x alinhada horizontalmente
            local x = centerX + dist * spacing
            local y = centerY

            -- efeito de escala baseado na distância
            local scale = 0.5 - math.min(math.abs(dist) * 0.15, 0.05)

            -- destaque no selecionado
            local selected = math.floor(self.scroll + 0.5) == (i - 1)
            love.graphics.setColor({
                selected and 1 or 0.4, 
                selected and 1 or 0.4, 
                selected and 1 or 0.4, 
            })

            -- retângulo do item
            --love.graphics.rectangle("fill", x - w / 2, y - h / 2, w, h, 10)
            love.graphics.draw(self.menuContent[i].icon, x, y, 0, scale, scale, self.menuContent[i].icon:getWidth() / 2, self.menuContent[i].icon:getHeight() / 2)
            love.graphics.setColor(1, 1, 1)
            -- nome centralizado
            --love.graphics.setColor(1, 1, 1)
            --love.graphics.printf(self.menuContent[i].name, x - 100, y - 8, 200, "center")
        end

        --love.graphics.rectangle("fill", optionBoxX, love.graphics.getHeight() / 2 - 256 / 2, 256, 256, 15)
    self.menuCam:detach()

    love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:update(elapsed)
    self.MenuBGP:update(elapsed)

    self.scroll = self.scroll + (self.scrollTarget - self.scroll) * elapsed * self.scrollSpeed

    if self.enterCamAnimTransitionRunning then
        self.enterCamTweenGroup:update(elapsed)
    end

    if self.leaveCamAnimTransitionRunning then
        self.leaveCamTweenGroup:update(elapsed)
    end
end

function MenuState:mousepressed(x, y, button)

end

function MenuState:keypressed(k)
    if k == "right" then
        self.scrollTarget = math.min(#self.menuContent - 1, self.scrollTarget + 1)
    elseif k == "left" then
        self.scrollTarget = math.max(0, self.scrollTarget - 1)
    end
end

return MenuState