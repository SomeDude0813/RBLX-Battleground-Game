local animations = {}

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local AnimationManager = require(services.rp.Shared.Managers.AnimationManager)

local user = game.Players.LocalPlayer
local char = user.Character or user.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local animator: Animator = humanoid:WaitForChild("Animator")

AnimationManager.Init()

local footstepVFX = char:WaitForChild("FootstepVFX")

local LStep = footstepVFX:WaitForChild("LStep").ParticleEmitter
local RStep = footstepVFX:WaitForChild("RStep").ParticleEmitter

animator.AnimationPlayed:Connect(function(animTrack)
	if animTrack.Name == "WalkAnim" then
		animTrack:GetMarkerReachedSignal("RStep"):Connect(function()
			LStep:Emit(1)
		end)
		animTrack:GetMarkerReachedSignal("LStep"):Connect(function()
			RStep:Emit(1)
		end)
	end
end)
