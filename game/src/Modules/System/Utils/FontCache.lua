local FontCache = {
    paths = {},
    imgpaths = {},
    pool = {},
    bmppool = {},
}

local template = [[!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]]

function FontCache.init()
    FontCache.paths = love.filesystem.getDirectoryItems("assets/fonts")

    for f = 1, #FontCache.paths, 1 do
        FontCache.paths[f] = "assets/fonts/" .. FontCache.paths[f]
    end
end

function FontCache.registerImageFont(name, path)
    FontCache.imgpaths[name] = path
end

function FontCache.getImageFont(n, size)
    if FontCache.paths[n] then
        if FontCache.bmppool[name .. "-" .. size] then
            return FontCache.bmppool[name .. "-" .. size]
        else
            FontCache.bmppool[name .. "-" .. size] = love.graphics.newImageFont()
            return FontCache.bmppool[name .. "-" .. size]
        end
    end
end

function FontCache.getFont(_name, _size)
    for p = 1, #FontCache.paths, 1 do
        local path = FontCache.paths[p]:match("[^/]+$"):gsub(".ttf", "")
        if path == _name then
            local fontdata = _name .. "-" .. _size
            if FontCache.pool[fontdata] then
                return FontCache.pool[fontdata]
            else
                FontCache.pool[fontdata] = love.graphics.newFont(FontCache.paths[p], _size)
                return FontCache.pool[fontdata]
            end
        end
    end
    error(string.format("[ERROR] : The font %s is not on the path", _name))
end

return FontCache