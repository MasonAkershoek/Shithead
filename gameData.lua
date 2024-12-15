-- Game Object
Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)
    self:setGlobals()
    return self
end

function Game:setup()
    bootManager("Starting up", .1)

    -- Canves
    self.drawSpace = love.graphics.newCanvas(_GAME_WIDTH, _GAME_HEIGHT)

    -- Import settings
    bootManager("Loading Settings", .2)
    local saveSet = table.load("settings.shit")
    if saveSet then
        self.SETTINGS.SCREENVARIABLES.SCREENMODE = saveSet.SCREENVARIABLES.SCREENMODE
        self.SETTINGS.SHOWFPS = saveSet.SHOWFPS
        self.SETTINGS.SCREENVARIABLES.VSYNC = saveSet.SCREENVARIABLES.VSYNC
        if self.SETTINGS.SHOWFPS then
            MAKE_FPS_HUD()
        end
        if saveSet.SCREENVARIABLES.CURRENTDISPLAY <= love.window.getDisplayCount() then
            self.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY = saveSet.SCREENVARIABLES.CURRENTDISPLAY
        end
    end
    os.remove("shithead.shit")

    bootManager("init Display", .3)
    initDisplay()
    love.graphics.setDefaultFilter("linear","linear",10)
    logger:log(love.graphics.getDefaultFilter())
    love.graphics.setLineStyle("rough")

    bootManager("Loading Graphics", .4)
    self:getCardGraphics()

    bootManager("Loading Sounds", .5)
    self:loadSounds()

    bootManager("Loading Shader Scripts", .6)
    self:loadShaders()

    START_MAIN_MENU()

    bootManager("Done!", 1)

    TEsound.playLooping(self.SOUNDS["music2"],"static","main")
    MAKE_OPTIONS_MENU()
end

function Game:createGameObj()
    local game = {
        turn = 0,
        opponents = {}
    }
end

-- Quit the game
function Game:quit()
    logger:log("Total Time Played:", G.mainTimePassed)
    logger:close()
    table.save(self.SETTINGS, "settings.shit")
    love.event.quit()
end

-- Load all game sounds
function Game:loadSounds()
    self.SOUNDS = {}
    local soundPath = "resources/music/"
    for x, file in ipairs(love.filesystem.getDirectoryItems(soundPath)) do
        self.SOUNDS[string.sub(file, 1, #file - 4)] = love.sound.newSoundData(soundPath .. file)
    end
end

-- Load all game graphics
function Game:getCardGraphics()
    self.CARDGRAPHICS = {}
    self.CARDGRAPHICS["CARDFACES"] = {}
    self.CARDGRAPHICS["CARDBACKS"] = {}
    self.CARDGRAPHICS["CARDLETTERS"] = {}
    local cardFacePath = "resources/graphics/cards/cardFaces"
    local cardLetterkPath = "resources/graphics/cards/letters"
    local cardBackPath = "resources/graphics/cards/cardBacks"
    for _, file in ipairs(love.filesystem.getDirectoryItems(cardBackPath)) do
        local imageName = string.sub(file, 1, -5)
        self.CARDGRAPHICS["CARDBACKS"][imageName] = love.graphics.newImage(cardBackPath .. "/" .. file,{mipmaps = true, dpiscale = 1})
    end
    for _, file in ipairs(love.filesystem.getDirectoryItems(cardFacePath)) do
        local imageName = string.sub(file, 1, -5)
        self.CARDGRAPHICS["CARDFACES"][imageName] = love.graphics.newImage(cardFacePath .. "/" .. file,{mipmaps = true, dpiscale = 1})
    end
    for _, file in ipairs(love.filesystem.getDirectoryItems(cardLetterkPath)) do
        local imageName = string.sub(file, 1, -5)
        self.CARDGRAPHICS["CARDLETTERS"][imageName] = love.graphics.newImage(cardLetterkPath .. "/" .. file,{mipmaps = true, dpiscale = 1})
    end
end

-- Load Game Shaders
function Game:loadShaders()
    self.SHADERS = {}
    local path = "shaders/"
    for x, file in ipairs(love.filesystem.getDirectoryItems(path)) do
        self.SHADERS[string.sub(file, 1, #file - 5)] = love.graphics.newShader(path .. file)
        logger:log(string.sub(file, 1, #file - 5))
    end
end

function Game:update(dt)
    applyDisplaySettings()
    updateList(G.UI.BOX, dt)
    updateList(G.CARDS, dt)
    for _,area in pairs(G.CARDAREAS) do 
        area:update(dt)
    end
    for _, func in ipairs(self.BUFFEREDFUNCS) do
        func()
    end
    self.BUFFEREDFUNCS = {}
end

function Game:draw()
    love.graphics.setBackgroundColor(lovecolors:getColor("BGCOLOR"))

    love.graphics.setCanvas(self.drawSpace)
    love.graphics.clear()

    for _,area in pairs(G.CARDAREAS) do 
        area:draw()
    end
    drawList(G.CARDS)
    drawList(G.UI.BOX)

	local x, y = love.mouse.getPosition()
	x,y = toGame(x,y)
	love.graphics.setColor(lovecolors:getColor("BLUE"))
	love.graphics.rectangle("fill", x-5, y-5, 10, 10)
	love.graphics.setColor({ 1, 1, 1, 1 })

    love.graphics.setCanvas()

    local x,y,_ = love.window.getMode()

    love.graphics.draw(self.drawSpace, x/2,y/2,0,G.SETTINGS.SCREENVARIABLES.SCREENSCALE,G.SETTINGS.SCREENVARIABLES.SCREENSCALE,_GAME_WIDTH/2,_GAME_HEIGHT/2)
    love.graphics.setShader()
end
