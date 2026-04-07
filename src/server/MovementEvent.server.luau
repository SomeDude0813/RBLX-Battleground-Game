local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local MovementEvent = services.rp.Remotes.Events.MovementEvent
local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

MovementEvent.OnServerEvent:Connect(function(user: string, actionName: string, data: {})
	local inputState = data.State
	warn(inputState)

	if inputState == "Begin" and StateManager:CanAction(user, actionName) == false then
		print("InAction")
		return
	end

	if actionName == "Sprint" then
		StateManager:SetState(user, "Sprinting", inputState)
	end
end)
