local Skillset = {}
Skillset.__index = Skillset

Skillset.Name = "Demo"

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

Skillset.Skills = require(services.rp.Shared.Info.Skills[Skillset.Name])

function Skillset.init(user: Player)
	local self = setmetatable({}, Skillset)
	self.User = user
end

return Skillset
