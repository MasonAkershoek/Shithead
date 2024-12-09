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
    t:addContent(UILabel.new(0, 0, 20, { alignment = "center", text = " WINS!!!\n" }))
    t:addContent(UIButton.new(0, 0, 200, 100, {
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
                removeSelf(self, UI.BOX)
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
    t:addContent(UILabel.new(0, 0, 50, { alignment = "center", text = "Debug Menu" }))
    for _, op in ipairs(G.cardTable.opa.opponents) do
        t:addContent(UILabel.new(0, 0, 20, { alignment = "center", text = op.name .. ": " }))
        t:addContent(UILabel.new(0, 0, 20, { alignment = "center", text = "Empty" }))
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
                removeSelf(self, UI.BOX)
                G.SETTINGS.debugBoxActive = false
            end
        end
    )
    G.SETTINGS.debugBoxActive = true
end

MAKE_ESC_MENU = function()
    local t = UIBox.new(
        400,
        700,
        {
            radius = 10,
            padding = 10,
            borderSize = 10,
            alignment = "Vertical",
            positions = { Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, -200), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x / 2, G.SCREENVARIABLES["GAMEDEMENTIONS"].y / 2) }
        }
    )
    t:setActive()
    t:addContent(UILabel.new(0, 0, 50, { alignment = "center", text = "Menu" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Main Menu", color = "RED", action = "mainmenu" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Options", color = "RED", action = "options" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Quit", color = "RED", action = "quit" }))
    t:addFunction(
        function(self)
            if G.SETTINGS.escMenuActive and G.KEYBOARDMANAGER:getLastKeyPress() == "escape" then
                G.SETTINGS.escMenuActive = false
                G.SETTINGS.paused = false
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
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Play", color = "DARKERBLUE", action = "play" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Multiplayer", color = "DARKERYELLOW" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Options", color = "DARKERGREEN" }))
    t:addContent(UIButton.new(0, 0, 200, 100, { radius = 10, text = "Quit", color = "DARKERRED", action = "quit" }))
end

MAKE_INTRO_CARDS = function()

end

MAKE_FPS_HUD = function()
    local t = UIBox.new(
        100,
        100,
        {
            drawBox = false,
            positions = { Vector.new(-200, 100), Vector.new(100, 100) }
        }
    )
    t:setActive()
    logger:log(t.drawBox)
    t:addContent(UILabel.new(0, 0, 20, { alignment = "center" }))
    t:addFunction(
        function(self)
            self.contents[1]:setText(love.timer.getFPS())
        end
    )
    t:addFunction(
        function(self)
            table.insert(G.BUFFEREDFUNCS, function ()
                if G.KEYBOARDMANAGER:getLastKeyPress() == "f3" and G.SETTINGS.SHOWFPS then
                    G.SETTINGS.SHOWFPS = false
                    logger:log("Close FPS")
                    removeSelf(self, G.UI.BOX)
                end
            end)
        end
    )
end
