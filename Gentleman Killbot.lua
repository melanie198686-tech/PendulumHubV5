-- padero#0001
-- Script By: 123jl123 (fixed without external loadstring)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Torso = Character:WaitForChild("Torso")
local Head = Character:WaitForChild("Head")
local Humanoid = Character:WaitForChild("Humanoid")
local LeftArm = Character:WaitForChild("Left Arm")
local LeftLeg = Character:WaitForChild("Left Leg")
local RightArm = Character:WaitForChild("Right Arm")
local RightLeg = Character:WaitForChild("Right Leg")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local function Create(className)
	return function(props)
		local inst = Instance.new(className)
		local parent = props and props.Parent
		if props then
			for k, v in pairs(props) do
				if k ~= "Parent" then
					inst[k] = v
				end
			end
		end
		if parent then
			inst.Parent = parent
		end
		return inst
	end
end

local folder = game:GetObjects("rbxassetid://9208704446")[1]
folder.Parent = Character

for _, v in pairs(folder:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
	end
end

local EffectPack = folder.Extras:Clone()
folder.Extras:Destroy()

local ZTfade = false
local ZT = false
local OverClocking = false
local Jets = false
local MHIT = CFrame.new()
local Hold = false
local weps = false

local Anim = "Idle"
local inairvel = 0
local WalkAnimStep = 0
local sine = 0
local change = 1
local Animstep = 0
local WalkAnimMove = 0.1
local Combo = 0
local attack = false
local RJ = RootPart:FindFirstChild("RootJoint")
local Neck = Torso:FindFirstChild("Neck")
local visn = 0
local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local NeckCF = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
local IsXray = false
local spin = 1
local spinto = 1
local spinrad = 0

local forWFB = 0
local forWRL = 0

local FF = Instance.new("ForceField")
FF.Visible = false
FF.Name = "FatForce"
FF.Parent = Character

local Effects = Instance.new("Folder")
Effects.Name = "Effects"
Effects.Parent = Character

local it = Instance.new
local vt = Vector3.new
local cf = CFrame.new
local euler = CFrame.fromEulerAnglesXYZ
local angles = CFrame.Angles
local cn = CFrame.new
local mr = math.rad
local mememode = false
local IT = Instance.new
local CF = CFrame.new
local VT = Vector3.new
local RAD = math.rad
local C3 = Color3.new
local UD2 = UDim2.new
local BRICKC = BrickColor.new
local ANGLES = CFrame.Angles
local EULER = CFrame.fromEulerAnglesXYZ
local COS = math.cos
local ACOS = math.acos
local SIN = math.sin
local ASIN = math.asin
local ABS = math.abs
local MRANDOM = math.random
local FLOOR = math.floor

local function getAimPosition()
	if typeof(MHIT) == "CFrame" then
		return MHIT.Position
	elseif typeof(MHIT) == "Vector3" then
		return MHIT
	end
	return RootPart.Position + RootPart.CFrame.LookVector * 50
end

local lastid = "http://www.roblox.com/asset/?id=2984992418"
local s2 = it("Sound")
s2.EmitterSize = 30
s2.Parent = Torso
local CurId = 1
local s2c = s2:Clone()

local playsong = true
s2.SoundId = lastid
if playsong then
	s2:Play()
else
	s2:Stop()
end
local lastsongpos = 0

local crosshair = Instance.new("BillboardGui")
crosshair.Size = UDim2.new(10, 0, 10, 0)
crosshair.Enabled = false
crosshair.StudsOffset = Vector3.new(0, 0, -1)
crosshair.Parent = Character

local imgl = Instance.new("ImageLabel")
imgl.Position = UDim2.new(0, 0, 0, 0)
imgl.Size = UDim2.new(1, 0, 1, 0)
imgl.Image = "rbxassetid://578065407"
imgl.BackgroundTransparency = 1
imgl.ImageTransparency = 0.7
imgl.ImageColor3 = Color3.new(1, 1, 1)
imgl.Parent = crosshair

--//=================================\\
--||          LOCAL IDS
--\\=================================//

local GROWL = 1544355717
local ROAR = 528589382
local ECHOBLAST = 376976397
local CAST = 459523898
local ALCHEMY = 424195979
local BUILDUP = 698824317
local BIGBUILDUP = 874376217
local IMPACT = 231917744
local LARGE_EXPLOSION = 168513088
local TURNUP = 299058146

if Character:FindFirstChild("Animate") then
	Character.Animate:Destroy()
end

local function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10, 10, 10, 10
end

local CFuncs = {
	Part = {
		Create = function(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
			local Part = Create("Part")({
				Parent = Parent,
				Reflectance = Reflectance,
				Transparency = Transparency,
				CanCollide = false,
				Locked = true,
				BrickColor = BrickColor.new(tostring(BColor)),
				Name = Name,
				Size = Size,
				Material = Material,
			})
			RemoveOutlines(Part)
			return Part
		end,
	},
	Mesh = {
		Create = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
			local Msh = Create(Mesh)({
				Parent = Part,
				Offset = OffSet,
				Scale = Scale,
			})
			if Mesh == "SpecialMesh" then
				Msh.MeshType = MeshType
				Msh.MeshId = MeshId
			end
			return Msh
		end,
	},
	Weld = {
		Create = function(Parent, Part0, Part1, C0, C1)
			return Create("Weld")({
				Parent = Parent,
				Part0 = Part0,
				Part1 = Part1,
				C0 = C0,
				C1 = C1,
			})
		end,
	},
	Sound = {
		Create = function(id, par, vol, pit)
			task.spawn(function()
				local S = Create("Sound")({
					Volume = vol,
					Pitch = pit or 1,
					SoundId = "http://www.roblox.com/asset/?id=" .. tostring(id),
					Parent = par or workspace,
				})
				task.wait()
				S:Play()
				Debris:AddItem(S, 6)
			end)
		end,
	},
	ParticleEmitter = {
		Create = function(Parent, Color1, Color2, LightEmission, Size, Texture, Transparency, ZOffset, Accel, Drag, LockedToPart, VelocityInheritance, EmissionDirection, Enabled, LifeTime, Rate, Rotation, RotSpeed, Speed, VelocitySpread)
			return Create("ParticleEmitter")({
				Parent = Parent,
				Color = ColorSequence.new(Color1, Color2),
				LightEmission = LightEmission,
				Size = Size,
				Texture = Texture,
				Transparency = Transparency,
				ZOffset = ZOffset,
				Acceleration = Accel,
				Drag = Drag,
				LockedToPart = LockedToPart,
				VelocityInheritance = VelocityInheritance,
				EmissionDirection = EmissionDirection,
				Enabled = Enabled,
				Lifetime = LifeTime,
				Rate = Rate,
				Rotation = Rotation,
				RotSpeed = RotSpeed,
				Speed = Speed,
				VelocitySpread = VelocitySpread,
			})
		end,
	},
}

task.spawn(function()
	local face = Head:FindFirstChildOfClass("Decal")
	if face then
		face:Destroy()
	end
end)

task.spawn(function()
	local snd = Character:FindFirstChild("Sound")
	if snd then
		snd:Destroy()
	end
end)

--//=================================\\
--|| SAZERENOS ARTIFICIAL HEARTBEAT
--\\=================================//
local Frame_Speed = 1 / 30
local ArtificialHB = Instance.new("BindableEvent")
ArtificialHB.Name = "ArtificialHB"
ArtificialHB.Parent = script or Character

local frame = Frame_Speed
local tf = 0
local allowframeloss = false
local tossremainder = false
local lastframe = tick()
ArtificialHB:Fire()

RunService.Heartbeat:Connect(function(s)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			ArtificialHB:Fire()
			lastframe = tick()
		else
			for _ = 1, math.floor(tf / frame) do
				ArtificialHB:Fire()
			end
			lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

local function Swait(NUMBER)
	if NUMBER == nil or NUMBER <= 0 then
		ArtificialHB.Event:Wait()
	else
		for _ = 1, NUMBER do
			ArtificialHB.Event:Wait()
		end
	end
end

--[Functions]--
local function so(id, par, vol, pit)
	CFuncs.Sound.Create(id, par, vol, pit)
end

local function weld(parent, part0, part1, c0)
	local w = it("Weld")
	w.Parent = parent
	w.Part0 = part0
	w.Part1 = part1
	w.C0 = c0
	return w
end

local function joint(parent, part0, part1, c0)
	local m = it("Motor6D")
	m.Parent = parent
	m.Part0 = part0
	m.Part1 = part1
	m.C0 = c0
	return m
end

local function MakeJoint(parent, part0, part1, c0)
	return joint(parent, part0, part1, c0)
end

local ArmorParts = {}

local function WeldAllTo(Part1, Part2, scan, Extra)
	local EXCF = Part2.CFrame * Extra
	for _, v3 in pairs(scan:GetDescendants()) do
		if v3:IsA("BasePart") then
			weld(v3, v3, Part1, EXCF:ToObjectSpace(v3.CFrame):Inverse())
			v3.Anchored = false
			v3.Massless = true
			v3.CanCollide = false
			v3.Parent = Part1
			v3.Locked = true
			if not v3:FindFirstChild("Destroy") then
				table.insert(ArmorParts, {
					Part = v3,
					Par = v3.Parent,
					Col = v3.Color,
					Mat = v3.Material.Name,
				})
			else
				v3:Destroy()
			end
		end
	end
	Part1.Transparency = 1
end

local function JointAllTo(Part1, Part2, scan, Extra)
	local EXCF = Part2.CFrame * Extra
	for _, v3 in pairs(scan:GetDescendants()) do
		if v3:IsA("BasePart") then
			joint(v3, v3, Part1, EXCF:ToObjectSpace(v3.CFrame):Inverse())
			v3.Anchored = false
			v3.Massless = true
			v3.CanCollide = false
			v3.Parent = Part1
			v3.Locked = true
			local destroyFlag = v3:FindFirstChild("Destroy")
			if destroyFlag then
				destroyFlag:Destroy()
			end
		end
	end
	Part1.Transparency = 1
end

local function GatherAllInstances(Parent, ig)
	local Instances = {}
	local function GatherInstances(node)
		for _, v in pairs(node:GetChildren()) do
			if v ~= ig then
				GatherInstances(v)
				table.insert(Instances, v)
			end
		end
	end
	GatherInstances(Parent)
	return Instances
end

local function MakeCharacterVisible(char)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			if obj.Name ~= "HumanoidRootPart" then
				obj.Transparency = 0
			end
			obj.LocalTransparencyModifier = 0
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 0
		end
	end
end

MakeCharacterVisible(Character)

RunService.RenderStepped:Connect(function()
	if Character and Character.Parent then
		for _, obj in ipairs(Character:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
				obj.LocalTransparencyModifier = 0
			end
		end
	end
end)

local function WeldChildrenTo(Part1, Part2, Extra)
	local EXCF = Part2.CFrame * Extra
	for _, v3 in pairs(GatherAllInstances(Part2)) do
		if v3:IsA("BasePart") then
			weld(v3, v3, Part1, EXCF:ToObjectSpace(v3.CFrame):Inverse())
			v3.Anchored = false
			v3.CanCollide = false
			v3.Parent = Part1
		end
	end
	Part2:Destroy()
end

-- Armor attachments
local ChestPart = EffectPack.Part:Clone()
ChestPart.Parent = Character
ChestPart.Name = "H1a"
local H1a = weld(Torso, Torso, ChestPart, cf(0, 0.5, -0.4))

local MissileBox = EffectPack.Part:Clone()
MissileBox.Parent = Character
MissileBox.Name = "MissileBox"
local MX1w = weld(Torso, Torso, MissileBox, cf(0, -0.7, -0.25))

local MiniGun = EffectPack.Part:Clone()
MiniGun.Parent = Character
MiniGun.Name = "MiniGun"
local FlameW = weld(RightArm, RightArm, MiniGun, cf(0, 0, 0))

local SpinnyThingy = EffectPack.Part:Clone()
SpinnyThingy.Parent = Character
SpinnyThingy.Name = "SpinnyThingy"
local SpinnyThingyWeld = weld(folder.Armor.MiniGun.SpinPos, folder.Armor.MiniGun.SpinPos, SpinnyThingy, cf(0, 0, 0))

local Finger1 = EffectPack.Part:Clone()
Finger1.Parent = Character
Finger1.Name = "RightLow1"
local Fg1 = weld(RightArm, RightArm, Finger1, cf(0, 0, 0))

local Finger2 = EffectPack.Part:Clone()
Finger2.Parent = Character
Finger2.Name = "RightLow2"
local Fg2 = weld(RightArm, RightArm, Finger2, cf(0, 0, 0))

local Finger3 = EffectPack.Part:Clone()
Finger3.Parent = Character
Finger3.Name = "RightLow3"
local Fg3 = weld(RightArm, RightArm, Finger3, cf(0, 0, 0))

local Finger4 = EffectPack.Part:Clone()
Finger4.Parent = Character
Finger4.Name = "RightLow4"
local Fg4 = weld(RightArm, RightArm, Finger4, cf(0, 0, 0))

local Boot1 = EffectPack.Part:Clone()
Boot1.Parent = Character
Boot1.Name = "RightFrontBoot"
local RB1 = weld(RightLeg, RightLeg, Boot1, cf(0, 0, 0))

local Boot2 = EffectPack.Part:Clone()
Boot2.Parent = Character
Boot2.Name = "RightBackBoot"
local RB2 = weld(RightLeg, RightLeg, Boot2, cf(0, 0, 0))

local Boot3 = EffectPack.Part:Clone()
Boot3.Parent = Character
Boot3.Name = "LeftFrontBoot"
local LB1 = weld(LeftLeg, LeftLeg, Boot3, cf(0, 0, 0))

local Boot4 = EffectPack.Part:Clone()
Boot4.Parent = Character
Boot4.Name = "LeftBackBoot"
local LB2 = weld(LeftLeg, LeftLeg, Boot4, cf(0, 0, 0))

local LHP = EffectPack.Part:Clone()
LHP.Parent = Character
LHP.Name = "LeftHand"
local LHP2 = weld(LeftArm, LeftArm, LHP, cf(0, 0, 0))

for _, v in pairs(folder.Armor:GetChildren()) do
	if v:IsA("Model") then
		local charPart = Character:FindFirstChild(v.Name)
		if charPart and v:FindFirstChild("Handle") then
			WeldAllTo(charPart, v.Handle, v, CFrame.new(0, 0, 0))
		end
	end
end

local function rayCast(Pos, Dir, Max, Ignore)
	return workspace:FindPartOnRay(Ray.new(Pos, Dir.Unit * (Max or 999.999)), Ignore)
end

local function SetTween(SPart, CFr, MoveStyle2, outorin2, AnimTime)
	if not SPart or not SPart.Parent then
		return
	end
	local MoveStyle = Enum.EasingStyle[MoveStyle2] or Enum.EasingStyle.Quad
	local outorin = Enum.EasingDirection[outorin2] or Enum.EasingDirection.Out

	local dahspeed = 1
	if attack and mememode then
		dahspeed = 5
	end
	if SPart.Name == "Bullet" then
		dahspeed = 1
	end

	local tweeningInformation = TweenInfo.new(
		math.max(AnimTime / dahspeed, 0),
		MoveStyle,
		outorin,
		0,
		false,
		0
	)
	local tweenanim = TweenService:Create(SPart, tweeningInformation, CFr)
	tweenanim:Play()
end

local SToneTexture = Create("Texture")({
	Texture = "http://www.roblox.com/asset/?id=1693385655",
	Color3 = Color3.new(17 / 255, 17 / 255, 17 / 255),
})

local function AddStoneTexture(part)
	task.spawn(function()
		for i = 0, 6, 1 do
			local Tx = SToneTexture:Clone()
			Tx.Face = i
			Tx.Parent = part
		end
	end)
end

local function New(Object, Parent, Name, Data)
	local obj = Instance.new(Object)
	for Index, Value in pairs(Data or {}) do
		obj[Index] = Value
	end
	obj.Parent = Parent
	obj.Name = Name
	return obj
end

local TRAN_MAP = {
	["1"] = "a", ["2"] = "b", ["3"] = "c", ["4"] = "d", ["5"] = "e", ["6"] = "f",
	["7"] = "g", ["8"] = "h", ["9"] = "i", ["10"] = "j", ["11"] = "k", ["12"] = "l",
	["13"] = "m", ["14"] = "n", ["15"] = "o", ["16"] = "p", ["17"] = "q", ["18"] = "r",
	["19"] = "s", ["20"] = "t", ["21"] = "u", ["22"] = "v", ["23"] = "w", ["24"] = "x",
	["25"] = "y", ["26"] = "z", ["27"] = "_", ["28"] = "0", ["29"] = "1", ["30"] = "2",
	["31"] = "3", ["32"] = "4", ["33"] = "5", ["34"] = "6", ["35"] = "7", ["36"] = "8",
	["37"] = "9",
}

local function Tran(Num)
	return TRAN_MAP[tostring(Num)] or ""
end

local function MaybeOk(Mode, Extra)
	if Mode == 1 then
		local GivenText = ""
		local msg = tostring(Extra or "")
		local LastFound = 1
		for v3 = 1, #msg do
			if string.sub(msg, v3, v3) == "," then
				local token = string.sub(msg, LastFound, v3 - 1)
				GivenText = GivenText .. Tran(token)
				LastFound = v3 + 1
			end
		end
		return GivenText
	elseif Mode == 2 then
		print("fat")
	end
	return ""
end

local function CreateMesh2(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local NEWMESH = IT(MESH)
	if MESH == "SpecialMesh" then
		NEWMESH.MeshType = MESHTYPE
		if MESHID ~= "nil" and MESHID ~= "" then
			NEWMESH.MeshId = "http://www.roblox.com/asset/?id=" .. MESHID
		end
		if TEXTUREID ~= "nil" and TEXTUREID ~= "" then
			NEWMESH.TextureId = "http://www.roblox.com/asset/?id=" .. TEXTUREID
		end
	end
	NEWMESH.Offset = OFFSET or VT(0, 0, 0)
	NEWMESH.Scale = SCALE
	NEWMESH.Parent = PARENT
	return NEWMESH
end

local function CreatePart2(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
	local NEWPART = IT("Part")
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.Anchored = (ANCHOR ~= false)
	NEWPART.BrickColor = BRICKC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = Torso.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

local S = IT("Sound")
local function CreateSound2(ID, PARENT, VOLUME, PITCH, DOESLOOP)
	local NEWSOUND
	task.spawn(function()
		NEWSOUND = S:Clone()
		NEWSOUND.Parent = PARENT
		NEWSOUND.Volume = VOLUME
		NEWSOUND.Pitch = PITCH
		NEWSOUND.SoundId = "http://www.roblox.com/asset/?id=" .. tostring(ID)
		NEWSOUND:Play()
		if DOESLOOP then
			NEWSOUND.Looped = true
		else
			repeat
				task.wait()
			until not NEWSOUND.Playing
			NEWSOUND:Destroy()
		end
	end)
	return NEWSOUND
end

local function WACKYEFFECT(Table)
	local TYPE = Table.EffectType or "Sphere"
	local SIZE = Table.Size or VT(1, 1, 1)
	local ENDSIZE = Table.Size2 or VT(0, 0, 0)
	local TRANSPARENCY = Table.Transparency or 0
	local ENDTRANSPARENCY = Table.Transparency2 or 1
	local CFRAME = Table.CFrame or Torso.CFrame
	local MOVEDIRECTION = Table.MoveToPos
	local ROTATION1 = Table.RotationX or 0
	local ROTATION2 = Table.RotationY or 0
	local ROTATION3 = Table.RotationZ or 0
	local MATERIAL = Table.Material or "Neon"
	local COLOR = Table.Color or C3(1, 1, 1)
	local TIME = Table.Time or 45
	local SOUNDID = Table.SoundID
	local SOUNDPITCH = Table.SoundPitch
	local SOUNDVOLUME = Table.SoundVolume

	task.spawn(function()
		local PLAYSSOUND = false
		local SOUND
		local EFFECT = CreatePart2(3, Effects, MATERIAL, 0, TRANSPARENCY, BRICKC("Pearl"), "Effect", VT(1, 1, 1), true)
		if SOUNDID ~= nil and SOUNDPITCH ~= nil and SOUNDVOLUME ~= nil then
			PLAYSSOUND = true
			SOUND = CreateSound2(SOUNDID, EFFECT, SOUNDVOLUME, SOUNDPITCH, false)
		end
		EFFECT.Color = COLOR
		local MSH
		if TYPE == "Sphere" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "Sphere", "", "", SIZE, VT(0, 0, 0))
		elseif TYPE == "Cylinder" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "Cylinder", "", "", SIZE, VT(0, 0, 0))
		elseif TYPE == "Block" or TYPE == "Cube" then
			MSH = IT("BlockMesh")
			MSH.Scale = VT(SIZE.X, SIZE.X, SIZE.X)
			MSH.Parent = EFFECT
		elseif TYPE == "Wave" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "20329976", "", SIZE, VT(0, 0, -SIZE.X / 8))
		elseif TYPE == "Ring" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "559831844", "", VT(SIZE.X, SIZE.X, 0.1), VT(0, 0, 0))
		elseif TYPE == "Slash" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "662586858", "", VT(SIZE.X / 10, 0, SIZE.X / 10), VT(0, 0, 0))
		elseif TYPE == "Round Slash" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "662585058", "", VT(SIZE.X / 10, 0, SIZE.X / 10), VT(0, 0, 0))
		elseif TYPE == "Swirl" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "1051557", "", SIZE, VT(0, 0, 0))
		elseif TYPE == "Skull" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "4770583", "", SIZE, VT(0, 0, 0))
		elseif TYPE == "Crystal" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "9756362", "", SIZE, VT(0, 0, 0))
		elseif TYPE == "Crown" then
			MSH = CreateMesh2("SpecialMesh", EFFECT, "FileMesh", "173770780", "", SIZE, VT(0, 0, 0))
		end

		if MSH ~= nil then
			local GROWTH = SIZE - ENDSIZE
			local TRANS = TRANSPARENCY - ENDTRANSPARENCY
			if TYPE == "Block" then
				SetTween(EFFECT, { CFrame = CFRAME * ANGLES(RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360))) }, "Linear", "InOut", TIME / 60)
			else
				SetTween(EFFECT, { CFrame = CFRAME }, "Linear", "InOut", 0)
			end

			task.wait()
			SetTween(EFFECT, { Transparency = EFFECT.Transparency - TRANS }, "Linear", "InOut", TIME / 60)

			if TYPE == "Block" then
				SetTween(EFFECT, { CFrame = CFRAME * ANGLES(RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360)), RAD(MRANDOM(0, 360))) }, "Linear", "InOut", 0)
			else
				SetTween(EFFECT, { CFrame = EFFECT.CFrame * ANGLES(RAD(ROTATION1), RAD(ROTATION2), RAD(ROTATION3)) }, "Linear", "InOut", 0)
			end

			if MOVEDIRECTION ~= nil then
				local ORI = EFFECT.Orientation
				SetTween(EFFECT, { CFrame = CF(MOVEDIRECTION) }, "Linear", "InOut", TIME / 60)
				SetTween(EFFECT, { Orientation = ORI }, "Linear", "InOut", TIME / 60)
			end

			MSH.Scale = MSH.Scale - GROWTH / TIME
			SetTween(MSH, { Scale = ENDSIZE }, "Linear", "InOut", TIME / 60)
			if TYPE == "Wave" then
				SetTween(MSH, { Offset = VT(0, 0, -MSH.Scale.X / 8) }, "Linear", "InOut", TIME / 60)
			end

			for _ = 1, TIME + 1 do
				task.wait(0.05)
			end
		end

		Debris:AddItem(EFFECT, 15)
		if not PLAYSSOUND then
			EFFECT:Destroy()
		elseif SOUND then
			SOUND.Stopped:Connect(function()
				EFFECT:Destroy()
			end)
		end
	end)
end

local function CreatePart(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
	local Part = Create("Part")({
		Parent = Parent,
		Reflectance = Reflectance,
		Transparency = Transparency,
		CanCollide = false,
		Locked = true,
		BrickColor = BrickColor.new(tostring(BColor)),
		Name = Name,
		Size = Size,
		Material = Material,
	})
	RemoveOutlines(Part)
	return Part
end

--[Particles]--
local Particle2_1 = Create("ParticleEmitter")({
	Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(170 / 255, 255 / 255, 255 / 255)),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.75, 0.4),
		NumberSequenceKeypoint.new(1, 1),
	}),
	Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 0),
	}),
	Texture = "rbxassetid://241922778",
	Lifetime = NumberRange.new(0.55, 0.95),
	Rate = 100,
	VelocitySpread = 180,
	Rotation = NumberRange.new(0),
	RotSpeed = NumberRange.new(-200, 200),
	Speed = NumberRange.new(8.0),
	LightEmission = 1,
	LockedToPart = false,
	Acceleration = Vector3.new(0, 0, 0),
	EmissionDirection = Enum.NormalId.Top,
	Drag = 4,
	Enabled = false,
})

local BEGONE_Particle = Create("ParticleEmitter")({
	Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.1, 0),
		NumberSequenceKeypoint.new(0.3, 0),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	}),
	Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.15, 1.5),
		NumberSequenceKeypoint.new(0.75, 1.5),
		NumberSequenceKeypoint.new(1, 0),
	}),
	Texture = "rbxassetid://936193661",
	Lifetime = NumberRange.new(1.5),
	Rate = 100,
	VelocitySpread = 0,
	Rotation = NumberRange.new(0),
	RotSpeed = NumberRange.new(-10, 10),
	Speed = NumberRange.new(0),
	LightEmission = 0.25,
	LockedToPart = true,
	Acceleration = Vector3.new(0, 0, 0),
	EmissionDirection = Enum.NormalId.Top,
	Drag = 4,
	ZOffset = 1,
	Enabled = false,
})

local function Lightning(Part0, Part1, Times, Offset, Color, Thickness, Trans, SizeAdd, Time, Dely)
	local dur = Time or 0.5
	task.spawn(function()
		local magz = (Part0 - Part1).Magnitude
		local curpos = Part0
		local trz = { -Offset, Offset }
		for i = 1, Times do
			local li = Instance.new("Part")
			li.Name = "Lightning"
			li.TopSurface = 0
			li.Material = Enum.Material.Neon
			li.BottomSurface = 0
			li.Anchored = true
			li.Locked = true
			li.Transparency = Trans or 0
			li.BrickColor = Color
			li.CanCollide = false
			li.Size = Vector3.new(0, 0, magz / Times)
			li.Parent = Torso

			local Offzet = Vector3.new(trz[math.random(1, 2)], trz[math.random(1, 2)], trz[math.random(1, 2)])
			local trolpos = CFrame.new(curpos, Part1) * CFrame.new(0, 0, magz / Times).Position + Offzet

			if Times == i then
				local magz2 = (curpos - Part1).Magnitude
				li.Size = Vector3.new(0, 0, magz2)
				SetTween(li, { Size = VT(Thickness * (1 - (i / Times + 0.1)), Thickness * (1 - (i / Times + 0.1)), magz2), Transparency = 1 }, "Back", "Out", dur)
				li.CFrame = CFrame.new(curpos, Part1) * CFrame.new(0, 0, -magz2 / 2)
			else
				li.CFrame = CFrame.new(curpos, trolpos) * CFrame.new(0, 0, magz / Times / 2)
				SetTween(li, { Size = VT(Thickness * (1 - (i / Times)), Thickness * (1 - (i / Times)), magz / Times), Transparency = 1 }, "Back", "Out", dur)
			end

			curpos = li.CFrame * CFrame.new(0, 0, magz / Times / 2).Position
			task.delay(dur, function()
				if li and li.Parent then
					li:Destroy()
				end
			end)

			if Dely ~= nil then
				Swait(Dely)
			end
		end
	end)
end

local function MakeForm(PART, TYPE)
	if TYPE == "Cyl" then
		local MSH = IT("CylinderMesh")
		MSH.Parent = PART
	elseif TYPE == "Ball" then
		local MSH = IT("SpecialMesh")
		MSH.MeshType = Enum.MeshType.Sphere
		MSH.Parent = PART
	elseif TYPE == "Wedge" then
		local MSH = IT("SpecialMesh")
		MSH.MeshType = Enum.MeshType.Wedge
		MSH.Parent = PART
	end
end

local function Raycast(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
	return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.Unit * RANGE), IGNOREDECENDANTS)
end

local function CastProperRay(StartPos, EndPos, Distance, Ignore)
	local DIRECTION = CF(StartPos, EndPos).LookVector
	return Raycast(StartPos, DIRECTION, Distance, Ignore)
end

local function ShowDamage(Pos, Text, Time, Color)
	local Rate = 1 / 30
	local pos = Pos or Vector3.new(0, 0, 0)
	local text = Text or ""
	local dur = Time or 2
	local col = Color or Color3.new(1, 0, 1)

	local EffectPart = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 1, BrickColor.new(col), "Effect", Vector3.new(0, 0, 0))
	EffectPart.Anchored = true
	local BillboardGui = Create("BillboardGui")({ Size = UDim2.new(2, 0, 2, 0), Adornee = EffectPart, Parent = EffectPart })
	local TextLabel = Create("TextLabel")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "DMG: " .. tostring(text),
		TextColor3 = col,
		TextScaled = true,
		Font = Enum.Font.ArialBold,
		Parent = BillboardGui,
	})
	TextLabel.TextTransparency = 1
	Debris:AddItem(EffectPart, dur + 0.1)

	task.spawn(function()
		local Frames = dur / Rate
		EffectPart.CFrame = CFrame.new(pos)
		task.wait()
		TextLabel.TextTransparency = 0
		SetTween(TextLabel, { TextTransparency = 1 }, "Quad", "In", Frames / 60)
		SetTween(TextLabel, { Rotation = math.random(-25, 25) }, "Elastic", "InOut", Frames / 60)
		SetTween(TextLabel, { TextColor3 = Color3.new(1, 0, 0) }, "Elastic", "InOut", Frames / 60)
		SetTween(EffectPart, { CFrame = CFrame.new(pos) + Vector3.new(math.random(-5, 5), math.random(1, 5), math.random(-5, 5)) }, "Linear", "InOut", Frames / 60)
		task.wait(Frames / 60)
		if EffectPart and EffectPart.Parent then
			EffectPart:Destroy()
		end
	end)
end

local function Damagefunc(Part, hit, minim, maxim, knockback, Type, Property, Delay, HitSound, HitPitch)
	if not hit or not hit.Parent then
		return
	end
	local h = hit.Parent:FindFirstChildOfClass("Humanoid")
	for _, v in pairs(hit.Parent:GetChildren()) do
		if v:IsA("Humanoid") and v.Health > 0.0001 then
			h = v
		end
	end

	if not h or h.Health < 0.001 or h.Parent:FindFirstChild("Fly away") then
		return
	end

	task.spawn(function()
		local targetTorso = h.Parent:FindFirstChild("Torso") or h.Parent:FindFirstChild("UpperTorso")
		if h.Health > 9999999 and minim < 9999 and Type ~= "IgnoreType" and targetTorso and not h.Parent:FindFirstChild("Fly away") then
			local FATag = Instance.new("Model")
			FATag.Name = "Fly away"
			FATag.Parent = h.Parent
			Debris:AddItem(FATag, 2.5)
			task.wait(0.25)

			local YourGone = Instance.new("Part")
			YourGone.Reflectance = 0
			YourGone.Transparency = 1
			YourGone.CanCollide = false
			YourGone.Locked = true
			YourGone.Anchored = true
			YourGone.BrickColor = BrickColor.new("Really blue")
			YourGone.Name = "YourGone"
			YourGone.Size = Vector3.new()
			YourGone.Material = Enum.Material.SmoothPlastic
			YourGone:BreakJoints()
			YourGone.Parent = targetTorso
			YourGone.CFrame = targetTorso.CFrame

			local NewParticle = Instance.new("ParticleEmitter")
			NewParticle.Parent = YourGone
			NewParticle.Acceleration = Vector3.new(0, 0, 0)
			NewParticle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 10), NumberSequenceKeypoint.new(1, 0) })
			NewParticle.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(1, 0, 0))
			NewParticle.Lifetime = NumberRange.new(0.55, 0.95)
			NewParticle.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0),
				NumberSequenceKeypoint.new(1, 1),
			})
			NewParticle.Speed = NumberRange.new(0, 0)
			NewParticle.ZOffset = 2
			NewParticle.Texture = "rbxassetid://243660364"
			NewParticle.RotSpeed = NumberRange.new(0, 0)
			NewParticle.Rotation = NumberRange.new(-180, 180)
			NewParticle.Enabled = false
			Debris:AddItem(YourGone, 3)

			for _ = 0, 2, 1 do
				NewParticle:Emit(1)
				so("1448044156", targetTorso, 2, 1)
				YourGone.CFrame = targetTorso.CFrame
				task.wait(0.2)
			end
			task.wait(0.1)
			NewParticle:Emit(3)
			so("1448044156", targetTorso, 2, 0.8)
			YourGone.CFrame = targetTorso.CFrame
		end
	end)

	if hit.Parent ~= Character and (hit.Parent:FindFirstChild("Torso") or hit.Parent:FindFirstChild("UpperTorso")) ~= nil then
		local deb = hit.Parent:FindFirstChild("DebounceHit")
		if deb and deb:IsA("BoolValue") and deb.Value == true then
			return
		end

		local c = Create("ObjectValue")({ Name = "creator", Value = Player, Parent = h })
		Debris:AddItem(c, 0.5)

		if HitSound ~= nil and HitPitch ~= nil then
			so(HitSound, hit, 1, HitPitch)
		end

		local Damage = math.random(minim or 1, maxim or minim or 1)
		local blocked = false
		local block = hit.Parent:FindFirstChild("Block")
		if block and block:IsA("IntValue") and block.Value > 0 then
			blocked = true
			block.Value = block.Value - 1
		end

		if not blocked then
			ShowDamage(Part.CFrame * CFrame.new(0, 0, Part.Size.Z / 2).Position + Vector3.new(0, 1.5, 0), Damage, 1.5, Color3.new(0, 0, 0))
		else
			ShowDamage(Part.CFrame * CFrame.new(0, 0, Part.Size.Z / 2).Position + Vector3.new(0, 1.5, 0), Damage / 2, 1.5, Color3.new(0, 0, 0))
		end

		if Type == "Knockdown" or Type == "Knockdown2" or Type == "HPSteal" then
			if Type == "Knockdown2" or Type == "HPSteal" then
				Combo = 1
			end
			task.delay(0.2, function()
				-- placeholder for knockdown state
			end)
		elseif Type == "Fire" then
			local HTorso = hit.Parent:FindFirstChild("Torso") or hit.Parent:FindFirstChild("UpperTorso")
			if HTorso then
				local tags = 0
				for _, v2 in ipairs(HTorso:GetChildren()) do
					if v2:IsA("Folder") and v2.Name == "OnFire" then
						tags += 1
					end
				end
				if tags < 2 then
					local fireef = EffectPack.FireEffect:Clone()
					local tag = Instance.new("Folder")
					tag.Name = "OnFire"
					tag.Parent = HTorso
					Debris:AddItem(tag, 4.5)

					for _, v in ipairs(fireef:GetDescendants()) do
						if v:IsA("ParticleEmitter") or v:IsA("SpotLight") then
							Debris:AddItem(v, 5)
							v.Parent = HTorso
							task.spawn(function()
								for _ = 1, 35 do
									if v:IsA("ParticleEmitter") then
										v:Emit(2)
									end
									Damagefunc(HTorso, HTorso, 2, 3, 0, "Normal", RootPart, 0.1, "1273118342", math.random(10, 30) / 10)
									local humCheck = HTorso.Parent and HTorso.Parent:FindFirstChildOfClass("Humanoid")
									if not humCheck or humCheck.Health <= 0.01 then
										break
									end
									task.wait(0.1)
								end
							end)
						end
					end
					fireef:Destroy()
				end
			end
		elseif Type == "Instakill" then
			task.spawn(function()
				local targetTorso = h.Parent:FindFirstChild("Torso") or h.Parent:FindFirstChild("UpperTorso")
				if targetTorso and not h.Parent:FindFirstChild("Fly away") then
					local FATag = Instance.new("Model")
					FATag.Name = "Fly away"
					FATag.Parent = h.Parent
					Debris:AddItem(FATag, 2.5)
					task.wait(0.25)

					local YourGone = Instance.new("Part")
					YourGone.Reflectance = 0
					YourGone.Transparency = 1
					YourGone.CanCollide = false
					YourGone.Locked = true
					YourGone.Anchored = true
					YourGone.BrickColor = BrickColor.new("Really blue")
					YourGone.Name = "YourGone"
					YourGone.Size = Vector3.new()
					YourGone.Material = Enum.Material.SmoothPlastic
					YourGone:BreakJoints()
					YourGone.Parent = targetTorso
					YourGone.CFrame = targetTorso.CFrame

					local NewParticle = Instance.new("ParticleEmitter")
					NewParticle.Parent = YourGone
					NewParticle.Acceleration = Vector3.new(0, 0, 0)
					NewParticle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 10), NumberSequenceKeypoint.new(1, 0) })
					NewParticle.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(1, 0, 0))
					NewParticle.Lifetime = NumberRange.new(0.55, 0.95)
					NewParticle.Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.25, 0),
						NumberSequenceKeypoint.new(1, 1),
					})
					NewParticle.Speed = NumberRange.new(0, 0)
					NewParticle.ZOffset = 2
					NewParticle.Texture = "rbxassetid://243660364"
					NewParticle.RotSpeed = NumberRange.new(0, 0)
					NewParticle.Rotation = NumberRange.new(-180, 180)
					NewParticle.Enabled = false
					Debris:AddItem(YourGone, 3)

					for _ = 0, 2, 1 do
						NewParticle:Emit(1)
						so("1448044156", targetTorso, 2, 1)
						YourGone.CFrame = targetTorso.CFrame
						task.wait(0.2)
					end
					task.wait(0.1)
					NewParticle:Emit(3)
					so("1448044156", targetTorso, 2, 0.8)
					YourGone.CFrame = targetTorso.CFrame
				end
			end)
		elseif Type == "Impale" then
			CFuncs.Sound.Create("268249319", hit, 0.8, 2)
			task.wait(1)
		elseif Type == "Freeze2" then
			task.delay(1.5, function()
				-- placeholder for unfreeze
			end)
		end

		local debounce = Create("BoolValue")({ Name = "DebounceHit", Parent = hit.Parent, Value = true })
		Debris:AddItem(debounce, Delay or 0.1)
	end
end

local function MagniDamage(Part, magni, mindam, maxdam, knock, Type2)
	local Type = mememode and "Instakill" or Type2
	if Type2 == "NormalKnockdown" then
		Type = "Knockdown"
	end

	for _, c in pairs(workspace:GetChildren()) do
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum then
			local head = c:FindFirstChild("Head")
			if head and c.Name ~= Player.Name then
				local mag = (head.Position - Part.Position).Magnitude
				if mag <= magni then
					Damagefunc(Part, head, mindam, maxdam, knock, Type, RootPart, 0.1, "851453784", 1.2)
				end
			end
		end
	end
end

local function CFMagniDamage(HTCF, magni, mindam, maxdam, knock, Type)
	local DGP = Instance.new("Part")
	DGP.Parent = Character
	DGP.Size = Vector3.new(0.05, 0.05, 0.05)
	DGP.Transparency = 1
	DGP.CanCollide = false
	DGP.Anchored = true
	DGP.Archivable = false
	RemoveOutlines(DGP)
	DGP.CFrame = HTCF

	task.spawn(function()
		MagniDamage(DGP, magni, mindam, maxdam, knock, Type)
	end)
	Debris:AddItem(DGP, 0.05)
end

local function findNearestTorso(pos, dist1)
	local torso
	local dist = dist1 or 1000
	for _, temp2 in ipairs(workspace:GetChildren()) do
		if temp2:IsA("Model") and temp2 ~= Character then
			local temp = temp2:FindFirstChild("Torso") or temp2:FindFirstChild("UpperTorso")
			local human = temp2:FindFirstChildOfClass("Humanoid")
			if temp and human and human.Health > 0 then
				local d = (temp.Position - pos).Magnitude
				if d < dist then
					torso = temp
					dist = d
				end
			end
		end
	end
	return torso
end

local function BulletHitEffectSpawn(EffectCF, EffectName)
	local MainEffectHolder = Instance.new("Part")
	MainEffectHolder.Reflectance = 0
	MainEffectHolder.Transparency = 1
	MainEffectHolder.CanCollide = false
	MainEffectHolder.Locked = true
	MainEffectHolder.Anchored = true
	MainEffectHolder.BrickColor = BrickColor.new("Bright green")
	MainEffectHolder.Name = "Bullet"
	MainEffectHolder.Size = Vector3.new(0.05, 0.05, 0.05)
	MainEffectHolder.Material = Enum.Material.Neon
	MainEffectHolder:BreakJoints()
	MainEffectHolder.CFrame = EffectCF
	MainEffectHolder.Parent = Effects

	local EffectAttach = Instance.new("Attachment")
	EffectAttach.Parent = MainEffectHolder
	Debris:AddItem(MainEffectHolder, 15)

	if EffectName == "Explode" then
		EffectAttach.Orientation = Vector3.new(90, 0, 0)
		local p1 = EffectPack.Explode_Fire_Effect:Clone()
		p1.Parent = MainEffectHolder
		p1:Emit(150)

		local p2 = EffectPack.Explode_Smoke2_Effect:Clone()
		p2.Parent = MainEffectHolder
		p2:Emit(25)

		local p3 = EffectPack.Explode_Smoke_Effect:Clone()
		p3.Parent = MainEffectHolder
		p3:Emit(185)
		Debris:AddItem(MainEffectHolder, 2)
	elseif EffectName == "Spark" then
		EffectAttach.Orientation = Vector3.new(90, 0, 0)
		local p1 = EffectPack.Spark:Clone()
		p1.Parent = MainEffectHolder
		p1:Emit(math.random(2, 5))
		Debris:AddItem(MainEffectHolder, 2)
	elseif EffectName == "Nuke" then
		so(923073285, MainEffectHolder, 8, 2)
		EffectAttach.Orientation = Vector3.new(0, 0, 0)
		local EffectAttach2 = Instance.new("Attachment")
		EffectAttach2.Orientation = Vector3.new(0, 0, 0)
		EffectAttach2.Parent = MainEffectHolder

		local p1 = EffectPack.Nuke_Flash:Clone()
		p1.Parent = EffectAttach
		p1:Emit(20)

		local p2 = EffectPack.Nuke_Smoke:Clone()
		p2.Parent = EffectAttach2
		p2.Enabled = true
		task.spawn(function()
			for i = 0, 2, 0.025 / 1.5 do
				p2.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.15, 0.5 + (i / 4)),
					NumberSequenceKeypoint.new(0.95, 0.5 + (i / 4)),
					NumberSequenceKeypoint.new(1, 1),
				})
				Swait()
			end
			p2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1) })
			p2.Enabled = false
		end)

		local p3 = EffectPack.Nuke_Wave:Clone()
		p3.Parent = EffectAttach
		p3:Emit(185)
		Debris:AddItem(EffectAttach, 10)
	end
end

local function ProjectileDmg(MinDmg1, MaxDmg1, Lookpos1, Lookray1, Aura1, Type, Partf)
	if Lookray1 ~= nil and Lookray1.Parent and Lookray1.Parent:FindFirstChildOfClass("Humanoid") then
		task.spawn(function()
			Damagefunc(Partf, Lookray1, MinDmg1, MaxDmg1, MinDmg1, Type, RootPart, 0.1, "851453784", 1.2)
		end)
	else
		CFMagniDamage(CF(Lookpos1), Aura1, MinDmg1, MaxDmg1, MinDmg1, Type)
	end
end

local function FireSoul(SpawnCF)
	local GhostHolder = EffectPack.Missile:Clone()
	GhostHolder.Parent = Effects
	GhostHolder.CFrame = SpawnCF

	for _, v3 in pairs(GatherAllInstances(GhostHolder)) do
		if v3:IsA("ParticleEmitter") then
			v3.Enabled = true
		end
	end

	task.spawn(function()
		local thrust = GhostHolder:FindFirstChild("Rocket Thrust Loop")
		if thrust then
			thrust:Play()
		end
	end)

	so(771710614, GhostHolder, 1, 1)
	task.wait()
	Debris:AddItem(GhostHolder, 60)
	GhostHolder.Transparency = 0

	task.spawn(function()
		while GhostHolder.Parent == Effects do
			local GhostTarget = findNearestTorso(GhostHolder.Position)
			if GhostTarget ~= nil then
				if not OverClocking then
					SetTween(GhostHolder, {
						CFrame = CFrame.new(
							GhostHolder.Position + GhostHolder.CFrame.LookVector * 20,
							(GhostTarget.Position + GhostHolder.CFrame.LookVector * 30) - VT(math.random(-10, 10), math.random(-15, 15), math.random(-10, 10))
						),
					}, "Linear", "Out", 0.2)
				else
					SetTween(GhostHolder, {
						CFrame = CFrame.new(
							GhostHolder.Position + GhostHolder.CFrame.LookVector * 20,
							GhostTarget.Position + GhostHolder.CFrame.LookVector * 21
						),
					}, "Linear", "Out", 0.1)
				end
			else
				SetTween(GhostHolder, {
					CFrame = CFrame.new(
						GhostHolder.Position + GhostHolder.CFrame.LookVector * 20,
						GhostHolder.Position + VT(0, -1, 0) + GhostHolder.CFrame.LookVector * 30
					),
				}, "Linear", "Out", 0.2)
			end

			local Lookray, Lookpos, test1 = rayCast(GhostHolder.Position, GhostHolder.CFrame.LookVector, 10, Character)
			if Lookray ~= nil then
				so(2814355743, GhostHolder, 3, 2)
				BulletHitEffectSpawn(CF(Lookpos, Lookpos + (test1 or Vector3.new())), "Explode")
				ProjectileDmg(50, 65, Lookpos, nil, 45, "Knockdown", GhostHolder)

				local thrust = GhostHolder:FindFirstChild("Rocket Thrust Loop")
				if thrust then
					thrust:Stop()
				end

				for _, v3 in pairs(GatherAllInstances(GhostHolder)) do
					if v3:IsA("ParticleEmitter") then
						v3.Enabled = false
					end
				end

				SetTween(GhostHolder, { Transparency = 1 }, "Quad", "Out", 1)
				Debris:AddItem(GhostHolder, 2)
				break
			end
			Swait()
		end
	end)
end

-- Limbs setup
local RJW = weld(RJ.Parent, RJ.Part0, RJ.Part1, RJ.C0)
RJW.C1 = RJ.C1
RJW.Name = RJ.Name

local NeckW = weld(Neck.Parent, Neck.Part0, Neck.Part1, Neck.C0)
NeckW.C1 = Neck.C1
NeckW.Name = Neck.Name

local RW = weld(Torso, Torso, RightArm, cf(0, 0, 0))
local LW = weld(Torso, Torso, LeftArm, cf(0, 0, 0))
local RH = weld(Torso, Torso, RightLeg, cf(0, 0, 0))
local LH = weld(Torso, Torso, LeftLeg, cf(0, 0, 0))

RW.C1 = cn(0, 0.5, 0)
LW.C1 = cn(0, 0.5, 0)
RH.C1 = cn(0, 1, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
LH.C1 = cn(0, 1, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) }, "Quad", "InOut", 0.1)
SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) }, "Quad", "InOut", 0.1)
SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) }, "Quad", "InOut", 0.1)
SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) }, "Quad", "InOut", 0.1)
SetTween(RH, { C0 = CFrame.new(0.5, -0.90, 0) }, "Quad", "InOut", 0.1)
SetTween(LH, { C0 = CFrame.new(-0.5, -0.90, 0) }, "Quad", "InOut", 0.1)

local function SpawnDrone(SPCF)
	local baseCF = (typeof(SPCF) == "CFrame" and SPCF) or CF(typeof(SPCF) == "Vector3" and SPCF or RootPart.Position)
	task.spawn(function()
		local DroneModel = EffectPack:FindFirstChild("Toaster") and EffectPack.Toaster:Clone() or EffectPack.Drone:Clone()
		local Drone = EffectPack.Part:Clone()
		Drone.Parent = Effects
		Drone.Name = "Drone"
		Drone.Anchored = true

		task.delay(30, function()
			if Drone and Drone.Parent then
				Drone:Destroy()
			end
		end)

		Drone.CFrame = baseCF * CF(0, 10, 600)
		JointAllTo(Drone, DroneModel.Handle, DroneModel, CFrame.new(0, 0, 0))
		SetTween(Drone, { CFrame = baseCF * CF(math.random(-100, 100) / 10, math.random(5, 20), math.random(-10, 10) / 10) }, "Quad", "Out", 1)
		task.wait(1)

		local v2 = findNearestTorso(Drone.Position, 70)
		if v2 ~= nil then
			SetTween(Drone, { CFrame = CF(Drone.CFrame.Position, v2.CFrame.Position) }, "Quad", "InOut", 0.5)
		end
		Swait(0.15 * 30)

		for _ = 1, 16 do
			for i = 1, 2, 1 do
				local v = findNearestTorso(Drone.Position, 70)
				local gunPart = Drone:FindFirstChild("gun" .. i)
				if v ~= nil and gunPart then
					SetTween(Drone, { CFrame = CF(Drone.CFrame.Position, v.CFrame.Position) }, "Quad", "Out", 0.25)
					local _, lightp, test1 = rayCast(gunPart.CFrame.Position, CFrame.new(gunPart.CFrame.Position, v.CFrame.Position).LookVector, 70, Character)
					if DroneModel.Name ~= "Toaster" then
						Lightning(gunPart.CFrame.Position, lightp, 5, 0.2, BrickColor.new("Alder"), 0.15, 0.5, -0.5, 0.5, nil)
						BulletHitEffectSpawn(CF(lightp, lightp + (test1 or Vector3.new())), "Spark")
						task.spawn(function()
							so("168586621", Drone, 1.6, math.random(120, 220) / 100)
							so("1225795839", Drone, 2, math.random(120, 220) / 100)
							CFMagniDamage(CF(lightp), 10, 5, 10, 10, "Knockdown")
						end)
						Swait(0.15 * 30)
					else
						Lightning(gunPart.CFrame.Position, lightp, 1, 1, BrickColor.new("Alder"), 0.05, 0, -0.5, 1, nil)
						BulletHitEffectSpawn(CF(lightp, lightp + (test1 or Vector3.new())), "Spark")
						task.spawn(function()
							so("1578823908", Drone, 4, math.random(100, 150) / 100)
							CFMagniDamage(CF(lightp), 25, 75, 80, -50, "Knockdown")
						end)
						SetTween(Drone, { CFrame = CF(Drone.CFrame.Position, v.CFrame.Position) * CF(0, 0.5, -0.25) }, "Quad", "InOut", 0.15)
						Swait(0.15 * 30)
					end
				end
			end

			v2 = findNearestTorso(Drone.Position, 70)
			if v2 ~= nil then
				SetTween(Drone, { CFrame = CF(Drone.CFrame.Position, v2.CFrame.Position) }, "Quad", "InOut", 0.1)
			end
		end

		SetTween(Drone, { CFrame = Drone.CFrame * CF(0, 1000, 100) }, "Quad", "InOut", 6)
		task.wait(6)
		if Drone and Drone.Parent then
			Drone:Destroy()
		end
	end)
end

local function Attack1()
	attack = true
	Humanoid.JumpPower = 0
	Humanoid.WalkSpeed = 0

	task.spawn(function()
		SetTween(MX1w, { C0 = CF(0, 0, 0.15) * ANGLES(mr(90), 0, 0) }, "Back", "Out", 0.5)
		Swait(0.5)
		SetTween(MX1w, { C0 = CF(0, 0.1, 0.30) * ANGLES(mr(20), 0, 0) }, "Back", "Out", 0.25)
	end)

	so("418302853", Torso, 4, 2)
	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.6) * angles(math.rad(10), 0, 0) }, "Back", "Out", 0.3)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(20), 0, 0) }, "Back", "Out", 0.3)
	SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) * angles(math.rad(45), 0, math.rad(10)) }, "Back", "Out", 0.3)
	SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) * angles(math.rad(20), 0, math.rad(-10)) }, "Back", "Out", 0.3)
	SetTween(RH, { C0 = CFrame.new(0.5, -0.7, -0.2) * angles(math.rad(30), 0, 0) }, "Back", "Out", 0.3)
	SetTween(LH, { C0 = CFrame.new(-0.5, -1.0, -0.75) * angles(math.rad(-50), 0, 0) }, "Back", "Out", 0.3)
	task.wait(0.3)

	for _ = 1, 4 do
		for i = 1, 3 do
			local slot = MissileBox:FindFirstChild("MissileSlot" .. i)
			if slot then
				for _ = 1, 2 do
					task.spawn(function()
						FireSoul(CF(slot.CFrame.Position, slot.CFrame.Position + slot.CFrame.RightVector) * ANGLES(mr(math.random(-10, 10) / 10), mr(math.random(-10, 10) / 10), mr(math.random(-10, 10) / 10)))
					end)
				end
				SetTween(slot, { Color = C3(0, 0, 0) }, "Quad", "InOut", 0.05)
			end
			SetTween(MX1w, { C0 = CF(0, 0, 0.15) * ANGLES(mr(40), 0, 0) }, "Quad", "Out", 0.1)
			Swait(1)
			SetTween(MX1w, { C0 = CF(0, 0.1, 0.30) * ANGLES(mr(20), 0, 0) }, "Quad", "Out", 0.1)
			if slot then
				SetTween(slot, { Color = C3(180 / 255, 128 / 255, 255 / 255) }, "Quad", "InOut", 0.25)
			end
			Swait(1)
		end
	end

	task.spawn(function()
		SetTween(MX1w, { C0 = CF(0, 0, 0.15) * ANGLES(mr(90), 0, 0) }, "Back", "Out", 0.5)
		Swait(0.25 * 30)
		SetTween(MX1w, { C0 = CF(0, -0.7, -0.25) }, "Quad", "InOut", 0.25)
	end)
	attack = false
end

local eyehold = false
local function Attack2()
	attack = true
	Humanoid.JumpPower = 0
	Humanoid.WalkSpeed = 0

	local eyeffect1 = EffectPack.Light:Clone()
	eyeffect1.Parent = Head.Eye.Attachment
	eyeffect1.Enabled = true
	so("1841310110", Head, 3, 1)

	for _ = 1, 3.5, 0.1 do
		SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.3) * angles(math.rad(40), 0, 0) }, "Quad", "InOut", 0.1)
		SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(40), 0, 0) }, "Quad", "InOut", 0.1)
		SetTween(RW, { C0 = CFrame.new(1.2, 0.5, -0.2) * angles(math.rad(75 + math.random(-5, 5)), 0, math.rad(-40 + math.random(-5, 5))) }, "Quad", "Out", 0.1)
		SetTween(LW, { C0 = CFrame.new(-1.2, 0.5, -0.2) * angles(math.rad(75 + math.random(-5, 5)), 0, math.rad(40 + math.random(-5, 5))) }, "Quad", "Out", 0.1)
		SetTween(RH, { C0 = CFrame.new(0.5, -1, 0) * angles(math.rad(40), 0, 0) }, "Quad", "InOut", 0.1)
		SetTween(LH, { C0 = CFrame.new(-0.5, -1, 0) * angles(math.rad(40), 0, 0) }, "Quad", "InOut", 0.1)
		Swait()
	end

	so("197760420", Head, 8, 1)
	eyehold = true

	local Beam1 = Instance.new("Beam")
	Beam1.Parent = Torso.TorsoLaser

	local WalkPart = Instance.new("Part")
	WalkPart.Transparency = 1
	WalkPart.CanCollide = false
	WalkPart.Anchored = true
	WalkPart.CFrame = CFrame.new(0, 0, 0)
	WalkPart.Size = Vector3.new(0.1, 0.1, 0.1)
	WalkPart.Parent = Effects

	local Attach2 = Instance.new("Attachment")
	Attach2.Parent = WalkPart

	local NewParticle = Particle2_1:Clone()
	NewParticle.Parent = Attach2
	NewParticle.Acceleration = Vector3.new(0, 0, 0)
	NewParticle.Size = not OverClocking
		and NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0) })
		or NumberSequence.new({ NumberSequenceKeypoint.new(0, 50), NumberSequenceKeypoint.new(1, 0) })
	NewParticle.Color = ColorSequence.new(Color3.new(180 / 255, 128 / 255, 255 / 255), Color3.new(180 / 255, 128 / 255, 255 / 255))
	NewParticle.Lifetime = NumberRange.new(0.2, 0.3)
	NewParticle.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.25, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	NewParticle.Speed = NumberRange.new(0)
	NewParticle.ZOffset = 6
	NewParticle.RotSpeed = NumberRange.new(-40, 40)
	NewParticle.Rotation = NumberRange.new(-180, 180)
	NewParticle.Texture = "rbxassetid://217245118"
	NewParticle.Rate = 50

	local NewParticle2 = NewParticle:Clone()
	NewParticle2.LockedToPart = true
	NewParticle2.Parent = Attach2
	NewParticle.Texture = "rbxassetid://445231898"
	NewParticle.Lifetime = NumberRange.new(0.3, 0.5)
	NewParticle.ZOffset = 4
	NewParticle.Speed = NumberRange.new(1)

	task.spawn(function()
		if eyehold then
			task.spawn(function()
				while eyehold do
					task.wait(0.5)
					so("2162238374", Torso.TorsoLaser, 4, 2.0)
				end
				for _ = 1, 10 do
					for _, v in pairs(Torso.TorsoLaser:GetChildren()) do
						if v:IsA("Sound") then
							v.Volume = v.Volume - 0.4
						end
					end
					Swait()
				end
			end)

			while eyehold do
				Swait()
				Humanoid.JumpPower = 0
				change = 0.6
				Humanoid.WalkSpeed = 2

				task.spawn(function()
					local GunPart = Head.Eye
					local Glow1 = Color3.new(180 / 255, 128 / 255, 255 / 255)
					local Glow2 = Color3.new(180 / 255, 128 / 255, 255 / 255)
					local hitray, pos, test1 = rayCast(GunPart.Position, GunPart.CFrame.LookVector, 500, Character)
					local mag = (Torso.TorsoLaser.Position - pos).Magnitude

					Attach2.Position = pos
					NewParticle.Enabled = true
					NewParticle2.Enabled = true
					eyeffect1.Enabled = true

					Beam1.Texture = "rbxassetid://1134824633"
					Beam1.FaceCamera = true
					Beam1.Color = ColorSequence.new(Glow1, Glow2)
					Beam1.Transparency = NumberSequence.new(0, 0)
					Beam1.TextureLength = 0.1 * mag
					Beam1.Attachment0 = Head.Eye.Attachment
					Beam1.Attachment1 = Attach2
					Beam1.TextureSpeed = 15
					Beam1.LightEmission = 1
					Beam1.Width0 = 1
					Beam1.Width1 = not OverClocking and 2 or 20

					CFMagniDamage(CFrame.new(pos), not OverClocking and 5 or 30, 350, 500, 0, "Normal")

					if hitray ~= nil then
						local groundpart = CFuncs.Part.Create(Effects, Enum.Material.SmoothPlastic, 0, 0, hitray.BrickColor, "Ground", Vector3.new(math.random(50, 200) / 200, math.random(50, 200) / 200, math.random(50, 200) / 200))
						groundpart.Anchored = false
						groundpart.Material = hitray.Material
						groundpart.CanCollide = true
						groundpart.AssemblyLinearVelocity = Vector3.new(math.random(-50, 50), math.random(25, 50), math.random(-50, 50))
						groundpart.CFrame = CF(pos, pos + (test1 or Vector3.new())) * cn(math.random(-250, 250) / 100, 0.5, math.random(-250, 250) / 100) * CFrame.Angles(math.rad(math.random(-50, 50)), math.rad(math.random(-50, 50)), math.rad(math.random(-50, 50)))
						pcall(function()
							groundpart:SetNetworkOwner(Player)
						end)
						Debris:AddItem(groundpart, 1.0)
						SetTween(groundpart, { Size = VT(), Transparency = 1 }, "Quad", "In", 1)
					end
				end)
			end
		end

		task.spawn(function()
			for i = 0, 4, 0.3 do
				Swait()
				Beam1.Transparency = NumberSequence.new(i, i / 2)
			end
		end)

		NewParticle.Enabled = false
		NewParticle2.Enabled = false
		eyeffect1.Enabled = false

		Debris:AddItem(WalkPart, 1)
		Debris:AddItem(Attach2, 1)
		Debris:AddItem(Beam1, 1)
		Debris:AddItem(NewParticle, 1)
		Debris:AddItem(NewParticle2, 1)
		Debris:AddItem(eyeffect1, 1)
		so("1229184354", Torso, 5, 2)
	end)

	for i = 1, 3.25, 0.075 do
		SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) }, "Linear", "InOut", 0.1)
		SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(60 - 20 * i), 0, 0) }, "Quad", "InOut", 0.1)
		SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) * angles(math.rad((-20 + 20 * i) + math.random(-5, 5)), 0, math.rad(math.random(-5, 5) + (45 / 5) * i)) }, "Quad", "Out", 0.1)
		SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) * angles(math.rad((-20 + 20 * i) + math.random(-5, 5)), 0, math.rad(math.random(-5, 5) - (45 / 5) * i)) }, "Quad", "Out", 0.1)
		SetTween(RH, { C0 = CFrame.new(0.5, -1, 0) }, "Quad", "InOut", 0.1)
		SetTween(LH, { C0 = CFrame.new(-0.5, -1, 0) }, "Quad", "InOut", 0.1)
		Swait()
	end
	eyehold = false
	Swait()
	attack = false
end

local dancing = false
local function Attack3()
	attack = true
	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.9) * angles(math.rad(50), 0, math.rad(35)) }, "Quad", "InOut", 0.4)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(30), 0, math.rad(-35)) }, "Quad", "InOut", 0.4)
	SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) * angles(math.rad(65), 0, math.rad(35)) }, "Quad", "Out", 0.4)
	SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-30), 0, 0) }, "Quad", "Out", 0.4)
	SetTween(RH, { C0 = CFrame.new(0.5, 0, -0.25) * angles(math.rad(60), 0, math.rad(30)) }, "Quad", "InOut", 0.4)
	SetTween(LH, { C0 = CFrame.new(-0.5, -1, 0) * angles(0, 0, math.rad(15)) }, "Quad", "InOut", 0.4)

	so("3136984947", Head, 5, 0.8)
	Swait(0.4 * 30)

	local portal = Instance.new("Part")
	portal.Reflectance = 0
	portal.Transparency = 1
	portal.CanCollide = false
	portal.Locked = true
	portal.Anchored = true
	portal.BrickColor = BrickColor.new("Really blue")
	portal.Name = "portal"
	portal.Size = Vector3.new()
	portal.Material = Enum.Material.SmoothPlastic
	portal:BreakJoints()
	portal.CFrame = RootPart.CFrame

	local _, PortalPos = rayCast(portal.Position, CFrame.new(portal.Position, portal.Position - Vector3.new(0, 1, 0)).LookVector, 80, Character)
	portal.CFrame = cn(PortalPos)

	local max = OverClocking and 50 or 25
	local min = 0

	task.spawn(function()
		WACKYEFFECT({
			Time = 50,
			EffectType = "Sphere",
			Size = VT(0, 0, 0),
			Size2 = VT(max * 2, 0.1, max * 2),
			Transparency = 0.25,
			Transparency2 = 1,
			CFrame = portal.CFrame * CF(0, 0.05, 0),
			Material = Enum.Material.Neon,
			Color = Color3.fromRGB(180, 128, 255),
			SoundID = 167191994,
			SoundPitch = 1,
			SoundVolume = 4,
		})

		task.spawn(function()
			task.wait(0.1)
			for _, c in pairs(workspace:GetChildren()) do
				local h = c:FindFirstChildOfClass("Humanoid")
				local head = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
				if h and h.Health > 0.0001 and head and c ~= Character then
					local mag = (head.Position - portal.Position).Magnitude
					if mag < max and mag > min then
						task.spawn(function()
							local Shade = Instance.new("Model")
							Shade.Parent = Effects

							local hed = Instance.new("Part")
							hed.Reflectance = 0
							hed.Transparency = 1
							hed.CanCollide = false
							hed.Locked = true
							hed.Anchored = false
							hed.Material = Enum.Material.ForceField
							hed.BrickColor = BrickColor.new("Really black")

							local sTor = hed:Clone()
							sTor.Name = "Torso2"
							sTor.Size = Vector3.new(2, 2, 1)
							sTor:BreakJoints()
							sTor.CFrame = portal.CFrame * cn(0, -10, 0)

							local sraor = hed:Clone()
							sraor.Name = "RightArm"
							sraor.Size = Vector3.new(1, 2, 1)
							sraor:BreakJoints()
							sraor.CFrame = portal.CFrame * cn(0, -10, 0)

							local slaor = sraor:Clone()
							slaor.Name = "LeftArm"
							local srlor = sraor:Clone()
							srlor.Name = "RightLeg"
							local sllor = sraor:Clone()
							sllor.Name = "LeftLeg"

							hed.Name = "Head2"
							hed.Size = Vector3.new(1, 1, 1)
							hed:BreakJoints()
							hed.CFrame = portal.CFrame * cn(0, -10, 0)

							sTor.Anchored = true
							hed.Parent = Shade
							sTor.Parent = Shade
							sraor.Parent = Shade
							slaor.Parent = Shade
							srlor.Parent = Shade
							sllor.Parent = Shade

							Swait(math.random(1, 400) / 10)
							head.Anchored = true

							for _, part in ipairs({ sTor, hed, sraor, slaor, srlor, sllor }) do
								SetTween(part, { Transparency = 0 }, "Quad", "InOut", 0.24)
							end

							local NeckW2 = MakeJoint(sTor, sTor, hed, CFrame.new(0, 0, 0))
							NeckW2.C1 = NeckW.C1
							local RW2 = MakeJoint(sTor, sTor, sraor, cf(0, 0, 0))
							local LW2 = MakeJoint(sTor, sTor, slaor, cf(0, 0, 0))
							local RH2 = MakeJoint(sTor, sTor, srlor, cf(0, 0, 0))
							local LH2 = MakeJoint(sTor, sTor, sllor, cf(0, 0, 0))

							RW2.C1 = cn(0, 0.5, 0)
							LW2.C1 = cn(0, 0.5, 0)
							RH2.C1 = cn(0, 1, 0)
							LH2.C1 = cn(0, 1, 0)

							SetTween(sTor, { CFrame = head.CFrame * CFrame.new(0, -2, 4) * angles(math.rad(10), 0, 0) }, "Quad", "InOut", 1 / 20)
							Swait((1 / 5) * 30)
							SetTween(sTor, { CFrame = head.CFrame * CFrame.new(0, 0, 1) }, "Back", "Out", 1 / 3)

							Lightning(Head.Eye.Position, sTor.Position, 4, 0.4, BrickColor.new("Alder"), 0.1, 0.9, 1, 0.57, nil)
							Swait(1)

							MakeJoint(sTor, sTor, head, cf(0, 0, -1))
							head.Anchored = false
							Swait(math.random(1, 400) / 10)

							for _, part in ipairs({ sTor, hed, sraor, slaor, srlor, sllor }) do
								SetTween(part, { Color = Color3.fromRGB(180, 128, 255) }, "Quad", "Out", 1.5)
							end

							so("2924264089", sTor, 6, 1)
							Swait(1.4 * 30)

							WACKYEFFECT({
								Time = 50,
								EffectType = "Sphere",
								Size = VT(0, 0, 0),
								Size2 = VT(25, 25, 25),
								Transparency = 0.8,
								Transparency2 = 1,
								CFrame = sTor.CFrame,
								Material = Enum.Material.Neon,
								Color = Color3.fromRGB(180, 128, 255),
								SoundID = 3398040717,
								SoundPitch = 1,
								SoundVolume = 2,
							})

							BulletHitEffectSpawn(sTor.CFrame * ANGLES(mr(90), 0, 0), "Explode")
							Lightning(sTor.Position, Head.Eye.Position, 10, 0.6, BrickColor.new("Alder"), 1.5, 0, 1, 0.55, 1)
							CFMagniDamage(sTor.CFrame, 10, 60, 85, 100, "Knockdown")
							Shade:Destroy()
						end)
					end
				end
			end
		end)

		portal:Destroy()
	end)

	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) * angles(0, 0, math.rad(-30)) }, "Quad", "Out", 0.5)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(20), 0, math.rad(30)) }, "Quad", "Out", 0.5)
	SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) * angles(math.rad(150), 0, math.rad(55)) }, "Quad", "Out", 0.5)
	SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) }, "Back", "Out", 0.7)
	SetTween(RH, { C0 = CFrame.new(0.5, -1, 0) * angles(math.rad(-25), math.rad(-40), 0) }, "Quad", "Out", 0.5)
	SetTween(LH, { C0 = CFrame.new(-0.5, -1, 0) * angles(0, math.rad(40), 0) }, "Quad", "Out", 0.5)
	Swait(0.5 * 30)
	attack = false
end

local function Tuant2()
	attack = true
	dancing = true
	while dancing do
		local dahspeed = 0.5 + visn / 100
		change = (0.60 * 1) * dahspeed
		Humanoid.JumpPower = 0
		Humanoid.WalkSpeed = 2
		local speed = 1 + visn / 1000
		SetTween(RJW, { C0 = RootCF * CFrame.new(0 + (0.75 * math.cos(sine / 8)), 0 + (0.2 * math.sin(sine / 16)), -0.25 + (-0.1 * math.cos(sine / 4))) * angles(math.rad(-10 - 10 * math.sin(sine / 16)), 0, math.rad(0 + (20 * math.sin(sine / 8)))) }, "Quad", "InOut", 0.1 / speed)
		SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(20 * math.sin(sine / 16)), 0, math.rad(0 - (20 * math.sin(sine / 32)))) }, "Quad", "InOut", 0.1 / speed)
		SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) * angles(math.rad(120 + (-20 * math.cos(sine / 8)) + (-20 * math.sin(sine / 16))), 0, math.rad(25 + (25 * math.cos(sine / 8)))) }, "Quad", "Out", 0.1 / speed)
		SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) * angles(math.rad(120 + (20 * math.cos(sine / 8)) + (-20 * math.sin(sine / 16))), 0, math.rad(-25 + (25 * math.cos(sine / 8)))) }, "Quad", "Out", 0.1 / speed)
		SetTween(RH, { C0 = CFrame.new(0.5, -0.9 + 0.1 * math.cos(sine / 4), -0.1 - 0.1 * math.cos(sine / 4)) * angles(math.rad(-10 - (10 * math.sin(sine / 16)) - (5 * math.sin(sine / 8))), math.rad(-20 - (-20 * math.sin(sine / 8))), math.rad(10 + (20 * math.cos(sine / 8)))) }, "Quad", "InOut", 0.1 / speed)
		SetTween(LH, { C0 = CFrame.new(-0.5, -0.9 + 0.1 * math.cos(sine / 4), -0.1 - 0.1 * math.cos(sine / 4)) * angles(math.rad(-10 - (10 * math.sin(sine / 16)) + (5 * math.sin(sine / 8))), math.rad(20 + (-20 * math.sin(sine / 8))), math.rad(-10 + (20 * math.cos(sine / 8)))) }, "Quad", "InOut", 0.1 / speed)
		Swait()
	end
	Humanoid.JumpPower = 60
	Humanoid.WalkSpeed = 16
	attack = false
end

local function UpdateJets()
	local enabled = Jets == true
	if enabled then
		SetTween(RB1, { C0 = CF(0, 0.25, -0.05) * ANGLES(mr(25), 0, 0) }, "Back", "Out", 0.5)
		SetTween(RB2, { C0 = CF(0, 0.25, 0.05) * ANGLES(mr(-25), 0, 0) }, "Back", "Out", 0.5)
		SetTween(LB1, { C0 = CF(0, 0.25, -0.05) * ANGLES(mr(25), 0, 0) }, "Back", "Out", 0.5)
		SetTween(LB2, { C0 = CF(0, 0.25, 0.05) * ANGLES(mr(-25), 0, 0) }, "Back", "Out", 0.5)
	else
		SetTween(RB1, { C0 = CF(0, 0, 0) }, "Back", "Out", 0.5)
		SetTween(RB2, { C0 = CF(0, 0, 0) }, "Back", "Out", 0.5)
		SetTween(LB1, { C0 = CF(0, 0, 0) }, "Back", "Out", 0.5)
		SetTween(LB2, { C0 = CF(0, 0, 0) }, "Back", "Out", 0.5)
	end
	for _, v in ipairs(RightLeg:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = enabled
		end
	end
	for _, v in ipairs(LeftLeg:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = enabled
		end
	end
end

local function DroneSwarm()
	attack = true
	local randomtuant = math.random(1, 4)
	local sounds = { "159972582", "159882410", "159882578", "159882417" }
	so(sounds[randomtuant], Head, 2, 1)

	for _, v in pairs(Head:GetChildren()) do
		if v:IsA("Sound") then
			EffectPack.Echo2:Clone().Parent = v
			EffectPack.PT:Clone().Parent = v
		end
	end

	local fatsavecf = MHIT
	task.spawn(function()
		for _ = 1, math.random(2, 4) do
			Swait(math.random(1, 10))
			SpawnDrone(fatsavecf)
		end
	end)

	for _ = 0, 1, 0.1 do
		change = 0.60 * 5
		Humanoid.JumpPower = 10
		Humanoid.WalkSpeed = 0
		SetTween(RJW, { C0 = RootCF * cn(0, 0, -0.1 + 0.05 * math.cos(sine / 8)) * angles(math.rad(-5), 0, math.rad(-20)) }, "Quad", "InOut", 0.1)
		Swait()
	end

	for _ = 0, 3, 0.1 do
		change = 0.60 * 5
		Humanoid.JumpPower = 10
		Humanoid.WalkSpeed = 0
		SetTween(RJW, { C0 = RootCF * cn(0, 0, -0.1 + 0.05 * math.cos(sine / 8)) * angles(math.rad(-5), 0, math.rad(20)) }, "Quad", "InOut", 0.1)
		Swait()
	end
	attack = false
end

local flying = false
local function FlyMove()
	attack = true
	local NextAnimSpeed = 0.1
	local dahspeed = 1
	flying = true
	so(2157448269, Torso, 2, 1)
	Jets = true
	UpdateJets()

	local bg2 = Instance.new("BodyGyro")
	bg2.Parent = RootPart

	for _ = 0, 1, NextAnimSpeed do
		Swait()
		Humanoid.PlatformStand = false
		change = (0.60 * 2) * dahspeed
		Humanoid.JumpPower = 0
		Humanoid.WalkSpeed = 0
		local aimPos = getAimPosition()
		bg2.D = 300
		bg2.P = 9999
		bg2.MaxTorque = Vector3.new(1e5, 1e3, 1e5) * math.huge
		bg2.CFrame = CFrame.new(RootPart.Position, Vector3.new(aimPos.X, RootPart.Position.Y, aimPos.Z))
	end

	if flying then
		task.spawn(function()
			while flying do
				so("169572883", Torso, 3, 1.0)
				task.wait(0.5)
			end
		end)

		local bodyVelocity = Create("BodyVelocity")({
			Velocity = Vector3.new(0, 0.1, 0) + RootPart.CFrame.LookVector * 60,
			P = 5000,
			MaxForce = Vector3.new(80000, 80000, 80000),
			Parent = RootPart,
		})

		for _ = 1, 40, 0.25 do
			if flying then
				Swait()
			end
			Humanoid.PlatformStand = true
			change = (0.60 * 3) * dahspeed
			Humanoid.JumpPower = 0
			Humanoid.WalkSpeed = 0
			local aimPos = getAimPosition()
			bg2.D = 300
			bg2.P = 9999
			bg2.MaxTorque = Vector3.new(1e5, 1e3, 1e5) * math.huge
			bg2.CFrame = CFrame.new(RootPart.Position, aimPos)

			local speedMult = not OverClocking and 100 or 200
			bodyVelocity.Velocity = Vector3.new(0, 0.1, 0) + RootPart.CFrame.LookVector * speedMult

			if OverClocking and flying then
				Lightning((RootPart.CFrame * CF(math.random(-2, 2), math.random(-1, 1), 0)).Position, (RootPart.CFrame * CF(math.random(-36, 36), math.random(-36, 36), 70)).Position, 10, 0.6, BrickColor.new("Alder"), 1.5, 0.9, -0.5, 0.55, 1)
			end
			SetTween(RJW, { C0 = RootCF * cn(0, 1, 0) * angles(math.rad(60 - 6.5 * math.cos(sine / 8)), 0, 0) }, "Quad", "InOut", 0.08)
		end

		Debris:AddItem(bodyVelocity, 0.1)
	end

	so(1053625322, LeftLeg, 2, 0.5)
	so(1053625322, RightLeg, 2, 0.5)

	for _ = 0, 1.0, 0.15 do
		Swait()
		Humanoid.PlatformStand = false
		Humanoid.JumpPower = 0
		Humanoid.WalkSpeed = 0
		local aimPos = getAimPosition()
		bg2.D = 300
		bg2.P = 9999
		bg2.MaxTorque = Vector3.new(1e5, 1e3, 1e5) * math.huge
		bg2.CFrame = CFrame.new(RootPart.Position, Vector3.new(aimPos.X, RootPart.Position.Y, aimPos.Z))
	end

	task.wait(0.1)
	if bg2 and bg2.Parent then
		bg2:Destroy()
	end

	flying = false
	Jets = false
	UpdateJets()
	Humanoid.JumpPower = 20
	Humanoid.WalkSpeed = 10
	attack = false
end

local function Tesla()
	attack = true
	local dahspeed = (attack and mememode) and 3 or 1

	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) * angles(0, 0, math.rad(50)) }, "Quad", "InOut", 0.3 / dahspeed)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(0, 0, math.rad(-50)) }, "Quad", "InOut", 0.3 / dahspeed)
	SetTween(LHP2, { C0 = CF(0, 0, 0) }, "Quad", "InOut", 0.1)

	local glowPart = LHP:FindFirstChild("Glow")
	if OverClocking and glowPart then
		SetTween(glowPart, { Transparency = 1 }, "Quad", "InOut", 0.1)
	end

	task.wait(0.3 / dahspeed)

	task.spawn(function()
		so("2924262751", RightArm, 4, 1.2)
		task.wait(0.1 / dahspeed)
		CFMagniDamage(LeftArm.CFrame, 5, 40, 60, math.random(500, 1000) / 10, "Knockdown")
	end)

	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.2) * angles(0, 0, math.rad(-20)) }, "Back", "Out", 0.3 / dahspeed)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(-30), 0, math.rad(20)) }, "Back", "Out", 0.3 / dahspeed)
	SetTween(LHP2, { C0 = CF(0, -0.85, 0) }, "Quad", "InOut", 0.05)

	if OverClocking and glowPart then
		SetTween(glowPart, { Transparency = 0.15 }, "Quad", "InOut", 0.05)
	end

	for _ = 1, 25 do
		local v = glowPart and findNearestTorso(glowPart.Position, 150)
		if v ~= nil and glowPart then
			Swait(1)
			local _, lightp2, test12 = rayCast(glowPart.CFrame.Position, CF(glowPart.CFrame.Position, v.Position).LookVector, 150, Character)
			Lightning(glowPart.CFrame.Position, lightp2, 5, 2.6, BrickColor.new("Alder"), 2, 0.5, -0.5, 0.5, nil)
			BulletHitEffectSpawn(CF(lightp2, lightp2 + (test12 or Vector3.new())), "Spark")
			CFMagniDamage(CF(lightp2), 10, 45, 80, 50, "Knockdown")
		else
			Swait(0.3 * 30)
			break
		end
	end

	SetTween(LHP2, { C0 = CF(0, 0, 0) }, "Quad", "InOut", 0.25)
	if glowPart then
		SetTween(glowPart, { Transparency = 1 }, "Quad", "InOut", 0.25)
	end
	attack = false
end

local function AT1()
	attack = true
	local dahspeed = (attack and mememode) and 3 or 1
	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) * angles(0, 0, math.rad(50)) }, "Quad", "InOut", 0.3 / dahspeed)
	SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(0, 0, math.rad(-50)) }, "Quad", "InOut", 0.3 / dahspeed)
	task.wait(0.3 / dahspeed)

	task.spawn(function()
		so("1428541279", RightArm, 1.6, math.random(120, 220) / 100)
		task.wait(0.1 / dahspeed)
		local glowPart = LHP:FindFirstChild("Glow")
		if not OverClocking or not glowPart then
			CFMagniDamage(LeftArm.CFrame, 5, 40, 60, math.random(500, 1000) / 10, "Knockdown")
		else
			local v = findNearestTorso(glowPart.Position, 20)
			if v ~= nil then
				Lightning(glowPart.CFrame.Position, v.Position, 10, 0.6, BrickColor.new("Alder"), 0.5, 0.5, -0.5, 0.5, nil)
				CFMagniDamage(glowPart.CFrame, 20, 45, 80, math.random(320, 520) / 10, "Knockdown")
			end
		end
	end)

	task.wait(0.15 / dahspeed)
	attack = false
end

local function AT2()
	attack = true
	Humanoid.WalkSpeed = 5
	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) * angles(math.rad(-5), 0, math.rad(60)) }, "Quad", "InOut", 0.15)
	Swait(0.15 * 30)
	so("1428541279", RightArm, 1.6, math.random(120, 220) / 100)

	local aimPos = getAimPosition()
	local RootAndMouse = CF(RootPart.Position, RootPart.Position + CF(RootPart.Position * VT(1, 0, 1), aimPos * VT(1, 0, 1)).LookVector)
	SetTween(RootPart, { CFrame = RootAndMouse * CF(0, 0, -1) }, "Back", "Out", 0.1)
	CFMagniDamage(LeftArm.CFrame * CF(0, -1, 0), 7, 10, 15, 4, "Normal")

	Humanoid.WalkSpeed = 16
	Swait(0.1 * 30)
	attack = false
end

local function AT3()
	attack = true
	Humanoid.WalkSpeed = 5
	SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, 0) * angles(math.rad(-5), 0, math.rad(-60)) }, "Quad", "InOut", 0.15)
	Swait(0.15 * 30)
	so("1428541279", RightArm, 1.6, math.random(120, 220) / 100)

	local aimPos = getAimPosition()
	local RootAndMouse = CF(RootPart.Position, RootPart.Position + CF(RootPart.Position * VT(1, 0, 1), aimPos * VT(1, 0, 1)).LookVector)
	SetTween(RootPart, { CFrame = RootAndMouse * CF(0, 0, -1) }, "Back", "Out", 0.1)
	CFMagniDamage(RightArm.CFrame * CF(0, -1, 0), 7, 10, 15, 4, "Normal")

	Humanoid.WalkSpeed = 16
	Swait(0.1 * 30)
	attack = false
end

-- X-ray GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Xgui"
pcall(function()
	gui.Parent = game:GetService("CoreGui")
end)
if not gui.Parent then
	gui.Parent = Player:WaitForChild("PlayerGui")
end

local guifat = Instance.new("Frame")
guifat.Size = UDim2.new(1, 0, 1, 36)
guifat.Position = UDim2.new(0, 0, 0, -36)
guifat.Name = "FAT"
guifat.BackgroundTransparency = 1
guifat.Parent = gui

local viewport = Instance.new("ViewportFrame")
viewport.Size = UDim2.new(1, 0, 1, 0)
viewport.BackgroundTransparency = 1
viewport.BackgroundColor3 = C3(1, 1, 1)
viewport.CurrentCamera = workspace.CurrentCamera
viewport.Parent = guifat

local function AddstuffinXray()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Humanoid") and v ~= Humanoid and v.Parent then
			for _, v2 in ipairs(v.Parent:GetDescendants()) do
				if v2:IsA("BasePart") then
					local Xpart = EffectPack.Part:Clone()
					Xpart.Parent = viewport
					Xpart.Name = "Xray"
					Xpart.Size = v2.Size + VT(0.05, 0.05, 0.05)
					Xpart.Material = Enum.Material.ForceField
					Xpart.Transparency = 0
					Xpart.CFrame = v2.CFrame

					local mesh = v2:FindFirstChildOfClass("SpecialMesh")
					if mesh then
						local clone = mesh:Clone()
						clone.Parent = Xpart
					end

					local value = Instance.new("ObjectValue")
					value.Value = v2
					value.Name = "val"
					value.Parent = Xpart
					Xpart.BrickColor = BrickColor.new("Alder")
				end
			end
		end
	end
end

local function Attack6()
	SetTween(viewport, { BackgroundTransparency = 0.15, BackgroundColor3 = C3(0, 0, 0) }, "Bounce", "InOut", 0.25)
	IsXray = true
	AddstuffinXray()
	local updatetimer = 0

	while IsXray do
		Swait(5)
		updatetimer += 1
		if updatetimer > 10 then
			updatetimer = 0
			for _, v in ipairs(viewport:GetDescendants()) do
				v:Destroy()
			end
			AddstuffinXray()
		end
	end

	SetTween(viewport, { BackgroundTransparency = 1, BackgroundColor3 = C3(1, 1, 1) }, "Bounce", "InOut", 0.5)
	for _, v in ipairs(viewport:GetDescendants()) do
		v:Destroy()
	end
end

local function ClickCombo()
	if Anim == "Fall" or Anim == "Jump" then
		return
	end
	if Combo == 4 then
		AT1()
		Combo = 1
	elseif Combo == 0 then
		AT2()
		Combo = 1
	elseif Combo == 1 then
		AT3()
		Combo = 0
	end
end

local mouse = Player:GetMouse()
mouse.Move:Connect(function()
	MHIT = mouse.Hit
end)

local function Button1DownF()
	Hold = true
	if weps and not attack then
		for _, v in ipairs(SpinnyThingy:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("SpotLight") then
				v.Enabled = true
			end
		end
		Swait(0.25 * 30)
		spinto = 35
		while Hold do
			task.spawn(function()
				local pipe = SpinnyThingy:FindFirstChild("Hole" .. math.random(1, 4))
				if not pipe then
					return
				end
				local aimPos = getAimPosition()
				local dist = not OverClocking and 70 or 570
				local _, lightp, test1 = rayCast(pipe.CFrame.Position, CFrame.new(pipe.CFrame.Position, aimPos).LookVector, dist, Character)
				so("419268760", pipe, 2, not OverClocking and 1.2 or 1)
				Lightning(pipe.CFrame.Position, lightp, 5, not OverClocking and 0.5 or 1.5, BrickColor.new("Alder"), not OverClocking and 0.15 or 0.5, 0, -0.5, 0.5, nil)
				BulletHitEffectSpawn(CF(lightp, lightp + (test1 or Vector3.new())), "Spark")
				if not OverClocking then
					CFMagniDamage(CF(lightp), 10, 5, 10, 10, "Knockdown")
				else
					CFMagniDamage(CF(lightp - (CFrame.new(pipe.CFrame.Position, lightp).LookVector * 5)), 10, 50, 75, 50, "Knockdown")
				end
			end)

			local mathstuff = spin
			if mathstuff < 0.05 then
				mathstuff = 0.5
			elseif mathstuff > spinto then
				mathstuff = spinto
			end
			local mathEEEE = 6 * (1.35 - (mathstuff / spinto))
			Swait(mathEEEE)
		end
	elseif Hold and not weps and not attack then
		while Hold do
			if not attack then
				ClickCombo()
			else
				Swait()
			end
		end
	end
end

local function Button1UpF()
	if Hold then
		Hold = false
		spinto = 1
		for _, v in ipairs(SpinnyThingy:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("SpotLight") then
				v.Enabled = false
			end
		end
	end
end

mouse.Button1Down:Connect(Button1DownF)
mouse.Button1Up:Connect(Button1UpF)

so("420194643", Head, 1, 1)

local function resolveKey(input)
	if type(input) == "string" then
		return input:lower()
	end
	if typeof(input) == "InputObject" then
		return UserInputService:GetStringForKeyCode(input.KeyCode):lower()
	end
	return ""
end

local function KeyUpF(input, chatting)
	if chatting then
		return
	end
	local key = resolveKey(input)
	if key == "e" and flying then
		flying = false
	end
end

local function KeyDownF(input, chatting)
	if chatting then
		return
	end
	local key = resolveKey(input)

	if key == "f" and not attack and (not weps or not Hold) then
		weps = not weps
		local headHandle = Head:FindFirstChild("Handle") or Head
		if weps then
			so("420194643", headHandle, 1, 0.8)
			so("420997245", headHandle, 5, 0.7)
			for _, v in pairs(headHandle:GetChildren()) do
				if v:IsA("Sound") then
					EffectPack.Echo:Clone().Parent = v
				end
			end
			task.spawn(function()
				local lighter = MiniGun:FindFirstChild("Lighter")
				if lighter and lighter:FindFirstChild("Fire") then
					lighter.Fire.Enabled = true
				end
			end)
			SetTween(FlameW, { C0 = CF(0, -0.5, 0) }, "Back", "Out", 1)
			SetTween(Fg1, { C0 = CF(0, 0.25, 0) * ANGLES(mr(25), 0, mr(-15)) }, "Back", "Out", 0.5)
			SetTween(Fg2, { C0 = CF(0, 0.25, 0) * ANGLES(mr(25), 0, mr(15)) }, "Back", "Out", 0.5)
			SetTween(Fg3, { C0 = CF(0, 0.25, 0) * ANGLES(mr(-25), 0, mr(15)) }, "Back", "Out", 0.5)
			SetTween(Fg4, { C0 = CF(0, 0.25, 0) * ANGLES(mr(-25), 0, mr(-15)) }, "Back", "Out", 0.5)
		else
			so("420194643", headHandle, 1, 1)
			so("332757260", headHandle, 3, 1.75)
			for _, v in pairs(headHandle:GetChildren()) do
				if v:IsA("Sound") then
					EffectPack.Echo:Clone().Parent = v
				end
			end
			task.spawn(function()
				local lighter = MiniGun:FindFirstChild("Lighter")
				if lighter and lighter:FindFirstChild("Fire") then
					lighter.Fire.Enabled = false
				end
			end)
			SetTween(FlameW, { C0 = CF(0, 0, 0) }, "Quad", "Out", 0.5)
			SetTween(H1a, { C0 = CF(0, 0.5, -0.4) }, "Quad", "InOut", 0.5)
			SetTween(Fg1, { C0 = CF(0, 0, 0) }, "Quad", "In", 0.5)
			SetTween(Fg2, { C0 = CF(0, 0, 0) }, "Quad", "In", 0.5)
			SetTween(Fg3, { C0 = CF(0, 0, 0) }, "Quad", "In", 0.5)
			SetTween(Fg4, { C0 = CF(0, 0, 0) }, "Quad", "In", 0.5)
			task.wait(0.25)
			SetTween(MX1w, { C0 = CF(0, -0.7, -0.25) }, "Quad", "InOut", 0.25)
		end
	elseif key == "x" and not attack and not weps and OverClocking then
		Tesla()
	elseif key == "e" and not attack then
		FlyMove()
	elseif key == "y" then
		if not dancing and not attack then
			Tuant2()
		elseif dancing and attack then
			dancing = false
		end
	elseif key == "q" and not attack then
		if not OverClocking then
			CurId -= 1
			OverClocking = true
			for i = 1, 4 do
				for _, v in ipairs(Character:GetDescendants()) do
					if v:IsA("ParticleEmitter") and v.Name == "OverClock" .. i then
						v.Enabled = true
					end
				end
			end
			lastid = "http://www.roblox.com/asset/?id=3608582022"
			lastsongpos = 0
			s2.TimePosition = lastsongpos
			so(254873067, Torso, 2, 1)
			so(1567217295, Torso, 3, 0.8)
			so(147060085, Torso, 5, 1)
		else
			OverClocking = false
			for i = 1, 4 do
				for _, v in ipairs(Character:GetDescendants()) do
					if v:IsA("ParticleEmitter") and v.Name == "OverClock" .. i then
						v.Enabled = false
					end
				end
			end
		end
	elseif key == "g" and not attack then
		if not IsXray then
			Attack6()
		else
			IsXray = false
		end
	end
end

UserInputService.InputEnded:Connect(KeyUpF)
UserInputService.InputBegan:Connect(KeyDownF)

-- Overclock emitters
local OverClockEffect1 = EffectPack.OverClock1:Clone()
OverClockEffect1.Parent = Torso
OverClockEffect1.Enabled = false

local OverClockEffect2 = EffectPack.OverClock2:Clone()
OverClockEffect2.Parent = Torso
OverClockEffect2.Enabled = false

local OverClockEffect3 = EffectPack.OverClock3:Clone()
OverClockEffect3.Parent = Torso
OverClockEffect3.Enabled = false

task.spawn(function()
	local OverClockEffect4 = EffectPack.OverClock4:Clone()
	OverClockEffect4.Enabled = false
	OverClockEffect4.Parent = Torso
	OverClockEffect4:Clone().Parent = Head
	OverClockEffect4:Clone().Parent = RightArm
	OverClockEffect4:Clone().Parent = LeftArm
	OverClockEffect4:Clone().Parent = RightLeg
	OverClockEffect4:Clone().Parent = LeftLeg
end)

-- Optional FireMohawk weld if present on character
local mohawk = Character:FindFirstChild("FireMohawk")
if mohawk and mohawk:FindFirstChild("Handle") then
	local hat2 = mohawk.Handle
	hat2:BreakJoints()
	local Weld = Instance.new("Weld")
	Weld.Part1 = hat2
	Weld.Part0 = Torso
	Weld.C0 = CFrame.new(0, 0, 1)
	Weld.Parent = Character
	local mesh = hat2:FindFirstChildOfClass("SpecialMesh")
	if mesh then
		mesh:Destroy()
	end
end

-- Main loop
task.spawn(function()
	while Character.Parent do
		sine += change
		local hitfloor = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 4, Character)
		local torvel = (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).Magnitude

		if RootPart.AssemblyLinearVelocity.Y > 1 and hitfloor == nil then
			Anim = "Jump"
		elseif RootPart.AssemblyLinearVelocity.Y < -1 and hitfloor == nil then
			Anim = "Fall"
		elseif Humanoid.Sit then
			Anim = "Sit"
		elseif torvel < 0.5 and hitfloor ~= nil then
			Anim = "Idle"
		elseif torvel > 0.5 and hitfloor ~= nil then
			Anim = "Walk"
		else
			Anim = ""
		end

		local Ccf = Torso.CFrame
		local Walktest1 = Humanoid.MoveDirection * Ccf.LookVector
		local Walktest2 = Humanoid.MoveDirection * Ccf.RightVector
		forWFB = Walktest1.X + Walktest1.Z
		forWRL = Walktest2.X + Walktest2.Z

		spin = (vt(0, spin, 0):Lerp(vt(0, spinto, 0), 0.05)).Y
		spinrad += spin

		task.spawn(function()
			if s2 == nil or s2.Parent == nil then
				s2 = s2c:Clone()
				s2.Parent = Torso
				s2.Name = "BGMusic"
				s2.Pitch = 1
				s2.Volume = 1.5
				s2.Looped = true
				s2.Archivable = false
				s2.TimePosition = lastsongpos
				if playsong then
					s2:Play()
				else
					s2:Stop()
				end
			else
				lastsongpos = s2.TimePosition
				s2.Pitch = 1
				s2.Volume = 1.5
				s2.Name = "BGMusic"
				s2.Looped = true
				s2.SoundId = lastid
				s2.EmitterSize = 30
			end
		end)

		inairvel = math.min(torvel, 30) / 50 * 2
		SetTween(SpinnyThingyWeld, { C0 = ANGLES(mr(spinrad), 0, 0) }, "Quad", "Out", 0.055)

		if not attack then
			if Anim == "Jump" then
				change = 0.60 * 2
				SetTween(RJW, { C0 = RootCF * cn(0, 0 + (0.0395 / 2) * math.cos(sine / 8), -0.1 + 0.0395 * math.cos(sine / 8)) * angles(math.rad(-6.5 - 1.5 * math.cos(sine / 8)) + (inairvel * forWFB) / 2, math.rad(0) - (inairvel * forWRL) / 2, 0) }, "Quad", "Out", 0.25)
				SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(-26.5 + 2.5 * math.cos(sine / 8)), 0, 0) }, "Quad", "Out", 0.25)
				SetTween(RW, { C0 = cf(1.4 + 0.05 * math.cos(sine / 8), 0.5 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(140 - 2 * math.cos(sine / 8)), math.rad(-5), math.rad(8 + 4 * math.cos(sine / 8))) }, "Quad", "Out", 0.2)
				SetTween(LW, { C0 = cf(-1.4 + 0.05 * math.cos(sine / 8), 0.5 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(140 - 2 * math.cos(sine / 8)), math.rad(5), math.rad(-8 - 4 * math.cos(sine / 8))) }, "Quad", "Out", 0.2)
				SetTween(RH, { C0 = CFrame.new(0.5, -0.85 + 0.05 * math.cos(sine / 15), -0.2) * CFrame.Angles(math.rad(-15 - 1 * math.cos(sine / 10)), 0, 0) }, "Quad", "InOut", 0.075)
				SetTween(LH, { C0 = CFrame.new(-0.5, -0.35 + 0.05 * math.cos(sine / 15), -0.4) * CFrame.Angles(math.rad(-25 + 1 * math.cos(sine / 10)), 0, 0) }, "Quad", "InOut", 0.075)
			elseif Anim == "Fall" then
				change = 0.60 * 2
				SetTween(RJW, { C0 = RootCF * cn(0, 0 + (0.0395 / 2) * math.cos(sine / 8), -0.5 + 0.0395 * math.cos(sine / 8)) * angles(math.rad(5.5 - 1.5 * math.cos(sine / 8)) - (inairvel * forWFB) / 2, math.rad(0) + (inairvel * forWRL) / 2, 0) }, "Quad", "Out", 0.35)
				SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0) * angles(math.rad(26.5 + 2.5 * math.cos(sine / 8)), 0, 0) }, "Quad", "Out", 0.25)
				SetTween(RW, { C0 = cf(1.4 + 0.05 * math.cos(sine / 8), 0.5 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(105 - 2 * math.cos(sine / 8)), math.rad(-15), math.rad(80 + 4 * math.cos(sine / 8))) }, "Quad", "Out", 0.2)
				SetTween(LW, { C0 = cf(-1.4 + 0.05 * math.cos(sine / 8), 0.5 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(105 - 2 * math.cos(sine / 8)), math.rad(15), math.rad(-80 - 4 * math.cos(sine / 8))) }, "Quad", "Out", 0.2)
				SetTween(RH, { C0 = CFrame.new(0.5, -0.15 + 0.05 * math.cos(sine / 15), -0.4) * CFrame.Angles(math.rad(-15 - 1 * math.cos(sine / 10)), 0, 0) }, "Quad", "InOut", 0.1)
				SetTween(LH, { C0 = CFrame.new(-0.5, -0.55 + 0.05 * math.cos(sine / 15), -0.4) * CFrame.Angles(math.rad(-0 + 1 * math.cos(sine / 10)), 0, 0) }, "Quad", "InOut", 0.1)
			elseif Hold and weps then
				change = 0.60
				Humanoid.JumpPower = 0
				Humanoid.WalkSpeed = 0
				local speed = 0.85
				SetTween(RJW, { C0 = RootCF * cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8)) * angles(0, 0, math.rad(70)) }, "Quad", "InOut", 0.1 / speed)
				SetTween(NeckW, { C0 = NeckCF * angles(math.rad(-5 + 40.5 * (visn / 1000) - 4.5 * math.cos(sine / 8)), math.rad(2.5 - 5.5 * math.cos(sine / 16)), math.rad(0 - 60 + (15 * (visn / 1000)) * math.cos(sine / 15 + 0.4 * math.cos(sine / 20)))) }, "Linear", "InOut", 0.075 / speed)
				SetTween(RW, { C0 = cf(1.45, 0.55 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(90 - 2 * math.cos(sine / 8)) + mr(math.random(-5, 5)), mr(math.random(-5, 5)), math.rad(70 + (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				SetTween(LW, { C0 = cf(-1.46, 0.5 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(-2 * math.cos(sine / 8)), math.rad(5), math.rad(-18 - (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				SetTween(RH, { C0 = CFrame.new(0.5, -0.95 - 0.04 * math.cos(sine / 8), 0) * CFrame.Angles(0, math.rad(-20), math.rad(6.5)) }, "Quad", "InOut", 0.1)
				SetTween(LH, { C0 = CFrame.new(-0.5, -0.95 - 0.04 * math.cos(sine / 8), 0) * CFrame.Angles(0, math.rad(20), math.rad(-6.5)) }, "Quad", "InOut", 0.1)

				if hitfloor ~= nil then
					local aimPos = getAimPosition()
					SetTween(RootPart, { CFrame = CF(RootPart.Position, RootPart.Position + CF(RootPart.Position * VT(1, 0, 1), aimPos * VT(1, 0, 1)).LookVector) }, "Quad", "Out", 0.1)
				end
			elseif Anim == "Idle" then
				local dahspeed = 0 + visn / 100
				change = (0.60 * 1) * dahspeed
				Humanoid.JumpPower = 60
				Humanoid.WalkSpeed = 16
				local speed = 0.5 + visn / 1000

				if not weps then
					SetTween(RJW, { C0 = RootCF * cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8)) }, "Quad", "InOut", 0.1 / speed)
					SetTween(NeckW, { C0 = NeckCF * angles(math.rad(40.5 * (visn / 1000) - 4.5 * math.cos(sine / 8)), math.rad(2.5 - 5.5 * math.cos(sine / 16)), 0) }, "Linear", "InOut", 0.1 / speed)
					SetTween(RW, { C0 = cf(1.45, 0.55 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(-2 * math.cos(sine / 8)), math.rad(-5), math.rad(10 + (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				else
					SetTween(RJW, { C0 = RootCF * cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8)) * angles(0, 0, math.rad(-60)) }, "Quad", "InOut", 0.1 / speed)
					SetTween(NeckW, { C0 = NeckCF * angles(math.rad(-5 + 40.5 * (visn / 1000) - 4.5 * math.cos(sine / 8)), math.rad(2.5 - 5.5 * math.cos(sine / 16)), math.rad(60 + (25 * (visn / 1000)) * math.cos(sine / 15 + 0.4 * math.cos(sine / 20)))) }, "Linear", "InOut", 0.075 / speed)
					SetTween(RW, { C0 = cf(1.45, 0.55 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(150 - 2 * math.cos(sine / 8)), math.rad(-5), math.rad(10 + (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				end

				SetTween(LW, { C0 = cf(-1.46, 0.55 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(-2 * math.cos(sine / 8)), math.rad(5), math.rad(-10 - (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				SetTween(RH, { C0 = CFrame.new(0.5, -0.95 - 0.04 * math.cos(sine / 8), 0) * CFrame.Angles(0, math.rad(-20), math.rad(6.5)) }, "Quad", "InOut", 0.1)
				SetTween(LH, { C0 = CFrame.new(-0.5, -0.95 - 0.04 * math.cos(sine / 8), 0) * CFrame.Angles(0, math.rad(20), math.rad(-6.5)) }, "Quad", "InOut", 0.1)
			elseif Anim == "Walk" then
				local speed = 0.75 + (not OverClocking and 0.75 or 1.75) * (visn / 1000)
				if mememode then
					speed = 4
				end

				change = 2.6 * speed
				Humanoid.JumpPower = 60 * speed
				Humanoid.WalkSpeed = 16 * speed

				local RH2 = cf(-forWRL / 7 * math.cos(sine / 8), 0, forWFB / 7 * math.cos(sine / 8)) * angles(math.sin(-forWFB) * math.cos(sine / 8), 0, math.sin(-forWRL) * math.cos(sine / 8))
				local LH2 = cf(forWRL / 7 * math.cos(sine / 8), 0, -forWFB / 7 * math.cos(sine / 8)) * angles(math.sin(forWFB) * math.cos(sine / 8), 0, math.sin(forWRL) * math.cos(sine / 8))

				if not weps then
					SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.185 + 0.055 * math.cos(sine / 4) - math.sin(sine / 4) / 8) * angles(math.rad((forWFB * 2 - forWFB * math.cos(sine / 4)) * 10), math.rad((-forWRL + forWRL * math.cos(sine / 4)) * 5), math.rad(25 * forWRL + 8 * math.cos(sine / 8))) }, "Linear", "InOut", WalkAnimMove / speed)
					SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0.025 * math.cos(sine / 4)) * angles(math.rad(20 + (-forWFB * 2 + forWFB * math.cos(sine / 4)) * 8) + math.rad(45 * (visn / 1000)), math.rad((forWRL - forWRL * math.cos(sine / 4)) * 5), math.rad(-45 * forWRL - 8 * math.cos(sine / 8))) }, "Linear", "InOut", WalkAnimMove / speed)
					SetTween(RW, { C0 = cf(1.45, 0.5 + forWRL / 50 * math.cos(sine / 8), 0) * angles(math.rad(160 - 45 * (visn / 1000)), math.rad(15), math.rad(-10 + forWRL)) }, "Quad", "Out", WalkAnimMove / speed)
				else
					SetTween(RJW, { C0 = RootCF * CFrame.new(0, 0, -0.185 + 0.055 * math.cos(sine / 4) - math.sin(sine / 4) / 8) * angles(math.rad((forWFB * 1.5 - forWFB * math.cos(sine / 4)) * 10), math.rad((-forWRL + forWRL * math.cos(sine / 4)) * 5), math.rad(10 + 8 * math.cos(sine / 8))) }, "Linear", "InOut", WalkAnimMove / speed)
					SetTween(NeckW, { C0 = NeckCF * CFrame.new(0, 0, 0.025 * math.cos(sine / 4)) * angles(math.rad((-forWFB * 2 + forWFB * math.cos(sine / 4)) * 8) + math.rad(20 * (visn / 500)), math.rad((forWRL - forWRL * math.cos(sine / 4)) * 5), math.rad(-forWRL * 50 - 8 * math.cos(sine / 8))) }, "Linear", "InOut", WalkAnimMove / speed)
					SetTween(RW, { C0 = cf(1.45, 0.55 + 0.05 * math.cos(sine / 8), 0) * angles(math.rad(85 - 2 * math.cos(sine / 8)), math.rad(-5), math.rad(10 + (math.random(0, 15) * (visn / 1000)) * math.cos(sine / 8))) }, "Linear", "Out", 0.1 / speed)
				end

				SetTween(LW, { C0 = cf(-1.45, 0.5 + forWRL / 50 * math.cos(sine / 8), 0) * angles(math.rad(-forWFB * 25 * math.cos(sine / 8)), 0, math.rad(-8 - forWRL * 5 * math.cos(sine / 8))) }, "Quad", "Out", WalkAnimMove / speed)
				SetTween(RH, { C0 = CFrame.new(0.5, -0.75 + 0.35 * math.sin(sine / 8), -0.25 + 0.15 * math.cos(sine / 8)) * RH2 * CFrame.Angles(math.rad(-5 * math.cos(sine / 8)), 0, math.rad(2.5)) }, "Linear", "InOut", WalkAnimMove / speed)
				SetTween(LH, { C0 = CFrame.new(-0.5, -0.75 - 0.35 * math.sin(sine / 8), -0.25 - 0.15 * math.cos(sine / 8)) * LH2 * CFrame.Angles(math.rad(5 * math.cos(sine / 8)), 0, math.rad(-2.5)) }, "Linear", "InOut", WalkAnimMove / speed)
			elseif Anim == "Sit" then
				SetTween(RJW, { C0 = RootCF }, "Quad", "InOut", 0.1)
				SetTween(NeckW, { C0 = NeckCF }, "Quad", "InOut", 0.1)
				SetTween(RW, { C0 = CFrame.new(1.5, 0.5, 0) }, "Quad", "Out", 0.1)
				SetTween(LW, { C0 = CFrame.new(-1.5, 0.5, 0) }, "Quad", "Out", 0.1)
				SetTween(RH, { C0 = CFrame.new(0.5, -1, 0) * angles(math.rad(90), 0, 0) }, "Quad", "InOut", 0.1)
				SetTween(LH, { C0 = CFrame.new(-0.5, -1, 0) * angles(math.rad(90), 0, 0) }, "Quad", "InOut", 0.1)
				Humanoid.JumpPower = 60
			end
		end

		Swait(Animstep)
	end
end)
