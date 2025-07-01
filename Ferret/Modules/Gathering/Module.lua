local Module = require('Ferret/Module'):extend()

function Module:new()
    Module.super.new(self, 'Gathering')
end

function Module:tick(ferret)
    self.logger:info('Hello, world!')
end

return Module()
