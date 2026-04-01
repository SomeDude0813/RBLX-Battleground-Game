local StateManager = {}
StateManager.__index = StateManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

StateManager.PlayerStates = {}

function StateManager.new(user: Player)
	local self = setmetatable({}, StateManager)
	self.User = user
	self.States = {
		["Sprinting"] = false,
		["Stun"] = false,
	}

	StateManager.PlayerStates[user] = self.States

	print("statemanager initialized")
	print(StateManager.PlayerStates)

	StateManager:UpdateCharacter(user)

	return self
end

function StateManager:UpdateCharacter(user)
	local character = user.Character or user.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	local statusFolder = character:WaitForChild("StatusFolder")
	local plrStates = self.PlayerStates[user]

	local walkSpeed = Auxillary.BaseProperties.Humanoid.WalkSpeed
	local jumpHeight = Auxillary.BaseProperties.Humanoid.JumpHeight

	statusFolder.ChildAdded:Connect(function(child)
		local statusInfo = require(services.rp.Shared.Info.Statuses)[child.Name]
		print("Status Added : " .. child.Name)
		if statusInfo then
			humanoid.WalkSpeed = (walkSpeed * statusInfo.WalkSpeed)
			humanoid.JumpHeight = (jumpHeight * statusInfo.JumpHeight)
			print("stats changed")
		end
	end)
	statusFolder.ChildRemoved:Connect(function(child)
		local statusInfo = require(services.rp.Shared.Info.Statuses)[child.Name]
		if statusInfo then
			humanoid.WalkSpeed = (walkSpeed / statusInfo.WalkSpeed)
			humanoid.JumpHeight = (jumpHeight / statusInfo.JumpHeight)
		end
	end)

	local con = services.rs.Heartbeat:Connect(function()
		if plrStates.Sprinting and plrStates.Stun == false then
			humanoid.WalkSpeed = (walkSpeed * 1.5)
		else
			humanoid.WalkSpeed = walkSpeed
		end
	end)
end

function StateManager:LockMovement(user: Player, duration: number)
	if duration == nil then
		warn("Duration Not Provided : Defaulting to 1 second")
		duration = 1
	end

	local character = user.Character
	local statusFolder = character:FindFirstChild("StatusFolder")
	if statusFolder == nil then
		warn("Status Folder Not Found")
		return
	end

	local a = Instance.new("NumberValue")
	a.Name = "LockJump"
	a.Parent = statusFolder
	local b = Instance.new("NumberValue")
	b.Name = "LockWalk"
	b.Parent = statusFolder

	services.d:AddItem(a, duration)
	services.d:AddItem(b, duration)
end

function StateManager:CanAction(user: Player, action)
	local plrStates = self.PlayerStates[user]
	if plrStates == nil then
		print("Player States Not Found : " .. user.Name)
		return
	end

	local character = user.Character
	if character == nil then
		print("Character Not Found : " .. user.Name)
		return
	end

	local statusFolder = character:FindFirstChild("StatusFolder")
	if statusFolder == nil then
		print("Status Folder Not Found : " .. user.Name)
		return
	end

	if statusFolder:FindFirstChildOfClass("NumberValue") then
		return false
	end

	return true
end

function StateManager:SetState(user: Player, state: string, value: boolean, duration: number?)
	local plrStates = self.PlayerStates[user]
	if plrStates == nil then
		print("Player States Not Found : " .. user.Name)
		return
	end

	plrStates[state] = value
	print(state .. " set to " .. tostring(value))
	if duration then
		task.delay(duration, function()
			plrStates[state] = not value
		end)
	end
end

return StateManager
