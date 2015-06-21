--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
INT Types:
	1 -> Burgershot
	2 -> ZIP
	3 -> 24/7 1
	4- > Ammu-Nation 1
	5 -> Clucking Bell
	6 -> SexShop
	7- > Well Stacked Pizza & Co
	8 -> Victim
	9 -> Binco
	10 -> Disco
	11 -> Bar
	12 -> Gym
	13 -> Dnameier Sachs (DS -> Kleiderladen)
	14 -> Strip Club 1
	15 -> Jizzy
	16 -> Steakhouse
	17 -> BDSM Keller
	18 -> Donutshop
	19 -> Sub Urban
	20 -> Caligulas (Casino)
	21 -> Red Dragon (Casino)
	22 -> Casino
	23 -> Train Hard
	24 -> City Department
	25 -> Wettbüro
	26 -> LSPD
	27 -> Sherrif Buero
	28 -> LVPD
	29 -> SFPD
	30 -> Doneasty
]]

CIntMarker = inherit(CMarker)

function CIntMarker:constructor(iId, sName, iType, iInterior, iDimension)
	self.ID = iId
	self.Name = sName
	self.Type = iType
	self.Enabled = false
	self:setInterior(iInterior)
	self:setDimension(iDimension)

	self:setData("intmarkerid", self.ID)

	addEventHandler("onMarkerHit", self, function(theElement) self:onPortHit(theElement) end)
end

function CIntMarker:setPortData(iInt, iDim, fX, fY, fZ, fRot)
	self.DestInterior = iInt
	self.DestDimension = iDim
	self.DestX = fX
	self.DestY = fY
	self.DestZ = fZ
	self.DestRotation = fRot

	self.Enabled = true
end

function CIntMarker:isEnabled()
	return self.Enabled
end

function CIntMarker:getType()
	return self.Type
end

function CIntMarker:onPortHit(theElement)
	if (self:isEnabled() == true) then
		if (theElement:getDimension() == self:getDimension()) then
			if (theElement:getType() == "player") and ( not (isPedInVehicle(theElement)) ) then
				--[[
				fadeCamera ( theElement, false, 1,0,0,0)
				toggleAllControls( theElement, false)
				setTimer(setElementInterior,1200,1, theElement, self.DestInterior, self.DestX, self.DestY, self.DestZ)
				setTimer(function(Dim) theElement:setDimension(Dim) end,1200,1,self.DestDimension)
				setTimer(setElementRotation,1200,1,theElement,0,0,self.DestRotation)
				setTimer(toggleAllControls, 1500, 1, theElement, true)
				setTimer ( fadeCamera, 1300, 1, theElement, true, 2 )

				-]]
				theElement:fadeInPosition(self.DestX, self.DestY, self.DestZ, self.DestDimension, self.DestInterior, self.DestRotation)
				
				if(DEFINE_DEBUG) then
					outputChatBox("Interior ID: "..self.ID)
				end
				theElement.m_iCurIntID = self.ID
		--		outputChatBox(tostring(theElement.m_iCurIntID))
				if(self.DestDimension == 0) then -- Aussen
					theElement.m_iCurIntID = 0;
				end

				if (tonumber(self.DestInterior) ~= 0) then
					showPlayerHudComponent ( theElement, "all", false )
					showPlayerHudComponent ( theElement, "crosshair", true )
				else
					showPlayerHudComponent ( theElement, "all", false )
					showPlayerHudComponent ( theElement, "crosshair", true )
				end
			end
		end
	end
end
