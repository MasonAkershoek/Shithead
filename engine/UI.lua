UINode = setmetatable({}, {__index = Moveable})
UINode.__index = UINode

function UINode.new(x,y,w,h,args)
    local args = args or {}
    local self = setmetatable(Moveable.new(x,y,false), UINode)

    self.T = "Node"
    
    self.size = Vector.new(w,h)
    self.centerPoint = nil

    -- Setting UI Elements attrabutes
    self.radius = args.radius or 0
    self.internalPadding = args.internalPadding or 0
    self.showBorder = args.showBorder or true
    self.changed = false

    -- Shadow
    self.shadowOffset = 10
    self.shadowPos = Vector.new(self.pos.x+self.shadowOffset,self.pos.y+self.shadowOffset)
    self.showShadow = args.showShadow or true
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
    love.graphics.setColor(G:getColor("BLACK", .5))
    love.graphics.rectangle("fill", self.pos.x - (self.size.x/2) +5, self.pos.y - (self.size.y/2)+5, self.size.x, self.size.y, self.radius, self.radius)
end

-- UIBox class definition
UIBox = setmetatable({}, {__index = UINode})
UIBox.__index = UIBox

--[[
    Add an over shoot to the move function that allows you to specify an amout of over shoot for the
    object to take to make the movment feel more fluid 
]]

function UIBox.new(w,h,args)
    local args = args or {}
    local x = args.positions[1].x or 0
    local y = args.positions[1].y or 0
    local self = setmetatable(UINode.new(x,y,w,h,args), UIBox)

    self.T = "UIBox"

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
    self.moving = true
    if self.active then
        logger:log("UIBox Set Inactive")
        self.active = false
    else
        logger:log("UIBox Set Active")
        self.active = true
    end
    self.changed = true
end

function UIBox:HAlign()
    local flag = flag or true
    local tmpWidth = 0
    local sizeOffset = 400
    tmpHeight = 0
    if #self.contents > 0 then
        local xpoints = (((self.size.x-sizeOffset) + (self.size.x - (self.borderSize/2) -sizeOffset)) / (#self.contents + 1))
        local nextPoint = (self.pos.x+sizeOffset - self.size.x)
        for x=1, #self.contents do
            if flag then
                self.contents[x]:setPosImidiate((xpoints + nextPoint), self.pos.y)
            else
                self.contents[x]:setPosImidiate((xpoints + nextPoint))
            end
            nextPoint = nextPoint + xpoints
        end
    end
end

function UIBox:VAlign(padding)
    padding = padding or 00
    if #self.contents > 0 then
        local nextPoint = (self.pos.y - self.size.y/2)+10
        for x=1, #self.contents do
            nextPoint = nextPoint + ((self.contents[x].size.y/2) * self.contents[x].baseScale)
            self.contents[x]:setPosImidiate(self.pos.x, nextPoint)
            nextPoint = ((nextPoint + ((self.contents[x].size.y/2) * self.contents[x].baseScale)) + padding)
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
    if self.alignment == "Vertical" then self:VAlign() else self:HAlign() end
    self:move(dt)
    for item=1, #self.contents do
        if self.contents[item].T == "UIButton" then
            self.contents[item]:update(dt)
        end
    end
    if self.changed then
        for item=1, #self.contents do
            if self.contents[item].T == "UILabel" then
                --self.contents[item]:update()
                self.contents[item]:setWrap(self.size.x-(self.borderSize * 2)-(self.padding*2))
            end
        end
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
        self:drawShadow()
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

    self.T = "UILabel"

    self.fontSize = fontSize or 20
    self.text = locArgs.text or "Empty!"
    self.alignment = locArgs.alignment or "left"
    self.color = locArgs.color or "WHITE"

    self.textGraphics = love.graphics.newText(G.FONTMANAGER:getFont("GAMEFONT", self.fontSize), self.text)
    self.wdithLimit = self.textGraphics:getWidth() or 10
    self.textGraphics:setf(self.text, self.wdithLimit, self.alignment)
    self:setWidthAndHeight()
    return self
end

function UILabel:setText(newText)
    self.text = newText
    self.textGraphics:setf(self.text, self.wdithLimit, self.alignment)
    self:setWidthAndHeight()
end

function UILabel:getText()
    return self.text
end


-- set the text without formatting to get the width of the unformatted text then 
-- check if the newWidth is less then self.size.x
-- fix the wrap function, there should probably be both a with and wrap variable 
function UILabel:setWrap(newWidth)
    self.textGraphics:set(self.text)
    self:setWidthAndHeight()
    if newWidth < self.size.x then
        self.wdithLimit = newWidth
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
    love.graphics.setColor(G:getColor(self.color))
    love.graphics.draw(self.textGraphics, self.pos.x, self.pos.y,0,1,1,self.size.x/2, self.size.y/2)
end

-- UIButton class definition
UIButton = setmetatable({}, {__index = UINode})
UIButton.__index = UIButton

function UIButton.new(x,y,w,h,args)
    local args = args or {}
    local self = setmetatable(UINode.new(x,y,w,h,args), UIButton)

    self.T = "UIButton"

    self.action = args.action or nil
    self.color = args.color or "RED"
    self.text = args.text or "Empty!"
    self.textGraphics = UILabel.new(self.pos.x,self.pos.y, args.textFontSize, {text=self.text, alignment="center"})
    self.oldmousedown = ""
    self.clickTimer = Timer.new(.2)
    self.clickTimer:stopTimer()
    return self
end

function UIButton:onHover()
    if self:checkMouseHover() then
        self.hoverFlag = true
    else
       self.hoverFlag = false 
    end
end

function UIButton:setText(newText)
    self.textGraphics:setText(newText)
end

function UIButton:onSelect()
    if self:checkMouseHover() then
        if love.mouse.isDown(1) and not self.oldmousedown then
            if self.action ~= nil then
                G.EVENTMANAGER:emit(self.action)
                self.clickTimer:start()
            else
                print("No Action Supplied!")
                self.clickTimer:start()
            end
        end
    end
    self.oldmousedown = love.mouse.isDown(1)
end

function UIButton:update(dt)
    self:onHover()
    self:onSelect()
    self.clickTimer:update(dt)
    if self.clickTimer:isExpired() then self.clickTimer:stopTimer() end
end

function UIButton:draw()
    if self.showShadow then
        self:drawShadow()
    end
    self.textGraphics:setPosImidiate(self.pos.x,self.pos.y)
    if self.hoverFlag then
        love.graphics.setColor(G:getColor(self.color,1,.2))
    else
        love.graphics.setColor(G:getColor(self.color)) 
    end
    if self.clickTimer:isStopped() then
        love.graphics.rectangle("fill", self.pos.x - (self.size.x/2), self.pos.y - (self.size.y/2), self.size.x, self.size.y, self.radius, self.radius)
    else
        love.graphics.rectangle("fill", self.pos.x - (self.size.x/2)+self.shadowOffset/3, self.pos.y - (self.size.y/2)+self.shadowOffset/3, self.size.x, self.size.y, self.radius, self.radius)
    end
    love.graphics.setColor({1,1,1})
    self.textGraphics:draw()
end

UITextField = setmetatable({}, {__index = UINode})
UITextField.__index = UITextField

function UITextField.new(x,y,w,h,fontSize,args)
    local args = args or {}
    local self = setmetatable(UINode.new(x,y,w,h,args), UITextField)

    self.T = "UITextField"

    self.fontSize = fontSize or 20
    self.selected = false
    self.maxLen = args.maxLen or 10
    self.color = args.color or "WHITE"
    -- Text Field Text
    self.text = {}
    self.textGraphics = UILabel.new(0,0,self.fontSize,{alignment="left", text="", color="BLACK"})
    self.textGraphics:setPosImidiate(self.pos.x,self.pos.y)

    -- Temporary Text for Field
    self.tmpText = args.tmpText or ""
    self.tmpTextGraphics = UILabel.new(0,0,self.fontSize,{alignment="left", text="",color="LIGHTGRAY"})
    self.tmpTextGraphics:setPosImidiate(self.pos.x,self.pos.y)
    self.tmpTextGraphics:setText(self.tmpText)
    self.tmpTextGraphics:setWrap(self.size.x)

    -- Text Field Label Properties
    self.label = {
        showLabel = args.showLabel or false,
        position = args.lablePos or "left",
        text = args.lableText or "Empty!"
    }
    return self
end

function UITextField:select()
    if self:checkMouseHover() and not self.selected and love.mouse.isDown(1) then
        logger:log("Text Field Selected")
        self.selected = true
    elseif not self:checkMouseHover() and self.selected and love.mouse.isDown(1) then
        logger:log("Text Field Unselected")
        self.selected = false
    end  
end

function UITextField:getText()
    local tmp = ""
    for x,v in ipairs(self.text) do
        tmp = tmp .. v
    end
    return tmp
end

function UITextField:addText(newChar)
    if newChar ~= "" and #self.text < self.maxLen then
        table.insert(self.text, #self.text+1, newChar)
        self.textGraphics:setText(self:getText())
        self.textGraphics:setWrap(self.size.x)
        logger:log("Text Added To", self.T, newChar)
    end
end

function UITextField:backSpace()
    if #self.text > 0 then 
        table.remove(self.text, #self.text)
        self.textGraphics:setText(self:getText())
        self.textGraphics:setWrap(self.size.x)
    end
end

function UITextField:update(dt)
    self:select()
    if self.selected and G.KEYBOARDMANAGER.keyPressFlag then
        local key = convertKeyPress(G.KEYBOARDMANAGER:getLastKeyPress())
        if key == "backspace" then self:backSpace() else self:addText(key) end
    end
end

function UITextField:showCursor()
    
end

function UITextField:draw()
    if self.showShadow then
        self:drawShadow()
    end
    love.graphics.setColor(G:getColor(self.color))
    love.graphics.rectangle("fill", self.pos.x - (self.size.x/2), self.pos.y - (self.size.y/2), self.size.x, self.size.y, self.radius, self.radius)
    if #self.text == 0 and not self.selected then
        self.tmpTextGraphics:draw()
    else
        self.textGraphics:draw()
    end
end