require("sprite")

-- hand.lua

Hand = setmetatable({}, {__index = HboxContainer})
Hand.__index = Hand

function Hand.new(newX, newY)
    local self = setmetatable(HboxContainer.new(), Hand)
    self.cards = {}
    self.tmpHand = {}
    self.dockBottom = {}
    self.dockTop = {}
    self.area = (screenWidth * .25)
    self.x = newX
    self.y = newY
    return self
end

function Hand:getCardsList()
    cardList = {}
    for x=1, #self.cards do
        table.insert(cardList, {self.cards[x].rank, self.cards[x].suit})
    end
    return cardList
end

function Hand:addCardToHand(newCard)
    table.insert(self.cards, newCard)
    self.cards[#self.cards]:setNewPos(nil, self.y)
    self.cards[#self.cards].flipping = true
    love.audio.play(self.cards[#self.cards].dealSound)
end

function Hand:addDockTop(newCard)
    table.insert(self.dockTop, newCard)
    self.dockTop[#self.dockTop].newY = (self.y - self.dockTop[#self.dockTop].height - 40)
    self.dockTop[#self.dockTop].flipping = true
    love.audio.play(self.dockTop[#self.dockTop].dealSound)
end

function Hand:addDockBottom(newCard)
    table.insert(self.dockBottom, newCard)
    self.dockBottom[#self.dockBottom].newY = (self.y - self.dockBottom[#self.dockBottom].height - 50)
    self.dockBottom[#self.dockBottom].active = false
    love.audio.play(self.dockBottom[#self.dockBottom].dealSound)
end

function Hand:sortByRank()
    local tmp = nil
    local sorted = false
    for x = 1, #self.cards do
        sorted = false
        for y = 1, (#self.cards - x) do
            if self.cards[y].rank < self.cards[y + 1].rank then
                tmp = self.cards[y]
                self.cards[y] = self.cards[y+1]
                self.cards[y+1] = tmp
                sorted = true
            end
        end
        if (sorted == false) then
            break
        end
    end
end

function Hand:getCard()
    tmp = nil
    if #self.cards > 0 then
        for x=1, #self.cards do
            if self.cards[x].selected then
                tmp = self.cards[x]
                table.remove(self.cards, x)
                return tmp
            end
        end 
    elseif #self.dockTop > 0  then

    else
        
    end
        
end

function Hand:updateDockPos()
    self:updatePos(self.dockTop)
    self:updatePos(self.dockBottom)
end

function Hand:draw()
    love.graphics.draw(handContainer, self.x, (self.y  - 10), 0, (1), .55, (handContainer:getWidth()/2), (handContainer:getHeight()/2))
    if #self.cards > 0 then
        for x=1, #self.cards do
            self.cards[x]:draw()
        end
    end
    for x=1, #self.dockBottom do
        self.dockBottom[x]:draw()
    end
    for x=1, #self.dockTop do
        self.dockTop[x]:draw()
    end
end

function Hand:update(dt)
    self:sortByRank()
    self:updatePos(self.cards)
    if #self.dockBottom > 0 then
        for x = 1, #self.dockTop do
            self.dockTop[x]:update(dt)
        end
        for x = 1, #self.dockBottom do
            self.dockBottom[x]:update(dt)
        end
    end
    if #self.cards > 0 then
        for x=1, #self.cards do
            self.cards[x]:update(dt)
        end
    end
end