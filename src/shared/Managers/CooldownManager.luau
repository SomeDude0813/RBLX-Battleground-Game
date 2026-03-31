local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local CooldownManager = {}
CooldownManager.__index = CooldownManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Inputs = Auxillary.Inputs
local CooldownTable = Auxillary.Cooldowns

local Assets = services.rp.Assets.UI

CooldownManager.Cooldowns = {}

local DefaultCooldowns = require(services.rp.Shared.Info.CooldownManager)

function CooldownManager.new(user: Player)
	local self = setmetatable({}, CooldownManager)
	self.User = user
	CooldownManager.Cooldowns[user] = DefaultCooldowns

	print("Cooldown Manager Initialized for " .. user.Name)
	print(CooldownManager.Cooldowns)

	return self
end

function CooldownManager:CheckVar(variables)
	local isValid = true
	for i,v in pairs(variables) do
		if v == nil then
			isValid = false
		end
	end

	return isValid
end

function CooldownManager:GetCooldowns(user : Player)
	local userCooldowns = self.Cooldowns[user]
	if userCooldowns == nil then
		print("User Cooldown Not Found : "..user.." "..self.Cooldowns)
		return 
	end

	return userCooldowns
end

function CooldownManager:GetCooldown(user : Player, skillName)
	if Auxillary.CheckVariables({user, skillName}) == false then return end

	--[[local userCooldowns = self.Cooldowns[user]
	if userCooldowns == nil then
		return 
	end

	local skillCooldown = userCooldowns[skill]
	if skillCooldown == nil then
		return false
	end

	if skillCooldown.OnCooldown == true then
		return true
	end--]]

	local skill = self.Cooldowns[user][skillName]
	local lastUsed = skill.LastUsed

	local timeSince = tick() - lastUsed

	local cooldown;

	cooldown = 1

	if timeSince > cooldown then
		return false -- If cooldown has passed
	else
		return true -- If cooldown is active
	end

end

function CooldownManager:ClearSkillset()
	--[[
	for i, Skill in pairs(self.Cooldowns) do
		if Skill.Timer then
			Skill.Timer:Disconnect()
		end
		if Skill.Tile then
			Skill.Tile:Destroy()
		end
		self.Cooldowns[i] = nil
	end
	self.Cooldowns = {}
	--]]
end

function CooldownManager:AddSkill(user: Player, Skill: string, LayoutOrder: number)
	CooldownManager.Cooldowns[user]["Skill1"] = {
		OnCooldown = false,
		SkillName = Skill,
	}

	if LayoutOrder then
		--[[
		local Tile = Assets.SkillTile:Clone()
		Tile.SkillName.Text = Skill
		Tile.Key.Text = Key
		Tile.Cooldown.Text = ""
		Tile.LayoutOrder = LayoutOrder
		Tile.Parent = self.User.PlayerGui:WaitForChild("Main").MainFrame.Loadout
		self.Cooldowns[Skill].Tile = Tile
		--]]
	end
end

function CooldownManager:Cooldown(user : Player, skillName)
	if Auxillary.CheckVariables({user, skillName}) == false then return end
	print(user,skillName)
	local skill = self.Cooldowns[user][skillName]

	skill.LastUsed = tick()

	--user.InAction = true
	--task.wait()
 end

function CooldownManager:StartTimer(user : Player, skillName, skillType)
 	-- Types = Action or Skill (Abilities)
 	

end

function CooldownManager:OnCooldown(user : Player, Skill: string)
	if self.Cooldowns[user][Skill] then
		return self.Cooldowns[Skill].OnCooldown
	end
	warn("Skill Not Found, Wrong Name?")
	return nil
end

function CooldownManager:Action(user)
	self.Cooldowns[user].InAction = true
end

function CooldownManager:FreeAction(user)
	self.Cooldowns[user].InAction = false
end

function CooldownManager:CanAction(user)
	return not self.Cooldowns[user].InAction
end

return CooldownManager
