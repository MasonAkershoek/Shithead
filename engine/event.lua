EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)

    self.T = "EventManager"

    self.listeners = {}
    self.queue = {}
    return self
end

function EventManager:on(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
end

function EventManager:emit(eventName, tim)
    if not tim then 
        print("Event Emited")
        local callbacks = self.listeners[eventName]
        print(#callbacks)
        if callbacks then
            for _, callback in ipairs(callbacks) do
                callback(callback)
            end
        end
    else
        print("Event Added to Queue")
        tmp = G.TIMERMANAGER:addTimer(tim)
        table.insert(self.queue, {eventName, tmp})
    end
end

function EventManager:update(dt)
    for _,event in ipairs(self.queue) do
        if G.TIMERMANAGER:checkExpire(event[2]) then
            print("Timer Expired")
            print(event[1])
            self:emit(event[1])
        end
    end
end

Event = {}
Event.__index = Event

function Event.new(args)
    
end