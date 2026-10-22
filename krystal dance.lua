--[[
    KRYSTAL DANCE V2 – Rebuilt for stability
    All dances included (Q, E, R, T, Y, U, P, F, G, H, J, K)
   YESIIIRR MADE BY Melanie
]]

-- Wait for character
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- R6 part detection (fallback for R15)
local function getPart(name)
    local part = char:FindFirstChild(name)
    if not part then
        -- try alternate R15 names
        local alt = {
            ["Left Arm"] = "LeftUpperArm",
            ["Right Arm"] = "RightUpperArm",
            ["Left Leg"] = "LeftLowerLeg",
            ["Right Leg"] = "RightLowerLeg",
            ["Torso"] = "UpperTorso"
        }
        part = char:FindFirstChild(alt[name])
    end
    return part
end

local torso = getPart("Torso")
local head = char:FindFirstChild("Head")
local leftArm = getPart("Left Arm")
local rightArm = getPart("Right Arm")
local leftLeg = getPart("Left Leg")
local rightLeg = getPart("Right Leg")
local neck = torso:FindFirstChild("Neck") or torso:FindFirstChild("NeckR15")

if not (torso and head and leftArm and rightArm and leftLeg and rightLeg and neck) then
    warn("Missing body parts – use R6 or ensure all limbs exist")
    return
end

-- Create welds for limb manipulation
local function makeWeld(parent, part0, part1, c0)
    local w = Instance.new("ManualWeld", parent)
    w.Part0 = part0
    w.Part1 = part1 or part0
    w.C0 = c0 or CFrame.new()
    return w
end

local rootWeld = makeWeld(root, root, torso, CFrame.new(0, 0, 0))
rootWeld.C1 = CFrame.new(0, 0, 0)
local leftArmW = makeWeld(leftArm, leftArm, torso, CFrame.new(1.5, 0, 0))
local rightArmW = makeWeld(rightArm, rightArm, torso, CFrame.new(-1.5, 0, 0))
local leftLegW = makeWeld(leftLeg, leftLeg, torso, CFrame.new(0.5, 2, 0))
local rightLegW = makeWeld(rightLeg, rightLeg, torso, CFrame.new(-0.5, 2, 0))
local neckW = neck  -- we'll modify neck.C0 directly

-- Helper: safe lerp with nil checks
local function lerpWeld(weld, targetC0, alpha)
    if weld and targetC0 then
        weld.C0 = weld.C0:Lerp(targetC0, alpha)
    end
end

-- State variables
local dancing = false
local attacking = false
local danceType = nil
local sine = 0
local ws = 16
local change = 1

-- Position state (idle, walking, etc.)
local position = "Idle"

-- Sound helper
local function playSound(id, volume, looped)
    local s = Instance.new("Sound", torso)
    s.SoundId = "rbxassetid://" .. id
    s.Volume = volume or 5
    s.Looped = looped or false
    s:Play()
    game:GetService("Debris"):AddItem(s, 10)
    return s
end

-- Cancel any ongoing dance
local function stopDance()
    dancing = false
    attacking = false
    danceType = nil
    ws = 16
    hum.WalkSpeed = ws
    -- reset any sounds, etc.
    for _, v in pairs(torso:GetChildren()) do
        if v:IsA("Sound") then v:Stop(); v:Destroy() end
    end
end

-- Dance definitions (each returns a function that runs per frame while dancing)
local dances = {
    -- K: Runnin' in the 90's
    k = function()
        local angle = 0
        local jam = playSound("665751753", 8, true)
        jam.TimePosition = 22.3
        return function()
            angle = angle + 11
            lerpWeld(rootWeld, CFrame.new(1 * math.sin(sine/10), 0.1 + 0.8 * math.sin(sine/3), 0) *
                CFrame.Angles(0, 0, math.rad(8 * math.sin(sine/7))), 0.25)
            rootWeld.C1 = rootWeld.C1:Lerp(CFrame.Angles(0, math.rad(angle), 0), 0.25)
            lerpWeld(leftArmW, CFrame.new(1.4, 1.45, 0) * CFrame.Angles(math.rad(180), math.rad(-5 * math.sin(sine/3)), math.rad(-6 * math.sin(sine/3))), 0.25)
            lerpWeld(rightArmW, CFrame.new(-1.4, 1.45, 0) * CFrame.Angles(math.rad(180), math.rad(5 * math.sin(sine/3)), math.rad(6 * math.sin(sine/3))), 0.25)
            lerpWeld(rightLegW, CFrame.new(-0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(-10 + 5 * math.sin(sine/3))), 0.25)
            lerpWeld(leftLegW, CFrame.new(0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(10 - 5 * math.sin(sine/3))), 0.25)
        end
    end,
    -- J: Here comes the money!
    j = function()
        local gyro = Instance.new("BodyGyro", root)
        gyro.D = 175
        gyro.P = 20000
        gyro.MaxTorque = Vector3.new(0, 9000, 0)
        local moneySound = playSound("2426693638", 8, true)
        local robuxPile = Instance.new("Part", torso)
        robuxPile.Size = Vector3.new(1, 1, 1)
        robuxPile.CFrame = leftArm.CFrame
        robuxPile.CanCollide = false
        local pileWeld = makeWeld(robuxPile, robuxPile, torso, leftArm.CFrame:inverse() * torso.CFrame * CFrame.new(1, -0.7, 1.4))
        local mesh = Instance.new("SpecialMesh", robuxPile)
        mesh.MeshType = "FileMesh"
        mesh.Scale = Vector3.new(0.85, 0.85, 0.85)
        mesh.MeshId = "http://www.roblox.com/asset/?id=1285245"
        mesh.TextureId = "http://www.roblox.com/asset/?id=8587344"

        -- spawn robux coins
        local coinSpawn = coroutine.create(function()
            while dancing do
                task.wait(0.35)
                local coin = Instance.new("Part", torso)
                coin.Size = Vector3.new(1, 1, 1)
                coin.CFrame = robuxPile.CFrame * CFrame.Angles(0, math.rad(90), math.rad(90))
                coin.Anchored = false
                coin.CanCollide = true
                local cm = Instance.new("SpecialMesh", coin)
                cm.MeshType = "FileMesh"
                cm.Scale = Vector3.new(1.25, 1.25, 1.25)
                cm.MeshId = "http://www.roblox.com/asset/?id=667285348"
                cm.TextureId = "http://www.roblox.com/asset/?id=665939136"
                local bv = Instance.new("BodyVelocity", coin)
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                local dir = (mouse.Hit.p - coin.Position).unit
                bv.Velocity = dir * 45
                game:GetService("Debris"):AddItem(coin, 4)
                game:GetService("Debris"):AddItem(bv, 0.1)
            end
        end)
        coroutine.resume(coinSpawn)

        return function()
            gyro.CFrame = gyro.CFrame:Lerp(CFrame.new(root.Position, mouse.Hit.p), 0.4)
            lerpWeld(rootWeld, CFrame.new(0, -0.3, 0) * CFrame.Angles(math.rad(20), 0, 0), 0.25)
            lerpWeld(leftArmW, CFrame.new(1, 0.5 + 0.5 * math.sin(sine/2), 0.5) *
                CFrame.Angles(math.rad(-97), math.rad(40 - 20 * math.sin(sine/2)), 0), 0.25)
            lerpWeld(rightArmW, CFrame.new(-1, 0.5, 0.5) * CFrame.Angles(math.rad(-87), math.rad(-20), 0), 0.25)
            lerpWeld(rightLegW, CFrame.new(-0.3, 2, 0.5) * CFrame.Angles(math.rad(20), 0, math.rad(-10)), 0.25)
            lerpWeld(leftLegW, CFrame.new(0.3, 2, 0.5) * CFrame.Angles(math.rad(20), 0, math.rad(10)), 0.25)
        end
    end,
    -- H: The Spongebob
    h = function()
        local sound = playSound("840189092", 8, true)
        sound.TimePosition = 14.8
        local step = 0
        return function()
            step = step + 1
            if step % 30 < 15 then
                lerpWeld(rootWeld, CFrame.new(0.5, -0.4 + 0.1 * math.sin(sine/4), 0) *
                    CFrame.Angles(0, math.rad(20 * math.sin(sine/8)), math.rad(20)), 0.25)
                lerpWeld(rightLegW, CFrame.new(0.25, 2.05, 0) * CFrame.Angles(0, 0, math.rad(-35)), 0.25)
                lerpWeld(leftLegW, CFrame.new(0.31, 2.05, 0) * CFrame.Angles(0, 0, math.rad(14)), 0.25)
            elseif step % 30 < 20 then
                lerpWeld(rootWeld, CFrame.new(0, -0.1 * math.sin(sine/4), 0) *
                    CFrame.Angles(0, math.rad(20 * math.sin(sine/8)), 0), 0.25)
                lerpWeld(rightLegW, CFrame.new(-0.25, 0.7, 1.5) * CFrame.Angles(math.rad(72), math.rad(25), math.rad(-2)), 0.25)
                lerpWeld(leftLegW, CFrame.new(0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(10)), 0.25)
            elseif step % 30 < 25 then
                lerpWeld(rootWeld, CFrame.new(-0.5, -0.4 + 0.1 * math.sin(sine/4), 0) *
                    CFrame.Angles(0, math.rad(20 * math.sin(sine/8)), math.rad(-20)), 0.25)
                lerpWeld(rightLegW, CFrame.new(-0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(-10)), 0.25)
                lerpWeld(leftLegW, CFrame.new(-0.25, 2.05, 0) * CFrame.Angles(0, 0, math.rad(35)), 0.25)
            else
                lerpWeld(rootWeld, CFrame.new(-0.5, -0.1, 0) *
                    CFrame.Angles(0, math.rad(20 * math.sin(sine/8)), 0), 0.25)
                lerpWeld(rightLegW, CFrame.new(-0.31, 2.05, 0) * CFrame.Angles(0, 0, math.rad(-14)), 0.3)
                lerpWeld(leftLegW, CFrame.new(0.25, 0.7, 1.5) * CFrame.Angles(math.rad(72), math.rad(-25), math.rad(-2)), 0.25)
            end
            lerpWeld(rightArmW, CFrame.new(-0.9, 0.65 + 0.4 * math.sin(sine/12), 1.2) *
                CFrame.Angles(math.rad(-35 - 15 * math.sin(sine/12)), math.rad(50 + 3 * math.sin(sine/12)), math.rad(3 - 1 * math.sin(sine/12))), 0.3)
            lerpWeld(leftArmW, CFrame.new(0.9, 0.65 + 0.4 * math.sin(sine/12), 1.2) *
                CFrame.Angles(math.rad(-35 - 15 * math.sin(sine/12)), math.rad(-50 - 3 * math.sin(sine/12)), math.rad(-3 + 1 * math.sin(sine/12))), 0.3)
        end
    end,
    -- G: The Shuffle
    g = function()
        local sound = playSound("168166611", 8, true)
        local step = 0
        return function()
            step = step + 1
            if step % 56 < 28 then
                lerpWeld(rightArmW, CFrame.new(-0.9, 0.65 + 0.4 * math.sin(sine/12), 1.2) *
                    CFrame.Angles(math.rad(-35 - 15 * math.sin(sine/12)), math.rad(50 + 3 * math.sin(sine/12)), math.rad(3 - 1 * math.sin(sine/12))), 0.2)
                lerpWeld(leftArmW, CFrame.new(1.2, 1.5, 0) *
                    CFrame.Angles(math.rad(180 - 7 * math.sin(sine/3)), math.rad(7 * math.sin(sine/3)), math.rad(7 * math.sin(sine/3))), 0.2)
                lerpWeld(rightLegW, CFrame.new(-0.5, 0.7, 1) *
                    CFrame.Angles(math.rad(75 - 10 * math.sin(sine/2)), 0, 0), 0.25)
                lerpWeld(leftLegW, CFrame.new(0.31, 2.05, -0.1) *
                    CFrame.Angles(math.rad(10), 0, math.rad(-2)), 0.3)
            else
                lerpWeld(rightArmW, CFrame.new(-0.9, 0.65 + 0.4 * math.sin(sine/12), 1.2) *
                    CFrame.Angles(math.rad(-35 - 15 * math.sin(sine/12)), math.rad(50 + 3 * math.sin(sine/12)), math.rad(3 - 1 * math.sin(sine/12))), 0.2)
                lerpWeld(leftArmW, CFrame.new(1.2, 1.5, 0) *
                    CFrame.Angles(math.rad(180 - 7 * math.sin(sine/3)), math.rad(7 * math.sin(sine/3)), math.rad(7 * math.sin(sine/3))), 0.2)
                lerpWeld(rightLegW, CFrame.new(-0.31, 2.05, 0.1) *
                    CFrame.Angles(math.rad(-10), 0, math.rad(-8)), 0.25)
                lerpWeld(leftLegW, CFrame.new(0.5, 0.7, 1.1) *
                    CFrame.Angles(math.rad(75 - 10 * math.sin(sine/2)), 0, math.rad(-2)), 0.25)
            end
            lerpWeld(rootWeld, CFrame.new(2 * math.sin(sine/9), -0.4 + 0.1 * math.sin(sine/3), 0) *
                CFrame.Angles(0, math.rad(20 * math.sin(sine/9)), 0), 0.25)
        end
    end,
    -- F: The Jerky
    f = function()
        local sound = playSound("138211362", 8, true)
        return function()
            lerpWeld(rootWeld, CFrame.new(0, -0.4, 0) *
                CFrame.Angles(math.rad(20 + 5 * math.sin(sine/2)), math.rad(10 * math.sin(sine/4)), 0), 0.25)
            lerpWeld(rightArmW, CFrame.new(-1.5, 0.89 - 0.4 * -math.sin(sine/2), 0.49) *
                CFrame.Angles(math.rad(-70 + 20 * -math.sin(sine/2)), 0, 0), 0.25)
            lerpWeld(leftArmW, CFrame.new(1.5, 0.89 - 0.4 * math.sin(sine/2), 0.49) *
                CFrame.Angles(math.rad(-70 + 20 * math.sin(sine/2)), 0, 0), 0.25)
            lerpWeld(rightLegW, CFrame.new(-0.33, 2, -0.2 + 0.3 * math.sin(sine/2)) *
                CFrame.Angles(math.rad(-20 - 20 * -math.sin(sine/2)), 0, math.rad(-8)), 0.25)
            lerpWeld(leftLegW, CFrame.new(0.33, 2, -0.2 - 0.3 * math.sin(sine/2)) *
                CFrame.Angles(math.rad(-20 - 20 * math.sin(sine/2)), 0, math.rad(8)), 0.25)
        end
    end,
    -- P: Barrel roll
    p = function()
        local sound = playSound("505320170", 8, true)
        local barrel = Instance.new("Part", torso)
        barrel.Size = Vector3.new(1, 1, 1)
        barrel.CFrame = torso.CFrame
        barrel.CanCollide = false
        local bWeld = makeWeld(barrel, barrel, torso, CFrame.new(0, 0, 0))
        local bMesh = Instance.new("SpecialMesh", barrel)
        bMesh.MeshType = "FileMesh"
        bMesh.Scale = Vector3.new(1.05, 0.95, 1.05)
        bMesh.MeshId = "http://www.roblox.com/asset/?id=29873142"
        bMesh.TextureId = "http://www.roblox.com/asset/?id=31082268"
        return function()
            lerpWeld(rootWeld, CFrame.new(5 * math.sin(sine/8), -1.8, 0) *
                CFrame.Angles(math.rad(-90), math.rad(180 * math.sin(sine/8)), 0), 0.25)
            lerpWeld(rightArmW, CFrame.new(-1.5, 1.5, 0) * CFrame.Angles(math.rad(180), 0, 0), 0.25)
            lerpWeld(leftArmW, CFrame.new(1.5, 1.5, 0) * CFrame.Angles(math.rad(180), 0, 0), 0.25)
            lerpWeld(leftLegW, CFrame.new(0.5, 2, 0) * CFrame.Angles(0, 0, 0), 0.25)
            lerpWeld(rightLegW, CFrame.new(-0.5, 2, 0) * CFrame.Angles(0, 0, 0), 0.25)
        end
    end,
    -- Q: The Swoosher
    q = function()
        local sound = playSound("1532157598", 8, true)
        local angle = 0
        return function()
            angle = angle + 10
            lerpWeld(rightLegW, CFrame.new(-0.52, 1.9, -0.35) * CFrame.Angles(math.rad(-30), 0, 0), 0.2)
            lerpWeld(leftLegW, CFrame.new(0.52, 1.9, 0.35) * CFrame.Angles(math.rad(30), 0, 0), 0.2)
            lerpWeld(rootWeld, CFrame.new(0.2 * math.sin(sine/3), -0.52, 0.2 * math.sin(sine/4)) *
                CFrame.Angles(math.rad(180), math.rad(angle), math.rad(15 * math.sin(sine/9))), 0.2)
            lerpWeld(leftArmW, CFrame.new(1.4, 1.45, 0) * CFrame.Angles(math.rad(180), math.rad(-1), math.rad(-3 * math.sin(sine/2))), 0.3)
            lerpWeld(rightArmW, CFrame.new(-1.4, 1.45, 0) * CFrame.Angles(math.rad(180), math.rad(1), math.rad(3 * math.sin(sine/2))), 0.3)
        end
    end,
    -- U: Russian Dance thing
    u = function()
        local sound = playSound("2341226836", 6, true)
        local step = 0
        return function()
            step = step + 1
            if step % 34 < 17 then
                lerpWeld(rightLegW, CFrame.new(-0.52, 1.5, -0.5) * CFrame.Angles(math.rad(-60), 0, 0), 0.2)
                lerpWeld(leftLegW, CFrame.new(0.52, 1.2, 0.55) * CFrame.Angles(math.rad(30), 0, 0), 0.2)
            else
                lerpWeld(rightLegW, CFrame.new(-0.52, 1.2, 0.55) * CFrame.Angles(math.rad(30), 0, 0), 0.2)
                lerpWeld(leftLegW, CFrame.new(0.52, 1.5, -0.5) * CFrame.Angles(math.rad(-60), 0, 0), 0.2)
            end
            lerpWeld(rootWeld, CFrame.new(0, -0.8 + 0.1 * math.sin(sine/3), 0) *
                CFrame.Angles(math.rad(22 - 2 * math.sin(sine/3)), 0, 0), 0.2)
            lerpWeld(leftArmW, CFrame.new(1, -0.2, 0.4) *
                CFrame.Angles(math.rad(-87 + 0.01 * math.sin(sine/9)), math.rad(80 - 3 * math.sin(sine/9)), 0), 0.3)
            lerpWeld(rightArmW, CFrame.new(-0.7, -0.2, 0.4) *
                CFrame.Angles(math.rad(-87 - 0.01 * math.sin(sine/9)), math.rad(-88 + 0.7 * math.sin(sine/9)), 0), 0.3)
        end
    end,
    -- Y: Moonwalk
    y = function()
        local sound = playSound("487872908", 8, true)
        sound.TimePosition = 13.98
        local forward = 0
        local rot = 0
        local phase = 0
        return function()
            phase = phase + 1
            if phase < 100 then
                forward = forward + 0.1
                lerpWeld(rootWeld, CFrame.new(0, -0.2, forward) * CFrame.Angles(0, 0, 0), 0.2)
                lerpWeld(rightLegW, CFrame.new(-0.31, 2.05, 0.1 * math.sin(sine/4)) *
                    CFrame.Angles(math.rad(10 * math.sin(sine/4)), 0, math.rad(-8)), 0.3)
                lerpWeld(leftLegW, CFrame.new(0.31, 2.05, -0.15 * math.sin(sine/4)) *
                    CFrame.Angles(math.rad(-10 * math.sin(sine/4)), 0, math.rad(8)), 0.3)
            elseif phase < 150 then
                rot = rot + 15
                lerpWeld(rootWeld, CFrame.new(0, -0.2, forward) * CFrame.Angles(0, math.rad(rot), 0), 0.2)
            elseif phase < 250 then
                forward = forward - 0.1
                lerpWeld(rootWeld, CFrame.new(0, -0.2, forward) * CFrame.Angles(0, math.rad(-180), 0), 0.2)
                lerpWeld(rightLegW, CFrame.new(-0.31, 2, 0.1 * math.sin(sine/4)) *
                    CFrame.Angles(math.rad(10 * math.sin(sine/4)), 0, math.rad(-8)), 0.3)
                lerpWeld(leftLegW, CFrame.new(0.31, 2, -0.15 * math.sin(sine/4)) *
                    CFrame.Angles(math.rad(-10 * math.sin(sine/4)), 0, math.rad(8)), 0.3)
                lerpWeld(rightArmW, CFrame.new(-1.3, 0.7, 0.2) *
                    CFrame.Angles(math.rad(220), 0, math.rad(-30)), 0.4)
                lerpWeld(leftArmW, CFrame.new(1.5, 0, 0) * CFrame.Angles(0, 0, 0), 0.3)
            else
                rot = rot + 15
                lerpWeld(rootWeld, CFrame.new(0, -0.2, forward) * CFrame.Angles(0, math.rad(rot), 0), 0.2)
                lerpWeld(rightArmW, CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, 0, 0), 0.1)
                if phase > 300 then phase = 0 end
            end
        end
    end,
    -- T: Plum juice dance
    t = function()
        local sound = playSound("2526093213", 8, true)
        local step = 0
        return function()
            step = step + 1
            if step % 40 < 20 then
                lerpWeld(rootWeld, CFrame.new(0, -0.2, 0) * CFrame.Angles(0, 0, math.rad(15)), 0.2)
                lerpWeld(rightArmW, CFrame.new(0.5, 1.98, 0.05) * CFrame.Angles(0, 0, math.rad(-140)), 0.2)
                lerpWeld(leftArmW, CFrame.new(1, 1.3, 0.05) * CFrame.Angles(0, 0, math.rad(50)), 0.2)
            else
                lerpWeld(rootWeld, CFrame.new(0, -0.2, 0) * CFrame.Angles(0, 0, math.rad(-15)), 0.2)
                lerpWeld(rightArmW, CFrame.new(-1, 1.4, 0.05) * CFrame.Angles(0, 0, math.rad(-50)), 0.2)
                lerpWeld(leftArmW, CFrame.new(-0.6, 2, 0.05) * CFrame.Angles(0, 0, math.rad(140)), 0.2)
            end
            lerpWeld(rightLegW, CFrame.new(-0.33, 2, 0.05) * CFrame.Angles(math.rad(3), 0, math.rad(-8)), 0.2)
            lerpWeld(leftLegW, CFrame.new(0.33, 2, -0.05) * CFrame.Angles(math.rad(-3), 0, math.rad(8)), 0.2)
        end
    end,
    -- E: The nutty
    e = function()
        local sound = playSound("335701357", 8, true)
        sound.TimePosition = 10
        return function()
            lerpWeld(rightLegW, CFrame.new(-0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(-10)), 0.1)
            lerpWeld(leftLegW, CFrame.new(0.3, 2, 0) * CFrame.Angles(0, 0, math.rad(10)), 0.1)
            lerpWeld(rootWeld, CFrame.new(0, -0.2, 0) * CFrame.Angles(0, 0, math.rad(15 * math.sin(sine/4))), 0.2)
            lerpWeld(rightArmW, CFrame.new(-1.3 + 0.3 * math.sin(sine/3.5), 0.5 * -math.sin(sine/3.5), 0.1) *
                CFrame.Angles(0, 0, math.rad(30 * math.sin(sine/3.5))), 0.2)
            lerpWeld(leftArmW, CFrame.new(1.3 + 0.3 * math.sin(sine/3.5), 0.5 * math.sin(sine/3.5), 0.1) *
                CFrame.Angles(0, 0, math.rad(30 * math.sin(sine/3.5))), 0.2)
        end
    end,
    -- R: Spin me right round!
    r = function()
        local sound = playSound("145799973", 8, true)
        local angle = 0
        return function()
            angle = angle + 10
            lerpWeld(rightLegW, CFrame.new(-0.27, 2, 0.1 * math.sin(sine/4)) *
                CFrame.Angles(math.rad(10 * math.sin(sine/4)), 0, math.rad(-8)), 0.3)
            lerpWeld(leftLegW, CFrame.new(0.27, 2, -0.1 * math.sin(sine/4)) *
                CFrame.Angles(math.rad(-10 * math.sin(sine/4)), 0, math.rad(8)), 0.3)
            lerpWeld(rootWeld, CFrame.new(0.5 * math.sin(sine/5), -0.2, 0.5 * math.sin(sine/4)) *
                CFrame.Angles(0, math.rad(angle), 0), 0.3)
            lerpWeld(rightArmW, CFrame.new(-0.5, 1.98, 0) * CFrame.Angles(0, 0, math.rad(-90)), 0.3)
            lerpWeld(leftArmW, CFrame.new(0.5, 1.98, 0) * CFrame.Angles(0, 0, math.rad(90)), 0.3)
        end
    end
}

-- Keybindings
mouse.KeyDown:connect(function(key)
    key = key:lower()
    local danceFunc = dances[key]
    if danceFunc then
        if dancing and danceType == key then
            stopDance()
        else
            stopDance()  -- stop any ongoing dance
            dancing = true
            attacking = true
            danceType = key
            ws = 0
            hum.WalkSpeed = ws
            local update = danceFunc()  -- get the frame updater
            -- store the updater to run each frame
            _G._danceUpdate = update
            -- also store cleanup
            _G._danceCleanup = function()
                -- cleanup any extra parts (e.g., robux pile, barrel)
                for _, v in pairs(torso:GetChildren()) do
                    if v:IsA("Part") and v.Name ~= "Torso" and v.Name ~= "HumanoidRootPart" and v.Name ~= "Head" then
                        v:Destroy()
                    end
                end
                ws = 16
                hum.WalkSpeed = ws
                attacking = false
            end
        end
    end
end)

-- Main animation loop (idle/walk/run etc.)
local function defaultAnimation()
    if not attacking and not dancing then
        local vel = root.Velocity
        if vel.y > 1 then
            -- jump
            lerpWeld(rootWeld, CFrame.new(0, 0, 0), 0.2)
            lerpWeld(leftArmW, CFrame.new(1.4, 0.1, -0.2) * CFrame.Angles(math.rad(20), math.rad(-3), math.rad(-4)), 0.2)
            lerpWeld(rightLegW, CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(10), 0, 0), 0.2)
            lerpWeld(leftLegW, CFrame.new(0.5, 1, 0.9) * CFrame.Angles(math.rad(20), 0, 0), 0.2)
        elseif vel.y < -1 then
            -- falling
            lerpWeld(rootWeld, CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(15), 0, 0), 0.15)
            lerpWeld(rightLegW, CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(8), math.rad(4), 0), 0.2)
            lerpWeld(leftLegW, CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(8), math.rad(-4), 0), 0.2)
            lerpWeld(leftArmW, CFrame.new(1.5, 0.94 + 0.02 * math.sin(sine/12), 0) *
                CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)), 0, math.rad(45)), 0.2)
            lerpWeld(rightArmW, CFrame.new(-1.5, 0.94 + 0.02 * math.sin(sine/12), 0) *
                CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)), 0, math.rad(-45)), 0.2)
        elseif vel.Magnitude > 2 then
            -- walking
            lerpWeld(rightArmW, CFrame.new(-1.5 + root.RotVelocity.Y / 85, 0.35, -0.5 * math.sin(sine/11)) *
                CFrame.Angles(math.rad(35 * math.sin(sine/11)), 0, math.rad(-10 + root.RotVelocity.Y / 10)), 0.3)
            lerpWeld(leftArmW, CFrame.new(1.5 + root.RotVelocity.Y / 85, 0.45, 0.5 * math.sin(sine/11)) *
                CFrame.Angles(math.rad(-55 * math.sin(sine/11)), math.rad(-5 * math.sin(sine/8)), math.rad(10 + root.RotVelocity.Y / 10)), 0.3)
            lerpWeld(rootWeld, CFrame.new(0, -0.15 * 0.6 * -math.sin(sine/5.5), 0) *
                CFrame.Angles(math.rad(10), math.rad(12 * -math.sin(sine/11)), math.rad(0) + root.RotVelocity.Y / 30), 0.3)
            lerpWeld(rightLegW, CFrame.new(-0.5, 1.92 - 0.35 * math.cos(sine/11) / 2.8, -0.2 + 0.2 - math.sin(sine/11) / 3.4) *
                CFrame.Angles(math.rad(25 - 25) + -math.sin(sine/11) / 2.3, 0, 0), 0.3)
            lerpWeld(leftLegW, CFrame.new(0.5, 1.92 + 0.35 * math.cos(sine/11) / 2.8, -0.2 + 0.2 + math.sin(sine/11) / 3.4) *
                CFrame.Angles(math.rad(25 - 25) - -math.sin(sine/11) / 2.3, 0, 0), 0.3)
        else
            -- idle
            lerpWeld(rootWeld, CFrame.new(0, -0.2 + -0.1 * math.sin(sine/12), 0) *
                CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, 0), 0.1)
            lerpWeld(leftArmW, CFrame.new(1.5, 0.27 + 0.02 * math.sin(sine/12), 0.20 * -math.sin(sine/12)) *
                CFrame.Angles(math.rad(20 * math.sin(sine/12)), 0, math.rad(10)), 0.1)
            lerpWeld(rightArmW, CFrame.new(-1.5, 0.27 + 0.02 * math.sin(sine/12), 0.20 * -math.sin(sine/12)) *
                CFrame.Angles(math.rad(20 * math.sin(sine/12)), 0, math.rad(-10)), 0.1)
            lerpWeld(rightLegW, CFrame.new(-0.3, 2 - 0.1 * math.sin(sine/12), 0) *
                CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(-10)), 0.1)
            lerpWeld(leftLegW, CFrame.new(0.3, 2 - 0.1 * math.sin(sine/12), 0) *
                CFrame.Angles(math.rad(6 * -math.sin(sine/12)), 0, math.rad(10)), 0.1)
        end
    end
end

-- Heartbeat loop
game:GetService("RunService").Heartbeat:Connect(function()
    sine = sine + 0.5  -- smooth increment
    if dancing and _G._danceUpdate then
        _G._danceUpdate()
    else
        defaultAnimation()
    end
    -- small yield to prevent freezing
    task.wait()
end)

-- Cleanup when character dies
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    -- re-run setup (simplified: reload script)
    -- In practice, you'd re-weld, but for simplicity we stop dances.
    stopDance()
end)

print("KRYSTAL DANCE V2 loaded successfully! Press Q, E, R, T, Y, U, P, F, G, H, J, K to dance.")
