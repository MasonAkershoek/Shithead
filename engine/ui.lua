-- ui.lua

Button = setmetatable({}, {__index = Node})
Button.__index = Button

function Button.new(newText,nx,ny,w,h,nColor,action)
    local newText = newText or "EMPTY!"
    local nx = nx or 0
    local ny = ny or 0
    local self = setmetatable(Node.new(nx,ny), Button)
    self.action = action
    self.size:setVect(w,h)
    self.text = love.graphics.newText(G.GAMEFONT, {{1,1,1}, newText})
    self.color = nColor
    self.tranparancy = 1
    self.radius = 20
    self.shadow = true
    self.active = true
    self.cooldown = 0
    self.oldmousedown = ""
    return self
end

function Button:onSelect()
    if self:checkMouseHover() then
        if love.mouse.isDown(1) and not self.oldmousedown then
            G.EVENTMANAGER:emit(self.action)
        end
    end
    self.oldmousedown = love.mouse.isDown(1)
end

function Button:onHover()
    if self:checkMouseHover() then
        self.hoverFlag = true
    else
       self.hoverFlag = false 
    end
end

function Button:update(dt)
    self:onHover()
    self:onSelect()
end

function Button:draw()
    if self.shadow then
        love.graphics.setColor(G:getColor("BLACK", .5))
        love.graphics.rectangle("fill", self.pos.x - (self.size.x/2) +5, self.pos.y - (self.size.y/2)+5, self.size.x, self.size.y, self.radius, self.radius)
    end
    love.graphics.setColor(G:getColor(self.color))
    if self.hoverFlag then
        love.graphics.setShader(G.darkenShader)
        G.darkenShader:send("darkness", 0.5)
    end
    love.graphics.rectangle("fill", self.pos.x - (self.size.x/2), self.pos.y - (self.size.y/2), self.size.x, self.size.y, self.radius, self.radius)
    love.graphics.setShader()
    love.graphics.setColor({G.COLORS["WHITE"].r, G.COLORS["WHITE"].g, G.COLORS["WHITE"].b, 1})
    love.graphics.draw(self.text, self.pos.x, self.pos.y, 0, 1, 1, self.text:getWidth()/2, self.text:getHeight()/2)
end

Label = setmetatable({}, {__index = Node})
Label.__index = Label

function Label.new(newText, fontSize)
    local self = setmetatable(Node.new(0,0), Label) 
    self.text = newText or "EMPTY!"
    self.textImage = love.graphics.newText(G.GAMEFONT, {{1,1,1}, self.text})
    return self
end

function Label:updateText(newText)
    self.text = newText
    self.textImage = love.graphics.newText(G.GAMEFONT, {{1,1,1}, self.text})
end

function Label:update(dt)
    
end

function Label:draw()
    love.graphics.draw(self.textImage, self.pos.x, self.pos.y, 0, 1, 1, self.textImage:getWidth()/2, self.textImage:getHeight()/2) 
end

TextEntry = setmetatable({}, {__index = Node})
TextEntry.__index = TextEntry

function TextEntry.new(nx,ny,w,h)
    self.pos.x = nx
    self.pos.y = ny
    self.size.x = w
    self.size.y = h
    self.text = ""
    self.active = false
end

function TextEntry.update()
    
end

function TextEntry.draw()
    if self.active then
        
    end
end

UIBox = setmetatable({}, {__index = HboxContainer})
UIBox.__index = UIBox

function UIBox.new(args)
    local self = setmetatable(HboxContainer.new(args.x, args.y), UIBox)
    self.pos.x = args.x
    self.pos.y = args.y
    self.size.width = args.width
    self.size.height = args.height
    self.radius = 20
    self.transparency = .3
    self.area = args.area or 0
    self.contents = args.contents or {}
    return self
end

function UIBox:update(dt)
    self:updatePos(self.contents, true)
    self:move(dt)
    updateList(self.contents, dt)
end

function UIBox:draw()
    --Draw Shadow
    love.graphics.setColor(0,0,0,self.transparency)
    love.graphics.rectangle("fill", self.pos.x-(self.size.width/2), self.pos.y-(self.size.height/2), self.size.width+10, self.size.height+10, self.radius,self.radius)

    -- Draw UIBox Border
    love.graphics.setColor(G.COLORS["LIGHTGRAY"].r,G.COLORS["LIGHTGRAY"].g,G.COLORS["LIGHTGRAY"].b)
    love.graphics.rectangle("fill", self.pos.x-((self.size.width/2)+5), self.pos.y-((self.size.height/2)+5), self.size.width+10, self.size.height+10,self.radius,self.radius)

    -- Draw UIBox
    love.graphics.setColor(G.COLORS["DARKGRAY"].r,G.COLORS["DARKGRAY"].g,G.COLORS["DARKGRAY"].b)
    love.graphics.rectangle("fill", self.pos.x-(self.size.width/2), self.pos.y-(self.size.height/2), self.size.width, self.size.height ,self.radius,self.radius)

    love.graphics.setColor(1,1,1,1)
    drawList(self.contents)
end

function UIBox:draw()
    --Draw Shadow
    love.graphics.setColor(0,0,0,self.transparency)
    love.graphics.rectangle("fill", self.pos.x-(self.size.width/2), self.pos.y-(self.size.height/2), self.size.width+10, self.size.height+10, self.radius,self.radius)

    -- Draw UIBox Border
    love.graphics.setColor(G.COLORS["LIGHTGRAY"].r,G.COLORS["LIGHTGRAY"].g,G.COLORS["LIGHTGRAY"].b)
    love.graphics.rectangle("fill", self.pos.x-((self.size.width/2)+5), self.pos.y-((self.size.height/2)+5), self.size.width+10, self.size.height+10,self.radius,self.radius)

    -- Draw UIBox
    love.graphics.setColor(G.COLORS["DARKGRAY"].r,G.COLORS["DARKGRAY"].g,G.COLORS["DARKGRAY"].b)
    love.graphics.rectangle("fill", self.pos.x-(self.size.width/2), self.pos.y-(self.size.height/2), self.size.width, self.size.height ,self.radius,self.radius)

    love.graphics.setColor(1,1,1,1)
    drawList(self.contents)
end


-- UI Definitions

-- Main Menu Buton Box
-- MAINMENUBOX = {}
-- MAINMENUBOX.x = G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2
-- MAINMENUBOX.y = G.SCREENVARIABLES["GAMEDEMENTIONS"].y+200
-- MAINMENUBOX.width = 1000
-- MAINMENUBOX.height = 150
-- MAINMENUBOX.area = G.SCREENVARIABLES["GAMEDEMENTIONS"].x * .30
-- MAINMENUBOX.contents = {
--     Button.new("Play", nil, G.SCREENVARIABLES["GAMEDEMENTIONS"].y+400,200,100, "BLUE", "play"),
--     Button.new("Multiplayer", nil, G.SCREENVARIABLES["GAMEDEMENTIONS"].y+400,200,100, "GREEN","multiplayer"),
--     Button.new("Options", nil, G.SCREENVARIABLES["GAMEDEMENTIONS"].y+400,200,100, "YELLOW","options"),
--     Button.new("Quit", nil, G.SCREENVARIABLES["GAMEDEMENTIONS"].y+400,200,100, "RED", "quit")
-- }

-- Playtest Box
PLAYTEST = {}
PLAYTEST.x = G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2
PLAYTEST.y = G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2 - 350
PLAYTEST.width = 700
PLAYTEST.height = 300
PLAYTEST.area = 200
PLAYTEST.contents = {
    Label.new(
    "Thank you for play testing Shithead!\n\n" .. 
    "This is the first play test release\n" .. 
    "of the game so expect some bugs and\n" .. 
    "missing features. Please feel free to\n" ..
    "send me any ideas for fetures that you\n" ..
    "would like to see in the game or\n" ..
    "problems you encounter during your test\n" ..
    "\n                         Thanks - Mason"
    , 20)
}

-- Win Box
WINBOX = {}
WINBOX.x = G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2
WINBOX.y = G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2
WINBOX.width = 500
WINBOX.height = 300
WINBOX.area = 200
WINBOX.contents = {
    Label.new(" WINS!!!\n press q to quit.")
}

TEST = {}
TEST.x = G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2
TEST.y = G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2