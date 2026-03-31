local Movement = {}
Movement.__index = Movement

local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)

local services = Auxillary.Services

local Timer = require(services.rs.Modules.Auxillary.Timer)
local VFX = require(services.rs.Modules.Auxillary.VFX)
local Janitor = require(services.rs.Modules.Auxillary.Janitor)

local Statuses = {
	["Stun"] = { WalkSpeed = 0, JumpHeight = 0 },
	["LockWalk"] = { WalkSpeed = 0, JumpHeight = 1 },
	["LockJump"] = { WalkSpeed = 1, JumpHeight = 0 },
	["Speed"] = { WalkSpeed = 1.2, JumpHeight = 1 },
	["Slow"] = { WalkSpeed = 0.5, JumpHeight = 1 },
}

function Movement.new(user: Player, cooldownManager: {})
	local self = setmetatable({}, Movement)
	self.User = user
	self.Janitor = Janitor.new()
	self.States = {
		["Sprinting"] = false,
		["Stun"] = false,
	}
	self.CooldownManager = cooldownManager

	return self
end

function Movement:Lock() end

function Movement:Unlock() end

function Movement:LockMovement()
	self.A = Instance.new("NumberValue")
	self.A.Name = "LockJump"
	self.A.Parent = self.User.Character.StatusFolder
	self.B = Instance.new("NumberValue")
	self.B.Name = "LockWalk"
	self.B.Parent = self.User.Character.StatusFolder
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
	self.Janitor:Cleanup()

	local statusFolder = character:WaitForChild("StatusFolder")

	--for i, v in pairs(character:GetChildren()) do
	--	if v.Name == "StatusFolder" and v ~= statusFolder then
	--		v:Destroy()
	--	end
	--end

	local function updateMovement(statusFolder)
		local walkSpeed = Auxillary.BaseProperties.Humanoid.WalkSpeed
		local jumpHeight = Auxillary.BaseProperties.Humanoid.JumpHeight

		--if not self.CooldownManager:CanAction() then
		--	walkSpeed = 0
		--	jumpHeight = 0
		--end

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

	local con
	con = services.RS.Heartbeat:Connect(function(dt)
		updateMovement(statusFolder)
	end)

	self.Janitor:Add(con, "Disconnect")
end

function Movement:SprintBegin()
	self.States.Sprinting = true
end

function Movement:SprintEnd()
	self.States.Sprinting = false
end

return table.freeze(Movement)
