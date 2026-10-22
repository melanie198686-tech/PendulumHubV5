local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local tor = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
local larm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
local rarm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
local head = char:WaitForChild("Head")

-- Stop deaths and disable default animations
if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
hum.MaxHealth = math.huge
hum.Health = math.huge

-- Setup Motor6Ds
local rsh = tor:FindFirstChild("Right Shoulder") or tor:FindFirstChild("RightShoulder")
local lsh = tor:FindFirstChild("Left Shoulder") or tor:FindFirstChild("LeftShoulder")
local neck = tor:FindFirstChild("Neck")

-- Create Sword Mesh Setup
local function createSword()
    local s = Instance.new("Part", char)
    s.Size = Vector3.new(1, 0.8, 4)
    s.CanCollide = false
    s.Massless = true
    s.Transparency = 0
    
    local mesh = Instance.new("SpecialMesh", s)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://11996935"
    mesh.TextureId = "rbxassetid://23719291"
    mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
    
    local sparkle = Instance.new("Sparkles", s)
    sparkle.SparkleColor = Color3.new(0, 255, 155)
    
    local boom = Instance.new("Sound", s)
    boom.SoundId = "rbxassetid://2233908"
    boom.Name = "Boom"
    
    return s
end

local sword1 = createSword()
local sword2 = createSword()

-- Weld Swords to Arms
local w1 = Instance.new("Weld", larm)
w1.Part0 = larm
w1.Part1 = sword1
w1.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(270), math.rad(90), 0)

local w2 = Instance.new("Weld", rarm)
w2.Part0 = rarm
w2.Part1 = sword2
w2.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(270), math.rad(90), 0)

-- Nuke Function (Safely avoids your character)
local isNuking = false
local function boom(part)
    if isNuking or not part or part.Anchored then return end
    if part:IsDescendantOf(char) then return end -- DO NOT DESTROY YOUR OWN BODY
    
    isNuking = true
    
    local ehum = part.Parent:FindFirstChild("Humanoid") or part.Parent.Parent:FindFirstChild("Humanoid")
    if ehum then ehum.Health = 0 end
    
    game:GetService("Debris"):AddItem(part, 0)
    isNuking = false
end

sword1.Touched:Connect(boom)
sword2.Touched:Connect(boom)

-- Explode on Click (Safe)
local load = true
local mouse = plr:GetMouse()

mouse.Button1Down:Connect(function()
    if load then
        load = false
        sword1.Boom:Play()
        sword2.Boom:Play()
        
        -- Explosion that ignores your own body
        local e = Instance.new("Explosion")
        e.Position = tor.Position
        e.BlastPressure = 0
        e.BlastRadius = 1000
        e.Visible = false
        e.Hit:Connect(function(part)
            if not part:IsDescendantOf(char) then
                boom(part)
            end
        end)
        e.Parent = workspace
        
        task.wait(1)
        load = true
    end
end)

-- Super Jump
hum.Jumping:Connect(function()
    tor.Velocity = Vector3.new(tor.Velocity.X, tor.Velocity.Y + 40, tor.Velocity.Z)
end)

-- Spinning Animation
game:GetService("RunService").Heartbeat:Connect(function()
    if hum.Health > 0 then
        hum.Health = math.huge
        if lsh then lsh.Transform = CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360))) end
        if rsh then rsh.Transform = CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360))) end
        if neck then neck.Transform = CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360))) end
    end
end)

print("OPSwords Loaded.")
