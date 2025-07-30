return function(levelname)
    return {
        meta = {
            title = levelname or "Unnamed level",
            gameversion = 0,
            requestedDifficulty = 0, -- int range 1 -> 10
            songid = "builtin:flow",   -- it now uses protocol parse to identify song source
            bgConfig = {
                bgFactor = {
                    x = 0.5,
                    y = 0.5
                },
                bgColor = "nx_color:0,0,0"
            },
            levelid = 0,
        },
        level = {
            assets = {},
            values = {},
            bgID = 2,
            events = {},
        },
    }
end