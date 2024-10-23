-- mainmenu.lua

MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new()
    local self = setmetatable({}, MainMenu)

    self.T = "MainMenu"

    -- Main Menu Title
    self.titleCards = TitleCards.new((G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2), (G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2))
    self.title = {"S", "H", "I", "T", "H", "E", "A", "D"}
    self.titleIndex = 1
    self.titleTimer = Timer.new(.08)
    self.titleDone = false
    self.exitDone = false
    self.flag = false
    self.pitch = 1
    self.versionText = love.graphics.newText(G.GAMEFONT, {{0,0,0}, "Version: ", _GAME_VERSION})

    -- Menu Buttons
    self.buttonBoxTimer = Timer.new(1.5)

    -- TEST ESC Menu
    self.escMenu = UIBox.new(400,700, ESCMENUDEF)

    -- Exit
    self.exitFlag = false

    self.demoBox = UIBox.new(600,350,DemoDef)
    self.buttonBox = UIBox.new(1000,150,ButtonBoxDef)
    logger:log("MainMenu Created")
    return self
end

function MainMenu:initTitleCards()
    if self.titleTimer:isExpired() then
        self.titleTimer:reset()
        local suit = math.random(4)
        local tmp = Card.new(1,1, -150, (G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2))
        tmp.cardFace = G.CARDGRAPHICS["CARDLETTERS"]["card" .. G.CARDSUITS[suit] .. self.title[self.titleIndex]]
        tmp.active = false
        self.titleIndex = self.titleIndex + 1
        --tmp.mouseMoveable = true
        self.titleCards:addCard(tmp)
        TEsound.pitch("deal", self.pitch)
        self.pitch = self.pitch + .005
    end
    if self.titleIndex == #self.title + 1 then self.titleIndex = 1 self.pitch = 1 end
end

function MainMenu:exit()
    if self.titleTimer:isStopped() then self.titleTimer:reset(.12) end
    if self.titleTimer:isExpired() and not self.exitDone and self.titleIndex <= #self.title + 1 then
        self.titleTimer:reset()
        self.titleCards:addDiscard(self.titleIndex)
        TEsound.pitch("deal", self.pitch)
        self.pitch = self.pitch - .005
        self.titleIndex = self.titleIndex+1
    end
    if self.titleIndex == #self.title + 1 then self.exitDone = true end
    if self.exitDone and not self.flag then self.buttonBox:setActive() self.demoBox:setActive() self.flag = true end
    if self.exitDone and not self.buttonBox.moving then G.gameScreen = 1 end
end

function MainMenu:update(dt)
    -- Play the into animation
    if #self.titleCards.cards ~= #self.title and not self.titleDone then 
        self:initTitleCards() 
    elseif not self.titleDone then
         self.titleTimer:stopTimer() self.titleDone = true 
         logger:log("Title Done")
    end

    -- Dely the movment of the buttons
    if self.buttonBoxTimer:isExpired() then
        self.buttonBox:setActive()
        self.demoBox:setActive()
        self.buttonBoxTimer:stopTimer()
    end

    -- Exit animation
    if self.exitFlag then
        self:exit()
    end


    self.titleCards:update(dt)
    self.titleTimer:update(dt)
    self.buttonBoxTimer:update(dt)
    self.demoBox:update(dt)
    self.buttonBox:update(dt)
    --self.escMenu:update(dt)
end

function MainMenu:draw()
    love.graphics.draw(self.versionText, 100,G.SCREENVARIABLES["GAMEDEMENTIONS"].y*.9074)
    self.titleCards:draw()
    self.demoBox:draw()
    self.buttonBox:draw()
    --self.escMenu:draw()
end


--[[ Title Card Logic ]]
TitleCards = setmetatable({}, {__index = HboxContainer})
TitleCards.__index = TitleCards

function TitleCards.new(nx,ny)
    local self = setmetatable(HboxContainer.new(nx,ny), TitleCards)
        self.cards = {}
        self.area = (G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2) - (350)
        self.discard = HboxContainer.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x + 200, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)
        self.discard.cards = {}
        self.discard.area = 20
    return self
end

function TitleCards:addCard(newCard)
    newCard.flipping = true
    newCard:playSound()
    table.insert(self.cards, newCard)
    self:updatePos(self.cards, true)
end

function TitleCards:addDiscard(index)
    local tmp = self.cards[index]
    tmp:playSound()
    tmp.flipping = true
    table.insert(self.discard.cards, tmp)
end

function TitleCards:update(dt)
    self.discard:updatePos(self.discard.cards, true)
    updateList(self.cards, dt)
    updateList(self.discard.cards, dt)
end

function TitleCards:draw()
    drawList(self.cards)
    drawList(self.discard.cards)
end

-- UIDefinitions for the Main Menu

-- Definition for Demo Box
DemoDef = {
    radius=10, 
    padding=10, 
    borderSize=10,
    alignment="Horizontal",
    positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, -200), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, 200)},
    contents={UILabel.new(
        G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,
        G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2,
        20,
        {
            alignment="center",
            text="Thank you for play testing Shithead! " .. 
            "This is the first play test release " .. 
            "of the game so expect some bugs and " .. 
            "missing features. Please feel free to " ..
            "send me any ideas for fetures that you " ..
            "would like to see in the game or " ..
            "problems you encounter during your test " ..
            "\n\nThanks - Mason"
        }
    )
    }
}

-- Definition for Button Box
ButtonBoxDef = {
    radius=10,
    padding=10,
    borderSize=10,
    alignment="Horizontal",
    positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, 2000),Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, G.SCREENVARIABLES["GAMEDEMENTIONS"].y*.9074)},
    contents={
        UIButton.new(0,0,200,100, {radius=10, text="Play", color="BLUE", action="play"}),
        UIButton.new(0,0,200,100, {radius=10, text="Multiplayer", color="YELLOW"}),
        UIButton.new(0,0,200,100, {radius=10, text="Options", color="GREEN"}),
        UIButton.new(0,0,200,100, {radius=10, text="Quit", color="RED",action="quit"})
    }
}

-- ESC Menu definition
ESCMENUDEF = {
    radius=10, 
    padding=10, 
    borderSize=10,
    alignment="Vertical",
    positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, 200)},
    contents={
        UILabel.new(0,0, 50, {alignment="center", text="Menu"}),
        UIButton.new(0,0,200,100,{radius=10, text="Main Menu", color="RED", action="mainmenu"}),
        UIButton.new(0,0,200,100,{radius=10, text="Options", color="RED", action="options"}),
        UIButton.new(0,0,200,100,{radius=10, text="Quit", color="RED", action="quit"})
    }
}