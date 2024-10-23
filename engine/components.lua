--[[
    Font Manager - This object allows for easy creating of fonts with different font sizes and only creates the Font
    object when the program requests them
]]
FontManager = {}
FontManager.__index = FontManager

function FontManager.new()
    local self = setmetatable({}, FontManager)
    self.fontPaths = {}
    self.fonts = {}
    return self
end

function FontManager:addFont(fontName, fontPath)
    if self.fontPaths[fontName] == nil and love.filesystem.getInfo(fontPath) then
        self.fontPaths[fontName] = fontPath
    else
       print("Font alredy exists.") 
    end
end

function FontManager:gg(fontName, fontSize)
    return self.fonts[fontName] and self.fonts[fontName][fontSize] ~= nil
end

function FontManager:getFont(fontName, fontSize)
    if self.fontPaths[fontName] ~= nil then
        if not self:gg(fontName, fontSize) then
            self.fonts[fontName] = self.fonts[fontName] or {}  -- Ensure the fontName table exists
            self.fonts[fontName][fontSize] = love.graphics.newFont(self.fontPaths[fontName], fontSize)
        end
        return self.fonts[fontName][fontSize]
    else
        print("Font does not exist.") 
    end
end


--[[
    Color Manager - This object makes getting colors colors easyer and less combersome
]]
ColorManager = {}
ColorManager.__index = ColorManager

function ColorManager.new()
    local self = setmetatable({}, ColorManager)
    self.colors = {}
    for color in ipairs(colors) do
        self.colors[colors[color][1]] = love.math.colorFromBytes(colors[color][2], colors[color][3], colors[color][4])
    end
    return self
end

function ColorManager:addColor(colorName, rgbCode)
    if self.colors[colorName] == nil then
        self.colors[colorName] = {love.math.colorFromBytes(rgbCode[1], rgbCode[2], rgbCode[3])}
    else
       print("Color alredy exists.") 
    end
end

function ColorManager:getColor(colorName, transparency)
    local trans = transparency or 1
    if self.colors[colorName] ~= nil then
        local tmp =  self.colors[colorName]
        table.insert(tmp, #tmp+1, trans)
        return tmp
    else
       print("Color dosnt exist!") 
    end
end

-- Color Definitions
colors = {
    {"BLACK", {0, 0, 0}},
    {"WHITE", {255, 255, 255}},
    {"RED", {150, 16, 9}},
    {"GREEN", {48, 137, 54}},
    {"YELLOw", {204, 204, 63}},
    {"BLUE", {41, 46, 153}},
    {"LIGHTGRAY", {104, 101, 103}},
    {"DARKGRAY", {71, 69, 70}},
    {"BGCOLOR", {68, 119, 102}}
}

--[[
    Display Manager - This object deals with all the screen demention/monitor changes happening to the Game
    this will be helpfull when implementing the display settings menu
]]
DisplayManager = {}
DisplayManager.__index = DisplayManager

function DisplayManager.new()
    local self = setmetatable({}, DisplayManager)
    self.displayNum = love.window.getDisplayCount()
    self.displayModes = {}
    self.display = 1
    self.mode = 1
    self.fullscreen = true
    return self
end

function DisplayManager:getDisplayModes()
    for x in self.displayNum do
        table.insert(self.displayModes, #self.displayModes + 1, love.window.getFullscreenModes(x))
    end
end

function DisplayManager:getCenter()
    
end

function DisplayManager:update()
    local _,_, flags = love.window.getMode()
    if flags.display ~= self.display then
        self.display = flags.display
        push:setupScreen(_GAME_WIDTH, _GAME_HEIGHT, self.displayModes[self.display].width, self.displayModes[self.display].height, {fullscreen = self.fullscreen, resizable = false, canvas = false, pixelperfect = false, stretched=false})
    end
end

KeyboardManager = {}
KeyboardManager.__index = KeyboardManager

function KeyboardManager.new()
    local self = setmetatable({}, KeyboardManager)
    self.buffer = {}
    self.keyPressFlag = false
    return self
end

function KeyboardManager:getFullBuff()
    return self.buffer
end

function KeyboardManager:getBuffasStr()
    local tmp = ""
    for x=1, #self.buffer do
        tmp = tmp .. self.buffer[x]
    end
    return tmp
end

function KeyboardManager:getLastKeyPress()
    return self.buffer[#self.buffer]
end

function KeyboardManager:addKeyPress(keyPress)
    if #self.buffer == 10 then
        table.remove(self.buffer, 1)
    end
    table.insert(self.buffer, #self.buffer+1, keyPress)
    self.keyPressFlag = true
end

function KeyboardManager:ifIn(subString)
    
end