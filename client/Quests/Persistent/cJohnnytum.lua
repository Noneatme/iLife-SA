--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local CJohnnytum = {}

function CJohnnytum:constructor()

	addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
		function()
			self.ChurchSound = playSound3D("http://rewrite.ga/mp3/Quest/Johnnytum/Hallelulaj.mp3", 2244.3872070312, -1325.3762207031, 27, true)
			setElementDimension(self.ChurchSound, 25000)
			setSoundMaxDistance(self.ChurchSound,100)
		end
	)

	self.LeinwandShader = dxCreateShader("res/shader/texture.fx")
	dxSetShaderValue(self.LeinwandShader, "Tex", dxCreateTexture("res/images/quests/persistent/johnnytum/lordi.png"))

	self.Leinwand = createObject(8331, 2244.5, -1363.6, 27.4, 0, 0, 111.25)
	setElementDimension(self.Leinwand, 25000)

	--engineRemoveShaderFromWorldTexture(billboardLarge, "bobo_3", self.Leinwand)
	engineApplyShaderToWorldTexture(self.LeinwandShader , "bobo_3", self.Leinwand, true)
end

function CJohnnytum:destructor()

end
