local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)
local services = Auxillary.Services

local BridgeNet = require(game:GetService("ReplicatedStorage").Modules.Auxillary.BridgeNet2)
local Replicator = BridgeNet.ServerBridge("Replicator")
local Server = BridgeNet.ServerBridge("Server")
local DataChange = BridgeNet.ServerBridge("DataChange")
local GetData = BridgeNet.ServerBridge("GetData")

local Identifiers = {--bridgenet template for advanced usage
	test = BridgeNet.ReferenceIdentifier("Data"),
	action = BridgeNet.ReferenceIdentifier("Action"),
}

local Ragdoll = require(services.rs.Modules.Auxillary.Ragdoll)
local ProfileService = require(services.sss.Modules.Auxillary.ProfileService)
local ProfileStore = ProfileService.GetProfileStore("PlayerData", {
	Soul = 0,--kills get souls that can be spent if u wanna make a store ig
	LastDay = 0,--track day so we know when to reset
	DailySoul = 0,--track so we can limit soul gain per day(stop afk farmer)
	Kill = 0,--lifetime kill
})

services.ps:RegisterCollisionGroup("Uncollidable")
services.ps:RegisterCollisionGroup("Player")
services.ps:CollisionGroupSetCollidable("Uncollidable", "Player", false)

local LifetimeKillsSB = game:GetService("DataStoreService"):GetOrderedDataStore("lf")

local Profiles = {}

Replicator:Connect(function(p : Player, repData : any)
	repData.Data.Client = p
	Replicator:Fire(BridgeNet.AllPlayers(), repData)
	--Server:Fire(BridgeNet.PlayersExcept({p}), repData)
end)

Server:Connect(function(p : Player, sData : any)
	require(services.sss.Modules.Skillsets[sData.Skillset][sData.Module.."Server"])[sData.Action](p, sData.Data)
end)

DataChange:Connect(function(p : Player, sData : {any})
	require(services.sss.Modules.Data[sData.Action])(p, sData.Data, Profiles[p].Data)
end)
require(Auxillary.Services.sss.Modules.Auxillary.CommonMethods).Profiles = Profiles
DataChange.OnServerInvoke = function(p, sData)
	return require(services.sss.Modules.Data[sData.Action])(p, sData.Data, Profiles[p].Data)
end
GetData.OnServerInvoke = function(p :Player, sData : {any})
	return Profiles[p].Data
end

services.p.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		services.RS.Heartbeat:Wait()
		character.Parent = workspace.Humanoids
		
		local meshhead = script.Head:Clone()
		meshhead.CFrame = character:WaitForChild("Head").CFrame
		character.Torso.Neck.Part1 = meshhead

		meshhead.Color = character.Head.Color
		meshhead.face.Texture = character.Head.face.Texture
		character.Head:Destroy()
		meshhead.Parent = character
		
		character.PrimaryPart = character.HumanoidRootPart
		local humanoid = character.Humanoid
		humanoid.BreakJointsOnDeath = false
		humanoid.RequiresNeck = false

		local clones = {}
		for _, v in ipairs(services.rs.Modules.Auxillary.Ragdoll.RagdollParts:GetChildren()) do
			clones[v.Name] = v:Clone()
		end
		
		for _, v in pairs(character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CollisionGroup = "Player"
			end
		end

		local folder1 = Instance.new("Folder")
		folder1.Name = "RagdollConstraints"
		for _, v in pairs(clones) do
			if v:IsA("Attachment") then
				v.Parent = character[v:GetAttribute("Parent")]
			elseif v:IsA("BallSocketConstraint") then
				v.Attachment0 = clones[v:GetAttribute("0")]
				v.Attachment1 = clones[v:GetAttribute("1")]
				v.Parent = folder1
			end
		end
		folder1.Parent = character

		local folder2 = Instance.new("Folder")
		folder2.Name = "Motors"
		local value
		for _, v in ipairs(character.Torso:GetChildren()) do
			if v:IsA("Motor6D") then
				value = Instance.new("ObjectValue")
				value.Value = v
				value.Parent = folder2
			end
		end
		
		folder2.Parent = folder1
		
		local StatusFolder = Instance.new("Folder")
		StatusFolder.Name = "StatusFolder"
		StatusFolder.Parent = character

		local au = Instance.new("ObjectValue")
		au.Name = "Aura"
		au.Value = nil
		au.Parent = character
	end)
	local UserProfile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	
	if UserProfile ~= nil then
		UserProfile:AddUserId(player.UserId) -- GDPR compliance
		UserProfile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		UserProfile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(services.p) == true then
			Profiles[player] = UserProfile
			UserProfile.Data.Soul = 1000
			local day = DateTime.now():ToUniversalTime()
			day = day.Day + day.Year
			if UserProfile.Data.LastDay ~= day then
				UserProfile.Data.LastDay = day
			end
			--UserProfile.Data.Accessory = {}
			print("LOADED PROFILE")
			--print(UserProfile.Data, "p")
		else
			-- Player left before the profile loaded:
			UserProfile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick() 
	end	
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Kills"
	gold.Value = UserProfile.Data.Kill
	gold.Parent = leaderstats
	
	local UltimateBar = Instance.new("NumberValue")
	UltimateBar.Name = "Ultimate"
	UltimateBar.Value = 0
	UltimateBar.Parent = player
	
	do
		local a = Instance.new("NumberValue")
		a.Name = "LastCombat"
		a.Value = 0
		a.Parent = player
	end
	do
		local a = Instance.new("StringValue")
		a.Name = "Skillset"
		a.Value = "Demo"
		a.Parent = player
	end
	
	--task.spawn(function()
	--	services.RS.Heartbeat:Connect(function(dt)
	--		if UltimateBar.Value ~= 0 and UltimateBar.Value ~= 100 then
	--			UltimateBar.Value = math.max(UltimateBar.Value - dt, 0)
	--		end
	--	end)
		
	--end)
	
	local Character = Instance.new("StringValue")
	Character.Name = "Character"
	Character.Value = "Demo"
	Character.Parent = player
end)
services.p.PlayerRemoving:Connect(function(Player)
	if Profiles[Player] then
		task.spawn(function()
			local val = Profiles[Player].Data.Kill
			LifetimeKillsSB:UpdateAsync(Player.UserId, function(oldval,datastorekeyinfo : DataStoreKeyInfo)
				return val
			end)
		end)
		Profiles[Player]:Release()
	end
end)
function updateleaderboard()
	local pages = LifetimeKillsSB:GetSortedAsync(false, 50,1, 10e30)

	for i, v in workspace.Leaderboard.SurfaceGui.Scoreboard.Body:GetChildren() do
		if v:IsA("GuiBase") and v.Visible then
			v:Destroy()
		end
	end
	local top = pages:GetCurrentPage()

	for i , v in ipairs(top) do
		local userid =tonumber(v.key)
		local kills = v.value
		local s, PlayerInfo = pcall(function() 
			return game:GetService("UserService"):GetUserInfosByUserIdsAsync({userid})[1]
		end)
		local username,name
		if PlayerInfo then
			username = PlayerInfo.Username
			name = PlayerInfo.DisplayName
			
		else
			username = "error"
			name = 'error'
		end
		local clone= workspace.Leaderboard.SurfaceGui.Scoreboard.Body.PlayerCardTemp:Clone()
		clone.NameFrame.NameLabel.Text = username
		clone.NameFrame.NameLabel.NameLabel.Text = "@"..name
		clone.Num.Text = kills
		clone.NameFrame.PlaceText.Text = i
		local s, image = pcall(function()
			return Auxillary.Services.p:GetUserThumbnailAsync(userid, Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
		end)
		clone.NameFrame.Goat.Image = image
		clone.Parent = workspace.Leaderboard.SurfaceGui.Scoreboard.Body
		clone.Visible = true
	end
end
updateleaderboard()


for i, character in pairs(workspace.Humanoids:GetChildren()) do
	Ragdoll:Setup(character)
end

for i, part in pairs(workspace.Map.Breakable:GetDescendants()) do
	part:SetAttribute("Breakable", true)
end