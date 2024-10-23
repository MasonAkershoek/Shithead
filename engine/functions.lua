-- functions.lua

-- A simple function for checking if a value is contained in a list
function ifIn(value, list)
    for x=1, #list do
        if value == list[x] then
            return true
        end
    end
    return false
end

function drawList(list)
    if #list ~= 0 then 
        for x=1, #list do
            list[x]:draw()
        end
    end
end

function updateList(list, dt)
    if #list ~= 0 then 
        for x=1, #list do
            list[x]:update(dt)
        end
    end
end

function calcDistance(newPos, currentPos)
    local dirx = newPos.x - currentPos.x
    local diry = newPos.y - currentPos.y
    return math.sqrt((dirx^2) + (diry^2))
end

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

-- Event Callbacks
function play()
	G.mainMenu.exitFlag = true
end

function setMainMenu()
    self.buttonBox:setPos(nil,G.SCREENVARIABLES["GAMEDEMENTIONS"].y-200)
end

function convertKeyPress(keyPress)
    local letters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
    if ifIn(keyPress, letters) then
        return keyPress
    end
    if keyPress == "space" then  return " " end
    if keyPress == "backspace" then return keyPress end
    return ""
end