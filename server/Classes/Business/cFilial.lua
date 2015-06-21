--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Filials = {}

CFilial = {}

function CFilial:constructor(iID, iInterior, iPrice, sOwner)
	self.ID = iID
	self.Interior = iInterior
	self.Price = iPrice
	self.Owner = sOwner
	
	
	--[[
	local pedData = fromJSON(JSONPedData)
	
	for k,v in pairs(pedData) do
		local ped = createPed(v["Skin"], v["X"], v["Y"], v["Z"], v["RZ"], false)
		table.insert(self.FillialenPeds, enew(ped, CVendorPed, v))
	end
	]]
	
	Filials[self.ID] = self
end

function CFilial:destructor()

end