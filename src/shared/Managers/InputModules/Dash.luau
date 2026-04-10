local Dash = {}

local user: Player = game.Players.LocalPlayer

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Action: RemoteEvent = services.rp.Remotes.Events.Action

local InputManager = require(services.rp.Shared.Managers.InputManager)

function Dash:Fire(state)
	print("dash fired")
end

return Dash
