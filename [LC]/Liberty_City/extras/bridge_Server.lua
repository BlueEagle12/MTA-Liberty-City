
Bridges = {}
Original = {}
GlobalPos = {}


function runBridge()
	for i,v in pairs(getElementsByType('object')) do
		if (getElementID(v) == 'bridge_lift') then

			Bridges[#Bridges+1] = v
			local x,y,z = getElementPosition(v)
			Original[v] = {x,y,z}
			GlobalPos = {x,y,z}
		end
	end
end

function moveBridgeBack(V)
	local x,y,z = unpack(Original[v] or GlobalPos)
	moveObject ( V, 5000, x,y,z )
end


function moveBridge()
	for i,v in pairs(Bridges) do
		local x,y,z = unpack(Original[v] or GlobalPos)
		moveObject ( v, 5000, x,y,z+50 )
		setTimer ( moveBridgeBack, 20000, 1,v)
	end
end

function moveBridgeA()
	setTimer ( moveBridge, 1000, 1)
	setTimer ( moveBridgeA, 200000+(math.random(0,10000)), 1)
end

setTimer ( moveBridgeA, 300000, 1)

setTimer ( runBridge, 15000, 1)