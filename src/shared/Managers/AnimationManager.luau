local AnimationManager = {}
AnimationManager.__index = AnimationManager

local Auxillary = require(game:GetService("ReplicatedStorage").Shared.Auxillary.Auxillary)
local services = Auxillary.Services

local User: Player
local Character: Model
local Humanoid: Humanoid
local Animator: Animator

local AnimationFolder = services.rp.Assets.Animations
local Animations = {}
for _, animation in pairs(AnimationFolder:GetDescendants()) do
	if animation:IsA("Animation") then
		Animations[animation.Name] = animation
	end
end
print("Animations Loaded")
print(Animations)

function AnimationManager.Init()
	User = game.Players.LocalPlayer
	Character = User.Character or User.CharacterAdded:Wait()
	Humanoid = Character:FindFirstChild("Humanoid")
	Animator = Humanoid:FindFirstChild("Animator")

	User.CharacterAdded:Connect(function(newChar)
		Character = newChar
		Humanoid = Character:WaitForChild("Humanoid", 1)
		Animator = Humanoid:WaitForChild("Animator", 1)
	end)

	for _, animation in Animations do
		Animator:LoadAnimation(animation)
	end
end

function AnimationManager:StopAllAnimations()
	local animations = Animator:GetPlayingAnimationTracks()
	for _, animation in animations do
		animation:Stop()
	end
end

function AnimationManager:Play(animationName, data)
	local FadeTime = 1 -- Default
	local Weight = 1 -- Default
	local Speed = 1 -- Default
	do
		if data.FadeTime then
			FadeTime = data.FadeTime
		else
			warn("Default Fadetime")
		end
		if data.Weight then
			Weight = data.Weight
		end
		if data.Speed then
			Speed = data.Speed
		end
	end

	--self:StopAllAnimations()

	local animation = Animations[animationName]
	if animation == nil then
		warn("Animation Not Found, Wrong Name?" .. tostring(animationName))
	end

	local animTrack = Animator:LoadAnimation(animation)
	animTrack:Play(FadeTime, Weight, Speed)

	warn("Animation Played : " .. animationName)
end

function AnimationManager:Stop(animationName, FadeTime)
	if FadeTime == nil then
		FadeTime = 1 -- Default
		warn("FadeTime Not Found (Defaulted to " .. FadeTime .. ")")
	end

	if Animations[animationName] == nil then
		warn("Animation Not Found, Wrong Name? : " .. tostring(animationName))
	end

	local playingAnimations = Animator:GetPlayingAnimationTracks()
	warn(playingAnimations)
	for _, anim in playingAnimations do
		if anim.Name == animationName then
			anim:Stop(FadeTime)
			anim.Stopped:Connect(function()
				task.delay(FadeTime, function()
					--anim:Destroy()
				end)
			end)
			warn("Animation Stopped")
		end
	end
end

return AnimationManager
