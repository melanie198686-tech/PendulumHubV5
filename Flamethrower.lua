--[[
  Fixed this with a phone
]]

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris     = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse  = player:GetMouse()

-- ============================================================
-- PART 1 — "Suicide gun" alignment (needs Flamethrower Back)
-- ============================================================
_G.loop = true
local char = player.Character or player.CharacterAdded:Wait()

local function Align(Part0, Part1, removeMesh)
    local A0 = Instance.new("Attachment")
    local A1 = Instance.new("Attachment")

    local AO = Instance.new("AlignOrientation")
    AO.Attachment0     = A0
    AO.Attachment1     = A1
    AO.Responsiveness  = math.huge
    AO.RigidityEnabled = true
    AO.Parent          = Part0

    local AP = Instance.new("AlignPosition")
    AP.Attachment0     = A0
    AP.Attachment1     = A1
    AP.Responsiveness  = math.huge
    AP.RigidityEnabled = true
    AP.MaxForce        = 999999999
    AP.Parent          = Part0

    A0.Parent = Part0
    A1.Parent = Part1

    if removeMesh then
        local m = Part0:FindFirstChildOfClass("SpecialMesh")
        if m then m:Destroy() end
    end

    Part0:BreakJoints()

    task.spawn(function()
        while _G.loop do
            local target = Part1.CFrame * A0.CFrame:Inverse()
            if (Part0.Position - target.p).magnitude >= 5 then
                Part0.CFrame = target
            end
            Part0.Velocity = Vector3.new(0, 35, 0)
            RunService.Heartbeat:Wait()
        end
    end)

    return { A0, {Attach0 = A0, Attach1 = A1}, {AlignOrientation = AO, AlignPosition = AP} }
end

do
    local ftBack   = char:FindFirstChild("Flamethrower Back")
    local rightArm = char:FindFirstChild("Right Arm")
    if ftBack and rightArm then
        local handle = ftBack:FindFirstChild("Handle") or ftBack:FindFirstChildOfClass("Part")
        if handle then
            local hat = Align(handle, rightArm, false)
            local cf  = rightArm.CFrame
                * CFrame.new(0, -1, -0.5)
                * CFrame.Angles(math.rad(265), math.rad(-90), 0)
            hat[1].CFrame = cf:Inverse() * rightArm.CFrame

            task.spawn(function()
                char.AncestryChanged:Wait()
                _G.loop = false
            end)
        end
    else
        warn("[SUICIDE GUN] 'Flamethrower Back' accessory not found — Part 1 skipped.")
    end
end

-- ============================================================
-- PART 2 — Flamethrower
-- ============================================================
local targetChar = workspace:FindFirstChild("non")
if targetChar then
    char = targetChar
else
    warn("[SUICIDE GUN] Model 'non' not found in workspace — using LocalPlayer.Character.")
end

local function P(parent, props)
    local p = Instance.new("Part")
    p.BrickColor     = BrickColor.new("Really black")
    p.FormFactor     = Enum.FormFactor.Custom
    p.BottomSurface  = Enum.SurfaceType.Smooth
    p.TopSurface     = Enum.SurfaceType.Smooth
    for k, v in pairs(props) do p[k] = v end
    p.Parent = parent
    return p
end

local function M(parent, class, props)
    local mesh = Instance.new(class)
    mesh.Name = "Mesh"
    for k, v in pairs(props) do mesh[k] = v end
    mesh.Parent = parent
    return mesh
end

-- ---------- Flamethrower model ----------
local m = Instance.new("Model")
m.Name = "Flamethrower"

local p1 = P(m, {Size = Vector3.new(0.200000003, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-4.31863213, 1.2999835, 26.8280258, 0.898792505, -0.438372105, 6.44474255e-007, 4.2475844e-007, -8.7068031e-007, 0.999996066, -0.438369185, -0.898793578, 7.74858847e-007),
    CanCollide = false})
M(p1, "CylinderMesh", {Scale = Vector3.new(0.7, 1, 1.4)})

local p2 = P(m, {Size = Vector3.new(0.200000003, 0.799999952, 0.200000003),
    CFrame = CFrame.new(-4.22384691, 1.29998171, 27.1336765, -0.945517242, 0.325569242, 6.44474255e-007, -5.4352688e-007, 9.19547631e-007, 0.999996066, 0.325566202, 0.945517898, 7.74858847e-007),
    CanCollide = false})
M(p2, "CylinderMesh", {Scale = Vector3.new(0.9, 1, 1.5)})

local p3 = P(m, {Name = "Handle2", BrickColor = BrickColor.new("Black"),
    Material = Enum.Material.Grass,
    Size = Vector3.new(0.200000003, 0.400000006, 0.200000003),
    CFrame = CFrame.new(-4.36384678, 1.48997498, 26.7136898, 0.998628676, -0.0523356572, 1.65257313e-006, 0.0505531132, 0.964598, 0.258818507, -0.0135439271, -0.258463174, 0.96592474),
    CanCollide = false})
M(p3, "CylinderMesh", {Scale = Vector3.new(0.7, 1, 1.4)})

local p4 = P(m, {Size = Vector3.new(0.200000003, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-4.08384609, 1.29998279, 26.8336773, 6.66825997e-007, 1.56834642e-006, 0.999999166, 0.999996066, 6.85452505e-007, 7.1152931e-007, 8.0466117e-007, 0.999998689, 1.56834619e-006),
    CanCollide = false})
M(p4, "CylinderMesh", {Scale = Vector3.new(1.2, 0.5, 1.79)})

local p5 = P(m, {Size = Vector3.new(0.200000003, 1.79999995, 0.200000003),
    CFrame = CFrame.new(-4.08383894, 1.29998529, 27.6837158, 6.66825997e-007, 1.56834642e-006, 0.999999166, 0.999996066, 6.85452505e-007, 7.1152931e-007, 8.0466117e-007, 0.999998689, 1.56834619e-006),
    CanCollide = false})
M(p5, "CylinderMesh", {Scale = Vector3.new(1, 1, 1.7)})

local p6 = P(m, {Size = Vector3.new(1, 1.20000005, 1),
    CFrame = CFrame.new(-4.07870293, 1.24756896, 29.8614006, -0.0122325243, 0.00382106518, 0.999915302, 0.999817967, -0.0144664943, 0.0122870263, 0.0145196915, 0.999886394, -0.0036436012)})
M(p6, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.461538464, 0.769230723, 0.461538464)})
M(p6, "CylinderMesh", {Scale = Vector3.new(1, 0.9, 0.44)})
local d1 = Instance.new("Decal"); d1.Texture = "rbxassetid://85448092"; d1.Face = Enum.NormalId.Top; d1.Parent = p6

local p7 = P(m, {BrickColor = BrickColor.new("Institutional white"),
    Size = Vector3.new(1, 1.20000005, 1),
    CFrame = CFrame.new(-4.08290291, 1.26348102, 28.7615242, -0.0122325243, 0.00382106518, 0.999915302, 0.999817967, -0.0144664943, 0.0122870263, 0.0145196915, 0.999886394, -0.0036436012)})
M(p7, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.15384616, 1, 0.307692319)})
M(p7, "CylinderMesh", {Scale = Vector3.new(1.7, 1.1, 0.3)})

local p8 = P(m, {Name = "Barrel", Size = Vector3.new(1, 1.20000005, 1),
    CFrame = CFrame.new(-4.07320023, 1.24000597, 30.3669701, 0.999916196, 0.00121372147, 0.0126282591, 0.0122011788, 0.18082355, -0.983437181, -0.00347740925, 0.983514667, 0.180784032)})
M(p8, "SpecialMesh", {MeshId = "rbxassetid://1091603", TextureId = "", MeshType = Enum.MeshType.FileMesh, Scale = Vector3.new(0.3, 0.3, 0.3)})

local p9 = P(m, {Size = Vector3.new(0.288717359, 0.288717419, 0.288717419),
    CFrame = CFrame.new(-4.12095404, 1.04495895, 29.1705666)})
M(p9, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(1.37011397, 0.164413691, 1.50712562)})

local p10 = P(m, {BrickColor = BrickColor.new("Institutional white"),
    Size = Vector3.new(1, 1.20000005, 1),
    CFrame = CFrame.new(-4.07969093, 1.060624, 28.9585953, -0.999915302, -0.0122325243, -0.00382106518, -0.0122870263, 0.999817967, 0.0144664943, 0.0036436012, 0.0145196915, -0.999886394)})
M(p10, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.15384616, 0.153846145, 1)})

local p11 = P(m, {Name = "Handle", BrickColor = BrickColor.new("Institutional white"),
    Size = Vector3.new(1, 1.20000005, 1),
    CFrame = CFrame.new(-4.07311201, 0.707809985, 28.6968918, -0.999919653, 0.0111990925, 0.00594851235, -0.0121958125, -0.977798998, -0.209190041, 0.00347371167, -0.209245741, 0.977856994)})
M(p11, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.15384616, 0.538461506, 0.307692319)})

local p12 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.981667995, 29.0914536)})
M(p12, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.351311207, 0.351311326, 0.175655678)})

local p13 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.882772982, 29.1310101, -1, 0, 0, 0, 1, 0, 0, 0, -1)})
M(p13, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(0.351311207, 0.175655663, 0.175655678)})

local p14 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.882772982, 29.2496853)})
M(p14, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(0.351311207, 0.175655663, 0.175655678)})

local p15 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.922330976, 29.0914536)})
M(p15, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.351311207, 0.175655663, 0.175655678)})

local p16 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.12095404, 0.831354022, 28.9332237, 1, 4.23044048e-006, -3.67623443e-006, 4.23044048e-006, 1, 1.40141863e-008, -3.67623443e-006, 1.40141863e-008, 1)})
M(p16, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(1.75655627, 1.68629432, 0.175655678)})

local p17 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.12095404, 0.878817022, 28.9727783)})
M(p17, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(1.75655627, 1.2647208, 0.175655678)})

local p18 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.882772982, 29.0914536)})
M(p18, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.351311207, 0.175655663, 0.175655678)})

local p19 = P(m, {Size = Vector3.new(0.799999356, 0.200000003, 0.399999857),
    CFrame = CFrame.new(-4.08384228, 0.900013506, 26.983717, -9.93235176e-007, 0.999998927, 1.46056539e-006, -0.987684608, 6.33298328e-007, -0.156433105, -0.156434968, 1.56834574e-006, 0.987686932),
    CanCollide = false})
M(p19, "BlockMesh", {Scale = Vector3.new(1, 1, 0.7)})

local p20 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.12095404, 0.700815022, 29.0321178, 1, -5.8353038e-008, -6.71499549e-008, 6.71499549e-008, 2.22569144e-010, -1, -5.8353038e-008, 1, -2.22569144e-010)})
M(p20, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(1.75655627, 0.702622652, 0.175655678)})

local p21 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.12095404, 0.700815022, 29.3090191, -1, 0, 0, 0, 0, -1, 0, -1, 0)})
M(p21, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(1.75655627, 0.702622652, 0.175655678)})

local p22 = P(m, {Size = Vector3.new(0.799999356, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-4.08384562, 0.887999296, 27.1074524, -9.93235176e-007, 0.999998927, 1.46056539e-006, -0.987684608, 6.33298328e-007, -0.156433105, -0.156434968, 1.56834574e-006, 0.987686932),
    CanCollide = false})
M(p22, "BlockMesh", {Scale = Vector3.new(1, 0.3, 0.9)})

local p23 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.08139706, 0.843216002, 29.1705666)})
M(p23, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.351311207, 0.175655663, 0.878278494)})

local p24 = P(m, {Size = Vector3.new(0.474551886, 0.474551976, 0.474551976),
    CFrame = CFrame.new(-4.14073181, 0.728498995, 28.9727783)})
M(p24, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(0.750219524, 0.0333430953, 0.0833577439)})

local p25 = P(m, {Size = Vector3.new(0.225199535, 0.22519955, 0.22519958),
    CFrame = CFrame.new(-4.12095404, 0.661257982, 29.1705666)})
M(p25, "SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(1.75655627, 0.175655663, 1.93221235)})

local p26 = P(m, {Size = Vector3.new(0.474551886, 0.474551976, 0.474551976),
    CFrame = CFrame.new(-4.12095404, 0.601921976, 29.1705666, 1, 0, 0, 0, 0, 1, 0, -1, 0)})
M(p26, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(0.833577335, 0.916935086, 0.166715518)})

local p27 = P(m, {Name = "Handle3", BrickColor = BrickColor.new("Dark stone grey"),
    Transparency = 1,
    Size = Vector3.new(1, 1.4000001, 0.200000033),
    CFrame = CFrame.new(-4.08382893, 0.999998987, 28.0838623, 0.999999404, -1.18091657e-006, 5.96045709e-007, 5.96045652e-007, -6.55650126e-007, 0.999996662, 1.18091657e-006, -0.999998808, 6.55650069e-007)})
M(p27, "SpecialMesh", {MeshType = Enum.MeshType.Wedge, Scale = Vector3.new(0.25, 0.25, 0.2)})

m.Parent = char

-- ---------- Fueltank model ----------
local m2 = Instance.new("Model")
m2.Name = "Fueltank"

local f1 = P(m2, {BrickColor = BrickColor.new("Black"),
    Size = Vector3.new(0.400000036, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-0.283439994, 0.479694009, -15.516386, 1.56834642e-006, -6.78001982e-007, 0.999999046, 5.96045879e-007, -0.999996066, 6.63100707e-007, 0.999998689, -8.64265758e-007, 1.59814817e-006)})
M(f1, "CylinderMesh", {Scale = Vector3.new(2, 1.5, 1)})

local f2 = P(m2, {Name = "ChangeColor", BrickColor = BrickColor.new("Institutional white"),
    Material = Enum.Material.Neon,
    Size = Vector3.new(0.400000036, 1.19999981, 1),
    CFrame = CFrame.new(0.116168, 1.10000396, -15.0161295, 1.56834642e-006, -6.78001982e-007, 0.999999046, 5.96045879e-007, -0.999996066, 6.63100707e-007, 0.999998689, -8.64265758e-007, 1.59814817e-006),
    CanCollide = false})
M(f2, "CylinderMesh", {Scale = Vector3.new(2, 1, 1)})

local f3 = P(m2, {Name = "FuelCenter", BrickColor = BrickColor.new("Mid gray"),
    Material = Enum.Material.Neon,
    Size = Vector3.new(0.400000036, 0.799999833, 1),
    CFrame = CFrame.new(-0.283439994, 1.19967496, -15.5163736, 1.56834642e-006, -6.78001982e-007, 0.999999046, 5.96045879e-007, -0.999996066, 6.63100707e-007, 0.999998689, -8.64265758e-007, 1.59814817e-006)})
M(f3, "CylinderMesh", {Scale = Vector3.new(1.4, 1, 1)})

local f4 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(0.125933915, 0.449839592, -15.0262089, 0.000333837903, 0.000261210633, 0.999998927, -0.999996006, -5.68053565e-007, 0.000335178163, -7.72354667e-007, -0.999998629, 0.000264377333)})
M(f4, "SpecialMesh", {MeshType = Enum.MeshType.Sphere})

local f5 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(-0.283836007, 1.60003495, -15.5161457, -6.74276521e-007, -1.59814874e-006, 0.999998927, -0.999996066, -5.96045879e-007, 6.44474198e-007, -7.74858904e-007, -0.999998748, 1.56834574e-006)})
M(f5, "SpecialMesh", {MeshType = Enum.MeshType.Sphere, Scale = Vector3.new(0.71, 0.71, 0.71)})

local f6 = P(m2, {Size = Vector3.new(0.400000036, 0.200000003, 0.200000003),
    CFrame = CFrame.new(0.116157003, 2.09999895, -15.0161324, 1.5385441e-006, -6.66825883e-007, 0.999999046, 6.85452505e-007, -0.999996066, 6.74276464e-007, 0.999998748, -7.15254316e-007, 1.53854353e-006)})
M(f6, "CylinderMesh", {Scale = Vector3.new(2, 1, 1)})

local f7 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(0.116163999, 1.70000398, -15.0161362, 1.56834642e-006, -6.78001982e-007, 0.999999046, 5.96045879e-007, -0.999996066, 6.63100707e-007, 0.999998689, -8.64265758e-007, 1.59814817e-006)})
M(f7, "SpecialMesh", {MeshType = Enum.MeshType.Sphere})

local f8 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(-0.283437014, 0.779699028, -15.5163822, -6.74276521e-007, -1.59814874e-006, 0.999998927, -0.999996066, -5.96045879e-007, 6.44474198e-007, -7.74858904e-007, -0.999998748, 1.56834574e-006)})
M(f8, "SpecialMesh", {MeshType = Enum.MeshType.Sphere, Scale = Vector3.new(0.71, 0.71, 0.71)})

local f9 = P(m2, {Size = Vector3.new(0.400000036, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-0.28343299, 0.279718012, -15.5163898, 7.71134239e-007, 0.999998987, -1.59814874e-006, 0.999996066, 6.18397394e-007, -5.96045879e-007, 9.23870459e-007, 1.59814817e-006, -0.999998748)})
M(f9, "CylinderMesh", {Scale = Vector3.new(2, 1.5, 1)})

local f10 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(-0.68383199, 1.701056, -15.012146, -5.82017606e-007, 0.000486697129, 0.999998808, -0.999639988, -0.026683826, 1.37168181e-005, 0.0266824923, -0.999642611, 0.000489670201)})
M(f10, "SpecialMesh", {MeshType = Enum.MeshType.Sphere})

local f11 = P(m2, {Name = "ChangeColor2", BrickColor = BrickColor.new("Institutional white"),
    Material = Enum.Material.Neon,
    Size = Vector3.new(0.400000036, 1.19999981, 1),
    CFrame = CFrame.new(-0.683839977, 1.100003, -15.0161276, 1.3895326e-006, -6.48199716e-007, 0.999999166, 5.66243557e-007, -0.999996305, 6.33298498e-007, 0.999998689, -8.34463606e-007, 1.4491369e-006),
    CanCollide = false})
M(f11, "CylinderMesh", {Scale = Vector3.new(2, 1, 1)})

local f12 = P(m2, {Size = Vector3.new(0.400000036, 0.200000003, 0.200000003),
    CFrame = CFrame.new(-0.683830023, 2.10087895, -15.0254364, -0.000486697129, -7.13852432e-006, 0.999998868, 0.0266838577, -0.999639928, 7.20503476e-006, 0.999642491, 0.0266825818, 0.00048978941)})
M(f12, "CylinderMesh", {Scale = Vector3.new(2, 1, 1)})

local f13 = P(m2, {Size = Vector3.new(0.799999356, 0.799999356, 0.799999356),
    CFrame = CFrame.new(-0.683435977, 0.499675006, -15.0163736, -6.74276521e-007, -1.59814874e-006, 0.999998927, -0.999996066, -5.96045879e-007, 6.44474198e-007, -7.74858904e-007, -0.999998748, 1.56834574e-006)})
M(f13, "SpecialMesh", {MeshType = Enum.MeshType.Sphere})

m2.Parent = char

-- ---------- Weld chain (both models) ----------
local function weldChain(model)
    local prev
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            if prev then
                local weld = Instance.new("Weld")
                weld.Part0 = prev
                weld.Part1 = part
                weld.C0    = prev.CFrame:Inverse()
                weld.C1    = part.CFrame:Inverse()
                weld.Parent = prev
            end
            prev = part
        end
    end
end
weldChain(char.Fueltank)
weldChain(char.Flamethrower)

-- ---------- Weld to body ----------
local torso  = char:FindFirstChild("Torso")
local lArm   = char:FindFirstChild("Left Arm")
local rArm   = char:FindFirstChild("Right Arm")
if not (torso and lArm and rArm) then
    warn("[SUICIDE GUN] Missing R6 body parts on 'non' — aborting.")
    return
end

char.Fueltank.FuelCenter.CFrame = CFrame.new(torso.Position)

-- Replace shoulder joints with custom welds
local lSh = torso:FindFirstChild("Left Shoulder")
local rSh = torso:FindFirstChild("Right Shoulder")
if lSh then lSh.Part1 = nil end
if rSh then rSh.Part1 = nil end

local w1 = Instance.new("Weld")
w1.Part0 = torso
w1.Part1 = lArm
w1.C1    = CFrame.new(-0.249, 1.35, 0.6) * CFrame.fromEulerAnglesXYZ(math.rad(290), 0, math.rad(-90))
w1.Parent = torso

local w2 = Instance.new("Weld")
w2.Part0 = torso
w2.Part1 = rArm
w2.C1    = CFrame.new(-1, -0.2, 0.35) * CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-15), 0)
w2.Parent = torso

char.Flamethrower.Handle.CFrame = CFrame.new(lArm.Position)

local SWeld = Instance.new("Weld")
SWeld.Name  = "SWeld"
SWeld.Part0 = char.Fueltank.FuelCenter
SWeld.Part1 = torso
SWeld.C0    = CFrame.new(1.35, 0, 0) * CFrame.fromEulerAnglesXYZ(0, -7.9, 59.68)
SWeld.Parent = char.Fueltank.FuelCenter

local SWeld2 = Instance.new("Weld")
SWeld2.Name  = "SWeld2"
SWeld2.Part0 = char.Flamethrower.Handle
SWeld2.Part1 = lArm
SWeld2.C0    = CFrame.new(-0.70, 0, -1) * CFrame.Angles(5, 7.8, 0)
SWeld2.Parent = char.Flamethrower.Handle

-- ---------- Sounds ----------
local auto = 0

local s1 = Instance.new("Sound")
s1.SoundId     = "rbxassetid://260131404"
s1.PlayOnRemove = false
s1.Volume      = 100
s1.Looped      = false
s1.Pitch       = 1
s1.Parent      = char.Flamethrower.Handle

local s2 = Instance.new("Sound")
s2.SoundId     = "rbxassetid://260131485"
s2.PlayOnRemove = false
s2.Volume      = 100
s2.Looped      = true
s2.Pitch       = 1
s2.Parent      = char.Flamethrower.Handle

local s3 = Instance.new("Sound")
s3.SoundId     = "rbxassetid://260131519"
s3.PlayOnRemove = false
s3.Volume      = 100
s3.Looped      = false
s3.Pitch       = 1
s3.Parent      = char.Flamethrower.Handle

-- ---------- Button press: audio + color + recoil ----------
mouse.Button1Down:Connect(function()
    auto = 1
    s1:Stop(); s2:Stop()
    s1:Play(); s2:Play()
    SWeld2.C0 = CFrame.new(-0.70, 0, -0.80) * CFrame.Angles(5, 7.8, 0)
    char.Fueltank.ChangeColor.BrickColor  = BrickColor.new("Really red")
    char.Fueltank.ChangeColor2.BrickColor = BrickColor.new("Really red")
    char.Fueltank.FuelCenter.BrickColor   = BrickColor.new("Really red")
end)

mouse.Button1Up:Connect(function()
    auto = 0
    s1:Stop(); s2:Stop(); s3:Play()
    SWeld2.C0 = CFrame.new(-0.70, 0, -1) * CFrame.Angles(5, 7.8, 0)
    char.Fueltank.ChangeColor.BrickColor  = BrickColor.new("Institutional white")
    char.Fueltank.ChangeColor2.BrickColor = BrickColor.new("Institutional white")
    char.Fueltank.FuelCenter.BrickColor   = BrickColor.new("Institutional white")
    local smoke = char.Flamethrower.Barrel:FindFirstChild("Smoke")
    if smoke then smoke:Destroy() end
end)

-- ---------- Fire loop ----------
mouse.Button1Down:Connect(function()
    auto = 1
    while auto == 1 do
        task.wait(0.20)

        local smoke = Instance.new("Smoke", char.Flamethrower.Barrel)
        Debris:AddItem(smoke, 1)

        local bullet = Instance.new("Part")
        Debris:AddItem(bullet, 0.90)
        bullet.Size       = Vector3.new(2, 2, 2)
        bullet.Shape      = Enum.PartType.Ball
        bullet.Transparency = 1
        bullet.CanCollide = false
        bullet.Name       = "bullet"
        bullet.CFrame     = char.Flamethrower.Barrel.CFrame * CFrame.new(0, 3, 0)
        bullet.Parent     = workspace

        Instance.new("Fire", bullet)

        local light = Instance.new("PointLight", bullet)
        light.Range      = 5
        light.Brightness = 20
        light.Color      = Color3.fromRGB(255, 85, 0)

        local bv = Instance.new("BodyVelocity", bullet)
        bv.MaxForce = Vector3.new(math.huge, math.huge, 850)
        bv.Velocity = mouse.Hit.lookVector * 47

        bullet.Touched:Connect(function(hit)
            local parent = hit.Parent
            local hum    = parent:FindFirstChildOfClass("Humanoid")
            local torso2 = parent:FindFirstChild("Torso")
            if hum and torso2 then
                local fire1 = Instance.new("Fire", torso2)
                Debris:AddItem(fire1, 3)
                -- NOTE: math.random(0,0) always 0 → change to real damage if desired
                hum:TakeDamage(math.random(0, 0))
                task.wait(0.30)
                hum:TakeDamage(math.random(0, 0))
                task.wait(0.30)
                hum:TakeDamage(math.random(0, 0))
            end
        end)
    end
end)

-- ============================================================
-- PART 3 — Fire Mohawk (needs FireMohawk accessory on player)
-- ============================================================
pcall(function()
    player.Character.FireMohawk.Handle.AccessoryWeld:Destroy()
end)
pcall(function()
    workspace.non.FireMohawk.Handle.Anchored = true
end)

task.spawn(function()
    while true do
        pcall(function()
            local c  = player.Character
            local fm = c and c:FindFirstChild("FireMohawk")
            local r  = c and c:FindFirstChild(player.Name)
            if fm and fm:FindFirstChild("Handle")
               and r and r:FindFirstChild("HumanoidRootPart") then
                fm.Handle.CFrame = r.HumanoidRootPart.CFrame
            end
        end)
        task.wait()
    end
end)
