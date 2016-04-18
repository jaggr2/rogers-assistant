
#Include XMLRead.ahk

file = config.xml

AutoUpdate := XMLRead(file, "RogersAssistant.General@AutoUpdate")

MsgBox, [%AutoUpdate%]