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

    local levelList = loveframes.Create("list")
    levelList:SetSize(640, 480)
    levelList:SetPadding(8)
    levelList:SetSpacing(8)
    levelList:Center()
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


    -- fake --
    for i = 1, 20, 1 do
        local btn = loveframes.Create("button")
        btn:SetText(i)
        btn:SetHeight(96)
        btn.drawfunc = drawButton
        btn.OnClick = function(obj)
            print(inspect(levelList))
        end
        levelList:AddItem(btn)
    end
end