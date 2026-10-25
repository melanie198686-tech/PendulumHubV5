-- [[ Magic Unknown, fixed. Requires R6. ]] --
-- fixed by feyz

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Debris           = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")

Player    = Players.LocalPlayer
Character = Player.Character or Player.CharacterAdded:Wait()
PlayerGui = Player.PlayerGui
Backpack  = Player.Backpack

if not Character:FindFirstChild("Torso") then
    warn("[Magic Unknown] Requires R6 avatar. Change to R6 and re-execute.")
    return
end

Torso     = Character.Torso
Head      = Character.Head
Humanoid  = Character.Humanoid
LeftArm   = Character["Left Arm"]
LeftLeg   = Character["Left Leg"]
RightArm  = Character["Right Arm"]
RightLeg  = Character["Right Leg"]
LS        = Torso["Left Shoulder"]
LH        = Torso["Left Hip"]
RS        = Torso["Right Shoulder"]
RH        = Torso["Right Hip"]
Face      = Head:FindFirstChild("face")
Neck      = Torso.Neck
RootPart  = Character.HumanoidRootPart
RootJoint = RootPart.RootJoint

it        = Instance.new
vt        = Vector3.new
cf        = CFrame.new
cn        = CFrame.new
euler     = CFrame.fromEulerAnglesXYZ
angles    = CFrame.Angles
mouse     = Player:GetMouse()
cam       = workspace.CurrentCamera
deb       = Debris

attacktype        = 1
attacktype2       = 1
attack            = false
attackdebounce    = false
attackmode        = 'none'
stance            = false
noleg             = false
evadecooldown     = false
equip             = false
combo             = 0
trispeed          = 0.2
attackspeed       = 0.14
Swing             = 1
local idle        = 0
local Anim        = "Idle"
local ff          = 2
local sine        = 0
local change      = 1
local val         = 0
local speed       = 0
local Effects     = {}

-- [[ Fix 1: LoadLibrary("RbxUtility") no longer exists. Replace with a stub. ]] --
-- Original was: local RbxUtility = LoadLibrary("RbxUtility"); local Create = RbxUtility.Create
local function Create(className)
    return function(props)
        local obj = Instance.new(className)
        for k, v in pairs(props) do
            obj[k] = v
        end
        return obj
    end
end

-- [[ Fix 2: Character.Animate:Destroy() / Humanoid.Animator:Destroy() may error. ]] --
if Character:FindFirstChild("Animate") then Character.Animate.Parent = nil end
pcall(function() Humanoid.Animator:Destroy() end)

necko  = cf(0, 1,  0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
necko2 = cf(0, -0.5, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
LHC0   = cf(-1, -1, 0, -0,-0,-1, 0, 1, 0, 1, 0, 0)
LHC1   = cf(-0.5, 1, 0,-0,-0,-1, 0, 1, 0, 1, 0, 0)
RHC0   = cf(1, -1, 0, 0, 0, 1, 0, 1, 0, -1,-0,-0)
RHC1   = cf(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1,-0,-0)
RootCF = euler(-1.57, 0, 3.14)
local NeckCF = cn(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

if Face then Face:Destroy() end

-- ===== Eyes =====
local function makeEye(xoff)
    local eye = Instance.new("Part")
    eye.Parent       = Character
    eye.Size         = Vector3.new(0.2, 0.2, 0.2)
    eye.Archivable   = true
    eye.Transparency = 0
    eye.CanCollide   = false
    eye.Material     = "Neon"
    eye.Color        = Color3.fromRGB(48, 0, 211)
    local m = Instance.new("SpecialMesh", eye)
    m.MeshType = "Sphere"
    m.Scale    = Vector3.new(0.66, 1.22, 0.66)
    local w = Instance.new("Weld")
    w.Parent = eye
    w.Part0  = Head
    w.Part1  = eye
    w.C0     = CFrame.new(xoff, 0.19, -0.55)
end
makeEye( 0.13)
makeEye(-0.13)

-- ===== Music =====
music = Instance.new("Sound", PlayerGui)
music.Volume  = 1
music.Pitch   = 1
music.SoundId = "rbxassetid://1849245030"
music.Looped  = true
music:Play()

-- ===== Helpers =====
so = function(id, par, vol, pit)
    coroutine.resume(coroutine.create(function()
        local sou = Instance.new("Sound", par or workspace)
        sou.Volume  = vol
        sou.Pitch   = pit or 1
        sou.SoundId = id
        sou:Play()
        Debris:AddItem(sou, 8)
    end))
end

function NoOutline(Part)
    Part.TopSurface, Part.BottomSurface = 10, 10
    Part.LeftSurface, Part.RightSurface = 10, 10
    Part.FrontSurface, Part.BackSurface = 10, 10
end
RemoveOutlines = NoOutline

function swait(num)
    if not num or num == 0 then
        RunService.Stepped:Wait()
    else
        for _ = 0, num do RunService.Stepped:Wait() end
    end
end

-- ===== Replace shoulders with welds =====
RSH = Torso["Right Shoulder"]
LSH = Torso["Left Shoulder"]
if RSH then RSH.Parent = nil end
if LSH then LSH.Parent = nil end

RW = Instance.new("Weld")
RW.Name   = "RW"
RW.Part0  = Torso
RW.C0     = cn( 1.5, 0.5, 0)
RW.C1     = cn( 0, 0.5, 0)
RW.Part1  = RightArm
RW.Parent = Torso

LW = Instance.new("Weld")
LW.Name   = "LW"
LW.Part0  = Torso
LW.C0     = cn(-1.5, 0.5, 0)
LW.C1     = cn( 0, 0.5, 0)
LW.Part1  = LeftArm
LW.Parent = Torso

-- ===== clERP / Quaternion math (fixed Slerp) =====
function clerp(a, b, t)
    local qa = {QuaternionFromCFrame(a)}
    local qb = {QuaternionFromCFrame(b)}
    local ax, ay, az = a.x, a.y, a.z
    local bx, by, bz = b.x, b.y, b.z
    local _t = 1 - t
    return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz, QuaternionSlerp(qa, qb, t))
end

function QuaternionFromCFrame(cf)
    local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
    local trace = m00 + m11 + m22
    if trace > 0 then
        local s = math.sqrt(1 + trace)
        local recip = 0.5 / s
        return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5
    else
        local i = 0
        if m11 > m00 then i = 1 end
        if m22 > (i == 0 and m00 or m11) then i = 2 end
        if i == 0 then
            local s = math.sqrt(m00-m11-m22+1)
            local recip = 0.5 / s
            return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip
        elseif i == 1 then
            local s = math.sqrt(m11-m22-m00+1)
            local recip = 0.5 / s
            return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip
        else
            local s = math.sqrt(m22-m00-m11+1)
            local recip = 0.5 / s
            return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip
        end
    end
end

function QuaternionToCFrame(px, py, pz, x, y, z, w)
    local xs, ys, zs = x+x, y+y, z+z
    local wx, wy, wz = w*xs, w*ys, w*zs
    local xx, xy, xz = x*xs, x*ys, x*zs
    local yy, yz, zz = y*ys, y*zs, z*zs
    return CFrame.new(px, py, pz,
        1-(yy+zz), xy-wz, xz+wy,
        xy+wz, 1-(xx+zz), yz-wx,
        xz-wy, yz+wx, 1-(xx+yy))
end

function QuaternionSlerp(a, b, t)
    local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
    local startInterp, finishInterp
    if cosTheta >= 0.0001 then
        if (1 - cosTheta) > 0.0001 then
            local theta = math.acos(cosTheta)
            local inv = 1 / math.sin(theta)
            startInterp  = math.sin((1-t)*theta) * inv
            finishInterp = math.sin(t*theta) * inv
        else
            startInterp, finishInterp = 1-t, t
        end
    else
        if (1 + cosTheta) > 0.0001 then
            local theta = math.acos(-cosTheta)
            local inv = 1 / math.sin(theta)
            startInterp  = math.sin((t-1)*theta) * inv
            finishInterp = math.sin(t*theta) * inv
        else
            startInterp, finishInterp = t-1, t
        end
    end
    return a[1]*startInterp + b[1]*finishInterp,
           a[2]*startInterp + b[2]*finishInterp,
           a[3]*startInterp + b[3]*finishInterp,
           a[4]*startInterp + b[4]*finishInterp
end

function rayCast(Position, Direction, Range, Ignore)
    return workspace:FindPartOnRay(Ray.new(Position, Direction.unit * (Range or 999.999)), Ignore)
end

-- ===== Ray helpers =====
function findNearestTorso(pos)
    local list = workspace:GetChildren()
    local torso, dist = nil, 10000
    for _, temp2 in ipairs(list) do
        if temp2.ClassName == "Model" and temp2 ~= Character then
            local temp  = temp2:FindFirstChild("HumanoidRootPart")
            local human = temp2:FindFirstChild("Humanoid")
            if temp and human and human.Health > 0 then
                if (temp.Position - pos).magnitude < dist then
                    torso = temp
                    dist = (temp.Position - pos).magnitude
                end
            end
        end
    end
    return torso
end

-- ===== Effect function set (via Create stub) =====
CFuncs = {
    ["Part"] = {
        Create = function(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
            local Part = Create("Part"){
                Parent = Parent, Reflectance = Reflectance, Transparency = Transparency,
                CanCollide = false, Locked = true,
                BrickColor = BrickColor.new(tostring(BColor)),
                Name = Name, Size = Size, Material = Material,
            }
            if Part.BrickColor == BrickColor.new("Mulberry") then
                Part.BrickColor = BrickColor.new("Crimson")
            end
            if Part.BrickColor == BrickColor.new("Royal purple") then
                Part.BrickColor = BrickColor.new("Bright red")
            end
            if Part.BrickColor == BrickColor.new("Alder") or Part.BrickColor == BrickColor.new("Dark indigo") then
                Part.BrickColor = BrickColor.new("Really red")
            end
            RemoveOutlines(Part)
            return Part
        end;
    },
    ["Mesh"] = {
        Create = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
            local Msh = Create(Mesh){ Parent = Part, Offset = OffSet, Scale = Scale }
            if Mesh == "SpecialMesh" then
                Msh.MeshType = MeshType
                if MeshId and MeshId ~= "" and MeshId ~= "nil" then Msh.MeshId = MeshId end
            end
            return Msh
        end;
    },
    ["Weld"] = {
        Create = function(Parent, Part0, Part1, C0, C1)
            return Create("Weld"){ Parent = Parent, Part0 = Part0, Part1 = Part1, C0 = C0, C1 = C1 }
        end;
    },
    ["Sound"] = {
        Create = function(id, par, vol, pit)
            coroutine.resume(coroutine.create(function()
                local S = Create("Sound"){
                    Volume = vol, Pitch = pit or 1, SoundId = id, Parent = par or workspace,
                }
                task.wait()
                S:Play()
                Debris:AddItem(S, 6)
            end))
        end;
    },
}

EffectModel = Create("Model"){ Parent = Character, Name = "Effects" }

Effects = {
    Block = {
        Create = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
            local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, bc, "Effect", Vector3.new())
            prt.Anchored = true
            prt.CFrame = cframe
            local msh = CFuncs.Mesh.Create("BlockMesh", prt, "", "", Vector3.new(), Vector3.new(x1, y1, z1))
            Debris:AddItem(prt, 10)
            if Type == 2 then
                table.insert(Effects, {prt, "Block2", delay, x3, y3, z3, msh})
            else
                table.insert(Effects, {prt, "Block1", delay, x3, y3, z3, msh})
            end
        end;
    },
    Cylinder = {
        Create = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
            local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, bc, "Effect", Vector3.new(0.2,0.2,0.2))
            prt.Anchored = true
            prt.CFrame = cframe
            local msh = CFuncs.Mesh.Create("CylinderMesh", prt, "", "", Vector3.new(), Vector3.new(x1, y1, z1))
            Debris:AddItem(prt, 2)
            Effects[#Effects + 1] = {prt, "Cylinder", delay, x3, y3, z3, msh}
        end;
    },
    Sphere = {
        Create = function(bc, cframe, x1, y1, z1, x3, y3, z3, y2, delay)
            local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, bc, "Effect", Vector3.new())
            prt.Anchored = true
            prt.CFrame = cframe
            local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "Sphere", "", Vector3.new(0, y2 or 0, 0), Vector3.new(x1, y1, z1))
            Debris:AddItem(prt, 10)
            table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
        end;
    },
    Wave = {
        Create = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
            local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, bc, "Effect", Vector3.new())
            prt.Anchored = true
            prt.CFrame = cframe
            local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "FileMesh", "rbxassetid://20329976", Vector3.new(), Vector3.new(x1, y1, z1))
            Debris:AddItem(prt, 10)
            table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
        end;
    },
    Break = {
        Create = function(bc, cframe, x1, y1, z1)
            local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, bc, "Effect", Vector3.new(0.5,0.5,0.5))
            prt.Anchored = true
            prt.CFrame = cframe * CFrame.fromEulerAnglesXYZ(math.random(-50,50), math.random(-50,50), math.random(-50,50))
            local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "Sphere", "", Vector3.new(), Vector3.new(x1, y1, z1))
            local num = math.random(10, 50) / 1000
            Debris:AddItem(prt, 10)
            table.insert(Effects, {prt, "Shatter", num, prt.CFrame, math.random() - math.random(), 0, math.random(50, 100) / 100})
        end;
    },
}

-- ===== Weapon model =====
local m = Create("Model"){ Parent = Character, Name = "WeaponModel" }

function Armor()
    -- Right arm armor (compact form)
    RightArmHandle = CFuncs.Part.Create(Character["Right Arm"], "Plastic", 0, 1, "Medium stone grey", "RightArmHandle", Vector3.new(1.0117017, 2.02340055, 1.01170254))
    RightArmHandleWeld = CFuncs.Weld.Create(m, Character["Right Arm"], RightArmHandle, CFrame.new(), CFrame.new())
    local p = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(1.05, 2.05, 1.05))
    p.Shape = Enum.PartType.Block
    CFuncs.Weld.Create(m, RightArmHandle, p, CFrame.new(), CFrame.new())

    -- Torso armor
    TorsoHandle = CFuncs.Part.Create(Character["Torso"], "Plastic", 0, 1, "Medium stone grey", "TorsoHandle", Vector3.new(2, 2, 1))
    TorsoHandleWeld = CFuncs.Weld.Create(m, Character["Torso"], TorsoHandle, CFrame.new(), CFrame.new())
    local tp = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(2.05, 2.05, 1.05))
    tp.Shape = Enum.PartType.Block
    CFuncs.Weld.Create(m, TorsoHandle, tp, CFrame.new(), CFrame.new())

    -- Right leg armor
    RightLegHandle = CFuncs.Part.Create(Character["Right Leg"], "Plastic", 0, 1, "Medium stone grey", "RightLegHandle", Vector3.new(1.0117017, 2.02340055, 1.01170254))
    RightLegHandleWeld = CFuncs.Weld.Create(m, Character["Right Leg"], RightLegHandle, CFrame.new(), CFrame.new())
    local rp = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(1.05, 2.05, 1.05))
    rp.Shape = Enum.PartType.Block
    CFuncs.Weld.Create(m, RightLegHandle, rp, CFrame.new(), CFrame.new())

    -- Left leg armor
    LeftLegHandle = CFuncs.Part.Create(Character["Left Leg"], "Plastic", 0, 1, "Medium stone grey", "LeftLegHandle", Vector3.new(1.0117017, 2.02340055, 1.01170254))
    LeftLegHandleWeld = CFuncs.Weld.Create(m, Character["Left Leg"], LeftLegHandle, CFrame.new(), CFrame.new())
    local lp = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(1.05, 2.05, 1.05))
    lp.Shape = Enum.PartType.Block
    CFuncs.Weld.Create(m, LeftLegHandle, lp, CFrame.new(), CFrame.new())

    -- Left arm armor
    LeftArmHandle = CFuncs.Part.Create(Character["Left Arm"], "Plastic", 0, 1, "Medium stone grey", "LeftArmHandle", Vector3.new(1.0117017, 2.02340055, 1.01170254))
    LeftArmHandleWeld = CFuncs.Weld.Create(m, Character["Left Arm"], LeftArmHandle, CFrame.new(0.015, 0, 0), CFrame.new())
    local lap = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(1.05, 2.05, 1.05))
    lap.Shape = Enum.PartType.Block
    CFuncs.Weld.Create(m, LeftArmHandle, lap, CFrame.new(), CFrame.new())

    -- Head armor
    HeadHandle = CFuncs.Part.Create(Character["Head"], "Plastic", 0, 1, "Medium stone grey", "HeadHandle", Vector3.new(1.0117017, 2.02340055, 1.01170254))
    HeadHandleWeld = CFuncs.Weld.Create(m, Character["Head"], HeadHandle, CFrame.new(0.015, 0, 0), CFrame.new())
    local hp = CFuncs.Part.Create(m, "SmoothPlastic", 0, 0, "Really black", "Part", Vector3.new(1.265, 1.265, 1.265))
    hp.Shape = Enum.PartType.Block
    CFuncs.Mesh.Create("SpecialMesh", hp, Enum.MeshType.Head, "", Vector3.new(), Vector3.new(1, 1, 1))
    CFuncs.Weld.Create(m, HeadHandle, hp, CFrame.new(), CFrame.new(.01, 0, 0))
end

-- ===== Spawn Animation 1 & 2 =====
function SpawnAnim1()
    attack = true
    for _ = 0, 1, 0.05 do
        swait()
        RootJoint.C0    = clerp(RootJoint.C0, RootCF * cn(0, 0, -2.5) * angles(math.rad(90), 0, 0), .4)
        Torso.Neck.C0   = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-2), math.rad(-20), 0), .4)
        LW.C0           = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.1), 0.4)
        RW.C0           = clerp(RW.C0, CFrame.new( 1.5, 0.5, -0.1) * angles(0, 0, math.rad(24)), 0.4)
        RH.C0           = clerp(RH.C0, cn(1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, 1.6, 0) * angles(math.rad(-15), 0, 0), .4)
        LH.C0           = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(5), 0, 0), .4)
    end
end

function SpawnAnim2()
    for _ = 0, .2, 0.2 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -2.5) * angles(math.rad(90), 0, 0), .1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-2), math.rad(-10), 0), .1)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.1), 0.1)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, -0.1) * angles(0, 0, math.rad(11)), 0.1)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, 1.6, 0) * angles(math.rad(-5), 0, 0), .1)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(2), 0, 0), .1)
    end
    for _ = 0, 2, 0.2 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, -1, -0.5) * angles(math.rad(45), 0, 0), .1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .1)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.1) * angles(math.rad(45), 0, 0), 0.1)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, -0.1) * angles(math.rad(45), 0, 0), 0.1)
        RH.C0         = clerp(RH.C0, cn(1, -0.8, 0)   * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(math.rad(-2), math.rad(5), math.rad(45)), .1)
        LH.C0         = clerp(LH.C0, cn(-1, -0.8, -0.7) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(-2), math.rad(5), math.rad(20)), .1)
    end
    for _ = 0, 2, 0.2 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), .1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .1)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.1), 0.1)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, -0.1), 0.1)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)   * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(math.rad(-2), math.rad(5), 0), .1)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(-2), math.rad(5), 0), .1)
    end
    attack = false
end

Humanoid.DisplayDistanceType = "None"
Humanoid.HealthDisplayDistance = 0
Humanoid.NameDisplayDistance = 0
Humanoid.NameOcclusion = "EnemyOcclusion"

Armor()

-- ===== Setup =====
local trans = 1
for _, v in pairs(m:GetChildren()) do
    if v.ClassName == "Part" then
        v.CanCollide   = false
        v.Transparency = trans
    end
end

attack = true
RootPart.Anchored = true
local fake = Instance.new("Part", Torso)
fake.Size         = Vector3.new(0.1, 0.2, 0.1)
fake.Transparency = 1
fake.Anchored     = true
fake.Material     = "Neon"
fake.CanCollide   = false
fake.BrickColor   = BrickColor.new("Really black")
fake.CFrame       = Torso.CFrame * CFrame.new(0, -3, 0)
local fake1 = Instance.new("CylinderMesh", fake)
SpawnAnim1()

task.wait(0.5)
local val2 = 5
while task.wait() and fake and fake.Transparency >= 0 do
    fake.Transparency = fake.Transparency - 0.04
    val2 = val2 - 0.1
    fake1.Scale = fake1.Scale + Vector3.new(val2, 0, val2)
end

if Character.Head:FindFirstChild("face") then Character.Head.face:Destroy() end
for _ = 1, 91 do
    task.wait()
    trans = trans - .01
    for _, v in pairs(m:GetChildren()) do
        if v.ClassName == "Part" then
            v.Transparency = trans
            fake1.Scale = fake1.Scale - Vector3.new(.0025, 0, .0025)
        end
    end
end
fake:Destroy()
task.wait(1)
SpawnAnim2()
RootPart.Anchored = false

-- ===== Orb eyes =====
local Orbd = Instance.new("Part", Character)
Orbd.Name         = "Orbd"
Orbd.Shape        = Enum.PartType.Block
Orbd.CanCollide   = false
Orbd.BrickColor   = BrickColor.new("White")
Orbd.Transparency = 0
Orbd.Material     = "Neon"
Orbd.Size         = Vector3.new(0.2, 0.3, 0.2)
Orbd.TopSurface, Orbd.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
local W1 = Instance.new("Weld", Orbd)
W1.Part0, W1.Part1 = Character.Head, Orbd
W1.C1 = CFrame.new(-0.2, -0.2, 0.49)
local M1 = Instance.new("SpecialMesh", Orbd)
M1.MeshType = "Sphere"
M1.Scale    = Vector3.new(1, 0, 1)

local Orbvc = Instance.new("Part", Character)
Orbvc.Name         = "Orbvc"
Orbvc.Shape        = Enum.PartType.Block
Orbvc.CanCollide   = false
Orbvc.BrickColor   = BrickColor.new("White")
Orbvc.Transparency = 0
Orbvc.Material     = "Neon"
Orbvc.Size         = Vector3.new(0.2, 0.3, 0.2)
Orbvc.TopSurface, Orbvc.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
local W2 = Instance.new("Weld", Orbvc)
W2.Part0, W2.Part1 = Character.Head, Orbvc
W2.C1 = CFrame.new(0.2, -0.2, 0.49)
local M2 = Instance.new("SpecialMesh", Orbvc)
M2.MeshType = "Sphere"
M2.Scale    = Vector3.new(1, 0, 1)

-- ===== Sound assets =====
EFS = Instance.new("Sound"); EFS.Parent  = Torso; EFS.SoundId  = "rbxassetid://177359995"; EFS.Volume  = 4; EFS:Play()
EFS2 = Instance.new("Sound"); EFS2.Parent = Torso; EFS2.SoundId = "rbxassetid://177339878"; EFS2.Volume = 0.2; EFS2.Looped = true; EFS2:Play()
EFS3 = Instance.new("Sound"); EFS3.Parent = Torso; EFS3.SoundId = "rbxassetid://585364476"; EFS3.Volume = 0.8
ATS  = Instance.new("Sound"); ATS.Parent  = Torso; ATS.SoundId  = "rbxassetid://347611423"; ATS.Volume = 2

Character.Humanoid.WalkSpeed = 3

-- ===== Portal / Trail =====
trailwait = false
function PortalEffect()
    for _, v in pairs(Torso:GetChildren()) do
        if v:IsA("Part") and v.Name == "trap" then
            Effects.Wave.Create(BrickColor.new("Really black"), v.CFrame, 0, -.2, 0, .7, .02, .7, 0.08)
            v.CFrame = CFrame.new(v.CFrame.x, v.CFrame.y, v.CFrame.z) * angles(math.rad(0), math.rad(0 + 1000 * math.cos(sine)), math.rad(0))
        end
    end
end

function trail()
    if trailwait == false and attack == false and Anim == "Idle" then
        trailwait = true
        Effects.Sphere.Create(BrickColor.new("Really black"), RootPart.CFrame, 20, 10, 20, .8, -.05, .8, -2.94, 0.004)
        task.wait(.5)
        trailwait = false
    end
    if trailwait == false and attack == false and Anim == "Walk" then
        trailwait = true
        Effects.Sphere.Create(BrickColor.new("Really black"), RootPart.CFrame, 30, 10, 30, .4, -.05, .4, -2.94, 0.005)
        task.wait(.3)
        trailwait = false
    end
end

-- ===== attack1 / attack2 / blink =====
function attack1()
    attack = true
    RootPart.Anchored = true
    Humanoid.WalkSpeed = 0
    Effects.Wave.Create(BrickColor.new("Really black"), RootPart.CFrame, 1, 1, 1, 0.2, .5, 0.2, 0.07)
    Effects.Block.Create(BrickColor.new("Really black"), RootPart.CFrame, 2, 2, 2, 10.2, 10.2, 10.2, 0.07)
    task.wait()

    for _ = 0, 2, 0.05 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -4) * angles(math.rad(90), 0, 0), .4)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), .4)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    for _ = 0, 1, 0.05 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, -60, -4) * angles(math.rad(90), 0, 0), 1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), .4)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    EFS3:Play()
    for _ = 0, .1, 0.05 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, -60, -4) * angles(0, 0, math.rad(180)), 1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), .4)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    Effects.Wave.Create(BrickColor.new("Really black"), Head.CFrame, 1, 1, 1, 0.2, 0.5, 0.2, 0.07)
    Effects.Block.Create(BrickColor.new("Really black"), Torso.CFrame, 2, 2, 2, 10.2, 10.2, 10.2, 0.07)
    EFS.SoundId = "rbxassetid://518230185"
    EFS:Play()
    for _ = 0, 2, 0.05 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, -60, 0) * angles(0, 0, math.rad(180)), .2)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .4)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    local targetV5 = Character.Torso.CFrame
    task.wait()
    for _ = 0, 0, 1 do
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), 1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), 0)
        LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    Character.HumanoidRootPart.CFrame = targetV5
    attack = false
    Humanoid.WalkSpeed = 3
    RootPart.Anchored = false
end

function attack2()
    attack = true
    for _ = 0, 1, 0.05 do
        Character.Humanoid.WalkSpeed = .5
        swait()
        RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -3.6) * angles(math.rad(90), 0, 0), .4)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(90), 0, 0), .4)
        LW.C0         = clerp(LW.C0, CFrame.new(0, .5, 0), 0.4)
        RW.C0         = clerp(RW.C0, CFrame.new(0, .5, 0), 0.4)
        RH.C0         = clerp(RH.C0, cn(0, 1, 0) * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .4)
        LH.C0         = clerp(LH.C0, cn(0, 1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .4)
    end
    for _ = 1, 121 do
        task.wait()
        Humanoid.JumpPower = 0
        Humanoid.WalkSpeed = 40
        Effects.Wave.Create(BrickColor.new("Really black"), Torso.CFrame, 4, -4, 1.02, -0.1, 0.001, -0.005, 0.03)
        Effects.Break.Create(BrickColor.new("Really black"), Torso.CFrame, 0.2, 0.2, 0.2)
    end
    Effects.Block.Create(BrickColor.new("Really black"), Torso.CFrame, 2, 2, 2, 6.2, 6.2, 6.2, 0.07)
    Humanoid.JumpPower = 50
    Humanoid.WalkSpeed = 3
    attack = false
end

function blink()
    task.wait()
    for i = 0, 1, 0.1 do
        swait()
        M1.Scale = Vector3.new(1, 0.2 + 0.3*i, .9)
        M2.Scale = Vector3.new(1, 0.2 + 0.3*i, .9)
    end
    task.wait(1)
    for i = 0, 1, 0.2 do
        task.wait()
        M1.Scale = Vector3.new(1, 0.7 - 1*i, 1)
        M2.Scale = Vector3.new(1, 0.7 - 1*i, 1)
    end
    for i = 0, 1, 0.2 do
        swait()
        M1.Scale = Vector3.new(1, 0.7 + 0.3*i, 1)
        M2.Scale = Vector3.new(1, 0.7 + 0.3*i, 1)
    end
    while true do
        task.wait()
        swait(math.random(220, 440))
        for i = 0, 1, 0.05 do
            task.wait()
            M1.Scale = Vector3.new(1, 0.7 - 1*i, 1)
            M2.Scale = Vector3.new(1, 0.7 - 1*i, 1)
        end
        for i = 0, 1, 0.05 do
            swait()
            M1.Scale = Vector3.new(1, 0.7 + 0.3*i, 1)
            M2.Scale = Vector3.new(1, 0.7 + 0.3*i, 1)
        end
    end
end

-- ===== Health set to a big finite value (avoid overflow) =====
local BIG_HP = 1e100
Humanoid.MaxHealth = BIG_HP
Humanoid.Health    = BIG_HP
RunService:BindToRenderStep("magic_hp_regen", 0, function()
    if Humanoid.Health < BIG_HP then
        Humanoid.Health = BIG_HP
    end
end)

-- ===== Sound =====
EFS.SoundId = "rbxassetid://177359995"
EFS:Play()
task.wait(.5)
Sound = Instance.new("Sound", Torso)
Sound.SoundId = "rbxassetid://649587991"
Sound.Volume = 5
Sound.Looped = true
Sound:Play()

-- ===== onTouch / onTouch2 =====
function onTouch(part)
    local model   = part.Parent
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local head    = model:FindFirstChild("Head")
    if not humanoid or not head then return end
    if attack or model == Character or model.Name == "Effects" then return end

    if humanoid.Health > 0.01 then
        Effects.Block.Create(BrickColor.new("Really black"), head.CFrame, 2, 2, 2, 10.2, 10.2, 10.2, 0.07)
        humanoid.Health = 100  -- FE: does not replicate to server
        attack = true
        for _ = 0, 6, .5 do
            swait()
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, math.rad(-25)), .4)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), .4)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(60), 0, 0), 0.2)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(160), 0, math.rad(90)), 0.2)
            RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .2)
            LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .2)
        end
        ATS:Play()
        for _ = 0, 5, .5 do
            swait()
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, math.rad(25)), .4)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), .4)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), 0, 0), 0.2)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(90),  0, math.rad(-20)), 0.2)
            RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .2)
            LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .2)
        end
        attack = false
    end
end

function onTouch2(part)
    local model    = part.Parent
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local head     = model:FindFirstChild("Head")
    local rootpart = model:FindFirstChild("HumanoidRootPart")
    if not (humanoid and head and rootpart) then return end
    if model == Character or model.Name == "Effects" then return end
    if humanoid.Health <= 0 then return end

    Effects.Block.Create(BrickColor.new("Really black"), head.CFrame, 2, 2, 2, 10.2, 10.2, 10.2, 0.07)

    rootpart.Anchored = true
    for _ = 1, 120 do
        rootpart.CFrame = CFrame.new(rootpart.CFrame.x, rootpart.CFrame.y - .1, rootpart.CFrame.z)
        task.wait()
    end
    rootpart.Anchored = false

    -- FE-only pocket dimension (won't replicate to server)
    local derp = CFrame.new(10050, 1, 10050)
    local qw2 = Instance.new("Part", workspace)
    local qw3 = Instance.new("SpecialMesh", qw2)
    qw2.CFrame, qw2.Name, qw2.Anchored = derp, "sky", true
    qw3.MeshId    = "rbxassetid://1527559"
    qw3.TextureId = "rbxassetid://1529455"
    qw3.Scale     = Vector3.new(-1800, -2080, -1800)
    for i = 1, 200 do
        local qw = Instance.new("Part", workspace)
        qw.Shape      = Enum.PartType.Block
        qw.Size       = Vector3.new(8 + i/12, 8 + i/99, 8 + i/12)
        qw.CFrame     = CFrame.new(derp.x + i*math.random(), derp.y + i/20 + math.random(1,2), derp.z + i*math.random())
        qw.BrickColor = BrickColor.new("Black")
        qw.Anchored   = true
        qw.Name       = "Part"
        qw.TopSurface, qw.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
        qw.Material   = "Granite"
        Debris:AddItem(qw, 50)
    end
    Debris:AddItem(qw2, 50)

    task.wait()
    model:MoveTo(Vector3.new(10100, 101, 10100))
    for _ = 1, 400 do
        if humanoid.Health > 0 then
            humanoid.WalkSpeed = 4
            Effects.Break.Create(BrickColor.new("Really red"), head.CFrame, 0.2, 0.2, 0.2)
            humanoid:TakeDamage(0)
            for _ = 1, 5 do task.wait() end
        end
    end
    if humanoid.Health > 0 then
        for _ = 1, 10 do
            humanoid.Health = 100
            task.wait()
        end
    end
end

Torso.Touched:Connect(onTouch)

-- ===== Keybinds =====
local hidden, wait3, thetrap, wait2, autofind = false, false, false, false, false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode.Name:lower()

    if key == "z" and not attack then
        attack1()
    elseif key == "x" and not attack then
        attack2()
    elseif key == "v" then
        autofind = not autofind
    elseif key == "e" and not wait2 then
        wait2 = true
        EFS.SoundId = "rbxassetid://177359995"
        EFS:Play()
        task.wait(3.4)
        wait2 = false
    elseif key == "c" then
        if not hidden and not wait3 and not attack then
            hidden, wait3 = true, true
            Humanoid.JumpPower = 0
            attack = true
            Humanoid.WalkSpeed = 0
            for _ = 0, 5, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -10) * angles(math.rad(15), 0, 0), .05)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(45), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(25), 0, 0), 0.1)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(25), 0, 0), 0.1)
                RH.C0         = clerp(RH.C0, cn(1, -0.3, -0.5)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(0, 0, math.rad(-15)), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -0.3, -0.5) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(0, 0, math.rad(15)), .1)
            end
            Humanoid.WalkSpeed = 3
        elseif hidden and not wait3 then
            wait3 = true
            hidden = false
            EFS3:Play()
            Humanoid.WalkSpeed = 0
            for _ = 0, 5, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), .03)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-25), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.3)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(160), 0, 0), 0.3)
                RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .1)
            end
            Humanoid.WalkSpeed = 3
            Humanoid.JumpPower = 50
            attack = false
        end
        task.wait()
        wait3 = false
    elseif key == "q" and not attack then
        attack = true
        if not thetrap then
            Humanoid.WalkSpeed = 0
            Humanoid.JumpPower = 0
            for _ = 0, 2, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), .2)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.1)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.1)
                RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .1)
            end
            thetrap = true
            local trap = Instance.new("Part", Torso)
            trap.Size         = Vector3.new(3.1, 0.4, 3.1)
            trap.Transparency = 1
            trap.Anchored     = true
            trap.Material     = "Neon"
            trap.Name         = "LoadingTrap...."
            trap.CanCollide   = false
            trap.BrickColor   = BrickColor.new("Really black")
            trap.CFrame       = Torso.CFrame * CFrame.new(0, -3, 0)
            local trapMesh = Instance.new("CylinderMesh", trap)
            trapMesh.Scale = Vector3.new(2.5, 1, 2.5)
            for _ = 0, 5, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -6) * angles(0, 0, 0), .05)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, math.rad(-90)), 0.1)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(0, 0, math.rad(90)),  0.1)
                RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .1)
            end
            for _ = 1, 70 do
                trap.Transparency = trap.Transparency - .01
                task.wait()
            end
            trap.Touched:Connect(onTouch2)
            trap.Name = "trap"
            for _ = 0, 5, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), .05)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-25), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, math.rad(-20)), 0.1)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(0, 0, math.rad( 20)), 0.1)
                RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .1)
            end
            task.wait()
            Humanoid.WalkSpeed = 3
            Humanoid.JumpPower = 50
        else
            Humanoid.WalkSpeed = 0
            Humanoid.JumpPower = 0
            for _ = 0, 1, 0.05 do
                swait()
                RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, 0), .2)
                Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25), 0, 0), .2)
                LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.1)
                RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0), 0.1)
                RH.C0         = clerp(RH.C0, cn(1, -1, 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0), .1)
                LH.C0         = clerp(LH.C0, cn(-1, -1, 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0), .1)
            end
            for _, v in pairs(Torso:GetChildren()) do
                if v:IsA("Part") and v.Name == "trap" then
                    for _ = 1, 70 do
                        v.Transparency = v.Transparency + .01
                        task.wait()
                    end
                    v:Destroy()
                    task.wait()
                end
            end
            Humanoid.WalkSpeed = 3
            Humanoid.JumpPower = 50
            thetrap = false
        end
        attack = false
    end
end)

-- ===== Auto stuff =====
function AutoStuff()
    if attack == false and wait2 == false then
        local r = math.random(1, 500)
        if r == 1 then attack1()
        elseif r == 2 then attack2()
        elseif r == 3 then
            wait2 = true
            Humanoid.Jump = true
            task.wait(1.5)
            wait2 = false
        elseif r == 4 then
            wait2 = true
            EFS.SoundId = "rbxassetid://177359995"
            EFS:Play()
            task.wait(1.5)
            wait2 = false
        end
    end
end

-- ===== Bind render steps (unique names — original all used "ew" so only last ran) =====
RunService:BindToRenderStep("magic_autofind", 0, function()
    task.wait()
    if autofind then
        local target = findNearestTorso(Character.HumanoidRootPart.Position)
        if target then
            Humanoid:MoveTo(target.Position)
            AutoStuff()
        end
        Orbd.BrickColor  = BrickColor.new("Really red")
        Orbvc.BrickColor = BrickColor.new("Really red")
    else
        Orbd.BrickColor  = BrickColor.new("White")
        Orbvc.BrickColor = BrickColor.new("White")
    end
end)

RunService:BindToRenderStep("magic_portal", 0, function()
    if math.random(1, 500) == 1 then
        for _ = 1, 10 do
            PortalEffect()
            task.wait()
        end
    end
end)

RunService:BindToRenderStep("magic_trail", 0, function()
    trail()
end)

-- ===== Main animation loop =====
RunService.Stepped:Connect(function()
    Torsovelocity = (RootPart.Velocity * Vector3.new(1, 0, 1)).magnitude
    velocity = RootPart.Velocity.y
    sine = sine + change
    local hit = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)

    if RootPart.Velocity.y > 1 and hit == nil then
        Anim = "Jump"
        if not attack then
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(-5), 0, 0), .1)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), 0, 0), .1)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(-40), 0, math.rad(30)), .1)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-40), 0, math.rad(-30)), .1)
            RH.C0         = clerp(RH.C0, cn(1, -.9, -.3)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(math.rad(3), 0, 0), .1)
            LH.C0         = clerp(LH.C0, cn(-1, -.7, -.5) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(-3), 0, 0), .1)
        end
    elseif RootPart.Velocity.y < -1 and hit == nil then
        Anim = "Fall"
        if not attack then
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(10), 0, 0), .1)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), 0, 0), .1)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(-20), 0, math.rad(50)), .1)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), 0, math.rad(-50)), .1)
            RH.C0         = clerp(RH.C0, cn(1, -1, -.3)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(math.rad(-5), 0, 0), .1)
            LH.C0         = clerp(LH.C0, cn(-1, -.8, -.3) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(-5), 0, 0), .1)
        end
    elseif Torsovelocity < 1 and hit ~= nil then
        Anim = "Idle"
        if not attack then
            change = .3
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.05*math.cos(sine/25)) * angles(0, 0, math.rad(5)), .05)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(25 - 1*math.cos(sine/25)), 0, math.rad(-5)), .05)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(0, 0, math.rad(5 + 3*math.cos(sine/25))), 0.05)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, math.rad(-5 - 3*math.cos(sine/25))), 0.05)
            RH.C0         = clerp(RH.C0, cn(1, -.9 - 0.05*math.cos(sine/25), 0)  * CFrame.fromEulerAnglesXYZ(0,  1.6, 0) * angles(math.rad(-2 + 1*math.cos(sine/25)), math.rad(-2), 0), .05)
            LH.C0         = clerp(LH.C0, cn(-1, -.9 - 0.05*math.cos(sine/25), 0) * CFrame.fromEulerAnglesXYZ(0, -1.6, 0) * angles(math.rad(-2 + 1*math.cos(sine/25)), math.rad(-2), 0), .05)
        end
    elseif Torsovelocity > 2 and hit ~= nil then
        Anim = "Walk"
        if not attack then
            change = 0.3
            RootJoint.C0  = clerp(RootJoint.C0, RootCF * CFrame.new(0, 0, -0.175 + 0.025*math.cos(sine/3.5) + -math.sin(sine/3.5)/7) * angles(math.rad(5 - 2.5*math.cos(sine/3.5)), 0, math.rad(10*math.cos(sine/7))), 0.15)
            Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * CFrame.new(0, 0, 0.025*math.cos(sine/3.5)) * angles(math.rad(0 - 4.5*math.cos(sine/3.5)), math.rad(5 - 6.5*math.cos(sine/3.5)), math.rad(-10*math.cos(sine/7))), 0.15)
            RW.C0         = clerp(RW.C0, CFrame.new( 1.5, 0.5, 0) * angles(math.rad(15*math.cos(sine/7)) + math.sin(sine/7)/2.5, 0, math.rad(10)),  0.05)
            LW.C0         = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-15*math.cos(sine/7)) + -math.sin(sine/7)/2.5, 0, math.rad(-10)), 0.05)
            RH.C0         = clerp(RH.C0, CFrame.new(1, -0.925 - 0.5*math.cos(sine/7)/2, 0.5*math.cos(sine/7)/2) * angles(math.rad(-15 - 15*math.cos(sine/7)) + -math.sin(sine/7)/2.5, math.rad(90 - 10*math.cos(sine/7)), 0) * angles(math.rad(0 + 2.5*math.cos(sine/7)), 0, 0), 0.15)
            LH.C0         = clerp(LH.C0, CFrame.new(-1, -0.925 + 0.5*math.cos(sine/7)/2, -0.5*math.cos(sine/7)/2) * angles(math.rad(-15 + 15*math.cos(sine/7)) + math.sin(sine/7)/2.5, math.rad(-90 - 10*math.cos(sine/7)), 0) * angles(math.rad(0 - 2.5*math.cos(sine/7)), 0, 0), 0.15)
        end
    end

    -- Effect step (iterates backward so table.remove is safe)
    if #Effects > 0 then
        for e = #Effects, 1, -1 do
            local T = Effects[e]
            if T then
                local Part  = T[1]
                local Mode  = T[2]
                local Delay = T[3]
                if Part and Part.Parent and Part.Transparency <= 1 then
                    if Mode == "Block1" then
                        Part.CFrame = Part.CFrame * CFrame.fromEulerAnglesXYZ(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                        local M = T[7]; if M then M.Scale = M.Scale + Vector3.new(T[4], T[5], T[6]) end
                        Part.Transparency = Part.Transparency + Delay
                    elseif Mode == "Block2" then
                        local M = T[7]; if M then M.Scale = M.Scale + Vector3.new(T[4], T[5], T[6]) end
                        Part.Transparency = Part.Transparency + Delay
                    elseif Mode == "Cylinder" then
                        local M = T[1]:FindFirstChildOfClass("DataModelMesh")
                        if M then M.Scale = M.Scale + Vector3.new(T[4], T[5], T[6]) end
                        Part.Transparency = Part.Transparency + Delay
                    elseif Mode == "Shatter" then
                        Part.Transparency = Part.Transparency + Delay
                        T[4] = T[4] * CFrame.new(0, T[7], 0)
                        Part.CFrame = T[4] * CFrame.fromEulerAnglesXYZ(T[6], 0, 0)
                        T[6] = T[6] + T[5]
                    end
                else
                    if Part and Part.Parent then Part:Destroy() end
                    table.remove(Effects, e)
                end
            end
        end
    end
end)

-- ===== NoClip =====
RunService.Stepped:Connect(function()
    pcall(function() Player.Character.Torso.CanCollide = false end)
    pcall(function() Player.Character.Head.CanCollide  = false end)
end)

print("---------------------")
print("Made by 123jl123")
print("---------------------")
print("do not leak...")
print("and i hope you have a nice day :)")
print("---------------------")

blink()
