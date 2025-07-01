local TriggerManager = require('Ferret/Model'):extend()

function TriggerManager:new(ferret)
    self.listeners = {}
    self.logger = require('Ferret/Logger')(ferret, 'Ferret', 'TriggerManager')

    for _, state in pairs(Lifecycle) do
        self.listeners[state] = {}
    end
end

function TriggerManager:subscribe(event_type, callback)
    table.insert(self.listeners[event_type], callback)
end

function TriggerManager:handle_event(event_type, ferret)
    for _, callback in ipairs(self.listeners[event_type]) do
        callback(ferret)
    end
end

return TriggerManager
