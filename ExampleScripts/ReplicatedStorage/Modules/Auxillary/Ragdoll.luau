local module = {}
local Players = game:GetService("Players")

local PhysicsService = game:GetService("PhysicsService")
PhysicsService:RegisterCollisionGroup("Ragdoll")

local ragParts = script.RagdollParts:GetChildren()

function module:Setup(char: Model)


	local humanoid = char:FindFirstChild("Humanoid")
	assert(humanoid, "Can only set-up ragdoll on R6 humanoid rigs")
	assert(humanoid.RigType == Enum.HumanoidRigType.R6, "Can only set-up ragdoll on R6 humanoid rigs")
	assert(humanoid.RootPart ~= nil, "No RootPart was found in the provided rig")
	assert(char:FindFirstChild("HumanoidRootPart"), "No HumanoidRootPart was found in the provided rig")

	for _, v: BasePart in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			--v:SetNetworkOwner(nil)
		end
	end

	-- Setup ragdoll
	humanoid.BreakJointsOnDeath = false
	humanoid.RequiresNeck = false

	local clones = {}
	for _, v in ipairs(ragParts) do
		clones[v.Name] = v:Clone()
	end

	local folder1 = Instance.new("Folder")
	folder1.Name = "RagdollConstraints"
	for _, v in pairs(clones) do
		if v:IsA("Attachment") then
			v.Parent = char[v:GetAttribute("Parent")]
		elseif v:IsA("BallSocketConstraint") then
			v.Attachment0 = clones[v:GetAttribute("0")]
			v.Attachment1 = clones[v:GetAttribute("1")]
			v.Parent = folder1
		end
	end
	folder1.Parent = char

	local folder2 = Instance.new("Folder")
	folder2.Name = "Motors"
	local value
	for _, v in ipairs(char.Torso:GetChildren()) do
		if v:IsA("Motor6D") then
			value = Instance.new("ObjectValue")
			value.Value = v
			value.Parent = folder2
		end
	end
	folder2.Parent = folder1

	
end

function module:Ragdoll(char: Model)
	char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	char.Humanoid.AutoRotate = false
	for _, v in ipairs(char.RagdollConstraints.Motors:GetChildren()) do
		v.Value.Enabled = false
	end

	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CollisionGroup = "Ragdoll"
		end
	end

	char.HumanoidRootPart:ApplyAngularImpulse(Vector3.new(math.random(-30,30) , math.random(-30,30), math.random(-30,30)) * char.HumanoidRootPart.AssemblyMass)
end

function module:Unragdoll(char: Model)
	char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	for _, v in ipairs(char.RagdollConstraints.Motors:GetChildren()) do
		v.Value.Enabled = true
	end

	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CollisionGroup = "Default"
		end
	end
	char.Humanoid.AutoRotate = true
end

return module
