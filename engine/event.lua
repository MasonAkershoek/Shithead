EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)

    self.T = "EventManager"

    self.listeners = {}
    self.queue = {}
    return self
end

function EventManager:addListener(listenerName, event)
    logger:log("Adding Listener: ", listenerName)
    self.listeners[listenerName] = event
end

function EventManager:addEventToQueue(event)
    if event.trigger == "after" and #self.queue > 0 then
        event.after = self.queue[#self.queue]
    end
    table.insert(self.queue, event)
end

function EventManager:emit(eventName)
    if self.listeners[eventName] then
        self.listeners[eventName]:emit()
    else
        logger:log("No listener found for event: ", eventName)
    end
end

function EventManager:update(dt)
    updateList(self.queue, dt)
    for x = #self.queue, 1, -1 do
        if self.queue[x].isExpired then
            table.remove(self.queue, x)
        end
    end
end

Event = {}
Event.__index = Event

function Event.new(func, args)
    local self = setmetatable({}, Event)

    self.T = "Event"

    -- Main event configurations
    local args = args or {}
    self.trigger = args.trigger or "imidiate"
    self.delay = args.delay or nil
    self.callback = func or function() logger:log("Empty Callback!") end
    self.emited = false

    -- trigger spesific configurations
    if self.delay then
        self.timer = Timer.new(self.delay)
    end

    if self.trigger == "after" then
        self.timer:stopTimer()
        self.after = nil
    end
    if self.trigger == "condition" then
        self.conditionCheck = args.conditionCallback
    end
    return self
end

function Event:emit()
    logger:log("Event Emiting Event")
    self.callback()
    self.emited = true
end

function Event:update()
    if self.trigger == "after" then
        if self.after.timer:isExpired() then
            if self.timer:isStopped() and not self.timer:isExpired() then self.timer:start() end
            if self.timer:isExpired() then
                self:emit()
            end
        end
    elseif self.trigger == "imidiate" then
        if self.timer:isExpired() then
            self:emit()
        end
    end
end
