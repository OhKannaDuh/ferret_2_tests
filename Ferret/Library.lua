require('Ferret/Lifecycle')

local ferret = {}

ferret.config = require('Ferret/Config')

ferret.modules = {
    gathering = require('Ferret/Modules/Gathering/Module'),
}

return ferret
