;-----------------------------------
; Copyrights 2006 by Roger Jaggi
;-----------------------------------
; Platform:       MS Windows XP
; Author:         Roger Jaggi <admin@rogersassistant.rogerworld.ch>
;-----------------------------------

; REGISTRY-INPUTS MÜSSEN ÜBERALL NOCH ÜBERPRÜFT WERDEN!

;___________________________________
; Set constants
#NoEnv
#SingleInstance force

;___________________________________
; Set vars
currentversion = 1.0.2
registry_rootkey = HKCU
registry_subkey = Software\Rogers Assistant

installdir = %A_ScriptDir%

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


;___________________________________
; Generate traymenu
menu, tray, icon, %installdir%\images\rogersassistant.ico
menu, tray, Tip , Rogers Assistant 
menu, tray, NoStandard

menu, tray, add, Status, ShowStatus
menu, tray, add, Einstellungen, OpenSettings
menu, tray, add
menu, tray, add, Neustart, ProgramReload
menu, tray, add, Beenden, ProgramExit

menu, tray, Default, Status

;__________________________________
; Generate status GUI
Gui, Margin, 0, 0
Gui, Add, Picture, w320 h50 x0 y5, %installdir%\images\title.png
Gui, Add, Button, x180 y70 w120 h32 gOpenSettings, Einstellungen...
Gui, Add, Button, x180 y143 w120 h22 gProgramReload, Neustarten
Gui, Add, Button, x180 y168 w120 h22 gProgramExit, Beenden

Gui, Add, GroupBox, x10 y65 w150 h125, Funktionen
Gui, Add, Text, x20 y85, Shortcuts:
Gui, Add, Text, x20 y105, EasyOrdner:
Gui, Add, Text, x20 y125, Wikipedia:
Gui, Add, Text, x20 y145, Google:
Gui, Add, Text, x20 y165, Leo:

Gui, Add, GroupBox, x10 y200 w300 h140, Aktive Shortcuts
Gui, Add, ListView, x20 y220 w280 h110 -hdr -Multi +ReadOnly +Report +LVS_EX_FULLROWSELECT gShortcutlist, Shortcut|Datei
Gui, Show, w320 h350 center hide, Rogers Assistant


;__________________________________
; Start LEO
RegRead, setting_leo, %registry_rootkey%, %registry_subkey%, Leo
if setting_leo = 1
{
	;http://dict.leo.org/?lp=ende&lang=de&search={suchbegriff}
	RegRead, setting_leourl, %registry_rootkey%, %registry_subkey%\Leo, URL
	RegRead, setting_leohotkey, %registry_rootkey%, %registry_subkey%\Leo, Hotkey
	Hotkey, %setting_leohotkey%, Leo
}


;__________________________________
; Start Google
RegRead, setting_google, %registry_rootkey%, %registry_subkey%, Google
if setting_google = 1
{
	;http://google.de/search?hl=de&meta=lr=lang_de&q={suchbegriff}
	RegRead, setting_googleurl, %registry_rootkey%, %registry_subkey%\Google, URL
	RegRead, setting_googlehotkey, %registry_rootkey%, %registry_subkey%\Google, Hotkey
	Hotkey, %setting_googlehotkey%, Google
}


;__________________________________
; Start Wikipedia
RegRead, setting_wikipedia, %registry_rootkey%, %registry_subkey%, Wikipedia
if setting_wikipedia = 1
{
	;http://de.wikipedia.org/wiki/?search={suchbegriff}
	RegRead, setting_wikipediaurl, %registry_rootkey%, %registry_subkey%\Wikipedia, URL
	RegRead, setting_wikipediahotkey, %registry_rootkey%, %registry_subkey%\Wikipedia, Hotkey
	Hotkey, %setting_wikipediahotkey%, Wikipedia
}


;__________________________________
; Start Shortcuts
RegRead, setting_shortcuts, %registry_rootkey%, %registry_subkey%, Shortcuts
if setting_shortcuts = 1
{
	Loop, %registry_rootkey%, %registry_subkey%\Shortcuts, 2, 1
	{
		RegRead, temp_shortcuts_status, %registry_rootkey%, %registry_subkey%\Shortcuts\%A_LoopRegName%, Status
		if temp_shortcuts_status = 1
		{
			
			Hotkey, %A_LoopRegName%, OpenShortcut
			RegRead, temp_shortcuts_run, %registry_rootkey%, %registry_subkey%\Shortcuts\%A_LoopRegName%, Run
			LV_Add("", Hotkey2String(A_LoopRegName), temp_shortcuts_run)
		}
	}
}
LV_ModifyCol()

;__________________________________
; Start EasyOrdner
easyordner_menuitems = 0
RegRead, setting_easyordner, %registry_rootkey%, %registry_subkey%, EasyOrdner
if setting_easyordner = 1
{
	Loop
	{
		RegRead, easyordner_status, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Status
		If ErrorLevel
		{
			break
		}

		If easyordner_status = 1
		{
			easyordner_menuitems++
			RegRead, easyordner_name, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Name
			RegRead, easyordner_path, %registry_rootkey%, %registry_subkey%\EasyOrdner\%A_Index%, Path
			if easyordner_name = Seperator
			{
				Menu, EasyOrdner, Add
			}
			else
			{
				easyordner_name = %easyordner_name%
				easyordner_path = %easyordner_path%
				Transform, easyordner_path%easyordner_menuitems%, deref, %easyordner_path%
				Menu, EasyOrdner, Add, %easyordner_name%, OpenEasyordnerItem			
			}
		}
	}

	if easyordner_menuitems <> 0
	{
		RegRead, setting_easyordnerhotkey, %registry_rootkey%, %registry_subkey%, EasyOrdnerHotkey
		Hotkey, ~MButton, ShowEasyordnerMenu
	}
}


;__________________________________
; Start Auto-Update
RegRead, setting_checkupdates, %registry_rootkey%, %registry_subkey%, CheckUpdates
if setting_checkupdates = 1
{
	URLDownloadToFile, http://rogersassistant.rogerworld.ch/checkupdate.php, %A_Temp%\ra_checkupdate.txt
	FileReadLine, temp_updatecheck, %A_Temp%\ra_checkupdate.txt, 2
	FileDelete, %A_Temp%\ra_checkupdate.txt
	temp_updatecheck = %temp_updatecheck%
	If temp_updatecheck <>
	{
		If temp_updatecheck > %currentversion%
		{
			MsgBox, 4, Rogers Assistant, Eine neue Version von Rogers Assistant ist verfügbar. Möchten Sie die Produkthomepage besuchen, um die neue Version herunterzuladen?
			IfMsgBox yes
			{
				Run, http://rogersassistant.rogerworld.ch
			}
		}
	}
}


;__________________________________
; GUI Status Output
if setting_shortcuts = 1
{
	Gui, Add, Text, x90 y85 cGreen, Aktiviert
}
else{
	Gui, Add, Text, x90 y85 cRed, Deaktiviert
}

if setting_easyordner = 1
{
	Gui, Add, Text, x90 y105 cGreen, Aktiviert
}
else{
	Gui, Add, Text, x90 y105 cRed, Deaktiviert
}

if setting_wikipedia = 1
{
	Gui, Add, Text, x90 y125 cGreen, Aktiviert
}
else{
	Gui, Add, Text, x90 y125 cRed, Deaktiviert
}

if setting_google = 1
{
	Gui, Add, Text, x90 y145 cGreen, Aktiviert
}
else{
	Gui, Add, Text, x90 y145 cRed, Deaktiviert
}

if setting_leo = 1
{
	Gui, Add, Text, x90 y165 cGreen, Aktiviert
}
else{
	Gui, Add, Text, x90 y165 cRed, Deaktiviert
}


;__________________________________
return

;##################################
;##################################
;##################################

;__________________________________
ShowStatus:
	Gui, Restore
return


;__________________________________
OpenSettings:
	Run, %installdir%\Config.exe
return


;__________________________________
ProgramReload:
	Reload
	Sleep, 1000
	MsgBox, 0, Rogers Assistant Error, Rogers Assistant konnte nicht neu gestartet werden und wird nun beendet.
	ExitApp
return


;__________________________________
ProgramExit:
	ExitApp
return


;__________________________________
SearchRoutine:
	temp_clipcontent =
	temp_ClipBackup := ClipboardAll
	Clipboard =
	Send, ^c
	ClipWait, 0.5
	temp_suchbegriff := Clipboard
	Clipboard := temp_ClipBackup
	temp_ClipBackup =
	temp_suchbegriff = %temp_suchbegriff%
	If temp_suchbegriff =
	{
		Inputbox, temp_suchbegriff , Rogers Assistant - %temp_title%, Bitte Suchbegriff eingeben:, , 400, 120
		If ErrorLevel
		{
			return
		}
	}
	StringReplace, temp_command, temp_url, {suchbegriff}, %temp_suchbegriff%, 1
	Run, %temp_command%
	temp_suchbegriff=
	temp_command=
return


;__________________________________
Leo:
	temp_url = %setting_leourl%
	temp_title = Leo 
	GoSub, SearchRoutine
return


;__________________________________
Wikipedia:
	temp_url = %setting_wikipediaurl%
	temp_title = Wikipedia
	GoSub, SearchRoutine
return


;__________________________________
Google:
	temp_url = %setting_googleurl%
	temp_title = Google
	GoSub, SearchRoutine
return


;__________________________________
OpenEasyordnerItem:
	StringTrimLeft, easyordner_path, easyordner_path%A_ThisMenuItemPos%, 0
	if easyordner_path =
	{
		return
	}
	if easyordner_class = #32770  ;Dialog.
	{
		if easyordner_Edit1Pos <>
		{
			WinActivate ahk_id %easyordner_window_id%
			ControlGetText, easyordner_text, Edit1, ahk_id %easyordner_window_id%
			ControlSetText, Edit1, %easyordner_path%, ahk_id %easyordner_window_id%
			ControlSend, Edit1, {Enter}, ahk_id %easyordner_window_id%
			Sleep, 100
			ControlSetText, Edit1, %easyordner_text%, ahk_id %easyordner_window_id%
			return
		}
	}
	else if easyordner_class in ExploreWClass,CabinetWClass  ;Explorer.
	{
		if easyordner_Edit1Pos <>
		{
			ControlSetText, Edit1, %easyordner_path%, ahk_id %easyordner_window_id%
			ControlSend, Edit1, {Right}{Enter}, ahk_id %easyordner_window_id%
			return
		}
	}
	else if easyordner_class = ConsoleWindowClass ;Console
	{
		WinActivate, ahk_id %easyordner_window_id%
		SetKeyDelay, 0
		IfInString, easyordner_path, :
		{
			StringLeft, easyordner_path_drive, easyordner_path, 1
			Send %easyordner_path_drive%:{enter}
		}
		Send, cd %easyordner_path%{Enter}
		return
	}
	else if easyordner_class = TTOTAL_CMD
	{
		WinActivate, ahk_id %easyordner_window_id%
		;return
	}
	Run, Explorer %easyordner_path%
return


;__________________________________
ShowEasyordnerMenu:
	WinGet, easyordner_window_id, ID, A
	WinGetClass, easyordner_class, ahk_id %easyordner_window_id%
	ControlGetPos, easyordner_Edit1Pos,,,, Edit1, ahk_id %easyordner_window_id%
	if easyordner_class = MozillaUIWindowClass
	{
		return
	}
	Menu, EasyOrdner, show
return


;__________________________________
OpenShortcut:
	RegRead, temp_shortcut_run, %registry_rootkey%, %registry_subkey%\Shortcuts\%A_ThisHotkey%, Run
	Run, %temp_shortcut_run%
return

;__________________________________
Shortcutlist:
if A_GuiEvent = DoubleClick
{
	LV_GetText(temp_shortcut, A_EventInfo)
	temp_shortcut := String2Hotkey(temp_shortcut)
	RegRead, temp_shortcut_run, %registry_rootkey%, %registry_subkey%\Shortcuts\%temp_shortcut%, Run
	Run, %temp_shortcut_run%
}
return

;__________________________________
Debugging:
	ListVars
return
