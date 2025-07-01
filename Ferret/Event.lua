TriggerEvent = luanet.load_type('SomethingNeedDoing.Core.Enums.TriggerEvent')

local labels = {}
for k, v in pairs(TriggerEvent) do
    labels[v] = k
end

-- Attach a method to get the label
function TriggerEvent.get_label(value)
    return labels[value] or ('Unknown(' .. tostring(value) .. ')')
end
