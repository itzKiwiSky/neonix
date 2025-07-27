local presence = require 'src.Modules.System.Presence'

return function()
    local jsonfile = json.decode(love.filesystem.read("src/ApiConfig.json"))

    discordRPC.initialize(jsonfile.discord.appid, true)

    presence.largeImageKey = "init_rpc"
    presence()
end