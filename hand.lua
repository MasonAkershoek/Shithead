Hand = {}
--.1667
Hand.__index = Hand

function Hand.new(newX, newY, screenWidth, deck)
    local self = setmetatable({}, Hand)
    self.cards = {}
    self.tmpHand = {}
    --self.discards = {}
    self.dockBottom = {}
    self.dockTop = {}
    self.x = newX
    self.y = newY
    self.cardArea = (screenWidth * .25)
    self.oldmousedown = ""
    self.deck = deck
    return self
end

function Hand:updatePos(dt)
    if #self.cards > 0 then
        self:sortByRank()
        local xpoints = ((self.cardArea + self.cardArea) / (#self.cards + 1))
        width, height = love.graphics.getDimensions()
        local nextPoint = (( width / 2) - self.cardArea)
        for x=1, #self.cards do
            self.cards[x]:setNewPos((xpoints + nextPoint))
            nextPoint = nextPoint + xpoints
            if not self.cards[x].fliped then
                self.cards[x].flipping = true
            end
            --self.cards[x]:update(dt)
        end
    end
end

function Hand:setDockPos()
    local xpoints = ((self.cardArea + self.cardArea) / (#self.dockTop + 1))
    width, height = love.graphics.getDimensions()
    local nextPoint = (( screenWidth / 2) - self.cardArea)
    for x=1, #self.dockTop do
        self.dockTop[x]:setNewPos(xpoints + nextPoint, (self.dockTop[x].y - 230))
        self.dockBottom[x]:setNewPos(xpoints + nextPoint, (self.dockBottom[x].y - 230))
        nextPoint = nextPoint + xpoints
        if not self.dockTop[x].fliped then
            self.dockTop[x].flipping = true
        end
    end
end

function Hand:getCardsList()
    cardList = {}
    for x=1, #self.cards do
        table.insert(cardList, {self.cards[x].rank, self.cards[x].suit})
    end
    return cardList
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

--[[

function Hand:sortCards()
    if love.keyboard.isDown("s") then
        for x = 1, 4 do 
            for y = 1, #self.cards do
                if self.cards[y].suit == x then
                    table.insert(self.tmpHand, self.cards[y]) 
                end
            end
        end
        for k=1, #self.cards do
            self.cards[k] = nil
        end
        for k=1, #self.tmpHand do
            table.insert(self.cards, self.tmpHand[k])
            self.tmpHand[k] = nil 
        end
    end
    if love.keyboard.isDown("r") then
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
end

function Hand:discard()
    removed = 0
    if love.keyboard.isDown("d") then
        for x=1, #self.cards do
            if self.cards[(x - removed)].selected then
                table.insert(self.discards, self.cards[x - removed])
                table.remove(self.cards, (x - removed))
                removed = removed + 1
            end
        end
        for x=1, #self.discards do
            self.discards[x].newx = 3000
            self.discards[x].newy = 600 
        end
    end
end

]]

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
    self:updatePos(dt)
    if #self.dockBottom > 0 then
        for x = 1, #self.dockTop do
            self.dockTop[x]:update(dt)
        end
        for x = 1, #self.dockBottom do
            print(self.dockBottom[x].rank)
            self.dockBottom[x]:update(dt)
        end
    end
    if #self.cards > 0 then
        for x=1, #self.cards do
            self.cards[x]:update(dt)
        end
    end
end