-- functions.lua

-- A simple function for checking if a value is contained in a list

--- This function checks to see if a value <value> is inside a given table
---@param value any
---@param list table
function ifIn(value, list)
    for x=1, #list do
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
        for x=1, #list do
            list[x]:draw()
        end
    end
end

--- Takes in a table of objects that all contain an update function and calls them in the order they appear in the list
---@param list table
---@param dt integer
function updateList(list, dt)
    if #list ~= 0 then 
        for x=1, #list do
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
    return math.sqrt((dirx^2) + (diry^2))
end

-- Depreciate love has a built in function for this
function getOS()
	-- ask LuaJIT first
	if jit then
		return jit.os
	end

	-- Unix, Linux variants
	local fh,err = assert(io.popen("uname -o 2>/dev/null","r"))
	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end

-- Move somewhere else, This function is to spesific to shithead to be in this file

--- This function checkks if a given card rank is a special card
---@param pCardRank any
---@param tCardRank any
---@return boolean
function checkCard(pCardRank, tCardRank)
    if ifIn(pCardRank, {2,5,8,10}) then
        return true
    end
    if tCardRank == 5 then
        if pCardRank < tCardRank then return true end
    elseif pCardRank > tCardRank then
        return true
    end
    return false
end

-- Event Callbacks -- Depreciate
function play()
	G.mainMenu.exitFlag = true
end

--- This function sorts throiugh key presses to pass only the values requested
---@param keyPress string
---@return string
function convertKeyPress(keyPress)
    if #keyPress ==1 then
        return keyPress
    end
    if keyPress == "space" then  return " " end
    if keyPress == "backspace" then return keyPress end
    return ""
end

function setMainMenu()
    G.gameScreen = 0
end