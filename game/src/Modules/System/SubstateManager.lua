local SubstateManager = {}

SubstateManager.queue = {}

-- fetch event callbacks from love.handlers
local loveCallbacks = { 'draw', 'update' }
for k in pairs(love.handlers) do
    loveCallbacks[#loveCallbacks + 1] = k
end

function SubstateManager.init()
    
end

function SubstateManager.registerEvents(callbacks)
    local registry = {}
    callbacks = callbacks or loveCallbacks
    for _, f in ipairs(callbacks) do
        registry[f] = love[f] or __NULL__
        love[f] = function(...)
            registry[f](...)
            return GS[f](...)
        end
    end
end

return SubstateManager