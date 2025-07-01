local ferret = require('Ferret/Library')

local Core = require('Ferret/Model'):extend()

function Core:new()
    self.running = false
    self.fps = 24
    self.lifecycle_manager = require('Ferret/LifecycleManager')(ferret)
    self.module_manager = require('Ferret/ModuleManager')(ferret)
    self.logger = require('Ferret/Logger')(ferret, 'Ferret', 'Core')
end

function Core:on_update()
    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.PreTick, ferret)
    end

    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.Tick, ferret)
    end

    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.PostTick, ferret)
    end
end

function Core:start()
    if self.running then
        return
    end

    self.lifecycle_manager:handle_state(Lifecycle.PreInitialize, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.Initialize, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.PostInitialize, ferret)
    self.running = true

    -- persist
    while self.running do
        yield('/wait 0.01')
    end
end

function Core:stop()
    self.running = false

    self.lifecycle_manager:handle_state(Lifecycle.PreTeardown, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.Teardown, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.PostTeardown, ferret)
end

ferret.core = Core()

-- Helpers
function ferret:register_module(module)
    ferret.core.module_manager:register(module)
end

return ferret
