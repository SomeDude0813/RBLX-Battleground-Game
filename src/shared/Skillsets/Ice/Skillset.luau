local Skillset = {}
Skillset.__index = Skillset

Skillset.Name = "Ice"

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

Skillset.Skills = {
	[1] = "Ice 1",
	[2] = "Ice 2",
	[3] = "Ice 3",
	[4] = "Ice 4",
}

function Skillset.init(user: Player)
	local self = setmetatable({}, Skillset)
	self.User = user
end

return Skillset
