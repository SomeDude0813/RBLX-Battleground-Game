local Skillset = {}
Skillset.__index = Skillset

Skillset.Name = "Earth"

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

Skillset.Skills = {
	[1] = "Earth 1",
	[2] = "Earth 2",
	[3] = "Earth 3",
	[4] = "Earth 4",
}

function Skillset.init(user: Player)
	local self = setmetatable({}, Skillset)
	self.User = user
end

return Skillset
