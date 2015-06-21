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
-- ## Name: cServerInfoRenderer.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cServerInfoRenderer = inherit(cSingleton);

--[[

]]
-- ////////////////////////////////
-- ///// renderTexture 		//////
-- ///// Returns: texture		///
-- //////////////////////////////

function cServerInfoRenderer:renderTexture()
   local renderTarget      = dxCreateRenderTarget(1600, 900, false);
   renderTarget:setAsTarget();

   dxDrawImage(0, 0, 1600, 900, "res/images/render/serverinfos.jpg")

   dxDrawLine(0, 0, 1600, 0, tocolor(0, 0, 0, 255), 5)
   dxDrawLine(1600, 0, 1600, 900, tocolor(0, 0, 0, 255), 5)
   dxDrawLine(1600, 900, 0, 900, tocolor(0, 0, 0, 255), 5)
   dxDrawLine(0, 900, 0, 0, tocolor(0, 0, 0, 255), 5)

   dxDrawText("Global Server Statistics: (Generated: "..self.m_tblInfos["dateGenerated"]..")", 15, 15, 50, 50, tocolor(0, 0, 0, 255), 4, "default-bold")
   dxDrawText("Global Server Statistics: (Generated: "..self.m_tblInfos["dateGenerated"]..")", 10, 10, 50, 50, tocolor(20, 255, 200, 255), 4, "default-bold")

   -- Server Infos --

   local text = "Total Registered Players: "..self.m_tblInfos["registeredPlayers"]

   local y = 105;
   local x = 30;

   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   text = "Total User Vehicles: "..self.m_tblInfos["vehicles"]
   y = y+30

   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   text = "Total Houses: "..self.m_tblInfos["houses"]
   y = y+30

   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   text = "Total Money In Circulation: $"..self.m_tblInfos["totalMoney"]
   y = y+30

   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   text = "Server Online Since: "..self.m_tblInfos["serverOnlineSince"]
   y = y+30

   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   -- Meistes Geld --
   y = y+190

   text = "Top 10 Users (Money):";
   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   local oldy = y;
   for i = 1, 10, 1 do
      y = y+30;
      if(self.m_tblInfos["top10usersmoney"] and self.m_tblInfos["top10usersmoney"][i]) then
         text = i..". "..self.m_tblInfos["top10usersmoney"][i] or "-";
      else
         text = "-"
      end
      dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
      dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")
   end

   x = 380;
   y = oldy;
   text = "Top 10 Users (Playtime):";
   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")


   for i = 1, 10, 1 do
      y = y+30;
      if(self.m_tblInfos["top10usersplaytime"] and self.m_tblInfos["top10usersplaytime"][i]) then
         text = i..". "..self.m_tblInfos["top10usersplaytime"][i] or "-";
      else
         text = "-"
      end
      dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
      dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")
   end

   x = x+380;
   y = oldy;
   text = "Top 10 Users (Registered):";
   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   for i = 1, 10, 1 do
      y = y+30;
      if(self.m_tblInfos["top10usersregistered"] and self.m_tblInfos["top10usersregistered"][i]) then
         text = i..". "..self.m_tblInfos["top10usersregistered"][i] or "-";
      else
         text = "-"
      end
      dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
      dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")
   end

   x = x+380;
   y = oldy;
   text = "Top 10 Corporations (Members):";
   dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
   dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   for i = 1, 10, 1 do
      y = y+30;
      if(self.m_tblInfos["top10corporations"] and self.m_tblInfos["top10corporations"][i]) then
         text = i..". "..self.m_tblInfos["top10corporations"][i] or "-";
      else
         text = "-"
      end
      dxDrawText(text, x+2, y+2, 50, 50, tocolor(0, 0, 0, 255), 2, "default-bold")
      dxDrawText(text, x, y+2, 50, 50, tocolor(255, 255, 255, 255), 2, "default-bold")

   end

   dxSetRenderTarget(nil)
   return renderTarget;
end

-- ///////////////////////////////
-- ///// refreshBillboard  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:refreshBillboard()
   if(self.m_uTexture) then
      destroyElement(self.m_uTexture);
   else
      self.m_uShader = dxCreateShader("res/shader/texture.fx")
   end

   self.m_uTexture = self:renderTexture();

   dxSetShaderValue(self.m_uShader, "Tex", self.m_uTexture);
   engineApplyShaderToWorldTexture(self.m_uShader, "cokopops_2", self.m_uBillboard);
end

-- ///////////////////////////////
-- ///// onInfosGet   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:onInfosGet(tblInfos)
   self.m_tblInfos = tblInfos;

   self:refreshBillboard()
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:constructor(...)
   addEvent("onServerInfoRendererDatasGet", true)

   self.m_uBillboard    = Object(8293, 1480, -1774.5999755859, 27, 0, 0, 52.75);
   -- Texture: cokopops_2

    -- Klassenvariablen --
    self.m_tblInfos  =
    {
      ["registeredPlayers"]      = 1522,
      ["vehicles"]               = 500,
      ["houses"]                 = 252,
      ["totalMoney"]             = 252525222,
      ["serverOnlineSince"]      = "03.05.2013",
      ["dateGenerated"]          = "03.05.2015 25:25",

      ["top10usersmoney"]     =
      {
         [1] = "User, Money",
         [2] = "User, Money",
         [3] = "User, Money",
         [4] = "User, Money",
         [5] = "User, Money",
         [6] = "User, Money",
         [7] = "User, Money",
         [8] = "User, Money",
         [9] = "User, Money",
         [10] = "User, Money",
      },
      ["top10usersplaytime"]     =
      {
         [1] = "User, Money",
         [2] = "User, Money",
         [3] = "User, Money",
         [4] = "User, Money",
         [5] = "User, Money",
         [6] = "User, Money",
         [7] = "User, Money",
         [8] = "User, Money",
         [9] = "User, Money",
         [10] = "User, Money",
      },
      ["top10usersregistered"]     =
      {
         [1] = "User, Money",
         [2] = "User, Money",
         [3] = "User, Money",
         [4] = "User, Money",
         [5] = "User, Money",
         [6] = "User, Money",
         [7] = "User, Money",
         [8] = "User, Money",
         [9] = "User, Money",
         [10] = "User, Money",
      },
      ["top10corporations"]     =
      {
         [1] = "User, Money",
         [2] = "User, Money",
         [3] = "User, Money",
         [4] = "User, Money",
         [5] = "User, Money",
         [6] = "User, Money",
         [7] = "User, Money",
         [8] = "User, Money",
         [9] = "User, Money",
         [10] = "User, Money",
      },
   }

    -- Funktionen --
    self.m_funcOnServerInfosGet  = function(...) self:onInfosGet(...) end

    -- Events --
    addEventHandler("onServerInfoRendererDatasGet", getLocalPlayer(), self.m_funcOnServerInfosGet)

    triggerServerEvent("onServerInfoRendererPlayerRequestFiles", getLocalPlayer())
end

-- EVENT HANDLER --
