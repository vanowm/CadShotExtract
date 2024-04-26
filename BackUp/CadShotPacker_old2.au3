#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=CadShotPacker.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=CadShot Packer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.16
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=©V@no 2023
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=ProductName|CadShot Packer
;~ #AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /so /rm /rsln
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <_zip.au3>
#include <file.au3>
#include <FileSystemMonitor.au3>
#include <Crypt.au3>
#include <_debug.au3>
#include <TrayConstants.au3>

;~ Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)
Opt("trayMenuMode", 2) ; no aotomatic check
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

Global Const $VERSION = "1.0.0.16"
Global Const $TITLE = "CadShot Packer v" & $VERSION

If @Compiled Then
		FileCreateShortcut(@ScriptFullPath, @StartupDir & "\CadShotPacker.lnk", @ScriptDir)
Endif

Dim $msg
Global $cadShotDir = "C:\ProgramData\Autometrix\CadShot3\"
Global $cadShotDirTemp = @TempDir & "\CadShotPacker\"
Global $cadShotImage = $cadShotDir & "PreviousImage.jpg"
Global $cadShotDeskewed = $cadShotDirTemp & "deskewed.jpg"
Global $cadShotPpi = $cadShotDirTemp & "ppi.txt"
Global $cadShotFilenameZip = $cadShotDirTemp & "CadShot.zip"
Global $cadShotFilenameMD5 = $cadShotDirTemp & ".md5"
Global $cadShotDestDir = "D:\CadShot\"

Global $cadShotModified = FileGetTime($cadShotImage, 0, 1)
Global $cadShotFilename = getFileName($cadShotModified)
Global $cadShotDestPackage = $cadShotDestDir & $cadShotFilename & ".cadshotimage"
Global $cadShotDestImage = $cadShotDestDir & "CadShotMobile\" & $cadShotFilename & ".jpg"

Global $lastMD5 = FileRead($cadShotFilenameMD5)
; Setup File System Monitoring
_FileSysMonSetup(3, $cadShotDir, $cadShotDir)

; Main Loop

Global $hash = _Crypt_HashFile($cadShotImage, $CALG_MD5)
Global $modified = (Not ($lastMD5 = $hash And FileExists($cadShotDestImage) And FileExists($cadShotDestPackage) And _Crypt_HashFile($cadShotDestImage, $CALG_MD5) = $hash)) ? TimerInit() : 0
Global $modifiedCheck = TimerInit()
$hash = ""
TraySetToolTip("CadShotPacker v" & $VERSION)
TrayCreateItem($TITLE)
TrayItemSetState(-1, $TRAY_DISABLE)
TrayCreateItem("")
Global $trayImages = TrayCreateItem("Open Images Folder")
TrayItemSetOnEvent(-1, "TrayEvent")
Global $trayPackage = TrayCreateItem("Open Packages Folder")
TrayItemSetOnEvent(-1, "TrayEvent")
Global $trayCadshot = TrayCreateItem("Open CadShot Folder")
TrayItemSetOnEvent(-1, "TrayEvent")

While 1

	; Handle Directory related events
;~ _FileSysMonDirEventHandler()copy


	If $modified > 0 And TimerDiff($modified) > ($modifiedCheck = $modified ? 1000 : 1000) And _FileTestOpen($cadShotImage) = 1 Then
		$modified = 0
		checkFile()
	EndIf
	If TimerDiff($modifiedCheck) > 1000 And (FileGetTime($cadShotImage, 0, 1) <> $cadShotModified) Then
		$modifiedCheck = TimerInit()
		$modified = $modifiedCheck
		$cadShotModified = FileGetTime($cadShotImage, 0, 1)
	EndIf
	Sleep(10)
WEnd

Func TrayEvent()
	Switch @TRAY_ID
		Case $trayCadshot
			ShellExecute($cadShotDir)
		Case $trayImages
			ShellExecute($cadShotDestDir & "CadShotMobile\")
		Case $trayPackage
			ShellExecute($cadShotDestDir)
	EndSwitch
EndFunc   ;==>TrayEvent
Func checkFile()
	Local $_hash = _Crypt_HashFile($cadShotImage, $CALG_MD5)
	If ($hash == $_hash) Then Return
	$hash = $_hash
	Local $fMD5 = FileOpen($cadShotFilenameMD5, $FO_OVERWRITE)
	FileWrite($fMD5, $hash)
	FileClose($fMD5)
	$cadShotModified = FileGetTime($cadShotImage, 0, 1)
	$cadShotFilename = getFileName($cadShotModified)
	$cadShotDestPackage = $cadShotDestDir & $cadShotFilename & ".cadshotimage"
	$cadShotDestImage = $cadShotDestDir & "CadShotMobile\" & $cadShotFilename & ".jpg"
	If (FileExists($cadShotDestImage) And FileExists($cadShotDestPackage) And _Crypt_HashFile($cadShotDestImage, $CALG_MD5) = $hash) Then Return
	If Not FileExists($cadShotPpi) Then FileWrite($cadShotPpi, "55")
	_Zip_Create($cadShotFilenameZip, 1)
	ConsoleWrite(@error & " " & FileExists($cadShotFilenameZip) & " " & FileExists($cadShotImage) & @CRLF)
	FileCopy($cadShotImage, $cadShotDeskewed, 1)
	_Zip_AddItem($cadShotFilenameZip, $cadShotDeskewed)
	_Zip_AddItem($cadShotFilenameZip, $cadShotPpi)
	FileDelete($cadShotDeskewed)
	FileDelete($cadShotPpi)
	FileMove($cadShotFilenameZip, $cadShotDestPackage, 1)
	FileCopy($cadShotImage, $cadShotDestImage, 1)
	ConsoleWrite("modified " & $modified & " " & @error & " " & $hash & @CRLF)
EndFunc   ;==>checkFile

Func getFileName($cadShotModified)
	Local $year = StringLeft($cadShotModified, 4)
	Local $month = StringMid($cadShotModified, 5, 2)
	Local $day = StringMid($cadShotModified, 7, 2)
	Local $hour = StringMid($cadShotModified, 9, 2)
	Local $min = StringMid($cadShotModified, 11, 2)
	Local $sec = StringMid($cadShotModified, 13, 2)
	Return "CadShot " & $year & "-" & $month & "-" & $day & "T" & $hour & "-" & $min & "-" & $sec
EndFunc   ;==>getFileName

Func _FileSysMonActionEvent($event_type, $event_id, $event_value)

	Local $event_type_name
	Local $fs_event = ObjCreate("Scripting.Dictionary")

	If $event_value == $cadShotImage And $modified <> 1 Then

		If $hash <> _Crypt_HashFile($cadShotImage, $CALG_MD5) Then $modified = TimerInit()
		ConsoleWrite($event_id & " " & $event_type & " " & $fs_event.item(Hex($event_id)) & " " & $event_value & @CRLF)
		ConsoleWrite(_FileTestOpen($event_value) & " " & _Crypt_HashFile($event_value, $CALG_MD5) & @CRLF)
	EndIf
EndFunc   ;==>_FileSysMonActionEvent

Func _FileTestOpen($FileIn)
	Local $return
	Local Static $lastReturn
	If Not FileExists($FileIn) Then
		$return = SetError(1, 0, 0)
	Else
		Local $hFile = FileOpen($FileIn, 1)
		If $hFile = -1 Then
			$return = SetError(2, 0, 0)
		Else
			FileClose($hFile)
			if $lastReturn = 0 Then 
				$modified = TimerInit()
				$return = -1
			Else
				$return = 1
			endif
		EndIf
	EndIf
	$lastReturn = $return
	Return $return
EndFunc   ;==>_FileTestOpen
