-- NEBULAGLITCHER V1.2 — fixed by feyz
-- Original: by 123jl123 (last update 6th of June, 2018)

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local Debris             = game:GetService("Debris")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace          = workspace
local Lighting           = game:GetService("Lighting")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local S = setmetatable({}, {__index = function(_, i) return game:GetService(i) end})
local CF = {N = CFrame.new, A = CFrame.Angles, fEA = CFrame.fromEulerAnglesXYZ}
local C3 = {N = Color3.new, RGB = Color3.fromRGB, HSV = Color3.fromHSV, tHSV = Color3.toHSV}
local V3 = {N = Vector3.new, FNI = Vector3.FromNormalId, A = Vector3.FromAxis}
local M  = {C = math.cos, R = math.rad, S = math.sin, P = math.pi, RNG = math.random, H = math.huge,
    RRNG = function(min, max, div) return math.rad(math.random(min, max) / (div or 1)) end}
local R3 = {N = Region3.new}
local pl  = math.random()
local De  = Debris
local WS  = Workspace
local Lght= Lighting
local RepS= ReplicatedStorage
local IN  = Instance.new
local Plrs= Players
local UIS = UserInputService

local Plr   = Plrs.LocalPlayer
local Char  = Plr.Character or Plr.CharacterAdded:Wait()

if not Char:FindFirstChild("Torso") then
    warn("[NebulaGlitcher] Requires R6 avatar. Change to R6 and re-execute.")
    return
end

local Hum   = Char:FindFirstChildOfClass'Humanoid'
local RArm  = Char["Right Arm"]
local LArm  = Char["Left Arm"]
local RLeg  = Char["Right Leg"]
local LLeg  = Char["Left Leg"]
local Root  = Char:FindFirstChild'HumanoidRootPart'
local Torso = Char.Torso
local Head  = Char.Head
local PlrGui= Plr:FindFirstChildOfClass'PlayerGui'
local Mouse = Plr:GetMouse()

local NeutralAnims      = true
local Attack            = false
local Debounces         = {Debounces = {}}
local Hit               = {}
local Sine              = 0
local Change            = 1
local Combo             = 1
local Hue               = 0
local BloodPuddles      = {}
local DontAttackPlayers = false
local BurnInterval      = .7
local Radioactive       = {}
local Hits              = 0
local HitTime           = time()
local MaxHits           = 60

local Effects = IN("Folder", Char)
Effects.Name = "Effects"

function Output(_type, ...)
    warn(table.concat{..., "\t"})
end
Output("Note", "NEBULAGLITCHER V1.2 (fixed)")

-- ============================================================
-- Debounce system
-- ============================================================
function Debounces:New(name, cooldown)
    local a = {Usable = true, Cooldown = cooldown or 2, CoolingDown = false, LastUse = 0}
    setmetatable(a, {__index = Debounces})
    Debounces.Debounces[name] = a
    return a
end
function Debounces:Use(override)
    if self.Usable or override then
        self.Usable = false
        self.CoolingDown = true
        local lu = time()
        self.LastUse = lu
        task.delay(self.Cooldown or 2, function()
            if self.LastUse == lu then
                self.CoolingDown = false
                self.Usable = true
            end
        end)
    end
end
function Debounces:Get(name)
    for i, v in next, Debounces.Debounces do
        if i == name then return v end
    end
end
function Debounces:GetProgressPercentage()
    if self.CoolingDown and not self.Usable then
        return math.max(math.floor(((time() - self.LastUse) / self.Cooldown or 2) * 100))
    end
    return 100
end

-- ============================================================
-- Core instance helpers
-- ============================================================
function Sound(parent, id, pitch, volume, looped, effect, autoPlay)
    local s = IN("Sound")
    s.SoundId  = "rbxassetid://"..tostring(id or 0)
    s.Pitch    = pitch or 1
    s.Volume   = volume or 1
    s.Looped   = looped or false
    if autoPlay then
        coroutine.wrap(function()
            repeat task.wait() until s.IsLoaded
            s.Playing = autoPlay or false
        end)()
    end
    if (not looped and effect) then
        s.Stopped:Connect(function()
            s.Volume = 0
            s:Destroy()
        end)
    end
    s.Parent = parent or Torso
    return s
end

function Part(parent, color, material, size, cframe, anchored, cancollide)
    local part = IN("Part")
    part.Parent = parent or Char
    part[typeof(color) == 'BrickColor' and 'BrickColor' or 'Color'] = color or C3.N(0, 0, 0)
    part.Material = material or Enum.Material.SmoothPlastic
    part.TopSurface, part.BottomSurface = 10, 10
    part.Size = size or V3.N(1, 1, 1)
    part.CFrame = cframe or CF.N(0, 0, 0)
    part.CanCollide = cancollide or false
    part.Anchored = anchored or false
    return part
end

function Weld(part0, part1, c0, c1)
    local w = IN("Weld")
    w.Parent = part0
    w.Part0 = part0
    w.Part1 = part1
    w.C0 = c0 or CF.N()
    w.C1 = c1 or CF.N()
    return w
end

function Mesh(parent, meshtype, meshid, textid, scale, offset)
    local m = IN("SpecialMesh")
    m.MeshId    = meshid or ""
    m.TextureId = textid or ""
    m.Scale     = scale or V3.N(1, 1, 1)
    m.Offset    = offset or V3.N(0, 0, 0)
    m.MeshType  = meshtype or Enum.MeshType.Sphere
    m.Parent    = parent
    return m
end

NewInstance = function(instance, parent, properties)
    local inst = Instance.new(instance)
    inst.Parent = parent
    if properties then
        for i, v in next, properties do
            pcall(function() inst[i] = v end)
        end
    end
    return inst
end

Clone = function(instance, parent, properties)
    local inst = instance:Clone()
    inst.Parent = parent
    if properties then
        for i, v in next, properties do
            pcall(function() inst[i] = v end)
        end
    end
    return inst
end

function SoundPart(id, pitch, volume, looped, effect, autoPlay, cf)
    local sp = NewInstance("Part", Effects, {
        Transparency = 1, CFrame = cf or Torso.CFrame, Anchored = true,
        CanCollide = false, Size = V3.N()
    })
    local s = IN("Sound")
    s.SoundId  = "rbxassetid://"..tostring(id or 0)
    s.Pitch    = pitch or 1
    s.Volume   = volume or 1
    s.Looped   = looped or false
    if autoPlay then
        coroutine.wrap(function()
            repeat task.wait() until s.IsLoaded
            s.Playing = autoPlay or false
        end)()
    end
    if (not looped and effect) then
        s.Stopped:Connect(function()
            s.Volume = 0
            sp:Destroy()
        end)
    end
    s.Parent = sp
    return s, sp
end

local Instance = setmetatable({ClearChildrenOfClass = function(where, class, recursive)
    local children = (recursive and where:GetDescendants() or where:GetChildren())
    for _, v in next, children do if v:IsA(class) then v:Destroy() end end
end}, {__index = Instance})

-- ============================================================
-- Camera shake
-- ============================================================
function CamShake(who, times, intense, origin)
    coroutine.wrap(function()
        if who == Plr or who == Char or (who and who.IsDescendantOf and who:IsDescendantOf(Plr)) then
            local intensity = intense
            local cam = workspace.CurrentCamera
            for _ = 1, times do
                local camDist
                if typeof(origin) == 'Instance' and origin:IsA'BasePart' then
                    camDist = math.floor((cam.CFrame.p - origin.Position).magnitude) / 25
                elseif typeof(origin) == 'Vector3' then
                    camDist = math.floor((cam.CFrame.p - origin).magnitude) / 25
                end
                if camDist and camDist > 0 then
                    intensity = math.min(intense, math.floor(intense / camDist))
                end
                cam.CFrame = cam.CFrame:Lerp(
                    cam.CFrame * CFrame.new(
                        math.random(-intensity, intensity) / 100,
                        math.random(-intensity, intensity) / 100,
                        math.random(-intensity, intensity) / 100
                    ) * CFrame.Angles(
                        math.rad(math.random(-intensity, intensity) / 100),
                        math.rad(math.random(-intensity, intensity) / 100),
                        math.rad(math.random(-intensity, intensity) / 100)
                    ), .4)
                swait()
            end
        end
    end)()
end
function CamShakeAll(times, intense, origin)
    for _, v in next, Plrs:GetPlayers() do
        CamShake(v:FindFirstChildOfClass'PlayerGui' or v:FindFirstChildOfClass'Backpack' or v.Character, times, intense, origin)
    end
end
function CamShakeAOE(origin, range, times, intense, blacklist)
    local hit = {}
    for _, v in next, getRegion(origin, range, blacklist or {}) do
        if v.Parent and Plrs:GetPlayerFromCharacter(v.Parent) and not hit[v.Parent] and v.Parent:FindFirstChildOfClass'Humanoid' then
            CamShake(v, times, intense, origin)
            hit[v.Parent] = true
        end
    end
end

-- ============================================================
-- Customization constants
-- ============================================================
local Frame_Speed     = 60
local Remove_Hats     = false
local Remove_Clothing = false
local PlayerSize      = 1
local MusicID         = 407749940
local Pitch           = 1
local VisSong         = 147372923
local God             = false
local Muted           = false
local PrimaryParts    = {}
local SecondaryParts  = {}
local WalkSpeed       = 16
local Mode            = 1

-- Name tag
pcall(function() Char.LeftWing:Destroy() end)
pcall(function() Char.Halo:Destroy() end)
local txt = IN("BillboardGui", PlrGui)
txt.Adornee = Head
txt.Name = "NameDetect"
txt.Size = UDim2.new(4, 0, 1.2, 0)
txt.StudsOffset = Vector3.new(-8, 8/1.5, 0)
local text = IN("TextLabel", txt)
text.Size = UDim2.new(5, 0, 3.5, 0)
text.Font = Enum.Font.Fantasy
text.TextScaled = true
text.BackgroundTransparency = 1
text.TextTransparency = 0
text.TextStrokeTransparency = 0
text.TextStrokeColor3 = Color3.new(0, 0, 0)
text.TextColor3 = Color3.new(1, 0, 0)
text.Text = "Solitude"

pcall(function() Char.ReaperShadowHead.Eye1.BrickColor = BrickColor.new'Black' end)
pcall(function() Char.ReaperShadowHead.Eye2.BrickColor = BrickColor.new'Black' end)

function RecolorTextAndRename(name, col1, col2)
    text.TextStrokeColor3 = col2
    text.TextColor3 = col1
    text.Text = name
end

New = function(Object, Parent, Name, Data)
    local o = Instance.new(Object)
    for Index, Value in pairs(Data or {}) do o[Index] = Value end
    o.Parent = Parent
    o.Name = Name
    return o
end

-- ============================================================
-- Feather model
-- ============================================================
local Feather = New("Model", nil, "Feather", {})
local Main = New("Part", Feather, "Main", {
    Transparency = 1, Size = Vector3.new(0.0500000007, 0.0500000007, 0.0500000007),
    CFrame = CFrame.new(-1.38499999, 33.7899933, -0.127610922, 1, 0, 0, 0, -1, 0, 0, 0, -1),
    BottomSurface = Enum.SurfaceType.Smooth, TopSurface = Enum.SurfaceType.Smooth,
})
New("SpecialMesh", Main, "Mesh", {MeshType = Enum.MeshType.Brick})

local function addFeatherPart(name, cf, meshType, scale)
    local p = New("Part", Feather, name, {
        BrickColor = BrickColor.new("Institutional white"), Material = Enum.Material.SmoothPlastic,
        Size = Vector3.new(0.0500000007, 0.0500000007, 0.0500000007),
        CFrame = cf, BottomSurface = Enum.SurfaceType.Smooth, TopSurface = Enum.SurfaceType.Smooth,
        Color = Color3.new(0.972549, 0.972549, 0.972549),
    })
    New("SpecialMesh", p, "Mesh", {Scale = scale, MeshType = meshType})
    New("Motor", p, "wald", {Part0 = p, Part1 = Main,
        C0 = CFrame.new(), C1 = CFrame.new(0, 0, 0)})
    return p
end
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 33.7899933, 0.144406915, 1, 0, 0, 0, -1, 0, 0, 0, -1), Enum.MeshType.Brick, Vector3.new(1, 12.3999977, 10.999999))
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 33.7899933, -0.405595958, -1, 0, 0, 0, -1, 0, 0, 0, 1), Enum.MeshType.Brick, Vector3.new(1, 12.3999977, 10.999999))
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 32.7949944, -0.405595958, -1, 0, 0, 0, -1, 0, 0, 0, 1), Enum.MeshType.Wedge, Vector3.new(1, 27.3999977, 10.999999))
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 32.7949944, 0.144407034, 1, 0, 0, 0, -1, 0, 0, 0, -1), Enum.MeshType.Wedge, Vector3.new(1, 27.3999977, 10.999999))
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 34.7849922, -0.405595958, 1, 0, 0, 0, 1, 0, 0, 0, 1), Enum.MeshType.Wedge, Vector3.new(1, 27.3999977, 10.999999))
addFeatherPart("CrystalPart", CFrame.new(-1.38499999, 34.7849922, 0.144407034, -1, 0, 0, 0, 1, 0, 0, 0, -1), Enum.MeshType.Wedge, Vector3.new(1, 27.3999977, 10.999999))

for _, v in next, Feather:GetChildren() do
    if v:IsA'BasePart' then
        v.CanCollide = false
        v.BrickColor = BrickColor.new'Black'
        v.Material = Enum.Material.Neon
        v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
    end
end

-- ============================================================
-- Core model (Core1 + Core2 parts welded to Torso)
-- ============================================================
local Core = New("Model", Char, "Core", {})
local Core1 = New("Part", Core, "Core1", {
    BrickColor = BrickColor.new("Black"), CanCollide = false, Material = Enum.Material.SmoothPlastic,
    FormFactor = Enum.FormFactor.Symmetric, Size = Vector3.new(0.5, 0.5, 1.04999959),
    CFrame = CFrame.new(-11.8130245, 33.4548035, 27.3183327,
        -8.05594027e-08, 8.28877091e-08, 1.00000942,
        0.707106829, 0.707106829, 9.31322575e-10,
        -0.707110167, 0.707110226, 2.70083547e-08),
    BackSurface = Enum.SurfaceType.SmoothNoOutlines, BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
    FrontSurface = Enum.SurfaceType.SmoothNoOutlines, LeftSurface = Enum.SurfaceType.SmoothNoOutlines,
    RightSurface = Enum.SurfaceType.SmoothNoOutlines, TopSurface = Enum.SurfaceType.SmoothNoOutlines,
})
New("Motor", Core1, "CW1", {
    Part0 = Core1, Part1 = Torso,
    C0 = CFrame.new(0, 0, 0, -3.09086197e-08, 0.707106769, -0.707106769,
        3.09086197e-08, 0.707106769, 0.707106769, 1, 0, -4.37113883e-08),
    C1 = CFrame.new(-0.0409317017, 0.453670502, -0.00761127472,
        -0.0156120239, -4.36557457e-11, 0.999880552,
        -0.0062853382, 0.999980271, -9.81385238e-05,
        -0.999863088, -0.0062860758, -0.015611751),
})

local Core2 = New("Part", Core, "Core2", {
    BrickColor = BrickColor.new("Black"), CanCollide = false, Material = Enum.Material.Neon,
    FormFactor = Enum.FormFactor.Symmetric, Size = Vector3.new(0.349999994, 0.349999994, 1.06999981),
    CFrame = CFrame.new(-11.8130217, 33.4548035, 27.3183327,
        -8.05594027e-08, 8.28877091e-08, 1.00000942,
        0.707106829, 0.707106829, 9.31322575e-10,
        -0.707110167, 0.707110226, 2.70083547e-08),
    BackSurface = Enum.SurfaceType.SmoothNoOutlines, BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
    FrontSurface = Enum.SurfaceType.SmoothNoOutlines, LeftSurface = Enum.SurfaceType.SmoothNoOutlines,
    RightSurface = Enum.SurfaceType.SmoothNoOutlines, TopSurface = Enum.SurfaceType.SmoothNoOutlines,
})
New("Motor", Core2, "CW2", {
    Part0 = Core2, Part1 = Torso,
    C0 = CFrame.new(0, 0, 0, -3.09086197e-08, 0.707106769, -0.707106769,
        3.09086197e-08, 0.707106769, 0.707106769, 1, 0, -4.37113883e-08),
    C1 = CFrame.new(-0.0409317017, 0.453670502, -0.00761413574,
        -0.0156120239, -4.36557457e-11, 0.999880552,
        -0.0062853382, 0.999980271, -9.81385238e-05,
        -0.999863088, -0.0062860758, -0.015611751),
})
NewInstance("Humanoid", Core, {MaxHealth = 500, Health = 500})

if Remove_Hats then Instance.ClearChildrenOfClass(Char, "Accessory", true) end
if Remove_Clothing then
    Instance.ClearChildrenOfClass(Char, "Clothing", true)
    Instance.ClearChildrenOfClass(Char, "ShirtGraphic", true)
end

local Music = Sound(Char, MusicID, 1, 3, true, false, true)
Music.Name = 'Music'

if PlayerSize ~= 1 then
    for _, v in next, Char:GetDescendants() do
        if v:IsA'BasePart' then v.Size = v.Size * PlayerSize end
    end
end

-- ============================================================
-- Halo / Wings
-- ============================================================
local Halo      = NewInstance("Model", Char, {Name = 'Halo'})
local LWing     = NewInstance("Model", Char, {Name = 'LeftWing'})
local RWing     = NewInstance("Model", Char, {Name = 'RightWing'})
local LWingEXT  = NewInstance("Model", Char, {Name = 'LeftWingEXT'})
local RWingEXT  = NewInstance("Model", Char, {Name = 'RightWingEXT'})

local LWingWelds  = {}
local RWingWelds  = {}
local LWingEWelds = {}
local RWingEWelds = {}

local HaloHandle  = NewInstance("Part", Halo,     {Size = V3.N(.05, .05, .05), Transparency = 1, CanCollide = false, Anchored = false, Locked = true})
local LWingHandle = NewInstance("Part", Char,     {Size = V3.N(.05, .05, .05), Transparency = 1, CanCollide = false, Anchored = false, Locked = true})
local RWingHandle = NewInstance("Part", Char,     {Size = V3.N(.05, .05, .05), Transparency = 1, CanCollide = false, Anchored = false, Locked = true})

for i = 1, 360, 5 do
    local part = NewInstance("Part", Halo, {
        BrickColor = BrickColor.new"Black", Material = Enum.Material.Neon,
        Size = V3.N(0.25, 0.1, 0.1), Anchored = false, CanCollide = false, Locked = true,
    })
    NewInstance("Weld", part, {Part0 = HaloHandle, Part1 = part, C0 = CF.A(0, M.R(i), 0) * CF.N(0, 0, -1)})
    table.insert(PrimaryParts, part)
end

for i = 1, 6 do
    local cr = Part(Char, BrickColor.new'Black', Enum.Material.SmoothPlastic, V3.N(.05, .05, .05), CF.N(), false, false)
    cr.Transparency = 1
    local clone = Feather:Clone()
    local men = clone.Main
    Weld(cr, men)
    local weld = Weld(men, LWingHandle)
    if i > 3 then
        for _, v in next, clone:GetChildren() do v.Parent = LWingEXT; v.Transparency = 1 end
    else
        for _, v in next, clone:GetChildren() do v.Parent = LWing end
    end
    table.insert(LWingWelds, weld)
    table.insert(PrimaryParts, cr)
end

for i = 1, 6 do
    local cr = Part(Char, BrickColor.new'Black', Enum.Material.SmoothPlastic, V3.N(.05, .05, .05), CF.N(), false, false)
    cr.Transparency = 1
    local clone = Feather:Clone()
    local men = clone.Main
    Weld(cr, men)
    local weld = Weld(men, RWingHandle)
    if i > 3 then
        for _, v in next, clone:GetChildren() do
            v.Parent = RWingEXT
            if v:IsA'BasePart' then v.Transparency = 1 end
        end
    else
        for _, v in next, clone:GetChildren() do
            v.Parent = RWing
            if v:IsA'BasePart' then v.Transparency = 1 end
        end
    end
    table.insert(RWingWelds, weld)
    table.insert(PrimaryParts, cr)
end

for _, v in next, PrimaryParts do
    if v:IsA'BasePart' then v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0) end
end
Core1.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
Core2.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop() end
pcall(function() Char.Animate:Destroy() end)
pcall(function() Hum.Animator:Destroy() end)

-- ============================================================
-- Motor joints
-- ============================================================
local LS  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = LArm,  C0 = CF.N(-1.5*PlayerSize, 0.5*PlayerSize, 0), C1 = CF.N(0, .5*PlayerSize, 0)})
local RS  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = RArm,  C0 = CF.N( 1.5*PlayerSize, 0.5*PlayerSize, 0), C1 = CF.N(0, .5*PlayerSize, 0)})
local NK  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = Head,  C0 = CF.N(0, 1.5*PlayerSize, 0)})
local LH  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = LLeg,  C0 = CF.N(-.5*PlayerSize, -1*PlayerSize, 0), C1 = CF.N(0, 1*PlayerSize, 0)})
local RH  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = RLeg,  C0 = CF.N( .5*PlayerSize, -1*PlayerSize, 0), C1 = CF.N(0, 1*PlayerSize, 0)})
local RJ  = NewInstance('Motor', Char, {Part0 = Root,  Part1 = Torso})
local HW  = NewInstance('Motor', Char, {Part0 = Torso, Part1 = HaloHandle,  C0 = CF.N(0, 1.5, 1.5) * CF.A(M.R(90), 0, 0)})
local LWW = NewInstance('Motor', Char, {Part0 = Torso, Part1 = LWingHandle, C0 = CF.N(0, 0, 1.5)})
local RWW = NewInstance('Motor', Char, {Part0 = Torso, Part1 = RWingHandle, C0 = CF.N(0, 0, 1.5)})

local LSC0, RSC0, NKC0, LHC0, RHC0, RJC0 = LS.C0, RS.C0, NK.C0, LH.C0, RH.C0, RJ.C0

-- ============================================================
-- swait — no script.Heartbeat dependence
-- ============================================================
function swait(n)
    if n == 0 or n == nil then
        RunService.Stepped:Wait()
    else
        for _ = 0, n do RunService.Stepped:Wait() end
    end
end

-- ============================================================
-- Effect primitives
-- ============================================================
function Kill(whom)
    pcall(function()
        if GetTorso(whom) then Sound(GetTorso(whom), 62339698, .25, 2, false, true, true) end
        for _, v in next, whom:GetChildren() do
            if v:IsA'BasePart' then
                v.Parent = Effects
                v.CanCollide = false
                v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                v.Anchored = false
                local dustT = NewInstance("ParticleEmitter", v, {
                    Color = ColorSequence.new(Core2.Color),
                    LightEmission = 1,
                    Size = NumberSequence.new(.75, 0),
                    Texture = "rbxassetid://284205403",
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)},
                    Lifetime = NumberRange.new(1),
                    Rate = 250,
                    Acceleration = V3.N(0, 0, 0),
                    Speed = NumberRange.new(0),
                    Enabled = true,
                })
                v.Color = Core2.Color
                v.Material = Enum.Material.Neon
                NewInstance('BodyPosition', v, {
                    MaxForce = V3.N(150, 150, 150), D = 1000, P = 3000,
                    position = v.Position + V3.N(M.RNG(-5, 5), M.RNG(-5, 5), M.RNG(-5, 5)),
                })
                v.Transparency = .25
                coroutine.wrap(function()
                    for i = v.Transparency, 1, .01 do v.Transparency = i; swait() end
                    Sound(v, 1192402877, 1, 1, false, true, true)
                    v.Transparency = 1
                    dustT.Speed = NumberRange.new(1, 5)
                    dustT.Acceleration = V3.N(0, 10, 0)
                    dustT.Enabled = false
                    Debris:AddItem(v, 3)
                end)()
            end
        end
    end)
end

function NoobySphere(Lifetime, Speed, Type, Pos, StartSize, Inc, Color, Range, MeshId)
    local fxP = Part(Effects, Color, Enum.Material.Neon, V3.N(1, 1, 1), Pos + Pos.lookVector * (Range or 0), true, false)
    local fxM = Mesh(fxP, (MeshId and Enum.MeshType.FileMesh or Enum.MeshType.Sphere), (MeshId and "rbxassetid://"..MeshId or ""), "", StartSize, V3.N())
    if Mode == 6 or Mode == 4 or Mode == 696969 then fxP.Color = Core2.Color end
    local Scale = 1
    local speeder = Speed
    if Type == "Multiply" then Scale = 1 * Inc
    elseif Type == "Divide" then Scale = 1 / Inc end
    coroutine.wrap(function()
        for i = 0, 10/Lifetime, .1 do
            if Mode == 6 or Mode == 4 or Mode == 696969 then fxP.Color = Core2.Color end
            if Type == "Multiply" then Scale = Scale - 0.01 * Inc / Lifetime
            elseif Type == "Divide" then Scale = Scale - 0.01 / Inc * Lifetime end
            speeder = speeder - 0.01 * Speed * Lifetime
            fxP.CFrame = fxP.CFrame + fxP.CFrame.lookVector * speeder * Lifetime
            fxP.Transparency = fxP.Transparency + 0.01 * Lifetime
            fxM.Scale = fxM.Scale + Vector3.new(Scale * Lifetime, Scale * Lifetime, 0)
            if fxP.Transparency >= 1 then break end
            swait()
        end
        fxP:Destroy()
    end)()
end

function NoobySphere2(Lifetime, Type, Pos, StartSize, Inc, Color, MeshId, NotAffect)
    local fxP = Part(Effects, Color, Enum.Material.Neon, V3.N(1, 1, 1), Pos, true, false)
    local fxM = Mesh(fxP, (MeshId and Enum.MeshType.FileMesh or Enum.MeshType.Sphere), (MeshId and "rbxassetid://"..MeshId or ""), "", StartSize, V3.N())
    if not NotAffect and (Mode == 6 or Mode == 4 or Mode == 696969) then fxP.Color = Core2.Color end
    local Scale = 1
    if Type == "Multiply" then Scale = 1 * Inc
    elseif Type == "Divide" then Scale = 1 / Inc end
    coroutine.wrap(function()
        for _ = 0, 10/Lifetime, .1 do
            if not NotAffect and (Mode == 6 or Mode == 4 or Mode == 696969) then fxP.Color = Core2.Color end
            if Type == "Multiply" then Scale = Scale - 0.01 * Inc / Lifetime
            elseif Type == "Divide" then Scale = Scale - 0.01 / Inc * Lifetime end
            fxP.Transparency = fxP.Transparency + 0.01 * Lifetime
            fxM.Scale = fxM.Scale + Vector3.new(Scale * Lifetime, Scale * Lifetime, Scale * Lifetime)
            swait()
        end
        fxP:Destroy()
    end)()
    return fxP
end

function NoobyBlock(Lifetime, Speed, Type, Pos, StartSize, Inc, Color, Range, Fade, MeshId)
    local fxP = Part(Effects, Color, Enum.Material.Neon, V3.N(1, 1, 1), Pos + Pos.lookVector * Range, true, false)
    local fxM = Mesh(fxP, (MeshId and Enum.MeshType.FileMesh or Enum.MeshType.Brick), (MeshId and "rbxassetid://"..MeshId or ""), "", StartSize, V3.N())
    if Mode == 6 or Mode == 4 or Mode == 696969 then fxP.Color = Core2.Color end
    local Scale = 1
    local speeder = Speed
    if Type == "Multiply" then Scale = 1 * Inc
    elseif Type == "Divide" then Scale = 1 / Inc end
    coroutine.wrap(function()
        for i = 0, 10/Lifetime, .1 do
            if Mode == 6 or Mode == 4 or Mode == 696969 then fxP.Color = Core2.Color end
            if Type == "Multiply" then Scale = Scale - 0.01 * Inc / Lifetime
            elseif Type == "Divide" then Scale = Scale - 0.01 / Inc * Lifetime end
            if Fade then fxP.Transparency = i / (10/Lifetime) end
            speeder = speeder - 0.01 * Speed * Lifetime / 10
            fxP.CFrame = fxP.CFrame + fxP.CFrame.lookVector * speeder * Lifetime
            fxM.Scale = fxM.Scale - Vector3.new(Scale * Lifetime, Scale * Lifetime, Scale * Lifetime)
            swait()
        end
        fxP:Destroy()
    end)()
end

function Bezier(startpos, pos2, pos3, endpos, t)
    local A = startpos:Lerp(pos2, t)
    local B = pos2:Lerp(pos3, t)
    local C = pos3:Lerp(endpos, t)
    return A:Lerp(B, t):Lerp(B:Lerp(C, t), t)
end

function SphereFX(duration, color, scale, pos, endScale, increment)
    return OEffect{Effect = 'ResizeAndFade', Color = color, Size = scale,
        Mesh = {MeshType = Enum.MeshType.Sphere}, CFrame = pos,
        FXSettings = {EndSize = endScale, EndIsIncrement = increment}}
end
function BlastFX(duration, color, scale, pos, endScale, increment)
    return OEffect{Effect = 'ResizeAndFade', Color = color, Size = scale,
        Mesh = {MeshType = Enum.MeshType.FileMesh, MeshId = 'rbxassetid://20329976'}, CFrame = pos,
        FXSettings = {EndSize = endScale, EndIsIncrement = increment}}
end
function BlockFX(duration, color, scale, pos, endScale, increment)
    return OEffect{Effect = 'ResizeAndFade', Color = color, Size = scale,
        CFrame = pos, FXSettings = {EndSize = endScale, EndIsIncrement = increment}}
end

function ShootBullet(data)
    local Size = data.Size or V3.N(2, 2, 2)
    local Color = data.Color or BrickColor.new'Crimson'
    local StudsPerFrame = data.Speed or 10
    local Shape = data.Shape or 'Ball'
    local Frames = data.Frames or 160
    local Pos = data.Origin or Torso.CFrame
    local Direction = data.Direction or Mouse.Hit
    local Material = data.Material or Enum.Material.Neon
    local OnUpdate = data.Update
    local OnHit = data.HitFunction or function(_hit, pos)
        AOEDamage(pos, 0, {MinimumDamage = 5, MaximumDamage = 0})
        OEffect{Effect = 'ResizeAndFade', Color = Color, Size = V3.N(10, 10, 10),
            Material = Enum.Material.Neon, Mesh = {MeshType = Enum.MeshType.Sphere},
            CFrame = CF.N(pos), FXSettings = {EndSize = V3.N(.05, .05, .05), EndIsIncrement = true}}
        for _ = 1, 5 do
            local ang = CF.A(M.RRNG(-180, 180), M.RRNG(-180, 180), M.RRNG(-180, 180))
            OEffect{Effect = 'Fade', Frames = 65, Size = V3.N(5, 5, 10),
                CFrame = CF.N((CF.N(pos) * ang * CF.N(0, 0, -10)).p, pos),
                Mesh = {MeshType = Enum.MeshType.Sphere}, Material = Enum.Material.Neon, Color = Color,
                MoveDirection = (CF.N((CF.N(pos) * ang * CF.N(0, 0, -50)).p, pos)).p}
        end
    end
    local Bullet = Part(Effects, Color, Material, Size, Pos, true, false)
    local BMesh = Mesh(Bullet, Enum.MeshType.Brick, "", "", V3.N(1, 1, 1), V3.N())
    if Shape == 'Ball' then BMesh.MeshType = Enum.MeshType.Sphere
    elseif Shape == 'Head' then BMesh.MeshType = Enum.MeshType.Head
    elseif Shape == 'Cylinder' then BMesh.MeshType = Enum.MeshType.Cylinder end
    coroutine.wrap(function()
        for i = 1, Frames + 1 do
            if OnUpdate and typeof(OnUpdate) == 'function' then OnUpdate(Bullet, BMesh, i) end
            local hit, pos, norm, dist = CastRay(Bullet.CFrame.p,
                CF.N(Bullet.CFrame.p, Direction.p) * CF.N(0, 0, -StudsPerFrame).p, StudsPerFrame)
            if hit then OnHit(hit, pos, norm, dist); break
            else Bullet.CFrame = CF.N(Bullet.CFrame.p, Direction.p) * CF.N(0, 0, -StudsPerFrame) end
            swait()
        end
        Bullet:Destroy()
    end)()
end

function Puddle(hit, pos, norm, data)
    local material = data.Material or Enum.Material.SmoothPlastic
    local color = data.Color or BrickColor.new'Crimson'
    local size = data.Size or 1
    if hit.Name ~= 'BloodPuddle' then
        local p = NewInstance('Part', workspace, {
            Material = material, BrickColor = color, Size = V3.N(size, .1, size),
            CFrame = CF.N(pos, pos + norm) * CF.A(90 * M.P / 180, 0, 0),
            Anchored = true, CanCollide = false, Archivable = false, Locked = true, Name = 'BloodPuddle',
        })
        NewInstance('CylinderMesh', p, {Name = 'CylinderMesh'})
        BloodPuddles[p] = 0
    else
        local cyl = hit:FindFirstChild'CylinderMesh'
        if cyl then
            BloodPuddles[hit] = 0
            cyl.Scale = cyl.Scale + V3.N(size, 0, size)
            hit.Transparency = 0
        end
    end
end

function Droplet(data)
    local Size = data.Size or 1
    local Color = data.Color or BrickColor.new'Crimson'
    local StudsPerFrame = data.Speed or 1
    local Shape = data.Shape or 'Ball'
    local Frames = (data.Frames or 160) + 1
    local Pos = data.Origin or Root.CFrame
    local Direction = data.Direction or Root.CFrame.lookVector * 100000
    local Material = data.Material or Enum.Material.SmoothPlastic
    local Drop = data.Drop or .05
    local Bullet = Part(Effects, Color, Material, V3.N(Size, Size, Size), Pos, true, false)
    local BMesh = Mesh(Bullet, Enum.MeshType.Brick, "", "", V3.N(1, 1, 1), V3.N())
    if Shape == 'Ball' then BMesh.MeshType = Enum.MeshType.Sphere end
    coroutine.wrap(function()
        for i = 1, Frames do
            Pos = Pos * CF.N(0, -(Drop * i), 0)
            local hit, pos, norm = CastRay(Bullet.CFrame.p,
                CF.N(Pos.p, Direction) * CF.N(0, 0, -(StudsPerFrame * i)).p, StudsPerFrame)
            if hit and (not hit.Parent or (not hit.Parent:FindFirstChildOfClass'Humanoid' and not hit.Parent:IsA'Accessory')) then
                Puddle(hit, pos, norm, data); break
            else
                Bullet.CFrame = CF.N(Pos.p, Direction) * CF.N(0, 0, -(StudsPerFrame * i))
            end
            swait()
        end
        Bullet:Destroy()
    end)()
end

function Zap2(data)
    local Color = data.Color or BrickColor.new'Electric blue'
    local StartPos = data.Start or Torso.Position
    local EndPos = data.End or Mouse.Hit.p
    local SegLength = data.SegL or 2
    local Thicc = data.Thickness or 0.5
    local Fades = data.Fade or 45
    local Parent = data.Parent or Effects
    local MaxD = data.MaxDist or 200
    local Material = data.Material or Enum.Material.Neon
    local Raycasts = data.Raycasts or false
    local AddMesh = (data.Mesh == nil and true or data.Mesh)
    if (StartPos - EndPos).magnitude > MaxD then
        EndPos = CF.N(StartPos, EndPos) * CF.N(0, 0, -MaxD).p
    end
    local _, pos, _, dist = nil, EndPos, nil, (StartPos - EndPos).magnitude
    if Raycasts then
        _, pos, _, dist = CastRay(StartPos, EndPos, MaxD)
    end
    local segments = dist / SegLength
    local model = IN("Model", Parent)
    model.Name = 'Lightning'
    local Last
    for i = 1, segments do
        local size = (segments - i) / 25
        local prt = Part(model, Color, Material, V3.N(Thicc + size, SegLength, Thicc + size), CF.N(), true, false)
        if AddMesh then IN("CylinderMesh", prt) end
        if Last and math.floor(segments) == i then
            local mag = (Last.CFrame * CF.N(0, -SegLength/2, 0).p - EndPos).magnitude
            prt.Size = V3.N(Thicc + size, mag, Thicc + size)
            prt.CFrame = CF.N(Last.CFrame * CF.N(0, -SegLength/2, 0).p, EndPos) * CF.A(M.R(90), 0, 0) * CF.N(0, -mag/2, 0)
        elseif not Last then
            prt.CFrame = CF.N(StartPos, pos) * CF.A(M.R(90), 0, 0) * CF.N(0, -SegLength/2, 0)
        else
            prt.CFrame = CF.N(Last.CFrame * CF.N(0, -SegLength/2, 0).p,
                CF.N(pos) * CF.A(M.R(M.RNG(0, 360)), M.R(M.RNG(0, 360)), M.R(M.RNG(0, 360))) * CF.N(0, 0, SegLength/3 + (segments - i)).p
            ) * CF.A(M.R(90), 0, 0) * CF.N(0, -SegLength/2, 0)
        end
        Last = prt
    end
    if Fades > 0 then
        coroutine.wrap(function()
            for i = 1, Fades do
                for _, v in next, model:GetChildren() do
                    if v:IsA'BasePart' then v.Transparency = i/Fades end
                end
                swait()
            end
            model:Destroy()
        end)()
    else Debris:AddItem(model, .01) end
    return {End = (Last and Last.CFrame * CF.N(0, -Last.Size.Y/2, 0).p), Last = Last, Model = model}
end

function Tween(obj, props, time, easing, direction, repeats, backwards)
    local info = TweenInfo.new(time or .5, easing or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out, repeats or 0, backwards or false)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
end

function OEffect(data)
    local FX = data.Effect or 'ResizeAndFade'
    local Parent = data.Parent or Effects
    local Color = data.Color or C3.N(0, 0, 0)
    local Size = data.Size or V3.N(1, 1, 1)
    local MoveDir = data.MoveDirection
    local MeshData = data.Mesh
    local Frames = data.Frames or 45
    local Manual = data.Manual
    local Material = data.Material
    local CFra = data.CFrame or Torso.CFrame
    local Settings = data.FXSettings or {}
    local RotInc = data.RotInc or {0, 0, 0}
    if typeof(RotInc) == 'number' then RotInc = {RotInc, RotInc, RotInc} end
    local Prt, Msh
    coroutine.wrap(function()
        if Manual and typeof(Manual) == 'Instance' and Manual:IsA'BasePart' then
            Prt = Manual
        else
            Prt = Part(Parent, Color, Material, Size, CFra, true, false)
        end
        if typeof(MeshData) == 'table' then
            Msh = Mesh(Prt, MeshData.MeshType, MeshData.MeshId, MeshData.TextureId, MeshData.Scale, MeshData.Offset)
        end
        local grow = Size - (Settings.EndSize or (Msh and Msh.Scale or Size) / 2)
        if FX ~= 'Arc' then
            for Frame = 1, Frames do
                if FX == "Fade" then
                    Prt.Transparency = Frame/Frames
                elseif FX == "ResizeAndFade" then
                    if Settings.EndSize then
                        if Settings.EndIsIncrement then
                            if Msh then Msh.Scale = Msh.Scale + Settings.EndSize
                            else Prt.Size = Prt.Size + Settings.EndSize end
                        else
                            if Msh then Msh.Scale = Msh.Scale - grow/Frames
                            else Prt.Size = Prt.Size - grow/Frames end
                        end
                    end
                    Prt.Transparency = Frame/Frames
                end
                if Settings.RandomizeCFrame then
                    Prt.CFrame = Prt.CFrame * CF.A(M.RRNG(-360, 360), M.RRNG(-360, 360), M.RRNG(-360, 360))
                else
                    Prt.CFrame = Prt.CFrame * CF.A(unpack(RotInc))
                end
                if MoveDir then
                    local orientation = Prt.Orientation
                    Prt.CFrame = CF.N(Prt.Position, MoveDir) * CF.N(0, 0, -(CFra.p - MoveDir).magnitude/Frames)
                    Prt.Orientation = orientation
                end
                swait()
            end
            Prt:Destroy()
        else
            local start = Settings.Start
            local endP = Settings.End
            if not endP and Settings.Home then endP = Settings.Home.CFrame end
            if start and endP then
                local third = Settings.Third or start:Lerp(endP, 0.25) * CF.N(M.RNG(-25, 25), M.RNG(0, 25), M.RNG(-25, 25))
                local fourth = Settings.Fourth or start:Lerp(endP, 0.75) * CF.N(M.RNG(-25, 25), M.RNG(0, 25), M.RNG(-25, 25))
                for Frame = 0, 1, (Settings.Speed or 0.01) do
                    if Settings.Home then endP = Settings.Home.CFrame end
                    Prt.CFrame = Bezier(start, third, fourth, endP, Frame)
                end
                if Settings.RemoveOnGoal then Prt:Destroy() end
            else
                Prt:Destroy()
            end
        end
    end)()
    return Prt, Msh
end

function SoulSteal(whom)
    local torso = (whom:FindFirstChild'Head' or whom:FindFirstChild'Torso' or whom:FindFirstChild'UpperTorso' or whom:FindFirstChild'LowerTorso' or whom:FindFirstChild'HumanoidRootPart')
    if torso and torso:IsA'BasePart' then
        local Model = Instance.new("Model", Effects)
        Model.Name = whom.Name .. "'s Soul"
        local Soul = Part(Model, BrickColor.new'Black', 'Glass', V3.N(.5, .5, .5), torso.CFrame, true, false)
        Soul.Name = 'Head'
        NewInstance("Humanoid", Model, {Health = 0, MaxHealth = 0})
        OEffect{Effect = "Arc", Manual = Soul,
            FXSettings = {Start = torso.CFrame, Home = Torso, RemoveOnGoal = true}}
        local lastPoint = Soul.CFrame.p
        for _ = 0, 1, 0.01 do
            local point = CFrame.new(lastPoint, Soul.Position) * CFrame.Angles(-math.pi/2, 0, 0)
            local mag = (lastPoint - Soul.Position).magnitude
            OEffect{Effect = "Fade", CFrame = point * CF.N(0, mag/2, 0),
                Size = V3.N(.5, mag + .5, .5), Color = Soul.BrickColor}
            lastPoint = Soul.CFrame.p
            swait()
        end
        for _ = 1, 5 do
            OEffect{Effect = "Fade", Color = BrickColor.new'Black',
                MoveDirection = (Torso.CFrame * CFrame.new(M.RNG(-40, 40), M.RNG(-40, 40), M.RNG(-40, 40))).p}
        end
    end
end

-- ============================================================
-- Utility
-- ============================================================
function CastRay(startPos, endPos, range, ignoreList)
    local ray = Ray.new(startPos, (endPos - startPos).unit * range)
    local part, pos, norm = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList or {Char}, false, true)
    return part, pos, norm, (pos and (startPos - pos).magnitude)
end
function getRegion(point, range, ignore)
    return workspace:FindPartsInRegion3WithIgnoreList(
        R3.N(point - V3.N(1, 1, 1) * range/2, point + V3.N(1, 1, 1) * range/2), ignore, 100)
end
function clerp(startCF, endCF, alpha) return startCF:Lerp(endCF, alpha) end
function GetTorso(char)
    return char:FindFirstChild'Torso' or char:FindFirstChild'UpperTorso' or char:FindFirstChild'LowerTorso' or char:FindFirstChild'HumanoidRootPart'
end

function ShowDamage(Pos, Text, Time, Color)
    coroutine.wrap(function()
        local Rate = 1/Frame_Speed
        Pos = Pos or Vector3.new()
        Text = Text or ""
        Time = Time or 2
        Color = Color or Color3.new(1, 0, 1)
        local ep = NewInstance("Part", Effects, {
            Material = Enum.Material.SmoothPlastic, Reflectance = 0, Transparency = 1,
            BrickColor = BrickColor.new(Color), Name = "Effect",
            Size = Vector3.new(0, 0, 0), Anchored = true, CFrame = CF.N(Pos),
        })
        local bb = NewInstance("BillboardGui", ep, {Size = UDim2.new(1.25, 0, 1.25, 0), Adornee = ep})
        local tl = NewInstance("TextLabel", bb, {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = Text,
            Font = Enum.Font.Bodoni, TextColor3 = Color, TextStrokeColor3 = Color3.new(0, 0, 0),
            TextStrokeTransparency = 0, TextScaled = true,
        })
        Debris:AddItem(ep, Time)
        ep.Parent = workspace
        task.delay(0, function()
            Tween(ep, {CFrame = CF.N(Pos) * CF.N(0, 3, 0)}, Time, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
            local Frames = Time/Rate
            for F = 1, Frames do
                swait()
                local p = F/Frames
                tl.TextTransparency = p
                tl.TextStrokeTransparency = p
            end
            if ep and ep.Parent then ep:Destroy() end
        end)
    end)()
end

function DealDamage(data)
    local Who = data.Who
    local MinDam = data.MinimumDamage or 15
    local MaxDam = data.MaximumDamage or 30
    local MaxHP = data.MaxHP or 1e5
    local DB = data.Debounce or .2
    local CritData = data.Crit or {}
    local CritChance = CritData.Chance or 0
    local CritMultiplier = CritData.Multiplier or 1
    local DamageEffects = data.DamageFX or {}
    local DamageType = DamageEffects.Type or "Normal"
    local DeathFunction = DamageEffects.DeathFunction
    if not Who then return end
    local Humanoid = Who:FindFirstChildOfClass'Humanoid'
    local DoneDamage = M.RNG(MinDam, MaxDam) * (M.RNG(1, 100) <= CritChance and CritMultiplier or 1)
    local canHit = true
    if Humanoid then
        for i, p in pairs(Hit) do
            if p[1] == Humanoid then
                if time() - p[2] <= DB then canHit = false else Hit[i] = nil end
            end
        end
        if canHit then
            table.insert(Hit, {Humanoid, time()})
            local HitTorso = GetTorso(Who)
            local player = Plrs:GetPlayerFromCharacter(Who)
            if not player or (not DontAttackPlayers and player.UserId ~= 5719877 and player.UserId ~= 61573184 and player.UserId ~= 19081129) then
                if Humanoid.MaxHealth >= MaxHP and Humanoid.Health > 0 then
                    Hits = math.min(Hits + 1, MaxHits)
                    HitTime = time() + 1
                    if DeathFunction then DeathFunction(Who, Humanoid) end
                else
                    local c = Instance.new("ObjectValue", Hum)
                    c.Name = "creator"
                    c.Value = Plr
                    Debris:AddItem(c, 0.35)
                    if Humanoid.Health > 0 then
                        Hits = math.min(Hits + 1, MaxHits)
                        HitTime = time() + 1
                        if Mode == 9 and not Radioactive[Who] then
                            Radioactive[Who] = {0, M.RNG(time() + 4, time() + 14)}
                        end
                        if Who:FindFirstChild'Head' then
                            ShowDamage((Who.Head.CFrame * CF.N(0, 0, Who.Head.Size.Z/2).p + V3.N(0, 1.5, 0) + V3.N(M.RNG(-2, 2), 0, M.RNG(-2, 2))),
                                math.floor(DoneDamage), 1.5, Core2.Color)
                        end
                        if Humanoid.Health - DoneDamage <= 0 and DeathFunction then DeathFunction(Who, Humanoid) end
                    end
                    if DamageType == 'Knockback' and HitTorso then
                        local up = DamageEffects.KnockUp or 25
                        local back = DamageEffects.KnockBack or 25
                        local origin = DamageEffects.Origin or Root
                        local decay = DamageEffects.Decay or .5
                        local bv = Instance.new("BodyVelocity", HitTorso)
                        bv.P = 20000
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Velocity = Vector3.new(0, up, 0) + (origin.CFrame.lookVector * back)
                        Debris:AddItem(bv, decay)
                    end
                end
            end
        end
    end
end

function AOEDamage(where, range, options)
    local hit = {}
    for _, v in next, getRegion(where, range, {Char}) do
        if v.Parent and v.Parent:FindFirstChildOfClass'Humanoid' and not hit[v.Parent] then
            local callTable = {Who = v.Parent}
            hit[v.Parent] = true
            for k, val in next, options do callTable[k] = val end
            DealDamage(callTable)
        end
    end
    return hit
end

function Chat(txt_, color)
    coroutine.wrap(function()
        if Char:FindFirstChild'ChatGUI' then Char.ChatGUI:Destroy() end
        local bbg = NewInstance("BillboardGui", Char, {Name = 'ChatGUI', Size = UDim2.new(0, 100, 0, 40), StudsOffset = V3.N(0, 2, 0), Adornee = Head})
        local t = NewInstance("TextLabel", bbg, {
            Text = "", BackgroundTransparency = 1, TextColor3 = color,
            BorderSizePixel = 0, Font = Enum.Font.Antique, TextSize = 50,
            TextStrokeTransparency = 1, Size = UDim2.new(1, 0, .5, 0),
        })
        local snd = Sound(Head, 418252437, M.RNG(9, 11)/10, 3, false, false, true)
        for i = 1, #txt_ do
            task.delay(i/25, function()
                snd.Pitch = M.RNG(9, 11)/10
                snd.Volume = 3
                snd.Parent = Effects
                snd:Play()
                t.Text = txt_:sub(1, i)
            end)
        end
        task.delay((#txt_/25) + 2.5, function()
            for i = 0, 1, .025 do
                t.TextTransparency = i
                t.Rotation = M.RNG(-25, 25)
                t.Position = UDim2.new(0, M.RNG(-15, 15), 0, M.RNG(-15, 15))
                swait()
            end
            bbg:Destroy()
        end)
    end)()
end

-- ============================================================
-- Combat abilities
-- ============================================================
function ClickGlitch()
    Attack = true
    NeutralAnims = false
    local oWS = WalkSpeed
    WalkSpeed = 0
    Hum.JumpPower = 0
    Hum.AutoRotate = false
    Root.CFrame = CF.N(Root.CFrame.p, CF.N(Mouse.Hit.x, Root.CFrame.y, Mouse.Hit.z).p)
    for _ = 0, 2, 0.1 do
        swait()
        local A = .3
        Root.CFrame = CF.N(Root.CFrame.p, CF.N(Mouse.Hit.x, Root.CFrame.y, Mouse.Hit.z).p)
        RJ.C0 = clerp(RJ.C0, CFrame.new(-0.00417825999, 0.00628786907, -0.00260206894, 0.513858557, -0.00539401267, -0.857858002, 1.84496116e-06, 0.99998033, -0.00628653914, 0.85787499, 0.00322880922, 0.513848424), A)
        LH.C0 = clerp(LH.C0, CFrame.new(-0.496490777, -0.990816116, 0.0216251202, 0.500402868, 0, 0.865792811, -0.00544379698, 0.99998033, 0.00314635527, -0.865775645, -0.00628764462, 0.500392973), A)
        RH.C0 = clerp(RH.C0, CFrame.new(0.49852562, -0.990978837, 0.0154569345, 0.500402868, 0, 0.865792811, -0.00544379698, 0.99998033, 0.00314635527, -0.865775645, -0.00628764462, 0.500392973), A)
        LS.C0 = clerp(LS.C0, CFrame.new(-1.30906916, 0.822547674, -0.226739705, -0.481323838, 0.719669759, -0.500402868, -0.832959116, -0.55330795, 0.00544379698, -0.272959113, 0.419435322, 0.865775645), A)
        RS.C0 = clerp(RS.C0, CFrame.new(1.35554826, 0.564801514, -0.116690002, 0.84398663, -0.312275827, 0.436085641, 0.311970115, 0.94716835, 0.074478887, -0.43630439, 0.0731864721, 0.896817923), A)
        NK.C0 = clerp(NK.C0, CFrame.new(-7.85058364e-06, 1.49894369, -0.0143952277, 0.500402868, 0, 0.865792811, -0.00544379698, 0.99998033, 0.00314635527, -0.865775645, -0.00628764462, 0.500392973), A)
    end
    Sound(LArm, 217767125, M.RNG(75, 125)/100, 10, false, true, true)
    coroutine.wrap(function()
        local MousePos = Mouse.Hit
        local effect = Part(Effects, Core2.Color, Enum.Material.Neon, V3.N(2.5, 2.5, 2.5), MousePos, true, false)
        for _ = 0, 6, .1 do
            effect.Color = Core2.Color
            MousePos = MousePos * CF.N(M.RNG(-15, 15)/100, M.RNG(-15, 15)/100, M.RNG(-15, 15)/100)
            effect.CFrame = MousePos * CF.A(M.RRNG(0, 360), M.RRNG(0, 360), M.RRNG(0, 360))
            effect.Size = V3.N(2.5, 2.5, 2.5) + V3.N(M.RNG(-150, 150)/100, M.RNG(-150, 150)/100, M.RNG(-150, 150)/100)
            swait()
        end
        AOEDamage(MousePos.p, 30, {MinimumDamage = 30, MaximumDamage = 75})
        for i = 0, 3, .1 do
            effect.Color = Core2.Color
            effect.CFrame = MousePos * CF.A(M.RRNG(0, 360), M.RRNG(0, 360), M.RRNG(0, 360))
            effect.Size = effect.Size + V3.N(1, 1, 1)
            effect.Transparency = i/3
            swait()
        end
        effect:Destroy()
    end)()
    WalkSpeed = oWS
    Hum.JumpPower = 50
    Hum.AutoRotate = true
    Attack = false
    NeutralAnims = true
end

function PureBomb()
    Attack = true
    NeutralAnims = false
    local orb = Part(Effects, BrickColor.new'Baby blue', Enum.Material.Neon, V3.N(1, 1, 1), RArm.CFrame * CF.N(0, -1, 0), true, false)
    local orbM = Mesh(orb, Enum.MeshType.Sphere, "", "", V3.N(.1, .1, .1))
    local Scale = 0.1
    Hum.AutoRotate = false
    Sound(orb, 136007472, 1, 5, false, true, true)
    for _ = 0, 10, 0.1 do
        Scale = Scale + .05
        orb.CFrame = RArm.CFrame * CF.N(0, -0.5 - (Scale/1.5), 0)
        Root.CFrame = CF.N(Root.CFrame.p, CF.N(Mouse.Hit.x, Root.CFrame.y, Mouse.Hit.z).p)
        orbM.Scale = V3.N(Scale, Scale, Scale)
        NoobySphere(4, -.1, 'Multiply', orb.CFrame * CF.A(M.RRNG(-180, 180), M.RRNG(-180, 180), M.RRNG(-180, 180)), V3.N(1, 1, 1), 0, BrickColor.new'Baby blue', 5)
        swait()
    end
    Sound(Root, 260433768, 1, 5.25, false, true, true)
    ShootBullet{
        Size = V3.N(Scale, Scale, Scale), Shape = 'Ball', Frames = 320, Origin = orb.CFrame,
        Speed = 5, Color = BrickColor.new'Baby blue',
        HitFunction = function(_, pos)
            SoundPart(151304356, 1, 5.25, false, true, true, CF.N(pos))
            AOEDamage(pos, Scale * 4, {MinimumDamage = 25, MaximumDamage = 60})
            OEffect{Effect = 'ResizeAndFade', Color = BrickColor.new'Baby blue',
                Size = V3.N(Scale * 2, Scale * 2, Scale * 2), Material = Enum.Material.Neon,
                Mesh = {MeshType = Enum.MeshType.Sphere}, CFrame = CF.N(pos),
                FXSettings = {EndSize = V3.N(.1, .1, .1), EndIsIncrement = true}}
            for _ = 0, 49 do
                NoobyBlock(1, M.RNG(1, 10)/2, "Multiply",
                    CF.N(pos) * CF.A(M.RRNG(-360, 360), M.RRNG(-360, 360), M.RRNG(-360, 360)),
                    V3.N(4, 4, 4), 0.08, BrickColor.new('Pastel light blue'), 0, true)
            end
        end,
    }
    orb:Destroy()
    Hum.AutoRotate = true
    Attack = false
    NeutralAnims = true
end

function Aeroplane()
    Attack = true
    NeutralAnims = false
    NoobySphere2(3, 'Multiply', Root.CFrame, V3.N(2, 2, 2), .5, BrickColor.new'White')
    local rad = 0
    for _ = 0, 3, 0.1 do
        AOEDamage(Root.CFrame.p, 4, {MinimumDamage = 15, MaximumDamage = 30})
        swait()
        Root.Velocity = Root.CFrame.lookVector * (350)
    end
    for _ = 0, 18, 0.1 do
        AOEDamage(Root.CFrame.p, 4, {MinimumDamage = 15, MaximumDamage = 30})
        swait()
        rad = rad + .1
        Root.Velocity = Root.CFrame.lookVector * 150
    end
    Attack = false
    NeutralAnims = true
end

function Shrek()
    Attack = true
    NeutralAnims = false
    local oWS = WalkSpeed
    WalkSpeed = 0
    Sound(Head, 368794903, 1.2, 10, false, true, true)
    local wo = IN("Model", Effects)
    for i = 1, 3 do
        local wat = 12.5 + (i * 2)
        local screamPart = Part(wo, BrickColor.new'Pearl', Enum.Material.Neon, V3.N(1, 1, 1), Head.CFrame, false, false)
        screamPart.Transparency = .6 + (i/10)
        Mesh(screamPart, Enum.MeshType.Sphere, "", "", V3.N(wat, wat, wat))
        Weld(screamPart, Torso)
    end
    for _ = 0, 8, 0.1 do
        swait()
        AOEDamage(Torso.CFrame.p, 20, {MinimumDamage = 5, MaximumDamage = 10})
    end
    WalkSpeed = oWS
    Attack = false
    NeutralAnims = true
end

function MurderKnife()
    local Sai = New("Model", Char, "Sai", {})
    local Handle = New("Part", Sai, "Handle", {
        Transparency = 1, Size = Vector3.new(0.0500000007, 0.0500000007, 0.0500000007),
        CFrame = CFrame.new(-13.6449995, 31.3018703, 19.1356354), CanCollide = false,
        BottomSurface = Enum.SurfaceType.Smooth, TopSurface = Enum.SurfaceType.Smooth,
    })
    local HW_ = New("Weld", Handle, 'Weld', {Part0 = RArm, Part1 = Handle, C0 = CF.N(0, -1, 0) * CF.A(M.R(-90), 0, 0)})
    local BladenShit = New("Part", Sai, "BladenShit", {
        Transparency = 1, Size = Vector3.new(0.0500000007, 0.0500000007, 0.0500000007),
        CFrame = CFrame.new(-13.6450005, 32.2849274, 19.1353073), CanCollide = false,
        BottomSurface = Enum.SurfaceType.Smooth, TopSurface = Enum.SurfaceType.Smooth,
    })
    New("Motor", BladenShit, "mot", {Part0 = BladenShit, Part1 = Handle,
        C1 = CFrame.new(-9.53674316e-07, 0.983057022, -0.000328063965)})
    local Hitbox = New("Part", Sai, "Hitbox", {
        Transparency = 1, Size = Vector3.new(0.0500000007, 1.74999952, 0.340000063),
        CFrame = CFrame.new(-13.6450005, 33.2651939, 19.1278477), CanCollide = false,
        BottomSurface = Enum.SurfaceType.Smooth, TopSurface = Enum.SurfaceType.Smooth,
    })
    New("Motor", Hitbox, "mot", {Part0 = Hitbox, Part1 = Handle,
        C1 = CFrame.new(-9.53674316e-07, 1.96332359, -0.00778770447)})
    return HW_, Sai
end

function DoMurder(target)
    if not target then return end
    local torso = GetTorso(target)
    local hum = target:FindFirstChildOfClass'Humanoid'
    local hed = target:FindFirstChild'Head'
    if not (torso and hum and hum.Health > 0 and hed) then return end
    local oWS = WalkSpeed
    local oPar = target.Parent
    local originalpos = Root.CFrame
    WalkSpeed = 0
    Hum.JumpPower = 0
    Attack = true
    NeutralAnims = false
    Root.Anchored = true
    torso.Anchored = true
    target.Parent = Char
    Hum.AutoRotate = false
    for _ = 0, 9 do
        NoobySphere(3, .25, 'Multiply',
            Root.CFrame * CF.A(M.RRNG(-360, 360), M.RRNG(-360, 360), M.RRNG(-360, 360)),
            V3.N(1, 1, 10), -.01, Core2.BrickColor)
    end
    Root.CFrame = torso.CFrame * CF.N(0, 0, 1.89)
    local HW_, knife = MurderKnife()
    Sound(Core2, 847061203, 1, 2.5, false, true, true)
    for _ = 0, 3, 0.1 do
        swait()
        local A = .2
        RJ.C0 = RJ.C0:Lerp(CFrame.new(0, 0.00628662109, 0), A)
        LH.C0 = LH.C0:Lerp(CFrame.new(-0.496665925, -0.990936279, 0.00762737356), A)
        RH.C0 = RH.C0:Lerp(CFrame.new(0.498333007, -0.991060257, 0.0170113072), A)
        LS.C0 = LS.C0:Lerp(CFrame.new(-1.28516543, 0.724190474, -0.474189818, 0.972499251, 0.184650362, -0.141949132, -0.134552032, -0.0520570427, -0.989538252, -0.190108046, 0.981424689, -0.0257803537), A)
        RS.C0 = RS.C0:Lerp(CFrame.new(1.14291549, 0.806114435, 0.620829105, 0.806192696, 0.353628874, 0.474341691, 0.13779296, -0.891899109, 0.430730879, 0.575383842, -0.281891108, -0.767770052), A)
        NK.C0 = NK.C0:Lerp(CFrame.new(8.77380371e-05, 1.49900436, -0.00497436523), A)
    end
    Sound(torso, 429400881, 1.2, 4, false, true, true)
    target.Parent = oPar
    local hum2 = target:FindFirstChildOfClass'Humanoid'
    if hum2 then hum2.Health = hum2.Health - hum2.MaxHealth/3 end
    for _ = 0, 3, 0.1 do
        swait()
        local A = .3
        RJ.C0 = RJ.C0:Lerp(CFrame.new(-0.00238382886, 0.00628662109, -0.00060180336, 0.896098733, 0, -0.443854868, 0, 1, 0, 0.443854868, 0, 0.896098733), A)
        LH.C0 = LH.C0:Lerp(CFrame.new(-0.496673644, -0.990932465, 0.00768280122), A)
        RH.C0 = RH.C0:Lerp(CFrame.new(0.498329222, -0.991056442, 0.017009737), A)
        LS.C0 = LS.C0:Lerp(CFrame.new(-1.17789793, 0.575393677, -0.0879677832, 0.584696472, 0.754816532, -0.297291398, -0.179923102, -0.236678019, -0.95478332, -0.791048646, 0.61174798, -0.00257586688), A)
        RS.C0 = RS.C0:Lerp(CFrame.new(1.05549359, 0.484450161, -0.690232515, 0.71294421, 0.397806346, -0.577460706, -0.424427927, -0.410723001, -0.806949615, -0.558185995, 0.820400417, -0.123982459), A)
        NK.C0 = NK.C0:Lerp(CFrame.new(0.000124273589, 1.49900436, -0.00493157003, 0.896098733, 0, 0.443854868, 0, 1, 0, -0.443854868, 0, 0.896098733), A)
    end
    Sound(torso, 429400881, .7, 4, false, true, true)
    if hum2 then hum2.Health = hum2.Health - hum2.MaxHealth/3 end
    coroutine.wrap(function()
        local hum3 = target:FindFirstChildOfClass'Humanoid'
        if hum3 then
            repeat swait(); hum3.Health = hum3.Health - .5 until hum3.Health <= 1
            Kill(target)
            knife:Destroy()
        end
    end)()
    WalkSpeed = oWS
    Hum.JumpPower = 50
    Hum.AutoRotate = true
    Root.CFrame = originalpos
    Root.Anchored = false
    torso.Anchored = false
    Attack = false
    NeutralAnims = true
end

function MobileMurder()
    Attack = true
    local oWS = WalkSpeed
    WalkSpeed = 0
    local what
    what = Mouse.Button1Down:Connect(function()
        what:Disconnect()
        local target = (Mouse.Target and Mouse.Target.Parent)
        if target and GetTorso(target) then
            WalkSpeed = oWS
            DoMurder(target)
        else
            WalkSpeed = oWS
            Attack = false
        end
    end)
end

function NeckSnap(target)
    if not target then return end
    local torso = GetTorso(target)
    local hum = target:FindFirstChildOfClass'Humanoid'
    local hed = target:FindFirstChild'Head'
    if not (torso and hum and hum.Health > 0 and hed) then return end
    local oWS = WalkSpeed
    local oPar = target.Parent
    WalkSpeed = 0
    Hum.JumpPower = 0
    Attack = true
    NeutralAnims = false
    Root.Anchored = true
    torso.Anchored = true
    target.Parent = Char
    Hum.AutoRotate = false
    Root.CFrame = torso.CFrame * CF.N(-0.54454422, 0, 0.987496376)
    for _, v in next, torso:GetChildren() do
        if v:IsA'JointInstance' and (v.Part0 == hed or v.Part1 == hed) then v:Destroy() end
    end
    local weld = NewInstance('Motor', torso, {Part0 = hed, Part1 = torso, C0 = CF.N(0, -1.5, 0)})
    for _ = 0, 1, 0.1 do swait() end
    Sound(hed, 1093102664, 1, 5, false, true, true)
    for _ = 0, 1.3, 0.1 do
        swait()
        weld.C0 = weld.C0:Lerp(CF.N(0, -1.5, 0) * CF.A(0, M.R(-90), 0), .3)
    end
    target.Parent = oPar
    WalkSpeed = oWS
    Hum.JumpPower = 50
    Hum.AutoRotate = true
    Root.Anchored = false
    torso.Anchored = false
    Attack = false
    NeutralAnims = true
end

function MobileNeckSnap()
    Attack = true
    local oWS = WalkSpeed
    WalkSpeed = 0
    local what
    what = Mouse.Button1Down:Connect(function()
        what:Disconnect()
        local target = (Mouse.Target and Mouse.Target.Parent)
        if target and GetTorso(target) then
            WalkSpeed = oWS
            NeckSnap(target)
        else
            WalkSpeed = oWS
            Attack = false
        end
    end)
end

function SongSmash()
    Attack = true
    NeutralAnims = false
    for _ = 0, 3, 0.1 do
        swait()
        NoobySphere(5, .3, "Multiply",
            LArm.CFrame * CF.N(0, -1, 0) * CF.A(M.RRNG(-180, 180), M.RRNG(-180, 180), M.RRNG(-180, 180)),
            V3.N(.1, .1, .1), 0, Core2.Color, 0, 1088207)
    end
    AOEDamage(Root.CFrame.p, 110, {MinimumDamage = pl/15, MaximumDamage = pl/5})
    NoobySphere2(3, "Multiply", Root.CFrame * CF.N(0, -2.9, 0), V3.N(110, 0.1, 110), 0.01, Core2.Color)
    for _ = 1, 20 do
        NoobySphere(3, 0.5, "Multiply",
            Root.CFrame * CF.N(M.RNG(-42.5, 42.5), -5, M.RNG(-42.5, 42.5)) * CF.A(M.R(90) + M.RRNG(-45, 45), M.RRNG(-45, 45), M.RRNG(-45, 45)),
            V3.N(.5, .5, .5), 0, Core2.Color, 0, 1088207)
    end
    Attack = false
    NeutralAnims = true
end

function AttackOne()
    Attack = true
    NeutralAnims = false
    for _ = 0, .7, 0.1 do swait() end
    Sound(RArm, 200632136, 1.1, 5, false, true, true)
    for _ = 0, .9, 0.1 do
        swait()
        AOEDamage(RArm.CFrame.p, 2, {MinimumDamage = 10, MaximumDamage = 30})
    end
    Combo = 2
    Attack = false
    NeutralAnims = true
end

function AttackTwo()
    Attack = true
    NeutralAnims = false
    for _ = 0, 1, 0.1 do swait() end
    Sound(LArm, 200632136, .9, 5, false, true, true)
    for _ = 0, 1, 0.1 do
        swait()
        AOEDamage(LArm.CFrame.p, 2, {MinimumDamage = 10, MaximumDamage = 30})
    end
    Combo = 3
    Attack = false
    NeutralAnims = true
end

function AttackThree()
    Attack = true
    NeutralAnims = false
    for _ = 0, 1, 0.1 do swait() end
    local a = 2
    coroutine.wrap(function()
        for i = 5, 45, 10 do
            local hite = Instance.new("Part", Char)
            hite.Anchored = true
            hite.CanCollide = false
            hite.Material = "Neon"
            hite.Size = V3.N(1, 1, 1)
            hite.Transparency = 1
            hite.CFrame = (Root.CFrame + Root.CFrame.lookVector) * CF.A(0, M.R(90 + (a * 45)), 0) * CF.N(0, 0, i)
            CamShakeAOE(hite.CFrame.p, 10, 30, 250)
            NoobySphere2(3, 'Multiply', hite.CFrame, V3.N(0, 0, 0), .15, Core2.Color)
            NoobySphere2(6, 'Multiply', hite.CFrame, V3.N(0, 0, 0), .3, Core2.Color)
            AOEDamage(hite.CFrame.p, 10, {MinimumDamage = 25, MaximumDamage = 45})
            Sound(hite, 183763506, 1, 5, false, true, true)
            Debris:AddItem(hite, 2)
            swait()
        end
    end)()
    Combo = 1
    Attack = false
    NeutralAnims = true
end

-- ============================================================
-- Modes
-- ============================================================
function MurderMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Black' end end
    for _, v in next, RWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 1; v.BrickColor = BrickColor.new'Black' end end
    for _, v in next, Halo:GetChildren() do if v:IsA'BasePart' then v.Material = Enum.Material.Neon; v.BrickColor = BrickColor.new'Black' end end
    pcall(function() Char.ReaperShadowHead.Eye1.Color = C3.N(1, 0, 0) end)
    pcall(function() Char.ReaperShadowHead.Eye2.Color = C3.N(1, 0, 0) end)
    WalkSpeed = 16
    Mode = 1
    Core2.BrickColor = BrickColor.new'Black'
    Core2.Material = Enum.Material.Neon
    RecolorTextAndRename("Murder", Color3.new(1, 0, 0), Color3.new(0, 0, 0))
    Sound(Root, "206082327", 1, 2.5, false, true, true)
end

function PureMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Pastel Blue' end end
    WalkSpeed = 16
    pcall(function() Char.ReaperShadowHead.Eye1.Color = C3.N(0, 1, 1) end)
    pcall(function() Char.ReaperShadowHead.Eye2.Color = C3.N(0, 1, 1) end)
    RecolorTextAndRename("Clarity", C3.N(1, 1, 1), BrickColor.new'Pastel Blue'.Color)
    MusicID = 1539245059
    Pitch = 1
    Mode = 2
    Core2.BrickColor = BrickColor.new'Pastel Blue'
    Core2.Material = Enum.Material.Neon
end

function GlitchMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.DiamondPlate; v.Transparency = 0; v.BrickColor = BrickColor.new'White' end end
    WalkSpeed = 16
    pcall(function() Char.ReaperShadowHead.Eye1.Color = C3.N(1, 1, 1) end)
    pcall(function() Char.ReaperShadowHead.Eye2.Color = C3.N(1, 1, 1) end)
    RecolorTextAndRename("Glitchy", C3.N(1, 1, 1), C3.N(1, 1, 1))
    MusicID = 1470848774
    Pitch = .93
    Mode = 3
    Core2.BrickColor = BrickColor.new'Dark stone grey'
    Core2.Material = Enum.Material.DiamondPlate
end

function StressMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = .25; v.BrickColor = BrickColor.new'Crimson' end end
    WalkSpeed = 14
    RecolorTextAndRename("Stress", C3.N(.6, 0, 0), C3.N(0, 0, 0))
    MusicID = 614032233
    Pitch = 1
    Mode = 4
    Core2.BrickColor = BrickColor.new'Black'
    Core2.Material = Enum.Material.Neon
end

function JusticeMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Institutional white' end end
    WalkSpeed = 50
    RecolorTextAndRename("Justice", C3.N(1, 1, 1), C3.N(0, 0, 0))
    MusicID = 1102271169
    Pitch = 1
    Mode = 5
    Core2.BrickColor = BrickColor.new'White'
    Core2.Material = Enum.Material.Neon
end

function IceMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Pastel light blue' end end
    WalkSpeed = 8
    RecolorTextAndRename("SubZero", C3.N(0, 1, 1), C3.N(1, 1, 1))
    MusicID = 144121562
    Pitch = 1
    Mode = 7
    Core2.BrickColor = BrickColor.new'Pastel light blue'
    Core2.Material = Enum.Material.Neon
end

function LoveMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Pink' end end
    WalkSpeed = 16
    RecolorTextAndRename("Love", BrickColor.new'Pink'.Color, C3.N(1, 1, 1))
    MusicID = 1030177093
    Pitch = 1
    Mode = 8
    Core2.BrickColor = BrickColor.new'Pink'
    Core2.Material = Enum.Material.Neon
end

function VisMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Institutional white' end end
    WalkSpeed = 16
    RecolorTextAndRename("Visualiser", C3.N(1, 1, 1), C3.N(0, 0, 0))
    MusicID = VisSong
    Pitch = 1
    Mode = 6
    Core2.BrickColor = BrickColor.new'White'
    Core2.Material = Enum.Material.Neon
end

function ToxicMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Lime green' end end
    WalkSpeed = 14
    RecolorTextAndRename("Nuclear", BrickColor.new'Lime green'.Color, C3.N(0, .6, 0))
    MusicID = 798163149
    Pitch = 1
    Mode = 9
    Core2.BrickColor = BrickColor.new'Lime green'
    Core2.Material = Enum.Material.Neon
end

function BarracudaMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'New Yeller' end end
    WalkSpeed = 24
    RecolorTextAndRename("Pendulum Hub Master", BrickColor.new'New Yeller'.Color, C3.N(1, 1, 1))
    MusicID = 256251217
    Pitch = 1
    Mode = 16
    Core2.BrickColor = BrickColor.new'New Yeller'
    Core2.Material = Enum.Material.Neon
end

function FluctuateMode()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Alder' end end
    WalkSpeed = 18
    RecolorTextAndRename("FLUCTUATION", BrickColor.new'Alder'.Color, C3.N(1, 1, 1))
    MusicID = 1047567668
    Pitch = 1
    Mode = 10
    Core2.BrickColor = BrickColor.new'Alder'
    Core2.Material = Enum.Material.Neon
end

function InsaneMode()
    Attack = true
    NeutralAnims = false
    MusicID = 919231299
    Pitch = 1
    WalkSpeed = 0
    Sound(Core2, 136007472, 1.25, 2.5, false, true, true)
    for _ = 0, 4, 0.1 do
        swait()
        NoobySphere(2.5, -1.5, 'Multiply', Core2.CFrame * CF.A(M.RRNG(-180, 180), M.RRNG(-180, 180), M.RRNG(-180, 180)), V3.N(3.5, 3.5, 45), -.035, Core2.Color, 100)
    end
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Neon; v.Transparency = 0; v.BrickColor = BrickColor.new'Really black' end end
    WalkSpeed = 12
    Mode = 696969
    Core2.BrickColor = BrickColor.new'Black'
    Core2.Material = Enum.Material.Neon
    RecolorTextAndRename("INSANITY", Color3.new(0, 0, 0), Color3.new(1, 1, 1))
    Attack = false
    NeutralAnims = true
end

function RiddleMeThis()
    Attack = true
    NeutralAnims = false
    WalkSpeed = 0
    MusicID = 1420353940
    Pitch = 1
    Muted = true
    repeat swait() until Music.IsLoaded
    Muted = false
    Music.TimePosition = 0
    pcall(function()
        local Event = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if Event and Event:FindFirstChild("SayMessageRequest") then
            Event.SayMessageRequest:FireServer("Riddle Me This..", "All")
            task.wait(2)
            Event.SayMessageRequest:FireServer("Riddle Me That..", "All")
            task.wait(2)
            Event.SayMessageRequest:FireServer("Whos Afraid Of The Big Black..?", "All")
        end
    end)
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Glass; v.Transparency = 0; v.BrickColor = BrickColor.new'Really black' end end
    WalkSpeed = 50
    RecolorTextAndRename("The Big Black", BrickColor.new'Really black'.Color, C3.N(1, 1, 1))
    Core2.BrickColor = BrickColor.new'Really black'
    Core2.Material = Enum.Material.Glass
    Mode = 666666666666
    Attack = false
    NeutralAnims = true
end

function L_O_S_T()
    for _, v in next, LWing:GetChildren() do if v:IsA'BasePart' and v.Name ~= 'Main' then v.Material = Enum.Material.Glass; v.Transparency = 0; v.Color = C3.N(.4, 0, 0) end end
    WalkSpeed = 24
    RecolorTextAndRename("L O S T  S O U L", BrickColor.new'Crimson'.Color, C3.N(0, 0, 0))
    MusicID = 343860759
    Pitch = .9
    Mode = 666
    Core2.Color = C3.N(.4, 0, 0)
    Core2.Material = Enum.Material.Neon
end

-- ============================================================
-- Input
-- ============================================================
Plr.Chatted:Connect(function(msg)
    if msg:sub(1, 5) == "play/" and Mode == 6 then
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(tonumber(msg:sub(6))) end)
        if ok and info and info.Name then Chat("Playing: "..info.Name, Color3.new(1, 1, 1)) end
        MusicID = msg:sub(6)
        VisSong = msg:sub(6)
    elseif msg:sub(1, 5) == 'tpos/' and Mode == 6 then
        if Music then Music.TimePosition = tonumber(msg:sub(6)) end
    end
end)

function KeyPress(code)
    if code == Enum.KeyCode.One and Mode ~= 1 then MurderMode()
    elseif code == Enum.KeyCode.Two and Mode ~= 2 then PureMode()
    elseif code == Enum.KeyCode.Three and Mode ~= 3 then GlitchMode()
    elseif code == Enum.KeyCode.Four and Mode ~= 4 then StressMode()
    elseif code == Enum.KeyCode.Five and Mode ~= 5 then JusticeMode()
    elseif code == Enum.KeyCode.Six and Mode ~= 6 then VisMode()
    elseif code == Enum.KeyCode.Seven and Mode ~= 7 then IceMode()
    elseif code == Enum.KeyCode.Eight and Mode ~= 8 then LoveMode()
    elseif code == Enum.KeyCode.Nine and Mode ~= 9 then ToxicMode()
    elseif code == Enum.KeyCode.Zero and Mode ~= 10 then FluctuateMode()
    elseif code == Enum.KeyCode.T then
        if Mode == 1 then RiddleMeThis()
        elseif Mode == 4 then InsaneMode()
        elseif Mode == 666666666666 then L_O_S_T()
        elseif Mode == 666 then MurderMode()
        elseif Mode == 696969 then StressMode()
        elseif Mode == 10 then BarracudaMode() end
    elseif code == Enum.KeyCode.Semicolon then
        DontAttackPlayers = not DontAttackPlayers
        Chat(DontAttackPlayers and "Cannot attack players" or "Can attack players", Color3.new(1, 1, 1))
    elseif code == Enum.KeyCode.Z then
        if Mode == 1 then
            if not UserInputService.TouchEnabled then
                DoMurder((Mouse.Target and Mouse.Target.Parent))
            else MobileMurder() end
        elseif Mode == 666666666666 then
            if not UserInputService.TouchEnabled then
                NeckSnap((Mouse.Target and Mouse.Target.Parent))
            else MobileNeckSnap() end
        elseif Mode == 2 then PureBomb()
        elseif Mode == 3 then ClickGlitch()
        elseif Mode == 4 then Shrek()
        elseif Mode == 5 then Aeroplane()
        elseif Mode == 6 then SongSmash() end
    end
end

function AttackCombo()
    if Combo == 1 then AttackOne()
    elseif Combo == 2 then AttackTwo()
    elseif Combo == 3 then AttackThree() end
end

UserInputService.InputBegan:Connect(function(io, gpe)
    if Attack or gpe then return end
    if io.UserInputType == Enum.UserInputType.Keyboard then
        KeyPress(io.KeyCode)
    elseif io.UserInputType == Enum.UserInputType.MouseButton1 then
        AttackCombo()
    end
end)

-- ============================================================
-- Aura loop
-- ============================================================
coroutine.wrap(function()
    while true do
        if Mode == 5 then
            NoobySphere(5, 0.15, "Multiply", Root.CFrame * CF.N(M.RNG(-5, 5), -6, M.RNG(-5, 5)) * CF.A(M.R(90), 0, 0),
                V3.N(1.5, 1.5, 10), -0.015, BrickColor.new'White', 0)
        elseif Mode == 10 or Mode == 666666666666 then
            NoobySphere(5, math.random(25, 75)/100, "Multiply",
                Root.CFrame * CF.N(M.RNG(-15, 15), -10, M.RNG(-15, 15)) * CF.A(M.R(90), 0, 0) * CF.A(M.RRNG(-25, 25), M.RRNG(-25, 25), M.RRNG(-25, 25)),
                V3.N(.75, .75, 15), .005, Core2.BrickColor, 0)
        end
        if Mode == 666666666666 then
            NoobySphere(5, math.random(75, 150)/100, "Multiply",
                Root.CFrame * CF.N(M.RNG(-35, 35), -10, M.RNG(-35, 35)) * CF.A(M.R(90), 0, 0) * CF.A(M.RRNG(-25, 25), M.RRNG(-25, 25), M.RRNG(-25, 25)),
                V3.N(.75, .75, 25), .005, Core2.BrickColor, 0)
        end
        swait(1)
    end
end)()

-- ============================================================
-- Radioactive burn loop
-- ============================================================
coroutine.resume(coroutine.create(function()
    while true do
        swait(1)
        for who, data in next, Radioactive do
            local lastBurn, burnMaxTime = unpack(data)
            if time() - lastBurn >= BurnInterval then
                data[1] = time()
                for _, v in next, who:GetChildren() do
                    if v.Name == 'Health' and v:IsA'Script' then v.Disabled = true end
                end
                local hum = who:FindFirstChildOfClass'Humanoid'
                local tors = GetTorso(who)
                if hum and tors and hum.Health >= 0 then
                    local DoneDamage = M.RNG(4, 12)
                    Droplet{Size = .5, Color = BrickColor.new'Lime green', Direction = -(tors.CFrame.upVector * 2000), Origin = tors.CFrame}
                    if Hits >= MaxHits/4 then DoneDamage = DoneDamage + (DoneDamage * (Hits/MaxHits)) * 4 end
                    if hum.Health > 0 then
                        Hits = math.min(Hits + 1, MaxHits)
                        HitTime = HitTime + .1
                        if who:FindFirstChild'Head' then
                            ShowDamage((who.Head.CFrame * CF.N(0, 0, who.Head.Size.Z/2).p + V3.N(0, 1.5, 0) + V3.N(M.RNG(-2, 2), 0, M.RNG(-2, 2))),
                                math.floor(DoneDamage), 1.5, BrickColor.new'Forest green'.Color)
                        end
                        hum.MaxHealth = hum.MaxHealth - DoneDamage
                    end
                end
                if time() >= burnMaxTime or (hum and hum.Health <= 0) then
                    Radioactive[who] = nil
                    for _, v in next, who:GetChildren() do
                        if v.Name == 'Health' and v:IsA'Script' then v.Disabled = false end
                    end
                end
            end
        end
    end
end))

-- ============================================================
-- Main animation loop
-- ============================================================
while true do
    swait()
    Sine = Sine + Change
    Hue = Hue + 1
    if Hue > 360 then Hue = 0 end

    if not Music or not Music.Parent then
        local tPos = 0
        if Music then tPos = Music.TimePosition; Music:Stop(); Music:Destroy() end
        Music = Sound(Char, MusicID, 1, 3, true, false, true)
        Music.Name = 'Music'
        Music.TimePosition = tPos
    end
    Music.SoundId = "rbxassetid://"..MusicID
    Music.Parent  = Char
    Music.Pitch   = Pitch
    Music.Volume  = 2
    if Muted then Music:Pause() else Music:Resume() end

    if God then
        Hum.MaxHealth = 1e100
        Hum.Health = 1e100
        if not Char:FindFirstChildOfClass'ForceField' then
            local f = IN("ForceField", Char); f.Visible = false
        end
        Hum.Name = tostring(M.RNG() * 100)
    end

    local hitfloor = workspace:FindPartOnRay(
        Ray.new(Root.CFrame.p, CFrame.new(Root.Position, Root.Position - Vector3.new(0, 1, 0)).lookVector.unit * (4 * PlayerSize)), Char)

    local Walking = (math.abs(Root.Velocity.x) > 1 or math.abs(Root.Velocity.z) > 1)
    local State = (Hum.PlatformStand and 'Paralyzed' or Hum.Sit and 'Sit' or
        (not hitfloor and Root.Velocity.y < -1) and "Fall" or
        (not hitfloor and Root.Velocity.y > 1) and "Jump" or
        (hitfloor and Walking) and (Hum.WalkSpeed < 24 and "Walk" or "Run") or
        (hitfloor and "Idle"))

    Hum.WalkSpeed = WalkSpeed

    if NeutralAnims then
        if State == 'Idle' then
            local Alpha = .1
            if Mode == 1 then
                Change = 1
                RJ.C0 = clerp(RJ.C0, CFrame.new(-0.00779043138, -0.0846293643 + .1*M.C(Sine/32), -0.204210758, 0.912902117, -0.00691865245, -0.408120036, 0.117574908, 0.961935759, 0.246689886, 0.390878439, -0.273188382, 0.87896657), Alpha)
                LH.C0 = clerp(LH.C0, CFrame.new(-0.587742627, -1.00122428 - .1*M.C(Sine/32), -0.165018916, 0.860076427, 0.294745922, 0.416405559, -0.252913684, 0.955196917, -0.15373303, -0.443061411, 0.0269074962, 0.896087468), Alpha)
                RH.C0 = clerp(RH.C0, CFrame.new(0.343915284, -1.07833397 - .1*M.C(Sine/32), -0.0402937233, 0.964631855, -0.173768938, -0.198217094, 0.117325157, 0.956397653, -0.26746732, 0.236051857, 0.234751642, 0.942958832), Alpha)
                LS.C0 = clerp(LS.C0, CFrame.new(-1.39700282, 0.545769572, -0.00181379914, 0.907886505, 0.355485201, -0.222199559, -0.405204862, 0.880023003, -0.247727305, 0.107477367, 0.314944565, 0.943005204) * CF.A(0, M.R(16 - 8*M.C(Sine/32)), M.R(0 + 12*M.C(Sine/32))), Alpha)
                RS.C0 = clerp(RS.C0, CFrame.new(0.903979659, 0.624733686, -0.396169931, 0.827836394, 0.560810268, -0.013374418, 0.472599089, -0.7100721, -0.521965444, -0.302220345, 0.42578119, -0.852861941), Alpha)
                NK.C0 = clerp(NK.C0, CFrame.new(-0.0470906645, 1.53467083, -0.115898043, 0.906688511, -0.16142872, 0.389688164, -0.00265284558, 0.921666741, 0.387973785, -0.421792656, -0.352805078, 0.835236311), Alpha)
            else
                -- Fallback generic idle
                RJ.C0 = clerp(RJ.C0, RJC0 * CF.N(0, .2*M.C(Sine/6), 0) * CF.A(M.R(-5 + 5*M.C(Sine/12)), M.R(-10), 0), Alpha)
                NK.C0 = clerp(NK.C0, NKC0 * CF.A(M.R(-5 + 5*M.C(Sine/12)), 0, 0), Alpha)
                LS.C0 = clerp(LS.C0, LSC0 * CF.A(0, 0, M.R(-7 - 5*M.C(Sine/12))), Alpha)
                RS.C0 = clerp(RS.C0, RSC0 * CF.A(0, 0, M.R(7 + 5*M.C(Sine/12))), Alpha)
                LH.C0 = clerp(LH.C0, LHC0 * CF.N(0, -.2*M.C(Sine/6), 0) * CF.A(M.R(5 - 5*M.C(Sine/12)), M.R(10), 0), Alpha)
                RH.C0 = clerp(RH.C0, RHC0 * CF.N(0, -.2*M.C(Sine/6), 0) * CF.A(M.R(5 - 5*M.C(Sine/12)), M.R(-10), 0), Alpha)
            end
        elseif State == 'Walk' or State == 'Run' then
            local wsVal = 7 / (Hum.WalkSpeed / 16)
            local Alpha = math.min(.2 * (Hum.WalkSpeed / 16), 1)
            RJ.C0 = RJ.C0:Lerp(CF.N(0, 0 - .1*M.C(Sine/(wsVal/2)), 0) * CF.A(M.R(-5 - 2.5*M.C(Sine/(wsVal/2))), M.R(8*M.C(Sine/wsVal)), 0), Alpha)
            NK.C0 = NK.C0:Lerp(NKC0, Alpha)
            LS.C0 = LS.C0:Lerp(LSC0 * CF.N(0, 0, -.22*M.C(Sine/wsVal)) * CF.A(M.R(37*M.C(Sine/wsVal)), 0, M.R(-5 + 10*M.C(Sine/(wsVal/2)))), Alpha)
            RS.C0 = RS.C0:Lerp(RSC0 * CF.N(0, 0, .22*M.C(Sine/wsVal)) * CF.A(M.R(-37*M.C(Sine/wsVal)), 0, M.R(5 - 10*M.C(Sine/(wsVal/2)))), Alpha)
            LH.C0 = LH.C0:Lerp(LHC0 * CF.N(0, 0 + .1*M.C(Sine/(wsVal/2)), 0) * CF.A(0, -M.R(4*M.C(Sine/wsVal)), 0), Alpha)
            RH.C0 = RH.C0:Lerp(RHC0 * CF.N(0, 0 + .1*M.C(Sine/(wsVal/2)), 0) * CF.A(0, -M.R(4*M.C(Sine/wsVal)), 0), Alpha)
        elseif State == 'Jump' then
            local Alpha = .1
            LS.C0 = LS.C0:Lerp(LSC0 * CF.A(M.R(-5), 0, M.R(-90)), Alpha)
            RS.C0 = RS.C0:Lerp(RSC0 * CF.A(M.R(-5), 0, M.R(90)), Alpha)
            RJ.C0 = RJ.C0:Lerp(RJC0 * CF.A(math.min(math.max(Root.Velocity.Y/100, -M.R(45)), M.R(45)), 0, 0), Alpha)
            NK.C0 = NK.C0:Lerp(NKC0 * CF.A(math.min(math.max(Root.Velocity.Y/100, -M.R(45)), M.R(45)), 0, 0), Alpha)
            LH.C0 = LH.C0:Lerp(LHC0 * CF.A(0, 0, M.R(-5)), Alpha)
            RH.C0 = RH.C0:Lerp(RHC0 * CF.N(0, 1, -1) * CF.A(M.R(-5), 0, M.R(5)), Alpha)
        elseif State == 'Fall' then
            local Alpha = .1
            LS.C0 = LS.C0:Lerp(LSC0 * CF.A(M.R(-5), 0, M.R(-90)), Alpha)
            RS.C0 = RS.C0:Lerp(RSC0 * CF.A(M.R(-5), 0, M.R(90)), Alpha)
            RJ.C0 = RJ.C0:Lerp(RJC0 * CF.A(math.min(math.max(Root.Velocity.Y/100, -M.R(45)), M.R(45)), 0, 0), Alpha)
            NK.C0 = NK.C0:Lerp(NKC0 * CF.A(math.min(math.max(Root.Velocity.Y/100, -M.R(45)), M.R(45)), 0, 0), Alpha)
            LH.C0 = LH.C0:Lerp(LHC0 * CF.A(0, 0, M.R(-5)), Alpha)
            RH.C0 = RH.C0:Lerp(RHC0 * CF.N(0, 1, -1) * CF.A(M.R(-5), 0, M.R(5)), Alpha)
        end
    end

    -- Wing animation
    if LWingWelds[1] then
        LWingWelds[1].C0 = LWingWelds[1].C0:Lerp(CF.N(0, 0, 2.25) * CF.A(0, M.R(-90), 0) * CF.A(M.R(5), 0, M.R(12.5)), .1)
        RWingWelds[1].C0 = RWingWelds[1].C0:Lerp(CF.N(0, 0, -2.25) * CF.A(0, M.R(-90), 0) * CF.A(M.R(5), 0, -M.R(12.5)), .1)
    end

    -- Blood puddle decay
    for i, v in next, BloodPuddles do
        local mesh = i:FindFirstChild'CylinderMesh'
        BloodPuddles[i] = v + 1
        if not mesh or i.Transparency >= 1 then
            i:Destroy()
            BloodPuddles[i] = nil
        elseif v >= Frame_Speed * 4 then
            local trans = (v - Frame_Speed * 4) / (Frame_Speed * 2)
            i.Transparency = trans
            if mesh.Scale.Z > 0 then mesh.Scale = mesh.Scale - V3.N(.05, 0, .05) end
        else
            i.Transparency = 0
        end
    end
end
