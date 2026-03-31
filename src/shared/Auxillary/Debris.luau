local Debris = {}

local TS : TweenService = game:GetService("TweenService")

function Debris.SpawnPart(size, cf, centerCF, material, transparency, color, tweenInfo)
    local part : Part = Instance.new("Part")
    part.Material = material
    part.Size = Vector3.new(0,0,0)
    part.Name = "CraterPart"
    part.Transparency = transparency
    part.Anchored = true
    part.CanCollide = false
    part.Color = color
    part.CFrame = centerCF
    TS:Create(part, tweenInfo, {Size = size, CFrame = cf}):Play()
    return part
end

function Debris.RandomAngle()
    return CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
end

function Debris.Crater(origin, direction, segments, radius, height, width, xAngle, speed, lifetime)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {workspace.Map}

    local cast = workspace:Raycast(origin, direction, params)

    if cast then
        local centerCF = CFrame.new(cast.Position, cast.Position + cast.Normal) * CFrame.Angles(math.rad(90),0,0)
        local angle = 360/segments
        local distance = radius * math.sin(math.rad((180 - angle)/2))
        local sideLength = 2 * (radius) * math.sin(math.rad(180/segments))
         
        
    end
end

return Debris