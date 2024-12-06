-- hand.lua

-- Hand Object
--------------------------------------------------
Hand = setmetatable({}, {__index = HboxContainer})
Hand.__index = Hand

function Hand.new(nx, ny)
    local self = setmetatable(HboxContainer.new(nx,ny), Hand)
    self.cards = {}
    self.handEmpty = true
    self.tmpHand = {}
    self.dockBottomEmpty = true
    self.dockBottom = {}
    self.dockTopEmpty = true
    self.dockTop = {}
    self.area = (G.SCREENVARIABLES["GAMEDEMENTIONS"].x * .25)
    self.dockArea = self.area - 170
    self.dockSetFlag = true
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
    if not newCard.fliped then
        newCard.flipping = true
    end
    newCard:setPos(nil, self.pos.y)
    newCard:playSound()
    table.insert(self.cards, newCard)
end

function Hand:setDeadZones()
    if #self.cards > 1 then
        for x=#self.cards, 2, -1 do
            local deadZone={}
            deadZone.t1 = self.cards[x]:getPos("centerleft")
            deadZone.t2 = self.cards[x-1]:getPos("centerright")
            if deadZone.t1.x > deadZone.t2.x then
                self.cards[x-1]:setDeadZone(nil)
            end
            self.cards[x-1]:setDeadZone(deadZone)
        end
    end
end

function Hand:check(hand, topCard)
    availableCards = 0
    for x=1, #hand do
        if topCard == 5 then
            if hand[x].rank <= topCard or ifIn(hand[x].rank, {2,5,8,10}) then
                hand[x].active = true
                hand[x].notPlayable = false
                availableCards = availableCards + 1 
            else
                hand[x].active = false
                hand[x].notPlayable = true
                if hand[x].selected then hand[x]:deSelect() end
            end
        else
            if hand[x].rank <= topCard and not ifIn(hand[x].rank, {2,5,8,10}) then
                hand[x].active = false
                hand[x].notPlayable = true
                if hand[x].selected then hand[x]:deSelect() end
            else
                availableCards = availableCards + 1 
                hand[x].active = true
                hand[x].notPlayable = false

            end
        end
    end
    return availableCards
end

function Hand:checkHand(topCard)
    availableCards = 0
    if #self.cards > 0 then
        availableCards = self:check(self.cards, topCard)
    elseif #self.dockTop > 0 then
        availableCards = self:check(self.dockTop, topCard)
    else
        if #self.dockBottom > 0 then
            return true 
        end
    end
    if availableCards > 0 then
        return true
    else
       return false 
    end
end

function Hand:checkSelect()
    local tmp = 0
    if #self.cards > 0 then 
        for x=1, #self.cards do
            if self.cards[x].newSelectFlag then
                tmp = x
                break
            end
        end
        if tmp ~= 0 then
            for x=1, #self.cards do
                if x ~= tmp then
                    if self.cards[x].selected then
                        self.cards[x]:deSelect()
                    end
                end
            end
        end
    elseif #self.dockTop > 0 then
        for x=1, #self.dockTop do
            if self.dockTop[x].newSelectFlag then
                tmp = x
                break
            end
        end
        if tmp ~= 0 then
            for x=1, #self.dockTop do
                if x ~= tmp then
                    if self.dockTop[x].selected then
                        self.dockTop[x]:deSelect()
                    end
                end
            end
        end
    else
        for x=1, #self.dockBottom do
            if self.dockBottom[x].newSelectFlag then
                tmp = x
                break
            end
        end
        if tmp ~= 0 then
            for x=1, #self.dockBottom do
                if x ~= tmp then
                    if self.dockBottom[x].selected then
                        self.dockBottom[x]:deSelect()
                    end
                end
            end
        end
    end
end

function Hand:addDockTop(newCard)
    newCard:playSound()
    table.insert(self.dockTop, newCard)
    self.dockTop[#self.dockTop]:setPos(nil, (self.pos.y - self.dockTop[#self.dockTop].size.y - 40))
    self.dockTop[#self.dockTop].flipping = true
end

function Hand:addDockBottom(newCard)
    newCard:playSound()
    table.insert(self.dockBottom, newCard)
    self.dockBottom[#self.dockBottom]:setPos(nil, (self.pos.y - self.dockBottom[#self.dockBottom].size.y - 40))
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

function Hand:empty()
    local tmp
    if not self.handEmpty then
        return table.remove(self.cards)
    elseif not self.dockTopEmpty then
        return table.remove(self.dockTop)
    elseif not self.dockBottomEmpty then
        return table.remove(self.dockBottom)
    end 
end

function Hand:getCard()
    local tmp = nil
    if #self.cards > 0 then
        for x=1, #self.cards do
            if self.cards[x].selected then
                tmp = self.cards[x]
                tmp.selected = false
                table.remove(self.cards, x)
                return tmp
            end
        end 
    elseif #self.dockTop > 0  then
        for x=1, #self.dockTop do
            if self.dockTop[x].selected then
                tmp = self.dockTop[x]
                tmp.selected = false
                table.remove(self.dockTop, x)
                return tmp
            end
        end 
    else
        for x=1, #self.dockBottom do
            if self.dockBottom[x].selected then
                tmp = self.dockBottom[x]
                tmp.selected = false
                table.remove(self.dockBottom, x)
                return tmp
            end
        end 
    end
        
end

function Hand:updateDockPos()
    self.area = self.dockArea
    self:updatePos(self.dockTop)
    self:updatePos(self.dockBottom)
    self.area = self.area + 170
end

function Hand:setDockActivity()
    if #self.cards > 0 then 
        for x=1, #self.dockTop do
            self.dockTop[x].active = false
            self.dockBottom[x].active = false
            if self.dockBottom[x].selected then self.dockBottom[x]:deSelect() end
            if self.dockTop[x].selected then self.dockTop[x]:deSelect() end
        end
    else
        if #self.dockTop > 0 then
            for x=1, #self.dockTop do
                self.dockTop[x].active = true
            end
        else
            for x=1, #self.dockBottom do
                self.dockBottom[x].active = true
            end 
        end
    end
end

function Hand:draw()
    love.graphics.setColor({0,0,0,.3})
    love.graphics.rectangle("fill", self.area, (self.pos.y - 100), self.area*2, 200, 20,20)
    love.graphics.rectangle("fill", (self.area + (self.area/2)), (self.pos.y - 340), self.area, 200, 20,20)
    love.graphics.setColor({1,1,1,1})

    drawList(self.cards)
    drawList(self.dockBottom)
    drawList(self.dockTop)
end

function Hand:update(dt)
    if #self.cards > 0 then self.handEmpty = false else self.handEmpty = true end
    if #self.dockBottom > 0 then self.dockBottomEmpty = false else self.dockBottomEmpty = true end
    if #self.dockTop > 0 then self.dockTopEmpty = false else self.dockTopEmpty = true end
    self:checkSelect()
    self:sortByRank()
    self:updatePos(self.cards)
    self:setDeadZones()
    updateList(self.cards, dt)
    updateList(self.dockBottom, dt)
    updateList(self.dockTop, dt)
end