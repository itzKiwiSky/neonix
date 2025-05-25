-- function got from https://gist.github.com/jrus/3197011

function stid()
    local template ='onyx-xyxyyxxx-xxxx-4xxx-yxxx-xxxxxx32xxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

return stid