local Module = require('Ferret/Model'):extend()

function Module:new(name)
    self.name = name
end

function Module:pre_initialize(ferret)
    self.logger = require('Ferret/Logger')(ferret, 'Ferret', self.name)
end
function Module:initialize(ferret) end
function Module:post_initialize(ferret) end

function Module:pre_tick(ferret) end
function Module:tick(ferret) end
function Module:post_tick(ferret) end

function Module:pre_teardown(ferret) end
function Module:teardown(ferret) end
function Module:post_teardown(ferret) end

return Module
