local ModuleManager = require('Ferret/Model'):extend()

function ModuleManager:new(ferret)
    self.ferret = ferret
    self.modules = {}
end

function ModuleManager:register(module)
    if not module or type(module) ~= 'table' then
        error('Module must be a table.')
    end

    table.insert(self.modules, module)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreInitialize, function()
        module:pre_initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Initialize, function()
        module:initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostInitialize, function()
        module:post_initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreTick, function()
        module:pre_tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Tick, function()
        module:tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostTick, function()
        module:post_tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreTeardown, function()
        module:pre_teardown(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Teardown, function()
        module:teardown(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostTeardown, function()
        module:post_teardown(self.ferret)
    end)
end

return ModuleManager
