Lifecycle = {
    PreInitialize = 1,
    Initialize = 2,
    PostInitialize = 3,

    PreTick = 4,
    Tick = 5,
    PostTick = 6,

    PreTeardown = 7,
    Teardown = 8,
    PostTeardown = 9,
}

local labels = {}
for k, v in pairs(Lifecycle) do
    labels[v] = k
end

-- Attach a method to get the label
function Lifecycle.get_label(value)
    return labels[value] or ('Unknown(' .. tostring(value) .. ')')
end
