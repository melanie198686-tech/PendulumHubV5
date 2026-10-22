--[[
    Netless Reaper — Fully Fixed & Modernized (ZERO DAMAGE)
    - Deals NO damage to other players
    - You take NO damage while Phase (Q) is active
    - Fully fixed syntax and animations
]]

warn("Netless Activated!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local LeftArm = Character:WaitForChild("Left Arm")
local RightArm = Character:WaitForChild("Right Arm")
local Mouse = Player:GetMouse()

-- Disable default animations
local Animate = Character:FindFirstChild("Animate")
if Animate then Animate.Disabled = true end
local Animator = Humanoid:FindFirstChildOfClass("Animator")
if Animator then Animator.Parent = nil end

-- GUI Setup
local GUI = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
GUI.Name = "ReaperUI"
GUI.ResetOnSpawn = false

local Frame = Instance.new("Frame", GUI)
Frame.Size = UDim2.new(0.1, 0, 0.05, 0)
Frame.Position = UDim2.new(0.85, 0, 0.425, 0)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.new(85/255, 40/255, 113/255)

local UltT = Instance.new("TextLabel", Frame)
UltT.Size = UDim2.new(1, 0, 1, 0)
UltT.BackgroundTransparency = 1
UltT.Text = "0%"
UltT.TextColor3 = Color3.new(1, 1, 1)
UltT.TextScaled = true
UltT.Font = Enum.Font.SourceSansBold

local Frame2 = Instance.new("Frame", GUI)
Frame2.Size = UDim2.new(0.1, 0, 0.05, 0)
Frame2.Position = UDim2.new(0.85, 0, 0.535, 0)
Frame2.BackgroundTransparency = 0.5
Frame2.BorderSizePixel = 0
Frame2.BackgroundColor3 = Color3.new(85/255, 40/255, 113/255)

local AmmoT = Instance.new("TextLabel", Frame2)
AmmoT.Size = UDim2.new(1, 0, 1, 0)
AmmoT.BackgroundTransparency = 1
AmmoT.Text = "8/8"
AmmoT.TextColor3 = Color3.new(1, 1, 1)
AmmoT.TextScaled = true
AmmoT.Font = Enum.Font.SourceSansBold

-- State
local attack = false
local ShotCoolDown = false
local Combo = 1
local UltCharge = 0
local Ammo = 8
local PhaseEnabled = true
local TeleportEnabled = true
local sine = 0
local idletime = 0

Humanoid.WalkSpeed = 24
Humanoid.JumpPower = 50

-- Base Joint CFrames (R6)
local RSC0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
local RSC1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
local LSC0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local LSC1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local RHC0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
local RHC1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
local LHC0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local LHC1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local NC0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local NC1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local RJC0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local RJC1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

local RS = Torso:FindFirstChild("Right Shoulder")
local LS = Torso:FindFirstChild("Left Shoulder")
local RH = Torso:FindFirstChild("Right Hip")
local LH = Torso:FindFirstChild("Left Hip")
local RJ = HumanoidRootPart:FindFirstChild("RootJoint")
local N = Torso:FindFirstChild("Neck")

local function lerpz(joint, prop, cfrmz, alp)
    joint[prop] = joint[prop]:Lerp(cfrmz, alp)
end

local function swait(num)
    num = num or 0
    for i = 0, num do
        RunService.Heartbeat:Wait()
    end
end

-- Initial Sounds
local GS1 = Instance.new("Sound", HumanoidRootPart) GS1.SoundId = "rbxassetid://612647950" GS1.Volume = 3 GS1:Play()
local PS = Instance.new("Sound", HumanoidRootPart) PS.SoundId = "rbxassetid://882101831" PS.Volume = 3 PS:Play()

-- Gun Builder
local function createGun(name, parentPart, offset)
    local gun = Instance.new("Part")
    gun.Size = Vector3.new(0.4, 1.4, 4)
    gun.CanCollide = false
    gun.Anchored = false
    gun.Name = name
    gun.Massless = true
    gun.Parent = Character
    
    local mesh = Instance.new("SpecialMesh", gun)
    mesh.MeshId = "rbxassetid://651422978"
    mesh.TextureId = "rbxassetid://651423359"
    mesh.Scale = Vector3.new(0.35, 0.35, 0.35)
    
    local w = Instance.new("Weld", parentPart)
    w.Part0 = parentPart
    w.Part1 = gun
    w.C0 = offset
    
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(0.2, 0.2, 0.2)
    effect.Transparency = 1
    effect.CanCollide = false
    effect.Parent = gun
    
    local efw = Instance.new("Weld", gun)
    efw.Part0 = gun
    efw.Part1 = effect
    efw.C0 = CFrame.new(0, 0.4, -2.4)
    
    local exp = Instance.new("ParticleEmitter", effect)
    exp.Texture = "rbxassetid://850216805"
    exp.LightEmission = 0.85
    exp.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 144, 46)),
        ColorSequenceKeypoint.new(0.121, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
    })
    exp.Rate = 500
    exp.Rotation = NumberRange.new(-360, 360)
    exp.Lifetime = NumberRange.new(1)
    exp.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.0138, 2),
        NumberSequenceKeypoint.new(1, 4)
    })
    exp.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    exp.Speed = NumberRange.new(2)
    exp.SpreadAngle = Vector2.new(25, 25)
    exp.VelocityInheritance = 0.5
    exp.ZOffset = 2
    exp.Enabled = false
    exp.EmissionDirection = Enum.NormalId.Front
    
    return gun, effect, exp
end

local LeftGun, LeftEffect, LeftExp = createGun("HellfireGun", LeftArm, CFrame.new(0, -2, -0.25) * CFrame.Angles(math.rad(-90), 0, 0))
local RightGun, RightEffect, RightExp = createGun("HellfireGun", RightArm, CFrame.new(0, -2, -0.25) * CFrame.Angles(math.rad(-90), 0, 0))

-- Bullets (ZERO DAMAGE)
local function ShotBullets(Gun)
    for i = 1, 15 do
        local Bul = Instance.new("Part", workspace)
        Bul.Transparency = 1
        Bul.Size = Vector3.new(0.2, 0.2, 0.2)
        Bul.CanCollide = false
        Bul.CFrame = CFrame.new(Gun.Position, Mouse.Hit.Position) * CFrame.Angles(math.rad(math.random(-5,5)), math.rad(math.random(-5,5)), math.rad(math.random(-5,5)))
        
        local Atch1 = Instance.new("Attachment", Bul) Atch1.Position = Vector3.new(0, 0.05, 0)
        local Atch2 = Instance.new("Attachment", Bul) Atch2.Position = Vector3.new(0, -0.05, 0)
        
        local Trail = Instance.new("Trail", Bul)
        Trail.Attachment0 = Atch1
        Trail.Attachment1 = Atch2
        Trail.Texture = "rbxassetid://22636887"
        Trail.Lifetime = 0.1
        Trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
        Trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        Trail.LightEmission = 1
        Trail.MinLength = 1
        
        local BV = Instance.new("BodyVelocity", Bul)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Velocity = Bul.CFrame.LookVector * 150
        
        Debris:AddItem(Bul, 0.5)
        
        -- Touched event removed, no damage dealt.
    end
end

-- Reload
local function Reload()
    if attack then return end
    attack = true
    
    for i = 1, 15 do
        lerpz(RJ, "C0", RJC0, 0.1)
        lerpz(N, "C0", NC0 * CFrame.Angles(math.rad(15), 0, 0), 0.1)
        lerpz(RS, "C0", RSC0 * CFrame.new(0, 0, -0.75) * CFrame.Angles(0, math.rad(45), math.rad(125)), 0.1)
        lerpz(LS, "C0", LSC0 * CFrame.new(0, 0, -0.75) * CFrame.Angles(0, math.rad(-45), math.rad(-125)), 0.1)
        swait()
    end
    
    for i = 1, 5 do
        lerpz(RS, "C0", RSC0 * CFrame.Angles(0, math.rad(-65), math.rad(75)), 0.25)
        lerpz(LS, "C0", LSC0 * CFrame.Angles(0, math.rad(65), math.rad(-75)), 0.25)
        swait()
    end
    
    local RD = RightGun:Clone() RD.Parent = workspace RD.CanCollide = true
    local LD = LeftGun:Clone() LD.Parent = workspace LD.CanCollide = true
    
    local BV = Instance.new("BodyVelocity", RD)
    BV.Velocity = HumanoidRootPart.CFrame.RightVector * 15 + HumanoidRootPart.CFrame.LookVector * 25
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Debris:AddItem(BV, 0.05)
    
    local BV2 = Instance.new("BodyVelocity", LD)
    BV2.Velocity = HumanoidRootPart.CFrame.RightVector * -15 + HumanoidRootPart.CFrame.LookVector * 25
    BV2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Debris:AddItem(BV2, 0.05)
    
    Debris:AddItem(RD, 3)
    Debris:AddItem(LD, 3)
    
    RightGun.Transparency = 1
    LeftGun.Transparency = 1
    
    for i = 1, 25 do
        lerpz(RS, "C0", RSC0 * CFrame.Angles(0, math.rad(-65), math.rad(75)), 0.25)
        lerpz(LS, "C0", LSC0 * CFrame.Angles(0, math.rad(65), math.rad(-75)), 0.25)
        swait()
    end
    
    RightGun.Transparency = 0
    LeftGun.Transparency = 0
    Ammo = 8
    attack = false
end

-- Phase (Now makes you COMPLETELY INVINCIBLE)
local function Phase()
    if not PhaseEnabled or attack then return end
    PhaseEnabled = false
    attack = true
    Humanoid.WalkSpeed = 48
    
    local sound = Instance.new("Sound", HumanoidRootPart) sound.SoundId = "rbxassetid://834224978" sound.Volume = 3 sound:Play()
    
    -- Force health to max continuously for the duration
    local invuln = true
    local hpConn = Humanoid.HealthChanged:Connect(function()
        if invuln then Humanoid.Health = Humanoid.MaxHealth end
    end)
    
    for i = 1, 100 do
        lerpz(RJ, "C0", RJC0 * CFrame.new(0, 0, 0.5) * CFrame.Angles(math.rad(-15), 0, 0), 0.1)
        lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(105)), 0.1)
        lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-105)), 0.1)
        swait()
    end
    
    invuln = false
    hpConn:Disconnect()
    Ammo = 8
    Humanoid.WalkSpeed = 24
    attack = false
    
    task.delay(8, function() PhaseEnabled = true end)
end

-- Teleport
local function Teleport()
    if not TeleportEnabled or attack then return end
    if (HumanoidRootPart.Position - Mouse.Hit.Position).Magnitude >= 100 then return end
    TeleportEnabled = false
    attack = true
    
    HumanoidRootPart.Anchored = true
    Humanoid.WalkSpeed = 0
    
    for i = 1, 40 do
        lerpz(RS, "C0", RSC0 * CFrame.new(0, 0, -0.75) * CFrame.Angles(0, math.rad(90), math.rad(125)), 0.1)
        lerpz(LS, "C0", LSC0 * CFrame.new(0, 0, -0.75) * CFrame.Angles(0, math.rad(-90), math.rad(-125)), 0.1)
        swait()
    end
    
    HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 2.5, 0))
    
    HumanoidRootPart.Anchored = false
    Humanoid.WalkSpeed = 24
    attack = false
    
    task.delay(10, function() TeleportEnabled = true end)
end

-- Death Fire (Visuals)
local function DeathFire()
    task.spawn(function()
        local m2 = Instance.new("Model", workspace)
        for _, v in pairs(Character:GetChildren()) do
            if v.ClassName == "Part" and v.Name ~= "HumanoidRootPart" then
                local clone = v:Clone()
                clone.BrickColor = BrickColor.new("Really black")
                clone.Anchored = true
                clone.CanCollide = false
                if clone:FindFirstChild("Mesh") then clone.Mesh.TextureId = "" end
                clone.Parent = m2
                Debris:AddItem(clone, 1)
            end
        end
        
        RightExp.Enabled = true
        LeftExp.Enabled = true
        task.wait(0.1)
        RightExp.Enabled = false
        LeftExp.Enabled = false
    end)
end

-- Ultimate: Death Blossom
local function DeathBlossom()
    if UltCharge < 100 or attack then return end
    UltCharge = 0
    attack = true
    HumanoidRootPart.Anchored = true
    
    local GS = Instance.new("Sound", HumanoidRootPart) GS.SoundId = "rbxassetid://506001681" GS.Volume = 3 GS:Play()
    
    local function spinPose(rjOffset, nAngles, rsAngles, lsAngles, rhOffset, rhAngles, lhOffset, lhAngles)
        lerpz(RJ, "C0", RJC0 * rjOffset, 0.1)
        lerpz(N, "C0", NC0 * nAngles, 0.1)
        lerpz(RS, "C0", RSC0 * CFrame.new(0, 0, -0.75) * rsAngles, 0.1)
        lerpz(LS, "C0", LSC0 * CFrame.new(0, 0, -0.75) * lsAngles, 0.1)
        lerpz(RH, "C0", RHC0 * rhOffset * rhAngles, 0.1)
        lerpz(LH, "C0", LHC0 * lhOffset * lhAngles, 0.1)
    end

    for i = 1, 15 do
        spinPose(CFrame.new(), CFrame.Angles(math.rad(15), 0, 0), CFrame.Angles(0, math.rad(90), math.rad(125)), CFrame.Angles(0, math.rad(-90), math.rad(-125)), CFrame.new(), CFrame.Angles(math.rad(-5), 0, 0), CFrame.new(), CFrame.Angles(math.rad(-5), 0, 0))
        swait()
    end
    
    DeathFire()
    
    for spin = 1, 10 do
        for i = 1, 15 do
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(5), 0)
            spinPose(CFrame.new(0, 0, -1), CFrame.Angles(0, 0, 0), CFrame.Angles(0, math.rad(90 * (spin % 2 == 0 and 1 or -1)), math.rad(90)), CFrame.Angles(0, math.rad(-90 * (spin % 2 == 0 and 1 or -1)), math.rad(-90)), CFrame.new(1, 1, 0), CFrame.Angles(math.rad(-5), 0, 0), CFrame.new(0, 1, 0), CFrame.Angles(math.rad(-5), 0, math.rad(-45)))
            swait()
        end
        DeathFire()
    end
    
    HumanoidRootPart.Anchored = false
    attack = false
    Reload()
end

-- Input
Mouse.Button1Down:Connect(function()
    if Humanoid.Health <= 0 or attack or ShotCoolDown then return end
    if Ammo == 0 then
        local S = Instance.new("Sound", LeftEffect) S.SoundId = "rbxassetid://596722009" S.Volume = 0.5 S:Play() Debris:AddItem(S, 1)
        return
    end
    
    ShotCoolDown = true
    Ammo = Ammo - 1
    
    if Combo == 1 then
        Combo = 2
        LeftExp.Enabled = true
        ShotBullets(LeftEffect)
        for i = 1, 3 do
            lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-125)), 0.35)
            swait()
        end
    else
        Combo = 1
        RightExp.Enabled = true
        ShotBullets(RightEffect)
        for i = 1, 3 do
            lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(125)), 0.35)
            swait()
        end
    end
    
    LeftExp.Enabled = false
    RightExp.Enabled = false
    task.wait(0.35)
    ShotCoolDown = false
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or Humanoid.Health <= 0 then return end
    if input.KeyCode == Enum.KeyCode.Q then Phase()
    elseif input.KeyCode == Enum.KeyCode.E then DeathBlossom()
    elseif input.KeyCode == Enum.KeyCode.R then Reload()
    elseif input.KeyCode == Enum.KeyCode.Z then Teleport()
    end
end)

-- Animation Loop
RunService.RenderStepped:Connect(function()
    if Humanoid.Health <= 0 then return end
    
    UltT.Text = math.floor(UltCharge) .. "%"
    AmmoT.Text = Ammo .. "/8"
    
    if not attack then
        if HumanoidRootPart.Velocity.Y > 0.25 then
            lerpz(RJ, "C0", RJC0, 0.1)
            lerpz(N, "C0", NC0 * CFrame.Angles(math.rad(10), 0, 0), 0.1)
            lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(75)), 0.1)
            lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-75)), 0.1)
            lerpz(RH, "C0", RHC0 * CFrame.Angles(math.rad(-5), 0, math.rad(-25)), 0.1)
            lerpz(LH, "C0", LHC0 * CFrame.Angles(math.rad(-5), 0, math.rad(25)), 0.1)
        elseif HumanoidRootPart.Velocity.Y < -0.25 then
            lerpz(RJ, "C0", RJC0, 0.1)
            lerpz(N, "C0", NC0 * CFrame.Angles(math.rad(10), 0, 0), 0.1)
            lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(125)), 0.1)
            lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-125)), 0.1)
            lerpz(RH, "C0", RHC0 * CFrame.Angles(math.rad(-5), 0, math.rad(25)), 0.1)
            lerpz(LH, "C0", LHC0 * CFrame.Angles(math.rad(-5), 0, math.rad(-25)), 0.1)
        elseif (HumanoidRootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude > 1 then
            sine = sine + 1
            lerpz(RJ, "C0", RJC0 * CFrame.new(0, 0, math.cos(sine/3) * 0.05) * CFrame.Angles(math.rad(10), 0, 0), 0.2)
            lerpz(N, "C0", NC0 * CFrame.Angles(math.rad(-10), 0, 0), 0.2)
            lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(95 + (math.cos(sine/3) * -2.5))), 0.2)
            lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-(95 + (math.cos(sine/3) * -2.5)))), 0.2)
            lerpz(RH, "C0", RHC0 * CFrame.new(0, 0.05 + (math.cos(sine/3) * -0.05), 0) * CFrame.Angles(0, 0, math.rad(-(15 + math.cos(sine/6) * 75))), 0.2)
            lerpz(LH, "C0", LHC0 * CFrame.new(0, 0.05 + (math.cos(sine/3) * -0.05), 0) * CFrame.Angles(0, 0, math.rad(15 - math.cos(sine/6) * 75)), 0.2)
        else
            sine = sine + 1
            idletime = idletime + 1
            if idletime >= 200 then
                lerpz(RJ, "C0", RJC0 * CFrame.new(0, 0, 0.1 + (math.cos(sine/64) * -0.1)), 0.05)
                lerpz(N, "C0", NC0, 0.05)
                lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(25 + (math.cos(sine/64) * -4))), 0.05)
                lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-(25 + (math.cos(sine/64) * -4)))), 0.05)
                lerpz(RH, "C0", RHC0 * CFrame.new(0, 0.1 + (math.cos(sine/64) * 0.1), 0) * CFrame.Angles(math.rad(-5), 0, 0), 0.05)
                lerpz(LH, "C0", LHC0 * CFrame.new(0, 0.1 + (math.cos(sine/64) * 0.1), 0) * CFrame.Angles(math.rad(-5), 0, 0), 0.05)
            else
                lerpz(RJ, "C0", RJC0 * CFrame.new(0, 0, math.cos(sine/64) * -0.1), 0.05)
                lerpz(N, "C0", NC0, 0.05)
                lerpz(RS, "C0", RSC0 * CFrame.Angles(0, 0, math.rad(90 + (math.cos(sine/64) * -4))), 0.05)
                lerpz(LS, "C0", LSC0 * CFrame.Angles(0, 0, math.rad(-(90 + (math.cos(sine/64) * -4)))), 0.05)
                lerpz(RH, "C0", RHC0 * CFrame.new(0, 0.1 + (math.cos(sine/64) * 0.1), 0) * CFrame.Angles(math.rad(-5), 0, 0), 0.05)
                lerpz(LH, "C0", LHC0 * CFrame.new(0, 0.1 + (math.cos(sine/64) * 0.1), 0) * CFrame.Angles(math.rad(-5), 0, 0), 0.05)
            end
        end
    end
end)
