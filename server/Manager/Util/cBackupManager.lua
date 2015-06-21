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
-- ## Name: cBackupManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cBackupManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// doBackup    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBackupManager:doBackup()
    for tbl, bool in pairs(self.m_tblTablesToBackup) do
        if(bool) then
            CDatabase:getInstance():queryAsync("SELECT * FROM ??;", self.m_uReturnQueryFunction, tbl, tbl)
        end
    end
end

-- ///////////////////////////////
-- ///// returnQuery 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBackupManager:returnQuery(result)
    local file = File("backups/")
    for index, row in pairs(result) do

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBackupManager:constructor(...)
    -- Klassenvariablen --
    self.m_tblTablesToBackup        =
    {
        ["user"]                    = true,
        ["bans"]                    = true,
        ["corporation_vehicle"]     = true,
        ["corporation_connections"] = true,
        ["corporation_business"]    = true,
        ["corporations"]            = true,
        ["drugs"]                   = true,
        ["gangareas"]               = true,
        ["house_objects"]           = true,
        ["houses"]                  = true,
        ["inventory"]               = true,
        ["joindata"]                = true,
        ["system"]                  = true,
        ["user"]                    = true,
        ["userdata"]                = true,
        ["vehicles"]                = true,
        ["logs"]                    = true,
    }

    -- Funktionen --
    self.m_uReturnQueryFunction     = function(...) self:returnQuery(...) end

    -- Events --
end

-- EVENT HANDLER --
