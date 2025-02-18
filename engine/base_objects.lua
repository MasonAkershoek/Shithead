-- Node Object
----------------------------------------------
Node = {}
Node.__index = Node

function Node.new(nx, ny, args)
    local self = setmetatable({}, Node)

    self.T = "Node"

    self._Args = args or {T = {}}

    self._Conf = self._Args.conf or {}

    -- Transformation in the nodes local space
    self._Transform = 
    {
        x = self._Args.T.x or nx or 0,
        y = self._Args.T.y or ny or 0,
        w = self._Args.T.w or 0,
        h = self._Args.T.h or 0,
        r = self._Args.T.r or 0,
        sx = self._Args.T.sx or 1,
        sy = self._Args.T.sy or 1,
        skx = self._Args.T.skx or 0,
        sky = self._Args.T.sky or 0
    }

    self._GlobalTransform = 
    {
        x = self._Args.T.x or nx or 0,
        y = self._Args.T.y or ny or 0,
        w = self._Args.T.w or 0,
        h = self._Args.T.h or 0,
        r = self._Args.T.r or 0,
        sx = self._Args.T.sx or 1,
        sy = self._Args.T.sy or 1,
        skx = self._Args.T.skx or 0,
        sky = self._Args.T.sky or 0
    }

    self._ClickOffset = Vector.new(0,0)

    -- Zone of the Node where mouse hover will not be trigered
    self._DeadZone = nil

    -- Node States
    self._States = 
    {
        visible = true,
        paused = false,
        clicked = {is=false, can=true},
        drag = {is=false, can=true},
        hovered = {is=false, can=true},
    }

    -- Parent/Children pointers
    self._Parent = self._Args.parent or nil
    self._Children = {}

    -- Added functions
    self._Functions = self._Args.functions or {}

    return self
end

-- Width and height getters
function Node:getWidth()
    return (self._Transform.w * self._Transform.sx)
end

function Node:getHeight()
    return (self._Transform.h * self._Transform.sy)
end

function Node:getSize()
    return Vector.new(self._GlobalTransform.x, self._GlobalTransform.y)
end

function Node:setSize(nw, nh)
    local nw = nw or nil
    local nh = nh or nil
    if nw then
        self._Transform.w = nw
    end
    if nh then
        self._Transform.h = nh
    end
end

function Node:setGlobalPos()
    if self.parent then
        local parentTransform = self.parent._GlobalTransform
        self._GlobalTransform.x = parentTransform.x + self._Transform.x
        self._GlobalTransform.y = parentTransform.y + self._Transform.y
        self._GlobalTransform.r = parentTransform.r + self._Transform.r
        self._GlobalTransform.sx = parentTransform.sx * self._Transform.sx
        self._GlobalTransform.sy = parentTransform.sy * self._Transform.sy
        self._GlobalTransform.skx = parentTransform.skx + self._Transform.skx
        self._GlobalTransform.sky = parentTransform.sky + self._Transform.sky
    else
        self._GlobalTransform = self._Transform
    end
end

-- Parent Child relationship functions
function Node:addChildren(newChild, tag)
    newChild:setParent(self)
    if tag then
        self._Children[tag] = newChild
    else
        table.insert(self._Children, newChild)
    end
end

function Node:removeChild(child, tag)
    if tag then
        table.remove(self.children[tag])
        return
    end
    if child then
        removeSelf(child, self.children)
        return
    end
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
    removeSelf(self, self.parent.children)
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

--- Returns a spesifed point on the object 
--- @param pos string Default: center [center, topleft, topright, bottomleft, bottomright, centerleft, centerright, centertop, centerbottom]
--- @return Vector
function Node:getPos(pos)
    local pos = pos or "center"
    local ret = Vector.new()

    if pos == "center" then
        ret.x = self._Transform.x 
        ret.y = self._Transform.y

    elseif pos == "topleft" then
        ret.x = (self._Transform.x - ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = (self._Transform.y - ((self._Transform.h * self._Transform.st) / 2))

    elseif pos == "topright" then
        ret.x = (self._Transform.x + ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = (self._Transform.y - ((self._Transform.h * self._Transform.sy) / 2))

    elseif pos == "bottomleft" then
        ret.x = (self._Transform.x - ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = (self._Transform.y + ((self._Transform.h * self._Transform.sy) / 2))

    elseif pos == "bottomright" then
        ret.x = (self._Transform.x + ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = (self._Transform.y + ((self._Transform.h * self._Transform.sy) / 2))

    elseif pos == "centerleft" then
        ret.x = (self._Transform.x - ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = self._Transform.y

    elseif pos == "centerright" then
        ret.x = (self._Transform.x + ((self._Transform.w * self._Transform.sx) / 2))
        ret.y = self._Transform.y

    elseif pos == "centertop" then
        ret.x = self._Transform.x
        ret.y = (self._Transform.y - ((self._Transform.h * self._Transform.sy) / 2))

    elseif pos == "centerbottom" then
        ret.x = self._Transform.x
        ret.y = (self._Transform.y + ((self._Transform.h * self._Transform.sy) / 2))
    end
    return ret
end

function Node:setDeadZone(deadZone)
    self.deadZone = deadZone
end

function Node:setScale(newScale)
    self._Transform.scale = newScale
end

function Node:setPos(nx, ny)
    nx = nx or nil
    ny = ny or nil
    if nx ~= nil then
        self._Transform.x = nx
    end
    if ny ~= nil then
        self._Transform.y = ny
    end
end

function Node:checkDeadZone(mx, my)
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
    if mousex > (self._Transform.x - self:getWidth() / 2) and mousex < (self._Transform.x + self:getWidth() / 2) then
        if mousey > (self._Transform.y - self:getHeight() / 2) and mousey < (self._Transform.y + self:getHeight() / 2) then
            if not self:checkDeadZone(mousex, mousey) then
                return true
            end
        end
        return false
    end
    return false
end

function Node:isInside(x,y)
    if x > (self._Transform.x - self:getWidth() / 2) and x < (self._Transform.x + self:getWidth() / 2) then
        if y > (self._Transform.y - self:getHeight() / 2) and y < (self._Transform.y + self:getHeight() / 2) then
            return true
        end
        return false
    end
    return false
end

function Node:drawBoundingRect()
    love.graphics.setColor(lovecolors:getColor("BLUE"))
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", self._GlobalTransform.x, self._GlobalTransform.y, self:getWidth(), self:getHeight())
    love.graphics.setColor({1,1,1,1})
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

function Moveable.new(nx, ny, args)
    local self = setmetatable(Node.new(nx, ny, args), Moveable)

    self.T = "Moveable"

    -- Used to tell the movable object how to move this can include position, scale and rotation
    self._NextTransform = 
    {
        complete = false,
        x = 0,
        y = 0,
        r = 0,
        scale = 1
    }

    self._States.move = {is=false, can=true}
    self._States.mouseMoveable = {is=false, can=true}
    self._MovementVector = Vector.new(0, 0)
    self._DistanceToDest = 0
    self._Speed = self._Args.speed or 0
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

-- Updated setPos
function Moveable:moveTo(x,y,s,r)
    self._NextTransform.x = x or self._Transform.x
    self._NextTransform.y = y or self._Transform.y
    self._NextTransform.s = s or self._Transform.scale
    self._NextTransform.r = r or self._Transform.r
    self._NextTransform.complete = false
end

-- Needs Refactoring
function Moveable:move(dt)
    self._Transform.x = self._NextTransform.x
    self._Transform.y = self._NextTransform.y

    -- New Method Logic
    -- if not self._NextTransform.complete and self._MovementVector.x == 0 then
    --     local dirx = self._NextTransform.x - self._Transform.x
    --     local diry = self._NextTransform.y - self._Transform.y
    --     local distance = math.sqrt((dirx^2) + (diry^2))
    --     local normx = dirx / distance
    --     local normy = diry / distance
    --     self._MovementVector:setVect(normx, normy)
    -- end
    -- count = 0
    -- while not isWithinRange(self:getPos(), Vector.new(self._NextTransform.x, self._NextTransform.y)) and not self._States.drag.is and count < (self._Speed * dt) do
        
    -- end

    -- -- Old method logic
    -- if self.moveFlag or self.pos.x ~= self.newPos.x or self.pos.y ~= self.newPos.y then
    --     local dirx = self.newPos.x - self.pos.x
    --     local diry = self.newPos.y - self.pos.y
    --     self.distance = math.sqrt((dirx ^ 2) + (diry ^ 2))
    --     local normx = dirx / self.distance
    --     local normy = diry / self.distance
    --     self.HCenter.x = ((self.pos.x + self.newPos.x) / 2)
    --     self.HCenter.y = ((self.pos.y + self.newPos.y) / 2)
    --     self.movement:setVect(normx, normy)
    --     self.moveFlag = false
    -- end
    -- if not self.pos:checkDistance(self.newPos, 5) and not self.mouseMove then
    --     for x = 1, G.CARDSPEED * dt do
    --         if not self.pos:checkDistance(self.newPos, 5) then
    --             self.pos.x = (self.pos.x + (self.movement.x))
    --             self.pos.y = (self.pos.y + (self.movement.y))
    --         else
    --             break
    --         end
    --     end
    -- elseif not self.mouseMove then
    --     self.movement:setVect(0, 0)
    --     self.pos:setVect(self.newPos.x, self.newPos.y)
    --     self.moving = false
    -- end
end

-- Sprite Object
----------------------------------------------
Sprite = setmetatable({}, { __index = Moveable })
Sprite.__index = Sprite

function Sprite.new(nx, ny, newTexture, args)
    local self = setmetatable(Moveable.new(nx, ny, args), Sprite)

    self.T = "Sprite"

    if newTexture ~= nil then
        self:setSprite(newTexture)
    else
        self._Texture = nil
    end
    self._Opac = 1
    return self
end

function Sprite:setSprite(newTexture)
    if type(newTexture) == "string" then
        self._Texture = love.graphics.newImage(newTexture)
    else
        self._Texture = newTexture
    end
    self:initSprite()
end

function Sprite:initSprite()
    self._Transform.w = (self._Texture:getWidth())
    self._Transform.h = (self._Texture:getHeight())
end

function Sprite:draw()
    self:setGlobalPos()
    love.graphics.setColor({ 1, 1, 1, self._Opac })
    love.graphics.draw(self._Texture, self._GlobalTransform.x, self._GlobalTransform.y, self._GlobalTransform.r, self._GlobalTransform.sx, self._GlobalTransform.sy, self._Transform.w / 2, self._Transform.h / 2)
    drawList(self._Children)
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
        else
            return false
        end
    else
        return false
    end
end

-- if p1.x > (p2.x-space) and p1.x < (p2.x+space) then
--     if p1.y > (p2.y - space) and p1.y < (p2.y+space) then
--            return true
--     end
-- else
--     return false
--end