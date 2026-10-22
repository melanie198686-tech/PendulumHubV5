--------------------------------------------------------------
-----------//THE NIGHTFALL\\-----------
--[[Movelist
Mouseclick = 3 combos
-Attack 1 = Downwards slash
-Attack 2 = Power slash
-Attack 3 = Whirlwind slash
Q = Impale
E = Forward dash
R = Ear destroyer
T = Taunt
Y = Cutting storm
U = Homing Cutting storm
---------]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunSrv = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local hum = Character:FindFirstChildOfClass("Humanoid")
if hum then hum.Name = "Humanoid" end

local LeftArm = Character:WaitForChild("Left Arm")
local LeftLeg = Character:WaitForChild("Left Leg")
local RightArm = Character:WaitForChild("Right Arm")
local RightLeg = Character:WaitForChild("Right Leg")
local Root = Character:WaitForChild("HumanoidRootPart")
local Head = Character:WaitForChild("Head")
local Torso = Character:WaitForChild("Torso")

-- Disable default animations
local Animate = Character:FindFirstChild("Animate")
if Animate then Animate.Disabled = true end

-- FIX: Destroy the conflicting Motor6Ds so we can use the original script's weld math
for _, joint in pairs(Torso:GetChildren()) do
    if joint:IsA("Motor6D") and joint.Name ~= "Neck" then joint:Destroy() end
end
for _, joint in pairs(Root:GetChildren()) do
    if joint:IsA("Motor6D") then joint:Destroy() end
end

-- Recreate the joints exactly as the original script did
local function createWeld(parent, p0, p1, c0)
    local w = Instance.new("ManualWeld")
    w.Parent = parent
    w.Part0 = p0
    w.Part1 = p1
    w.C0 = c0
    return w
end

local RIGHTARMLERP = createWeld(RightArm, RightArm, Torso, CFrame.new(-1.5, 0, -0))
local LEFTARMLERP = createWeld(LeftArm, LeftArm, Torso, CFrame.new(1.5, 0, -0))
local RIGHTLEGLERP = createWeld(RightLeg, RightLeg, Torso, CFrame.new(-0.5, 2, 0))
local LEFTLEGLERP = createWeld(LeftLeg, LeftLeg, Torso, CFrame.new(0.5, 2, 0))
local ROOTLERP = createWeld(Root, Root, Torso, CFrame.new(0, 0, 0))

local Ne = Torso:WaitForChild("Neck")
local HEADLERP = createWeld(Head, Head, Head, CFrame.new(0, -1.5, -0))

local walking = false
local singularitybounce = false
local jumping = false
local targetfound = false
local grabbed = false
local attacking = false
local firsttime = false
local dash1 = true
local dash2 = false
local tauntdebounce = false
local mouse = Player:GetMouse()
local position = nil
local MseGuide = true
local running = false
local settime = 0
local sine = 0
local t = 0
local ws = 19
local jp = 100
local secondform = false
local change = 1
local combo1 = true
local dancing = false
local equip = false
local dgs = 75
local dedlaff = false
local combo2 = false
local spin1 = true
local spin2 = false
local switch1 = true
local switch2 = false
local firsttime2 = false
local isattacking = false
local combo3 = false
local gunallowance = false
local cooldown = false
local shooting = false

local slasher = {1543186629,1543187082,1543187280,1543186883}
local slasher2 = {220834019,220834000,220833976,220833967}
local slash = #slasher
local slash2 = #slasher2

-- FIXED LINE 94 (PlayerGui instead of script.Parent)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Player:WaitForChild("PlayerGui")

local function MAKETRAIL(PARENT, POS1, POS2, LIFETIME, COLOR)
    local A = Instance.new("Attachment", PARENT)
    A.Position = POS1
    local B = Instance.new("Attachment", PARENT)
    B.Position = POS2
    local tr = Instance.new("Trail", PARENT)
    tr.Attachment0 = A
    tr.Attachment1 = B
    tr.Enabled = true
    tr.Lifetime = LIFETIME
    tr.TextureMode = Enum.TextureMode.Static
    tr.LightInfluence = 0
    tr.Color = COLOR
    tr.Transparency = NumberSequence.new(0, 1)
end

local footsteps = Instance.new("Sound",Torso)
footsteps.SoundId = "rbxassetid://1244506786"
footsteps.Volume = 0
footsteps.Looped = true
footsteps.Pitch = 1.6
footsteps.Name = "fp"
footsteps:Play()

slash = slasher[math.random(1,#slasher)]
local slashs = Instance.new("Sound",RightArm)
slashs.SoundId = "rbxassetid://"..slash
slashs.Volume = 10
slashs.Name = "slashs"

local introsound = Instance.new("Sound",Torso)
introsound.SoundId = "rbxassetid://1842444810"
introsound.Volume = 4
introsound:Play()

task.spawn(function()
    local doomtheme = Instance.new("Sound",Torso)
    doomtheme.Volume = 0
    doomtheme.SoundId = "rbxassetid://2114921530"
    doomtheme.Looped = true
    doomtheme:Play()
    doomtheme.Name = "doomtheme"
    for i = 1, 20 do
        doomtheme.Volume = doomtheme.Volume + .1
        task.wait()
    end
end)

local leftlocation = Instance.new("Part",LeftArm)
leftlocation.Size = Vector3.new(1,1,1)
leftlocation.Transparency = 1
local leftlocweld = createWeld(leftlocation, leftlocation, LeftArm, CFrame.new(0,1.2,0))

local rightlocation = Instance.new("Part",RightArm)
rightlocation.Size = Vector3.new(1,1,1)
rightlocation.Transparency = 1
local rightlocweld = createWeld(rightlocation, rightlocation, RightArm, CFrame.new(0,1.2,0))

local A = Instance.new("Attachment", rightlocation)
A.Position = Vector3.new(.1,.3,.1)
local B = Instance.new("Attachment", rightlocation)
B.Position = Vector3.new(-.1,-.3,-.1)
local tr1 = Instance.new("Trail", rightlocation)
tr1.Attachment0 = A
tr1.Attachment1 = B
tr1.Enabled = false
tr1.Lifetime = .6
tr1.TextureMode = Enum.TextureMode.Static
tr1.LightInfluence = 0
tr1.Color = ColorSequence.new(BrickColor.new("Eggplant").Color, BrickColor.new("Really black").Color)
tr1.Transparency = NumberSequence.new(0, 1)

local mas = Instance.new("Model",Head) 
mas.Name = "Model2Script"
local o1 = Instance.new("Model")
local o2 = Instance.new("Part", o1)
o2.Name = "Head"
o2.Material = Enum.Material.SmoothPlastic
o2.BrickColor = BrickColor.new("Really black")
o2.Transparency = 1
o2.Size = Vector3.new(1.99999988, 0.99999994, 0.99999994)
o2.CFrame = CFrame.new(12.5892553, 4.50960207, -3.75727963, 0.998376548, -0.000250246754, 0.0569584854, 0.000245001953, 1.00000846, 9.91025372e-05, -0.056957975, -8.49864373e-05, 0.998385131)
o1.Parent = mas
mas.Parent = workspace
mas:MakeJoints()

for _,v in pairs(Character:GetChildren()) do
    if v.ClassName == "Pants" or v.ClassName == "Hat" or v.ClassName == "CharacterMesh" or v.ClassName == "Shirt Graphic" then
        v:Destroy()
    end
end

local shirt = Instance.new("Shirt", Character)
shirt.ShirtTemplate = "rbxassetid://863473913"

task.spawn(function()
    while task.wait() do
        if Head:FindFirstChild("face") then
            if secondform then
                Head.face.Texture = "rbxassetid://1127768638"
            else
                Head.face.Texture = "rbxassetid://629947734"
            end
        end
        hum.WalkSpeed = 50
        hum.JumpPower = 125
        LeftArm.BrickColor = BrickColor.new("Really black")
        RightArm.BrickColor = BrickColor.new("Really black")
        Head.BrickColor = BrickColor.new("Really black")
        Torso.BrickColor = BrickColor.new("Really black")
        LeftLeg.BrickColor = BrickColor.new("Really black")
        RightLeg.BrickColor = BrickColor.new("Really black")
    end
end)

task.spawn(function()
    hum.MaxHealth = math.huge
    task.wait(.00001)
    hum.Health = math.huge
end)

local ff = Instance.new("ForceField", Character)
ff.Visible = false

local function damagealll(Radius,Position)		
    local Returning = {}		
    for _,v in pairs(workspace:GetChildren()) do		
        if v ~= Character and v:FindFirstChildOfClass('Humanoid') then
            local targetTorso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
            if targetTorso then
                local Mag = (targetTorso.Position - Position).Magnitude		
                if Mag < Radius then		
                    table.insert(Returning,v)		
                end
            end
        end		
    end		
    return Returning		
end

local function ray(pos, dir, rang, ignoredesc)
    return workspace:FindPartOnRay(Ray.new(pos, dir.Unit * rang), ignoredesc)
end

local debounce = false

mouse.Button1Down:Connect(function()
    if debounce or attacking then return end
    debounce = true
    
    if combo1 then
        combo1, combo2, combo3 = false, true, false
        attacking = true
        ws = 12
        local g1 = Instance.new("BodyGyro", Root)
        g1.D, g1.P = 175, 20000
        g1.MaxTorque = Vector3.new(0,9000,0)
        for i = 1, 12 do
            g1.CFrame = g1.CFrame:Lerp(CFrame.new(Root.Position,mouse.Hit.Position),.4)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(.4,-.2,-.2) * CFrame.Angles(math.rad(90),math.rad(130),0),.3)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(-2), math.rad(40), 0), 0.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            task.wait()
        end
        tr1.Enabled = true
        slash = slasher[math.random(1,#slasher)]
        slashs.SoundId = "rbxassetid://"..slash
        slashs:Play()
        local hitbox = Instance.new("Part",Torso)
        hitbox.CFrame = Root.CFrame * CFrame.new(1,0,-3)
        hitbox.Anchored, hitbox.Transparency, hitbox.CanCollide = true, 1, false
        hitbox.Size = Vector3.new(1,1,1)
        
        local Hit = damagealll(3,hitbox.Position)
        for _,v in pairs(Hit) do
            local victimHum = v:FindFirstChildOfClass("Humanoid")
            if victimHum and victimHum.Health > 0 then
                victimHum.Health = 0
                slash2 = slasher2[math.random(1,#slasher2)]
                local targetTorso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
                if targetTorso then
                    local damagesound = Instance.new("Sound",targetTorso)
                    damagesound.SoundId = "rbxassetid://"..slash2
                    damagesound.Volume = 8
                    damagesound:Play()
                    Debris:AddItem(damagesound,4)
                end
            end
        end
        ws = 6
        for i = 1, 12 do
            g1.CFrame = g1.CFrame:Lerp(CFrame.new(Root.Position,mouse.Hit.Position),.4)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(.2,1.4,-.3) * CFrame.Angles(math.rad(90),math.rad(230),0),.3)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(2), math.rad(-60), 0), 0.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            task.wait()
        end
        g1:Destroy()
        hitbox:Destroy()
        tr1.Enabled = false
        attacking = false
        debounce = false
        ws = 19
        
    elseif combo2 then
        combo1, combo2, combo3 = false, false, true
        attacking = true
        ws = 12
        local g1 = Instance.new("BodyGyro", Root)
        g1.D, g1.P = 175, 20000
        g1.MaxTorque = Vector3.new(0,9000,0)
        for i = 1, 12 do
            g1.CFrame = g1.CFrame:Lerp(CFrame.new(Root.Position,mouse.Hit.Position),.4)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(2), math.rad(-40), 0), 0.3)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-.3,1.8,-0) * CFrame.Angles(math.rad(-120),math.rad(99),0),.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            task.wait()
        end
        tr1.Enabled = true
        slash = slasher[math.random(1,#slasher)]
        slashs.SoundId = "rbxassetid://"..slash
        slashs:Play()
        
        local hitbox = Instance.new("Part",Torso)
        hitbox.CFrame = Root.CFrame * CFrame.new(1,0,-3)
        hitbox.Anchored, hitbox.Transparency, hitbox.CanCollide = true, 1, false
        hitbox.Size = Vector3.new(1,1,1)
        
        local Hit = damagealll(3,hitbox.Position)
        for _,v in pairs(Hit) do
            local victimHum = v:FindFirstChildOfClass("Humanoid")
            if victimHum and victimHum.Health > 0 then
                victimHum.Health = 0
                slash2 = slasher2[math.random(1,#slasher2)]
                local targetTorso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
                if targetTorso then
                    local damagesound = Instance.new("Sound",targetTorso)
                    damagesound.SoundId = "rbxassetid://"..slash2
                    damagesound.Volume = 8
                    damagesound:Play()
                    Debris:AddItem(damagesound,4)
                end
            end
        end
        for i = 1, 12 do
            g1.CFrame = g1.CFrame:Lerp(CFrame.new(Root.Position,mouse.Hit.Position),.4)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(-2), math.rad(40), 0), 0.3)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-.8,-.25,0) * CFrame.Angles(math.rad(-60),math.rad(-70),0),.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            task.wait()
        end
        g1:Destroy()
        tr1.Enabled = false
        debounce = false
        hitbox:Destroy()
        attacking = false
        ws = 19
        
    elseif combo3 then
        combo1, combo2, combo3 = true, false, false
        attacking = true
        local spinny = 0
        ws = 16
        local spinnysound = Instance.new("Sound",Torso)
        spinnysound.SoundId = "rbxassetid://1290491542"
        spinnysound.Volume = 8
        spinnysound.Pitch = .8
        spinnysound:Play()
        tr1.Enabled = true
        local hitbox = Instance.new("Part",Torso)
        hitbox.CFrame = Root.CFrame * CFrame.new(1,0,-3)
        hitbox.Anchored, hitbox.Transparency, hitbox.CanCollide = true, 1, false
        hitbox.Size = Vector3.new(1,1,1)
        if spin1 then spin1, spin2 = false, true else spin1, spin2 = true, false end
        
        for i = 1, 45 do
            hitbox.CFrame = Root.CFrame * CFrame.new(1,0,-3)
            local Hit = damagealll(3,hitbox.Position)
            for _,v in pairs(Hit) do
                local victimHum = v:FindFirstChildOfClass("Humanoid")
                if victimHum and victimHum.Health > 0 then
                    victimHum.Health = 0
                end
            end
            if spin1 then
                spinny = spinny - 45
                RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-.3,1.4,.5) * CFrame.Angles(math.rad(-90),math.rad(90),0),.3)
                LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.55,.55,0)* CFrame.Angles(math.rad(10),math.rad(-5),math.rad(35)),.3)
                ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(40)), 0.3)
                ROOTLERP.C1 = ROOTLERP.C1:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(spinny), 0), 0.3)
                RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
                LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            elseif spin2 then
                spinny = spinny - 45
                RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-.3,1.4,.5) * CFrame.Angles(math.rad(-90),math.rad(90),0),.3)
                LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.55,.55,0)* CFrame.Angles(math.rad(10),math.rad(-5),math.rad(35)),.3)
                ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-40)), 0.3)
                ROOTLERP.C1 = ROOTLERP.C1:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(spinny), 0), 0.3)
                RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
                LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            end
            task.wait()
        end
        tr1.Enabled = false
        spinnysound:Destroy()
        attacking = false
        debounce = false
        spinny = 0
        ROOTLERP.C1 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
        ws = 19
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    local Press = input.KeyCode.Name:lower()
    
    if Press == 'q' then
        if mouse.Target and mouse.Target.Parent ~= Character then
            local enemyHum = mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
            if enemyHum and enemyHum.Health > 0 then
                if debounce or attacking then return end
                debounce = true
                attacking = true
                local targetfound = false
                local enemy = enemyHum
                local sound = Instance.new("Sound", Torso)
                sound.SoundId = "rbxassetid://862693565"
                sound.Volume = 10
                sound:Play()
                Debris:AddItem(sound, 5)
                
                for i = 1, 400 do
                    if targetfound then break end
                    local Hit = damagealll(5,Torso.Position)
                    for _,v in pairs(Hit) do
                        if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Parent.Name == enemy.Parent.Name then
                            targetfound = true
                        end
                    end
                    local enemyTorso = enemy.Parent:FindFirstChild("UpperTorso") or enemy.Parent:FindFirstChild("Torso")
                    if enemyTorso then
                        hum:MoveTo(enemyTorso.Position)
                    end
                    footsteps.Volume = 2
                    footsteps.Pitch = 2.2
                    ws = 30
                    change = 2
                    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.15,-.3) * CFrame.Angles(math.rad(50 + 5 * math.sin(sine/8)),0,math.rad(-10)),.3)
                    LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.1,-.15,.5) * CFrame.Angles(math.rad(-70),math.rad(40),math.rad(-20)),.3)
                    ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.07 + 0.2*math.sin(sine/3.5), 0) * CFrame.Angles(math.rad(-30), 0, math.rad(0) + Root.RotVelocity.Y / 30), 0.3)
                    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.52, 1.9 - 0.35 * math.cos(sine/7)/2.8, -.3  + 0.2 - math.sin(sine/7)/3.4) * CFrame.Angles(math.rad(25 - 35) + -math.sin(sine/7)/2.3, math.rad(0)*math.cos(sine/7), 0), 0.3)
                    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.52, 1.9 + 0.35 * math.cos(sine/7)/2.8, -.3 + 0.2 + math.sin(sine/7)/3.4) * CFrame.Angles(math.rad(25 - 35) - -math.sin(sine/7)/2.3, math.rad(0)*math.cos(sine/1), 0), 0.3)
                    task.wait()
                end
                
                if targetfound then
                    ws = 0
                    enemy.WalkSpeed = 0
                    local sound2 = Instance.new("Sound", rightlocation)
                    sound2.SoundId = "rbxassetid://862701802"
                    sound2.Volume = 9
                    sound2:Play()
                    Debris:AddItem(sound2, 5)
                    
                    footsteps.Volume = 0
                    for i = 1, 12 do
                        LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
                        ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.175, 0) * CFrame.Angles(0, math.rad(60), 0), 0.3)
                        RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
                        LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
                        RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.79,.05) * CFrame.Angles(math.rad(190),0,math.rad(-10)),.3)
                        task.wait()
                    end
                    
                    local locationpartz = Instance.new("Part",Torso)
                    locationpartz.Size = Vector3.new(1,1,1)
                    locationpartz.Anchored, locationpartz.Transparency, locationpartz.CanCollide = false, 1, false
                    locationpartz.CFrame = rightlocation.CFrame * CFrame.new(0,-1.5,0)
                    
                    local enemyTorso = enemy.Parent:FindFirstChild("UpperTorso") or enemy.Parent:FindFirstChild("Torso")
                    if enemyTorso then
                        enemyTorso.CFrame = locationpartz.CFrame * CFrame.new(1,0,0) * CFrame.Angles(math.rad(-90),0,0)
                        local weldofweld = createWeld(locationpartz, locationpartz, enemyTorso, CFrame.Angles(math.rad(-90),0,0))
                    end
                    locationpartz.Anchored = true
                    local sound3 = Instance.new("Sound",RightArm)
                    sound3.SoundId = "rbxassetid://877870515"
                    sound3.Volume = 7
                    sound3:Play()
                    Debris:AddItem(sound3, 6)
                    
                    for i = 1, 250 do
                        locationpartz.CFrame = rightlocation.CFrame * CFrame.new(0,-1.5,0) 
                        LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.44,-.125) * CFrame.Angles(math.rad(48),0,math.rad(30)), 0.02)
                        ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.175, 0) * CFrame.Angles(0, math.rad(60), 0), 0.03)
                        RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.03)
                        LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.03)
                        RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.79,.05) * CFrame.Angles(math.rad(190),0,math.rad(-12)),.03)
                        task.wait()
                    end
                    
                    local ded = Instance.new("Sound",enemyTorso or Torso)
                    ded.SoundId = "rbxassetid://429400881"
                    ded.Volume = 9
                    ded.Pitch = .9
                    ded:Play()
                    
                    task.spawn(function()
                        local energyplosion = Instance.new("Part",Torso)
                        if enemyTorso then energyplosion.CFrame = enemyTorso.CFrame end
                        energyplosion.Size = Vector3.new(.1,.1,.1)
                        energyplosion.BrickColor = BrickColor.new("Alder")
                        energyplosion.Anchored, energyplosion.CanCollide, energyplosion.Transparency = true, false, 0
                        energyplosion.Shape, energyplosion.Material = Enum.PartType.Ball, Enum.Material.Neon
                        
                        for i = 1, 20 do
                            enemy.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
                            hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
                            energyplosion.Size = energyplosion.Size + Vector3.new(2,2,2)
                            energyplosion.Transparency = energyplosion.Transparency + .05
                            task.wait()
                        end
                        hum.CameraOffset = Vector3.new(0,0,0)
                        enemy.CameraOffset = Vector3.new(0,0,0)
                        energyplosion:Destroy()
                    end)
                    locationpartz:Destroy()
                    enemy.Health = 0
                    ws = 19
                    debounce = false
                    attacking = false
                else
                    ws = 19
                    debounce = false
                    attacking = false
                end
            end
        end
        
    elseif Press == 'y' then
        if debounce or attacking then return end
        debounce, attacking = true, true
        ws = 12
        local g1 = Instance.new("BodyGyro", Root)
        g1.D, g1.P = 175, 20000
        g1.MaxTorque = Vector3.new(0,9000,0)
        
        local chargo = Instance.new("Sound",rightlocation)
        chargo.SoundId = "rbxassetid://306181935"
        chargo.Volume = 7
        chargo.Pitch = 1.1
        chargo:Play()
        Debris:AddItem(chargo,5)
        
        for i = 1, 120 do
            task.spawn(function()
                local sk = Instance.new("Part",Torso)
                sk.CanCollide, sk.Anchored, sk.BrickColor = false, true, BrickColor.new("Alder")
                sk.CFrame = rightlocation.CFrame * CFrame.Angles(math.rad(math.random(-180,180)),0,math.rad(math.random(-180,180)))
                local skmesh = Instance.new("SpecialMesh",sk)
                skmesh.MeshId = "rbxassetid://662586858"
                skmesh.Scale = Vector3.new(.01,.001,.01)
                for i = 1, 20 do
                    skmesh.Scale = skmesh.Scale + Vector3.new(.01,0,.01)
                    sk.Transparency = sk.Transparency + .05
                    task.wait()
                end
                sk:Destroy()
            end)
            g1.CFrame = g1.CFrame:Lerp(CFrame.new(Root.Position,mouse.Hit.Position),.4)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(2), math.rad(-40), 0), 0.03)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-.3,1.8,-0) * CFrame.Angles(math.rad(-120),math.rad(99),0),.03)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.03)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.03)
            task.wait()
        end
        
        task.spawn(function()
            local bullet = Instance.new("Part",Torso)
            bullet.CanCollide, bullet.Anchored = false, false
            bullet.Size, bullet.Transparency = Vector3.new(2,2,2), .5
            bullet.Shape, bullet.Material = Enum.PartType.Ball, Enum.Material.Neon
            bullet.BrickColor = BrickColor.new("Alder")
            bullet.CFrame = rightlocation.CFrame
            local energloop = Instance.new("Sound",bullet)
            energloop.Volume = 6
            energloop.SoundId = "rbxassetid://2607597779"
            energloop.Looped = true
            energloop:Play()
            
            MAKETRAIL(bullet, Vector3.new(.2,.2,0), Vector3.new(-.2,-.2,0), .5, ColorSequence.new(BrickColor.new("Alder").Color, BrickColor.new("Eggplant").Color))
            local bov = Instance.new("BodyVelocity",bullet)
            bov.MaxForce = Vector3.new(99999,99999,99999)
            bullet.CFrame = CFrame.new(bullet.Position,mouse.Hit.Position)
            bov.Velocity = bullet.CFrame.LookVector*180
            
            for i = 1, 225 do
                local Hit = damagealll(15,bullet.Position)
                for _,v in pairs(Hit) do
                    local victimHum = v:FindFirstChildOfClass("Humanoid")
                    if victimHum and v.Name ~= Player.Name then
                        victimHum.Health = 0
                        local targetTorso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
                        if targetTorso then
                            local vel = Instance.new("BodyVelocity", targetTorso) 
                            vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            vel.Velocity = CFrame.new(bullet.Position, targetTorso.Position).LookVector*120
                            Debris:AddItem(vel,.1)
                        end
                    end
                end
                task.wait()
            end
            bullet:Destroy()
        end)
        
        local bems = Instance.new("Sound",rightlocation)
        bems.SoundId = "rbxassetid://1351572613"
        bems.Volume = 8
        bems:Play()
        Debris:AddItem(bems,5)
        
        for i = 1, 12 do
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(.2,1.4,-.3) * CFrame.Angles(math.rad(90),math.rad(230),0),.3)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(38 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(-8), math.rad(60), 0), 0.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(-10)), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .1) * CFrame.Angles(0, 0, math.rad(10)), 0.3)
            task.wait()
        end
        g1:Destroy()
        debounce = false
        attacking = false
        
    elseif Press == 't' then
        if debounce or attacking or tauntdebounce then return end
        debounce, attacking = true, true
        ws = 4
        task.spawn(function()
            for i = 1, 60 do 
                RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2, .5) * CFrame.Angles(math.rad(20), 0, math.rad(-10)), 0.2)
                LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2, .5) * CFrame.Angles(math.rad(20), 0, math.rad(10)), 0.2)
                ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.165, 0) * CFrame.Angles(math.rad(20), 0, 0),.2)
                LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.64 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(45)), 0.2)
                RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.9 + .02 * math.sin(sine/12),.05) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(-45)), 0.2)
                task.wait()
            end
            debounce, attacking = false, false
            ws = 19
        end)
        tauntdebounce = true
        local tauntsound = Instance.new("Sound", Head)
        tauntsound.Volume = 10
        tauntsound.SoundId = "rbxassetid://246480487"
        tauntsound:Play()
        task.wait(3)
        task.wait(tauntsound.TimeLength)
        tauntsound:Destroy()
        task.wait(1)
        tauntdebounce = false
        
    elseif Press == 'e' then
        if debounce or attacking then return end
        debounce, attacking = true, true
        task.spawn(function()
            if dash1 then
                dash1, dash2 = false, true
            elseif dash2 then
                dash1, dash2 = true, false
            end
            for i = 1, 30 do
                RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.15,-.3) * CFrame.Angles(math.rad(50 + 5 * math.sin(sine/8)),0,math.rad(-10)),.3)
                LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.1,-.15,.5) * CFrame.Angles(math.rad(-70),math.rad(40),math.rad(-20)),.3)
                ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.25, 0) * CFrame.Angles(math.rad(-30), 0, Root.RotVelocity.Y / 30), 0.3)
                RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.52, 1.9, .3) * CFrame.Angles(math.rad(25), 0, math.rad(-2)), 0.3)
                LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.52, 1.9,-.2) * CFrame.Angles(math.rad(-25), 0, 0), 0.3)
                task.wait()
            end
            local boomsound = Instance.new("Sound",Torso)
            boomsound.SoundId = "rbxassetid://1177784919"
            boomsound.Volume = 8
            boomsound:Play()
            Debris:AddItem(boomsound,5)
            
            for i = 1, 30 do
                local Hit = damagealll(16,Torso.Position)
                for _,v in pairs(Hit) do
                    local victimHum = v:FindFirstChildOfClass("Humanoid")
                    if victimHum and victimHum.Health > 0 then
                        victimHum.Health = 0
                        local targetTorso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
                        if targetTorso then
                            local vel = Instance.new("BodyVelocity", targetTorso) 
                            vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            vel.Velocity = CFrame.new(Torso.Position,targetTorso.Position).LookVector*90
                            Debris:AddItem(vel,.1)
                        end
                    end
                end
                Root.CFrame = Root.CFrame * CFrame.new(0,0,-2.4)
                task.wait()
            end
            debounce, attacking = false, false
        end)
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    local Press = input.KeyCode.Name:lower()
    
    if Press == 'r' then
        if mouse.Target and mouse.Target.Parent ~= Character then
            local enemy = mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
            if enemy and enemy.Health > 0 then
                if debounce or attacking then return end
                debounce, attacking = true, true
                local grabbed = false
                
                ws = 8
                for i = 1, 20 do
                    ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(-2), math.rad(40), 0), 0.3)
                    LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(.3,1.62,-.07) * CFrame.Angles(math.rad(-120),math.rad(-99),0),.3)
                    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.52, 1.9, .3) * CFrame.Angles(math.rad(25), 0, math.rad(-2)), 0.3)
                    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.52, 1.9,-.2) * CFrame.Angles(math.rad(-25), 0, 0), 0.3)
                    task.wait()
                end
                for i = 1, 20 do
                    if grabbed then break end
                    local Hit = damagealll(5,rightlocation.Position)
                    for _,v in pairs(Hit) do
                        local victimHum = v:FindFirstChildOfClass("Humanoid")
                        if victimHum and victimHum.Parent.Name == enemy.Parent.Name then
                            grabbed = true
                        end
                    end
                    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.52, 1.9, .3) * CFrame.Angles(math.rad(25), 0, math.rad(-2)), 0.3)
                    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.52, 1.9,-.2) * CFrame.Angles(math.rad(-25), 0, 0), 0.3)
                    LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.25,-.18,.2) * CFrame.Angles(math.rad(-70),math.rad(40),0),.3)
                    ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(-2), math.rad(-40), 0), 0.3)
                    task.wait()
                end
                if grabbed then
                    ws = 0
                    enemy.WalkSpeed = 0
                    local enemyWeld = createWeld(enemy.Parent.Head, enemy.Parent.Head, leftlocation, CFrame.new(0,-.6,0) * CFrame.Angles(math.rad(90),0,math.rad(180)))
                    
                    for i = 1, 35 do
                        ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.165 + -.1 * math.sin(sine/12), 0) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)),0,0),.1)
                        RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.4 + .02 * math.sin(sine/12),.10 * -math.sin(sine/12)) * CFrame.Angles(math.rad(-10 + 10 * math.sin(sine/12)),0,math.rad(-25)), 0.1)
                        RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2 - .1 * math.sin(sine/12), .1) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(-10)), 0.1)
                        LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2.0 - .1 * math.sin(sine/12), .1) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(10)), 0.1)
                        LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.4,.8,.39) * CFrame.Angles(math.rad(-138),0,0),.3)
                        task.wait()
                    end
                    enemy.Health = 0
                    enemyWeld:Destroy()
                end
                debounce, attacking = false, false
                ws = 19
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        local RootVel = Root.AssemblyLinearVelocity
        local hf = ray(Root.Position, Vector3.new(0,-1,0), 9, Character)
        if RootVel.Y > 1 and hf == nil then
            position = "Jump"
        elseif RootVel.Y < -1 and hf == nil then
            position = "Falling"
        elseif RootVel.Magnitude < 2 and hf ~= nil then
            position = "Idle"
        elseif RootVel.Magnitude > 2 and hf ~= nil then
            position = "Walking"
        end
    end
end)

local anims = task.spawn(function()
    while task.wait() do
        settime = 0.05
        sine = sine + change
        
        if position == "Jump" and not attacking then
            change = 1
            ws = 35
            footsteps.Volume = 0
            LEFTLEGLERP.C1 = LEFTLEGLERP.C1:Lerp(CFrame.new(0,0,0),.1)
            RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:Lerp(CFrame.new(0,0,0),.1)
            LEFTARMLERP.C1 = LEFTARMLERP.C1:Lerp(CFrame.new(0,0,0),.4)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0), 0.4)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.2)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(-10)), 0.2)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.5, 1, .9) * CFrame.Angles(math.rad(20), 0, 0), 0.4)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.5, 1.0, .9) * CFrame.Angles(math.rad(20), 0, 0), 0.4)
            
        elseif position == "Falling" and not attacking then
            change = 1
            ws = 19
            footsteps.Volume = 0
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(15), 0, 0), 0.15)
            LEFTLEGLERP.C1 = LEFTLEGLERP.C1:Lerp(CFrame.new(0,0,0),.1)
            RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:Lerp(CFrame.new(0,0,0),.1)
            LEFTARMLERP.C1 = LEFTARMLERP.C1:Lerp(CFrame.new(0,0,0),.4)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.5, 2, .5) * CFrame.Angles(math.rad(8), math.rad(4), 0), 0.2)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.5, 2, .5) * CFrame.Angles(math.rad(8), math.rad(-4), 0), 0.2)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.64 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(45)), 0.2)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.9 + .02 * math.sin(sine/12),.05) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(-45)), 0.2)
            
        elseif position == "Walking" and not attacking then
            change = 1.2
            ws = 19
            footsteps.Volume = 2
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.15,-.3) * CFrame.Angles(math.rad(50 + 5 * math.sin(sine/8)),0,math.rad(-10)),.3)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.1,-.15,.5) * CFrame.Angles(math.rad(-70),math.rad(40),math.rad(-20)),.3)
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.07 + 0.2*math.sin(sine/3.5), 0) * CFrame.Angles(math.rad(-30), 0, Root.RotVelocity.Y / 30), 0.3)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.52, 1.9 - 0.35 * math.cos(sine/7)/2.8, -.3  + 0.2 - math.sin(sine/7)/3.4) * CFrame.Angles(math.rad(25 - 35) + -math.sin(sine/7)/2.3, 0, 0), 0.3)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.52, 1.9 + 0.35 * math.cos(sine/7)/2.8, -.3 + 0.2 + math.sin(sine/7)/3.4) * CFrame.Angles(math.rad(25 - 35) - -math.sin(sine/7)/2.3, 0, 0), 0.3)
            
        elseif position == "Idle" and not attacking then
            change = .5
            ws = 19
            footsteps.Volume = 0
            ROOTLERP.C0 = ROOTLERP.C0:Lerp(CFrame.new(0, -.165 + -.1 * math.sin(sine/12), 0) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)),0,0),.1)
            LEFTARMLERP.C0 = LEFTARMLERP.C0:Lerp(CFrame.new(1.5,.14 + .02 * math.sin(sine/12),-.125) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),0,math.rad(10)), 0.1)
            RIGHTARMLERP.C0 = RIGHTARMLERP.C0:Lerp(CFrame.new(-1.5,.4 + .02 * math.sin(sine/12),.10 * -math.sin(sine/12)) * CFrame.Angles(math.rad(-10 + 10 * math.sin(sine/12)),0,math.rad(-25)), 0.1)
            RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:Lerp(CFrame.new(-0.3, 2 - .1 * math.sin(sine/12), .1) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(-10)), 0.1)
            LEFTLEGLERP.C0 = LEFTLEGLERP.C0:Lerp(CFrame.new(0.3, 2.0 - .1 * math.sin(sine/12), .1) * CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(10)), 0.1)
        end
    end
end)

hum.JumpPower = 100
hum.AutoJumpEnabled = true
