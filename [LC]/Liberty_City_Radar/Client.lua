local RADAR_CORE_RESOURCE = "Radar_Core";
local retryTimer;

local function selectLibertyCityRadar()
	local radarCore = getResourceFromName(RADAR_CORE_RESOURCE);
	if (not radarCore or getResourceState(radarCore) ~= "running") then
		return false;
	end

	local ok = call(radarCore, "setRadarConfigResource", getResourceName(getThisResource()));
	if (ok == true and isTimer(retryTimer)) then
		killTimer(retryTimer);
		retryTimer = nil;
	end

	return ok == true;
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if (not selectLibertyCityRadar()) then
			retryTimer = setTimer(selectLibertyCityRadar, 250, 0);
		end
	end
);

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if (isTimer(retryTimer)) then
			killTimer(retryTimer);
		end

		local radarCore = getResourceFromName(RADAR_CORE_RESOURCE);
		if (radarCore and getResourceState(radarCore) == "running") then
			if (call(radarCore, "getRadarConfigResource") == getResourceName(getThisResource())) then
				call(radarCore, "resetRadarConfigResource");
			end
		end
	end
);
