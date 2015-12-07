[Variables]
; There are 3 possible options:
; 1. Non clickable text: Only .Text
; 2. Menu: .Menu (optional .Text)
;          Menus can have an optional .Header value, which is displayed in the header when the menu is opened
; 3. Bang: .Bang and .Text (if .Text is omitted it displays as "(null)")
;          Bangs can have and optional .Msg value that is displayed when the option is clicked
; If both .Menu and .Bang exist, .Bang is used and .Menu is ignored
;
; A ".Menu" references another variable "namespace", in this case it is "Programs"
; the options for "Programs" are located in the Terminal.Programs... variables
Terminal.1.Menu=Programs

Terminal.2.Menu=Games

Terminal.3.Menu=Web
Terminal.3.Text=Websites



Terminal.Programs.1.Text=Google Chrome
Terminal.Programs.1.Bang=["C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"]
;Terminal.Programs.1.Msg=LUA MOTHERFUCKER

Terminal.Programs.2.Text=Steam
Terminal.Programs.2.Bang=["S:\Steam\steam.exe"]

Terminal.Programs.3.Text=Skype
Terminal.Programs.3.Bang=["C:\Program Files (x86)\Skype\Phone\Skype.exe"]

Terminal.Programs.4.Text=Team Speak
Terminal.Programs.4.Bang=["C:\Program Files (x86)\TeamSpeak 3 Client\ts3client_win32.exe"]

Terminal.Programs.5.Text=Photoshop
Terminal.Programs.5.Bang=["C:\Program Files (x86)\Photoshop\Photoshop.exe"]

Terminal.Programs.2.Text=Task Manager
Terminal.Programs.2.Bang=["taskmgr.exe"]



Terminal.Games.Header=Entertainment Maintainers

Terminal.Games.1.Text=Counter Strike: GO
Terminal.Games.1.Bang=["steam://rungameid/730"]

Terminal.Games.2.Text=Rocket League
Terminal.Games.2.Bang=["steam://rungameid/252950"]

Terminal.Games.3.Text=The Binding of Isaac: Rebirth
Terminal.Games.3.Bang=["steam://rungameid/250900"]

Terminal.Games.4.Text=Prison Architect
Terminal.Games.4.Bang=["steam://rungameid/233450"]

Terminal.Games.5.Text=Fallout: New Vegas
Terminal.Games.5.Bang=["steam://rungameid/22380"]



Terminal.Web.1.Text=Reddit
Terminal.Web.1.Bang=["https://reddit.com"]
Terminal.Web.1.Msg=Connecting to Reddit...

Terminal.Web.2.Text=Youtube
Terminal.Web.2.Bang=["https://youtube.com"]
Terminal.Web.2.Msg=Connecting to Youtube...

Terminal.Web.3.Text=Gmail
Terminal.Web.3.Bang=["https://mail.google.com"]
Terminal.Web.3.Msg=Connecting to Gmail...

Terminal.Web.4.Text=Amazon
Terminal.Web.4.Bang=["https://amazon.com"]
Terminal.Web.4.Msg=Connecting to Amazon...

Terminal.Web.5.Text=Netflix
Terminal.Web.5.Bang=["https://netflix.com"]
Terminal.Web.5.Msg=Connecting to Netflix...
