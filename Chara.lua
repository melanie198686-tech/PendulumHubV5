-- Created by Nebula_Zorua (Fixed & Zero-Damage)
-- Y o u  a c t  l i k e  y o u  h a v e  a  c h o i c e. =)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local RArm = Char:WaitForChild("Right Arm")
local LArm = Char:WaitForChild("Left Arm")
local RLeg = Char:WaitForChild("Right Leg")
local LLeg = Char:WaitForChild("Left Leg")
local Root = Char:WaitForChild("HumanoidRootPart")
local Torso = Char:WaitForChild("Torso")
local Head = Char:WaitForChild("Head")
local Mouse = Player:GetMouse()

local NeutralAnims = true
local Attack = false
local BloodPuddles = {}
local Effects = {}
local Debounces = { Debounces = {} }
local Hit = {}
local Sine = 0
local Change = 1
local Souls = 0

local CF = { N = CFrame.new, A = CFrame.Angles, fEA = CFrame.fromEulerAnglesXYZ }
local C3 = { N = Color3.new, RGB = Color3.fromRGB, HSV = Color3.fromHSV }
local V3 = { N = Vector3.new }
local M = { C = math.cos, R = math.rad, S = math.sin, P = math.pi, RNG = math.random, H = math.huge, RRNG = function(min, max, div) return math.rad(math.random(min, max) / (div or 1)) end }
local IN = Instance.new
local CSK = ColorSequenceKeypoint.new
local CS = ColorSequence.new

local Frame_Speed = 75
local Remove_Hats = false
local Remove_Clothing = false
local PlayerSize = 1
local DamageColor = BrickColor.new("Really red")
local MusicID = 935501955
local WalkSpeed = 8
local MaxSouls = 100
local MaxHealth = 500

-- Fix: Modern Create wrapper
local function NewInstance(class, parent, props)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function() inst[k] = v end)
        end
    end
    inst.Parent = parent
    return inst
end

-- Fix: LoadLibrary replacement
local function Part(parent, color, material, size, cframe, anchored, cancollide)
    local part = Instance.new("Part")
    part.BrickColor = (typeof(color) == "BrickColor" and color or BrickColor.new(color or "Black"))
    part.Material = material or Enum.Material.SmoothPlastic
    part.TopSurface, part.BottomSurface = 10, 10
    part.Size = size or V3.N(1, 1, 1)
    part.CFrame = cframe or CF.N(0, 0, 0)
    part.Anchored = anchored or false
    part.CanCollide = cancollide or false
    part.Parent = parent or Char
    return part
end

local function Mesh(parent, meshtype, meshid, textid, scale, offset)
    local part = Instance.new("SpecialMesh")
    part.MeshId = meshid or ""
    part.TextureId = textid or ""
    part.Scale = scale or V3.N(1, 1, 1)
    part.Offset = offset or V3.N(0, 0, 0)
    part.MeshType = meshtype or Enum.MeshType.Sphere
    part.Parent = parent
    return part
end

local function Sound(parent, id, pitch, volume, looped, effect, autoPlay)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id or 0)
    s.Pitch = pitch or 1
    s.Volume = volume or 1
    s.Looped = looped or false
    if autoPlay then
        task.spawn(function()
            repeat task.wait() until s.IsLoaded
            s.Playing = autoPlay
        end)
    end
    if not looped and effect then
        s.Stopped:Connect(function()
            s.Volume = 0
            s:Destroy()
        end)
    end
    s.Parent = parent or Torso
    return s
end

local EffectsFolder = IN("Folder", Char)
EffectsFolder.Name = "Effects"

Hum.MaxHealth = MaxHealth
Hum.Health = MaxHealth

-- Create Knife
local Knife = NewInstance("Part", Char, {Name = "Knife", Size = V3.N(.4, 3, .7), Anchored = false, CanCollide = false, Locked = true, Color = C3.N(0, 0, 0)})
Mesh(Knife, Enum.MeshType.FileMesh, "rbxassetid://121944778", "rbxassetid://362719969", V3.N(1, 1, 1), V3.N())
local AuraEmitter = NewInstance("ParticleEmitter", Knife, {EmissionDirection = "Back", Color = CS{CSK(0, C3.N(1, 0, 0)), CSK(0.5, C3.N(1, 1, 0)), CSK(1, C3.RGB(255, 191, 0))}, LightEmission = .5, LightInfluence = 0, Size = NumberSequence.new(0.3), Texture = "rbxassetid://141116476", Transparency = NumberSequence.new(0, 1), LockedToPart = true, Lifetime = NumberRange.new(1), Rate = 150, Speed = NumberRange.new(0)})
local FireEmitter = NewInstance("ParticleEmitter", Knife, {EmissionDirection = "Back", Color = CS(C3.N(1, 0, 0), C3.N(1, 0, 0)), LightEmission = .5, LightInfluence = 0, Size = NumberSequence.new{NumberSequenceKeypoint.new(0, .5, 0), NumberSequenceKeypoint.new(0.755, 0, 0), NumberSequenceKeypoint.new(1, 0, 0)}, Texture = "rbxassetid://141116476", Transparency = NumberSequence.new(0.35, 1), Lifetime = NumberRange.new(1, 2), Rate = 150, Speed = NumberRange.new(3)})

local KTrail = NewInstance("Trail", Knife, {
    Attachment0 = NewInstance("Attachment", Knife, {Position = V3.N(0, -.4, 0)}),
    Attachment1 = NewInstance("Attachment", Knife, {Position = V3.N(0, 1.2, 0)}),
    Color = CS(C3.N(1, 0, 0)),
    Enabled = false,
    Transparency = NumberSequence.new(0, 1),
    Lifetime = 1.25,
})
NewInstance("PointLight", Knife, {Color = C3.N(1, 0, 0), Range = 10, Brightness = 3})

local Hair = Part(Char, C3.N(0, 0, 0), Enum.Material.SmoothPlastic, V3.N(1, 1, 1), CF.N(), false, false)
Mesh(Hair, Enum.MeshType.FileMesh, "rbxassetid://250264520", "rbxassetid://75975464", V3.N(1.05, 1.05, 1.05), V3.N())

Hum.DisplayDistanceType = "None"

-- Name Tag
local naeeym2 = IN("BillboardGui", Char)
naeeym2.AlwaysOnTop = true
naeeym2.Size = UDim2.new(5, 35, 2, 15)
naeeym2.StudsOffset = V3.N(0, 2.5, 0)
naeeym2.Adornee = Char.Head
naeeym2.Name = "Name"
naeeym2.PlayerToHideFrom = Player
local tecks2 = IN("TextLabel", naeeym2)
tecks2.BackgroundTransparency = 1
tecks2.TextScaled = true
tecks2.BorderSizePixel = 0
tecks2.Text = "Chara"
tecks2.Font = Enum.Font.Bodoni
tecks2.TextSize = 30
tecks2.TextStrokeTransparency = 0
tecks2.TextColor3 = C3.N(0, 0, 0)
tecks2.TextStrokeColor3 = C3.N(.7, 0, 0)
tecks2.Size = UDim2.new(1, 0, 0.5, 0)
tecks2.Parent = naeeym2

Hum.WalkSpeed = WalkSpeed

for i = 1, 35 do
    local FACE = Part(Char, C3.N(0, 0, 0), Enum.Material.Neon, V3.N(1.01, .5, 1.01), CF.N(), false, false)
    FACE.Transparency = 0 + (i - 1) / 35.2
    FACE.Name = "ShadowFace"
    Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = FACE
    NewInstance("Weld", Head, {Part0 = Head, Part1 = FACE, C0 = CF.N(0, .35 - (i - 1) / 75, 0)})
end

local LEye = Part(Char, C3.N(1, 0, 0), Enum.Material.Neon, V3.N(.15, .25, .2), CF.N(), false, false)
Mesh(LEye, Enum.MeshType.Sphere, "", "", V3.N(1, 1, 1), V3.N())
NewInstance("Weld", LEye, {Part0 = Head, Part1 = LEye, C0 = CF.N(-.2, .2, -.49)})

local REye = Part(Char, C3.N(1, 0, 0), Enum.Material.Neon, V3.N(.15, .25, .2), CF.N(), false, false)
Mesh(REye, Enum.MeshType.Sphere, "", "", V3.N(1, 1, 1), V3.N())
NewInstance("Weld", REye, {Part0 = Head, Part1 = REye, C0 = CF.N(.2, .2, -.49)})

local Music = Sound(Torso, MusicID, 1, 3, true, false, true)
Music.Name = "Music"

for _, v in next, Hum:GetPlayingAnimationTracks() do
    v:Stop()
end
pcall(game.Destroy, Char:FindFirstChild("Animate"))
pcall(game.Destroy, Hum:FindFirstChild("Animator"))

-- Joints
local LS = NewInstance("Motor", Char, {Part0 = Torso, Part1 = LArm, C0 = CF.N(-1.5 * PlayerSize, 0.5 * PlayerSize, 0), C1 = CF.N(0, .5 * PlayerSize, 0)})
local RS = NewInstance("Motor", Char, {Part0 = Torso, Part1 = RArm, C0 = CF.N(1.5 * PlayerSize, 0.5 * PlayerSize, 0), C1 = CF.N(0, .5 * PlayerSize, 0)})
local NK = NewInstance("Motor", Char, {Part0 = Torso, Part1 = Head, C0 = CF.N(0, 1.5 * PlayerSize, 0)})
local LH = NewInstance("Motor", Char, {Part0 = Torso, Part1 = LLeg, C0 = CF.N(-.5 * PlayerSize, -1 * PlayerSize, 0), C1 = CF.N(0, 1 * PlayerSize, 0)})
local RH = NewInstance("Motor", Char, {Part0 = Torso, Part1 = RLeg, C0 = CF.N(.5 * PlayerSize, -1 * PlayerSize, 0), C1 = CF.N(0, 1 * PlayerSize, 0)})
local RJ = NewInstance("Motor", Char, {Part0 = Root, Part1 = Torso})
local HW = NewInstance("Motor", Char, {Part0 = RArm, Part1 = Knife, C0 = CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0)})
local HW2 = NewInstance("Motor", Char, {Part0 = Head, Part1 = Hair, C0 = CF.N(0, .25, 0)})

local LSC0 = LS.C0
local RSC0 = RS.C0
local NKC0 = NK.C0
local LHC0 = LH.C0
local RHC0 = RH.C0
local RJC0 = RJ.C0

-- Heartbeat
local ArtificialHB = IN("BindableEvent", script)
ArtificialHB.Name = "Heartbeat"
local tf = 0
local frame = 1 / Frame_Speed
ArtificialHB:Fire()

RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for i = 1, math.floor(tf / frame) do
            ArtificialHB:Fire()
        end
        tf = tf - frame * math.floor(tf / frame)
    end
end)

local function swait(num)
    num = num or 1
    for i = 0, num do
        ArtificialHB.Event:Wait()
    end
end

local function clerp(startCF, endCF, alpha)
    return startCF:Lerp(endCF, alpha)
end

-- Fix: Modern raycast
local function rayCast(pos, dir, range, ignore)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Char}
    local result = workspace:Raycast(pos, dir.Unit * (range or 4), params)
    if result then return result.Instance, result.Position end
    return nil, nil
end

-- ZERO DAMAGE Kill Function
local function Kill(whom)
    if whom.Name == Player.Name then return end
    -- Do nothing except visual effect
    for _, v in next, whom:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

-- ZERO DAMAGE Soul Steal
local function SoulSteal(whom, human)
    local torso = (whom:FindFirstChild("Torso") or whom:FindFirstChild("UpperTorso") or whom:FindFirstChild("LowerTorso") or whom:FindFirstChild("HumanoidRootPart"))
    local succ, health, alive = pcall(function() return whom:FindFirstChildOfClass("Humanoid").Health, whom:FindFirstChildOfClass("Humanoid").Health > 0 end)
    if torso and torso:IsA("BasePart") and alive then
        -- DO NOT KILL - just show visual
        local Model = IN("Model", EffectsFolder)
        Model.Name = whom.Name .. "'s Soul"
        local Soul = Part(Model, human and BrickColor.new("Really red") or BrickColor.new(C3.N(1, 1, 1)), "Glass", V3.N(1, 1, 1), torso.CFrame, true, false)
        Soul.Name = "Head"
        Mesh(Soul, Enum.MeshType.Sphere)
        local Hoom = NewInstance("Humanoid", Model, {MaxHealth = (health <= 10000 and health / 2 or 10000), Health = (health <= 10000 and health / 2 or 10000)})
        local AT0 = NewInstance("Attachment", Soul, {Position = V3.N(0, .5, 0)})
        local AT1 = NewInstance("Attachment", Soul, {Position = V3.N(0, -.5, 0)})
        NewInstance("Trail", Soul, {Attachment0 = AT0, Attachment1 = AT1, Transparency = NumberSequence.new(0), FaceCamera = true, Color = CS(Soul.Color), Lifetime = .5, MinLength = 0})
        NewInstance("PointLight", Soul, {Color = Soul.Color, Range = 10, Brightness = 3})
        
        local turdso = Soul:Clone()
        turdso.Name = "Torso"
        turdso.CanCollide = false
        turdso.Anchored = true
        turdso.CFrame = Soul.CFrame
        turdso.Parent = Model
        turdso.Size = V3.N()
        turdso.Transparency = 1
        
        local Distance = math.huge
        repeat
            if not Soul.Parent then break end
            Soul.CFrame = CF.N(Soul.Position, Torso.Position) * CF.N(0, 0, -1)
            turdso.CFrame = Soul.CFrame
            Distance = (Soul.CFrame.p - Torso.CFrame.p).magnitude
            swait()
        until Hoom.Health <= 0 or not Soul.Parent or Distance <= 1.2
        
        if Soul.Parent and Hoom.Health > 0 then
            Model:Destroy()
            Souls = Souls + (human and 1 or .1)
        else
            Model:Destroy()
        end
    end
end

-- ZERO DAMAGE AoE
local function AOEKill(where, range)
    for _, v in next, workspace:GetDescendants() do
        if v:IsA("BasePart") then
            local hum = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            if hum and v.Parent ~= Char and (v.Position - where).Magnitude <= range then
                task.spawn(SoulSteal, v.Parent, true)
            end
        end
    end
end

-- ZERO DAMAGE Slash Attack
local function Slash()
    Attack = true
    NeutralAnims = false
    local sound = Sound(Knife, 437475935, 1, 5, false, true, false)
    for i = 0, 2, 0.1 do
        swait()
        local Alpha = .2
        RJ.C0 = clerp(RJ.C0, CFrame.new(0.034, 0.006, 0.057, 0.94, 0.002, 0.33, 1e-6, 0.99, -0.006, -0.33, 0.005, 0.94), Alpha)
        LH.C0 = clerp(LH.C0, CFrame.new(-0.496, -0.99, 0.021, 0.999, 0, 0.015, -9e-5, 0.999, 0.006, -0.015, -0.006, 0.999), Alpha)
        RH.C0 = clerp(RH.C0, CFrame.new(0.498, -0.99, 0.015, 0.999, 0, 0.015, -9e-5, 0.999, 0.006, -0.015, -0.006, 0.999), Alpha)
        LS.C0 = clerp(LS.C0, CFrame.new(-1.32, 0.47, -0.005, 0.93, 0.35, 0.015, -0.35, 0.93, 0.006, -0.012, -0.011, 0.999), Alpha)
        RS.C0 = clerp(RS.C0, CFrame.new(1.12, 0.36, -0.48, 0.49, 0.65, 0.57, 0.72, 0.06, -0.68, -0.48, 0.75, -0.43), Alpha)
        NK.C0 = clerp(NK.C0, CFrame.new(-0.011, 1.49, -0.07, 0.94, 0.01, -0.32, 0.002, 0.99, 0.06, 0.33, -0.06, 0.94), Alpha)
        HW.C0 = HW.C0:Lerp(CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0), Alpha)
    end
    KTrail.Enabled = true
    sound:Play()
    for i = 0, 2.5, 0.1 do
        swait()
        -- VISUAL SWING
        local Alpha = .25
        RJ.C0 = clerp(RJ.C0, CFrame.new(-0.035, 0.006, -0.009, 0.817, -0.003, -0.575, -1e-6, 0.999, -0.006, 0.575, 0.005, 0.817), Alpha)
        LH.C0 = clerp(LH.C0, CFrame.new(-0.496, -0.99, 0.021, 0.999, 0, 0.015, -9e-5, 0.999, 0.006, -0.015, -0.006, 0.999), Alpha)
        RH.C0 = clerp(RH.C0, CFrame.new(0.498, -0.99, 0.015, 0.999, 0, 0.015, -9e-5, 0.999, 0.006, -0.015, -0.006, 0.999), Alpha)
        LS.C0 = clerp(LS.C0, CFrame.new(-1.32, 0.47, -0.005, 0.93, 0.35, 0.015, -0.35, 0.93, 0.006, -0.012, -0.011, 0.999), Alpha)
        RS.C0 = clerp(RS.C0, CFrame.new(1.23, 0.4, 0.002, 0.49, -0.84, 0.19, 0.72, 0.52, 0.45, -0.48, -0.08, 0.86), Alpha)
        NK.C0 = clerp(NK.C0, CFrame.new(0.031, 1.49, -0.025, 0.817, -0.033, 0.574, -0.003, 0.998, 0.06, -0.575, -0.053, 0.816), Alpha)
        HW.C0 = HW.C0:Lerp(CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0), Alpha)
    end
    KTrail.Enabled = false
    Attack = false
    NeutralAnims = true
end

Mouse.Button1Down:Connect(function()
    if Attack then return end
    Slash()
end)

Mouse.KeyDown:Connect(function(k)
    if Attack then return end
    if k:lower() == "z" then
        AOEKill(Root.Position, 25)
    end
    if k:lower() == "q" then
        WalkSpeed = (WalkSpeed == 8 and 32 or 8)
    end
end)

-- Anti-Fling / Reset
Player.CharacterAdded:Connect(function(newChar)
    Char = newChar
    Hum = newChar:WaitForChild("Humanoid")
    Root = newChar:WaitForChild("HumanoidRootPart")
    Torso = newChar:WaitForChild("Torso")
end)

-- Main Animation Loop
while Char.Parent do
    swait()
    Sine = Sine + Change
    
    if Music and Music.Parent ~= Torso then
        Music.Parent = Torso
        Music:Resume()
    end
    
    local hitfloor = rayCast(Root.Position, (CFrame.new(Root.Position, Root.Position - Vector3.new(0, 1, 0))).LookVector, 4, Char)
    local Walking = (math.abs(Root.Velocity.X) > 1 or math.abs(Root.Velocity.Z) > 1)
    local State = (Hum.PlatformStand and "Paralyzed" or Hum.Sit and "Sit" or not hitfloor and Root.Velocity.Y < -1 and "Fall" or not hitfloor and Root.Velocity.Y > 1 and "Jump" or hitfloor and Walking and "Walk" or hitfloor and "Idle")
    
    Hum.WalkSpeed = WalkSpeed
    if State == "Walk" then
        if Hum.WalkSpeed >= 24 then
            local wsVal = 22 / (Hum.WalkSpeed / 16)
            local Alpha = math.min(.1 * (Hum.WalkSpeed / 16), 1)
            Change = 2
            RH.C1 = RH.C1:Lerp(CF.N(0, 1, 0) * CF.N(0, 0 - .2 * M.C(Sine / wsVal), 0 + .4 * M.C(Sine / wsVal)) * CF.A(M.R(25 + 45 * M.C(Sine / wsVal)) + -M.S(Sine / wsVal), 0, 0), Alpha)
            LH.C1 = LH.C1:Lerp(CF.N(0, 1, 0) * CF.N(0, 0 + .2 * M.C(Sine / wsVal), 0 - .4 * M.C(Sine / wsVal)) * CF.A(M.R(25 - 45 * M.C(Sine / wsVal)) + M.S(Sine / wsVal), 0, 0), Alpha)
        else
            Change = .9
            local wsVal = 8 / (Hum.WalkSpeed / 8)
            local Alpha = math.min(.2 * (Hum.WalkSpeed / 8), 1)
            LH.C1 = LH.C1:Lerp(CF.N(0, 1 - .2 * M.C(Sine / wsVal) / 2, .4 * M.C(Sine / wsVal) / 2) * CF.A(M.R(15 - 2 * M.C(Sine / wsVal)) - M.S(Sine / wsVal) / 2.5, 0, 0) * CF.A(M.R(0 - 3 * M.C(Sine / wsVal)), 0, 0), Alpha)
            RH.C1 = RH.C1:Lerp(CF.N(0, 1 + .2 * M.C(Sine / wsVal) / 2, -.4 * M.C(Sine / wsVal) / 2) * CF.A(M.R(15 + 2 * M.C(Sine / wsVal)) + M.S(Sine / wsVal) / 2.5, 0, 0) * CF.A(M.R(0 + 3 * M.C(Sine / wsVal)), 0, 0), Alpha)
        end
    else
        RH.C1 = RH.C1:Lerp(CF.N(0, 1, 0), .1)
        LH.C1 = LH.C1:Lerp(CF.N(0, 1, 0), .1)
    end
    
    local face = Head:FindFirstChild("face")
    if not face then
        NewInstance("Decal", Head, {Name = "face", Face = Enum.NormalId.Front, Texture = "rbxassetid://404306534"})
    else
        face.Texture = "rbxassetid://404306534"
    end
    
    RArm.BrickColor = BrickColor.new("Pastel brown")
    LArm.BrickColor = BrickColor.new("Pastel brown")
    RLeg.BrickColor = BrickColor.new("Pastel brown")
    LLeg.BrickColor = BrickColor.new("Pastel brown")
    Torso.BrickColor = BrickColor.new("Pastel brown")
    Head.BrickColor = BrickColor.new("Pastel brown")
    Hum.Name = "Chara"
    Hum.MaxHealth = MaxHealth
    Hum.DisplayDistanceType = "None"
    
    if NeutralAnims then
        if State == "Idle" then
            Change = 1
            local Alpha = .1
            RJ.C0 = clerp(RJ.C0, CFrame.new(-0.1, 0 + .05 * M.C(Sine / 16), -0.238, 0.857, -0.003, -0.515, 0, 0.999, -0.006, 0.515, 0.005, 0.857), Alpha)
            LH.C0 = clerp(LH.C0, CFrame.new(-0.536, -0.991 - .05 * M.C(Sine / 16), -0.013, 0.849, 0, 0.528, -0.003, 0.999, 0.005, -0.528, -0.006, 0.849), Alpha)
            RH.C0 = clerp(RH.C0, CFrame.new(0.529, -0.991 - .05 * M.C(Sine / 16), -0.082, 0.849, 0, 0.528, -0.003, 0.999, 0.005, -0.528, -0.006, 0.849), Alpha)
            LS.C0 = clerp(LS.C0, CFrame.new(-1.322, 0.156 + .15 * M.C(Sine / 16), 0.234, 0.878, -0.457, 0.145, 0.260, 0.708, 0.657, -0.403, -0.539, 0.740), Alpha)
            RS.C0 = clerp(RS.C0, CFrame.new(1.252, 0.605 + .15 * M.C(Sine / 16), -0.019, 0.915, -0.287, -0.283, 0.301, 0.954, 0.006, 0.268, -0.091, 0.959), Alpha)
            NK.C0 = clerp(NK.C0, CFrame.new(0, 1.499, -0.014, 0.770, -0.360, 0.527, 0.388, 0.920, 0.063, -0.507, 0.156, 0.847), Alpha)
            HW.C0 = HW.C0:Lerp(CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0), Alpha)
            
        elseif State == "Walk" then
            local wsVal = 8 / (Hum.WalkSpeed / 8)
            local Alpha = math.min(.2 * (Hum.WalkSpeed / 8), 1)
            RJ.C0 = RJ.C0:Lerp(CF.N(0, 0 - .05 * M.C(Sine / (wsVal / 2)), 0) * CF.A(0, M.R(0 - 5 * M.S(Sine / wsVal) / 2), 0), Alpha)
            LS.C0 = LS.C0:Lerp(LSC0 * CF.N(0, 0, 0 + .3 * M.S(Sine / wsVal)) * CF.A(M.R(0 - 25 * M.S(Sine / wsVal)), 0, M.R(5 - 5 * M.S(Sine / wsVal))), Alpha)
            RS.C0 = RS.C0:Lerp(RSC0 * CF.N(0, 0, 0 - .3 * M.S(Sine / wsVal)) * CF.A(M.R(0 + 25 * M.S(Sine / wsVal)), 0, M.R(-5 - 5 * M.S(Sine / wsVal))), Alpha)
            NK.C0 = NK.C0:Lerp(NKC0, Alpha)
            LH.C0 = LH.C0:Lerp(LHC0 * CF.N(0, 0 + .05 * M.C(Sine / (wsVal / 2)), 0), Alpha)
            RH.C0 = RH.C0:Lerp(RHC0 * CF.N(0, 0 + .05 * M.C(Sine / (wsVal / 2)), 0), Alpha)
            HW.C0 = HW.C0:Lerp(CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0), Alpha)
            
        elseif State == "Jump" or State == "Fall" then
            local Alpha = .2
            RJ.C0 = clerp(RJ.C0, RJC0 * CF.A(math.min(math.max(Root.Velocity.Y / 100, -M.R(65)), M.R(65)), 0, 0), Alpha)
            LH.C0 = clerp(LH.C0, CFrame.new(-0.504, -0.291, -0.487, 0.999, -0.004, 0.015, -1e-4, 0.958, 0.287, -0.015, -0.287, 0.958), Alpha)
            RH.C0 = clerp(RH.C0, CFrame.new(0.453, -0.871, 0.09, 0.986, -0.168, 0.015, 0.163, 0.970, 0.183, -0.046, -0.178, 0.983), Alpha)
            LS.C0 = clerp(LS.C0, CFrame.new(-1.552, 0.577, -0.003, 0.976, 0.217, 0.016, -0.217, 0.976, 0.006, -0.014, -0.010, 0.999), Alpha)
            RS.C0 = clerp(RS.C0, CFrame.new(1.502, 0.637, 0.006, 0.978, -0.210, 0.016, 0.210, 0.978, 0.006, -0.017, -0.003, 0.999), Alpha)
            NK.C0 = clerp(NK.C0, CFrame.new(0, 1.499, -0.014, 1, 0, 0, 0, 0.998, 0.064, 0, -0.064, 0.998), Alpha)
            HW.C0 = HW.C0:Lerp(CF.N(0, -1, -1) * CF.A(M.R(-90), 0, 0), Alpha)
        end
    end
end
