local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local canAction = services.rp.Remotes.Events.canAction

local StateManager = require(services.rp.Shared.Managers.StateManager)
local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)

canAction.OnServerEvent:Connect(function(user: Player, action: string, data: {})
	if StateManager:CanAction(user) then
		canAction:FireClient(user)
	end
end)
