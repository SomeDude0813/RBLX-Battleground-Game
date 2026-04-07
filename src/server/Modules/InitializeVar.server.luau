local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Players = services.p

local StateManager = require(services.rp.Shared.Managers.StateManager)

Players.PlayerAdded:Connect(function(user: Player)
	user.CharacterAdded:Connect(function(character)
		services.rs.Heartbeat:Wait()
		character.Parent = workspace.Characters
		local statusFolder = Instance.new("Folder")
		statusFolder.Name = "StatusFolder"
		statusFolder.Parent = character
	end)

	local varFolder = Instance.new("Folder")
	varFolder.Name = "Variables"
	varFolder.Parent = user

	local Skillset = Instance.new("StringValue")
	Skillset.Name = "Skillset"
	Skillset.Value = "None"
	Skillset.Parent = varFolder

	local InAction = Instance.new("BoolValue")
	InAction.Name = "InAction"
	InAction.Value = false
	InAction.Parent = varFolder
end)
