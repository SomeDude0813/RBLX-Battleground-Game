local user = game.Players.LocalPlayer

local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services
local inputTable = Auxillary.Inputs

local skillset = user:WaitForChild("Skillset")
local skillsetModule;

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
	if actionName == "M1" then
		skillsetModule.Action(user, inputState)
	end
end

local function bindInputs()
	for actionName, Key in pairs(inputTable) do
		CAS:BindAction(actionName, onInput, false, Key)
	end
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