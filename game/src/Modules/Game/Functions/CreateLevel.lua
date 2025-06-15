return function(levelname)
    return {
        meta = {
            title = levelname or "Unnamed level",
            gameversion = 0,
            requestedDifficulty = 0, -- int range 1 -> 5
            songid = "builtin:none",   -- it now uses protocol parse to identify song source
            bgConfig = {
                bgFactor = {
                    x = 0.5,
                    y = 0.5
                },
                bgOffsetX = 0,
                bgOffsetY = 256
            },
            levelid = 0,
        },
        level = {
            startPos = {640 - 16, 384 - 16},
            endPos = {1584, 384 - 16},
            bgID = 1,
            colorChannels = {
                ["bg"] = {60 / 255, 205 / 255, 168 / 255},
                ["obj"] = {255 / 255, 255 / 255, 255 / 255},
                ["finalObj"] = {191 / 255, 113 / 255, 216 / 255},
                ["ground"] = {255 / 255, 255 / 255, 255 / 255}
            },
            startGamemode = "cube",
            startSpeed = 0, -- range from 0 to 4
            gravityFlipped = false,
        },
        objects = {
        },
    }
end