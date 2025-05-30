local function uuid()
    local template ='NX-xxyx3xxx-xxxx-4xxx-yxxx-xyyyxxxxyyxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end