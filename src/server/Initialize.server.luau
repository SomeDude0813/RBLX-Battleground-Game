local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)
local MovementManager = require(services.rp.Shared.Managers.MovementManager)

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

	do
		local a = Instance.new("NumberValue")
		a.Name = "LastCombat"
		a.Value = 0
		a.Parent = player
	end
	do
		local a = Instance.new("StringValue")
		a.Name = "Skillset"
		a.Value = "Demo"
		a.Parent = player
	end
	do
		local a = Instance.new("NumberValue")
		a.Name = "Combo"
		a.Value = 0
		a.parent = player
	end

	local Character = Instance.new("StringValue")
	Character.Name = "Character"
	Character.Value = "Demo"
	Character.Parent = player

	CooldownManager.new(player)

	local Skillset = require(services.rp.Shared.Skillsets[player.Skillset.Value].Skillset)
	Skillset.new(player, {})
	MovementManager.new(player, {})
end)
