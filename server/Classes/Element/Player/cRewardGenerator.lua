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
-- ## Name: cPlayer_RewardGenerator.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################



cPlayer_RewardGenerator = inherit(cSingleton);

--[[

   Erklaerung: Klasse zur Generierung des Login-Rewards beim erfolgreichen Einloggen von mehreren Tagen hintereinander

]]

-- ///////////////////////////////
-- ///// generateReward 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPlayer_RewardGenerator:generateReward(iLevel)
   local randTBL = self.m_tblRewards["day0"];

   if(iLevel < 3) then
      randTBL = self.m_tblRewards["day0"];
   elseif(iLevel < 7) then
      randTBL = self.m_tblRewards["day3"];
   else
      randTBL = self.m_tblRewards["day7"];

      if(cBasicFunctions:calculateProbability(1)) then -- 1% Wahrscheinlichkeit
         randTBL = self.m_tblRewards["veryrare"];
      end
   end

   local tbl = randTBL[math.random(1, #randTBL)];

   return tbl;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPlayer_RewardGenerator:constructor(...)
   -- Klassenvariablen --
   math.randomseed(math.random(0, 99999999));
   self.m_tblRewards      =
   {
      ["day0"] =
      {
         {"geld", 1000},
         {"geld", 2500},
         {"geld", 5000},
         {"geld", 10000},
         {"item", 267, math.random(1, 2)},    -- Rakete: 2
         {"item", 266, math.random(5, 15)},   -- Boeller: 10
         {"item", 270, math.random(1, 3)},    -- Roemischer Kerze: 2
         {"item", 261, math.random(1, 3)},    -- Reperaturkit: 2
         {"item", 6, math.random(5, 15)},     -- Rubbellos
         {"item", 301, math.random(5, 15)},   -- Artefakt Aufladung 1
         {"item", 302, math.random(3, 5)},   -- Artefakt Aufladung 2
         {"item", 303, math.random(1, 3)},   -- Artefakt Aufladung 3
         {"item", 229, math.random(1, 7)},   -- Eisen
         {"item", 251, math.random(1, 7)},   -- Schwarzpulver
      },
      ["day3"] =
      {
         {"geld", 5000},
         {"geld", 7000},
         {"geld", 10000},
         {"geld", 15000},
         {"item", 5, math.random(10, 50)},    -- Chicken burger
         {"item", 4, math.random(10, 50)},    -- Donuts
         {"item", 301, math.random(10, 15)},   -- Artefakt Aufladung 1
         {"item", 302, math.random(10, 15)},   -- Artefakt Aufladung 2
         {"item", 303, math.random(5, 15)},   -- Artefakt Aufladung 3
         {"item", 265, math.random(5, 15)},   -- Geldsack

         {"item", 50, math.random(1, 5)},   -- Kleine Huette
         {"item", 259, math.random(1, 5)},   -- Lagerkiste
         {"item", 295, math.random(1, 5)},   -- Weisser Baum

      },
      ["day7"] =
      {
         {"geld", 10000},
         {"geld", 15000},
         {"geld", 20000},
         {"item", 5, math.random(10, 50)},    -- Chicken burger
         {"item", 4, math.random(10, 50)},    -- Donuts
         {"item", 301, math.random(15, 25)},   -- Artefakt Aufladung 1
         {"item", 302, math.random(15, 25)},   -- Artefakt Aufladung 2
         {"item", 303, math.random(10, 25)},   -- Artefakt Aufladung 3
         {"item", 265, math.random(25, 55)},   -- Geldsack
         {"item", 51, math.random(1, 5)},   -- Radio
         {"item", 218, math.random(1, 1)},   -- Garage
         {"item", 219, math.random(1, 1)},   -- Bauhuette
         {"item", 267, math.random(10, 20)},    -- Rakete: 2
         {"item", 268, math.random(3, 7)},      -- Raketenbatterie
         {"item", 269, math.random(1, 3)},    -- Kugelbombe
         {"item", 272, math.random(1, 3)},    -- Groundshell
         {"item", 259, math.random(1, 5)},   -- Lagerkiste
         {"item", 295, math.random(1, 5)},   -- Weisser Baum

      },

      ["veryrare"] =
      {
         {"geld", 50000},                    -- Geld
         {"item", 271, math.random(2, 3)},   -- Roemische Kerzenbatterie
         {"item", 181, math.random(1, 1)},   -- Muelltonne
         {"item", 179, math.random(1, 1)},   -- Sodaautomat
         {"item", 183, math.random(1, 1)},   -- Telefonhaus
         {"item", 37, math.random(1, 1)},   -- Werbeantrag
         {"item", 263, math.random(1, 1)},   -- Namensaenderung

      }
   }

   -- Funktionen --


   -- Events --
end

-- EVENT HANDLER --
