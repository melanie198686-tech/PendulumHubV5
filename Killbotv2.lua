--[[
    FIXED REANIMATION SCRIPT
    FIXED BY MELANIE!!!
]]

-- ===== INIT =====
local IN = Instance.new  -- FIX: defined

local SCRIPTUTIL = game:GetObjects("rbxassetid://5276526474")[1]
if not SCRIPTUTIL then error("Missing SCRIPTUTIL") end

-- ensure required children exist (create dummy if missing)
local function ensureChild(parent, name, className)
    local child = parent:FindFirstChild(name)
    if not child then
        child = IN(className or "Folder")
        child.Name = name
        child.Parent = parent
    end
    return child
end

local EffectsFolder = ensureChild(SCRIPTUTIL, "Effects")
local ExplosionDeb = ensureChild(SCRIPTUTIL, "ExplosionDebris")
local GibParticles = ensureChild(SCRIPTUTIL, "gibBlood")
local CrushedHeadModel = ensureChild(SCRIPTUTIL, "CrushedHead")
local MorphModel = ensureChild(SCRIPTUTIL, "Morph")
local MistAttach = ensureChild(SCRIPTUTIL, "Mist", "Attachment")  -- if needed

-- ===== HELPERS =====
local function linear(t, b, c, d) return c * t / d + b end
local function inBack(t, b, c, d, s)
    s = s or 1.70158
    t = t / d
    return c * t * t * ((s + 1) * t - s) + b
end
local function outBack(t, b, c, d, s)
    s = s or 1.70158
    t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b
end

-- ===== SEQUENCES =====
local Vector3Sequence, Vector3SequenceKeypoint = {}, {}
Vector3SequenceKeypoint.new = function(time, value, envelope)
    assert(typeof(time) == 'number', "bad argument #1")
    assert(typeof(value) == 'Vector3', "bad argument #2")
    return { Time = time, Value = value, Envelope = envelope }
end
Vector3Sequence.new = function(...)
    local tuple = { ... }
    if #tuple == 2 then
        return Vector3Sequence.new { Vector3SequenceKeypoint.new(0, tuple[1]), Vector3SequenceKeypoint.new(1, tuple[2]) }
    else
        local thing = tuple[1]
        if typeof(thing) == 'Vector3' then
            return Vector3Sequence.new(thing, thing)
        elseif typeof(thing) == 'table' then
            assert(#thing >= 2, "need at least 2 keypoints")
            local last
            for i, v in next, thing do
                assert(v.Value and v.Time and typeof(v.Value) == 'Vector3', "invalid keypoint at " .. i)
                if not last or v.Time > last then last = v.Time else error("times must be ordered") end
            end
            return setmetatable({ Keypoints = thing }, { __index = Vector3Sequence })
        else
            error("table expected")
        end
    end
end

local CFrameSequence, CFrameSequenceKeypoint = {}, {}
CFrameSequenceKeypoint.new = function(time, value, envelope)
    assert(typeof(time) == 'number', "bad argument #1")
    assert(typeof(value) == 'CFrame', "bad argument #2")
    return { Time = time, Value = value, Envelope = envelope }
end
CFrameSequence.new = function(...)
    local tuple = { ... }
    if #tuple == 2 then
        return CFrameSequence.new { CFrameSequenceKeypoint.new(0, tuple[1]), CFrameSequenceKeypoint.new(1, tuple[2]) }
    else
        local thing = tuple[1]
        if typeof(thing) == 'CFrame' then
            return CFrameSequence.new(thing, thing)
        elseif typeof(thing) == 'table' then
            assert(#thing >= 2, "need at least 2 keypoints")
            local last
            for i, v in next, thing do
                assert(v.Value and v.Time and typeof(v.Value) == 'CFrame', "invalid keypoint at " .. i)
                if not last or v.Time > last then last = v.Time else error("times must be ordered") end
            end
            return setmetatable({ Keypoints = thing }, { __index = CFrameSequence })
        else
            error("table expected")
        end
    end
end

local RNG = (function()
    local R = Random.new()
    return function(min, max, int)
        return int and R:NextInteger(min, max) or R:NextNumber(min, max)
    end
end)()

local S = setmetatable({}, { __index = function(s, i) return game:GetService(i) end })
local CF = { N = CFrame.new, A = CFrame.Angles, fEA = CFrame.fromEulerAnglesXYZ }
local C3 = { N = Color3.new, RGB = Color3.fromRGB, HSV = function(...) local d = { ... } if typeof(d[1]) == 'Color3' then return Color3.toHSV(...) else return Color3.fromHSV(...) end end }
local V3 = { N = Vector3.new, FNI = Vector3.FromNormalId, A = Vector3.FromAxis }
local M = {
    C = math.cos, R = math.rad, S = math.sin, T = math.tan, AT = math.atan, AT2 = math.atan2,
    AS = math.asin, AC = math.acos, A = math.abs, F = math.floor, CE = math.ceil, P = math.pi,
    RNG = RNG, H = math.huge, RRNG = function(...) return math.rad(RNG(...)) end
}
local R3 = Region3.new
local De = S.Debris
local WS = workspace
local Lght = S.Lighting
local RepS = S.ReplicatedStorage
local Plrs = S.Players

-- ===== PLAYER SETUP =====
local Plr = Plrs.LocalPlayer
if not Plr then error("No LocalPlayer") end

local Char = Plr.Character
if not Char then Char = Plr.CharacterAdded:Wait() end
local Hum = Char:FindFirstChildOfClass("Humanoid")
assert(Hum and Hum.RigType == Enum.HumanoidRigType.R6, "R6 Humanoid required")

local Head = Char.Head
local RArm = Char["Right Arm"]
local LArm = Char["Left Arm"]
local RLeg = Char["Right Leg"]
local LLeg = Char["Left Leg"]
local Torso = Char.Torso
local Root = Char.HumanoidRootPart

-- ===== HEARTBEAT (FIXED) =====
local Heartbeat = IN("BindableEvent")
Heartbeat.Name = "Heartbeat"
Heartbeat.Parent = SCRIPTUTIL

local tf = 0
local frame = 1 / 60
game:GetService("RunService").Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for _ = 1, math.floor(tf / frame) do
            Heartbeat:Fire()
        end
        tf = tf - frame * math.floor(tf / frame)
    end
end)

local function swait(num)
    if num == 0 or not num then
        Heartbeat.Event:Wait()
    else
        for _ = 1, num do
            Heartbeat.Event:Wait()
        end
    end
end

-- ===== INSTANCE CREATORS =====
local baseSound = IN("Sound")

function Sound(parent, id, pitch, volume, looped, effect, autoPlay)
    local s = baseSound:Clone()
    s.SoundId = "rbxassetid://" .. tostring(id or 0)
    s.Pitch = pitch or 1
    s.Volume = volume or 1
    s.Looped = looped or false
    if autoPlay then
        coroutine.wrap(function()
            repeat swait() until s.IsLoaded
            s.Playing = autoPlay
        end)()
    end
    if not looped and effect then
        s.Stopped:Connect(function()
            s.Volume = 0
            s:Destroy()
        end)
    elseif effect then
        warn("Can't be looped and effect")
    end
    s.Parent = parent or WS
    return s
end

function Part(parent, color, material, size, cframe, anchored, cancollide)
    local p = IN("Part")
    p[typeof(color) == 'BrickColor' and 'BrickColor' or 'Color'] = color or C3.N(0, 0, 0)
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface, p.BottomSurface = 10, 10
    p.Size = size or V3.N(1, 1, 1)
    p.CFrame = cframe or CF.N()
    p.CanCollide = cancollide or false
    p.Anchored = anchored or false
    p.Parent = parent
    return p
end

function Weld(part0, part1, c0, c1)
    local w = IN("Weld")
    w.Part0 = part0
    w.Part1 = part1
    w.C0 = c0 or CF.N()
    w.C1 = c1 or CF.N()
    w.Parent = part0
    return w
end

function Mesh(parent, meshtype, meshid, textid, scale, offset)
    local m = IN("SpecialMesh")
    m.MeshId = meshid or ""
    m.TextureId = textid or ""
    m.Scale = scale or V3.N(1, 1, 1)
    m.Offset = offset or V3.N(0, 0, 0)
    m.MeshType = meshtype or Enum.MeshType.Sphere
    m.Parent = parent
    return m
end

function SoundPart(id, pitch, volume, looped, effect, autoPlay, cf)
    local sp = Part(EffectsFolder, C3.N(1, 1, 1), Enum.Material.SmoothPlastic, V3.N(0.05, 0.05, 0.05), cf, true, false)
    sp.Transparency = 1
    local snd = Sound(sp, id, pitch, volume, looped, effect, autoPlay)
    return snd
end

function Joint(name, part0, part1, c0, c1, type)
    local j = IN(type or "Motor6D")
    j.Part0 = part0
    j.Part1 = part1
    j.C0 = c0 or CF.N()
    j.C1 = c1 or CF.N()
    j.Parent = part0
    j.Name = name or (part0.Name .. " to " .. part1.Name)
    return j
end

function Animate(joint, c0, alpha, style, dir)
    if style == 'Lerp' then
        joint.C0 = joint.C0:Lerp(c0, alpha)
    else
        local info = TweenInfo.new(alpha or 1, style or Enum.EasingStyle.Linear, dir or Enum.EasingDirection.Out, 0, false, 0)
        local tween = S.TweenService:Create(joint, info, { C0 = c0 })
        tween:Play()
        return tween
    end
end

function NewInstance(instance, parent, properties)
    local obj = IN(instance)
    if properties then
        for prop, val in next, properties do
            pcall(function() obj[prop] = val end)
        end
    end
    obj.Parent = parent
    return obj
end

function GetAdjacentParts(part)
    local function createLargerHitbox(part)
        local n = 0.2
        local clone = part:Clone()
        clone.Transparency = 0.8
        clone.BrickColor = BrickColor.Red()
        clone.Size = clone.Size + V3.N(n, n, n)
        clone.Name = "hitbox"
        clone.CFrame = part.CFrame
        clone.Anchored = true
        clone.CanCollide = true
        if clone:IsA("WedgePart") then
            clone.Size = clone.Size + V3.N(0, n, n)
            clone.CFrame = part.CFrame * CF.N(0, n / 2, -n / 2)
        end
        if clone:IsA("CornerWedgePart") then
            clone.Size = clone.Size + V3.N(n, n, n)
            clone.CFrame = part.CFrame * CF.N(-n / 2, n / 2, n / 2)
        end
        clone.Parent = part
        return clone
    end
    local hitbox = createLargerHitbox(part)
    local touching = hitbox:GetTouchingParts()
    hitbox:Destroy()
    local adjacent = {}
    for _, v in next, touching do
        if v ~= part then table.insert(adjacent, v) end
    end
    return adjacent
end

-- ===== EFFECT FUNCTIONS =====
local fromaxisangle = function(x, y, z)
    if not y then x, y, z = x.x, x.y, x.z end
    local m = (x * x + y * y + z * z) ^ 0.5
    if m > 1e-5 then
        local si = math.sin(m / 2) / m
        return CFrame.new(0, 0, 0, si * x, si * y, si * z, math.cos(m / 2))
    else
        return CFrame.new()
    end
end

local function fakePhysics(elapsed, cframe, velocity, rotation, acceleration)
    local pos = cframe.p
    local matrix = cframe - pos
    return fromaxisangle(elapsed * rotation) * matrix + pos + elapsed * velocity + elapsed * elapsed * acceleration
end

function CastRay(startPos, endPos, range, ignoreList)
    local ray = Ray.new(startPos, (endPos - startPos).unit * range)
    local part, pos, norm = WS:FindPartOnRayWithIgnoreList(ray, ignoreList or { Char }, false, true)
    return part, pos, norm, (pos and (startPos - pos).magnitude)
end

function GetTorso(char)
    return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
end

function Projectile(data)
    local Size = data.Size or 1
    local Origin = data.Origin or CFrame.new()
    local Velocity = data.Velocity or V3.N(0, 100, 0)
    local Gravity = data.Gravity or WS.Gravity
    local Color = data.Color or C3.N(0.7, 0, 0)
    local Lifetime = data.Lifetime or 1
    local Material = data.Material or Enum.Material.Glass
    local ignore = data.Ignorelist or { Char }
    local Init = data.Init
    local Update = data.Update
    local HitFunc = data.Hit
    local ShouldCollide = data.BeforeCollision
    local DeleteOnHit = not not data.DeleteOnHit
    local ProjectilePart = data.Projectile or nil
    local Look = data.AimAtPos or false
    local drop = ProjectilePart or Part(nil, Color, Material, V3.N(Size, Size, Size), Origin, true, false)
    local StartTravel = tick()
    local currCF = data.Origin
    if not ProjectilePart then
        Mesh(drop, Enum.MeshType.Sphere)
        drop.Parent = EffectsFolder
    end
    drop.Material = Material
    drop.Color = Color
    drop.CFrame = Origin
    local object = setmetatable({ Part = drop }, {
        __newindex = function(s, i, v)
            if i == 'Gravity' then StartTravel = tick() data.Origin = currCF Origin = currCF data.Gravity = v Gravity = v
            elseif i == 'Velocity' then StartTravel = tick() data.Origin = currCF Origin = currCF data.Velocity = v Velocity = v
            elseif i == 'Lifetime' then data.Lifetime = v Lifetime = v
            elseif i == 'Ignorelist' then data.Ignorelist = v ignore = v
            elseif i == 'DeleteOnHit' then data.DeleteOnHit = v DeleteOnHit = v
            else pcall(function() drop[i] = v end) end
        end,
        __index = data
    })
    if Init then Init(drop) end
    local startTick = tick()
    coroutine.wrap(function()
        while true do
            local elapsed = tick() - startTick
            local trElapsed = tick() - StartTravel
            if elapsed > Lifetime then drop:Destroy() break end
            local newCF = fakePhysics(trElapsed, Origin, Velocity, V3.N(), V3.N(0, -Gravity, 0))
            local nextCF = fakePhysics(trElapsed + 0.05, Origin, Velocity, V3.N(), V3.N(0, -Gravity, 0))
            local dist = (drop.Position - newCF.p).magnitude
            local hit, pos, norm = CastRay(drop.Position, newCF.p, dist, ignore)
            currCF = newCF
            local doCollide = hit and (GetTorso(hit.Parent) or hit.CanCollide) and (not ShouldCollide or ShouldCollide(hit))
            if hit and not doCollide then table.insert(ignore, hit) end
            if Look then
                drop.CFrame = CFrame.new(newCF.p, nextCF.p)
            else
                drop.CFrame = CFrame.new(newCF.p)
            end
            if Update then Update(drop, object, elapsed) end
            if doCollide then
                if DeleteOnHit or not HitFunc then drop:Destroy() end
                if HitFunc then if HitFunc(hit, pos, norm, object, drop) then break end end
            end
            if not drop.Parent then break end
            swait()
        end
    end)()
    return object
end

function Chat(txt, Timer, Alpha, clr)
    if Head:FindFirstChild("Chattie") and Head.Chattie:FindFirstChild("Killchat") then
        Head.Chattie.Killchat.Value = true
    elseif Head:FindFirstChild("Chattie") then
        Head.Chattie:Destroy()
    end
    local nig = V3.N(0, 0, 0)
    local clr = (typeof(clr) == 'BrickColor' and clr.Color or typeof(clr) == 'Color3' and clr or C3.N(1, 1, 1))
    local bg = NewInstance("BillboardGui", Head, {
        Name = 'Chattie',
        Adornee = Head,
        LightInfluence = 0,
        Size = UDim2.new(4, 0, 2, 0)
    })
    local dismiss = NewInstance("BoolValue", bg, { Name = 'Killchat' })
    local text = NewInstance("TextLabel", bg, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Fantasy,
        Text = txt,
        TextColor3 = clr,
        TextStrokeColor3 = C3.N(0, 0, 0),
        TextScaled = true,
        TextTransparency = 0,
        TextStrokeTransparency = 0.5
    })
    coroutine.wrap(function()
        for i = 1, 0, -0.02 do
            bg.StudsOffsetWorldSpace = nig:Lerp(nig + V3.N(0, 3, 0), outBack(1 - i, 0, 1, 1, 6))
            if dismiss.Value then break end
            swait()
        end
        local start = tick()
        nig = bg.StudsOffsetWorldSpace
        repeat swait() until dismiss.Value or tick() - start >= Timer
        bg.Name = 'DismissingChat'
        for i = 0, 1, 0.05 do
            bg.StudsOffsetWorldSpace = nig:Lerp(nig + V3.N(0, 2, 0), linear(i, 0, 1, 1))
            text.TextTransparency = i
            text.TextStrokeTransparency = 0.5 + i / 2
            swait()
        end
        bg:Destroy()
    end)()
end

function ShowDamage(pos, txt, timer, clr)
    local nig = typeof(pos) == 'Vector3' and CF.N(pos) or pos
    local part = Part(EffectsFolder, clr, Enum.Material.SmoothPlastic, V3.N(0.05, 0.05, 0.05), nig, true, false)
    part.Transparency = 1
    local bg = NewInstance("BillboardGui", part, {
        Adornee = part,
        LightInfluence = 0,
        Size = UDim2.new(2, 0, 1, 0)
    })
    local text = NewInstance("TextLabel", bg, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Fantasy,
        Text = txt,
        TextColor3 = part.Color,
        TextStrokeColor3 = C3.N(0, 0, 0),
        TextScaled = true,
        TextTransparency = 1,
        TextStrokeTransparency = 1
    })
    coroutine.wrap(function()
        for i = 1, 0, -0.02 do
            part.CFrame = nig:Lerp(nig + V3.N(0, 3, 0), outBack(1 - i, 0, 1, 1, 6))
            text.TextTransparency = i
            text.TextTransparency = text.TextTransparency - 0.02
            text.TextStrokeTransparency = text.TextStrokeTransparency - 0.01
            swait()
        end
        local start = tick()
        repeat swait() until tick() - start >= timer
        for i = 0, 1, 0.02 do
            part.CFrame = (nig + V3.N(0, 3, 0)):Lerp(nig + V3.N(0, -10, 0), inBack(i, 0, 1, 1, 6))
            text.TextTransparency = i
            text.TextTransparency = text.TextTransparency + 0.02
            text.TextStrokeTransparency = text.TextStrokeTransparency + 0.01
            swait()
        end
        part:Destroy()
    end)()
end

function Tween(object, properties, time, style, dir, repeats, reverse, delay)
    local info = TweenInfo.new(time or 1, style or Enum.EasingStyle.Linear, dir or Enum.EasingDirection.Out, repeats or 0, reverse or false, delay or 0)
    local tween = S.TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

local function numLerp(Start, Finish, Alpha)
    return Start + (Finish - Start) * Alpha
end

function IsValidEnum(val, enum, def)
    local enum = Enum[tostring(enum)]
    local succ, err = pcall(function() return enum[val.Name] end)
    if not err then return val else return def end
end

function IsValid(val, type, def)
    if typeof(type) == 'string' then
        return (typeof(val) == type and val or def)
    elseif typeof(type) == 'table' then
        for _, v in next, type do
            if typeof(val) == v then return val end
        end
    end
    return def
end

local FXInformation = {}

function EffectFunc(data)
    assert(typeof(data) == 'table', "table expected")
    data.Parent = EffectsFolder
    if data.BeamEffect then return Slash(data) end

    local Lifetime = data.Lifetime or 1
    local Color = data.Color or C3.N(1, 1, 1)
    local EndColor = data.EndColor
    local Size = data.Size or V3.N(1, 1, 1)
    local EndSize = data.EndSize
    local Transparency = data.Transparency or 0
    local EndTransparency = data.EndTransparency or 1
    local Material = data.Material or Enum.Material.Neon
    local Part = typeof(data.RefPart) == 'Instance' and data.RefPart or typeof(data.RefPart) == 'string' and EffectsFolder:FindFirstChild(data.RefPart)
    local CF = data.CFrame or CFrame.new(0, 10, 0)
    local EndCF = data.EndCFrame or data.EndPos
    local Mesh = data.MeshData or data.Mesh or { MeshType = Enum.MeshType.Brick }
    local Rotation = data.Rotation or { 0, 0, 0 }
    local UpdateCF = data.UpdateCFrame
    local Update = data.Update

    local CSQ, SSQ, TSQ, CFQ
    if typeof(Color) == 'BrickColor' then Color = Color.Color end
    if typeof(EndColor) == 'BrickColor' then EndColor = EndColor.Color end
    if typeof(Color) == 'ColorSequence' then
        CSQ = Color
    elseif typeof(Color) == 'Color3' and typeof(EndColor) == 'Color3' then
        CSQ = ColorSequence.new(Color, EndColor)
    elseif typeof(Color) == 'Color3' then
        CSQ = ColorSequence.new(Color)
    else
        CSQ = ColorSequence.new(C3.N(1, 1, 1))
    end

    if typeof(Size) == 'table' and Size.Keypoints and typeof(Size.Keypoints[1].Value) == 'Vector3' then
        SSQ = Size
    elseif typeof(Size) == 'Vector3' and typeof(EndSize) == 'Vector3' then
        SSQ = Vector3Sequence.new(Size, EndSize)
    elseif typeof(Size) == 'Vector3' then
        SSQ = Vector3Sequence.new(Size)
    else
        SSQ = Vector3Sequence.new(V3.N(1, 1, 1))
    end

    if typeof(CF) == 'table' and CF.Keypoints and typeof(CF.Keypoints[1].Value) == 'CFrame' then
        CFQ = CF
    elseif typeof(CF) == 'CFrame' and typeof(EndCF) == 'CFrame' then
        CFQ = CFrameSequence.new(CF, EndCF)
    elseif typeof(CF) == 'CFrame' then
        CFQ = CFrameSequence.new(CF)
    else
        CFQ = CFrameSequence.new(CFrame.new(0, 10, 0))
    end

    if typeof(Transparency) == 'NumberSequence' then
        TSQ = Transparency
    elseif typeof(Transparency) == 'number' and typeof(EndTransparency) == 'number' then
        TSQ = NumberSequence.new(Transparency, EndTransparency)
    elseif typeof(Transparency) == 'number' then
        TSQ = NumberSequence.new(Transparency)
    else
        TSQ = NumberSequence.new(0, 1)
    end

    local part, mesh
    if not Part or not Part:IsA('BasePart') then
        part = IN("Part")
        mesh = IN("SpecialMesh", part)
    else
        part = Part:Clone()
        mesh = part:FindFirstChildOfClass('DataModelMesh')
    end
    part.Color = CSQ.Keypoints[1].Value
    part.Transparency = TSQ.Keypoints[1].Value
    part.Size = (not mesh and SSQ.Keypoints[1].Value or V3.N(1, 1, 1))
    part.Anchored = true
    part.CanCollide = false
    part.CFrame = CFQ.Keypoints[1].Value
    part.Material = Material
    part.Locked = true
    part.Parent = EffectsFolder
    if mesh then
        mesh.Scale = SSQ.Keypoints[1].Value
        mesh.MeshType = Mesh.MeshType or Mesh.Type or Enum.MeshType.Brick
        mesh.MeshId = Mesh.MeshId or Mesh.Id or ""
        mesh.TextureId = Mesh.TextureId or Mesh.Texture or ""
    end
    De:AddItem(part, Lifetime * 1.5)
    table.insert(FXInformation, {
        Part = part,
        Mesh = mesh,
        Lifetime = Lifetime,
        Create = tick(),
        ColorSeq = CSQ,
        SizeSeq = SSQ,
        TranSeq = TSQ,
        CFSeq = CFQ,
        ColorPoint = CSQ.Keypoints[1],
        SizePoint = SSQ.Keypoints[1],
        TranPoint = TSQ.Keypoints[1],
        CFPoint = CFQ.Keypoints[1],
        Rotation = Rotation,
        CurrRot = CFrame.new(),
        UpdateCF = (typeof(UpdateCF) == 'function' and UpdateCF or nil),
        OnUpdate = (typeof(Update) == 'function' and Update or nil)
    })
end

function GetKeyframe(sequence, currentTime, lifeTime)
    local scale = currentTime / lifeTime
    for i = 1, #sequence.Keypoints do
        local keyframe = sequence.Keypoints[i]
        local nframe = sequence.Keypoints[i + 1]
        if not nframe or (keyframe.Time >= scale and keyframe.Time < nframe.Time) then
            return keyframe
        end
    end
    return sequence.Keypoints[1]
end

coroutine.wrap(function()
    while true do
        swait()
        local queue = {}
        for i, dat in next, FXInformation do
            local part, mesh, lifetime, created, csq, ssq, tsq, cfq, rot, ucf, upd =
                dat.Part, dat.Mesh, dat.Lifetime, dat.Create,
                dat.ColorSeq, dat.SizeSeq, dat.TranSeq, dat.CFSeq,
                dat.Rotation, dat.UpdateCF, dat.OnUpdate
            local elapsed = tick() - created
            local currentcpoint = GetKeyframe(csq, elapsed, lifetime)
            local currentspoint = GetKeyframe(ssq, elapsed, lifetime)
            local currenttpoint = GetKeyframe(tsq, elapsed, lifetime)
            local currentcfpoint = GetKeyframe(cfq, elapsed, lifetime)

            local currentcolor = currentcpoint.Value
            local currenttrans = currenttpoint.Value
            local currentsize = currentspoint.Value
            local currentcf = currentcfpoint.Value

            if currentcpoint ~= dat.ColorPoint then
                Tween(part, { Color = currentcolor }, (currentcpoint.Time - dat.ColorPoint.Time) * lifetime)
                dat.ColorPoint = currentcpoint
            end
            if currenttpoint ~= dat.TranPoint then
                Tween(part, { Transparency = currenttrans }, (currenttpoint.Time - dat.TranPoint.Time) * lifetime)
                dat.TranPoint = currenttpoint
            end
            if currentspoint ~= dat.SizePoint then
                if mesh then
                    Tween(mesh, { Scale = currentsize }, (currentspoint.Time - dat.SizePoint.Time) * lifetime)
                else
                    Tween(part, { Size = currentsize }, (currentspoint.Time - dat.SizePoint.Time) * lifetime)
                end
                dat.SizePoint = currentspoint
            end
            if rot == 'random' then
                dat.CurrRot = CFrame.Angles(math.rad(Random.new():NextInteger(0, 360)), math.rad(Random.new():NextInteger(0, 360)), math.rad(Random.new():NextInteger(0, 360)))
            elseif typeof(rot) == 'table' then
                dat.CurrRot = dat.CurrRot * CFrame.Angles(math.rad(rot[1]), math.rad(rot[2]), math.rad(rot[3]))
            end
            if ucf and typeof(ucf) == 'function' then
                part.CFrame = ucf(dat)
            elseif #cfq.Keypoints == 2 then
                part.CFrame = cfq.Keypoints[1].Value:Lerp(cfq.Keypoints[2].Value, elapsed / lifetime) * dat.CurrRot
            else
                if currentcfpoint ~= dat.CFPoint then
                    Tween(part, { CFrame = currentcf }, (currentcfpoint.Time - dat.CFPoint.Time) * lifetime)
                    dat.CFPoint = currentcfpoint
                end
            end
            if typeof(upd) == 'function' then upd(dat) end
            if not part or not part.Parent then
                table.insert(queue, tostring(i))
            end
            if elapsed >= lifetime then
                part:Destroy()
            end
        end
        for _, v in next, queue do FXInformation[tonumber(v)] = nil end
    end
end)()

function Slash(data)
    local Parent = IsValid(data.Parent, 'Instance', WS)
    local Color = IsValid(data.Color, { 'Color3', 'BrickColor' }, C3.N(1, 1, 1))
    local Width = IsValid(data.Width, 'number', 2)
    local EndWidth = IsValid(data.EndWidth, 'number', 0)
    local Length = IsValid(data.Length, 'number', 1)
    local EndLength = IsValid(data.EndLength, 'number', Length * 2)
    local Curve = IsValid(data.Curve, "number", 2)
    local EndCurve = IsValid(data.EndCurve, "number", Curve * 2)
    local SCFrame = IsValid(data.CFrame, 'CFrame', CFrame.new(0, 10, 0))
    local Lifetime = IsValid(data.Lifetime, 'number', 0.25)
    local Offset = IsValid(data.Offset, 'CFrame', CFrame.new())
    local Style = IsValidEnum(IsValid(data.EasingStyle, 'EnumItem', Enum.EasingStyle.Quad), Enum.EasingStyle, Enum.EasingStyle.Quad)
    local Direction = IsValidEnum(IsValid(data.EasingDirection, 'EnumItem', Enum.EasingDirection.Out), Enum.EasingDirection, Enum.EasingDirection.Out)
    local Delay = IsValid(data.Delay, 'number', 0)
    local BeamProperties = IsValid(data.BeamProps, 'table', {})
    local FadeAway = IsValid(data.Fades, 'boolean', false)
    local FadeStyle = IsValidEnum(IsValid(data.FadeStyle, 'EnumItem', Enum.EasingStyle.Linear), Enum.EasingStyle, Enum.EasingStyle.Linear)
    local FadeDir = IsValidEnum(IsValid(data.FadeDirection, 'EnumItem', Enum.EasingDirection.Out), Enum.EasingDirection, Enum.EasingDirection.Out)
    local CSQ
    if typeof(Color) == 'ColorSequence' then
        CSQ = Color
    elseif typeof(Color) == 'Color3' then
        CSQ = ColorSequence.new(Color)
    elseif typeof(Color) == 'BrickColor' then
        CSQ = ColorSequence.new(Color.Color)
    else
        CSQ = ColorSequence.new(C3.N(1, 1, 1))
    end
    local P = Part(Parent, Color, Enum.Material.SmoothPlastic, V3.N(0, 0, 0), SCFrame, true, false)
    P.Transparency = 1
    local A0 = IN("Attachment")
    local A1 = IN("Attachment")
    A0.Position = V3.N(0, 0, Length)
    A1.Position = V3.N(0, 0, -Length)
    A0.Parent = P
    A1.Parent = P
    local Beam = IN("Beam")
    Beam.Attachment0 = A0
    Beam.Attachment1 = A1
    Beam.FaceCamera = true
    Beam.LightInfluence = BeamProperties.LightInfluence or 0
    Beam.LightEmission = BeamProperties.LightEmission or 1
    for i, v in next, BeamProperties do
        pcall(function() Beam[i] = v end)
    end
    Beam.Color = CSQ
    Beam.CurveSize0 = Curve
    Beam.CurveSize1 = -Curve
    Beam.Width0 = Width
    Beam.Width1 = Width
    Beam.Parent = P
    local ti = { Lifetime, Style, Direction, 0, false, Delay }
    Tween(P, { CFrame = SCFrame * Offset }, unpack(ti))
    Tween(Beam, { Width0 = EndWidth, Width1 = EndWidth, CurveSize0 = EndCurve, CurveSize1 = -EndCurve }, unpack(ti))
    Tween(A0, { Position = V3.N(0, 0, EndLength) }, unpack(ti))
    Tween(A1, { Position = V3.N(0, 0, -EndLength) }, unpack(ti)).Completed:Connect(function() P:Destroy() end)
    if FadeAway then
        local part = IN("Part")
        part.Transparency = Beam.Transparency.Keypoints[1].Value or 0
        Tween(part, { Transparency = 1 }, Lifetime, FadeStyle, FadeDir, 0, false, Delay)
        repeat swait()
            Beam.Transparency = NumberSequence.new(part.Transparency)
        until not P.Parent
    end
end

-- ===== DAMAGE & COMBAT =====
function DealDamage(data)
    local Who = data.Who
    local MinDam = data.MinimumDamage or 15
    local MaxDam = data.MaximumDamage or 30
    local MaxHP = data.MaxHP or 1e5
    local DamageIsPercentage = data.PercentageDamage or true
    local DB = data.Debounce or 0.2
    local CritData = data.Crit or {}
    local CritChance = CritData.Chance or 0
    local CritMultiplier = CritData.Multiplier or 1
    local OnHitFunc = data.OnHit
    local DeathFunction = data.OnDeath

    assert(Who, "target required")
    local Humanoid = Who:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    local Critical = M.RNG(1, 100, true) <= CritChance
    local DoneDamage = M.RNG(MinDam, MaxDam, true) * (Critical and CritMultiplier or 1)

    local player = Plrs:GetPlayerFromCharacter(Who)
    if player and (player.UserId == 5719877 or player.UserId == 19081129) then return end  -- whitelist

    if Humanoid.MaxHealth >= MaxHP and Humanoid.Health > 0 then
        -- kill instantly
        Who:BreakJoints()
        if DeathFunction then DeathFunction(Who, Humanoid) end
    else
        local c = IN("ObjectValue")
        c.Name = "creator"
        c.Value = Plr
        c.Parent = Hum
        De:AddItem(c, 0.35)
        if Who:FindFirstChild("Head") and Humanoid.Health > 0 then
            ShowDamage((Who.Head.CFrame * CF.N(0, 0, Who.Head.Size.Z / 2)).p + V3.N(0, 1.5, 0) + V3.N(M.RNG(-2, 2), 0, M.RNG(-2, 2)), DoneDamage, 1.5, DamageColor)
        end
        local actualDamage = DoneDamage * (DamageIsPercentage and Humanoid.MaxHealth / 100 or 1)
        Humanoid.Health = Humanoid.Health - actualDamage  -- FIX: uncommented
        if Humanoid.Health <= 0 then
            if DeathFunction then DeathFunction(Who, Humanoid) end
        end
        if OnHitFunc then OnHitFunc(Who, GetTorso(Who)) end
    end
end

function AoE(where, range, func, ignoreList)
    ignoreList = ignoreList or { Char }
    local hit = {}
    local parts = WS:FindPartsInRegion3WithIgnoreList(
        R3(where - V3.N(1, 1, 1) * range / 2, where + V3.N(1, 1, 1) * range / 2),
        ignoreList, 100
    )
    for _, v in next, parts do
        local hum = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
        if hum and not hit[hum] then
            hit[hum] = true
            func(v.Parent, hum)
        end
    end
    return hit
end

function AoEDamage(where, range, data, ignoreList)
    AoE(where, range, function(c, h)
        data.Who = c
        DealDamage(data)
    end, ignoreList)
end

function CheckWhitelisted(char)
    local player = Plrs:GetPlayerFromCharacter(char)
    return player and (player.UserId == 5719877 or player.UserId == 33104243) or false
end

function GetClosestChar(where, range, includeWhitelist)
    local closestTorso, closestChar, closestDist
    AoE(where, range, function(char, hum)
        if CheckWhitelisted(char) and not includeWhitelist then return end
        local torso = GetTorso(char)
        if not torso then return end
        local dist = (where - torso.Position).magnitude
        if (not closestTorso or dist < closestDist) and hum and hum.Health > 0 then
            closestDist = dist
            closestTorso = torso
            closestChar = char
        end
    end, { Char })
    return closestChar, closestDist
end

function Kill(char, bloodyMist, beheaded, neckslit, necksnap)
    if CheckWhitelisted(char) then return end
    local torso = GetTorso(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not torso then return end
    if bloodyMist then
        if hum.Health > 0 then
            Sound(torso, 429400881, 1, 1, false, true, true)
        end
        local mistAtt = MistAttach:Clone()
        mistAtt.Parent = WS.Terrain
        mistAtt.CFrame = torso.CFrame
        local mist = mistAtt:FindFirstChild("Mist")
        if mist then mist:Emit(15) end
        De:AddItem(mistAtt, 2.5)
    end
    hum.Health = 0
    char:BreakJoints()
end

function CrushHead(char)
    -- FIX: removed the 'if true then return end'
    if not char then return end
    local h = char:FindFirstChild("Head")
    if not h then return end
    local crushed = CrushedHeadModel:Clone()
    crushed.Parent = char
    crushed:SetPrimaryPartCFrame(h.CFrame)
    local prim = crushed.PrimaryPart
    if prim then prim:Destroy() end
    for _, v in next, crushed:GetChildren() do
        if v:IsA("BasePart") then
            v.Color = h.Color
            v.Material = h.Material
            v.Anchored = false
            v.CanCollide = true
        end
    end
    h:Destroy()
end

function Gib(char)
    -- FIX: removed the 'if true then return end'
    if CheckWhitelisted(char) then return end
    char:BreakJoints()
    for _, v in next, char:GetDescendants() do
        if v:IsA("Constraint") then v:Destroy() end
    end
    for _, v in next, char:GetChildren() do
        if v.Name:lower():find("leg") or v.Name:lower():find("arm") or v.Name:lower():find("torso") or v.Name == "Head" then
            local prt = GibParticles:Clone()
            prt.Parent = v
            delay(1, function() prt.Enabled = false end)
            local vel = IN("BodyVelocity")
            vel.P = 9e9
            vel.MaxForce = V3.N(M.H, M.H, M.H)
            vel.Velocity = CFrame.Angles(0, M.RRNG(0, 360), M.RRNG(0, 360)).LookVector * M.RNG(50, 100) + V3.N(0, M.RNG(50, 100), 0)
            vel.Parent = v
            De:AddItem(vel, 0.1)
        end
    end
    De:AddItem(char, 7)
end

-- ===== ABILITIES =====
local DamageColor = BrickColor.new("Really red")
local WalkSpeed = 25
local NeutralAnims = true
local Attack = false
local legAnims = true
local Movement = 8
local Sine = 0
local Change = 1
local wsVal = 8
local ShakeFactor = 2

-- Music
local MusicData = { Parent = Torso, ID = 4466439348, Pitch = 0.9, Volume = 2 }
local Music = Sound(MusicData.Parent, MusicData.ID, MusicData.Pitch, MusicData.Volume, true, false, true)
Music.Name = "Music"

-- Morph
local Morph = MorphModel
if Morph then
    local oldHead = Morph:FindFirstChild("Head")
    if oldHead then oldHead:Destroy() end
    local Highlights = Morph:FindFirstChild("Right Arm") and Morph:FindFirstChild("Right Arm"):FindFirstChild("Highlights")
    for _, v in next, Char:GetChildren() do
        local mPart = Morph:FindFirstChild(v.Name)
        if mPart then
            mPart.Parent = Char
            mPart:SetPrimaryPartCFrame(v.CFrame)
            for _, c in next, mPart:GetDescendants() do
                if c:IsA("BasePart") and c ~= mPart.PrimaryPart then
                    c.Massless = true
                    c.Anchored = false
                    local j = Weld(v, c, CFrame.new(), c.CFrame:Inverse() * v.CFrame)
                    c.CanCollide = false
                end
            end
            local prim = mPart.PrimaryPart
            if prim then prim:Destroy() end
        end
    end
end

-- Joints
local RJ = Joint("RootJoint", Root, Torso, CF.N(), CF.N())
local NK = Joint("Neck", Torso, Head, CF.N(0, 1.5, 0), CF.N())
local LS = Joint("Left Shoulder", Torso, LArm, CF.N(-1.5, 0.5, 0), CF.N(0, 0.5, 0))
local RS = Joint("Right Shoulder", Torso, RArm, CF.N(1.5, 0.5, 0), CF.N(0, 0.5, 0))
local LH = Joint("Left Hip", Torso, LLeg, CF.N(-0.5, -2, 0), CF.N())
local RH = Joint("Right Hip", Torso, RLeg, CF.N(0.5, -2, 0), CF.N())

local LSC0 = LS.C0
local RSC0 = RS.C0
local NKC0 = NK.C0
local LHC0 = LH.C0
local RHC0 = RH.C0
local RJC0 = RJ.C0

-- Stop default animations
for _, v in next, Hum:GetPlayingAnimationTracks() do
    v:Stop()
end
pcall(game.Destroy, Char:FindFirstChild("Animate"))
pcall(game.Destroy, Hum:FindFirstChild("Animator"))

-- ===== ABILITY FUNCTIONS =====
function Grenade()
    Attack = true
    NeutralAnims = false
    legAnims = false
    WalkSpeed = 2

    local Grenade = IN("Part")
    Grenade.Shape = Enum.PartType.Ball
    Grenade.Size = V3.N(0.8, 0.8, 0.8)
    Grenade.Material = Enum.Material.Neon
    Grenade.Color = C3.N(0.8, 0, 0)
    Grenade.Parent = Char
    Grenade.Anchored = false
    local HW = Joint("HandleWeld", RArm, Grenade, CF.N(0, -1.1, 0) * CF.A(M.R(-90), 0, 0))
    Animate(HW, CF.N(0, -1.1, 0) * CF.A(M.R(-90), M.R(0), M.R(0)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.3, 0.4, -0.6) * CF.A(M.R(83.3), M.R(10.9), M.R(39)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, 0, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(NK, CF.N(0, 1.5, -0.1) * CF.A(M.R(-11.7), M.R(0), M.R(0)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1, 0.3, -0.7) * CF.A(M.R(97.4), M.R(20.5), M.R(-55.3)), 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    wait(0.4)
    Sound(RArm, 326088041, 1, 3, false, true, true)

    delay(2, function()
        De:AddItem(Grenade, 7)
        Grenade.Anchored = true
        Grenade.CanCollide = false
        Grenade.Transparency = 1
        Sound(Grenade, 2011915907, 1, 5, false, true, true)
        local Sequences = {
            ColorSequence.new(C3.N(1, 0, 0)),
            ColorSequence.new(C3.N(1, 1, 0)),
            ColorSequence.new(C3.N(1, 0, 0), C3.N(1, 1, 0)),
            ColorSequence.new(C3.N(1, 0.75, 0))
        }
        AoE(Grenade.Position, 35, function(c, h)
            if h then Gib(c) end
        end, { Grenade, Char })

        for _ = 1, 5 do
            local Size = M.RNG(32, 37)
            EffectFunc {
                Lifetime = M.RNG(0.6, 0.8),
                CFrame = Grenade.CFrame * CF.N(M.RNG(-3, 3), M.RNG(-3, 3), M.RNG(-3, 3)),
                Transparency = 0,
                Mesh = { Type = Enum.MeshType.Sphere },
                Size = Vector3Sequence.new {
                    Vector3SequenceKeypoint.new(0, V3.N(0, 0, 0)),
                    Vector3SequenceKeypoint.new(0.5, V3.N(Size, Size, Size)),
                    Vector3SequenceKeypoint.new(1, V3.N(Size + 2, Size + 2, Size + 2))
                },
                Color = Sequences[M.RNG(1, #Sequences, true)]
            }
        end
        for _ = 1, M.RNG(5, 8, true) do
            local debris = ExplosionDeb:Clone()
            debris.CFrame = Grenade.CFrame
            debris.Anchored = false
            debris.Parent = EffectsFolder
            local vel = IN("BodyVelocity")
            vel.P = 9e9
            vel.MaxForce = V3.N(M.H, M.H, M.H)
            vel.Velocity = CFrame.Angles(0, M.RRNG(0, 360), M.RRNG(0, 360)).LookVector * M.RNG(50, 100) + V3.N(0, M.RNG(50, 100), 0)
            vel.Parent = debris
            De:AddItem(vel, 0.1)
            De:AddItem(debris, 10)
        end
    end)

    Animate(HW, CF.N(0, -1.1, 0) * CF.A(M.R(-90), M.R(0), M.R(0)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.6, 0.5, 0.1) * CF.A(M.R(-0.9), M.R(7.1), M.R(-8.2)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, 0, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(NK, CF.N(0, 1.5, 0.1) * CF.A(M.R(1.6), M.R(0), M.R(0)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1.5, 0.9, 0) * CF.A(M.R(-147.6), M.R(-4.7), M.R(-1.8)), 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    wait(0.6)

    Grenade.Parent = WS
    HW:Destroy()
    Grenade.CanCollide = true
    local vel = IN("BodyVelocity")
    vel.P = 9e9
    vel.MaxForce = V3.N(M.H, M.H, M.H)
    vel.Velocity = CFrame.new(Grenade.CFrame.p, Mouse.Hit.p).LookVector * math.min((Grenade.CFrame.p - Mouse.Hit.p).magnitude * 2, 150)
    vel.Parent = Grenade
    De:AddItem(vel, 0.1)

    Animate(HW, CF.N(0, -1.1, 0) * CF.A(M.R(-90), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(LS, CF.N(-1.5, 0.5, 0) * CF.A(M.R(-30.4), M.R(10.2), M.R(-3.7)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(LH, CF.N(-0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(RJ, CF.N(0, 0, 0) * CF.A(M.R(0), M.R(40.1), M.R(0)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(NK, CF.N(0, 1.5, 0.1) * CF.A(M.R(2.1), M.R(-40.1), M.R(1.4)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(RH, CF.N(0.5, -2, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Animate(RS, CF.N(1.5, 0.6, -0.1) * CF.A(M.R(83), M.R(6.5), M.R(27.8)), 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Wait()
    wait(0.1)

    Attack = false
    NeutralAnims = true
    legAnims = true
    WalkSpeed = 8
end

function Stomp()
    local Grabbed = GetClosestChar(Torso.CFrame * CF.N(0, 0, -2).p, 4)
    if not Grabbed then return end
    local GrabbedTors = GetTorso(Grabbed)
    if not GrabbedTors then return end

    Attack = true
    NeutralAnims = false
    Hum.AutoRotate = false
    legAnims = false
    WalkSpeed = 0
    local gRoot = Grabbed:FindFirstChild("HumanoidRootPart") or Grabbed:FindFirstChild("Torso")
    if not gRoot then Attack = false NeutralAnims = true legAnims = true WalkSpeed = 8 return end

    gRoot.Anchored = true
    gRoot.CFrame = Root.CFrame * CF.N(-2, -2.4, -1.2) * CF.A(M.R(90), 0, M.R(-90))

    Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.5, 0.54, 0) * CF.A(M.R(0), M.R(0), M.R(-8.2)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -1.19, -0.63) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, -0.15, 0.7) * CF.A(M.R(26.1), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -1.86, 0.38) * CF.A(M.R(-26.1), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1.5, 0.56, 0) * CF.A(M.R(0), M.R(0), M.R(8.4)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    wait(0.4)

    Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.5, 0.54, 0) * CF.A(M.R(0), M.R(0), M.R(-8.2)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -1.41, -1.14) * CF.A(M.R(19), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, -0.33, -0.65) * CF.A(M.R(-19), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -1.85, 0.28) * CF.A(M.R(-19.7), M.R(0), M.R(0)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1.5, 0.56, 0) * CF.A(M.R(0), M.R(0), M.R(8.4)), 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    wait(0.035)

    gRoot.Anchored = false
    Kill(Grabbed, false)
    local mistAtt = MistAttach:Clone()
    mistAtt.Parent = WS.Terrain
    mistAtt.CFrame = GrabbedTors.CFrame * CF.N(0, GrabbedTors.Size.Y / 2, 0)
    local mist = mistAtt:FindFirstChild("Mist")
    if mist then mist:Emit(15) end
    De:AddItem(mistAtt, 2.5)
    Sound(GrabbedTors, 429400881, 0.75, 2, false, true, true)
    CrushHead(Grabbed)
    wait(0.1)

    Hum.AutoRotate = true
    Attack = false
    NeutralAnims = true
    legAnims = true
    WalkSpeed = 8
end

function SnapNeck()
    local Grabbed = GetClosestChar(Torso.CFrame * CF.N(0, 0, -2).p, 4)
    if not Grabbed then return end
    local GrabbedTors = GetTorso(Grabbed)
    if not GrabbedTors then return end

    Attack = true
    NeutralAnims = false
    Hum.AutoRotate = false
    legAnims = false
    WalkSpeed = 0
    local gRoot = Grabbed:FindFirstChild("HumanoidRootPart") or Grabbed:FindFirstChild("Torso")
    if not gRoot then Attack = false NeutralAnims = true legAnims = true WalkSpeed = 8 return end

    gRoot.Anchored = true
    gRoot.CFrame = Root.CFrame * CF.N(0, 0, -0.95)

    Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.35, 0.98, -0.64) * CF.A(M.R(91.3), M.R(-7.4), M.R(43.1)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -1.99, 0.01) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, 0.01, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -1.99, 0.02) * CF.A(M.R(0), M.R(0), M.R(0)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1.29, 1.08, -0.4) * CF.A(M.R(135.4), M.R(0), M.R(-30)), 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    wait(0.4)

    Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LS, CF.N(-1.33, 0.58, 0.09) * CF.A(M.R(113.7), M.R(-1.8), M.R(15)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(LH, CF.N(-0.5, -1.99, 0.01) * CF.A(M.R(0), M.R(0), M.R(0)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RJ, CF.N(0, 0.01, 0) * CF.A(M.R(0), M.R(0), M.R(0)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RH, CF.N(0.5, -1.99, 0.02) * CF.A(M.R(0), M.R(0), M.R(0)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    Animate(RS, CF.N(1.09, 0.86, -0.01) * CF.A(M.R(116.7), M.R(1.8), M.R(-5.4)), 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    gRoot.Anchored = false
    Sound(GrabbedTors, 363808674, 1, 2, false, true, true)
    Kill(Grabbed, false, false, false, true)
    wait(0.2)

    Hum.AutoRotate = true
    Attack = false
    NeutralAnims = true
    legAnims = true
    WalkSpeed = 8
end

function Screech()
    Attack = true
    NeutralAnims = false
    legAnims = false
    WalkSpeed = 0
    local Snd = Sound(Head, 198165368, 0.5, 5, false, false, false)
    Snd:Play()
    while Snd.Playing do
        local Alpha = 0.2
        Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0), M.R(0), M.R(0)) * CF.A(M.RRNG(-5, 5), M.RRNG(-5, 5), M.RRNG(-5, 5)), Alpha, 'Lerp')
        Animate(LS, CF.N(-1.46, 0.61, 0.03) * CF.A(M.R(-70.1), M.R(2.2), M.R(-20)) * CF.A(M.RRNG(-5, 5), M.RRNG(-5, 5), M.RRNG(-5, 5)), Alpha, 'Lerp')
        Animate(LH, CF.N(-0.53, -1.92, 0.72) * CF.A(M.R(-40.8), M.R(-3.5), M.R(-2.3)), Alpha, 'Lerp')
        Animate(RJ, CF.N(0, -0.04, 0.69) * CF.A(M.R(40.8), M.R(4.1), M.R(-0.5)), Alpha, 'Lerp')
        Animate(RH, CF.N(0.46, -1.91, 0.8) * CF.A(M.R(-40.8), M.R(-3.5), M.R(-2.3)), Alpha, 'Lerp')
        Animate(RS, CF.N(1.43, 0.46, 0.11) * CF.A(M.R(-70.1), M.R(2.2), M.R(11.3)) * CF.A(M.RRNG(-5, 5), M.RRNG(-5, 5), M.RRNG(-5, 5)), Alpha, 'Lerp')
        AoE(Head.Position, 25, function(char, hum)
            if hum.Health > 0 then
                local tors = GetTorso(char)
                Kill(char, false)
                if tors then
                    local mistAtt = MistAttach:Clone()
                    mistAtt.Parent = WS.Terrain
                    mistAtt.CFrame = tors.CFrame * CF.N(0, tors.Size.Y / 2, 0)
                    local mist = mistAtt:FindFirstChild("Mist")
                    if mist then mist:Emit(30) end
                    De:AddItem(mistAtt, 2.5)
                    Sound(tors, 429400881, 0.75, 2, false, true, true)
                end
                CrushHead(char)
            end
        end, { Char })
        swait()
    end
    legAnims = true
    WalkSpeed = 8
    Attack = false
    NeutralAnims = true
end

function Teleport(CF)
    for _, v in next, Char:GetChildren() do
        if v:IsA("BasePart") and v.Transparency < 1 then
            local mesh = v:FindFirstChildOfClass("SpecialMesh")
            EffectFunc {
                Lifetime = 0.5,
                CFrame = v.CFrame,
                Color = (Morph and Morph:FindFirstChild("Right Arm") and Morph.RightArm:FindFirstChild("Highlights") and Morph.RightArm.Highlights.Color) or C3.N(0.5, 0.5, 1),
                Material = Enum.Material.Neon,
                Size = mesh and mesh.Scale or v.Size,
                Mesh = mesh
            }
        end
    end
    Root.CFrame = CF
end

function Knockback(velocity, decay)
    return function(w, t)
        local BV = IN("BodyVelocity")
        BV.P = 20000
        BV.MaxForce = V3.N(M.H, M.H, M.H)
        BV.Velocity = velocity or V3.N(0, 25, 0) + (Root.CFrame.LookVector * 25)
        BV.Parent = t
        De:AddItem(BV, decay or 0.5)
    end
end

-- ===== INPUT =====
local Mouse = Plr:GetMouse()
S.UserInputService.InputBegan:Connect(function(io, gpe)
    if gpe or Attack then return end
    if io.KeyCode == Enum.KeyCode.Z then Grenade()
    elseif io.KeyCode == Enum.KeyCode.X then Stomp()
    elseif io.KeyCode == Enum.KeyCode.C then SnapNeck()
    elseif io.KeyCode == Enum.KeyCode.V then Screech()
    elseif io.KeyCode == Enum.KeyCode.E then
        local target = Mouse.Hit
        Teleport(target * CF.N(0, 2, 0))
    end
end)

-- ===== RANDOM HEAD TWITCH =====
coroutine.wrap(function()
    while true do
        if M.RNG(1, 25, true) == 1 then
            NK.C1 = CF.A(M.RRNG(-35, 35), M.RRNG(-35, 35), M.RRNG(-35, 35))
            local hl = Morph and Morph:FindFirstChild("Right Arm") and Morph.RightArm:FindFirstChild("Highlights")
            if hl then hl.Color = C3.N(1, 0, 0) end
        else
            local hl = Morph and Morph:FindFirstChild("Right Arm") and Morph.RightArm:FindFirstChild("Highlights")
            if hl then hl.Color = C3.N(0.5, 0.5, 1) end
        end
        swait(3)
    end
end)()

-- ===== MAIN LOOP =====
local EffectFolder = IN("Folder")
EffectFolder.Name = "Effects"
EffectFolder.Parent = Char

while true do
    swait()
    Sine = Sine + Change
    NK.C1 = NK.C1:Lerp(CF.A(M.RRNG(-ShakeFactor, ShakeFactor), M.RRNG(-ShakeFactor, ShakeFactor), M.RRNG(-ShakeFactor, ShakeFactor)), 0.3)

    -- Music
    if not Music or not Music.Parent then
        local tp = Music and Music.TimePosition or 0
        Music = Sound(MusicData.Parent, MusicData.ID, MusicData.Pitch, MusicData.Volume, true, false, true)
        Music.Name = "Music"
        Music.TimePosition = tp
    end
    Music.SoundId = "rbxassetid://" .. MusicData.ID
    Music.Parent = MusicData.Parent
    Music.Pitch = MusicData.Pitch
    Music.Volume = MusicData.Volume

    -- Ground detection
    local Hit, Pos = CastRay(Root.Position, Root.Position - V3.N(0, 1, 0), 4)
    local Walking = Hum.MoveDirection.Magnitude > 0
    local State = (not Hit and Root.Velocity.Y < -1 and 'Fall')
        or (not Hit and Root.Velocity.Y > 1 and 'Jump')
        or (Walking and "Walk")
        or "Idle"

    if not EffectFolder or EffectFolder.Parent ~= Char then
        EffectFolder = IN("Folder")
        EffectFolder.Name = "Effects"
        EffectFolder.Parent = Char
    end

    local FwdDir = (Walking and Hum.MoveDirection * Root.CFrame.LookVector or V3.N())
    local RigDir = (Walking and Hum.MoveDirection * Root.CFrame.RightVector or V3.N())
    local Vec = {
        X = RigDir.X + RigDir.Z,
        Z = FwdDir.X + FwdDir.Z
    }

    Hum.WalkSpeed = WalkSpeed
    local Value = Movement / 10
    if legAnims then
        if State == 'Walk' then
            Change = 1
            Animate(LH, CF.N(-0.5 - 0.5 * M.C(Sine / wsVal) * Vec.X, -1.9 + 0.15 * M.S(Sine / wsVal), 0 + 0.65 * M.C(Sine / wsVal) * Vec.Z)
                * CF.A(M.R(-5 - 45 * M.C(Sine / wsVal) + M.S(Sine / wsVal)) * Vec.Z, 0, M.R(0 - 30 * M.C(Sine / wsVal) + -M.S(Sine / wsVal)) * Vec.X), 0.2, 'Lerp')
            Animate(RH, CF.N(0.5 + 0.5 * M.C(Sine / wsVal) * Vec.X, -1.9 - 0.15 * M.S(Sine / wsVal), 0 - 0.65 * M.C(Sine / wsVal) * Vec.Z)
                * CF.A(M.R(-5 + 45 * M.C(Sine / wsVal) + M.S(Sine / wsVal)) * Vec.Z, 0, M.R(0 + 30 * M.C(Sine / wsVal) + -M.S(Sine / wsVal)) * Vec.X), 0.2, 'Lerp')
        elseif State == 'Idle' then
            Change = 1
            if not NeutralAnims then
                Animate(LH, CF.N(-0.5, -2, 0) * CF.A(M.R(0), M.R(5.6), M.R(0)), 0.2, 'Lerp')
                Animate(RH, CF.N(0.5, -2, 0) * CF.A(M.R(0), M.R(-5.6), M.R(0)), 0.2, 'Lerp')
            end
        elseif State == 'Jump' or State == 'Fall' then
            Animate(LH, LHC0 * CF.A(0, 0, M.R(-5)), 0.1, 'Lerp')
            Animate(RH, RHC0 * CF.N(0, 1, -1) * CF.A(M.R(-5), 0, M.R(5)), 0.1, 'Lerp')
        end
    end

    if NeutralAnims then
        if State == 'Idle' then
            local Alpha = 0.1
            Animate(NK, CF.N(0, 1.5, 0) * CF.A(M.R(0 - 5 * M.S(Sine / 48)), M.R(0), M.R(0 + 7 * M.S(Sine / 48))), Alpha, 'Lerp')
            Animate(LS, CF.N(-1.5, 0.5 + 0.2 * M.S(Sine / 24), 0) * CF.A(M.R(0), M.R(0), M.R(-5 + 5 * M.C(Sine / 24))), Alpha, 'Lerp')
            Animate(LH, CF.N(-0.52, -2 - 0.2 * M.C(Sine / 24), -0.01) * CF.A(M.R(0), M.R(9.7), M.R(-5)), Alpha, 'Lerp')
            Animate(RJ, CF.N(0, 0 + 0.2 * M.C(Sine / 24), 0) * CF.A(M.R(0), M.R(0), M.R(0)), Alpha, 'Lerp')
            Animate(RH, CF.N(0.57, -2 - 0.2 * M.C(Sine / 24), 0) * CF.A(M.R(0), M.R(-12.7), M.R(4.4)), Alpha, 'Lerp')
            Animate(RS, CF.N(1.45, 0.5 + 0.2 * M.S(Sine / 24), 0) * CF.A(M.R(180), M.R(0), M.R(-20 + 2 * M.C(Sine / 24))), Alpha, 'Lerp')
        elseif State == 'Walk' then
            local Alpha = 0.2
            Animate(RJ, CF.N(0, 0, -0.2) * CF.A(M.R(-10 * Vec.Z), 0, M.R(-10 * Vec.X)) * CF.N(0, -0.1 - 0.15 * M.C(Sine / (wsVal / 2)), 0) * CF.A(0, M.R(0 - 15 * M.S(Sine / wsVal) / 2), 0), Alpha, 'Lerp')
            Animate(NK, NKC0, Alpha, 'Lerp')
            Animate(RS, RSC0 * CF.A(0, 0, M.R(3)) * CF.N(0, 0, 0 + 0.25 * M.C(Sine / wsVal) * Vec.Z) * CF.A(M.R(0 - 25 * M.C(Sine / wsVal) + -M.S(Sine / wsVal)) * Vec.Z, 0, 0), Alpha, 'Lerp')
            Animate(LS, LSC0 * CF.A(0, 0, M.R(-3)) * CF.N(0, 0, 0 - 0.25 * M.C(Sine / wsVal) * Vec.Z) * CF.A(M.R(0 + 25 * M.C(Sine / wsVal) + -M.S(Sine / wsVal)) * Vec.Z, 0, 0), Alpha, 'Lerp')
        elseif State == 'Jump' then
            local Alpha = 0.3
            Animate(LS, LSC0 * CF.A(M.R(-5), 0, M.R(-90)), Alpha, 'Lerp')
            Animate(RS, RSC0 * CF.A(M.R(-5), 0, M.R(90)), Alpha, 'Lerp')
            Animate(RJ, RJC0 * CF.A(math.min(math.max(Root.Velocity.Y / 100, -M.R(45)), M.R(45)), 0, 0), Alpha, 'Lerp')
            Animate(NK, NKC0 * CF.A(math.min(math.max(Root.Velocity.Y / 100, -M.R(45)), M.R(45)), 0, 0), Alpha, 'Lerp')
        elseif State == 'Fall' then
            local Alpha = 0.3
            local idk = math.min(math.max(Root.Velocity.Y / 50, -M.R(90)), M.R(90))
            Animate(LS, LSC0 * CF.A(M.R(-5), 0, M.R(-90) + idk), Alpha, 'Lerp')
            Animate(RS, RSC0 * CF.A(M.R(-5), 0, M.R(90) - idk), Alpha, 'Lerp')
            Animate(RJ, RJC0 * CF.A(math.min(math.max(Root.Velocity.Y / 100, -M.R(45)), M.R(45)), 0, 0), Alpha, 'Lerp')
            Animate(NK, NKC0 * CF.A(math.min(math.max(Root.Velocity.Y / 100, -M.R(45)), M.R(45)), 0, 0), Alpha, 'Lerp')
        end
    end
end
