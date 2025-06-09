return function(x, y, angle)
    return {
        x = x,
        y = y,
        angle = angle or 0,
        meta = {
            alpha = 0,
            color = "obj",
            selected = false,
            group = 0
        }
    }
end