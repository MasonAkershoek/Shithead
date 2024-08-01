require("cardtable")
require("gameData")
require("opponent")

--[[
TO-DO List
-------------------
* Make the game run at a consistant frame rate of 60 fps
* Fix the Move function to make sure things always move in a straight line to its location
* Standerdize and set up a scaling engine to make sure everythin in the game scales properly
* Begin setting up the load Function better, write a function to handle monitor detection and the ability of that monitor
* Change the card flip animation so that if flips with its movment and compleate the flip when it gets to its destination

Ideas
-------------------
* when a 10 is played make a burning effect for every card in the pile using partical effects and some shaders/ animation
* When a 8 is played use some kind of shader effect to make the 8 card look like glass when hovered over
* when a 5 is played make blue arrow partical effects that go down
* Figure something out for two idk
]]


function love.load()
    love.graphics.setNewFont(12)
    local r, g, b = love.math.colorFromBytes(0, 155, 51)
    love.graphics.setBackgroundColor(r, g, b)
    love.window.setMode(1920, 1080, {display=3})
    updateScreenDimentions()
    love.window.setFullscreen(true)
    cardTable = CardTable.new()
end
  
function love.update(dt)
    updateScreenDimentions()
    cardTable:update(dt)
    if love.keyboard.isDown("q") then
        love.event.quit()
    end
end
  
  
function love.draw()   
    cardTable:draw()
end
