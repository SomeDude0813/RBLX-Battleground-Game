local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local SpawnEvent = services.rp.Remotes.Events.SpawnEvent

local SkillsetFolder = services.rp.Shared.Skillsets

local CooldownManager = require(services.rp.Shared.Managers.CooldownManager)
local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

SpawnEvent.OnServerEvent:Connect(function(user: Player, skillsetName: string)
	print("Spawn Fired")
	-- Character spawning
	local newChar = workspace.Dummys.Elemental[skillsetName]:Clone()
	newChar.HumanoidRootPart.Position = user.Character.HumanoidRootPart.Position
	newChar.Humanoid:Destroy()
	newChar.Name = user.Name
	newChar.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)
	newChar.Parent = workspace.Characters

	local newHum = user.Character:FindFirstChild("Humanoid"):Clone()
	local newAnimate = user.Character:FindFirstChild("Animate"):Clone()

	user.Character = newChar

	task.wait(1)

	newHum.Parent = newChar
	newAnimate.Parent = newChar
	warn("Character Sp0awned")

	local skillset = user.Variables.Skillset
	skillset.Value = skillsetName

	-- Initialize skillset
	CooldownManager.new(user)
	MovementManager.new(user)
	StateManager.new(user)

	--Activate Combat UI
	SpawnEvent:FireClient(user, { Func = "SetSkillset", Skillset = skillsetName })
end)
