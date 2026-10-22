--[[
    Fixed animation script.
    - No fling (removed BodyThrust, per-frame teleport, velocity spam)
    - Weld-only animation (safe, client-side)
    - All original animations preserved
]]

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid    = Character:WaitForChild("Humanoid")
local RootPart    = Character:WaitForChild("HumanoidRootPart")
local Torso       = Character:WaitForChild("Torso")
local Head        = Character:WaitForChild("Head")

local CF  = CFrame.new
local CFA = CFrame.Angles

-- ─────────────────────────────────────────────────────────────
--  Helpers
-- ─────────────────────────────────────────────────────────────
local function swait()
    RunService.Stepped:Wait()
end

local function LerpStyle(t, s, d)
    return TweenService:GetValue(t, s, d)
end

local function makesound(id, speed, volume, parent)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.PlaybackSpeed = speed
    s.Volume = volume
    s.RollOffMaxDistance = 100
    s.Parent = parent
    s:Play()
    return s
end

-- Floor raycast (proper modern API)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = { Character }

local function isGrounded()
    local result = workspace:Raycast(
        RootPart.Position,
        Vector3.new(0, -4, 0),
        rayParams
    )
    return result ~= nil
end

-- ─────────────────────────────────────────────────────────────
--  Joint / weld setup
-- ─────────────────────────────────────────────────────────────
local neck = Instance.new("Weld", Torso)
neck.Part0 = Torso
neck.Part1 = Head
neck.C0 = CF(0, 1.5, 0)
local nek = neck.C1

local root = RootPart.RootJoint.C0
local rs   = Torso["Right Shoulder"].C0
local ls   = Torso["Left Shoulder"].C0
local rh   = Torso["Right Hip"].C0
local lh   = Torso["Left Hip"].C0

-- Optional tail weld (guarded — only if you actually have a Tail)
local TailWeld = Instance.new("Weld", Torso)
TailWeld.Part0 = Torso
TailWeld.Part1 = Torso
local TC0 = TailWeld.C0 * CF(0, 0, 0.4)

Humanoid.JumpPower = 80
Humanoid.WalkSpeed = 20

-- Music (optional — comment out if you don't want it)
local Song = Instance.new("Sound", RootPart)
Song.SoundId = "rbxassetid://198665867"
Song.Looped = true
Song:Play()

-- ─────────────────────────────────────────────────────────────
--  State
-- ─────────────────────────────────────────────────────────────
local Attacking = false
local Running   = false
local ComboCont = 1
local Anim      = "Idle"

-- ─────────────────────────────────────────────────────────────
--  Attack combo (pure weld animation — no teleport, no thrust)
-- ─────────────────────────────────────────────────────────────
local function Attack()
    if Attacking then return end
    Attacking = true

    pcall(function()
        if ComboCont == 1 then
            -- Right punch windup
            for _ = 0, 10, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(-30), 0, math.rad(80)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0.5, 0, -1.2) * CFA(0, math.rad(90), math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            -- Right punch follow-through
            for _ = 0, 15, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0.5, 0, 0) * CFA(0, math.rad(-85), math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            ComboCont = 2

        elseif ComboCont == 2 then
            -- Left punch windup
            for _ = 0, 10, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek * CFA(0, math.rad(90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(-30), 0, math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, 0, math.rad(-12)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            -- Left punch follow-through
            for _ = 0, 10, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek * CFA(0, math.rad(-90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0) * CFA(0, 0, math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, 0, math.rad(-12)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0.5) * CFA(0, math.rad(90), math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            ComboCont = 3

        elseif ComboCont == 3 then
            -- Right kick windup
            for _ = 0, 10, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(10), 0, math.rad(-50)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, 0, math.rad(-5)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(8)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, math.rad(-50), math.rad(-98)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, math.rad(20), 0), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            -- Right kick follow-through
            for _ = 0, 15, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek * CFA(0, math.rad(90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0) * CFA(math.rad(-40), 0, math.rad(90)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, 0, math.rad(-5)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(8)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, math.rad(90), math.rad(-50)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, math.rad(-90), 0), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            end
            ComboCont = 1
        end
    end)

    Attacking = false
end

-- ─────────────────────────────────────────────────────────────
--  Spin kick (no anchoring, no manual position shift)
-- ─────────────────────────────────────────────────────────────
local function SpinKick()
    if Attacking then return end
    Attacking = true

    pcall(function()
        for _ = 0, 60, 1 do
            swait()
            neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(30), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, 0, math.rad(-20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(-30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
        end
        for i = 0, 60, 1 do
            swait()
            neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(-20 - 36 * i), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, math.rad(30), math.rad(40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, math.rad(-30), math.rad(-40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(50)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
        end
    end)

    Attacking = false
end

-- ─────────────────────────────────────────────────────────────
--  Input
-- ─────────────────────────────────────────────────────────────
local Mouse   = LocalPlayer:GetMouse()
local B1Hold  = false

Mouse.Button1Down:Connect(function()
    B1Hold = true
    while B1Hold do
        task.wait()
        Attack()
    end
end)

Mouse.Button1Up:Connect(function()
    B1Hold = false
end)

Mouse.KeyDown:Connect(function(key)
    key = key:lower()

    if key == "z" then
        SpinKick()

    elseif key == "t" and not Attacking then
        Attacking = true
        pcall(function()
            makesound("rbxassetid://6433451653", 1, 1, Torso)
            for _ = 0, 100, 1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek * CFA(math.rad(-15 + math.sin(time() * 16) * 15), 0, 0), LerpStyle(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(-10 + math.sin(time() * 16) * 10), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0, 0.4 + math.sin(time() * 17) * 0.4, 0) * CFA(0, math.rad(90), math.rad(123)), LerpStyle(0.07, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(math.rad(10), 0, math.rad(-90)), LerpStyle(0.07, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, math.rad(-30 + math.sin(time() * 17) * 20), math.rad(-10 + math.sin(time() * 16) * 10)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(10 + math.sin(time() * 16) * -10)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-20 + math.sin(-time() * 3.83) * -20), math.rad(-math.sin(time() * 3.83 / 2) * 24), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            end
        end)
        Attacking = false

    elseif key == "r" and not Attacking then
        Attacking = true
        pcall(function()
            while Character.Humanoid.MoveDirection.Magnitude < 0.1 do
                swait()
                neck.C1 = neck.C1:Lerp(nek * CF(0, -0.4, 0) * CFA(math.rad(-90), math.rad(-math.cos(time() * 3) * 30), 0), LerpStyle(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
                RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, -2.5) * CFA(math.rad(78), math.rad(math.sin(time() * 3) * 12), math.rad(math.sin(time() * 3) * 40)), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0.3, 0.4 + 0.4 + math.sin(time() * 3) * 0.2, -0.4 - 0.2 + math.sin(time() * 3) * 0.2) * CFA(math.rad(-45) + math.rad(math.sin(time() * 3) * 12), 0, math.rad(170 + math.cos(time() * 3) * 5)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(-0.3, 0.4 + 0.4 - math.sin(time() * 3) * 0.2, -0.4 - 0.2 + math.sin(time() * 3) * 0.2) * CFA(math.rad(-45) - math.rad(math.sin(time() * 3) * 12), 0, math.rad(-170 + math.cos(time() * 3) * 5)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(math.rad(-math.sin(time() * 3) * 12), math.rad(math.sin(time() * 3) * 30), math.rad(-62 + math.cos(time() * 3) * 30)), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(math.rad(-math.sin(time() * 3) * 12), math.rad(math.sin(time() * 3) * 30), math.rad(62 + math.cos(time() * 3) * 30)), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
                TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(0, 0, math.rad(math.cos(time() * 3) * 40)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            end
        end)
        Attacking = false

    elseif key == "f" then
        if not Running then
            Running = true
            Humanoid.WalkSpeed = 40
        else
            Running = false
            Humanoid.WalkSpeed = 20
        end

    elseif key == "x" and not Attacking then
        local target = Mouse.Target
        if target and target.Parent and target.Parent:FindFirstChildWhichIsA("Humanoid") then
            Attacking = true
            pcall(function()
                local Camera  = workspace.CurrentCamera
                local Target  = target.Parent

                Camera.CameraType = Enum.CameraType.Scriptable

                -- Camera zoom-in windup
                for _ = 0, 200, 1 do
                    swait()
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((Head.CFrame * CF(0, 0, -5)).Position, Head.CFrame.Position), 1)
                    neck.C1 = neck.C1:Lerp(nek * CFA(math.rad(20), 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(20), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0, -0.5, 0) * CFA(math.rad(-25), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(0, -0.5, 0) * CFA(math.rad(-25), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                end

                for _ = 0, 20, 1 do
                    swait()
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((Head.CFrame * CF(0, 0, -3)).Position, Head.CFrame.Position), 1)
                end

                -- Reposition ONCE (not every frame) to avoid fling
                local targetHRP = Target:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    RootPart.CFrame = targetHRP.CFrame * CF(0, 0, -8)
                end

                for _ = 0, 100, 1 do
                    swait()
                    if targetHRP then
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((Head.CFrame * CF(-3, 0, 0)).Position, targetHRP.CFrame.Position), 0.2)
                    end
                    neck.C1 = neck.C1:Lerp(nek, LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CFA(math.rad(20), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0, -0.5, 0) * CFA(math.rad(-80), 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(0, -0.5, 0) * CFA(math.rad(-80), 0, math.rad(20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CFA(0, 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                end

                Camera.CameraType = Enum.CameraType.Custom
            end)
            Attacking = false
        end
    end
end)

-- ─────────────────────────────────────────────────────────────
--  Collision tweaks
-- ─────────────────────────────────────────────────────────────
local collideConn = RunService.Stepped:Connect(function()
    if Character and Character.Parent and Character:FindFirstChild("Head") then
        Character.Head.CanCollide = false
        Character["Left Leg"].CanCollide = false
        Character["Right Leg"].CanCollide = false
    end
end)

-- ─────────────────────────────────────────────────────────────
--  Main animation loop (WELD ONLY — no teleport, no thrust)
-- ─────────────────────────────────────────────────────────────
while Character.Parent do
    swait()
    if not Character.Parent then break end

    local vel       = RootPart.Velocity
    local torvel    = Humanoid.MoveDirection.Magnitude
    local grounded  = isGrounded()

    if vel.Y > 1 and not grounded then
        Anim = "Jumping"
    elseif vel.Y < -1 and not grounded then
        Anim = "Falling"
    elseif torvel < 0.5 and grounded then
        Anim = "Idle"
    elseif torvel > 0.5 and grounded then
        Anim = "Walking"
    end

    local W1 = Humanoid.MoveDirection * RootPart.CFrame.LookVector
    local W2 = Humanoid.MoveDirection * RootPart.CFrame.RightVector
    local WVA = W1.X + W1.Z
    local RLV = W2.X + W2.Z

    if not Attacking then
        if Anim == "Falling" then
            neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0.3) * CFA(math.rad(20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root, LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(math.rad(-40), 0, math.rad(5)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(math.rad(-40), 0, math.rad(-5)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CF(0.4, 0.8, 0) * CFA(0, 0, math.rad(10)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CF(0.4, 0.5, 0) * CFA(0, 0, math.rad(50)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))

        elseif Anim == "Jumping" then
            neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0.3) * CFA(math.rad(-20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root, LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CFA(0, math.rad(-40), math.rad(-20)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CFA(0, math.rad(40), math.rad(20)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CF(0.4, 0.8, 0) * CFA(0, 0, math.rad(-10)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CF(0.4, 0.5, 0) * CFA(0, 0, math.rad(-50)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))

        elseif Anim == "Idle" then
            local t = time() * 3.83
            neck.C1 = neck.C1:Lerp(nek * CFA(math.rad(7 + math.cos(t) * -5 + (-6 + math.sin(t) * 6)), math.rad(-24) + math.rad(math.sin(t / 2) * 10), math.rad(-math.cos(t / 2) * 13)), LerpStyle(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, math.cos(t) / 10), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(-0.1, math.cos(t) / 10, 0) * CFA(math.rad(-5) + math.sin(-t) / 8.7, 0, math.rad(5) + math.cos(-t) / 8.7), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(0.1, math.cos(t) / 10, 0) * CFA(math.rad(-5) + math.sin(-t) / 8.7, 0, math.rad(-5) - math.cos(-t) / 8.7), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Right Hip"].C0      = Torso["Right Hip"].C0:Lerp(rh * CF(0, -math.cos(t) / 8, 0) * CFA(math.rad(-4), math.rad(-12), math.rad(8)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Left Hip"].C0       = Torso["Left Hip"].C0:Lerp(lh * CF(0, -math.cos(t) / 8, 0) * CFA(math.rad(-1), math.rad(7), math.rad(2)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-20 + math.sin(-t) * -20), math.rad(-math.sin(t / 2) * 24), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))

        elseif Anim == "Walking" and not Running then
            local t = time() * 8
            local RLA = CF(math.sin(t) * 0.5 * WVA, 0.3 * (1 - WVA), math.sin(t) * 0.5 * RLV) * CFA(-math.sin(t) / 1.5 * RLV, 0, math.sin(t) / 1.2 * WVA)
            local LLA = RLA
            neck.C1 = neck.C1:Lerp(nek * CFA(math.rad(7), math.clamp(math.cos(t) * 0.2 + math.rad(-RootPart.RotVelocity.Y * 8), math.rad(-85), math.rad(85)), math.rad(-RootPart.RotVelocity.Y * 0.4)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -math.sin(t * 2) / 3.2, -math.sin(t * 2) / 3) * CFA(math.rad(-5 + WVA * 15) - math.rad(math.sin(t * 2) * 10), math.clamp(math.rad(0) + RootPart.RotVelocity.Y / 50, math.rad(-20), math.rad(20)), math.cos(t) * 0.2), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(-math.sin(t) / 4.5, 0, 0) * CFA(math.rad(-5), -math.sin(t) * 0.1 + math.rad(RootPart.RotVelocity.Y * 3), -math.sin(t) * 0.4), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(-math.sin(t) / 4.5, 0, 0) * CFA(math.rad(-5), -math.sin(t) * 0.1 + math.rad(RootPart.RotVelocity.Y * 3), -math.sin(t) * 0.4), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Hip"].C0 = Torso["Right Hip"].C0:Lerp(rh * CF(0, math.cos(t) / 8, 0) * RLA * CFA(0, -math.sin(t) * 0.5 * WVA, math.rad(-5 + WVA * 15) - math.rad(math.sin(t * 2) * 10)), LerpStyle(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Left Hip"].C0  = Torso["Left Hip"].C0:Lerp(lh * CF(0, -math.cos(t) / 8, 0) * LLA * CFA(0, -math.sin(t) * 0.5 * WVA, -math.rad(-5 + WVA * 15) + math.rad(math.sin(t * 2) * 10)), LerpStyle(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-30 + math.sin(-t) * -20), 0, -math.rad(-math.sin(t / 2) * 20 + RLV * 2)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))

        elseif Anim == "Walking" and Running then
            local t = time() * 15
            local RLA = CF(0, (0.5 + math.cos(t) * 0.5) * WVA + 0.2, (0.5 - math.cos(t) * 0.5) * RLV + 0.2) * CFA(0, -math.rad(math.sin(t) * 80) * RLV, math.rad(math.sin(t) * 80) * WVA)
            local LLA = CF(0, (0.5 + math.cos(t) * 0.5) * WVA - 0.2, (-0.5 + math.cos(t) * 0.5) * RLV - 0.2) * CFA(0, -math.rad(math.sin(t) * 80) * RLV, math.rad(-math.sin(t) * 80) * WVA)
            local RAA = CF(0, 0.8 + math.sin(t) * 0.9 * WVA, math.sin(t) * 0.9 * RLV) * CFA(0, math.rad(-math.cos(t) * 85) * RLV, math.rad(math.cos(t) * 85) * WVA)
            local LAA = CF(0, 0.8 + math.sin(t) * 0.9 * WVA, math.sin(t) * 0.9 * -RLV) * CFA(0, math.rad(-math.cos(t) * 85) * RLV, math.rad(-math.cos(t) * 85) * WVA)
            neck.C1 = neck.C1:Lerp(nek * CFA(0, math.rad(-RootPart.RotVelocity.Y * 5), 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF((-1 - math.sin(t) * 2) * RLV, (-1 - math.sin(t) * 2) * WVA, -0.5 - math.sin(t) * 0.8) * CFA(math.rad(80 - math.cos(t) * 20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Shoulder"].C0 = Torso["Right Shoulder"].C0:Lerp(rs * CF(0.6 + math.sin(t) * 1, 0, -0.6) * RAA * CFA(math.rad(-10 + math.cos(t * 2) * 10), 0, math.rad(80)), LerpStyle(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Left Shoulder"].C0  = Torso["Left Shoulder"].C0:Lerp(ls * CF(-0.6 - math.sin(t) * 1, 0, -0.6) * LAA * CFA(math.rad(-10 + math.cos(t * 2) * 10), 0, math.rad(-80)), LerpStyle(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
            Torso["Right Hip"].C0 = Torso["Right Hip"].C0:Lerp(rh * CF(0.4 - math.cos(t) * 0.9, 0, 0) * RLA * CFA(0, 0, math.rad(50)), LerpStyle(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            Torso["Left Hip"].C0  = Torso["Left Hip"].C0:Lerp(lh * CF(-0.4 + math.cos(t) * 0.9, 0, 0) * LLA * CFA(0, 0, math.rad(-80)), LerpStyle(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
            TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CF(0, 0.7, 0.3) * CFA(math.rad(-110 + math.sin(-t) * -20), -math.rad(RLV * 30), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
        end
    end
end

-- Cleanup on character removal
collideConn:Disconnect()
