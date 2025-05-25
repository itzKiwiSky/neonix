local function _copyTable(_tbl, _count)
    local tblOftbl = {}
    for t = 1, _count, 1 do
        table.insert(tblOftbl, _tbl)
    end
    return tblOftbl
end

local function _devide(list, factor)
    for i, v in ipairs(list) do 
        list[i] = list[i] * factor 
    end
end

local SpectrumVisualizer = class:extend("SpectrumVisualizer")

function SpectrumVisualizer:__construct(_songPath, _size, _barCount)
    self.barCount = _barCount
    self.size = _size
    self.soundData = love.sound.newSoundData(_songPath)
    self.frequency = 44100
    self.length = self.size / self.frequency
    self.assets = {
        ["gradientBar"] = love.graphics.newGradient("vertical", unpack(_copyTable({50 / 255, 50 / 255, 50 / 255, 255}, 15)), unpack( _copyTable({100 / 255, 100 / 255, 100 / 255, 255}, 5)), {167 / 255, 167 / 255, 167 / 255, 255})
    }
    self.spectrum = {}
end

function SpectrumVisualizer:draw(_x, _y, _barSize, _amplitude)
    for b = 0, self.barCount, 1 do
        if self.spectrum[b + 1] then
            love.graphics.draw(self.assets["gradientBar"], b * _barSize + _x, _y, 0, _barSize, -1 * (self.spectrum[b + 1]:abs() * _amplitude))
        end
    end
end

function SpectrumVisualizer:getBar(_index)
    return self.spectrum[_index]
end

function SpectrumVisualizer:update(elapsed, _songData)
    local mpos = _songData:tell("samples")
    local msize = self.soundData:getSampleCount()

    local values = {}

    for v = mpos, mpos + (self.size - 1), 1 do
        local copyPos = v
        if v + 2048 > msize then v = msize / 2 end

        values[#values + 1] = complex.new(self.soundData:getSample(v * 2), 0)
    end

    self.spectrum = luafft.fft(values, false)
    _devide(self.spectrum, 10)
end

return SpectrumVisualizer