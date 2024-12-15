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
            positions = { Vector.new(_GAME_WIDTH / 2, -200), Vector.new(_GAME_WIDTH / 2, _GAME_HEIGHT / 2) }
        }
    )
    t:setActive()
    t:addChildren(UILabel.new(0, 0, 50, { alignment = "center", text = "Menu" }))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Main Menu", color = "RED", action = "mainmenu" }))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Options", color = "RED", action = "options" }))
    t:addChildren(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Quit", color = "RED", action = "quit" }))
    t:addFunction(
        function(self)
            if G.SETTINGS.ESCAPEMENUACTIVE and G.KEYBOARDMANAGER:getLastKeyPress() == "escape" then
                G.SETTINGS.ESCAPEMENUACTIVE = false
                G.SETTINGS.PAUSED = false
                removeSelf(self, G.UI.BOX)
            end
        end
    )
end

-- UIDefinitions for the Main Menu

-- Definition for Demo Box
-- DemoDef = {
--     radius = 10,
--     padding = 10,
--     borderSize = 10,
--     alignment = "Horizontal",
--     positions = { Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, -200), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, 200) },
--     contents = { UILabel.new(
--         G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2,
--         G.SCREENVARIABLES["GAMEDEMENTIONS"].y / 2,
--         20,
--         {
--             alignment = "center",
--             text = "Thank you for play testing Shithead! " ..
--                 "This is the first play test release " ..
--                 "of the game so expect some bugs and " ..
--                 "missing features. Please feel free to " ..
--                 "send me any ideas for fetures that you " ..
--                 "would like to see in the game or " ..
--                 "problems you encounter during your test " ..
--                 "\n\nThanks - Mason"
--         }
--     )
--     }
-- }

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
    t:addChildren(UIButton.new(-100, -100, 200, 100, { radius = 10, text = "Options", color = "DARKERGREEN" }))
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
    for x=0, 6 do
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
            alignment = "Vertical"
        }
    )
    t:setActive()
    t:addChildren(UILabel.new(0,0,50,{alignment="center", text="Options"}))
    t:addChildren(UISlider.new(0,0,600,30,{showLabel=true, labelPos="top", labelText="Volume", labelColor="WHITE"}))
    t:addFunction(function (self)
        TEsound.volume("main",self.children[2]:getValue())
    end)
end