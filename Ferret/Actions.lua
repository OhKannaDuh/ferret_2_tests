local Actions = require('Ferret/List'):extend()

function Actions:new()
    Actions.super.new(self, Excel.GetSheet('Action'):All())
end

return Actions
