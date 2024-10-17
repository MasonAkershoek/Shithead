-- opponent.lua

-- This is  a class for holding and updating information about the opponents UI
Opponent = setmetatable({}, {__index = VboxContainer})
Opponent.__index = Opponent

-- Opponent Constructorfunc
function Opponent.new(newName, playerImagePath)
    local self = setmetatable(VboxContainer.new(), Opponent)

    -- Opponent Name
    self.name = newName
    self.nameGraphic = NameGraphic.new(newName)

    -- Opponent Hand
    self.hand = {}
    self.dock = OpponentDock.new()

    -- Opponent Face Icon
    self.opponent_icon = OpponentIcon.new(playerImagePath)
    self.area = ((self.nameGraphic.size.y + self.opponent_icon.size.y))
    return self
end

function Opponent:addCardToHand(newCard)
    newCard:setPos(self.pos.x, (0-150))
    if newCard.fliped then newCard.flipping = true end
    newCard:playSound()
    table.insert(self.hand, newCard)
end

function Opponent:addCardToDockBottom(newCard)
    newCard:playSound()
    self.dock:addCardTop(newCard)
end

function Opponent:addCardToDockTop(newCard)
    newCard:playSound()
    self.dock:addCardBottom(newCard)
end

function Opponent:sortByRank()
    local tmp = nil
    local sorted = false
    for x = 1, #self.hand do
        sorted = false
        for y = 1, (#self.hand - x) do
            if self.hand[y].rank > self.hand[y + 1].rank then
                tmp = self.hand[y]
                self.hand[y] = self.hand[y+1]
                self.hand[y+1] = tmp
                sorted = true
            end
        end
        if (sorted == false) then
            break
        end
    end
end

function Opponent:checkCards(cards, topCard)
    selectedCard = nil
    if topCard == 5 then 
        for x=1, #cards do
            if cards[x].rank < topCard then
                selectedCard = x
                break
            end
        end
    else
        for x=1, #cards do
            if cards[x].rank > topCard then
                selectedCard = x
                break
            end
        end
    end
    if selectedCard == nil then 
        return 0
    else
        return selectedCard
    end
end

function Opponent:turn(topCard)
    selectedCard = 0
    which = 0
    if #self.hand > 0 then
        selectedCard = self:checkCards(self.hand, topCard)
    elseif #self.dock.dockTop > 0 then
        selectedCard = self:checkCards(self.dock.dockTop, topCard)
        which = 1
    elseif self.dock:getBottomNum() > 0 then
        randCard = math.random(self.dock:getBottomNum())
        if self.dock.dockBottom[randCard].rank > topCard then
            selectedCard = randCard
            which = 2
        else
           self:addCardToHand(self.dock.dockBottom[randCard])
           table.remove(self.dock.dockBottom, randCard) 
        end
    else
        return true
    end 
    if selectedCard == 0 then
        return false
    end
    if which == 0 then
        tmp = self.hand[selectedCard]
        table.remove(self.hand, selectedCard) 
    elseif which == 1 then
        tmp = self.dock.dockTop[selectedCard]
        table.remove(self.dock.dockTop, selectedCard)
    else
        tmp = self.dock.dockBottom[selectedCard]
        table.remove(self.dock.dockBottom, selectedCard) 
    end
    return tmp
end

-- Function to hold all the update information for objects in the class and to be called in the main love2d update function
    function Opponent:update(dt)
        self:sortByRank()
        self:updatePos({self.nameGraphic, self.opponent_icon, self.dock}, 20, true)
        self.opponent_icon:update(dt)
        self.nameGraphic:update(dt)
        self.dock:update(dt)
        updateList(self.hand, dt)
        self:move(dt)
    end

-- Function to call all the draw functions for objects in the class. To be called in the main love2d update function
function Opponent:draw()
    love.graphics.setColor({0,0,0,.3})
    love.graphics.rectangle("fill", (self.pos.x - 125), (self.pos.y - (80)), 250, self.area*2 + 150, 20,20)
    love.graphics.rectangle("fill", (self.area + (self.area/2)), (self.pos.y - 340), self.area, 200, 20,20)
    love.graphics.setColor({1,1,1,1})
    self.opponent_icon:draw()
    self.nameGraphic:draw()
    self.dock:draw()
    drawList(self.hand)
end

-------------------------------------------------------------------------------------------------------------------------------

NameGraphic = setmetatable({}, {__index = Sprite})
NameGraphic.__index = NameGraphic

function NameGraphic.new(newName)
    local self = setmetatable(Sprite.new(), NameGraphic)
    self.texture = love.graphics.newText(G.GAMEFONT, {{0,0,0}, newName})
    self.size.y = self.texture:getHeight()
    self.size.x = self.texture:getWidth()
    return self
end

function NameGraphic:update(dt)
    self:move(dt)
end

-------------------------------------------------------------------------------------------------------------------------------

OpponentDock = setmetatable({}, {__index = HboxContainer})
OpponentDock.__index = OpponentDock

function OpponentDock.new()
    local self = setmetatable(HboxContainer.new(), OpponentDock)
    self.dockTop = {} 
    self.dockBottom = {}
    self.area = (150)
    self.dockSet = true
    return self
end

function OpponentDock:addCardTop(newCard)
    newCard:setScale(.5,.5)
    newCard.active = false
    newCard.flipping = true
    newCard:playSound()
    table.insert(self.dockTop, newCard)
end

function OpponentDock:addCardBottom(newCard)
    newCard:setScale(.5,.5)
    newCard.active = false
    newCard:playSound()
    table.insert(self.dockBottom, newCard)
    self.size.y = (newCard.size.y * .5)
end

function OpponentDock:getTopNum()
    return #self.dockTop
end

function OpponentDock:getBottomNum()
    return #self.dockBottom
end

function OpponentDock:draw()
    drawList(self.dockBottom)
    drawList(self.dockTop)
end

function OpponentDock:update(dt)
    if self.dockSet then
        self:updatePos(self.dockBottom, true)
        self:updatePos(self.dockTop, true)
        if #self.dockTop == 3 then
            self.dockSet = false
        end
    end
    updateList(self.dockBottom, dt)
    updateList(self.dockTop, dt)
    self:move(dt)
end

-------------------------------------------------------------------------------------------------------------------------------

OpponentIcon = setmetatable({}, {__index = Sprite})

OpponentIcon.__index = OpponentIcon

function OpponentIcon.new(iconPath)
    local self = setmetatable(Sprite.new(), OpponentIcon)
    self.texture = love.graphics.newImage(iconPath)
    self:setScale(2,2)
    self:initSprite()
    return self
end

function OpponentIcon:update(dt)
    self:move(dt)
end

-------------------------------------------------------------------------------------------------------------------------------

-- This is the class for containing the opponents UI and determening where they should be placed
OpponentArea = setmetatable({}, {__index = HboxContainer})
OpponentArea.__index = OpponentArea

-- OpponentArea Constructor
function OpponentArea.new(nx, ny)
    local self = setmetatable(HboxContainer.new(nx,ny), OpponentArea)
    self.opponents = {}
    self.area = (G.SCREENVARIABLES["GAMEDEMENTIONS"].x * .50)
    return self
end

function OpponentArea:addOpponent(newOpponent)
    table.insert(self.opponents, newOpponent)
end

function OpponentArea:deal(newCard, opponentIndex)
    if self.opponents[opponentIndex].dock:getBottomNum() < 3 then
        self.opponents[opponentIndex].dock:addCardBottom(newCard)
    elseif self.opponents[opponentIndex].dock:getTopNum() < 3 then
        self.opponents[opponentIndex].dock:addCardTop(newCard)
    else
        self.opponents[opponentIndex]:addCardToHand(newCard)
    end
end

function OpponentArea:update(dt)
    self:updatePos(self.opponents, true)
    updateList(self.opponents, dt)
end

function OpponentArea:draw(dt)
    drawList(self.opponents)
end