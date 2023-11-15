#include <_zip.au3>
#include <file.au3>

$sFileExtract = "deskewed.jpg"
$sDirExtract = "" ;"CadShotMobile\"
for $i = 1 to $CmdLine[0]
	$sFileCadShot = $CmdLine[$i]
	Local $sDrive, $sDir, $sName, $sExt
	_PathSplit($sFileCadShot, $sDrive, $sDir, $sName, $sExt)
	$sPath = $sDrive & $sDir
	$sFile = $sPath & $sName
	;~ ConsoleWrite($sFile & @CRLF)
	;~ ConsoleWrite($sPath & @CRLF)

	if $sExt = ".cadshotimage" OR $sExt = ".cadshot" OR $sExt = ".zip" Then
		$sFileZip = $sFile & ".zip"
		FileMove($sFileCadShot, $sFileZip, 1)
		$result = _Zip_Unzip($sFileZip, $sFileExtract, $sPath, 1)
		;~ ConsoleWrite($result & @CRLF)
		;~ consoleWrite(@error & @CRLF)
		FileMove($sFileZip, $sFileCadShot, 1)
		FileMove($sPath & $sFileExtract, $sPath & $sDirExtract & $sName & ".jpg", 1)
		;~ ConsoleWrite($sFileCadShot & @CRLF)
	EndIf
Next