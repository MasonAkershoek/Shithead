require("cardtable")
require("gameData")
require("opponent")


function love.load()
    love.graphics.setNewFont(12)
    local r, g, b = love.math.colorFromBytes(0, 155, 51)
    love.graphics.setBackgroundColor(r, g, b)
    love.window.setMode(1920, 1080, {display=2})
    updateScreenDimentions()
    love.window.setFullscreen(true)
    cardTable = CardTable.new()
end
  
function love.update(dt)
    updateScreenDimentions()
    cardTable:update(dt)
    if love.keyboard.isDown("d") and #cardTable.playerHand.cards < 8 then
        --table.insert(cardTable.playerHand.cards, cardTable.deck:getCard())
        cardTable.playerHand:addCardToHand(cardTable.deck:getCard())
    end
    if love.keyboard.isDown("q") then
        love.event.quit()
    end
end
  
  
function love.draw()   
    cardTable:draw()
end
