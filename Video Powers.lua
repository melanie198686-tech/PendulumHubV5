--[[
skibidi
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

local plr = Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local human = chr:WaitForChild("Humanoid")
local mouse = plr:GetMouse()

local selected = false
local activu = false
local torrent = false
local boxingu = false

local tors = chr:WaitForChild("Torso")
local rarm = chr:WaitForChild("Right Arm")
local larm = chr:WaitForChild("Left Arm")
local rleg = chr:WaitForChild("Right Leg")
local lleg = chr:WaitForChild("Left Leg")
local hrp = chr:WaitForChild("HumanoidRootPart")
local head = chr:WaitForChild("Head")
local anim = human:WaitForChild("Animator")

-- Notify user
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "READ ME!";
        Text = "Zero damage mode. Requires an executor with loadstring support.";
        Duration = 10;
    })
end)

-- Heartbeat Simulation (Fixed)
local Heartbeat = Instance.new("BindableEvent")
Heartbeat.Name = "Heartbeat"
Heartbeat.Parent = script
local frame = 1 / 30
local tf = 0
RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for i = 1, math.floor(tf / frame) do
            Heartbeat:Fire()
        end
        tf = tf - frame * math.floor(tf / frame)
    end
end)

local function swait(num)
    num = num or 1
    for i = 1, num do
        Heartbeat.Event:Wait()
    end
end

-- Tool Setup
local tool = Instance.new("Tool")
tool.CanBeDropped = false
tool.RequiresHandle = false
tool.TextureId = "rbxassetid://37338767"
tool.ToolTip = "hehe yea boi"
tool.Name = "fir"
tool.Parent = plr.Backpack

local modz = Instance.new("Model")
modz.Name = "memes"
modz.Parent = chr

-- Base CFrames
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

local RS = tors:FindFirstChild("Right Shoulder")
local LS = tors:FindFirstChild("Left Shoulder")
local RH = tors:FindFirstChild("Right Hip")
local LH = tors:FindFirstChild("Left Hip")
local RJ = hrp:FindFirstChild("RootJoint")
local N = tors:FindFirstChild("Neck")

local cf = CFrame.new
local ang = CFrame.Angles
local rd = math.rad
local rd2 = math.random

local function nooutline(p)
    p.TopSurface, p.BottomSurface, p.LeftSurface, p.RightSurface, p.FrontSurface = 10, 10, 10, 10, 10
end

local function makepart(color, name, reflec, mater, parnt, cfram)
    local port = Instance.new("Part")
    port.BrickColor = BrickColor.new(color)
    port.Name = name
    port.Transparency = 1
    nooutline(port)
    port.Reflectance = reflec
    port.Material = mater
    port.Anchored = false
    port.CanCollide = false
    port.Locked = true
    port.Size = Vector3.new(0.2, 0.2, 0.2)
    port.Parent = parnt
    return port
end

local function makemesh(meshtype, scale, meshid, parent)
    local mes = Instance.new("SpecialMesh")
    mes.MeshType = Enum.MeshType[meshtype]
    mes.Scale = scale
    if meshtype == "FileMesh" then mes.MeshId = meshid end
    mes.Parent = parent
    return mes
end

local function makeweld(parent, p0, p1, c0, c1)
    local wel = Instance.new("Weld")
    wel.Part0 = p0
    wel.Part1 = p1
    wel.C0 = c0
    if c1 then wel.C1 = c1 end
    wel.Parent = parent
    return wel
end

local function vidp(prnt)
    local s = Instance.new("ParticleEmitter")
    s.Enabled = false
    s.LockedToPart = true
    s.Color = ColorSequence.new(Color3.fromRGB(36, 235, 235))
    s.LightEmission = 0.6
    s.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.275), NumberSequenceKeypoint.new(0.406, 0.762), NumberSequenceKeypoint.new(0.433, 2.05), NumberSequenceKeypoint.new(0.476, 0.625), NumberSequenceKeypoint.new(1, 0.05)})
    s.Texture = "rbxassetid://31270182"
    s.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.89, 0.6), NumberSequenceKeypoint.new(1, 1)})
    s.Name = "vid"
    s.Lifetime = NumberRange.new(0.2)
    s.Rate = 25
    s.Speed = NumberRange.new(7, 10)
    s.VelocitySpread = 360
    s.Parent = prnt

    local s2 = Instance.new("ParticleEmitter")
    s2.Enabled = false
    s2.LockedToPart = false
    s2.Color = ColorSequence.new(Color3.fromRGB(36, 235, 235))
    s2.LightEmission = 0.6
    s2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.853, 0.125), NumberSequenceKeypoint.new(1, 0)})
    s2.Texture = "rbxassetid://31270182"
    s2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.89, 0.6), NumberSequenceKeypoint.new(1, 1)})
    s2.Name = "vid2"
    s2.Lifetime = NumberRange.new(0.5)
    s2.Rate = 150
    s2.Speed = NumberRange.new(2, 6)
    s2.VelocitySpread = 360
    s2.Parent = prnt
end

local function glow(tz, paz, length)
    if tz.Parent:FindFirstChildOfClass("Humanoid") and paz.Transparency == 1 then
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://221727606"
        s.Volume = 0.25
        s.Pitch = math.random(9, 11) / 10
        s.Parent = paz
        s:Play()
        
        local hmesh = Instance.new("SpecialMesh")
        hmesh.MeshType = Enum.MeshType.FileMesh
        hmesh.MeshId = "NOSSIN"
        hmesh.Parent = paz.Parent
        paz.Transparency = 0.55
        paz.vid.Enabled = true
        paz.vid2.Enabled = true
        
        task.delay(length, function()
            paz.Transparency = 1
            paz.vid.Enabled = false
            paz.vid2.Enabled = false
            hmesh:Destroy()
            s:Destroy()
        end)
    end
end

local function makeglow()
    for _, p in pairs(chr:GetChildren()) do
        if p.ClassName == "Accessory" then
            local h = p:FindFirstChildOfClass("Part")
            local nh = h:Clone()
            for _, n in ipairs(nh:GetChildren()) do
                if n.ClassName == "Attachment" or n.ClassName == "Motor6D" or n.ClassName == "Weld" then n:Destroy() end
            end
            nooutline(nh)
            nh.CFrame = h.CFrame
            nh.Transparency = 1
            nh.Name = "Glow"
            nh.Material = Enum.Material.Neon
            nh.BrickColor = BrickColor.new("Teal")
            nh.CustomPhysicalProperties = PhysicalProperties.new(0.2, 0.3, 0.5)
            nh.CanCollide = false
            nh.Parent = h
            makeweld(nh, nh, h, cf(0, 0, 0))
            
            local m = nh:FindFirstChildOfClass("SpecialMesh")
            if m then
                m.Scale = m.Scale + Vector3.new(0.06, 0.06, 0.06)
                m.TextureId = ""
            end
            vidp(nh)
            nh.Touched:Connect(function(po) glow(po, nh, 0.8) end)
            
        elseif p.ClassName == "Part" and p ~= hrp and p.Name ~= "HumanoidRootPart" then
            local n = p:Clone()
            for _, m in ipairs(n:GetChildren()) do
                if m.ClassName == "Attachment" or m.ClassName == "Motor6D" or m.ClassName == "Weld" then m:Destroy() end
            end
            nooutline(n)
            n.Transparency = 1
            n.Material = Enum.Material.Neon
            n.Name = "Glow"
            n.BrickColor = BrickColor.new("Teal")
            n.CFrame = p.CFrame
            n.CustomPhysicalProperties = PhysicalProperties.new(0.2, 0.3, 0.5)
            n.CanCollide = false
            n.Parent = p
            makeweld(n, n, p, cf(0, 0, 0))
            vidp(n)
            n.Touched:Connect(function(po) glow(po, n, 0.8) end)
            
            if n:FindFirstChildOfClass("Decal") then n:FindFirstChildOfClass("Decal"):Destroy() end
            
            if p:FindFirstChildOfClass("SpecialMesh") then
                local c = p:FindFirstChildOfClass("SpecialMesh"):Clone()
                c.Scale = c.Scale + Vector3.new(0.05, 0.05, 0.05)
                c.Parent = n
            else
                local m = Instance.new("BlockMesh")
                m.Scale = (p == tors) and Vector3.new(1.05, 1.05, 1.05) or Vector3.new(1.05, 1.025, 1.05)
                m.Parent = n
            end
        end
    end
end
makeglow()

local function lerpz(joint, prop, cfrmz, alp)
    joint[prop] = joint[prop]:Lerp(cfrmz, alp)
end

local function resetlerp()
    RJ.C0, RJ.C1 = RJC0, RJC1
    N.C0, N.C1 = NC0, NC1
    RS.C0, RS.C1 = RSC0, RSC1
    LS.C0, LS.C1 = LSC0, LSC1
    RH.C0, RH.C1 = RHC0, RHC1
    LH.C0, LH.C1 = LHC0, LHC1
end

local ign = {chr}

local function proj(cframe)
    task.spawn(function()
        local mis = Instance.new("Part")
        mis.Anchored = true
        mis.CanCollide = false
        mis.Size = Vector3.new(1, 1, 1)
        mis.Transparency = 1
        mis.Name = "pew"
        mis.CFrame = cframe
        mis.Parent = workspace
        
        local s = Instance.new("ParticleEmitter")
        s.Enabled = true
        s.Color = ColorSequence.new(Color3.fromRGB(36, 235, 235))
        s.LightEmission = 0.6
        s.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(0.0241, 0.0625), NumberSequenceKeypoint.new(0.0299, 0.66), NumberSequenceKeypoint.new(0.0344, 0.0225), NumberSequenceKeypoint.new(1, 0)})
        s.Texture = "rbxassetid://31270182"
        s.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.89, 0.6), NumberSequenceKeypoint.new(1, 1)})
        s.Name = "vid"
        s.Lifetime = NumberRange.new(1)
        s.Rate = 3000
        s.Speed = NumberRange.new(25, 50)
        s.VelocitySpread = 20
        s.EmissionDirection = Enum.NormalId.Back
        s.Parent = mis
        Debris:AddItem(mis, 10)
        table.insert(ign, mis)
        
        local wat = 0
        local derp = false
        local v = Instance.new("Sound")
        v.SoundId = "rbxassetid://221727606"
        v.Volume = 0.5
        v.Looped = true
        v.Pitch = math.random(12, 13) / 10
        v.Parent = mis
        v:Play()
        
        repeat
            swait()
            wat = wat + 1
            local ray = Ray.new(mis.Position, mis.CFrame.LookVector * 8)
            local prt, pos = workspace:FindPartOnRayWithIgnoreList(ray, ign)
            if prt and pos and 1 > prt.Transparency then
                derp = true
                mis.CFrame = CFrame.new(pos)
                v:Stop()
                s.Enabled = false
                s.Speed = NumberRange.new(15, 25)
                s.Lifetime = NumberRange.new(5)
                s.VelocitySpread = 360
                s:Emit(40)
                local n = Instance.new("Sound")
                n.Volume = 0.75
                n.Pitch = rd2(9, 11) / 10
                n.SoundId = "rbxassetid://184374162"
                n.Parent = mis
                n:Play()
                hito(mis, 300, 500000, 0.01) -- Does 0 damage
            else
                mis.CFrame = mis.CFrame * CFrame.new(0, 0, -5)
            end
        until wat == 50 or derp == true
        
        if derp == true then Debris:AddItem(mis, 1) end
    end)
end

local function hito(partoz, magn, dmg, debtim)
    for _, guy in pairs(workspace:GetChildren()) do
        local hum = guy:FindFirstChild("Humanoid")
        local head = guy:FindFirstChild("Head")
        if hum and head and guy ~= chr and magn > (head.Position - partoz.Position).Magnitude and not head:FindFirstChild("alabo") then
            -- DEALS ZERO DAMAGE
            local db = Instance.new("StringValue")
            db.Name = "alabo"
            db.Parent = head
            task.delay(debtim, function() db:Destroy() end)
        end
    end
end

-- Sword
local function makesword(swocfrm, weldp1, cframe0)
    local ay = function(name, size, parnt)
        local port = Instance.new("Part")
        port.BrickColor = BrickColor.new("Teal")
        port.Name = name
        port.Transparency = 1
        nooutline(port)
        port.Material = Enum.Material.Neon
        port.Anchored = false
        port.CanCollide = false
        port.Locked = true
        port.Size = size
        port.Parent = parnt
        return port
    end

    local swordmo = Instance.new("Model")
    swordmo.Name = "swod"
    swordmo.Parent = modz
    
    local booval = Instance.new("BoolValue")
    booval.Value = true
    booval.Name = "mememem"
    booval.Parent = swordmo

    local function pr(par, amt, sped)
        local s = Instance.new("ParticleEmitter")
        s.Enabled = false
        s.LockedToPart = true
        s.Color = ColorSequence.new(Color3.fromRGB(36, 235, 235))
        s.LightEmission = 0.6
        s.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(0.05, 0.3), NumberSequenceKeypoint.new(0.1, 0.15), NumberSequenceKeypoint.new(0.8, 0.2), NumberSequenceKeypoint.new(1, 0)})
        s.Texture = "rbxassetid://31270182"
        s.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(0.89, 0.7), NumberSequenceKeypoint.new(1, 1)})
        s.Name = "vid"
        s.Lifetime = NumberRange.new(0.75)
        s.Rate = 1
        s.Speed = sped
        s.VelocitySpread = 3
        s.Parent = par
        task.spawn(function()
            while booval.Value do
                swait()
                s:Emit(amt)
            end
        end)
        return s
    end

    local b1 = ay("b1", Vector3.new(0.3, 2.5, 0.3), swordmo)
    pr(b1, 5, NumberRange.new(0, 1))
    if weldp1 then
        makeweld(b1, b1, weldp1, cframe0, nil)
    end
    local bla = Instance.new("Sound")
    bla.SoundId = "rbxassetid://61425219"
    bla.Volume = 0.75
    bla.Pitch = math.random(7, 9) / 10
    bla.Parent = b1
    bla:Play()

    local b2 = ay("b2", Vector3.new(0.6, 0.75, 0.4), swordmo)
    pr(b2, 1, NumberRange.new(0, 1))
    makeweld(b2, b2, b1, ang(rd(180), rd(0), rd(0)) * cf(0, 1.5, 0), nil)

    local b3 = ay("b3", Vector3.new(0.7, 0.75, 0.5), swordmo)
    pr(b3, 1, NumberRange.new(0, 3))
    makeweld(b3, b3, b1, ang(rd(180), rd(90), rd(0)) * cf(0, -1.5, 0), nil)

    local b8 = ay("b8", Vector3.new(0.5, 5.5, 0.2), swordmo)
    pr(b8, 9, NumberRange.new(1, 3))
    makeweld(b8, b8, b1, ang(rd(0), rd(0), rd(0)) * cf(0, -4, 0), nil)

    return swordmo
end

local function removesword(swordmodel)
    swordmodel.mememem.Value = false
    local hn = swordmodel.b1
    hn.Anchored = true
    local w = hn:FindFirstChildOfClass("Weld")
    if w then w:Destroy() end

    local bla = Instance.new("Sound")
    bla.SoundId = "rbxassetid://192783601"
    bla.Volume = 1.25
    bla.Pitch = math.random(9, 10) / 10
    bla.Parent = hn
    bla:Play()
    Debris:AddItem(swordmodel, 1.25)
end

-- Sword swing
local function eswing()
    if activu or not selected then return end
    activu = true
    local sw = makesword(hrp.CFrame, rarm, ang(rd(90), rd(0), rd(90)) * cf(0, 1, 0.5))
    
    for _ = 1, 12 do
        swait()
        lerpz(RJ, "C0", RJC0 * cf(0, 0.75, 0) * ang(rd(0), rd(0), rd(-70)), 0.5)
        lerpz(RS, "C0", RSC0 * cf(0.3, 0.25, 0.55) * ang(rd(-30), rd(-70), rd(15)), 0.5)
        lerpz(LS, "C0", LSC0 * ang(rd(10), rd(5), rd(10)), 0.5)
    end
    for _ = 1, 14 do
        swait()
        hito(sw.b8, 3, 35, 0.8) -- Does 0 damage
        lerpz(RJ, "C0", RJC0 * cf(0, -0.75, 0) * ang(rd(0), rd(0), rd(60)), 0.6)
        lerpz(RS, "C0", RSC0 * cf(-0.1, 0.65, 0.9) * ang(rd(-15), rd(135), rd(-165)), 0.6)
    end
    removesword(sw)
    resetlerp()
    activu = false
end

-- Torrent Gun
local function torentmod()
    if not selected or activu then return end
    if not torrent then
        torrent = true
        local viarm = Instance.new("Part")
        nooutline(viarm)
        viarm.CanCollide = false
        viarm.Transparency = 1
        viarm.Name = "shootingu"
        viarm.Size = Vector3.new(1.25, 1, 1.25)
        viarm.CFrame = rarm.CFrame
        viarm.Parent = modz
        makeweld(viarm, viarm, rarm, cf(0, 1, 0))

        local s = Instance.new("ParticleEmitter")
        s.Enabled = true
        s.Color = ColorSequence.new(Color3.fromRGB(36, 235, 235))
        s.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.0241, 0.0925), NumberSequenceKeypoint.new(0.0299, 0.56), NumberSequenceKeypoint.new(0.0344, 0.0925), NumberSequenceKeypoint.new(1, 0)})
        s.Texture = "rbxassetid://31270182"
        s.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.89, 0.6), NumberSequenceKeypoint.new(1, 1)})
        s.Name = "vid"
        s.Lifetime = NumberRange.new(1)
        s.Rate = 1250
        s.Speed = NumberRange.new(2, 3)
        s.VelocitySpread = 180
        s.Parent = viarm

        task.spawn(function()
            while torrent do
                swait()
                lerpz(RS, "C0", RSC0 * ang(rd(0), rd(0), rd(90)), 0.3)
            end
        end)

        local shootinz = false
        tool.Activated:Connect(function()
            shootinz = true
            repeat
                swait(3)
                lerpz(RS, "C0", RSC0 * cf(rd2(-3, -1) / 10, 0, 0) * ang(rd(rd2(-5, 5)), rd(rd2(-5, 5)), rd(rd2(95, 105))), 0.8)
                proj(CFrame.new(viarm.Position, mouse.Hit.Position + Vector3.new(rd2(-1, 1), rd2(-1, 1), 0)))
            until not shootinz or not torrent
        end)
        tool.Deactivated:Connect(function()
            shootinz = false
        end)
    else
        torrent = false
        local v = modz:FindFirstChild("shootingu")
        if v then v:Destroy() end
        resetlerp()
    end
end

-- Fly
local function fly()
    if not selected or activu or torrent then return end
    activu = true
    human.PlatformStand = true
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(15000, 15000, 15000)
    bg.P = 2500
    bg.D = 100
    bg.CFrame = CFrame.new(hrp.Position, mouse.Hit.Position)
    bg.Parent = hrp

    local bf = Instance.new("BodyVelocity")
    bf.MaxForce = Vector3.new(15000, 15000, 15000)
    bf.P = 2500
    bf.Velocity = (mouse.Hit.Position - hrp.Position).Unit * 200
    bf.Parent = hrp

    for d = 1, 100 do
        swait()
        bg.CFrame = CFrame.new(hrp.Position, mouse.Hit.Position)
        bf.Velocity = (mouse.Hit.Position - hrp.Position).Unit * (200 - d * 2)
        lerpz(RJ, "C0", RJC0 * ang(rd(80), rd(0), math.sin(-hrp.RotVelocity.Y / 5)), 0.4)
    end

    bf:Destroy()
    bg:Destroy()
    human.PlatformStand = false
    resetlerp()
    activu = false
end

-- Speed
local function suprfast()
    if not selected or activu then return end
    activu = true
    human.WalkSpeed += 30
    human.JumpPower += 45
    task.wait(2)
    human.WalkSpeed -= 30
    human.JumpPower -= 45
    activu = false
end

-- Music / Meme
local function musiclel()
    if not selected or activu then return end
    if not boxingu then
        boxingu = true
        local derp = makepart("Teal", "hurr", 0.25, Enum.Material.Neon, modz, hrp.CFrame)
        derp.Anchored = true
        derp.Transparency = 0.5
        derp.Size = Vector3.new(3, 2, 2)
        derp.CFrame = hrp.CFrame
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://151760030"
        mesh.Parent = derp
        
        local s = Instance.new("Sound")
        s.Name = "moose"
        s.Volume = 1
        s.EmitterSize = 40
        s.MaxDistance = 40
        s.Looped = true
        s.Parent = derp

        -- Fix the GUI and sound logic here
        local sg = Instance.new("ScreenGui", plr.PlayerGui)
        sg.Name = "simpleflips"
        
        local fr = Instance.new("Frame", sg)
        fr.Position = UDim2.new(0.85, 0, 0.4, 0)
        fr.Size = UDim2.new(0, 200, 0, 100)
        fr.BackgroundColor3 = Color3.fromRGB(24, 244, 255)
        
        local mbox = Instance.new("TextBox", fr)
        mbox.Position = UDim2.new(0.5, -75, 0.1, 0)
        mbox.Size = UDim2.new(0, 150, 0, 40)
        mbox.Text = "MEME"
        
        local pley = Instance.new("TextButton", fr)
        pley.Position = UDim2.new(0.1, 0, 0.6, 0)
        pley.Size = UDim2.new(0, 75, 0, 35)
        pley.Text = "Play"
        
        local stap = Instance.new("TextButton", fr)
        stap.Position = UDim2.new(0.55, 0, 0.6, 0)
        stap.Size = UDim2.new(0, 75, 0, 35)
        stap.Text = "Stop"

        pley.MouseButton1Click:Connect(function()
            s.SoundId = "rbxassetid://" .. mbox.Text
            s:Play()
        end)
        stap.MouseButton1Click:Connect(function()
            s:Stop()
        end)
    else
        boxingu = false
        local derp = modz:FindFirstChild("hurr")
        if derp then derp:Destroy() end
        local sg = plr.PlayerGui:FindFirstChild("simpleflips")
        if sg then sg:Destroy() end
    end
end

-- Input
mouse.KeyDown:Connect(function(key)
    if key == "f" then suprfast() end
    if key == "q" then torentmod() end
    if key == "c" then fly() end
    if key == "e" then eswing() end
    if key == "m" then musiclel() end
end)

tool.Equipped:Connect(function() selected = true end)
tool.Unequipped:Connect(function() selected = false end)
