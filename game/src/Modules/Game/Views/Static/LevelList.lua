return function()
    local settings = {
        lpadding = 16,
        blank = function()end,
        fonts = {
            ["buttonsFont"] = fontcache.getFont("comfortaa_regular", 18),
            ["levelNameFont"] = fontcache.getFont("comfortaa_semibold", 25),
        },
        images = {
            ["gradientBG"] = love.graphics.newGradient("vertical", {0.35, 0.35, 0.35, 1}, {0.1, 0.1, 0.1, 1}),
            ["decoGradient"] = love.graphics.newGradient("horizontal", 
                {0, 0, 0, 0}, 
                {1, 1, 1, 1}, 
                {0, 0, 0, 0}
            )
        },
    }

    local function drawButton(object)
        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local hover = object:GetHover()
        local text = object:GetText()
        local font = object:GetFont() or skin.controls.smallfont
        local twidth = font:getWidth(object.text)
        local theight = font:getHeight(object.text)
        local down = object:GetDown()

        love.graphics.setFont(font)

        -- button body
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", x, y, width, height)
        
        love.graphics.setColor(1, 1, 1, 1)
        skin.PrintText(text, x + width/2 - twidth/2, y + height/2 - theight/2)
        -- button border
        love.graphics.setLineWidth(3)
        love.graphics.setColor(0.75, 0.75, 0.75, 1)
        love.graphics.rectangle("line", x, y, width, height)
        love.graphics.setLineWidth(1)
        --skin.OutlinedRectangle(x, y, width, height)
    end

    local function scrollarea(object)

        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local bartype = object.bartype or "vertical"
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", x, y, width, height)
        love.graphics.setColor(1, 1, 1, 1)
        
        if bartype == "vertical" then
            skin.OutlinedRectangle(x, y, width, height, true, true)
        elseif bartype == "horizontal" then
            skin.OutlinedRectangle(x, y, width, height, false, false, true, true)
        end
        
    end

    local function scrollbar(object)

        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local dragging = object.dragging or false
        local hover = object:GetHover()
        local bartype = object:GetBarType()
        local back, border
        
        if dragging then
            back  = {0, 0, 0, 1}
            border = {0.5, 0.5, 0.5, 1}
        elseif hover then
            back  = {0.25, 0.25, 0.25, 1}
            border = {1, 1, 1, 1}
        else
            back  = {0, 0, 0, 1}
            border = {0.75, 0.75, 0.75, 1}
        end
        
        love.graphics.setColor(back)
        love.graphics.rectangle("fill", x, y, width, height)
        love.graphics.setColor(border)
        skin.OutlinedRectangle(x, y, width, height)

        love.graphics.setColor(border)
        skin.OutlinedRectangle(x + 1, y + 1, width - 2, height - 2)
    end

    local function scrollbody(object)

        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local bodycolor = {0, 0, 0, 1}
        
        love.graphics.setColor(bodycolor)
        love.graphics.rectangle("fill", x, y, width, height)
        love.graphics.setColor(1, 1, 1, 1)
        skin.OutlinedRectangle(x, y, width, height)

    end

    local function scrollbutton(object)

        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local hover = object:GetHover()
        local scrolltype = object:GetScrollType()
        local down = object.down
        local back, fore, border
        
        if down then
            back  = {0.75, 0.75, 0.75, 1}
            fore  = {0.25, 0.25, 0.25, 1}
            border = {0.75, 0.75, 0.75, 1}
        elseif hover then
            back  = {1, 1, 1, 1}
            fore  = {0, 0, 0, 1}
            border = {0.75, 0.75, 0.75, 1}
        else
            back  = {0, 0, 0, 1}
            fore  = {1, 1, 1, 1}
            border = {0.75, 0.75, 0.75, 1}
        end
        
        -- button back
        love.graphics.setColor(back)
        love.graphics.rectangle("fill", x, y, width, height)
        -- button border
        love.graphics.setColor(border)
        skin.OutlinedRectangle(x, y, width, height)
        
        local image
        if scrolltype == "up" then
            image = skin.images["arrow-up.png"]
        elseif scrolltype == "down" then
            image = skin.images["arrow-down.png"]
        elseif scrolltype == "left" then
            image = skin.images["arrow-left.png"]
        elseif scrolltype == "right" then
            image = skin.images["arrow-right.png"]
        end
        
        local imagewidth = image:getWidth()
        local imageheight = image:getHeight()
        --image:setFilter("nearest", "nearest")
        love.graphics.setColor(fore)

        love.graphics.draw(image, x + width/2 - imagewidth/2, y + height/2 - imageheight/2)

        love.graphics.setColor(back)
        skin.OutlinedRectangle(x + 1, y + 1, width - 2, height - 2)
    end

    local function customFrame(object)
        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local hover = object:IsTopChild()
        local name = object:GetName()
        local icon = object:GetIcon()
        local font = skin.controls.smallfont
        
        local body   = skin.controls.color_back0
        local top    = hover and skin.controls.color_active or skin.controls.color_fore0
        local fore   = skin.controls.color_back0
        local border = skin.controls.color_back1
        
        -- frame body
        love.graphics.setColor(body)
        love.graphics.rectangle("fill", x, y, width, height)
        
        -- frame top bar
        love.graphics.setColor(top)
        love.graphics.rectangle("fill", x, y, width, 25)
        
        -- frame name section
        love.graphics.setFont(font)
        
        if icon then
            local iconwidth = icon:getWidth()
            local iconheight = icon:getHeight()
            --icon:setFilter("nearest", "nearest")
            love.graphics.setColor(skin.controls.color_image)
            love.graphics.draw(icon, x + 5, y + 5)
            love.graphics.setColor(fore)
            skin.PrintText(name, x + iconwidth + 10, y + 5)
        else
            love.graphics.setColor(fore)
            skin.PrintText(name, x + 5, y + 5)
        end
        
        -- frame border
        love.graphics.setColor(border)
        skin.OutlinedRectangle(x, y, width, height)
        love.graphics.setColor(border)
        skin.OutlinedRectangle(x, y, width, height)
    end

    local levelList = loveframes.Create("list")
    levelList:SetSize(640, 480)
    levelList:SetPadding(8)
    levelList:SetSpacing(8)
    levelList:SetX(shove.getViewportWidth() / 2 - levelList:GetWidth() / 2)
    levelList:SetY(shove.getViewportHeight() / 2 - levelList:GetHeight() / 2)
    levelList.update = function(object, elapsed)
        levelList:SetX(shove.getViewportWidth() / 2 - levelList:GetWidth() / 2)
        levelList:SetY(shove.getViewportHeight() / 2 - levelList:GetHeight() / 2)
    end
    levelList.drawfunc = function(object)
        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local bodycolor = skin.controls.list_body_color
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", x, y, width, height)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", x, y, width, height)
        love.graphics.setColor(1, 1, 1, 1)
    end
    levelList.scrolly.drawfunc = scrollbody
    levelList.scrolly.internals[1].drawfunc = scrollarea
    levelList.scrolly.internals[1].internals[1].drawfunc = scrollbar
    levelList.scrolly.internals[2].drawfunc = scrollbutton
    levelList.scrolly.internals[3].drawfunc = scrollbutton
    --print(inspect(levelList.scrolly))

    local function createLevelButton(name)
        local btn = loveframes.Create("button")
        btn:SetText(name)
        btn:SetHeight(96)
        btn.drawfunc = drawButton
        btn:SetFont(settings.fonts["levelNameFont"])
        btn.OnClick = function(obj)
            --print(inspect(levelList))
        end
        levelList:AddItem(btn)
    end

    local function refreshLevelList()
        local levelsListDir = love.filesystem.getDirectoryItems("user/editor")

        levelList:Clear()
        if #levelsListDir == 0 then
            local listMessage = loveframes.Create("text")
            listMessage:SetFont(settings.fonts["levelNameFont"])
            listMessage:SetText({ color = {1, 1, 1, 255}, languageService["menu_level_list_title"] })
            listMessage:CenterX()
            listMessage.update = function(object, elapsed)
                listMessage:SetX(shove.getViewportWidth() / 2 - listMessage:GetWidth() / 2)
            end
            listMessage:SetY(64)

            return
        end
    
        for _, v in ipairs(levelsListDir) do
            if love.filesystem.getInfo("user/editor/" .. v).type == "file" then
                createLevelButton(v:gsub("%.[^.]+$", ""))
            end
        end
    end

    refreshLevelList()

    local title = loveframes.Create("text")
    title:SetFont(settings.fonts["levelNameFont"])
    title:SetText({ color = {1, 1, 1, 255}, languageService["menu_level_list_title"] })
    title:CenterX()
    title.update = function(object, elapsed)
        title:SetX(shove.getViewportWidth() / 2 - title:GetWidth() / 2)
    end
    title:SetY(64)

    local buttonRefresh = loveframes.Create("button")
    buttonRefresh:SetText(languageService["level_list_item_buttons_refresh"])
    buttonRefresh:SetPos(16, shove.getViewportHeight() - 85)
    buttonRefresh:SetFont(settings.fonts["buttonsFont"])
    buttonRefresh:SetSize(128, 72)
    buttonRefresh.drawfunc = drawButton
    buttonRefresh.OnClick = refreshLevelList

    local createButton = loveframes.Create("button")
    createButton:SetText(languageService["menu_level_list_create"])
    createButton:SetPos(shove.getViewportWidth() - 144, shove.getViewportHeight() - 85)
    createButton:SetFont(settings.fonts["buttonsFont"])
    createButton:SetSize(128, 72)
    createButton.drawfunc = drawButton
    createButton.OnClick = function(obj)
        
    end

    local backButton = loveframes.Create("button")
    backButton:SetText(languageService["level_list_item_buttons_back"])
    backButton:SetPos(16, 16)
    backButton:SetFont(settings.fonts["buttonsFont"])
    backButton:SetSize(96, 72)
    backButton.drawfunc = drawButton
    backButton.OnClick = function()
        gamestate.pop()
    end

end