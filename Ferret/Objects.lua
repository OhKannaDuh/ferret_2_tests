local Objects = require('Ferret/List'):extend()

function Objects:new()
    Objects.super.new(self, Svc.Objects)
end

function Objects:where_object_kind(kind)
    return self:where(function(o)
        return o.ObjectKind == kind
    end)
end

-- 111

function Objects:sort_by_distance(pos)
    return self:sort(function(a, b)
        local dxA = a.Position.X - pos.X
        local dyA = a.Position.Y - pos.Y
        local dzA = a.Position.Z - pos.Z
        local distA = dxA * dxA + dyA * dyA + dzA * dzA

        local dxB = b.Position.X - pos.X
        local dyB = b.Position.Y - pos.Y
        local dzB = b.Position.Z - pos.Z
        local distB = dxB * dxB + dyB * dyB + dzB * dzB

        return distA < distB
    end)
end

function Objects:sort_by_distance_to_player()
    return self:sort_by_distance(Svc.ClientState.LocalPlayer.Position)
end

return Objects
