local Sprint = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local AnimationManager = require(services.rp.Shared.Managers.AnimationManager)

function Sprint:Fire(state)
	print("fired")
end

return Sprint
