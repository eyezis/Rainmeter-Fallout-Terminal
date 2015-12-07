function Initialize()
	bDebugMode = false

	bScanlines = (SKIN:GetVariable("Scanlines", "1") == "1")
	bSound = (SKIN:GetVariable("Sound", "1") == "1")
	SetScanlines(bScanlines)

	sMeterFormat = "MeterMenu%d"
	iNumMenuOpts = 11 -- MeterMenu11 is reserved for the [Back] option
	sBaseVar = "Terminal."

	sSoundBase="#@#Sounds\\key%d.wav"
	iSoundMax = 5 -- Sounds are from 1 to iSoundMax
	sCurrentMenu = ""
	sPrevName = "(null)"

	tMt = {}
	tMt["Action"] = {} -- Holds the functions to execute when a meter is clicked
	tMt["Text"] = {} -- Holds text to print when an option is hovered/selected
	tMt["Sound"] = {} -- Holds the name of the sound to play when an option is hovered
	tMt["Type"] = {} -- Holds the type of each option
	for i=1,iNumMenuOpts do
		local sMeter = sMeterFormat:format(i)
		tMt["Action"][sMeter] = function() end
		tMt["Text"][sMeter] = "(null)"
		tMt["Sound"][sMeter] = ""
		tMt["Type"][sMeter] = ""
	end

	loadMenu("", "Menu")
	if bSound then
		SKIN:Bang("[Play #@#Sounds\\poweron.wav]")
	end
end

-- Settings functions
function SetScanlines(bVal)
	if bVal then
		SKIN:Bang("!SetOption", "MeterScanlines", "Hidden", "0")
	else
		SKIN:Bang("!SetOption", "MeterScanlines", "Hidden", "1")
	end
	bScanlines = bVal
	SKIN:Bang('!WriteKeyValue', 'Variables', 'Scanlines', (bScanlines and '1' or '0'))
end
function SetSound(bVal)
	bSound = bVal
	SKIN:Bang('!WriteKeyValue', 'Variables', 'Sound', (bSound and '1' or '0'))
end

-- Event handlers
function onClick(sMeter)
	printd("onClick: " .. sMeter)
	tMt["Action"][sMeter]()
end
function onHover(sMeter)
	if tMt["Type"][sMeter] == "Text" then return end

	SKIN:Bang("!SetOption", sMeter, "SolidColor",  "#TextBColHover#")
	SKIN:Bang("!SetOption", sMeter, "FontColor", "#TextColHover#")
	SKIN:Bang("!SetVariable", "LowerText2", tMt["Text"][sMeter])

	if bSound then
		SKIN:Bang("[Play " .. tMt["Sound"][sMeter] .. "]")
	end
end
function onLeave(sMeter)
	SKIN:Bang("!SetOption", sMeter, "SolidColor",  "#TextBColNormal#")
	SKIN:Bang("!SetOption", sMeter, "FontColor", "#TextColNormal#")
	SKIN:Bang("!SetVariable", "LowerText2", "")
end

-- Menu handlers
-- Loads and displays a menu
function loadMenu(sMenu, sName)
	if sMenu == "" then 
		SKIN:Bang("!SetVariable", "LowerText1", "Loading Menu...")
	else
		SKIN:Bang("!SetVariable", "LowerText1", "Loading " .. tostring(sName) .. "...")
	end

	local sHeader = ""
	if sMenu == "Config." then
		sHeader = "ROBCO Industries (TM) Termlink Settings#CRLF#Clearance: ROBCO Ind. Staff"
	elseif sMenu == "" then
		sHeader = "Welcome to ROBCO Industries (TM) Termlink#CRLF#Clearance: VAULT-TEC SECURITY"
	else
		sHeader = "ROBCO Industries (TM) Termlink " .. SKIN:GetVariable(sBaseVar .. sMenu .. "Header", tostring(sName)) .."#CRLF#Clearance: VAULT-TEC SECURITY"
	end
	SKIN:Bang("!SetVariable", "Header", sHeader)

	sCurrentMenu = sMenu
	local sText = ""
	local sLastType = nil
	local iNum = 0
	local iBackInd = iNumMenuOpts

	for i=1,iNumMenuOpts-1 do
		local sMeter = sMeterFormat:format(i)

		-- Get and store the type of the current option
		sType = getType(sBaseVar .. sMenu .. i .. ".")
		tMt["Type"][sMeter] = sType
		-- Count the number of valid options
		if sType ~= nil then
			iNum = iNum + 1
		end

		-- If the previous option is not nil and this one is nil, the back button could possibly be placed here
		if sLastType ~= nil and sType == nil then
			iBackInd = i
		end

		-- Hide the meter if it is not going to do anything
		SKIN:Bang("!SetOption", sMeter, "Hidden", (sType == nil) and "1" or "0")

		-- Only process the items that we are going to be using
		if sType ~= nil then
			-- Get and set the text of the meter
			sText = getText(sBaseVar .. sMenu .. i .. ".")
			tMt["Text"][sMeter] = sText
			if bDebugMode then
				SKIN:Bang("!SetOption", sMeter, "Text", "[" .. sText .. "]" .. " - " .. tostring(sType))
			else
				SKIN:Bang("!SetOption", sMeter, "Text", "[" .. sText .. "]")
			end

			-- Get and store the sound to play when this option is highlighted
			tMt["Sound"][sMeter] = sSoundBase:format(CharHash(sText) % iSoundMax + 1)

			-- Get the function that we will run when the meter is clicked
			tMt["Action"][sMeter] = getFunction(sBaseVar .. sMenu .. i .. ".", sType, sText)
		end

		sLastType = sType
	end

	-- No options? Back is the at first one
	if iNum == 0 then iBackInd = 1 end

	-- Hide the last meter if we aren't going to use it
	if iBackInd ~= iNumMenuOpts or sMenu == "" then
		SKIN:Bang("!SetOption", sMeterFormat:format(iNumMenuOpts), "Hidden", "1")
	end

	sMeter = sMeterFormat:format(iBackInd)
	SKIN:Bang("!SetOption", sMeter, "Hidden", "0")
	-- Only show the back button if we are not on the main menu
	if sMenu ~= "" then
		-- Create the back option
		SKIN:Bang("!SetOption", sMeter, "Text", "[Back]")
		local sParent = GetMenuParent(sCurrentMenu)
		local sOld = sPrevName
		tMt["Action"][sMeter] = function() loadMenu(sParent, sOld) end
		tMt["Text"][sMeter] = "Return"
		tMt["Sound"][sMeter] = sSoundBase:format(CharHash("Back") % iSoundMax + 1)
	else
		-- Create the settings option
		SKIN:Bang("!SetOption", sMeter, "Text", "[[MeasureDate]]")
		tMt["Action"][sMeter] = function () loadMenu("Config.", "Settings") end
		tMt["Text"][sMeter] = "Settings"
		tMt["Sound"][sMeter] = sSoundBase:format(CharHash("Settings") % iSoundMax + 1)
	end

	if bDebugMode then
		SKIN:Bang("!SetVariable", "Debug", ">>> " .. sBaseVar .. sCurrentMenu .. "(" .. iNum .. " items)")
	end

	sPrevName = sName
	-- Update and redraw the skin
	redraw()
end
function getText(sOption)
	local s = SKIN:GetVariable(sOption .. "Text")
	if s == nil then
		-- Attempt to get text from the ".Menu" option
		s = SKIN:GetVariable(sOption .. "Menu")
		if s == nil then
			s = "(null)"
		end
	end

	return s
end
function getType(sOption)
	local sM = SKIN:GetVariable(sOption .. "Menu")
	local sB = SKIN:GetVariable(sOption .. "Bang")
	local sT = SKIN:GetVariable(sOption .. "Text")

	-- Text if no menu and no option but .Text exists
	if sM == nil and sB == nil and sT ~= nil then return "Text" end

	-- Menu if .Menu exists and .Bang does not
	if sM ~= nil and sB == nil then return "Menu" end
	-- Bang if .Bang exists and .Menu does not
	if sB ~= nil and sM == nil then return "Bang" end

	-- Both menu and bang options?
	-- Use .Bang, ignore .Menu
	-- And screw you for trying to break my script
	if sM ~= nil and sB ~= nil then
		return "Bang"
	end

	-- All other cases are considered not valid
	return nil
end
function getFunction(sOption, sType, sText)
	if sType == nil then
		return function() end
	elseif sType == "Text" then
		return function() end
	elseif sType == "Bang" then
		local sBang = SKIN:GetVariable(sOption .. "Bang")
		local sMsg = SKIN:GetVariable(sOption .. "Msg", "Launching " .. tostring(sText) .. "...")
		return function()
			SKIN:Bang("!SetVariable", "LowerText1", sMsg)
			SKIN:Bang(sBang)
		end
	elseif sType == "Menu" then
		local sMenu = SKIN:GetVariable(sOption .. "Menu")

		return function() loadMenu(sCurrentMenu .. sMenu .. ".", sText) end
	end

	return function() print("Error: Unhandled case") end 
end
function GetMenuParent(sMenu)
	local s = sMenu:reverse()
	local iPos = s:find(".", 2, true)
	if iPos == nil then return "" end
	s = s:sub(iPos)
	return s:reverse()
end

-- Other functions
function CharHash(sStr)
	if type(sStr) ~= "string" then return 0 end
	local s = sStr:lower()
	local iT = 0
	for i=1,s:len() do
		iT = iT + s:byte(i, i)
	end
	return iT
end
function printd(s)
	if bDebugMode then return print(s) end
end
function redraw()
	SKIN:Bang("!Update")
	SKIN:Bang("!Redraw")
end