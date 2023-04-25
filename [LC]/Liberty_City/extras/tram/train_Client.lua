
tramList = {}

function addTram(tram)
	tramList[tram] = true
end

addEvent( "addTram", true )
addEventHandler( "addTram", root, addTram )


function calculateRotationDegree(obj1,x,y,z)
	-- Next, calculate the direction vector from obj1 to obj2
	local x1, y1, z1 = getElementPosition(obj1)
	local x2, y2, z2 = x,y,z
	local dx, dy, dz = (x2 - x1), (y2 - y1), (z2 - z1)
	local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
	local direction = { x = dx / distance, y = dy / distance, z = dz / distance }

	return direction.x,direction.y,direction.z
end

starting = {}
currentTar = {}
currentXYZ = {}

duration = 1000

addEventHandler("onClientRender", root, function()
	for object,data in pairs(tramList) do
		if getElementData(object,'targetLoc') then
			local tX,tY,tZ = unpack(getElementData(object,'targetLoc'))
			
			if currentTar[object] then
				local x,y,z = unpack(currentTar[object])
				if (x == tX) and (y == tY) then
					-- Nothing
				else
					starting[object] = getTickCount()
					currentTar[object] = {tX,tY,tZ}
				end
			else
				starting[object] = getTickCount()
				currentTar[object] = {tX,tY,tZ}
			end
			
			local time = tonumber(getElementData(object,'cartSpeed') or 1000)
			local startTime = starting[object]
			local elapsed = getTickCount() - startTime
			local progress = math.min(elapsed/time,1)

			local xr,yr,zr = calculateRotationDegree(object,tX,tY,tZ)
			

			
			
			local cX,cY,cZ = unpack(currentXYZ[object] or {0,0,0})
			
			local pitch = -math.asin(zr) * 180 / math.pi
			local yaw = math.atan2(yr, xr) * 180 / math.pi
			
			
			local x,y,z = interpolateBetween(cX, cY, cZ, pitch, 0, yaw+90, progress, "Linear")
		
			-- Apply the new rotation to the object
			setElementRotation(object, x,y,z)
			
			currentXYZ[object] = {x,y,z}
			print(progress)
		end
	end
end)

