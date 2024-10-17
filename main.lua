push = require "librarys.push"

if not _RELESE_MODE then
	require "librarys.lovedebug"
end
require "librarys.tesound"
require "engine.components"
require "engine.functions"
require "gameObjects"
require "gameData"
moonshine = require 'librarys.moonshine'
require "hand"
require "cards"
require "mainmenu"
require "opponent"
--require "engine.ui"
require "engine.UI"
require "cardtable"
require "math"

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
	math.randomseed(os.time())
	push:setupScreen(G.SCREENVARIABLES["GAMEDEMENTIONS"].x, G.SCREENVARIABLES["GAMEDEMENTIONS"].y, G.SCREENVARIABLES["SCREENSIZE"].x, G.SCREENVARIABLES["SCREENSIZE"].y, {fullscreen = G.SCREENVARIABLES["FULLSCREEN"], resizable = false, canvas = false, pixelperfect = false, stretched=false})
	G.EVENTMANAGER:on("play", play)
	G.EVENTMANAGER:on("quit", function() love.event.quit() end)
	G.EVENTMANAGER:on("playButton", function() G.playerPlayButton = true end)
	G.EVENTMANAGER:on("advanceTurn", function() G.turn = G.turn + 1 end)
	G:initGameScreens()

	effect = moonshine(moonshine.effects.crt)
	.chain(moonshine.effects.scanlines)
end
  
function love.update(dt)
    G:update(dt)
	TEsound.cleanup()
end
  
  
function love.draw()   
	G:draw()
end