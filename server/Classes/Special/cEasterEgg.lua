--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CEasterEgg = inherit(CObject)

function CEasterEgg:constructor()
	local start = getTickCount()
	addEventHandler( "onElementClicked", getRootElement(), 
		function(theButton, theState, thePlayer)
			if (theButton == "left") and (theState == "down") then
				if (getElementType(source) == "player") then
					if (getPlayerName(source) == "ReWrite") then
						Achievements[45]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Dawi") then
						Achievements[46]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Shape") then
						Achievements[47]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Marcelsius") then
						Achievements[48]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Samy") then
						Achievements[49]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "KingK") then
						Achievements[50]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Noneatme") then
						Achievements[51]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Monster") then
						Achievements[52]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Ryker") then
						Achievements[53]:playerAchieved(thePlayer)
						return true
					end
					if (getPlayerName(source) == "Audifire") then
						Achievements[54]:playerAchieved(thePlayer)
						return true
					end
				end
			end
		end
	)
	
	outputServerLog("Eastereggs loaded! (" .. getTickCount() - start .. "ms)")
end

function CEasterEgg:destructor()

end

--Eastereggs

CEasterEggPed = {}

function CEasterEggPed:constructor(Name, Text, AchievementID )
	self.Name = Name
	self.AchievementID = AchievementID or 0
	self.Text = Text
	
	addEventHandler("onElementClicked", self, bind(CEasterEggPed.onClicked, self))
	addEventHandler("onPedWasted", self, bind(CEasterEggPed.onWasted, self))
	setElementData(self, "EastereggPed", true)
	setElementFrozen(self, true)
end

function CEasterEggPed:destructor()

end

function CEasterEggPed:onWasted()
	
end

Jenkins = {
	56,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112
}

function CEasterEggPed:onClicked(mouseButton, buttonState, playerWhoClicked)
	if (mouseButton == "left" and buttonState=="down") then
		outputChatBox(self.Name..": "..self.Text, playerWhoClicked,255,255,255)
		if (self.AchievementID > 0) then
			Achievements[self.AchievementID]:playerAchieved(playerWhoClicked)
		end
		
		for k,v in ipairs(Jenkins) do
			if not playerWhoClicked:hasAchievement(Achievements[v]) then
				return true
			end
		end
		Achievements[113]:playerAchieved(playerWhoClicked)
	end
end

Horror = createPed(264, 2226.7880859375, 1838.6708984375, 10.8203125, 90, nil, nil, false)
enew(Horror, CEasterEggPed, "HorrorClown", "Stereo Mexico? /deletemap!", 24)

Reazon = createPed(10, -688.1181640625 , 938.7607421875 , 13.6328125, 360, nil, nil, false)
enew(Reazon, CEasterEggPed, "Reazon", "Ich will ein Glücksbärchie sein!", 55)

SchrottyJenkins = createPed(158,2351.494140625,-658.6982421875,128.06198120117,181.7688293457, nil, nil, true)
enew(SchrottyJenkins, CEasterEggPed, "Schrotty", "Hey, Ich verkaufe hier seit 30 Jahren meine Gebrauchtwagen!", 56)

BauerJenkins = createPed(158,-365.53125, -1417.5869140625, 29.640625,180, nil, nil, true)
enew(BauerJenkins, CEasterEggPed, "Bauer Jenkins", "Der dümmste Bauer hat die größten Kartoffeln...", 87)

BergsteigerJenkins = createPed(158 ,-2607.2021484375, -1539.2294921875, 421.6911315918, 112, nil, nil, true)
enew(BergsteigerJenkins, CEasterEggPed, "Bergsteiger Jenkins", "Runter kommt man immer!", 88)

VorarbeiterJenkins = createPed(158,  589.8740234375, 871.73828125, -42.497318267822, 270, nil, nil, true)
enew(VorarbeiterJenkins, CEasterEggPed, "Vorarbeiter Jenkins", "Schiiiiiiiiichtwechseeeeeel!", 89)

GolferJenkins = createPed(158,  1305.5517578125, 2799.3564453125, 10.193878173828, 140, nil, nil, true)
enew(GolferJenkins, CEasterEggPed, "Golfer Jenkins", "Komm schon... Glory Holes!", 90)

DealerJenkins = createPed(158,  -2514.9482421875, 2353.55859375, 4.9837732315063, 0, nil, nil, true)
enew(DealerJenkins, CEasterEggPed, "Dealer Jenkins", "Es ist nicht alles Schnee, was weiß ist!", 91)

KoenigJenkins = createPed(158,  2233.4375, 1090.412109375, 40.796875 , 63, nil, nil, true)
enew(KoenigJenkins, CEasterEggPed, "König Jenkins", "Knie nieder, Knappe!", 92)

HolzfaellerJenkins = createPed(158,  -557.4912109375, -196.9306640625, 78.413536071777, 270, nil, nil, true)
enew(HolzfaellerJenkins, CEasterEggPed, "Holzfäller Jenkins", "Der Regenwald war mir nicht genug!", 93)

HasspredigerJenkins = createPed(158,  2225.0458984375, 2522.734375, 11.222219467163, 180, nil, nil, true)
enew(HasspredigerJenkins, CEasterEggPed, "Hassprediger Jenkins", "Das ist Wahnsinn, wir kommen alle in die Hölle. HÖLLE! HÖLLE! HÖLLE! HÖLLE!", 94)

GuentherJenkins = createPed(158, 2000.721, 1523.528, 17.068, 180,  nil, nil, true)
enew(GuentherJenkins, CEasterEggPed, "Günther Jenkins", "Olaf, Olaf, Olaf, ehm... Olaf!", 95)

ChemikerJenkins = createPed(158, 215.045, 1467.044, 23.734, 0, nil, nil, true)
enew(ChemikerJenkins, CEasterEggPed, "Chemiker Jenkins", "Ich hab an den Docks gekündigt! Zu simpel, muahaha!", 96)

AnglerJenkins = createPed(158, -1364.591, 2055.523, 52.515, 90, nil, nil, true)
enew(AnglerJenkins, CEasterEggPed, "Angler Jenkins", "Petri Heil, du Barsch!", 97)

PennerJenkins = createPed(158, -1638.480, -2239.312, 31.476, 90.0219421, nil, nil, true)
enew(PennerJenkins, CEasterEggPed, "Penner Jenkins", "Pfaaaaandflaschen!", 98)

PraesidentJenkins = createPed(158, 1122.943, -2037.115, 69.893, 270.001373, nil, nil, true)
enew(PraesidentJenkins, CEasterEggPed, "Präsident Jenkins", "Yes, we scan!", 99)

IndianerJenkins = createPed(158, -773.525, 1425.603, 13.945, 50.0082397, nil, nil, true)
enew(IndianerJenkins, CEasterEggPed, "Indianer Jenkins", "Huwuschaka, Huwuschaker! Regentanz!", 100)

ImbissJenkins = createPed(158, -2145.612, -425.229, 35.335, 70.0192260, nil, nil, true)
enew(ImbissJenkins, CEasterEggPed, "Imbiss Jenkins", "Einmal HotDog Schranke?", 101)

WetterfroschJenkins = createPed(158, -2535.166, -689.265, 139.320, 180.019653, nil, nil, true)
enew(WetterfroschJenkins, CEasterEggPed, "Wetterfrosch Jenkins", "Oh mein Gott! 13,37 Grad!", 102)

KolumbusJenkins = createPed(158, -1507.574, 1374.769, 3.708, 270.001373, nil, nil, true)
enew(KolumbusJenkins, CEasterEggPed, "Kolumbus Jenkins", "Wo sind die Indianer Babys?", 103)

AutobotJenkins = createPed(158, 2323.601, 1283.187, 97.529, 90.0160522, nil, nil, true)
enew(AutobotJenkins, CEasterEggPed, "Autobot Jenkins", "Me-me-me ... Bdü-Bdü-Bdü... Ferrari", 104)

BibliothekarJenkins = createPed(158, 2257.712, -71.089, 31.601, 270.004119, nil, nil, true)
enew(BibliothekarJenkins, CEasterEggPed, "Bibliothekar Jenkins", "Pschhhhhhhhht!", 105)

MutantJenkins = createPed(158, 1273.863, 294.378, 19.554, 240.006851, nil, nil, true)
enew(MutantJenkins, CEasterEggPed, "Mutant Jenkins", "Ich hätte aufhören sollen bei Burgershot zu essen!", 106)

SchwarzmarktJenkins = createPed(158, 246.714, -54.899, 1.577, 0, nil, nil, true)
enew(SchwarzmarktJenkins, CEasterEggPed, "Schwarzmarkt Jenkins", "Wie wäre es mit Nacktfotos von KingK?", 107)

BigfootJenkins = createPed(158, 1934.386, -496.177, 25.974, 90.0023193, nil, nil, true)
enew(BigfootJenkins, CEasterEggPed, "Bigfoot Jenkins", "Jenkins so kalt... Jenkins haben Hunger!", 108)

CallgirlJenkins = createPed(158, 410.504, -1313.636, 32.351, 170.001342, nil, nil, true)
enew(CallgirlJenkins, CEasterEggPed, "Callgirl Jenkins", "Wo ist meine Perücke hin?!", 109)

EinsamerJenkins = createPed(158, -2091.166, 2313.966, 25.914, 230.013748, nil, nil, true)
enew(EinsamerJenkins, CEasterEggPed, "Einsamer Jenkins", "Bist du mein Freund?", 110)

MedizinerJenkins = createPed(158, -1514.801, 2519.111, 56.070, 0.01098632, nil, nil, true)
enew(MedizinerJenkins, CEasterEggPed, "Mediziner Jenkins", "Eine Rektaluntersuchung? Kommt sofort!", 111)

ChickenJenkins = createPed(158, -236.853, 2664.652, 73.713, 180.009597, nil, nil, true)
enew(ChickenJenkins, CEasterEggPed, "Chicken Jenkins", "Das Hofhuhn... Tock, tocki, tocki, tock, tock!", 112)