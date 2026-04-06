local Movement = {}
Movement.__index = Movement

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local StateManager = require(services.rp.Shared.Managers.StateManager)

local Action = services.rp.Remotes.Events.CombatEvent

function Movement.new(user: Player)
	local self = setmetatable({}, Movement)
	self.User = user

	return self
end

function Movement:Dash(user: Player)
	print("Dash", user)

	if StateManager:CanAction(user, "Dash") == false then
		print("InAction")
		return
	end

	local character = user.Character
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	local dashDirection = rootPart.CFrame.LookVector
	local dashDistance = 50
	local dashTime = 0.2
	local dashCFrame = rootPart.CFrame + (dashDirection * dashDistance)

	local dashTween = game:GetService("TweenService"):Create(rootPart, TweenInfo.new(dashTime), { CFrame = dashCFrame })

	Action:FireClient(user, "Dash", { CFrame = dashCFrame, DashTime = dashTime, DashDistance = dashDistance })
end

function Movement:SprintBegin(user: Player)
	print("begin")
	--print(user)
	if user == nil then
		warn("User Not Found!")
		return
	end

	local char = user.Character
	char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)

	if StateManager:CanAction(user, "Sprint") == false then
		print("InAction")
		return
	end

	StateManager:SetState(user, "Sprinting", true)
	print("sprint")
end

function Movement:SprintEnd(user: Player)
	print("end")
	local char = user.Character
	char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
	StateManager:SetState(user, "Sprinting", false)
end

return table.freeze(Movement)
