local CooldownManager = {}
CooldownManager.__index = CooldownManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local Inputs = Auxillary.Inputs
local CooldownTable = Auxillary.Cooldowns

local Assets = services.rp.Assets.UI

CooldownManager.Cooldowns = {}


function CooldownManager.new(user: Player)
	local self = setmetatable({}, CooldownManager)
	self.User = user
	CooldownManager.Cooldowns[user] = {}

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

function CooldownManager:GetCooldown(user : Player, skill)
	if CooldownManager:CheckVariables({user, skill}) == false then return end

	local userCooldowns = self.Cooldowns[user]
	if userCooldowns == nil then
		return 
	end

	local skillCooldown = userCooldowns[skill]
	if skillCooldown == nil then
		return false
	end

	if skillCooldown.OnCooldown == true then
		return true
	end

	return false
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

function CooldownManager:Cooldown(Skill) end

function CooldownManager:OnCooldown(Skill: string)
	if self.Cooldowns[Skill] then
		return self.Cooldowns[Skill].OnCooldown
	end
	warn("Skill Not Found, Wrong Name?")
	return nil
end

function CooldownManager:Action()
	self.InAction = true
end

function CooldownManager:FreeAction()
	self.InAction = false
end

function CooldownManager:CanAction()
	return not self.InAction
end

return CooldownManager
