-- Game Object
Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    -- Main Game Timer
    self.mainGameTimer = Timer.new(1)
    self.mainTimePassed = 0

    -- Timer Manager
    self.TIMERMANAGER = TimerManager.new()

    -- EventManager
    self.EVENTMANAGER = EventManager.new()
    self.EVENTMANAGER:on("play", play)
	self.EVENTMANAGER:on("quit", function() self:quit() end)
	self.EVENTMANAGER:on("playButton", function() G.playerPlayButton = true end)
    self.EVENTMANAGER:on("setMainMenu", function() G:changeScreen(0) end)
    self.EVENTMANAGER:on("setCardTable", function() G:changeScreen(1) end)

    -- DisplayManager
    self.DISPLAYMANAGER = DisplayManager.new()

    -- ColorManager
    self.COLORMANAGER = ColorManager.new()

    -- FontManager
    self.FONTMANAGER = FontManager.new()
    self.FONTMANAGER:addFont("GAMEFONT", "resources/graphics/pixelFont.otf")

    -- KeyboardStuff
    self.KEYBOARDMANAGER = KeyboardManager.new()

    -- Screen Variables
    local _,_, flags = love.window.getMode()
    self.SCREENVARIABLES = {}
    self.SCREENVARIABLES["SCREENNUM"] = love.window.getDisplayCount()
    self.SCREENVARIABLES["GAMEDEMENTIONS"] = {}
    self.SCREENVARIABLES["GAMEDEMENTIONS"].x = 1920
    self.SCREENVARIABLES["GAMEDEMENTIONS"].y = 1080
    self.SCREENVARIABLES["SCREENSIZE"] = {}
    self.SCREENVARIABLES["SCREENSIZE"].x, self.SCREENVARIABLES["SCREENSIZE"].y = love.window.getDesktopDimensions(flags.display)
    self.SCREENVARIABLES["FULLSCREEN"] = true
    self.SCREENVARIABLES["DISPLAYCOUNT"] = love.window.getDisplayCount()
    self.SCREENVARIABLES["CURRENTDISPLAY"] = flags.display


    -- Graphics
    self.CARDGRAPHICS = {}
    self.CARDGRAPHICS["CARDFACES"] = {}
    self.CARDGRAPHICS["CARDBACKS"] = {}
    self.CARDGRAPHICS["CARDLETTERS"] = {}
    self:getCardGraphics()

    -- Shaders
    shadercode = love.filesystem.read("shaders/darkcard.glsl")
    self.darkenShader = love.graphics.newShader(shadercode)

    -- Fonts
    self.GAMEFONT = love.graphics.newFont("resources/graphics/pixelFont.otf", 20)
    self.GAMEFONT:setFilter("linear","nearest")
    love.graphics.setLineStyle("rough")

    -- Colors
    self.COLORS = self:initColors()

    -- Sounds
    self.MUSIC1 = "resources/music/music2.mp3"
    self.DEALSOUND = "resources/music/card1.ogg"

    -- Card Constants
    self.CARDSPEED = 3000
    self.CARDSUITS = {"Spades", "Diamonds", "Clubs", "Hearts"}
    self.SPECIALCARDS = {2,5,8,10}


    -- GameFlags
    self.gameFlag = 
    {
        playerPlayButton = false,
        escMenu = false
    }
    self.playerPlayButton = false
    self.turn = 0

    -- Game Screen
    self.gameScreen = 0
    self.GAMESTATES = {"DEAL", "TURN", "BURN", "PICKUP", "WIN"}
    self.gamestate = self.GAMESTATES[1]
    self:updateDisplay()
    return self
end

function Game:nextTurn(flag)
    if not flag then
        self.turn = self.turn + 1
        logger:log("Next Players Turn: "..self.turn)
    else
        if self.turn > #self.cardTable.opa.opponents + 1 then
            self.turn = 1
            logger:log("Resetting Turn Counter: "..self.turn)
        end 
    end
end

function Game:setState(newState)
    self.gamestate = self.GAMESTATES[newState]
    logger:log("Game state set to: "..self.gamestate)
end

function Game:initGameScreens()
    self.mainMenu = MainMenu.new()
    self.cardTable = CardTable.new()
end

function Game:quit()
    logger:log("Total Time Played:",G.mainTimePassed)
    logger:close()
    love.event.quit()
end

function Game:loadSounds()

end

function Game:getCardGraphics()
    local cardFacePath = "resources/graphics/cards/cardFaces"
    local cardLetterkPath = "resources/graphics/cards/letters"
    local cardBackPath = "resources/graphics/cards/cardBacks"    
    for _,file in ipairs(love.filesystem.getDirectoryItems(cardBackPath)) do
        local imageName = string.sub(file,1, -5)
        self.CARDGRAPHICS["CARDBACKS"][imageName] = love.graphics.newImage(cardBackPath .. "/" .. file)
    end
    for _,file in ipairs(love.filesystem.getDirectoryItems(cardFacePath)) do
        local imageName = string.sub(file,1, -5)
        self.CARDGRAPHICS["CARDFACES"][imageName] = love.graphics.newImage(cardFacePath .. "/" .. file)
    end
    for _,file in ipairs(love.filesystem.getDirectoryItems(cardLetterkPath)) do
        local imageName = string.sub(file,1, -5)
        self.CARDGRAPHICS["CARDLETTERS"][imageName] = love.graphics.newImage(cardLetterkPath .. "/" .. file)
    end
    logger:log("Card Graphics Loaded")
end

function Game:initColors()
    local colors = {}
    -- Colors 
    colors["BLACK"] = {}
    colors["BLACK"].r = 0
    colors["BLACK"].g = 0
    colors["BLACK"].b = 0

    colors["WHITE"] = {}
    colors["WHITE"].r = 255
    colors["WHITE"].g = 255
    colors["WHITE"].b = 255

    colors["RED"] = {}
    colors["RED"].r, colors["RED"].g, colors["RED"].b = love.math.colorFromBytes(150,16,9)

    colors["GREEN"] = {}
    colors["GREEN"].r, colors["GREEN"].g, colors["GREEN"].b = love.math.colorFromBytes(48,137,54)

    colors["YELLOW"] = {}
    colors["YELLOW"].r, colors["YELLOW"].g, colors["YELLOW"].b = love.math.colorFromBytes(204,204,63)

    colors["BLUE"] = {}
    colors["BLUE"].r, colors["BLUE"].g, colors["BLUE"].b = love.math.colorFromBytes(41,46,153)

    colors["LIGHTGRAY"] = {}
    colors["LIGHTGRAY"].r, colors["LIGHTGRAY"].g, colors["LIGHTGRAY"].b = love.math.colorFromBytes(104,101,103)

    colors["DARKGRAY"] = {}
    colors["DARKGRAY"].r, colors["DARKGRAY"].g, colors["DARKGRAY"].b = love.math.colorFromBytes(71,69,70)

    colors["BGCOLOR"] = {}
    colors["BGCOLOR"].r, colors["BGCOLOR"].g, colors["BGCOLOR"].b = love.math.colorFromBytes(68,119,102)
    return colors
end

-- Make some changes so this function isnt called so often
function Game:getColor(colorName, transparancy, darken)
    transparancy = transparancy or 1
    local color = {}
    local darken = darken or 0
    for key,value in pairs(self.COLORS) do
        if colorName == key then
            table.insert(color, self.COLORS[colorName].r-darken) 
            table.insert(color, self.COLORS[colorName].g-darken) 
            table.insert(color, self.COLORS[colorName].b-darken)
            table.insert(color, transparancy)
            return color
        end
    end
    print("Color ", colorName, " not found!")
    return nil
end

function Game:updateDisplay()
    local _,_, flags = love.window.getMode()
    if flags.display ~= self.SCREENVARIABLES["CURRENTDISPLAY"] then
        self.SCREENVARIABLES["CURRENTDISPLAY"] = flags.display
        self.SCREENVARIABLES["SCREENSIZE"].x, self.SCREENVARIABLES["SCREENSIZE"].y = love.window.getDesktopDimensions(flags.display)
        push:setupScreen(G.SCREENVARIABLES["GAMEDEMENTIONS"].x, G.SCREENVARIABLES["GAMEDEMENTIONS"].y, G.SCREENVARIABLES["SCREENSIZE"].x, G.SCREENVARIABLES["SCREENSIZE"].y, {fullscreen = G.SCREENVARIABLES["FULLSCREEN"], resizable = false, canvas = false, pixelperfect = false, stretched=false})
    end
end

function Game:update(dt)
    self:updateDisplay()
    self.mainGameTimer:update(dt)
    if self.mainGameTimer:isExpired() then self.mainTimePassed = self.mainTimePassed + 1 self.mainGameTimer:reset() end
    if G.gameScreen == 1 then
        self.cardTable:update(dt)
    else
        self.mainMenu:update(dt)
    end
    self.EVENTMANAGER:update(dt)
    self.TIMERMANAGER:update(dt)
end

function Game:changeScreen(index)
    self.gameScreen = index
    if index == 1 then
        self.mainMenu = nil
        self.mainMenu = MainMenu.new()
    else
        self.cardTable = nil
        self.cardTable = CardTable.new()
    end
    logger:log("Screen Changed to " .. index)
end

function Game:draw()
    push:start()
    push:setBorderColor({G.COLORS["BGCOLOR"].r, G.COLORS["BGCOLOR"].g, G.COLORS["BGCOLOR"].b})
    if self.gameScreen == 1 then
        self.cardTable:draw()
    else
        self.mainMenu:draw()
    end
	push:finish()
end


G = Game.new()
