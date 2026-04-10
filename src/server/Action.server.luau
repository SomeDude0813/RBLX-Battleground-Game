local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Action = services.rp.Remotes.Events.Action

local StateManager = require(services.rp.Shared.Managers.StateManager)
local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)

local ActionModules = {}
for _, module in pairs(services.rp.Shared.Managers.InputModules:GetChildren()) do
	ActionModules[module.Name] = require(module)
end

Action.OnServerEvent:Connect(function(user: Player, data: {})
	local actionName = data.Action
	local state
	if data.State then
		state = data.State
	end

	if StateManager:CanAction(user) then
		ActionModules[actionName]:Fire()
	end
end)
