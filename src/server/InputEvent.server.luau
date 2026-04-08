local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local InputEvent = services.rp.Remotes.Events.InputEvent

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

InputEvent.OnServerEvent:Connect(function(user, actionName, data)
	if actionName == "Sprint" then
		local sprintValue = StateManager:GetState(user, "Sprint")
		do
			if sprintValue == true then
				sprintValue = false
			elseif sprintValue == false then
				sprintValue = true
			end
		end
		StateManager:SetState(user, "Sprint", sprintValue)
	end
end)
