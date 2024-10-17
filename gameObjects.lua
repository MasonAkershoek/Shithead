-- gameObjects.lua

-- Node Object
----------------------------------------------
Node = {}
Node.__index = Node

function Node.new(nx,ny)
    nx = nx or 0
    ny = ny or 0

    local self = setmetatable({}, Node)

    -- Node Position and tansformations
    self.pos = Vector.new(nx,ny)
    self.size = Vector.new(1,1)
    self.baseScale = 1
    self.scale = Vector.new(self.baseScale,self.baseScale)
    self.skew = Vector.new(0,0)
    self.rotation = 0
    
    -- Object Flags
    self.hoverFlag = false

    return self
end

function Node:getWidth()
    return (self.size.x * self.scale.x)
end

function Node:getHeight()
    return self.size.y * self.scale.y
end

function Node:setScale(nxs,nys)
    nxs = nxs or nil
    nys = nys or nil
    if nxs ~= nil then 
        self.scale.x = nxs
        self.baseScale = nxs
    end
    if nys ~= nil then
        self.scale.y = nys
        self.baseScale = nys
    end
end

function Node:setSkew(nxs,nys)
    nxs = nxs or nil
    nys = nys or nil
    if nxs ~= nil then 
        self.skew.x = nxs
    end
    if nys ~= nil then
        self.skew.y = nys
    end
end

function Node:setPos(nx,ny)
    nx = nx or nil
    ny = ny or nil
    if nx ~= nil then 
        self.pos.x = nx
    end
    if ny ~= nil then
        self.pos.y = ny
    end
end

function Node:checkMouseHover()
    local mousex, mousey = love.mouse.getPosition()
    local mousex, mousey = push:toGame(mousex, mousey)
    if mousex > (self.pos.x - ((self.size.x * self.scale.x)/2)) and mousex < (self.pos.x + ((self.size.x * self.scale.x)/2)) then
        if mousey > (self.pos.y - ((self.size.y * self.scale.y)/2)) and mousey < (self.pos.y + ((self.size.y * self.scale.y)/2)) then
            return true
        end
        return false
    end
    return false
end


-- Moveable Object
----------------------------------------------
Moveable = setmetatable({}, {__index = Node})
Moveable.__index = Moveable

function Moveable.new(nx,ny,mouseMoveable)
    mouseMoveable = mouseMoveable or false
    local self = setmetatable(Node.new(nx,ny), Moveable)
    self.newPos = Vector.new(nx,ny)
    self.movement = Vector.new(0,0)
    self.distance = 0
    self.HCenter = {}
    self.HCenter.x = 0
    self.HCenter.y = 0
    self.mouseMoveable = mouseMoveable
    self.moveFlag = false
    self.moving = false
    self.mouseMove = false
    return self
end

function Moveable:mouseMoving()
    if self:checkMouseHover() and love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        local xOffset = 0
        local yOffset = 0
        mx,my = push:toGame(mx,my)
        self:setPosImidiate(mx,my)
        self.mouseMove = true
    else
        self.mouseMove = false
    end
end

function Moveable:setPos(nx,ny)
    if not self.mouseMove then
        nx = nx or nil
        ny = ny or nil
        if nx ~= nil then 
            self.newPos.x = nx
            self.moveFlag = true
            self.moving = true
        end
        if ny ~= nil then
            self.newPos.y = ny
            self.moveFlag = true
            self.moving = true
        end
    end
end

function Moveable:setPosImidiate(nx,ny)
    nx = nx or nil
    ny = ny or nil
    if nx ~= nil then 
        self.pos.x = nx
    end
    if ny ~= nil then
        self.pos.y = ny
    end
end

function Moveable:move(dt)
    if self.mouseMoveable then
        self:mouseMoving()
    end
    if self.moveFlag then
        local dirx = self.newPos.x - self.pos.x
        local diry = self.newPos.y - self.pos.y
        self.distance = math.sqrt((dirx^2) + (diry^2))
        local normx = dirx / self.distance
        local normy = diry / self.distance
        self.HCenter.x = ((self.pos.x + self.newPos.x)/2)
        self.HCenter.y = ((self.pos.y + self.newPos.y)/2)
        self.movement:setVect(normx, normy)
        self.moveFlag = false
    end
    if not self.pos:checkDistance(self.newPos, 5) and not self.mouseMove then 
        for x=1, G.CARDSPEED*dt do
            if not self.pos:checkDistance(self.newPos, 5) then 
                self.pos.x = (self.pos.x + (self.movement.x))
                self.pos.y = (self.pos.y + (self.movement.y))
            else
                break
            end
        end
    elseif not self.mouseMove then
        self.pos:setVect(self.newPos.x, self.newPos.y)
        self.moving = false
    end
end


-- Sprite Object
----------------------------------------------
Sprite = setmetatable({}, {__index = Moveable})
Sprite.__index = Sprite

function Sprite.new(nx,ny,mouseMoveable,newTexture)
    newTexture = newTexture or nil
    local self = setmetatable(Moveable.new(nx,ny,mouseMoveable), Sprite)
    if newTexture ~= nil then
        self.texture = love.graphics.newImage(newTexture)
    else
       self.texture = nil 
    end
    self.transparency = 1
    return self
end

function Sprite:initSprite()
    self.size.x = (self.texture:getWidth())
    self.size.y = (self.texture:getHeight())
    self.texture:setFilter("nearest", "nearest", 5)
end

function Sprite:update()
    
end

function Sprite:draw()
    love.graphics.setColor({1,1,1,self.transparency})
    love.graphics.draw(self.texture, self.pos.x, self.pos.y, self.rotation, self.scale.x, self.scale.y, self.size.x/2, self.size.y/2)
end

-- Vector2 Object
----------------------------------------------
Vector = {}
Vector.__index = Vector

function Vector.new(x,y)
    local self = setmetatable({}, Vector)
    x=x or 0
    x=x or 0
    self.x = x
    self.y = y
    return self
end

function Vector:setVect(x, y)
    self.x = x
    self.y = y
end

function Vector:checkDistance(otherVect, space)
    if self.x > (otherVect.x - space) and self.x < (otherVect.x + space) then
        if self.y > (otherVect.y - space) and self.y < (otherVect.y + space) then
            return true 
        end
    else
        return false
    end
end

-- HboxContainer
----------------------------------------------
HboxContainer = setmetatable({}, {__index = Moveable})

HboxContainer.__index = HboxContainer

function HboxContainer.new(nx,ny, bgBox)
    bgBox = bgBox or false
    local self = setmetatable(Moveable.new(nx,ny), HboxContainer)
    self.area = 0
    self.baseScale = 1
    self.boxFlag = bgBox
    self.borderBox = nil
    self.itemsMoving = false
    return self
end

function HboxContainer:getWidth()
    return self.size.x/2 + self.area
end

function HboxContainer:updatePos(items, flag, i)
    flag = flag or false
    tmpWidth = 0
    tmpHeight = 0
    if self.borderBox ~= nil then
        self.borderBox:setPos(self.pos.x, self.pos.y)
    end
    if #items > 0 then
        local xpoints = ((self.area + self.area) / (#items + 1))
        local nextPoint = (self.pos.x - self.area)
        for x=1, #items do
            if not i then 
                if flag then
                    items[x]:setPos((xpoints + nextPoint), self.pos.y)
                else
                    items[x]:setPos((xpoints + nextPoint))
                end
            else
                if flag then
                    items[x]:setPosImidiate((xpoints + nextPoint), self.pos.y)
                else
                    items[x]:setPosImidiate((xpoints + nextPoint))
                end
            end
            nextPoint = nextPoint + xpoints
            tmpWidth = tmpWidth + items[x]:getWidth()
            if items[x]:getHeight() > tmpHeight then
                tmpHeight = items[x]:getHeight()
            end
        end
        self.size.x = tmpWidth
        self.size.y = tmpHeight
    end
end

function HboxContainer:checkMoving(items)
    for _, card in ipairs(items) do
        if card.moving then 
            return false
        end
    end
    return true
end

function HboxContainer:update(dt)
    self:move(dt)
    if self.borderBox ~= nil then
        self.borderBox:update(dt)
    end
end

-- VboxContainer1
---------------------------------------------------------------------------------------------
VboxContainer = setmetatable({}, {__index = Moveable})

VboxContainer.__index = VboxContainer

function VboxContainer.new(nx,ny)
    local self = setmetatable(Moveable.new(nx,ny), VboxContainer)
    self.area = 0
    return self
end

function VboxContainer:updatePos(items, padding, i)
    padding = padding or 0
    if #items > 0 then
        local nextPoint = (self.pos.y - self.area)
        for x=1, #items do
            nextPoint = nextPoint + ((items[x].size.y/2) * items[x].baseScale)
            if not i then
                items[x]:setPos(self.pos.x, nextPoint)
            else
                items[x]:setPosImidiate(self.pos.x, nextPoint)
            end
            nextPoint = ((nextPoint + ((items[x].size.y/2) * items[x].baseScale)) + padding)
        end
    end
end

-- Event Manager

EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)
    self.listeners = {}
    self.queue = {}
    return self
end

function EventManager:on(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
end

function EventManager:emit(eventName, tim)
    tim = tim or nil
    print("Time: ", tim)
    if not tim then 
        print("Event Emited")
        local callbacks = self.listeners[eventName]
        print(#callbacks)
        if callbacks then
            for _, callback in ipairs(callbacks) do
                callback(callback)
            end
        end
    else
        print("Event Added to Queue")
        tmp = G.TIMERMANAGER:addTimer(tim)
        table.insert(self.queue, {eventName, tmp})
    end
end

function EventManager:update(dt)
    for _,event in ipairs(self.queue) do
        if G.TIMERMANAGER:checkExpire(event[2]) then
            print("Timer Expired")
            print(event[1])
            self:emit(event[1])
        end
    end
end

-- Timer
Timer = {}
Timer.__index = Timer

function Timer.new(newTime, ...)
    local self = setmetatable({}, Timer)
    print("New Timer: ", newTime)
    self.time = newTime
    self.ogTime = newTime
    self.stopped = false
    self.expired = false
    if ... ~= nil then 
        self.callback = ...
    end
    return self
end

function Timer:reset(newTime)
    newTime = newTime or self.ogTime
    self.time = newTime
    self.expired = false
    self.stopped = false
end

function Timer:stopTimer()
    self.stopped = true
    self.time = 0
    self.expired = false
end

function Timer:isExpired()
    return self.expired
end

function Timer:isStopped()
    if self.stopped then 
        return true 
    else 
        return false 
    end
end

function Timer:start()
    self:reset()
    self.stopped = false
end

function Timer:update(dt)
    if not self.stopped then
        if self.time < 0 and not self.expired then 
            self.expired = true
            if self.callback ~= nil then
                callback(self.callback)
            end
            return self.expired
        else
            self.time = self.time - dt 
        end
    end
end

-- Timer Manager
TimerManager = {}
TimerManager.__index = TimerManager

function TimerManager.new()
    local self = setmetatable({}, TimerManager)
    self.timers = {}
    return self
end

function TimerManager:addTimer(time)
    print("Time: ", time)
    table.insert(self.timers, Timer.new(time))
    return #self.timers
end

function TimerManager:checkExpire(index)
    if self.timers[index]:isExpired() then
        table.remove(self.timers[index])
        return true
    end
    return false
end

function TimerManager:update(dt)
    for x=1, #self.timers do
        self.timers[x]:update(dt)
    end
end