-- Game Object
Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)
    self:setGlobals()
    return self
end

function Game:setup()
    bootManager("Start up", "Load settings", .1)
    local saveSet = table.load("settings.shit")
    self.SETTINGS.SCREENVARIABLES.SCREENMODE = saveSet.SCREENVARIABLES.SCREENMODE
    print(self.SETTINGS.SCREENVARIABLES.SCREENMODE)

    bootManager("Load Settings", "Load Graphics", .3)
    self:getCardGraphics()
    bootManager("Load Graphics", "Load Sounds", .2)
    self:loadSounds()
    local saveSet = table.save(self.SETTINGS, "settings.shit")
end

function Game:createGameObj()
    local game = {
        turn = 0,
    }
end

function Game:nextTurn(flag)
    if not flag then
        self.turn = self.turn + 1
        logger:log("Next Players Turn: " .. self.turn)
    else
        if self.turn > #self.cardTable.opa.opponents + 1 then
            self.turn = 1
            logger:log("Resetting Turn Counter: " .. self.turn)
        end
    end
end

function Game:quit()
    logger:log("Total Time Played:", G.mainTimePassed)
    logger:close()
    love.event.quit()
end

function Game:loadSounds()
    self.SOUNDS = {}
    local soundPath = "resources/music/"
    for x, file in ipairs(love.filesystem.getDirectoryItems(soundPath)) do
        self.SOUNDS[string.sub(file, 1, #file - 4)] = love.sound.newSoundData(soundPath .. file)
    end
end

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
        self.CARDGRAPHICS["CARDBACKS"][imageName] = love.graphics.newImage(cardBackPath .. "/" .. file)
    end
    for _, file in ipairs(love.filesystem.getDirectoryItems(cardFacePath)) do
        local imageName = string.sub(file, 1, -5)
        self.CARDGRAPHICS["CARDFACES"][imageName] = love.graphics.newImage(cardFacePath .. "/" .. file)
    end
    for _, file in ipairs(love.filesystem.getDirectoryItems(cardLetterkPath)) do
        local imageName = string.sub(file, 1, -5)
        self.CARDGRAPHICS["CARDLETTERS"][imageName] = love.graphics.newImage(cardLetterkPath .. "/" .. file)
    end
end

function Game:updateDisplay()
    local _, _, flags = love.window.getMode()
    if flags.display ~= self.SETTINGS.SCREENVARIABLES["CURRENTDISPLAY"] then
        self.SCREENVARIABLES["CURRENTDISPLAY"] = flags.display
        self.SCREENVARIABLES["SCREENSIZE"].x, self.SCREENVARIABLES["SCREENSIZE"].y = love.window.getDesktopDimensions(
            flags.display)
        push:setupScreen(G.SCREENVARIABLES["GAMEDEMENTIONS"].x, G.SCREENVARIABLES["GAMEDEMENTIONS"].y,
            G.SCREENVARIABLES["SCREENSIZE"].x, G.SCREENVARIABLES["SCREENSIZE"].y,
            { fullscreen = G.SCREENVARIABLES["FULLSCREEN"], resizable = false, canvas = false, pixelperfect = false, stretched = false })
    end
end

function Game:update(dt)
    updateList(G.UI.BOX, dt)
    --self:updateDisplay()
end

function Game:draw()
    love.graphics.setBackgroundColor(lovecolors:getColor("BGCOLOR"))

    drawList(G.UI.BOX)
end
