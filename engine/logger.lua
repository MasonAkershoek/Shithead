Logger = {}
Logger.__index = Logger

function Logger.new()
    local self = setmetatable({}, Logger)
    self.fileName = os.date("%d-%m-%y_%H:%M:%S.log")
    self.file = io.open("logs/"..self.fileName, "a")
    io.output(self.file)
    return self
end

function Logger:log(message, ...)
    local time = os.date("%H:%M:%S")
    local message = tostring(message) or "Empty Log!"
    local args = {...}
    for x,v in ipairs(args) do
        message = message .. " " .. tostring(v)
    end
    print(message)
    io.write("["..time.."] - "..message.."\r\n")
end

function Logger:close()
    io.close(self.file)
end

logger = Logger.new()