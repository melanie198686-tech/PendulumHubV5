--------------------------------------------------------------------------------
--A Really Mad Guy with a Knife, a Tec-9 and a Sawed-Off! THOSE KIDS WILL PAY!--
--------------------------------------------------------------------------------
--By CKbackup (Sugarie Saffron)
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local debby = game:GetService("Debris")

_G.loop = true
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

if not char:FindFirstChild("Torso") then
    warn("[MadGuy] R6 required."); return
end

local function Align(Part0, Part1, Mesh, loopVar)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition    = Instance.new("AlignPosition", Part0)
    }
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')
    if Mesh and m then m:Destroy() end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
    Aligns.AlignPosition.MaxForce = 999999999
    task.spawn(function()
        while _G[loopVar] do
            local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude
            if mag >= 5 then
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
            end
            Part0.Velocity = Vector3.new(0,35,0)
            RunService.Heartbeat:Wait()
        end
    end)
    return {Attachments.Attach0, Attachments, Aligns}
end

local whiteSS = char:FindFirstChild('White SS')
if whiteSS and whiteSS:FindFirstChild('Handle') then
    local hat = Align(whiteSS.Handle, char['Left Arm'], false, "loop")
    if hat and hat[1] then
        local cf = char['Left Arm'].CFrame*CFrame.new(0,-.6,-.75)*CFrame.Angles(math.rad(45),math.rad(-20),0)
        hat[1].CFrame = cf:Inverse() * char['Left Arm'].CFrame
    end
end
task.spawn(function() char.AncestryChanged:Wait(); _G.loop = false end)

_G.loop2 = true
local rifle = char:FindFirstChild('Cartoony Rainbow Rifle')
if rifle and rifle:FindFirstChild('Handle') then
    local hat = Align(rifle.Handle, char['Right Arm'], false, "loop2")
    if hat and hat[1] then
        local cf = char['Right Arm'].CFrame*CFrame.new(0,-1,-0.5)*CFrame.Angles(math.rad(35),math.rad(70),60)
        hat[1].CFrame = cf:Inverse() * char['Right Arm'].CFrame
    end
end
task.spawn(function() char.AncestryChanged:Wait(); _G.loop2 = false end)

task.wait(1/60)

local Player    = Players.LocalPlayer
local chara     = Player.Character or Player.CharacterAdded:Wait()
local Humanoid  = chara:FindFirstChildOfClass("Humanoid")
local Mouse     = Player:GetMouse()
local LeftArm   = chara["Left Arm"]
local RightArm  = chara["Right Arm"]
local LeftLeg   = chara["Left Leg"]
local RightLeg  = chara["Right Leg"]
local Head      = chara.Head
local Torso     = chara.Torso
local Camera    = workspace.CurrentCamera
local RootPart  = chara.HumanoidRootPart
local RootJoint = RootPart.RootJoint

local attack = false
local Anim = 'Idle'
local attacktype = 1
local delays = false
local play = true
local targetted = nil
local Torsovelocity = (RootPart.Velocity * Vector3.new(1, 0, 1)).magnitude
local velocity = RootPart.Velocity.y
local sine = 0
local change = 1
local doe = 0

Humanoid.WalkSpeed = 8
if Humanoid:FindFirstChild("Animator") then Humanoid.Animator.Parent = nil end
if chara:FindFirstChild("Animate") then chara.Animate.Parent = nil end

-- ============================================================
-- FIXED motor: removes any existing joint between the two parts
-- and creates a Motor6D instead of the deprecated Motor class
-- ============================================================
local function newMotor(part0, part1, c0, c1)
    for _, container in ipairs({part0, part1}) do
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Motor6D") or child:IsA("Motor") or child:IsA("Weld") then
                if (child.Part0 == part0 and child.Part1 == part1)
                or (child.Part0 == part1 and child.Part1 == part0) then
                    child:Destroy()
                end
            end
        end
    end
    local w = Instance.new('Motor6D')
    w.Parent = part0
    w.Part0  = part0
    w.Part1  = part1
    w.C0     = c0
    w.C1     = c1
    return w
end

local function clerp(a, b, t) return a:lerp(b, t) end

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local NeckCF = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

local RW = newMotor(Torso, RightArm, CFrame.new(1.5, 0, 0),  CFrame.new(0, 0, 0))
local LW = newMotor(Torso, LeftArm,  CFrame.new(-1.5, 0, 0), CFrame.new(0, 0, 0))
local RH = newMotor(Torso, RightLeg, CFrame.new(.5, -2, 0),   CFrame.new(0, 0, 0))
local LH = newMotor(Torso, LeftLeg,  CFrame.new(-.5, -2, 0),  CFrame.new(0, 0, 0))

RootJoint.C1    = CFrame.new(0, 0, 0)
RootJoint.C0    = CFrame.new(0, 0, 0)
Torso.Neck.C1   = CFrame.new(0, 0, 0)
Torso.Neck.C0   = CFrame.new(0, 1.5, 0)

local rarmc1 = RW.C1
local larmc1 = LW.C1
local rlegc1 = RH.C1
local llegc1 = LH.C1
local resetc1 = false

local function PlayAnimationFromTable(t, speed, bool)
    RootJoint.C0 = clerp(RootJoint.C0, t[1], speed)
    Torso.Neck.C0 = clerp(Torso.Neck.C0, t[2], speed)
    RW.C0 = clerp(RW.C0, t[3], speed)
    LW.C0 = clerp(LW.C0, t[4], speed)
    RH.C0 = clerp(RH.C0, t[5], speed)
    LH.C0 = clerp(LH.C0, t[6], speed)
    if bool == true and resetc1 == false then
        resetc1 = true
        RW.C1 = rarmc1; LW.C1 = larmc1; RH.C1 = rlegc1; LH.C1 = llegc1
    end
end

local ArtificialHB = Instance.new("BindableEvent")
ArtificialHB.Name = "Heartbeat"
local frame = 0.03333333333333
local tf = 0
ArtificialHB:Fire()
RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for i = 1, math.floor(tf / frame) do ArtificialHB:Fire() end
        tf = tf - frame * math.floor(tf / frame)
    end
end)

local function swait(num)
    if num == 0 or num == nil then
        ArtificialHB.Event:Wait()
    else
        for _ = 0, num do ArtificialHB.Event:Wait() end
    end
end

local function RemoveOutlines(part)
    part.TopSurface, part.BottomSurface = 10, 10
    part.LeftSurface, part.RightSurface = 10, 10
    part.FrontSurface, part.BackSurface = 10, 10
end

local function so(id, par, pit, vol)
    local sou = Instance.new("Sound", par or workspace)
    if par == chara then sou.Parent = chara.Torso end
    sou.Volume  = vol
    sou.Pitch   = pit or 1
    sou.SoundId = "rbxassetid://" .. id
    sou.PlayOnRemove = true
    sou:Destroy()
end

local function New(Class, Parent, Name, Data)
    local obj = Instance.new(Class)
    for Index, Value in pairs(Data or {}) do obj[Index] = Value end
    obj.Parent = Parent
    obj.Name = Name
    return obj
end

local Naifu = New("Part", chara, "Naifu", {
    BrickColor = BrickColor.new("Dark stone grey"),
    Size = Vector3.new(0.2, 0.2, 2.1),
    CFrame = CFrame.new(0,0,0),
    CanCollide = false, Material = Enum.Material.SmoothPlastic,
    Color = Color3.new(0.388235, 0.372549, 0.384314)
})
New("SpecialMesh", Naifu, "Mesh", {
    Scale = Vector3.new(0.5, 0.7, 0.5),
    MeshId = "rbxassetid://54430772",
    TextureId = "rbxassetid://54430066",
    MeshType = Enum.MeshType.FileMesh
})
New("ManualWeld", Naifu, "Weld", {
    Part0 = Naifu, Part1 = LeftArm,
    C0 = CFrame.new(0,0,0,-0.556669891,-0.766044796,-0.321393907,-0.663414657,0.642787278,-0.383021802,0.499999702,7.3450633e-07,-0.866025567),
    C1 = CFrame.new(-0.0408859253,-1.28767514,0.650009155,-0.866025388,0,-0.500000238,0,1,0,0.500000238,0,-0.866025388)
})

local TEC9 = New("Part", chara, "TEC9", {
    BrickColor = BrickColor.new("Dark stone grey"), Transparency = 1,
    Size = Vector3.new(0.2, 1.2, 1.8), CFrame = CFrame.new(0,0,0),
    CanCollide = false, Material = Enum.Material.SmoothPlastic,
    Color = Color3.new(0.388235, 0.372549, 0.384314)
})
New("SpecialMesh", TEC9, "Mesh", {
    Scale = Vector3.new(0.3, 0.3, 0.3),
    MeshId = "rbxassetid://742046473",
    TextureId = "rbxassetid://742046691",
    MeshType = Enum.MeshType.FileMesh
})
New("ManualWeld", TEC9, "Weld", {
    Part0 = TEC9, Part1 = RightArm,
    C0 = CFrame.new(0,0,0,-1,5.16190539e-08,-1.29974794e-07,-1.00172471e-07,-8.19882651e-09,1,-1.61844298e-08,1,-4.67569983e-08),
    C1 = CFrame.new(-0.0999984741,-1.70001817,-7.62939453e-06,-1,0,0,0,1,0,0,0,-1)
})

local DBarrel = New("Part", chara, "DBarrel", {
    BrickColor = BrickColor.new("Dark stone grey"), Transparency = 1,
    Size = Vector3.new(0.2, 0.8, 2.1), CFrame = CFrame.new(0,0,0),
    CanCollide = false, Material = Enum.Material.SmoothPlastic,
    Color = Color3.new(0.388235, 0.372549, 0.384314)
})
New("SpecialMesh", DBarrel, "Mesh", {
    Scale = Vector3.new(0.007, 0.007, 0.007),
    MeshId = "rbxassetid://438826329",
    TextureId = "rbxassetid://438826340",
    MeshType = Enum.MeshType.FileMesh
})
New("ManualWeld", DBarrel, "Weld", {
    Part0 = DBarrel, Part1 = RightArm,
    C0 = CFrame.new(0,0,0,0.99998486,-0.00132099993,0.00535099953,0.00129485771,0.999987245,0.00488600042,-0.00535738515,-0.0048789978,0.999973774),
    C1 = CFrame.new(0.00952529907,-1.46699142,-0.100050688,-0.868691146,-0.00176300027,0.495351046,-0.495353371,0.00488599995,-0.868677914,-0.000888805604,-0.999986589,-0.00511773303)
})

local att1 = Instance.new("Attachment", Naifu); att1.Position = Vector3.new(0, .2, -.2)
local att2 = Instance.new("Attachment", Naifu); att2.Position = Vector3.new(0, .1, 1.5)
local tr1 = Instance.new("Trail", Naifu)
tr1.Color = ColorSequence.new(Color3.new(.5,.5,.5), Color3.new(1,1,1))
tr1.Transparency = NumberSequence.new(0, 1)
tr1.Lifetime = .5
tr1.Enabled  = false
tr1.Attachment0 = att1
tr1.Attachment1 = att2

for _, v in pairs(chara:GetChildren()) do
    if v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
end
local sh = Instance.new("Shirt", chara); sh.ShirtTemplate = "rbxassetid://567462542"
local pn = Instance.new("Pants", chara); pn.PantsTemplate = "rbxassetid://1521666087"

local function rayCast(Position, Direction, Range, Ignore)
    if Direction.Magnitude == 0 then return nil, Position end
    return workspace:FindPartOnRay(Ray.new(Position, Direction.Unit * (Range or 999.999)), Ignore)
end

local EffectModel = Instance.new("Model", chara); EffectModel.Name = "Effects"

local Effects = {
    Block = function(cf, partsize, meshstart, meshadd, matr, colour, spin, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = partsize
        p.Anchored = true; p.CanCollide = false; p.Material = matr; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("BlockMesh", p); m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
                if spin then
                    p.CFrame = p.CFrame * CFrame.Angles(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                end
            end
            p:Destroy()
        end)
        return p
    end,
    Sphere = function(cf, partsize, meshstart, meshadd, matr, colour, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = partsize
        p.Anchored = true; p.CanCollide = false; p.Material = matr; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("SpecialMesh", p); m.MeshType = "Sphere"; m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
            end
            p:Destroy()
        end)
        return p
    end,
    Cylinder = function(cf, partsize, meshstart, meshadd, matr, colour, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = partsize
        p.Anchored = true; p.CanCollide = false; p.Material = matr; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("CylinderMesh", p); m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
            end
            p:Destroy()
        end)
        return p
    end,
    Wave = function(cf, meshstart, meshadd, colour, spin, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = Vector3.new()
        p.Anchored = true; p.CanCollide = false; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("SpecialMesh", p); m.MeshId = "rbxassetid://20329976"; m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
                p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(spin), 0)
            end
            p:Destroy()
        end)
        return p
    end,
    Ring = function(cf, meshstart, meshadd, colour, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = Vector3.new()
        p.Anchored = true; p.CanCollide = false; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("SpecialMesh", p); m.MeshId = "rbxassetid://3270017"; m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
            end
            p:Destroy()
        end)
        return p
    end,
    Meshed = function(cf, meshstart, meshadd, colour, meshid, textid, spin, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = Vector3.new()
        p.Anchored = true; p.CanCollide = false; p.CFrame = cf
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("SpecialMesh", p); m.MeshId = meshid; m.TextureId = textid; m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
                p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(spin), 0)
            end
            p:Destroy()
        end)
        return p
    end,
    Explode = function(cf, partsize, meshstart, meshadd, matr, colour, move, inverse, factor)
        local p = Instance.new("Part", EffectModel)
        p.BrickColor = BrickColor.new(colour); p.Size = partsize
        p.Anchored = true; p.CanCollide = false; p.Material = matr
        p.CFrame = cf * CFrame.Angles(math.rad(math.random(-360,360)), math.rad(math.random(-360,360)), math.rad(math.random(-360,360)))
        p.Transparency = inverse and 1 or 0
        local m = Instance.new("SpecialMesh", p); m.MeshType = "Sphere"; m.Scale = meshstart
        task.spawn(function()
            for i = 0, 1, factor do
                swait()
                p.Transparency = inverse and (1 - i) or i
                m.Scale = m.Scale + meshadd
                p.CFrame = p.CFrame * CFrame.new(0, move, 0)
            end
            p:Destroy()
        end)
        return p
    end,
}

local function chatfunc(text)
    task.spawn(function()
        if chara:FindFirstChild("TalkingBillBoard") ~= nil then
            chara:FindFirstChild("TalkingBillBoard"):Destroy()
        end
        local naeeym2 = Instance.new("BillboardGui", chara)
        naeeym2.Size = UDim2.new(0, 100, 0, 40)
        naeeym2.StudsOffset = Vector3.new(0, 3, 0)
        naeeym2.Adornee = chara.Head
        naeeym2.Name = "BLABLABLA"
        local tecks2 = Instance.new("TextLabel", naeeym2)
        tecks2.BackgroundTransparency = 1
        tecks2.BorderSizePixel = 0
        tecks2.Text = ""
        tecks2.Font = Enum.Font.Antique
        tecks2.TextSize = 24
        tecks2.TextStrokeTransparency = 0
        tecks2.TextColor3 = Color3.new(0,0,0)
        tecks2.TextStrokeColor3 = Color3.new(1,0,0)
        tecks2.Size = UDim2.new(1, 0, 0.5, 0)
        task.spawn(function()
            while tecks2 and tecks2.Parent do
                swait()
                tecks2.Position = UDim2.new(0, math.random(-3,3), 0, math.random(-3,3))
            end
        end)
        for i = 1, string.len(text), 1 do
            tecks2.Text = string.sub(text, 1, i)
            swait()
        end
        swait(30)
        for _ = 1, 5 do
            swait()
            tecks2.Position = tecks2.Position - UDim2.new(0, 0, .05, 0)
            tecks2.TextStrokeTransparency = tecks2.TextStrokeTransparency + .2
            tecks2.TextTransparency = tecks2.TextTransparency + .2
        end
        naeeym2:Destroy()
    end)
end

local function GetDudesTorso(c)
    return c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
end

local function BodyVel(part, faws)
    local bv = Instance.new("BodyVelocity", part)
    bv.P = 10000000
    bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
    bv.Velocity = faws
    debby:AddItem(bv, .2)
end

local function Dmg(dude, dmg, env, faws, trip, efftyp, toim)
    if not dude or dude == chara then return end
    if dude:FindFirstChild("HITO") then return end
    local debounce = Instance.new("BoolValue", dude)
    debounce.Name = "HITO"
    debby:AddItem(debounce, toim)
    local hum = dude:FindFirstChildOfClass("Humanoid")
    local dam = -math.huge
    if hum then
        local finhel = hum.Health - dam
        if finhel <= 0 and dude:FindFirstChild("DEATHED") == nil then
            Instance.new("BoolValue", dude).Name = "DEATHED"
            local soaa = Instance.new("Sound", dude.Head)
            local cho = math.random(1, 5)
            if cho == 1 then soaa.SoundId = "rbxassetid://111896685"
            elseif cho == 2 then soaa.SoundId = "rbxassetid://535528169"
            elseif cho == 3 then soaa.SoundId = "rbxassetid://1080363252"
            elseif cho == 4 then soaa.SoundId = "rbxassetid://147758746"
            elseif cho == 5 then soaa.SoundId = "rbxassetid://626777433"; soaa.Volume = .2; soaa.TimePosition = 1 end
            debby:AddItem(soaa, 6)
            soaa:Play()
        end
        hum.Health = hum.Health - dam
    end
    task.spawn(function()
        local naeeym2 = Instance.new("BillboardGui", dude)
        naeeym2.Size = UDim2.new(0, 100, 0, 40)
        naeeym2.StudsOffset = Vector3.new(0, 3, 0)
        naeeym2.Adornee = dude:FindFirstChild("Head")
        naeeym2.Name = "TalkingBillBoard"
        local tecks2 = Instance.new("TextLabel", naeeym2)
        tecks2.BackgroundTransparency = 1
        tecks2.BorderSizePixel = 0
        tecks2.Text = "-"..dam
        tecks2.Font = Enum.Font.Antique
        tecks2.TextSize = 24
        tecks2.TextStrokeTransparency = 0
        tecks2.TextColor3 = Color3.new(0,0,0)
        tecks2.TextStrokeColor3 = Color3.new(1,0,0)
        tecks2.Size = UDim2.new(1, 0, 0.5, 0)
        swait(10)
        for i = 0, 1, .05 do
            swait()
            tecks2.Position = tecks2.Position - UDim2.new(0, 0, .005, 0)
            tecks2.TextStrokeTransparency = i
            tecks2.TextTransparency = i
        end
        naeeym2:Destroy()
    end)
    local torsy = GetDudesTorso(dude)
    if torsy then
        if efftyp == "Sharp" then
            local cho = math.random(1, 3)
            if cho == 1 then so(444667824, torsy, 1, 1)
            elseif cho == 2 then so(444667844, torsy, 1, 1)
            elseif cho == 3 then so(444667859, torsy, 1, 1) end
        end
        if faws ~= 0 then BodyVel(torsy, faws) end
        if trip == true then
            torsy.CFrame = torsy.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
            torsy.RotVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
        end
    end
end

local function MagnitudeDmg(par, magni, dmg, env, faws, trip, efftyp, toim)
    for _, c in pairs(workspace:GetDescendants()) do
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and c ~= chara then
            local head = GetDudesTorso(c)
            if head and magni >= (head.Position - par.Position).magnitude then
                Dmg(c, dmg, env, faws, trip, efftyp, toim)
            end
        end
    end
end

local mus = Instance.new("Sound", Head)
mus.Name = "mus"
mus.SoundId = "rbxassetid://581195737"
mus.Looped = true
mus.Volume = 1
mus:Play()

task.spawn(function()
    chatfunc("I'm tired of all of this crap..")       swait(90)
    chatfunc("Now the day of reckoning has begun..")   swait(90)
    chatfunc("This shall be my finest hour..")         swait(90)
    chatfunc("ICH BIN GOTT! BERZERKER!")
end)

function smek()
    attack = true
    Humanoid.WalkSpeed = 16
    for _ = 0, 1, .1 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(0.0506498702, -5.11459177e-07, -0.0829713419, 0.76604414, 0, 0.642788053, -2.68192082e-07, 1.00000834, 3.19618522e-07, -0.642793417, -4.17232513e-07, 0.766050518),
            CFrame.new(0.0446723551, 1.46553934, 0.0211830139, 0.735023618, 0.242944986, -0.633023083, -0.171009988, 0.969846427, 0.173647657, 0.656122029, -0.0193818808, 0.754406095),
            CFrame.new(1.40946591, -0.0135071278, 0, 1.00000012, 0, 0, 0, 1, 0, 0, 0, 1.00000012),
            CFrame.new(-1.55299187, 0.416839302, -0.457236975, 0.68952775, 0.492403448, -0.53112185, -0.633021951, 0.766044736, -0.11161866, 0.35190171, 0.413175911, 0.839911342),
            CFrame.new(0.499983132, -2.00001597, -9.13441181e-06, 0.76604414, 0, -0.642788053, 0, 1, 0, 0.642788053, 0, 0.76604414),
            CFrame.new(-0.500005186, -2.00001597, -1.22189522e-06, 0.98480773, 0, 0.173648447, 0, 1, 0, -0.173648447, 0, 0.98480773),
        }, .3, false)
    end
    Humanoid.WalkSpeed = 2
    tr1.Enabled = true
    so(536642316, Naifu, 1, 1)
    for _ = 0, 1.4, .2 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(0.0327370502, 1.24810251e-09, 0.00299140904, 0.64278698, 0, -0.766044974, 3.19616191e-07, 1, 2.68189382e-07, 0.766044974, -4.17229018e-07, 0.64278698),
            CFrame.new(-0.0331632644, 1.46557713, -0.11364907, 0.656121135, -0.0193833038, 0.754413188, -0.171011418, 0.969854534, 0.173649102, -0.735024333, -0.24294585, 0.633027315),
            CFrame.new(1.24921072, -0.104290992, 0.29409039, 0.93969059, 0.26200676, 0.21985054, -0.342026025, 0.719844162, 0.604022086, -2.68220901e-07, -0.642788291, 0.766043901),
            CFrame.new(-0.663761616, 0.985711455, -0.487553686, 0.383021712, -0.64278698, -0.663414836, -0.866025984, 0, -0.499998987, 0.321392834, 0.766044974, -0.556670249),
            CFrame.new(0.500005841, -2.00003386, -4.52250242e-06, 0.984807551, 0, -0.173649341, 0, 1, 0, 0.173649341, 0, 0.984807551),
            CFrame.new(-0.499993563, -2.00003386, -1.44541264e-06, 0.64278698, 0, 0.766044974, 0, 1, 0, -0.766044974, 0, 0.64278698),
        }, .5, false)
        MagnitudeDmg(Naifu, 3, 40, 3, RootPart.CFrame.lookVector*5, false, "Sharp", .5)
    end
    swait(5)
    Humanoid.WalkSpeed = 8
    tr1.Enabled = false
    attack = false
end

zhold = true
function shoot()
    attack = true
    so(169799883, TEC9, 1, 1)
    for _ = 0, 1, .1 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            CFrame.new(0.0838357508, 1.42719412, -0.166348219, 0.857789159, 0.297403604, -0.419224113, -0.141315028, 0.920631945, 0.363959879, 0.49419412, -0.252958179, 0.83173573),
            CFrame.new(1.22406256, -0.130654663, 0.277106255, 0.941511214, 0.33170712, 0.0593906641, -0.33170709, 0.881204426, 0.336822212, 0.0593910143, -0.336822152, 0.939693391),
            CFrame.new(-1.43159902, 0, 0.187939197, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
            CFrame.new(0.499998897, -1.99999988, -1.49011612e-06, 0.939692736, 0, -0.342019886, 0, 1, 0, 0.342019916, 0, 0.939692736),
            CFrame.new(-0.500001848, -1.99999988, 1.62422657e-06, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
        }, .3, false)
    end
    Humanoid.WalkSpeed = 2
    local ref = Instance.new("Part", chara)
    ref.Size = Vector3.new(0,0,0); ref.Anchored = true; ref.CanCollide = false; ref.Transparency = 1
    TEC9.Transparency = 0
    for _ = 0, 1, .1 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(-0.0438226089, 0, -0.0217384323, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
            CFrame.new(0.0674266815, 1.48262143, -0.0571227223, 0.939692736, 0.0593910702, -0.33682391, 0, 0.984807849, 0.173647985, 0.342019886, -0.163175747, 0.925416768),
            CFrame.new(1.62663007, 0.722141325, -0.273156077, 0.883022428, -0.342019916, 0.321393609, 0.342019916, 0, -0.939692736, 0.321393609, 0.939692736, 0.116977602),
            CFrame.new(-1.34998989, 0, 0.259806901, 0.866024911, 0, 0.500000954, 0, 1, 0, -0.500000954, 0, 0.866024852),
            CFrame.new(0.499997795, -1.99999917, -1.51991844e-06, 0.866025686, 0, -0.499999642, 0, 1, 0, 0.499999642, 0, 0.866025686),
            CFrame.new(-0.500000119, -1.99999917, 1.50501728e-06, 0.939692438, 0, 0.342020929, 0, 1, 0, -0.342020959, 0, 0.939692438),
        }, .3, false)
    end
    swait(5)
    local shots = 20
    repeat
        so(745308042, TEC9, 1, 1)
        ref.CFrame = Mouse.Hit
        MagnitudeDmg(ref, 2, 12, 2, RootPart.CFrame.lookVector*3, false, "Shot", .1)
        local hitpt = Instance.new("Part", EffectModel)
        hitpt.Size = Vector3.new(0, 0, .3)
        hitpt.CFrame = TEC9.CFrame * CFrame.new(0, .465, .1)
        hitpt.Velocity = RootPart.CFrame.rightVector*10 + Vector3.new(0, 5, 0)
        local hitm = Instance.new("SpecialMesh", hitpt)
        hitm.MeshId = "rbxassetid://94295100"; hitm.TextureId = "rbxassetid://94287792"; hitm.Scale = Vector3.new(3,3,3.5)
        task.spawn(function()
            swait(30)
            for i = 0, 1, .1 do swait(); hitpt.Transparency = i end
            hitpt:Destroy()
        end)
        Effects.Block(TEC9.CFrame*CFrame.new(-.05,.465,-.9), Vector3.new(1,1,1), Vector3.new(), Vector3.new(.1,.1,.1), "Neon", "Bright yellow", true, false, .1)
        shots = shots - 1
        for _ = 0, 1 do
            swait()
            PlayAnimationFromTable({
                CFrame.new(-0.0438226089, 0, -0.0217384323, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
                CFrame.new(0.0674266815, 1.48262143, -0.0571227223, 0.939692736, 0.0593910702, -0.33682391, 0, 0.984807849, 0.173647985, 0.342019886, -0.163175747, 0.925416768),
                CFrame.new(1.62663007, 0.722141325, -0.273156077, 0.883022428, -0.342019916, 0.321393609, 0.342019916, 0, -0.939692736, 0.321393609, 0.939692736, 0.116977602)*CFrame.Angles(math.rad(math.random(-5,5)),math.rad(math.random(-5,5)),math.rad(math.random(-5,5))),
                CFrame.new(-1.34998989, 0, 0.259806901, 0.866024911, 0, 0.500000954, 0, 1, 0, -0.500000954, 0, 0.866024852),
                CFrame.new(0.499997795, -1.99999917, -1.51991844e-06, 0.866025686, 0, -0.499999642, 0, 1, 0, 0.499999642, 0, 0.866025686),
                CFrame.new(-0.500000119, -1.99999917, 1.50501728e-06, 0.939692438, 0, 0.342020929, 0, 1, 0, -0.342020959, 0, 0.939692438),
            }, .3, false)
        end
    until zhold == false or shots == 0
    swait(5)
    ref:Destroy()
    TEC9.Transparency = 1
    Humanoid.WalkSpeed = 8
    attack = false
end

function dbshoot()
    attack = true
    so(169799883, DBarrel, 1, 1)
    for _ = 0, 1, .1 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            CFrame.new(0.0838357508, 1.42719412, -0.166348219, 0.857789159, 0.297403604, -0.419224113, -0.141315028, 0.920631945, 0.363959879, 0.49419412, -0.252958179, 0.83173573),
            CFrame.new(1.22406256, -0.130654663, 0.277106255, 0.941511214, 0.33170712, 0.0593906641, -0.33170709, 0.881204426, 0.336822212, 0.0593910143, -0.336822152, 0.939693391),
            CFrame.new(-1.43159902, 0, 0.187939197, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
            CFrame.new(0.499998897, -1.99999988, -1.49011612e-06, 0.939692736, 0, -0.342019886, 0, 1, 0, 0.342019916, 0, 0.939692736),
            CFrame.new(-0.500001848, -1.99999988, 1.62422657e-06, 0.939692736, 0, 0.342019886, 0, 1, 0, -0.342019916, 0, 0.939692736),
        }, .3, false)
    end
    Humanoid.WalkSpeed = 2
    DBarrel.Transparency = 0
    for _ = 0, 1, .1 do
        swait()
        PlayAnimationFromTable({
            CFrame.new(0, 0.0149096567, 0.133909225, 1, 0, 0, 0, 0.984807849, -0.173647985, 0, 0.173647985, 0.984807849),
            CFrame.new(0, 1.43158329, -0.187937319, 1, 0, 0, 0, 0.939692855, 0.342019796, 0, -0.342019796, 0.939692855),
            CFrame.new(1.0840646, 0.399937928, -0.718070745, 0.868691146, 0.495353371, 0.000888805604, -0.0877529308, 0.15565595, -0.983905911, -0.487519473, 0.854632378, 0.17868565),
            CFrame.new(-1.35562694, -0.0255649146, 0.396688521, 0.939692378, -0.116977789, 0.321394831, -2.60770321e-07, 0.939692855, 0.342019856, -0.342021167, -0.321393549, 0.883021951),
            CFrame.new(0.499995321, -2.00755072, 0.218008161, 0.939692736, 0, -0.342019886, 0.0593910702, 0.984807849, 0.163175747, 0.33682391, -0.173647985, 0.925416768),
            CFrame.new(-0.499996126, -2.00755, 0.218011439, 0.939692736, 0, 0.342019886, -0.0593910702, 0.984807849, 0.163175747, -0.33682391, -0.173647985, 0.925416768),
        }, .3, false)
    end
    swait(5)
    so(132455829, DBarrel, 1, 1)
    local ref = Instance.new("Part", chara)
    ref.Size = Vector3.new(0,0,0); ref.Anchored = true; ref.CanCollide = false; ref.Transparency = 1
    ref.CFrame = RootPart.CFrame*CFrame.new(0, 0, -6)
    MagnitudeDmg(ref, 4, 100, 0, RootPart.CFrame.lookVector*12, true, "Shot", .1)
    Effects.Block(DBarrel.CFrame*CFrame.new(.1,.3,1.1),  Vector3.new(1,1,1), Vector3.new(), Vector3.new(.1,.1,.1), "Neon", "Bright yellow", true, false, .05)
    Effects.Block(DBarrel.CFrame*CFrame.new(-.1,.3,1.1), Vector3.new(1,1,1), Vector3.new(), Vector3.new(.1,.1,.1), "Neon", "Bright yellow", true, false, .05)
    ref:Destroy()
    swait(15)
    so(211134014, DBarrel, 1, 1)
    DBarrel.Transparency = 1
    Humanoid.WalkSpeed = 8
    attack = false
end

Mouse.Button1Down:Connect(function()
    if attack == false then smek() end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local k = input.KeyCode.Name:lower()
    if k == 'm' then
        if mus.IsPlaying then mus:Stop()
        elseif mus.IsPaused then mus:Play() end
    end
    if attack == false then
        if k == 'z' then zhold = true; shoot()
        elseif k == 'x' then dbshoot() end
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name:lower() == 'z' then zhold = false end
end)

task.spawn(function()
    while true do
        swait()
        doe = doe <= 360 and doe + 2 or 0
    end
end)

-- ============ MAIN ANIMATION LOOP ============
while true do
    swait()
    if Head:FindFirstChild("mus") == nil then
        mus = Instance.new("Sound", Head)
        mus.Name = "mus"
        mus.SoundId = "rbxassetid://581195737"
        mus.Looped = true
        mus.Volume = 1
        mus:Play()
    end
    Torsovelocity = (RootPart.Velocity * Vector3.new(1, 0, 1)).magnitude
    velocity = RootPart.Velocity.y
    sine = sine + change
    local hit = rayCast(RootPart.Position, (CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0))).lookVector, 4, chara)

    if RootPart.Velocity.y > 1 and hit == nil then
        Anim = "Jump"
        if attack == false then
            PlayAnimationFromTable({
                CFrame.new(0, 0.0382082276, -0.0403150208, 1, 0, 0, 0, 0.984807849, 0.173647985, 0, -0.173647985, 0.984807849),
                CFrame.new(0, 1.46579528, 0.0939689279, 1, 0, 0, 0, 0.939692855, -0.342019796, 0, 0.342019796, 0.939692855),
                CFrame.new(1.20945489, -0.213504896, 3.55388607e-07, 0.939692736, 0.342019916, 1.53461215e-07, -0.342019945, 0.939692736, 1.93715096e-07, -8.56816769e-08, -2.23517418e-07, 1.00000012),
                CFrame.new(-1.20945573, -0.213503733, 5.0439985e-07, 0.939692736, -0.342019916, -1.53461215e-07, 0.342019945, 0.939692736, 1.93715096e-07, 8.56816769e-08, -2.23517418e-07, 1.00000012),
                CFrame.new(0.5, -1.99739456, -0.0180913229, 1, 0, 0, 0, 1.00000012, 0, 0, 0, 1.00000012),
                CFrame.new(-0.5, -1.30000103, -0.39999947, 1, 0, 0, 0, 0.939692676, 0.342020601, 0, -0.342020601, 0.939692676),
            }, .3, false)
        end
    elseif RootPart.Velocity.y < -1 and hit == nil then
        Anim = "Fall"
        if attack == false then
            PlayAnimationFromTable({
                CFrame.new(0, -0.0646628663, 0.0399149321, 1, 0, 0, 0, 0.984807849, -0.173647985, 0, 0.173647985, 0.984807849),
                CFrame.new(0, 1.4913609, -0.128171027, 1, 0, 0, 0, 0.939692855, 0.342019796, 0, -0.342019796, 0.939692855),
                CFrame.new(1.55285025, 0.466259956, -9.26282269e-08, 0.766043842, -0.642788351, -6.46188241e-08, 0.642788291, 0.766043961, -7.4505806e-08, 1.04308128e-07, 1.49011612e-08, 1.00000012),
                CFrame.new(-1.5605253, 0.475036323, -2.10609159e-07, 0.766043842, 0.642788351, 6.46188241e-08, -0.642788291, 0.766043961, -7.4505806e-08, -1.04308128e-07, 1.49011612e-08, 1.00000012),
                CFrame.new(0.500000954, -1.9973948, -0.0180922765, 1, 0, 0, 0, 1.00000012, 0, 0, 0, 1.00000012),
                CFrame.new(-0.499999046, -1.30000043, -0.400000483, 1, 0, 0, 0, 0.939692855, 0.342019796, 0, -0.342019796, 0.939692855),
            }, .3, false)
        end
    elseif Torsovelocity < 1 and hit ~= nil then
        Anim = "Idle"
        if attack == false then
            change = 1
            PlayAnimationFromTable({
                CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.new(0, .05 * math.cos(sine/10), 0),
                CFrame.new(0, 1.48262823, -0.0984786302, 1, 0, 0, 0, 0.984807849, 0.173647985, 0, -0.173647985, 0.984807849),
                CFrame.new(1.20945334, -0.213505104, 0, 0.939692736, 0.342019886, 0, -0.342019916, 0.939692736, 0, 0, 0, 1),
                CFrame.new(-1.37076354, 0, -0.304326713, 0.866025388, 0, -0.500000238, 0, 1, 0, 0.500000238, 0, 0.866025388),
                CFrame.new(0.499997705, -2, -2.77906656e-06, 0.984807849, 0, -0.173647985, 0, 1, 0, 0.173647985, 0, 0.984807849) * CFrame.new(0, -.05 * math.cos(sine/10), 0),
                CFrame.new(-0.50000149, -2, -2.11596489e-06, 0.984807849, 0, 0.173647985, 0, 1, 0, -0.173647985, 0, 0.984807849) * CFrame.new(0, -.05 * math.cos(sine/10), 0),
            }, .3, false)
        end
    elseif Torsovelocity > 2 and hit ~= nil then
        Anim = "Walk"
        if attack == false then
            Humanoid.WalkSpeed = 8
            PlayAnimationFromTable({
                CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.new(0, -0.08 * math.cos(sine/5), 0),
                CFrame.new(0, 1.48263013, -0.0984808952, 1, 0, 0, 0, 0.984807849, 0.173647985, 0, -0.173647985, 0.984807849),
                CFrame.new(1.5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.new(0, 0, -.5 * math.cos(sine/10)) * CFrame.Angles(math.rad(30 * math.cos(sine/10)), 0, 0),
                CFrame.new(-1.37076354, 0, -0.304326713, 0.866025388, 0, -0.500000238, 0, 1, 0, 0.500000238, 0, 0.866025388),
                CFrame.new(0.540300786, -1.99793816, -9.82598067e-07, 0.998698533, -0.0510031395, 6.36324955e-07, 0.0510031395, 0.998698533, -1.00461093e-05, -8.35937328e-08, 1.08393433e-05, 1.00000024) * CFrame.new(0, 0, .5 * math.cos(sine/10)) * CFrame.Angles(math.rad(-30 * math.cos(sine/10)), 0, 0),
                CFrame.new(-0.539563596, -1.99794078, 1.12228372e-06, 0.998635888, 0.0523072146, -1.77852357e-07, -0.0523072146, 0.998635888, -1.00715051e-05, -3.89727461e-07, 1.08406466e-05, 1.00000024) * CFrame.new(0, 0, -.5 * math.cos(sine/10)) * CFrame.Angles(math.rad(30 * math.cos(sine/10)), 0, 0),
            }, .3, false)
        end
    end
end
