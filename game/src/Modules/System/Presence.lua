local Presence = {
    state = "",
    details = "",
    largeImageKey = "init",
    largeImageText = "",
    smallImageKey = "",
    smallImageText = ""
}

local presenceCall = {
    __call = function()
        discordRPC.updatePresence(Presence)
    end
}

setmetatable(Presence, presenceCall)

return Presence