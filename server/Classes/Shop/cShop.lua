--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Shops = {}
InteriorShops = {}

CShop = {}

function CShop:constructor(sName, iID)
	self.Name = sName
	self.m_iBusinessID = 0;
	if(iID) then
		self.ID = iID;
		InteriorShops[iID] = self;
	end
end

function CShop:destructor()

end

function CShop:getName()
	return self.Name
end
