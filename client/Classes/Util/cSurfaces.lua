--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: Surfaces.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Surfaces = {};
Surfaces.__index = Surfaces;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Surfaces:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetTypeFromID 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Surfaces:GetTypeFromID(id)
	if(id) and (id >= -1 and id <= 178) then
		return (self.ids[id] or false);
	else
		return false;
	end
end

-- ///////////////////////////////
-- ///// IsAboveThing 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Surfaces:IsAboveThing(x, y, z)
	local hit, x, y, z, element, normalX, normalY, normalZ, material = processLineOfSight(
		x, y, z,
		x, y, z+200,
		true,
		false,
		false)
	
	if(hit) and (material) then
		return true, getDistanceBetweenPoints3D(x, y, z, x, y, z+200);
	else
		return false;
	end
end

-- ///////////////////////////////
-- ///// GetSurfaceID 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Surfaces:GetSurfaceID(x, y, z)
	local hit, x, y, z, element, normalX, normalY, normalZ, material = processLineOfSight(
		x, y, z,
		x, y, z-10,
		true,
		true,
		false)
	
	if(hit) and (material) then
		return material, {x, y, z};
	else
		return false;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Surfaces:Constructor(...)
	
	self.ids = {};
	
	self.ids[-2]		= 	"roof";
	self.ids[-1]		= 	"interior";
	self.ids[0]			=	"tarmac";
	self.ids[1]			=	"tarmac";
	self.ids[2]			=	"tarmac";
	self.ids[3]			=	"tarmac";
	self.ids[4]			=	"tarmac";
	self.ids[5]			=	"tarmac";
	self.ids[6]			=	"gravel";
	self.ids[7]			=	"concrete";
	self.ids[8]			=	"concrete";
	self.ids[9]			=	"grass";
	self.ids[10]		=	"grass";
	self.ids[11]		=	"grass";
	self.ids[12]		=	"grass";
	self.ids[13]		=	"grass";
	self.ids[14]		=	"grass";
	self.ids[15]		=	"grass";
	self.ids[16]		=	"grass";
	self.ids[17]		=	"grass";
	self.ids[18]		=	"stone";
	self.ids[19]		=	"dirt";
	self.ids[20]		=	"dirt";
	self.ids[21]		=	"dirt";
	self.ids[22]		=	"dirt";
	self.ids[23]		=	"vegetation";
	self.ids[24]		=	"dirt";
	self.ids[25]		=	"dirt";
	self.ids[26]		=	"dirt";
	self.ids[27]		=	"dirt";
	self.ids[28]		=	"sand";
	self.ids[29]		=	"sand";
	self.ids[30]		=	"sand";
	self.ids[31]		=	"sand";
	self.ids[32]		=	"sand";
	self.ids[33]		=	"sand";
	self.ids[34]		=	"concrete";
	self.ids[35]		=	"stone";
	self.ids[36]		=	"stone";
	self.ids[37]		=	"stone";
	self.ids[38]		=	"water";
	self.ids[39]		=	"water";
	self.ids[40]		=	"dirt";
	self.ids[41]		=	"vegetation";
	self.ids[42]		=	"wood";
	self.ids[43]		=	"wood";
	self.ids[44]		=	"wood";
	self.ids[45]		=	"glass";
	self.ids[46]		=	"glass";
	self.ids[47]		=	"glass";
	self.ids[48]		=	"misc";
	self.ids[49]		=	"misc";
	self.ids[50]		=	"metal";
	self.ids[51]		=	"metal";
	self.ids[52]		=	"metal";
	self.ids[53]		=	"metal";
	self.ids[54]		=	"metal";
	self.ids[55]		=	"metal";
	self.ids[56]		=	"metal";
	self.ids[57]		=	"metal";
	self.ids[58]		=	"metal";
	self.ids[59]		=	"metal";
	self.ids[60]		=	"misc";
	self.ids[61]		=	"misc";
	self.ids[62]		=	"misc";
	self.ids[63]		=	"metal";
	self.ids[64]		=	"metal";
	self.ids[65]		=	"metal";
	self.ids[66]		=	"misc";
	self.ids[67]		=	"misc";
	self.ids[68]		=	"misc";
	self.ids[69]		=	"stone";
	self.ids[70]		=	"wood";
	self.ids[71]		=	"misc";
	self.ids[72]		=	"wood";
	self.ids[73]		=	"wood";
	self.ids[74]		=	"sand";
	self.ids[75]		=	"sand";
	self.ids[76]		=	"sand";
	self.ids[77]		=	"sand";
	self.ids[78]		=	"sand";
	self.ids[79]		=	"sand";
	self.ids[80]		=	"grass";
	self.ids[81]		=	"grass";
	self.ids[82]		=	"grass";
	self.ids[83]		=	"dirt";
	self.ids[84]		=	"dirt";
	self.ids[85]		=	"tarmac";
	self.ids[86]		=	"sand";
	self.ids[87]		=	"dirt";
	self.ids[88]		=	"dirt";
	self.ids[89]		=	"concrete";
	self.ids[90]		=	"misc";
	self.ids[91]		=	"misc";
	self.ids[92]		=	"misc";
	self.ids[93]		=	"misc";
	self.ids[94]		=	"misc";
	self.ids[95]		=	"misc";
	self.ids[96]		=	"sand";
	self.ids[97]		=	"sand";
	self.ids[98]		=	"sand";
	self.ids[99]		=	"sand";
	self.ids[100]		=	"dirt";
	self.ids[101]		=	"rubbish";
	self.ids[102]		=	"misc";
	self.ids[103]		=	"misc";
	self.ids[104]		=	"misc";
	self.ids[105]		=	"misc";
	self.ids[106]		=	"misc";
	self.ids[107]		=	"misc";
	self.ids[108]		=	"misc";
	self.ids[109]		=	"stone";
	self.ids[110]		=	"dirt";
	self.ids[111]		=	"vegetation";
	self.ids[112]		=	"vegetation";
	self.ids[113]		=	"vegetation";
	self.ids[114]		=	"vegetation";
	self.ids[115]		=	"grass";
	self.ids[116]		=	"grass";
	self.ids[117]		=	"grass";
	self.ids[118]		=	"grass";
	self.ids[119]		=	"grass";
	self.ids[120]		=	"grass";
	self.ids[121]		=	"grass";
	self.ids[122]		=	"grass";
	self.ids[123]		=	"dirt";
	self.ids[124]		=	"dirt";
	self.ids[125]		=	"grass";
	self.ids[126]		=	"dirt";
	self.ids[127]		=	"concrete";
	self.ids[128]		=	"dirt";
	self.ids[129]		=	"dirt";
	self.ids[130]		=	"dirt";
	self.ids[131]		=	"sand";
	self.ids[132]		=	"dirt";
	self.ids[133]		=	"dirt";
	self.ids[134]		=	"concrete";
	self.ids[135]		=	"asphalt";
	self.ids[136]		=	"asphalt";
	self.ids[137]		=	"asphalt";
	self.ids[138]		=	"concrete";
	self.ids[139]		=	"rubbish";
	self.ids[140]		=	"concrete";
	self.ids[141]		=	"dirt";
	self.ids[142]		=	"dirt";
	self.ids[143]		=	"sand";
	self.ids[144]		=	"asphalt";
	self.ids[145]		=	"dirt";
	self.ids[146]		=	"grass";
	self.ids[147]		=	"grass";
	self.ids[148]		=	"grass";
	self.ids[149]		=	"grass";
	self.ids[150]		=	"grass";
	self.ids[151]		=	"grass";
	self.ids[152]		=	"grass";
	self.ids[153]		=	"grass";
	self.ids[154]		=	"stone";
	self.ids[155]		=	"dirt";
	self.ids[156]		=	"dirt";
	self.ids[157]		=	"sand";
	self.ids[158]		=	"misc";
	self.ids[159]		=	"misc";
	self.ids[160]		=	"grass";
	self.ids[161]		=	"stone";
	self.ids[162]		=	"metal";
	self.ids[163]		=	"misc";
	self.ids[164]		=	"metal";
	self.ids[165]		=	"concrete";
	self.ids[166]		=	"misc";
	self.ids[167]		=	"metal";
	self.ids[168]		=	"metal";
	self.ids[169]		=	"misc";
	self.ids[170]		=	"misc";
	self.ids[171]		=	"metal";
	self.ids[172]		=	"wood";
	self.ids[173]		=	"wood";
	self.ids[174]		=	"wood";
	self.ids[175]		=	"glass";
	self.ids[176]		=	"misc";
	self.ids[177]		=	"misc";
	self.ids[178]		=	"misc";
	
	
	--outputDebugString("[CALLING] Surfaces: Constructor");
end

-- EVENT HANDLER --
