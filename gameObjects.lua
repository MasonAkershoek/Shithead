-- gameObjects.lua

-- Node Object
----------------------------------------------
Node = {}
Node.__index = Node

--- Class: Node
--- Constructer method for the Node class
---@param nx integer
---@param ny integer
function Node.new(nx, ny)
    nx = nx or 0
    ny = ny or 0

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
    self.parent = nil
    self.children = {}

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

function Node:setParent(newParent)
    self.parent = newParent
end

function Node:removeParent()
    self:setParent(nil)
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
    --local mousex, mousey = push:toGame(mousex, mousey)
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

-- Moveable Object
----------------------------------------------
Moveable = setmetatable({}, { __index = Node })
Moveable.__index = Moveable

function Moveable.new(nx, ny, mouseMoveable)
    local mouseMoveable = mouseMoveable or false
    local self = setmetatable(Node.new(nx, ny), Moveable)

    self.T = "Moveable"

    self.newPos = Vector.new(nx, ny)
    self.movement = Vector.new(0, 0)
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
    if self.moveFlag then
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
    --self.texture:setFilter("linear", "linear", 1)
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

-- HboxContainer
----------------------------------------------
HboxContainer = setmetatable({}, { __index = Moveable })

HboxContainer.__index = HboxContainer

function HboxContainer.new(nx, ny, bgBox)
    bgBox = bgBox or false
    local self = setmetatable(Moveable.new(nx, ny), HboxContainer)

    self.T = "HboxContainer"

    self.area = 0
    self.baseScale = 1
    self.boxFlag = bgBox
    self.borderBox = nil
    self.itemsMoving = false
    return self
end

function HboxContainer:getWidth()
    return self.size.x / 2 + self.area
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
        for x = 1, #items do
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
VboxContainer = setmetatable({}, { __index = Moveable })

VboxContainer.__index = VboxContainer

function VboxContainer.new(nx, ny)
    local self = setmetatable(Moveable.new(nx, ny), VboxContainer)

    self.T = "VboxContainer"

    self.area = 0
    return self
end

function VboxContainer:updatePos(items, padding, i)
    padding = padding or 0
    if #items > 0 then
        local nextPoint = (self.pos.y - self.area)
        for x = 1, #items do
            nextPoint = nextPoint + ((items[x].size.y / 2) * items[x].baseScale)
            if not i then
                items[x]:setPos(self.pos.x, nextPoint)
            else
                items[x]:setPosImidiate(self.pos.x, nextPoint)
            end
            nextPoint = ((nextPoint + ((items[x].size.y / 2) * items[x].baseScale)) + padding)
        end
    end
end
