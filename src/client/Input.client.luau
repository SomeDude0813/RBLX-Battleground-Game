local user = game.Players.LocalPlayer
local char = user.Character or user.CharacterAdded:Wait()

local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services
local inputTable = Auxillary.Inputs

local MovementManager = require(services.rp.Shared.Managers.MovementManager)
local StateManager = require(services.rp.Shared.Managers.StateManager)

local CombatEvent = services.rp.Remotes.Events.CombatEvent
local MovementEvent: RemoteEvent = services.rp.Remotes.Events.MovementEvent
local InputEvent: RemoteEvent = services.rp.Remotes.Events.InputEvent

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

	if state == "Begin" and actionName == "Sprint" then
		InputEvent:FireServer(actionName, {})
	end
end

--services.uis.InputBegan:Connect(handleInput)

local function bindInputs()
	CAS:BindAction("Sprint", onInput, false, inputTable["Sprint"])
	CAS:BindAction("Dash", onInput, false, inputTable["Dash"])
	CAS:BindAction("M1", onInput, false, inputTable["M1"])
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
