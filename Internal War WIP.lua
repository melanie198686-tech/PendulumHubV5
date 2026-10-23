-- ============================================================
-- "God" script — fixed for modern Roblox (R6 only)
-- Original by makhail07 / FE conversion by Mizt
-- ============================================================

-- ---------- SHIM ----------
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Debris     = game:GetService("Debris")

if not Align_Hat    then Align_Hat    = function() return nil end end
if not Destroy_Mesh then Destroy_Mesh = function() end          end

_G.wait  = task.wait
_G.spawn = task.spawn
_G.delay = task.delay

local _Player = Players.LocalPlayer
local _Char   = _Player.Character or _Player.CharacterAdded:Wait()
if not _Char:FindFirstChild("Torso") then
    warn("[God] R6 character required."); return
end

-- ---------- CORE SETUP ----------
Player       = Players.LocalPlayer
PlayerGui    = Player.PlayerGui
Cam          = workspace.CurrentCamera
Backpack     = Player.Backpack
Character    = Player.Character
Humanoid     = Character:WaitForChild("Humanoid")
Mouse        = Player:GetMouse()
RootPart     = Character:WaitForChild("HumanoidRootPart")
Torso        = Character:WaitForChild("Torso")
Head         = Character:WaitForChild("Head")
RightArm     = Character:WaitForChild("Right Arm")
LeftArm      = Character:WaitForChild("Left Arm")
RightLeg     = Character:WaitForChild("Right Leg")
LeftLeg      = Character:WaitForChild("Left Leg")
RootJoint    = RootPart:WaitForChild("RootJoint")
Neck         = Torso:WaitForChild("Neck")
RightShoulder = Torso:WaitForChild("Right Shoulder")
LeftShoulder  = Torso:WaitForChild("Left Shoulder")
RightHip     = Torso:WaitForChild("Right Hip")
LeftHip      = Torso:WaitForChild("Left Hip")

local sick = Instance.new("Sound", Character)

IT     = Instance.new
CF     = CFrame.new
VT     = Vector3.new
RAD    = math.rad
C3     = Color3.new
UD2    = UDim2.new
BRICKC = BrickColor.new
ANGLES = CFrame.Angles
EULER  = CFrame.fromEulerAnglesXYZ
COS    = math.cos
ACOS   = math.acos
SIN    = math.sin
ASIN   = math.asin
ABS    = math.abs
MRANDOM = math.random
FLOOR  = math.floor

Animation_Speed = 3
Frame_Speed = 0.016666666666666666
local Speed = 16

local ROOTC0 = CF(0, 0, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local NECKC0 = CF(0, 1, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local RIGHTSHOULDERC0 = CF(-0.5, 0, 0) * ANGLES(RAD(0), RAD(90), RAD(0))
local LEFTSHOULDERC0  = CF(0.5, 0, 0)  * ANGLES(RAD(0), RAD(-90), RAD(0))

local DAMAGEMULTIPLIER = 1

local ANIM     = "Idle"
local ATTACK   = false
local EQUIPPED = false
local HOLD     = false
local COMBO    = 1
local Rooted   = false
local SINE     = 0
local KEYHOLD  = false
local CHANGE   = 2 / Animation_Speed
local WALKINGANIM = false
local VALUE1   = false
local VALUE2   = false

local ROBLOXIDLEANIMATION = IT("Animation")
ROBLOXIDLEANIMATION.Name = "Roblox Idle Animation"
ROBLOXIDLEANIMATION.AnimationId = "http://www.roblox.com/asset/?id=180435571"

local WEAPONGUI = IT("ScreenGui", PlayerGui)
WEAPONGUI.Name = "Weapon GUI"

Character.Archivable = true
local SHADOW = Character:Clone()
SHADOW.Parent = nil

RootPart2  = SHADOW:WaitForChild("HumanoidRootPart")
Torso2     = SHADOW:WaitForChild("Torso")
Head2      = SHADOW:WaitForChild("Head")
RightArm2  = SHADOW:WaitForChild("Right Arm")
LeftArm2   = SHADOW:WaitForChild("Left Arm")
RightLeg2  = SHADOW:WaitForChild("Right Leg")
LeftLeg2   = SHADOW:WaitForChild("Left Leg")

pcall(Align_Hat, "Cyber Peacock Tail 2.0", Torso2, 0,0,0,90,0,0)
pcall(Destroy_Mesh, "Cyber Peacock Tail 2.0")
pcall(Align_Hat, "PaperBagRanger", Head2, 0,0,0,0,0,0)
pcall(Destroy_Mesh, "PaperBagRanger")
pcall(Align_Hat, "gradcap_18", RightArm2, 0,0,0,0,0,0)
pcall(Destroy_Mesh, "gradcap_18")
pcall(Align_Hat, "DreamCap", LeftArm2, 0,0,0,0,0,0)
pcall(Destroy_Mesh, "DreamCap")
pcall(Align_Hat, "Scarlett", RightLeg2, 0,0,0,0,0,0)
pcall(Destroy_Mesh, "Scarlett")
pcall(Align_Hat, "PanicCap", LeftLeg2, 0,0,0,0,0,0)
pcall(Destroy_Mesh, "PanicCap")

RootJoint2      = RootPart2:WaitForChild("RootJoint")
Neck2           = Torso2:WaitForChild("Neck")
RightShoulder2  = Torso2:WaitForChild("Right Shoulder")
LeftShoulder2   = Torso2:WaitForChild("Left Shoulder")
RightHip2       = Torso2:WaitForChild("Right Hip")
LeftHip2        = Torso2:WaitForChild("Left Hip")

SHADOW.PrimaryPart = RootPart2
Character.Archivable = false
SHADOW.Name = Player.Name .. "'s War"

local Effects = IT("Folder", Character)
Effects.Name = "Effects"

local ANIMATOR = Humanoid:FindFirstChildOfClass("Animator")
local ANIMATE  = Character:FindFirstChild("Animate")

local UNANCHOR = true
local ROAR = 528589078
local E = 1.32
local PLAYSONG = true
local REPLAY   = false

-- ---------- HEARTBEAT ----------
ArtificialHB = IT("BindableEvent")
ArtificialHB.Name = "ArtificialHB"
local frame = Frame_Speed
local tf = 0
local lastframe = tick()

RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        for _ = 1, math.floor(tf / frame) do
            ArtificialHB:Fire()
        end
        lastframe = tick()
        tf = tf - frame * math.floor(tf / frame)
    end
end)

-- ---------- UTILITIES ----------
function Raycast(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
    if DIRECTION.Magnitude == 0 then return nil, POSITION end
    return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.Unit * RANGE), IGNOREDECENDANTS)
end

function PositiveAngle(NUMBER)
    if NUMBER >= 0 then NUMBER = 0 end
    return NUMBER
end

function NegativeAngle(NUMBER)
    if NUMBER <= 0 then NUMBER = 0 end
    return NUMBER
end

function Swait(NUMBER)
    if NUMBER == 0 or NUMBER == nil then
        ArtificialHB.Event:Wait()
    else
        for i = 1, NUMBER do
            ArtificialHB.Event:Wait()
        end
    end
end

function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
    local NEWMESH = IT(MESH)
    if MESH == "SpecialMesh" then
        NEWMESH.MeshType = MESHTYPE
        if MESHID ~= "nil" and MESHID ~= "" then
            NEWMESH.MeshId = "rbxassetid://" .. MESHID
        end
        if TEXTUREID ~= "nil" and TEXTUREID ~= "" then
            NEWMESH.TextureId = "rbxassetid://" .. TEXTUREID
        end
    end
    NEWMESH.Offset = OFFSET or VT(0, 0, 0)
    NEWMESH.Scale  = SCALE
    NEWMESH.Parent = PARENT
    return NEWMESH
end

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
    local NEWPART = IT("Part")
    NEWPART.Reflectance  = REFLECTANCE
    NEWPART.Transparency = TRANSPARENCY
    NEWPART.CanCollide    = false
    NEWPART.Locked        = true
    NEWPART.Anchored      = (ANCHOR ~= false)
    NEWPART.BrickColor    = BRICKC(tostring(BRICKCOLOR))
    NEWPART.Name          = NAME
    NEWPART.Size          = SIZE
    NEWPART.Position      = Torso.Position
    NEWPART.Material      = MATERIAL
    NEWPART:BreakJoints()
    NEWPART.Parent        = PARENT
    return NEWPART
end

local weldBetween = function(a, b)
    local weldd = IT("ManualWeld")
    weldd.Part0 = a
    weldd.Part1 = b
    weldd.C0 = CF()
    weldd.C1 = b.CFrame:Inverse() * a.CFrame
    weldd.Parent = a
    return weldd
end

function QuaternionFromCFrame(cf)
    local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
    local trace = m00 + m11 + m22
    if trace > 0 then
        local s = math.sqrt(1 + trace)
        local recip = 0.5 / s
        return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
    else
        local i = 0
        if m00 < m11 then i = 1 end
        if m22 > (i == 0 and m00 or m11) then i = 2 end
        if i == 0 then
            local s = math.sqrt(m00 - m11 - m22 + 1)
            local recip = 0.5 / s
            return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
        elseif i == 1 then
            local s = math.sqrt(m11 - m22 - m00 + 1)
            local recip = 0.5 / s
            return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
        else
            local s = math.sqrt(m22 - m00 - m11 + 1)
            local recip = 0.5 / s
            return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
        end
    end
end

function QuaternionToCFrame(px, py, pz, x, y, z, w)
    local xs, ys, zs = x + x, y + y, z + z
    local wx, wy, wz = w * xs, w * ys, w * zs
    local xx = x * xs
    local xy = x * ys
    local xz = x * zs
    local yy = y * ys
    local yz = y * zs
    local zz = z * zs
    return CFrame.new(px, py, pz,
        1 - (yy + zz), xy - wz, xz + wy,
        xy + wz, 1 - (xx + zz), yz - wx,
        xz - wy, yz + wx, 1 - (xx + yy))
end

function QuaternionSlerp(a, b, t)
    local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
    local startInterp, finishInterp
    if cosTheta >= 1.0E-4 then
        if 1 - cosTheta > 1.0E-4 then
            local theta = ACOS(cosTheta)
            local inv = 1 / SIN(theta)
            startInterp  = SIN((1 - t) * theta) * inv
            finishInterp = SIN(t * theta) * inv
        else
            startInterp, finishInterp = 1 - t, t
        end
    elseif 1 + cosTheta > 1.0E-4 then
        local theta = ACOS(-cosTheta)
        local inv = 1 / SIN(theta)
        startInterp  = SIN((t - 1) * theta) * inv
        finishInterp = SIN(t * theta) * inv
    else
        startInterp, finishInterp = t - 1, t
    end
    return a[1]*startInterp + b[1]*finishInterp,
           a[2]*startInterp + b[2]*finishInterp,
           a[3]*startInterp + b[3]*finishInterp,
           a[4]*startInterp + b[4]*finishInterp
end

function Clerp(a, b, t)
    local qa = { QuaternionFromCFrame(a) }
    local qb = { QuaternionFromCFrame(b) }
    local ax, ay, az = a.x, a.y, a.z
    local bx, by, bz = b.x, b.y, b.z
    local _t = 1 - t
    return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz, QuaternionSlerp(qa, qb, t))
end

function CreateFrame(PARENT, TRANSPARENCY, BORDERSIZEPIXEL, POSITION, SIZE, COLOR, BORDERCOLOR, NAME)
    local frame = IT("Frame")
    frame.BackgroundTransparency = TRANSPARENCY
    frame.BorderSizePixel = BORDERSIZEPIXEL
    frame.Position = POSITION
    frame.Size = SIZE
    frame.BackgroundColor3 = COLOR
    frame.BorderColor3 = BORDERCOLOR
    frame.Name = NAME
    frame.Parent = PARENT
    return frame
end

function CreateLabel(PARENT, TEXT, TEXTCOLOR, TEXTFONTSIZE, TEXTFONT, TRANSPARENCY, BORDERSIZEPIXEL, STROKETRANSPARENCY, NAME)
    local label = IT("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UD2(1, 0, 1, 0)
    label.Position = UD2(0, 0, 0, 0)
    label.TextColor3 = TEXTCOLOR
    label.TextStrokeTransparency = STROKETRANSPARENCY
    label.TextTransparency = TRANSPARENCY
    label.FontSize = TEXTFONTSIZE
    label.Font = TEXTFONT
    label.BorderSizePixel = BORDERSIZEPIXEL
    label.TextScaled = false
    label.Text = TEXT
    label.Name = NAME
    label.Parent = PARENT
    return label
end

function NoOutlines(PART)
    PART.TopSurface, PART.BottomSurface = 10, 10
    PART.LeftSurface, PART.RightSurface  = 10, 10
    PART.FrontSurface, PART.BackSurface  = 10, 10
end

function CreateWeldOrSnapOrMotor(TYPE, PARENT, PART0, PART1, C0, C1)
    local W = IT(TYPE)
    W.Part0 = PART0
    W.Part1 = PART1
    W.C0 = C0
    W.C1 = C1
    W.Parent = PARENT
    return W
end

local S = IT("Sound")

function CreateSound(ID, PARENT, VOLUME, PITCH, DOESLOOP)
    local NEWSOUND
    coroutine.resume(coroutine.create(function()
        NEWSOUND = S:Clone()
        NEWSOUND.Parent  = PARENT
        NEWSOUND.Volume  = VOLUME
        NEWSOUND.Pitch   = PITCH
        NEWSOUND.SoundId = "rbxassetid://" .. ID
        NEWSOUND:Play()
        if DOESLOOP == true then
            NEWSOUND.Looped = true
        else
            repeat task.wait(1) until NEWSOUND.Playing == false
            NEWSOUND:Destroy()
        end
    end))
    return NEWSOUND
end

function CFrameFromTopBack(at, top, back)
    local right = top:Cross(back)
    return CF(at.x, at.y, at.z, right.x, top.x, back.x, right.y, top.y, back.y, right.z, top.z, back.z)
end

function WACKYEFFECT(Table)
    local TYPE             = Table.EffectType or "Sphere"
    local SIZE             = Table.Size or VT(1, 1, 1)
    local ENDSIZE          = Table.Size2 or VT(0, 0, 0)
    local TRANSPARENCY     = Table.Transparency or 0
    local ENDTRANSPARENCY  = Table.Transparency2 or 1
    local CFRAME           = Table.CFrame or Torso.CFrame
    local MOVEDIRECTION    = Table.MoveToPos or nil
    local ROTATION1        = Table.RotationX or 0
    local ROTATION2        = Table.RotationY or 0
    local ROTATION3        = Table.RotationZ or 0
    local MATERIAL         = Table.Material or "Neon"
    local COLOR            = Table.Color or C3(1, 1, 1)
    local TIME             = Table.Time or 45
    local SOUNDID          = Table.SoundID or nil
    local SOUNDPITCH       = Table.SoundPitch or nil
    local SOUNDVOLUME      = Table.SoundVolume or nil

    coroutine.resume(coroutine.create(function()
        local PLAYSSOUND = false
        local SOUND
        local EFFECT = CreatePart(3, Effects, MATERIAL, 0, TRANSPARENCY, BRICKC("Pearl"), "Effect", VT(1, 1, 1), true)
        if SOUNDID and SOUNDPITCH and SOUNDVOLUME then
            PLAYSSOUND = true
            SOUND = CreateSound(SOUNDID, EFFECT, SOUNDVOLUME, SOUNDPITCH, false)
        end
        EFFECT.Color = COLOR
        local MSH
        if TYPE == "Sphere" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "Sphere", "", "", SIZE, VT(0, 0, 0))
        elseif TYPE == "Block" or TYPE == "Box" then
            MSH = IT("BlockMesh", EFFECT); MSH.Scale = SIZE
        elseif TYPE == "Wave" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "20329976", "", SIZE, VT(0, 0, -SIZE.X / 8))
        elseif TYPE == "Ring" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "559831844", "", VT(SIZE.X, SIZE.X, 0.1), VT(0, 0, 0))
        elseif TYPE == "Slash" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662586858", "", VT(SIZE.X/10, 0, SIZE.X/10), VT(0, 0, 0))
        elseif TYPE == "Round Slash" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662585058", "", VT(SIZE.X/10, 0, SIZE.X/10), VT(0, 0, 0))
        elseif TYPE == "Swirl" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "1051557", "", SIZE, VT(0, 0, 0))
        elseif TYPE == "Skull" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "4770583", "", SIZE, VT(0, 0, 0))
        elseif TYPE == "Crystal" then
            MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "9756362", "", SIZE, VT(0, 0, 0))
        end
        if MSH ~= nil then
            local MOVESPEED
            if MOVEDIRECTION ~= nil then
                MOVESPEED = (CFRAME.p - MOVEDIRECTION).Magnitude / TIME
            end
            local GROWTH = SIZE - ENDSIZE
            local TRANS  = TRANSPARENCY - ENDTRANSPARENCY
            if TYPE == "Block" then
                EFFECT.CFrame = CFRAME * ANGLES(RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)))
            else
                EFFECT.CFrame = CFRAME
            end
            for _ = 1, TIME + 1 do
                Swait()
                MSH.Scale = MSH.Scale - GROWTH / TIME
                if TYPE == "Wave" then MSH.Offset = VT(0, 0, -MSH.Scale.X / 8) end
                EFFECT.Transparency = EFFECT.Transparency - TRANS / TIME
                if TYPE == "Block" then
                    EFFECT.CFrame = CFRAME * ANGLES(RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)))
                else
                    EFFECT.CFrame = EFFECT.CFrame * ANGLES(RAD(ROTATION1), RAD(ROTATION2), RAD(ROTATION3))
                end
                if MOVEDIRECTION ~= nil then
                    local ORI = EFFECT.Orientation
                    EFFECT.CFrame = CF(EFFECT.Position, MOVEDIRECTION) * CF(0, 0, -MOVESPEED)
                    EFFECT.Orientation = ORI
                end
            end
            if PLAYSSOUND == false then
                EFFECT:Destroy()
            else
                repeat Swait() until SOUND.Playing == false
                EFFECT:Destroy()
            end
        elseif PLAYSSOUND == false then
            EFFECT:Destroy()
        else
            repeat Swait() until SOUND.Playing == false
            EFFECT:Destroy()
        end
    end))
end

function MakeForm(PART, TYPE)
    if TYPE == "Cyl" then
        IT("CylinderMesh", PART)
    elseif TYPE == "Ball" then
        local MSH = IT("SpecialMesh", PART); MSH.MeshType = "Sphere"
    elseif TYPE == "Wedge" then
        local MSH = IT("SpecialMesh", PART); MSH.MeshType = "Wedge"
    end
end

function CastProperRay(StartPos, EndPos, Distance, Ignore)
    local DIRECTION = CF(StartPos, EndPos).lookVector
    return Raycast(StartPos, DIRECTION, Distance, Ignore)
end

function GetRoot(MODEL, ROOT)
    if ROOT == true then
        return MODEL:FindFirstChild("HumanoidRootPart") or MODEL:FindFirstChild("Torso") or MODEL:FindFirstChild("UpperTorso")
    end
    return MODEL:FindFirstChild("Torso") or MODEL:FindFirstChild("UpperTorso")
end

function FacialShadow()
    local SHADOWS = {}
    for i = 1, 16 do
        local FACE = CreatePart(3, Effects, "Fabric", 0, 0 + (i - 1) / 16.2, "Dark stone grey", "FaceGradient", VT(1.01, 0.65, 1.01), false)
        FACE.Color = C3(0, 0, 0)
        local sm = Head:FindFirstChildOfClass("SpecialMesh")
        if sm then sm:Clone().Parent = FACE end
        CreateWeldOrSnapOrMotor("Weld", Head, Head, FACE, CF(0, 0.45 - (i - 1) / 25, 0), CF(0, 0, 0))
        table.insert(SHADOWS, FACE)
    end
    return function()
        for i = 1, #SHADOWS do SHADOWS[i]:Destroy() end
    end
end

function CreateFlyingDebree(FLOOR, POSITION, AMOUNT, BLOCKSIZE, SWAIT, STRENGTH)
    if FLOOR == nil then return end
    for _ = 1, AMOUNT do
        local DEBREE = CreatePart(3, Effects, "Neon", FLOOR.Reflectance, FLOOR.Transparency, "Pearl", "Debree", BLOCKSIZE, false)
        DEBREE.Material = FLOOR.Material
        DEBREE.Color = FLOOR.Color
        DEBREE.CFrame = POSITION * ANGLES(RAD(MRANDOM(-360, 360)), RAD(MRANDOM(-360, 360)), RAD(MRANDOM(-360, 360)))
        DEBREE.Velocity = VT(MRANDOM(-STRENGTH, STRENGTH), MRANDOM(-STRENGTH, STRENGTH), MRANDOM(-STRENGTH, STRENGTH))
        coroutine.resume(coroutine.create(function()
            Swait(15)
            DEBREE.Parent = workspace
            DEBREE.CanCollide = true
            Debris:AddItem(DEBREE, SWAIT)
        end))
    end
end

-- ---------- SHADOW SCALING ----------
local SIZE = 2
RootPart2.Size   = RootPart.Size  * SIZE
Torso2.Size      = Torso.Size     * SIZE
RightArm2.Size   = RightArm.Size  * SIZE
RightLeg2.Size   = RightLeg.Size  * SIZE
LeftArm2.Size    = LeftArm.Size   * SIZE
LeftLeg2.Size    = LeftLeg.Size   * SIZE

RootJoint2.C0    = ROOTC0 * CF(0,0,0) * ANGLES(RAD(0),RAD(0),RAD(0))
RootJoint2.C1    = ROOTC0 * CF(0,0,0) * ANGLES(RAD(0),RAD(0),RAD(0))
Neck2.C0         = NECKC0 * CF(0,0,0 + (1*SIZE - 1)) * ANGLES(RAD(0),RAD(0),RAD(0))
Neck2.C1         = CF(0, -0.5*SIZE, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
RightShoulder2.C1 = CF(0, 0.5*SIZE, -0.35*SIZE)
LeftShoulder2.C1  = CF(0, 0.5*SIZE, -0.35*SIZE)
RightHip2.C0     = CF( 1*SIZE, -1*SIZE, 0) * ANGLES(RAD(0),  RAD(90), RAD(0))
LeftHip2.C0      = CF(-1*SIZE, -1*SIZE, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))
RightHip2.C1     = CF( 0.5*SIZE, 1*SIZE, 0) * ANGLES(RAD(0),  RAD(90), RAD(0))
LeftHip2.C1      = CF(-0.5*SIZE, 1*SIZE, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))
Head2.Size       = VT(1, 1, 1) * SIZE

-- Attach shadow to the player body
RootJoint2.Parent     = RootPart
Neck2.Parent          = Torso
RightShoulder2.Parent = Torso
LeftShoulder2.Parent  = Torso
RightHip2.Parent      = Torso
LeftHip2.Parent       = Torso

-- ---------- GUI ----------
local SKILLTEXTCOLOR = C3(1, 1, 1)
local SKILLFONT      = "Fantasy"
local SKILLTEXTSIZE  = 6
local ATTACKS = { "Z-Tremor Punch", "E-Meteor Impact", "R-Uppercut" }
for i = 1, #ATTACKS do
    local SKILLFRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.05, 0, 0.9 - 0.04*i, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0,0,0), "Skill Frame")
    local SKILLTEXT  = CreateLabel(SKILLFRAME, "[" .. ATTACKS[i] .. "]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 0, "Skill text")
    SKILLTEXT.TextXAlignment = "Left"
end

-- ---------- DAMAGE ----------
function ApplyDamage(Humanoid, Damage)
    Damage = Damage * DAMAGEMULTIPLIER
    if Humanoid.Health < 2000 then
        if Humanoid.Health - Damage > 0 then
            Humanoid.Health = Humanoid.Health - Damage
        else
            Humanoid.Parent:BreakJoints()
        end
    else
        Humanoid.Parent:BreakJoints()
    end
end

function ApplyAoE(POSITION, RANGE, MINDMG, MAXDMG, FLING, INSTAKILL)
    for _, CHILD in pairs(workspace:GetDescendants()) do
        if CHILD.ClassName == "Model" and CHILD ~= Character then
            local HUM = CHILD:FindFirstChildOfClass("Humanoid")
            if HUM then
                local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
                if TORSO and RANGE >= (TORSO.Position - POSITION).Magnitude then
                    if INSTAKILL == true then
                        CHILD:BreakJoints()
                    else
                        ApplyDamage(HUM, MRANDOM(MINDMG, MAXDMG))
                    end
                    if FLING > 0 then
                        for _, c in pairs(CHILD:GetChildren()) do
                            if c:IsA("BasePart") then
                                local bv = IT("BodyVelocity")
                                bv.MaxForce = VT(1e9, 1e9, 1e9)
                                bv.Velocity = CF(POSITION, TORSO.Position).lookVector * FLING
                                bv.Parent = c
                                Debris:AddItem(bv, 0.05)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ---------- ATTACKS ----------
function Intro()
    EQUIPPED = true
    ATTACK   = true
    Rooted   = true
    if Rooted == false then
        Disable_Jump = false
        Humanoid.WalkSpeed = Speed
    else
        Disable_Jump = true
        Humanoid.WalkSpeed = 0
    end
    coroutine.resume(coroutine.create(function()
        repeat
            Swait()
            RootPart2.Anchored = true
            for _, c in pairs(SHADOW:GetChildren()) do
                if c:IsA("Part") then
                    c.Color = C3(1, 1, 1)
                    if c ~= RootPart2 then c.Transparency = 1 end
                    if c:FindFirstChildOfClass("Decal") then c:ClearAllChildren() end
                    c.CanCollide = false
                    c.Material = "Neon"
                elseif c ~= RightShoulder2 and c ~= LeftShoulder2 and c ~= RightHip2 and c ~= LeftHip2 and c ~= Neck2 and c ~= RootJoint2 then
                    c:Destroy()
                end
            end
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-5), RAD(0), RAD(-35)), 1 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0,      NECKC0 * CF(0,0,0) * ANGLES(RAD(0),  RAD(0), RAD(35)),  1 / Animation_Speed)
            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(-1), RAD(0), RAD(3)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            LeftShoulder.C0  = Clerp(LeftShoulder.C0,  CF(-1.5, 0.5, 0) * ANGLES(RAD(-1), RAD(0), RAD(-3)) * LEFTSHOULDERC0, 1 / Animation_Speed)
            RightHip.C0  = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-12), RAD(80), RAD(0)) * ANGLES(RAD(-2), RAD(0), RAD(0)), 1 / Animation_Speed)
            LeftHip.C0   = Clerp(LeftHip.C0,  CF(-1, -1, -0.01) * ANGLES(RAD(0),  RAD(-60), RAD(0)) * ANGLES(RAD(-2), RAD(0), RAD(0)), 1 / Animation_Speed)
        until ATTACK == false
    end))
    task.wait(1)
    SHADOW.Parent = Character
    SHADOW:SetPrimaryPartCFrame(RootPart.CFrame * CF(0, -20, 5))
    local HIT, POS = Raycast(RootPart.CFrame * CF(0, 0, 5).p, CF(RootPart.Position, RootPart.Position + VT(0, -1, 0)).lookVector, 4, Character)
    for _ = 1, 250 do
        Swait()
        E = E - 0.0032
        local AREA = CF(POS) * ANGLES(RAD(0), RAD(MRANDOM(0, 360)), RAD(0)) * CF(0, 0, MRANDOM(2, 18))
        local TIMER = MRANDOM(20, 80)
        WACKYEFFECT({
            Time = TIMER, EffectType = "Sphere",
            Size = VT(1, 1, 1), Size2 = VT(0, 45, 0),
            Transparency = 1, Transparency2 = 1,
            CFrame = AREA, MoveToPos = AREA.p + VT(0, MRANDOM(35, 160), 0),
            RotationX = 0, RotationY = 0, RotationZ = 0,
            Material = "Neon", Color = C3(1, 1, 1)
        })
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.01)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-5), RAD(0), RAD(0)), 1 / Animation_Speed)
        Neck2.C0      = Clerp(Neck2.C0, NECKC0 * CF(0,0,0 + (1*SIZE-1)) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-15), RAD(0), RAD(45)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-15), RAD(0), RAD(-45)) * LEFTSHOULDERC0, 1 / Animation_Speed)
        RightHip2.C0 = Clerp(RightHip2.C0, CF(1*SIZE, -0.7*SIZE, -0.5*SIZE) * ANGLES(RAD(-25), RAD(80), RAD(0)) * ANGLES(RAD(-1*SIN(SINE/6)), RAD(0), RAD(0)), 1 / Animation_Speed)
        LeftHip2.C0  = Clerp(LeftHip2.C0, CF(-1*SIZE, -0.7*SIZE, -0.5*SIZE) * ANGLES(RAD(-25), RAD(-80), RAD(0)) * ANGLES(RAD(-1*SIN(SINE/6)), RAD(0), RAD(0)), 1 / Animation_Speed)
    end
    for _ = 0, 0.6, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.1)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, -0.5*SIZE) * ANGLES(RAD(140), RAD(0), RAD(-25)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, -0.5*SIZE) * ANGLES(RAD(140), RAD(0), RAD(25)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
    end
    CreateSound(ROAR, Head2, 10, 1, false)
    for _ = 0, 4, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.1)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(35), RAD(0), RAD(0)), 1 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-45), RAD(0), RAD(25)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-45), RAD(0), RAD(-25)) * LEFTSHOULDERC0, 1 / Animation_Speed)
    end
    ATTACK = false
    Rooted = false
end

function Roar(TABLE)
    ATTACK = true
    Rooted = true
    local E2 = false
    coroutine.resume(coroutine.create(function()
        repeat
            Swait()
            RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 8, 0), 0.1)
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0), 0.15 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(35), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.45, 0.65, 0) * ANGLES(RAD(170), RAD(0), RAD(-22)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            LeftShoulder.C0  = Clerp(LeftShoulder.C0,  CF(-1.45, 0.65, 0) * ANGLES(RAD(170), RAD(0), RAD(22)) * LEFTSHOULDERC0, 1 / Animation_Speed)
            RightHip.C0  = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            LeftHip.C0   = Clerp(LeftHip.C0,  CF(-1, -1, -0.01) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
        until E2 == true
    end))
    for _ = 0, 1, 0.1 / Animation_Speed do
        Swait()
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.15*SIZE, 0.5*SIZE, -0.5*SIZE) * ANGLES(RAD(140), RAD(0), RAD(-45)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.15*SIZE, 0.5*SIZE, -0.5*SIZE) * ANGLES(RAD(140), RAD(0), RAD(45)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
    end
    CreateSound(ROAR, Effects, 4, 1, false)
    if TABLE then
        for i = 1, #TABLE do
            local HUM = TABLE[i]:FindFirstChildOfClass("Humanoid")
            if HUM then
                local ROOT = GetRoot(TABLE[i], true)
                if ROOT then
                    ApplyDamage(HUM, MRANDOM(25, 50))
                    local bv = IT("BodyVelocity")
                    bv.MaxForce = VT(1e9, 1e9, 1e9)
                    bv.Velocity = CF(RootPart.Position, ROOT.Position).lookVector * 150
                    bv.Parent = ROOT
                    Debris:AddItem(bv, 0.05)
                end
            end
        end
    end
    for _ = 0, 6, 0.1 / Animation_Speed do
        Swait()
        local HITFLOOR, HITPOS = Raycast(RootPart2.Position, CF(RootPart.Position, RootPart.Position + VT(0, -1, 0)).lookVector, 25, Character)
        if HITFLOOR then
            CreateFlyingDebree(HITFLOOR, CF(HITPOS), 1, VT(1,1,1)*MRANDOM(7,15)/10, 5, 60)
        end
        WACKYEFFECT({
            EffectType = "Wave",
            Size = VT(20, 1, 20), Size2 = VT(25 + MRANDOM(0,8), 7, 25 + MRANDOM(0,8)),
            Transparency = 1, Transparency2 = 1,
            CFrame = CF(HITPOS) * ANGLES(RAD(0), RAD(MRANDOM(0, 360)), RAD(0)),
            RotationX = 0, RotationY = 5, RotationZ = 0,
            Material = "Neon", Color = C3(1, 1, 1)
        })
    end
    E2 = true
    if TABLE then
        CreateSound(1535995263, Head, 10, 1, false)
    end
    ATTACK = false
    Rooted = false
end

function Punch()
    ATTACK = true
    Rooted = false
    local HITS = {}
    Speed = 12
    for _ = 0, 1, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.1)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-5), RAD(0), RAD(-45)), 0.5 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, -0.25*SIZE) * ANGLES(RAD(90), RAD(0), RAD(-45)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(0), RAD(0), RAD(-25)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
        RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(0), RAD(0), RAD(-25)), 1 / Animation_Speed)
        Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(0 - 2.5*SIN(SINE/12)), RAD(0), RAD(25)), 1 / Animation_Speed)
        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(25)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
        LeftShoulder.C0  = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 1 / Animation_Speed)
    end
    CreateSound(588693579, RightArm2, 6, MRANDOM(8, 12) / 10, false)
    for _ = 0, 0.3, 0.1 / Animation_Speed do
        Swait()
        WACKYEFFECT({
            EffectType = "Box", Size = RightArm2.Size, Size2 = RightArm2.Size,
            Transparency = 1, Transparency2 = 1, CFrame = RightArm2.CFrame,
            Material = "Neon", Color = C3(1,1,1)
        })
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 3, -5), 0.4)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(45), RAD(0), RAD(45)), 0.5 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.25*SIZE, 0.5*SIZE, -0.25*SIZE) * ANGLES(RAD(135), RAD(0), RAD(45)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
        RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(0), RAD(0), RAD(25)), 1 / Animation_Speed)
        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(-25)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
    end
    for _, CHILD in pairs(workspace:GetDescendants()) do
        if CHILD.ClassName == "Model" and CHILD ~= Character then
            local HUM = CHILD:FindFirstChildOfClass("Humanoid")
            if HUM then
                local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
                if TORSO and (TORSO.Position - RightArm2.CFrame * CF(0, -2, 0).p).Magnitude <= 15 then
                    table.insert(HITS, CHILD)
                    coroutine.resume(coroutine.create(function()
                        CreateSound(260430117, TORSO, 3, MRANDOM(8, 12) / 10, false)
                        TORSO.Anchored = true
                        local POS = TORSO.CFrame
                        for _ = 1, 35 do
                            Swait()
                            ApplyDamage(HUM, MRANDOM(1, 1))
                            TORSO.CFrame = POS * CF(MRANDOM(-2,2)/10, MRANDOM(-2,2)/10, MRANDOM(-2,2)/10)
                        end
                        TORSO.Anchored = false
                    end))
                end
            end
        end
    end
    if #HITS > 0 then
        Roar(HITS)
    end
    Speed = 16
    ATTACK = false
    Rooted = false
end

function Throw()
    ATTACK = true
    Rooted = false
    local DEBREE = {}
    for _ = 0, 1, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 1, 2), 0.2)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(90), RAD(0), RAD(-25)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(90), RAD(0), RAD(25)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
    end
    local CFRAME = RootPart2.CFrame * CF(0, 50, 0)
    Humanoid.PlatformStand = true
    UNANCHOR = false
    for _ = 0, 1, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, CF(CFRAME.p, VT(Mouse.Hit.p.X, RootPart2.Position.Y, Mouse.Hit.p.Z)), 0.2)
        RootPart.CFrame = RootPart2.CFrame * CF(0, -1, -2)
    end
    local WELD = CreateWeldOrSnapOrMotor("Weld", RightArm2, RightArm2, Torso, CF(0, -2, 0) * ANGLES(RAD(-90), RAD(0), RAD(0)), CF(0, 0, 0))
    for _ = 0, 0.4, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, CF(CFRAME.p, VT(Mouse.Hit.p.X, RootPart2.Position.Y, Mouse.Hit.p.Z)), 0.2)
    end
    local IMPACT = false
    WELD:Destroy()
    RootPart.CFrame = CF(RightArm2.CFrame * CF(0, -3, 0).p, Mouse.Hit.p)
    CreateSound(588693579, RightArm2, 6, MRANDOM(8, 12) / 10, false)
    local FLOOR
    for _ = 1, 80 do
        Swait()
        local HIT, POS = Raycast(RootPart.Position, RootPart.CFrame.lookVector, 6, Character)
        if HIT then
            FLOOR = HIT
            IMPACT = true
            local ORI = VT(0, RootPart.Orientation.Y, 0)
            RootPart.CFrame = CF(POS + VT(0, 3.5, 0))
            RootPart.Orientation = ORI
            break
        else
            RootPart.CFrame = RootPart.CFrame * CF(0, 0, -6)
        end
    end
    UNANCHOR = true
    if FLOOR then
        Humanoid.PlatformStand = false
        local FLING = false
        coroutine.resume(coroutine.create(function()
            local ROCKS = MRANDOM(8, 13)
            for i = 1, ROCKS do
                local DEBREEPART = CreatePart(3, Effects, FLOOR.Material, 0, 0, FLOOR.BrickColor, "Debree", VT(1,1,1)*MRANDOM(2,7), true)
                DEBREEPART.CFrame = CF(RootPart.Position - VT(0, 7, 0)) * ANGLES(RAD(0), RAD(360/ROCKS*i), RAD(0)) * CF(0, 0, MRANDOM(20, 28)) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)))
                table.insert(DEBREE, { DEBREEPART, DEBREEPART.Orientation, CF(DEBREEPART.Position + VT(0, MRANDOM(3,7)+8, 0)) })
            end
            repeat
                Swait()
                for i = 1, #DEBREE do
                    local ROCK = DEBREE[i][1]
                    ROCK.CFrame = Clerp(ROCK.CFrame, DEBREE[i][3], 0.3)
                    ROCK.Orientation = DEBREE[i][2]
                end
            until FLING == true or ATTACK == false
            if FLING == false then
                for i = 1, #DEBREE do
                    DEBREE[i][1].Anchored = false
                    Debris:AddItem(DEBREE[i][1], 4)
                end
            end
        end))
        local UNDO = FacialShadow()
        CreateSound(765590102, Torso, 2, MRANDOM(8, 12) / 10, false)
        task.wait(2)
        UNDO()
    end
    REPLAY = false
    ATTACK = false
    Rooted = false
end

function Uppercut()
    ATTACK = true
    Rooted = false
    local HITS = {}
    Speed = 12
    for _ = 0, 1, 0.1 / Animation_Speed do
        Swait()
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.1)
        RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-5), RAD(0), RAD(-45)), 0.5 / Animation_Speed)
        RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, -0.25*SIZE) * ANGLES(RAD(90), RAD(0), RAD(-45)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
        LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(0), RAD(0), RAD(-25)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
        RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(0), RAD(0), RAD(-25)), 1 / Animation_Speed)
        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(25)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
    end
    CreateSound(588693579, RightArm2, 6, MRANDOM(8, 12) / 10, false)
    for _ = 0, 0.3, 0.1 / Animation_Speed do
        Swait()
        WACKYEFFECT({
            EffectType = "Box", Size = RightArm2.Size, Size2 = RightArm2.Size,
            Transparency = RightArm2.Transparency, Transparency2 = 1,
            CFrame = RightArm2.CFrame,
            Material = "Neon", Color = C3(1,1,1)
        })
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 3, -5), 0.4)
    end
    for _, CHILD in pairs(workspace:GetDescendants()) do
        if CHILD.ClassName == "Model" and CHILD ~= Character then
            local HUM = CHILD:FindFirstChildOfClass("Humanoid")
            if HUM then
                local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
                if TORSO and (TORSO.Position - RightArm2.CFrame * CF(0, -2, 0).p).Magnitude <= 15 then
                    coroutine.resume(coroutine.create(function()
                        CreateSound(260430117, TORSO, 3, MRANDOM(8, 12) / 10, false)
                        local grav = IT("BodyPosition", TORSO)
                        grav.D = 1500
                        grav.P = 20000
                        grav.MaxForce = VT(math.huge, math.huge, math.huge)
                        grav.Position = TORSO.Position + VT(0, 25, 0)
                        TORSO.RotVelocity = VT(MRANDOM(-25,25), MRANDOM(-25,25), MRANDOM(-25,25))
                        table.insert(HITS, {CHILD, grav})
                        ApplyDamage(HUM, MRANDOM(12, 22))
                    end))
                end
            end
        end
    end
    if #HITS > 0 then
        coroutine.resume(coroutine.create(function()
            repeat Swait() until ATTACK == false
            for i = 1, #HITS do
                if HITS[i][2] then HITS[i][2]:Destroy() end
            end
        end))
    end
    REPLAY = true
    local PLAYING = false
    local WHACK   = false
    local HITTING = 0
    local PAYDOWN = 200
    local UNDO = FacialShadow()
    for _ = 0, 0.5, 0.1 / Animation_Speed do
        Swait()
        if PLAYING then break end
    end
    if #HITS > 0 then
        local KEY
        KEY = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "R" and WHACK == false then
                if PLAYING == false then PLAYING = true end
                WHACK   = true
                PAYDOWN = 70
                HITTING = HITTING + 1
                for i = 1, #HITS do
                    if HITS[i][1] then
                        local ROOT = GetRoot(HITS[i][1], true)
                        if ROOT then
                            local HUM = HITS[i][1]:FindFirstChildOfClass("Humanoid")
                            if HUM and HUM.Health > 0 then
                                HUM.PlatformStand = true
                                CreateSound(260430117, ROOT, 3, MRANDOM(8, 12) / 10, false)
                                local HIT, POS = Raycast(ROOT.Position + VT(0, 5, 0), CF(RootPart.Position, RootPart.Position - VT(0, 5, 0)).lookVector, 60, HITS[i][1])
                                ROOT.CFrame = CF(POS)
                                ApplyDamage(HUM, MRANDOM(12, 18))
                                ROOT.RotVelocity = VT(MRANDOM(-25,25), MRANDOM(-25,25), MRANDOM(-25,25)) * 4
                            end
                        end
                    end
                end
                WHACK = false
            end
        end)
        task.delay(3, function()
            if KEY then KEY:Disconnect() end
        end)
    end
    task.wait(0.6)
    if KEY then pcall(function() KEY:Disconnect() end) end
    if HITTING > 4 then
        CreateSound(1535994137, Head, 10, 1, false)
    end
    UNDO()
    Speed = 16
    REPLAY = false
    ATTACK = false
    Rooted = false
end

function TakeOn()
    ATTACK = true
    Rooted = true
    coroutine.resume(coroutine.create(function()
        repeat
            Swait()
            RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0.25*COS(SINE/12)) * ANGLES(RAD(-5 + 2*SIN(SINE/12)), RAD(15), RAD(35)), 0.5 / Animation_Speed)
        until ATTACK == false
    end))
    CreateSound(1535994669, Head, 10, 1, false)
    task.wait(1)
    ATTACK = false
    Rooted = false
end

-- ---------- INPUT ----------
function MouseDown() if ATTACK == false then end end
function MouseUp()   HOLD = false end

function KeyDown(Key)
    KEYHOLD = true
    if Key == "z" and ATTACK == false then Punch()    end
    if Key == "e" and ATTACK == false and REPLAY == false then Throw()    end
    if Key == "r" and ATTACK == false and REPLAY == false then Uppercut() end
    if Key == "t" and ATTACK == false then Roar()     end
    if Key == "y" and ATTACK == false then TakeOn()   end
end

function KeyUp() KEYHOLD = false end

Mouse.Button1Down:Connect(function() MouseDown() end)
Mouse.Button1Up:Connect(function()   MouseUp()   end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeyDown(input.KeyCode.Name:lower())
    end
end)
UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeyUp(input.KeyCode.Name:lower())
    end
end)

function unanchor()
    for _, c in pairs(Character:GetChildren()) do
        if c:IsA("BasePart") and c ~= RootPart then c.Anchored = false end
    end
    if UNANCHOR == true then
        RootPart.Anchored = false
    else
        RootPart.Anchored = true
    end
end

Humanoid.Changed:Connect(function(prop)
    if prop == "Jump" and Disable_Jump == true then
        Humanoid.Jump = false
    end
end)

coroutine.resume(coroutine.create(function()
    while true do
        Swait()
        SINE = SINE + CHANGE
    end
end))

-- ---------- MAIN LOOP ----------
while true do
    Swait()
    if ANIMATE then ANIMATE.Parent = nil end
    if ANIMATOR then
        for _, v in next, ANIMATOR:GetPlayingAnimationTracks() do
            v:Stop()
        end
    end
    local TORSOVELOCITY  = (RootPart.Velocity * VT(1, 0, 1)).magnitude
    local TORSOVERTICALVELOCITY = RootPart.Velocity.y
    local HITFLOOR = Raycast(RootPart.Position, CF(RootPart.Position, RootPart.Position + VT(0, -1, 0)).lookVector, 4, Character)
    local WALKSPEEDVALUE = 4
    if ANIM == "Walk" and TORSOVELOCITY > 1 then
        RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0, 0, -0.05 * COS(SINE / (WALKSPEEDVALUE / 2))) * ANGLES(RAD(0), RAD(0) - RootPart.RotVelocity.Y / 75, RAD(0)), 2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
        Neck.C1 = Clerp(Neck.C1, CF(0, -0.5, 0) * ANGLES(RAD(-90), RAD(0), RAD(180)) * ANGLES(RAD(2.5 * SIN(SINE / (WALKSPEEDVALUE / 2))), RAD(0), RAD(0) - Head.RotVelocity.Y / 30), 0.2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
        RightHip.C1 = Clerp(RightHip.C1, CF(0.5, 0.875 - 0.125 * SIN(SINE / WALKSPEEDVALUE) - 0.15 * COS(SINE / WALKSPEEDVALUE * 2), -0.125 * COS(SINE / WALKSPEEDVALUE) + 0.2 - 0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0) - RightLeg.RotVelocity.Y / 75, RAD(0), RAD(76 * COS(SINE / WALKSPEEDVALUE))), 0.4 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
        LeftHip.C1  = Clerp(LeftHip.C1,  CF(-0.5, 0.875 + 0.125 * SIN(SINE / WALKSPEEDVALUE) - 0.15 * COS(SINE / WALKSPEEDVALUE * 2), 0.125 * COS(SINE / WALKSPEEDVALUE) + 0.2 + 0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0) + LeftLeg.RotVelocity.Y / 75, RAD(0), RAD(76 * COS(SINE / WALKSPEEDVALUE))), 0.4 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
    elseif ANIM ~= "Walk" or TORSOVELOCITY < 1 then
        RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0,0,0), 0.2 / Animation_Speed)
        Neck.C1      = Clerp(Neck.C1, CF(0, -0.5, 0) * ANGLES(RAD(-90), RAD(0), RAD(180)), 0.2 / Animation_Speed)
        RightHip.C1  = Clerp(RightHip.C1, CF(0.5, 1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)), 0.2 / Animation_Speed)
        LeftHip.C1   = Clerp(LeftHip.C1,  CF(-0.5, 1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)), 0.2 / Animation_Speed)
    end
    if TORSOVERTICALVELOCITY > 1 and HITFLOOR == nil then
        ANIM = "Jump"
        if ATTACK == false then
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(-5), RAD(0), RAD(0)), 1 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(-35), RAD(0), RAD(25 + 10*COS(SINE/12))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            LeftShoulder.C0  = Clerp(LeftShoulder.C0,  CF(-1.5, 0.5, 0) * ANGLES(RAD(-35), RAD(0), RAD(-25 - 10*COS(SINE/12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
        end
    elseif TORSOVERTICALVELOCITY < -1 and HITFLOOR == nil then
        ANIM = "Fall"
        if ATTACK == false then
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
        end
    elseif TORSOVELOCITY < 1 and HITFLOOR ~= nil then
        ANIM = "Idle"
        if ATTACK == false then
            RootJoint2.C0 = Clerp(RootJoint2.C0, ROOTC0 * CF(0,0,0.25*COS(SINE/12)) * ANGLES(RAD(-5 + 2*SIN(SINE/12)), RAD(15), RAD(35)), 0.5 / Animation_Speed)
            Neck2.C0      = Clerp(Neck2.C0, NECKC0 * CF(0,0,0 + (1*SIZE - 1)) * ANGLES(RAD(25 - 2*SIN(SINE/12)), RAD(0), RAD(-35)), 0.5 / Animation_Speed)
            RightShoulder2.C0 = Clerp(RightShoulder2.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-35 + 15*SIN(SINE/12)), RAD(0), RAD(60)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
            LeftShoulder2.C0  = Clerp(LeftShoulder2.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(-35 + 15*SIN(SINE/12)), RAD(0), RAD(-60)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
            RightHip2.C0 = Clerp(RightHip2.C0, CF(1*SIZE, -1*SIZE, 0) * ANGLES(RAD(0), RAD(80 - 1*SIN(SINE/6)), RAD(0)) * ANGLES(RAD(-3*SIN(SINE/12)), RAD(0), RAD(0)), 0.5 / Animation_Speed)
            LeftHip2.C0  = Clerp(LeftHip2.C0, CF(-1*SIZE, -0.3*SIZE, -0.6*SIZE) * ANGLES(RAD(-25), RAD(-80 + 1*SIN(SINE/6)), RAD(0)) * ANGLES(RAD(-3*SIN(SINE/12)), RAD(0), RAD(0)), 0.5 / Animation_Speed)
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0 + 0.05*COS(SINE/12)) * ANGLES(RAD(0), RAD(0), RAD(-15)), 1 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(0 - 2.5*SIN(SINE/12)), RAD(0), RAD(15)), 1 / Animation_Speed)
            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5 + 0.05*SIN(SINE/12), 0) * ANGLES(RAD(0), RAD(0), RAD(3)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            LeftShoulder.C0  = Clerp(LeftShoulder.C0,  CF(-1.35, 0.5, 0.2) * ANGLES(RAD(-25), RAD(0), RAD(45)) * LEFTSHOULDERC0, 1 / Animation_Speed)
        end
    elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil then
        ANIM = "Walk"
        if ATTACK == false then
            RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,-0.05) * ANGLES(RAD(5), RAD(0), RAD(0)), 1 / Animation_Speed)
            Neck.C0      = Clerp(Neck.C0, NECKC0 * CF(0,0,0) * ANGLES(RAD(5 - 1*SIN(SINE/(WALKSPEEDVALUE/2))), RAD(0), RAD(0)), 1 / Animation_Speed)
            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(30*COS(SINE/WALKSPEEDVALUE)), RAD(0), RAD(5)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            LeftShoulder.C0  = Clerp(LeftShoulder.C0,  CF(-1.5, 0.5, 0) * ANGLES(RAD(-30*COS(SINE/WALKSPEEDVALUE)), RAD(0), RAD(-5)) * LEFTSHOULDERC0, 1 / Animation_Speed)
        end
    end
    if ATTACK == false then
        RootPart2.CFrame = Clerp(RootPart2.CFrame, RootPart.CFrame * CF(0, 6, 5), 0.1)
    end
    unanchor()
    RootPart2.Anchored = true
    if Rooted == false then
        Disable_Jump = false
        Humanoid.WalkSpeed = Speed
    else
        Disable_Jump = true
        Humanoid.WalkSpeed = 0
    end
    for _, c in pairs(SHADOW:GetChildren()) do
        if c:IsA("Part") then
            c.Color = C3(1, 1, 1)
            if c ~= RootPart2 then c.Transparency = 1 end
            if c:FindFirstChildOfClass("Decal") then c:ClearAllChildren() end
            c.CanCollide = false
            c.Material = "Neon"
        elseif c:IsA("Model") or c:IsA("Accessory") or c:IsA("Sound") then
            c:Destroy()
        end
    end
    sick.SoundId = "rbxassetid://609005478"
    sick.Looped  = true
    sick.Pitch   = 1
    sick.Volume  = 1.5
    sick.Parent  = Character
    if not sick.Playing and PLAYSONG then sick:Play() end
    if EQUIPPED == false then
        Intro()
    end
end
