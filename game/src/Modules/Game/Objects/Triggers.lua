local _hitbox = require 'src.Components.Modules.Game.Objects.Hitbox'
local _object = require 'src.Components.Modules.Game.Objects.Object'

return function(id, x, y, angle, collision)
    local o = _object(x, y, angle)
    o.id = id or 1
    o.type = "trigger"
    o.properties = {}

    switch(o.id, {
        [1] = function()
            o.properties.offsetX = 0
            o.properties.offsetY = 0
            o.properties.moveTime = 0
            o.properties.type = "linear"
            o.properties.zoom = 1
        end,
        [2] = function()
            o.properties.channelTarget = {}
            o.properties.targetColor = {1, 1, 1, 1}
            o.properties.fadeTime = 0
        end
    })

    return o
end