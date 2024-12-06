-- Love Colors v0.1

-- Color Library for love2d to make getting colors for setColor calls easyer

LoveColors={}
LoveColors.__index = LoveColors

--- lovecolors constructor
---@return table
function LoveColors.new()
    local self = setmetatable({}, LoveColors)
    self.colors = {}
    self:setColors()
    return self
end

--- This function returns a table that can be passed into the love.graphics.setColor function
---@param colorName string
---@param oppacity integer "0-1"
---@param tintScale integer "<0-1> If you dont want to use this value but want to shade pass nil"
---@param shadeScale integer "<0-1>"
---@return table
function LoveColors:getColor(colorName, oppacity, tintScale, shadeScale)
    local oppacity = oppacity or 1
    local tintScale = tintScale or nil
    local shadeScale = shadeScale or nil
    local color = {}
    color.r = self.colors[colorName].r
    color.g = self.colors[colorName].g
    color.b = self.colors[colorName].b

    if tintScale then
        color.r = (color.r + ((255-color.r) * tintScale))
        color.g = (color.g + ((255-color.g) * tintScale))
        color.b = (color.b + ((255-color.b) * tintScale))
        
    elseif shadeScale then
        color.r = color.r * (1 - shadeScale)
        color.g = color.g * (1 - shadeScale)
        color.b = color.b * (1 - shadeScale)
    end

    color.r, color.g, color.b = love.math.colorFromBytes(color.r, color.g, color.b)
    return {color.r, color.g, color.b, oppacity}
end

function LoveColors:setColors(r,g,b)
    self.colors["BGCOLOR"] = {}
    self.colors["BGCOLOR"].r = 68
    self.colors["BGCOLOR"].g = 119
    self.colors["BGCOLOR"].b = 102

    self.colors["RED"] = {}
    self.colors["RED"].r = 255
    self.colors["RED"].g = 0
    self.colors["RED"].b = 0

    self.colors["DARKERRED"] = {}
    self.colors["DARKERRED"].r = 150
    self.colors["DARKERRED"].g = 16
    self.colors["DARKERRED"].b = 9

    self.colors["GREEN"] = {}
    self.colors["GREEN"].r = 0
    self.colors["GREEN"].g = 255
    self.colors["GREEN"].b = 0

    self.colors["DARKERGREEN"] = {}
    self.colors["DARKERGREEN"].r = 48
    self.colors["DARKERGREEN"].g = 137
    self.colors["DARKERGREEN"].b = 54

    self.colors["BLUE"] = {}
    self.colors["BLUE"].r = 0
    self.colors["BLUE"].g = 0
    self.colors["BLUE"].b = 255

    self.colors["DARKERBLUE"] = {}
    self.colors["DARKERBLUE"].r = 41 
    self.colors["DARKERBLUE"].g = 46
    self.colors["DARKERBLUE"].b = 153

    self.colors["ORANGE"] = {}
    self.colors["ORANGE"].r = 255
    self.colors["ORANGE"].g = 108
    self.colors["ORANGE"].b = 0

    self.colors["PINK"] = {}
    self.colors["PINK"].r = 255
    self.colors["PINK"].g = 129
    self.colors["PINK"].b = 192

    self.colors["PURPLE"] = {}
    self.colors["PURPLE"].r = 126
    self.colors["PURPLE"].g = 30
    self.colors["PURPLE"].b = 156

    self.colors["YELLOW"] = {}
    self.colors["YELLOW"].r = 255
    self.colors["YELLOW"].g = 255
    self.colors["YELLOW"].b = 20

    self.colors["DARKERYELLOW"] = {}
    self.colors["DARKERYELLOW"].r = 204
    self.colors["DARKERYELLOW"].g = 204
    self.colors["DARKERYELLOW"].b = 63

    self.colors["LIGHTBLUE"] = {}
    self.colors["LIGHTBLUE"].r = 149
    self.colors["LIGHTBLUE"].g = 208
    self.colors["LIGHTBLUE"].b = 252

    self.colors["CYAN"] = {}
    self.colors["CYAN"].r = 0
    self.colors["CYAN"].g = 255
    self.colors["CYAN"].b = 255

    self.colors["MAGENTA"] = {}
    self.colors["MAGENTA"].r = 255
    self.colors["MAGENTA"].g = 0
    self.colors["MAGENTA"].b = 255

    self.colors["BROWN"] = {}
    self.colors["BROWN"].r = 101
    self.colors["BROWN"].g = 55
    self.colors["BROWN"].b = 0

    self.colors["BLACK"] = {}
    self.colors["BLACK"].r = 0
    self.colors["BLACK"].g = 0
    self.colors["BLACK"].b = 0

    self.colors["WHITE"] = {}
    self.colors["WHITE"].r = 255
    self.colors["WHITE"].g = 255
    self.colors["WHITE"].b = 255

    self.colors["GREY"] = {}
    self.colors["GREY"].r = 146
    self.colors["GREY"].g = 149
    self.colors["GREY"].b = 145

    self.colors["LIGHTGRAY"] = {}
    self.colors["LIGHTGRAY"].r = 104
    self.colors["LIGHTGRAY"].g = 101
    self.colors["LIGHTGRAY"].b = 103

    self.colors["DARKGRAY"] = {}
    self.colors["DARKGRAY"].r = 71
    self.colors["DARKGRAY"].g = 69
    self.colors["DARKGRAY"].b = 70

    self.colors["LIMEGREEN"] = {}
    self.colors["LIMEGREEN"].r = 137
    self.colors["LIMEGREEN"].g = 254
    self.colors["LIMEGREEN"].b = 5

    self.colors["DARKBLUE"] = {}
    self.colors["DARKBLUE"].r = 0
    self.colors["DARKBLUE"].g = 3
    self.colors["DARKBLUE"].b = 53

    self.colors["LIGHTGREEN"] = {}
    self.colors["LIGHTGREEN"].r = 150
    self.colors["LIGHTGREEN"].g = 249
    self.colors["LIGHTGREEN"].b = 123

    self.colors["OLIVE"] = {}
    self.colors["OLIVE"].r = 110
    self.colors["OLIVE"].g = 117
    self.colors["OLIVE"].b = 14

    self.colors["MAROON"] = {}
    self.colors["MAROON"].r = 101
    self.colors["MAROON"].g = 0
    self.colors["MAROON"].b = 33

    self.colors["SKYBLUE"] = {}
    self.colors["SKYBLUE"].r = 117
    self.colors["SKYBLUE"].g = 187
    self.colors["SKYBLUE"].b = 253

    self.colors["TURQUOISE"] = {}
    self.colors["TURQUOISE"].r = 6
    self.colors["TURQUOISE"].g = 194
    self.colors["TURQUOISE"].b = 172

    self.colors["DARKGREEN"] = {}
    self.colors["DARKGREEN"].r = 3
    self.colors["DARKGREEN"].g = 45
    self.colors["DARKGREEN"].b = 17

    self.colors["LIGHTPINK"] = {}
    self.colors["LIGHTPINK"].r = 255
    self.colors["LIGHTPINK"].g = 209
    self.colors["LIGHTPINK"].b = 223

    self.colors["GOLD"] = {}
    self.colors["GOLD"].r = 219
    self.colors["GOLD"].g = 180
    self.colors["GOLD"].b = 12

    self.colors["INDIGO"] = {}
    self.colors["INDIGO"].r = 56
    self.colors["INDIGO"].g = 2
    self.colors["INDIGO"].b = 130

    self.colors["CORAL"] = {}
    self.colors["CORAL"].r = 252
    self.colors["CORAL"].g = 90
    self.colors["CORAL"].b = 80

    self.colors["NAVY"] = {}
    self.colors["NAVY"].r = 1
    self.colors["NAVY"].g = 21
    self.colors["NAVY"].b = 62

    self.colors["SALMON"] = {}
    self.colors["SALMON"].r = 255
    self.colors["SALMON"].g = 121
    self.colors["SALMON"].b = 108

    self.colors["BEIGE"] = {}
    self.colors["BEIGE"].r = 230
    self.colors["BEIGE"].g = 218
    self.colors["BEIGE"].b = 166

    self.colors["CHOCOLATE"] = {}
    self.colors["CHOCOLATE"].r = 61
    self.colors["CHOCOLATE"].g = 28
    self.colors["CHOCOLATE"].b = 2

    self.colors["PEACH"] = {}
    self.colors["PEACH"].r = 255
    self.colors["PEACH"].g = 176
    self.colors["PEACH"].b = 124

    self.colors["TEAL"] = {}
    self.colors["TEAL"].r = 2
    self.colors["TEAL"].g = 147
    self.colors["TEAL"].b = 134

    self.colors["VIOLET"] = {}
    self.colors["VIOLET"].r = 154
    self.colors["VIOLET"].g = 14
    self.colors["VIOLET"].b = 234
end

lovecolors = LoveColors.new()