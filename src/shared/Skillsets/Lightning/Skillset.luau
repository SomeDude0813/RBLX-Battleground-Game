local Skillset = {}
Skillset.__index = Skillset

Skillset.Name = "Lightning"

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

Skillset.Skills = {
	[1] = "Lightning 1",
	[2] = "Lightning 2",
	[3] = "Lightning 3",
	[4] = "Lightning 4",
}

function Skillset.init(user: Player)
	local self = setmetatable({}, Skillset)
	self.User = user
end

return Skillset
