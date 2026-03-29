local Hitbox = {}
local debugMode = game["Run Service"]:IsStudio()
debugMode = false

local Auxillary = require(game:GetService("ReplicatedStorage").Modules.Auxillary.Auxillary)
local services = Auxillary.Services

export type HitBoxData = {
	CFrame : CFrame,
	Size : Vector3,
	IgnoreList : {Instance},
	Func : ({CFrame : CFrame, Size : Vector3, Hit : Instance}) -> (),
}

export type WeldData = {
	Offset : CFrame,
	Part : BasePart
}

function Hitbox.Hitbox(hbData : HitBoxData)
	local cframe = hbData.CFrame
	local size = hbData.Size
	local ignoreList = hbData.IgnoreList or {}
	
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {workspace.Humanoids}
	
	local hb
	local pt
	if debugMode then
		pt = Instance.new("Part")
		pt.Transparency = .8
		pt.Material = Enum.Material.SmoothPlastic
		pt.Color = Color3.fromRGB(0,255,0)
		pt.CFrame = cframe
		pt.Size = size
		pt.CanCollide = false
		pt.CanQuery = false
		pt.Anchored = true
		pt.Parent = workspace.FX
		
		services.d:AddItem(pt, .1)
		
		hb =  workspace:GetPartsInPart(pt, params)
	else
		hb = workspace:GetPartBoundsInBox(cframe, size, params)
	end
	
	local hitList = {}
	
	for i, part in pairs(hb) do
		if part.Parent:FindFirstChildWhichIsA("Humanoid") and not table.find(ignoreList, part.Parent) and not hitList[part.Parent] then
			hitList[part.Parent] = true
			if pt then
				pt.Color = Color3.fromRGB(255,0,0)
				pt.Material = Enum.Material.Neon
				pt.Transparency = .5
			end
		end
	end
	
	return hitList
end
function Hitbox.Hitbox2(hbData : HitBoxData)
	local cframe = hbData.CFrame
	local size = hbData.Size
	local ignoreList = hbData.IgnoreList or {}

	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {workspace.Humanoids}

	local hb
	local pt
	if debugMode then
		pt = Instance.new("Part")
		pt.Transparency = .8
		pt.Material = Enum.Material.SmoothPlastic
		pt.Color = Color3.fromRGB(0,255,0)
		pt.CFrame = cframe
		pt.Size = size
		pt.CanCollide = false
		pt.CanQuery = false
		pt.Anchored = true
		pt.Parent = workspace.FX

		services.d:AddItem(pt, .1)

		hb =  workspace:GetPartsInPart(pt, params)
	else
		hb = workspace:GetPartBoundsInBox(cframe, size, params)
	end

	local hitList = {}

	for i, part in hb do
		if part.Parent:FindFirstChildWhichIsA("Humanoid") and not table.find(ignoreList, part.Parent) and not table.find(hitList,part.Parent) then
			table.insert(hitList, part.Parent)
			if pt then
				pt.Color = Color3.fromRGB(255,0,0)
				pt.Material = Enum.Material.Neon
				pt.Transparency = .5
			end
		end
	end

	return hitList
end

function Hitbox.Round(hbData : HitBoxData, radius : number)
	local cframe = hbData.CFrame
	local ignoreList = hbData.IgnoreList

	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {workspace.Humanoids}

	local hb
	local pt
	if debugMode then
		pt = Instance.new("Part")
		pt.Transparency = .8
		pt.Material = Enum.Material.SmoothPlastic
		pt.Color = Color3.fromRGB(0,255,0)
		pt.CFrame = cframe
		pt.Size = Vector3.new(radius * 2,radius * 2,radius * 2)
		pt.CanCollide = false
		pt.CanQuery = false
		pt.Anchored = true
		pt.Shape = Enum.PartType.Ball
		pt.Parent = workspace.FX

		services.d:AddItem(pt, .1)

		hb =  workspace:GetPartsInPart(pt, params)
	else
		hb = workspace:GetPartBoundsInRadius(cframe.Position, radius, params)
	end
	
	local hitList = {}

	for i, part in pairs(hb) do
		if part.Parent:FindFirstChildWhichIsA("Humanoid") and not table.find(ignoreList, part.Parent) and not table.find(hitList, part.Parent) then
			table.insert(hitList,part.Parent)
			if pt then
				pt.Color = Color3.fromRGB(255,0,0)
				pt.Material = Enum.Material.Neon
				pt.Transparency = .5
			end
		end
	end

	return hitList
end

function Hitbox.LingeringHitbox(hbData : HitBoxData, length : number, weldData : WeldData)
	local startTime = time()
	local con
	con = services.RS.Heartbeat:Connect(function(dt)
		if time() - startTime >= length then
			con:Disconnect()
		end	
		
		if weldData.Part then
			hbData.CFrame = weldData.Part.CFrame * weldData.Offset
		end
		
		local hl = Hitbox.Hitbox(hbData)
		for hit, _ in pairs(hl) do
			if hbData.Func then
				local hitData = {
					CFrame = hbData.CFrame,
					Size = hbData.Size,
					Hit = hit,
				}
				hbData.Func(hitData)
			end
			table.insert(hbData.IgnoreList, hit)
		end
	end)
end

return table.freeze(Hitbox)
