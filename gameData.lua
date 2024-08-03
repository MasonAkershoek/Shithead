-- Scaling Factors
function getScaleFactor(width, height)

end
scaleX = 1
scaleY = 1

-- Fonts
gameFont = love.graphics.newFont("graphics/pixelFont.otf", 20)
gameFont:setFilter("nearest","nearest")

-- Screen Data
screenWidth, screenHeight = love.graphics.getDimensions()

function updateScreenDimentions()
    screenWidth, screenHeight = love.graphics.getDimensions()
end

-- graphics


-- Audio 
music1 = love.audio.newSource("music/music2.mp3", "static")

Vector = {}
Vector.__index = Vector

function Vector.new(x,y)
    local self = setmetatable({}, Vector)
    self.x = x
    self.y = y
    return self
end

function Vector:changePos(x, y)
    self.x = x
    self.y = y
end

function Vector:checkDistance(otherVect, space)
    if self.x > (otherVect.x - space) and self.x < (otherVect.x + space) then
        if self.y > (otherVect.y - space) and self.y < (otherVect.y + space) then
            return true 
        end
    else
        return false
    end
end