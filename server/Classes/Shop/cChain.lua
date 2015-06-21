--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Chains = {}

CChain = {}

function CChain:constructor(iID, sName, iMoney, iValue, iOwner)
	self.ID = iID
	self.Name = sName
	self.Money = iMoney
	self.Value = iValue
	self.Owner = iOwner
	
	Chains[self.ID] = self
end

function CChain:destructor()

end

function CChain:getID()
	return self.ID
end

function CChain:save()
	CDatabase:getInstance():query("UPDATE chains SET Money=?, Value=?, Owner=?", self.Money, self.Value, self.Owner)
end