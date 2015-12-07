#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         EyeZiS

 Script Function:
	Automates the process of building a .rmskin
	NOTE: I have no idea how to do this only with the commandline

#ce ----------------------------------------------------------------------------


Global Const $sSkin = "FalloutTerminalv2"
Global Const $sSkinsFolder = @ScriptDir

ShellExecute("C:\Program Files\Rainmeter\Rainmeter.exe", "!Manage Skins")

$hWin = WinWait("Manage Rainmeter")
WinActivate($hWin)
ControlClick($hWin, "", "[CLASS:Button; INSTANCE:2]")

$hWin2 = WinWait("Rainmeter Skin Packager")
WinActivate($hWin2)
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:1]", "Fallout Terminal v2")
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:2]", "EyeZiS")
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:3]", "v1.0.3")
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

ControlCommand($hWin2, "", "[CLASS:SysTabControl32; INSTANCE:1]", "TabRight", "2")
Sleep(1500)
ControlSetText($hWin2, "", "[CLASS:Edit; INSTANCE:2]", $sSkin & "\@Resources\Variables.inc")
Sleep(1000)

ControlClick($hWin2, "", "[CLASS:Button; INSTANCE:17]")

; A "human" should close the packager now

Do
	Sleep(100)
Until Not WinExists($hWin)

FileDelete($sSkinsFolder & "\*.rmskin")

ConsoleWrite($sFile & @CRLF)
ConsoleWrite($sSkinsFolder & @CRLF)
FileMove($sFile, $sSkinsFolder)