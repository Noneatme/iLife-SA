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

CObject = inherit(CElement)
registerElementClass("object", CObject)

function CObject:constructor()

end

function CObject:destructor()

end

function CObject:setMass(...)
	return setObjectMass(self, ...)
end
