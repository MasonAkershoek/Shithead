-- Cards.lua

require("sprite")

Card = setmetatable({}, {__index = Sprite})
Card.__index = Card

math.randomseed(os.time())

-- Card Class Constructor method
function Card.new(newRank, newSuit, nx, ny)
    local self = setmetatable(Sprite.new(), Card)
    self.rank = newRank
    self.suit = newSuit
    self.x = nx
    self.y = ny
    self.speed = 1200
    self.hovered = false
    self.selected = false
    self.moving = false
    self.fliped = false
    self.oldmousedown = ""
    self.active = true
    self.flipping = false
    self.flag = false
    self.cardBack = love.graphics.newImage("cards/CardBack.png")

    if self.suit == 1 then
        self.cardFace = love.graphics.newImage("cards/cardSpades" .. tostring(self.rank) .. ".png")
    elseif self.suit == 3  then
        self.cardFace = love.graphics.newImage("cards/cardClubs" .. tostring(self.rank) .. ".png")
    elseif self.suit == 2 then
        self.cardFace = love.graphics.newImage("cards/cardHearts" .. tostring(self.rank) .. ".png")
    else
        self.cardFace = love.graphics.newImage("cards/cardDiamonds" .. tostring(self.rank) .. ".png")
    end

    self.image = self.cardBack
    self:initSprite()
    return self
end

-- This method handles the logic for hovering over the cards
function Card:hover()
    if not self.moving then
        mx, my = love.mouse.getPosition()
        local tlx = (self.x - (self.width/2))
        local tly = (self.y - (self.height/2))
        if mx > tlx and mx < (tlx + self.width) and my > tly and my < (tly + self.height) then
            if self.hovered ~= true then
                self.hovered = true
                self.newy = (self.y - 10)
            end
        else
            if self.hovered ~= false then
                self.hovered = false
                self.newy = (self.y + 10)
            end
        end
    end
end

function Card:onSelect()
    self.cooldown = 40
    mx, my = love.mouse.getPosition()
    local tlx = (self.x - (self.width/2))
    local tly = (self.y - (self.height/2))
    if mx > tlx and mx < (tlx + self.width) and my > tly and my < (tly + self.height) then
        if love.mouse.isDown(1) and not self.oldmousedown then
            if self.selected ~= false then
                self.selected = false
                self.newY = (self.y + 20)
            else 
                self.selected = true
                self.newY = (self.y - 20)
            end
        end
    end
    self.oldmousedown = love.mouse.isDown(1)
end

function Card:flipAnimation()
    if self.flipping then
        if self.flag then
            self.xScale = self.xScale + .03
            if self.xScale == self.baseScale then
                self.flipping = false
                self.flag = false
            end
        else
            self.xScale = self.xScale - .03
            if self.xScale <= 0 then
                self.flag = true
                if self.fliped then
                    self.fliped = false
                    self.image = self.cardBack
                else
                    self.fliped = true
                    self.image = self.cardFace
                end
            end
        end
    end
end

function Card:update(dt)
    if self.active then
        self:onSelect() 
    end
    --self:hover()
    self:move(dt)
    self:flipAnimation()
    if self.cooldown ~= 0 then
        self.cooldown = self.cooldown - 5
    end
end

Deck = {}
Deck.__index = Deck

Deck.usedCards = {}

-- Deck Constructor class
function Deck.new(newx, newy)
    local self = setmetatable({}, Deck)
    self.image = love.graphics.newImage("cards/CardBack.png")
    self.image:setFilter("nearest","nearest") 
    self.x = newx
    self.y = newy
    self.dealSound = love.audio.newSource("music/deal.mp3", "static")
    self.dealSound:setVolume(1)
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
    love.audio.play(self.dealSound)
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
    --love.graphics.draw(self.image, self.x, self.y, 0, .7, .7, self.width/2, self.height/2)
end