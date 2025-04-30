local function htmlHexToMTA(hex, alpha)
    -- strip leading “#”
    hex = hex:gsub("^#","")
    -- expand short form “abc” → “aabbcc”
    if #hex == 3 then
        hex = hex:sub(1,1):rep(2)
            .. hex:sub(2,2):rep(2)
            .. hex:sub(3,3):rep(2)
    end
    -- parse channels
    local r = tonumber(hex:sub(1,2), 16) or 0
    local g = tonumber(hex:sub(3,4), 16) or 0
    local b = tonumber(hex:sub(5,6), 16) or 0

    return {r, g, b}
end





radarSettings = {
	['mapTexture'] = 'images/radar.png', -- Don't change
	['mapTextureSize'] = 2048, -- Don't change
	['mapWaterColor'] = {77.3,87.1,85.1,0}, -- Adjusted for this map
	['mapColor'] = htmlHexToMTA('#ca8c40'),
	['mapColorScale'] = 1.1, -- Adjusted for this map
	['alpha'] = 240, -- Can change
};






