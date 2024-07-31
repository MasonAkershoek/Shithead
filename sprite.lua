-- sprite.lua

Sprite = {}

Sprite.__index = Sprite

function Sprite.new()
    local self = setmetatable({}, Sprite)
    self.image = nil
    self.x = 0
    self.y = 0
    self.newX = 0
    self.newY = 0
    self.speed = 1200
    self.baseScale = 1
    self.xScale = self.baseScale
    self.yScale = self.baseScale
    self.xSkew = 0
    self.ySkew = 0
    self.width = nil
    self.height = nil
    return self
end

function Sprite:initSprite()
    self.width = (self.image:getWidth())
    self.height = (self.image:getHeight())
    self.image:setFilter("nearest", "nearest", 1)
end

function Sprite:move(dt)
    if self.newX ~= 0 then
        self.moving = true
        if math.abs((self.x - self.newX)) < 10 then
            self.x = self.newX
            self.newX = 0
            self.moving = false
        else
            if self.newX < self.x then 
                self.x = (self.x - (self.speed * dt))
            else
                self.x = (self.x + (self.speed * dt))
            end
        end
    end
    if self.newY ~= 0 then
        self.moving = true
        if math.abs((self.y - self.newY)) < 10 then
            self.y = self.newY
            self.newY = 0
            self.moving = false
        else
            if self.newY < self.y then 
                self.y = (self.y - (self.speed * dt))
            else
                self.y = (self.y + (self.speed * dt))
            end
        end
    end
end

function Sprite:checkMouseHover()
    local mousex, mousey = love.mouse.getPosition()
    if mousex > (self.x - ((self.width*self.baseScale)/2)) and mousex < (self.x + ((self.width*self.baseScale)/2)) then
        if mousey > (self.y - ((self.height*self.baseScale)/2)) and mousey < (self.y + ((self.height*self.baseScale)/2)) then
            return true
        end
        return false
    end
    return false
end

function Sprite:changeScale(newx, newy)
    newx = newx or nil
    newy = newy or nil
    if newx ~= nil then 
        self.xScale = newx
        self.baseScale = newx
    end
    if newy ~= nil then
        self.yScale = newy
        self.baseScale = newx
    end
    self:initSprite()
end

function Sprite:setNewPos(newx, newy)
    newx = newx or nil
    newy = newy or nil
    if newx ~= nil then 
        self.newX = newx
    end
    if newy ~= nil then
        self.newY = newy
    end
end

function Sprite:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.xScale, self.yScale, (self.width/2), (self.height/2), self.xSkew, self.ySkew)
end

---------------------------------------------------------------------------------------------

HboxContainer = {}

HboxContainer.__index = HboxContainer

function HboxContainer.new()
    local self = setmetatable({}, HboxContainer)
    self.area = nil
    self.baseScale = 1
    self.x = 0
    self.y = 0
    return self
end

function HboxContainer:setNewPos(newx, newy)
    newx = newx or nil
    newy = newy or nil
    if newx ~= nil then 
        self.x = newx
    end
    if newy ~= nil then
        self.y = newy
    end
end

function HboxContainer:updatePos(items, flag)
    flag = flag or false
    if #items > 0 then
        local xpoints = ((self.area + self.area) / (#items + 1))
        local nextPoint = (self.x - self.area)
        for x=1, #items do
            if flag then
                items[x]:setNewPos((xpoints + nextPoint), self.y)
            else
                items[x]:setNewPos((xpoints + nextPoint))
            end
            nextPoint = nextPoint + xpoints
        end
    end
end

---------------------------------------------------------------------------------------------

VboxContainer = {}

VboxContainer.__index = VboxContainer

function VboxContainer.new()
    local self = setmetatable({}, VboxContainer)
    self.area = nil
    self.x = 0
    self.y = 0
    return self
end

function VboxContainer:setNewPos(newx, newy)
    newx = newx or nil
    newy = newy or nil
    if newx ~= nil then 
        self.x = newx
    end
    if newy ~= nil then
        self.y = newy
    end
end

function VboxContainer:updatePos(items, padding)
    padding = padding or 0
    if #items > 0 then
        local nextPoint = (self.y - self.area)
        for x=1, #items do
            nextPoint = nextPoint + ((items[x].height/2) * items[x].baseScale)
            items[x]:setNewPos(self.x, nextPoint)
            nextPoint = ((nextPoint + ((items[x].height/2) * items[x].baseScale)) + padding)
        end
    end
end