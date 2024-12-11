function START_MAIN_MENU()
    G.MAJORSTATE = G.MAJORSTATES.MAINMENU
    G.MINORSTATE = G.MINORSTATES.MAININTRO
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
                end,
                {
                    trigger = "after",
                    delay = .1
                }
            )
        )
    end
    logger:log("MAMA: ", #G.EVENTMANAGER.queue)
    G.EVENTMANAGER:addEventToQueue(Event.new(MAKE_MAIN_MENU_BUTTON_BOX, { trigger = "after", delay = .5 }))
end
