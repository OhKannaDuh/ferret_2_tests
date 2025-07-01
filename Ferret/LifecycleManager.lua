local LifecycleManager = require('Ferret/Model'):extend()

function LifecycleManager:new(ferret)
    self.listeners = {}
    self.logger = require('Ferret/Logger')(ferret, 'Ferret', 'LifecycleManager')

    for _, state in pairs(Lifecycle) do
        self.listeners[state] = {}
    end
end

function LifecycleManager:subscribe(state, callback)
    table.insert(self.listeners[state], callback)
end

function LifecycleManager:handle_state(state, ferret)
    for _, callback in ipairs(self.listeners[state]) do
        callback(ferret)
    end
end

return LifecycleManager
