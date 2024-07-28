require("gameData")

-- This is  a class for holding and updating information about the opponents UI
Opponent = {}
Opponent.__index = Opponent

-- Opponent Constructor
function Opponent.new(newName, playerImagePath)
    local self = setmetatable({}, Opponent)

    -- Opponent Name
    self.name = newName
    self.nameGraphic = nameGraphic.new(newName)

    -- Opponent Hand
    self.hand = {}
    self.dock = OpponentDock.new()

    -- Opponent Face Icon
    self.opponent_icon = OpponentIcon.new(playerImagePath)

    -- The possision for the opponent UI
    self.x = 0
    self.y = 0
    return self
end

function Opponent:addCardToHand(newCard)
    table.insert(self.hand, newCard)
end

function Opponent:addCardToDockBottom(newCard)
    self.dock:addCardTop(newCard)
end

function Opponent:addCardToDockTop(newCard)
    self.dock:addCardBottom(newCard)
end

function Opponent:updatePos(newX, newY)
    self.x = newX
    self.y = newY
end

-- Function to hold all the update information for objects in the class and to be called in the main love2d update function
function Opponent:update()
    self.opponent_icon:updatePos(self.x, self.y)
    self.nameGraphic:updatePos(self.x, (self.y - ((self.opponent_icon.height/2) + 30)))
    self.dock:updatePos(self.x, (self.y + ((self.opponent_icon.height/2) + 30)))
end

-- Function to call all the draw functions for objects in the class. To be called in the main love2d update function
function Opponent:draw()
    self:updatePos()
    self.opponent_icon:draw()
    self.nameGraphic:draw()
    self.dock:draw()
end

-------------------------------------------------------------------------------------------------------------------------------

nameGraphic = {}
nameGraphic.__index = nameGraphic

function nameGraphic.new(newName)
    local self = setmetatable({}, nameGraphic)
    self.image = love.graphics.newText(gameFont, {{0,0,0}, newName})
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = 0
    self.y = 0
    return self
end

function nameGraphic:updatePos(newX, newY)
    self.x = newX
    self.y = newY
end

function nameGraphic:update()
    
end

function nameGraphic:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, (self.width/2), (self.height/2))
end

-------------------------------------------------------------------------------------------------------------------------------

OpponentDock = {}
OpponentDock.__index = OpponentDock

function OpponentDock.new()
    local self = setmetatable({}, OpponentDock)
    self.dockTop = {}
    self.dockBottom = {}
    return self
end

function OpponentDock:addCardTop(newCard)
    table.insert(self.dockTop, newCard)
end

function OpponentDock:addCardBottom(newCard)
    table.insert(self.dockBottom, newCard)
end

function OpponentDock:updateDockPos()
    for x=1, #self.dockTop do
        
    end
    for x=1, #self.dockBottom do
    
    end
end

function OpponentDock:setDockPos()
    local xpoints = ((self.cardArea + self.cardArea) / (#self.dockTop + 1))
    local nextPoint = (( screenWidth / 2) - self.cardArea)
    for x=1, #self.dockTop do
        self.dockTop[x].newx = (xpoints + nextPoint)
        self.dockTop[x].newy = (self.dockTop[x].y - 230)
        nextPoint = nextPoint + xpoints
        if not self.dockTop[x].fliped then
            self.dockTop[x].flipping = true
        end
    end
end

function OpponentDock:getCardTop()
    
end

function OpponentDock:updatePos()

end

function OpponentDock:getCardBottom()
    
end

function OpponentDock:draw()
    if #self.dockTop > 0 then
        for x=1, #self.dockTop do
            self.dockTop[x]:draw()
        end
    end
    if #self.dockBottom > 0 then
        for x=1, #self.dockBottom do
            self.dockBottom[x]:draw()
        end
    end
end

function OpponentDock:update()
    if #self.dockTop > 0 then
        for x=1, #self.dockTop do
            self.dockTop[x]:update()
        end
    end
    if #self.dockBottom > 0 then
        for x=1, #self.dockBottom do
            self.dockBottom[x]:update()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------

OpponentIcon = {}

OpponentIcon.__index = OpponentIcon

function OpponentIcon.new(iconPath, newX, newY)
    local self = setmetatable({}, OpponentIcon)
    self.image = love.graphics.newImage(iconPath)
    self.image:setFilter("nearest","nearest")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.scale = 2
    return self
end

function OpponentIcon:updatePos(newX, newY)
    self.x = newX
    self.y = newY
end

function OpponentIcon:update()
    
end

function OpponentIcon:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.width/2, self.height/2)
end

-------------------------------------------------------------------------------------------------------------------------------

-- This is the class for containing the opponents UI and determening where they should be placed
OpponentArea = {}

OpponentArea.__index = OpponentArea

-- OpponentArea Constructor
function OpponentArea.new(newX, newY)
    local self = setmetatable({}, OpponentArea)
    self.opponents = {}
    self.opponentArea = (screenWidth * .50)
    self.x = newX
    self.y = newY
    return self
end

function OpponentArea:addOpponent(newOpponent)
    table.insert(self.opponents, newOpponent)
end

function OpponentArea:updatePos(dt)
    if #self.opponents > 0 then
        local xpoints = ((self.opponentArea + self.opponentArea) / (#self.opponents + 1))
        local nextPoint = (( screenWidth / 2) - self.opponentArea)
        for x=1, #self.opponents do
            self.opponents[x]:updatePos((xpoints + nextPoint), self.y)
            nextPoint = nextPoint + xpoints
        end
    end
end

function OpponentArea:update(dt)
    self:updatePos(dt)
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