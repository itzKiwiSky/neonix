local lgSetColor = love.graphics.setColor

function love.graphics.getQuads(filename)
    local image = love.graphics.newImage(filename .. ".png")
    local jsonData = love.filesystem.read(filename .. ".json")
    local sparrow = json.decode(jsonData)

    local Quads = {}
    for i = 1, #sparrow.frames, 1 do
        local Quad = love.graphics.newQuad(
            sparrow.frames[i].frame.x,
            sparrow.frames[i].frame.y,
            sparrow.frames[i].frame.w,
            sparrow.frames[i].frame.h,
            image
        )

        table.insert(Quads, Quad)
    end
    return image, Quads
end

function love.graphics.getQuadsFromHash(filename)
    local image = love.graphics.newImage(filename .. ".png")
    local jsonData = love.filesystem.read(filename .. ".json")
    local sparrow = json.decode(jsonData)

    local quads = {}
    for key, obj in pairs(sparrow.frames) do
        if obj.trimmed then
            quads[key:gsub("%.[^.]+$", "")] = {
                quad = love.graphics.newQuad(
                    obj.frame.x,
                    obj.frame.y,
                    obj.frame.w,
                    obj.frame.h,
                    image
                ),
                sw = obj.sourceSize.w,
                sh = obj.sourceSize.h,
                w = obj.spriteSourceSize.w,
                h = obj.spriteSourceSize.h,
            }
        else
            quads[key:gsub("%.[^.]+$", "")] = love.graphics.newQuad(
                obj.frame.x,
                obj.frame.y,
                obj.frame.w,
                obj.frame.h,
                image
            )
        end
    end

    return image, quads
end

function love.graphics.getQuadsFromAtlas(atlas, splitX, splitY)
    local image = love.graphics.newImage(atlas)
    splitX, splitY = splitX or image:getWidth(), splitY or image:getHeight()
    local quads = {}
    
    local frameWidth = image:getWidth() / splitX
    local frameHeight = image:getHeight() / splitY

    for y = 0, splitY - 1, 1 do
        for x = 0, splitX - 1, 1 do
            local quad = love.graphics.newQuad(
                x * frameWidth,
                y * frameHeight,
                math.floor(image:getWidth() / splitX),
                math.floor(image:getHeight() / splitY),
                image
            )

            table.insert(quads, quad)
        end
    end

    return image, quads
end

function love.graphics.newGradient(dir, ...)
    -- Check for direction
    local isHorizontal = true
    if dir == "vertical" then
        isHorizontal = false
    elseif dir ~= "horizontal" then
        error("bad argument #1 to 'gradient' (invalid value)", 2)
    end

    -- Check for colors
    local colorLen = select("#", ...)
    if colorLen < 2 then
        error("color list is less than two", 2)
    end

    -- Generate mesh
    local meshData = {}
    if isHorizontal then
        for i = 1, colorLen do
            local color = select(i, ...)
            local x = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {x, 1, x, 1, color[1], color[2], color[3], color[4] or 1}
            meshData[#meshData + 1] = {x, 0, x, 0, color[1], color[2], color[3], color[4] or 1}
        end
    else
        for i = 1, colorLen do
            local color = select(i, ...)
            local y = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {0, y, 0, y, color[1], color[2], color[3], color[4] or 1}
            meshData[#meshData + 1] = {1, y, 1, y, color[1], color[2], color[3], color[4] or 1}
        end
    end

    -- Resulting Mesh has 1x1 image size
    return love.graphics.newMesh(meshData, "strip", "static")
end

--[[
function love.graphics.setHexColor(_r, _g, _b, _a)

    local function _normalizeColor(value)
        if type(value) == "number" then
            if value >= 0 and value <= 1 then
                return value
            elseif value >= 0 and value <= 255 then
                return value
            else
                error("Color value must be between 0 and 1 or between 0 and 255.")
            end
        else
            error("Color value must be a number.")
        end
    end

    if type(_r) == "string" then
        local r, g, b, a = _r:match("#(%x%x)(%x%x)(%x%x)(%x%x)")
        if r then
            r = tonumber(r, 16) / 0xff
            g = tonumber(g, 16) / 0xff
            b = tonumber(b, 16) / 0xff
            if a then
                a = tonumber(a, 16) / 0xff
            end
        end
        lgSetColor(r, g, b, a or 1)
    end
end
]]--
return love.graphics