-- Game Object
Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    -- Timer Manager
    self.TIMERMANAGER = TimerManager.new()

    -- EventManager
    self.EVENTMANAGER = EventManager.new()

    -- DisplayManager
    self.DISPLAYMANAGER = DisplayManager.new()

    -- ColorManager
    self.COLORMANAGER = ColorManager.new()

    -- FontManager
    self.FONTMANAGER = FontManager.new()
    self.FONTMANAGER:addFont("GAMEFONT", "resources/graphics/pixelFont.otf")

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


    -- GameFlags
    self.playerPlayButton = false
    self.turn = 0

    -- Game Screen
    self.gameScreen = 0
    self.GAMESTATES = {"DEAL", "TURN", "BURN", "PICKUP", "WIN"}
    self.gamestate = self.GAMESTATES[1]
    return self
end

function Game:initGameScreens()
    self.mainMenu = MainMenu.new()
    --self.cardTable = CardTable.new()
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

function Game:getColor(colorName, transparancy)
    transparancy = transparancy or 1
    local color = {}
    for key,value in pairs(self.COLORS) do
        if colorName == key then
            table.insert(color, self.COLORS[colorName].r) 
            table.insert(color, self.COLORS[colorName].g) 
            table.insert(color, self.COLORS[colorName].b)
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
    if G.gameScreen == 1 then
        self.cardTable:update(dt)
    else
        self.mainMenu:update(dt)
    end
    if love.keyboard.isDown("q") then
        love.event.quit()
    end
    self.EVENTMANAGER:update(dt)
    self.TIMERMANAGER:update(dt)

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
