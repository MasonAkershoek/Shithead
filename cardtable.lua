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

    -- Table Deck
    self.deck = Deck.new(screenWidth/2,(screenHeight/2 - 100))

    -- player and opponent hands
    self.playerHand = Hand.new((screenWidth/2),(screenHeight*.9))
    self.opa = OpponentArea.new(screenWidth/2, 100)
    self:initOpponents()

    -- Function Flags
    self.flag = true
    self.dealFlag = true
    self.timer = 0
    self.dealNum = 1

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

function CardTable:deal()
    if self.timer == 0 then
        self.timer = 10
        if #self.deck.usedCards ~= 52 then
            if self.dealNum <= #self.opa.opponents then 
                print(#self.opa.opponents[self.dealNum].dock.dockBottom)
                print(#self.opa.opponents[self.dealNum].dock.dockTop)
                if #self.opa.opponents[self.dealNum].dock.dockBottom < 3 then
                    self.opa.opponents[self.dealNum]:addCardToDockBottom(self.deck:getCard())
                elseif #self.opa.opponents[self.dealNum].dock.dockTop <= 3 then
                    self.opa.opponents[self.dealNum]:addCardToDockTop(self.deck:getCard())
                else
                    self.opa.opponents[self.dealNum]:addCardToHand(self.deck:getCard())
                end
            else
                if #self.playerHand.dockBottom < 3 then
                self.playerHand:addDockBottom(self.deck:getCard())
                elseif #self.playerHand.dockTop < 3 then
                    self.playerHand:addDockTop(self.deck:getCard())
                else
                    self.playerHand:addCardToHand(self.deck:getCard())
                end
            end
            self.dealNum = self.dealNum + 1
            if self.dealNum > #self.opa.opponents + 1 then
                self.dealNum = 1
            end
        else
            self.dealFlag = false 
        end
    else
        self.timer = self.timer - 1
    end
end

function CardTable:draw()
    self.deck:draw()
    self.playerHand:draw()
    self.opa:draw()
end

function CardTable:update(dt)
    --[[
    if self.flag then
        self:initDock()
        self.flag = false 
    end
    ]]
    if self.dealFlag then
        self:deal() 
        self.playerHand:updateDockPos()
    end
    self.playerHand:update(dt)
    self.opa:update(dt)
end