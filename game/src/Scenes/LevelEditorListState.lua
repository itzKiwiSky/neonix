LevelEditorListState = {}

function LevelEditorListState:enter()
    self.loveView = require 'src.Modules.System.Utils.LoveView'

    self.loveView.registerLoveframesEvents()
    self.loveView.loadView("src/Modules/Game/Views/LevelList.lua")

    --self.song = SoundManager.newChannel("mainMenu")
    --self.song:loadSource("future_base")
    --if not self.song.source:isPlaying() then
    --    self.song:play()
    --    self.song:setLooping(true)
    --    self.song:setVolume(gameSave.save.user.settings.audio.musicVolume)
    --end
end

function LevelEditorListState:draw()
    self.loveView.draw()
end

function LevelEditorListState:update(elapsed)
    self.loveView.update(elapsed)
end

return LevelEditorListState