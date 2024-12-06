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