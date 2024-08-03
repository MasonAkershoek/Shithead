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

    -- Card Pile 
    self.cardPile = CardPile.new(screenWidth/2,(screenHeight/2 - 100))

    -- player and opponent hands
    self.playerHand = Hand.new((screenWidth/2),(screenHeight*.9))
    self.opa = OpponentArea.new(screenWidth/2, 100)
    self:initOpponents()
    love.audio.play(music1)

    -- Function Flags
    self.flag = true
    self.dealFlag = true
    self.timer = 0
    self.turnBuffer = 0
    self.dealNum = 1

    -- GamePlay Vars
    self.topCard = 0
    self.turn = #self.opa.opponents + 1

    return self
end

function CardTable:initOpponents()
    for x=1, 4 do
        self.opa:addOpponent(Opponent.new(("Opponent " .. tostring(x)), "graphics/face.png"))
    end
end

function CardTable:deal()
    if self.timer == 0 then
        self.timer = 5
        if #self.deck.usedCards ~= 52 then
            if self.dealNum <= #self.opa.opponents then 
                if self.opa.opponents[self.dealNum].dock:getBottomNum() < 3 then
                    self.opa.opponents[self.dealNum]:addCardToDockTop(self.deck:getCard())
                elseif self.opa.opponents[self.dealNum].dock:getTopNum() < 3 then
                    self.opa.opponents[self.dealNum]:addCardToDockBottom(self.deck:getCard())
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

function CardTable:checkSelect()
    tmp = 0
    if #self.playerHand.cards > 0 then 
        for x=1, #self.playerHand.cards do
            if self.playerHand.cards[x].newSelectFlag then
                tmp = x
                break
            end
        end
        if tmp ~= 0 then
            for x=1, #self.playerHand.cards do
                if x ~= tmp then
                    if self.playerHand.cards[x].selected then
                        self.playerHand.cards[x]:deSelect()
                    end
                end
            end
        end
    end
end

function CardTable:addCardsToHand(cards)
    for x=1, #cards do
        if self.turn < #self.opa.opponents + 1 then
           self.opa.opponents[self.turn]:addCardToHand(cards[x]) 
        else
            self.playerHand:addCardToHand(cards[x])
        end
    end
end

function CardTable:gameLogic()
    if self.dealFlag then
        self:deal() 
        self.playerHand:updateDockPos()
    else
        print(self.topCard)
        if #self.cardPile.cards ~= 0 then
            self.topCard = self.cardPile:getTopCard()
        else
           self.topCard = 0 
        end
        if self.turn < (#self.opa.opponents + 1) then
            if self.turnBuffer == 0 then
                self.turnBuffer = 50
                tmp = self.opa.opponents[self.turn]:turn(self.topCard)
                if tmp == false then
                    cards = self.cardPile:pickUpPile()
                    self:addCardsToHand(cards)
                else   
                    self.cardPile:addCard(tmp)
                end
                self.turn = self.turn + 1
            else
               self.turnBuffer = self.turnBuffer - 1 
            end
        else
            if love.keyboard.isDown("p") then
                self.turnBuffer = 50
                self.cardPile:addCard(self.playerHand:getCard())
                self.turn = self.turn + 1
            end
        end
        if self.turn > #self.opa.opponents + 1 then
            self.turn = 1
        end
    end
end

function CardTable:draw()
    self.deck:draw()
    self.playerHand:draw()
    self.opa:draw()
    self.cardPile:draw()
end

function CardTable:update(dt)
    self:checkSelect()
    self.cardPile:update(dt)
    self:gameLogic()
    self.playerHand:update(dt)
    self.opa:update(dt)
    
end