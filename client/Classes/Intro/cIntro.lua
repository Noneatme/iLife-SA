--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CIntro = {}

function CIntro:constructor()
	self.CurrentFrame = 1
	self.Music = "http://rewrite.ga/iLife/cdub.mp3"
	--self.Music = "http://noneatme.de/portal2_robots_ftw.mp3"
	self.tFrameChange = bind(self.FrameChange, self)
	self.Dim = getElementDimension(getLocalPlayer())
	self.dxFont = dxCreateFont ( "res/fonts/secrcode.ttf", 60, false)
	
	new(CIntroFrame, 1, 12000,
		function()
			local sx, sy = guiGetScreenSize()
			--outputChatBox("1st")
			
			local Blender = new(CBlender)
			
			local render= function()
					local alpha = Blender:fade(0, 255, 19000, 3000)
					dxDrawText("A", 0, (sy/2)-200, sx, (sy/2)-200, tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
					dxDrawImage((sx/2)-225, (sy/2)-100, 200, 200, "res/images/rewrite.png", 0, 0, 0, tocolor(255,255,255, alpha), true)
					dxDrawImage((sx/2)+25, (sy/2)-100, 200, 200, "res/images/noneatme.png", 0, 0, 0, tocolor(255,255,255, alpha), true)
					dxDrawText("Production", 0, (sy/2)+200, sx, (sy/2)+200, tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
			end
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 11500, 1
			)
		end
	)
	
	new(CIntroFrame, 2, 27000,
		function()
			--outputChatBox("2nd")
			local sx, sy = guiGetScreenSize()
			
			local Blender = new(CBlender)
			setCameraMatrix(1477.4541015625,-927.7900390625,187.36685180664,1502.2568359375,-1413.6904296875,112.99348449707)
			smoothMoveCamera(1477.4541015625,-927.7900390625,187.36685180664,1502.2568359375,-1413.6904296875,112.99348449707,1510.962890625,-1682.396484375,90.76350402832,1433.3935546875,-1712.193359375,50.543941497803, 27000)
			
			local render= function()
				local alpha = Blender:fade(0, 255, 32000, 5000)
				dxDrawImage((sx/2)-245, (sy/2)-80, 490, 160, "res/images/header.png", 0, 0, 0, tocolor(255,255,255, alpha), true)
			end
			
			setTimer(function()
				fadeCamera(true, 4.0, 255, 255, 255)
			end, 4000, 1)
			
			setTimer(function()
				fadeCamera(false, 1, 0, 0, 0)
			end, 26000, 1)
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 27000, 1
			)
		end
	)
	
	new(CIntroFrame, 3, 10000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("3th")
			setCameraMatrix(1560.30078125,-1631.9384765625,14.3828125,1542.5341796875,-1629.6552734375,13.3828125)
			smoothMoveCamera(1560.30078125,-1631.9384765625,14.3828125,1542.5341796875,-1629.6552734375,13.3828125, 1574.30078125,-1631.9384765625,14.3828125, 1542.5341796875,-1629.6552734375,10.3828125, 10000)
			fadeCamera(true, 1.0, 255, 255, 255)
			
			Peds[1] = createPed(113, 1549, -1629.14065625, 13.3828125, 265)
			Peds[2] = createPed(115, 1551, -1629.14065625, 13.3828125, 265)
			Peds[3] = createPed(181, 1553, -1629.14065625, 13.3828125, 265)
			Peds[4] = createPed(120, 1555, -1629.14065625, 13.3828125, 265)
			--SWAT
			Peds[5] = createPed(285, 1549, -1631.14065625, 13.3828125, 265)
			Peds[6] = createPed(285, 1551, -1631.14065625, 13.3828125, 265)
			Peds[7] = createPed(285, 1553, -1631.14065625, 13.3828125, 265)
			Peds[8] = createPed(285, 1555, -1631.14065625, 13.3828125, 265)
			Peds[9] = createPed(285, 1549, -1627.14065625, 13.3828125, 265)
			Peds[10] = createPed(285, 1551, -1627.14065625, 13.3828125, 265)
			Peds[11] = createPed(285, 1553, -1627.14065625, 13.3828125, 265)
			Peds[12] = createPed(285, 1555, -1627.14065625, 13.3828125, 265)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			for k,v in ipairs(Peds) do
				setPedAnimation(v, "ped", "WALK_player", -1, true, true, false, false)
			end
			
			setTimer(
				function()
					fadeCamera(false, 1, 0,0,0)
				end, 9000,1
			)
			
			setTimer(
				function()
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end
				end, 10000,1
			)
		end
	)
	
	new(CIntroFrame, 4, 12000,
		function()
			local Peds = {}
			local Objects = {}
		
			--outputChatBox("4th")
			fadeCamera(true, 1, 255, 255, 255)
			setCameraMatrix(1589.962890625, -1647.0341796875, 13.330603599548, 1588.73828125, -1633.4423828125, 13.3828125)
			smoothMoveCamera(1589.962890625, -1647.0341796875, 13.330603599548, 1588.73828125, -1633.4423828125, 13.3828125, 1589.962890625, -1647.0341796875, 14.330603599548, 1588.73828125, -1633.4423828125, 13.3828125, 10000)
			
			Objects[1] = createObject(2949, 1584.0999755859, -1637.9000244141, 12.60000038147)
			Objects[2] = createObject(2949, 1584.0999755859, -1637.9000244141, 12.699999809265)
			Objects[3] = createObject(966, 1585.1999511719, -1638.0999755859, 12.5)	
			Objects[4] = createObject(968, 1585.0999755859, -1638.0999755859, 13.39999961853)
				
			setElementRotation(Objects[1], 0, 0, 270)
			setElementRotation(Objects[2], 0, 180, 270)
			setElementRotation(Objects[3], 0, 0, 182.25)	
			setElementRotation(Objects[4], 0, 90, 2)		
			
			--ReWrite
			Peds[1] = createPed(24, 1584.8427734375, -1638.854296875, 13.321388244629, 0)
		
			--Leader
			Peds[2] = createPed(113, 1589.1999511719, -1631.4000244141, 13.39999961853, 180)
			Peds[3] = createPed(115, 1589.1999511719, -1629.9000244141, 13.39999961853, 180)
			Peds[4] = createPed(181, 1589.1999511719, -1628.4000244141, 13.39999961853, 180)
			Peds[5] = createPed(120, 1589.1999511719, -1626.9000244141, 13.39999961853, 180)
			
			--Swats
			Peds[6] = createPed(285, 1587.9, -1631.4000244141, 13.39999961853, 180)
			Peds[7] = createPed(285, 1587.9, -1629.9000244141, 13.39999961853, 180)
			Peds[8] = createPed(285, 1587.9, -1628.4000244141, 13.39999961853, 180)
			Peds[9] = createPed(285, 1587.9, -1626.9000244141, 13.39999961853, 180)
			Peds[10] = createPed(285, 1590.6, -1631.4000244141, 13.39999961853, 180)
			Peds[11] = createPed(285, 1590.6, -1629.9000244141, 13.39999961853, 180)
			Peds[12] = createPed(285, 1590.6, -1628.4000244141, 13.39999961853, 180)
			Peds[13] = createPed(285, 1590.6, -1626.9000244141, 13.39999961853, 180)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			for k,v in ipairs(Peds) do
				if (k == 1 ) then
					setPedAnimation(v, "BOMBER", "BOM_PLANT_LOOP", -1, true, false, true, true)
				else
					setPedAnimation(v, "ped", "WALK_player", -1, true, true, false, false)
				end
			end
			
			
		
			setTimer(
				function()
					for k,v in ipairs(Peds) do
						setPedAnimation(v, nil, nil)
					end	
				end, 4000, 1
			)
		
			local sx, sy = guiGetScreenSize()
		
			local Blender = new(CBlender)
		
			local render= function()
				local alpha = Blender:fade(0, 255, 16000, 2000)
				dxDrawText("Featuring", 0, 40, sx-40, 40, tocolor(255,255,255, alpha), 1, self.dxFont, "right", "center", false, false, true, false, false)
				dxDrawImage((sx)-330, 100, 250, 250, "res/images/dawi.png", 0, 0, 0, tocolor(255,255,255, alpha), true)
				
				if ((getElementHealth(Peds[1]) == 100)) then
					local x,y,z = getElementPosition(Peds[1])
					local fx, fy = getScreenFromWorldPosition(x,y,z+1.1)
					local fxc, fyc = getScreenFromWorldPosition(x,y,z+1.0)
					
					if (fx and fx) then
						dxDrawText("ReWrite", fx, fy, fx, fy, tocolor(255,255,255, 255), 1.5, "arial", "center", "center", false, false, true, false, false)
						dxDrawText("\"Scripter\"", fxc, fyc, fxc, fyc, tocolor(150,150,150, 255), 1.2, "arial", "center", "center", false, false, true, false, false)
					end
				end
			end
			
			local renderFX = function()
				fxAddTyreBurst(1585.0999755859, -1638.0999755859, 13.39999961853, 0,0,3)
				fxAddSparks (1585.0999755859, -1638.0999755859, 13.39999961853, 0,0,3)
			end
		
			addEventHandler("onClientRender", getRootElement(), render)
		
			setTimer(
				function()
					moveObject(Objects[4], 2000, 1585.0999755859, -1638.0999755859, 13.39999961853, 0, -17, 0)
					addEventHandler("onClientRender", getRootElement(), renderFX)
					setTimer(
						function()
							removeEventHandler("onClientRender", getRootElement(), renderFX)
							createExplosion(1585.1999511719, -1638.0999755859, 12.5, 2)
							createExplosion(1586.453125, -1634.0498046875, 13.3828125, 2)
							createExplosion(1590.7783203125,-1634.0673828125,13.435409545898, 2)
							moveObject(Objects[4], 700,1585.0999755859, -1636.0999755859, 12.5, 180 , 17, 0)
							for k,v in ipairs(Peds) do
								setElementHealth(v, 0)
							end	
						end, 2000, 1
					)
				end, 7000, 1
			)
		
			setTimer(
				function()
					fadeCamera(false, 1, 0,0,0)
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 11000,1
			)
			
			setTimer(
				function()
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 12000,1
			)
		end
	)
	
	new(CIntroFrame, 5, 7000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("5th")
			setCameraMatrix(933.9912109375, -1078.0712890625, 32.261817932129,863.1640625, -1093.76953125, 32.933975219727)
			smoothMoveCamera(933.9912109375, -1078.0712890625, 32.261817932129,863.1640625, -1093.76953125, 32.933975219727, 843.2822265625, -1115.2880859375, 27.926473617554, 838.4609375, -1118.2939453125, 24.060228347778, 7000)
			fadeCamera(true, 1.0, 255, 255, 255)
			
			Objects[1] = createObject(869,838.7000100,-1118.5999800,23.5000000,0.0000000,0.0000000,0.0000000) --object(veg_pflowerswee) (1)
			Objects[2] = createObject(869,838.7999900,-1115.3000500,23.5000000,0.0000000,0.0000000,0.0000000) --object(veg_pflowerswee) (2)
			Objects[3] = createObject(869,848.4000200,-1118.0000000,23.5000000,0.0000000,0.0000000,0.0000000) --object(veg_pflowerswee) (3)
			Objects[4] = createObject(869,848.4000200,-1114.5999800,23.5000000,0.0000000,0.0000000,0.0000000) --object(veg_pflowerswee) (4)
			Objects[5] = createObject(2896,845.4000200,-1116.5000000,24.1000000,0.0000000,0.0000000,91.0000000) --object(casket_law) (1)
			Objects[6] = createObject(2896,841.4000200,-1116.5000000,24.1000000,0.0000000,0.0000000,91.0000000) --object(casket_law) (2)
			Objects[7] = createObject(2245,845.7999900,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (1)
			Objects[8] = createObject(2245,845.0999800,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (2)
			Objects[9] = createObject(2245,844.4000200,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (3)
			Objects[10] = createObject(2245,843.7000100,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (4)
			Objects[11] = createObject(2245,843.0000000,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (5)
			Objects[12] = createObject(2245,842.2999900,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (6)
			Objects[13] = createObject(2245,841.5999800,-1114.5999800,23.4000000,0.0000000,0.0000000,0.0000000) --object(plant_pot_11) (7)
			Objects[14] = createObject(2896,844.0000000,-1116.5000000,24.1000000,0.0000000,0.0000000,91.0000000) --object(casket_law) (3)
			Objects[15] = createObject(2896,842.7000100,-1116.5000000,24.1000000,0.0000000,0.0000000,91.0000000) --object(casket_law) (4)
			
			Peds[1] = createPed(125,844.5,-1110.80005,24.2,181.003)
			Peds[2] = createPed(125,841.40002,-1108.90002,24.2,181.005)
			Peds[3] = createPed(125,845.5,-1107.40002,24.2,181.003)
			Peds[4] = createPed(111,843.5,-1109.40002,24.2,180.003)
			Peds[5] = createPed(111,839.5,-1110.40002,24.2,180.003)
			Peds[6] = createPed(124,844.20001,-1107.90002,24.2,180.003)
			Peds[7] = createPed(124,841.70001,-1110.59998,24.2,180.003)
			Peds[8] = createPed(298,842.29999,-1107.09998,24.2,180)
			Peds[9] = createPed(298,845,-1109.59998,24.2,180.003)
			Peds[10] = createPed(116,839.90002,-1107.90002,24.2,190.003)
			Peds[11] = createPed(115,841,-1107.59998,24.2,190.003)
			Peds[12] = createPed(118,846.09998,-1108.5,24.2,170.003)
			Peds[13] = createPed(118,842.90002,-1110.5,24.2,190.002)
			Peds[14] = createPed(100,843.20001,-1105.80005,24.3,180)
			Peds[15] = createPed(100,842.59998,-1108.30005,24.3,184)
			Peds[16] = createPed(100,844.40002,-1106.40002,24.3,170)
			Peds[17] = createPed(258,845.79999,-1120.59998,24,10)

			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setTimer(
				function()
					fadeCamera(false, 1, 0,0,0)
				end, 6000,1
			)
			
			setTimer(
				function()
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 7000,1
			)
			
		end
	)
	
	new(CIntroFrame, 6, 5000,
		function()
			local Peds = {}
			local Objects = {}
		
			local sx, sy = guiGetScreenSize()
			--outputChatBox("6th")
			
			local Blender = new(CBlender)
			
			local render= function()
					local alpha = Blender:fade(0, 255, 8000, 1500)
					dxDrawText("Zwei Wochen später...", 0, (sy/2), sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
			end
			
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 5000, 1
			)
		end
	)
	
	new(CIntroFrame, 7, 10000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("7th")
			
			Peds[1] = createPed( 137, 1396.4091796875,-1861.755859375,13.546875)
			setPedControlState(Peds[1], "walk", true)
			setPedControlState(Peds[1], "forwards", true)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setCameraMatrix(1392.3212890625,-1856.35546875,17.414304733276, 1396.4091796875, -1861.755859375, 13.546875)
			smoothMoveCamera(1392.3212890625,-1856.35546875,17.414304733276, 1396.4091796875, -1861.755859375, 13.546875, 1393.140625, -1848.009765625, 18.631935119629 , 1396.4091796875,-1846.49609375,13.546875, 10000)
			
			fadeCamera(true, 1.0, 255, 255, 255)
			
			local sx, sy = guiGetScreenSize()
			
			local render= function()
					local x,y,z = getElementPosition(Peds[1])
					local fx, fy = getScreenFromWorldPosition(x,y,z+1.1)
					local fxc, fyc = getScreenFromWorldPosition(x,y,z+1.0)
					
					
					if (fx and fx) then
						dxDrawText(getPlayerName(getLocalPlayer()), fx, fy, fx, fy, tocolor(255,255,255, 255), 1.5, "arial", "center", "center", false, false, true, false, false)
						dxDrawText("Bürger", fxc, fyc, fxc, fyc, tocolor(150,150,150, 255), 1.2, "arial", "center", "center", false, false, true, false, false)
					end
				
			end
			
			setTimer(
				function()
					addEventHandler("onClientRender", getRootElement(), render)
				end, 700, 1
			)
			
			setTimer(
				function()
					fadeCamera(false, 1.0, 0, 0, 0)
				end, 9000, 1
			)
			
			setTimer(
				function()
					local x,y,z = getElementPosition(Peds[1])
					removeEventHandler("onClientRender", getRootElement(), render)
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 10000, 1
			)
		end
	)
	
	new(CIntroFrame, 8, 13000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("8th")
			
			Peds[1] = createPed( 137, 1397.0166015625, -1785.1689453125, 13.546875)
			setPedControlState(Peds[1], "walk", true)
			setPedControlState(Peds[1], "forwards", true)
			
			Peds[2] = createPed(109, 1378.2763671875, -1773.7373046875, 13.546875, 270)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setTimer(
				function()
					local x,y,z = getElementPosition(Peds[2])
					setPedLookAt(Peds[1], x, y, z, 7000, Peds[2])
					setPedAnimation(Peds[2], "ON_LOOKERS", "wave_loop", -1, true, false, false, false)
				end, 2000, 1
			)
			
			setTimer(
				function()
					setPedControlState(Peds[1], "forwards", false)
					setPedControlState(Peds[1], "left", true)
					setPedAnimation(Peds[2], nil, nil)
					setPedControlState(Peds[2], "backwards", true)
				end, 8000, 1
			)
			
			setCameraMatrix(1403.36328125, -1790.8427734375, 16.962553024292, 1379.21875, -1772.8359375, 13.546875)
			smoothMoveCamera(1403.36328125, -1790.8427734375, 16.962553024292, 1379.21875, -1772.8359375, 13.546875, 1403.36328125, -1770.01953125, 16.962553024292, 1378.904296875, -1768.619140625, 13.546875, 10000)
			
			fadeCamera(true, 1.0, 255, 255, 255)
			
			local sx, sy = guiGetScreenSize()
			
			local render= function()
					local x,y,z = getElementPosition(Peds[1])
					local fx, fy = getScreenFromWorldPosition(x,y,z+1.1)
					local fxc, fyc = getScreenFromWorldPosition(x,y,z+1.0)
					
					
					if (fx and fx) then
						dxDrawText(getPlayerName(getLocalPlayer()), fx, fy, fx, fy, tocolor(255,255,255, 255), 1.5, "arial", "center", "center", false, false, true, false, false)
						dxDrawText("Bürger", fxc, fyc, fxc, fyc, tocolor(150,150,150, 255), 1.2, "arial", "center", "center", false, false, true, false, false)
					end
				
			end
			
			setTimer(
				function()
					addEventHandler("onClientRender", getRootElement(), render)
				end, 700, 1
			)
			
			setTimer(
				function()
					fadeCamera(false, 1.0, 0, 0, 0)
				end, 12000, 1
			)
			
			setTimer(
				function()
					local x,y,z = getElementPosition(Peds[1])
					removeEventHandler("onClientRender", getRootElement(), render)
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 13000, 1
			)
		end
	)
	
	new(CIntroFrame, 9, 6000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("9th")
			--Player
			Peds[1] = createPed( 137, 1348.0078125, -1774.0771484375, 13.466242790222, 90)
			setPedControlState(Peds[1], "walk", true)
			setPedControlState(Peds[1], "forwards", true)
			--Gangmembers
			Peds[2] = createPed(109, 1341.224609375, -1768.447265625, 13.518249511719, 180)
			Peds[3] = createPed(108, 1339.6552734375, -1768.3994140625, 13.535594940186, 200)
			Peds[4] = createPed(110, 1338.333984375, -1768.505859375, 13.546664237976, 215)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setTimer(
				function()
					setPedControlState(Peds[1], "forwards", false)
					setPedControlState(Peds[1], "right", true)
				end, 3500, 1
			)
			
			setTimer(
				function()
					setPedControlState(Peds[1], "right", false)
					setPedControlState(Peds[2], "forwards", true)
					setPedControlState(Peds[3], "forwards", true)
					setPedControlState(Peds[4], "forwards", true)
				end, 4000, 1
			)
			
			setCameraMatrix(1351.353515625, -1773.6142578125, 14.381235122681, 1337.2392578125, -1773.60546875, 14.510272979736)
			smoothMoveCamera(1351.353515625, -1773.6142578125, 14.381235122681, 1337.2392578125, -1773.60546875, 14.510272979736, 1340.3818359375, -1773.8056640625, 14.656971931458, 1340.7119140625, -1766.4873046875, 13.521754264832, 6000)
			
			fadeCamera(true, 1.0, 255, 255, 255)
			
			local sx, sy = guiGetScreenSize()
			
			local render= function()
					local x,y,z = getElementPosition(Peds[1])
					local fx, fy = getScreenFromWorldPosition(x,y,z+1.1)
					local fxc, fyc = getScreenFromWorldPosition(x,y,z+1.0)
					
					
					if (fx and fx) then
						dxDrawText(getPlayerName(getLocalPlayer()), fx, fy, fx, fy, tocolor(255,255,255, 255), 1.5, "arial", "center", "center", false, false, true, false, false)
						dxDrawText("Bürger", fxc, fyc, fxc, fyc, tocolor(150,150,150, 255), 1.2, "arial", "center", "center", false, false, true, false, false)
					end
				
			end
			
			setTimer(
				function()
					addEventHandler("onClientRender", getRootElement(), render)
				end, 700, 1
			)
			
			setTimer(
				function()
					fadeCamera(false, 1.0, 0, 0, 0)
				end, 5000, 1
			)
			
			setTimer(
				function()
					local x,y,z = getElementPosition(Peds[1])
					removeEventHandler("onClientRender", getRootElement(), render)
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 6000, 1
			)
		end
	)
	
	new(CIntroFrame, 10, 6000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("10th")
			--Player
			Peds[1] = createPed( 137, 1340.9638671875, -1772.4814453125, 13.516731262207, 127)
			setPedAnimation(Peds[1], "CRACK", "crckidle2", -1, true, false, false, true)
			--Gangmembers
			Peds[2] = createPed(109, 1340.4228515625, -1772.904296875, 13.523732185364, 310)
			Peds[3] = createPed(108, 1340.9521484375, -1771.8212890625, 13.520655632019, 125)
			Peds[4] = createPed(110, 1343.033203125,-1772.9462890625,13.483865737915, 82)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setPedControlState(Peds[2], "fire", true)
			setPedControlState(Peds[3], "fire", true)
			setPedControlState(Peds[4], "fire", true)
			
			setTimer(
			function ()
				setPedControlState(Peds[2], "fire", not (getPedControlState(Peds[2], "fire")))
				setPedControlState(Peds[3], "fire", not (getPedControlState(Peds[3], "fire")))
				setPedControlState(Peds[4], "fire", not (getPedControlState(Peds[4], "fire")))
			end, 500, 10
			)
			
			setCameraMatrix(1340.18359375, -1771.55859375, 15.834021568298, 1340.18359375, -1771.55859375, 13.534291267395)
			smoothMoveCamera(1340.18359375, -1771.55859375, 15.834021568298, 1340.18359375, -1771.55859375, 13.534291267395, 1340.490234375, -1761.6953125, 13.523266792297, 1340.18359375, -1771.55859375, 13.534291267395, 6000)
			
			fadeCamera(true, 1.0, 255, 255, 255)
			
			local sx, sy = guiGetScreenSize()
			
			local render= function()
					local x,y,z = getElementPosition(Peds[1])
					local fx, fy = getScreenFromWorldPosition(x,y,z+1.1)
					local fxc, fyc = getScreenFromWorldPosition(x,y,z+1.0)
					
					
					if (fx and fx) then
						dxDrawText(getPlayerName(getLocalPlayer()), fx, fy, fx, fy, tocolor(255,255,255, 255), 1.5, "arial", "center", "center", false, false, true, false, false)
						dxDrawText("Bürger", fxc, fyc, fxc, fyc, tocolor(150,150,150, 255), 1.2, "arial", "center", "center", false, false, true, false, false)
					end
				
			end
			
			setTimer(
				function()
					addEventHandler("onClientRender", getRootElement(), render)
				end, 700, 1
			)
			
			setTimer(
				function()
					fadeCamera(false, 1.0, 0, 0, 0)
				end, 5000, 1
			)
			
			setTimer(
				function()
					local x,y,z = getElementPosition(Peds[1])
					removeEventHandler("onClientRender", getRootElement(), render)
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 6000, 1
			)
		end
	)

	new(CIntroFrame, 11, 5000,
		function()
			local Peds = {}
			local Objects = {}
			
			--outputChatBox("11th")
			--Player
			Peds[1] = createPed( 137, 1340.9638671875, -1772.4814453125, 13.516731262207, 127)
			setPedAnimation(Peds[1], "CRACK", "crckidle2", -1, true, false, false, true)
			
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			setCameraMatrix(1340.9638671875, -1772.4814453125, 15.516731262207, 1340.9638671875, -1772.4814453125, 13.516731262207)
			smoothMoveCamera(1340.9638671875, -1772.4814453125, 15.516731262207, 1340.9638671875, -1772.4814453125, 13.516731262207, 1340.9638671875, -1772.4814453125, 25.516731262207, 1340.9638671875, -1772.4814453125, 13.516731262207, 5000)
			
			fadeCamera(true, 1.0, 255, 255, 255)
			
			local sx, sy = guiGetScreenSize()
			
			
			setTimer(
				function()
					fadeCamera(false, 1.0, 0, 0, 0)
				end, 5000, 1
			)
			
			setTimer(
				function()
					for k,v in ipairs(Peds) do
						destroyElement(v)
					end	
					for k,v in ipairs(Objects) do
						destroyElement(v)
					end	
				end, 6000, 1
			)
		end
	)
	new(CIntroFrame, 12, 5000,
		function()
			--outputChatBox("12th")
			local Peds = {}
			local Objects = {}
		
		
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
			
			local sx, sy = guiGetScreenSize()
			
			local Blender = new(CBlender)
			
			local render= function()
					local alpha = Blender:fade(0, 255, 8000, 1500)
					dxDrawText("Wer bin ich?", 0, (sy/2)-100, sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
					dxDrawText("Was mache ich hier?", 0, (sy/2)+100, sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
			end
			
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 5000, 1
			)
		end
	)
	
	new(CIntroFrame, 13, 5000,
		function()
			--outputChatBox("13th")
			local Peds = {}
			local Objects = {}
		
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
		
			local sx, sy = guiGetScreenSize()
			
			local Blender = new(CBlender)
			
			local render= function()
					local alpha = Blender:fade(0, 255, 8000, 1500)
					dxDrawText("Diese Schmerzen!", 0, (sy/2)-100, sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
					dxDrawText("Ich hab doch irgendwo...", 0, (sy/2)+100, sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
			end
			
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 5000, 1
			)
		end
	)
	
	new(CIntroFrame, 14, 5000,
		function()
			--outputChatBox("14th")
			local Peds = {}
			local Objects = {}
		
			for k,v in ipairs(Peds) do
				setElementDimension(v, self.Dim)
			end	
			for k,v in ipairs(Objects) do
				setElementDimension(v, self.Dim)
			end	
		
			local sx, sy = guiGetScreenSize()
			
			local Blender = new(CBlender)
			
			local render= function()
					local alpha = Blender:fade(0, 255, 8000, 1500)
					dxDrawText("Ah hier...\nmeinen Personalausweis!", 0, (sy/2)-100, sx, (sy/2), tocolor(255,255,255, alpha), 1, self.dxFont, "center", "center", false, false, true, false, false)
			end
			
			
			addEventHandler("onClientRender", getRootElement(), render)
			
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), render)
				end, 5000, 1
			)
		end
	)
	
end

function CIntro:destructor()

end

function CIntro:start()
	setElementDimension(getLocalPlayer(), 27569)
	self.Dim = getElementDimension(getLocalPlayer())
	setPlayerHudComponentVisible ( "all", false)
	hud:Toggle(false)
	self.CurrentFrame = 1
	if (#IntroFrames > 0) then
		self.Sound = playSound(self.Music, false)
		fadeCamera(false)
		self:FrameChange()
	else
		outputDebugString("No Intro-Frames detected.")
	end
end

function CIntro:FrameChange()
	if (#IntroFrames >= self.CurrentFrame) then
		setTimer(self.tFrameChange,IntroFrames[self.CurrentFrame]:getDuration()+500, 1)
		IntroFrames[self.CurrentFrame]:run()
		self.CurrentFrame = self.CurrentFrame+1
	else
		self:stop()
	end
end

function CIntro:stop()
	if (isElement(destroyElement(self.Sound))) then
		destroyElement(self.Sound)
	end
	setElementDimension(getLocalPlayer(), 5)
	self:endFunc()
	--outputChatBox("Stopped Intro!")
end

function CIntro:setEndFunc(func)
	self.endFunc = func
end

addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			Intro = new(CIntro)
		end
	end
)

--[[
addCommandHandler("intro",
	function()
		Intro:start()
	end
)
]]

local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil
 
local function removeCamHandler ()
	if(sm.moov == 1) then
		sm.moov = 0
		removeEventHandler ( "onClientPreRender", getRootElement(), camRender )
	end
end
 
local function camRender ()
	local x1, y1, z1 = getElementPosition ( sm.object1 )
	local x2, y2, z2 = getElementPosition ( sm.object2 )
	setCameraMatrix ( x1, y1, z1, x2, y2, z2 )
end
 
function smoothMoveCamera ( x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time )
	if(sm.moov == 1) then return false end
		
	sm.object1 = createObject ( 1337, x1, y1, z1 )
	sm.object2 = createObject ( 1337, x1t, y1t, z1t )
	setElementAlpha ( sm.object1, 0 )
	setElementAlpha ( sm.object2, 0 )
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject ( sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad" )
	moveObject ( sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad" )
 
	addEventHandler ( "onClientPreRender", getRootElement(), camRender )
	sm.moov = 1
	setTimer ( removeCamHandler, time, 1 )
	setTimer (
		function()
			if (isElement(destroyElement(sm.object1))) then
				destroyElement(sm.object1)
			end
			if (isElement(destroyElement(sm.object2))) then
				destroyElement(sm.object2)
			end
		end
	, time, 1)
	
	return true
end