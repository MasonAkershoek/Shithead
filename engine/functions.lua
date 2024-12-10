---@diagnostic disable: undefined-field
-- functions.lua

-- A simple function for checking if a value is contained in a list

--- This function checks to see if a value <value> is inside a given table
---@param value any
---@param list table
function ifIn(value, list)
    for x = 1, #list do
        if value == list[x] then
            return true
        end
    end
    return false
end

--- Takes in a table of objects that all contain a draw function and calls them in the order they appear in the list
---@param list table
function drawList(list)
    if #list ~= 0 then
        for x = 1, #list do
            list[x]:draw()
        end
    end
end

--- Takes in a table of objects that all contain an update function and calls them in the order they appear in the list
---@param list table
---@param dt integer
function updateList(list, dt)
    if #list ~= 0 then
        for x = 1, #list do
            list[x]:update(dt)
        end
    end
end

--- Takes two vectors and calculates the distance between them
---@param newPos Vector
---@param currentPos Vector
---@return integer
function calcDistance(newPos, currentPos)
    local dirx = newPos.x - currentPos.x
    local diry = newPos.y - currentPos.y
    return math.sqrt((dirx ^ 2) + (diry ^ 2))
end

-- Move somewhere else, This function is to spesific to shithead to be in this file

--- This function checkks if a given card rank is a special card
---@param pCardRank any
---@param tCardRank any
---@return boolean
function checkCard(pCardRank, tCardRank)
    if ifIn(pCardRank, { 2, 5, 8, 10 }) then
        return true
    end
    if tCardRank == 5 then
        if pCardRank < tCardRank then return true end
    elseif pCardRank > tCardRank then
        return true
    end
    return false
end

--- This function sorts throiugh key presses to pass only the values requested
---@param keyPress string
---@return string
function convertKeyPress(keyPress)
    if #keyPress == 1 then
        return keyPress
    end
    if keyPress == "space" then return " " end
    if keyPress == "backspace" then return keyPress end
    return ""
end

function removeSelf(obj, tbl)
    for x, y in ipairs(tbl) do
        if y == obj then
            table.remove(tbl, x)
        end
    end
end

function addCardToHand(card, hand)

end

function initDisplay()
    G.SETTINGS.SCREENVARIABLES.DIPLAYNUM = love.window.getDisplayCount()
    for x = 1, G.SETTINGS.SCREENVARIABLES.DIPLAYNUM do
        table.insert(G.SETTINGS.SCREENVARIABLES.DISPLAY.name, love.window.getDisplayName(x))
        table.insert(G.SETTINGS.SCREENVARIABLES.DISPLAY.name, love.window.getDesktopDimensions(x))
    end
    local winWidth, winHeight = love.window.getDesktopDimensions(G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY)
    G.SETTINGS.SCREENVARIABLES.SCREENSCALE = 800 / _GAME_WIDTH
    G.SETTINGS.SCREENVARIABLES.YOFFSET = _GAME_HEIGHT - 600
    logger:log("ScreenScale: ", G.SETTINGS.SCREENVARIABLES.SCREENSCALE)
    local windowArgs = { vsync = G.SETTINGS.SCREENVARIABLES.VSYNC, display = G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY, msaa = 1, resizable=true }
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "borderless" then windowArgs.borderless = true end
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "fullscreen" then windowArgs.fullscreen = true end
    love.window.setMode(800, 600, windowArgs)
end

function applyDisplaySettings()
    local winWidth, winHeight = love.window.getDesktopDimensions(G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY)
    G.SETTINGS.SCREENVARIABLES.SCREENSCALE = winWidth / _GAME_WIDTH
    G.SETTINGS.SCREENVARIABLES.YOFFSET = _GAME_HEIGHT - winHeight
    logger:log("ScreenScale: ", G.SETTINGS.SCREENVARIABLES.SCREENSCALE)
    local windowArgs = { vsync = G.SETTINGS.SCREENVARIABLES.VSYNC, display = G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY, msaa = 1 }
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "borderless" then windowArgs.borderless = true end
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "fullscreen" then windowArgs.fullscreen = true end
    --love.window.updateMode(winWidth, winHeight, windowArgs)

end

function toGame(x, y)
    return (x / G.SETTINGS.SCREENVARIABLES.SCREENSCALE), (y / G.SETTINGS.SCREENVARIABLES.SCREENSCALE)
end

function sortByRank(cards)
    local tmp = nil
    local sorted = false
    for x = 1, #cards do
        sorted = false
        for y = 1, (cards - x) do
            if cards[y].rank < cards[y + 1].rank then
                tmp = cards[y]
                cards[y] = cards[y + 1]
                cards[y + 1] = tmp
                sorted = true
            end
        end
        if (sorted == false) then
            break
        end
    end
end

-- This function was written by localthunk and slightly modified by me
-- I plan to make more changes in the future
function bootManager(msg, progress)
    local w, h = love.window.getMode()
    love.graphics.push()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(lovecolors:getColor("SKYBLUE"))
    if progress > 0 then love.graphics.rectangle('fill', w / 2 - 150, h / 2 - 15, progress * 300, 30) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', w / 2 - 150, h / 2 - 15, 300, 30)
    love.graphics.pop()
    love.graphics.present()
    logger:log(msg, " : ", progress)
end
