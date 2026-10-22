local plrs       = game:GetService("Players")
local plr        = plrs.LocalPlayer
local tweenserv  = game:GetService("TweenService")
local lighting   = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Debris     = game:GetService("Debris")

local char = plr.Character or plr.CharacterAdded:Wait()
local hum  = char:WaitForChild("Humanoid")
local mou  = plr:GetMouse()
local tor  = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
local root = char:FindFirstChild("HumanoidRootPart")
local head = char:FindFirstChild("Head")
local face = head and head:FindFirstChildOfClass("Decal")
local larm = char:FindFirstChild("Left Arm")  or char:FindFirstChild("LeftUpperArm")
local rarm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
local rleg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
local lleg = char:FindFirstChild("Left Leg")  or char:FindFirstChild("LeftUpperLeg")
local neck = tor:FindFirstChild("Neck")
local rootj= root:FindFirstChild("RootJoint") or root:FindFirstChild("Root")
local LS   = tor:FindFirstChild("Left Shoulder")
local RS   = tor:FindFirstChild("Right Shoulder")
local LH   = tor:FindFirstChild("Left Hip")
local RH   = tor:FindFirstChild("Right Hip")
local bp   = plr:FindFirstChild("Backpack")

-- Kill default animation cleanly
if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
if hum:FindFirstChild("Animator")   then hum.Animator:Destroy() end

-- Save rest poses
local rootj0 = rootj.C0
local neck0  = neck.C0
local LS0    = LS.C0
local RS0    = RS.C0
local LH0    = LH.C0
local RH0    = RH.C0
local rootj1 = rootj.C1
local neck1  = neck.C1
local LS1    = LS.C1
local RS1    = RS.C1
local LH1    = LH.C1
local RH1    = RH.C1

local CFn  = CFrame.new
local CFa  = CFrame.Angles
local Rad  = math.rad
local Sin  = math.sin
local Cos  = math.cos
local sine = 1

-- =========================================================
-- Sword attachment: take the accessory off your own character
-- =========================================================
local penp -- the greatsword part
local hat = char:FindFirstChild("MeshPartAccessory")
if hat and hat:FindFirstChild("Handle") then
    penp = hat.Handle
    local aw = penp:FindFirstChild("AccessoryWeld")
    if aw then aw:Destroy() end
else
    warn("MeshPartAccessory hat not equipped — equip the Corrupt Demonic Greatsword first!")
    return
end

local penpw = Instance.new("Weld", penp)
penpw.Part0 = rarm
penpw.Part1 = penp
penpw.C1 = CFn(0, -1, 0) * CFa(0, 0, Rad(180))
local penpw0 = penpw.C0
local penpw1 = penpw.C1
local penw    = penpw
local penw0   = penw.C0
local penw1   = penw.C1

-- =========================================================
-- State
-- =========================================================
local ws = 16
local jp = 50
local out = false
local ouch = false
local hitok = false
local canattack = true
local stabstate = 1
local Stabbing = false
local Throwing = false
local rot = 1
local dmg = 5

local function swait(num)
    if num == 0 or num == nil then
        RunService.Stepped:Wait()
    else
        for _ = 0, num do RunService.Stepped:Wait() end
    end
end

local function clerp(a, b, t)
    return a:Lerp(b, t)
end

-- =========================================================
-- Sound helper
-- =========================================================
local function clickSound(parent)
    local s = parent:FindFirstChild("Penclickit360")
    if not s then
        s = Instance.new("Sound", parent)
        s.Name = "Penclickit360"
        s.SoundId = "rbxassetid://537744814"
        s.Volume = 5
    end
    s:Play()
end

local function playBlood(part, id)
    local bloodsound = Instance.new("Sound", part)
    bloodsound.Volume = 10
    bloodsound.SoundId = "rbxassetid://" .. id
    bloodsound:Play()
    Debris:AddItem(bloodsound, 1)

    local bloodsplash = Instance.new("ParticleEmitter", part)
    bloodsplash.Lifetime = NumberRange.new(0.7, 1)
    bloodsplash.Speed = NumberRange.new(6)
    bloodsplash.SpreadAngle = Vector2.new(-360, 360)
    bloodsplash.Rate = 1000
    bloodsplash.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0)})
    bloodsplash.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
    bloodsplash.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))})
    bloodsplash.Texture = "rbxassetid://771221224"
    Debris:AddItem(bloodsplash, 1)
    task.delay(0.25, function() bloodsplash.Enabled = false end)
end

local function handleHit(hit)
    if not hitok or hit:IsDescendantOf(char) then return end
    if hit.Parent:FindFirstChildOfClass("Humanoid") then
        hitok = false
        if out then playBlood(hit, "180083298") end
    elseif hit.Parent and hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid") then
        hitok = false
        if out then playBlood(hit, "180083298") end
    end
end

-- =========================================================
-- ToggleSharp (E)
-- =========================================================
function ToggleSharp()
    clickSound(penp)
    if out == false then dmg = 30; out = true
    else dmg = 5; out = false end
end

-- =========================================================
-- Stab (LMB) — alternates between two stances
-- =========================================================
function Stab()
    if canattack ~= true then return end

    if stabstate == 1 then
        Stabbing = true
        canattack = false
        stabstate = 2
        hum.WalkSpeed = 35
        hum.JumpPower = 7
        hitok = true
        penp.Touched:Connect(handleHit)

        for i = 0, 1, .15 do
            penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), i)
            neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
            rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025), i)
            LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
            RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(-30), Rad(-30), Rad(-3)), i)
            LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), 0), i)
            RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), 0), i)
            LS.C0 = clerp(LS.C0, LS0, i)
            RS.C0 = clerp(RS.C0, RS0 * CFa(0, 0, Rad(150)), i)
            LH.C0 = clerp(LH.C0, LH0, i)
            RH.C0 = clerp(RH.C0, RH0, i)
            swait()
        end
        for i = 0, 1, .15 do
            penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), i)
            neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
            rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025), i)
            LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
            RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(20), Rad(-30), Rad(-3)), i)
            LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), 0), i)
            RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), 0), i)
            LS.C0 = clerp(LS.C0, LS0, i)
            RS.C0 = clerp(RS.C0, RS0 * CFa(0, 0, Rad(20)), i)
            LH.C0 = clerp(LH.C0, LH0, i)
            RH.C0 = clerp(RH.C0, RH0, i)
            swait()
        end
        hitok = false
        hum.WalkSpeed = ws
        hum.JumpPower = jp
        canattack = true
        Stabbing = false

    elseif stabstate == 2 then
        canattack = false
        stabstate = 1
        hum.WalkSpeed = 35
        hum.JumpPower = 7
        hitok = true
        penp.Touched:Connect(handleHit)

        for i = 0, 1, .15 do
            penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), i)
            neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
            rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025), i)
            LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
            RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(30), Rad(30), Rad(-3)), i)
            LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), 0), i)
            RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), 0), i)
            LS.C0 = clerp(LS.C0, LS0, i)
            RS.C0 = clerp(RS.C0, RS0 * CFa(0, 0, Rad(150)), i)
            LH.C0 = clerp(LH.C0, LH0, i)
            RH.C0 = clerp(RH.C0, RH0, i)
            swait()
        end
        for i = 0, 1, .15 do
            penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), i)
            neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
            rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025), i)
            LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
            RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(-20), Rad(30), Rad(-3)), i)
            LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), 0), i)
            RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), 0), i)
            LS.C0 = clerp(LS.C0, LS0, i)
            RS.C0 = clerp(RS.C0, RS0 * CFa(0, 0, Rad(20)), i)
            LH.C0 = clerp(LH.C0, LH0, i)
            RH.C0 = clerp(RH.C0, RH0, i)
            swait()
        end
        hitok = false
        hum.WalkSpeed = ws
        hum.JumpPower = jp
        canattack = true
        Stabbing = false
    end
end

-- =========================================================
-- Throw (F) — clone the hat, fling it, animate
-- =========================================================
function Throw()
    if canattack ~= true then return end
    Throwing = true
    canattack = false
    hum.WalkSpeed = 35
    hum.JumpPower = 7
    ouch = true

    for i = 0, 1, .15 do
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, 0, Rad(-90)), i)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025), i)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
        RS.C1 = clerp(RS.C1, RS1 * CFa(0, Rad(-30), Rad(-3)), i)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), 0), i)
        RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), 0), i)
        LS.C0 = clerp(LS.C0, LS0, i)
        RS.C0 = clerp(RS.C0, RS0 * CFa(0, Rad(90), Rad(90)), i)
        LH.C0 = clerp(LH.C0, LH0, i)
        RH.C0 = clerp(RH.C0, RH0, i)
        swait()
    end

    -- Clone the entire hat
    local throwpen = hat:Clone()
    for _, v in ipairs(throwpen:GetChildren()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    throwpen.Parent = workspace

    local throwbod = throwpen:FindFirstChild("Handle")
    if throwbod then
        local bw = throwbod:FindFirstChild("AccessoryWeld")
        if bw then bw:Destroy() end
        local throwbv = Instance.new("BodyVelocity", throwbod)
        throwbv.Velocity = mou.Hit.lookVector * 100
        throwbv.MaxForce = Vector3.new(1e17, 1e17, 1e17)

        throwbod.Touched:Connect(function(hit)
            if ouch and not hit:IsDescendantOf(char) then
                ouch = false
                throwpen:Destroy()
                if hit.Parent:FindFirstChildOfClass("Humanoid") or
                   (hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
                    if out then playBlood(hit, "180083286") end
                end
            end
        end)
    end

    for _, v in ipairs(penp:GetChildren()) do
        if v:IsA("BasePart") then v.Transparency = 1 end
    end
    penp.Transparency = 1

    for i = 0, 1, .1 do
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, 0, Rad(-90)), i)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), i)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025) * CFa(Rad(-20), 0, 0), i)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
        RS.C1 = clerp(RS.C1, RS1 * CFa(0, Rad(-30), Rad(-3)), i)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(-5), Rad(-20)), i)
        RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(5), Rad(-20)), i)
        LS.C0 = clerp(LS.C0, LS0, i)
        RS.C0 = clerp(RS.C0, RS0 * CFa(0, Rad(-80), Rad(90)), i)
        LH.C0 = clerp(LH.C0, LH0, i)
        RH.C0 = clerp(RH.C0, RH0, i)
        swait()
    end
    for i = 0, 1, .1 do
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, 0, Rad(-90)), i)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-30), 0, 0), i)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025) * CFa(0, 0, Rad(-30)), i)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), i)
        RS.C1 = clerp(RS.C1, RS1 * CFa(0, Rad(-30), Rad(-3)), i)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(35), 0), i)
        RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025, 0) * CFa(Rad(5), Rad(35), 0), i)
        LS.C0 = clerp(LS.C0, LS0, i)
        RS.C0 = clerp(RS.C0, RS0 * CFn(0, 0, -0.5) * CFa(0, Rad(90), Rad(30)), i)
        LH.C0 = clerp(LH.C0, LH0, i)
        RH.C0 = clerp(RH.C0, RH0, i)
        swait()
    end
    penp.Transparency = 0
    hum.WalkSpeed = ws
    hum.JumpPower = jp
    canattack = true
    Throwing = false
end

-- =========================================================
-- Input
-- =========================================================
mou.KeyDown:Connect(function(k)
    k = k:lower()
    if k == "e" then ToggleSharp()
    elseif k == "f" then Throw() end
end)
mou.Button1Down:Connect(Stab)

-- =========================================================
-- MAIN ANIMATION LOOP
-- =========================================================
local state = "Idle"
RunService.Stepped:Connect(function()
    sine = sine + 1
    rot  = rot + 25
    if rot >= 360 then rot = 1 end

    local torvel = (root.Velocity * Vector3.new(1,0,1)).magnitude
    if Stabbing then state = "Stabbing"
    elseif Throwing then state = "Throwing"
    elseif root.Velocity.Y > 1 then state = "Jump"
    elseif root.Velocity.Y < -1 then state = "Fall"
    elseif torvel < 1 then state = "Idle"
    elseif tor.Velocity.Magnitude < 50 then state = "Walk"
    end

    if state == "Jump" then
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), 0.15)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2), 0, 0), 0.15)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFa(Rad(-15), 0, 0), 0.15)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(10), 0, 0), 0.15)
        RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(10), 0, 0), 0.15)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.2, 0) * CFa(Rad(2), 0, Rad(-15)), 0.15)
        RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.5, 0) * CFa(Rad(2), 0, Rad(15)), 0.15)
        LS.C0 = clerp(LS.C0, LS0, 0.15)
        RS.C0 = clerp(RS.C0, RS0, 0.15)
        LH.C0 = clerp(LH.C0, LH0 * CFn(-0.2, 0, 0), 0.15)
        RH.C0 = clerp(RH.C0, RH0 * CFn(0.5, 0, 0), 0.15)

    elseif state == "Fall" then
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), 0.15)
        neck.C1 = clerp(neck.C1, neck1 * CFa(0, 0, 0), 0.15)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFa(Rad(15), 0, 0), 0.15)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(35), 0, 0), 0.15)
        RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(35), 0, 0), 0.15)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0.2, -0.2, -0.1) * CFa(Rad(15), 0, Rad(10)), 0.15)
        RH.C1 = clerp(RH.C1, RH1 * CFn(-0.2, -0.2, -0.1) * CFa(Rad(15), 0, Rad(-10)), 0.15)
        LS.C0 = clerp(LS.C0, LS0, 0.15)
        RS.C0 = clerp(RS.C0, RS0, 0.15)
        LH.C0 = clerp(LH.C0, LH0 * CFa(0, 0, Rad(-20)), 0.15)
        RH.C0 = clerp(RH.C0, RH0 * CFa(0, 0, Rad(20)), 0.15)

    elseif state == "Idle" then
        penw.C1 = clerp(penw.C1, penw1 * CFn(0, 0, 0.5) * CFa(0, 0, Rad(rot)), 0.15)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-2*Cos(sine/15)), 0, 0), 0.15)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0, 0.025*Cos(sine/15)), 0.15)
        LS.C1 = clerp(LS.C1, LS1 * CFa(Rad(-30), 0, Rad(-40)), 0.15)
        RS.C1 = clerp(RS.C1, RS1 * CFa(Rad(2), 0, Rad(-3*Cos(sine/15))), 0.15)
        LH.C1 = clerp(LH.C1, LH1 * CFn(0, -0.025*Cos(sine/15), 0) * CFa(Rad(5), Rad(-5), 0), 0.15)
        RH.C1 = clerp(RH.C1, RH1 * CFn(0, -0.025*Cos(sine/15), 0) * CFa(Rad(5), Rad(5), 0), 0.15)
        LS.C0 = clerp(LS.C0, LS0, 0.15)
        RS.C0 = clerp(RS.C0, RS0 * CFa(0, 0, Rad(80)), 0.15)
        LH.C0 = clerp(LH.C0, LH0, 0.15)
        RH.C0 = clerp(RH.C0, RH0, 0.15)

    elseif state == "Walk" then
        penw.C1 = clerp(penw.C1, penw1 * CFa(0, Rad(-90), 0), 0.15)
        neck.C1 = clerp(neck.C1, neck1 * CFa(Rad(-5), 0, 0), 0.15)
        rootj.C1 = clerp(rootj.C1, rootj1 * CFn(0, 0.1*Cos(sine/3), 0.1*Cos(sine/3)) * CFa(Rad(-5), 0, Rad(5*Cos(sine/6))), 0.15)
        LS.C1 = clerp(LS.C1, LS1 * CFa(0, 0, Rad(-50*Cos(sine/6))), 0.15)
        RS.C1 = clerp(RS.C1, RS1 * CFa(0, 0, Rad(-50*Cos(sine/6))), 0.15)
        LH.C1 = clerp(LH.C1, LH1 * CFa(Rad(2), Rad(-5), Rad(50*Cos(sine/6))), 0.15)
        RH.C1 = clerp(RH.C1, RH1 * CFa(Rad(2), Rad(5), Rad(50*Cos(sine/6))), 0.15)
        LS.C0 = clerp(LS.C0, LS0, 0.15)
        RS.C0 = clerp(RS.C0, RS0, 0.15)
        LH.C0 = clerp(LH.C0, LH0, 0.15)
        RH.C0 = clerp(RH.C0, RH0, 0.15)
    end
end)

-- =========================================================
-- Ambient music (one-shot, replaces the broken bottom block)
-- =========================================================
local s = Instance.new("Sound")
s.Name = "Sound"
s.SoundId = "rbxassetid://221057812"
s.Volume = 1
s.Looped = false
s.Parent = workspace
task.wait(2)
s:Play()

print("Corrupt Demonic Greatsword loaded. E = sharpen, LMB = stab, F = throw.")
