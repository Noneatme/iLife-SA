--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: PedBloodManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

PedBloodManager = {};
PedBloodManager.__index = PedBloodManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function PedBloodManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RemovePedBlood		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PedBloodManager:RemovePedBlood(uPed)
	self.pedBlood[uPed] = nil;
end

-- ///////////////////////////////
-- ///// RenderBlood 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PedBloodManager:RenderBlood()
	for uPed, bodyparts in pairs(self.pedBlood) do
		local totalAmmount = 0;
		if(isElement(uPed)) and (isElementStreamedIn(uPed)) then
			for iBodypart, iAmmount in pairs(bodyparts) do
				if(tonumber(iAmmount)) and (iAmmount > 0) then
					
					local iOB = iBodypart;
					if(iBodypart == "torso") then
						iBodypart = 8;
					else
						iBodypart = (self.bones[iBodypart] or false)
					end
					
					if(iBodypart) then
						local x, y, z = getPedBonePosition(uPed, iBodypart);
						local iBla = iAmmount;
						if(iAmmount > 50) then
							iBla = 50;
						end
						fxAddBlood(x, y, z, 0, 0, 0, iBla/20);
						
						totalAmmount = totalAmmount+iBla;
					
					end
					
					iAmmount = iAmmount-0.05;
					self.pedBlood[uPed][iOB] = iAmmount;
					
					
				end
			end
			if(totalAmmount > 20) then
				if not(self.pedBlood[uPed]["fb"]) then
					setPedFootBloodEnabled(uPed, true);
					self.pedBlood[uPed]["fb"] = true;
				end
			else
				if(self.pedBlood[uPed]["fb"] == true) then
					setPedFootBloodEnabled(uPed, false);
					self.pedBlood[uPed]["fb"] = false;
				end
			end
		else
			self:RemovePedBlood(uPed);
		end
	end
end


-- ///////////////////////////////
-- ///// PedHit		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PedBloodManager:PedHit(uPed, uAttacker, iWeapon, iBodypart, iLoss)
	if not(self.pedBlood[uPed]) then
		self.pedBlood[uPed] = {};
	end
	if not(iBodyPart) then
		iBodyPart = "torso";
	end
	if not(self.pedBlood[uPed][iBodypart]) then
		self.pedBlood[uPed][iBodypart] = 0;
	end
	
	self.pedBlood[uPed][iBodypart] = self.pedBlood[uPed][iBodypart]+iLoss;
end

-- ///////////////////////////////
-- ///// Reset		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////
function PedBloodManager:Reset(uPed)
	setTimer(
		function() 
			self.pedBlood[uPed] = {}
		end
	, 2000, 1)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PedBloodManager:Constructor(...)
	-- Klassenvariablen --
	self.pedBlood	= {};
	
	-- Methoden --
	self.pedHitFunc			= function(...) self:PedHit(source, ...) end;
	self.renderBloodFunc	= function(...) self:RenderBlood(...) end;
	
	
	self.bones	= 
	{
		[3] = 1,
		[4] = 1,
		[5] = 33,
		[6] = 23,
		[7] = 42,
		[8] = 52,
		[9] = 8,
		
	
	}
	
	addEventHandler("onClientPedDamage", getRootElement(), self.pedHitFunc)
	addEventHandler("onClientPlayerDamage", getRootElement(), self.pedHitFunc)
	
	addEventHandler("onClientRender", getRootElement(), self.renderBloodFunc)
	
	addEventHandler("onClientPedWasted", getRootElement(), function() PedBloodManager.Reset(self, source) end)
	-- Events --
	
	--logger:OutputInfo("[CALLING] PedBloodManager: Constructor");
end

-- EVENT HANDLER --