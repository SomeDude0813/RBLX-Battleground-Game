local plr = game.Players.LocalPlayer
local skillset
local skillsetModule

local Auxillary = require(game.ReplicatedStorage.Shared.Auxillary.Auxillary)
local services = Auxillary.Services
local inputTable = Auxillary.InputTable

local Action = services.rp.Remotes.Action

local CAS = services.cas

function SetUpPlayer()
	local c = plr.Character or plr.CharacterAdded:Wait()
	local h = c:WaitForChild("Humanoid")

	h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
end

function SetUpSkillset()
	skillset = plr:WaitForChild("Skillset").Value


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

local function onInput(actionName, inputState)
	if actionName == "M1" then
		skillsetModule.OnM1(inputState)
	end
end

local function bindInputs()
	for actionName, Key in pairs(inputTable) do
		CAS:BindAction(actionName, onInput, false, Key)
	end
end

bindInputs()
