function START_MAIN_MENU()
    G.MAJORSTATE = G.MAJORSTATES.MAINMENU
    G.MINORSTATE = G.MINORSTATES.MAININTRO
    local menuArea = CardArea.new(960, 540, 1100, {})
    table.insert(G.CARDAREAS, menuArea)
    for letter = 1, #G.TILE do
        G.EVENTMANAGER:addEventToQueue(
            Event.new(
                function()
                    local suit = math.random(4)
                    local tmp = Card.new(1, 1, -150,
                        (G.SETTINGS.SCREENVARIABLES.DISPLAY.RESOLUTIONS[G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY][2] / 2))
                    tmp.cardFace = G.CARDGRAPHICS["CARDLETTERS"]
                        ["card" .. G.CARDSUITS[suit] .. string.upper(G.TILE[letter])]
                    tmp.active = false
                    tmp:startFlipping()
                    tmp:setPos(500, 200)
                    tmp:playSound()
                    tmp.mouseMoveable = true
                    table.insert(G.CARDAREAS[1].cards, tmp)
                end,
                {
                    trigger = "after",
                    delay = .1
                }
            )
        )
    end
    G.EVENTMANAGER:addEventToQueue(Event.new(MAKE_MAIN_MENU_BUTTON_BOX, { trigger = "after", delay = .5 }))
end
