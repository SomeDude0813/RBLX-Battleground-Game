local Skillset = {}
Skillset.__index = Skillset

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CheckCD: RemoteFunction = services.rp.Remotes.Functions.CheckCooldown

function Skillset.new(user: Player, cooldownManager: {})
	local self = setmetatable({}, Skillset)
	self.User = user
	self.CooldownManager = cooldownManager

	return self
end

function Skillset.OnM1(inputState)
	CheckCD:InvokeServer("M1")
end

return Skillset
