local Dash = {}

local user: Player = game.Players.LocalPlayer

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local canAction: RemoteEvent = services.rp.Remotes.Events.canAction

local InputManager = require(services.rp.Shared.Managers.InputManager)

function Dash:Fire(state)
	if state == "End" then
		return
	end

	canAction:FireServer(user, {})

	canAction.OnClientEvent:Connect(function()
		print("fired")
	end)
end

return Dash
