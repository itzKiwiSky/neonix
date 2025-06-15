local editorState = require 'src.Scenes.EditorState'

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

    local function imgButtonNoteSkin(object)

        local skin = object:GetSkin()
        local x = object:GetX()
        local y = object:GetY()
        local width = object:GetWidth()
        local height = object:GetHeight()
        local text = object:GetText()
        local hover = object:GetHover()
        local image = object:GetImage()
        local imagecolor = object.imagecolor or skin.controls.color_image
        local down = object.down
        local font = object:GetFont() or skin.controls.imagebuttonfont
        local twidth = font:getWidth(object.text)
        local theight = font:getHeight(object.text)
        local checked = object.checked
        local quad = object.quad

        love.graphics.setColor(imagecolor)
        if quad then
            _, _, w, h = quad:getViewport()
            love.graphics.draw(image, quad, x, y, 0, width / w, height / h)
        else
            love.graphics.draw(image, x, y, 0, width / image:getWidth(), height / image:getHeight())
        end
    end

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
    buildButton.OnClick = function(obj)
        editorState.Editor.data.currentEditorMode = "build"
    end
    actionButtonGrid:AddItem(buildButton, 1, 1, "left")

    local editButton = loveframes.Create("button")
    editButton:SetText("Edit")
    editButton:SetFont(settings.fonts["buttonsFont"])
    editButton:SetSize(158, 42)
    editButton.OnClick = function(obj)
        editorState.Editor.data.currentEditorMode = "edit"
    end
    actionButtonGrid:AddItem(editButton, 2, 1, "left")

    local deleteButton = loveframes.Create("button")
    deleteButton:SetText("Delete")
    deleteButton:SetFont(settings.fonts["buttonsFont"])
    deleteButton:SetSize(158, 42)
    deleteButton.OnClick = function(obj)
        editorState.Editor.data.currentEditorMode = "delete"
    end
    actionButtonGrid:AddItem(deleteButton, 3, 1, "left")

    local imageDeco = loveframes.Create("image")
    imageDeco.image = settings.images["decoGradient"]
    imageDeco:SetParent(panelWindow)
    imageDeco:SetX(shove.getViewportWidth() * 0.165)
    imageDeco:SetScale(16, panelWindow:GetHeight())

    local panelObjects = loveframes.Create("panel")
    panelObjects:SetPos(panelWindow:GetWidth() * 0.18 - panelObjects.x, panelWindow.y)
    panelObjects:SetSize(panelWindow:GetWidth() - panelObjects.x, 164)
    panelObjects.drawfunc = settings.blank

    local categoryObjectList = loveframes.Create("list")
    categoryObjectList:SetParent(panelObjects)
    categoryObjectList:SetPos(32, 72)
    categoryObjectList:SetSize(980, 64)
    categoryObjectList:SetPadding(5)
    categoryObjectList:SetSpacing(5)
    categoryObjectList:EnableHorizontalStacking(true)
    categoryObjectList.drawfunc = settings.blank

    --print(inspect(categoryObjectPanel))
    --print(#categoryObjectPanel.children.remove)

    local function renderCategory(type)
        categoryObjectList:Clear()
        for i = 1, #editorState.assets[type].quads, 1 do
            local btn = loveframes.Create("imagebutton")
            btn:SetImage(editorState.assets[type].img)
            btn.quad = editorState.assets[type].quads[i]
            btn:SetSize(40, 40)
            btn.OnClick = function(obj)
                editorState.Editor.data.objID = i
            end
            btn.drawfunc = imgButtonNoteSkin

            categoryObjectList:AddItem(btn)
        end
    end

    renderCategory(editorState.Editor.data.objType)
    for b = 1, 3, 1 do
        local btnCat = loveframes.Create("imagebutton")
        btnCat:SetParent(panelObjects)
        btnCat:SetImage(editorState.assets[settings.types[b]].img)
        btnCat.quad = editorState.assets[settings.types[b]].quads[1]
        btnCat:SetSize(40, 40)
        btnCat:SetY(8)
        btnCat:SetX(-16 + btnCat:GetX() + 48 * b)
        btnCat.OnClick = function(obj)
            editorState.Editor.data.objType = settings.types[b]
            renderCategory(editorState.Editor.data.objType)
        end
        btnCat.drawfunc = imgButtonNoteSkin
    end
end