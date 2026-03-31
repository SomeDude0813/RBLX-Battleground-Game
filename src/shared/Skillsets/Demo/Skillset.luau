local Skillset = {}
Skillset.__index = Skillset

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local RemoteFolder = services.rp.Remotes
local CheckCD: RemoteFunction = RemoteFolder.Functions.CheckCooldown
local Action : RemoteEvent = RemoteFolder.Events.Action

Skillset.Cooldowns = {
	["Skill1"] = 5,
	["Skill2"] = 3,
	["Skill3"] = 5,
	["Skill4"] = 2
}

function Skillset.new(user: Player, cooldownManager: {})
	local self = setmetatable({}, Skillset)
	self.User = user
	self.CooldownManager = cooldownManager

	return self
end

function Skillset.Action(user, inputState)
	if inputState == Enum.UserInputState.Begin then
		inputState = "Begin"
	else
		inputState = "End"
	end


	if inputState == "Begin" then
		Action:FireServer("M1")
		
	end
end

return Skillset
