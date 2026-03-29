local CommonMethods = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)

local services = Auxillary.Services

local Timer = require(services.rs.Modules.Auxillary.Timer)
local VFX = require(services.rs.Modules.Auxillary.VFX)
local Janitor = require(services.rs.Modules.Auxillary.Janitor)
CommonMethods.Profiles = nil--it is set later in Server script
local Hitbox = require(services.rs.Modules.Auxillary.Hitbox)
local Ragdoll = require(services.rs.Modules.Auxillary.Ragdoll)

local BridgeNet = require(services.rs.Modules.Auxillary.BridgeNet2)
local Replicator = BridgeNet.ServerBridge("Replicator")
local Server = BridgeNet.ServerBridge("Server")

local Voxel = require(services.rs.Modules.Auxillary.VoxelDestruction)

function CommonMethods.Ragdoll(char, length)
	task.spawn(function()
		char.HumanoidRootPart:ApplyAngularImpulse(Vector3.new(-90, 0, 0))
		Ragdoll:Ragdoll(char)
		if services.p:GetPlayerFromCharacter(char) then
			local player = services.p:GetPlayerFromCharacter(char)
			local repData = {
				Custom = true,
				Action = "Ragdoll",
				Data = {Length = length}
			}
			Replicator:Fire(BridgeNet.Players({player}), repData)
		end
		task.wait(length)
		Ragdoll:Unragdoll(char)
	end)
end
CommonMethods.Counters = {}
local function ApplyStatus(Name,Char, d)
	local a = Instance.new('IntValue')
	a.Name = Name
	a.Parent = Char.StatusFolder
	services.d:AddItem(a,d)	
end
function CommonMethods.ApplyIFrame(Character, Dur)
	local a = Instance.new('IntValue')
	a.Name = "IFrame"
	a.Parent = Character.StatusFolder
	services.d:AddItem(a, Dur)	
end
function CommonMethods.ApplyStun(Character,D)
	local stun = Instance.new("IntValue")
	stun.Name = "Stun"
	stun.Parent = Character.StatusFolder
	services.d:AddItem(stun, D)
end
function CommonMethods.ApplySlow(Character,D)
	local stun = Instance.new("IntValue")
	stun.Name = "Slow"
	stun.Parent = Character.StatusFolder
	services.d:AddItem(stun, D)
end
function CommonMethods.BlockBreak(Character)
	if Character:HasTag("Block") then
		Character:RemoveTag("Block")
		CommonMethods.ApplyStun(Character,2)
		CommonMethods.ApplySlow(Character,2)
		local repData = {
			Skillset = "Demo",
			Skill = "Skillset",
			Effect = "BlockBreak",
			Data = {Character = Character,},
		}
		Replicator:Fire(BridgeNet.AllPlayers(), repData)
		return true
	end
	return false
end

function CommonMethods.Damage(player, target, damage)
	if target.Humanoid.Health <= 0 then return end
	if player then
		local eP = services.p:GetPlayerFromCharacter(target)
		
		if eP then
			if CommonMethods.Counters[eP] then
				
			else
				eP.Ultimate.Value = math.min(100, eP.Ultimate.Value + damage/10)
				target.Humanoid:TakeDamage(damage)	
			end
			eP.LastCombat.Value = workspace:GetServerTimeNow()
		else
			target.Humanoid:TakeDamage(damage)	
		end
		if target.Humanoid.Health <= 0 then
			CommonMethods.Profiles[player].Data.Kill+=1
			CommonMethods.Profiles[player].Data.Soul += 1
			player.leaderstats.Kills.Value += 1
		end
		player.Ultimate.Value = math.min(100, player.Ultimate.Value + damage/5)
	end
end

function CommonMethods.DestroyTerrain(cf : CFrame, radius : number, raycastResult : RaycastResult)
	task.spawn(function()
		--[[
		cframe: CFrame, 
		size: Vector3, 
		shape: Enum.PartType?,  
		parameters: OverlapParams?,
		voxelSize: number?, 
		debrisCount: number?, 
		cutoutSize: number?, 
		gridLock: boolean?,
		reset: number?,
		freeze: boolean?,
		destroy: boolean?,
		lock: boolean?
		
		]]
		
		
		local debris, walls = Voxel.destroy(
			cf,
			Vector3.one * 2 * radius,
			Enum.PartType.Ball,
			nil,
			2, -- size
			radius * radius,
			1, -- cutout
			true,
			5, 
			nil,
			nil,
			nil
		)
		
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Include
		params.FilterDescendantsInstances = {workspace.Map.Destructible}
		
		local hitParts = workspace:GetPartBoundsInRadius(cf.Position, radius, params)
		local hitList = {}
		for i, v in pairs(hitParts) do
			if v.Parent:IsA("Model") and not hitList[v.Parent] then
				hitList[v.Parent] = true
				local object = v.Parent
				object:SetAttribute("Broken", true)
				object.Parent = services.rs.TempStorage
				task.delay(10,function()
					object.Parent = workspace.Map.Destructible
					object:SetAttribute("Broken", false)
				end)
			end
		end
		
		if raycastResult then
			if raycastResult.Instance:IsDescendantOf(workspace.Map.Destructible) then
				local object = raycastResult.Instance.Parent
				object:SetAttribute("Broken", true)
				object.Parent = services.rs.TempStorage
				task.delay(10,function()
					object.Parent = workspace.Map.Destructible
					object:SetAttribute("Broken", false)
				end)
			end
		end
	

		if #debris > 0 then
			for i,debri in ipairs(debris) do
				debri.Anchored = false;
				debri:ApplyImpulse( Vector3.new(math.random(-100, 100), 50, math.random(-100, 100)) )
			end

			
		end
		task.wait(5)
		--warn("lagfest")
		Voxel.cleanup(debris)
	end)
end

return CommonMethods