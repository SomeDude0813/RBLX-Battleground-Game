local module = {}

module.Services = {
	["rp"] = game:GetService("ReplicatedStorage"),
	["rf"] = game:GetService("ReplicatedFirst"),
	["ts"] = game:GetService("TweenService"),
	["ps"] = game:GetService("PhysicsService"),
	["ss"] = game:GetService("ServerStorage"),
	["sss"] = game:GetService("ServerScriptService"),
	["l"] = game:GetService("Lighting"),
	["ms"] = game:GetService("MaterialService"),
	["mps"] = game:GetService("MarketplaceService"),
	["d"] = game:GetService("Debris"),
	["p"] = game:GetService("Players"),
	["uis"] = game:GetService("UserInputService"),
	["rs"] = game:GetService("RunService"),
	["SS"] = game:GetService("SoundService"),
	["cs"] = game:GetService("CollectionService"),
	["cas"] = game:GetService("ContextActionService"),
}

module.BaseProperties = {
	["Camera"] = {
		FieldOfView = 70,
	},
	["Humanoid"] = {
		WalkSpeed = game.StarterPlayer.CharacterWalkSpeed,
		JumpHeight = game.StarterPlayer.CharacterJumpHeight,
	},
	["ColorCorrection"] = {
		Saturation = 0.45,
	},
	["Clouds"] = {
		Cover = 0.7,
		Density = 0.2,
		Color = Color3.fromRGB(255, 255, 255),
	},
}

module.Inputs = {
	["M1"] = Enum.UserInputType.MouseButton1,
	["Dash"] = Enum.KeyCode.Q,
	["Jump"] = Enum.KeyCode.Space,
	["Sprint"] = Enum.KeyCode.LeftShift,
	["Skill1"] = Enum.KeyCode.One,
	["Skill2"] = Enum.KeyCode.Two,
	["Skill3"] = Enum.KeyCode.Three,
	["Skill4"] = Enum.KeyCode.Four,
	["Skill5"] = Enum.KeyCode.Five,
}

module.Cooldowns = {
	["Combo"] = 0.5,
	["ComboReset"] = 1.5,
	["Dash"] = 2,
	["HeldDash"] = 5,
}

function module.CheckVariables(variables: {})
	for _, v in variables do
		if v == false then
			return false
		end
	end

	return true
end

return module
