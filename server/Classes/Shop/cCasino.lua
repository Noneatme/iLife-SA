--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCasino = inherit(CShop)

function CCasino:constructor(dim)
	-- Klassenvariablen
	self.Dim = dim

	-- Slotmachines
	self.slotMachines =  {
		createSlotmachine(1136.4541015625, -10.7548828125, 1001.0796875, 0, 0, 180.4833984375, 12, dim),
		createSlotmachine(1131.41015625, 3.4482421875, 1001.0796875, 0, 0, 0.96408081054688, 12, dim),
		createSlotmachine(1134.203125, 3.4482421875, 1001.0796875, 0, 0, 0.00274658203125, 12, dim),
		createSlotmachine(1125.763671875, -7.169921875, 1001.0796875, 0, 0, 179.0771484375, 12, dim),
		createSlotmachine(1117.7373046875, 9.92578125, 1002.5784912109, 0, 0, 91.234619140625, 12, dim),
	}
	self.ID = dim-20000
	CShop.constructor(self, "Casino", self.ID)
end

function CCasino:destructor()

end
