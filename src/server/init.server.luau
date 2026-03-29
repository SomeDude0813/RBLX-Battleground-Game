local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

services.p.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character)
		services.rs.Heartbeat:Wait()
		character.Parent = workspace.Humanoids

		character.PrimaryPart = character.HumanoidRootPart
		local humanoid = character.Humanoid
		humanoid.BreakJointsOnDeath = false
		humanoid.RequiresNeck = false

		local StatusFolder = Instance.new("Folder")
		StatusFolder.Name = "StatusFolder"
		StatusFolder.Parent = character

		local au = Instance.new("ObjectValue")
		au.Name = "Aura"
		au.Value = nil
		au.Parent = character
	end)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Kills"
end)
