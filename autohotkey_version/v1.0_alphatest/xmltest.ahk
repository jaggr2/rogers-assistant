; Example 2: aggregate a list of most-downloaded programs on download.com

#Include XMLRead.ahk ; includes the function

title = Rogerworld.ch News
href = http://www.rogerworld.ch/feed/news_headlines_de.xml

TrayTip, %title% - Downloading...
	, Downloading RSS XML from:`n%href%, 10, 1
file = %A_Temp%\cnet_%A_Now%.xml
URLDownloadToFile, %href%, %file%
If ErrorLevel { ; if download was unsucessful...
	TrayTip
	MsgBox, 18, %title% - Error, Downloading failed?, 5
	IfMsgBox, Abort
		ExitApp
	IfMsgBox, Retry
		Reload
}

Gui, Font, s14 underline
Gui, Add, Text, vTitle gVisitMain, % XMLRead(file, "rss.channel.title") ; % RSS title
Gui, Font
Gui, Add, ListView, w600 r10 gVisit, #|Title|Description|Published

items = 7 ; there number of item elements to parse ...
Loop, %items% {
	LV_Add("", A_Index
		, XMLRead(file, "rss.channel.item(" . A_Index - 1 . ").title") ; item title
		, XMLRead(file, "rss.channel.item(" . A_Index - 1 . ").description") ; item description
		, XMLRead(file, "rss.channel.item(" . A_Index - 1 . ").pubDate")) ; item pubdate (date published)
	link%A_Index% := XMLRead(file, "rss.channel.item(". A_Index - 1 . ").link") ; store the item URL
}

IL := IL_Create(items)
LV_SetImageList(IL)
Loop, %items%
	IL_Add(IL, "shell32.dll", 14)

Loop, 4
	LV_ModifyCol(A_Index, "AutoHdr") ; auto-adjust columns

basex := XMLRead(file, "rss.channel.link") ; main URL
SplitPath, basex, , , , , base
StringReplace, base, base, http://
StringReplace, base, base, www.
StringReplace, base, base, /

Gui, Add, Button, Section w50 gGuiClose Default, &Close
Gui, Add, Text, ys+5, Double-click an item to view it on %base%
RSS := XMLRead(file, "rss@version") ; RSS version (attribute)
FileDelete, %file%
TrayTip
Gui, Show, , %title% - RSS Version %RSS%
Return

VisitMain:
Run, %basex%
Return

Visit:
If A_GuiEvent = DoubleClick
	Run, % link%A_EventInfo% ; opens item's link
Return

GuiClose:
ExitApp