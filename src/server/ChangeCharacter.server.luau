local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local SpawnEvent = services.rp.Remotes.Events.SpawnEvent

local SkillsetFolder = services.rp.Shared.Skillsets

SpawnEvent.OnServerEvent:Connect(function(user: Player)
	local newChar = workspace.Dummys.Fire:Clone()
	newChar.HumanoidRootPart.Position = user.Character.HumanoidRootPart.Position
	newChar.Humanoid:Destroy()
	newChar.Name = user.Name
	newChar.Parent = workspace.Characters
	local newHum = user.Character:FindFirstChild("Humanoid"):Clone()

	user.Character = newChar

	newHum.Parent = newChar

	local animateScript = newChar:FindFirstChild("Animate")
	animateScript.Disabled = true
	animateScript.Disabled = false
end)
