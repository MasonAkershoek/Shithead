UINode = setmetatable({}, {__index = Moveable})
UINode.__index = UINode

function UINode.new(x,y,w,h,args)
    local args = args or {}
    local self = setmetatable(Moveable.new(x,y,false), UINode)

    self.size = Vector.new(w,h)
    self.centerPoint = nil

    -- Setting UI Elements attrabutes
    self.radius = args.radius or 0
    self.internalPadding = args.internalPadding or 0
    self.showShadow = args.showShadow or true
    self.showBorder = args.showBorder or true
    self.changed = false
    return self
end

function UINode:getX()
    return self.pos.x
end

function UINode:getY()
    return self.pos.y
end

function UINode:setPadding(value)
    self.internalPadding = value or 0
end

function UINode:getPadding()
    return self.internalPadding
end

function UINode:getWidth()
    return self.size.x
end

function UINode:setWidth(value)
    self.size.x = value or 0
    self.changed = true
end

function UINode:getHeight()
    return self.size.y
end

function UINode:setHeight(value)
    self.size.y = value or 0
    self.changed = true
end

function UINode:setRadius(value)
    self.radius = value or 0
end

function UINode:getRadius()
    return self.radius
end

function UINode:drawShadow()
    
end

-- UIBox class definition
UIBox = setmetatable({}, {__index = UINode})
UIBox.__index = UIBox

function UIBox.new(w,h,args)
    local args = args or {}
    local x = args.positions[1].x or 0
    local y = args.positions[1].y or 0
    local self = setmetatable(UINode.new(x,y,w,h,args), UIBox)

    self.alignment = args.alignment or "Vertical"
    self.contents = args.contents or {}
    self.positions = args.positions or {Vector.new(0,0),Vector.new(0,0)}
    self.active = false
    self.borderSize = args.borderSize or 10
    self.padding = args.padding or 0
    self.borderColor = args.borderColor or G.COLORS["LIGHTGRAY"]
    self.color = args.color or G.COLORS["DARKGRAY"]
    return self
end

function UIBox:removeContent(index)
    table.remove(self.contents, index)
    self.changed = true
end

function UIBox:addContent(newContent, Index)
    local index = Index or 0
    table.insert(self.contents, index, newContent)
    self.changed = true
end

function UIBox:getContentSize()
    return #self.contents
end

function UIBox:setActive()
    if self.active then
        self.active = false
    else
        self.active = true
    end
    self.changed = true
end

function UIBox:HAlign()
    local flag = flag or true
    local tmpWidth = 0
    tmpHeight = 0
    if #self.contents > 0 then
        local xpoints = ((self.size.x + self.size.x) / (#self.contents + 1))
        local nextPoint = (self.pos.x - self.size.x)
        for x=1, #self.contents do
            self.contents[x]:setWrap(self.size.x-self.borderSize-self.padding)
            if flag then
                self.contents[x]:setPosImidiate((xpoints + nextPoint), self.pos.y)
            else
                self.contents[x]:setPosImidiate((xpoints + nextPoint))
            end
            nextPoint = nextPoint + xpoints
        end
    end
end

--[[
    change update list to allow the passing of arguments
    for all contents of the UIBox there update functions need have a pointer to there parent function
    add a variable to the UINode called changed that is set anytime a function that changes the dementions/pos 
    of a ui object happens and then resets at the end of the update function

]]
function UIBox:update(dt)
    self:HAlign()
    self:move(dt)
    if self.changed then
        if self.active then
            self:setPos(self.positions[2].x, self.positions[2].y)
        else
            self:setPos(self.positions[1].x, self.positions[1].y)
        end
        self.changed = false
    end
end

function UIBox:draw()
    if self.showShadow then
        
    end
    if self.showBorder then
        love.graphics.setColor(G.COLORS["LIGHTGRAY"].r,G.COLORS["LIGHTGRAY"].g,G.COLORS["LIGHTGRAY"].b)
        love.graphics.rectangle("fill", self.pos.x-(self.size.x/2), self.pos.y-(self.size.y/2), self.size.x, self.size.y, self.radius,self.radius)
    end
    love.graphics.setColor(G.COLORS["DARKGRAY"].r,G.COLORS["DARKGRAY"].g,G.COLORS["DARKGRAY"].b)
    love.graphics.rectangle("fill", self.pos.x-((self.size.x-self.borderSize)/2), self.pos.y-((self.size.y-self.borderSize)/2), self.size.x-self.borderSize, self.size.y-self.borderSize, self.radius, self.radius)
    drawList(self.contents)
end


-- UILabel class definition
UILabel = setmetatable({}, {__index = UINode})
UILabel.__index = UILabel

function UILabel.new(x,y,fontSize,args)
    local locArgs = args or {}
    local self = setmetatable(UINode.new(x,y,0,0,args), UILabel)

    self.fontSize = fontSize or 0
    self.text = locArgs.text or "Empty!"
    self.alignment = locArgs.alignment or "left"
    self.wdithLimit = 0

    self.textGraphics = love.graphics.newText(G.GAMEFONT, self.text)
    self.textGraphics:setf(self.text, self.wdithLimit, self.alignment)
    self:setWidthAndHeight()
    return self
end

function UILabel:setText(newText)
    self.text = newText
    self.textGraphics:setf(self.text, newWidth, self.alignment)
    self:setWidthAndHeight()
end

function UILabel:getText()
    return self.text
end


-- set the text without formatting to get the width of the unformatted text then 
-- check if the newWidth is less then self.size.x
function UILabel:setWrap(newWidth)
    if newWidth < self.size.x then
        self.widthLimit = newWidth
        self.textGraphics:setf(self.text, newWidth, self.alignment)
        self:setWidthAndHeight()
    end 
end

function UILabel:setAlignment(alignment)
    self.alignment = alignment
    self.textGraphics:setf(self.text, self.size.x, self.alignment)
end

function UILabel:setWidthAndHeight()
    self.size.x = self.textGraphics:getWidth()
    self.size.y = self.textGraphics:getHeight()
end

function UILabel:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.textGraphics, self.pos.x, self.pos.y,0,1,1,self.size.x/2, self.size.y/2)
end

-- UIButton class definition
UIButton = setmetatable({}, {__index = UIButton})
UIButton.__index = UIButton

function UIButton.new(x,y,w,h,args)
    local args = args or {}
    local self = setmetatable(UINode.new(x,y,w,h,args))
    self.action = args.action or function() print("Empty Function") end
    self.color = args.color or G.COLORS["RED"]
    self.text = args.text or "Empty!"
    self.clickCooldown = args.clickCooldown or 5
    self.oldmousedown = ""
    return self
end

function UIButton.update(dt)
    
end

function UIButton.draw()
    
end