-- cardtable.lua

-- CardTable Class Definition
CardTable = {}
CardTable.__index = CardTable

-- CardTable Class Constructer
function CardTable.new()
    local self = setmetatable({}, CardTable)

    -- Table Deck
    self.deck = Deck.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,(G.SCREENVARIABLES["SCREENSIZE"].y/2 - 100))
    -- Card Pile 
    self.cardPile = CardPile.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,(G.SCREENVARIABLES["SCREENSIZE"].y/2 - 100))

    -- player and opponent hands
    self.playerHand = Hand.new((G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2),(G.SCREENVARIABLES["SCREENSIZE"].y*.87))
    self.opa = OpponentArea.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, 100)
    self:initOpponents()
    -- TEsound.playLooping(G.MUSIC1, "static")

    -- PlayButton
    self.playButton = UIButton.new((G.SCREENVARIABLES["GAMEDEMENTIONS"].x * .87),(G.SCREENVARIABLES["SCREENSIZE"].y*.87), 200, 100,{color="RED", action="playButton", text="Play!",radius="10"})

    -- WINBOX
    self.winbox = UIBox.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,G.SCREENVARIABLES["SCREENSIZE"].y/2,WINBOXDEF)
    self.winbox.winner = ""

    -- Function Flags
    self.flag = true
    self.dealFlag = true

    -- GamePlay Vars
    self.topCard = 0
    G.turn = #self.opa.opponents + 1
    self.pitch = 1
    self.dealNum = 1
    self.dealTimer = Timer.new(.05)
    G.turnTimer = Timer.new(3)
    self.burnIndex = 1
    self.turnBuffer = 0

    return self
end

function CardTable:initOpponents()
    for x=1, 4 do
        self.opa:addOpponent(Opponent.new(("Opponent " .. tostring(x)), "resources/graphics/face.png"))
    end
    self.opa:updatePos(self.opa.opponents, true, true)
    self.opa:setPos(nil, 500, true)
end

function CardTable:deal()
    if self.dealTimer:isExpired() then
        self.dealTimer:reset()
        if #self.deck.usedCards ~= 52 then
            if self.dealNum <= #self.opa.opponents then 
                self.opa:deal(self.deck:getCard(), self.dealNum)
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
            TEsound.pitch("deal", self.pitch)
            self.pitch = self.pitch + .001
        else
            G.gamestate = G.GAMESTATES[2]
            self.dealTimer:stopTimer()
            TEsound.pitch("deal", 1)
        end
    end
end

function CardTable:addCardsToHand(cards)
    for x=1, #cards do
        if self.topCard == 10 then
            cards[x].burnParticals:emit(100)
            self.deck:addDiscard(cards[x])
        else
            if G.turn < #self.opa.opponents + 1 then
            self.opa.opponents[G.turn]:addCardToHand(cards[x]) 
            else
                self.playerHand:addCardToHand(cards[x])
            end
        end
    end
end

function CardTable:checkWin()
    if #self.playerHand.dockBottom == 0 and #self.playerHand.cards == 0 then
        return {"Player"}
    end
    for op in ipairs(self.opa.opponents) do
        if #self.opa.opponents[op].dock.dockBottom == 0 and #self.opa.opponents[op].hand == 0 then 
            return {self.opa.opponents[op].name}
        end
    end
end

function CardTable:gameLogic()
    -- Logic for dealing the cards
    if G.gamestate == "DEAL" then
        self:deal() 
        self.playerHand:updateDockPos()

    -- Logic for taking turns
    elseif G.gamestate == "TURN" then
        local winData = self:checkWin()
        if winData ~= nil then
            self.winbox.winner = winData[1]
            self.winbox.contents[1]:setText((self.winbox.winner .. self.winbox.contents[1].text))
            G.gamestate = G.GAMESTATES[5]
            self.winbox:setActive()
        else
            self.playerHand:setDockActivity()
            if #self.cardPile.cards ~= 0 then

                self.topCard = self.cardPile:getTopCard()

                if self.topCard == 10 then
                    G.gamestate = G.GAMESTATES[3]
                    self.dealTimer:reset(.5)
                end
            else
                self.topCard = 0 
            end

            if G.turn < (#self.opa.opponents + 1) then
                if self.turnBuffer == 0 then
                    self.turnBuffer = 50
                    local tmp = self.opa.opponents[G.turn]:turn(self.topCard)
                    if tmp == false then
                        G.gamestate = G.GAMESTATES[4]
                        self.dealTimer:reset(.5)
                    else   
                        self.cardPile:addCard(tmp)
                    end
                    if G.gamestate == "TURN" then
                        G.turn = G.turn + 1
                    end
                else
                self.turnBuffer = self.turnBuffer - 1 
                end
            else
                if self.turnBuffer == 0 then
                    local tmp = self.playerHand:checkHand(self.topCard)
                    if tmp then
                        if G.playerPlayButton then
                            G.playerPlayButton = false
                            local playerCard = self.playerHand:getCard()
                            if playerCard ~= nil then
                                self.turnBuffer = 50
                                print(playerCard.rank, self.cardPile:getTopCard())
                                if checkCard(playerCard.rank, self.cardPile:getTopCard()) then
                                    G.turn = G.turn + 1
                                else
                                    G.gamestate = G.GAMESTATES[4]
                                    self.dealTimer:reset(.5)
                                    self.turnBuffer = 50
                                end
                                self.cardPile:addCard(playerCard)
                            end
                        end
                    else
                        G.gamestate = G.GAMESTATES[4]
                        self.dealTimer:reset(.5)
                        self.turnBuffer = 50
                    end
                else
                    self.turnBuffer = self.turnBuffer - 1 
                end
            end
            if G.turn > #self.opa.opponents + 1 then
                G.turn = 1
            end
        end

    -- Logic for burning the deck
    elseif G.gamestate == "BURN" then
        if self.dealTimer:isExpired() then
            self.dealTimer:reset(.05)
            self.cardPile.cards[#self.cardPile.cards].burnParticals:emit(20)
            self.deck:addDiscard(self.cardPile:getCard())
            if #self.cardPile.cards <= 0 then G.gamestate = G.GAMESTATES[2] self.dealTimer:stopTimer() end
        end

    -- Logic for picking up the deck
    elseif G.gamestate == "PICKUP" then
        if self.dealTimer:isExpired() then
            self.dealTimer:reset(.05)
            if G.turn < (#self.opa.opponents + 1) then
                self.opa.opponents[G.turn]:addCardToHand(self.cardPile:getCard()) 
            else
               self.playerHand:addCardToHand(self.cardPile:getCard())
            end
            if #self.cardPile.cards <= 0 then G.gamestate = G.GAMESTATES[2] self.dealTimer:stopTimer() G.turn = G.turn + 1 end
        end
    
    elseif G.gamestate == "WIN" then

    end
        
end

function CardTable:draw()
    self.deck:draw()
    self.playerHand:draw()
    self.opa:draw()
    self.cardPile:draw()
    self.deck:draw()
    self.playButton:draw()
    if G.gamestate == "WIN" then
        self.winbox:draw()
    end
end

function CardTable:update(dt)
    self.dealTimer:update(dt)
    self.cardPile:update(dt)
    self:gameLogic()
    self.playerHand:update(dt)
    self.opa:update(dt)
    self.deck:update(dt)
    self.playButton:update()
    if G.gamestate == "WIN" then
        self.winbox:update(dt)
    end
end

-- UIDefinitions for the CardTable

-- Definition for Win Box
WINBOXDEF = {
    radius=10, 
    padding=10, 
    borderSize=10,
    alignment="right",
    positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,-100),Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)},
    contents={
        UILabel.new(
        G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,
        G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2,
        20,
        {
            alignment="center",
            text=" WINS!!!\n"
        }
    )
    }
}