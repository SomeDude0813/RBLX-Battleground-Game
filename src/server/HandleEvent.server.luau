local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)


local Players = services.p

local RemoteFolder = services.rp.Remotes.Events

RemoteFolder.Action.OnServerEvent:Connect(function(user, actionName)
    if Auxillary.CheckVariables({user, actionName}) == false then return end

    if actionName == "M1" then
        local LastCombat = user.LastCombat.Value
        local Combo = user.Combo.Value

        

    end
end)