local CommonMethods = {}

local Auxillary = require(game.ReplicatedStorage.Modules.Auxillary.Auxillary)
local services = Auxillary.Services

CommonMethods.Counters = {}
local function ApplyStatus(Name, Char, d)
	local a = Instance.new("IntValue")
	a.Name = Name
	a.Parent = Char.StatusFolder
	services.d:AddItem(a, d)
end
function CommonMethods.ApplyIFrame(Character, Dur)
	local a = Instance.new("IntValue")
	a.Name = "IFrame"
	a.Parent = Character.StatusFolder
	services.d:AddItem(a, Dur)
end
function CommonMethods.ApplyStun(
	Character: Model,
	D --[[Duration]]: IntValue
)
	local stun = Instance.new("IntValue")
	stun.Name = "Stun"
	stun.Parent = Character.StatusFolder
	services.d:AddItem(stun, D)
end
function CommonMethods.ApplySlow(
	Character: Model,
	D --[[Duration]]: IntValue
)
	local stun = Instance.new("IntValue")
	stun.Name = "Slow"
	stun.Parent = Character.StatusFolder
	services.d:AddItem(stun, D)
end
function CommonMethods.BlockBreak(Character: Model)
	if Character:HasTag("Block") then
		Character:RemoveTag("Block")
		CommonMethods.ApplyStun(Character, 2)
		CommonMethods.ApplySlow(Character, 2)
		--[[
		local repData = {
			Skillset = "Demo",
			Skill = "Skillset",
			Effect = "BlockBreak",
			Data = {Character = Character,},
		}
		Replicator:Fire(BridgeNet.AllPlayers(), repData)
		--]]
		return true
	end
	return false
end

function CommonMethods.Damage(player, target, damage)
	if target.Humanoid.Health <= 0 then
		return
	end
	if player then
		local eP = services.p:GetPlayerFromCharacter(target)

		if eP then
			eP.Ultimate.Value = math.min(100, eP.Ultimate.Value + damage / 10)
			target.Humanoid:TakeDamage(damage)
		else
			target.Humanoid:TakeDamage(damage)
		end

		if target.Humanoid.Health <= 0 then
			player.leaderstats.Kills.Value += 1
		end
		player.Ultimate.Value = math.min(100, player.Ultimate.Value + damage / 5)
	end
end

return CommonMethods
