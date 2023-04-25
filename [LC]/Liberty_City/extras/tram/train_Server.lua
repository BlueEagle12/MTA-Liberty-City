globalCarts = {}
globalCarts = {}
globalCartTrackInfo = {}

Count = 4 -- How long are the trains?

function runTrain()
	for index,stations in pairs(Tracks) do
		globalCarts[index] = {}
		globalCarts[index]['Power'] = 200 -- Default Speed
		globalCarts[index]['Trains'] = {} -- Trains Table
		globalCarts[index]['Doors'] = {} -- Doors Table
		globalCarts[index]['Track'] = {} 
		for _,stationData in pairs(stations) do
			if stationData[4] == 1 then
				local blip = createBlip(stationData[1],stationData[2],stationData[3],33) -- Mark Stations
			end
		end
		createCarts(index)
	end
	setTimer ( updateClients, 1000, 0)
end

function updateClients()
	for i = 1,#Tracks do
		for ia = 1,Count do
			local tram = globalCarts[i]['Trains'][ia]
			if isElement(tram) then
				triggerClientEvent ( root, "addTram", root,tram )
			end
		end
	end
end


function setSpeed(_,_,Train,Speed)
	if globalCarts[tonumber(Train)] then
		globalCarts[tonumber(Train)]['Power'] = Speed -- Set the Speed
		outputChatBox("Setting speed for train# "..Train.." At "..Speed)
	end
end
addCommandHandler("Speed",setSpeed) -- Stynax , /Speed Train# Speed


function createCarts(TrackNumber)
	globalCartTrackInfo[TrackNumber] = {}
	for i=1,Count do
		globalCartTrackInfo[TrackNumber][i] = 1
		if globalCarts[TrackNumber]['Trains'][i-1]  then
			local x,y,z = getElementOffset(globalCarts[TrackNumber]['Trains'][i-1],0,22,0)
			globalCarts[TrackNumber]['Trains'][i] = exports['eagleLoader']:streamObject('tram',x,y,z,0,0,0) -- Create cart at track subset.
			globalCarts[TrackNumber]['Doors'][i] = {}
			globalCarts[TrackNumber]['Doors'][i][1] = exports['eagleLoader']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #1
			globalCarts[TrackNumber]['Doors'][i][2] = exports['eagleLoader']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #2
		else
			local x,y,z = unpack(Tracks[TrackNumber][1])
			globalCarts[TrackNumber]['Trains'][i] = exports['eagleLoader']:streamObject('tram',x,y,z,0,0,0) -- Create cart at track subset.
			globalCarts[TrackNumber]['Doors'][i] = {}
			globalCarts[TrackNumber]['Doors'][i][1] = exports['eagleLoader']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #1
			globalCarts[TrackNumber]['Doors'][i][2] = exports['eagleLoader']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #2
		end
		
		
		local Cart = globalCarts[TrackNumber]['Trains'][i]
		globalCarts[Cart] = {TrackNumber,i} -- Defines which track the cart is on, and which subsection.
		attachElements(globalCarts[TrackNumber]['Doors'][i][1],Cart,0,0,0)	-- Attach Door #1
		attachElements(globalCarts[TrackNumber]['Doors'][i][2],Cart,0,0.8,0)	-- Attach Door #2
		createBlipAttachedTo(Cart,56) -- Attach Blip to cart
	end
end


function checkDistance(cords1,cords2)
	local x,y,z = unpack(cords1)
	local tX,tY,tZ = unpack(cords2)
	local distance = getDistanceBetweenPoints3D(x,y,z,tX,tY,tZ)
	return distance
end

function getObjectDistance(obj1,obj2)
	local x,y,z = getElementPosition(obj1)
	local x2,y2,z2 = getElementPosition(obj2)
	return getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
end

cartMoved = {}

function checkCarts()
	for track,train in pairs(Tracks) do
		if globalCarts[track] then
			for index,cart in pairs(globalCarts[track]['Trains']) do
				local currentTrack = globalCartTrackInfo[track][index]
				local x,y,z = getElementPosition(cart)
				local tX,tY,tZ = unpack(Tracks[track][currentTrack])
				local distance = getDistanceBetweenPoints3D(x,y,z,tX,tY,tZ)
				if (distance < 5) or (not cartMoved[cart]) then
					globalCartTrackInfo[track][index] = currentTrack + 1
					stopObject(cart)
					moveCart(cart,track,index,globalCartTrackInfo[track][index])
				end
			end
		end
	end
end

setTimer ( checkCarts, 100 , 0)

function moveCart(cart,track,index,currentTrack)
	cartMoved[cart] = true
	local Speed = globalCarts[track]['Power']
	local x,y,z = getElementPosition(cart)
	local tX,tY,tZ = unpack(Tracks[track][currentTrack])
	local distance = getDistanceBetweenPoints3D(x,y,z,tX,tY,tZ)
	setElementData(cart,'targetLoc',{tX,tY,tZ})


	local previousCart = globalCarts[track]['Trains'][index-1]
	if previousCart then
		cartDistance = -(getObjectDistance(cart,previousCart)-25)/25
	else
		cartDistance = 0
	end
	

	local cartSpeed = (distance*Speed)+cartDistance
	setElementData(cart,'cartSpeed',cartSpeed)
	moveObject (cart,cartSpeed,tX,tY,tZ)
end

--[[

function timer(Cart,CartID)
	local Track,SubSet = unpack(Assigned[Cart])
	
	local Speed = Trains[Track]['Power']

	getTrack(Cart) -- Define the carts track
	local Track,SubSet = unpack(Assigned[Cart])

	local TheTrack = Tracks[Track][SubSet]

	local CartX,CartY,CartZ = getElementPosition(Cart)
	local TrackX,TrackY,TrackZ = TheTrack[1],TheTrack[2],TheTrack[3]
	local Distance = getDistanceBetweenPoints3D (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Distance

	local PreviousTrain = Trains[Track]['Trains'][CartID-1]
	if PreviousTrain then
		CartDistance = getDistance(Cart,PreviousTrain)*25
	else
		CartDistance = 0
	end
	
	local CartSpeed = (Distance*Speed)+CartDistance
	
	if (CartID > 1) then
		moveObject (Cart,CartSpeed,TheTrack[1],TheTrack[2],TheTrack[3])
	else
		local xr,yr,zr = getElementRotation(Cart)
		local Xr,Yr,Zr = GetRotation2 (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Rotation

		moveObject (Cart,CartSpeed,TheTrack[1],TheTrack[2],TheTrack[3])
	end
	
	Trains[Track]['Timer'][CartID] = setTimer (timer,CartSpeed-5, 1,Cart,CartID)

	if TheTrack[4] == 1 and CartID == 1 then -- If it's a station, and this is the 3rd cart stop the train
		for i=1,Count do
			stopObject(Trains[Track]['Trains'][i])
			killTimer(Trains[Track]['Timer'][i])
			setTimer ( timer, 30000, 1,Trains[Track]['Trains'][i],i)
		end

		OpenDoors(Track)
		setTimer ( CloseDoors, 28000, 1,Track)
	end
end


function getClosestTrain(player)
	Distance = 50
	Assigned2 = 0
	for i,v in pairs(Tracks[1]) do
		local x,y,z = v[1],v[2],v[3]
		local xa,ya,za = getElementPosition(player)
		local distance = getDistanceBetweenPoints3D ( x,y,z,xa,ya,za)
		if distance < Distance then
			Distance = distance
			Assigned2 = i
		end
	end
	print(Assigned2)
end

addCommandHandler ( "getTrainStation", getClosestTrain )

setTimer ( runTrain, 15000, 1)
]]--

setTimer ( runTrain, 15000, 1)