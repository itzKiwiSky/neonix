local _hitbox = require 'src.Components.Modules.Game.Objects.Hitbox'
local _object = require 'src.Components.Modules.Game.Objects.Object'

return function(id, x, y, angle, collision)
    local o = _object(x, y, angle)
    o.id = id or 1
    o.type = "tile"
    o.collision = collision or true
    o.hitbox = _hitbox("solid", x, y, 16, 16, 32, 32)
    return o
end