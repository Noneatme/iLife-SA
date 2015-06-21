--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

function replaceShisha()
    local sound = playSound3D("http://oriental-high.rautemusik.fm", 971.2001953125, -1548.2998046875, 1.8999999761581, true)
    local sound2 = playSound3D("http://oriental-high.rautemusik.fm", 967.79998779297, -1551.0999755859, 21.39999961853, true)
    setSoundMaxDistance( sound, 25 )
    setSoundMaxDistance( sound2, 25 )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceShisha)
