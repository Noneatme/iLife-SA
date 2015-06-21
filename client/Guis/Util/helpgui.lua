--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

HelpGui = {
	["Window"] = false,
	["Image"] = {},
	["Button"] = {},
	["List"] = {},
	["Label"] = {}
}

HelpText = {
	["nil"] = "Wähle einen Punkt aus der Liste aus!",
	["Beta"] = "Willkommen in der Beta!\nBitte melde Fehler die du findest im Forum.\nAuch über Verbesserungsvorschläge würden wir uns freuen.\nSolltest du Fragen haben, kannst du ein Teammitglied gerne um Hilfe bitten.",                       
	["Fraktionen"] = "Fraktionen sind Vollzeit Berufe. Zudem gibt es dort verschiedene Ränge.\nDu kannst dich in den Fraktionen hocharbeiten indem dein Chef dich befördert.\nEs gibt folgende böse Fraktionen: Grove Street Families, Los Santos Vagos, Temple Drive Ballas. \nUnd folgende gute Fraktionen: LSPD\nDie guten Fraktionen sorgen für Recht und Ordnung wohingegen die bösen Fraktionen sich gegenseitig bekriegen oder illegale Aktionen starten. \nEs gibt aber auch Neutrale Fraktionen wie die SAT und das LSC Team. Das SAT Team versorgt alle User mit den Neusten Informationen so wie Wetter Daten und weiteren Aktionen. Das LSC Team versucht die Ordnung auf den Straßen von Los Santos zu halten in dem sie Autos abschleppt und auch bei Pannen behilflich ist. /nWenn du in einer Fraktion beitreten möchtest, kannst du dich im Forum unter http://www.ilife-sa.de/ bewerben.  ",
	["Stadthalle"] = "Die Stadthalle befindet sich am gelben Punkt auf der Karte\nIn ihr kannst du Lizenzen wie den Personalausweis oder den PKW-Schein kaufen.\n Außerdem kannst du dort iAdvertisings schalten.\nWenn du einen Job suchst, kannst du dort die Jobs auf der Karte anzeigen lassen. ",
	["Häuser"] = "In San Andreas sind einige Hausmarker gesetzt.\nDiese sind entweder grün, dann sind diese noch nicht besetzt oder blau, dann sind sie besetzt.\nDu kannst dich entweder in bereits von anderen Spielern gekaufte Häuser einmieten, oder dir dein eigenes kaufen.\nDazu laufe einfach in den Marker hinein.",
	["Inventar"] = "Dein Inventar lässt sich mit der Taste \"i\" öffnen\nDort kannst du alles ansehen oder teilweise verwenden, was du gefunden, erworben oder erhandelt hast.",
	["Shops"] = "Es gibt einige Läden in Los Santos.\nIn diesen kannst du deine gesammelten Pfandflaschen abgeben\nOder neue Gegenstände wie eine Kamera oder einen Schokoriegel erwerben.",
	["Jobs"] = "Jobs kannst du jederzeit annehmen und wieder kündigen.\nDiese werden wahrscheinlich deine Haupteinahmequelle sein.\nWenn du einen Job nicht findest, kannst du in der Stadthalle nach ihm suchen. ",
	["HUD"] = "Das HUD ist individuell gestaltbar.\nMit der Taste F2 rufst du das HUD-Menü auf.\nDort kannst du die Größe oder die Transparenz einstellen. Oder du deaktivierst sie durch die Checkbox ganz.\nDu kannst die einzelnen Elemente auch mit dem Mauszeiger verschieben. ",
	["Fahrzeuge"] = "Fahrzeuge kannst du bei Fahrzeughändlern kaufen.\nDiese findest du auf der Karte als blaues Auto.\nWenn dir ein Fahrzeug gefällt und du es kaufen möchtest klicke einfach auf das Auto mit dem Mauszeiger drauf.\nSolltest du ein Auto besitzen kannst du das Fahrzeug-Panel mit der Taste F7 aufrufen.\nDort kannst du deine Fahrzeuge abschleppen lassen und sie werden da gespawnt, wo du sie geparkt hast.\nDu kannst dein Fahrzeug auch abschließen indem du mit der linken Maustaste auf sie rauf klickst.\nWenn du mit der rechten Maustaste auf das Auto klickst, öffnen sich die Fahrzeuginformationen.\n\n Steig in den Wagen ein, löse die Handbremse [B] und geniesse dein Fahrerlebnis.",
	["Regeln"] = "Um dir unsere Server Regeln anzuschauen folge einfach diesem link http://www.ilife-sa.de/index.php/Thread/2014-iLife-Regeln/ ",
	["Support/Admins"] = "Wenn du noch Fragen hast die nicht hier aufgelistet sind kannst du gerne den oben angezeigten Support Button ein Teammitglied deine Frage stellen.\nDie Teammitglieder sind stets bemüht deine Fragen schnell zu beantworten.\nSollte aber mal deine Frage nicht sofort beantwortet werden können, so gedulde dich bitte.\nDenn auch wir Admins sind Menschen und haben nicht immer Zeit für alles.",
	["Karte"] = "Mit der Taste F11 öffnest du die Karte. Es öffnet sich automatisch ein Filter. Dort kannst du indem du auf das jeweilige Kreuz klickst, die Blips an/ausstellen.\n\nBlips:\nBürger - BurgerShot, rosanes C - Stripclub, Waffe - Ammunation (Waffenladen), Hühnchen - Cluckin Bell, Herz - Sexshop, weißes D - Donutladen, Würfel - Casino, Pizzastück - Well stacked Pizza, blaue Sirene - Police Department, rotes S - Supermarkt, T-Shirt - Kleidungsladen, weißes W - Wettbüro, Schallplatte - Disco, Softdrink - Bar, Besteck - Restaurant, Dollar - Bankautomat, blaues Auto - Autohaus, Anker - Boot Club, Sprühflasche - Payn Spray, gelber Punkt - Stadthalle, Hantel - Fitness-Studio ",
	["Sonstiges"] = "Mülleimer:\nAuf der Karte sind überall silberne Mülleimer verteilt\nWenn du neben einem stehst und ihn anklickst erhältst du entweder einen Gegenstand oder manchmal auch gar nichts.\n\nNPCs:\nEs gibt an einigen Orten NPCs mit denen du Handeln kannst.\nAber pass auf! Es kann sein dass er dir ein illegales Geschäft anbietet.MÜLLEIMER NPCs BANK\n\nWichtige Befehle:\n /admins - Alle Admins, die online sind anzeigen\n Die Taste M um den Mauszeiger zu öffnen \nHandy - Das Handy kannst du mit /number [Namen] , /call [Nummer] , /sms [Nummer] benutzen \n Spawnpunkt/Status mit /self ist dir die Möglichkeit gegeben deinen Spawnpunkt zu änder, aber achte darauf das du mindestens 15 min offline warst ansonsten wird der Spawnpunkt nicht gesetzt, deinen Status kannst du in diesem menü auch ändern. "
    }

function showHelpGui()
	if (not clientBusy) then
		hideHelpGui()
		
		HelpGui["Window"] = new(CDxWindow, "Hilfe & Informationen", 500, 450, true, true, "Center|Middle")
		HelpGui["Window"]:setHideFunction(function() HelpGui["Window"] = nil end)
		
		HelpGui["Button"][1] = new(CDxButton, "Support", 5, 10, 200, 42, tocolor(255,255,255,255), HelpGui["Window"])
		
		HelpGui["List"][1] = new(CDxList, 5, 60, 200, 350, tocolor(125,125,125,200), HelpGui["Window"])
		HelpGui["List"][1]:addColumn("Seite")
		
		HelpGui["List"][1]:addRow("Beta")
		HelpGui["List"][1]:addRow("Fraktionen")
		HelpGui["List"][1]:addRow("Stadthalle")
		HelpGui["List"][1]:addRow("Häuser")
		HelpGui["List"][1]:addRow("Inventar")
		HelpGui["List"][1]:addRow("Shops")
		HelpGui["List"][1]:addRow("Jobs")
		HelpGui["List"][1]:addRow("HUD")
		HelpGui["List"][1]:addRow("Fahrzeuge")
		HelpGui["List"][1]:addRow("Regeln")
		HelpGui["List"][1]:addRow("Support/Admins")
		HelpGui["List"][1]:addRow("Karte")
		HelpGui["List"][1]:addRow("Sonstiges")
		
		HelpGui["Button"][1]:addClickFunction(
			function()
				hideHelpGui()
				showSupportOverviewGui()
			end
		)
		
		HelpGui["List"][1]:addClickFunction(
			function()
				HelpGui["Label"][1]:setText(HelpText[HelpGui["List"][1]:getRowData(1)])
			end
		)		
		
		HelpGui["Label"][1] = new(CDxLabel, HelpText["nil"], 210, 10, 280, 350, tocolor(255,255,255,255), 1.0, "default", "left", "top", HelpGui["Window"])
		
		HelpGui["Window"]:add(HelpGui["Button"][1])
		HelpGui["Window"]:add(HelpGui["List"][1])
		HelpGui["Window"]:add(HelpGui["Label"][1])
		HelpGui["Window"]:show()
	end
end

function hideHelpGui()
	if (HelpGui["Window"]) then
		HelpGui["Window"]:hide()
		HelpGui["Window"] = false
	end
end

function toggleHelpGui()
	if (HelpGui["Window"]) then
		hideHelpGui()
	else
		showHelpGui()
	end
end

bindKey(_Gsettings.keys.HelpMenu, "down", toggleHelpGui)