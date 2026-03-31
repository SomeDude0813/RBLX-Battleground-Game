local Functions = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)

local folder = services.rp.Remotes.Functions
for i, v in pairs(folder:GetDescendants()) do
	if v:IsA("RemoteFunction") then
		Functions[v.Name] = v
	end
end

Functions.CheckCooldown.OnServerInvoke = function(player, canUse) end
