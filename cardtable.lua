-- cardtable.lua

require("cards")
require("hand")
require("opponent")

-- CardTable Class Definition
CardTable = {}
CardTable.__index = CardTable

-- CardTable Class Constructer
function CardTable.new()
    local self = setmetatable({}, CardTable)
    width, height = love.graphics.getDimensions()
    self.deck = Deck.new(1900,(height*.85))
    self.music = love.audio.newSource("music/music2.mp3", "static")
    self.music:setVolume(1)
    love.audio.play(self.music)

    -- player and opponent hands
    self.playerHand = Hand.new((width/2),(height*.9))

    self.opa = OpponentArea.new(screenWidth/2, 100)
    self:initOpponents()

    self.flag = true
    return self
end

function CardTable:initOpponents()
    for x=1, 4 do
        self.opa:addOpponent(Opponent.new(("Opponent " .. tostring(x)), "face.png"))
    end
end


function CardTable:initDock()
    for x=1, 3 do
        self.playerHand:addDockTop(self.deck:getCard())
        self.playerHand:addDockBottom(self.deck:getCard())
    end
    for x=1, #self.opa.opponents do
        for y=1, 3 do
            self.opa.opponents[x]:addCardToDockTop(self.deck:getCard())
            self.opa.opponents[x]:addCardToDockBottom(self.deck:getCard())
        end
    end
    self.playerHand:updateDockPos()
end

function CardTable:draw()
    --self.deck:draw()
    self.playerHand:draw()
    self.opa:draw()
end

function CardTable:update(dt)
    if self.flag then
        self:initDock()
        self.flag = false 
    end
    self.playerHand:update(dt)
    self.opa:update(dt)
end