-- Scaling Factors
function getScaleFactor(width, height)

end

-- Fonts
gameFont = love.graphics.newFont("pixelFont.otf", 20)
gameFont:setFilter("nearest","nearest")

-- Screen Data
screenWidth, screenHeight = love.graphics.getDimensions()

function updateScreenDimentions()
    screenWidth, screenHeight = love.graphics.getDimensions()
end

-- graphics
handContainer = love.graphics.newImage("handContainer.png")

