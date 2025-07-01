local Config = require('Ferret/Model'):extend()

function Config:new()
    self.show_debug = false
    self.echo_log = false
end

return Config
