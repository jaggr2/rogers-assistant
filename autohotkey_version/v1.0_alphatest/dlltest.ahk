; Example: A working script that writes some text to a file then reads it back into memory (requires v1.0.34+).
; This method can be used to help performance in cases where multiple files are being read or written simultaneously.

FileSelectFile, FileName, S16,, Create a new file:
if FileName =
	return
GENERIC_WRITE = 0x40000000  ; Open the file for writing rather than reading.
CREATE_ALWAYS = 2  ; Create new file (overwriting any existing file).
hFile := DllCall("CreateFile", str, FileName, Uint, GENERIC_WRITE, Uint, 0, UInt, 0, UInt, CREATE_ALWAYS, Uint, 0, UInt, 0)
if not hFile
{
	MsgBox Can't open "%FileName%" for writing.
	return
}
TestString = This is a test string.`r`n  ; When writing a file this way, use `r`n rather than `n to start a new line.
DllCall("WriteFile", UInt, hFile, str, TestString, UInt, StrLen(TestString), UIntP, BytesActuallyWritten, UInt, 0)
DllCall("CloseHandle", UInt, hFile)  ; Close the file.

; Now that the file was written, read its contents back into memory.
GENERIC_READ = 0x80000000  ; Open the file for reading rather than writing.
OPEN_EXISTING = 3  ; This mode indicates that the file to be opened must already exist.
FILE_SHARE_READ = 0x1 ; Whether other processes can open the file while we have it open.
FILE_SHARE_WRITE = 0x2
hFile := DllCall("CreateFile", str, FileName, UInt, GENERIC_READ, UInt, FILE_SHARE_READ|FILE_SHARE_WRITE, UInt, 0, UInt, OPEN_EXISTING, Uint, 0, UInt, 0)
if not hFile
{
	MsgBox Can't open "%FileName%" for reading.
	return
}
MsgBox, hFile: %hFile%
; Make the variable empty for testing purposes, but ensure it retains sufficient capacity:
BytesToRead := VarSetCapacity(TestString, StrLen(TestString))
DllCall("ReadFile", UInt, hFile, str, TestString, UInt, BytesToRead, UIntP, BytesActuallyRead, UInt, 0)
DllCall("CloseHandle", UInt, hFile)  ; Close the file.
MsgBox The following string was read from the file: %TestString%
