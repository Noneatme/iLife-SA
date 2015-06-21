--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local sX,sY = guiGetScreenSize()

BankGuiShown = false

Bank = {
["Window"] = false,
["Label"] = {},
["Button"] = {},
["Edit"] = {}
}

addEvent("BankGuiOpen",true)
addEventHandler("BankGuiOpen", getLocalPlayer(), function()
	if (not clientBusy and not BankGuiShown) then
		closeBankGui()

		Bank["Window"] = new(CDxWindow, "Bank of San Andreas", 305, 427, true, true, "Center|Middle")

		Bank["Label"][1] = new(CDxLabel, "Girokonto", 0, 50, 300, 20, tocolor(255,255,255,255), 1.5, "default", "center", "center", Bank["Window"])
		Bank["Label"][2] = new(CDxLabel, "Kontostand: "..formNumberToMoneyString(getElementData(getLocalPlayer(), "Bankgeld")), 20, 100, 280, 20, tocolor(255,255,255,255), 1.3, "default", "left", "center", Bank["Window"])
		Bank["Label"][3] = new(CDxLabel, "Bargeld: "..formNumberToMoneyString(getElementData(getLocalPlayer(), "Geld")), 20, 125, 280, 20, tocolor(255,255,255,255), 1.3, "default", "left", "center", Bank["Window"])
		Bank["Label"][4] = new(CDxLabel, "Betrag:", 10, 170, 290, 30, tocolor(255,255,255,255), 2, "default", "left", "center", Bank["Window"])
		Bank["Edit"][1] = new(CDxEdit, "0", 10, 205, 280, 50, "Number", tocolor(0,0,0,255), Bank["Window"])
		Bank["Button"][1] = new(CDxButton, "Einzahlen", 5, 260, 290, 50, tocolor(255,255,255,255), Bank["Window"])
		Bank["Button"][2] = new(CDxButton, "Auszahlen", 5, 320, 290, 50, tocolor(255,255,255,255), Bank["Window"])

		Bank["Button"][3] = new(CDxButton, "Verwalten", 0, 0, 100, 40, tocolor(125,125,125,255), Bank["Window"])
		Bank["Button"][4] = new(CDxButton, "Überweisen", 100, 0, 100, 40, tocolor(255,255,255,255), Bank["Window"])
		Bank["Button"][5] = new(CDxButton, "Fraktion", 200, 0, 100, 40, tocolor(255,255,255,255), Bank["Window"])

		Bank["Button"][1]:addClickFunction(
		function ()
			if (tonumber(Bank["Edit"][1]:getText())>0) then
				triggerServerEvent( "onPlayerBankDeposit", getLocalPlayer(), tonumber(Bank["Edit"][1]:getText()) )
			end
		end
		)

		Bank["Button"][2]:addClickFunction(
		function ()
			if (tonumber(Bank["Edit"][1]:getText())>0) then
				triggerServerEvent( "onPlayerBankWithdraw", getLocalPlayer(), tonumber(Bank["Edit"][1]:getText()) )
			end
		end
		)

		Bank["Button"][4]:addClickFunction(
		function ()
			Bank["Window"]:hide()
			delete(Bank["Window"])
			Bank["Window"] = false
			BankGuiShown = false
			triggerEvent("BankTransferGuiOpen", getLocalPlayer())
		end
		)

		Bank["Button"][5]:addClickFunction(
		function ()
			if (getElementData(localPlayer, "Fraktion") ~= 0) then
				Bank["Window"]:hide()
				delete(Bank["Window"])
				Bank["Window"] = false
				BankGuiShown = false
				triggerEvent("FactionbankGuiOpen", getLocalPlayer())
			else
				showInfoBox("error", "Du gehörst keiner Fraktion an!")
			end
		end
		)

		Bank["Window"]:add(Bank["Label"][1])
		Bank["Window"]:add(Bank["Label"][2])
		Bank["Window"]:add(Bank["Label"][3])
		Bank["Window"]:add(Bank["Label"][4])
		Bank["Window"]:add(Bank["Edit"][1])
		Bank["Window"]:add(Bank["Button"][1])
		Bank["Window"]:add(Bank["Button"][2])
		Bank["Window"]:add(Bank["Button"][3])
		Bank["Window"]:add(Bank["Button"][4])
		Bank["Window"]:add(Bank["Button"][5])

		Bank["Window"]:setHideFunction(function() closeBankGui() end)

		Bank["Window"]:show()
		BankGuiShown = true
	end
end
)

function closeBankGui()
	if (Bank["Window"] ~= false) then
		Bank["Window"]:hide()
		delete(Bank["Window"])
		Bank["Window"] = false
		setTimer( function() BankGuiShown = false end, 1000,1)
	end
end

Banktransfer = {
["Window"] = false,
["Label"] = {},
["Button"] = {},
["Edit"] = {}
}

addEvent("BankTransferGuiOpen",true)
addEventHandler("BankTransferGuiOpen", getLocalPlayer(), function()
	if (not clientBusy and not BankGuiShown) then
		closeBanktransferGui()

		Banktransfer["Window"] = new(CDxWindow, "Bank of San Andreas", 305, 427, true, true, "Center|Middle")

		Banktransfer["Label"][1] = new(CDxLabel, "Überweisen", 0, 50, 300, 20, tocolor(255,255,255,255), 1.5, "default", "center", "center", Banktransfer["Window"])
		Banktransfer["Label"][2] = new(CDxLabel, "Kontostand: "..formNumberToMoneyString(getElementData(getLocalPlayer(), "Bankgeld")), 20, 100, 280, 20, tocolor(255,255,255,255), 1.3, "default", "left", "center", Banktransfer["Window"])
		Banktransfer["Label"][3] = new(CDxLabel, "Name:", 10, 130, 290, 50, tocolor(255,255,255,255), 2, "default", "left", "center", Banktransfer["Window"])
		Banktransfer["Edit"][1] = new(CDxEdit, "", 10, 180, 280, 50, "normal", tocolor(0,0,0,255), Banktransfer["Window"])
		Banktransfer["Label"][4] = new(CDxLabel, "Betrag:", 10, 235, 255, 50, tocolor(255,255,255,255), 2, "default", "left", "center", Banktransfer["Window"])
		Banktransfer["Edit"][2] = new(CDxEdit, "0", 10, 280, 280, 50, "Number", tocolor(0,0,0,255), Banktransfer["Window"])
		Banktransfer["Button"][1] = new(CDxButton, "Überweisen", 5, 335, 290, 50, tocolor(255,255,255,255), Banktransfer["Window"])

		Banktransfer["Button"][2] = new(CDxButton, "Verwalten", 0, 0, 100, 40, tocolor(255,255,255,255), Banktransfer["Window"])
		Banktransfer["Button"][3] = new(CDxButton, "Überweisen", 100, 0, 100, 40, tocolor(125,125,125,255), Banktransfer["Window"])
		Banktransfer["Button"][4] = new(CDxButton, "Fraktion", 200, 0, 100, 40, tocolor(255,255,255,255), Banktransfer["Window"])

		Banktransfer["Button"][1]:addClickFunction(
		function ()
			if (tonumber(Banktransfer["Edit"][2]:getText())>0) then
				triggerServerEvent( "onPlayerBankTransfer", getLocalPlayer(),Banktransfer["Edit"][1]:getText(), tonumber(Banktransfer["Edit"][2]:getText()) )
			end
		end
		)

		Banktransfer["Button"][2]:addClickFunction(
		function ()
			Banktransfer["Window"]:hide()
			delete(Banktransfer["Window"])
			Banktransfer["Window"] = false
			BankGuiShown = false
			triggerEvent("BankGuiOpen", getLocalPlayer())
		end
		)

		Banktransfer["Button"][4]:addClickFunction(
		function ()
			if (getElementData(localPlayer, "Fraktion") ~= 0) then
				Banktransfer["Window"]:hide()
				delete(Banktransfer["Window"])
				Banktransfer["Window"] = false
				BankGuiShown = false
				triggerEvent("FactionbankGuiOpen", getLocalPlayer())
			else
				showInfoBox("error", "Du gehörst keiner Fraktion an!")
			end
		end
		)

		Banktransfer["Window"]:add(Banktransfer["Label"][1])
		Banktransfer["Window"]:add(Banktransfer["Label"][2])
		Banktransfer["Window"]:add(Banktransfer["Label"][3])
		Banktransfer["Window"]:add(Banktransfer["Label"][4])
		Banktransfer["Window"]:add(Banktransfer["Edit"][1])
		Banktransfer["Window"]:add(Banktransfer["Edit"][2])
		Banktransfer["Window"]:add(Banktransfer["Button"][1])
		Banktransfer["Window"]:add(Banktransfer["Button"][2])
		Banktransfer["Window"]:add(Banktransfer["Button"][3])
		Banktransfer["Window"]:add(Banktransfer["Button"][4])

		Banktransfer["Window"]:setHideFunction(function() closeBanktransferGui() end)

		Banktransfer["Window"]:show()
		BankGuiShown = true
	end
end
)

function closeBanktransferGui()
	if (Banktransfer["Window"] ~= false) then
		Banktransfer["Window"]:hide()
		delete(Banktransfer["Window"])
		Banktransfer["Window"] = false
		setTimer( function() BankGuiShown = false end, 1000,1)
	end
end

Factionbank = {
["Window"] = false,
["Label"] = {},
["Button"] = {},
["Edit"] = {}
}

addEvent("FactionbankGuiOpen",true)
addEventHandler("FactionbankGuiOpen", getLocalPlayer(), function()
	if (not clientBusy and not BankGuiShown) then
		closeFactionbankGui()

		Factionbank["Window"] = new(CDxWindow, "Bank of San Andreas", 305, 427, true, true, "Center|Middle")

		Factionbank["Label"][1] = new(CDxLabel, "Fraktionskasse", 0, 50, 300, 20, tocolor(255,255,255,255), 1.5, "default", "center", "center", Factionbank["Window"])
		Factionbank["Label"][2] = new(CDxLabel, "Kontostand: "..formNumberToMoneyString(getElementData(getLocalPlayer(), "Bankgeld")), 20, 100, 280, 20, tocolor(255,255,255,255), 1.3, "default", "left", "center", Factionbank["Window"])
		Factionbank["Label"][3] = new(CDxLabel, "Fraktionskasse: "..formNumberToMoneyString(FactionData["Money"]), 20, 125, 280, 20, tocolor(255,255,255,255), 1.3, "default", "left", "center", Factionbank["Window"])
		Factionbank["Label"][4] = new(CDxLabel, "Betrag:", 10, 170, 290, 30, tocolor(255,255,255,255), 2, "default", "left", "center", Factionbank["Window"])
		Factionbank["Edit"][1] = new(CDxEdit, "0", 10, 205, 280, 50, "Number", tocolor(0,0,0,255), Factionbank["Window"])
		Factionbank["Button"][1] = new(CDxButton, "Einzahlen", 5, 260, 290, 50, tocolor(255,255,255,255), Factionbank["Window"])
		Factionbank["Button"][2] = new(CDxButton, "Auszahlen", 5, 320, 290, 50, tocolor(255,255,255,255), Factionbank["Window"])

		Factionbank["Button"][3] = new(CDxButton, "Verwalten", 0, 0, 100, 40, tocolor(125,125,125,255), Factionbank["Window"])
		Factionbank["Button"][4] = new(CDxButton, "Überweisen", 100, 0, 100, 40, tocolor(255,255,255,255), Factionbank["Window"])
		Factionbank["Button"][5] = new(CDxButton, "Fraktion", 200, 0, 100, 40, tocolor(255,255,255,255), Factionbank["Window"])

		Factionbank["Button"][1]:addClickFunction(
		function ()
			if (tonumber(Factionbank["Edit"][1]:getText())>0) then
				triggerServerEvent( "onPlayerPayInFactionBank", getLocalPlayer(),Factionbank["Edit"][1]:getText())
			end
		end
		)

		Factionbank["Button"][2]:addClickFunction(
		function ()
			if (tonumber(Factionbank["Edit"][1]:getText())>0) then
				triggerServerEvent( "onPlayerPayOutFactionBank", getLocalPlayer(),Factionbank["Edit"][1]:getText())
			end
		end
		)

		Factionbank["Button"][3]:addClickFunction(
		function ()
			Factionbank["Window"]:hide()
			delete(Factionbank["Window"])
			Factionbank["Window"] = false
			BankGuiShown = false
			triggerEvent("BankGuiOpen", getLocalPlayer())
		end
		)

		Factionbank["Button"][4]:addClickFunction(
		function ()
			Factionbank["Window"]:hide()
			delete(Factionbank["Window"])
			Factionbank["Window"] = false
			BankGuiShown = false
			triggerEvent("BankTransferGuiOpen", getLocalPlayer())
		end
		)

		Factionbank["Window"]:add(Factionbank["Label"][1])
		Factionbank["Window"]:add(Factionbank["Label"][2])
		Factionbank["Window"]:add(Factionbank["Label"][3])
		Factionbank["Window"]:add(Factionbank["Label"][4])
		Factionbank["Window"]:add(Factionbank["Edit"][1])
		Factionbank["Window"]:add(Factionbank["Button"][1])
		Factionbank["Window"]:add(Factionbank["Button"][2])
		Factionbank["Window"]:add(Factionbank["Button"][3])
		Factionbank["Window"]:add(Factionbank["Button"][4])
		Factionbank["Window"]:add(Factionbank["Button"][5])

		Factionbank["Window"]:setHideFunction(function() closeFactionbankGui() end)

		Factionbank["Window"]:show()
		BankGuiShown = true
	end
end
)

function closeFactionbankGui()
	if (Factionbank["Window"] ~= false) then
		Factionbank["Window"]:hide()
		delete(Factionbank["Window"])
		Factionbank["Window"] = false
		setTimer( function() BankGuiShown = false end, 1000,1)
	end
end

addEvent("BankGuiRefresh",true)
addEventHandler("BankGuiRefresh", getLocalPlayer(), function()
	if (Bank["Window"]) then
		Bank["Label"][2]:setText("Kontostand: "..formNumberToMoneyString(math.floor(getElementData(getLocalPlayer(), "Bankgeld"))))
		Bank["Label"][3]:setText("Bargeld: "..formNumberToMoneyString(math.floor(getElementData(getLocalPlayer(), "Geld"))))
	end
	if (Banktransfer["Window"]) then
		Banktransfer["Label"][2]:setText("Kontostand: "..formNumberToMoneyString(math.floor(getElementData(getLocalPlayer(), "Bankgeld"))))
	end
	if (Factionbank["Window"]) then
		Factionbank["Label"][2]:setText("Kontostand: "..formNumberToMoneyString(math.floor(getElementData(getLocalPlayer(), "Bankgeld"))))
		Factionbank["Label"][3]:setText("Fraktionskasse: "..formNumberToMoneyString(math.floor(FactionData["Money"])))
	end
end
)
