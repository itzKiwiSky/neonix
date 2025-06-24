LevelEditorListState = {}

function LevelEditorListState:enter()
    self.viewManager = require 'src.Modules.System.Utils.ViewManager'

    self.viewManager.load("src/Modules/Game/Views/Static/LevelList.lua")

    --self.song = SoundManager.newChannel("mainMenu")
    --self.song:loadSource("future_base")
    --if not self.song.source:isPlaying() then
    --    self.song:play()
    --    self.song:setLooping(true)
    --    self.song:setVolume(gameSave.save.user.settings.audio.musicVolume)
    --end
end

function LevelEditorListState:draw()
    self.viewManager.draw()
end

function LevelEditorListState:update(elapsed)
    self.viewManager.update(elapsed)
    self.viewManager.reloadViews()
end

function LevelEditorListState:mousepressed(x, y, button)
    self.viewManager.mousepressed(x, y, button)
end

function LevelEditorListState:mousereleased(x, y, button)
    self.viewManager.mousereleased(x, y, button)
end

function LevelEditorListState:keypressed(k)
    self.viewManager.keypressed(k)
end

function LevelEditorListState:keyreleased(k)
    self.viewManager.keyreleased(k)
end


function LevelEditorListState:textinput(t)
    self.viewManager.textinput(t)
end

return LevelEditorListState