-- change some flags to change the engine behavior

local featureFlags = {}
featureFlags.debug = not love.filesystem.isFused()   -- debug stuff will not appear on compiled games --
featureFlags.videoStats = false

return featureFlags
