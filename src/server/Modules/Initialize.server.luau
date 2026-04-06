local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Players = services.p

local StateManager = require(services.rp.Shared.Managers.StateManager)

Players.PlayerAdded:Connect(function(user: Player)
	user.CharacterAdded:Connect(function(character)
		services.rs.Heartbeat:Wait()
		character.Parent = workspace.Characters
	end)
	local Character = Instance.new("StringValue")
	Character.Name = "Character"
	Character.Value = "None"
	Character.Parent = user

	local InAction = Instance.new("BoolValue")
	InAction.Name = "InAction"
	InAction.Value = false
	InAction.Parent = user

	StateManager.new(user)
end)
