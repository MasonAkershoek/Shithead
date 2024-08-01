require("gameData")
require("sprite")

-- This is  a class for holding and updating information about the opponents UI
Opponent = setmetatable({}, {__index = VboxContainer})
Opponent.__index = Opponent

-- Opponent Constructor
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
    self.area = ((self.nameGraphic.height + self.opponent_icon.height))
    return self
end

function Opponent:addCardToHand(newCard)
    table.insert(self.hand, newCard)
    self.hand[#self.hand]:setNewPos(self.x, (0-150))
    love.audio.play(self.hand[#self.hand].dealSound)
end

function Opponent:addCardToDockBottom(newCard)
    self.dock:addCardTop(newCard)
end

function Opponent:addCardToDockTop(newCard)
    self.dock:addCardBottom(newCard)
end

function Opponent:newPos(newx, newy)
    self.x = newx
    self.y = newy
end

-- Function to hold all the update information for objects in the class and to be called in the main love2d update function
function Opponent:update(dt)
    self:updatePos({self.nameGraphic, self.opponent_icon, self.dock}, 20)
    self.opponent_icon:update(dt)
    self.nameGraphic:update(dt)
    self.dock:update(dt)
    if #self.hand > 0 then
        for x=1, #self.hand do
            self.hand[x]:update(dt)
        end
    end
end

-- Function to call all the draw functions for objects in the class. To be called in the main love2d update function
function Opponent:draw()
    self.opponent_icon:draw()
    self.nameGraphic:draw()
    self.dock:draw()
    if #self.hand > 0 then
        for x=1, #self.hand do
            self.hand[x]:draw()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------

NameGraphic = setmetatable({}, {__index = Sprite})
NameGraphic.__index = NameGraphic

function NameGraphic.new(newName)
    local self = setmetatable(Sprite.new(), NameGraphic)
    self.image = love.graphics.newText(gameFont, {{0,0,0}, newName})
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
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
    self.height = 0
    self.dockBottom = {}
    self.area = (150)
    return self
end

function OpponentDock:addCardTop(newCard)
    table.insert(self.dockTop, newCard)
    self.dockTop[#self.dockTop]:changeScale(.5,.5)
    self.dockTop[#self.dockTop].active = false
    self.dockTop[#self.dockTop].flipping = true
    love.audio.play(self.dockTop[#self.dockTop].dealSound)
end

function OpponentDock:addCardBottom(newCard)
    table.insert(self.dockBottom, newCard)
    self.height = (newCard.height * .5)
    self.dockBottom[#self.dockBottom]:changeScale(.5,.5)
    self.dockBottom[#self.dockBottom].active = false
    love.audio.play(self.dockBottom[#self.dockBottom].dealSound)
end

function OpponentDock:getTopNum()
    return #self.dockTop
end

function OpponentDock:getBottomNum()
    return #self.dockBottom
end

function OpponentDock:draw()
    if #self.dockBottom > 0 then
        for x=1, #self.dockBottom do
            self.dockBottom[x]:draw()
        end
    end
    if #self.dockTop > 0 then
        for x=1, #self.dockTop do
            self.dockTop[x]:draw()
        end
    end
end

function OpponentDock:update(dt)
    self:updatePos(self.dockBottom, true)
    self:updatePos(self.dockTop, true)
    if #self.dockBottom > 0 then
        for x=1, #self.dockBottom do
            self.dockBottom[x]:update(dt)
        end
    end
    if #self.dockTop > 0 then
        for x=1, #self.dockTop do
            self.dockTop[x]:update(dt)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------

OpponentIcon = setmetatable({}, {__index = Sprite})

OpponentIcon.__index = OpponentIcon

function OpponentIcon.new(iconPath)
    local self = setmetatable(Sprite.new(), OpponentIcon)
    self.image = love.graphics.newImage(iconPath)
    self:changeScale(2,2)
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
function OpponentArea.new(newX, newY)
    local self = setmetatable(HboxContainer.new(), OpponentArea)
    self.opponents = {}
    self.area = (screenWidth * .50)
    self.x = newX
    self.y = newY
    return self
end

function OpponentArea:addOpponent(newOpponent)
    table.insert(self.opponents, newOpponent)
end

function OpponentArea:update(dt)
    self:updatePos(self.opponents, true)
    if #self.opponents > 0 then
        for x=1, #self.opponents do
            self.opponents[x]:update(dt)
        end
    end
end

function OpponentArea:draw(dt)
    if #self.opponents > 0 then
        for x=1, #self.opponents do 
            self.opponents[x]:draw()
        end
    end
end