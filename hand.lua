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
end

function Hand:addDockTop(newCard)
    table.insert(self.dockTop, newCard)
    self.dockTop[#self.dockTop].y = (self.y - self.dockTop[#self.dockTop].height - 50)
    self.dockTop[#self.dockTop].flipping = true
end

function Hand:addDockBottom(newCard)
    table.insert(self.dockBottom, newCard)
    self.dockBottom[#self.dockBottom].y = (self.y - self.dockBottom[#self.dockBottom].height - 50)
    self.dockBottom[#self.dockBottom].active = false
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

function Hand:updateDockPos()
    self:updatePos(self.dockTop)
    self:updatePos(self.dockBottom)
end

function Hand:draw()
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