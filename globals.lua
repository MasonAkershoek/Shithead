GAME_VERSION = "0.0.6"

function Game:setGlobals()
    self.STATE = nil
end

-- Fonts
FONTMANAGER = FontManager.new()
FONTMANAGER:addFont("GAMEFONT", "resources/graphics/pixelFont.otf")

EVENTMANAGER = EventManager.new()

-- EventManager
EVENTMANAGER:on("play", play)
EVENTMANAGER:on("quit", function() G.quit() end)
EVENTMANAGER:on("playButton", function() G.playerPlayButton = true end)
EVENTMANAGER:on("setMainMenu", function() G.gamestate = "CLEANUP" end)
EVENTMANAGER:on("setCardTable", function() G:changeScreen(1) end)

-- Timer Stuff
TIMERMANAGER = TimerManager.new()

-- Instances
UI = {
    BOX = {}
}

-- Settings
SETTINGS = {
    showFPS = false,
}


G = Game.new()