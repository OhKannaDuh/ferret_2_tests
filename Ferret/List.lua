local List = require('Ferret/Model'):extend()

function List:new(source)
    self.source = source
    self._filters = {}
    self._sorter = nil
    self._selector = nil
end

function List:where(filter)
    table.insert(self._filters, filter)
    return self
end

function List:sort(sorter)
    self._sorter = sorter
    return self
end

function List:select(selector)
    self._selector = selector
    return self
end

function List:to_table()
    local list = {}

    for item in luanet.each(self.source) do
        local passes = true
        for _, filter in ipairs(self._filters) do
            if not filter(item) then
                passes = false
                break
            end
        end

        if passes then
            if self._selector then
                table.insert(list, self._selector(item))
            else
                table.insert(list, item)
            end
        end
    end

    if self._sorter then
        table.sort(list, self._sorter)
    end

    return list
end

function List:first()
    local list = self:to_table()
    return list[1]
end

function List:count()
    local count = 0
    for item in luanet.each(self.source) do
        local passes = true
        for _, filter in ipairs(self._filters) do
            if not filter(item) then
                passes = false
                break
            end
        end
        if passes then
            count = count + 1
        end
    end
    return count
end

function List:any()
    for item in luanet.each(self.source) do
        local passes = true
        for _, filter in ipairs(self._filters) do
            if not filter(item) then
                passes = false
                break
            end
        end
        if passes then
            return true
        end
    end
    return false
end

return List
