local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateManager = require(ReplicatedStorage.Shared.Managers.StateManager)
local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)
local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local CooldownList = require(services.rp.Shared.Info.Cooldowns)

local Players = services.p

local RemoteFolder = services.rp.Remotes.Events

RemoteFolder.Action.OnServerEvent:Connect(function(user, actionName, data)
	if Auxillary.CheckVariables({ user, actionName }) == false then
		return
	end

	if StateManager:CanAction(user, actionName) == false then
		return
	end

	if CooldownManager:OnCooldown(user, actionName, CooldownList[actionName]) == true then
		return
	end

	if actionName == "Sprint" then
		MovementManager["Sprint" .. data.State](nil, user)
	end

	if actionName == "Dash" then
		MovementManager:Dash(user)
	end

	if actionName == "M1" then
		if data.State == "End" then return end
		local LastCombat = user.LastCombat.Value
		local Combo = user.Combo.Value

		--if CooldownManager:CanAction(user) == false then return end
		if user.InAction.Value == true then
			return
		end

		user.InAction.Value = false
		LastCombat = tick()
		Combo = Combo + 1

		CooldownManager:Cooldown(user, "M1")
		StateManager:AddStatus(user, "Slow", CooldownList["M1"])
		print("cooldown start")
	end
end)
