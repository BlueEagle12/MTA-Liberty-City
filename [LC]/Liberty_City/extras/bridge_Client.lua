Corona = {}


function createThem()
	if getResourceFromName('custom_coronas') then
		Corona[1] = exports.custom_coronas:createCorona(-375.54018790113,-608.0468943387,66.652904601074,3,255,0,0,150,true)
		Corona[2] = exports.custom_coronas:createCorona(-375.54019461236,-652.4933948387,66.652904601074,3,255,0,0,150,true)
		Corona[3] = exports.custom_coronas:createCorona(-859.54480007031,-654.18908095703,66.652904601074,3,255,0,0,150,true)
		Corona[4] = exports.custom_coronas:createCorona(-859.54480007031,-609.74258045703,66.652904601074,3,255,0,0,150,true)
	end
end


addEvent( "createThem", true )
addEventHandler( "createThem", localPlayer, createThem )

function removeThem()
	if getResourceFromName('custom_coronas') then
		for i,v in pairs(Corona) do
			exports.custom_coronas:destroyCorona(v)
			Corona[i] = nil
		end
	end
end
addEvent( "removeThem", true )
addEventHandler( "removeThem", localPlayer, removeThem )




function runBridge()
	for i,v in pairs(getElementsByType('object')) do
		if (getElementID(v) == 'bridge_lift') then
			local lowlod = getLowLODElement (v)
			if lowlod then
				attachElements(lowlod,v)
			end
		end
	end
end

setTimer ( runBridge, 15000, 1)
