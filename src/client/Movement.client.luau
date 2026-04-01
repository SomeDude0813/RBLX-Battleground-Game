local user = game.Players.LocalPlayer
local char = user.Character or user.CharacterAdded:Wait()

local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services
local inputTable = Auxillary.Inputs

local skillset = user:WaitForChild("Skillset")
local skillsetModule

local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

local Action = services.rp.Remotes.Events.Action

local CAS = services.cas

local function SetUpPlayer(skillset)
	local c = user.Character or user.CharacterAdded:Wait()
	local h = c:WaitForChild("Humanoid")

	h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	skillset = user:WaitForChild("Skillset").Value
	print(skillset)
	skillsetModule = require(services.rp.Shared.Skillsets[skillset].Skillset)
end

SetUpPlayer(skillset)

local function onInput(actionName, inputState)
	local state = "End" or "Begin"
	do
		if inputState == Enum.UserInputState.Begin then
			state = "Begin"
		else
			state = "End"
		end
	end

	if actionName == "Sprint" then
		Action:FireServer("Sprint", { State = state })
	end

	if actionName == "Dash" then
		if state == "Begin" then
			Action:FireServer("Dash")
		end
	end

	if actionName == "M1" then
		Action:FireServer("M1", { State = state })
	end
end

--services.uis.InputBegan:Connect(handleInput)

local function bindInputs()
	CAS:BindAction("Sprint", onInput, false, inputTable["Sprint"])
	CAS:BindAction("Dash", onInput, false, inputTable["Dash"])
	CAS:BindAction("M1", onInput, false, inputTable["M1"])
end

bindInputs()

Action.OnClientEvent:Connect(function(actionName, data)
	if actionName == "SetSkillset" then
		SetUpPlayer(data.Skillset)
	end

	if actionName == "Dash" then
		local tween = data.Tween
		print(actionName, data)
	end
end)

--[[
--//Camera Shaking Stuff--
local camera = workspace.CurrentCamera
local oldCamCF
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	if oldCamCF then
		local _,_,z = shakeCFrame:ToOrientation()
		local x,y,_ = shakeCFrame:ToObjectSpace(oldCamCF):ToEulerAnglesXYZ()
		camera.CFrame = camera.CFrame * CFrame.Angles(x,y, -z) 
	if skillset == "" then
		skillset = "Demo"
	end

	skillsetModule = require(services.rp.Modules.Skillsets[skillset].Skillset)
end
--]]
