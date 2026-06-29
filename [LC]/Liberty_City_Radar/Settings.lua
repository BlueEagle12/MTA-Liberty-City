

local MAPDIR = ':' .. getResourceName(getThisResource()) .. '/images/';

local function attr(node, name)
	if (not node) then return nil; end
	local v = xmlNodeGetAttribute(node, name);
	if (v == false or v == nil or v == '') then return nil; end
	return v;
end

local function numAttr(node, name, default)
	local v = attr(node, name);
	return v and tonumber(v) or default;
end

local function strAttr(node, name, default)
	return attr(node, name) or default;
end

local function boolAttr(node, name, default)
	local v = attr(node, name);
	if (not v) then return default; end
	v = string.lower(v);
	return (v == 'true' or v == '1' or v == 'yes');
end

local function colorChild(parent, name, default)
	local node = parent and xmlFindChild(parent, name, 0);
	if (not node) then return default; end
	local c = {
		numAttr(node, 'r', default[1]),
		numAttr(node, 'g', default[2]),
		numAttr(node, 'b', default[3]),
	};
	local a = attr(node, 'a');
	if (a) then
		c[4] = tonumber(a);
	elseif (default[4] ~= nil) then
		c[4] = default[4];
	end
	return c;
end

local function splitList(s, default)
	if (not s) then return default; end
	local t = {};
	for item in string.gmatch(s, '[^,]+') do
		item = item:gsub('^%s+', ''):gsub('%s+$', '');
		if (item ~= '') then t[#t + 1] = item; end
	end
	if (#t == 0) then return default; end
	return t;
end

local function loadConfig()
	local root = xmlLoadFile('config.xml');
	if (not root) then
		outputDebugString('[Liberty_City_Radar] config.xml could not be loaded; using built-in defaults.', 2);
	end

	local function child(name)
		return root and xmlFindChild(root, name, 0);
	end

	local nMap        = child('map');
	local nAppearance = child('appearance');
	local nArtwork    = child('artwork');
	local nSizes      = child('sizes');
	local nMinimap    = child('minimap');
	local nBigmap     = child('bigmap');
	local nStats      = child('stats');
	local nColors     = child('colors');
	local nKeys       = child('keys');
	local nBehaviour  = child('behaviour');

	local iconFolder = strAttr(nArtwork, 'iconFolder', 'images/');
	local mapColor = colorChild(nAppearance, 'mapColor', { 202, 140, 64 });

	local s = {
		['mapTexture']     = MAPDIR .. strAttr(nMap, 'texture', 'radar.png'),
		['mapTextureSize'] = numAttr(nMap, 'textureSize', 2048),
		['worldSize']      = numAttr(nMap, 'worldSize', 6000),

		['mapWaterColor'] = colorChild(nAppearance, 'waterColor', { 77.3, 87.1, 85.1, 0 }),
		['mapColor']      = mapColor,
		['mapColorScale'] = numAttr(nAppearance, 'mapColorScale', 1.1),
		['alpha']         = numAttr(nAppearance, 'alpha', 240),
		['showStats']     = boolAttr(nAppearance, 'showStats', false),

		['imageFolder']     = iconFolder,
		['arrowImage']      = iconFolder .. strAttr(nArtwork, 'arrow',     'arrow.png'),
		['playerBlipImage'] = iconFolder .. strAttr(nArtwork, 'player',    '2.png'),
		['raceStartImage']  = iconFolder .. strAttr(nArtwork, 'raceStart', '53.png'),
		['warpImage']       = iconFolder .. strAttr(nArtwork, 'warp',      '56.png'),

		['defaultBlipSize'] = numAttr(nSizes, 'defaultBlip', 20),
		['playerBlipSize']  = numAttr(nSizes, 'playerBlip',  25),
		['playerDotSize']   = numAttr(nSizes, 'playerDot',   20),
		['arrowSize']       = numAttr(nSizes, 'arrow',       20),
		['markerSize']      = numAttr(nSizes, 'marker',      20),
		['markerHoverSize'] = numAttr(nSizes, 'markerHover', 40),

		['minimap'] = {
			baseWidth  = numAttr(nMinimap, 'baseWidth',  200),
			baseHeight = numAttr(nMinimap, 'baseHeight', 200),
			margin     = numAttr(nMinimap, 'margin',     20),
			zoom       = numAttr(nMinimap, 'zoom',       5),
			minZoom    = numAttr(nMinimap, 'minZoom',    2),
			maxZoom    = numAttr(nMinimap, 'maxZoom',    10),
		},

		['bigmap'] = {
			margin   = numAttr(nBigmap, 'margin',   20),
			zoom     = numAttr(nBigmap, 'zoom',     2),
			minZoom  = numAttr(nBigmap, 'minZoom',  0.2),
			maxZoom  = numAttr(nBigmap, 'maxZoom',  5),
			panClamp = numAttr(nBigmap, 'panClamp', 3000),
		},

		['statsBarHeight'] = numAttr(nStats, 'barHeight', 10),

		['colors'] = {
			raceLineBig   = colorChild(nColors, 'raceLineBig',   { 255, 75, 0, 240 }),
			raceLineSmall = colorChild(nColors, 'raceLineSmall', { 0, 100, 255, 240 }),
			border        = colorChild(nColors, 'border',        { 0, 0, 0, 255 }),
			warp          = colorChild(nColors, 'warp',          { 255, 255, 0 }),
			marker        = colorChild(nColors, 'marker',        { 255, 255, 255, 240 }),
			player        = colorChild(nColors, 'player',        { 255, 165, 0, 255 }),
			hint          = colorChild(nColors, 'hint',          { 150, 150, 150, 255 }),
		},

		['keys'] = {
			toggleBigmap = strAttr(nKeys, 'toggleBigmap', 'F11'),
			zoomIn       = splitList(attr(nKeys, 'zoomIn'),  { 'mouse_wheel_up', '+', 'num_add' }),
			zoomOut      = splitList(attr(nKeys, 'zoomOut'), { 'mouse_wheel_down', '-', 'num_sub' }),
			unlockCursor = strAttr(nKeys, 'unlockCursor', 'lctrl'),
		},

		['radarRadiusOnFoot']     = numAttr(nBehaviour, 'radarRadiusOnFoot',     180),
		['radarRadiusMaxSpeed']   = numAttr(nBehaviour, 'radarRadiusMaxSpeed',   360),
		['minimapZoomSpeed']      = numAttr(nBehaviour, 'minimapZoomSpeed',      2.0),
		['warpAltitudeThreshold'] = numAttr(nBehaviour, 'warpAltitudeThreshold', 100),
	};

	if (root) then xmlUnloadFile(root); end
	return s;
end

local radarSettings = loadConfig();

function getRadarSettings()
	return radarSettings;
end
