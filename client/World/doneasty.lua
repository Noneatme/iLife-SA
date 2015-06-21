--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
DoneastyShader = {
	[1] = dxCreateShader("res/shader/texture.fx"),
	[2] = dxCreateShader("res/shader/texture.fx"),
	[3] = dxCreateShader("res/shader/texture.fx"),
	[4] = dxCreateShader("res/shader/texture.fx"),
	[5] = dxCreateShader("res/shader/texture.fx"),
	[6] = dxCreateShader("res/shader/texture.fx"),
	[7] = dxCreateShader("res/shader/texture.fx"),
	[8] = dxCreateShader("res/shader/texture.fx"),
	[9] = dxCreateShader("res/shader/texture.fx"),
	[10] = dxCreateShader("res/shader/texture.fx")
}

DoneastyTextures = {
	[2] = "cj_don_post_2",
	[6] = "cj_don_post_1",
	[1] = "cj_binc_3",
	[7] = "base5_2",
	[4] = "cj_merc_logo",
	[3] = "cj_pizza_men1"
}

addEventHandler("onClientResourceStart", getRootElement(), function() triggerServerEvent("onClientRequestDoneastyObects", localPlayer) end)

addEvent("onServerSendDoneastyObjects", true)
addEventHandler("onServerSendDoneastyObjects", getRootElement(),
	function(obj)
		for k,v in ipairs(DoneastyShader) do
			if (DoneastyTextures[k]) then
				dxSetShaderValue(v,"Tex",dxCreateTexture("res/images/doneasty/"..k..".png"))
				for kk,vv in ipairs(obj) do
					engineRemoveShaderFromWorldTexture(billboardLarge, DoneastyTextures[k], vv)
					engineApplyShaderToWorldTexture(v, DoneastyTextures[k], vv, true)
				end
			end
		end
	end
)

addEventHandler("onClientResourceStart", getRootElement(),
	function()
		DoneastyLaden = dxCreateShader("res/shader/texture.fx")
		dxSetShaderValue(DoneastyLaden,"Tex",dxCreateTexture("res/images/doneasty/banner.png"))
		engineApplyShaderToWorldTexture(DoneastyLaden, "bailbonds1_lan", nil, true)
	end
)

function renderDoneasty()
	local sx, sy = guiGetScreenSize()
	dxDrawImage((sx-616)/2, (sy-237)/2, 616, 237, "res/images/doneasty/11.png")
end

Doneasty = nil

addEvent("DoneastyBook", true)
addEventHandler("DoneastyBook", getRootElement(),
	function()
		if not(Doneatsy) then
			Doneasty = true
			addEventHandler("onClientRender", getRootElement(), renderDoneasty)
			hideInventoryGui()
			setTimer(function() removeEventHandler("onClientRender", getRootElement(),renderDoneasty) Doneasty = nil end, 6000, 1)
		end
	end
)]]
