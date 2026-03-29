local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local plr: Player = services.p.LocalPlayer

local c: Model = plr.Character or plr.CharacterAdded:Wait()
local h: Humanoid = c:WaitForChild("Humanoid")

h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

local VFX = require(services.rp.Modules.Auxillary.VFX)

local CooldownManager = require(services.rp.Modules.Managers.CooldownManager)
local MovementManager = require(services.rp.Modules.Managers.MovementManager)

--[[
--//Camera Shaking Stuff--
local camera = workspace.CurrentCamera
local oldCamCF
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	if oldCamCF then
		local _,_,z = shakeCFrame:ToOrientation()
		local x,y,_ = shakeCFrame:ToObjectSpace(oldCamCF):ToEulerAnglesXYZ()
		camera.CFrame = camera.CFrame * CFrame.Angles(x,y, -z) 
	end
	oldCamCF = shakeCFrame
end)
camShake:Start()
--]]

--//Data that is sent to skillsets
local ClientData = {
	--CameraShake = camShake,
	Mouse = plr:GetMouse(),
	Function = {},
	CooldownManager = CooldownManager.new(plr),
	PlayerData = nil,
	MovementManager = nil,
}

ClientData.MovementManager = MovementManager.new(plr, ClientData.CooldownManager)

--ClientData.PlayerData = GetData:InvokeServerAsync()

--//Skillset
local CurrentSkillsetName = nil
local CurrentSkillset = {}
ClientData.Skillset = CurrentSkillsetName

function SetUpSkillset(Name)
	if Name == nil then
		Name = "Demo" -- Default Skillset
	end
	CurrentSkillsetName = Name

	for i, Module in pairs(services.rp.Modules.Skillsets[Name]:GetChildren()) do
		local Skill = require(Module)
		if Module.Name == "Skillset" then
			--plr.PlayerGui.Main.MainFrame.UltBar.UltName.Text = "None"
			CurrentSkillset.Skillset = require(services.rp.Modules.Skillsets[Name].Skillset).new(plr, ClientData)
			for i, skill in pairs(CurrentSkillset.Skillset.Skills) do
				ClientData.CooldownManager:AddSkill(skill.Name, skill.Cooldown, skill.Key)
			end
		else
			CurrentSkillset[Skill.Key] = Skill.new(plr, ClientData)
			ClientData.CooldownManager:AddSkill(Skill.Name, Skill.Cooldown, Skill.Key, Skill.UILayoutOrder)
		end
	end
end

function SetDownSkillSet()
	ClientData.CooldownManager:ClearSkillset()
	CurrentSkillset = {}
end

ClientData.Function.SetUpSkillset = SetUpSkillset()

--//Input
function handleInputs(input, gpe)
	local convertedInput = ""
	local state = input.UserInputState == Enum.UserInputState.End and "End" or "Begin"

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		convertedInput = "M1"
	elseif input.KeyCode.Value >= 48 and input.KeyCode.Value <= 57 then
		convertedInput = tostring(input.KeyCode.Value - 48)
	else
		convertedInput = input.KeyCode.Name
	end

	if plr.Character.Humanoid.Health <= 0 then
		return
	end
	if
		(state == "End" or ClientData.CooldownManager:CanAction())
		and ClientData.MovementManager.States.Stun == false
		and plr.Character.StatusFolder:FindFirstChild("Stun") == nil
	then
		if CurrentSkillset[convertedInput] then
			CurrentSkillset[convertedInput][state](CurrentSkillset(convertedInput))
		elseif CurrentSkillset.Skillset.Skills[convertedInput] then
			local skill = CurrentSkillset.Skillset.Skills[convertedInput].Name
			CurrentSkillset.Skillset[skill .. state](CurrentSkillset.Skillset)
		elseif convertedInput == "LeftShift" then
			ClientData.MovementManager["Sprint" .. state](ClientData.MovementManager)
		elseif convertedInput == "H" then
			plr.PlayerGui.Main.Enabled = not plr.PlayerGui.Main.Enabled
		end
	end
end

services.uis.InputBegan:Connect(handleInputs)
services.uis.InputEnded:Connect(handleInputs)
