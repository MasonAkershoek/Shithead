-- UIDefinitions for the CardTable

-- Definition for Win Box
WINBOXDEF = {
    radius=10, 
    padding=10, 
    borderSize=10,
    alignment="right",
    positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,-300),Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)},
    contents={
        UILabel.new(
        G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,
        G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2,
        20,
        {
            alignment="center",
            text=" WINS!!!\n"
        }
        ),
        UIButton.new(0,0,200,100,{radius=10, text="Main Menu", color="DARKERRED",action="setMainMenu"})
    }
}

MAKE_WIN_BOX = function ()
    local t = UIBox.new(
        600,
        350,
        {
            radius=10, 
            padding=10, 
            borderSize=10,
            alignment="right",
            positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,-300),Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)}
        }
    )

    t:addContent(
        UILabel.new(
        G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2,
        G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2,
        20,
        {
            alignment="center",
            text=" WINS!!!\n"
        }
        )
    )
    t:addContent(
        UIButton.new(0,0,200,100,{radius=10, text="Main Menu", color="DARKERRED",action="setMainMenu"})
    )
    return t
end

DEBUGBOXDEF = {
    radius = 10,
    padding = 0,
    borderSize = 10,
    alignment = "Vertical",
    positions={Vector.new(-500, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2),Vector.new(350, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)},
    contents={
        UILabel.new(0,0,50,{alignment="center", text="Debug Menu"}),
        UILabel.new(0,0,20,{alignment="center", text="player1: "}),
        UILabel.new(0,0,20,{alignment="center",text="Empty"}),
        UILabel.new(0,0,20,{alignment="center", text="player2: "}),
        UILabel.new(0,0,20,{alignment="center",text="Empty"}),
        UILabel.new(0,0,20,{alignment="center", text="player3: "}),
        UILabel.new(0,0,20,{alignment="center",text="Empty"}),
        UILabel.new(0,0,20,{alignment="center", text="player4: "}),
        UILabel.new(0,0,20,{alignment="center",text="Empty"})
    }
}

MAKE_DEBUG_BOX = function ()
    local t = UIBox.new(
        600,
        350,
        {
            radius = 10,
            padding = 0,
            borderSize = 10,
            alignment = "Vertical",
            positions={Vector.new(-500, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2),Vector.new(350, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)},
        }
    );
    t:setActive()
    t:addContent(UILabel.new(0,0,50,{alignment="center", text="Debug Menu"}))
    for _,op in ipairs(G.cardTable.opa.opponents) do
        t:addContent(UILabel.new(0,0,20,{alignment="center", text=op.name..": "}))
        t:addContent(UILabel.new(0,0,20,{alignment="center",text="Empty"}))
    end

    t:addFunction(
        function (self)
            local index = 1
            for x=3, #self.contents, 2 do
                local cards = ""
                for y,card in ipairs(G.cardTable.opa.opponents[index].hand) do
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
        function (self)
            if SETTINGS.debugBoxActive and G.KEYBOARDMANAGER:getLastKeyPress() == "k" then
                removeSelf(self, UI.BOX)
                SETTINGS.debugBoxActive = false
            end
        end
    )
    logger:log("made debug Box")
    SETTINGS.debugBoxActive = true
end

MAKE_ESC_MENU = function ()
    local t = UIBox.new(
        400,
        700,
        {
            radius=10, 
            padding=10, 
            borderSize=10,
            alignment="Vertical",
            positions={Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, -200), Vector.new(G.SCREENVARIABLES["GAMEDEMENTIONS"].x/2, G.SCREENVARIABLES["GAMEDEMENTIONS"].y/2)}
        }
    )
    t:setActive()
    t:addContent(UILabel.new(0,0, 50, {alignment="center", text="Menu"}))
    t:addContent(UIButton.new(0,0,200,100,{radius=10, text="Main Menu", color="RED", action="mainmenu"}))
    t:addContent(UIButton.new(0,0,200,100,{radius=10, text="Options", color="RED", action="options"}))
    t:addContent(UIButton.new(0,0,200,100,{radius=10, text="Quit", color="RED", action="quit"}))
    t:addFunction(
        function (self)
            if SETTINGS.escMenuActive and G.KEYBOARDMANAGER:getLastKeyPress() == "escape" then
                SETTINGS.escMenuActive = false
                SETTINGS.paused = false
                removeSelf(self, UI.BOX)
            end
        end
    )
    logger:log("Made esc menu", " ", #UI.BOX)
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
        UIButton.new(0,0,200,100, {radius=10, text="Play", color="DARKERBLUE", action="play"}),
        UIButton.new(0,0,200,100, {radius=10, text="Multiplayer", color="DARKERYELLOW"}),
        UIButton.new(0,0,200,100, {radius=10, text="Options", color="DARKERGREEN"}),
        UIButton.new(0,0,200,100, {radius=10, text="Quit", color="DARKERRED",action="quit"})
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