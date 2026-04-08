local StateManager = {}
StateManager.__index = StateManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Statuses = require(services.rp.Shared.Info.Statuses)

StateManager.PlayerStates = {}

function StateManager.new(user: Player)
	local self = setmetatable({}, StateManager)
	self.User = user
	self.States = {
		["Sprint"] = false,
	}

	StateManager.PlayerStates[user] = self.States

	print("Statemanager initialized")
	StateManager:UpdateCharacter(user)

	return self
end

function StateManager:UpdateCharacter(user)
	local Heartbeat = services.rs.Heartbeat
	local character = user.Character or user.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	local statusFolder = character:WaitForChild("StatusFolder")
	local Variables = user:FindFirstChild("Variables")
	local hasStatus = false

	local plrStates = self.PlayerStates[user]

	local walkSpeed = Auxillary.BaseProperties.Humanoid.WalkSpeed
	local jumpHeight = Auxillary.BaseProperties.Humanoid.JumpHeight

	local SprintMultiplier = Auxillary.GameVariables.SprintMultiplier

	local function Sprint()
		if plrStates.Sprinting and hasStatus == false then
			humanoid.WalkSpeed = (walkSpeed * SprintMultiplier)
		elseif hasStatus == false then
			humanoid.WalkSpeed = walkSpeed
		end
	end

	local con: RBXScriptConnection = Heartbeat:Connect(function()
		Sprint()
		if Variables.InAction == true then
			humanoid.WalkSpeed = 0
		end
		if plrStates.Sprinting and hasStatus == false then
			humanoid.WalkSpeed = (walkSpeed * 1.5)
		elseif hasStatus == false then
			humanoid.WalkSpeed = walkSpeed
		end
	end)

	statusFolder.ChildAdded:Connect(function(status)
		local statusData = Statuses[status.Name]
		if statusData then
			print("child added: " .. status.Name)
			hasStatus = true
			local speed = humanoid.WalkSpeed * statusData.WalkSpeed
			local jump = jumpHeight * statusData.JumpHeight

			humanoid.WalkSpeed = speed
			humanoid.JumpHeight = jump
		end
	end)
	statusFolder.ChildRemoved:connect(function(status)
		print("connect")
		hasStatus = false
	end)
end

function StateManager:AddStatus(user: Player, statusName: string, duration: number?)
	if not Auxillary.CheckVariables({ user, statusName }) then
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

	local status = Instance.new("IntValue")
	status.Name = statusName
	status.Parent = statusFolder
	if duration then
		services.d:AddItem(status, duration)
	end
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

function StateManager:GetState(user: Player, state: string)
	return self.PlayerStates[user][state]
end

return StateManager
