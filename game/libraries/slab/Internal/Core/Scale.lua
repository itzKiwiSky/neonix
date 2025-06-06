
--[[

MIT License

Copyright (c) 2019-2021 Love2D Community <love2d.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]


local CurrentScale = 1


local Scale = {}

function Scale.SetScale(newScale)
    assert(type(newScale) == "number", "Scale needs to be a number!")
    CurrentScale = newScale
end

function Scale.GetScale()
    return CurrentScale or 1
end

function Scale.GetScreenWidth()
    return love.graphics.getWidth() / Scale.GetScale()
end

function Scale.GetScreenHeight()
    return love.graphics.getHeight() / Scale.GetScale()
end

function Scale.GetScreenDimensions()
    return Scale.GetScreenWidth(), Scale.GetScreenHeight()
end


return Scale

