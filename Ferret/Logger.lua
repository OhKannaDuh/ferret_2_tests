local Logger = require('Ferret/Model'):extend()

function Logger:new(ferret, ...)
    self.ferret = ferret
    self.names = { ... }
end

function Logger:log(level, message)
    local prefix = ''
    if #self.names > 0 then
        local parts = {}
        for _, name in ipairs(self.names) do
            table.insert(parts, '[' .. name .. ']')
        end
        prefix = table.concat(parts, ' ') .. ' '
    end

    prefix = prefix .. '[' .. level .. '] '

    if level == 'debug' and self.ferret.config.show_debug then
        Dalamud.LogDebug(prefix .. message)
    elseif level == 'info' then
        Dalamud.Log(prefix .. message)
    end

    if self.ferret.config.echo_log then
        yield('/e ' .. prefix .. message)
    end
end

function Logger:info(message)
    self:log('info', message)
end

function Logger:debug(message)
    self:log('debug', message)
end

return Logger
