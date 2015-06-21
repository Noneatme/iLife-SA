--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--

addEvent("onDrugCookJobMarkerHit", true)
addEventHandler("onDrugCookJobMarkerHit", getRootElement(),
	function()
		DrugCookJobStartGui["Window"] = new(CDxWindow, "Zettel", 200, 320, true, true, "Center|Middle")
		DrugCookJobStartGui["Label"][1] = new(CDxLabel, "An der Tür klebt ein Zettel:\n\nWir suchen immer Chemiker, die für uns Arbeiten. Guter Lohn für wenig Aufwand! Erzählen Sie aber niemanden, was Sie hier tun!", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", DrugCookJobStartGui["Window"])
		DrugCookJobStartGui["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), DrugCookJobStartGui["Window"])
		
		DrugCookJobStartGui["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onClientDrugCookJobStart", getLocalPlayer())
				DrugCookJobStartGui["Window"]:hide()
				delete(DrugCookJobStartGui["Window"])
				DrugCookJobStartGui["Window"] = false
			end
		)
		
		DrugCookJobStartGui["Window"]:add(DrugCookJobStartGui["Label"][1])
		DrugCookJobStartGui["Window"]:add(DrugCookJobStartGui["Button"][1])
		DrugCookJobStartGui["Window"]:show()
	end
)

DrugCookJobStartGui = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

DrugCookSounds = {
	[1] = "http://rewrite.ga/iLife/drugcook/bbmusical.mp3",
	[2] = "http://rewrite.ga/iLife/drugcook/bbtrack1.mp3",
	[3] = "http://rewrite.ga/iLife/drugcook/bbdub.mp3"
}

DrugCookSound = false
addEvent("onClientRecieveDrugCookMap", true)
addEventHandler("onClientRecieveDrugCookMap", getRootElement(),
	function(Objects, dim)
		for k,v in ipairs(Objects) do
			setElementDimension(v, dim)
		end
		local sound = math.random(1,#DrugCookSounds)
		DrugCookSound = playSound(DrugCookSounds[sound], true)
		setSoundVolume(DrugCookSound, 0.5)
	end
)

addEvent("onClientEndDrugCookJob", true)
addEventHandler("onClientEndDrugCookJob", getRootElement(),
	function()
		if isElement(DrugCookSound) then
			destroyElement(DrugCookSound)
		end
	end
)

addEvent("onClientDrugCookStep", true)
addEventHandler("onClientDrugCookStep", getRootElement(),
	function(stepID)
		if (stepID == 1) then
			showInfoBox("info", "Beantworte die folgenden Fragen!")
			Phase1()
		end
		if (stepID == 2) then
			showInfoBox("info", "Beantworte die folgenden Fragen!")
			Phase2()	
		end
		if (stepID == 3) then
			showInfoBox("info", "Führe die Ephedrin Reduktion aus!")
		end
		if (stepID == 4) then
			Phase4()
		end
		if (stepID == 5) then
			showInfoBox("info", "Extrahiere das Meth!")
		end
		if (stepID == 6) then
			Phase6()
		end
		if (stepID == 7) then
			Phase7()
		end
		if (stepID == 8) then
		end
	end
)


local Phase1q = {
	[1]="Wasserstoff",
    [2]="Helium",
    [3]="Lithium",
    [4]="Beryllium",
    [5]="Bor",
    [6]="Kohlenstoff",
    [7]="Stickstoff",
    [8]="Sauerstoff",
    [9]="Fluor",
    [10]="Neon",
    [11]="Natrium",
    [12]="Magnesium",
    [13]="Aluminium",
    [14]="Silizium",
    [15]="Phosphor",
    [16]="Schwefel",
    [17]="Chlor",
    [18]="Argon",
    [19]="Kalium",
    [20]="Calcium",
    [21]="Scandium",
    [22]="Titan",
    [23]="Vanadium",
    [24]="Chrom",
    [25]="Mangan",
    [26]="Eisen",
    [27]="Kobalt",
    [28]="Nickel",
    [29]="Kupfer",
    [30]="Zink",
    [31]="Gallium",
    [32]="Germanium",
    [33]="Arsen",
    [34]="Selen",
    [35]="Brom",
    [36]="Krypton",
    [37]="Rubidium",
    [38]="Strontium",
    [39]="Yttrium",
    [40]="Zirconium",
    [41]="Niob",
    [42]="Molybdän",
    [43]="Technetium",
    [44]="Ruthenium",
    [45]="Rhodium",
    [46]="Palladium",
    [47]="Silber",
    [48]="Cadmium",
    [49]="Indium",
    [50]="Zinn",
    [51]="Antimon",
    [52]="Tellur",
    [53]="Iod",
    [54]="Xenon",
    [55]="Cäsium",
    [56]="Barium",
    [57]="Lanthan",
    [58]="Cer",
	[59]="Praseodym",
    [60]="Neodym",
    [61]="Promethium",
    [62]="Samarium",
    [63]="Europium",
    [64]="Gadolinium",
    [65]="Terbium",
    [66]="Dysprosium",
    [67]="Holmium",
    [68]="Erbium",
    [69]="Thulium",
    [70]="Ytterbium",
    [71]="Lutetium",
    [72]="Hafnium",
    [73]="Tantal",
    [74]="Wolfram",
    [75]="Rhenium",
    [76]="Osmium",
    [77]="Iridium",
    [78]="Platin",
    [79]="Gold",
    [80]="Quecksilber",
    [81]="Thallium",
    [82]="Blei",
    [83]="Bismut",
    [84]="Polonium",
    [85]="Astat",
    [86]="Radon",
    [87]="Francium",
    [88]="Radium",
    [89]="Actinium",
    [90]="Thorium",
    [91]="Protaktinium",
    [92]="Uran",
    [93]="Neptunium",
    [94]="Plutonium",
    [95]="Americium",
    [96]="Curium",
    [97]="Berkelium",
    [98]="Californium",
    [99]="Einsteinium",
    [100]="Fermium",
    [101]="Mendelevium",
    [102]="Nobelium",
    [103]="Lawrencium",
    [104]="Rutherfordium",
    [105]="Dubnium",
    [106]="Seaborgium",
    [107]="Bohrium",
    [108]="Hassium",
    [109]="Meitnerium",
    [110]="Darmstadtium",
    [111]="Röntgenium",
    [112]="Copernicium",
    [113]="Ununtrium",
    [114]="Flerovium",
    [115]="Ununpentium",
    [116]="Livermorium",
    [117]="Ununseptium",
    [118]="Ununoctium"
}

local Phase1a = {
	[1]="H",
    [2]="He",
    [3]="Li",
    [4]="Be",
    [5]="B",
    [6]="C",
    [7]="N",
    [8]="O",
    [9]="F",
    [10]="Ne",
    [11]="Na",
    [12]="Mg",
    [13]="Al",
    [14]="Si",
    [15]="P",
    [16]="S",
    [17]="Cl",
    [18]="Ar",
    [19]="K",
    [20]="Ca",
    [21]="Sc",
    [22]="Ti",
    [23]="V",
    [24]="Cr",
    [25]="Mn",
    [26]="Fe",
    [27]="Co",
    [28]="Ni",
    [29]="Cu",
    [30]="Zn",
    [31]="Ga",
    [32]="Ge",
    [33]="As",
    [34]="Se",
    [35]="Br",
    [36]="Kr",
    [37]="Rb",
    [38]="Sr",
    [39]="Y",
    [40]="Zr",
    [41]="Nb",
    [42]="Mo",
    [43]="Tc",
    [44]="Ru",
    [45]="Rh",
    [46]="Pd",
    [47]="Ag",
    [48]="Cd",
    [49]="In",
    [50]="Sn",
    [51]="Sb",
    [52]="Te",
    [53]="I",
    [54]="Xe",
    [55]="Cs",
    [56]="Ba",
    [57]="La",
    [58]="Ce",
    [59]="Pr",
    [60]="Nd",
    [61]="Pm",
    [62]="Sm",
    [63]="Eu",
    [64]="Gd",
    [65]="Tb",
    [66]="Dy",
    [67]="Ho",
    [68]="Er",
    [69]="Tm",
    [70]="Yb",
    [71]="Lu",
    [72]="Hf",
    [73]="Ta",
    [74]="W",
    [75]="Re",
    [76]="Os",
    [77]="Ir",
    [78]="Pt",
    [79]="Au",
    [80]="Hg",
    [81]="Tl",
    [82]="Pb",
    [83]="Bi",
    [84]="Po",
    [85]="At",
    [86]="Rn",
    [87]="Fr",
    [88]="Ra",
    [89]="Ac",
    [90]="Th",
    [91]="Pa",
    [92]="U",
    [93]="Np",
    [94]="Pu",
    [95]="Am",
    [96]="Cm",
    [97]="Bk",
    [98]="Cf",
    [99]="Es",
    [100]="Fm",
    [101]="Md",
    [102]="No",
    [103]="Lr",
    [104]="Rf",
    [105]="Db",
    [106]="Sg",
    [107]="Bh",
    [108]="Hs",
    [109]="Mt",
    [110]="Ds",
    [111]="Rg",
    [112]="Cn",
    [113]="Uut",
    [114]="Fl",
    [115]="Uup",
    [116]="Lv",
    [117]="Uus",
    [118]="Uuo"
}




function Phase1()
	local Phase1d = {}
	local P1 = {}
	
	P1["Current"] = math.random(1, #Phase1q)
	Phase1d[P1["Current"]] = true
	P1["purity"] = 100
	P1["window"] = new(CDxWindow, "Phase 1:", 502, 430, true, true, "Center|Middle")
	P1["image"] = new(CDxImage, 30, 20, 440, 275, "res/images/jobs/drugcook/periodensystem.png",tocolor(255,255,255,255), P1["window"])
	P1["label"] = new(CDxLabel, "Frage: Welches Symbol hat das Element "..Phase1q[P1["Current"]].." ?", 10, 320, 400, 30, tocolor(255,255,255,255), 1, "default", "left", "top", P1["window"])
	P1["edit"] = new(CDxEdit, "", 10, 340, 150, 42, "normal", tocolor(0,0,0,255), P1["window"])  
	P1["button"] = new(CDxButton, "Antworten", 200, 340, 150, 42, tocolor(255,255,255,255), P1["window"])
	
	P1["button"]:addClickFunction(
		function()
			if (P1["edit"]:getText() == Phase1a[P1["Current"]]) then	
				showInfoBox("info", "Richtige Antwort!")
			else
				P1["purity"] = P1["purity"]-20
				showInfoBox("info", "Falsche Antwort!")
			end
			
			if (table.size(Phase1d) < 5 ) then
				repeat P1["Current"] = math.random(1, #Phase1q) until not Phase1d[P1["Current"]]
				Phase1d[P1["Current"]] = true
				P1["label"]:setText("Frage: Welches Symbol hat das Element "..Phase1q[P1["Current"]].." ?")
				P1["edit"]:setText("")
			else
				P1["window"]:setHideFunction(function() end)
				triggerServerEvent("onClientDrugCookStep", getRootElement(), P1["purity"] )
				P1["window"]:hide()
				clientBusy = false
				delete(P1["window"])
			end
		end
	)
	
	P1["window"]:add(P1["image"])
	P1["window"]:add(P1["label"])
	P1["window"]:add(P1["edit"])
	P1["window"]:add(P1["button"])
	
	P1["window"]:setHideFunction(function() triggerServerEvent("onClientDrugCookStep", getRootElement(), 0) end)
	
	P1["window"]:show()
	clientBusy = true
end

local Phase2q = {
	[1] = "Erlenmeyerkolben",
	[2] = "Reagenzglas",
	[3] = "Rundkolben",
	[4] = "Spitzkolben",
	[5] = "Birnenkolben ",
	[6] = "Kristallisierschale",
	[7] = "Becherglas",
	[8] = "Standzylinder",
	[9] = "Flasche",
	[10] = "Standkolben"
}

local Phase2a = {
	[1] = "1",
	[2] = "2",
	[3] = "3",
	[4] = "4",
	[5] = "5",
	[6] = "6",
	[7] = "7",
	[8] = "8",
	[9] = "9",
	[10] = "10"
}




function Phase2()
	local Phase2d = {}
	local P2 = {}
	
	P2["Current"] = math.random(1, #Phase2q)
	Phase2d[P2["Current"]] = true
	P2["purity"] = 100
	P2["window"] = new(CDxWindow, "Phase 2:", 502, 430, true, true, "Center|Middle")
	P2["image"] = new(CDxImage, 30, 20, 440, 275, "res/images/jobs/drugcook/pistons.png",tocolor(255,255,255,255), P2["window"])
	P2["label"] = new(CDxLabel, "Frage: Welche Zahl ist ein(e) "..Phase2q[P2["Current"]].." ?", 10, 320, 400, 30, tocolor(255,255,255,255), 1, "default", "left", "top", P2["window"])
	P2["edit"] = new(CDxEdit, "", 10, 340, 150, 42, "normal", tocolor(0,0,0,255), P2["window"])  
	P2["button"] = new(CDxButton, "Antworten", 200, 340, 150, 42, tocolor(255,255,255,255), P2["window"])
	
	P2["button"]:addClickFunction(
		function()
			if (P2["edit"]:getText() == Phase2a[P2["Current"]]) then	
				showInfoBox("info", "Richtige Antwort!")
			else
				P2["purity"] = P2["purity"]-25
				showInfoBox("info", "Falsche Antwort!")
			end
			
			if (table.size(Phase2d) < 4 ) then
				repeat P2["Current"] = math.random(1, #Phase2q) until not Phase2d[P2["Current"]]
				Phase2d[P2["Current"]] = true
				P2["label"]:setText("Frage: Welche Zahl ist ein(e) "..Phase2q[P2["Current"]].." ?")
				P2["edit"]:setText("")
			else
				P2["window"]:setHideFunction(function() end)
				triggerServerEvent("onClientDrugCookStep", getRootElement(), P2["purity"] )
				P2["window"]:hide()
				clientBusy = false
				delete(P2["window"])
			end
		end
	)
	
	P2["window"]:add(P2["image"])
	P2["window"]:add(P2["label"])
	P2["window"]:add(P2["edit"])
	P2["window"]:add(P2["button"])
	
	P2["window"]:setHideFunction(function() triggerServerEvent("onClientDrugCookStep", getRootElement(), 0) end)
	
	P2["window"]:show()
	clientBusy = true
end

function Phase4()
	setCameraMatrix(1376.6839599609, -42.332443237305, 1003.0394287109, 1421.1380615234, -47.565483093262, 913.61657714844, 0, 80)
	hud:Toggle(false)
	toggleAllControls(false)
	showChat(false)
	clientBusy = true
	showCursor(true)
	setCursorAlpha(0)
	addEventHandler("onClientRender", getRootElement(), Phase4render)
end

local P4={
	["Starttick"]=false,
	["HitCount"]=0
}

local P4elements = {
}

local sx,sy = guiGetScreenSize()
local rot = 1
function Phase4render()
	if not P4["Starttick"] then
		P4["Starttick"]=getTickCount()
	end
	if (getTickCount()-P4["Starttick"] < 45000) and (P4["HitCount"]<1000) and (not getKeyState("F9")) then
		local _x,_y = getCursorPosition()
		if (getDistanceBetweenPoints2D (sx/2, sy/2, _x*sx, _y*sy) >= 300) then
			P4["HitCount"] = P4["HitCount"]+1
			setCursorPosition(sx/2,sy/2)
		end
		dxDrawText("Phase 3\n"..tostring(45-(math.floor((getTickCount()-P4["Starttick"])/1000))).." Sekunden verbleibend\n"..tostring(math.floor(P4["HitCount"]/10)).."% verwertet",50,50,50,50,tocolor(255,255,255,255),1.6,"default-bold")
		dxDrawText("Bewege deine Maus so schnell du kannst!",0,0,sx,sy,tocolor(255,255,255,255),3,"default-bold", "center", "bottom")
		local rottime = 15000-( 14500*((P4["HitCount"]/10)/100))
		local rotb = rot
		rot = (rot+(3600/rottime))%360
		dxDrawImage((sx/2)-150, (sy/2)-150, 300, 300,  "res/images/hud/component_hungerbar/apple_circle.png", rot)
		
		if (rot<rotb) then
			table.insert(P4elements, {["a"]=math.random(0,359),["ctime"]=getTickCount()})
		end
		
		for k,v in ipairs(P4elements) do
			local dur = getTickCount()-v["ctime"]
			if (dur < 5000) then
				local tx, ty = getPointFromDistanceRotation(math.floor(sx/2), math.floor(sy/2), math.floor(400*(dur/5000)), v["a"])
				dxDrawImage(tx-75, ty-51, 150, 102, "res/images/jobs/drugcook/structure.png", 0, 0, 0, tocolor(255,255,255, 255-(255*(dur/5000)) ))
			else
				table.remove(P4elements, k)
			end
		end
	else
		if (P4["HitCount"] < 500) then
			P4["HitCount"] = 0
		end
		removeEventHandler("onClientRender", getRootElement(), Phase4render)
		hud:Toggle(true)
		toggleAllControls(true)
		showChat(true)
		setCameraTarget(localPlayer)
		setCursorAlpha(255)
		showCursor(false)
		clientBusy = false
		if P4["HitCount"]>1000 then
			P4["HitCount"] = 1000
		end
		if (math.floor((P4["HitCount"]-500)/5) > 0) then
			triggerServerEvent("onClientDrugCookStep", getRootElement(), math.floor((P4["HitCount"]-500)/5))
		else
			triggerServerEvent("onClientDrugCookStep", getRootElement(), 0)
		end
		
		P4["Starttick"]=false
		P4["HitCount"]=0
	end
end

local Snake = false
function Phase6()
	Snake = new(CSnake, 27, 27, 15, 500)
	Snake:setImage("eat", "res/images/jobs/drugcook/meth.png")
	toggleAllControls(false)
	setCameraMatrix(1377.7983398438 , -28.315227508545 , 1002.2305908203 , 1403.5319824219 , -40.303134918213 , 906.34484863281 , 0 , 80)
	addEventHandler("onClientRender", getRootElement(), Phase6render)
	hud:Toggle(false)
	showChat(false)
	clientBusy = true
	unhandled = false
end

local unhandled = false
function Phase6render()
	Snake:render()
	if (Snake:getStacks() >= 40) then
		CSnake:setFinished(true)
	end
	dxDrawText("Phase 4\nExtrahiert: "..tostring(math.floor((Snake:getStacks()/40)*100)).." %",50,50,50,50,tocolor(255,255,255,255),1.6,"default-bold")
	dxDrawText("Benutze die Pfeiltasten zum Steuern!",0,0,sx,sy,tocolor(255,255,255,255),3,"default-bold", "center", "bottom")
	if (Snake:isFinished()) then
		if not(unhandled) then
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), Phase6render)
					toggleAllControls(true)
					setCameraTarget(localPlayer)
					clientBusy = false
					hud:Toggle(true)
					showChat(true)
					if (Snake:getStacks() > 40) then
						triggerServerEvent("onClientDrugCookStep", getRootElement(), 100)
					else
						triggerServerEvent("onClientDrugCookStep", getRootElement(), math.floor((100/40)*Snake:getStacks()))
					end
					delete(Snake)
					Snake = false
					unhandled = false
				end, 2000, 1
			)
			unhandled = true
		end
	end
end

local Breakout = false
function Phase7()
	Breakout = new(CBreakout, 5, 20, 20)
	Breakout:setImage("target", "res/images/jobs/drugcook/meth.png")
	showInfoBox("info", "Zerschlage das Meth!")
	toggleAllControls(false)
	setCameraMatrix(1360.5026855469, -16.301069259644, 1001.6418457031, 1261.0727539063, -15.404054641724, 991.01745605469, 0, 80)
	addEventHandler("onClientRender", getRootElement(), Phase7render)
	hud:Toggle(false)
	showChat(false)
	clientBusy = true
	unhandled = false
end

function Phase7render()
	Breakout:render()
	dxDrawText("Phase 5\nZerschlagen: "..tostring(Breakout:getPoints()).." %",50,50,50,50,tocolor(255,255,255,255),1.6,"default-bold")
	dxDrawText("Benutze die Pfeiltasten zum Steuern!",0,0,sx,sy,tocolor(255,255,255,255),3,"default-bold", "center", "bottom")
	if not(Breakout:isFinished()) then
	else
		if not(unhandled) then
			setTimer(
				function()
					removeEventHandler("onClientRender", getRootElement(), Phase7render)
					toggleAllControls(true)
					setCameraTarget(localPlayer)
					clientBusy = false
					hud:Toggle(true)
					showChat(true)
					if (Breakout:getPoints() > 100) then
						triggerServerEvent("onClientDrugCookStep", getRootElement(), 100)
					else
						triggerServerEvent("onClientDrugCookStep", getRootElement(), Breakout:getPoints())
					end
					delete(Breakout)
					Breakout = false
					unhandled = false
				end, 2000, 1
			)
			unhandled = true
		end
	end	
end