-- cards.lua

Card = setmetatable({}, {__index = Sprite})
Card.__index = Card

math.randomseed(os.time())

-- Card Class Constructor method
function Card.new(newRank, newSuit, nx, ny)
    local self = setmetatable(Sprite.new(nx,ny), Card)

    self.T = "Card"

    -- Card Atributes
    self.rank = newRank
    self.suit = newSuit

    -- Card States
    self.selected = false
    self.moving = false
    self.fliped = false
    self.active = true
    self.flipping = false
    self.notPlayable = false
    self.inCardPile = false

    -- Function Variables
    self.oldmousedown = ""
    self.flipFlag = false
    self.floatFlag = true
    self.hoverFlag = true
    self.newSelectFlag = false

    -- Card Image
    self.cardBack = love.graphics.newImage("resources/graphics/cards/cardBacks/cardBack1.png")
    self:getCardFace()
    self.texture = self.cardBack
    self:initSprite()
    self.darkenShader = G.darkenShader
    self.darkenShader:send("darkness", 0.5)
    self.burnParticals = love.graphics.newParticleSystem(love.graphics.newImage("resources/graphics/fire.png"), 100)

    -- Should be moved to cardpile 
    self.burnParticals:setParticleLifetime(1, 2)
    self.burnParticals:setLinearAcceleration(100, -200, -100, 0)
    self.burnParticals:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    self.burnParticals:setSpeed(10,10)
    self.burnParticals:setSpread( 2 )
    self.burnParticals:setEmissionArea("uniform", (self.texture:getWidth()/2)*self.scale.x, (self.texture:getHeight()/2)*self.scale.y)
    self.burnParticals:setEmissionRate(2)
    -----------------------------------------------------------

    return self
end

function Card:getCardFace()
    -- Get The Coresponding image data from 
    self.cardFace = G.CARDGRAPHICS["CARDFACES"]["card" .. G.CARDSUITS[self.suit] .. tostring(self.rank)]
    if self.rank == 1 then self.rank = 14 end
end

-- This method handles the logic for hovering over the cards
function Card:onHover(dt)
    -- If the card is flipping instantly return
    if self.flipping then return end
    
    if self:checkMouseHover() then
        if self.hoverFlag then
            self.scale.x = self.scale.x + .30
            self.scale.y = self.scale.y + .30
            self.hoverFlag = false
        else
            if self.scale.x >= self.baseScale +.2 then
                self.scale.x = math.max(self.scale.x - (3.5 * dt), self.baseScale)
                self.scale.y = math.max(self.scale.y - (3.5 * dt), self.baseScale)
            end
        end
    elseif self.scale.x ~= self.baseScale then
        if self.scale.x > self.baseScale then
            self.scale.x = math.max(self.scale.x - (3.5 * dt), self.baseScale)
            self.scale.y = math.max(self.scale.y - (3.5 * dt), self.baseScale)
        end
        if self.scale.x == self.baseScale then self.hoverFlag = true end
    end
end

function Card:playSound()
    TEsound.play(G.DEALSOUND, "static", {"deal"})
end

function Card:floatingAnimation(dt)
    if self.floatFlag then
        self.skew.x = self.skew.x - .05 * dt
        self.skew.y = -(self.skew.x)
        if self.skew.x <= -0.05 then
            self.floatFlag = false
        end
    else
        self.skew.x = self.skew.x + .05 * dt
        self.skew.y = -(self.skew.x)
        if self.skew.x >= .05 then
            self.floatFlag = true
        end
    end
end

function Card:onSelect()
    if self:checkMouseHover() then
        if love.mouse.isDown(1) and not self.oldmousedown then
            if self.selected ~= false then
                self:deSelect()
            else 
                self:select()
            end
        end
    end
    self.oldmousedown = love.mouse.isDown(1)
end

function Card:deSelect()
    if self.selected then
        self.selected = false
        self:setPos(nil, self.pos.y + 20)
    end
end

function Card:select()
    if not self.selected and self.active then
        self.selected = true
        self.newSelectFlag = true
        self:setPos(nil, (self.newPos.y - 20))
    end
end

function Card:startFlipping(fullFlip)
    fullFlip = fullFlip or false
    if fullFlip then
        
    else
        self.flipping = true
    
    end
    
end


function Card:flipAnimation()
    if self.flipping then
        if self.flipFlag then
            self.scale.x = self.scale.x + (5 * love.timer.getDelta())
            if self.scale.x >= self.baseScale then
                self:setScale(self.baseScale, self.baseScale)
                self.flipping = false
                self.flipFlag = false
            end
        else
            self.scale.x = self.scale.x - (5 * love.timer.getDelta())
            if self.scale.x <= 0 then
                self.flipFlag = true
                if self.fliped then
                    self.fliped = false
                    self.texture = self.cardBack
                else
                    self.fliped = true
                    self.texture = self.cardFace
                end
            end
        end
    end
end

--[[
function Card:flipAnimation()
    if self.flipping then
        local dirx = self.newPos.x - self.pos.x
        local diry = self.newPos.y - self.pos.y
        local c = math.sqrt((dirx^2) + (diry^2))
        self.scale.x = (c/self.distance)
        if self.scale.x <= 0 then
            self.flipping = false
            self.texture = self.cardFace
        end
    end
end
]]

function Card:op8(dt)
    if self.rank == 8 then 
        if self:checkMouseHover() and self.inCardPile then
            if self.transparency > 0 then 
                self.transparency = self.transparency - (.9 *dt)
                if self.transparency < 0 then self.transparency = 0 end
            end
        else
            if self.transparency < 1 then
                self.transparency = self.transparency + (.9 *dt)
                if self.transparency > 1 then self.transparency = 1 end
            end 
        end
    end

end

function Card:update(dt)
    if self.newSelectFlag then
        self.newSelectFlag = false
    end
    self:onSelect() 
    self:onHover(dt)
    self:move(dt)
    self:floatingAnimation(dt)
    self:flipAnimation()
    if self.fliped and self.rank==10 then
        self.burnParticals:update(dt)
        self.burnParticals:setSizes(self.scale.x)
        self.burnParticals:setEmissionArea("uniform", math.abs((self.texture:getWidth()/2)*self.scale.x), math.abs((self.texture:getHeight()/2)*self.scale.y))
    end
    self:op8(dt)
end

function Card:draw()
    love.graphics.setColor({0,0,0,self.transparency - .5})
    love.graphics.draw(self.texture, self.pos.x+7, self.pos.y+7, 0, self.scale.x, self.scale.y, (self.size.x/2), (self.size.y/2), self.skew.x, self.skew.y)
    love.graphics.setColor({1,1,1,1})
    if self.notPlayable then
        love.graphics.setShader(self.darkenShader)
    end
    love.graphics.setColor({1,1,1,self.transparency})
    love.graphics.draw(self.texture, self.pos.x, self.pos.y, 0, self.scale.x, self.scale.y, (self.size.x/2), (self.size.y/2), self.skew.x, self.skew.y)
    love.graphics.setColor({1,1,1,1})
    love.graphics.setShader()
    if self.fliped and self.rank==10 then
        love.graphics.draw(self.burnParticals, self.pos.x, self.pos.y)
    end
end

Deck = setmetatable({}, {__index = Sprite})
Deck.__index = Deck

Deck.usedCards = {}

-- Deck Constructor class
function Deck.new(nx, ny)
    local self = setmetatable(Sprite.new(nx,ny), Deck)

    self.T = "Deck"

    self.texture = love.graphics.newImage("resources/graphics/cards/cardBacks/cardBack1.png")
    self.cards = self:buildDeck(nx, ny)
    self.discard = {}
    self:initSprite()
    return self
end

function Deck:shuffle()
    local tmp = {}
    local posIndex = 0
    for x=1, 52 do
        local tmpCard = self:getRandCard()
        tmpCard:setPosImidiate(self.pos.x+posIndex, self.pos.y-posIndex)
        tmpCard.mouseMoveable = true
        table.insert(tmp,#tmp+1,tmpCard)
        posIndex = posIndex + .5
    end
    self.cards = tmp
    self.usedCards = {}
end

-- This method generates all cards in the deck
function Deck:buildDeck(x,y)
    local tmp = {}
    local posIndex = 0
    for i=1, 4 do
        for j=1, 13 do
            local newCard = Card.new(j,i, self.pos.x+posIndex, self.pos.y-posIndex)
            newCard.mouseMoveable = false
            table.insert(tmp, newCard)
            posIndex = posIndex + .5
        end
    end
    return tmp
end

function Deck:addDiscard(newCard)
    newCard:setPos(-200, self.pos.y)
    newCard:setScale(1, 1)
    if newCard.fliped then
        newCard.flipping = true
    end
    newCard:playSound()
    table.insert(self.discard, newCard)
    
end

function Deck:getRandCard()
    local randCard = math.random(52)
    while self:checkUsedCards(randCard) do
        randCard = math.random(52)
    end
    table.insert(self.usedCards, randCard)
    return self.cards[randCard]
end

function Deck:getDeal()
    local tmp = self.cards[#self.cards]
    table.remove(self.cards, #self.cards)
    return tmp
end

function Deck:checkUsedCards(cardNum)
    if #self.usedCards > 0 then
        for x=1, #self.usedCards do
            if cardNum == self.usedCards[x] then
                return true
            end
        end
    end
    return false
end

function Deck:draw()
    if #self.usedCards < 52 then
        drawList(self.cards)
    end
end

function Deck:update(dt)
    updateList(self.discard, dt)
end

CardPile = setmetatable({}, {__index = Node})
CardPile.__index = CardPile

function CardPile.new(nx, ny)
    local self = setmetatable(Node.new(nx,ny), CardPile)

    self.T = "CardPile"
    
    self.cards = {}
    return self
end

function CardPile:addCard(newCard)
    newCard:setPos(self.pos.x, self.pos.y)
    if not newCard.fliped then
        newCard.flipping = true
    end
    newCard:setScale(1, 1)
    newCard.active = false
    newCard.notPlayable = false
    newCard:playSound()
    newCard.inCardPile = true
    table.insert(self.cards, newCard)
end

function CardPile:getCard()
    local tmp = self.cards[#self.cards]
    tmp.inCardPile = false
    table.remove(self.cards, #self.cards)
    return tmp
end

function CardPile:empty()
    return table.remove(self.cards)
end

function CardPile:getTopCard(index)
    local index = index or 0
    if #self.cards ~= 0 then
        if self.cards[#self.cards].rank == 8 then
            if #self.cards > 1 then
                while self.cards[#self.cards - index].rank == 8 do
                    index = index + 1
                    if index >= #self.cards then return 0 end
                end
            else
               return 0 
            end
        end 
        return self.cards[#self.cards - index].rank
    else 
        return 0
    end
end

function CardPile:draw()
    drawList(self.cards)
end

function CardPile:update(dt)
    updateList(self.cards, dt)
end