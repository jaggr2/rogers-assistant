;-----------------------------------
; Copyrights 2006 by Roger Jaggi
;-----------------------------------
; Platform:       MS Windows XP
; Author:         Roger Jaggi <admin@rogersassistant.rogerworld.ch>
;-----------------------------------

;___________________________________
; Set constants
#NoTrayIcon
#NoEnv
#SingleInstance force

;___________________________________
; Set vars
registry_rootkey = HKEY_CURRENT_USER
registry_subkey = Software\Rogers Assistant

installdir = %A_ScriptDir%

RegRead, defaultdir, HKLM, %registry_subkey%,DefaultDir
If defaultdir=
{
	defaultdir = %A_Desktop%
}

;___________________________________
; Icon
menu, tray, icon, %installdir%\images\rogersassistant.ico

;___________________________________
; Set functions
String2Hotkey(stringtoparse)
{
	StringUpper, stringtoparse, stringtoparse
	StringReplace, stringtoparse, stringtoparse, %A_SPACE%, , All
	StringReplace, stringtoparse, stringtoparse, %A_TAB%, , All
	StringReplace, stringtoparse, stringtoparse, +, , All
	StringReplace, stringtoparse, stringtoparse, SHIFT, +, All
	StringReplace, stringtoparse, stringtoparse, WIN, #, All
	StringReplace, stringtoparse, stringtoparse, ALT, !, All
	StringReplace, stringtoparse, stringtoparse, CTRL, ^, All
	return %stringtoparse%
}

Hotkey2String(stringtoparse)
{
	temp_outputstring=
	Loop, Parse, stringtoparse 
	{
		StringReplace, temp_char, A_LoopField, +, SHIFT, All
		StringReplace, temp_char, temp_char, #, WIN, All
		StringReplace, temp_char, temp_char, !, ALT, All
		StringReplace, temp_char, temp_char, ^, CTRL, All			
		temp_outputstring = %temp_outputstring% + %temp_char%
	}
	StringTrimLeft, stringtoparse, temp_outputstring, 2
	temp_outputstring=
	StringUpper, stringtoparse, stringtoparse
	return %stringtoparse%
}

set_checkbox(temp_guifield, temp_registryfield)
{
	global registry_rootkey registry_subkey
	RegRead, temp_setting, %registry_rootkey%, %registry_subkey%, %temp_registryfield%
	if ErrorLevel
	{
		temp_setting = 0
	}
	else if temp_setting = 0
	{
		temp_setting = 0
	}
	else {
		temp_setting = 1
	}
	GUIControl, , %temp_guifield%, %temp_setting%
}

set_kombination(hotstring, window, shift, ctrl, alt, win, letter)
{
	hotstring = %hotstring%
	Loop, Parse, hotstring
	{
		If A_LoopField = +
		{
			GuiControl, %window% , %shift%, 1
		}
		else If A_LoopField = ^
		{
			GuiControl, %window% , %ctrl%, 1
		}
		else If A_LoopField = !
		{
			GuiControl, %window% , %alt%, 1
		}
		else If A_LoopField = #
		{
			GuiControl, %window% , %win%, 1
		}
	}
	StringRight, temp_letter, hotstring, 1
	temp_letter = %temp_letter%
	GuiControl, %window% , %letter%, %temp_letter%
}

get_kombination( shift, ctrl, alt, win, letter)
{
	temp_hotstring=
	If %shift% = 1
	{
		temp_hotstring=%temp_hotstring% Shift +
	}
	If %ctrl% = 1
	{
		temp_hotstring=%temp_hotstring% Ctrl +
	}
	If %alt% = 1
	{
		temp_hotstring=%temp_hotstring% Alt +
	}
	If %win% = 1
	{
		temp_hotstring=%temp_hotstring% Win +
	}
	letter := %letter%
	temp_hotstring=%temp_hotstring% %letter%
	return temp_hotstring
}


;__________________________________
; Generate GUI
Gui, Margin, 0, 0

Gui, Add, Tab, w410 h362 x5 y5 , Allgemein|Shortcuts|EasyOrdner|Wikipedia|Google|Leo|Info
Gui, Tab, 1
	Gui, Add, Groupbox, w380 h80  x20  y35, Automatischer Start
	Gui, Add, Text    , w360 h30  x30  y55, Mit dieser Option wird Rogers Assitant bei jedem Windowsstart automatisch gestartet.
	Gui, Add, Checkbox, w360 h20  x30  y87 vGUI_Autostart, Starte Rogers Assistant bei jedem Windowsstart

	Gui, Add, Groupbox, w380 h95 x20  y130 , Automatische Updatebenachrichtigung
	Gui, Add, Text    , w360 h45  x30  y150 , Rogers Assistant kann sich bei jedem Start mit dem Rogerworld.ch-Server verbinden und überprüfen, ob ein neues Softwareupdate zum Download bereit steht und Sie allenfalls benachrichtigen.
	Gui, Add, Checkbox, w360 h20  x30  y195 vGUI_Checkupdates, Überprüfe bei jedem Start auf ein neues Update

	Gui, Add, Groupbox, w380 h110 x20  y240, Einstellungen verwalten
	Gui, Add, Text,     w360 h25  x30  y260 , Diese Funktionen dienen zum Import/Export aller Einstellungen.
	Gui, Add, Text    , w190 h25  x30 y288, Gespeicherte Einstellungen importieren:
	Gui, Add, Button,   w80  h23  x230  y285 gImport, Importieren...
	Gui, Add, Text    , w190 h25  x30 y318, Einstellungen in eine Datei exportieren:
	Gui, Add, Button,   w80  h23  x230  y315 gExport, Exportieren...

Gui, Tab, 2
	Gui, Add, Groupbox, w380 h80  x20  y35, Shortcuts
	Gui, Add, Text    , w360 h30  x30  y55, Mit Shortcuts lässt sich jede Software per Tastenkombination starten. Zum Beispiel könnte man per Druck auf Win+F den Mozilla Firefox starten.
	Gui, Add, Checkbox, w360 h20  x30  y85 vGUI_Shortcutsactivate, Shortcuts aktivieren
	
	Gui, Add, Groupbox, w380 h225 x20  y125, Shortcuts einstellen
	Gui, Add, ListView, w360 h167 x30  y145 vGUI_Shortcutlistview Checked -Multi , |Kombination     |Auszuführende Software 
	Gui, Add, Button,   w75  h23  x30  y317 gNewShortcut, Neu...
	Gui, Add, Button,   w75  h23  x110 y317 gEditShortcut, Bearbeiten...
	Gui, Add, Button,   w75  h23  x190 y317 gDeleteShortcut, Löschen

Gui, Tab, 3
	Gui, Add, Groupbox, w380 h80  x20  y35 , EasyOrdner
	Gui, Add, Text    , w360 h30  x30  y55 , Per Klick/Druck auf das Mausrad erscheint das EasyOrdner-Menü, aus dem komfortabel ein Ordner geöffnet werden kann.
	Gui, Add, Checkbox, w360 h20  x30  y85 vGUI_Easyordneractivate, EasyOrdner aktivieren
	
	Gui, Add, Groupbox, w380 h225 x20  y125, EasyOrdner einstellen
	Gui, Add, ListView, w300 h167 x30  y145 vGUI_Easyordnerlistview Checked -Multi , |Titel                    |Zu öffnender Ordner 
	Gui, Add, Button,   w75  h23  x30  y317 gNewEasyOrdnerItem, Neu...
	Gui, Add, Button,   w75  h23  x110 y317 gEditEasyOrdnerItem, Bearbeiten...
	Gui, Add, Button,   w75  h23  x190 y317 gDeleteEasyOrdnerItem, Löschen
	Gui, Add, Button,   w50  h23  x340 y200 gMoveupEasyOrdnerItem, Auf
	Gui, Add, Button,   w50  h23  x340 y230 gMovedownEasyOrdnerItem, Ab

Gui, Tab, 4
	Gui, Add, Groupbox, w380 h80  x20  y35 , Wikipedia-Funktion
	Gui, Add, Text    , w360 h30  x30  y55 , Per Tastenkombination kann Rogers Assistant ein markiertes Wort bei der freien Enzyklopädie Wikipedia nachschlagen. 
	Gui, Add, Checkbox, w360 h20  x30  y85 vGUI_Wikipediaactivate, Wikipedia-Funktion aktivieren
	
	Gui, Add, Groupbox, w380 h65  x20  y125, Tastenkombination
	Gui, Add, Text    , w360 h20  x30  y145, Tastenkombination dieser Funktion einstellen:
	Gui, Add, Checkbox, w40       x30  y165 vGUI_Wikipedia_shift, Shift
	Gui, Add, Text,     w5        x75  y165 , +
	Gui, Add, Checkbox, w35       x90  y165 vGUI_Wikipedia_ctrl, Ctrl
	Gui, Add, Text,     w5        x130 y165 , +
	Gui, Add, Checkbox, w33       x145 y165 vGUI_Wikipedia_alt, Alt
	Gui, Add, Text,     w5        x180 y165 , +
	Gui, Add, Checkbox, w35       x195 y165 vGUI_Wikipedia_win, Win
	Gui, Add, Text,     w5        x240 y165 , +
	Gui, Add, Edit,     w20       x255 y162 Limit1 Uppercase vGUI_Wikipedia_letter,

	Gui, Add, Groupbox, w380 h150 x20  y200, URL-Suchmaske
	Gui, Add, Text    , w360 h45  x30  y220, Damit Rogers Assistant weis, welche URL er zur Suche öffnen muss, ist die Einstellung der Suchmaske-URL nötig. Die Stelle, die er durch den Suchbegriff ersetzen soll, wird mit {suchbegriff} markiert. 
	Gui, Add, Text    , w30       x30  y273, URL:
	Gui, Add, Edit    , w320      x60  y270 vGUI_Wikipedia_url,
	Gui, Add, Text    , w360 h20  x30  y300, Internetadresse des Services:
	Gui, Add, Text    , w360 h20  x30  y320, http://de.wikipedia.org

Gui, Tab, 5
	Gui, Add, Groupbox, w380 h80  x20  y35 , Google-Funktion
	Gui, Add, Text    , w360 h30  x30  y55 , Per Tastenkombination kann Rogers Assistant ein markiertes Wort bei der Websitensuchmaschine Google nachschlagen. 
	Gui, Add, Checkbox, w360 h20  x30  y85 vGUI_Googleactivate, Google-Funktion aktivieren
	
	Gui, Add, Groupbox, w380 h65  x20  y125, Tastenkombination
	Gui, Add, Text    , w360 h20  x30  y145, Tastenkombination dieser Funktion einstellen:
	Gui, Add, Checkbox, w40       x30  y165 vGUI_Google_shift, Shift
	Gui, Add, Text,     w5        x75  y165 , +
	Gui, Add, Checkbox, w35       x90  y165 vGUI_Google_ctrl, Ctrl
	Gui, Add, Text,     w5        x130 y165 , +
	Gui, Add, Checkbox, w33       x145 y165 vGUI_Google_alt, Alt
	Gui, Add, Text,     w5        x180 y165 , +
	Gui, Add, Checkbox, w35       x195 y165 vGUI_Google_win, Win
	Gui, Add, Text,     w5        x240 y165 , +
	Gui, Add, Edit,     w20       x255 y162 vGUI_Google_letter Limit1 Uppercase,

	Gui, Add, Groupbox, w380 h150 x20  y200, URL-Suchmaske
	Gui, Add, Text    , w360 h45  x30  y220, Damit Rogers Assistant weis, welche URL er zur Suche öffnen muss, ist die Einstellung der Suchmaske-URL nötig. Die Stelle, die er durch den Suchbegriff ersetzen soll, wird mit {suchbegriff} markiert. 
	Gui, Add, Text    , w30       x30  y273, URL:
	Gui, Add, Edit    , w320      x60  y270 vGUI_Google_url,
	Gui, Add, Text    , w360 h20  x30  y300, Internetadresse des Services:
	Gui, Add, Text    , w360 h20  x30  y320, http://www.google.ch

Gui, Tab, 6
	Gui, Add, Groupbox, w380 h80  x20  y35 , LEO-Funktion
	Gui, Add, Text    , w360 h30  x30  y55 , Per Tastenkombination kann Rogers Assistant ein markiertes Wort beim Onlinewörterbuch LEO der Universität München nachschlagen. 
	Gui, Add, Checkbox, w360 h20  x30  y85 vGUI_Leoactivate, Leo-Funktion aktivieren
	
	Gui, Add, Groupbox, w380 h65  x20  y125, Tastenkombination
	Gui, Add, Text    , w360 h20  x30  y145, Tastenkombination dieser Funktion einstellen:
	Gui, Add, Checkbox, w40       x30  y165 vGUI_Leo_shift, Shift
	Gui, Add, Text,     w5        x75  y165 , +
	Gui, Add, Checkbox, w35       x90  y165 vGUI_Leo_ctrl, Ctrl
	Gui, Add, Text,     w5        x130 y165 , +
	Gui, Add, Checkbox, w33       x145 y165 vGUI_Leo_alt, Alt
	Gui, Add, Text,     w5        x180 y165 , +
	Gui, Add, Checkbox, w35       x195 y165 vGUI_Leo_win, Win
	Gui, Add, Text,     w5        x240 y165 , +
	Gui, Add, Edit,     w20       x255 y162 vGUI_Leo_letter Limit1 Uppercase,

	Gui, Add, Groupbox, w380 h150 x20  y200, URL-Suchmaske
	Gui, Add, Text    , w360 h45  x30  y220, Damit Rogers Assistant weis, welche URL er zur Suche öffnen muss, ist die Einstellung der Suchmaske-URL nötig. Die Stelle, die er durch den Suchbegriff ersetzen soll, wird mit {suchbegriff} markiert. 
	Gui, Add, Text    , w30       x30  y273, URL:
	Gui, Add, Edit    , w320      x60  y270 vGUI_Leo_url,
	Gui, Add, Text    , w360 h20  x30  y300, Internetadresse des Services:
	Gui, Add, Text    , w360 h20  x30  y320, http://www.leo.org

Gui, Tab, 7
	Gui, Add, Groupbox, w380 h135 x20  y35 , Rogers Assistant
	Gui, Add, Text    , w360 h90  x30  y55 , Rogers Assistant entwickelte Roger Jaggi mit dem Ziel, ein Tool zur komfortableren Handhabung des Betriebssystems Windows zu schaffen. Dazu wurden mehrere sinnvolle, komplett einstellbare Funktionen eingebaut. Feedback wie Wünsche, Fehlermeldungen, Ideen für neue Funktionen usw. sind jederzeit willkommen und erwünscht. Besuchen Sie dazu die Produkthomepage unter:
	Gui, Add, Text    , w180 h20  x30  y140 cBlue gOpenHomepage, http://rogersassistant.rogerworld.ch
	
	Gui, Add, Groupbox, w190 h45  x20  y180, Version
	Gui, Add, Text    , w170 h20  x30  y200, 1.0 Beta Release Candidat 1

	Gui, Add, Groupbox, w190 h60  x20  y235, Author
	Gui, Add, Text    , w170 h15  x30  y255, Roger Jaggi
	Gui, Add, Text    , w170 h15  x30  y270, admin@rogerworld.ch
	
	Gui, Add, Groupbox, w190 h45  x20  y305, Lizenz
	Gui, Add, Text    , w170 h15  x30  y325, Freeware	
	
	Gui, Add, Groupbox, w175 h170 x225 y180, Logo
	Gui, Add, Picture, w145 h140 x245 y200, %installdir%\images\logo.png
	
Gui, Tab
	Gui, Add, Button, x260 y372 w75 h23 gSaveSettings, OK
	Gui, Add, Button, x340 y372 w75 h23 gProgramExit , Abbrechen

Gui, Show, w420 h400, Rogers Assistant Einstellungen

Gui, 2:+owner
Gui, 2:Margin, 0, 0
Gui, 2:Add, Text    , w240 x15 y15, Tastenkombination:
Gui, 2:Add, Checkbox, w40 x15 y35 vGUI_Shortcutdetails_shift, Shift
Gui, 2:Add, Text    , w5 x60 y35, +
Gui, 2:Add, Checkbox, w35 x75 y35 vGUI_Shortcutdetails_ctrl, Ctrl
Gui, 2:Add, Text    , w5 x115 y35, +
Gui, 2:Add, Checkbox, w33 x130 y35 vGUI_Shortcutdetails_alt, Alt
Gui, 2:Add, Text    , w5 x165 y35, +
Gui, 2:Add, Checkbox, w35 x180 y35 vGUI_Shortcutdetails_win, Win
Gui, 2:Add, Text    , w5 x220 y35, +
Gui, 2:Add, Edit    , w20 x235 y32 Limit1 Uppercase vGUI_Shortcutdetails_letter,
Gui, 2:Add, Text    , w240 x15 y60, Zu ausführender Befehl:
Gui, 2:Add, Edit    , w240 x15 y75 vGUI_Shortcutdetails_run,
Gui, 2:Add, Button, x15 y97 gShortcutDurchsuchen, Durchsuchen...
Gui, 2:Add, Button, x15 y135 w240 gShortcutSave, Sichern und Schliessen
Gui, 2:Show, w270 h170 center hide, Shortcut Details

Gui, 3:+owner
Gui, 3:Margin, 0, 0
Gui, 3:Add, Radio   , w240 x15 y10 vGUI_Easyordnerdetails_seperator gChangeRadioToSeperator, Seperator
Gui, 3:Add, Radio   , w240 x15 y30 vGUI_Easyordnerdetails_entry gChangeRadioToOrdner, Ordner:
Gui, 3:Add, Text    , w240 x15 y55 vGUI_Easyordnerdetails_text_titel, Titel:
Gui, 3:Add, Edit    , w240 x15 y70 vGUI_Easyordnerdetails_title,
Gui, 3:Add, Text    , w240 x15 y100 vGUI_Easyordnerdetails_text_ordner, Zu öffnender Ordner:
Gui, 3:Add, Edit    , w240 x15 y115 vGUI_Easyordnerdetails_folder,
Gui, 3:Add, Button, x15 y137 gEasyOrdnerDurchsuchen vGUI_Easyordnerdetails_Durchsuchen, Durchsuchen...
Gui, 3:Add, Button, x15 y175 w240 gSaveEasyOrdnerItem, Sichern und Schliessen
Gui, 3:Show, w270 h210 center hide, Easy Ordner Eintragdetails

;__________________________________
; Insert Data in GUI Fields

; Tab Allgemein
set_checkbox("GUI_Checkupdates", "CheckUpdates")

RegRead, setting_autostart, HKCU, Software\Microsoft\Windows\CurrentVersion\Run , Rogers Assistant
if ErrorLevel
{
	temp_setting = 0
}
else {
	temp_setting = 1
}
GUIControl, ,GUI_Autostart, %temp_setting%


; Tab Shortcuts
set_checkbox("GUI_Shortcutsactivate", "Shortcuts")

Gui, Listview, GUI_Shortcutlistview
Loop, %registry_rootkey%, %registry_subkey%\Shortcuts, 2, 1
{
	RegRead, temp_shortcuts_status, %registry_rootkey%, %registry_subkey%\Shortcuts\%A_LoopRegName%, Status
	RegRead, temp_shortcuts_run, %registry_rootkey%, %registry_subkey%\Shortcuts\%A_LoopRegName%, Run
	if temp_shortcuts_status = 1
	{
		LV_Add("Check", "", Hotkey2String(A_LoopRegName), temp_shortcuts_run)
	}
	else {
		LV_Add("", "", Hotkey2String(A_LoopRegName), temp_shortcuts_run)	
	}
}

; Tab EasyOrdner
set_checkbox("GUI_Easyordneractivate", "Shortcuts")

Gui, Listview, GUI_Easyordnerlistview
Loop
{
	RegRead, temp_easyordner_status, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Status
	If ErrorLevel
	{
		break
	}
	RegRead, temp_easyordner_name, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Name
	RegRead, temp_easyordner_path, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Path
	
	
	If temp_easyordner_status = 1
	{
		LV_Add("Check", "", temp_easyordner_name, temp_easyordner_path)
	}
	else {
		LV_Add("", "", temp_easyordner_name, temp_easyordner_path)
	}
}

; Tab Wikipedia
set_checkbox("GUI_Wikipediaactivate", "Wikipedia")

RegRead, temp_kombination, %registry_rootkey%, %registry_subkey%\Wikipedia, Hotkey
set_kombination(temp_kombination, "", "GUI_Wikipedia_shift", "GUI_Wikipedia_ctrl", "GUI_Wikipedia_alt", "GUI_Wikipedia_win", "GUI_Wikipedia_letter")

RegRead, temp_url, %registry_rootkey%, %registry_subkey%\Wikipedia, URL
GuiControl, ,GUI_Wikipedia_url, %temp_url%


; Tab Google
set_checkbox("GUI_Googleactivate", "Google")

RegRead, temp_kombination, %registry_rootkey%, %registry_subkey%\Google, Hotkey
set_kombination(temp_kombination, "", "GUI_Google_shift", "GUI_Google_ctrl", "GUI_Google_alt", "GUI_Google_win", "GUI_Google_letter")

RegRead, temp_url, %registry_rootkey%, %registry_subkey%\Google, URL
GuiControl, ,GUI_Google_url, %temp_url%


; Tab Leo
set_checkbox("GUI_Leoactivate", "Leo")

RegRead, temp_kombination, %registry_rootkey%, %registry_subkey%\Leo, Hotkey
set_kombination(temp_kombination, "", "GUI_Leo_shift", "GUI_Leo_ctrl", "GGUI_Leo_alt", "GUI_Leo_win", "GUI_Leo_letter")

RegRead, temp_url, %registry_rootkey%, %registry_subkey%\Leo, URL
GuiControl, ,GUI_Leo_url, %temp_url%


;__________________________________
return

;##################################
;##################################
;##################################

;__________________________________
GuiClose:
ProgramExit:
	ExitApp
return


;__________________________________
SaveSettings:
	;Speichere Inhalte und schliesse Fenster
	Gui, 1:Submit

	; Lösche bisherige Konfiguration
	RegDelete, %registry_rootkey%, %registry_subkey%
	
	;Tab Allgemein
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, CheckUpdates, %GUI_Checkupdates%
	
	RegDelete, %registry_rootkey%, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Rogers Assistant
	If GUI_Autostart = 1
	{
			RegWrite, REG_SZ, %registry_rootkey%, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Rogers Assistant, %installdir%\RogersAssistant.exe
	}
	
	;Tab Shortcuts
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, Shortcuts, %GUI_Shortcutsactivate%
	
	Gui, ListView, GUI_Shortcutlistview
	Loop, % LV_GetCount()
	{	
		;% Get Items
		LV_GetText(temp_kombination, A_Index, 2)
		LV_GetText(temp_run, A_Index, 3)
		temp_kombination := String2Hotkey(temp_kombination)
		
		RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Shortcuts\%temp_kombination%, Run, %temp_run%
		
		temp_startline := A_Index - 1
		temp_nextchecked := LV_GetNext(temp_startline, "Checked")	
		if temp_nextchecked = %A_Index%
		{
			RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Shortcuts\%temp_kombination%, Status, 1
		}
		else
		{
			RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Shortcuts\%temp_kombination%, Status, 0
		}
	}
	
	
	;Tab EasyOrdner
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, EasyOrdner, %GUI_Easyordneractivate%
		
	Gui, ListView, GUI_Easyordnerlistview
	Loop, % LV_GetCount() 
	{
		;% Get Items
		LV_GetText(temp_title, A_Index, 2)
		LV_GetText(temp_folder, A_Index, 3)
		
		RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Name, %temp_title%
		RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Path, %temp_folder%
		
		temp_startline := A_Index - 1
		temp_nextchecked := LV_GetNext(temp_startline, "Checked")	
		if temp_nextchecked = %A_Index%
		{
			RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Status, 1
		}
		else
		{
			RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Status, 0
		}
	}
	
	
	;Tab Wikipedia
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, Wikipedia, %GUI_Wikipediaactivate%
	
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Wikipedia, URL, %GUI_Wikipedia_url%
	
	temp_kombination := get_kombination( "GUI_Wikipedia_shift", "GUI_Wikipedia_ctrl", "GUI_Wikipedia_alt", "GUI_Wikipedia_win", "GUI_Wikipedia_letter")
	temp_kombination := String2Hotkey(temp_kombination)
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Wikipedia, Hotkey, %temp_kombination%	
	
	
	;Tab Google
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, Google, %GUI_Googleactivate%
	
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Google, URL, %GUI_Google_url%
	
	temp_kombination := get_kombination( "GUI_Google_shift", "GUI_Google_ctrl", "GUI_Google_alt", "GUI_Google_win", "GUI_Google_letter")
	temp_kombination := String2Hotkey(temp_kombination)
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Google, Hotkey, %temp_kombination%

	
	;Tab Leo
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%, Leo, %GUI_Leoactivate%
	
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Leo, URL, %GUI_Leo_url%
	
	temp_kombination := get_kombination( "GUI_Leo_shift", "GUI_Leo_ctrl", "GUI_Leo_alt", "GUI_Leo_win", "GUI_Leo_letter")
	temp_kombination := String2Hotkey(temp_kombination)
	RegWrite, REG_SZ, %registry_rootkey%, %registry_subkey%\Leo, Hotkey, %temp_kombination%
	
	;Starte RogersAssistant.exe neu
	Run, %installdir%\RogersAssistant.exe
	
	GoSub, ProgramExit
return

;__________________________________
; Allgemein

;__________________________________
Import:
	MsgBox, 4, Rogers Assistant Warnung, ACHTUNG: Handelt es sich um eine beschädigte Importdatei, gehen sämtliche Einstellungen verloren! Möchten Sie trotzdem fortfahren?
	IfMsgBox No
	{
		return
	}	
	FileSelectFile, temp_importfile, 3, %installdir%, Bitte Importdatei auswählen:, Einstellungsdateien (*.reg)
	If temp_importfile=
	{
		return
	}
	StringRight, temp_extcheck, temp_importfile, 3
	if temp_extcheck = reg
	{
		Gui, Show, hide
		RegDelete, %registry_rootkey%, %registry_subkey%
		RunWait, REGEDIT.EXE /S "%temp_importfile%", , Hide
		Run, %installdir%\RogersAssistant.exe
		MsgBox, 0, Rogers Assistant, Einstellungen wurden importiert! Rogers Assistant wird neu gestartet.
		Reload
	}
return

Export:
	FileSelectFile, temp_exportfile, S3, %installdir%, Bitte Speicheort auswählen:, Einstellungsdateien (*.reg)
	If temp_exportfile=
	{
		return
	}
	StringRight, temp_extcheck, temp_exportfile, 4
	if temp_extcheck <> .reg
	{
		temp_exportfile = %temp_exportfile%.reg
	}
	RunWait, REGEDIT.EXE /E "%temp_exportfile%" "%registry_rootkey%\%registry_subkey%"
	MsgBox, 0, Rogers Assistant, Einstellungen wurden exportiert!
return


;__________________________________
; Shortcut

;__________________________________
NewShortcut:
	Gui, Listview, GUI_Shortcutlistview
	LV_Add("Select Focus Check", "", "", "")
	GoSub EditShortcut
return

EditShortcut:
	Gui, 2:Show, , Shortcut Details
	GuiControl, 2: ,GUI_Shortcutdetails_active, 0
	GuiControl, 2: ,GUI_Shortcutdetails_shift, 0
	GuiControl, 2: ,GUI_Shortcutdetails_ctrl, 0
	GuiControl, 2: ,GUI_Shortcutdetails_alt, 0
	GuiControl, 2: ,GUI_Shortcutdetails_win, 0
	GuiControl, 2: ,GUI_Shortcutdetails_letter,
	GuiControl, 2: ,GUI_Shortcutdetails_run, 

	Gui, ListView, GUI_Shortcutlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	LV_GetText(temp_kombination, temp_linenumber, 2)
	LV_GetText(temp_run, temp_linenumber, 3)	
	temp_kombination := String2Hotkey(temp_kombination)
	set_kombination(temp_kombination, "2:", "GUI_Shortcutdetails_shift", "GUI_Shortcutdetails_ctrl", "GUI_Shortcutdetails_alt", "GUI_Shortcutdetails_win", "GUI_Shortcutdetails_letter")
	GuiControl, 2: ,GUI_Shortcutdetails_run, %temp_run%
	
return

DeleteShortcut:
	Gui, Listview, GUI_Shortcutlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	LV_Delete(temp_linenumber)
return

ShortcutDurchsuchen:
	FileSelectFile, temp_run, 3, %defaultdir%, Bitte Datei auswählen:
	If temp_run <>
	{
		GuiControl, 2: ,GUI_Shortcutdetails_run, %temp_run%
	}
return

ShortcutSave:
Gui, 2:Submit

temp_hotstring := get_kombination( "GUI_Shortcutdetails_shift", "GUI_Shortcutdetails_ctrl", "GUI_Shortcutdetails_alt", "GUI_Shortcutdetails_win", "GUI_Shortcutdetails_letter")

Gui, 1:Default
Gui, ListView, GUI_Shortcutlistview
	if StrLen(temp_hotstring) > 4
	{
		if GUI_Shortcutdetails_letter <>
		{
			if GUI_Shortcutdetails_run <>
			{
				LV_Modify(temp_linenumber, "", "", temp_hotstring, GUI_Shortcutdetails_run)
			}
			else{
				MsgBox, 0, Rogers Assistant Eingabefehler, Es muss einen auszuführenden Befehl geben!
				GoSub EditShortcut
			}
		}
		else
		{	
			MsgBox, 0, Rogers Assistant Eingabefehler, Die Tastenkombination muss am Schluss einen Buchstaben oder eine Zahl haben!
			GoSub EditShortcut
		}
	}
	else
	{
		MsgBox, 0, Rogers Assistant Eingabefehler, Es muss mindestens 1 Zusatztaste (Shift, Ctrl, ...) aktiviert werden!
		GoSub EditShortcut
	}

temp_hotstring=
return

;__________________________________
; EasyOrdner

;__________________________________
NewEasyOrdnerItem:
	Gui, Listview, GUI_Easyordnerlistview
	LV_Add("Select Focus Check", "", "")
	GoSub EditEasyOrdnerItem	
return

EditEasyOrdnerItem:
	Gui, ListView, GUI_Easyordnerlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	LV_GetText(temp_title, temp_linenumber, 2)
	LV_GetText(temp_folder, temp_linenumber, 3)	

	Gui, 3:Show, , Easy Ordner Eintragdetails	
	If temp_title = Seperator
	{
		GoSub, ChangeRadioToSeperator
		GuiControl, 3: ,GUI_Easyordnerdetails_seperator, 1
		GuiControl, 3: ,GUI_Easyordnerdetails_entry, 0
		temp_title=
		temp_folder=
	}
	else{
		GoSub, ChangeRadioToOrdner
		GuiControl, 3: ,GUI_Easyordnerdetails_entry, 1
		GuiControl, 3: ,GUI_Easyordnerdetails_seperator, 0
	}
	GuiControl, 3: ,GUI_Easyordnerdetails_title, %temp_title%
	GuiControl, 3: ,GUI_Easyordnerdetails_folder, %temp_folder%
return

DeleteEasyOrdnerItem:
	Gui, ListView, GUI_Easyordnerlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	LV_Delete(temp_linenumber)
return

EasyOrdnerDurchsuchen:
	FileSelectFolder, temp_folder, %defaultdir%, ,Bitte Ordner auswählen:
	If temp_folder <>
	{
		GuiControl, 3: ,GUI_Easyordnerdetails_folder, %temp_folder%
	}
return

SaveEasyOrdnerItem:
Gui, 3:Submit
Gui, 1:Default
Gui, ListView, GUI_Easyordnerlistview
if GUI_Easyordnerdetails_seperator = 1
{
	LV_Modify(temp_linenumber, "", "", "Seperator", "--------------------")
}
else
{	
	if GUI_Easyordnerdetails_title <>
	{
		if GUI_Easyordnerdetails_folder <>
		{
			LV_Modify(temp_linenumber, "", "", GUI_Easyordnerdetails_title, GUI_Easyordnerdetails_folder)
		}
		else
		{	
			MsgBox, 0, Rogers Assistant Eingabefehler, Es muss ein gültiger Ordner angegeben werden!
			GoSub EditEasyOrdnerItem
		}
	}
	else
	{
		MsgBox, 0, Rogers Assistant Eingabefehler, Es muss ein Titel angegeben werden!
		GoSub EditEasyOrdnerItem
	}
}
return

ChangeRadioToSeperator:
	GuiControl, 3: Disable,GUI_Easyordnerdetails_title
	GuiControl, 3: Disable,GUI_Easyordnerdetails_folder
	GuiControl, 3: Disable,GUI_Easyordnerdetails_Durchsuchen
	GuiControl, 3: Disable,GUI_Easyordnerdetails_text_titel
	GuiControl, 3: Disable,GUI_Easyordnerdetails_text_ordner
return

ChangeRadioToOrdner:
	GuiControl, 3: Enable,GUI_Easyordnerdetails_title
	GuiControl, 3: Enable,GUI_Easyordnerdetails_folder
	GuiControl, 3: Enable,GUI_Easyordnerdetails_Durchsuchen
	GuiControl, 3: Enable,GUI_Easyordnerdetails_text_titel
	GuiControl, 3: Enable,GUI_Easyordnerdetails_text_ordner
return

MoveupEasyOrdnerItem:
	Gui, ListView, GUI_Easyordnerlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	temp_newlinenumber := temp_linenumber - 1
	
	if temp_newlinenumber > 0
	{
		temp_nextchecked := LV_GetNext(temp_newlinenumber, "Checked")	
		LV_GetText(temp_title, temp_linenumber, 2)
		LV_GetText(temp_folder, temp_linenumber, 3)	
		LV_Delete(temp_linenumber)
		If temp_nextchecked = %temp_linenumber%
		{
			LV_Insert(temp_newlinenumber, "Select Focus Check", "",temp_title, temp_folder)
		}
		else
		{
			LV_Insert(temp_newlinenumber, "Select Focus", "",temp_title, temp_folder)		
		}
	}
return

MovedownEasyOrdnerItem:
	Gui, ListView, GUI_Easyordnerlistview
	temp_linenumber := LV_GetNext("" , "Focused")
	temp_newlinenumber := temp_linenumber + 1
	temp_newlinenumber2 := temp_linenumber - 1
	temp_rowscount := LV_GetCount()
	if temp_newlinenumber <= temp_rowscount
	{
		temp_nextchecked := LV_GetNext(temp_newlinenumber2, "Checked")	
		LV_GetText(temp_title, temp_linenumber, 2)
		LV_GetText(temp_folder, temp_linenumber, 3)			
		LV_Delete(temp_linenumber)
		If temp_nextchecked = %temp_linenumber%
		{
			LV_Insert(temp_newlinenumber, "Select Focus Check", "",temp_title, temp_folder)
		}
		else
		{
			LV_Insert(temp_newlinenumber, "Select Focus", "",temp_title, temp_folder)		
		}
	}
return

;__________________________________
; Extras

OpenHomepage:
	Run, http://rogersassistant.rogerworld.ch
return
