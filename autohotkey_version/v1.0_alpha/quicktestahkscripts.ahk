^W::

send ^c

FileDelete, c:\TempScript.ahk
FileAppend, %Clipboard%, c:\TempScript.ahk
run, c:\TempScript.ahk

return

!^W::

Gui, Add, Edit, vScri r30 w300
Gui, Add, Button, default, Run!
Gui, Show,, Quick Script
return
ButtonRun!:
Gui, Submit
Gui, Destroy

FileDelete, c:\TempScript.ahk
FileAppend, %Scri%, c:\TempScript.ahk
run, c:\TempScript.ahk

return