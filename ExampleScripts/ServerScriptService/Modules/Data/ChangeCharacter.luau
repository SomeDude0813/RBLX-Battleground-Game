local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)

local services = Auxillary.Services

local CommonMethods = require(services.sss.Modules.Auxillary.CommonMethods)

return function(p, d)
	if workspace:GetServerTimeNow() - p.LastCombat.Value  > 10 then
		p.Skillset.Value = d.Skillset
		p.Ultimate.Value = 0
		p.Character.Humanoid.Health = 0
	end
end