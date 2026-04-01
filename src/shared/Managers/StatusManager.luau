local StatusManager = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

function StatusManager:ApplyStatus(target: Model, statusName: string, duration: number)
	local statusFolder = target:FindFirstChild("StatusFolder")
	if statusFolder == nil then
		warn("Target does not have a StatusFolder. Cannot apply status.")
		return
	end

	local status = Instance.new("IntValue")
	status.Name = statusName
	status.Parent = statusFolder

	services.d:AddItem(status, duration)
end

return StatusManager
