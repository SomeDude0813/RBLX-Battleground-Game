local CooldownManager = {}
CooldownManager.__index = CooldownManager

local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)
local services = Auxillary.Services

local Assets = services.rp.Assets.UI

function CooldownManager.new(user: Player)
	local self = setmetatable({}, CooldownManager)
	self.User = user
	self.Cooldowns = {}
	self.InAction = false

	return self
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

function CooldownManager:AddSkill(Skill: string, Length: number, Key: string, LayoutOrder: number)
	self.Cooldowns[Skill] = {
		OnCooldown = false,
		Length = Length,
		Key = Key,
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

function CooldownManager:Cooldown(Skill)
	local SkillCooldown = self.Cooldowns[Skill]
	if SkillCooldown then
		if SkillCooldown.Timer then
			warn("There is already a cooldown running for this skill")
			return
		end
		local Start = time()
		SkillCooldown.OnCooldown = true

		SkillCooldown.Timer = services.RS.RenderStepped:Connect(function(dt)
			local TimeElapsed = math.min((time() - Start), SkillCooldown.Length)
			if SkillCooldown.Tile then
				SkillCooldown.Tile.CooldownColder.UIGradient.Offset =
					Vector2.new(0, 1.5 * TimeElapsed / SkillCooldown.Length - 0.5)
				SkillCooldown.Tile.Cooldown.Text = math.ceil((SkillCooldown.Length - TimeElapsed) * 10) / 10
			end
			if TimeElapsed == SkillCooldown.Length then
				SkillCooldown.Timer:Disconnect()
				SkillCooldown.Timer = nil
				SkillCooldown.OnCooldown = false
				if SkillCooldown.Tile then
					SkillCooldown.Tile.Cooldown.Text = ""
				end
			end
		end)
	end
end

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
