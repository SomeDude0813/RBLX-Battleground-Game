local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local user = services.p.LocalPlayer

local SpawnEvent = services.rp.Remotes.Events.SpawnEvent

SpawnEvent.OnClientEvent:Connect(function(data)
	print("fired")
	local Skillset = data.Skillset
	print(Skillset)

	local skillsetModule = require(services.rp.Shared.Skillsets[Skillset].Skillset)
	--skillsetModule.init(user) --Initialize the modules

	local skillNames = skillsetModule.Skills

	local PlayerGui = user.PlayerGui
	local CombatGui = PlayerGui.CombatGui

	CombatGui.Enabled = true

	for i, skillName in pairs(skillNames) do
		CombatGui.Loadout["Skill" .. i].Text = skillName
	end
end)
