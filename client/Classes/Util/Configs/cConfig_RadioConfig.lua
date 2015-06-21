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
-- ## Name: Script.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cConfig_RadioConfig = inherit(cConfiguration);

--[[

]]

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfig_RadioConfig:constructor(...)
    -- Klassenvariablen --
    self.defaultValues      =
    {
        ["radenabled_vehicle"]             = "true",
        ["radenabled_object"]              = "true",
    }

    self.xtraValues      =
    {
        ["radio_1"]                             = "Technobase.FM|http://listen.technobase.fm/tunein-dsl-pls",
        ["radio_2"]                             = "Housetime.FM|http://listen.housetime.fm/tunein-dsl-pls",
        ["radio_3"]                             = "Hardbase.FM|http://listen.hardbase.fm/tunein-dsl-pls",
        ["radio_4"]                             = "YouFM Rock|http://gffstream.ic.llnwd.net/stream/gffstream_mp3_w77a",
        ["radio_5"]                             = "Techno4Ever.FM Mainstream|http://tunein01.t4e.dj/main/dsl/mp3",
        ["radio_6"]                             = "Techno4Ever.FM Clubstream|http://tunein01.t4e.dj/club/dsl/mp3",
        ["radio_7"]                             = "Trancebase.FM|http://listen.trancebase.fm/tunein-dsl-pls",
        ["radio_8"]                             = "Coretime.FM|http://listen.coretime.fm/tunein-dsl-pls",
        ["radio_9"]                             = "EinsLIVE|http://gffstream.ic.llnwd.net/stream/gffstream_stream_wdr_einslive_b",
        ["radio_10"]                            = "Rautemusik.FM - Oriental|http://oriental-high.rautemusik.fm",
        ["radio_11"]                            = "Top 100 Station|http://91.250.76.18:80",
        ["radio_12"]                            = "Dubstep.FM|http://sc147.dlnetworks.net:8000",
        ["radio_13"]                            = "Anarchy of Sound|http://217.114.217.101:8018",
        ["radio_14"]                            = "Rautemusik.FM - 12Punks|http://12punks-high.rautemusik.fm",
        ["radio_15"]                            = "DUBLOVERS.FM|http://stream03.mlc.fm/stream/1/",
        ["radio_16"]                            = "Rockradio.com - Power Metal|http://pub7.rockradio.com:80/rr_powermetal",
        ["radio_17"]                            = "DEFJAY - Rn'B|http://tuner.defjay.de:80",
        ["radio_18"]                            = "Horror FM - Dubstep|http://fm.mtasa.de:8020",
        ["radio_19"]                            = "iLoveRadio|http://www.iloveradio.de//listen.m3u",

    }

    self.m_bInsertJustOnNoneExists      = true;
    -- Funktionen --


    -- Events --
    cConfiguration.constructor(self, "cfg/radio.xml", self.defaultValues, self.m_bInsertJustOnNoneExists);
end

-- EVENT HANDLER --
