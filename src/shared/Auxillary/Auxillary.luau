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
	["cs"] = game:GetService("CollectionService")
}

module.BaseProperties = {
	["Camera"] = {
		FieldOfView = 70,
	},
	["Humanoid"] = {
		WalkSpeed = 16,
		JumpHeight = 7.2,
	},
	["ColorCorrection"] = {
		Saturation = .45
	},
	["Clouds"] = {
		Cover = .7,
		Density = .2,
		Color = Color3.fromRGB(255,255,255)
	}
}

return module
