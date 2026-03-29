local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)

local services = Auxillary.Services
local baseProps = Auxillary.BaseProperties

local BoatTween = require(services.rs.Modules.Auxillary.BoatTween)

local VFX = {}

function VFX.Tween(object : Instance, tweenData : BoatTween.TweenData)
	local tween = BoatTween.Create(object, tweenData)
	return tween
end

function VFX.CreateAndEmit(fx, pos : CFrame | Vector3)
	local vfx = fx:Clone()
	if typeof(pos) == "CFrame" then
		vfx.CFrame = pos
	else
		vfx.Position = pos
	end
	
	vfx.Parent =workspace.FX
	local longest=  0
	for i, v in pairs(vfx:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			if v.Lifetime.Max > longest then
				longest = v.Lifetime.Max
			end
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
	game.Debris:AddItem(vfx, longest)
end

function VFX.Emit(effect : BasePart)
	for i, v in pairs(effect:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
end

function VFX.EmitOnce(effect : BasePart, lifetime : number)
	VFX.Emit(effect)
	services.d:AddItem(effect, lifetime)
end

function VFX.EmitSustain(effect : BasePart)
	for i, v in pairs(effect:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
end

function VFX.EmitDisable(effect : BasePart)
	for i, v in pairs(effect:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			v.Enabled = false
		end
	end
end
function VFX.EmitEnable(effect : BasePart)
	for i, v in pairs(effect:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			v.Enabled = true
		end
	end
end

function VFX.Params()
	local params=  RaycastParams.new()
	params.FilterDescendantsInstances = {workspace.Map}
	params.FilterType = Enum.RaycastFilterType.Include
	return params
end

function VFX.MeshFlipbook(mesh : mesh, framerate : number, textures : table)
	for i, v in pairs(textures) do
		mesh.TextureId = v
		task.wait(1/framerate)
	end
end

local activeImpactFrame = nil


function VFX.ResetLighting()
	services.ts:Create(services.l.ImpactFrame, TweenInfo.new(0), {Brightness = 0, Contrast = 0, Saturation = 0}):Play()
	services.ts:Create(
		services.l.Blur,
		TweenInfo.new(0),
		{
			Size = 0
		}
	):Play()
end

impactFrames = {
	[1] = function()
		task.wait()
		services.l.ImpactFrame.Brightness = -.5
		services.l.ImpactFrame.Contrast = -30
		services.l.ImpactFrame.Saturation = -(Auxillary.BaseProperties.ColorCorrection.Saturation+1)
		task.wait(.1)
		services.l.ImpactFrame.Brightness = 0
		services.l.ImpactFrame.Contrast = 0
		services.l.ImpactFrame.Saturation = 0
	end,
	
	[2] = function()
		
		
		services.ts:Create(services.l.ImpactFrame, TweenInfo.new(.3), {Brightness = -.2, Saturation = -.2}):Play()
		
		task.wait(.3)
		services.ts:Create(
			services.l.ImpactFrame, 
			TweenInfo.new(
				.1, 
				Enum.EasingStyle.Back, 
				Enum.EasingDirection.Out), 
			{
				Contrast = 1.6,
				Brightness = .8,
				Saturation = .3
			}
		):Play()
		
		task.wait(.1)
		VFX.ResetLighting()
	end,
	
	[3] = function()
		
		services.ts:Create(
			services.l.Blur,
			TweenInfo.new(.1),
			{
				Size = 12
			}
		):Play()
		task.wait(.1)
		VFX.ResetLighting()
	end,
	
	[4] = function()--the restarted epilepsy heartattack impact frame
		services.ts:Create(services.l.ImpactFrame, TweenInfo.new(.3), {Brightness = -.2, Saturation = -.2}):Play()
		services.ts:Create(services.l.Blur,TweenInfo.new(.3),{Size = math.random(3,6)}):Play()
		task.wait(.3)
		for bab = 1, 4 do
			for i = -1, 1,2 do
				services.ts:Create(
					services.l.ImpactFrame, 
					TweenInfo.new(
						.1, 
						Enum.EasingStyle.Back, 
						Enum.EasingDirection.Out), 
					{
						Contrast = math.random(6 - i ,10 + i) * i,
						Brightness = math.random(-12- i,-8+ i) * i ,
						Saturation = math.random(20 - i,100 + i)/20 * i
					}
				):Play()
				services.ts:Create(
					workspace.CurrentCamera, 
					TweenInfo.new(
						.1, 
						Enum.EasingStyle.Back, 
						Enum.EasingDirection.Out), 
					{
						FieldOfView = 70 + math.abs(i-1) * 30
					}
				):Play()
				task.wait(.1)
			end
		end
		--workspace.CurrentCamera.FieldOfView = 70
		VFX.ResetLighting()
	end,
}


function VFX.ImpactFramePreset(preset : number) -- [1, 4]
	if activeImpactFrame then
		task.cancel(activeImpactFrame)
	end
	VFX.ResetLighting()
	activeImpactFrame = task.spawn(impactFrames[preset])
end

function VFX.ScaleParticle(particlePart : BasePart, scale : number)
	local props = {
		"Speed",
		"Acceleration",
		"Size",
	}
	
	for i, v in pairs(particlePart:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			for i, prop in pairs(props) do
				v[prop] = Auxillary.ScaleValue(v[prop], scale)
			end
		end
	end
end

function VFX.SimpleProjectile(model : Model, origin : Vector3, velocity : Vector3, acceleration : Vector3, range : number, exclude : {}, func, fuc)
	local proj
	
	if model:IsA("Model") then
		proj = model
	else
		proj = model
	end
	
	proj:PivotTo(CFrame.new(origin, origin + velocity))
	
	local dist = 0
	
	local con
	con = services.RS.Heartbeat:Connect(function(dt)
		local curPos = proj:GetPivot().Position
		local nextPos = proj:GetPivot().Position + (velocity * dt) + (acceleration * dt * dt)
		
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = exclude
		
		dist += (curPos - nextPos).Magnitude
		
		local result 
		if not (model:IsA("BasePart") and model.Size ~= Vector3.new(3,3,3)) then
			result = workspace:Raycast(curPos, (velocity * dt) + (1/2 * acceleration * dt * dt), params)
		else
			result = workspace:Blockcast(CFrame.new(curPos, nextPos),model.Size,(velocity * dt) + (1/2 * acceleration * dt * dt), params)
		end	
		if result then
			proj:PivotTo(CFrame.new(result.Position, curPos) * CFrame.Angles(0,math.pi,0))
			con:Disconnect()
			if func then
				local ResultTable = {
					Position = result.Position,
					Instance = result.Instance,
					Normal = result.Normal,
					Projectile = proj,
					Material = result.Material,
				}
				
				func(ResultTable)
			end
			return
		elseif dist >= range then
			con:Disconnect()
			if fuc then
				fuc(proj)
			else
				proj:Destroy()
			end
			return
		end
		velocity = velocity + acceleration * dt
		proj:PivotTo(CFrame.new(nextPos, curPos) * CFrame.Angles(0,math.pi,0))
		
		
	end)
	return {Projectile = proj}
end

function VFX.ToSurfaceCFrame(position : Vector3, normal : Vector3)
	return CFrame.new(position + normal.Unit * .01, position + normal) * CFrame.Angles(math.rad(-90),0,0)
end

function VFX.PartAppearanceFromRayResult(result : RaycastResult, part : Part)
	part.Material = result.Material
	if result.Instance == workspace.Terrain then
		part.Color = workspace.Terrain:GetMaterialColor(result.Material)
	else
		part.Color = result.Instance.Color
		part.Transparency = result.Instance.Transparency
		for i, v in pairs(result.Instance:GetChildren()) do
			if v:IsA("Texture") then
				local c = v:Clone()
				c.Parent = part
			end
		end
	end
end

function VFX.Crater(CraterData : {})
	local Position = CraterData.Position
	local CastDirection = CraterData.CastDirection or Vector3.new(0,-100,0)
	local Segments = CraterData.Segments or 8
	local Radius = CraterData.Radius
	local Normal = CraterData.Normal or Vector3.new(0,1,0)
	local Lifespan = CraterData.Lifespan or 4
	local Layers = CraterData.Layers or 1
	local BaseSize = CraterData.BaseSize or Vector3.new(2,2,2)
	local FlyingRocks = CraterData.FlyingRocks or Radius
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {workspace.Map, workspace.Terrain}
	
	local centerPos = Position
	
	local baseCF = CFrame.new(centerPos, centerPos + Normal) * CFrame.Angles(math.rad(-90),0,0)
	
	
	
	for l = 1, Layers do
		local angle = 360/Segments

		for i = 1, Segments do
			local testCF = baseCF * CFrame.Angles(0,(i-1) * math.rad(Auxillary.Random(angle * .9, angle * 1.1)),0) * CFrame.new(0,0,-Radius)

			local testRes = workspace:Raycast(testCF.Position + Normal, Normal * -2, params)
			if testRes then
				local pt = Instance.new("Part")
				pt.CFrame = testCF * CFrame.Angles(math.rad(Auxillary.Random(25,45)),0,0)
				pt.Position = testRes.Position
				VFX.PartAppearanceFromRayResult(testRes, pt)
				pt.Anchored = true
				pt.CanCollide = false
				local size = BaseSize * Auxillary.Random(80,120)/100
				pt.Size = Vector3.new(0,0,0)
				services.ts:Create(pt, TweenInfo.new(.2), {Size = size}):Play()
				pt.Parent = workspace.FX

				task.delay(Lifespan, function()
					services.ts:Create(pt, TweenInfo.new(1), {Size = Vector3.new(0,0,0), Position = pt.Position - Normal}):Play()
					task.wait(1)
					pt:Destroy()
				end)
			end
		end
		
		local MaxSize = BaseSize.Magnitude
		
		for i = 1, FlyingRocks do
			local testCF = baseCF * CFrame.Angles(0,math.rad(Auxillary.Random(0,360)), 0) * CFrame.new(0,0,-1 * Radius/3)
			local testRes = workspace:Raycast(testCF.Position + Normal, Normal * -2, params)
			if testRes then
				local pt = Instance.new("Part")
				pt.CFrame = testCF * CFrame.Angles(math.rad(Auxillary.Random(25,45)),0,0)
				pt.Position = testRes.Position + testRes.Normal
				VFX.PartAppearanceFromRayResult(testRes, pt)
				pt.Anchored = false
				pt.CanCollide = true
				pt.Size = Vector3.new(Auxillary.Random(MaxSize,MaxSize * 10),Auxillary.Random(MaxSize,MaxSize * 10),Auxillary.Random(MaxSize,MaxSize * 10))/20
				pt.Parent = workspace.FX
				pt.Massless = true
				pt.AssemblyLinearVelocity = (Normal * Auxillary.Random(50,150) + Vector3.new(Auxillary.Random(-10,10),Auxillary.Random(-10,10),Auxillary.Random(-10,10)))
				task.delay(Lifespan, function()
					services.ts:Create(pt, TweenInfo.new(1), {Transparency = 1}):Play()
					task.wait(1)
					pt:Destroy()
				end)	
			end			
		end
		baseCF *= CFrame.Angles(0,Auxillary.Random(0,360),0)
		Radius *= 1.2
		BaseSize *= 1.2
	end
end

function VFX.PropertyChange(fx, propname, newval)
	local function change(fx)
		fx[propname] = newval
	end
	if fx:IsA("ParticleEmitter") then
		change(fx)
	else
		for i, v in fx:GetDescendants() do
			if v:IsA("ParticleEmitter") then
				change(v)
			end
		end
	end
end

function VFX.CFRandomAngles()
	return CFrame.Angles(math.rad(Auxillary.Random(0,360)),math.rad(Auxillary.Random(0,360)),math.rad(Auxillary.Random(0,360)))
end



return VFX
