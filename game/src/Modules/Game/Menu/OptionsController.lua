local OptionsController = {}

OptionsController.options = {}

function OptionsController.addOption(cfg)
    local cfg = cfg or 
    {
        name = "Video",
        type = "button",
        action = function()end
    }
end

return OptionsController