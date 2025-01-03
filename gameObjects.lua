-- gameObjects.lua

-- Node Object
----------------------------------------------
Node = {}
Node.__index = Node

function Node.new(nx, ny, args)
    local nx = nx or 0
    local ny = ny or 0
    local args = args or {}

    local self = setmetatable({}, Node)

    self.T = "Node"

    -- Node Position and tansformations
    self.pos = Vector.new(nx, ny)
    self.size = Vector.new(1, 1)
    self.deadZone = nil
    self.baseScale = 1
    self.scale = Vector.new(self.baseScale, self.baseScale)
    self.skew = Vector.new(0, 0)
    self.rotation = 0

    -- Parent/Children pointers
    self.parent = args.parent or nil
    self.children = {}

    -- Added functions
    self.functions = args.functions or {}

    -- Object Flags
    self.hoverFlag = false

    return self
end

-- Width and height getters
function Node:getWidth()
    return (self.size.x * self.scale.x)
end

function Node:getHeight()
    return (self.size.y * self.scale.y)
end

function Node:getSize()
    return Vector.new(self.size.x, self.size.y)
end

-- Parent Child relationship functions
function Node:addChildren(newChild, tag)
    newChild:setParent(self)
    if tag then
        self.children[tag] = newChild
    else
        table.insert(self.children, newChild)
    end
end

function Node:removeChild(tag)
    table.remove(self.children[tag])
end

function Node:updateChildren(dt)
    for _,child in ipairs(self.children) do
        child:update(dt)
    end
end

function Node:setParent(newParent)
    self.parent = newParent
    self.stopOnPause = self.parent.stopOnPause
end

function Node:removeParent()
    self:setParent(nil)
end

function Node:addFunction(newFunction)
    table.insert(self.functions, newFunction)
end

function Node:updateFunctions()
    for _, func in ipairs(self.functions) do
        func(self)
    end
end

function Node:getPos(pos)
    local pos = pos or "center"
    local ret = Vector.new()
    if pos == "center" then
        return self.pos
    elseif pos == "topleft" then
        ret.x = (self.pos.x - ((self.size.x * self.scale.x) / 2))
        ret.y = (self.pos.y - ((self.size.y * self.scale.y) / 2))
    elseif pos == "topright" then
        ret.x = (self.pos.x + ((self.size.x * self.scale.x) / 2))
        ret.y = (self.pos.y - ((self.size.y * self.scale.y) / 2))
    elseif pos == "bottomleft" then
        ret.x = (self.pos.x - ((self.size.x * self.scale.x) / 2))
        ret.y = (self.pos.y + ((self.size.y * self.scale.y) / 2))
    elseif pos == "bottomright" then
        ret.x = (self.pos.x + ((self.size.x * self.scale.x) / 2))
        ret.y = (self.pos.y + ((self.size.y * self.scale.y) / 2))
    elseif pos == "centerleft" then
        ret.x = (self.pos.x - ((self.size.x * self.scale.x) / 2))
        ret.y = self.pos.y
    elseif pos == "centerright" then
        ret.x = (self.pos.x + ((self.size.x * self.scale.x) / 2))
        ret.y = self.pos.y
    elseif pos == "centertop" then
        ret.x = self.pos.x
        ret.y = (self.pos.y - ((self.size.y * self.scale.y) / 2))
    elseif pos == "centerbottom" then
        ret.x = self.pos.x
        ret.y = (self.pos.y + ((self.size.y * self.scale.y) / 2))
    end
    return ret
end

function Node:setDeadZone(deadZone)
    self.deadZone = deadZone
end

function Node:setScale(nxs, nys)
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

function Node:setSkew(nxs, nys)
    nxs = nxs or nil
    nys = nys or nil
    if nxs ~= nil then
        self.skew.x = nxs
    end
    if nys ~= nil then
        self.skew.y = nys
    end
end

function Node:setPos(nx, ny)
    nx = nx or nil
    ny = ny or nil
    if nx ~= nil then
        self.pos.x = nx
    end
    if ny ~= nil then
        self.pos.y = ny
    end
end

function Node:checkDeadZoneMouseHover(mx, my)
    -- Check the dead Zone
    if self.deadZone ~= nil then
        if mx > self.deadZone.t1.x and mx < self.deadZone.t2.x then
            return true
        end
    else
        return false
    end
    return false
end

function Node:checkMouseHover()
    local mousex, mousey = love.mouse.getPosition()
    local mousex, mousey = toGame(mousex, mousey)
    if mousex > (self.pos.x - self:getWidth() / 2) and mousex < (self.pos.x + self:getWidth() / 2) then
        if mousey > (self.pos.y - self:getHeight() / 2) and mousey < (self.pos.y + self:getHeight() / 2) then
            if not self:checkDeadZoneMouseHover(mousex, mousey) then
                return true
            end
        end
        return false
    end
    return false
end

function Node:isInside(x,y)
    if x > (self.pos.x - self:getWidth() / 2) and x < (self.pos.x + self:getWidth() / 2) then
        if y > (self.pos.y - self:getHeight() / 2) and y < (self.pos.y + self:getHeight() / 2) then
            return true
        end
        return false
    end
    return false
end

function Node:update(dt)
    return
end

function Node:draw()
    return
end

-- Moveable Object
----------------------------------------------
Moveable = setmetatable({}, { __index = Node })
Moveable.__index = Moveable

function Moveable.new(nx, ny, mouseMoveable, args)
    local mouseMoveable = mouseMoveable or false
    local self = setmetatable(Node.new(nx, ny, args), Moveable)

    self.T = "Moveable"

    self.newPos = Vector.new(nx, ny)
    self.movement = Vector.new(0, 0)
    self.distance = 0
    self.HCenter = Vector.new(0,0)
    self.mouseMoveable = mouseMoveable
    self.moveFlag = false
    self.moving = false
    self.mouseMove = false
    self.stopOnPause = true
    return self
end

function Moveable:mouseMoving()
    if self:checkMouseHover() and love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        mx,my = toGame(mx,my)
        --mx, my = push:toGame(mx, my)
        self:setPosImidiate(mx, my)
        self.mouseMove = true
    else
        self.mouseMove = false
    end
end

function Moveable:setPos(nx, ny)
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

function Moveable:setPosImidiate(nx, ny)
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
    if self.moveFlag or self.pos.x ~= self.newPos.x or self.pos.y ~= self.newPos.y then
        local dirx = self.newPos.x - self.pos.x
        local diry = self.newPos.y - self.pos.y
        self.distance = math.sqrt((dirx ^ 2) + (diry ^ 2))
        local normx = dirx / self.distance
        local normy = diry / self.distance
        self.HCenter.x = ((self.pos.x + self.newPos.x) / 2)
        self.HCenter.y = ((self.pos.y + self.newPos.y) / 2)
        self.movement:setVect(normx, normy)
        self.moveFlag = false
    end
    if not self.pos:checkDistance(self.newPos, 5) and not self.mouseMove then
        for x = 1, G.CARDSPEED * dt do
            if not self.pos:checkDistance(self.newPos, 5) then
                self.pos.x = (self.pos.x + (self.movement.x))
                self.pos.y = (self.pos.y + (self.movement.y))
            else
                break
            end
        end
    elseif not self.mouseMove then
        self.movement:setVect(0, 0)
        self.pos:setVect(self.newPos.x, self.newPos.y)
        self.moving = false
    end
end

-- Sprite Object
----------------------------------------------
Sprite = setmetatable({}, { __index = Moveable })
Sprite.__index = Sprite

function Sprite.new(nx, ny, mouseMoveable, newTexture)
    newTexture = newTexture or nil
    local self = setmetatable(Moveable.new(nx, ny, mouseMoveable), Sprite)

    self.T = "Sprite"

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
end

function Sprite:draw()
    love.graphics.setColor({ 1, 1, 1, self.transparency })
    love.graphics.draw(self.texture, self.pos.x, self.pos.y, self.rotation, self.scale.x, self.scale.y, self.size.x / 2,
        self.size.y / 2)
end

-- Vector2 Object
----------------------------------------------
Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)

    self.T = "Vector"
    self.x = x or 0
    self.y = y or 0
    return self
end

function Vector:setVect(x, y)
    self.x = x
    self.y = y
end

function Vector:getX()
    return self.x
end

function Vector:getY()
    return self.y
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