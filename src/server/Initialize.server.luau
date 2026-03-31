local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)
local MovementManager = require(services.rp.Shared.Managers.MovementManager)

local plrStats = {
	["LastCombat"] = {
		Type = "Number",
		Value = 0,
	},
	["Skillset"] = {
		Type = "String",
		Value = "Demo"
	},
	["Combo"] = {
		Type = "Number",
		Value = 0
	},
	["InAction"] = {
		Type = "Bool",
		Value = false
	}
}

local function SetUpStats(user)
	for name, data in plrStats do
		local statType = data.Type
		local value = data.Value

		local valueVar = Instance.new(statType.."Value")
		valueVar.Name = name
		valueVar.Value = value
		valueVar.Parent = user
	end
end

services.p.PlayerAdded:Connect(function(user : Player)
	user.CharacterAdded:Connect(function(character)
		local StatusFolder = character:FindFirstChild("StatusFolder")
		local au = character:FindFirstChild("Aura")
		if au or StatusFolder then return end
		
		services.rs.Heartbeat:Wait()
		character.Parent = workspace.Humanoids

		character.PrimaryPart = character.HumanoidRootPart
		local humanoid = character.Humanoid
		humanoid.BreakJointsOnDeath = false
		humanoid.RequiresNeck = false

		StatusFolder = Instance.new("Folder")
		StatusFolder.Name = "StatusFolder"
		StatusFolder.Parent = character

		au = Instance.new("ObjectValue")
		au.Name = "Aura"
		au.Value = nil
		au.Parent = character
	end)

	SetUpStats(user)

	local Character = Instance.new("StringValue")
	Character.Name = "Character"
	Character.Value = "Demo"
	Character.Parent = user

	CooldownManager.new(user)

	local Skillset = require(services.rp.Shared.Skillsets[user.Skillset.Value].Skillset)
	Skillset.new(user, {})
	MovementManager.new(user, {})
end)
