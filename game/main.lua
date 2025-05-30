require('src.Modules.System.Run')

local function preloadAudio(target)
    --local files = fsutil.scanFolder("assets/sounds/Tracks", false)
    local files = love.filesystem.getDirectoryItems("assets/sounds/Tracks")

    for f = 1, #files, 1 do
        local filename = (((files[f]:lower()):gsub(" ", "_")):gsub("%.[^.]+$", "")):match("[^/]+$")
        loveloader.newSource(target, filename, "assets/sounds/Tracks/" .. files[f], "stream")
        if FEATURE_FLAGS.debug then
            io.printf(string.format("{bgBrightMagenta}{brightCyan}{bold}[LOVE]{reset}{brightWhite} : Audio file queue to load with {brightGreen}sucess{reset} | {bold}{underline}{brightYellow}%s{reset}\n", filename))
        end
    end
end

function love.initialize()
    SoundManager = require 'src.Modules.System.Utils.Sound'
    SoundManager.sourceList = {}
    local save = require 'src.Modules.System.Utils.Save'

    preloadAudio(SoundManager.sourceList)

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
                discordRichPresence = true,
                gamepadSupport = false,
            }
            }
        }
    }

    gameSave:initialize()

    registers = {
        user = {
            roundStarted = false,
            paused = false,
        },
        system = {
            showDebugHitbox = false,
            gameTime = 0,
            editor = {
                fileDialogOpen = false,
                fileDialogSave = false,
                metaDataWindow = false,
                addNewColorChannel = false,
                newColorChannelTag = "",
                colorChannelColorPicker = false,
                colorChannelCreateCurrentColor = {1, 1, 1, 1},
                editColorChannelPicker = false,
                currentKey = 0,
                currentSelectedLevelID = 0,
                saveName = "",
                useCustomSongFlag = false,
            }
        }
    }

    loveloader.start(function()
        AUDIO_LOADED = true
    end, function(k, h, n)
        if FEATURE_FLAGS.debug then
            io.printf(string.format("{bgBrightMagenta}{brightCyan}{bold}[LOVE]{reset}{brightWhite} : Audio file loaded with {brightGreen}sucess{reset} | {bold}{underline}{brightYellow}%s{reset}\n", n))
        end
    end)


    local languageManager = require 'src.Modules.System.Utils.LanguageManager'
    languageService = languageManager.getData(gameSave.save.user.settings.misc.language)

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

    love.filesystem.createDirectory("user")
    love.filesystem.createDirectory("user/editor")
    love.filesystem.createDirectory("user/saved")
    love.filesystem.createDirectory("user/songs")

    gamestate.registerEvents()
    gamestate.switch(LoadingState)
end