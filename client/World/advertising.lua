--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- Muss beizeiten nochmal komplett Neugeschrieben werden, in eine Singleton Managerklasse integrieren und die statischen Funktionsaufrufe entfernen


function trimTextIntoLines(text, maxLettersPerRow)
	local words 	= {}
    local i			= 1
    while (gettok(text,i, " ") ~= false) do
        words[i] = gettok(text, i , " ")
        i = i+1;
    end

    local count		= 0
    text 			= ""

    for index, value in pairs(words) do
        count = count + #value
        if (count > maxLettersPerRow) then
            text = text.."\n"..value.." "
            count = 0
        else
            text = text..value.." "
        end

    end
    return text
end

addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			billboardLarge = dxCreateShader("res/shader/texture.fx")
			dxSetShaderValue(billboardLarge,"Tex",dxCreateTexture("res/images/board.png"))

			engineApplyShaderToWorldTexture(billboardLarge,"eris_2")
			engineApplyShaderToWorldTexture(billboardLarge,"diderSachs01")
			engineApplyShaderToWorldTexture(billboardLarge,"cokopops_1")
			engineApplyShaderToWorldTexture(billboardLarge,"homies_1")
			engineApplyShaderToWorldTexture(billboardLarge,"homies_2")
			engineApplyShaderToWorldTexture(billboardLarge,"heat_01")
			engineApplyShaderToWorldTexture(billboardLarge,"heat_02")
			engineApplyShaderToWorldTexture(billboardLarge,"heat_03")
			engineApplyShaderToWorldTexture(billboardLarge,"heat_04")
			--engineApplyShaderToWorldTexture(billboardLarge,"ads003 copy")
			engineApplyShaderToWorldTexture(billboardLarge,"hardon_1")
			engineApplyShaderToWorldTexture(billboardLarge,"eris_1")
			engineApplyShaderToWorldTexture(billboardLarge,"prolaps01")
			engineApplyShaderToWorldTexture(billboardLarge,"bobo_3")
			engineApplyShaderToWorldTexture(billboardLarge,"bobo_2")
			engineApplyShaderToWorldTexture(billboardLarge,"bobo_1")
			engineApplyShaderToWorldTexture(billboardLarge,"eris_3")
			engineApplyShaderToWorldTexture(billboardLarge,"billbd1_lae")
			engineApplyShaderToWorldTexture(billboardLarge,"bobobillboard1")
			engineApplyShaderToWorldTexture(billboardLarge,"semi1dirty")
			engineApplyShaderToWorldTexture(billboardLarge,"semi2dirty")
			engineApplyShaderToWorldTexture(billboardLarge,"semi3dirty")
			engineApplyShaderToWorldTexture(billboardLarge,"downtsign12_la")
			engineApplyShaderToWorldTexture(billboardLarge,"prolaps02")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_sprunk_front2")
			engineApplyShaderToWorldTexture(billboardLarge,"zombiegeddon")
			engineApplyShaderToWorldTexture(billboardLarge,"victim_bboard")
			engineApplyShaderToWorldTexture(billboardLarge,"ws_starballs")
			engineApplyShaderToWorldTexture(billboardLarge,"sunbillb03")
			engineApplyShaderToWorldTexture(billboardLarge,"sunbillb10")
			engineApplyShaderToWorldTexture(billboardLarge,"dogbill01")
			engineApplyShaderToWorldTexture(billboardLarge,"base5_1")
			engineApplyShaderToWorldTexture(billboardLarge,"eris_5")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_bs_menu1")
			engineApplyShaderToWorldTexture(billboardLarge,"24hoursign1_lawn")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_sex_sign1")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_zip_1")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_pizza_men1")
			engineApplyShaderToWorldTexture(billboardLarge,"gun_xtra4")
			engineApplyShaderToWorldTexture(billboardLarge,"cj_bobo")
			engineApplyShaderToWorldTexture(billboardLarge,"rodesign02_la")

			--[[
			engineApplyShaderToWorldTexture(billboardLarge,"snpedtest1")
			engineApplyShaderToWorldTexture(billboardLarge,"shad_ped")
			engineApplyShaderToWorldTexture(billboardLarge,"newsvan92decal128")
			]]
			--heat_02,, cokopos_1, eris_2, homies_2, hardon_1, eris_1, diderSachs01, homies_2, , bobo_2
		end
	end
)



Ads = {}

CurrentAd = 1

addEvent("onClientRecieveAd", true)

addEventHandler("onClientRecieveAd", getRootElement(),
	function(tAds)
		Ads = tAds

		for k,v in ipairs(Ads) do
			v["Text"] = string.gsub(v["Text"], "\\oe", "ö")
			v["Text"] = string.gsub(v["Text"], "\\ae", "ä")
			v["Text"] = string.gsub(v["Text"], "\\ue", "ü")
			v["Text"] = string.gsub(v["Text"], "\\n", "\n")
			v["Text"] = string.gsub(v["Text"], "\\sz", "ß")
			v["Text"] = string.gsub(v["Text"], "\\Oe", "Ö")
			v["Text"] = string.gsub(v["Text"], "\\Ae", "Ä")
			v["Text"] = string.gsub(v["Text"], "\\Ue", "Ü")
			v["Name"] = string.gsub(v["Name"], "\\oe", "ö")
			v["Name"] = string.gsub(v["Name"], "\\ae", "ä")
			v["Name"] = string.gsub(v["Name"], "\\ue", "ü")
			v["Name"] = string.gsub(v["Name"], "\\n", "\n")
			v["Name"] = string.gsub(v["Name"], "\\sz", "ß")
			v["Name"] = string.gsub(v["Name"], "\\Oe", "Ö")
			v["Name"] = string.gsub(v["Name"], "\\Ae", "Ä")
			v["Name"] = string.gsub(v["Name"], "\\Ue", "Ü")
		end
	end
)


addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			triggerServerEvent("onClientRequestAds", getLocalPlayer(), getLocalPlayer())

			setTimer(
				function()
					triggerServerEvent("onClientRequestAds", getLocalPlayer(), getLocalPlayer())
				end
			,60000, 0)

			setTimer(
				function()
					if (#Ads > CurrentAd) then
						CurrentAd = CurrentAd+1
					else
						CurrentAd = 1
					end


					local sizex, sizey = 2, 2

					if(toboolean(config:getConfig("lowrammode"))) then
						sizex, sizey = 0.5, 0.5
					end

					local ta = dxCreateRenderTarget(550*sizex, 270*sizey)
					if(ta) then
						dxSetRenderTarget(ta, true)

						dxDrawImage(0,0, 550*sizex, 270*sizey,"res/images/board.png")
						if (Ads[CurrentAd]) then
							if (not(Ads[CurrentAd]["Telephone"])) then
								Ads[CurrentAd]["Telephone"] = "-"
							end
							dxDrawText(Ads[CurrentAd]["Name"] --[[.." (Tel. "..Ads[CurrentAd]["Telephone"]..")"]], 20*sizex, 0, 520*sizex, 60*sizey, tocolor(0, 0, 0), 2*sizex, "default-bold", "left", "center", true, true)
							dxDrawText(Ads[CurrentAd]["Text"], 20*sizex, 70*sizey, 520*sizex, 260*sizey, tocolor(0, 0, 0), 2*sizex, "default-bold", "left", "top", true, true)

							dxSetRenderTarget()


							dxSetShaderValue(billboardLarge,"Tex",ta)

						end

						destroyElement(ta)
					end
				end, 15000, 0
			)
		end
	end
)
