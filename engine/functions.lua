---@diagnostic disable: undefined-field
-- functions.lua

-- A simple function for checking if a value is contained in a list
function ifIn(value, list)
    for x = 1, #list do
        if value == list[x] then
            return true
        end
    end
    return false
end

--- Takes in a table of objects that all contain a draw function and calls them in the order they appear in the list
function drawList(list)
    if #list ~= 0 then
        for x = 1, #list do
            list[x]:draw()
        end
    end
end

--- Takes in a table of objects that all contain an update function and calls them in the order they appear in the list
function updateList(list, dt)
    if #list ~= 0 then
        for x = 1, #list do
            list[x]:update(dt)
        end
    end
end

--- Takes two vectors and calculates the distance between them
function calcDistance(newPos, currentPos)
    local dirx = newPos.x - currentPos.x
    local diry = newPos.y - currentPos.y
    return math.sqrt((dirx ^ 2) + (diry ^ 2))
end

-- Move somewhere else, This function is to spesific to shithead to be in this file

--- This function checkks if a given card rank is a special card
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
function convertKeyPress(keyPress)
    if #keyPress == 1 then
        return keyPress
    end
    if keyPress == "space" then return " " end
    if keyPress == "backspace" then return keyPress end
    return ""
end

-- Removes self from a given table
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
    local width = _GAME_WIDTH
    local height = _GAME_HEIGHT
    local windowArgs = { vsync = G.SETTINGS.SCREENVARIABLES.VSYNC, display = G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY, msaa = 16, resizable=true }

    G.SETTINGS.SCREENVARIABLES.DIPLAYNUM = love.window.getDisplayCount()
    for x = 1, G.SETTINGS.SCREENVARIABLES.DIPLAYNUM do
        table.insert(G.SETTINGS.SCREENVARIABLES.DISPLAY.NAMES, love.window.getDisplayName(x))
        table.insert(G.SETTINGS.SCREENVARIABLES.DISPLAY.RESOLUTIONS, { love.window.getDesktopDimensions(x) })
    end

    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "windowed" then
        width = width * .95
        height = height * .95
    end

    G.SETTINGS.SCREENVARIABLES.SCREENSCALE = width / _GAME_WIDTH
    G.SETTINGS.SCREENVARIABLES.YOFFSET = _GAME_HEIGHT - height
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "borderless" then windowArgs.borderless = true end
    if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "fullscreen" then windowArgs.fullscreen = true end
    logger:log("MAS", width)
    love.window.setMode(width, height, windowArgs)
end

function applyDisplaySettings()
    local width,height,flags = love.window.getMode()
    local windowMode = "windowed"
    if flags.borderless == true then windowMode = "borderless" end
    if flags.fullscreen == true then windowMode = "fullscreen" end
    local windowArgs = {display = G.SETTINGS.SCREENVARIABLES.CURRENTDISPLAY}

    G.SETTINGS.SCREENVARIABLES.SCREENSCALE = width / _GAME_WIDTH
    local yScale = height / _GAME_HEIGHT
    G.SETTINGS.SCREENVARIABLES.YOFFSET = _GAME_HEIGHT - height

    if yScale < G.SETTINGS.SCREENVARIABLES.SCREENSCALE then G.SETTINGS.SCREENVARIABLES.SCREENSCALE = yScale end

    if windowMode ~= G.SETTINGS.SCREENVARIABLES.SCREENMODE then
        G.SETTINGS.SCREENVARIABLES.SCREENMODE = windowMode
        if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "borderless" then windowArgs.borderless = true end
        if G.SETTINGS.SCREENVARIABLES.SCREENMODE == "fullscreen" then windowArgs.fullscreen = true end
        love.window.updateMode(width,height,windowArgs)
    end
end

-- Coverts the mouse position to the scaled canves 
function toGame(x, y)
    local w,h,_ = love.window.getMode()
    local scale = G.SETTINGS.SCREENVARIABLES.SCREENSCALE
    local canvWidth = _GAME_WIDTH * scale
    local canvHeight = _GAME_HEIGHT * scale
    local xpad = (w-canvWidth)
    local ypad = (h-canvHeight)
    return (x/scale)-xpad/(scale*2), (y/scale)-ypad/(scale*2)
end

-- sorts a given list of cards by rank
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

function setDeadZones(items)
    if #items > 1 then
        for x = #items, 2, -1 do
            local deadZone = {}
            deadZone.t1 = items[x]:getPos("centerleft")
            deadZone.t2 = items[x - 1]:getPos("centerright")
            if deadZone.t1.x > deadZone.t2.x then
                items[x - 1]:setDeadZone(nil)
            end
            items[x - 1]:setDeadZone(deadZone)
        end
    end
end

-- Horizontaly align a given table of objects
function HAlign(container, items, immediate, args)
    local args = args or {}
    local immediate = immediate or false
    local spaceEvenly = args.spaceEvenly or false
    local padding = args.padding or 0
    local objPadding = args.objPadding or 0

    if not container then logger:lot("No container supplyed!") return end
    if not items then logger:log("No table of items supplyed!") return end
    if #items == 0 then logger:log("Table supplyed is empty.") return end

    local pos = container:getPos("centerleft")
    local size = container:getSize()

    local xpoints = 0
    local nextPoint = 0
    if spaceEvenly then
        xpoints = ((size.x) / (#items))
        nextPoint = pos.x + xpoints/2
    else
        nextPoint = (pos.x + items[1]:getWidth()/2) + padding
    end
    for x = 1, #items do
        if not immediate then
            items[x]:setPos((nextPoint), pos.y)
        else
            items[x]:setPosImidiate((nextPoint), pos.y)
        end
        if not spaceEvenly and items[x+1] then
            nextPoint = ((nextPoint + items[x]:getWidth()/2) + (items[x+1]:getWidth()/2)) + objPadding
        else
            nextPoint = nextPoint + xpoints
        end
    end
end

-- Virticly align a given table of objects
function VAlign(container, items, immediate, args)
    local args = args or {}
    local immediate = immediate or false
    local spaceEvenly = args.spaceEvenly or false
    local padding = args.padding or 0
    local objPadding = args.objPadding or 0

    if not container then logger:lot("No container supplyed!") return end
    if not items then logger:log("No table of items supplyed!") return end
    if #items == 0 then logger:log("Table supplyed is empty.") return end

    local pos = container:getPos("centertop")
    local size = container:getSize()

    local xpoints = 0
    local nextPoint = 0
    if spaceEvenly then
        xpoints = ((size.y) / (#items))
        nextPoint = pos.y + xpoints/2
    else
        nextPoint = (pos.y + items[1]:getHeight()/2) + padding
    end
    for x = 1, #items do
        if not immediate then
            items[x]:setPos(pos.x, nextPoint)
        else
            items[x]:setPosImidiate(pos.x, nextPoint)
        end
        if not spaceEvenly and items[x+1] then
            nextPoint = ((nextPoint + items[x]:getHeight()/2) + (items[x+1]:getHeight()/2)) + objPadding
        else
            nextPoint = nextPoint + xpoints
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
