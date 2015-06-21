--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CBlender = {}

function CBlender:constructor()
	self.startTick = false
end

function CBlender:destructor()

end

function CBlender:fade(von, bis, time, blendingValue)
	if not(self.startTick) then
		self.startTick = getTickCount()
    end
		
	local a
       
	local a1 = interpolateBetween(von, 0, 0, bis, 0, 0, ((getTickCount()-self.startTick)/blendingValue), "InQuad")
	a = a1

	if(a1 >= bis) and (getTickCount()-self.startTick > time/2) then
		if not(self.endTick) then
			self.endTick = getTickCount()
		end
		a2 = interpolateBetween(a1, 0, 0, 0, 0, 0, ((getTickCount()-self.endTick)/blendingValue), "OutQuad")
		a = a2
	end
	return a
end