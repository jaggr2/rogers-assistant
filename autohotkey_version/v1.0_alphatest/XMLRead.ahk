XMLRead(source, tree, default = "") { ; v2.0 - by Titan
	If source is integer
		DllCall("ReadFile", UInt, source, Str, c, UInt, DllCall("GetFileSize", UInt
			, source, UInt, 0), UIntP, DllCall("SetFilePointer", UInt, source, UInt, 0
			, UInt, 0, UInt, 0), UInt, 0)
	Else FileRead, c, %source%
	StringGetPos, t, tree, @
	If !ErrorLevel {
		StringTrimLeft, a, tree, t + 1
		StringLeft, tree, tree, t
	}
	xc := A_StringCaseSense
	StringCaseSense, On
	Loop, Parse, tree, .
	{
		e := A_LoopField
		i = 1
		StringGetPos, t, e, (
		If !ErrorLevel {
			StringMid, i, e, t + 2, InStr(e, ")") - t - 2
			i++
			StringLeft, e, e, t
		}
		StringReplace, c, c, <%e%>, <%e% >, A
		StringReplace, c, c, <%e%/, <%e% /, A
		ex := "<" . e . " "
		n := A_Index
		Loop {
			StringTrimLeft, c, c, InStr(c, ex, 1) - 1
			StringReplace, c, c, <, <, UseErrorLevel
			t := ErrorLevel
			StringReplace, c, c, />, />, UseErrorLevel
			t -= ErrorLevel
			StringReplace, c, c, </, </, UseErrorLevel
			If (t - ErrorLevel * 2) * -1 - n < 0 or x
				Break
			Else StringTrimLeft, c, c, 1
		}
		StringGetPos, t, c, %ex%, L%i%
		x += ErrorLevel
		StringTrimLeft, c, c, t
		t := InStr(c, "</" . e, 1)
		IfNotEqual, t, 0, StringLeft, c, c, t + StrLen(e) + 2
	}
	If a {
		x += !InStr(c, " " . a . "=", 1)
		StringTrimLeft, c, c, InStr(c, a . "=", 1) + StrLen(a) + 1
		StringReplace, c, c, ', ", A
		StringLeft, c, c, InStr(c, """") - 1
	} Else {
		x += InStr(c, "/>") and InStr(c, "/>") < InStr(c, "</")
		StringMid, c, c, InStr(c, ">") + 1, InStr(c, "</" . e . ">", 1) - 1 - InStr(c, ">")
	}
	StringCaseSense, %xc%
	IfGreater, x, 0, SetEnv, c, %default%
	Return, c
}
