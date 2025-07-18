
---@class LoveView
local LoveView = {}

LoveView.isEventRegistered = false  ---@type boolean

LoveView.views = {}     ---@type table<loveView.view>

---@private
local function reloadView(path)
    if love.filesystem.isFused() then
        return
    end

    for _, view in ipairs(LoveView.views) do
        local fileinfo = love.filesystem.getInfo(view.path)
        if fileinfo.modtime > view.lastmod then
            loveframes.RemoveAll()
            LoveView.views[_].lastmod = fileinfo.modtime

            --local chunk = love.filesystem.load(view.path)
            local ok, res = pcall(love.filesystem.load, view.path)
            local chunk = res
            if not ok or type(res) == "nil" then
                print("[ERROR] : " .. res)
                return
            end

            local sucess, err = pcall(chunk())
            if err then
                print(err)
                return
            end
            print("[VIEW] : Updated view")
        end
    end
end

function LoveView.loadView(path)
    assert(loveframes ~= nil, "[ERROR] : Loveframes not found")
    assert(type(path) == "string", "[ERROR] : Expected type 'string' for path, got: " .. type(path))

    -- clear old view --
    loveframes.RemoveAll()
    local fileinfo = love.filesystem.getInfo(path)

    if fileinfo ~= nil then
        local viewstruct = {}

        local ok, res, errmsg = pcall(love.filesystem.load, path)
        if not ok or type(res) == "nil" then 
            print("[ERROR] : Failed to load. " .. res) 
            return
        end
        
        local viewfile = res

        viewstruct.path = path
        viewstruct.lastmod = fileinfo.modtime

        local sucess, err = pcall(viewfile())
        if not sucess then
            print(err)
            return
        end

        LoveView.views[#LoveView.views + 1] = viewstruct
    else
        print("File not found, ignoring it")
    end
end

function LoveView.draw()
    local sucess, err = pcall(loveframes["draw"])
    if err then print(err) end
end

function LoveView.update(elapsed)
    reloadView()
    local sucess, err = pcall(loveframes["update"], elapsed)
    if err then print(err) end
end

function LoveView.registerLoveframesEvents()
    if LoveView.isEventRegistered then
        return
    end

    local function blank() end
    local allowedEvents = { "mousepressed", "mousereleased", "wheelmoved", "textinput", "keypressed", "keyreleased" }
    local ogFuncs = {}
    for _, event in ipairs(allowedEvents) do
        ogFuncs[event] = love[event] or blank
        love[event] = function (...)
            ogFuncs[event](...)
            if loveframes[event] then
                local sucess, err = pcall(loveframes[event], ...)
                if err then
                    print(err)
                end
            end
        end
    end
    LoveView.isEventRegistered = true
end

return LoveView