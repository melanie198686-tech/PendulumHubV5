--[[ Magic Unknown, fixed. By feyz. ]]--

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Debris            = game:GetService("Debris")
local UserInputService  = game:GetService("UserInputService")

Player      = Players.LocalPlayer
Character   = Player.Character or Player.CharacterAdded:Wait()
PlayerGui   = Player.PlayerGui
Backpack    = Player.Backpack

-- R6 guard
if not Character:FindFirstChild("Torso") then
    warn("[Magic Unknown] Requires R6 avatar. Set to R6 and re-execute.")
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

attack            = false
attackdebounce    = false
attackmode        = 'none'
attacktype        = 1
attacktype2       = 1
combo             = 0
stance            = false
noleg             = false
evadecooldown     = false
equip             = false
shooting          = false
trispeed          = 0.2
attackspeed       = 0.14
Swing             = 1
local idle  = 0
local Anim  = "Idle"
local ff    = 2
local sine  = 0
local change = 1
local val = 0
local speed = 0
local Effects = {}
local sine_ = sine

necko  = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
necko2 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

if Face then Face:Destroy() end

-- ===== Eyes =====
local function makeEye(xoff)
    local eye = Instance.new("Part")
    eye.Parent      = Character
    eye.Size        = Vector3.new(0.2, 0.2, 0.2)
    eye.Archivable  = true
    eye.Transparency = 0
    eye.CanCollide  = false
    eye.Material    = "Neon"
    eye.Color       = Color3.fromRGB(48, 0, 211)
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
music.Volume = 1
music.Pitch  = 1
music.SoundId = "rbxassetid://1849245030"
music.Looped = true
music:Play()

-- ===== Helpers =====
so = function(id, par, vol, pit)
    coroutine.resume(coroutine.create(function()
        local sou = Instance.new("Sound", par or workspace)
        sou.Volume   = vol
        sou.Pitch    = pit or 1
        sou.SoundId  = id
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

-- ===== Replace shoulders with welds =====
RSH = Torso["Right Shoulder"]
LSH = Torso["Left Shoulder"]
if RSH then RSH.Parent = nil end
if LSH then LSH.Parent = nil end

RW = Instance.new("Weld")
RW.Name  = "Right Shoulder"
RW.Part0 = Torso
RW.C0    = cf(1.5, 0.5, 0)
RW.C1    = cf(0, 0.5, 0)
RW.Part1 = RightArm
RW.Parent = Torso

LW = Instance.new("Weld")
LW.Name  = "Left Shoulder"
LW.Part0 = Torso
LW.C0    = cf(-1.5, 0.5, 0)
LW.C1    = cf(0, 0.5, 0)
LW.Part1 = LeftArm
LW.Parent = Torso

-- Remove hips so our welds take over (matches shoulder pattern)
if LH then LH.Parent = nil end
if RH then RH.Parent = nil end

local function newWeld(wp0, wp1, x, y, z)
    local w = Instance.new("Weld", wp1)
    w.Part0 = wp0
    w.Part1 = wp1
    w.C0    = CFrame.new(x, y, z)
    return w
end

newWeld(RootPart, Torso,    0,   -1, 0); Torso.Weld.C1    = CFrame.new(0, -1, 0)
newWeld(Torso,    LeftLeg, -0.5, -1, 0); LeftLeg.Weld.C1  = CFrame.new(0,  1, 0)
newWeld(Torso,    RightLeg, 0.5, -1, 0); RightLeg.Weld.C1 = CFrame.new(0,  1, 0)

function swait(num)
    if not num or num == 0 then
        RunService.Stepped:Wait()
    else
        for _ = 0, num do RunService.Stepped:Wait() end
    end
end

-- ===== part / mesh =====
part = function(formfactor, parent, reflectance, transparency, brickcolor, name, size)
    local fp = it("Part")
    fp.formFactor  = formfactor
    fp.Parent      = parent
    fp.Reflectance = reflectance
    fp.Transparency = transparency
    fp.CanCollide  = false
    fp.Locked      = true
    -- Accept either a string or a BrickColor
    if type(brickcolor) == "string" then
        fp.BrickColor = BrickColor.new(brickcolor)
    else
        fp.BrickColor = brickcolor
    end
    fp.Name   = name
    fp.Size   = size
    fp.Position = Torso.Position
    NoOutline(fp)
    if fp.BrickColor.Name == "Really black" then
        fp.Material = "Metal"
    else
        fp.Material = "Neon"
    end
    fp:BreakJoints()
    return fp
end

mesh = function(Mesh, par, meshtype, meshid, offset, scale)
    local m = it(Mesh)
    m.Parent = par
    if Mesh == "SpecialMesh" then
        m.MeshType = meshtype
        if meshid and meshid ~= "" and meshid ~= "nil" then
            if meshid:sub(1, 4) == "http" or meshid:sub(1, 9) == "rbxasset" then
                m.MeshId = meshid
            else
                m.MeshId = "http://www.roblox.com/asset/?id=" .. meshid
            end
        end
    end
    m.Offset = offset
    m.Scale  = scale
    return m
end

weld = function(parent, p0, p1, c0)
    local w = it("Weld")
    w.Parent = parent
    w.Part0  = p0
    w.Part1  = p1
    w.C0     = c0
    return w
end

F1 = Instance.new("Folder", Character); F1.Name = "Effects Folder"
F2 = Instance.new("Folder", F1);          F2.Name = "Effects"

-- ===== Effect primitives =====
MagicBlock = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
    local prt = part(3, workspace, 0, 0, bc, "Effect", vt())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = mesh("BlockMesh", prt, "", "", vt(), vt(x1, y1, z1))
    Debris:AddItem(prt, 10)
    if Type == 1 or Type == nil then
        table.insert(Effects, {prt, "Block1", delay, x3, y3, z3, msh})
    elseif Type == 2 then
        table.insert(Effects, {prt, "Block2", delay, x3, y3, z3, msh})
    elseif Type == 3 then
        table.insert(Effects, {prt, "Block3", delay, x3, y3, z3, msh,
            prt.CFrame * euler(math.random(-50,50), math.random(-50,50), math.random(-50,50)), 0})
    end
end

MagicCircle = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = part(3, workspace, 0, 0, bc, "Effect", vt())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = mesh("SpecialMesh", prt, "Sphere", nil, vt(), vt(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

-- Fixed: original referenced x2/y2/z2 which didn't exist.
MagicRing = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = part(3, workspace, 0, 0, bc, "Effect", vt(0.5, 0.5, 0.5))
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = mesh("SpecialMesh", prt, "FileMesh", "3270017", vt(), vt(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

MagicCylinder = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = part(3, workspace, 0, 0, bc, "Effect", vt())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = mesh("CylinderMesh", prt, "", "", vt(), vt(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

MagicWave = function(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = part(3, workspace, 0, 0, bc, "Effect", vt())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = mesh("SpecialMesh", prt, "FileMesh", "20329976", vt(), vt(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

function FindNearestTorso(Position, Distance, SinglePlayer)
    if SinglePlayer then
        return (SinglePlayer.Torso.CFrame.p - Position).magnitude < Distance
    end
    local List = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Torso") and v ~= Character then
            if (v.Torso.Position - Position).magnitude <= Distance then
                table.insert(List, v)
            end
        end
    end
    return List
end

function FindNearestHead(Position, Distance, SinglePlayer)
    if SinglePlayer then
        return Distance > (SinglePlayer.Torso.CFrame.p - Position).magnitude
    end
    local List = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Head") and v ~= Character
           and Distance >= (v.Head.Position - Position).magnitude then
            table.insert(List, v)
        end
    end
    return List
end

-- ===== clERP / quaternion math =====
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

local lerp = function(a, b, t) return a*(1-t) + b*t end

function weld5(p0, p1, c0, c1)
    local w = Instance.new("Weld", p0)
    w.Part0, w.Part1, w.C0, w.C1 = p0, p1, c0, c1
    return w
end

function rayCast(Pos, Dir, Max, Ignore)
    return workspace:FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or 999.999)), Ignore)
end

-- ===== CreatePart / CreateMesh (used by SphereEffect & WaveEffect) =====
function CreatePart(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
    local Part = Instance.new("Part")
    Part.Parent = Parent
    Part.Reflectance = Reflectance
    Part.Transparency = Transparency
    Part.CanCollide = false
    Part.Locked = true
    if type(BColor) == "string" then
        Part.BrickColor = BrickColor.new(BColor)
    else
        Part.BrickColor = BColor
    end
    Part.Name   = Name
    Part.Size   = Size
    Part.Material = Material
    NoOutline(Part)
    return Part
end

function CreateMesh(Mesh, Part, MeshType, MeshId, OffSet, Scale)
    local Msh = Instance.new(Mesh)
    Msh.Parent = Part
    Msh.Offset = OffSet
    Msh.Scale  = Scale
    if Mesh == "SpecialMesh" then
        Msh.MeshType = MeshType
        if MeshId and MeshId ~= "" then Msh.MeshId = MeshId end
    end
    return Msh
end

function SphereEffect(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = CreatePart(workspace, "Neon", 0, 0, bc, "Effect", Vector3.new())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = CreateMesh("SpecialMesh", prt, "Sphere", "", Vector3.new(), Vector3.new(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

function WaveEffect(bc, cframe, x1, y1, z1, x3, y3, z3, delay)
    local prt = CreatePart(workspace, "Neon", 0, 0, bc, "Effect", Vector3.new())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = CreateMesh("SpecialMesh", prt, "FileMesh", "rbxassetid://20329976", Vector3.new(), Vector3.new(x1, y1, z1))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
end

-- ===== Projectile =====
function Bullets(thinggy, place, size, color, velocity, damage, bounce, collide)
    swait()
    local Bullet = Instance.new("Part", workspace)
    Bullet.Locked       = true
    Bullet.Name         = "Bullet"
    Bullet.Anchored     = bounce
    Bullet.CanCollide   = collide
    Bullet.Transparency = 0.24
    Bullet.Reflectance  = 0
    Bullet.BottomSurface = 0
    Bullet.TopSurface    = 0
    Bullet.Shape        = 0
    Bullet.BrickColor   = BrickColor.new(color)
    Bullet.Size         = Vector3.new(size, size, size)
    Bullet.Material     = "Neon"
    Bullet.Orientation  = vt(-90, 0, 0)

    local Bulletthing = Instance.new("SpecialMesh", Bullet)
    Bulletthing.MeshType = "Sphere"

    local Bulletforce = Instance.new("BodyForce", Bullet)
    Bulletforce.force = Vector3.new(0, Bullet:GetMass() * 166.2, 0)

    Bullet.CFrame = thinggy.CFrame * CFrame.new(
        math.random(-place, place),
        math.random(-place, place),
        math.random(-place, place))

    local bv = Instance.new("BodyVelocity", Bullet)
    bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)
    Bullet.CFrame = CFrame.new(Bullet.Position, mouse.Hit.p)
    bv.velocity = Bullet.CFrame.lookVector * velocity

    Bullet.Touched:Connect(function(hit)
        if hit.Parent ~= Character and hit.Parent.Parent ~= Character
           and hit.Name ~= "prt" and hit.Name ~= "Effect" and hit.Name ~= "orb"
           and Bullet.Anchored == false then
            Bullet.Anchored = true
            Bullet.Transparency = 1
            Debris:AddItem(Bullet, 4)

            local Explode = Instance.new("Explosion")
            Explode.Position      = Bullet.Position
            Explode.Parent        = workspace
            Explode.BlastPressure = 0
            Explode.BlastRadius   = Bullet.Size.X * 5.6
            Explode.Visible       = false

            Explode.Hit:Connect(function(h)
                local hum = h.Parent and h.Parent:FindFirstChildOfClass("Humanoid")
                if hum and h.Parent ~= Character then
                    if hum.MaxHealth > 500 then
                        hum.MaxHealth = 100
                        hum.Health    = 100
                    end
                    -- Original passed 0; preserved as visual-only
                    if attackdebounce == false then
                        attackdebounce = true
                        hum:TakeDamage(0)
                        task.wait(0.02)
                        attackdebounce = false
                    end
                end
            end)

            coroutine.resume(coroutine.create(function()
                MagicCircle(BrickColor.new("Royal purple"), cf(Bullet.Position), 10, 10, 10, 50, 50, 50, 0.065)
                MagicCircle(BrickColor.new("Royal purple"), cf(Bullet.Position), 0, 1, 0, 15, 0, 15, 0.025)
                MagicRing(BrickColor.new("Royal purple"), cf(Bullet.Position) * euler(math.random(-50,50), math.random(-50,50), math.random(-50,50)), 0, 0, 4, 4, 4, 0, 0.025)
                MagicRing(BrickColor.new("Royal purple"), cf(Bullet.Position) * euler(math.random(-50,50), math.random(-50,50), math.random(-50,50)), 0, 0, 0.5, -1, -1, 0, 0.025)
            end))
        end
    end)

    coroutine.resume(coroutine.create(function()
        for _ = 0, 16, 0.1 do swait() end
        if Bullet.Anchored == false and Bullet.Parent then
            Bullet:Destroy()
        end
    end))
end

-- ===== Dash =====
local bl = Instance.new("BlurEffect", workspace.CurrentCamera)
bl.Size = 0

function Dash()
    evadecooldown = true
    attack = true
    so("http://www.roblox.com/asset/?id=231917788", Torso, 1, 1)
    bl.Size = 84

    MagicCircle(BrickColor.new("White"),        cf(RootPart.Position), 800, 5, 800,  0,   0,   0,   0.05)
    MagicCircle(BrickColor.new("Royal purple"), cf(RootPart.Position), 800, 10, 800, -40, 0,  -40,  0.025)
    MagicCircle(BrickColor.new("White"),        cf(RootPart.Position), 800, 10, 800, -42, 1000, -42, 0.05)
    MagicCircle(BrickColor.new("Royal purple"), cf(RootPart.Position), 1000, 10, 1000, -62, 1200, -62, 0.05)

    RootPart.CFrame   = RootPart.CFrame * CFrame.new(0, 0, -96)
    RootPart.Velocity = RootPart.CFrame.lookVector * 280

    for _, v in pairs(FindNearestHead(Torso.CFrame.p, 52.5)) do
        if v:FindFirstChild("Torso") and v:FindFirstChild("Humanoid") then
            so("http://www.roblox.com/asset/?id=138186576", v.Torso, 10, 1)
            v:FindFirstChild("Humanoid"):TakeDamage(0)
            SphereEffect(BrickColor.new("Royal purple"), cf(v.Torso.Position), 1, 1, 1, 6.8, 6.8, 6.8, 0.04)
            MagicBlock(BrickColor.new("White"),        cf(v.Torso.Position), 2000, 2000, 2000, -100, -100, -100, 0.05, 1)
            MagicBlock(BrickColor.new("Royal purple"), cf(v.Torso.Position), 2500, 2500, 2500, -150, -150, -150, 0.05, 1)
            MagicBlock(BrickColor.new("White"),        cf(v.Torso.Position), 3000, 3000, 3000, -200, -200, -200, 0.05, 1)
            MagicCircle(BrickColor.new("Royal purple"), cf(v.Torso.Position), 800, 2, 800, 150, 2, 150, 0.05)
            MagicCircle(BrickColor.new("White"),        cf(v.Torso.Position), 800, 2, 800, 100, 4, 100, 0.05)
            MagicCircle(BrickColor.new("Royal purple"), cf(v.Torso.Position), 800, 2, 800,  50, 6,  50, 0.05)
            MagicCircle(BrickColor.new("White"),        cf(v.Torso.Position),   0, 0,   0, 100, 100, 100, 0.05)
            MagicCircle(BrickColor.new("Royal purple"), cf(v.Torso.Position),   0, 0,   0, 200, 200, 200, 0.05)
            MagicCircle(BrickColor.new("White"),        cf(v.Torso.Position),   0, 0,   0, 300, 300, 300, 0.05)
            MagicCircle(BrickColor.new("Royal purple"), cf(v.Torso.Position),   0, 0,   0, 400, 400, 400, 0.05)
            MagicCircle(BrickColor.new("White"),        cf(v.Torso.Position), 800, 2, 800,   4, 350,   4, 0.005)
            MagicCircle(BrickColor.new("Royal purple"), cf(v.Torso.Position), 600, 2, 600,   4, 300,   4, 0.005)
            MagicCircle(BrickColor.new("White"),        cf(v.Torso.Position), 400, 2, 400,   4, 250,   4, 0.005)
        end
    end

    local cam = workspace.CurrentCamera
    for _ = 0, 1, 0.064 do
        swait()
        cam.FieldOfView        = lerp(cam.FieldOfView, 110, 0.5)
        Humanoid.CameraOffset  = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 12), 0.24)
        RootPart.Velocity      = RootPart.CFrame.lookVector * 175
        bl.Size                = bl.Size - 8.5
        SphereEffect(BrickColor.new("Royal purple"),
            RootPart.CFrame * angles(math.random(-50,50), math.random(-50,50), math.random(-50,50)),
            1, 5, 1, 5.5, 10, 5.5, 0.03)
        Torso.Weld.C0     = clerp(Torso.Weld.C0,     CFrame.new(0, -1, -12) * CFrame.Angles(math.rad(-40), 0, 0), 0.4)
        Torso.Neck.C0     = clerp(Torso.Neck.C0,     necko * angles(math.rad(-30), 0, 0), .4)
        RW.C0             = clerp(RW.C0,             CFrame.new(1.5,  0.5, 0) * angles(math.rad(-20), 0,  math.rad(30)), .4)
        LW.C0             = clerp(LW.C0,             CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), 0, -math.rad(30)), .4)
        LeftLeg.Weld.C0   = clerp(LeftLeg.Weld.C0,   CFrame.new(-0.5, -1,   -0.4) * CFrame.Angles(math.rad(-40), 0, 0), 0.8)
        RightLeg.Weld.C0  = clerp(RightLeg.Weld.C0,  CFrame.new( 0.5, -0.7, -0.7) * CFrame.Angles(math.rad(-60), 0, 0), 0.8)
    end

    attack = false
    attackdebounce = false
    Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.1)
    task.wait(0.2)
    bl.Size = 0
    evadecooldown = false
end

-- ===== Shoot =====
function shoot()
    attack = true
    shooting = true

    local thing = Instance.new("BodyGyro", RootPart)
    thing.D = 50
    thing.P = 6000
    thing.MaxTorque = vt(100000, math.huge, 0)
    thing.CFrame = CFrame.new(RootPart.Position, mouse.Hit.p)

    for _ = 0, 2, 0.16 do
        swait()
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(0, math.rad(90), 0), 0.2)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(0, 0, math.rad(-80)), .2)
        RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(90), 0, math.rad(90)), .2)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), 0, math.rad(-30)), .2)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.73, -1.0, 0) * CFrame.Angles(math.rad(-25), math.rad(-66), math.rad(-25)), 0.1)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.6, -1.0, 0) * CFrame.Angles(0, math.rad(-83), 0), 0.1)
    end

    while shooting == true do
        swait(1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(90), 0, math.rad(90)), .2)
        so("http://roblox.com/asset/?id=200633327", Torso, 2, 1)
        thing.CFrame = CFrame.new(RootPart.Position, mouse.Hit.p)
        Torso.Velocity = RootPart.CFrame.lookVector * -13
        Bullets(RightArm, 0, 1.5, "Royal purple", 700, 25.5, false, false)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(80), math.rad(40), math.rad(80)), .2)
        coroutine.resume(coroutine.create(function()
            for _ = 0, 0.5, 0.1 do
                swait()
                Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(
                    Vector3.new(math.random(-0.99, 0.99), math.random(-0.99, 0.99), math.random(-0.99, 0.99)), 0.24)
            end
        end))
    end
    attack = false
    thing:Destroy()
end

-- ===== Dual shoot =====
function dshoot()
    attack = true
    shooting = true

    local thing = Instance.new("BodyGyro", RootPart)
    thing.D = 50
    thing.P = 6000
    thing.MaxTorque = vt(100000, math.huge, 0)
    thing.CFrame = CFrame.new(RootPart.Position, mouse.Hit.p)
    so("http://roblox.com/asset/?id=1268159756", Torso, 5, 1)

    for _ = 0, 3, 0.16 do
        swait()
        MagicRing(BrickColor.new("Royal purple"), RootPart.CFrame * CFrame.new(0, 0, -8), 9, 9, 1, -0.7, -0.7, 0, 0.07)
        MagicCircle(BrickColor.new("Royal purple"), RootPart.CFrame * CFrame.new(0, 0, -8), 9, 9, 9, -0.7, -0.7, -0.7, 0.07)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, 0), 0.2)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(0, 0, 0), .2)
        RW.C0            = clerp(RW.C0, CFrame.new(1.3, 0.5, -0.4) * angles(math.rad(90), 0, math.rad(-20)), .2)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.4) * angles(math.rad(90), 0, math.rad(20)), .2)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1.0, 0) * CFrame.Angles(math.rad(25), 0, math.rad(-25)), 0.1)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.0, 0) * CFrame.Angles(math.rad(25), 0, math.rad(25)), 0.1)
    end

    while shooting == true do
        swait(0.5)
        coroutine.resume(coroutine.create(function()
            MagicRing(BrickColor.new("Royal purple"), RootPart.CFrame * CFrame.new(0, 0, -8), 3, 3, 1, 10.2, 10.2, 0, 0.07)
        end))
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1.0, 0) * CFrame.Angles(math.rad(25), 0, math.rad(-25)), 0.3)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.0, 0) * CFrame.Angles(math.rad(25), 0, math.rad(25)), 0.3)
        so("http://roblox.com/asset/?id=200633327", Torso, 2, 1)
        thing.CFrame = CFrame.new(RootPart.Position, mouse.Hit.p)
        Torso.Velocity = RootPart.CFrame.lookVector * -63

        Torso.Weld.C0 = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(0, math.rad(-30), 0), 0.4)
        Bullets(RightArm, 0, 2.5, "Royal purple", 1200, 45.5, false, false)
        coroutine.resume(coroutine.create(function()
            for _ = 0, 0.5, 0.1 do
                swait()
                Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(
                    Vector3.new(math.random(-2.64, 2.64), math.random(-2.64, 2.64), math.random(-2.64, 2.64)), 0.44)
            end
        end))

        Torso.Weld.C0 = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(0, math.rad(30), 0), 0.2)
        Bullets(LeftArm, 0, 2.5, "Royal purple", 1200, 45.5, false, false)
        coroutine.resume(coroutine.create(function()
            for _ = 0, 0.5, 0.1 do
                swait()
                Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(
                    Vector3.new(math.random(-0.99, 0.99), math.random(-0.99, 0.99), math.random(-0.99, 0.99)), 0.24)
            end
        end))
    end
    attack = false
    thing:Destroy()
end

-- ===== Final Devastator =====
function finaldev()
    attack = true
    so("http://roblox.com/asset/?id=815032096", Head, 6, 0.84)
    so("http://roblox.com/asset/?id=200633529", workspace, 3, 0.84)

    for i = 0, 14, 0.1 do
        swait()
        WaveEffect(BrickColor.new("White"),        RootPart.CFrame * CFrame.new(0, -1, 0) * angles(0, math.rad(90*i), 0),  1, 1, 1, 7, 0.8, 7, 0.09)
        WaveEffect(BrickColor.new("Royal purple"), RootPart.CFrame * CFrame.new(0, -1, 0) * angles(0, math.rad(-90*i), 0), 1, 1, 1, 5, 0.8, 5, 0.05)
        Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(
            Vector3.new(math.random(-0.7, 0.7), math.random(-0.7, 0.7), math.random(-0.7, 0.7)), 0.16)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(-16), 0, 0), 0.15)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(14), 0, 0), .15)
        RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(0, 0, math.rad(87)), .15)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, math.rad(-87)), .15)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, 0, -0.5) * CFrame.Angles(math.rad(16), 0, 0), 0.15)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.14, 0.2) * CFrame.Angles(math.rad(-17), 0, 0), 0.15)
    end

    so("http://roblox.com/asset/?id=197161452", Torso, 7, 1)
    for i = 0, 6, 0.1 do
        swait()
        WaveEffect(BrickColor.new("White"),        RootPart.CFrame * CFrame.new(0, -1, 0) * angles(0, math.rad(90*i), 0),  1, 1, 1, 7, 0.8, 7, 0.09)
        WaveEffect(BrickColor.new("Royal purple"), RootPart.CFrame * CFrame.new(0, -1, 0) * angles(0, math.rad(-90*i), 0), 1, 1, 1, 5, 0.8, 5, 0.05)
        Head.Velocity = Vector3.new(0, 320, 0)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(260*i), 0, 0), 0.6)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(70), 0, 0), .1)
        RW.C0            = clerp(RW.C0, CFrame.new(.7, -0.22, -0.5) * angles(math.rad(90), 0, math.rad(-90)), 0.1)
        LW.C0            = clerp(LW.C0, CFrame.new(-.7, -0.22, -0.5) * angles(math.rad(90), 0, math.rad(90)), 0.1)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -.34, -0.7) * CFrame.Angles(math.rad(-25), 0, 0), 0.1)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -.34, -0.7) * CFrame.Angles(math.rad(-25), 0, 0), 0.1)
    end

    local bel = part(3, Character, 0, 1, BrickColor.new("Royal purple"), "Ball", vt(0.126, 0.126, 0.126))
    local belmsh = mesh("SpecialMesh", bel, "Sphere", "nil", vt(), vt(10, 10, 10))

    local Charge = Instance.new("Sound", bel)
    Charge.Volume = 10
    Charge.SoundId = "http://roblox.com/asset/?id=244578827"
    Charge.Pitch = 0.8
    Charge:Play()

    bel.Anchored = true
    for i = 0, 47, 0.1 do
        swait()
        bel.CFrame       = RootPart.CFrame * cf(0, 90*i/3.5, 0)
        bel.Transparency = bel.Transparency - 0.0034
        belmsh.Scale     = belmsh.Scale + Vector3.new(24, 24, 24)
        Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 1*i, 1*i), 0.15)
        workspace.CurrentCamera.FieldOfView = lerp(workspace.CurrentCamera.FieldOfView, 40 + 1*i, 0.15)
        Head.Velocity = Vector3.new(0, 2.4 + 0.8*i, 0)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(35), 0, 0), 0.2)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(-13), 0, 0), .2)
        RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.7, 0) * angles(0, 0, math.rad(140)), .2)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.7, 0) * angles(0, 0, math.rad(-140)), .2)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1.0, 0) * CFrame.Angles(math.rad(-45), math.rad(34), math.rad(-25)), 0.1)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.0, 0) * CFrame.Angles(math.rad(-45), math.rad(-34), math.rad(25)), 0.1)
    end

    so("http://roblox.com/asset/?id=160212892", Head, 10, 0.84)
    for _ = 0, 4, 0.1 do
        swait()
        Head.Velocity = Vector3.new(0, 2.4, 0)
        Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.15)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(35), 0, 0), 0.2)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(13), 0, 0), .2)
        RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.7, 0) * angles(0, 0, math.rad(140)), .2)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.7, 0) * angles(0, 0, math.rad(-140)), .2)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1.0, 0) * CFrame.Angles(math.rad(-45), math.rad(34), math.rad(-25)), 0.1)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.0, 0) * CFrame.Angles(math.rad(-45), math.rad(-34), math.rad(25)), 0.1)
    end

    bel.Anchored = false
    local bv = Instance.new("BodyVelocity", bel)
    bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)
    bel.CFrame  = CFrame.new(bel.Position, mouse.Hit.p)
    bv.velocity = bel.CFrame.lookVector * 350

    local con5 = bel.Touched:Connect(function()
        bel.Anchored = true
        bel.Transparency = 1
        Debris:AddItem(bel, 5.2)

        coroutine.resume(coroutine.create(function()
            so("http://www.roblox.com/asset/?id=167115397", workspace, 6, 1)
            so("http://www.roblox.com/asset/?id=138186576", workspace, 6, 1)
            for _ = 0, 0.4, 0.1 do
                swait()
                for _, v in pairs(FindNearestHead(bel.CFrame.p, 252.5)) do
                    if v:FindFirstChild("Torso") and v:FindFirstChild("Humanoid") then
                        local h = v:FindFirstChildOfClass("Humanoid")
                        if h.MaxHealth > 500 then
                            h.MaxHealth = 100
                            h.Health    = 100
                        end
                        h:TakeDamage(0)
                        coroutine.resume(coroutine.create(function()
                            for _ = 0, 2, 0.1 do
                                swait()
                                v.Head.Velocity = -v.Head.CFrame.lookVector * 660 + Vector3.new(0, 684, 0)
                            end
                        end))
                    end
                end
                coroutine.resume(coroutine.create(function()
                    for _ = 0, 2.4, 0.1 do
                        swait()
                        Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(
                            Vector3.new(math.random(-2.64, 2.64), math.random(-2.64, 2.64), math.random(-2.64, 2.64)), 0.44)
                    end
                end))
                MagicBlock(BrickColor.new("White"),        cf(bel.Position), 2000, 2000, 2000, -100, -100, -100, 0.05, 1)
                MagicBlock(BrickColor.new("Royal purple"), cf(bel.Position), 2500, 2500, 2500, -150, -150, -150, 0.05, 1)
                MagicBlock(BrickColor.new("White"),        cf(bel.Position), 3000, 3000, 3000, -200, -200, -200, 0.05, 1)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position), 1800, 222, 1800, 1150, 222, 1150, 0.05)
                MagicCircle(BrickColor.new("White"),        cf(bel.Position), 1800, 222, 1800, 1100, 224, 1100, 0.05)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position), 1800, 222, 1800,  150, 216,  150, 0.05)
                MagicCircle(BrickColor.new("White"),        cf(bel.Position),    0,   0,    0, 1100, 4100, 1100, 0.05)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position),    0,   0,    0, 1200, 1200, 1200, 0.05)
                MagicCircle(BrickColor.new("White"),        cf(bel.Position),    0,   0,    0, 1300, 1300, 1300, 0.05)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position),    0,   0,    0, 1400, 1400, 1400, 0.05)
                MagicCircle(BrickColor.new("White"),        cf(bel.Position), 4800, 222, 1800,  224, 1350,  224, 0.005)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position), 1600, 222, 1600,  224, 1300,  224, 0.005)
                MagicCircle(BrickColor.new("White"),        cf(bel.Position), 1400, 222, 1400,  224, 1250,  224, 0.005)
                WaveEffect(BrickColor.new("White"),        cf(bel.Position) * angles(0, math.rad(90*_),  0), 1, 1, 1, 24, 5.4, 24, 0.09)
                WaveEffect(BrickColor.new("Royal purple"), cf(bel.Position) * angles(0, math.rad(-90*_), 0), 1, 1, 1, 22, 4.8, 22, 0.05)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position), 10, 10, 10, 50, 50, 50, 0.065)
                MagicCircle(BrickColor.new("Royal purple"), cf(bel.Position), 0, 1, 0, 15, 0, 15, 0.025)
                MagicRing(BrickColor.new("White"),        cf(bel.Position) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 24, 24, 1, 12, 12, 0, 0.015)
                MagicRing(BrickColor.new("Royal purple"), cf(bel.Position) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 24, 24, 1, 12, 12, 0, 0.015)
                MagicRing(BrickColor.new("White"),        cf(bel.Position) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 24, 24, 1, 8, 8, 0, 0.015)
                MagicRing(BrickColor.new("Royal purple"), cf(bel.Position) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 24, 24, 1, 12, 12, 0, 0.015)
            end
        end))
    end)

    for _ = 0, 32, 0.1 do
        swait()
        Head.Velocity = Vector3.new(0, 2.4, 0)
        Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-35), 0, 0), 0.2)
        Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(43), 0, 0), .2)
        RW.C0            = clerp(RW.C0, CFrame.new(1.0, 0.5, -0.4) * angles(math.rad(80), math.rad(12), math.rad(-30)), .2)
        LW.C0            = clerp(LW.C0, CFrame.new(-1.0, 0.5, -0.4) * angles(math.rad(80), math.rad(-12), math.rad(30)), .2)
        LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1.0, 0) * CFrame.Angles(math.rad(75), math.rad(34), math.rad(-35)), 0.2)
        RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1.0, 0) * CFrame.Angles(math.rad(75), math.rad(-34), math.rad(35)), 0.2)
    end

    coroutine.resume(coroutine.create(function()
        for _ = 0, 63, 0.1 do swait() end
        if bel.Anchored == false and bel.Parent then bel:Destroy() end
    end))
    attack = false
end

-- ===== Keybinds (UserInputService) =====
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if attack == false then shoot() end
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name:lower()
        if key == 'e' and attack == false then dshoot()   end
        if key == 'q' and attack == false then finaldev() end
        if key == 'f' and attack == false and evadecooldown == false then Dash() end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if shooting == true then shooting = false end
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name:lower() == 'e' and shooting == true then
            shooting = false
        end
    end
end)

-- ===== Hand orbs =====
local orb  = part(3, Character, 0, 0.9, BrickColor.new("White"), "Effect", vt())
mesh("SpecialMesh", orb, "Sphere", nil, vt(), vt(15, 15, 15))

local orb2 = part(3, Character, 0, 0.9, BrickColor.new("White"), "Effect", vt())
mesh("SpecialMesh", orb2, "Sphere", nil, vt(), vt(15, 15, 15))

orb.Anchored  = true
orb2.Anchored = true
Humanoid.WalkSpeed = 30

-- ===== Render loop for orbs =====
local f = 0
RunService:BindToRenderStep("MagicOrbs", 0, function()
    f = f + 1
    workspace.CurrentCamera.FieldOfView = lerp(workspace.CurrentCamera.FieldOfView, 70, 0.076)
    if f >= 6 then
        f = 0
        SphereEffect(BrickColor.new("Royal purple"), cf(orb.Position)  * angles(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 1, 5, 1, .05, 4, .05, 0.03)
        SphereEffect(BrickColor.new("Royal purple"), cf(orb2.Position) * angles(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 1, 5, 1, .05, 4, .05, 0.03)
        MagicRing(BrickColor.new("Royal purple"), cf(orb.Position)  * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 3, 3, 1, -0.2, -0.2, 0, 0.07)
        MagicCircle(BrickColor.new("Royal purple"), cf(orb.Position), 0, 0, 0, 1.25, 1.25, 1.25, 0.05)
        MagicRing(BrickColor.new("Royal purple"), cf(orb2.Position) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)), 3, 3, 1, -0.2, -0.2, 0, 0.07)
        MagicCircle(BrickColor.new("Royal purple"), cf(orb2.Position), 0, 0, 0, 1.25, 1.25, 1.25, 0.05)
        MagicBlock(BrickColor.new("Royal purple"),
            cf(orb.Position) * cf(math.random(-2,2), math.random(-2,2), math.random(-2,2)) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)),
            1, 1, 1, 1, 1, 1, 0.1, 2)
        MagicBlock(BrickColor.new("Royal purple"),
            cf(orb2.Position) * cf(math.random(-2,2), math.random(-2,2), math.random(-2,2)) * euler(math.random(-360,360), math.random(-360,360), math.random(-360,360)),
            1, 1, 1, 1, 1, 1, 0.1, 2)
    end
end)

Humanoid.MaxHealth = 400

print("Move list")
print("---------")
print("F: Time Dash")
print("Hold Click: Lesser Bullets")
print("Hold E: Mega Bullets")
print("Q: Final Devastator")

-- ===== Main animation loop =====
while true do
    swait()
    sine = sine + change
    local torvel = (RootPart.Velocity * Vector3.new(1, 0, 1)).magnitude
    local hitfloor = rayCast(RootPart.Position,
        CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)
    local TiltVelocity = CFrame.new(RootPart.CFrame:vectorToObjectSpace(RootPart.Velocity))

    if attack == false then idle = idle + 1 else idle = 0 end

    Humanoid.Health = Humanoid.Health + 4

    orb.CFrame  = RightArm.CFrame * cf(0, -1, 0)
    orb2.CFrame = LeftArm.CFrame * cf(0, -1, 0)

    if RootPart.Velocity.y > 1 and hitfloor == nil then
        Anim = "Jump"
        if attack == false then
            change = 1
            Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.15)
            Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(4), 0, 0), 0.07)
            Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(-10 + 2.05*math.cos(sine/5)), 0, 0), 0.07)
            RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-20 + 2.05*math.cos(sine/5)), math.rad(-10), math.rad(50 - 2.05*math.cos(sine/5))), 0.07)
            LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20 + 2.05*math.cos(sine/5)), math.rad(-10), math.rad(-50 + 2.05*math.cos(sine/5))), 0.07)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1, -0.6) * CFrame.Angles(math.rad(-25 + 3.05*math.cos(sine/5)), math.rad(-3), 0), 0.1)
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -0.47, -0.7) * CFrame.Angles(math.rad(-12 + 3.05*math.cos(sine/5)), 0, 0), 0.1)
        end
    elseif RootPart.Velocity.y < -1 and hitfloor == nil then
        Anim = "Fall"
        change = 1
        if attack == false then
            Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.15)
            Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1, 0.2) * CFrame.Angles(math.rad(7 + 4*math.sin(sine/1.3)), 0, 0), 0.07)
            RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.65, 0) * angles(0, 0, math.rad(140 + 12*math.cos(sine/1.3))), 0.07)
            LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.65, 0) * angles(0, 0, math.rad(-140 + 12*math.cos(sine/1.3))), 0.07)
            Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(40 + 7*math.sin(sine/1.3)), 0, 0), 0.07)
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 + 0.17*math.cos(sine/1.3), -0.13) * CFrame.Angles(math.rad(18 + 7*math.cos(sine/1.3)), math.rad(3), 0), 0.1)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -0.37 + 0.17*math.cos(sine/1.3), -0.2) * CFrame.Angles(math.rad(32 + 7*math.cos(sine/1.3)), 0, 0), 0.1)
        end
    elseif torvel < 1 and hitfloor ~= nil then
        Anim = "Idle"
        change = 1
        if attack == false and equip == false then
            Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.15)
            orb.CFrame  = orb.CFrame:lerp(RightArm.CFrame * cf(0 + 2*math.cos(sine/40), -5 + 2*math.sin(sine/40), 0), 0.1)
            orb2.CFrame = orb2.CFrame:lerp(LeftArm.CFrame * cf(0 - 2*math.cos(sine/40), -5 + 2*math.sin(sine/40), 0), 0.1)
            Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1 - 0.04*math.cos(sine/40), 0) * CFrame.Angles(0, math.rad(-70), 0), 0.25)
            Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(10 + 2.6*math.sin(sine/40)), 0, math.rad(60)), 0.25)
            RW.C0            = clerp(RW.C0, CFrame.new(1.2, 0.55 + 0.04*math.sin(sine/40), 0.2) * angles(math.rad(-32 + 1.3*math.cos(sine/40)), math.rad(0 + 4*math.sin(sine/40)), math.rad(-22.3 + 2.2*math.cos(sine/40))), 0.25)
            LW.C0            = clerp(LW.C0, CFrame.new(-1.3, 0.55 + 0.04*math.sin(sine/40), -0.3 - 0.04*math.cos(sine/40)) * angles(math.rad(28 + 1.3*math.cos(sine/40)), math.rad(0 - 4*math.sin(sine/40)), math.rad(26.3 - 2.2*math.cos(sine/40))), 0.25)
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 + 0.04*math.cos(sine/40), 0) * CFrame.Angles(0, math.rad(8), math.rad(-7)), 0.25)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.57, -1 + 0.04*math.cos(sine/40), 0) * CFrame.Angles(0, math.rad(-2), math.rad(3)), 0.25)
        end
    elseif torvel > 1.5 and torvel < 22 and hitfloor ~= nil then
        Anim = "Walk"
        change = 0.84
        if attack == false and equip == false then
            Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.02)
            Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1 + 0.14*math.cos(sine/5), -0.3) * angles(math.rad(-2)*-math.rad(TiltVelocity.z)*9.5, math.rad(0 + 2*math.cos(sine/10)), math.rad(8)*-math.rad(TiltVelocity.x)*7.5 + RootPart.RotVelocity.Y/46), 0.08)
            Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(4 - 3*math.sin(sine/5)), 0, math.rad(2) + RootPart.RotVelocity.Y/13), 0.08)
            RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.5, 0 + 0.34*math.sin(sine/10)) * angles(math.rad(0 - 26*math.sin(sine/10)) + RootPart.RotVelocity.Y/-34, 0, math.rad(6 + 8*math.cos(sine/5)) - RootPart.RotVelocity.Y/34), 0.08)
            LW.C0            = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0 - 0.34*math.sin(sine/10)) * angles(math.rad(0 + 26*math.sin(sine/10)) + RootPart.RotVelocity.Y/34, 0, math.rad(-6 - 8*math.cos(sine/5)) + RootPart.RotVelocity.Y/-34), 0.08)
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 - 0.21*math.cos(sine/10), -0.03 + 0.19*math.cos(sine/10)) * CFrame.Angles(math.rad(-8 - 25*math.sin(sine/10)*-math.rad(TiltVelocity.z)*9.5), - RootPart.RotVelocity.Y/-24, math.rad(0 - 25*math.sin(sine/10)*math.rad(TiltVelocity.x)*6.5 - RootPart.RotVelocity.Y/34)), 0.08)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1 + 0.21*math.cos(sine/10), -0.03 - 0.19*math.cos(sine/10)) * CFrame.Angles(math.rad(-8 + 25*math.sin(sine/10)*-math.rad(TiltVelocity.z)*9.5), RootPart.RotVelocity.Y/24, math.rad(0 - 25*math.sin(sine/10)*-math.rad(TiltVelocity.x)*6.5 - RootPart.RotVelocity.Y/34)), 0.08)
        end
    elseif torvel >= 22 and hitfloor ~= nil then
        Anim = "Run"
        change = 0.84 + Humanoid.WalkSpeed/112
        if attack == false and equip == false then
            Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Vector3.new(0, 0, 0), 0.02)
            Torso.Weld.C0    = clerp(Torso.Weld.C0, CFrame.new(0, -1 - 0.5*math.cos(sine/2.5), -0.8) * angles(math.rad(-23 + 4*math.cos(sine/5)), math.rad(0 + 4*math.sin(sine/5)), RootPart.RotVelocity.Y/26), 0.1)
            Torso.Neck.C0    = clerp(Torso.Neck.C0, necko * angles(math.rad(-12 + 20*math.sin(sine/2.5)), 0, math.rad(0 + 5*math.sin(sine/5)) + RootPart.RotVelocity.Y/13), 0.1)
            RW.C0            = clerp(RW.C0, CFrame.new(1.5, 0.5, 0 - 0.34*math.cos(sine/5)) * angles(math.rad(10 + 57*math.cos(sine/5)) + RootPart.RotVelocity.Y/-34, math.rad(0 + 43*math.cos(sine/5)), math.rad(5) - RootPart.RotVelocity.Y/34), 0.25)
            LW.C0            = clerp(LW.C0, cf(-1.5, 0.5, 0 + 0.34*math.cos(sine/5)) * angles(math.rad(10 - 57*math.cos(sine/5)) + RootPart.RotVelocity.Y/34, math.rad(0 + 43*math.cos(sine/5)), math.rad(-5) + RootPart.RotVelocity.Y/-34), 0.25)
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 + 0.56*math.cos(sine/5), 0 - 0.48*math.cos(sine/5)) * CFrame.Angles(math.rad(0 + 73*math.sin(sine/5)), RootPart.RotVelocity.Y/42, RootPart.RotVelocity.Y/-54), 0.3)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1 - 0.56*math.cos(sine/5), 0 + 0.48*math.cos(sine/5)) * CFrame.Angles(math.rad(0 - 73*math.sin(sine/5)), RootPart.RotVelocity.Y/42, -RootPart.RotVelocity.Y/54), 0.3)
        end
        if attack == true and noleg == false then
            LeftLeg.Weld.C0  = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 - 0.24*math.cos(sine/5), 0.24*math.cos(sine/5)) * CFrame.Angles(math.rad(0 - 74*math.sin(sine/5)), 0, 0), 0.3)
            RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1 + 0.24*math.cos(sine/5), -0.24*math.cos(sine/5)) * CFrame.Angles(math.rad(0 + 74*math.sin(sine/5)), 0, 0), 0.3)
        end
    end

    -- ===== Effect step =====
    if #Effects > 0 then
        for e = 1, #Effects do
            if Effects[e] ~= nil then
                local T = Effects[e]
                if T ~= nil then
                    local Part  = T[1]
                    local Mode  = T[2]
                    local Delay = T[3]
                    if Mode ~= "Shoot" and Mode ~= "DecreaseStat" and Mode ~= "Wave"
                       and Mode ~= "FireWave" and Mode ~= "showDamage"
                       and Mode ~= "PartiEmi" and Mode ~= "AdjuEff" then
                        if Part and Part.Transparency <= 1 then
                            if Mode == "Block1" then
                                Part.CFrame = Part.CFrame * euler(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                                local m = T[7]; m.Scale = m.Scale + vt(T[4], T[5], T[6])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Block2" then
                                local m = T[7]; m.Scale = m.Scale + vt(T[4], T[5], T[6])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Block3" then
                                T[9] = T[9] + 0.5
                                Part.CFrame = T[8] * cf(0, T[9], 0) * euler(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                                local m = T[7]; m.Scale = m.Scale + vt(T[4], T[5], T[6])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Cylinder" then
                                local m = T[7]
                                m.Scale = m.Scale + vt(T[4] - Part.Transparency, T[5] - Part.Transparency, T[6] - Part.Transparency)
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Cylinder2" then
                                Part.CFrame = Part.CFrame * cf(0, T[8], 0)
                                local m = T[7]; m.Scale = m.Scale + vt(T[4], T[5], T[6])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Blood" then
                                local m = T[7]; Part.CFrame = Part.CFrame * cf(0, 0.5, 0)
                                m.Scale = m.Scale + vt(T[4], T[5], T[6])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Elec" then
                                local m = T[10]
                                m.Scale = m.Scale + vt(T[7], T[8], T[9])
                                Part.Transparency = Part.Transparency + Delay
                            elseif Mode == "Disappear" then
                                Part.Transparency = Part.Transparency + Delay
                            end
                        else
                            if Part and Part.Parent then Part:Destroy() end
                            table.remove(Effects, e)
                        end
                    end
                end
            end
        end
    end
end
