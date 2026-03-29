local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

services.p.PlayerAdded:Connect(function(player : Player)
    player.CharacterAdded:Connect(function(character)

end)

local i = 1

if i == 3 then
print("yes")
end