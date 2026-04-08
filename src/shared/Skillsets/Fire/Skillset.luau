local Skillset = {}
Skillset.__index = Skillset

Skillset.Name = "Fire"

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

Skillset.Skills = {
	[1] = "Fire 1",
	[2] = "Fire 2",
	[3] = "Fire 3",
	[4] = "Fire 4",
}

function Skillset.init(user: Player)
	local self = setmetatable({}, Skillset)
	self.User = user
end

return Skillset
