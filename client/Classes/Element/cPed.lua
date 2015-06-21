--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 23.12.2014
-- Time: 13:36
-- Project: MTA iLife
--

CPed = inherit(CElement)

registerElementClass("ped", CPed)

function CPed:constructor()

end

function CPed:destructor()

end

function CPed:setAnimation(...)
	return setPedAnimation(self, ...);
end
