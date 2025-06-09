return function()
    local settings = {
        lpadding = 16,
        blank = function()end,
        fonts = {
            ["buttonsFont"] = fontcache.getFont("comfortaa_regular", 18)
        },
        images = {
            ["gradientBG"] = love.graphics.newGradient("vertical", {0.35, 0.35, 0.35, 1}, {0.1, 0.1, 0.1, 1}),
            ["decoGradient"] = love.graphics.newGradient("horizontal", 
                {0, 0, 0, 0}, 
                {1, 1, 1, 1}, 
                {0, 0, 0, 0}
            )
        },
        types = { "tile", "hazard", "trigger" }
    }

    local panelWindow = loveframes.Create("panel")
    panelWindow:SetSize(shove.getViewportWidth(), 164)
    panelWindow:SetY(shove.getViewportHeight() - panelWindow:GetHeight())
    panelWindow.drawfunc = function(object)
        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local w = object:GetWidth()
        local h = object:GetHeight()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(settings.images["gradientBG"], x, y, 0, w, h)
        love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", x, y, w, h)
        love.graphics.setLineWidth(1)
    end

    local actionButtonGrid = loveframes.Create("grid")
    actionButtonGrid:SetParent(panelWindow)
    actionButtonGrid:SetRows(3)
    actionButtonGrid:SetColumns(1)
    actionButtonGrid:SetCellPadding(12)
    actionButtonGrid:SetY(8)
    actionButtonGrid.drawfunc = settings.blank

    local buildButton = loveframes.Create("button")
    buildButton:SetText("Build")
    buildButton:SetFont(settings.fonts["buttonsFont"])
    buildButton:SetSize(158, 42)
    actionButtonGrid:AddItem(buildButton, 1, 1, "left")

    local editButton = loveframes.Create("button")
    editButton:SetText("Edit")
    editButton:SetFont(settings.fonts["buttonsFont"])
    editButton:SetSize(158, 42)
    actionButtonGrid:AddItem(editButton, 2, 1, "left")

    local deleteButton = loveframes.Create("button")
    deleteButton:SetText("Delete")
    deleteButton:SetFont(settings.fonts["buttonsFont"])
    deleteButton:SetSize(158, 42)
    actionButtonGrid:AddItem(deleteButton, 3, 1, "left")

    local imageDeco = loveframes.Create("image")
    imageDeco.image = settings.images["decoGradient"]
    imageDeco:SetParent(panelWindow)
    imageDeco:SetX(shove.getViewportWidth() * 0.165)
    imageDeco:SetScale(16, panelWindow:GetHeight())


end