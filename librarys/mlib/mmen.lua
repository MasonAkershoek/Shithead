-- mmen is a small collection of variouse data managers for love2d


-- Font Manager - This object allows for easy creating of fonts with different font sizes and only creates the Font
-- object when the program requests them
FontManager = {}
FontManager.__index = FontManager

--- FunctionManagerConstructor
---@return FontManager
function FontManager.new()
    local self = setmetatable({}, FontManager)
    self.fontPaths = {}
    self.fonts = {}
    return self
end 

--- Class: addFont
--- addFont will add a font to the list of available fonts. If the font already exists then it is ignored
--- otherwise it is added to the font list with a default font size of 20
---@param fontName string
---@param fontPath string
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
    Display Manager - This object deals with all the screen demention/monitor changes happening to the Game
    this will be helpfull when implementing the display settings menu
]]
DisplayManager = {}
DisplayManager.__index = DisplayManager

function DisplayManager.new()
    local self = setmetatable({}, DisplayManager)
    self.displayNum = love.window.getDisplayCount()
    self.displayModes = self:getDisplayModes()
    self.currentDisplaySize = Vector.new(love.window.getDesktopDimensions())
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
    return Vector.new(self.screenWidth/2, self.screenHeight/2)
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

function KeyboardManager:getLastKeyPress(waitForNextKeyPress)
    local waitForNextKeyPress = waitForNextKeyPress or false
    if waitForNextKeyPress then
        if self.keyPressFlag then
            return self.buffer[#self.buffer]
        end
        return nil
    else
        return self.buffer[#self.buffer]
    end
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

-- Timer
Timer = {}
Timer.__index = Timer

function Timer.new(newTime, ...)
    local self = setmetatable({}, Timer)

    self.T = "Timer"

    self.time = newTime or 1
    self.ogTime = newTime
    self.stopped = false
    self.expired = false
    if ... ~= nil then 
        self.callback = ...
    end
    return self
end

function Timer:reset(newTime)
    newTime = newTime or self.ogTime
    self.time = newTime
    self.expired = false
    self.stopped = false
end

function Timer:stopTimer()
    self.stopped = true
    self.time = 0
    self.expired = false
end

function Timer:isExpired()
    return self.expired
end

function Timer:isStopped()
    if self.stopped then 
        return true 
    else 
        return false 
    end
end

function Timer:start()
    self:reset()
    self.stopped = false
end

function Timer:update(dt)
    if not self.stopped then
        if self.time < 0 and not self.expired then 
            self.expired = true
            if self.callback ~= nil then
                callback(self.callback)
            end
            return self.expired
        else
            self.time = self.time - dt 
        end
    end
end

-- Timer Manager
--[[
    The Timer Manager is good for one time timers used on the system
]]
TimerManager = {}
TimerManager.__index = TimerManager

function TimerManager.new()
    local self = setmetatable({}, TimerManager)

    self.T = "TimerManager"
    self.timers = {}
    return self
end

function TimerManager:addTimer(time)
    print("Time: ", time)
    local timer = Timer.new(time)
    table.insert(self.timers, timer)
    return timer
end

function TimerManager:checkExpire(index)
    if self.timers[index]:isExpired() then
        table.remove(self.timers[index])
        return true
    end
    return false
end

function TimerManager:update(dt)
    for x=1, #self.timers do
        self.timers[x]:update(dt)
    end
end