--!nocheck
-- Billie Eilish Script — Fixed for Modern Roblox
-- Keys: T = head bob, R = scream, Y = head pop, P = jevil hat, F = rage, U = banana

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local plr = Players.LocalPlayer
local char = workspace:FindFirstChild("non") or (plr.Character or plr.CharacterAdded:Wait())
local hum = char:WaitForChild("Humanoid")

if char:FindFirstChild("Animate") then
    char.Animate:Destroy()
end

local tors = char:WaitForChild("Torso")
local head = char:WaitForChild("Head")
local rootpart = char:WaitForChild("HumanoidRootPart")
local RS = tors:WaitForChild("Right Shoulder")
local LS = tors:WaitForChild("Left Shoulder")
local RH = tors:WaitForChild("Right Hip")
local LH = tors:WaitForChild("Left Hip")
local neck = tors:WaitForChild("Neck")
local rootj = rootpart:WaitForChild("RootJoint")

local RSnor = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
local LSnor = CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
local RHnor = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
local LHnor = CFrame.new(-1, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
local necknor = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
local rootjnor = CFrame.new(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

local sine = 0
local timepos = 0
local attack = false
local rooted = false
local playing = true
local speed = 16
local nokill = {}

-- Wig
local wig = Instance.new("Part")
wig.Size = Vector3.new(1.4, 1.99, 0.84)
wig.CanCollide = false
wig.Parent = head
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://952995462"
mesh.Scale = Vector3.new(1.44, 1.4, 1.22)
mesh.TextureId = "rbxassetid://949743130"
mesh.VertexColor = Vector3.new(1, 0.839, 0.73)
mesh.Parent = wig
local weld = Instance.new("Weld")
weld.Part0 = wig
weld.Part1 = head
weld.C1 = CFrame.new(0, -0.8, 0.25)
weld.Parent = wig

-- Music
local music = Instance.new("Sound")
music.Parent = tors
music.SoundId = "rbxassetid://4710045505"
music.Looped = true
music.Volume = 1
music:Play()

local function playSound(id, vol, pitch, parent)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = vol or 5
    if pitch then s.PlaybackSpeed = pitch end
    s.Parent = parent or head
    s:Play()
    return s
end

-- T: Head bob
local function headBob()
    local s = playSound("145757437", 10)
    local effect = Instance.new("PitchShiftSoundEffect")
    effect.Octave = 1.75
    effect.Parent = s
    for _ = 1, 120 do
        RunService.Stepped:Wait()
        head.Size = Vector3.new(2 + 1 * math.sin(sine / 5), 1 + 1 * math.sin(sine / 5), 1 + 1 * math.sin(sine / 5))
        neck.C0 = necknor * CFrame.new(0, 0, math.sin(sine / 5))
    end
    head.Size = Vector3.new(2, 1, 1)
end

-- R: Scream
local function scream()
    if attack then return end
    attack = true
    rooted = true
    playing = false
    local s = playSound("6069962045", 10)
    repeat
        RunService.Stepped:Wait()
        RS.C0 = RSnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
        LS.C0 = LSnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
        RH.C0 = RHnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
        LH.C0 = LHnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
        rootj.C0 = rootjnor * CFrame.new(0, 0, 3 * math.sin(sine / 2)) * CFrame.Angles(sine / 2, 0, 0)
        neck.C0 = necknor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
    until not s.Playing
    s:Destroy()
    rooted = false
    if math.random(1, 3) == 1 then
        local s2 = playSound("2878822762", 10, 2)
        repeat
            RunService.Stepped:Wait()
            head.Size = Vector3.new(2 + 1 * math.sin(sine / 2), 1 + 1 * math.sin(sine / 2), 1 + 1 * math.sin(sine / 2))
            RS.C0 = RSnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
            LS.C0 = LSnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
            RH.C0 = RHnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
            LH.C0 = LHnor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
            rootj.C0 = rootjnor
            neck.C0 = necknor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
        until not s2.Playing
        head.Size = Vector3.new(2, 1, 1)
    end
    playing = true
    attack = false
end

-- Y: Head pop
local function headPop()
    local s = playSound("3475233802", 10)
    local conn = head.Touched:Connect(function(hit)
        if hit.Parent and not hit:IsDescendantOf(char) and hit.Size.Magnitude < 300 then
            local parent = hit.Parent
            hit.Anchored = false
            hit.BrickColor = BrickColor.new("Bright green")
            hit.CFrame = head.CFrame
            hit.Velocity = head.CFrame.LookVector * 150
            playSound("704088758", 10)
        end
    end)
    for _ = 1, 180 do
        RunService.Stepped:Wait()
        head.Size = Vector3.new(20, 10, 10)
        neck.C0 = necknor * CFrame.new(0, -10, 0)
    end
    conn:Disconnect()
    head.Size = Vector3.new(2, 1, 1)
end

-- P: Jevil hat
local function jevilHat()
    if attack then return end
    attack = true
    playing = false
    local s = playSound("2533880583", 3)
    s.TimePosition = 20.15
    wig.Parent = nil
    local hat = Instance.new("Part")
    hat.Name = "JevilHat"
    hat.CanCollide = false
    hat.Size = Vector3.new(1, 1, 1)
    hat.Parent = char
    local hm = Instance.new("SpecialMesh")
    hm.MeshType = Enum.MeshType.FileMesh
    hm.MeshId = "rbxassetid://193760002"
    hm.TextureId = "rbxassetid://193760041"
    hm.VertexColor = Vector3.new(0.5, 0, 0.5)
    hm.Parent = hat
    local hw = Instance.new("Weld")
    hw.Part0 = head
    hw.Part1 = hat
    hw.C0 = CFrame.new(0, 0.5, 0.31)
    hw.Parent = hat
    for _, v in pairs(head:GetChildren()) do
        if v:IsA("Decal") then
            local old = v.Texture
            v.Texture = "rbxassetid://241553801"
            task.spawn(function()
                repeat RunService.Stepped:Wait() until (not s.Playing) or s.TimePosition > 30.35
                v.Texture = old
            end)
        end
    end
    playSound("2544975373", 10)
    speed = 50
    repeat
        RunService.Stepped:Wait()
        RS.C0 = RSnor * CFrame.Angles(0, 0, math.pi / 2 - 1 * math.sin(sine / 3))
        LS.C0 = LSnor * CFrame.Angles(0, 0, -math.pi / 2 + 1 * math.sin(sine / 3))
        RH.C0 = RHnor
        LH.C0 = LHnor
        rootj.C0 = rootjnor
        neck.C0 = necknor
    until (not s.Playing) or s.TimePosition > 30.35
    speed = 16
    hat:Destroy()
    wig.Parent = head
    s:Destroy()
    playing = true
    attack = false
end

-- F: Rage
local function rage()
    if attack then return end
    attack = true
    playing = false
    speed = 150
    local s = playSound("2259766079", 10)
    local thing = 1
    repeat
        RunService.Stepped:Wait()
        s.Volume = 10
        s.PlaybackSpeed = 1
        if not s.Playing then s:Play() end
        RS.C0 = RSnor * CFrame.Angles(0, 0, math.pi / 2 - 1 * math.sin(sine / (15 / thing)))
        LS.C0 = LSnor * CFrame.Angles(0, 0, -math.pi / 2 + 1 * math.sin(sine / (15 / thing)))
        RH.C0 = RHnor
        LH.C0 = LHnor
        rootj.C0 = rootjnor
        neck.C0 = necknor
        thing = thing + 0.005
    until (not s.Playing) or s.TimePosition > 10
    local old = head.BrickColor
    repeat
        RunService.Stepped:Wait()
        if s.TimePosition > 20 then
            head.BrickColor = BrickColor.new("Sunrise")
        end
        s.PlaybackSpeed = s.PlaybackSpeed + 0.001
        head.Size = head.Size + Vector3.new(0.01, 0.01, 0.01)
        neck.C0 = necknor * CFrame.Angles(math.random(-100, 100) / 20, math.random(-100, 100) / 20, math.random(-100, 100) / 20)
    until not s.Playing
    for _ = 1, 20 do
        local clone = head:Clone()
        clone.Parent = workspace
        clone.Velocity = Vector3.new(0, 200, 0)
        playSound("2878822762", 0.5)
    end
    head.Size = Vector3.new(2, 1, 1)
    head.BrickColor = old
    speed = 16
    playing = true
    attack = false
end

-- U: Banana
local function banana()
    local part = Instance.new("Part")
    part.CFrame = rootpart.CFrame * CFrame.new(0, 0, 5)
    part.Size = Vector3.new(3, 4, 3)
    part.Parent = workspace
    local click = Instance.new("ClickDetector", part)
    local mesh = Instance.new("SpecialMesh", part)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://430897733"
    mesh.Scale = Vector3.new(4, 4, 4)
    mesh.TextureId = "rbxassetid://430897961"
    local s = playSound("741801027", 3, nil, part)

    click.MouseClick:Connect(function()
        local b = Instance.new("Part")
        b.Size = Vector3.new(1, 1, 1)
        b.CFrame = part.CFrame * CFrame.new(0, 5, 0)
        b.Velocity = Vector3.new(math.random(-25, 25), 200, math.random(-25, 25))
        b.Parent = workspace
        local bm = Instance.new("SpecialMesh", b)
        bm.MeshType = Enum.MeshType.FileMesh
        bm.MeshId = "rbxassetid://28937301"
        bm.TextureId = "rbxassetid://28937670"
        bm.Scale = Vector3.new(0.8, 0.8, 0.8)
        playSound("28976727", 2, nil, b)
        local touched = false
        b.Touched:Connect(function(hit)
            if hit.Parent and hit.Parent:FindFirstChild("Head") and not hit:IsDescendantOf(char) and not touched then
                touched = true
                task.spawn(function()
                    for _ = 1, 60 do
                        RunService.Stepped:Wait()
                        bm.Scale = bm.Scale + Vector3.new(0.3, 0.3, 0.3)
                        b.Size = b.Size + Vector3.new(0.3, 0.3, 0.3)
                    end
                    b:Destroy()
                end)
                playSound("168411776", 10, nil, hit.Parent.Head)
            end
        end)
    end)
    repeat RunService.Stepped:Wait() until not s.Playing
    part:Destroy()
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if attack then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.T then headBob()
    elseif k == Enum.KeyCode.R then scream()
    elseif k == Enum.KeyCode.Y then headPop()
    elseif k == Enum.KeyCode.P then jevilHat()
    elseif k == Enum.KeyCode.F then rage()
    elseif k == Enum.KeyCode.U then banana()
    end
end)

-- Main loop
task.spawn(function()
    while char.Parent and hum.Health > 0 do
        RunService.Stepped:Wait()
        sine = sine + 1
        if attack then
            hum.WalkSpeed = rooted and 0 or speed
            hum.JumpPower = rooted and 0 or 50
        else
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        timepos = music.TimePosition
        if music.Parent ~= tors then
            music = Instance.new("Sound", tors)
            music.SoundId = "rbxassetid://4710045505"
            music.Looped = true
            music.TimePosition = timepos
            if playing then music:Play() else music:Pause() end
        end
        if playing and not music.Playing then music:Play() end
        if not playing and music.Playing then music:Pause() end

        local torsvel = (tors.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
        local hitfloor = workspace:FindPartOnRay(Ray.new(rootpart.Position, Vector3.new(0, -4, 0)), char)

        if not attack then
            if torsvel < 1 and hitfloor then
                RS.C0 = RS.C0:Lerp(RSnor * CFrame.Angles(0, 0, math.pi / 2 + 0.3 * math.cos(sine / 7) + 0.5 * math.sin(sine / 14)), 0.15)
                LS.C0 = LS.C0:Lerp(LSnor * CFrame.Angles(0, 0, 0.5 + 0.2 * math.sin(sine / 7) + 0.15 * math.cos(sine / 14)), 0.15)
                RH.C0 = RH.C0:Lerp(RHnor * CFrame.Angles(0, 0, -0.5 + 1 * math.sin(sine / 14) - 0.5 * math.cos(sine / 28)), 0.15)
                LH.C0 = LH.C0:Lerp(LHnor * CFrame.new(0.1 * math.sin(sine / 3.5) + 0.2 * math.cos(sine / 14), 0, 0) * CFrame.Angles(0, 0.2 * math.cos(sine / 28) - 0.3 * math.sin(sine / 48) + 0.15 * math.cos(sine / 3.5) - 0.25 * math.sin(sine / 3.5), -0.1 * math.sin(sine / 3.5) - 0.2 * math.cos(sine / 14)), 0.15)
                rootj.C0 = rootj.C0:Lerp(rootjnor * CFrame.new(0, 0, 0.3 * math.cos(sine / 4.5)), 0.15)
                neck.C0 = neck.C0:Lerp(necknor * CFrame.Angles(math.sin(sine / 10), math.cos(sine / 10), 0), 0.15)
            end
            if torsvel > 1 and hitfloor then
                RS.C0 = RS.C0:Lerp(RSnor * CFrame.Angles(0, sine / 5, -1 * math.sin(sine / 7)), 0.15)
                LS.C0 = LS.C0:Lerp(LSnor * CFrame.Angles(0, sine / 5, -1 * math.sin(sine / 7)), 0.15)
                RH.C0 = RH.C0:Lerp(RHnor * CFrame.new(1 * math.cos(sine / 7), 0.15 + 0.5 * math.cos(sine / 7), 0) * CFrame.Angles(0, 0.3 * math.sin(sine / 7), -0.23 + 1 * math.sin(sine / 7)), 0.15)
                LH.C0 = LH.C0:Lerp(LHnor * CFrame.new(1 * math.cos(sine / 7), 0.15 - 0.5 * math.cos(sine / 7), 0) * CFrame.Angles(0, 0.3 * math.sin(sine / 7), 0.23 + 1 * math.sin(sine / 7)), 0.15)
                rootj.C0 = rootj.C0:Lerp(rootjnor * CFrame.new(0, 0, -0.1 + 0.2 * math.cos(sine / 3.5)) * CFrame.Angles(0.2 - 0.4 * math.sin(sine / 3.5), rootpart.RotVelocity.Y / 50, -0.3 * math.sin(sine / 7)), 0.15)
                neck.C0 = neck.C0:Lerp(necknor * CFrame.Angles(0.4 * math.sin(sine / 3.5), 0, -head.RotVelocity.Y / 15 + 0.3 * math.sin(sine / 7)), 0.15)
            end
            if not hitfloor then
                RS.C0 = RS.C0:Lerp(RSnor * CFrame.Angles(math.clamp(tors.AssemblyLinearVelocity.Y / 200 - 0.3, -hum.JumpPower / 200 - 0.3, hum.JumpPower / 200 - 0.3), 0, math.pi / 1.5), 0.15)
                LS.C0 = LS.C0:Lerp(LSnor * CFrame.Angles(math.clamp(tors.AssemblyLinearVelocity.Y / 200 - 0.3, -hum.JumpPower / 200 - 0.3, hum.JumpPower / 200 - 0.3), 0, -math.pi / 1.5), 0.15)
                RH.C0 = RH.C0:Lerp(RHnor + Vector3.new(0, -0.6, 0.4), 0.15)
                LH.C0 = LH.C0:Lerp(LHnor * CFrame.Angles(0, 0, -0.3) + Vector3.new(0, -0.1, 0), 0.15)
                rootj.C0 = rootj.C0:Lerp(rootjnor * CFrame.Angles(-math.clamp(tors.AssemblyLinearVelocity.Y / 100, -hum.JumpPower / 100, hum.JumpPower / 100), 0, 0), 0.15)
                neck.C0 = neck.C0:Lerp(necknor * CFrame.Angles(math.random(-100, 100) / 1000, math.random(-100, 100) / 1000, math.random(-100, 100) / 1000), 0.15)
            end
        end
    end
end)

print("[Billie Eilish] Loaded! T = bob, R = scream, Y = pop, P = jevil, F = rage, U = banana")
