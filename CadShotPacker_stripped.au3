If Not ObjEvent("AutoIt.Error") Then
Global Const $0 = ObjEvent("AutoIt.Error", "_1")
EndIf
Func _0($1, $2, $3 = "", $4 = 21)
If Not _h() Then Return SetError(@error, 0, 0)
If Not _d($1) Then Return SetError(3, 0, 0)
If Not _d($2) Then Return SetError(4, 0, 0)
If Not FileExists($2) Then Return SetError(5, 0, 0)
If _d($3) Then Return SetError(6, 0, 0)
$2 = _n($2)
$3 = _n($3)
Local $5 = _l($2)
Local $6 = 0
If BitAND($4, 1) Then
$6 = 1
$4 -= 1
EndIf
Local $7 = $5
If $3 <> "" Then $7 = $3 & "\" & $5
Local $8 = _6($1, $7)
If @error Then Return SetError(7, 0, 0)
If $8 Then
If @extended Then
Return SetError(8, 0, 0)
Else
If $6 Then
_j($1, $7)
If @error Then Return SetError(10, 0, 0)
Else
Return SetError(9, 0, 0)
EndIf
EndIf
EndIf
Local $9 = ""
If $3 <> "" Then
$9 = _e($1, $3)
If @error Then Return SetError(11, 0, 0)
EndIf
Local $a = _i($1, $3)
$a.CopyHere($2, $4)
Do
Sleep(250)
Until IsObj($a.ParseName($5))
If $9 <> "" Then
_j($1, $3 & "\" & $9)
If @error Then Return SetError(12, 0, 0)
EndIf
Return 1
EndFunc
Func _1()
EndFunc
Func _4($b, $6 = 0)
If FileExists($b) And Not $6 Then Return SetError(1, 0, 0)
Local $c = FileOpen($b, 2 + 8 + 16)
If $c = -1 Then Return SetError(2, 0, 0)
FileWrite($c, Binary("0x504B0506000000000000000000000000000000000000"))
FileClose($c)
Return $b
EndFunc
Func _6($1, $2)
If Not _h() Then Return SetError(@error, 0, 0)
If Not _d($1) Then Return SetError(3, 0, 0)
Local $d = ""
$2 = _n($2)
If StringInStr($2, "\") Then
$d = _m($2)
$2 = _l($2)
EndIf
Local $a = _i($1, $d)
If Not IsObj($a) Then Return SetError(4, 0, 0)
Local $e = $a.ParseName($2)
If IsObj($e) Then Return SetExtended(Number($e.IsFolder), 1)
Return 0
EndFunc
Func _d($d)
If StringInStr($d, ":\") Then
Return True
Else
Return False
EndIf
EndFunc
Func _e($1, $d)
If Not _h() Then Return SetError(@error, 0, 0)
If Not _d($1) Then Return SetError(3, 0, 0)
Local $a = _i($1)
If Not IsObj($a) Then Return SetError(4, 0, 0)
$d = _n($d)
Local $f = "", $b = ""
If $d <> "" Then
Local $g = StringSplit($d, "\"), $h
For $i = 1 To $g[0]
$h = $a.ParseName($g[$i])
If IsObj($h) Then
If Not $h.IsFolder Then Return SetError(5, 0, 0)
$a = $h.GetFolder
Else
Local $j = _f()
If @error Then Return SetError(6, 0, 0)
Local $k = _i($j)
For $i = $i To $g[0]
$f &= $g[$i] & "\"
Next
DirCreate($j & "\" & $f)
$b = _g()
$f &= $b
FileClose(FileOpen($j & "\" & $f, 2 + 8))
$a.CopyHere($k.Items())
Do
Sleep(250)
Until _6($1, $f)
DirRemove($j, 1)
ExitLoop
EndIf
Next
EndIf
Return $b
EndFunc
Func _f()
Local $l
Do
$l = ""
While StringLen($l) < 7
$l &= Chr(Random(97, 122, 1))
WEnd
$l = @TempDir & "\~" & $l & ".tmp"
Until Not FileExists($l)
If Not DirCreate($l) Then Return SetError(1, 0, 0)
Return $l
EndFunc
Func _g()
Local $m = DllStructCreate("dword Data1;word Data2;word Data3;byte Data4[8]")
DllCall("ole32.dll", "int", "CoCreateGuid", "ptr", DllStructGetPtr($m))
Local $n = DllCall("ole32.dll", "int", "StringFromGUID2", "ptr", DllStructGetPtr($m), "wstr", "", "int", 40)
If @error Then Return SetError(1, 0, "")
Return StringRegExpReplace($n[2], "[}{-]", "")
EndFunc
Func _h()
If Not FileExists(@SystemDir & "\zipfldr.dll") Then Return SetError(1, 0, 0)
If Not RegRead("HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}", "") Then Return SetError(2, 0, 0)
Return 1
EndFunc
Func _i($1, $d = "")
If Not _h() Then Return SetError(@error, 0, 0)
If Not _d($1) Then Return SetError(3, 0, 0)
Local $o = ObjCreate("Shell.Application")
Local $a = $o.NameSpace($1)
If Not IsObj($a) Then Return SetError(4, 0, 0)
If $d <> "" Then
Local $p = StringSplit($d, "\")
Local $e
For $i = 1 To $p[0]
$e = $a.ParseName($p[$i])
If Not IsObj($e) Then Return SetError(5, 0, 0)
$a = $e.GetFolder
If Not IsObj($a) Then Return SetError(6, 0, 0)
Next
EndIf
Return $a
EndFunc
Func _j($1, $b)
If Not _h() Then Return SetError(@error, 0, 0)
If Not _d($1) Then Return SetError(3, 0, 0)
Local $d = ""
$b = _n($b)
If StringInStr($b, "\") Then
$d = _m($b)
$b = _l($b)
EndIf
Local $a = _i($1, $d)
If Not IsObj($a) Then Return SetError(4, 0, 0)
Local $q = $a.ParseName($b)
If Not IsObj($q) Then Return SetError(5, 0, 0)
Local $j = _f()
If @error Then Return SetError(6, 0, 0)
Local $o = ObjCreate("Shell.Application")
$o.NameSpace($j).MoveHere($q, 20)
DirRemove($j, 1)
$q = $a.ParseName($b)
If IsObj($q) Then
Return SetError(7, 0, 0)
Else
Return 1
EndIf
EndFunc
Func _l($d)
Return StringRegExpReplace($d, ".*\\", "")
EndFunc
Func _m($d)
Return StringRegExpReplace($d, "^(.*)\\.*?$", "${1}")
EndFunc
Func _n($r)
Return StringRegExpReplace($r, "(^\\+|\\+$)", "")
EndFunc
Func _2s(Const $s = @error, Const $t = @extended)
Local $u = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($s, $t, $u[0])
EndFunc
Global Const $v = Ptr(-1)
Global Const $w = Ptr(-1)
Global Const $x = BitShift(0x0100, 8)
Global Const $y = BitShift(0x2000, 8)
Global Const $0z = BitShift(0x8000, 8)
Func _ro($10)
Local $u = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $10)
If @error Then Return SetError(@error, @extended, 0)
Return $u[0]
EndFunc
Global $11, $12, $13, $14, $15, $16, $17, $18, $19
Global $1a, $1b, $1c, $1d, $1e = GUICreate("")
func _uz($1f = 3, $1g = "C:\", $1h = "")
if $1f = 1 or $1f = 3 Then
$1i = $1g
$1a = DllStructCreate("byte[4096]")
$15 = DllStructGetPtr($1a)
$18 = DllStructGetSize($1a)
$14 = 0
$12 = DllCall("kernel32.dll", "hwnd", "CreateFile", "Str", $1i, "Int", 0x1, "Int", BitOR(0x1, 0x4, 0x2), "ptr", 0, "int", 0x3, "int", BitOR(0x2000000, 0x40000000), "int", 0)
$12 = $12[0]
$1j = DllStructCreate("dword ReadLen")
$19 = DllStructCreate("Uint OL1;Uint OL2; Uint OL3; Uint OL4; hwnd OL5")
For $i = 1 To 5
DllStructSetData($19, $i, 0)
Next
$13 = DllStructGetPtr($19)
$1k = DllStructGetSize($19)
$1b = DllStructCreate("hwnd DirEvents")
$11 = DllStructGetPtr($1b)
$1c = DllStructGetSize($1b)
$1d = DllCall("kernel32.dll", "hwnd", "CreateEvent", "UInt", 0, "Int", True, "Int", False, "UInt", 0)
DllStructSetData($19, 5, $1d[0])
DllStructSetData($1b, 1, $1d[0])
$n = DllCall("kernel32.dll", "Int", "ReadDirectoryChangesW", "hwnd", $12, "ptr", $15, "dword", $18, "int", False, "dword", BitOR(0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x100), "Uint", 0, "Uint", $13, "Uint", 0)
$16 = ""
EndIf
if $1f = 2 or $1f = 3 Then
$1l = _ro("shchangenotifymsg")
GUIRegisterMsg($1l, "_v3")
if StringCompare($1h, "") <> 0 Then
$1m = DllCall("shell32.dll", "ptr", "ILCreateFromPath", "wstr", $1h)
EndIf
$1n = DllStructCreate("ptr pidl; int fRecursive")
if StringCompare($1h, "") <> 0 Then
DllStructSetData($1n, "pidl", $1m[0])
Else
DllStructSetData($1n, "pidl", 0)
EndIf
DllStructSetData($1n, "fRecursive", 0)
$17 = DllCall("shell32.dll", "int", "SHChangeNotifyRegister", "hwnd", $1e, "int", BitOR(0x0001, 0x0002), "long", 0x7FFFFFFF, "uint", $1l, "int", 1, "ptr", DllStructGetPtr($1n))
if StringCompare($1h, "") <> 0 Then
DllCall("ole32.dll", "none", "CoTaskMemFree", "ptr", $1m[0])
EndIf
EndIf
Return True
EndFunc
Func _v3($1o, $1p, $1q, $1r)
Local $1s, $1t, $n, $1u
$1s = DllStructCreate("dword dwItem1; dword dwItem2", $1q)
$n = DllCall("shell32.dll", "int", "SHGetPathFromIDList", "ptr", DllStructGetData($1s, "dwItem1"), "str", "")
if $1r = 0x00040000 Then
$1t = DllStructCreate("long")
DllCall("kernel32.dll", "none", "RtlMoveMemory", "ptr", DllStructGetPtr($1t), "ptr",(DllStructGetData($1s, "dwItem1")+2),"int", 4)
$1u = Int(Log(DllStructGetData($1t, 1)) / Log(2))
$n[2] = Chr(65 + $1u)
EndIf
if $1r <> 0x00000002 And $1r <> 0x00000004 Then
_vt(1, $1r, $n[2])
EndIf
Return True
EndFunc
Global Const $1v = 0xF0000000
Global $1w[3]
Func _v4()
If _vf() = 0 Then
Local $1x = DllOpen("Advapi32.dll")
If $1x = -1 Then Return SetError(1001, 0, False)
_vj($1x)
Local $1y = 24
Local $u = DllCall(_vi(), "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", $1y, "dword", $1v)
If @error Or Not $u[0] Then
Local $1z = @error + 1002, $20 = @extended
If Not $u[0] Then $20 = _2s()
DllClose(_vi())
Return SetError($1z, $20, False)
Else
_vl($u[1])
EndIf
EndIf
_vg()
Return True
EndFunc
Func _v5()
_vh()
If _vf() = 0 Then
DllCall(_vi(), "bool", "CryptReleaseContext", "handle", _vk(), "dword", 0)
DllClose(_vi())
EndIf
EndFunc
Func _va($21, $22, $23 = True, $24 = 0)
Local $u, $25 = 0, $1z = 0, $20 = 0, $26 = 0, $27 = 0
_v4()
If @error Then Return SetError(@error, @extended, -1)
Do
If $24 = 0 Then
$u = DllCall(_vi(), "bool", "CryptCreateHash", "handle", _vk(), "uint", $22, "ptr", 0, "dword", 0, "handle*", 0)
If @error Or Not $u[0] Then
$1z = @error + 10
$20 = @extended
If Not $u[0] Then $20 = _2s()
$27 = -1
ExitLoop
EndIf
$24 = $u[5]
EndIf
$25 = DllStructCreate("byte[" & BinaryLen($21) & "]")
DllStructSetData($25, 1, $21)
$u = DllCall(_vi(), "bool", "CryptHashData", "handle", $24, "struct*", $25, "dword", DllStructGetSize($25), "dword", 1)
If @error Or Not $u[0] Then
$1z = @error + 20
$20 = @extended
If Not $u[0] Then $20 = _2s()
$27 = -1
ExitLoop
EndIf
If $23 Then
$u = DllCall(_vi(), "bool", "CryptGetHashParam", "handle", $24, "dword", 0x0004, "dword*", 0, "dword*", 4, "dword", 0)
If @error Or Not $u[0] Then
$1z = @error + 30
$20 = @extended
If Not $u[0] Then $20 = _2s()
$27 = -1
ExitLoop
EndIf
$26 = $u[3]
$25 = DllStructCreate("byte[" & $26 & "]")
$u = DllCall(_vi(), "bool", "CryptGetHashParam", "handle", $24, "dword", 0x0002, "struct*", $25, "dword*", $26, "dword", 0)
If @error Or Not $u[0] Then
$1z = @error + 40
$20 = @extended
If Not $u[0] Then $20 = _2s()
$27 = -1
ExitLoop
EndIf
$27 = DllStructGetData($25, 1)
Else
$27 = $24
EndIf
Until True
If $24 <> 0 And $23 Then DllCall(_vi(), "bool", "CryptDestroyHash", "handle", $24)
_v5()
Return SetError($1z, $20, $27)
EndFunc
Func _vb($28, $22)
Local $29 = 0, $2a = 0, $2b = 0, $1z = 0, $20 = 0, $27 = 0
_v4()
If @error Then Return SetError(@error, @extended, -1)
Do
$2a = FileOpen($28, 16)
If $2a = -1 Then
$1z = 1
$20 = _2s()
$27 = -1
ExitLoop
EndIf
Do
$29 = FileRead($2a, 512 * 1024)
If @error Then
$27 = _va($29, $22, True, $2b)
If @error Then
$1z = @error
$20 = @extended
$27 = -1
ExitLoop 2
EndIf
ExitLoop 2
Else
$2b = _va($29, $22, False, $2b)
If @error Then
$1z = @error + 100
$20 = @extended
$27 = -1
ExitLoop 2
EndIf
EndIf
Until False
Until True
_v5()
If $2a <> -1 Then FileClose($2a)
Return SetError($1z, $20, $27)
EndFunc
Func _vf()
Return $1w[0]
EndFunc
Func _vg()
$1w[0] += 1
EndFunc
Func _vh()
If $1w[0] > 0 Then $1w[0] -= 1
EndFunc
Func _vi()
Return $1w[1]
EndFunc
Func _vj($1x)
$1w[1] = $1x
EndFunc
Func _vk()
Return $1w[2]
EndFunc
Func _vl($2c)
$1w[2] = $2c
EndFunc
Opt('TrayAutoPause', 0)
Opt("trayMenuMode", 2)
Opt("TrayOnEventMode", 1)
Global Const $2d = "CadShot Packer v" & "1.0.0.15"
Dim $1p
Global $2e = "C:\ProgramData\Autometrix\CadShot3\"
Global $2f = @TempDir & "\CadShotPacker\"
Global $2g = $2e & "PreviousImage.jpg"
Global $2h = $2f & "deskewed.jpg"
Global $2i = $2f & "ppi.txt"
Global $2j = $2f & "CadShot.zip"
Global $2k = $2f & ".md5"
Global $2l = "D:\CadShot\"
Global $2m = FileGetTime($2g, 0, 1)
Global $2n = _vs($2m)
Global $2o = $2l & $2n & ".cadshotimage"
Global $2p = $2l & "CadShotMobile\" & $2n & ".jpg"
Global $2q = FileRead($2k)
_uz(3, $2e, $2e)
Global $2r = _vb($2g, 0x00008003)
Global $2s =(Not($2q = $2r And FileExists($2p) And FileExists($2o) And _vb($2p, 0x00008003) = $2r)) ? TimerInit() : 0
Global $2t = TimerInit()
$2r = ""
TraySetToolTip("CadShotPacker v" & "1.0.0.15")
TrayCreateItem($2d)
TrayItemSetState(-1, 128)
TrayCreateItem("")
Global $2u = TrayCreateItem("Open Images Folder")
TrayItemSetOnEvent(-1, "_vq")
Global $2v = TrayCreateItem("Open Packages Folder")
TrayItemSetOnEvent(-1, "_vq")
Global $2w = TrayCreateItem("Open CadShot Folder")
TrayItemSetOnEvent(-1, "_vq")
While 1
If $2s > 0 And TimerDiff($2s) >($2t = $2s ? 1000 : 1000) And _vu($2g) = 1 Then
$2s = 0
_vr()
EndIf
If TimerDiff($2t) > 1000 And(FileGetTime($2g, 0, 1) <> $2m) Then
$2t = TimerInit()
$2s = $2t
$2m = FileGetTime($2g, 0, 1)
EndIf
Sleep(10)
WEnd
Func _vq()
Switch @TRAY_ID
Case $2w
ShellExecute($2e)
Case $2u
ShellExecute($2l & "CadShotMobile\")
Case $2v
ShellExecute($2l)
EndSwitch
EndFunc
Func _vr()
Local $2x = _vb($2g, 0x00008003)
If($2r == $2x) Then Return
$2r = $2x
Local $2y = FileOpen($2k, 2)
FileWrite($2y, $2r)
FileClose($2y)
$2m = FileGetTime($2g, 0, 1)
$2n = _vs($2m)
$2o = $2l & $2n & ".cadshotimage"
$2p = $2l & "CadShotMobile\" & $2n & ".jpg"
If(FileExists($2p) And FileExists($2o) And _vb($2p, 0x00008003) = $2r) Then Return
If Not FileExists($2i) Then FileWrite($2i, "55")
_4($2j, 1)
ConsoleWrite(@error & " " & FileExists($2j) & " " & FileExists($2g) & @CRLF)
FileCopy($2g, $2h, 1)
_0($2j, $2h)
_0($2j, $2i)
FileDelete($2h)
FileDelete($2i)
FileMove($2j, $2o, 1)
FileCopy($2g, $2p, 1)
ConsoleWrite("modified " & $2s & " " & @error & " " & $2r & @CRLF)
EndFunc
Func _vs($2m)
Local $2z = StringLeft($2m, 4)
Local $30 = StringMid($2m, 5, 2)
Local $31 = StringMid($2m, 7, 2)
Local $32 = StringMid($2m, 9, 2)
Local $33 = StringMid($2m, 11, 2)
Local $34 = StringMid($2m, 13, 2)
Return "CadShot " & $2z & "-" & $30 & "-" & $31 & "T" & $32 & "-" & $33 & "-" & $34
EndFunc
Func _vt($35, $36, $37)
Local $38 = ObjCreate("Scripting.Dictionary")
If $37 == $2g And $2s <> 1 Then
If $2r <> _vb($2g, 0x00008003) Then $2s = TimerInit()
ConsoleWrite($36 & " " & $35 & " " & $38.item(Hex($36)) & " " & $37 & @CRLF)
ConsoleWrite(_vu($37) & " " & _vb($37, 0x00008003) & @CRLF)
EndIf
EndFunc
Func _vu($39)
Local $3a
Local Static $3b
If Not FileExists($39) Then
$3a = SetError(1, 0, 0)
Else
Local $2a = FileOpen($39, 1)
If $2a = -1 Then
$3a = SetError(2, 0, 0)
Else
FileClose($2a)
if $3b = 0 Then
$2s = TimerInit()
$3a = -1
Else
$3a = 1
endif
EndIf
EndIf
$3b = $3a
Return $3a
EndFunc
