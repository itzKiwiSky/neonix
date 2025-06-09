return function(type, x, y, offsetX, offsetY, w, h)
    return {
        w = w,
        h = h,
        x = x - offsetX,
        y = y - offsetY,
        type = type
    }
end