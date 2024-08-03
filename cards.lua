-- Cards.lua

require("sprite")

Card = setmetatable({}, {__index = Sprite})
Card.__index = Card

math.randomseed(os.time())

-- Card Class Constructor method
function Card.new(newRank, newSuit, nx, ny)
    local self = setmetatable(Sprite.new(), Card)

    -- Card Atributes
    self.rank = newRank
    self.suit = newSuit
    self.dealSound = love.audio.newSource("music/deal.mp3", "static")
    self.dealSound:setVolume(1)

    -- Position
    self.pos.x = nx
    self.pos.y = ny

    -- Speed
    self.speed = 4000

    -- Card States
    self.hovered = false
    self.selected = false
    self.moving = false
    self.fliped = false
    self.active = true
    self.flipping = false

    -- Function Variables
    self.oldmousedown = ""
    self.flipFlag = false
    self.floatFlag = true
    self.hoverFlag = true
    self.newSelectFlag = false

    -- Card Image
    self.cardBack = love.graphics.newImage("graphics/cards/myCards/CardBack2.png")
    self:getCardFace()
    self.image = self.cardBack
    self:initSprite()

    return self
end

-- This method handles the logic for hovering over the cards
function Card:hover()
    if not self.flipping then
        if self:checkMouseHover() then
            if self.hoverFlag then
                self.xScale = self.xScale + .25
                self.yScale = self.yScale + .25
                self.hoverFlag = false
            else
                if self.xScale >= self.baseScale +.1 then
                    self.xScale = self.xScale - .1
                    self.yScale = self.yScale - .1
                end
            end
        else
            if self.xScale > self.baseScale and not self.flipping then
                self.xScale = self.xScale - .1
                self.yScale = self.yScale - .1
            elseif not self.flipping and self.xScale ~= self.baseScale then
                self.xScale = self.baseScale
                self.yScale = self.baseScale
                self.hoverFlag = true
            end
        end
    end
end

function Card:getCardFace()
    if self.suit == 1 then
        self.cardFace = love.graphics.newImage("graphics/cards/cardSpades" .. tostring(self.rank) .. ".png")
    elseif self.suit == 3  then
        self.cardFace = love.graphics.newImage("graphics/cards/cardClubs" .. tostring(self.rank) .. ".png")
    elseif self.suit == 2 then
        self.cardFace = love.graphics.newImage("graphics/cards/cardHearts" .. tostring(self.rank) .. ".png")
    else
        self.cardFace = love.graphics.newImage("graphics/cards/cardDiamonds" .. tostring(self.rank) .. ".png")
    end
end

function Card:floatingAnimation()
    if self.floatFlag then
        self.xSkew = self.xSkew - .001
        self.ySkew = -(self.xSkew)
        if self.xSkew <= -0.05 then
            self.floatFlag = false
        end
    else
        self.xSkew = self.xSkew + .001 
        self.ySkew = -(self.xSkew)
        if self.xSkew >= .05 then
            self.floatFlag = true
        end
    end
end

function Card:onSelect()
    self.cooldown = 40
    mx, my = love.mouse.getPosition()
    local tlx = (self.pos.x - (self.width/2))
    local tly = (self.pos.y - (self.height/2))
    if mx > tlx and mx < (tlx + self.width) and my > tly and my < (tly + self.height) then
        if love.mouse.isDown(1) and not self.oldmousedown then
            if self.selected ~= false then
                self.selected = false
                self:setNewPos(nil, (self.pos.y + 20))
            else 
                self.selected = true
                self.newSelectFlag = true
                self:setNewPos(nil, (self.newPos.y - 20))
            end
        end
    end
    self.oldmousedown = love.mouse.isDown(1)
end

function Card:deSelect()
    self.selected = false
    self:setNewPos(nil, self.pos.y + 20)
end

function Card:flipAnimation()
    if self.flipping then
        if self.flipFlag then
            self.xScale = self.xScale + .04
            if self.xScale == self.baseScale then
                self.flipping = false
                self.flipFlag = false
                self.xScale = self.baseScale
                self.yScale = self.baseScale
            end
        else
            self.xScale = self.xScale - .04
            if self.xScale <= 0 then
                self.flipFlag = true
                if self.fliped then
                    self.fliped = false
                    self.image = self.cardBack
                    self.xScale = self.baseScale
                    self.yScale = self.baseScale
                else
                    self.fliped = true
                    self.image = self.cardFace
                end
            end
        end
    end
end

function Card:update(dt)
    if self.newSelectFlag then
        self.newSelectFlag = fasle
    end
    if self.active then
        self:onSelect() 
    end
    if self.fliped then
        self:hover()
    end
    self:move(dt)
    self:floatingAnimation()
    self:flipAnimation()
end

Deck = {}
Deck.__index = Deck

Deck.usedCards = {}

-- Deck Constructor class
function Deck.new(newx, newy)
    local self = setmetatable({}, Deck)
    self.image = love.graphics.newImage("graphics/cards/myCards/CardBack2.png")
    self.image:setFilter("nearest","nearest") 
    self.x = newx
    self.y = newy
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.cards = self:buildDeck(newx, newy)
    return self
end

-- This method generates all cards in the deck
function Deck:buildDeck(x,y)
    tmp = {}
    for i=1, 4 do
        for j=1, 13 do
            table.insert(tmp, Card.new(j,i, self.x, self.y))
        end
    end
    return tmp
end

function Deck:getCard()
    randCard = math.random(52)
    while self:checkUsedCards(randCard) do
        randCard = math.random(52)
    end
    table.insert(self.usedCards, randCard)
    return self.cards[randCard]
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
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.width/2, self.height/2)
    end
end

CardPile = {}
CardPile.__index = CardPile

function CardPile.new(newx, newy)
    local self = setmetatable({}, CardPile)
    self.cards = {}
    self.x = newx
    self.y = newy
    return self
end

function CardPile:addCard(newCard)
    table.insert(self.cards, newCard)
    self.cards[#self.cards]:setNewPos(self.x, self.y)
    if not self.cards[#self.cards].fliped then
        self.cards[#self.cards].flipping = true
    end
    love.audio.play(self.cards[#self.cards].dealSound)
end

function CardPile:pickUpPile()
    tmp = {}
    for x=1, #self.cards do
        table.insert(tmp, self.cards[x])
    end
    for x = 1, #self.cards do
        table.remove(self.cards, x)
    end
    return tmp
end

function CardPile:getTopCard()
    return self.cards[#self.cards].rank
end

function CardPile:draw()
    if #self.cards > 0 then
        for x=1, #self.cards do
            self.cards[x]:draw()
        end
    end
end

function CardPile:update(dt)
    if #self.cards > 0 then
        for x=1, #self.cards do
            self.cards[x]:update(dt)
        end
    end
end