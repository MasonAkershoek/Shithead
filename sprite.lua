-- sprite.lua

require("gameData")

Sprite = {}

Sprite.__index = Sprite

function Sprite.new()
    local self = setmetatable({}, Sprite)
    self.image = nil
    self.pos = Vector.new(0,0)
    self.newPos = Vector.new(0,0)
    self.movement = Vector.new(0,0)
    self.speed = 10000
    self.baseScale = 1
    self.xScale = self.baseScale
    self.yScale = self.baseScale
    self.xSkew = 0
    self.ySkew = 0
    self.width = nil
    self.height = nil
    self.moveFlag = false
    return self
end

function Sprite:initSprite()
    self.width = (self.image:getWidth())
    self.height = (self.image:getHeight())
    self.image:setFilter("nearest", "nearest", 1)
end

function Sprite:move(dt)
    if self.moveFlag then
        dirx = self.newPos.x - self.pos.x
        diry = self.newPos.y - self.pos.y
        c = math.sqrt((dirx^2) + (diry^2))
        normx = dirx / c
        normy = diry / c
        self.movement:changePos(normx, normy)
        self.moveFlag = false
    end
    if not self.pos:checkDistance(self.newPos, 5) then 
        for x=1, self.speed do
            if not self.pos:checkDistance(self.newPos, 5) then 
                self.pos.x = (self.pos.x + (self.movement.x * dt))
                self.pos.y = (self.pos.y + (self.movement.y * dt))
            else
                break
            end
        end
    else
        self.pos:changePos(self.newPos.x, self.newPos.y)
    end
end

function Sprite:checkMouseHover()
    local mousex, mousey = love.mouse.getPosition()
    if mousex > (self.pos.x - ((self.width*self.baseScale)/2)) and mousex < (self.pos.x + ((self.width*self.baseScale)/2)) then
        if mousey > (self.pos.y - ((self.height*self.baseScale)/2)) and mousey < (self.pos.y + ((self.height*self.baseScale)/2)) then
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
    self.moveFlag = true
    if newx ~= nil then 
        self.newPos.x = newx
    end
    if newy ~= nil then
        self.newPos.y = newy
    end
end

function Sprite:draw()
    love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, self.xScale, self.yScale, (self.width/2), (self.height/2), self.xSkew, self.ySkew)
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