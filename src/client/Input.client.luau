local user = game.Players.LocalPlayer
local char = user.Character or user.CharacterAdded:Wait()

local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services
local inputTable = Auxillary.Inputs

local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

local CombatEvent = services.rp.Remotes.Events.CombatEvent
local MovementEvent = services.rp.Remotes.Events.MovementEvent

local CAS = services.cas

local skillset = user:WaitForChild("Variables"):WaitForChild("Skillset")

local function onInput(actionName, inputState)
	if skillset.Value == "None" then
		print("no skillset")
		return
	end

	local state
	do
		if inputState == Enum.UserInputState.Begin then
			state = "Begin"
		elseif inputState == Enum.UserInputState.End then
			state = "End"
		end
	end

	if actionName == "Sprint" then
		MovementManager["Sprint" .. state](nil, user)
	end

	if actionName == "Dash" then
		MovementEvent:FireServer("Dash", { State = state })
	end

	if actionName == "M1" then
		CombatEvent:FireServer("M1", { State = state })
	end
	if actionName == "SpawnCharacter" then
		if state == "Begin" then
			services.rp.Remotes.Events.SpawnEvent:FireServer("Fire")
		end
	end
end

--services.uis.InputBegan:Connect(handleInput)

local function bindInputs()
	CAS:BindAction("Sprint", onInput, false, inputTable["Sprint"])
	CAS:BindAction("Dash", onInput, false, inputTable["Dash"])
	CAS:BindAction("M1", onInput, false, inputTable["M1"])
	CAS:BindAction("SpawnCharacter", onInput, false, Enum.KeyCode.F)
end

bindInputs()

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
