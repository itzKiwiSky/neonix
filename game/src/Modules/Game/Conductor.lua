
---@class game.Conductor
local Conductor = {}

Conductor.bpm = 120
Conductor.measures = 4
Conductor.crochet = ((60 / Conductor.bpm) * 1000)
Conductor.stepCrochet = Conductor.crochet / Conductor.measures
Conductor.safeFrames = 5
Conductor.safeFramesOffset = math.floor((Conductor.safeFrames / 60 ) * 1000)	-- safe frames in milliseconds
Conductor.songPos = 0

Conductor.lastBeat = 0
Conductor.curBeat = 0
Conductor.lastStep = 0
Conductor.curStep = 0

Conductor.offset = 0

local function updateCrochets()
    Conductor.crochet = ((60 / Conductor.bpm) * 1000)
    Conductor.stepCrochet = Conductor.crochet / Conductor.measures
end

function Conductor.update()
    local oldStep = Conductor.curStep
    
    -- no mapped changes for bpm just yet, ain't nobody got time for that
    Conductor.curStep = math.floor(Conductor.songPos / Conductor.stepCrochet)
    Conductor.curBeat = math.floor(Conductor.curStep / Conductor.measures)
    
    updateCrochets()
    
    if oldStep ~= Conductor.curStep and Conductor.curStep > 0 then
        Conductor.stepHit()
    end
end

function Conductor.recalculateSong()
    Conductor.bpm = 120
    Conductor.measures = 4
    Conductor.crochet = ((60 / Conductor.bpm) * 1000)
    Conductor.stepCrochet = Conductor.crochet / Conductor.measures
end

function Conductor.stepHit()
    if Conductor.curStep % Conductor.measures == 0 then
        Conductor.beatHit()
    end
end

function Conductor.beatHit()end

return Conductor