-- ============================================================
-- Fixed by feyz
-- Original: makhail07 / FE conversion: Mizt
-- ============================================================
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris     = game:GetService("Debris")
local UIS        = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char   = player.Character or player.CharacterAdded:Wait()
local mouse  = player:GetMouse()
local camera = workspace.CurrentCamera

local function notify(t, txt, d)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=t, Text=txt, Duration=d or 3})
    end)
end

if not char:FindFirstChild("Torso") then
    notify("God Script", "R6 character required.", 5); return
end

-- Optional reanimation for paid executors
pcall(function()
    if syn then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tescalus/Pendulum-Hubs-Source/main/ReanimMain.lua"))()
    end
end)
notify("God Script", "Loaded (R6).", 3)

-- ============ compatible RbxUtility.Create ============
local function Create(className)
    return function(props)
        local inst = Instance.new(className)
        for k, v in pairs(props) do pcall(function() inst[k] = v end) end
        return inst
    end
end

-- ============ heartbeat ============
local ArtificialHB = Instance.new("BindableEvent")
local frame, tf = 1/60, 0
RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for _ = 1, math.floor(tf/frame) do ArtificialHB:Fire() end
        tf = tf - frame * math.floor(tf/frame)
    end
end)
local function swait(n)
    if not n or n == 0 then ArtificialHB.Event:Wait()
    else for _ = 0, n do ArtificialHB.Event:Wait() end end
end

-- ============ quaternion / cframe interpolation ============
local function clerp(a,b,t)
    local qa,qb = {QuaternionFromCFrame(a)},{QuaternionFromCFrame(b)}
    local ax,ay,az,bx,by,bz = a.x,a.y,a.z,b.x,b.y,b.z
    local _t = 1-t
    return QuaternionToCFrame(_t*ax+t*bx,_t*ay+t*by,_t*az+t*bz, QuaternionSlerp(qa,qb,t))
end
function QuaternionFromCFrame(cf)
    local _,_,_,m00,m01,m02,m10,m11,m12,m20,m21,m22 = cf:components()
    local tr = m00+m11+m22
    if tr > 0 then
        local s = math.sqrt(1+tr); local r = 0.5/s
        return (m21-m12)*r,(m02-m20)*r,(m10-m01)*r,s*0.5
    end
    local i = m00 < m11 and 1 or 0
    if m22 > (i == 0 and m00 or m11) then i = 2 end
    if i == 0 then
        local s = math.sqrt(m00-m11-m22+1); local r = 0.5/s
        return 0.5*s,(m10+m01)*r,(m20+m02)*r,(m21-m12)*r
    elseif i == 1 then
        local s = math.sqrt(m11-m22-m00+1); local r = 0.5/s
        return (m01+m10)*r,0.5*s,(m21+m12)*r,(m02-m20)*r
    else
        local s = math.sqrt(m22-m00-m11+1); local r = 0.5/s
        return (m02+m20)*r,(m12+m21)*r,0.5*s,(m10-m01)*r
    end
end
function QuaternionToCFrame(px,py,pz,x,y,z,w)
    local xs,ys,zs = x+x,y+y,z+z
    local wx,wy,wz = w*xs,w*ys,w*zs
    local xx,xy,xz = x*xs,x*ys,x*zs
    local yy,yz,zz = y*ys,y*zs,z*zs
    return CFrame.new(px,py,pz,
        1-(yy+zz), xy-wz, xz+wy,
        xy+wz, 1-(xx+zz), yz-wx,
        xz-wy, yz+wx, 1-(xx+yy))
end
function QuaternionSlerp(a,b,t)
    local ct = a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]
    local s,f
    if ct >= 1e-4 then
        if 1-ct > 1e-4 then
            local th = math.acos(ct); local inv = 1/math.sin(th)
            s = math.sin((1-t)*th)*inv; f = math.sin(t*th)*inv
        else s, f = 1-t, t end
    elseif 1+ct > 1e-4 then
        local th = math.acos(-ct); local inv = 1/math.sin(th)
        s = math.sin((t-1)*th)*inv; f = math.sin(t*th)*inv
    else s, f = t-1, t end
    return a[1]*s+b[1]*f, a[2]*s+b[2]*f, a[3]*s+b[3]*f, a[4]*s+b[4]*f
end

local function rayCast(pos, dir, range, ignore)
    if dir.Magnitude == 0 then return nil, pos end
    return workspace:FindPartOnRay(Ray.new(pos, dir.Unit*(range or 999.999)), ignore)
end

-- ============ damage ============
local maincolor = BrickColor.new("Institutional white")

local function showDamage(Dude, Text, Time, Color)
    task.spawn(function()
        local head = Dude:FindFirstChild("Head") or Dude:FindFirstChild("HumanoidRootPart")
        if not head then return end
        local gui = Instance.new("BillboardGui")
        gui.Size = UDim2.new(0,100,0,40)
        gui.StudsOffset = Vector3.new(0,3,0)
        gui.Adornee = head
        gui.Parent = Dude
        local lab = Instance.new("TextLabel")
        lab.BackgroundTransparency = 1
        lab.BorderSizePixel = 0
        lab.Text = Text
        lab.Font = Enum.Font.Fantasy
        lab.TextSize = 24
        lab.TextStrokeTransparency = 0
        lab.TextColor3 = Color3.new(.8,0,1)
        lab.TextStrokeColor3 = Color3.new(0,0,0)
        lab.Size = UDim2.new(1,0,0.5,0)
        lab.Parent = gui
        swait(10)
        for i = 0,1,.05 do
            swait()
            lab.Position = lab.Position - UDim2.new(0,0,.005,0)
            lab.TextStrokeTransparency = i
            lab.TextTransparency = i
        end
        gui:Destroy()
    end)
end

local function Damage(Part, hit, minim, maxim, knockback, Type, Property, Delay, HitSound, HitPitch)
    if not hit or not hit.Parent then return end
    local h = hit.Parent:FindFirstChildOfClass("Humanoid")
    if not h and hit.Parent.Parent then h = hit.Parent.Parent:FindFirstChildOfClass("Humanoid") end
    if not h or h.Parent == char then return end
    local dmg = minim + math.random()*(maxim-minim)
    h:TakeDamage(dmg)
    showDamage(hit.Parent, tostring(math.floor(dmg)), .5, maincolor)
    if HitSound then
        local s = Instance.new("Sound", hit)
        s.SoundId = "rbxassetid://"..HitSound
        s.Volume = 1; s.Pitch = HitPitch or 1; s:Play()
        Debris:AddItem(s, 2)
    end
    if Type == "Knockdown" and knockback > 0 then
        h.PlatformStand = true
        local tors = hit.Parent:FindFirstChild("Torso")
        if tors then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, knockback, 0)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Parent = tors; Debris:AddItem(bv, .5)
        end
    end
end

local function MagniDamage(Part, magni, mindam, maxdam, knock, Type)
    local pos = Part.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 and (hrp.Position-pos).Magnitude <= magni then
                Damage(Part, hrp, mindam, maxdam, knock, Type)
            end
        end
    end
end

-- ============ effect helpers ============
local function RemoveOutlines(part)
    part.TopSurface    = Enum.SurfaceType.SmoothNoOutlines
    part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
    part.LeftSurface   = Enum.SurfaceType.SmoothNoOutlines
    part.RightSurface  = Enum.SurfaceType.SmoothNoOutlines
    part.FrontSurface  = Enum.SurfaceType.SmoothNoOutlines
    part.BackSurface   = Enum.SurfaceType.SmoothNoOutlines
end

local CFuncs = {
    Part = {Create = function(Parent, Material, Refl, Trans, BColor, Name, Size)
        local p = Create("Part")({
            Parent=Parent, Reflectance=Refl, Transparency=Trans,
            CanCollide=false, Locked=true,
            BrickColor=BrickColor.new(tostring(BColor)),
            Name=Name, Size=Size, Material=Material
        })
        RemoveOutlines(p)
        return p
    end},
    Mesh = {Create = function(Mesh, Part, MeshType, MeshId, Offset, Scale)
        local m = Create(Mesh)({Parent=Part, Offset=Offset, Scale=Scale})
        if Mesh == "SpecialMesh" then
            m.MeshType = MeshType
            if MeshId and MeshId ~= "" then m.MeshId = MeshId end
        end
        return m
    end},
    Weld = {Create = function(Parent, P0, P1, C0, C1)
        return Create("Weld")({Parent=Parent, Part0=P0, Part1=P1, C0=C0, C1=C1})
    end},
    Sound = {Create = function(id, par, vol, pit)
        task.spawn(function()
            local s = Create("Sound")({
                Volume=vol, Pitch=pit or 1,
                SoundId="rbxassetid://"..tostring(id),
                Parent=par or workspace
            })
            s:Play(); Debris:AddItem(s, 6)
        end)
    end}
}

local EffectModel = Instance.new("Model")
EffectModel.Parent = char
local Effects = {}

local function makeEffect(brickcolor, cframe, kind, mtype, meshid, s1, s2, s3, dx, dy, dz, delay)
    local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, brickcolor, "Effect", Vector3.new())
    prt.Anchored = true
    prt.CFrame = cframe
    local msh = CFuncs.Mesh.Create(mtype, prt, kind, meshid, Vector3.new(0,0,0), Vector3.new(s1,s2,s3))
    Debris:AddItem(prt, 10)
    table.insert(Effects, {prt, "Cylinder", delay, dx, dy, dz, msh})
    return prt, msh
end

local E = {}
E.Wave = {Create = function(bc,cf,x1,y1,z1,x3,y3,z3,d)
    return makeEffect(bc,cf,"FileMesh","SpecialMesh","rbxassetid://20329976",x1/60,y1/60,z1/60,x3/60,y3/60,z3/60,d)
end}
E.Sphere = {Create = function(bc,cf,x1,y1,z1,x3,y3,z3,d)
    return makeEffect(bc,cf,"Sphere","SpecialMesh","",x1,y1,z1,x3,y3,z3,d)
end}
E.Ring = {Create = function(bc,cf,x1,y1,z1,x3,y3,z3,d)
    return makeEffect(bc,cf,"FileMesh","SpecialMesh","rbxassetid://3270017",x1,y1,z1,x3,y3,z3,d)
end}
E.Spiral = {Create = function(bc,cf,x1,y1,z1,x3,y3,z3,d)
    return makeEffect(bc,cf,"FileMesh","SpecialMesh","rbxassetid://1051557",x1,y1,z1,x3,y3,z3,d)
end}

local function Cso(ID, PARENT, VOLUME, PITCH)
    task.spawn(function()
        local s = Instance.new("Sound", PARENT or workspace)
        s.Volume = VOLUME; s.Pitch = PITCH or 1
        s.SoundId = "rbxassetid://"..tostring(ID)
        s:Play(); Debris:AddItem(s, 10)
    end)
end

local function CameraEnshaking(Length, Intensity)
    task.spawn(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local inten = Intensity; local rot = 0.01*Intensity
        for _ = 0, Length, 0.1 do
            swait()
            inten = inten - 0.05*Intensity/Length
            rot   = rot   - 5e-4*Intensity/Length
            hum.CameraOffset = Vector3.new(math.rad(math.random(-inten,inten)),
                                          math.rad(math.random(-inten,inten)),
                                          math.rad(math.random(-inten,inten)))
            camera.CFrame = camera.CFrame *
                CFrame.new(math.rad(math.random(-inten,inten)),
                           math.rad(math.random(-inten,inten)),
                           math.rad(math.random(-inten,inten))) *
                CFrame.Angles(math.rad(math.random(-inten,inten))*rot,
                              math.rad(math.random(-inten,inten))*rot,
                              math.rad(math.random(-inten,inten))*rot)
        end
        hum.CameraOffset = Vector3.new(0,0,0)
    end)
end

-- ============ character parts ============
local plr   = player
local hum   = char:WaitForChild("Humanoid")
local hed   = char:WaitForChild("Head")
local root  = char:WaitForChild("HumanoidRootPart")
local tors  = char:WaitForChild("Torso")
local ra    = char:WaitForChild("Right Arm")
local la    = char:WaitForChild("Left Arm")
local rl    = char:WaitForChild("Right Leg")
local ll    = char:WaitForChild("Left Leg")
local rootj = root:WaitForChild("RootJoint")
local neck  = tors:WaitForChild("Neck")

-- Disable default animation
local animate = char:FindFirstChild("Animate")
if animate then animate:Destroy() end
local animator = hum:FindFirstChildOfClass("Animator")
if animator then animator:Destroy() end

hum.WalkSpeed = 16
hum.JumpPower = 57

-- Replace shoulder joints with custom welds
local RSH = tors:FindFirstChild("Right Shoulder")
local LSH = tors:FindFirstChild("Left Shoulder")
if RSH then RSH.Parent = nil end
if LSH then LSH.Parent = nil end

local RW = Instance.new("Weld", tors)
RW.Name = "RW"; RW.Part0 = tors; RW.Part1 = ra
RW.C0 = CFrame.new(1.5, 0.5, 0); RW.C1 = CFrame.new(0, 0.5, 0)

local LW = Instance.new("Weld", tors)
LW.Name = "LW"; LW.Part0 = tors; LW.Part1 = la
LW.C0 = CFrame.new(-1.5, 0.5, 0); LW.C1 = CFrame.new(0, 0.5, 0)

local RH = tors:FindFirstChild("Right Hip")
local LH = tors:FindFirstChild("Left Hip")

-- Roots / neck defaults
local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF   = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF   = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)
local necko  = CFrame.new(0,1,0, -1,0,0, 0,0,1, 0,1,0)
local Rad    = math.rad
local Cos    = math.cos
local Sin    = math.sin

local Player_Size = 1
rootj.C0 = RootCF * CFrame.new(0,0,0) * CFrame.Angles(0,0,0)
neck.C0  = necko  * CFrame.new(0,0,0) * CFrame.Angles(0,0,0)
neck.C1  = CFrame.new(0,-0.5,0) * CFrame.Angles(Rad(-90),0,Rad(180))
RW.C0    = CFrame.new(1.5,0.5,0)
LW.C0    = CFrame.new(-1.5,0.5,0)
RH.C0    = CFrame.new(1,-1,0) * CFrame.Angles(0, Rad(90),0)
LH.C0    = CFrame.new(-1,-1,0)* CFrame.Angles(0, Rad(-90),0)
RH.C1    = CFrame.new(0.5,1,0) * CFrame.Angles(0, Rad(90),0)
LH.C1    = CFrame.new(-0.5,1,0)* CFrame.Angles(0, Rad(-90),0)

-- "Blob" weapon
local Blobby = Instance.new("Part", char)
Blobby.Name = "Blob"
Blobby.CanCollide = false
Blobby.BrickColor = BrickColor.new("Really black")
Blobby.Material = Enum.Material.Plastic
Blobby.Size = Vector3.new(1,1,2)
RemoveOutlines(Blobby)

local BWeld = Instance.new("Weld", Blobby)
BWeld.Part0 = ra; BWeld.Part1 = Blobby
BWeld.C1 = CFrame.new(0, -2, 1.1)
BWeld.C0 = CFrame.Angles(Rad(-86), 0, 0)

local M2 = Instance.new("SpecialMesh", Blobby)
M2.MeshId    = "rbxassetid://10604848"
M2.TextureId = "rbxassetid://10605252"
M2.Scale     = Vector3.new(1,1,1)

-- Music
local SONG = 703597239
local Music = Instance.new("Sound", tors)
Music.SoundId = "rbxassetid://"..SONG
Music.Volume = 1.5; Music.Looped = true; Music.Pitch = 1
Music:Play()

-- ============ hat alignment (safe) ============
local function Align(Part0, Part1)
    if not Part0 or not Part1 then return end
    local a0 = Instance.new("Attachment", Part0)
    local a1 = Instance.new("Attachment", Part1)
    local ao = Instance.new("AlignOrientation", Part0)
    ao.Attachment0 = a0; ao.Attachment1 = a1
    ao.Responsiveness = 200; ao.RigidityEnabled = true
    local ap = Instance.new("AlignPosition", Part0)
    ap.Attachment0 = a0; ap.Attachment1 = a1
    ap.Responsiveness = 200; ap.RigidityEnabled = true
    ap.MaxForce = 1e9
    Part0:BreakJoints()
    task.spawn(function()
        local alive = true
        Part0.AncestryChanged:Connect(function()
            if not Part0:IsDescendantOf(game) then alive = false end
        end)
        while alive do
            if (Part0.Position - (Part1.CFrame * a1.CFrame).p).Magnitude >= 5 then
                Part0.CFrame = Part1.CFrame * a1.CFrame:Inverse()
            end
            Part0.Velocity = Vector3.new(0, 35, 0)
            RunService.Heartbeat:Wait()
        end
    end)
    return a0
end

local accessory = char:FindFirstChild("MeshPartAccessory") or char:FindFirstChildWhichIsA("Accessory")
if accessory and accessory:FindFirstChild("Handle") then
    local a = Align(accessory.Handle, ra)
    if a then
        local cf = ra.CFrame * CFrame.new(0, -0.75, -2.5) * CFrame.Angles(Rad(45), Rad(-90), 0)
        a.CFrame = cf:Inverse() * ra.CFrame
    end
end

-- ============ helpers used by attacks ============
local function FindNearestHead(pos, dist)
    local list = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v ~= char and v:FindFirstChild("Head") then
            if (v.Head.Position - pos).Magnitude <= dist then
                table.insert(list, v)
            end
        end
    end
    return list
end

local function Eviscerate(dude)
    if dude == char then return end
    local head = dude:FindFirstChild("Head")
    if not head then return end
    local bg = Instance.new("BodyGyro", head)
    bg.CFrame = head.CFrame * CFrame.Angles(Rad(-90), 0, 0)
    Debris:AddItem(bg, 2)
    task.spawn(function()
        for _, v in ipairs(dude:GetDescendants()) do
            if v:IsA("BasePart") then
                task.spawn(function()
                    local pe = Instance.new("ParticleEmitter", v)
                    pe.LightEmission = 1
                    pe.Texture = "rbxassetid://284205403"
                    pe.Color = ColorSequence.new(maincolor.Color)
                    pe.Rate = 150
                    pe.Lifetime = NumberRange.new(1)
                    pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.75),NumberSequenceKeypoint.new(1,0)})
                    pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
                    pe.Speed = NumberRange.new(0)
                    pe.VelocitySpread = 30000
                    pe.Rotation = NumberRange.new(-500,500)
                    pe.RotSpeed = NumberRange.new(-500,500)
                    local bp = Instance.new("BodyPosition", v)
                    bp.P = 3000; bp.D = 1000
                    bp.MaxForce = Vector3.new(5e10,5e10,5e10)
                    bp.Position = v.Position + Vector3.new(math.random(-15,15),math.random(-15,15),math.random(-15,15))
                    task.delay(0.5, function() pe.Enabled = false end)
                    Debris:AddItem(pe, 4)
                    Debris:AddItem(bp, 0.6)
                end)
            end
        end
    end)
end

-- ============ attacks ============
local attack = false

local function Ban()
    attack = true
    for _ = 0, 2.6, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0, 0, -0.1 + 0.1*Cos(tick())) * CFrame.Angles(0,0,Rad(-60)), 0.2)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(-7.5*Sin(tick())), 0, Rad(60)), 0.2)
        RH.C0    = clerp(RH.C0,    CFrame.new(1,-0.9,0)  * CFrame.Angles(0,Rad(84),0)  * CFrame.Angles(Rad(-6.5),0,0), 0.2)
        LH.C0    = clerp(LH.C0,    CFrame.new(-1,-0.9,-0.6)* CFrame.Angles(0,Rad(-84),0) * CFrame.Angles(Rad(-6.5),0,Rad(20)), 0.2)
        RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0) * CFrame.Angles(Rad(160),Rad(-0.6),Rad(13)), 0.2)
        LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)* CFrame.Angles(Rad(15),Rad(-6),Rad(-25-4.5*Sin(tick()))), 0.2)
    end
    Cso(147722910, tors, 10, 1)
    CameraEnshaking(2, 15)
    for _ = 1, 3 do
        E.Wave.Create(BrickColor.new("Really black"), tors.CFrame * CFrame.new(0,-6,0) * CFrame.Angles(0, Rad(math.random(0,180)), 0),
                      550.5, 100.5, 550.5, 200, 20, 200, 0.05)
    end
    for _, v in ipairs(FindNearestHead(Blobby.Position, 9.5)) do Eviscerate(v) end
    for _ = 0, 3, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.1) * CFrame.Angles(0,0,Rad(-15)), 0.3)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(25-7.5*Sin(tick())),0,Rad(15)), 0.3)
        RH.C0    = clerp(RH.C0,    CFrame.new(1,-0.9,0) * CFrame.Angles(0,Rad(84),0)*CFrame.Angles(Rad(-6.5),0,Rad(-20)), 0.3)
        LH.C0    = clerp(LH.C0,    CFrame.new(-1,-0.9,0)* CFrame.Angles(0,Rad(-84),0)*CFrame.Angles(Rad(-6.5),0,0), 0.3)
        RW.C0    = clerp(RW.C0,    CFrame.new(1,0.3,-0.6)*CFrame.Angles(Rad(5),Rad(-0.6),Rad(-25)), 0.3)
        LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)*CFrame.Angles(Rad(15),Rad(-6),Rad(-25-4.5*Sin(tick()))), 0.3)
    end
    attack = false
end

local function BigBan()
    attack = true
    BWeld.C0 = CFrame.Angles(Rad(-90), Rad(-25), 0)
    for _ = 0, 3.6, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,1) * CFrame.Angles(Rad(-20),0,0), 0.2)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(-45-7.5*Sin(tick())),0,0), 0.2)
        RW.C0    = clerp(RW.C0,    CFrame.new(1,0.5,-0.6)*CFrame.Angles(Rad(-225),Rad(-0.6),Rad(-45)), 0.2)
        LW.C0    = clerp(LW.C0,    CFrame.new(-1,0.5,-0.6)*CFrame.Angles(Rad(-225),Rad(-6),Rad(45)), 0.2)
    end
    Cso(147722910, tors, 10, 1)
    CameraEnshaking(2, 15)
    for _ = 1, 3 do
        E.Wave.Create(BrickColor.new("Really black"), tors.CFrame * CFrame.new(0,-6,0) * CFrame.Angles(0,Rad(math.random(0,180)),0),
                      550.5, 100.5, 550.5, 200, 20, 200, 0.05)
    end
    for _, v in ipairs(FindNearestHead(Blobby.Position, 14.5)) do Eviscerate(v) end
    for _ = 0, 2.6, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,1) * CFrame.Angles(Rad(75),0,0), 0.2)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(45-7.5*Sin(tick())),0,0), 0.2)
        RW.C0    = clerp(RW.C0,    CFrame.new(1,0.5,-0.6)*CFrame.Angles(Rad(-325),Rad(-0.6),Rad(-45)), 0.2)
        LW.C0    = clerp(LW.C0,    CFrame.new(-1,0.5,-0.6)*CFrame.Angles(Rad(-325),Rad(-6),Rad(45)), 0.2)
    end
    BWeld.C0 = CFrame.Angles(Rad(-86),0,0)
    attack = false
end

local function BANN()
    attack = true
    M2.Scale = Vector3.new(2,2,2)
    for _ = 0, 4.6, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,1) * CFrame.Angles(0,0,Rad(-60)), 0.2)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(-7.5*Sin(tick())),0,Rad(60)), 0.2)
        RW.C0    = clerp(RW.C0,    CFrame.new(0.6,0.5,-0.4)*CFrame.Angles(Rad(160),Rad(-0.6),Rad(13)), 0.2)
        LW.C0    = clerp(LW.C0,    CFrame.new(-0.8,0.5,-0.4)*CFrame.Angles(Rad(156),Rad(-0.6),Rad(45)), 0.2)
    end
    Cso(147722910, char, 10, 1)
    CameraEnshaking(2, 35)
    for _ = 1, 3 do
        E.Wave.Create(BrickColor.new("Really black"), tors.CFrame * CFrame.new(0,-5,0) * CFrame.Angles(0,Rad(math.random(0,180)),0),
                      550.5, 100.5, 550.5, 200, 20, 200, 0.05)
    end
    for _, v in ipairs(FindNearestHead(Blobby.Position, 19.5)) do Eviscerate(v) end
    for _ = 0, 3, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.1) * CFrame.Angles(0,0,Rad(-15)), 0.3)
        neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(25-7.5*Sin(tick())),0,Rad(15)), 0.3)
        RW.C0    = clerp(RW.C0,    CFrame.new(1,0.3,-0.6)*CFrame.Angles(Rad(5),Rad(-0.6),Rad(-25)), 0.3)
        LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)*CFrame.Angles(Rad(15),Rad(-6),Rad(-25-4.5*Sin(tick()))), 0.3)
    end
    M2.Scale = Vector3.new(1,1,1)
    attack = false
end

-- ============ input ============
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local k = input.KeyCode.Name
        if k == "Zero" then hum.WalkSpeed = 38.82 end
        if not attack then
            if k == "E" then BigBan()
            elseif k == "R" then BANN()
            elseif k == "T" then Cso(1450018171, hed, 10, 1) end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 and not attack then
        Ban()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "Zero" then
        hum.WalkSpeed = 16
    end
end)

-- ============ main animation + effects loop ============
local sine, change = 0, 1
local Anim = "Idle"

while true do
    swait()
    sine = sine + change
    local torvel = (root.Velocity * Vector3.new(1,0,1)).Magnitude
    local hitfloor = rayCast(root.Position, CFrame.new(root.Position, root.Position - Vector3.new(0,1,0)).lookVector, 4, char)

    if not attack then
        if root.Velocity.y > 1 and not hitfloor then
            Anim = "Jump"
            rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.1) * CFrame.Angles(Rad(-16),0,0), 0.15)
            neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(10-2.5*Sin(sine/30)),0,0), 0.3)
            RH.C0    = clerp(RH.C0,    CFrame.new(1,-0.2,-0.3)  * RHCF * CFrame.Angles(Rad(-2.5),0,0), 0.15)
            LH.C0    = clerp(LH.C0,    CFrame.new(-1,-0.9,-0.5) * LHCF * CFrame.Angles(Rad(-2.5),0,0), 0.15)
            RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0) * CFrame.Angles(Rad(25),Rad(-0.6),Rad(13+4.5*Sin(sine/20))), 0.1)
            LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)* CFrame.Angles(Rad(25),Rad(-0.6),Rad(-13-4.5*Sin(sine/20))), 0.1)
        elseif root.Velocity.y < -1 and not hitfloor then
            Anim = "Fall"
            rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.1) * CFrame.Angles(Rad(24),0,0), 0.15)
            neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(10-2.5*Sin(sine/30)),0,0), 0.3)
            RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0) * CFrame.Angles(Rad(65),Rad(-0.6),Rad(45+4.5*Sin(sine/20))), 0.1)
            LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)* CFrame.Angles(Rad(55),Rad(-0.6),Rad(-45-4.5*Sin(sine/20))), 0.1)
        elseif torvel < 1 and hitfloor then
            Anim = "Idle"; change = 1
            rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.1) * CFrame.Angles(0,0,0), 0.15)
            neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(-7.5*Sin(sine/30)),0,0), 0.3)
            RH.C0    = clerp(RH.C0,    CFrame.new(1,-0.9,0)*CFrame.Angles(0,Rad(84),0)*CFrame.Angles(Rad(-6.5),0,0), 0.15)
            LH.C0    = clerp(LH.C0,    CFrame.new(-1,-0.9,0)*CFrame.Angles(0,Rad(-84),0)*CFrame.Angles(Rad(-6.5),0,0), 0.15)
            RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0)*CFrame.Angles(Rad(190),Rad(-0.6),Rad(13)), 0.1)
            LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)*CFrame.Angles(Rad(15),Rad(-6),Rad(-25-4.5*Sin(sine/20))), 0.1)
        elseif torvel > 2 and torvel < 25 and hitfloor then
            Anim = "Walk"; change = 1
            rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.175+0.025*Cos(sine/3.5)) * CFrame.Angles(Rad(3-2.5*Cos(sine/3.5)),0,Rad(8*Cos(sine/7))), 0.15)
            neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(6-6.5*Sin(sine/7)),0,0), 0.3)
            RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0)*CFrame.Angles(Rad(190),Rad(8*Cos(sine/7)),Rad(13)), 0.1)
            LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)*CFrame.Angles(Rad(-37*Cos(sine/7)),Rad(8*Cos(sine/7)),Rad(-6)), 0.1)
        elseif torvel >= 25 and hitfloor then
            Anim = "Sprint"; change = 1.35
            rootj.C0 = clerp(rootj.C0, RootCF * CFrame.new(0,0,-0.175+0.025*Cos(sine/3.5)) * CFrame.Angles(Rad(26-4.5*Cos(sine/3.5)),0,Rad(15*Cos(sine/7))), 0.15)
            neck.C0  = clerp(neck.C0,  necko  * CFrame.Angles(Rad(-45-2.5*Sin(sine/20)),0,0), 0.3)
            RW.C0    = clerp(RW.C0,    CFrame.new(1.5,0.5,0)*CFrame.Angles(Rad(215),Rad(8*Cos(sine/7)),Rad(13)), 0.15)
            LW.C0    = clerp(LW.C0,    CFrame.new(-1.5,0.5,0)*CFrame.Angles(Rad(-75),Rad(8*Cos(sine/7)),Rad(-13)), 0.15)
        end
    end

    -- effects update (reverse iteration to safely remove)
    for e = #Effects, 1, -1 do
        local Thing = Effects[e]
        if Thing then
            local Part, Mode, Delay = Thing[1], Thing[2], Thing[3]
            local IncX, IncY, IncZ = Thing[4], Thing[5], Thing[6]
            if Part and Part.Parent then
                if Part.Transparency < 1 then
                    local Mesh = Thing[7] or Part:FindFirstChildOfClass("DataModelMesh")
                    if Mode == "Cylinder" then
                        if Mesh then Mesh.Scale = Mesh.Scale + Vector3.new(IncX,IncY,IncZ) end
                        Part.Transparency = Part.Transparency + Delay
                    else
                        Part.Transparency = Part.Transparency + Delay
                    end
                else
                    Part:Destroy()
                    table.remove(Effects, e)
                end
            else
                table.remove(Effects, e)
            end
        end
    end
end
