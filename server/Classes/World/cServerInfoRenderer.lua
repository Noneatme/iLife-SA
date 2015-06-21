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

-- ///////////////////////////////
-- ///// reloadDatas 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:reloadDatas()
   self.m_tblInfos  = {}

   --[[
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

   ]]



   local result_user          = CDatabase:getInstance():query("SELECT COUNT(Name) AS Anzahl FROM user;");
   local result_veh           = CDatabase:getInstance():query("SELECT COUNT(ID) AS Anzahl FROM vehicles;");
   local result_house         = CDatabase:getInstance():query("SELECT COUNT(ID) AS Anzahl FROM houses;");
   local result_totalMoney    = CDatabase:getInstance():query("SELECT (SUM(u.Geld)+SUM(u.Bankgeld)+SUM(f.Depotmoney)) AS Anzahl FROM userdata u, factions f;");

   local result_top10money             = CDatabase:getInstance():query("SELECT Name, (Geld + Bankgeld) AS Anzahl FROM userdata u ORDER BY (Geld + Bankgeld) DESC LIMIT 10;");
   local result_top10playtime          = CDatabase:getInstance():query("SELECT Name, Played_Time AS Anzahl FROM user ORDER BY Played_Time DESC LIMIT 10;");
   local result_top10registered        = CDatabase:getInstance():query("SELECT Name, Register_Date AS Anzahl FROM user ORDER BY Register_Date ASC LIMIT 10;");


   self.m_tblInfos["registeredPlayers"]   = result_user[1]['Anzahl'];
   self.m_tblInfos["vehicles"]            = result_veh[1]['Anzahl'];
   self.m_tblInfos["houses"]              = result_house[1]['Anzahl'];
   self.m_tblInfos["totalMoney"]          = result_totalMoney[1]['Anzahl'];
   self.m_tblInfos["serverOnlineSince"]   = "25.01.2014";
   self.m_tblInfos["dateGenerated"]       = getCurrentDateWithTime();

   self.m_tblInfos["top10usersmoney"]           = {}
   self.m_tblInfos["top10usersplaytime"]        = {}
   self.m_tblInfos["top10usersregistered"]      = {}
   self.m_tblInfos["top10corporations"]         = {}

   for i = 1, 10, 1 do
      if(result_top10money[i]) then
         self.m_tblInfos["top10usersmoney"][i] = result_top10money[i]['Name']..", $"..result_top10money[i]['Anzahl']
      end
   end

   for i = 1, 10, 1 do
      if(result_top10playtime[i]) then
         self.m_tblInfos["top10usersplaytime"][i] = result_top10playtime[i]['Name']..", "..tonumber(math.floor(result_top10playtime[i]['Anzahl'] / 60))..":"..tonumber(math.floor(result_top10playtime[i]['Anzahl'] % 60))
      end
   end

   for i = 1, 10, 1 do
      if(result_top10registered[i]) then
         self.m_tblInfos["top10usersregistered"][i] = result_top10playtime[i]['Name']..", "..result_top10registered[i]['Anzahl'];
      end
   end
end

-- ///////////////////////////////
-- ///// onPlayerRequest 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:onPlayerRequest()
   local uPlayer = client;

   if not(self.m_bGenerated) then
      self:reloadDatas();
      self.m_bGenerated = true;

      setTimer(function()
         self.m_bGenerated = false;
      end, 60*60*1000, 1)
   end

   triggerClientEvent(uPlayer, "onServerInfoRendererDatasGet", uPlayer, self.m_tblInfos);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerInfoRenderer:constructor(...)
   addEvent("onServerInfoRendererPlayerRequestFiles", true)

    -- Klassenvariablen --
    self.m_tblInfos  = {}

    -- Funktionen --
    self.m_funcOnPlayerRequest      = function(...) self:onPlayerRequest(...) end

    -- Events --
    addEventHandler("onServerInfoRendererPlayerRequestFiles", getRootElement(), self.m_funcOnPlayerRequest)
end

-- EVENT HANDLER --
