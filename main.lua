-- Comunity Librarys
push = require "librarys.push"
require "librarys.tesound"
require "math"
if not _RELESE_MODE then
	require "librarys.lovedebug"
end

-- Personal Librarys
require "engine.logger"
require "librarys.mlib.lovecolors"
require "librarys.mlib.mmen"
require "engine.functions"
require "gameObjects"
require "gameData"
require "engine.UI"
require "engine.event"
require "hand"
require "cards"
require "mainmenu"
require "opponent"
require "cardtable"
require "globals"
require "uidefs"

local utf8 = require("utf8")

--[[
TO-DO List
-------------------
* Change the card flip animation so that if flips with its movment and compleate the flip when it gets to its destination
* Make it so when a card scales up and down with the opponent dock that it happens gradualy


Ideas
-------------------
* when a 10 is played make a burning effect for every card in the pile using partical effects and some shaders/ animation
* When a 8 is played use some kind of shader effect to make the 8 card look like glass when hovered over
* when a 5 is played make blue arrow partical effects that go down

To-Do Before demo 
-------------------
* Get all special cards working
* Get the main menu to work
* Simple win splash
]]


function love.load()
	OS = love.system.getOS()
	math.randomseed(os.time())
	push:setupScreen(G.SCREENVARIABLES["GAMEDEMENTIONS"].x, G.SCREENVARIABLES["SCREENSIZE"].y, G.SCREENVARIABLES["SCREENSIZE"].x, G.SCREENVARIABLES["SCREENSIZE"].y, {fullscreen = G.SCREENVARIABLES["FULLSCREEN"], resizable = false, canvas = false, pixelperfect = false, stretched=false})
	G:initGameScreens()
end

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
	logger:log((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.setNewFont(14)

	love.graphics.setColor(1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		if not love.graphics.isActive() then return end
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end

function love.keypressed(key,scancode,isrepeat)
	G.KEYBOARDMANAGER:addKeyPress(key)
	if key == "k" and not SETTINGS.debugBoxActive then
		G.KEYBOARDMANAGER.buffer = {}
		EVENTMANAGER:emit("activateDebug")
	end
	if key == "escape" and not SETTINGS.escMenuActive then
		G.KEYBOARDMANAGER.buffer = {}
		EVENTMANAGER:emit("activateEscapeMenu")
	end
end
  
function love.update(dt)
	G:update(dt)
	TIMERMANAGER:update(dt)
	EVENTMANAGER:update(dt)
	TEsound.cleanup()
	--myTextField:update(dt)
	G.KEYBOARDMANAGER.keyPressFlag = false
	--fps:setText("FPS: " .. love.timer.getFPS())
end
  
  
function love.draw()   
	G:draw()
	--fps:draw()
	--myTextField:draw()
end
