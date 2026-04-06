local animations = {}

local user = game.Players.LocalPlayer
local char = user.Character or user.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local animator: Animator = humanoid:WaitForChild("Animator")

for _, anim in pairs(char.Animate:GetDescendants()) do
	if anim:IsA("Animation") then
		local animTrack = animator:LoadAnimation(anim)
		animations[anim.Name] = animTrack
	end
end

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
