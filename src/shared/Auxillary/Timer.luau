local Timer = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.services


local RunService : RunService = services.rs

function Timer:Start(startTime, duration, func)
    
end

function Timer:StartCooldown(startTime, duration)
    task.wait(duration)
    print(tick() - startTime)
end

return Timer