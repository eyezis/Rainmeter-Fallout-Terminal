#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         EyeZiS

 Script Function:
	Automates the process of building a .rmskin
	NOTE: I have no idea how to do this only with the commandline

#ce ----------------------------------------------------------------------------


Global Const $sSkin = "FalloutTerminalv2"
Global Const $sSkinsFolder = @ScriptDir

FileDelete($sSkinsFolder & $sSkin & "*.rmskin")

ShellExecute("C:\Program Files\Rainmeter\Rainmeter.exe", "!Manage Skins")

$hWin = WinWait("Manage Rainmeter")
WinActivate($hWin)
ControlClick($hWin, "", "[CLASS:Button; INSTANCE:2]")

$hWin2 = WinWait("Rainmeter Skin Packager")
WinActivate($hWin2)
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:1]", "Fallout Terminal v2")
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:2]", "EyeZiS")
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:3]", "v1.0.1")
ControlClick($hWin2, "", "[CLASS:Button; INSTANCE:3]")

$hWin3 = WinWait("Add")
WinActivate($hWin3)
ControlCommand($hWin3, "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", "FalloutTerminalv2")
Sleep(500)
ControlClick($hWin3, "", "[CLASS:Button; INSTANCE:4]")

WinActivate($hWin2)
ControlClick($hWin2, "", "[CLASS:Button; INSTANCE:7]")
Sleep(500)
$sFile = ControlGetText($hWin2, "", "[CLASS:Edit; INSTANCE:1]")
ControlClick($hWin2, "", "[CLASS:Button; INSTANCE:4]")
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:2]", StringFormat("%s\%s.ini", $sSkin, $sSkin))
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:3]", "3.2.1.2386")

ControlClick($hWin2, "", "[CLASS:Button; INSTANCE:15]")

; A "human" should close the packager now

Do
	Sleep(100)
Until Not WinExists($hWin)

ConsoleWrite($sFile & @CRLF)
ConsoleWrite($sSkinsFolder & @CRLF)
FileMove($sFile, $sSkinsFolder)