--================================================================
--  SNIPER RIFLE — FULLY FIXED VERSION
--================================================================
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris     = game:GetService("Debris")
local UIS        = game:GetService("UserInputService")

local Ply   = Players.LocalPlayer
local cam   = workspace.CurrentCamera
local mouse = Ply:GetMouse()

--================================================================
--  CONFIG
--================================================================
local CONFIG = {
    SniperDamage = 100,   -- damage per shot
    AmmoCapacity = 10,
    MaxRange     = 100,   -- studs per raycast segment
    HitCooldown  = 0.2,   -- seconds between hits on same target
    Segments     = 15,    -- raycast segments per shot (trail length)
}

--================================================================
--  SHARED STATE
--================================================================
local Effects = {}       -- {part, mode, delay, dx, dy, dz}

--================================================================
--  HELPERS
--================================================================
local function Create(className)
    return function(props)
        local obj = Instance.new(className)
        for k, v in pairs(props) do
            local ok = pcall(function() obj[k] = v end)
            if not ok then
                local cap = k:sub(1,1):upper() .. k:sub(2)
                pcall(function() obj[cap] = v end)
            end
        end
        return obj
    end
end

local function RemoveOutlines(part)
    part.TopSurface    = Enum.SurfaceType.SmoothNoOutlines
    part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
    part.LeftSurface   = Enum.SurfaceType.SmoothNoOutlines
    part.RightSurface  = Enum.SurfaceType.SmoothNoOutlines
    part.FrontSurface  = Enum.SurfaceType.SmoothNoOutlines
    part.BackSurface   = Enum.SurfaceType.SmoothNoOutlines
end

local function CreatePart(_, Par, Mat, Ref, Tra, BC, Nam, Siz)
    local part = Instance.new("Part")
    part.Parent       = Par
    part.Reflectance  = Ref
    part.Transparency = Tra
    part.CanCollide   = false
    part.Locked       = true
    part.BrickColor   = BrickColor.new(tostring(BC))
    part.Name         = Nam
    part.Size         = Siz
    part.Material     = Mat
    RemoveOutlines(part)
    return part
end

local function CreateMesh(Ms, Par, MType, MId, OS, Sca)
    local Msh = Create(Ms){ Parent = Par, Offset = OS, Scale = Sca }
    if Ms == "SpecialMesh" then
        Msh.MeshType = MType
        Msh.MeshId   = MId
    end
end

local function CreateWeld(Par, PartA, PartB, CA, CB)
    local W = Instance.new("Weld")
    W.Parent = Par; W.Part0 = PartA; W.Part1 = PartB; W.C0 = CA; W.C1 = CB
    return W
end

local function CreateSound(id, par, vol, pit)
    task.spawn(function()
        local sou = Instance.new("Sound")
        sou.Parent  = par or workspace
        sou.Volume  = vol
        sou.Pitch   = pit or 1
        sou.SoundId = id
        task.wait()
        sou:Play()
    end)
end

local function clerp(a, b, t) return a:Lerp(b, t) end

-- [FIXED] modern Raycast API
local function rayCast(origin, direction, maxDist, ignore)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { ignore }
    local result = workspace:Raycast(origin, direction.Unit * (maxDist or 999.999), params)
    if result then
        return result.Instance, result.Position, result.Normal, result.Material
    end
    return nil, nil, nil, nil
end

-- [FIXED] proper damage (no more instakill via .Health = 0)
local function Damage(hit, damage, cooldown, Color1, Color2, HSound, HPitch)
    for _, v in pairs(hit:GetChildren()) do
        if v:IsA("Humanoid") and hit.Name ~= Ply.Name then
            if not v:FindFirstChild("Hitz") then
                local head = v.Parent and v.Parent:FindFirstChild("Head")
                if head then
                    local BillG = Create("BillboardGui"){
                        Parent = head, Size = UDim2.new(1, 0, 1, 0),
                        Adornee = head,
                        StudsOffset = Vector3.new(
                            math.random(-3,3), math.random(3,5), math.random(-3,3)),
                    }
                    Create("TextLabel"){
                        Parent = BillG, Size = UDim2.new(3,3,3,3),
                        BackgroundTransparency = 1,
                        Text = tostring(damage).."-",
                        TextColor3 = Color1.Color,
                        TextStrokeColor3 = Color2.Color,
                        TextStrokeTransparency = 0,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        TextSize = 18, Font = Enum.Font.ArialBold,
                    }
                    task.spawn(function()
                        task.wait(1)
                        for _ = 0, 1, .1 do
                            task.wait(.1)
                            BillG.StudsOffset = BillG.StudsOffset + Vector3.new(0, .1, 0)
                        end
                        BillG:Destroy()
                    end)
                end

                if damage >= v.Health then
                    v:TakeDamage(v.Health + 1)
                else
                    v:TakeDamage(damage)
                end

                local bool = Create("BoolValue"){ Parent = v, Name = "Hitz" }
                if HSound and HPitch then CreateSound(HSound, hit, 1, HPitch) end
                Debris:AddItem(bool, cooldown)
            end
        end
    end
end

-- [FIXED] cleanup loop moved to global heartbeat (survives respawns)
RunService.Heartbeat:Connect(function()
    for e = #Effects, 1, -1 do
        local Thing = Effects[e]
        local part = Thing and Thing[1]
        if not part or not part.Parent or part.Transparency >= 1 then
            if part then part:Destroy() end
            table.remove(Effects, e)
        else
            local mesh = part:FindFirstChildWhichIsA("DataModelMesh")
            if Thing[2] == "Cylinder" and mesh then
                mesh.Scale = mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
            end
            part.Transparency = math.min(part.Transparency + Thing[3], 1)
        end
    end
end)

--================================================================
--  PER-CHARACTER SETUP
--================================================================
local currentChar

local function setupCharacter(Char)
    if not Char or currentChar == Char then return end
    currentChar = Char

    -- [FIXED] R6 guard — this script only works on R6
    local Tor = Char:WaitForChild("Torso", 5)
    if not Tor then
        warn("[Sniper] This script requires an R6 character (no Torso found).")
        return
    end

    -- [FIXED] disable default animation
    local defaultAnim = Char:FindFirstChild("Animate")
    if defaultAnim then defaultAnim.Disabled = true end

    local He = Char:WaitForChild("Head")
    local Hu = Char:WaitForChild("Humanoid")
    local LA = Char:WaitForChild("Left Arm")
    local RA = Char:WaitForChild("Right Arm")
    local LS = Tor:WaitForChild("Left Shoulder")
    local RS = Tor:WaitForChild("Right Shoulder")
    local Ne = Tor:WaitForChild("Neck")
    local RP = Char:WaitForChild("HumanoidRootPart")
    local RJ = RP:WaitForChild("RootJoint")

    local NeckCF = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
    local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)

    local attack, equipped  = false, false
    local Aiming, Crouching = false, false
    local Zoomed, Depleted  = false, false
    local Ammo              = CONFIG.AmmoCapacity

    --================================================================
    --  Align (attaches an existing "Sniper" tool handle to the arm)
    --================================================================
    local function Align(Part0, Part1, Mesh)
        local AlignOrientation = Instance.new("AlignOrientation", Part0)
        local AlignPosition    = Instance.new("AlignPosition",   Part0)
        local Attach0 = Instance.new("Attachment", Part0)
        local Attach1 = Instance.new("Attachment", Part1)

        local m = Part0:FindFirstChildOfClass("SpecialMesh")
        if Mesh and m then m:Destroy() end
        Part0:BreakJoints()

        AlignOrientation.Attachment0     = Attach0
        AlignOrientation.Attachment1     = Attach1
        AlignOrientation.Responsiveness  = math.huge
        AlignOrientation.RigidityEnabled = true

        AlignPosition.Attachment0        = Attach0
        AlignPosition.Attachment1        = Attach1
        AlignPosition.Responsiveness     = math.huge
        AlignPosition.RigidityEnabled    = true
        AlignPosition.MaxForce           = 999999999

        -- [FIXED] self-terminating loop, no _G.loop, no upward velocity
        task.spawn(function()
            while Part0.Parent and Part1.Parent do
                local target = Part1.CFrame * Attach0.CFrame:Inverse()
                local mag    = (Part0.Position - target.Position).Magnitude
                if mag >= 5 then Part0.CFrame = target end
                RunService.Heartbeat:Wait()
            end
        end)

        return { Attach0 }
    end

    do
        local sniperTool = Char:FindFirstChild("Sniper")
        local sHandle    = sniperTool and sniperTool:FindFirstChild("Handle")
        if sHandle and RA then
            local hat = Align(sHandle, RA, false)
            local cf  = RA.CFrame * CFrame.new(0, -1, -0.5)
                       * CFrame.Angles(math.rad(35), math.rad(70), 10.4)
            hat[1].CFrame = cf:Inverse() * RA.CFrame
        end
    end

    --================================================================
    --  Build Weapon Model
    --================================================================
    local m = Create("Model"){ Parent = Char, Name = "WeaponModel" }
    if RS then RS.Parent = nil end
    if LS then LS.Parent = nil end

    local RW = Create("Weld"){ Name = "Right Shoulder", Part0 = Tor, Part1 = RA,
        C0 = CFrame.new(1.5, 0.5, 0), C1 = CFrame.new(0, 0.5, 0), Parent = Tor }
    local LW = Create("Weld"){ Name = "Left Shoulder", Part0 = Tor, Part1 = LA,
        C0 = CFrame.new(-1.5, 0.5, 0), C1 = CFrame.new(0, 0.5, 0), Parent = Tor }

    local Handle = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 1, "Navy blue", "Handle",
        Vector3.new(0.216133296, 0.432266444, 0.200000003))
    local Handleweld = CreateWeld(m, RA, Handle, CFrame.new(0,0,0),
        CFrame.new(1.03214836, -0.278110504, -0.0978469849, 0, 0.999999702, -2.98023224e-008, 0, -2.98023188e-008, -0.999999821, -1, 4.37113847e-008, -1.77635684e-015))
    CreateMesh("BlockMesh", Handle, "", "", Vector3.new(0,0,0), Vector3.new(1,1,0.540333092))

    local FakeHandle = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 1, "Navy blue", "FakeHandle",
        Vector3.new(0.216133296, 0.432266444, 0.200000003))
    local FakeHandleweld = CreateWeld(m, Handle, FakeHandle, CFrame.new(0,0,0),
        CFrame.new(0,0,0, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 4.37113812e-008, 4.73655636e-016, 1))

    local Barrel = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, "Smoky grey", "Barrel",
        Vector3.new(0.324199915, 0.200000003, 0.216133296))
    CreateWeld(m, FakeHandle, Barrel, CFrame.new(0,0,0),
        CFrame.new(-0.000385284424, 5.45991993, 0.648399353, 1.88395493e-016, 1.00281931e-024, -1, 0.999999642, 0, 4.37113812e-008, 0, -0.999999642, -4.73655636e-016))
    CreateMesh("CylinderMesh", Barrel, "", "", Vector3.new(0,0,0), Vector3.new(1, 0.567349613, 1))

    local function fileMesh(BC, Size, C0, Id, Scale)
        local p = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, BC, "Part", Size)
        CreateWeld(m, FakeHandle, p, CFrame.new(0,0,0), C0)
        CreateMesh("SpecialMesh", p, Enum.MeshType.FileMesh, "rbxassetid://"..Id, Vector3.new(0,0,0), Scale)
    end

    local function body(BC, Size, C0, MeshType, MeshScale)
        local p = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, BC, "Part", Size)
        CreateWeld(m, FakeHandle, p, CFrame.new(0,0,0), C0)
        if MeshType and MeshType ~= "SpecialMesh" then
            CreateMesh(MeshType, p, "", "", Vector3.new(0,0,0), MeshScale)
        end
        return p
    end

    body("Really black", Vector3.new(0.324199826, 0.324199826, 0.432266533), CFrame.new(-0.378201485, -0.162090302, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1))
    body("Really black", Vector3.new(0.216133282, 0.200000003, 0.200000003), CFrame.new(-1.03202057, 0.162498474, 0.864542007, 5.96045453e-008, 0.999996662, 2.34803412e-008, 4.76836078e-007, 6.32193187e-009, 0.999997854, 0.999997139, -2.98022425e-008, -4.3312528e-007), "CylinderMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Really black", Vector3.new(1.08066642, 0.200000003, 0.200000003), CFrame.new(0.648406029, -0.594371796, -0.161685944, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Navy blue", Vector3.new(0.756466568, 0.200000003, 0.432266533), CFrame.new(1.8910985, -0.70243454, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.200000003, 0.200000003, 0.216133296), CFrame.new(1.45885229, -0.832115173, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(0.540333211, 0.75646615, 1))
    body("Really black", Vector3.new(1.40486634, 0.200000003, 0.200000003), CFrame.new(0.810516357, -0.81047821, 0.162475586, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Navy blue", Vector3.new(0.216133282, 0.324199826, 0.200000003), CFrame.new(2.37740993, -0.594367981, 0.162475586, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 1, 0.540333092))
    fileMesh("Navy blue", Vector3.new(0.200000003, 0.200000003, 0.200000003), CFrame.new(0.0540370941, -0.162101746, 0, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 4.37113812e-008, 4.73655636e-016, 1), "3270017", Vector3.new(0.369587988, 0.358781129, 0.748901784))
    body("Navy blue", Vector3.new(0.216133282, 0.200000003, 0.216133296), CFrame.new(2.37741232, -0.702438354, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.432266563, 0.200000003, 0.216133296), CFrame.new(-0.000377655029, -1.56698084, -1.0320282, -4.17232428e-007, 6.32132613e-009, -0.999997616, -0.999997139, 2.98022425e-008, 2.99015426e-007, -8.70414851e-014, 0.999996722, -2.34809274e-008), "CylinderMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.432266563, 2.48553157, 0.216133296), CFrame.new(-0.000385284424, 3.51209116, 0.648399353, 1.78814986e-007, -6.32150376e-009, -1, 0.999999642, -5.96046341e-008, 2.22526424e-007, -5.96046341e-008, -0.999999642, 6.32149666e-009), "CylinderMesh", Vector3.new(1, 1, 1))
    body("Navy blue", Vector3.new(0.216133282, 0.200000003, 0.216133296), CFrame.new(2.37741327, -0.486289978, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.200000003, 0.756466269, 0.432266533), CFrame.new(-1.45884228, 0.0540428162, 0.000385284424, 0.999999583, -4.47034729e-008, 4.37113776e-008, 4.47034729e-008, 0.999999583, 2.42770696e-015, 0, -0, 1), "BlockMesh", Vector3.new(0.540333211, 1, 1))
    body("Really black", Vector3.new(2.485533, 0.216133222, 0.432266533), CFrame.new(1.02665424, -0.324203491, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1))
    body("Navy blue", Vector3.new(2.16133285, 0.200000003, 0.432266533), CFrame.new(1.18871307, -0.486282349, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.200000003, 0.200000003, 0.216133296), CFrame.new(0.270159721, -0.832111359, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(0.540333211, 0.75646615, 1))
    body("Navy blue", Vector3.new(1.08066642, 0.200000003, 0.432266533), CFrame.new(1.72902441, -0.594367981, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Navy blue", Vector3.new(0.216133282, 0.324199826, 0.200000003), CFrame.new(2.37740993, -0.594367981, -0.161708832, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 1, 0.540333092))
    body("Really black", Vector3.new(1.08066642, 0.200000003, 0.200000003), CFrame.new(0.648406029, -0.594371796, 0.162475586, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Navy blue", Vector3.new(0.324199975, 0.200000003, 0.200000003), CFrame.new(-0.0540428162, -0.486282349, 0.162475586, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Really black", Vector3.new(0.864533126, 0.540332973, 0.432266533), CFrame.new(-0.972568512, -0.0540428162, 0.000385284424, 0.999999583, -4.47034729e-008, 4.37113776e-008, 4.47034729e-008, 0.999999583, 2.42770696e-015, 0, -0, 1))
    body("Really black", Vector3.new(1.40486634, 0.200000003, 0.200000003), CFrame.new(0.810501099, -0.810474396, -0.161685944, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Really black", Vector3.new(0.432266563, 0.200000003, 0.216133296), CFrame.new(0.000385284424, 0.162106514, -1.0320282, 3.57626845e-007, 6.32133856e-009, 0.999997854, 0.999997139, -2.98022425e-008, -3.1391599e-007, -8.70414851e-014, 0.999996722, 2.34809345e-008), "CylinderMesh", Vector3.new(1, 0.540332973, 1))
    body("Really black", Vector3.new(0.216134712, 0.216134697, 0.216134712), CFrame.new(0.000408172607, 0.864553452, -1.03203201, 3.57626561e-007, 6.59261232e-008, 1, 0.999999642, 0, -3.1391528e-007, 0, 0.999999642, -6.59261374e-008))
    body("Really black", Vector3.new(1.40486634, 0.200000003, 0.432266533), CFrame.new(0.810516357, -0.70243454, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 1))
    body("Navy blue", Vector3.new(0.324199975, 0.200000003, 0.200000003), CFrame.new(-0.0540428162, -0.486282349, -0.161685944, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1), "BlockMesh", Vector3.new(1, 0.540332973, 0.540333092))
    body("Really black", Vector3.new(0.324199915, 0.756466269, 0.432266533), CFrame.new(-0.000385284424, 5.1330142, 0.648399353, 0, 0, -1, 0.999999642, 0, 4.37113812e-008, 0, -0.999999642, -4.73655636e-016), "CylinderMesh", Vector3.new(1, 1, 1))

    fileMesh("Really black", Vector3.new(0.324199975, 0.324199826, 0.200000003), CFrame.new(0.000377655029, -1.02661514, -0.378243446, 4.37113812e-008, 4.73655636e-016, 1, 0, 0.999999642, 4.73655636e-016, -0.999999642, 0, -4.37113812e-008), "3270017", Vector3.new(0.229101285, 0.250714511, 2.71571469))
    fileMesh("Navy blue", Vector3.new(0.324199975, 0.324199826, 0.200000003), CFrame.new(-0.000385284424, -1.02661896, 1.56696892, -1.93715053e-007, 9.32587256e-015, -0.999999702, 0, 0.999999642, 4.73655636e-016, 0.999999404, 4.47034836e-008, -6.05967614e-008), "3270017", Vector3.new(0.218294606, 0.239907846, 1.02987504))
    fileMesh("Really black", Vector3.new(0.200000003, 0.200000003, 0.200000003), CFrame.new(0.0540370941, -0.162101746, 0, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 4.37113812e-008, 4.73655636e-016, 1), "3270017", Vector3.new(0.369587988, 0.369587809, 0.748901784))
    fileMesh("Really black", Vector3.new(0.324199975, 0.324199826, 0.200000003), CFrame.new(-0.000385284424, -1.02661514, 1.35084629, -1.93715053e-007, 9.32587256e-015, -0.999999702, 0, 0.999999642, 4.73655636e-016, 0.999999404, 4.47034836e-008, -6.05967614e-008), "3270017", Vector3.new(0.229101285, 0.250714511, 2.71571469))

    local function wedge(BC, Size, C0)
        local p = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, BC, "Wedge", Size)
        CreateWeld(m, FakeHandle, p, CFrame.new(0,0,0), C0)
        CreateMesh("SpecialMesh", p, Enum.MeshType.Wedge, "", Vector3.new(0,0,0), Vector3.new(0.540333211, 1, 1))
    end
    wedge("Really black", Vector3.new(0.432266563, 0.216133222, 0.864533186), CFrame.new(0.000385284424, -0.324199677, -0.972576141, 2.98023117e-008, 0, 0.999999702, 0, -0.999999642, -4.73655636e-016, 0.999999285, 1.49011701e-008, 1.3909041e-008))
    wedge("Really black", Vector3.new(0.432266563, 0.216133192, 0.216133267), CFrame.new(0.000385284424, -0.108055115, -0.432257652, 2.98023117e-008, 0, 0.999999702, 0, -0.999999642, -4.73655636e-016, 0.999999285, 1.49011701e-008, 1.3909041e-008))
    wedge("Navy blue", Vector3.new(0.200000003, 0.200000003, 0.216133267), CFrame.new(0.162475586, -0.486286163, 0.32416153, 0, -0, 1, 0, 0.999999642, 4.73655636e-016, -0.999999642, 0, -4.37113812e-008))
    wedge("Really black", Vector3.new(0.200000003, 0.200000003, 0.216133267), CFrame.new(0.161708832, -0.810497284, 1.62095213, 1.49011559e-008, 0, -0.999999762, 0, 0.999999642, 4.73655636e-016, 0.999999404, 4.47034836e-008, 5.86125317e-008))
    wedge("Navy blue", Vector3.new(0.200000003, 0.432266384, 0.216133267), CFrame.new(0.162475586, -0.648399353, -2.86102295e-005, 0, -0, 1, 0, 0.999999642, 4.73655636e-016, -0.999999642, 0, -4.37113812e-008))
    wedge("Really black", Vector3.new(0.200000003, 0.200000003, 0.216133267), CFrame.new(-0.162475586, -0.810497284, 1.62095213, 1.49011559e-008, 0, -0.999999762, 0, 0.999999642, 4.73655636e-016, 0.999999404, 4.47034836e-008, 5.86125317e-008))
    wedge("Really black", Vector3.new(0.432266563, 0.216133237, 0.216133267), CFrame.new(0.000385284424, 0.324203491, 2.37740946, 1.06338617e-018, 5.01342412e-010, 0.999999404, 1.49011701e-008, -0.999999285, 5.01343078e-010, 0.999999285, 1.49011701e-008, 4.37113634e-008))
    wedge("Really black", Vector3.new(0.432266563, 0.216133222, 0.216133296), CFrame.new(0.000385284424, 0.108070374, -0.108057022, 2.98023117e-008, 0, 0.999999702, 0, -0.999999642, -4.73655636e-016, 0.999999285, 1.49011701e-008, 1.3909041e-008))
    wedge("Navy blue", Vector3.new(0.200000003, 0.200000003, 0.216133267), CFrame.new(-0.161708832, -0.486286163, 0.32416153, 0, -0, 1, 0, 0.999999642, 4.73655636e-016, -0.999999642, 0, -4.37113812e-008))

    local MagHandle = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "MagHandle",
        Vector3.new(0.432266504, 0.324199826, 0.216133296))
    local MagHandleweld = CreateWeld(m, FakeHandle, MagHandle, CFrame.new(0,0,0),
        CFrame.new(0.648423195, -0.0540428162, 0.000385284424, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 0, -0, 1))
    body("Navy blue", Vector3.new(0.200000003, 0.324199826, 0.216133296), CFrame.new(-0.270163536, 0, 0, 0.999999642, 0, 0, 0, 0.999999642, -0, 0, -0, 1), "BlockMesh", Vector3.new(0.540333211, 1, 1))
    body("Navy blue", Vector3.new(0.200000003, 0.324199826, 0.216133296), CFrame.new(0.270174026, 0, 0, 0.999999642, 0, 0, 0, 0.999999642, -0, 0, -0, 1), "BlockMesh", Vector3.new(0.540333211, 1, 1))

    local BoltHandle = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "BoltHandle",
        Vector3.new(0.216133282, 1.40486586, 0.216133267))
    local BoltHandleweld = CreateWeld(m, FakeHandle, BoltHandle, CFrame.new(0,0,0),
        CFrame.new(0.540328979, -0.486276627, -0.000385284424, -4.47034729e-008, -0.999999583, -2.42770696e-015, -0.999999642, 0, -4.37113812e-008, 0, 0, -0.99999994))
    CreateMesh("CylinderMesh", BoltHandle, "", "", Vector3.new(0,0,0), Vector3.new(1,1,1))

    local ScopeZoom = CreatePart(nil, m, Enum.Material.SmoothPlastic, 0, 1, "Bright violet", "ScopeZoom",
        Vector3.new(0.216133296, 0.200000003, 0.200000003))
    CreateWeld(m, FakeHandle, ScopeZoom, CFrame.new(0,0,0),
        CFrame.new(1.72752714, -1.03763962, 0, 0.999999642, 0, 4.37113812e-008, 0, 0.999999642, 4.73655636e-016, 4.37113812e-008, 4.73655636e-016, 1))

    local PE1 = Create("ParticleEmitter"){
        Parent = Barrel, Color = ColorSequence.new(BrickColor.new("Dark stone grey").Color),
        Transparency = NumberSequence.new(0), Size = NumberSequence.new(.5),
        Texture = "rbxassetid://257430870", Lifetime = NumberRange.new(.1),
        Rate = 100, SpreadAngle = Vector2.new(180, 180), Rotation = NumberRange.new(0),
        Speed = NumberRange.new(0), LightEmission = .6, LockedToPart = true, Enabled = false,
    }
    local PE2 = PE1:Clone()
    PE2.Size = NumberSequence.new(.7)
    PE2.LightEmission = 1
    PE2.Texture = "rbxassetid://87729590"

    local function CylinderEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
        local prt = CreatePart(nil, workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", Vector3.new(0.2,0.2,0.2))
        prt.Anchored = true
        prt.CFrame   = cframe
        CreateMesh("CylinderMesh", prt, "", "", Vector3.new(0,0,0), Vector3.new(x1,y1,z1))
        Debris:AddItem(prt, 2)
        Effects[#Effects + 1] = { prt, "Cylinder", delay, x3, y3, z3 }
    end

    --================================================================
    --  Shoot (fixed: single-target damage, nil-safe mouse)
    --================================================================
    local function Shoot(asd, spread1, spread2)
        if not mouse.Hit then return end
        local MainPos  = asd.Position
        local MainPos2 = mouse.Hit.Position
        local spread   = Vector3.new(
            (math.random(-spread1, 0) + math.random()) * spread2,
            (math.random(-spread1, 0) + math.random()) * spread2,
            (math.random(-spread1, 0) + math.random()) * spread2
        ) * (asd.Position - mouse.Hit.Position).Magnitude / 100
        local MouseLook = CFrame.new((MainPos + MainPos2) / 2, MainPos2 + spread)

        Ammo = Ammo - 1
        if Ammo <= 0 then Depleted = true end

        task.spawn(function()
            local num = CONFIG.Segments
            repeat
                task.wait()
                local hit, pos = rayCast(MainPos, MouseLook.LookVector, CONFIG.MaxRange, Char)
                if not pos then return end
                local mag = (MainPos - pos).Magnitude
                CylinderEffect(BrickColor.new("Dark stone grey"),
                    CFrame.new((MainPos + pos) / 2, pos) * CFrame.Angles(1.57, 0, 0),
                    3, mag * 5, 3, .5, 1, .5, 0.2)
                MainPos = MainPos + (MouseLook.LookVector * CONFIG.MaxRange)
                num = num - 1

                if hit ~= nil then
                    num = 0
                    -- [FIXED] direct single-target damage instead of AoE
                    local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Parent ~= Char then
                        Damage(hum.Parent, CONFIG.SniperDamage, CONFIG.HitCooldown,
                            BrickColor.new("Dark stone grey"),
                            BrickColor.new("Navy blue"),
                            "rbxassetid://199149297", 1)
                    end
                    local impact = CreatePart(nil, workspace, Enum.Material.Plastic,
                        0, 0.7, "Dark stone grey", "Impact", Vector3.new(0.3,0.3,0.3))
                    impact.Anchored = true
                    impact.CFrame = CFrame.new(pos)
                    Debris:AddItem(impact, 0.1)
                end
            until num <= 0
        end)
    end

    --================================================================
    --  Fire
    --================================================================
    local gyro = Instance.new("BodyGyro")
    gyro.Parent    = nil
    gyro.P = 1e7
    gyro.D = 1e3
    gyro.MaxTorque = Vector3.new(0, 1e7, 0)

    local function Fire()
        if not Aiming then return end
        attack = true
        CreateSound("rbxassetid://132572951", Barrel, 1, .9)
        CreateSound("rbxassetid://130767489", Barrel, .7, 1.2)
        PE1.Enabled = true; PE2.Enabled = true
        Shoot(Barrel, 0, 0)

        for _ = 0, 1, 0.2 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), math.rad(-10), math.rad(90)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(90), math.rad(-20), math.rad(-90)), .5)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.7, 0) * CFrame.Angles(0, math.rad(160), math.rad(140)), .5)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end
        PE1.Enabled = false; PE2.Enabled = false

        for _ = 0, 1, 0.1 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .3)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end

        Handleweld.Part0 = LA
        Handleweld.C0 = CFrame.new(0,0,0)
        Handleweld.C1 = CFrame.new(-0.737663269, -0.281144857, 0.33117196, 0.00916702952, 0.939647615, 0.342020333, 0.999940991, -0.0106014106, 0.00232372736, 0.00580918044, 0.341978878, -0.939689875)

        for _ = 0, 1, 0.1 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .3)
            LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end

        CreateSound("rbxassetid://146740582", BoltHandle, .7, 1)
        for _ = 0, 1, 0.1 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .5)
            LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
            BoltHandleweld.C0 = clerp(BoltHandleweld.C0, CFrame.new(.5, 0, 0) * CFrame.Angles(0,0,0), .4)
        end

        for _ = 0, 1, 0.1 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .5)
            LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
            BoltHandleweld.C0 = clerp(BoltHandleweld.C0, CFrame.new(0, 0, 0) * CFrame.Angles(0,0,0), .4)
        end

        for _ = 0, 1, 0.3 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .4)
            RW.C0 = clerp(RW.C0, CFrame.new(.51, 0.51, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .4)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.51, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .4)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .4)
        end

        Handleweld.Part0 = RA
        Handleweld.C0 = CFrame.new(0,0,0)
        Handleweld.C1 = CFrame.new(1.03214836, -0.278110504, -0.0978469849, 0, 0.999999702, -2.98023224e-008, 0, -2.98023188e-008, -0.999999821, -1, 4.37113847e-008, -1.77635684e-015)
        attack = false
    end

    --================================================================
    --  Reload
    --================================================================
    local function Reload()
        if attack then return end  -- [FIXED] guard
        attack = true
        for _ = 0, 1, 0.1 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(0, 0, math.rad(50)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -.5) * CFrame.Angles(math.rad(120), 0, math.rad(-50)), .3)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.5, -.5) * CFrame.Angles(0, math.rad(60), math.rad(120)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end
        CreateSound("rbxassetid://131045401", FakeHandle, 1, 1)
        MagHandleweld.Part0 = LA
        MagHandleweld.C0 = CFrame.new(.5, -1, .6) * CFrame.Angles(1.5, 0, 1.5)
        for _ = 0, 1, 0.08 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), math.rad(5), math.rad(50)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -.5) * CFrame.Angles(math.rad(120), 0, math.rad(-50)), .3)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.5, -.3) * CFrame.Angles(0, math.rad(90), math.rad(20)), .3)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end
        CreateSound("rbxassetid://131045429", FakeHandle, 1, 1)
        for _ = 0, 1, 0.08 do
            task.wait()
            if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
            elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
            Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(0, 0, math.rad(50)), .3)
            RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -.5) * CFrame.Angles(math.rad(100), 0, math.rad(-50)), .5)
            LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.5, -.3) * CFrame.Angles(0, math.rad(60), math.rad(100)), .5)
            FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
        end
        MagHandleweld.Part0 = FakeHandle
        MagHandleweld.C0 = CFrame.new(0,0,0) * CFrame.Angles(0,0,0)
        Ammo = CONFIG.AmmoCapacity

        if Depleted then
            Depleted = false
            Handleweld.Part0 = LA
            Handleweld.C0 = CFrame.new(0,0,0)
            Handleweld.C1 = CFrame.new(-0.737663269, -0.281144857, 0.33117196, 0.00916702952, 0.939647615, 0.342020333, 0.999940991, -0.0106014106, 0.00232372736, 0.00580918044, 0.341978878, -0.939689875)
            for _ = 0, 1, 0.1 do
                task.wait()
                if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
                elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .3)
                LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
            end
            CreateSound("rbxassetid://146740582", BoltHandle, .7, 1)
            for _ = 0, 1, 0.1 do
                task.wait()
                if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
                elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .5)
                LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
                BoltHandleweld.C0 = clerp(BoltHandleweld.C0, CFrame.new(.5, 0, 0) * CFrame.Angles(0,0,0), .4)
            end
            for _ = 0, 1, 0.3 do
                task.wait()
                if Crouching == false and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)), .4)
                elseif Crouching == true and Aiming == true then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(80)), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(.5, 0.5, -.6) * CFrame.Angles(math.rad(80), math.rad(-30), math.rad(-90)), .5)
                LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, 0) * CFrame.Angles(0, math.rad(160), math.rad(70)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
                BoltHandleweld.C0 = clerp(BoltHandleweld.C0, CFrame.new(0, 0, 0) * CFrame.Angles(0,0,0), .4)
            end
        end

        Handleweld.Part0 = RA
        Handleweld.C0 = CFrame.new(0,0,0)
        Handleweld.C1 = CFrame.new(1.03214836, -0.278110504, -0.0978469849, 0, 0.999999702, -2.98023224e-008, 0, -2.98023188e-008, -0.999999821, -1, 4.37113847e-008, -1.77635684e-015)
        attack = false
    end

    --================================================================
    --  Inputs  (stale-safe: ignores calls from dead characters)
    --================================================================
    mouse.Button1Down:Connect(function()
        if Char ~= currentChar then return end
        if attack == false and Depleted == false then Fire() end
    end)

    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if Char ~= currentChar then return end  -- [FIXED] stale handler guard
        local k = input.KeyCode and input.KeyCode.Name:lower() or ""
        if k == "r" and attack == false then Reload()
        elseif k == "f" and Aiming == false then Aiming = true
        elseif k == "f" and Aiming == true then Aiming = false
        elseif k == "c" and Aiming == true and Crouching == false then Crouching = true
        elseif k == "c" and Aiming == true and Crouching == true then Crouching = false
        elseif k == "z" and Aiming == true and Zoomed == false then
            Zoomed = true
            CreateSound("rbxassetid://180144779", FakeHandle, 1, 1)
            for _ = 0, 1, 0.2 do task.wait(); cam.FieldOfView = cam.FieldOfView - 5 end
            Ply.CameraMode = Enum.CameraMode.LockFirstPerson
            cam.FieldOfView = 10
            cam.CameraSubject = ScopeZoom
        elseif k == "z" and Aiming == true and Zoomed == true then
            Zoomed = false
            CreateSound("rbxassetid://190623951", FakeHandle, 1, 1)
            for _ = 0, 1, 0.2 do task.wait(); cam.FieldOfView = cam.FieldOfView + 5 end
            Ply.CameraMode = Enum.CameraMode.Classic
            cam.FieldOfView = 80
            cam.CameraSubject = Hu
        end
    end)

    --================================================================
    --  Animation loop
    --================================================================
    while Char.Parent do
        task.wait()
        local torvel = (RP.AssemblyLinearVelocity * Vector3.new(1,0,1)).Magnitude
        local hitfloor = rayCast(RP.Position,
            CFrame.new(RP.Position, RP.Position - Vector3.new(0,1,0)).LookVector, 4, Char)

        if Aiming then
            Hu.WalkSpeed = Crouching and 5 or 10
            gyro.Parent = RP
            gyro.CFrame = CFrame.new(Vector3.new(), (mouse.Hit and (mouse.Hit.Position - RP.CFrame.p).Unit * 100) or Vector3.new())
        else
            Hu.UseJumpPower = true
            Hu.JumpPower     = 50
            Hu.WalkSpeed     = 16
            gyro.Parent = nil
        end

        local velY = RP.AssemblyLinearVelocity.Y
        if velY > 1 and hitfloor == nil then
            -- Jump
            if attack == false and Aiming == false then
                RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(-20), 0, 0), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.4, -.2) * CFrame.Angles(math.rad(60), 0, math.rad(-40)), .3)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, -.4) * CFrame.Angles(0, math.rad(80), math.rad(60)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(80), 0), .3)
            elseif attack == false and Aiming == true then
                if Crouching == false then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,math.rad(-90)), .4)
                else RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,-.5) * CFrame.Angles(0,0,math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .4)
                RW.C0 = clerp(RW.C0, CFrame.new(.51, 0.51, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .4)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.51, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .4)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .4)
            end
        elseif velY < -1 and hitfloor == nil then
            -- Fall
            if attack == false and Aiming == false then
                RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .3)
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(20), 0, 0), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.4, -.2) * CFrame.Angles(math.rad(100), 0, math.rad(-40)), .3)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, -.4) * CFrame.Angles(0, math.rad(80), math.rad(100)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(80), 0), .3)
            elseif attack == false and Aiming == true then
                if Crouching == false then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,math.rad(-90)), .4)
                else RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,-.5) * CFrame.Angles(0,0,math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .4)
                RW.C0 = clerp(RW.C0, CFrame.new(.51, 0.51, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .4)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.51, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .4)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .4)
            end
        elseif torvel < 1 and hitfloor ~= nil then
            -- Idle
            if attack == false and Aiming == false then
                RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0, 0, -.5) * CFrame.Angles(0, 0, math.rad(50)), .3)
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(-50)), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.4, 0) * CFrame.Angles(math.rad(70), 0, math.rad(-40)), .3)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, -.4) * CFrame.Angles(0, math.rad(80), math.rad(70)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(70), 0), .3)
            elseif attack == false and Aiming == true then
                if Crouching == false then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,math.rad(-90)), .4)
                else RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,-.5) * CFrame.Angles(0,0,math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .4)
                RW.C0 = clerp(RW.C0, CFrame.new(.51, 0.51, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .4)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.51, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .4)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .4)
            end
        elseif torvel > 2 and hitfloor ~= nil then
            -- Walk
            if attack == false and Aiming == false then
                RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(math.rad(30), 0, 0), .3)
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(-20), 0, 0), .3)
                RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.4, -.2) * CFrame.Angles(math.rad(50), 0, math.rad(-40)), .3)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, -.4) * CFrame.Angles(0, math.rad(80), math.rad(50)), .3)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(80), 0), .3)
            elseif attack == false and Aiming == true then
                if Crouching == false then RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,math.rad(-90)), .4)
                else RJ.C0 = clerp(RJ.C0, RootCF * CFrame.new(0,0,-.5) * CFrame.Angles(0,0,math.rad(-90)), .4) end
                Ne.C0 = clerp(Ne.C0, NeckCF * CFrame.Angles(math.rad(5), 0, math.rad(90)), .4)
                RW.C0 = clerp(RW.C0, CFrame.new(.51, 0.51, -.6) * CFrame.Angles(math.rad(90), 0, math.rad(-90)), .4)
                LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.51, 0) * CFrame.Angles(0, math.rad(160), math.rad(90)), .4)
                FakeHandleweld.C0 = clerp(FakeHandleweld.C0, CFrame.new(0,0,0) * CFrame.Angles(0,0,0), .4)
            end
        end
    end
end

--================================================================
--  INIT + RESPAWN
--================================================================
if Ply.Character then
    task.spawn(setupCharacter, Ply.Character)
end

Ply.CharacterAdded:Connect(function(c)
    task.spawn(function()
        task.wait(0.5)
        setupCharacter(c)
    end)
end)
