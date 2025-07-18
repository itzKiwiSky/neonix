---@class FontCache
local FontCache = {
    paths = {},
    pool = {},
}

---Initializes the font cache function, loading all the font paths by name
function FontCache.init()
    FontCache.paths = love.filesystem.getDirectoryItems("assets/fonts")

    for f = 1, #FontCache.paths, 1 do
        FontCache.paths[f] = "assets/fonts/" .. FontCache.paths[f]
    end
end

---Check if the font exist in the path, if not, create a new object font with the size desire ad saves on the pool
---@param name string
---@param size number
---@return love.Font
function FontCache.getFont(name, size)
    for p = 1, #FontCache.paths, 1 do
        local path = FontCache.paths[p]:match("[^/]+$"):gsub(".ttf", "")
        if path == name then
            local fontdata = name .. "-" .. size
            if FontCache.pool[fontdata] then
                return FontCache.pool[fontdata]
            else
                FontCache.pool[fontdata] = love.graphics.newFont(FontCache.paths[p], size)
                return FontCache.pool[fontdata]
            end
        end
    end
    error(string.format("[ERROR] : The font %s is not on the path", _name))
end

return FontCache