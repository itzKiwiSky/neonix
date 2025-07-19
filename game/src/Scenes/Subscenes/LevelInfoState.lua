LevelInfoState = {}

function LevelInfoState:enter()
    self.viewManager = require 'src.Modules.System.Utils.ViewManager'

    self.viewManager.load("src/Modules/Game/Views/LevelInfo.lua")

    --self.song = SoundManager.newChannel("mainMenu")
    --self.song:loadSource("future_base")
    --if not self.song.source:isPlaying() then
    --    self.song:play()
    --    self.song:setLooping(true)
    --    self.song:setVolume(gameSave.save.user.settings.audio.musicVolume)
    --end
end

function LevelInfoState:draw()
    self.viewManager.draw()
end

function LevelInfoState:update(elapsed)
    self.viewManager.update(elapsed)
    self.viewManager.reloadViews()
end

function LevelInfoState:mousepressed(x, y, button)
    self.viewManager.mousepressed(x, y, button)
end

function LevelInfoState:mousereleased(x, y, button)
    self.viewManager.mousereleased(x, y, button)
end

function LevelInfoState:keypressed(k)
    self.viewManager.keypressed(k)
end

function LevelInfoState:keyreleased(k)
    self.viewManager.keyreleased(k)
end


function LevelInfoState:textinput(t)
    self.viewManager.textinput(t)
end

function LevelInfoState:wheelmoved(x, y)
    self.viewManager.wheelmoved(x, y)
end

return LevelInfoState