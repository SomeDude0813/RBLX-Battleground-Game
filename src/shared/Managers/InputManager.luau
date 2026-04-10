local InputManager = {}
InputManager.__index = InputManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local CAS = services.cas

local ActionModules = {}

InputManager.Inputs = {
	["W"] = false,
	["A"] = false,
	["S"] = false,
	["D"] = false,
}

function InputManager.new()
	for _, module in services.rp.Shared.Managers.InputModules:GetChildren() do
		if module:IsA("ModuleScript") then
			ActionModules[module.Name] = require(module)
		end
	end

	InputManager:BindInputs()
end

function InputManager:BindInputs()
	local function onInput(actionName, inputState)
		local state
		do
			if inputState == Enum.UserInputState.Begin then
				state = "Begin"
			else
				state = "End"
			end
		end

		if state == "Begin" then
			self.Inputs[actionName] = true
		else
			self.Inputs[actionName] = false
		end
	end

	local function onAction(actionName, inputState)
		local state
		do
			if inputState == Enum.UserInputState.Begin then
				state = true
			else
				state = false
			end
		end

		ActionModules[actionName]:Fire(state)
	end

	CAS:BindActionAtPriority("W", onInput, false, 1, Enum.KeyCode.W)
	CAS:BindActionAtPriority("A", onInput, false, 1, Enum.KeyCode.A)
	CAS:BindActionAtPriority("S", onInput, false, 1, Enum.KeyCode.S)
	CAS:BindActionAtPriority("D", onInput, false, 1, Enum.KeyCode.D)
	CAS:BindAction("Sprint", onAction, false, Enum.KeyCode.LeftShift)
	CAS:BindAction("Dash", onAction, false, Enum.KeyCode.Q)
end

return InputManager
