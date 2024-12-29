-- UIDefinitions for the CardTable

-- Definition for Win Box
MAKE_WIN_BOX = function()
    local t = UIBox.new(
        600,
        350,
        {
            radius = 10,
            padding = 10,
            borderSize = 10,
            alignment = "Vertical",
            positions = { Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, -300), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, G.SCREENVARIABLES["GAMEDEMENTIONS"].y / 2) }
        }
    )
    t:setActive()
    t:addChildren(UILabel.new(0, 0, 20, { alignment = "center", text = " WINS!!!\n" }))
    t:addChildren(UIButton.new(0, 0, 200, 100, {
        radius = 10,
        text = "Main Menu",
        color = "DARKERRED",
        action =
        "setMainMenu"
    }))
    t:addFunction(
        function(self)
            if G.cardTable.winner then
                self.contents[1]:setText((G.cardTable.winner .. self.contents[1].text))
                G.cardTable.winner = nil
            end
        end
    )
    t:addFunction(
        function(self)
            if G.gamestate == "CLEANUP" then
                removeSelf(self, G.UI.BOX)
            end
        end
    )
    return t
end

MAKE_DEBUG_BOX = function()
    local t = UIBox.new(
        600,
        350,
        {
            radius = 10,
            padding = 0,
            borderSize = 10,
            alignment = "Vertical",
            positions = { Vector.new(-500, G.SCREENVARIABLES["GAMEDEMENTIONS"].y / 2), Vector.new(350, G.SCREENVARIABLES["GAMEDEMENTIONS"].y / 2) },
        }
    );
    t:setActive()
    t:addChildren(UILabel.new(0, 0, 50, { alignment = "center", text = "Debug Menu" }))
    for _, op in ipairs(G.cardTable.opa.opponents) do
        t:addChildren(UILabel.new(0, 0, 20, { alignment = "center", text = op.name .. ": " }))
        t:addChildren(UILabel.new(0, 0, 20, { alignment = "center", text = "Empty" }))
    end

    t:addFunction(
        function(self)
            local index = 1
            for x = 3, #self.contents, 2 do
                local cards = ""
                for y, card in ipairs(G.cardTable.opa.opponents[index].hand) do
                    cards = cards .. " " .. tostring(card.rank)
                end
                if cards == self.contents[x]:getText() then
                else
                    self.contents[x]:setText(cards)
                    self.contents[x]:setAlignment("center")
                    self.contents[x]:setWrap(self:getWidth())
                end
                index = index + 1
            end
        end
    )
    t:addFunction(
        function(self)
            if G.SETTINGS.debugBoxActive and G.KEYBOARDMANAGER:getLastKeyPress() == "k" then
                removeSelf(self, G.UI.BOX)
                G.SETTINGS.debugBoxActive = false
            end
        end
    )
    G.SETTINGS.debugBoxActive = true
end

MAKE_ESC_MENU = function()
    local t = UIBox.new(
        400,
        500,
        {
            radius = 10,
            padding = 10,
            borderSize = 10,
            alignment = "Vertical",
            positions = { Vector.new(_GAME_WIDTH / 2, -200), Vector.new(_GAME_WIDTH / 2, _GAME_HEIGHT / 2) },
            objPadding = 20, 
            stopOnPause=false
        }
    )
    t:setActive()
    t:addChildren(UILabel.new(0, 0, 50, { alignment = "center", text = "Menu", parent=t}))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Main Menu", color = "RED", action = "mainmenu", parent=t}))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Options", color = "RED", action = "showOptions", parent=t}))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Quit", color = "RED", action = "quit", parent=t}))
    t:addFunction(
        function(self)
            if G.SETTINGS.ESCAPEMENUACTIVE and G.KEYBOARDMANAGER:getLastKeyPress() == "escape" then
                G.SETTINGS.ESCAPEMENUACTIVE = false
                G.SETTINGS.PAUSED = false
                removeSelf(self, G.UI.BOX)
            end
            if G.SETTINGS.OPTIONSACTIVE then
                G.SETTINGS.ESCAPEMENUACTIVE = false
                removeSelf(self, G.UI.BOX)
            end
        end
    )
end

MAKE_MAIN_MENU_BUTTON_BOX = function()
    local t = UIBox.new(
        1000,
        150,
        {
            radius = 10,
            padding = 10,
            borderSize = 10,
            alignment = "Horizontal",
            positions = { Vector.new(_GAME_WIDTH / 2, 2000), Vector.new(_GAME_WIDTH / 2, _GAME_HEIGHT * .9074) }
        }
    )
    t:setActive()
    logger:log("Button Box Size:", t.size.x)
    t:addChildren(UIButton.new(-100, -100, 200, 100, { radius = 10, text = "Play", color = "DARKERBLUE", action = "play" }))
    t:addChildren(UIButton.new(-100, -100, 200, 100, { radius = 10, text = "Multiplayer", color = "DARKERYELLOW" }))
    t:addChildren(UIButton.new(-100, -100, 200, 100, { radius = 10, text = "Options", color = "DARKERGREEN", action="showOptions" }))
    t:addChildren(UIButton.new(-100, -100, 200, 100, { radius = 10, text = "Quit", color = "DARKERRED", action = "quit" }))
end

MAKE_FPS_HUD = function()
    local t = UIBox.new(
        400,
        100,
        {
            drawBox = false,
            positions = { Vector.new(-200, 100), Vector.new(200, 100) }
        }
    )
    t:setActive()
    for x=0, 8 do
        t:addChildren(UILabel.new(0, 0, 20, { alignment = "center" }))
    end
    t:addFunction(
        function(self)
            local x, y, flags = love.window.getMode()
            local mx,my = love.mouse.getPosition()
            self.children[1]:setText("FPS: " .. love.timer.getFPS())
            self.children[1]:setAlignment("center")
            self.children[1]:setWrap(self:getWidth())
            self.children[2]:setText("Display: " .. flags.display)
            self.children[2]:setAlignment("center")
            self.children[2]:setWrap(self:getWidth())
            self.children[3]:setText("Queue: " .. #G.EVENTMANAGER.queue)
            self.children[3]:setAlignment("center")
            self.children[3]:setWrap(self:getWidth())
            self.children[4]:setText("X,Y: "..x..", "..y)
            self.children[4]:setAlignment("center")
            self.children[4]:setWrap(self:getWidth())
            self.children[5]:setText("mX,mY: "..mx..", "..my)
            self.children[5]:setAlignment("center")
            self.children[5]:setWrap(self:getWidth())
            mx,my = toGame(mx,my)
            self.children[6]:setText("SmX,SmY: "..math.floor(mx)..", "..math.floor(my))
            self.children[6]:setAlignment("center")
            self.children[6]:setWrap(self:getWidth())
            self.children[7]:setText("Scale: "..G.SETTINGS.SCREENVARIABLES.SCREENSCALE)
            self.children[7]:setAlignment("center")
            self.children[7]:setWrap(self:getWidth())
            self.children[8]:setText("Major State: "..G.MAJORSTATE)
            self.children[8]:setAlignment("center")
            self.children[8]:setWrap(self:getWidth())
            self.children[9]:setText("Minor State: "..G.MINORSTATE)
            self.children[9]:setAlignment("center")
            self.children[9]:setWrap(self:getWidth())
            
        end
    )
    t:addFunction(
        function(self)
            table.insert(G.BUFFEREDFUNCS, function()
                if G.KEYBOARDMANAGER:getLastKeyPress() == "f3" and G.SETTINGS.SHOWFPS then
                    G.SETTINGS.SHOWFPS = false
                    removeSelf(self, G.UI.BOX)
                end
            end)
        end
    )
end

MAKE_OPTIONS_MENU = function ()
    local t = UIBox.new(
        1000,
        500,
        {
            positions = {Vector.new(960,-200), Vector.new(960,540)},
            alignment = "Vertical",
            objPadding = 20,
            stopOnPause=false
        }
    )
    t:setActive()
    t:addChildren(UILabel.new(0,0,50,{alignment="center", text="Options", stopOnPause=false}))
    t:addChildren(UISlider.new(0,0,600,30,{showLabel=true, labelPos="top", labelText="Volume", labelColor="WHITE", sliderValue=G.SETTINGS.SOUND.VOLUME/100, stopOnPause=false}))
    local v = UIBox.new(
        400,
        50,
        {
            positions = {Vector.new(0,0), Vector.new(0,0)},
            alignment = "Horizontal",
            objPadding = 20,
            stopOnPause=false,
            parent = t,
            drawBox = false
        }
    )
    local leftButton = UIButton.new(0,0,50,80,{text="<", color="DARKERBLUE", action="displaymodeleft", parent=v})
    local displayButton = UIButton.new(0,0,200,80,{text="Borderless", color="DARKERBLUE", action="", parent=v})
    displayButton:addFunction(
        function (self)
            local modes = {"Fullscreen", "Windowed", "Borderless"}
            self:setText(modes[G.SETTINGS.SCREENVARIABLES.SCREENMODE])
        end
    )
    local rightButton = UIButton.new(0,0,50,80,{text=">", color="DARKERBLUE", action="displaymoderight", parent=v})


    v:addChildren(leftButton)
    v:addChildren(displayButton)
    v:addChildren(rightButton)
    t:addChildren(v)
    t:addFunction(function (self)
        G.SETTINGS.SOUND.VOLUME = self.children[2]:getValue() * 100
        TEsound.volume("main",self.children[2]:getValue())
    end)
    t:addFunction(function (self)
        if not G.SETTINGS.OPTIONSACTIVE then
            removeSelf(self, G.UI.BOX)
        end
    end)
end