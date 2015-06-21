Developers:

ReWrite(Danny): 
Basic Initial Element Classes, Player, Vehicle, Factionsystem, Factions, Gangwarsystem, Housesystem
AdManager, Inventory and Itemsystem, Player Management and Faction Management,
Vehicle Manager, Vehicle Shop Manager, Shopmanager, Turfmanagement, InteriorManager, NPCManager, Initial Factions
DxGUI, Jobs (Drugcookjob and Minigames), Questsystem and Quests, AchievementManager, SupportManager, Drugs
Base System and Foundation of iLife-SA

Noneatme (Gunvarrel): Nametags, HUD, Corporation System and Corporation Management GUI, DxGUI Design, Hall of Games,
Soundmanager, Localizationmanager, ContainerJob, Market, MarketSystem, new InventoryGUI
AnimationManager, GamemodeManager, Lobbymanager, MiningSystem, Object Movement System
WeaponTruck, Fireworks and FireworkManager, Drug-System, SAT Faction and Functions, Various Textures, Images, Sounds and Assets
Business-System, MapLoader, HighPing System, RandomUtils, Vehicle Engine System, Speedradar System, 
Login-Reward System, Password Encryption and much additional Work

Samy: 
Awesome Hookah System

Audifire: 
cCore.lua, Instance Creation, Performance Optimization

Dawi: 
Pizzajob, Translation

MasterM: 
Additional Work, GUI Modifications, additional fixes and bugfixes

Justus(Jusonex): Server-Side Trains

And many other people from the iLife-SA Community.

CHANGELOG.TXT (GERMAN:)

1.2.9: (THIS VERSION!)
    -> Neues Registerfenster
    -> Neues Registersystem
        -> Recruiter ist nun angegeben

    -> Fahrzeugdreck im low-ram modus ist nun standartmäßig zu Performancezwecken deaktiviert

    -> Telefonnummern überarbeitet:
        -> Alte Nummern Bleiben
        -> Neue Nummern sind im folgenden Format:
            xxx-xx-xxxx


-> Loginsounds wiederhergestellt
-> Todessound wiederhergestellt
-> Music bei Moxxys funktioniert wieder

-> Scoreboard veraendert


-> Loginfix bei DEFINE_DEBUG
   -> GUIS kann man nun nurnoch öffnen wenn man sich eingeloggt hat
   -> Asservatenkammer des LSPD's hinzugefügt
   -> Entnommene Items gehen in diese Kammer

   -> Items koennen im LSPD angesehen werden


   -> Clientseitigen ItemManager hinzugefuegt


-> Werbemanager neu geschrieben
   -> Doneastys entfernt (Muss komplett neugemacht werden)
   -> Werbungen koennen per CoreConfig nun deaktiviert werden

   -> Serverstats an der Stadthalle hinzugefuegt


-> Loginrewards hinzugefuegt:
   -> Man erhaelt nun diverse Belohnungen wenn man sich jeden Tag einloggt
   -> Bessere Rewards ab Tag
      -> 1, 3, 7 -> 7 Maximal
      -> Nach einloggen nach 48 Stunden wird der Counter wieder auf 1 gesetzt

      -> Viele Items und Geld moeglich zu Gewinnen

      

	  
CHANGELOG OLD: ---
--------------------
- Fehlende OOP funktionen hinzugefuegt
- Waffentruck Hinzugefuegt
    + Start: Bayside
    + Dealer: Nur Boese Fraktionen
    + Maximale Kisten: 10, fuer Leader: 15
    + Preis pro Kiste dynamisch
    + Ware pro Kiste dynamisch
    + Waffentruck wird nach

- Markierungen an Hauesern Fraktionen usw Hinzugefuegt
    + Vom Waffentruck
- F7 Bearbeitet

- Loadingsprite hinzugefuegt
    + Bei Serverlaggs aktiviert
    + Bei diversen Aktionen angezeigt

- Script OOP Ueberarbeitet
+ Neue Login Cams
- Neue Sounds:
    + Regensounds
    + Loginsounds

- Diverse Sounds ersetzt bzw. erneuert
- F7 Warnung gefixxt bei keinem Auto vorhanden
- Fahrzeug Lokalisieren geht jetzt (Sollte, noch nicht getestet)

- Fahrzeugtueren schliessen sich nun Automatisch wenn die Handbremse angezogen ist
- Handbremse beim Respawnen von Fahrzeugen funktioniert nun

Siehe : https://etherpad.mozilla.org/poe64lv9yY

ModelID: 968

Update so:
Hotfixx 1.1h:

- Fraktionsinventare gefixxt
- LSPD Waffen angepasst
- SAT Marker verändert
- Waffentruck im PD Computer integriert
- Viele Businesse und Prestiges wurden freigemacht
    - Bei inaktiven Usern
    - Bei gebannten Usern
    - Wer sein Business / Prestige verloren hat hat Anspruch auf Schadenseratz, bitte beim Admin melden. (Nachweis wäre wunderbar)

- SAT Base geändert
    - Neue Base in LS
- SAT Funktionen ergänz
    - Zeitungsstände und Pizzaboxen erfüllen nun Ihren zweck
- Ein paar neue Commands für Admins wurden hinzugefügt

- Bugfixxes:
    - Flugzeuge etwas gebufft -> Wieder zurückgesetzt
    - Bug gefixxt, der erlaubt mehr Items aus dem Fraktionslager zu entfernen als man tragen kann
    - Waffentruckerrors gefixxt
    - Business PayNSpray Temple gefixxt
    - Objekte werden jetzt korrekt zerstört wenn man gegenfährt
    - Rechtschreibfehler im WaffentruckGUI behoben
    - Man wird nun korrekt eingeknastet wenn man Stirbt und das Fraktionsinventar nicht vorhanden ist
    - Absperrungen der PD'ler werden nun nach 1. Stunde automatisch gelöscht


1.2:
- Neue Häuser in Blueberry und Red Country eingefügt
- Itemshop Businesse erhalten 25% des Kaufpreises in die Businesskasse
- Neues Business:
    - Kette: iLife Furniture
        - Einkaufszentrum, Kosten: ~$650.000
        - Baumarkt         Kosten: ~$500.000

- Markierungen an Mülltonen entfernt
- Werbertafelshader angepasst und neu erstellt
- Hall of Games bearbeitet
    -> Benutzt nun keine Objekte mehr als Collision
    -> FensterKollision und Gebäudekollision erstellt

- Neuen Maploader hinzugefügt
    -> Maps können Dynamisch geladen und Entladen werden
    -> Hungergames vorzeitig entfernt, Probleme mit Maploader
    -> Bessere Performance durch Maploader
    -> Maps werden beim Spawnen gedownloaded, dauert etwas also einfach Warten!

- Wetter Funktioniert wieder
- HudComponente angepasst
- Diverse Bugfixxes
- Feuerwerksshop entfernt

NEW:
- Waffentruckbalance angepasst
    -> Man bekommt nun weniger Waffenpakete
- Geldautomaten und 24/7 in Dillimore hinzugefügt
- Anti Highping hinzugefügt
    -> Tritt ab einem Ping von 125 in Kraft
    -> Man merkt wenn ein Spieler High-Ping hat, indem er Durchsichtig ist
- Diverse Hausinteriors angepasst
- Sniper Sound gefixxt
- Anti low-FPS hinzugefügt
    -> Tritt ab einer FPS <= 15 in Kraft


1.2.1:
- Einen Sodaautomaten zu benutzen kostet nun $50
    -> Geld wird dem Besitzer überwiesen

- Man kann nun das Fraktionsinventar betrachten wenn man noch nicht Rank 4 oder 5 ist, jedoch kann man nichts einlagern.

- Newsfraktionsmarker zur Wetteranzeige gefixxt
    -> Ist nun nicht mehr neben Gunvarrel's Haus zu sehen (@Sapphiron)

- Das LSPD und Gefängis Interior wird nun vom Server aus geladen
    -> Kein Durchfallen beim Reconnecten mehr möglich

- Türen von Fraktionsfahrzeugen schließen sich nun Korrekt
- Diverse Fehler von fehlenden Online-Datas behoben (e.G. Einknasten)

- Man kann sich nun im Gefängnis nicht mehr ausrüsten.

- Rechtschreibfehler beim Schokoriegel behoben

- Kameras und Kamerafilme können nun benutzt werden
- Rechtschreibfehler in der Muelltonne gefunden


1.2.2:
- Bei einem Highping wird man nun gekickt, da das System nicht richtig funktionierte
- /stopradios um die Radiostreams zu deaktivieren funktioniert nun
    -> Bei High-Ping durch Radiostreams benutzbar

- Bei der SAT Zeitung wird nun der Author korrekt genannt
- Waffentruck abgeändert
    -> Erklärung erfolgt später

- Einknastbug gefixxt, einknasten funktioniert nun perfekt
- LSPD Gate erneuert

- Maps laden nun schneller
- Neues Scoreboard hinzugefügt
    -> Scoreboard ist nun ein HUD Element
    -> Kann verschoben und transparent werden

- Handysystem erweitert, noch nicht ganz Funktionsfähig

- Blips beim Radar werden nun nicht mehr auf der anderen Seite der Karte gezeichnet
- Shoprobinformationen werden nun fuer alle boesen Fraktionen angezeigt

- Payday-Zinsen Anzeigefehler behoben
- Neue Schranken und Zäune bei diversen Parkplätzen und Häusern hinzugefügt
    -> Häuserschranken öffnen sich Automatisch
    -> Berechtigungen liegen beim Hausbesitzer der Hausschranke
    -> (Es läuft alles Vollautomatisch, keine Sorge)

- Diverse neue Admincommands hinzugefuegt

- Bugfix: Handy wird immer angezeigt
- Bugfix: Radar verschwindet manchmal
- Bugfix: HUD wird nicht angezeigt / Kompatiblitätsprobleme behoben
- Bugfix: Error beim Laden des Huds wenn keine Renderreihenfolge vorhanden ist

- Neuer Deathscreen


-----------------------

- Alkoholeffekt hinzugefügt
    -> Bei der Hall of Games 'Testbar'

- Hall of Games verändert
    - HDW201 hinzugefügt

- Shobrob gefixxt

- Hungergames funktioniert wieder

- Neue Animationen:
    - /bitchslap
    - /scratchballs
    - /scratchhead
    - /smoking
    - /crossarms3
    - /swingarms

- Fahrzeugmotor bei Privatfahrzeugen gefixxt
- Hall of Games ist wieder ein Prestige (Test)

- /hidenametags um die Nametags zu deaktivieren hinzugefügt
- Helikopterkamera aendert nun das Radio nicht mehr

- Bei der Kamera wird nun ein .PNG Bild in dem iLife Ordner in guter Qualität gespeichert, wenn ein Bild geschossen wird
    -> Hud, Chat, Crosshair werden aus dem Bild automatisch entfernt
    -> Funktioniert nur bei eingeschalteten Screenshotupload in den MTA Einstellungen! (Für SATler oder andere Personen bitte anschalten)

- Blitzer hinzugefügt
    -> Können von LSPD'ler hingestellt und bearbeitet werden
    -> Strafe wird vom Konto hinzugefügt
    -> Geld geht in die Fraktionskasse

- Radarfallen gefixxt
- Beim Objekte platzieren werden sie nun automatisch richtig auf die Z-Koordinate gestellt

- Fahrzeugschluesel funktionieren nun
    -> Kann vergeben und entfernt werden

- - - - - - - -
- Fahrzeugmotor in die Hauptklasse ausgelagert
    -> Unbekannte Fahrzeuge können jetzt gestartet werden

- Motor-Start-System Performanter gemacht

- Der Server startet nun schneller
    - Laden der Autos und Häuser erfolgt nun in einem andere Threads

- Animationen unterbrechen nun den Tazer nicht mehr

- Die Hall of Games ist nun ein Business
    -> Weiter Funktionen der Hall of Games geplant
    -> (Deathmatch, Race!)

- Helicopterkamera in Mavericks hinzugefügt (RSTRG als Beifahrer)
    -> Mausrad zum Zoomen

- Unerlaubte Skinmods in F8 lesbar gemacht
    -> Bei Kick bitte Entfernen


-  -  - Diverse -  -  -

- Script aufgeraeumt
- Instanzen ausgelagert
- Outputs angepasst

- Script performanter gemacht (Man sollte nun 5-10 FPS mehr erhalten)
    -> Für noch mehr Frames bitte das Entwicklergadget und das Networkmeter deaktivieren (F2)


Perfekte Idee:
- Hall of Games erweitern
- SAMP Objekt benutzen

- Adminbesprechung:

-WT:
- Andere Abgabepunkte in LS, LV, SF
-> Können Überall abgegeben werden
-> Bessere Ordnung für PDler

- Tuningsystem erneuern (Abspeicherung)

- Handy
    -> Hardcoded Apps:
        -> Call
        -> SMS
        -> Kontakte
        -> E-Mail
        -> Notepad
        -> Pizza
        -> Flohmarkt

- CEF Apps: (Chromium Embedded Framework)
    -> 9GAG
    -> YouTube
    -> Reddit
    -> Internetauftritte der einzelnen Business
    -> Internetauftritt selbst machbar (?)


- PD'ler Update
    -> Waffen
        -> PDler bekommen nun ab Rank 1 eine M4
        -> Raketenwerfer für Rank 4 und 5er hinzugefügt
        -> M4 und Raketenwerfer machen 150% mehr Schaden in No-DM zonen
        -> Pistolen machen nun Headshots

    -> Blitzer kann man nun auf das Dach eines Polizeiwagens montieren
    -> Beim Orten wird nun die Kamera des Smartphones gehackt, sodass der Polizist den Bildschirm des Opfers sehen kann
    -> Knastzeit * 100 Multipliziert
        -> 1 Wanted     = 10 Stunde Knast
        -> 6 Wanteds    = 60 Stunden Knast

    -> Shoprobs werden nun automatisch abgebrochen, da böse Fraktionen zu viel Angst vor den PD'lern haben
    -> Waffentrucks entfernt, zu viel Spielspaß für böse Fraktionen





- Protokoll:
    - No DM Zone
    -> Jeder soll Schießen können, jedoch
        -> Neutrale Fraktionen und Zivlisten nehmen kein Schaden und können nicht schießen

    -> Special Forces
    - Rank 1:
        - Deagle, MP5, Gasgranaten
    - Rank 2:
        -> Deagle, MP5, Gasgranaten, M4
    - Rank 3:
        -> Deagle, MP5, Gasgranaten, M4, Rifle
    - Rank 4, 5:
        -> Alles + Sniper


    -> Drogen:
        -> Anpflanzbar auf Grass, Dirt

-> Marktupdate:
    -> Dynamischer Markt mit Angebot und Nachfrage
    -> Erklärbar von Zaxon

    -> Inclusiv Inventar tragfähigkeit & Itemgewicht



-- TODO: --
-> Waffen Equppen verboten bei Schusswechsel für 5 Minuten

-------------------------------


- Geschwindigkeit aller Fahrzeuge angepasst (Übersetzung)
    -> Betrifft auch Radarfallen

- Konfigurationsdatei hinzugefügt
    -> Ort: config.xml
    -> Einstellungen wie Blitzer, Cursorbinds, Nametags vornehmbar
    -> Chatlog angepasst, verschlüsselung hinzugefügt
    -> Consolenlog hinzugefügt

- 'X' auf einem Fahrzeug drücken attacht nun die Person an dem Fahrzeug
    -> Kann mit X oder Leertaste entfernt werden
    -> Geht nur auf bestimmten Fahrzeugen + Boote

- Mausbug behoben
- Ein Zug fährt nun durch SA!
    -> Kann mit X attached werden
    -> Serverseitig Sychronisiert (Danke an Jusonex)
    -> (Bitte nicht hinten auf den hintersten Wagon stellen, Desychronisierung möglich)

- Zug hält nun an Haltestellen an
    -> Beinhaltet auch höchstgeschwindigkeitspositionen

- Züge entbuggt
    -> Darunter änderungen an den verfügbaren Gleisen vorgenommen

- No DM Zonen sind nun wirkliche No-DM Zonen
    -> Polizisten das Recht entzogen in No DM Zonen zu schießen, da sie es anscheinend ausnutzen

- Scoreboard verändert
    -> Zeigt nun den Ping in MS an
    -> Besser Lesbar

- HUD Developmentkit kann nun nurnoch von Admins benutzt werden
    -> Wegen Drogen

-> Impressum, Datenschutzrecht und Quellenangaben hinzugefügt
    -> Im Loginmenü Sichtbar
    -> /impressum
-> Passwortverschlüsselung verbessert
    -> Neue Technik: sha512
    -> Wird beim Einloggen einmalig ersetzt
    -> Passwörter werden außerdem gesalzen


-> Shoprobs geändert
    -> Meldung beim 1. Erfassen deaktiviert
    -> Shoprob gefixxt

-> Waffentrucks und Shoprobs können nun nicht gleichzeig aktiv sein

-> /hitsound ist nun eine Konfiguration
    -> Standart: deaktiviert
    -> Verändert

-> Drogenwurzeln hinzugefügt
    -> Können Angefplanz werden
    -> Nur auf Gras, Dirt, Sand anpflanzbar
    -> Hanfwurzel:
        -> Max. Ziehzeit:   16 Stunden
        -> Max. Ernte:      20 Gramm

    -> Cannabiswurzel:
        -> Max. Ziehzeit:   32 Stunden
        -> Max. Ernte:      50 Gramm

-> im /selfmenu kann man nun sein Passwort ändern
    -> Man muss sein zurzeitiges Passwort angeben

-> Loginsounds geändert
    -> Paar Entfernt, Paar hinzugefügt

-> Statistiken hinzugefügt
    -> Geblitzt
    -> Blitzergeld
    -> Drogen Geernted
    -> Drogen weggeworfen

-> Drogenkäufer hinzugefügt
    -> Befindet sich an der Sprunk Fabrik in Blueberry
    -> Drogen für die hälfte des Preises verkaufbar

-> Developmentwidget angepasst
    -> Für Admins werte, andererseit keine Werte

-> Drogen verfallen nun nach 50 Stunden
    -> Und geben nun nichts mehr, wenn sie nicht Rechzeitig geerntet werden

-> Durchbuggen mit der "Interagier-Funktion" bei Objekten ist nun nicht mehr möglich

-> Item Wegwerfen entbuggt

-> Shoprob geändert
    -> Es kann ein Waffentruck gestartet sein um Shoprobs zu machen
    -> Beute ist nun nichtmehr durch Rammen abnehmbar (Feedback)

-> Regensounds deaktiviert
    -> Standart hinzugefügt
    -> Sollte nun kein Laggen mehr verursachen
    -> Thunder Sounds aber noch Aktiv

-> Neue Achievements hinzgefügt
    -> Fahrzeuge, Blitzer
    -> Drogen
    -> Business, Prestige

-> Fahrzeugkofferaum funktioniert nun
-> Fahrzeug Ersatzreifen funktionieren nun

-> /scrambleword <Wort> um Wörter zu Verscramblen

-> DxGUI hat nun einen kompletten Neuanstrich
    -> Design Neu, Sachen neu
    -> Hud Skalierungsprobleme behoben

-> Waffentruckabladeanzeige funktioniert nun

-> Waffentruck entbuggt

-> "Passwort-Vergessen" Funktion Hinzugefügt

-> Tote Verbindungen werden nun durch ein System geschlossen (Bugmeldung #0008744, bugs.mtasa.com)

-> Waffentruck entbuggt (Finally!)

-> Radar Entbuggt
    -> Position wird nun richtig angezeigt
    -> Ganggebiete werden nun (fast) richtig angezeigt

-> PDLer bekommen nun Leben beim Ausrüsten
-> PD Dach ist jetzt drinne
    -> Marker kommt später

-> Drogen kann man nun nicht mehr unterwasser angepflanzt werden

-> /ooc Chat hinzugefügt
    -> Kann von Admins deaktiviert werden
    -> Kann Lokal mit /toggleooc daktiviert / aktiviert werden
    -> Ermöglicht das Globale Reden, (Out Of Character)
    -> Spamfilter + Spamschutz

-> Drogenpflanzen können nun nicht mehr gemoddet werden
-> Hall of Games Texturen ersetzt

-> /airbreak für Admins hinzugefügt

-> Lobbysystem an der Hall of Games hinzugefügt
    -> Kompletter Re-Write
    -> Momentan nur Derby Lobby verfügbar, weiter Folgen!

-> Marktsystem wurde hinzugefügt
    -> Aufrufbar mit F4
    -> Angebot und Nachfragen erstellbar
    -> Auf Anfragen und Nachfragen kommen 10% Marktzinsen

    -> Alles auf Offline-basis ausgerichtet

    -> BITTE TESTEN! (Bei Exploits wird ein Datenbankbackup vom jetzigen Stand aufgespielt. Bitte jeden Fehler melden!)

-> Integration mit Businesssystem ist in Arbeit.

-> Field "Temp" in der Derbyarena funktioniert nun
-> Sounds und Countdown zu den Lobbys hinzugefügt
-> Lobbysystem, Bugs gefixx

-> Derbyfield "Farm" hinzugefügt

-> Waffen werden nun beim Betreten einer Lobby abgenommen

-> Lobbys koennen nun nicht mehr nachgejoint werden
-> Lobbys fix #2
-> Zuschauer nehmen nun kein Schaden

1.2.4:

-> Modloader hinzugefügt
    -> Mods können Ingame geladen und entladen werden
    -> Erreichbar im /self menü
    -> Mods können auf Knopfdruck gedownloaded und ersetzt werden

-> /eject hinzugefügt
-> PD'ler können nun getazerte Personen grabben (Linksklick auf die getazerte Person in einem Auto)

-> sbx's classlib aktualisiert, MTA-OOP Aktiviert

-> Lobbys:
    -> Personen nehmen in Lobbys nun keinen Schaden mehr
    -> Während der Aufwärmphase ist das Fahrzeug nun unzerstörbar


-> LSPD:
    -> Marker zu den Dächern hinzugefügt

-> 3 neue Archievements hinzugefügt
-> Diverse GUI Aenderungen

-> Special Force hinzugefügt
    -> Gute Fraktion, Sitz in der nähe des LSPD's
    -> Eigener Knast, eigene Funktionen
    -> SWAT Pickup hinzugefügt
        -> Swat Modus aktivieren/deaktivieren
        -> Spezielle Waffen, C4 (Funktioniert noch nicht)
        -> Teargas macht kein Schaden

-> Neuer Pokesound hinzugefügt
    -> Wem der alte lieber gefällt, kann Ihn in der Config.xml wieder aktivieren

-> Lobbymap 3 ist nun nicht mehr standartmaessig vorhanden
-> Zuschauer in der Aufwärmphase erhalten nun kein Auto beim Spielstart mehr

-> Marktbug gefixt mitdem man Unhandelbare Items handeln kann
-> Tazercounter hizugefügt, ab 2. Tazerschuss kann man Grabben


-> Special Fore Bugfix:
    -> Shoprob meldungen
    -> Waffenpickup Skin-Bug
    -> SWAT Modus Duty - Pickup
    -> Fraktionskasse - Offlineflucht und Jailgeld wird nun in die richtige Kasse eingezahlt
    -> Beim Sterben verlässt man nun den SWAT modus
    -> Die Schranke beim LSPD kann nun auch die Special Force öffnen

-> F5 Anzeige behoben
-> Fraktionshelikopter gefixxt

-> Sachen von Usern, welche 4 Monate nicht online waren, werden nun Archiviert.

<< -- >>
-> Skin wird im Scoreboard nun richtig angezeigt
-> LSPD und SpF haben nun neue Fahrzeugsirenen
-> Diverse Texturen wurden ersetzt
-> Radio wird nun beim Tot nicht mehr abgespielt
-> Fahrzeugpanzerung wird nun wirklich gepanzert
-> Regen Deaktiviert
-> Einsteigbug der guten Fraktionen behoben

-> Skins Dingens gefixxt

-> LSPD Wantedcoputer addendum


-> Hüte Eingefügt!
    -> Bald Kaufbar

-> SpF können nun Durchsuchen
-> Auto Verkaufbug Behoben

-> Filter bei F11 wird nun korrekt geschlossen

-> Tuningaragen Änderungen:
    -> Fahrzeugvarianten nun in der Tuninggarage kaufbar!
    -> Adminbefehle für Fahrzeugänderung funktionieren nun
    -> Pay'n'Spray repariert nun Fahrzeuge mit Panzerung richtig
    -> Fehlende Tuninggaragen in SF und LV als Business hinzugefügt

    -> Der Motor von Fahrzeugen wird nun nach dem Respawnen deaktiviert

-> Tuninggarage fix:
    -> Colorpicker hinzugefügt
    -> Kameraposition geändert


-> Geschwindigkeit der Häuser und Automanager Loading Threads erhöht
-> Geschwindigkeit der Ladenzeiten der Bewegbaren Objekte nach Severrestart erhöht
-> Qualität der Werbetafeln erhöht

-> Adminbefehle für Administratoren geändert
    -> Können nun GMX's durchführen

-> Restartbefehl -> Zeit hinzugefügt
-> Windgeschwindigkeit gefixxt

-> Man kann sich nun an Boote attachen

-> Tuninggarage am Airport für Helikopter hinzugefügt
-> Tuninggarage in der Verona Beach für Boote hinzugefügt


-> Komplett neue Special Force Base hinzugefügt
    -> Mit Knast und allen Schranken
    -> Hat ungefähr 5 Minuten gedauert (Ohne Map)

-> Häuser werden nun nach 4 Monate Inaktivität automatisch wieder frei gemacht
    -> Dasselbe mit Prestigen und Businesse's
    -> Außerdem mit Objekten und Interiorobjekten

-> @-Zeichen nun im dxEdit Schreibbar


-> Markt ist nun auf der F9 Taste
-> PD Computer ist nun auf der F4 Taste

-> Tuninggaragen sind nun an der Marina Beach verfügbar (Für Boote)
-> Santa Maria Beach Map von MasterM eingefügt
-> Tuninggaragemap von Martin eingefügt

-> Respawnfehler behoben, wenn man von dem Zugführer getötet wird (Kein Respawn)

-> Stack Overflow im Inventar behoben, wenn ein Item in der Datenbank fehlte
    -> Items könnten eventuell nicht mehr Sortiert sein

-> Stellen in der SpF Base ist nun erst ab 4 Wanteds möglich

-> Die Wahrscheinlichkeit, das Benzin zu verschütten wurde auf 25% gesenkt
-> Hall of Games hat nun mehr "Einwohner"
    -> Zufall

-> Wettersystemänderungen:
    -> Das Wasserlevel ist nun Dynamisch
    -> Hängt vom Regenfall ab
    -> Überschwemmungen hinzugefügt

-> Neue Infobox Sounds

-> Marktbug behoben, bei dem man auf Knöpfe klicken kann obwohl das Marktfenster nicht offen ist
    -> Items wird nun beim Kaufen den Verkäufern angezeigt

-> Passwort Speicher funktion hinzugefügt
    -> Kann in der core.xml aktiviert werden, attribut: save_password -> true
    -> Falls aktiviert, einfach auf "Login" klicken.

-> Inventarbug gefixxt, wo ein Inventar von anderen Spielern genommen wurde
    -> Bei Autos
    -> Bei anderen Spielern (Samy)

-> Infoboxicons geändert

-> Nametags erneuert
    -> Inclusive Leben und Armor
    -> Corporationsicon wird neben dem Namen angezeigt

-> /limit Hinzugefügt
    -> Höchstgeschwindigkeit einstellbar
-> /tempo Hinzugefügt
    -> Selbstständiges Fahren des Autos

-> Scoreboard auf Corporationssystem angepasst
    -> Fraktion zu Corporation ersetzt
    -> Icons und Name bei Spieler hinzugefügt
    -> Performance verbessert
    -> Skinbilder erneuert, Komprimiert

-> Nametags erneuert
    -> Incluive Schutzweste
    -> Icons werden neben den Nametags angezeigt
    -> Peformanceprobleme durch Nametags behoben
    -> Design kann sich noch in der Laufzeit ändern
        -> Anzeige beim Leben verlieren

-> Veränderungen am DX Gui System
    -> Fehler bei den Render Targets und Clicksystem behoben

-> Coroprationsystem hinzugefügt
    -> Das Umfangreichste Firmenverwaltungssystem in komplett MTA!

    -> Jeder kann für eine gewisse Summe an Geld eine Firma / Gang erstellen. (Oberbegriff = Corporation)
    -> Corporationsmenü befindet sich auf F10
        -> Alle vorhanden Corporationen werden dort angezeigt
            -> Corporationsprofil:
                -> Gibt Informationen über die zurzeitige Corporation an
                -> Verrät Beziehungen zu anderen Corporationen
                -> Stellt Icon, Gründer, Gründungsdaten und Mitgleider dar

    -> Corporation mit F10 außerdem erstellbar
        -> Wahl eines dynamischen Icons möglich
        -> Basisfarbe und Namen wählbar, später nicht änderbar

    -> Corporationsmenü auf F5, falls in einer Corporation

    -> Rollensystem:
        -> 7 Verschiedene Rollen: (Vom CEO, Deputy CEO und HR Manager vergebbar)
            -> CEO: Chief Executive Officer: Gründer und einmalig in der Corporation
            -> Deputy CEO: Stellv. CEO: -> Selbe Rechte wie der CEO
            -> HR Manager: Human Resources Manager -> Rechte zum Inviten, Uninviten, Rollenvergabe
                -> Kann Außerdem Max. Spielerslots erhöhen
            -> PR Manager: Public Relations Manager: -> Kann Verbindungen und Beziehungen zu anderen Corporationen verwalten, anfragen und entfernen
            -> Financial Manager: -> Erlaubt es, die Corporationskasse zu verwalten.



-> Markt ist nun auf der F9 Taste
-> PD Computer ist nun auf der F4 Taste

-> Tuninggaragen sind nun an der Marina Beach verfügbar (Für Boote)
-> Santa Maria Beach Map von MasterM eingefügt
-> Tuninggaragemap von Martin eingefügt

-> Respawnfehler behoben, wenn man von dem Zugführer getötet wird (Kein Respawn)

-> Stack Overflow im Inventar behoben, wenn ein Item in der Datenbank fehlte
    -> Items könnten eventuell nicht mehr Sortiert sein

-> Stellen in der SpF Base ist nun erst ab 4 Wanteds möglich

-> Die Wahrscheinlichkeit, das Benzin zu verschütten wurde auf 25% gesenkt
-> Hall of Games hat nun mehr "Einwohner"
    -> Zufall

-> Wettersystemänderungen:
    -> Das Wasserlevel ist nun Dynamisch
    -> Hängt vom Regenfall ab
    -> Überschwemmungen hinzugefügt

-> Infoboxicons geändert
-> Neue Infobox Sounds
    -> Kann bei Bedarf wieder in der core.xml auf den alten plop Sound umgeändert werden

-> Marktbug behoben, bei dem man auf Knöpfe klicken kann obwohl das Marktfenster nicht offen ist
    -> Items wird nun beim Kaufen den Verkäufern angezeigt

-> Passwort Speicher funktion hinzugefügt
    -> Kann in der core.xml aktiviert werden, attribut: save_password -> true
    -> Falls aktiviert, einfach auf "Login" klicken.

-> Inventarbug gefixxt, wo ein Inventar von anderen Spielern genommen wurde
    -> Bei Autos
    -> Bei anderen Spielern (Samy)

-> Explosionen sind nun etwas größer, wenn das Auto einen vollen Tank besitzt
    -> Machen keinen Schaden

-> Nametags erneuert
    -> Inclusive Leben und Armor
    -> Corporationsicon wird neben dem Namen angezeigt

-> /limit Hinzugefügt
    -> Höchstgeschwindigkeit einstellbar
-> /tempo Hinzugefügt
    -> Selbstständiges Fahren des Autos

-> Scoreboard auf Corporationssystem angepasst
    -> Fraktion zu Corporation ersetzt
    -> Icons und Name bei Spieler hinzugefügt
    -> Performance verbessert
    -> Skinbilder erneuert, Komprimiert

-> Nametags erneuert
    -> Incluive Schutzweste
    -> Icons werden neben den Nametags angezeigt
    -> Peformanceprobleme durch Nametags behoben
    -> Design kann sich noch in der Laufzeit ändern
        -> Anzeige beim Leben verlieren

-> Veränderungen am DX Gui System
    -> Fehler bei den Render Targets und Clicksystem behoben

-> Coroprationsystem hinzugefügt
    -> Das Umfangreichste Firmenverwaltungssystem in komplett MTA!

    -> Jeder kann für eine gewisse Summe an Geld eine Firma / Gang erstellen. (Oberbegriff = Corporation)
    -> Corporationsmenü befindet sich auf F10
        -> Alle vorhanden Corporationen werden dort angezeigt
            -> Corporationsprofil:
                -> Gibt Informationen über die zurzeitige Corporation an
                -> Verrät Beziehungen zu anderen Corporationen
                -> Stellt Icon, Gründer, Gründungsdaten und Mitgleider dar

    -> Corporation mit F10 außerdem erstellbar
        -> Wahl eines dynamischen Icons möglich
        -> Basisfarbe und Namen wählbar, später nicht änderbar

    -> Corporationsmenü auf F5, falls in einer Corporation

    -> Rollensystem:
        -> 7 Verschiedene Rollen: (Vom CEO, Deputy CEO und HR Manager vergebbar)
            -> Mann kann verschiedene Rollen gleichzeitig besitzen

            -> CEO: Chief Executive Officer: Gründer und einmalig in der Corporation
            -> Deputy CEO: Stellv. CEO: -> Selbe Rechte wie der CEO
            -> HR Manager: Human Resources Manager -> Rechte zum Inviten, Uninviten, Rollenvergabe
                -> Kann Außerdem Max. Spielerslots erhöhen
            -> PR Manager: Public Relations Manager: -> Kann Verbindungen und Beziehungen zu anderen Corporationen verwalten, anfragen und entfernen
            -> Financial Manager: -> Erlaubt es, die Corporationskasse zu verwalten.
            -> Storage Manager: -> Erlaubt es, das Corporationsinventar zu verwalten.
            -> Production Manager: -> Erlaubt es, die verbundenen Businesse der Corporation zu verwalten.

    -> Bündnisssystem
        -> Bündnisse bringen diverse Vorteile und Nachteile:
            -> Freundschaftsbündniss:
                -> Businesse von Corporationen die eine Freundschaft geschlossen haben, können nicht ihre gegenseitige Businesse angreifen.
            -> Feindschaft:
                -> Eine offizielle Kriegserklärung zwischen 2 Corporationen.
                    -> Gangwars sind legal und dürfen bei Corporationen im Kriegsstatus gestartet werden.
                -> Beschuss bei Kontakt möglich.

        -> Bei Bündnissen können Financial Manager andere Corporationen Geld einfacher Überweisen.

    -> Menü (F5)
        -> Bereiche der Rollen einsehbar
        -> Human Resource Management:
            -> Erlaubt es, HR Manager User zu Inviten, Rollen zu geben und zu Uninviten.
            -> Auch Offline
        -> Public Resource Manager:
            -> Aussehen der Corporation kann geändert werden, Motd(Moto of the Day) und Biografie änderbar.

        -> Finanzmanager:
            -> Ein / Auszahlen, Geld an Verbundenen Corporationen senden möglich

        -> Storage Manager:
            -> Corporationsinventar einsehbar, Items aus und Einlagern
            -> Lager Überprüfen (Sog. Lager Einheiten, = LE)
            -> Corporationsfahrzeuge kaufbar, können vom Storage Manager umgeparkt werden
            -> Häuser können zu Corporationen hinzgefügt werden
            -> Skins der Rollen können gekauft werden

        -> Production Manager:
            -> Hält die Businesse auf den neusten Stand
            -> Kann Lager Einheiten auffüllen
            -> Kann Lager Einheiten zu den Businesse fahren

-> Serial Highping Ausnahmen hinzugefügt bei Spielern mit generell scheiß Internet

-> Inventarbug gefixt, indem man bei Fraktionsinventare, Corporationsinventaren und Kofferaumen Items aus und Einlagern kann, obwohl man kein Platz mehr im Inventar hat
    -> Personalausweise sollte man trotzdem besser nicht in diese Inventare packen.

-> Kaufdatum wird nun beim Kauf eines Fahrzeuges in der Datenbank gespeichert
    -> Kann bei Klick auf Fahrzeug betrachtet werden

-> Fraktions und Corporationsfahrzeuge sind nun per Rechtsklick anklickbar


-> Corporationschat
-> Fraktionsfahrzeuge Umparken
-> Skin setzen
-> Corporation verlassen können
-> Depduty nicht geben per Deputy

-> Haus verkaufen -> Kein Besitzer


-- NEU --

-> Anti Punchbug Workarount, bitte Testen


-> Wortfilter im OOC Chat und imwoo normalen Chat hinzugefuegt
-> Corporationfunktionen gehen nun:
    -> Skin ändern
    -> Zinssatz -> Payday
    -> Lohn     -> Payday

-> Fisch hinzugefuegt
    -> Funktion fehlt noch, kommt später

-> Anzeigefehler in F10 Corporation View behoben

-> Neuer Job: Truckerjob
    -> Ware an Positionen liefern
    -> Blablabla Marker abfahren oh toll Geld erhalten usw.

-> Springen im Knast gefixxt

-> Farmmap vorerst entfernt; Verursachte Laggen

-> Loadinganzeige beim klick auf Mülltonnen gefixxt

-> Payday Geändert
    -> Corporation berücksichtigt
    -> Fraktion berücksichtigt
    -> Grundeinkommen variiert nun

-> Corporatiosnänderungen:
    -> Upgradepreise angepasst für Bizes
    -> Abkürzung kann nun Max. 5 Zeichen lang sein
    -> Aktionen werden nun geloggt

    -> Payday behoben
    -> Lohn hinzugefügt
        -> Kann vom Finanzmanager gesetzt werden

    -> Steuern beim Payday der Corporation berücksichtigt

    -> Status funktioniert nun
    -> Bei einem Status unter 40% Spawnt man mit einer Schutzweste und Messer

-> Interiorübergang geht jetzt Schneller
-> Bug mit der Karte F11 gefixxt

-> Businessupdate:
    -> 150 Businesse hinzugefügt
    -> Können von Corporationen gekauft werden
    -> Nachschub muss immer Vorhanden sein
        -> Das Lager jedes Business kann leer gehen; immer mit Lagereinheiten auffüllen!
    -> Standartbizes sind vorerst gelockt

    -> Sollte ein Business für länger als 1 Tag leer sein, wird es enteignet

-> Neuer Fahrzeugshop: Truckshop
    -> Verschiedene Trucks und Anhänger kaufbar
    -> Befindet sich in LV

-> Marktplatz in der Fleischbergfirma hinzugefügt
    -> Trailer können dort beladen werden
    -> Trailer können von dort zu den Businessen gefahren werden
    -> Trailer können zu jedem Business gefahren werden, deshalb vorsicht vor Dieben!

-> Neue Items:
    -> Fisch
    -> Brot
    -> Karotten
    -> Kartoffel
    -> Pommes
    -> Weintrauben

- 1.2.6:

-> Low Video Memory Modus hinzugefügt
    -> Kann in der core.xml aktiviert werden (nach 1x. Connecten)
    -> Rendert Rendertargets und Bilder in geringer Qualität
    -> Ersetzt Scoreboard RT's

    -> Maps sortiert
        -> Planetuningmap von <Hier Name Einfügen> hinzugefügt
        -> Truckerjobmap von Ozan hinzugefügt
    -> Businesspreise / income angepasst
        -> Man macht nun bei Tankstellen, Ammu Nation und Einkaufszentren kein Minus mehr


-> Neue Buslinien hinzugefuegt
-> Rechtschreibfehler bei /tempo entfernt
-> Marker an dem Corporationsmarkt sind nun Pfeile

-> Wortfilter änderungen:
    -> Groß und Kleinschreibung funktioniert wieder
    -> Redundante Wörter entfernt, darunter ass, fuck und shit

    -> Nun auch im normalen Chat Aktiv (Nur der Zensurfilter!)

-> Payday Schreibfehler behoben

-> Wenn man aus dem Knast kommt, kann man nun wieder Springen, GUIS Betätigen usw.

-> Häuser enteignung funktioniert nun richtig bei Inaktiven Spielern



NEU:

-> /t Chat Funktioniert nun für Corporationen

-> Radiosystem überarbeitet
    -> Radiosender können mit /addradio <RadioURL> <RadioName> hinzugefügt werden#
        -> Momentan nur per Command möglich, da es ein paar Probleme mit dem Copy & Paste System in dem DxGui gibt
    -> /removeradio <RadioName> Um ein Radio zu entfernen
    -> listradios in der Console zeigt eine liste von Radios an

    -> 3D Autoradios hinzugefügt
        -> Beim Abspielen an das Auto geheftet
        -> Wird lauter, je mehr Türen des Fahrzeuges offen sind

    -> Garagentor bei der Garage hinzugefügt
        -> Kann mit Klick auf die Garage geöffnet werden


    -> Objekt Movement angepasst:
        -> SHIFT beim Drehen rotiert nun das Objekt schneller
        -> LALT beim Drehen rotiert das Objekt nun Langsamer

        -> BILD HOCH / BILD RUNTER verschiebt das Objekt in der Höhe

    -> Friendlist funktioniert nun
    -> Tel Nummer anzeigen Funktioniert nun


    -> Radios Speichern sich nun

    -> /pickall hinzgefügt
        -> Hebt alle Objekte im Umkreis auf (Welche einem Gehören)

    -> Performance von Objekten verbessert
    -> Diverse Performancefixes beim Radio
    -> Platzierte Radios geben nun META Informationen aus

    -> 2 Neue Maps hinzugefügt
(UPDATE IST NOCH NICHT FERTIG, ES KOMMEN HIER NOCH SACHEN HINZU)
Das Update ist noch nicht auf dem Live Server vorhanden. Dieser Changelog soll nur als Information über den zurzeitigen Stand dienen.


1.2.6:

-> /t Chat Funktioniert nun für Corporationen

-> Radiosystem überarbeitet
-> Radiosender können mit /addradio <RadioURL> <RadioName> hinzugefügt werden#
-> Momentan nur per Command möglich, da es ein paar Probleme mit dem Copy & Paste System in dem DxGui gibt
-> /removeradio <RadioName> Um ein Radio zu entfernen
-> listradios in der Console zeigt eine liste von Radios an

-> 3D Autoradios hinzugefügt
-> Beim Abspielen an das Auto geheftet
-> Wird lauter, je mehr Türen des Fahrzeuges offen sind

-> Garagentor bei der Garage hinzugefügt
-> Kann mit Klick auf die Garage geöffnet werden


-> Objekt Movement angepasst:
-> SHIFT beim Drehen rotiert nun das Objekt schneller
-> LALT beim Drehen rotiert das Objekt nun Langsamer

-> BILD HOCH / BILD RUNTER verschiebt das Objekt in der Höhe

-> Friendlist funktioniert nun
-> Tel Nummer anzeigen Funktioniert nun

1.2.6_01:
-> Radios Speichern sich nun

-> /pickall hinzgefügt
-> Hebt alle Objekte im Umkreis auf (Welche einem Gehören)

-> Performance von Objekten verbessert
-> Diverse Performancefixes beim Radio
-> Platzierte Radios geben nun META Informationen aus

-> 1 Neue Map hinzugefügt


1.2.7:
(UPDATE IST NOCH NICHT FERTIG, ES KOMMEN HIER NOCH SACHEN HINZU)
Das Update ist noch nicht auf dem Live Server vorhanden. Dieser Changelog soll nur als Information über den zurzeitigen Stand dienen.

-> Server läuft nun als 64 Bit Anwendung

-> /changelog für den neusten Changelog hinzugefügt
    -> Output in der Console

-> Fraktionsshop kann nun von Corporationen benutzt werden
-> 9 Neue Außenobjekte hinzugefügt
    -> Hauptsächich Bäume

-> Framerate in der Hall of Games und umliegend verbessert
    -> 2. Ebene in der Hall of Games hinzugefügt
    -> Ebenen sind nun in andere Dimensionen; Lags gefixxt

-> Grafikspeichernutzung reduziert
    -> Texturen werden nun Komprimiert; Dadurch könnte es bei Resourcenstart ein 1-2 Sekunden Freeze entstehen

-> Kategorie "Lizenzen und Papiere" heißt nun "Dokumente"
-> GUI List Anzeigefehler behoben, kann jedoch noch etwas rumbuggen.

-> Neues Inventar-GUI hinzugefügt
    -> Besser Sortiert, Übersichtlicher
    -> Suchfunktion hinzugefügt

    -> Lagfrei
    -> Unterstützt nun alle Items
    -> Einfache Verwendung bei Corporation / Fraktion / Fahrzeuginventaren


    -> Items haben nun ein Gewicht
    -> Inventare haben nun ein Maximalgewicht
        -> Überschreitung vorerst nicht möglich;
            -> Zurzeitige überladene Inventare können keine Items mehr aufnehmen
            -> Können jedoch alle Items benutzen und einlagern

            -> Fahrzeuge haben größere Inventare

            -> Itemshops angepasst

        -> Spielerinventar kann 100kg Fassen (Vorerst)

    -> DxList angepasst
        -> Shift beim Scrollen scrollt nun mehrere Linien gleichzeitig

    -> Itemshops angepasst

    -> Diverse Maps gefixxt
    -> Diverse Bugs behoben
        -> Radiolag behoben beim betreten eines Fahrzeuges



-> Neues PD Dach hinzugefuegt
-> PD Hat nun ein Leviathan

-> Corporationsfahrzeuge besitzen nun standartmäßig einen Kofferaum
-> Wird beim Verwandeln übernommen

-> Self-Menue angepasst

1.2.7_01:

    -> DxGui Bugfix

    -> Artefakte hinzugefügt:
        -> Können mit einem Artefaktscanner gescannt werden
            -> Kaufbar im Markt
        -> Erlaubt es Kisten zu finden, welche zufällig auf der gesammten SA Karte spawnen
            -> Verschiedene Arten von Kisten
            -> Feuerwerkskisten, Waffenkisten, Müllkisten, Seltene Kisten, Hüte usw.

        -> Benötigen Aufladungen zum Scannen
            -> 3 Aufladungen hinzugefügt:
                -> Reichweite: Jeweils 100m, 250m und 500m

    -> Geldsack nun Benutzbar
    -> Diverse Bilder ersetzt

1.2.7_01:

-> 3 Artefaktscanner hinzugefügt
    -> Tier 1, 2, 3
    -> Tier 1 kann nur 100m Aufladungen benutzen
    -> Tier 2 250m
    -> Tier 3 500m

    -> Vorhandene Scanner wurden durch Tier3 Scanner ersetzt

-> Nametags bearbeitet
-> Hotknife ist nun Blau
-> Artefakte Preisänderung:
    -> Level 1: $250
    -> Level 2: $750
    -> Level 3: $1350

1.2.7_02:
-> Bugfixes:
    -> Truckerjob
    -> Sonstige Errors

    -> Neue Artefakte hinzugefügt:
        -> Scannerartefakt:
            -> Dropt Scannerloot, Aufladungen, etc.


1.2.7_03:

    -> Tankstellen Explodieren nun nicht mehr wenn man gegenfährt


    -> Drogenpaket beim Artefakt wurde etwas gebufft
        -> Erhöhte Wahrscheinlichkeit für das Finden von mehreren Drogen
        -> Magic Mushrooms runtergesetzt

    -> Diverse Fehler beim Truckerjob behoben
        -> Marker verschwand immer

    -> Regenwetter entbuggt
        -> Keine Wetterbugs um 22 Uhr mehr


1.2.8:
Angefangen, Datum: 23. März 2015 15:35:12


-> Fahrzeugliste F7 ist nun nach Modellname Sortiert
-> Marktsystem angepasst:
    -> Hat nun eine Startseite
        -> Gibt Informationen auf letze Angebote und globale Angebote in dem Markt
        -> 3 Neue Tabs: Eigene Angebote, Eigene Nachfragen und Hilfe
        -> Doppelklick auf Listen bringt einem zu den Items

    -> Dx Listen sind nun nicht mehr in der Höhe größer wenn der Platz nach Links noch ausreicht
    -> Inventar "Im Markt Anzeigen" Knopf Funktioniert nun

    -> Neue Fahrzeugladen: Motoradshop
        -> In Temple / Mulholland
        -> Fahrzeuge: FCR, Freeway, Sandchez


    -> Diverse Maps eingefügtt:
        -> Tuningwerkstatt von Armenia
        -> Inselmap von MasterM

    -> Abgabepunkt des WT's in North Rock gefixxt

    -> Schutzweste wird nun auf dem Radar Links bei der Luft angezeigt, wenn Schutzweste vorhanden ist

    -> Truckerjob Änderungen:
        -> Trucks und Anhänger am TruckerJob sind nun für 10 Sekunden im Ghostmode
        -> Vorgegebenes Ziel entfernt; Ziele können nun selber ausgewählt werden
        -> Beim Abladen muss die Ware wieder zurück zum Job gefahren werden, um das Geld zu erhalten

1.2.8_01:

        -> Storagebox geht wieder
        -> Objekte Rotieren geht wieder

        -> Exploit Entfernt

        -> Bank GUI Anzeigefehler behoben
        -> Inselmap eingefügt

        -> SAT Reporter erhalten nun etwas mehr Geld beim Schreiben von News
        -> Mehr Einstellungen zur Framerateerhoehung in der config.xml aktiviert

        -> Truckerjob besitzt nun den Eventmultiplikator
        -> Beim Tod verliert man nun 1% des Handgeldes

        -> AFK Manager verbessert



        1.2.8_02 Hotfix:
            -> Bahnhofmap von MasterM hinzugefuegt
            -> Waschstrasse als Business funktioniert nun
            -> Diverse Admin CMS hinzugefuegt

            -> 'X' Button bei den CorporationsmanagementGUI's zeigt nun das vorherige GUI

            -> Storagebug exploit entfernt
            -> TheFirstGamer's Skin eingefuegt
