require('src.Modules.System.Run')

function love.initialize()
    local save = require 'src.Modules.System.Utils.Save'

    gameSave = save.new("game")

    gameSave.save = {
        clientID = stid(),
        user = {
            settings = {
            video = {
                resolution = 1,
                fullscreen = false,
                vsync = false,
                fpsCap = 200,
                antialiasing = true,
            },
            audio = {
                masterVolume = 75,
                musicVolume = 50,
                sfxVolume = 50,
            },
            misc = {
                language = "English",
                gamejolt = {
                    username = "",
                    usertoken = ""
                },
                subtitles = true,
                discordRichPresence = true,
                gamepadSupport = false,
                cacheNight = false,
            }
            }
        }
    }

    gameSave:initialize()

    registers = {}

    -- autoload states --
    local states = love.filesystem.getDirectoryItems("src/Scenes")
    for s = 1, #states, 1 do
        require("src.Scenes." .. states[s]:gsub(".lua", ""))
    end

    oldGetPosition = love.mouse.getPosition
    love.mouse.getPosition = function()
        local inside, mx, my = shove.mouseToViewport()
        return mx, my
    end

    gamestate.registerEvents()
    gamestate.switch(SplashState)
end