--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cAdManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cAdManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// init         		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAdManager:init()
   self.m_uShader    = dxCreateShader("res/shader/texture.fx")
   self.m_uTexture   = dxCreateTexture("res/images/board.png")


   dxSetShaderValue(self.m_uShader, "Tex", self.m_uTexture)

   for _, tex in pairs(self.m_tblTextures) do
      engineApplyShaderToWorldTexture(self.m_uShader, tex) -- Basta
   end


   self:reload()

   self.m_uReloadTimer     = setTimer(function() self:reload() end, self.m_iReloadTime, 0)
   self.m_uChangeTimer     = setTimer(function() self:changeAd() end, self.m_iChangeTime, 0)
end

-- ///////////////////////////////
-- ///// reload         	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAdManager:reload()
   triggerServerEvent("onClientRequestAds", getLocalPlayer(), getLocalPlayer())
end

-- ///////////////////////////////
-- ///// changeAd         	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAdManager:changeAd()
   if not(toboolean(config:getConfig("disableads"))) then
      if(self.m_iCurAd > #self.m_tblAds) then
         self.m_iCurAd = 1;
      else
         self.m_iCurAd = self.m_iCurAd+1;
      end

      local sizex, sizey = 2, 2

      if(toboolean(config:getConfig("lowrammode"))) then
         sizex, sizey = 0.5, 0.5
      end

      local ta = dxCreateRenderTarget(550*sizex, 270*sizey)
      if(ta) then
         dxSetRenderTarget(ta, true)

         dxDrawImage(0,0, 550*sizex, 270*sizey,"res/images/board.png")

         if(self.m_tblAds[self.m_iCurAd]) then
            if (not(self.m_tblAds[self.m_iCurAd]["Telephone"])) then
               self.m_tblAds[self.m_iCurAd]["Telephone"] = "-"
            end
            dxDrawText(self.m_tblAds[self.m_iCurAd]["Name"] --[[.." (Tel. "..Ads[CurrentAd]["Telephone"]..")"]], 20*sizex, 0, 520*sizex, 60*sizey, tocolor(0, 0, 0), 2*sizex, "default-bold", "left", "center", true, true)
            dxDrawText(self.m_tblAds[self.m_iCurAd]["Text"], 20*sizex, 70*sizey, 520*sizex, 260*sizey, tocolor(0, 0, 0), 2*sizex, "default-bold", "left", "top", true, true)

            dxSetRenderTarget()

            dxSetShaderValue(self.m_uShader, "Tex", ta)

         end
         dxSetRenderTarget(nil);
         destroyElement(ta)
      end
   end
end

-- ///////////////////////////////
-- ///// onAdsReceive 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAdManager:onAdsReceive(tblAds)
   self.m_tblAds = tblAds;

   for k,v in ipairs(self.m_tblAds) do
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

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAdManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientRecieveAd", true)

    self.m_iCurAd       = 1;

    self.m_tblAds       = {}
    self.m_iReloadTime  = 60000;      -- Zeit in MS welche die Werbungen neu laden sollen
    self.m_iChangeTime  = 15000;      -- Zeit in MS in welcher eine neue Werbung kommen soll


    self.m_tblTextures = {
      "eris_2",
      "diderSachs01",
      "cokopops_1",
      "homies_1",
      "homies_2",
      "heat_01",
      "heat_02",
      "heat_03",
      "heat_04",
      --"ads003 copy",
      "hardon_1",
      "eris_1",
      "prolaps01",
      "bobo_3",
      "bobo_2",
      "bobo_1",
      "eris_3",
      "billbd1_lae",
      "bobobillboard1",
      "semi1dirty",
      "semi2dirty",
      "semi3dirty",
      "downtsign12_la",
      "prolaps02",
      "cj_sprunk_front2",
      "zombiegeddon",
      "victim_bboard",
      "ws_starballs",
      "sunbillb03",
      "sunbillb10",
      "dogbill01",
      "base5_1",
      "eris_5",
      "cj_bs_menu1",
      "24hoursign1_lawn",
      "cj_sex_sign1",
      "cj_zip_1",
      "cj_pizza_men1",
      "gun_xtra4",
      "cj_bobo",
      "rodesign02_la",
   };

   self.m_funcOnAdsReceive    = function(...) self:onAdsReceive(...) end
   -- Funktionen --

    self:init();

    -- Events --

    addEventHandler("onClientRecieveAd", getLocalPlayer(), self.m_funcOnAdsReceive)
end

-- EVENT HANDLER --
