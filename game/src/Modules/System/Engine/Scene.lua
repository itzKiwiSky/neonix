local Scene = {}
Scene.scenes = {}
Scene.stack = {}
Scene.stackPointer = 1
Scene.events = {}
Scene._lastSceneName = "root"

-- fetch love callbacks --
for e in pairs(love.handlers) do
    Scene.events[#Scene.events + 1] = e
end

local function changeScene()
    local currentPointScene = Scene.stackPointer
end

function Scene.createScene(name, func)
    Scene.scenes[name] = ecs.world()
    Scene.scenes[name]:clear()
    -- passes a last scene name --
    Scene.scenes[name]:emit("enter", Scene._lastSceneName)
end

function Scene.push(name)
    if Scene.scenes[name] then
        table.push(Scene.stack, name)
        changeScene()
    end
end

function Scene.trigger()
    
end

return Scene