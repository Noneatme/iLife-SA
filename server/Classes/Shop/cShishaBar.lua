--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CShishaBar = {}

function CShishaBar:constructor()
	self.outside_to_int = createMarker ( 986.2998046875, -1553.900390625, 21.29999999237061, "corona", 1, 146, 146, 146, 255 )
	self.int_to_entrance = createMarker ( 968.7001953125, -1554.900390625, 0.69999998807907, "corona", 1, 146, 146, 146, 255 )
	self.int_to_outside = createMarker ( 975.599609375, -1554.400390625, 0.69999998807907, "corona", 1, 146, 146, 146, 255 )
	self.entrance_to_int = createMarker ( 972.20001220703, -1544.1999511719, 13.500000190735, "corona", 1, 146, 146, 146, 255 )

	self.SmokeMarkers = {}

	self.bStartSmoke = bind(CShishaBar.StartSmoke, self)
	self.bSmokePhase2 = bind(CShishaBar.SmokePhase2, self)
	self.bDestroySmoke = bind(CShishaBar.DestroySmoke, self)
	
	--Deprecated -> Use CIntMarker instead. Unnecessary because it is a singleton class.
	--Todo for further Versions.
	addEventHandler("onMarkerHit", self.int_to_outside, 
		function( player, matching)
			if (matching and getElementType( player ) == "player") then
				player:fadeInPosition(984.79998779297, -1553.9000244141, 21.799999237061, 0, 0)
			end
		end
	)
	 
	addEventHandler("onMarkerHit", self.outside_to_int, 
		function( player, matching )
			if (matching and getElementType( player ) == "player") then
				player:fadeInPosition(973.90002441406, -1554.8000488281, 1.2000000476837, 0, 0)
			end
		end
	)
	 
	addEventHandler("onMarkerHit", self.entrance_to_int, 
		function( player, matching )
			if (matching and getElementType( player ) == "player") then
				if (not player:payMoney(50)) then return end
				player:fadeInPosition( 971.09997558594, -1554.6999511719, 1.2000000476837, 0, 0)
			end
		end
	)
	
	addEventHandler("onMarkerHit", self.int_to_entrance, 
		function( player, matching)
			if (matching and getElementType( player ) == "player") then
				player:fadeInPosition( 972.29998779297, -1542.8000488281, 13.60000038147, 0, 0)
			end
		end
	)
	
end

function CShishaBar:destructor()

end
 
function CShishaBar:addSmokeMarker ( x,y,z,size )
	local marker = createMarker ( x,y,z, "cylinder", size, 0, 0, 0, 0 )
	table.insert(self.SmokeMarkers, marker)
	addEventHandler("onMarkerHit", marker, self.bStartSmoke)
end
 
function CShishaBar:StartSmoke ( hitElement, matching )
	if (matching and (getElementType(hitElement) == "player") ) then
        if ( hitElement.isSmoking ) then
                hitElement:showInfoBox("info", "Du rauchst bereits!")
        else
			if (not hitElement:payMoney(10)) then return end
			hitElement.isSmoking = true
			toggleControl ( hitElement, "jump", false )
			toggleControl ( hitElement, "fire", false )
			toggleControl ( hitElement, "forwards", false )
			toggleControl ( hitElement, "backwards", false )
			toggleControl ( hitElement, "left", false )
			toggleControl ( hitElement, "right", false )
			hitElement:showInfoBox("info", "Du ziehst an der Shisha!")
			triggerClientEvent ( hitElement, "onServerPlaySavedSound", getRootElement(), "http://rewrite.ga/iLife/shisha.mp3", "Shisha", false)
			setTimer ( self.bSmokePhase2, 4000, 1, hitElement )
		end
	end
end

 
function CShishaBar:SmokePhase2 ( thePlayer )
	thePlayer.ShishaSmoke = createObject ( 2066, 0, 0, 0)
	exports.bone_attach:attachElementToBone( thePlayer.ShishaSmoke, thePlayer, 1, 0, 0.2, 0, 0, 0 ,0)
	toggleControl ( thePlayer, "jump", true )
	toggleControl ( thePlayer, "fire", true )
	toggleControl ( thePlayer, "forwards", true )
	toggleControl ( thePlayer, "backwards", true )
	toggleControl ( thePlayer, "left", true )
	toggleControl ( thePlayer, "right", true )
	setTimer (self.bDestroySmoke, 8000, 1, thePlayer )
end
 
function CShishaBar:DestroySmoke ( thePlayer )
	if (isElement(thePlayer.ShishaSmoke)) then
		destroyElement ( thePlayer.ShishaSmoke )
	end
	thePlayer.isSmoking = nil
end

ShishaBar = new(CShishaBar)
ShishaBar:addSmokeMarker(972.2998046875, -1556.5999755859, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 964.09997558594, -1556.5999755859, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 968.20001220703, -1556.8000488281, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 960.40002441406, -1556.5999755859, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 975.90002441406, -1556.5999755859, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 979.70001220703, -1556.5999755859, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 983.09997558594, -1556.6999511719, 20.60000038147, 2)
ShishaBar:addSmokeMarker( 977.90002441406, -1550.0999755859, 20.5, 2)
ShishaBar:addSmokeMarker( 973.70001220703, -1550.0999755859, 20.5, 2)
ShishaBar:addSmokeMarker( 962.59997558594, -1550.7999511719, 20.5, 3)