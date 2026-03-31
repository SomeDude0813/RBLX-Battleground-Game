local DemoSkillset = {}
DemoSkillset.__index = DemoSkillset

DemoSkillset.Skills = {
	["M1"] = { Name = "Combat", Cooldown = 0.3, Key = "M1" },
	["Q"] = { Name = "Dash", Cooldown = 2, Key = "Q" },
	["F"] = { Name = "Block", Cooldown = 1, Key = "F" },
}

local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)
local services = Auxillary.Services

local VFX = require(services.rp.Modules.Auxillary.VFX)

local Assets = services.rp.Assets.Skillsets.Demo

local ComboLength = 0.3
local M1WindUp = 0.2
local ComboCooldown = 1

function DemoSkillset.new(user: Player, clientData: {})
	local self = setmetatable({}, DemoSkillset)

	self.User = user
	self.ClientData = clientData

	self.Combo = 1
	self.LastM1 = 0
	self.M1Held = false

	self.Animations = {}
	for i, v in Assets.Animations:GetChildren() do
		self.Animations[v.Name] = user.Character.Humanoid.Animator:LoadAnimation(v)
	end

	--self.User.PlayerGui.Main.MainFrame.UltBar.Ultname.Text = "Ultimate Name"
	return self
end

--[Hit Effect]--
function DemoSkillset.Hit(plr: Player, clientData: {}, data: {})
	local eChar = data.HitData.Hit
	if eChar:HasTag("Block") and data.Combo ~= 4 then
		--VFX.CreateAndEmit(Assets.VFX.Block, eChar.HumanoidRootPart.Position)
		return
	end
	--VFX.CreateAndEmit(Assets.VFX.Hit, eChar.HumanoidRootPart.Position)

	if data.Combo == 4 then
		local start = time()
		local con
		local cf
		if data.Move == "Downslam" then
			cf = CFrame.new(eChar.HumanoidRootPart.Position)
		elseif data.Combo == 4 then
			if data.Air then
				cf = CFrame.new(eChar.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
					* CFrame.Angles(math.rad(180), 0, 0)
			else
				cf = CFrame.new(
					eChar.HumanoidRootPart.Position,
					eChar.HumanoidRootPart.Position
						+ (data.Char.HumanoidRootPart.CFrame.LookVector + Vector3.new(0, 1, 0)).Unit
				) * CFrame.Angles(math.rad(90), 0, 0)
			end
		end

		local s = Assets.VFX.Slam.Start:Clone()
		s.CFrame = cf
		s.Parent = workspace
		services.ts:Create(s.Mesh, TweenInfo.new(0.2), { Scale = Vector3.new(0, 0.05, 0) }):Play()
		services.ts:Create(s.Decal, TweenInfo.new(0.2), { Transparency = 1 }):Play()
		services.d:AddItem(s, 0.3)
		local s2 = Assets.VFX.Slam.End:Clone()
		s2.CFrame = cf
		s2.Parent = workspace.FX
		services.ts:Create(s2.Mesh, TweenInfo.new(0.2), { Scale = Vector3.new(0.12, 0.004, 0.12) }):Play()
		services.ts:Create(s2.Decal, TweenInfo(0.2), { Transparency = 1 }):Play()
		services.d:AddItem(s2, 0.3)

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Include
		params.FilterDescendantsInstances = workspace.Map

		con = services.RS.Heartbeat:Connect(function(dt)
			if time() - start >= 2 or eChar.Parent == nil then
				con:Disconnect()
				return
			else
				if eChar.HumanoidRootPart.Position.AssemblyLinearVelocity.Magnitude >= 20 then
					local dir = data.HitData.CFrame.LookVector * 2
					local result = workspace:Raycast(eChar.HumanoidRootPart.Position, dir, params)
					if result then
						VFX.CreateAndEmit(
							Assets.VFX.Slam.Slam,
							CFrame.new(result.Position, result.Position + result.Normal)
						)
						VFX.Crater({
							Position = result.Position,
							Radius = 4,
							CastDirection = dir,
							Normal = result.Normal,
							Segments = 7,
							Layers = 2,
							BaseSize = Vector3.new(2, 0.5, 1),
							FlyingRocks = 3,
						})
						con:Disconnect()
						return
					end
				end
			end
		end)
	end
end

function DemoSkillset:CombatBegin()
	self.ClientData.CooldownManager:Action()

	local char = self.User.Character
	self.M1Held = true

	repeat
		if time() - self.LastM1 > ComboCooldown then
			self.Combo = 1
		end
		self.LastM1 = time()

		local attachment = Instance.new("Attachment", char.HumanoidRootPart)

		local Combo = self.Combo
		local Move = "Normal"
		local inAir = services.uis:IsKeyDown(Enum.KeyCode.Space)

		if char.Humanoid.FloorMaterial == Enum.Material.Air and Combo == 4 then
			Move = "Downslam"
			self.Animations.Down:Play()
		elseif Combo == 4 and inAir then
			self.Animations["Uppercut"]:Play()
		else
			self.Animations["Punch" .. self.Combo]:Play()
		end

		local hitSomeone = false

		local hbData = {
			CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2),
			Size = Vector3.new(3, 3, 4),
			IgnoreList = { char },
			Func = function(hitData)
				if not hitSomeone then
					hitSomeone = true
					local bv = Instance.new("LinearVelocity")
					bv.VectorVelocity = char.HumanoidRootPart.CFrame.LookVector * 25
					bv.MaxAxesForce = Vector3.new(999999, 0, 999999)
					bv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
					bv.Attachment0 = attachment
					bv.Parent = char.HumanoidRootPart
					services.d:AddItem(bv, 0.1)
					services.d:AddItem(attachment, 0.1)
				end

				local sData = {
					Skillset = "Demo",
					Module = "Skillset",
					Action = "Hit",
					Data = { hitData = hitData, Combo = Combo, Air = inAir },
				}

				local repData = {
					Skillset = "Demo",
					Skill = "Skillset",
					Effect = "Hit",
					Data = { HitData = hitData, Combo = Combo, Move = Move, Air = inAir, Char = char },
				}

				self.ClientData.Server:Fire(sData)
				self.ClientData.Replicator:Fire(repData)
			end,
		}

		local LockJump = Instance.new("IntValue")
		LockJump.Name = "LockJump"
		LockJump.Parent = char.StatusFolder

		task.wait(M1WindUp)

		if Move == "Downslam" then
			--local hb = Hitbox.LingeringHitbox(hbData, .1, {Part = char.HumanoidRootPart, Offset = CFrame.new(0,-4,-2) * CFrame.Angles(math.rad(-45),0,0)})
		else
			--local hb = Hitbox.LingeringHitbox(hbData, .1, {Part = char.HumanoidRootPart, Offset = CFrame.new(0,0,-2)})
		end

		services.d:AddItem(attachment, 0.3)

		if self.Combo == 4 then
			services.d:AddItem(LockJump, 0.6)
			local LockWalk = Instance.new("IntValue")
			LockWalk.Name = "LockWalk"
			LockWalk.Parent = char.StatusFolder
			services.d:AddItem(LockWalk, 0.6)
			--self.ClientData.CameraShaker:ShakeOnce(12,8,.2,.2)
			self.Combo = 1
			task.wait(ComboCooldown)
		else
			services.d:AddItem(LockJump, 0.3)
			--self.ClientData.CameraShaker:ShakeOnce(2,8,.1,.1)
			self.Combo += 1
			task.wait(ComboLength)
		end

	until self.M1Held == false or char.Humanoid.Health <= 0

	self.ClientData.CooldownManager:FreeAction()
end

function DemoSkillset:CombatEnd()
	if self.M1Held then
		self.M1Held = false
	end
end

function DemoSkillset.DashEffect(plr: Player, clientData: {}, data: {})
	local char = data.Character

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { workspace.Map }

	for i = 1, 8 do
		for i = 1, Auxillary.Random(1, 3) do
		end
	end
end

function DemoSkillset:DashBegin()
	if self.ClientData.CooldownManager:OnCooldown("Dash") then
		return
	end
	self.ClientData.CooldownManager:Cooldown("Dash")
	self.ClientData.CooldownManager:Action()

	local char = self.User.Character

	local vector = "Look"
	local dir = 1

	if services.uis:IsKeyDown(Enum.KeyCode.D) or services.uis:IsKeyDown(Enum.KeyCode.A) then
		vector = "Right"
	end
	if services.uis:IsKeyDown(Enum.KeyCode.A) or services.uis:IsKeyDown(Enum.KeyCode.S) then
		dir = -1
	end

	local repData = {
		Skillset = "Demo",
		Skill = "Skillset",
		Effect = "DashEffect",
		Data = { Character = char },
	}

	local attachment = Instance.new("Attachment", char.HumanoidRootPar)

	self.ClientData.Replicator:Fire(repData)
end

return DemoSkillset
