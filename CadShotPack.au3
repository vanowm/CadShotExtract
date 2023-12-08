#Include <APIConstants.au3>
#Include "RDC.au3"
#Include <Array.au3>
#include <Crypt.au3>

Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)

_RDC_OpenDll()
If @Error Then
    ConsoleWrite('Error: _RDC_OpenDll() - ' & @Error & @CR)
    Exit
EndIf

Global $rdc, $aData

global $cadShotDir = "C:\ProgramData\Autometrix\CadShot3"
$rdc = _RDC_Create($cadShotDir, 0, BitOR(0, $FILE_NOTIFY_CHANGE_SIZE, $FILE_NOTIFY_CHANGE_ATTRIBUTES, $FILE_NOTIFY_CHANGE_LAST_WRITE, $FILE_NOTIFY_CHANGE_CREATION, $FILE_NOTIFY_CHANGE_SECURITY))
If @Error Then
	ConsoleWrite('Error: _RDC_Create() - ' & @Error & ', ' & @Extended & @CR)
	Exit
EndIf

global $hash = ""
global $prevHash = null
While 1
	If $rdc = -1 Or $prevHash = $hash Then
		ContinueLoop
	EndIf
	$aData = _RDC_GetData($rdc)
	If @Error Then

		ConsoleWrite('Error: _RDC_GetData() - ' & @Error & ', ' & @Extended & ', ' & $cadShotDir & @CR)

		; Delete thread to avoid receiving this error!
		_RDC_Delete($rdc)
		$rdc = -1
		ContinueLoop
	EndIf
	For $j = 1 To $aData[0][0]

		ConsoleWrite("-----" & @cr & $aData[$j][1] & ' - ' & $aData[$j][0] & @CR)
		$hash = _Crypt_HashFile($cadShotDir & "/" & $aData[$j][0], $CALG_MD5)
	Next
	$prevHash = $hash
	ConsoleWrite($hash & @CR)
    Sleep(100)
WEnd