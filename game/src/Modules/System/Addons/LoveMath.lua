function love.math.wave(l, h, t, fn)
    fn = fn or function(t) return -math.cos(t) end
    return l + (fn(t) + 1) / 2 * (h - l)
end

return love.math