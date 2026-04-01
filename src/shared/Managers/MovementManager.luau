local Movement = {}
Movement.__index = Movement

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local StateManager = require(services.rp.Shared.Managers.StateManager)

local Action = services.rp.Remotes.Events.Action

local Statuses = {
	["Stun"] = { WalkSpeed = 0, JumpHeight = 0 },
	["LockWalk"] = { WalkSpeed = 0, JumpHeight = 1 },
	["LockJump"] = { WalkSpeed = 1, JumpHeight = 0 },
	["Speed"] = { WalkSpeed = 1.2, JumpHeight = 1 },
	["Slow"] = { WalkSpeed = 0.5, JumpHeight = 1 },
}

function Movement.new(user: Player)
	local self = setmetatable({}, Movement)
	self.User = user

	return self
end

function Movement:LockMovement(user, duration)
	self.A = Instance.new("NumberValue")
	self.A.Name = "LockJump"
	self.A.Parent = self.User.Character.StatusFolder
	self.B = Instance.new("NumberValue")
	self.B.Name = "LockWalk"
	self.B.Parent = self.User.Character.StatusFolder

	services.d:AddItem(self.A, duration)
	services.d:AddItem(self.B, duration)
end

function Movement:UnlockMovement()
	if self.A then
		self.A:Destroy()
		self.A = nil
		self.B:Destroy()
		self.B = nil
	end
end

function Movement:UpdateCharacter(character)
	local statusFolder = character:WaitForChild("StatusFolder")

	function updateMovement(statusFolder)
		local walkSpeed = Auxillary.BaseProperties.Humanoid.WalkSpeed
		local jumpHeight = Auxillary.BaseProperties.Humanoid.JumpHeight

		if self.States.Sprinting and self.States.Stun == false and self.CooldownManager:CanAction() then
			walkSpeed *= 1.5
		end

		for i, Status in pairs(Statuses) do
			if statusFolder:FindFirstChild(i) then
				walkSpeed *= Status.WalkSpeed
				jumpHeight *= Status.JumpHeight
				self.States[i] = true
			else
				self.States[i] = false
			end
		end

		character.Humanoid.WalkSpeed = walkSpeed
		character.Humanoid.JumpHeight = jumpHeight
	end

	--[[local con
	con = services.rs.Heartbeat:Connect(function(dt)
		updateMovement(statusFolder)
	end)--]]
end

function Movement:SprintBegin(user: Player)
	print("begin")
	--print(user)
	if user == nil then
		warn("User Not Found!")
		return
	end

	if StateManager:CanAction(user, "Sprint") == false then
		print("InAction")
		return
	end

	StateManager:SetState(user, "Sprinting", true)
	print("sprint")
end

function Movement:SprintEnd(user: Player)
	print("end")
	StateManager:SetState(user, "Sprinting", false)
end

return table.freeze(Movement)
