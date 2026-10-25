-- ============================================================
-- 1 am and im still fucking doing this help FIXED BY FEYZ
-- ============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Debris            = game:GetService("Debris")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")

local p         = Players.LocalPlayer
local char      = p.Character or p.CharacterAdded:Wait()
local Character = char
local Player    = p
local Mau5      = p:GetMouse()

-- ===== R6 check =====
if not char:FindFirstChild("Torso") then
    warn("[OrbRig] This script requires an R6 avatar. Set your avatar to R6 and re-execute.")
    return
end

-- ===== Body part refs =====
local larm   = char:FindFirstChild("Left Arm")
local rarm   = char:FindFirstChild("Right Arm")
local lleg   = char:FindFirstChild("Left Leg")
local rleg   = char:FindFirstChild("Right Leg")
local hed    = char:FindFirstChild("Head")
local torso  = char:FindFirstChild("Torso")
local hum    = char:FindFirstChild("Humanoid")
local root   = char:FindFirstChild("HumanoidRootPart")
local RootPart = root
local cam    = workspace.CurrentCamera

-- ===== Aliases =====
local l       = Lighting
local debris  = Debris
local rs      = RunService.RenderStepped

it    = Instance.new
vt    = Vector3.new
cn    = CFrame.new
cf    = CFrame.new
euler = CFrame.fromEulerAnglesXYZ
angles = CFrame.Angles

-- ===== Missing globals (were used but never defined) =====
so = function(id, parent, vol, pitch)
    local s = Instance.new("Sound", parent)
    s.SoundId = id                       -- id is a full URL
    s.Volume  = vol  or 1
    s.Pitch   = pitch or 1
    s:Play()
    Debris:AddItem(s, 10)
end

swait = function(n)
    n = n or 1
    for _ = 1, n do RunService.Heartbeat:Wait() end
end

-- ===== Debounce table =====
Debounces = {
    CanAttack = true,
    NoIdle    = false,
    Anger     = false,
    OrbMove1 = false, OrbMove2 = false, OrbMove3 = false, OrbMove4 = false,
    OrbMove5 = false, OrbMove6 = false, OrbMove7 = false, OrbMove8 = false,
}

-- ===== Fixed QuaternionSlerp (original never returned in the common case) =====
function QuaternionFromCFrame(cf)
    local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
    local trace = m00 + m11 + m22
    if trace > 0 then
        local s = math.sqrt(1 + trace)
        local recip = 0.5 / s
        return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
    else
        local i = 0
        if m00 < m11 then i = 1 end
        if i == 0 and m00 or m11 < m22 then i = 2 end
        if i == 0 then
            local s = math.sqrt(m00 - m11 - m22 + 1)
            local recip = 0.5 / s
            return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
        elseif i == 1 then
            local s = math.sqrt(m11 - m22 - m00 + 1)
            local recip = 0.5 / s
            return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
        else
            local s = math.sqrt(m22 - m00 - m11 + 1)
            local recip = 0.5 / s
            return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
        end
    end
end

function QuaternionToCFrame(px, py, pz, x, y, z, w)
    local xs, ys, zs = x + x, y + y, z + z
    local wx, wy, wz = w * xs, w * ys, w * zs
    local xx, xy, xz = x * xs, x * ys, x * zs
    local yy, yz, zz = y * ys, y * zs, z * zs
    return CFrame.new(px, py, pz,
        1 - (yy + zz), xy - wz, xz + wy,
        xy + wz, 1 - (xx + zz), yz - wx,
        xz - wy, yz + wx, 1 - (xx + yy))
end

function QuaternionSlerp(a, b, t)
    local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
    local startInterp, finishInterp
    if cosTheta >= 1e-4 then
        if 1 - cosTheta > 1e-4 then
            local theta = math.acos(cosTheta)
            local invSin = 1 / math.sin(theta)
            startInterp  = math.sin((1 - t) * theta) * invSin
            finishInterp = math.sin(t * theta) * invSin
        else
            startInterp, finishInterp = 1 - t, t
        end
    else
        if 1 + cosTheta > 1e-4 then
            local theta = math.acos(-cosTheta)
            local invSin = 1 / math.sin(theta)
            startInterp  = math.sin((t - 1) * theta) * invSin
            finishInterp = math.sin(t * theta) * invSin
        else
            startInterp, finishInterp = t - 1, t
        end
    end
    return a[1]*startInterp + b[1]*finishInterp,
           a[2]*startInterp + b[2]*finishInterp,
           a[3]*startInterp + b[3]*finishInterp,
           a[4]*startInterp + b[4]*finishInterp
end

function Lerp(a, b, t)
    local qa, qb = {QuaternionFromCFrame(a)}, {QuaternionFromCFrame(b)}
    local ax, ay, az = a.x, a.y, a.z
    local bx, by, bz = b.x, b.y, b.z
    local _t = 1 - t
    return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz, QuaternionSlerp(qa, qb, t))
end
local Lerp = CFrame.new().lerp   -- original shorthand overwrite

function scaleTween(strt, fnsh, tim)
    local c1, c2 = {strt.X, strt.Y, strt.Z}, {fnsh.X, fnsh.Y, fnsh.Z}
    for i, v in pairs(c1) do c1[i] = v + (c2[i] - v) * tim end
    return Vector3.new(c1[1], c1[2], c1[3])
end
function Lerp2(a, b, i) return a:lerp(b, i) end

function newWeld(wp0, wp1, x, y, z)
    local wld = Instance.new("Weld", wp1)
    wld.Part0, wld.Part1 = wp0, wp1
    wld.C0 = CFrame.new(x, y, z)
    return wld
end
function WeldBetween(a, b)
    local w = Instance.new("Weld", a)
    w.Part0, w.Part1 = a, b
    w.C0 = a.CFrame:inverse() * b.CFrame
    return w
end
function nooutline(part)
    part.TopSurface, part.BottomSurface = 10, 10
    part.LeftSurface, part.RightSurface = 10, 10
    part.FrontSurface, part.BackSurface = 10, 10
end
function part(formfactor, parent, material, reflectance, transparency, brickcolor, name, size)
    local fp = it("Part")
    fp.formFactor, fp.Parent = formfactor, parent
    fp.Reflectance, fp.Transparency = reflectance, transparency
    fp.CanCollide, fp.Locked = false, true
    fp.BrickColor = BrickColor.new(tostring(brickcolor))
    fp.Name, fp.Size = name, size
    fp.Position = torso.Position
    nooutline(fp)
    fp.Material = material
    fp:BreakJoints()
    return fp
end
function mesh(Mesh, part, meshtype, meshid, offset, scale)
    local m = it(Mesh)
    m.Parent = part
    if Mesh == "SpecialMesh" then
        m.MeshType = meshtype
        m.MeshId   = meshid
    end
    m.Offset, m.Scale = offset, scale
    return m
end
function weld(parent, p0, p1, c0, c1)
    local w = it("Weld")
    w.Parent, w.Part0, w.Part1, w.C0, w.C1 = parent, p0, p1, c0, c1
    return w
end
function HasntDamaged(name)
    for _, v in pairs(Damaged) do if v == name then return false end end
    return true
end
Damaged = Damaged or {}

-- ===== Fixed ShowDamage =====
function ShowDamage(Pos, Text, Time, Color)
    local Rate = 1/30
    Pos, Text, Time = Pos or Vector3.new(), Text or "", Time or 2
    Color = Color or Color3.new(1, 0, 0)
    local EffectPart = part("Custom", workspace, "Neon", 0, 1, BrickColor.new(Color), "Effect", vt(0, 0, 0))
    EffectPart.Anchored = true
    local gui = Instance.new("BillboardGui")
    gui.Size, gui.Adornee = UDim2.new(3, 3, 3, 3), EffectPart
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(3, 3, 3, 3)
    lbl.Text = Text
    lbl.TextColor3 = Color
    lbl.TextStrokeColor3 = BrickColor.new("Really black").Color
    lbl.TextScaled, lbl.TextStrokeTransparency = true, 0
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Parent = gui
    gui.Parent = EffectPart
    Debris:AddItem(EffectPart, Time + 0.1)
    EffectPart.Parent = workspace
    task.delay(0, function()
        local Frames = Time / Rate
        for Frame = 1, Frames do
            task.wait(Rate)
            local Percent = Frame / Frames
            EffectPart.CFrame = CFrame.new(Pos) + Vector3.new(0, Percent, 0)
            lbl.TextTransparency = Percent
            lbl.TextStrokeTransparency = Percent
        end
        if EffectPart and EffectPart.Parent then EffectPart:Destroy() end
    end)
end

-- ===== Damagefunc (mostly unchanged, API fixed) =====
function Damagefunc(Part, hit, minim, maxim, knockback, Type, Property, Delay, KnockbackType, decreaseblock)
    if hit.Parent == nil then return end
    local h = hit.Parent:FindFirstChild("Humanoid")
    for _, v in pairs(hit.Parent:GetChildren()) do
        if v:IsA("Humanoid") then h = v end
    end
    if hit.Parent.Parent and hit.Parent.Parent:FindFirstChild("Torso") then
        h = hit.Parent.Parent:FindFirstChild("Humanoid")
    end
    if hit.Parent:IsA("Accessory") then
        hit = hit.Parent.Parent:FindFirstChild("Head")
    end
    if h and hit.Parent.Name ~= Character.Name and hit.Parent:FindFirstChild("Torso") then
        if hit.Parent:FindFirstChild("DebounceHit") and hit.Parent.DebounceHit.Value then return end
        local c = Instance.new("ObjectValue")
        c.Name, c.Value, c.Parent = "creator", p, h
        Debris:AddItem(c, 0.5)
        local Damage = math.random(minim, maxim)
        local blocked, block = false, hit.Parent:FindFirstChild("Block")
        if block and block.Value and block.Value > 0 then
            blocked = true
            if decreaseblock then block.Value = block.Value - 1 end
        end
        local col = blocked and BrickColor.new("Bright blue").Color or Part.BrickColor.Color
        ShowDamage(hit.CFrame * CFrame.new(0, 0, Part.Size.Z/2).p + Vector3.new(0, 1.5, 0), -Damage, 1.5, col)

        if Type == "Knockdown" then
            hum = hit.Parent.Humanoid
            hum.PlatformStand = true
            task.delay(0.1, function() if hum then hum.PlatformStand = false end end)
            local angle = (hit.Position - Property.Position).unit
            local bv = Instance.new("BodyVelocity")
            bv.velocity = angle * knockback
            bv.P, bv.maxForce = 5000, Vector3.new(8000, 8000, 8000)
            bv.Parent = hit
            local rl = Instance.new("BodyAngularVelocity")
            rl.P = 3000
            rl.maxTorque = Vector3.new(5e5, 5e5, 5e5) * 5e13
            rl.angularvelocity = Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10))
            rl.Parent = hit
            Debris:AddItem(bv, 0.5)
            Debris:AddItem(rl, 0.5)
        elseif Type == "Normal" then
            local vp = Instance.new("BodyVelocity")
            vp.P = 500
            vp.maxForce = Vector3.new(math.huge, 0, math.huge)
            if KnockbackType == 1 then
                vp.velocity = Property.CFrame.lookVector * knockback + Property.Velocity / 1.05
            else
                vp.velocity = Property.CFrame.lookVector * knockback
            end
            if knockback > 0 then vp.Parent = hit.Parent.Torso end
            Debris:AddItem(vp, 0.1)
        elseif Type == "Up" then
            local bv = Instance.new("BodyVelocity")
            bv.velocity = vt(0, 60, 0)
            bv.P, bv.maxForce = 5000, Vector3.new(8000, 8000, 8000)
            bv.Parent = hit
            Debris:AddItem(bv, 1)
            local rl = Instance.new("BodyAngularVelocity")
            rl.P = 3000
            rl.maxTorque = Vector3.new(5e5, 5e5, 5e5) * 5e13
            rl.angularvelocity = Vector3.new(math.random(-30,30), math.random(-30,30), math.random(-30,30))
            rl.Parent = hit
            Debris:AddItem(rl, 0.5)
        elseif Type == "Snare" then
            local bp = Instance.new("BodyPosition")
            bp.P, bp.D = 2000, 100
            bp.maxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.position = hit.Parent.Torso.Position
            bp.Parent = hit.Parent.Torso
            Debris:AddItem(bp, 1)
        end

        local deb = Instance.new("BoolValue")
        deb.Name, deb.Parent, deb.Value = "DebounceHit", hit.Parent, true
        Debris:AddItem(deb, Delay or 0.5)
        local c2 = Instance.new("ObjectValue")
        c2.Name, c2.Value, c2.Parent = "creator", p, h
        Debris:AddItem(c2, 0.5)
    end
end

-- ===== Orb + Bomb constructors =====
function MakeOrb(Type)
    local this = {}
    local LightOrDark = Type or math.random(0, 1)
    local Orb = Instance.new("Part", Orbs)
    Orb.Anchored, Orb.Material = true, "Neon"
    Orb.BrickColor = BrickColor.new("Medium stone grey")
    Orb.CFrame = torso.CFrame
    Orb.CanCollide, Orb.Shape = false, "Ball"
    Orb.Size = Vector3.new(0.9, 0.9, 0.9)
    Orb.BottomSurface, Orb.TopSurface, Orb.Locked = "Smooth", "Smooth", true

    local Outline = Instance.new("Part", Orbs)
    Outline.Anchored, Outline.Material = true, "Neon"
    Outline.BrickColor = BrickColor.new("Medium stone grey")
    Outline.CFrame = torso.CFrame
    Outline.CanCollide, Outline.Shape = false, "Ball"
    Outline.Size = Vector3.new(1, 1, 1)
    Outline.BottomSurface, Outline.TopSurface = "Smooth", "Smooth"
    Outline.Transparency, Outline.Locked = 0.75, true

    newWeld(Outline, Orb, 0, 0, 0)
    local w = Instance.new("Weld", Orb)
    w.Part0, w.Part1, w.C0 = Orb, Outline, CFrame.new()

    local OrbMesh = Instance.new("SpecialMesh", Orb)
    OrbMesh.MeshType = "Sphere"
    OrbMesh.Scale = Vector3.new(0.9, 0.9, 0.9)

    local OutlineMesh = Instance.new("SpecialMesh", Outline)
    OutlineMesh.MeshType = "Sphere"
    OutlineMesh.Scale = Vector3.new(1, 1, 1)

    function this.Size(v3)
        OrbMesh.Scale     = Lerp2(OrbMesh.Scale,     v3 - Vector3.new(0.1,0.1,0.1), 0.3)
        OutlineMesh.Scale = Lerp2(OutlineMesh.Scale, v3, 0.3)
    end
    function this.CFrame(c)
        Orb.CFrame = c
        Outline.CFrame = c
    end
    return Orb, Outline, this
end

function TailedBeastBomb()
    local this = {}
    local model = Instance.new("Model", char)
    local Outer = Instance.new("Part", model)
    Outer.Material, Outer.Name = "Neon", "Outer"
    Outer.BrickColor = BrickColor.new("Really black")
    Outer.CFrame, Outer.Locked = CFrame.new(), true
    Outer.Size, Outer.CanCollide = Vector3.new(4,4,4), false
    Outer.Transparency = 0.25
    local OuterMesh = Instance.new("SpecialMesh", Outer)
    OuterMesh.MeshType, OuterMesh.Scale = "Sphere", Vector3.new(1,1,1)

    local Inner = Instance.new("Part", model)
    Inner.Material, Inner.Name = "Neon", "Inner"
    Inner.BrickColor = BrickColor.new("Institutional white")
    Inner.CFrame, Inner.Locked = Outer.CFrame, true
    Inner.Size = Outer.Size - Vector3.new(1,1,1)
    Inner.CanCollide, Inner.Transparency = false, 0.8
    local InnerMesh = Instance.new("SpecialMesh", Inner)
    InnerMesh.MeshType, InnerMesh.Scale = "Sphere", Vector3.new(1,1,1)

    local w1 = Instance.new("Weld", Inner)
    w1.Part0, w1.Part1, w1.C0 = Inner, Outer, CFrame.new()

    local Core = Instance.new("Part", model)
    Core.Material, Core.Name = "Neon", "Core"
    Core.BrickColor = BrickColor.new("New Yeller")
    Core.CFrame, Core.Locked = Outer.CFrame, true
    Core.Size = Inner.Size - Vector3.new(2,2,2)
    Core.CanCollide, Core.Shape, Core.Transparency = false, 0, 0
    local CoreMesh = Instance.new("SpecialMesh", Core)
    CoreMesh.MeshType, CoreMesh.Scale = "Sphere", Vector3.new(1,1,1)

    local w2 = Instance.new("Weld", Inner)
    w2.Part0, w2.Part1, w2.C0 = Inner, Core, CFrame.new()

    function this.reSize(v3)
        Outer.Size = Lerp2(Outer.Size, v3, 0.3)
        Inner.Size = Lerp2(Inner.Size, Outer.Size - Vector3.new(1,1,1), 0.3)
        Core.Size  = Lerp2(Core.Size,  Inner.Size - Vector3.new(2,2,2), 0.3)
    end
    return Outer, Inner, Core, this
end

function SpawnRasengan(m, c)
    local Rasengan = Instance.new("Part", m)
    Rasengan.BrickColor, Rasengan.Material = BrickColor.new("Bright blue"), "Neon"
    Rasengan.Anchored, Rasengan.CFrame = true, c or CFrame.new()
    Rasengan.CanCollide, Rasengan.Locked = false, true
    Rasengan.BottomSurface, Rasengan.TopSurface = "Smooth", "Smooth"
    Rasengan.Size = Vector3.new(0.9, 0.9, 0.9)
    local msh = Instance.new("SpecialMesh", Rasengan)
    msh.MeshType = "Sphere"

    local Outline = Instance.new("Part", m)
    Outline.BrickColor, Outline.Material = BrickColor.new("Institutional white"), "Neon"
    Outline.Transparency, Outline.Anchored = 0.7, true
    Outline.CanCollide, Outline.Locked = false, true
    Outline.BottomSurface, Outline.TopSurface = "Smooth", "Smooth"
    Outline.CFrame = Rasengan.CFrame
    Outline.Size = Rasengan.Size + Vector3.new(0.1,0.1,0.1)
    local om = Instance.new("SpecialMesh", Outline)
    om.MeshType = "Sphere"

    local w = Instance.new("Weld", Rasengan)
    w.Part0, w.Part1, w.C0 = Rasengan, Outline, CFrame.new()
    return Rasengan, Outline
end

function SpawnRasenShurikan(m, c)
    local Rasengan, Outline = SpawnRasengan(m, c)
    local this = {}
    local interval = 0
    Rasengan.BrickColor = BrickColor.new("Crimson")
    Outline.BrickColor = BrickColor.new("Really black")

    local Shurikan = Instance.new("Part", m)
    Shurikan.BrickColor, Shurikan.Material = BrickColor.new("Institutional white"), "Neon"
    Shurikan.Anchored, Shurikan.CanCollide = true, false
    Shurikan.BottomSurface, Shurikan.TopSurface = "Smooth", "Smooth"
    Shurikan.Locked, Shurikan.Size = true, Vector3.new(1,1,1)
    Shurikan.CFrame = Rasengan.CFrame

    local sm = Instance.new("SpecialMesh", Shurikan)
    sm.MeshType  = "FileMesh"
    sm.MeshId    = "rbxassetid://11376946"
    sm.Scale     = Vector3.new(7,7,7)
    sm.TextureId = "rbxassetid://269748808"

    function this.Start()
        this.Conn = RunService.RenderStepped:Connect(function()
            interval += 60
            Shurikan.CFrame = Rasengan.CFrame * CFrame.Angles(0, math.rad(interval), 0)
        end)
    end
    function this.Stop()
        if this.Conn then this.Conn:Disconnect() end
        Shurikan.CFrame = Rasengan.CFrame
    end
    return Rasengan, Outline, Shurikan, sm, this
end

-- ===== TruthSeekerOrb wrapper (replaces broken InstanceService) =====
function TruthSeekerOrb()
    local O1, O2 = MakeOrb()
    local wrapper = {}
    local mt = {}
    mt.__index = function(_, k)
        if k == "Outline" then return O2 end
        if k == "CFrame"  then return O1.CFrame end
        if k == "Size"    then return O1.Size end
        if k == "Parent"  then return O1.Parent end
        if k == "Touched" then return O1.Touched end
        if k == "Base"    then return O1 end
        return O1[k]
    end
    mt.__newindex = function(_, k, v)
        if k == "CFrame" then
            O1.CFrame, O2.CFrame = v, v
        elseif k == "Parent" then
            O1.Parent, O2.Parent = v, v
        elseif k == "Size" then
            local m1 = O1:FindFirstChildOfClass("SpecialMesh")
            local m2 = O2:FindFirstChildOfClass("SpecialMesh")
            if m1 and m2 then
                m1.Scale = Lerp2(m1.Scale, v - Vector3.new(0.1,0.1,0.1), 0.3)
                m2.Scale = Lerp2(m2.Scale, v, 0.3)
            end
        else
            O1[k] = v
        end
    end
    function wrapper:Destroy()
        O1:Destroy()
        O2:Destroy()
    end
    return setmetatable(wrapper, mt)
end

-- ===== Welds for R6 rig =====
newWeld(torso, larm, -1.5, 0.5, 0); larm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, rarm,  1.5, 0.5, 0); rarm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, hed,   0,   1.5, 0)
newWeld(torso, lleg, -0.5, -1,  0); lleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(torso, rleg,  0.5, -1,  0); rleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(root,  torso, 0,  -1,   0); torso.Weld.C1 = CFrame.new(0, -1, 0)

local laDef = CFrame.new(-1.5, 0.5, 0)
local raDef = CFrame.new( 1.5, 0.5, 0)
local hDef  = CFrame.new(0, 1.5, 0)
local tDef  = CFrame.new(0, -1, 0)
local llDef = CFrame.new(-0.5, -1, 0)
local rlDef = CFrame.new( 0.5, -1, 0)

-- ===== Orbs folder =====
Orbs = Instance.new("Model", char)
Orbs.Name = "Truthseeker Orbs"

local Orb1, Orb2, Orb3, Orb4 = TruthSeekerOrb(), TruthSeekerOrb(), TruthSeekerOrb(), TruthSeekerOrb()
local Orb5, Orb6, Orb7, Orb8 = TruthSeekerOrb(), TruthSeekerOrb(), TruthSeekerOrb(), TruthSeekerOrb()
local Orbs_ = {Orb1=Orb1, Orb2=Orb2, Orb3=Orb3, Orb4=Orb4, Orb5=Orb5, Orb6=Orb6, Orb7=Orb7, Orb8=Orb8}

local CurrentHealth = hum.Health
local DebounceShot = false

-- ===== Tailed Beast Bomb attack (mostly unchanged) =====
function TailedBeastBombAttack()
    hum.WalkSpeed = 0
    Debounces.CanAttack, Debounces.NoIdle = false, true
    for i = 1, 10 do
        larm.Weld.C0 = Lerp(larm.Weld.C0, laDef * CFrame.Angles(0, math.rad(20), math.rad(-80)), 0.2)
        torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, 45, 0) * CFrame.Angles(math.rad(10), 0, 0), 0.2)
        rarm.Weld.C0 = Lerp(rarm.Weld.C0, raDef * CFrame.Angles(0, math.rad(-20), math.rad(80)), 0.2)
        hed.Weld.C0  = Lerp(hed.Weld.C0,  hDef  * CFrame.Angles(math.rad(10), 0, 0), 0.2)
        lleg.Weld.C0 = Lerp(lleg.Weld.C0, llDef * CFrame.Angles(math.rad(-10), 0, math.rad(-20)), 0.2)
        rleg.Weld.C0 = Lerp(rleg.Weld.C0, rlDef * CFrame.Angles(math.rad(-10), 0, math.rad(20)), 0.2)
        task.wait()
    end

    local Outer, Inner, Core, Control = TailedBeastBomb()
    local SetupWeld = Instance.new("Weld", Inner)
    SetupWeld.Part0, SetupWeld.Part1 = Inner, torso
    SetupWeld.C0 = CFrame.new(0, 0, 10)
    task.wait()
    Core.Anchored, Outer.Anchored, Inner.Anchored = true, true, true
    for i = 1, 16 do
        Control.reSize(Lerp2(Outer.Size, Vector3.new(23,23,23), 0.3))
        task.wait()
    end
    task.wait(0.5)
    for i = 1, 20 do
        larm.Weld.C0 = Lerp(larm.Weld.C0, laDef * CFrame.Angles(0, math.rad(-80), math.rad(-80)), 0.2)
        torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, 45, 0) * CFrame.Angles(math.rad(-20), 0, 0), 0.2)
        rarm.Weld.C0 = Lerp(rarm.Weld.C0, raDef * CFrame.Angles(0, math.rad(80), math.rad(80)), 0.2)
        hed.Weld.C0  = Lerp(hed.Weld.C0,  hDef  * CFrame.Angles(math.rad(-10), 0, 0), 0.2)
        lleg.Weld.C0 = Lerp(lleg.Weld.C0, llDef * CFrame.Angles(math.rad(10), 0, math.rad(-20)), 0.2)
        rleg.Weld.C0 = Lerp(rleg.Weld.C0, rlDef * CFrame.Angles(math.rad(10), 0, math.rad(20)), 0.2)
        task.wait()
    end
    SetupWeld:Destroy()
    Core.Anchored, Outer.Anchored, Inner.Anchored = false, false, false

    local function shove(part)
        local bv = Instance.new("BodyVelocity", part)
        bv.maxForce = Vector3.new(1,1,1) * math.huge
        bv.velocity = torso.CFrame.lookVector * 100
    end
    shove(Inner); shove(Core); shove(Outer)

    local Explode
    Explode = Core.Touched:Connect(function(hit)
        if hit ~= char and hit.Name ~= "Outer" and hit.Name ~= "Inner" then
            Inner:Destroy(); Outer:Destroy()
            Explode:Disconnect()
            local cf = Core.CFrame
            Core.Anchored = true
            Core.Size = Vector3.new(3,3,3)
            Core.CanCollide = false

            -- Impact visuals
            local part3 = Instance.new("Part", rarm)
            part3.Anchored, part3.CanCollide, part3.Locked = true, false, true
            part3.TopSurface, part3.BottomSurface = "SmoothNoOutlines", "SmoothNoOutlines"
            part3.FormFactor, part3.Size = "Custom", Vector3.new(1,1,1)
            part3.CFrame, part3.Transparency = Core.CFrame, 0
            part3.BrickColor = BrickColor.new("Institutional white")
            local m3 = Instance.new("SpecialMesh", part3)
            m3.MeshType, m3.Scale = "Sphere", Vector3.new(1,1,1)

            local part4 = Instance.new("Part", rarm)
            part4.Material, part4.Anchored = "Neon", true
            part4.CanCollide, part4.Locked = false, true
            part4.TopSurface, part4.BottomSurface = "SmoothNoOutlines", "SmoothNoOutlines"
            part4.FormFactor, part4.Size = "Custom", Vector3.new(1,1,1)
            part4.CFrame, part4.Transparency = Core.CFrame, 1
            part4.BrickColor = BrickColor.new("New Yeller")
            local m4 = Instance.new("SpecialMesh", part4)
            m4.MeshType, m4.Scale = "Sphere", Vector3.new(0.5,0.5,0.5)

            local part7 = Instance.new("Part", rarm)
            part7.Material, part7.Anchored = "Neon", true
            part7.CanCollide, part7.Locked = false, true
            part7.TopSurface, part7.BottomSurface = "SmoothNoOutlines", "SmoothNoOutlines"
            part7.FormFactor, part7.Size = "Custom", Vector3.new(1,1,1)
            part7.CFrame, part7.Transparency = Core.CFrame, 0
            part7.BrickColor = BrickColor.new("Really black")
            local m7 = Instance.new("SpecialMesh", part7)
            m7.MeshType, m7.Scale = "Sphere", Vector3.new(0.1,0.1,0.1)

            -- Damage nearby humans
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v ~= char and v:FindFirstChild("Torso") and v:FindFirstChild("Humanoid") then
                    if (v.Torso.Position - Core.Position).Magnitude < 80 then
                        Damagefunc(Core, v.Torso, 10, 20, math.random(3,6), "Normal", RootPart, 0.05, 1)
                        v.Humanoid.PlatformStand = true
                        v.Torso.Velocity = hed.CFrame.lookVector * 100
                    end
                end
            end

            -- Mesh rings
            local part = Instance.new("Part", rarm)
            part.Anchored, part.CanCollide, part.Locked = true, false, true
            part.FormFactor, part.Size = "Custom", Vector3.new(1,1,1)
            part.CFrame, part.Transparency = Core.CFrame, 1
            part.BrickColor = BrickColor.new("Really black")
            local msh = Instance.new("SpecialMesh", part)
            msh.MeshId, msh.Scale = "rbxassetid://20329976", Vector3.new(2,2,2)

            local part2 = part:Clone(); part2.Parent = rarm
            part2.BrickColor = BrickColor.new("Really black")
            local part5 = part:Clone(); part5.Parent = rarm
            part5.BrickColor = BrickColor.new("New Yeller")
            local part6 = part:Clone(); part6.Parent = rarm
            part6.BrickColor = BrickColor.new("Institutional white")

            local msh2 = msh:Clone(); msh2.Parent = part2; msh2.Scale = Vector3.new(3,3,3)
            local msh5 = msh:Clone(); msh5.Parent = part5; msh5.Scale = Vector3.new(3,3,3)
            local msh6 = msh:Clone(); msh6.Parent = part6; msh6.Scale = Vector3.new(3,3,3)

            -- Blasts
            local blast  = Instance.new("Part", rarm)
            blast.BrickColor, blast.Anchored = BrickColor.new("Really black"), true
            blast.CanCollide, blast.Locked = false, true
            blast.Size, blast.Transparency = Vector3.new(1,1,1), 0.9
            blast.TopSurface, blast.BottomSurface = "Smooth", "Smooth"
            blast.CFrame = RootPart.CFrame * CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)
            local bm = Instance.new("SpecialMesh", blast)
            bm.Scale, bm.MeshId = Vector3.new(5,1,5), "rbxassetid://3270017"

            local blast2 = blast:Clone(); blast2.Parent = rarm
            blast2.BrickColor = BrickColor.new("New Yeller")
            local bm2 = bm:Clone(); bm2.Parent = blast2; bm2.Scale = Vector3.new(3,1,3)

            local blast3 = blast:Clone(); blast3.Parent = rarm
            blast3.BrickColor = BrickColor.new("Institutional white")
            local bm3 = bm:Clone(); bm3.Parent = blast3; bm3.Scale = Vector3.new(3,1,3)

            for i = 1, 120 do
                RunService.RenderStepped:Wait()
                Core.Transparency = Core.Transparency + 1/120
                part.Transparency = part.Transparency + 1/120
                part2.Transparency = part2.Transparency + 1/120
                part3.Transparency = part3.Transparency + 1/120
                part4.Transparency = part4.Transparency + 1/120
                part5.Transparency = part5.Transparency + 1/120
                part6.Transparency = part6.Transparency + 1/120
                part7.Transparency = part7.Transparency + 1/120
                blast.Transparency  = blast.Transparency  + 1/120
                blast2.Transparency = blast2.Transparency + 1/120
                blast3.Transparency = blast3.Transparency + 1/120

                Core.Size = Core.Size + Vector3.new(0.8, 0.8, 0.8)
                msh.Scale  = msh.Scale  + Vector3.new(1, 0.2, 1)
                msh2.Scale = msh2.Scale + Vector3.new(1.1, 0.2, 1.1)
                m3.Scale   = m3.Scale   + Vector3.new(3, 3, 3)
                m4.Scale   = m4.Scale   + Vector3.new(1.7, 1.7, 1.7)
                msh5.Scale = msh5.Scale + Vector3.new(1.6, 0.2, 1.6)
                msh6.Scale = msh6.Scale + Vector3.new(2, 0.2, 2)
                m7.Scale   = m7.Scale   + Vector3.new(4, 4, 4)
                bm.Scale   = bm.Scale   + Vector3.new(6, 6, 0.2)
                bm2.Scale  = bm2.Scale  + Vector3.new(4, 4, 0.2)
                bm3.Scale  = bm3.Scale  + Vector3.new(4, 4, 0.2)

                Core.CFrame   = cf
                part.CFrame   = Core.CFrame * CFrame.Angles(0, math.rad(i*2), 0)
                part2.CFrame  = Core.CFrame * CFrame.Angles(0, math.rad(-i*2), 0)
                part3.CFrame  = Core.CFrame
                part4.CFrame  = Core.CFrame
                part7.CFrame  = Core.CFrame
                part5.CFrame  = Core.CFrame * CFrame.Angles(0, math.rad(i*2.6), 0)
                part6.CFrame  = Core.CFrame * CFrame.Angles(0, math.rad(-i*2.4), 0)
                blast.CFrame  = Core.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                blast2.CFrame = Core.CFrame * CFrame.Angles(math.rad(-i*4), math.rad(i*4), 0)
                blast3.CFrame = Core.CFrame * CFrame.Angles(math.rad(180 + i*4), math.rad(90 - i*4), 0)
            end
            for _, v in ipairs({Core, part, part2, part3, part4, part5, part6, part7, blast, blast2, blast3}) do
                if v then v:Destroy() end
            end
        end
    end)

    Debounces.CanAttack, Debounces.NoIdle = true, false
    hum.WalkSpeed = 30
end

-- ===== Orb Shield =====
function TruthSeekerOrbSheild()
    Debounces.CanAttack, Debounces.NoIdle = false, true
    Defence = true
    CurrentHealth = hum.Health
    torso.Anchored = true
    Shield = Instance.new("Part", Orbs)
    Shield.Shape, Shield.CanCollide, Shield.Anchored = "Ball", true, true
    Shield.Material, Shield.Name, Shield.Locked = "Neon", "Shield", true
    Shield.Transparency = 0.3
    Shield.BrickColor = BrickColor.new("Really black")
    Shield.Size = Vector3.new(10.1, 10.1, 10.1)
    Shield.CFrame = torso.CFrame

    local function onDamage(hit)
        if hit:FindFirstChild("Humanoid") == nil and (hit:FindFirstChild("BodyVelocity") or hit:FindFirstChild("RocketPropulsion")) then
            hit.Anchored = true
            local m = hit:FindFirstChildOfClass("SpecialMesh")
            if m then
                for _ = 1, 5 do
                    m.Scale = m.Scale + Vector3.new(1,1,1)
                    task.wait(0.05)
                end
            end
        end
    end

    local Checker = Instance.new("Part", char)
    Checker.Transparency, Checker.Shape = 0.99, "Ball"
    Checker.Material, Checker.BrickColor = "Neon", BrickColor.new("Institutional white")
    Checker.Anchored, Checker.Locked, Checker.CanCollide = false, true, false
    Checker.CFrame, Checker.Size = torso.CFrame, Vector3.new(20,20,20)
    newWeld(Checker, torso, 0, 0, 0)
    Checker.Touched:Connect(onDamage)

    local InnerShield = Instance.new("Part", Orbs)
    InnerShield.CanCollide, InnerShield.Anchored = true, true
    InnerShield.Material, InnerShield.Name, InnerShield.Shape = "Neon", "InnerShield", "Ball"
    InnerShield.Locked, InnerShield.BrickColor = true, BrickColor.new("Royal purple")
    InnerShield.Size = Vector3.new(10,10,10)
    InnerShield.CFrame = Shield.CFrame
    newWeld(InnerShield, Shield, 0, 0, 0)
    newWeld(Shield, torso, 0, 0, 0)

    task.spawn(function()
        while Defence do
            hum.Health = CurrentHealth
            hum.WalkSpeed = 0
            task.wait()
        end
    end)

    for _ = 1, 16 do
        for _, v in pairs(Orbs:GetChildren()) do
            if v:IsA("Part") and v.Name ~= "InnerShield" and v.Name ~= "Shield" then
                v.Transparency = v.Transparency + 0.1
            end
        end
        task.wait()
    end
end

function TruthSeekerOrbSheildUp()
    Defence = false
    Debounces.CanAttack, Debounces.NoIdle = true, false
    Shield.CanCollide, InnerShield.CanCollide = false, false
    for _ = 1, 16 do
        Shield.Transparency      = Shield.Transparency + 0.1
        InnerShield.Transparency = InnerShield.Transparency + 0.1
        task.wait()
    end
    Shield:Destroy(); Checker:Destroy(); InnerShield:Destroy()
    torso.Anchored = false
    hum.WalkSpeed = 30
    for _ = 1, 16 do
        for _, v in pairs(Orbs:GetChildren()) do
            if v:IsA("Part") then v.Transparency = v.Transparency - 0.1 end
        end
        task.wait()
    end
end

-- ===== Orb shoot =====
function TruthSeekerOrbAttack()
    local selected = math.random(1, 8)
    local Orb = Orbs_["Orb" .. selected]
    local Outline = Orb.Outline
    so("http://www.roblox.com/asset/?id=553462044", hed, 0.35, 1.4 + math.random()/5)
    if Debounces["OrbMove" .. selected] then return end
    Debounces["OrbMove" .. selected] = true
    for _ = 1, 12 do
        Orb.CFrame = Lerp(Outline.CFrame, Mau5.Hit, 0.3)
        task.wait()
    end
    Debounces["OrbMove" .. selected] = false
    task.wait(0.1)
end

-- ===== Orb of Discord / Healing =====
local origHealth = {}
local OrbOfHealingEquipped = false
local OrbOfDiscordEquipped = false
local Darkness = Instance.new("Sound", torso)
Darkness.SoundId, Darkness.Volume = "rbxassetid://418097747", 0.8
local Healing  = Instance.new("Sound", torso)
Healing.SoundId, Healing.Volume = "rbxassetid://418097928", 0.8
local angle, angle2, angle3 = 0, 0, 0

function OrbOfDiscord(Target)
    if Target.Parent:IsA("Accessory") then Target = Target.Parent end
    local tplr = Players:GetPlayerFromCharacter(Target)
    if tplr and tplr.TeamColor == p.TeamColor then return end
    if OrbOfDiscordEquipped == Target.Parent then return end
    if OrbOfHealingEquipped == Target.Parent then OrbOfHealingEquipped = false end
    if Target.Parent:FindFirstChild("ForceField") then OrbOfDiscordEquipped = false; return end

    OrbOfDiscordEquipped = Target.Parent
    local OD1, OD2 = MakeOrb(1)
    OD1.BrickColor, OD2.BrickColor = BrickColor.new("Royal purple"), BrickColor.new("Really black")
    OD1.Parent, OD2.Parent = Target.Parent, Target.Parent

    if not origHealth[Target.Parent] then
        origHealth[Target.Parent] = Target.Parent:FindFirstChild("Humanoid").MaxHealth
    end
    Darkness:Play()
    task.spawn(function()
        while task.wait(0.2) and OrbOfDiscordEquipped == Target.Parent do
            Target.Parent.Humanoid.MaxHealth = origHealth[Target.Parent] * 0.7
            if OrbOfDiscordEquipped == false or OrbOfDiscordEquipped ~= Target.Parent then break end
            local chars = {}
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") then table.insert(chars, v) end
            end
            local hit = workspace:FindPartOnRayWithIgnoreList(
                Ray.new(root.Position, Target.Parent.HumanoidRootPart.Position - root.Position),
                {char, table.unpack(chars)})
            if hit then
                OrbOfDiscordEquipped = false
                break
            end
        end
    end)

    while task.wait() and OrbOfDiscordEquipped == Target.Parent do
        OD1.CFrame = Lerp(OD1.CFrame, Target.Parent.Torso.CFrame * CFrame.new(3, 3 + math.sin(angle2) * 0.32, 2), 0.3)
        OD2.CFrame = Lerp(OD2.CFrame, Target.Parent.Torso.CFrame * CFrame.new(3, 3 + math.sin(angle2) * 0.32, 2), 0.3)
        if OrbOfDiscordEquipped == false then break end
    end

    local prevHealth = Target.Parent.Humanoid.Health
    Target.Parent.Humanoid.MaxHealth = origHealth[Target.Parent]
    Target.Parent.Humanoid.Health    = prevHealth / (origHealth[Target.Parent] * 0.7) * origHealth[Target.Parent]
    OD1:Destroy(); OD2:Destroy()
    if OrbOfDiscordEquipped == Target.Parent then OrbOfDiscordEquipped = false end
end

function OrbOfHealing(Target)
    if Target.Parent:IsA("Accessory") then Target = Target.Parent end
    local tplr = Players:GetPlayerFromCharacter(Target)
    if tplr and tplr.TeamColor ~= p.TeamColor then return end
    if OrbOfHealingEquipped == Target.Parent then return end
    if OrbOfDiscordEquipped == Target.Parent then OrbOfDiscordEquipped = false end
    if OrbOfHealingEquipped ~= false then OrbOfHealingEquipped = false; task.wait() end
    if Target.Parent:FindFirstChild("ForceField") then OrbOfHealingEquipped = false; return end

    OrbOfHealingEquipped = Target.Parent
    local OH1, OH2 = MakeOrb(1)
    OH1.BrickColor, OH2.BrickColor = BrickColor.new("New Yeller"), BrickColor.new("Institutional white")
    OH1.Parent, OH2.Parent = Target.Parent, Target.Parent
    Healing:Play()

    task.spawn(function()
        while task.wait(1) and OrbOfHealingEquipped == Target.Parent do
            Target.Parent.Humanoid.Health = Target.Parent.Humanoid.Health + 5
            if OrbOfHealingEquipped == false then break end
        end
    end)
    task.spawn(function()
        while task.wait(0.2) do
            local chars = {}
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") then table.insert(chars, v) end
            end
            local hit = workspace:FindPartOnRayWithIgnoreList(
                Ray.new(root.Position, Target.Parent.HumanoidRootPart.Position - root.Position),
                {char, table.unpack(chars)})
            if hit then OrbOfHealingEquipped = false; break end
        end
    end)

    while OrbOfHealingEquipped do
        OH1.CFrame = Lerp(OH1.CFrame, Target.Parent.Torso.CFrame * CFrame.new(3, 1.8 + math.sin(angle2) * 0.32, 2), 0.3)
        OH2.CFrame = Lerp(OH2.CFrame, Target.Parent.Torso.CFrame * CFrame.new(3, 1.8 + math.sin(angle2) * 0.32, 2), 0.3)
        if OrbOfHealingEquipped == false then break end
        task.wait()
    end
    OH1:Destroy(); OH2:Destroy()
    OrbOfHealingEquipped = false
end

-- ===== Input =====
local function poseStand()
    for i = 1, 5 do
        rarm.Weld.C0 = Lerp(rarm.Weld.C0, cn(1.5, 0.5 - 0.1*math.cos(i/7) + math.sin(i/7)/7, 0) * angles(0 - 0.1*math.cos(i/7), 0, 0) * angles(math.rad(math.random(60,90)), math.rad(math.random(-20,20)), math.rad(20)), 0.8)
        larm.Weld.C0 = Lerp(larm.Weld.C0, cn(-1.5, 0.5 - 0.1*math.cos(i/7) + math.sin(i/7)/7, 0) * angles(0 - 0.1*math.cos(i/7), 0, 0) * angles(0, 0, math.rad(50)), 0.8)
        hed.Weld.C0  = CFrame.new(0, 1.5, 0)
        lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-1.5, -1, -0.5) * angles(1.2 - 0.1*math.cos(i/7), 0, 1.3), 0.8)
        rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new( 1.5, -1, -0.5) * angles(1.3 - 0.1*math.cos(i/7), 0, -1.2), 0.8)
        torso.Weld.C0 = Lerp(torso.Weld.C0, cn(0, -1.5 - 0.1*math.cos(i/7), 0) * cn(0, 1 - 0.1*math.cos(i/7), 0) * angles(0, 0.5, 0), 0.8)
        task.wait()
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if DebounceShot == false and Debounces.NoIdle == false then
            Debounces.NoIdle = true
            poseStand()
            Debounces.NoIdle = false
            TruthSeekerOrbAttack()
        end
        return
    end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local k = input.KeyCode.Name:lower()
    if k == "g" then
        TailedBeastBombAttack()
    elseif k == "q" then
        SpawnRasenShurikan(workspace)
    elseif k == "e" then
        local Targ = Mau5.Target
        Debounces.NoIdle = true
        poseStand()
        Debounces.NoIdle = false
        if Targ and Targ.Parent and Targ.Parent:FindFirstChild("Humanoid") then
            OrbOfHealing(Targ.Parent:FindFirstChild("Torso") or Targ.Parent:FindFirstChild("UpperTorso"))
        end
        if Targ and Targ.Parent:IsA("Accessory") and Targ.Parent.Parent:FindFirstChild("Humanoid") then
            OrbOfHealing(Targ.Parent.Parent:FindFirstChild("Torso") or Targ.Parent.Parent:FindFirstChild("UpperTorso"))
        end
    elseif k == "f" then
        local Targ = Mau5.Target
        Debounces.NoIdle = true
        poseStand()
        Debounces.NoIdle = false
        if Targ and Targ.Parent and Targ.Parent:FindFirstChild("Humanoid") then
            OrbOfDiscord(Targ.Parent:FindFirstChild("Torso") or Targ.Parent:FindFirstChild("UpperTorso"))
        end
        if Targ and Targ.Parent:IsA("Accessory") and Targ.Parent.Parent:FindFirstChild("Humanoid") then
            OrbOfDiscord(Targ.Parent.Parent:FindFirstChild("Torso") or Targ.Parent.Parent:FindFirstChild("UpperTorso"))
        end
    end
end)

-- ===== State tracking (was broken FreeFalling:connect) =====
hum.StateChanged:Connect(function(_, new)
    ffing = (new == Enum.HumanoidStateType.Freefall)
    jumpn = (new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall)
end)

-- ===== Main loop =====
local sine = 0
local twirl = 0
local change = 1
angle, angle2, angle3 = 0, 0, 0
local anglespeed, anglespeed2, anglespeed3 = 2, 1, 0.4

RunService.RenderStepped:Connect(function()
    angle  = angle  % 100 + anglespeed  / 10
    angle2 = angle2 % 100 + anglespeed2 / 10
    angle3 = angle3 % 100 + anglespeed3 / 10

    if Debounces.Anger == false then
        if Debounces.OrbMove1 == false then Orb1.CFrame = Lerp(Orb1.CFrame, torso.CFrame * CFrame.new(0,  3 + math.sin(angle2) * 0.2,  2), 0.04) end
        if Debounces.OrbMove2 == false then Orb2.CFrame = Lerp(Orb2.CFrame, torso.CFrame * CFrame.new(0, -3 + math.sin(angle2) * 0.32, 2), 0.03) end
        if Debounces.OrbMove3 == false then Orb3.CFrame = Lerp(Orb3.CFrame, torso.CFrame * CFrame.new(3,  0 + math.sin(angle2) * 0.22, 2), 0.06) end
        if Debounces.OrbMove4 == false then Orb4.CFrame = Lerp(Orb4.CFrame, torso.CFrame * CFrame.new(-3, 0 + math.sin(angle2) * 0.12, 2), 0.08) end
        if Debounces.OrbMove5 == false then Orb5.CFrame = Lerp(Orb5.CFrame, torso.CFrame * CFrame.new(-2, -2 + math.sin(angle2) * 0.12, 2), 0.07) end
        if Debounces.OrbMove6 == false then Orb6.CFrame = Lerp(Orb6.CFrame, torso.CFrame * CFrame.new(-2,  2 + math.sin(angle2) * 0.12, 2), 0.4) end
        if Debounces.OrbMove7 == false then Orb7.CFrame = Lerp(Orb7.CFrame, torso.CFrame * CFrame.new(2,   2 + math.sin(angle2) * 0.12, 2), 0.2) end
        if Debounces.OrbMove8 == false then Orb8.CFrame = Lerp(Orb8.CFrame, torso.CFrame * CFrame.new(2,  -2 + math.sin(angle2) * 0.12, 2), 0.05) end
    else
        -- Orbit rotation when "Anger" is true
        local a6 = math.sin(angle/6); local b6 = math.tan(angle2/6); local c6 = math.cos(angle3/6)
        if Debounces.OrbMove1 == false then Orb1.CFrame = Lerp(Orb1.CFrame, torso.CFrame * CFrame.new(0,  3 + math.sin(angle2)*0.2,  2) * CFrame.new(a6, b6, c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.04) end
        if Debounces.OrbMove2 == false then Orb2.CFrame = Lerp(Orb2.CFrame, torso.CFrame * CFrame.new(0, -3 + math.sin(angle2)*0.32, 2) * CFrame.new(a6, b6, c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.03) end
        if Debounces.OrbMove3 == false then Orb3.CFrame = Lerp(Orb3.CFrame, torso.CFrame * CFrame.new(3,  0 + math.sin(angle2)*0.22, 2) * CFrame.new(math.tan(angle/6), math.sin(angle2/6), c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.06) end
        if Debounces.OrbMove4 == false then Orb4.CFrame = Lerp(Orb4.CFrame, torso.CFrame * CFrame.new(-3, 0 + math.sin(angle2)*0.12, 2) * CFrame.new(math.tan(angle/6), math.sin(angle2/6), c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.08) end
        if Debounces.OrbMove5 == false then Orb5.CFrame = Lerp(Orb5.CFrame, torso.CFrame * CFrame.new(-2, -2 + math.sin(angle2)*0.12, 2) * CFrame.new(math.tan(angle/6), -math.tan(angle2/6), c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.07) end
        if Debounces.OrbMove6 == false then Orb6.CFrame = Lerp(Orb6.CFrame, torso.CFrame * CFrame.new(-2,  2 + math.sin(angle2)*0.12, 2) * CFrame.new(math.tan(angle/6), math.tan(angle2/6), c6) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.4) end
        if Debounces.OrbMove7 == false then Orb7.CFrame = Lerp(Orb7.CFrame, torso.CFrame * CFrame.new(2,   2 + math.sin(angle2)*0.12, 2) * CFrame.new(math.cos(angle/6), math.tan(angle2/6), math.tan(angle3/6)) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.2) end
        if Debounces.OrbMove8 == false then Orb8.CFrame = Lerp(Orb8.CFrame, torso.CFrame * CFrame.new(2,  -2 + math.sin(angle2)*0.12, 2) * CFrame.new(math.cos(angle/6), -math.tan(angle2/6), math.tan(angle3/6)) * CFrame.Angles(a6, b6, math.floor(angle3/6)), 0.05) end
    end

    sine = sine + change
    local animpose
    if jumpn then animpose = "Jumping"
    elseif ffing then animpose = "Freefalling"
    elseif (torso.Velocity * Vector3.new(1, 0, 1)).magnitude < 2 then animpose = "Idle"
    elseif (torso.Velocity * Vector3.new(1, 0, 1)).magnitude < 20 then animpose = "Walking"
    else animpose = "Running" end

    if animpose ~= lastanimpose then sine = 0 end
    lastanimpose = animpose

    if Debounces.NoIdle == false then
        if animpose == "Idle" then
            change = 0.5
            rarm.Weld.C0 = Lerp(rarm.Weld.C0, cn( 1.5, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, 0) * angles(0 - 0.1*math.cos(sine/7), 0, 0) * angles(0, math.rad(180), math.rad(-30)), 0.2)
            larm.Weld.C0 = Lerp(larm.Weld.C0, cn(-1.5, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, 0) * angles(0 - 0.1*math.cos(sine/7), 0, 0) * angles(0, math.rad(180), math.rad(30)), 0.2)
            hed.Weld.C0  = CFrame.new(0, 1.5, 0)
            lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-1.5, -1, -0.5) * angles(1.2 - 0.1*math.cos(sine/7), 0, 1.3), 0.4)
            rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new( 1.5, -1, -0.5) * angles(1.3 - 0.1*math.cos(sine/7), 0, -1.2), 0.4)
            torso.Weld.C0 = Lerp(torso.Weld.C0, cn(0, -1.5 - 0.1*math.cos(sine/7), 0) * cn(0, 1 - 0.1*math.cos(sine/7), 0), 0.2)
        elseif animpose == "Walking" then
            change = 0.5
            rarm.Weld.C0 = Lerp(rarm.Weld.C0, cn( 1.5, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, 0) * angles(0 - 0.1*math.cos(sine/7), 0, 0) * angles(0, math.rad(180), math.rad(-30)), 0.2)
            larm.Weld.C0 = Lerp(larm.Weld.C0, cn(-1.5, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, 0) * angles(0 - 0.1*math.cos(sine/7), 0, 0) * angles(0, math.rad(180), math.rad(30)), 0.2)
            hed.Weld.C0  = CFrame.new(0, 1.5, 0)
            lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-1.5, -1, -0.5) * angles(1.2 - 0.1*math.cos(sine/7), 0, 1.3), 0.4)
            rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new( 1.5, -1, -0.5) * angles(1.3 - 0.1*math.cos(sine/7), 0, -1.2), 0.4)
            torso.Weld.C0 = Lerp(torso.Weld.C0, cn(0, -1.5 - 0.1*math.cos(sine/7), 0) * cn(0, 1 - 0.1*math.cos(sine/7), 0), 0.2)
        elseif animpose == "Running" then
            change = 0.5
            twirl += 1
            rarm.Weld.C0 = Lerp(rarm.Weld.C0, cn( 0.7, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, -0.5) * angles(1.2 - 0.1*math.cos(sine/7), 0, -1.3), 0.2)
            larm.Weld.C0 = Lerp(larm.Weld.C0, cn(-0.7, 0.5 - 0.1*math.cos(sine/7) + math.sin(sine/7)/7, -0.5) * angles(1.3 - 0.1*math.cos(sine/7), 0,  1.2), 0.2)
            hed.Weld.C0  = CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(10), 0.5, 0)
            lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(-30), 0, 0), 0.4)
            rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new( 0.5, -1, 0) * CFrame.Angles(math.rad(-30), 0, 0), 0.4)
            torso.Weld.C0 = Lerp(torso.Weld.C0, cn(0, -1.5 - 0.1*math.cos(sine/7), 0) * cn(0, 1 - 0.1*math.cos(sine/4), 0) * angles(math.rad(-90), 0, 0) * angles(0, sine/10, 0), 0.5)
        elseif animpose == "Freefalling" then
            change = 0.5
        end
    end
end)
