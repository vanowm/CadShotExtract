#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=CadShot automatic pack
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=©V@no 2023
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=ProductName|CadShotPack
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /so /rm /rsln
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <_zip.au3>
#include <file.au3>
#include <FileSystemMonitor.au3>
#include <Crypt.au3>

;~ Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)

dim $msg
global $cadShotDir = "C:\ProgramData\Autometrix\CadShot3\"
global $cadShotImage = $cadShotDir & "PreviousImage.jpg"
global $cadShotDeskewed = $cadShotDir & "deskewed.jpg"
global $cadShotPpi = $cadShotDir & "ppi.txt"
global $cadShotDestDir = "D:\CadShot\"
; Setup File System Monitoring
_FileSysMonSetup(3, $cadShotDir, $cadShotDir)

; Main Loop

global $modified = 0
global $hash
While 1

	; Handle Directory related events
	;~ _FileSysMonDirEventHandler()

	$msg = GUIGetMsg()
	if $modified And TimerDiff($modified) > 1000 And _FileTestOpen($cadShotImage) then
		$modified = 0
		local $_hash = _Crypt_HashFile($cadShotImage, $CALG_MD5)
		if ($hash == $_hash) Then continueLoop
		$hash = $_hash
		if Not FileExists($cadShotPpi) Then FileWrite($cadShotPpi, "55")
		local $cadShotFileZip = $cadShotDir & "CadShot.zip"
		_Zip_Create($cadShotFileZip, 1)
		ConsoleWrite(@error & " " & FileExists($cadShotFileZip) & " " & FileExists($cadShotImage) & @CRLF)
		FileMove($cadShotImage, $cadShotDeskewed, 1)
		_Zip_AddItem($cadShotFileZip, $cadShotDeskewed)
		_Zip_AddItem($cadShotFileZip, $cadShotPpi)
		FileMove($cadShotDeskewed, $cadShotImage, 1)
		local $cadShotFile = "CadShot " & @YEAR & "-" & @MON & "-" & @MDAY & "T" & @HOUR & "-" & @MIN & "-" & @SEC
		local $cadShotDestFile = $cadShotDestDir & $cadShotFile & ".cadshotimage"
		local $cadShotDestImage = $cadShotDestDir & "CadShotMobile\" & $cadShotFile & ".jpg"
		FileMove($cadShotFileZip, $cadShotDestFile, 1)
		FileCopy($cadShotImage, $cadShotDestImage, 1)
		consolewrite($modified & " " & @error & " " & $hash & @CRLF)
	endif
WEnd

Func _FileSysMonActionEvent($event_type, $event_id, $event_value)

	Local $event_type_name
	Local $fs_event = ObjCreate("Scripting.Dictionary")

	if $event_value == $cadShotImage Then
	
		if $hash <> _Crypt_HashFile($cadShotImage, $CALG_MD5) Then $modified = TimerInit()
		ConsoleWrite($event_id & " " & $event_type & " " & $fs_event.item(Hex($event_id)) & " " & $event_value & @CRLF)
		ConsoleWrite(_FileTestOpen($event_value) & " " & _Crypt_HashFile($event_value, $CALG_MD5) & @CRLF)
	EndIf
EndFunc

Func _FileTestOpen($FileIn)
    If Not FileExists($FileIn) Then Return SetError(1, 0, 0)
    Local $hFile = FileOpen($FileIn, 1)
    If $hFile = -1 Then
        Return SetError(2, 0, 0)
    Else
        FileClose($hFile)
        Return 1
    EndIf
EndFunc
