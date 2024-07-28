
Sprite = {}

Sprite.__index = Sprite

function Sprite.new()
    local self = setmetatable({}, Sprite)
    self.image = nil
    self.x = 0
    self.y = 0
    self.newX = 0
    self.newY = 0
    self.baseScale = 1
    self.xScale = self.baseScale
    self.yScale = self.baseScale
    self.width = nil
    self.height = nil
    return self
end

function Sprite:initSprite()
    self.width = (self.image:getWidth() * self.baseScale)
    self.height = (self.image:getHeight() * self.baseScale)
    self.image:setFilter("nearest", "nearest")
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
    love.graphics.draw(self.image, self.x, self.y, 0, self.xScale, self.yScale, self.width/2, self.height/2)
end

---------------------------------------------------------------------------------------------

HboxContainer = {}

HboxContainer.__index = HboxContainer

function HboxContainer.new()
    local self = setmetatable({}, HboxContainer)
    self.area = nil
    self.x = nil
    self.y = nil
end

function HboxContainer:updatePos(items)
    
end

function HboxContainer:update()

end

function HboxContainer:draw()

end