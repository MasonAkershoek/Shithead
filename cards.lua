-- cards.lua

Card = setmetatable({}, { __index = Sprite })
Card.__index = Card

math.randomseed(os.time())

-- Card Class Constructor method
function Card.new(newRank, newSuit, nx, ny)
    local self = setmetatable(Sprite.new(nx, ny), Card)

    self.T = "Card"

    -- Card Atributes
    self._Identity =
    {
        rank = newRank,
        suit = newSuit
    }

    -- Card States
    self._CardStates =
    {
        playable = false,
        inPile = false,
        selected = {is=false, can=true},
        flipped = {is=false, can=true}, -- For refrance flipped = true means the card is face down
        flipping = false
    }

    -- Function Variables
    self.oldmousedown = ""
    self.newSelectFlag = false

    -- Card Image
    self._Faces = 
    {
        cardBack = love.graphics.newImage("resources/graphics/cards/cardBacks/cardBack1.png")
    }
    self:getCardFace()
    self:setSprite(self._Faces.cardBack)
    self:initSprite()

    -- self.burnParticals = love.graphics.newParticleSystem(love.graphics.newImage("resources/graphics/fire.png"), 100)

    -- Should be moved to cardpile
    -- self.burnParticals:setParticleLifetime(1, 2)
    -- self.burnParticals:setLinearAcceleration(100, -200, -100, 0)
    -- self.burnParticals:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    -- self.burnParticals:setSpeed(10, 10)
    -- self.burnParticals:setSpread(2)
    -- self.burnParticals:setEmissionArea("uniform", (self.texture:getWidth() / 2) * self._Transform.scale,
    --     (self.texture:getHeight() / 2) * self._Transform.scale)
    -- self.burnParticals:setEmissionRate(2)
    -----------------------------------------------------------
    table.insert(G.CARDS, self)

    self.r = 0
    return self
end

function Card:getRank()
    return self._Identity.rank
end

function Card:getSuit()
    return self._Identity.suit    
end

function Card:getCardFace()
    -- Get The Coresponding image data from
    self._Faces.cardFace = G.CARDGRAPHICS["CARDFACES"]["card" .. G.CARDSUITS[self._Identity.suit] .. tostring(self._Identity.rank)]
    if self._Identity.rank == 1 then self._Identity.rank = 14 end
end

-- This function need to be reworked to not use base scale and also work with delta time
-- This method handles the logic for hovering over the cards
function Card:onHover(dt)

end

function Card:playSound()
    TEsound.play(G.SOUNDS["card1"], "static", { "deal" })
end

function Card:floatingAnimation(dt)

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
        self:setPos(nil, self._Transform.y + 20)
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

-- Needs major work to dynamicly change with chanch of pos and remove base scale
function Card:flipAnimation()

end

function Card:op8(dt)
    if self._Identity.rank == 8 then
        if self:checkMouseHover() and self.inCardPile then
            if self._Opac > 0 then
                self._Opac = self._Opac - (.9 * dt)
                if self._Opac < 0 then self._Opac = 0 end
            end
        else
            if self._Opac < 1 then
                self._Opac = self._Opac + (.9 * dt)
                if self._Opac > 1 then self._Opac = 1 end
            end
        end
    end
end

function Card:update(dt)
    if self._Conf.stopOnPause and G.SETTINGS.PAUSED then
        return
    end
    if self.newSelectFlag then
        self.newSelectFlag = false
    end
    self:onSelect()
    self:onHover(dt)
    self:move(dt)
    self:floatingAnimation(dt)
    self:flipAnimation()
    -- if not self._CardStates.flipped.is and self.rank == 10 then
    --     self.burnParticals:update(dt)
    --     self.burnParticals:setSizes(self._Transform.scale)
    --     self.burnParticals:setEmissionArea("uniform", math.abs((self._Texture:getWidth() / 2) * self._Transform.scale),
    --         math.abs((self._Texture:getHeight() / 2) * self._Transform.scale))
    -- end
    self:op8(dt)
end

function Card:draw()
    self:setGlobalPos()
    self:drawBoundingRect()

    -- Handle Pause (Should be moved to the update function as the callback to the draw function should be added to the draw hash in the update function)
    if self.stopOnPause and G.SETTINGS.PAUSED then
        return
    end

    -- Draw Shadow
    love.graphics.setColor({ 0, 0, 0, self._Opac - .5 })
    love.graphics.draw(self._Texture, self._GlobalTransform.x + 7, self._GlobalTransform.y + 7, 0, self._GlobalTransform.sx, self._GlobalTransform.sy, (self._Transform.w / 2),
        (self._Transform.h / 2))
    love.graphics.setColor({ 1, 1, 1, 1 })

    -- Darken the card when in the notPlayable state
    if self.notPlayable then
        love.graphics.setShader(G.SHADERS["darkcard"])
    end

    -- Draw the card itself
    love.graphics.setColor({ 1, 1, 1, self.transparency })
    love.graphics.draw(self._Texture, self._GlobalTransform.x, self._GlobalTransform.y, 0, self._GlobalTransform.sx, self._GlobalTransform.sy, (self._Transform.w / 2),
        (self._Transform.h / 2))
    love.graphics.setColor({ 1, 1, 1, 1 })
    love.graphics.setShader()

    -- Draw the particals for the 10 card
    if self.fliped and self.rank == 10 then
        love.graphics.draw(self.burnParticals, self._GlobalTransform.x, self._GlobalTransform.y)
    end
end

Deck = setmetatable({}, { __index = Sprite })
Deck.__index = Deck

Deck.usedCards = {}

-- Deck Constructor class
function Deck.new(nx, ny)
    local self = setmetatable(Sprite.new(nx, ny), Deck)

    self.T = "Deck"

    self._Texture = love.graphics.newImage("resources/graphics/cards/cardBacks/cardBack1.png")
    self.cards = self:buildDeck(nx, ny)
    self.discard = {}
    self:initSprite()
    return self
end

function Deck:shuffle()
    local tmp = {}
    local posIndex = 0
    for x = 1, 52 do
        local tmpCard = self:getRandCard()
        tmpCard:setPosImidiate(self._GlobalTransform.x + posIndex, self._GlobalTransform.y - posIndex)
        table.insert(tmp, #tmp + 1, tmpCard)
        posIndex = posIndex + .5
    end
    self.cards = tmp
    self.usedCards = {}
end

-- This method generates all cards in the deck
function Deck:buildDeck(x, y)
    local tmp = {}
    local posIndex = 0
    for i = 1, 4 do
        for j = 1, 13 do
            local newCard = Card.new(j, i, self._GlobalTransform.x + posIndex, self._GlobalTransform.y - posIndex)
            newCard.mouseMoveable = false
            table.insert(tmp, newCard)
            posIndex = posIndex + .5
        end
    end
    return tmp
end

function Deck:addDiscard(newCard)
    newCard:setPos(-200, self._GlobalTransform.y)
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
        for x = 1, #self.usedCards do
            if cardNum == self.usedCards[x] then
                return true
            end
        end
    end
    return false
end

function Deck:draw()
    self:drawBoundingRect()
    if #self.usedCards < 52 then
        drawList(self.cards)
    end
end

function Deck:update(dt)
    updateList(self.discard, dt)
end

CardPile = setmetatable({}, { __index = Node })
CardPile.__index = CardPile

function CardPile.new(nx, ny)
    local self = setmetatable(Node.new(nx, ny), CardPile)

    self.T = "CardPile"

    self.cards = {}
    return self
end

function CardPile:addCard(newCard)
    newCard:setPos(self._GlobalTransform.x, self._GlobalTransform.y)
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
    self:drawBoundingRect()
    drawList(self.cards)
end

function CardPile:update(dt)
    updateList(self.cards, dt)
end
