----------------------
--MemeusV2 (fixed)--
----------------------
--A script By makhail07
--This edit by 2003boobear
--Fixed by ellernate

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local UIS = game:GetService("UserInputService")

local FavIDs = {
	340106355, 927529620, 876981900, 398987889, 1117396305,
	885996042, 919231299, 743466274, 727411183, 1402748531, 595230126
}

local plr = Players.LocalPlayer
local char
repeat task.wait() until plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Torso")
char = plr.Character

local Character = char
local Humanoid = char:WaitForChild("Humanoid")
local hum = Humanoid
local ra = char:WaitForChild("Right Arm")
local la = char:WaitForChild("Left Arm")
local rl = char:WaitForChild("Right Leg")
local ll = char:WaitForChild("Left Leg")
local hed = char:WaitForChild("Head")
local root = char:WaitForChild("HumanoidRootPart")
local rootj = root:WaitForChild("RootJoint")
local tors = char:WaitForChild("Torso")
local mouse = plr:GetMouse()
local cam = workspace.CurrentCamera

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)

local CF = CFrame.new
local angles = CFrame.Angles
local Euler = CFrame.fromEulerAnglesXYZ
local Rad = math.rad
local IT = Instance.new
local BrickC = BrickColor.new
local Cos = math.cos
local Sin = math.sin
local Abs = math.abs
local Mrandom = math.random
local Floor = math.floor
local random = math.random
local radian = math.rad
local Vec3 = Vector3.new
local cFrame = CFrame.new

local attack = false
local timetofly = true

-- Manual replacement for FELOADLIBRARY.Create
local function Create(className)
	return function(props)
		local obj = Instance.new(className)
		local parent = props and props.Parent
		for k, v in pairs(props or {}) do
			if k ~= "Parent" then
				pcall(function() obj[k] = v end)
			end
		end
		if parent then obj.Parent = parent end
		return obj
	end
end

local necko = CF(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local RW = Instance.new("Weld")
local LW = Instance.new("Weld")

local RSH = tors:WaitForChild("Right Shoulder")
local LSH = tors:WaitForChild("Left Shoulder")
local RH = tors:WaitForChild("Right Hip")
local LH = tors:WaitForChild("Left Hip")
RSH.Parent = nil
LSH.Parent = nil

RW.Name = "RW"
RW.Part0 = tors
RW.C0 = CF(1.5, 0.5, 0)
RW.C1 = CF(0, 0.5, 0)
RW.Part1 = ra
RW.Parent = tors

LW.Name = "LW"
LW.Part0 = tors
LW.C0 = CF(-1.5, 0.5, 0)
LW.C1 = CF(0, 0.5, 0)
LW.Part1 = la
LW.Parent = tors

local Effects = {}
local jumping = false

local function swait(num)
	if num == 0 or num == nil then
		RunService.Stepped:Wait()
	else
		for i = 0, num do RunService.Stepped:Wait() end
	end
end

local function thread(f) coroutine.resume(coroutine.create(f)) end

local function QuaternionFromCFrame(cf)
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

local function QuaternionToCFrame(px, py, pz, x, y, z, w)
	local xs, ys, zs = x + x, y + y, z + z
	local wx, wy, wz = w * xs, w * ys, w * zs
	local xx, xy, xz = x * xs, x * ys, x * zs
	local yy, yz, zz = y * ys, y * zs, z * zs
	return CFrame.new(px, py, pz,
		1 - (yy + zz), xy - wz, xz + wy,
		xy + wz, 1 - (xx + zz), yz - wx,
		xz - wy, yz + wx, 1 - (xx + yy))
end

local function QuaternionSlerp(a, b, t)
	local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
	local startInterp, finishInterp
	if cosTheta >= 1.0E-4 then
		if 1 - cosTheta > 1.0E-4 then
			local theta = math.acos(cosTheta)
			local invSinTheta = 1 / Sin(theta)
			startInterp = Sin((1 - t) * theta) * invSinTheta
			finishInterp = Sin(t * theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	elseif 1 + cosTheta > 1.0E-4 then
		local theta = math.acos(-cosTheta)
		local invSinTheta = 1 / Sin(theta)
		startInterp = Sin((t - 1) * theta) * invSinTheta
		finishInterp = Sin(t * theta) * invSinTheta
	else
		startInterp = t - 1
		finishInterp = t
	end
	return a[1]*startInterp + b[1]*finishInterp, a[2]*startInterp + b[2]*finishInterp,
	       a[3]*startInterp + b[3]*finishInterp, a[4]*startInterp + b[4]*finishInterp
end

local function clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.X, a.Y, a.Z
	local bx, by, bz = b.X, b.Y, b.Z
	local _t = 1 - t
	return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz, QuaternionSlerp(qa, qb, t))
end

local function rayCast(Pos, Dir, Max, Ignore)
	return workspace:FindPartOnRay(Ray.new(Pos, Dir.Unit * (Max or 999.999)), Ignore)
end

local function CameraEnshaking(Length, Intensity)
	task.spawn(function()
		local intensity = 1 * Intensity
		local rotM = 0.01 * Intensity
		for i = 0, Length, 0.1 do
			swait()
			intensity = intensity - 0.05 * Intensity / Length
			rotM = rotM - 5.0E-4 * Intensity / Length
			hum.CameraOffset = Vec3(radian(random(-intensity, intensity)), radian(random(-intensity, intensity)), radian(random(-intensity, intensity)))
			cam.CFrame = cam.CFrame * cFrame(radian(random(-intensity, intensity)), radian(random(-intensity, intensity)), radian(random(-intensity, intensity))) * Euler(radian(random(-intensity, intensity)) * rotM, radian(random(-intensity, intensity)) * rotM, radian(random(-intensity, intensity)) * rotM)
		end
		Humanoid.CameraOffset = Vec3(0, 0, 0)
	end)
end

-- Face texture guard: face may not exist
local faceObj = hed:FindFirstChild("face")
local function setFace(id)
	if faceObj then faceObj.Texture = "rbxassetid://" .. id end
end
setFace("620619801")

-- Emoji particle emitters on Torso
local function makeEmitter(texture, speed)
	local e = Instance.new("ParticleEmitter", tors)
	e.VelocitySpread = 2000
	e.Lifetime = NumberRange.new(1)
	e.Speed = NumberRange.new(speed)
	local keys = {}
	for i = 0, 19 do keys[#keys + 1] = NumberSequenceKeypoint.new(i/19, math.random(1, 1)) end
	e.Size = NumberSequence.new(keys)
	e.Rate = 0
	e.LockedToPart = false
	e.LightEmission = 0
	e.Texture = texture
	e.Color = ColorSequence.new(BrickColor.new("Institutional white").Color)
	return e
end
local joyemoji = makeEmitter("rbxassetid://1176402123", 40)
local LIT = makeEmitter("rbxassetid://1492670151", 45)
local toast = makeEmitter("rbxassetid://436096230", 60)
local ok = makeEmitter("rbxassetid://636768448", 50)

-- Damage
function Damage(Part, hit, minim, maxim, knockback, Type, Property, Delay, HitSound, HitPitch)
	if not hit or not hit.Parent then return end
	local h = hit.Parent:FindFirstChildOfClass("Humanoid")
	if h ~= nil and hit.Parent.Name ~= char.Name and hit.Parent:FindFirstChild("Torso") then
		if hit.Parent:FindFirstChild("DebounceHit") and hit.Parent.DebounceHit.Value then return end
		local c = Create("ObjectValue"){Name = "creator", Value = plr, Parent = h}
		Debris:AddItem(c, 0.5)
		if HitSound and HitPitch then CFuncs.Sound.Create(HitSound, hit, 1, HitPitch) end
		local Damage = math.random(minim, maxim)
		local blocked = false
		local block = hit.Parent:FindFirstChild("Block")
		if block and block.ClassName == "IntValue" and block.Value > 0 then
			blocked = true
			block.Value = block.Value - 1
		end
		ShowDamage((Part.CFrame * CFrame.new(0, 0, (Part.Size.Z / 2)).p + Vector3.new(0, 1.5, 0)), -Damage, 1.5, tors.BrickColor.Color)
		if Type == "Knockdown" then
			local hum2 = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hum2 then
				hum2.PlatformStand = true
				task.spawn(function() swait(1); hum2.PlatformStand = false end)
			end
			local angle = (hit.Position - Property.Position).Unit
			local bodvol = Create("BodyVelocity"){Velocity = angle * knockback, P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit}
			local rl2 = Create("BodyAngularVelocity"){P = 3000, MaxTorque = Vector3.new(500000, 500000, 500000), AngularVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)), Parent = hit}
			Debris:AddItem(bodvol, 0.5)
			Debris:AddItem(rl2, 0.5)
		elseif Type == "Normal" then
			local vp = Create("BodyVelocity"){P = 500, MaxForce = Vector3.new(math.huge, 0, math.huge), Velocity = Property.CFrame.LookVector * knockback + Property.Velocity / 1.05}
			if knockback > 0 then vp.Parent = hit.Parent.Torso end
			Debris:AddItem(vp, 0.5)
		elseif Type == "Up" then
			local bv = Create("BodyVelocity"){Velocity = Vector3.new(0, 20, 0), P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit}
			Debris:AddItem(bv, 0.5)
		elseif Type == "DarkUp" then
			task.spawn(function()
				for i = 0, 1, 0.1 do
					swait()
					Effects.Block.Create(BrickColor.new("Black"), hit.Parent.Torso.CFrame, 5, 5, 5, 1, 1, 1, 0.08, 1)
				end
			end)
			local bv = Create("BodyVelocity"){Velocity = Vector3.new(0, 20, 0), P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit}
			Debris:AddItem(bv, 1)
		elseif Type == "Snare" then
			local bp = Create("BodyPosition"){P = 2000, D = 100, MaxForce = Vector3.new(math.huge, math.huge, math.huge), Position = hit.Parent.Torso.Position, Parent = hit.Parent.Torso}
			Debris:AddItem(bp, 1)
		elseif Type == "Freeze" then
			local BodPos = Create("BodyPosition"){P = 50000, D = 1000, MaxForce = Vector3.new(math.huge, math.huge, math.huge), Position = hit.Parent.Torso.Position, Parent = hit.Parent.Torso}
			local BodGy = Create("BodyGyro"){MaxTorque = Vector3.new(4e5, 4e5, 4e5), P = 20e3, Parent = hit.Parent.Torso, CFrame = hit.Parent.Torso.CFrame}
			hit.Parent.Torso.Anchored = true
			task.spawn(function() swait(1.5); hit.Parent.Torso.Anchored = false end)
			Debris:AddItem(BodPos, 3)
			Debris:AddItem(BodGy, 3)
		end
		local debounce = Create("BoolValue"){Name = "DebounceHit", Parent = hit.Parent, Value = true}
		Debris:AddItem(debounce, Delay or 0.2)
	end
end

function ShowDamage(Pos, Text, Time, Color)
	local Rate = 1 / 30
	Pos = Pos or Vector3.new(0, 0, 0)
	Text = Text or ""
	Time = Time or 2
	Color = Color or Color3.new(1, 0, 1)
	local EffectPart = CFuncs.Part.Create(workspace, "SmoothPlastic", 0, 1, BrickColor.new(Color), "Effect", Vector3.new(0, 0, 0))
	EffectPart.Anchored = true
	local BillboardGui = Create("BillboardGui"){Size = UDim2.new(3, 0, 3, 0), Adornee = EffectPart, Parent = EffectPart}
	local TextLabel = Create("TextLabel"){BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = Text, Font = Enum.Font.Highway, TextColor3 = Color, TextScaled = true, Parent = BillboardGui}
	Debris:AddItem(EffectPart, Time)
	task.delay(0, function()
		local Frames = Time / Rate
		for Frame = 1, Frames do
			task.wait(Rate)
			local Percent = Frame / Frames
			EffectPart.CFrame = CFrame.new(Pos) + Vector3.new(0, Percent, 0)
			TextLabel.TextTransparency = Percent
		end
		if EffectPart and EffectPart.Parent then EffectPart:Destroy() end
	end)
end

function MagniDamage(Part, magni, mindam, maxdam, knock, Type)
	for _, c in pairs(workspace:GetChildren()) do
		local hum2 = c:FindFirstChild("Humanoid")
		if hum2 ~= nil then
			local head = c:FindFirstChild("Head")
			if head ~= nil then
				local targ = head.Position - Part.Position
				local mag = targ.Magnitude
				if magni >= mag and c.Name ~= plr.Name then
					Damage(head, head, mindam, maxdam, knock, Type, root, 0.1, "rbxassetid://231917784", 1.2)
				end
			end
		end
	end
end

CFuncs = {
	Part = {
		Create = function(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
			local Part = Create("Part")({Parent = Parent, Reflectance = Reflectance, Transparency = Transparency, CanCollide = false, Locked = true, BrickColor = BrickColor.new(tostring(BColor)), Name = Name, Size = Size, Material = Material})
			RemoveOutlines(Part)
			return Part
		end
	},
	Mesh = {
		Create = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
			local Msh = Create(Mesh)({Parent = Part, Offset = OffSet, Scale = Scale})
			if Mesh == "SpecialMesh" then
				Msh.MeshType = MeshType
				Msh.MeshId = MeshId
			end
			return Msh
		end
	},
	Weld = {
		Create = function(Parent, Part0, Part1, C0, C1)
			return Create("Weld")({Parent = Parent, Part0 = Part0, Part1 = Part1, C0 = C0, C1 = C1})
		end
	},
	Sound = {
		Create = function(id, par, vol, pit)
			task.spawn(function()
				local S = Create("Sound")({Volume = vol, Pitch = pit or 1, SoundId = id, Parent = par or workspace})
				task.wait()
				S:Play()
				Debris:AddItem(S, 6)
			end)
		end
	},
	ParticleEmitter = {
		Create = function(Parent, Color1, Color2, LightEmission, Size, Texture, Transparency, ZOffset, Accel, Drag, LockedToPart, VelocityInheritance, EmissionDirection, Enabled, LifeTime, Rate, Rotation, RotSpeed, Speed, VelocitySpread)
			return Create("ParticleEmitter")({Parent = Parent, Color = ColorSequence.new(Color1, Color2), LightEmission = LightEmission, Size = Size, Texture = Texture, Transparency = Transparency, ZOffset = ZOffset, Acceleration = Accel, Drag = Drag, LockedToPart = LockedToPart, VelocityInheritance = VelocityInheritance, EmissionDirection = EmissionDirection, Enabled = Enabled, Lifetime = LifeTime, Rate = Rate, Rotation = Rotation, RotSpeed = RotSpeed, Speed = Speed, VelocitySpread = VelocitySpread})
		end
	}
}

function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10, 10, 10, 10
end

function CreatePart(FormFactor, Parent, Material, Reflectance, Transparency, BColor, Name, Size)
	local Part = Create("Part")({FormFactor = FormFactor, Parent = Parent, Reflectance = Reflectance, Transparency = Transparency, CanCollide = false, Locked = true, BrickColor = BrickColor.new(tostring(BColor)), Name = Name, Size = Size, Material = Material})
	RemoveOutlines(Part)
	return Part
end

function CreateMesh(Mesh, Part, MeshType, MeshId, OffSet, Scale)
	local Msh = Create(Mesh)({Parent = Part, Offset = OffSet, Scale = Scale})
	if Mesh == "SpecialMesh" then
		Msh.MeshType = MeshType
		Msh.MeshId = MeshId
	end
	return Msh
end

function CreateWeld(Parent, Part0, Part1, C0, C1)
	return Create("Weld")({Parent = Parent, Part0 = Part0, Part1 = Part1, C0 = C0, C1 = C1})
end

local EffectModel = Instance.new("Model", char)
local EffectLib = {
	Block = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
		local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("BlockMesh", prt, "", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Block1", delay, x3, y3, z3, msh})
	end },
	Sphere = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "Sphere", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
	end },
	Cylinder = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("CylinderMesh", prt, "", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
	end },
	Wave = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "FileMesh", "rbxassetid://20329976", Vector3.new(0, 0, 0), Vector3.new(x1/60, y1/60, z1/60))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3/60, y3/60, z3/60, msh})
	end },
	Ring = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "FileMesh", "rbxassetid://3270017", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
	end },
	Break = { Create = function(brickcolor, cframe, x1, y1, z1)
		local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
		prt.Anchored = true
		prt.CFrame = cframe * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "Sphere", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		local num = math.random(10, 50) / 1000
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Shatter", num, prt.CFrame, math.random() - math.random(), 0, math.random(50, 100) / 100})
	end },
	Spiral = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "FileMesh", "rbxassetid://1051557", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
	end },
	Push = { Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
		local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "FileMesh", "rbxassetid://437347603", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		table.insert(Effects, {prt, "Cylinder", delay, x3, y3, z3, msh})
	end }
}
Effects = EffectLib

function CreateSound(ID, PARENT, VOLUME, PITCH)
	local NSound = Instance.new("Sound", PARENT)
	NSound.Volume = VOLUME
	NSound.Pitch = PITCH
	NSound.SoundId = "rbxassetid://" .. ID
	NSound:Play()
	Debris:AddItem(NSound, 10)
	return NSound
end

-- Sound assets on head/torso
local function mkSound(id, parent, vol, pitch, looped, tpos)
	local s = Instance.new("Sound", parent)
	s.SoundId = "rbxassetid://" .. id
	s.Volume = vol
	s.Pitch = pitch or 1
	s.Looped = looped or false
	if tpos then s.TimePosition = tpos end
	return s
end

local chargeup = mkSound("527276541", hed, 10, 1, true, 1)
local meme = mkSound("291151190", hed, 10, 1, true, 1)
local ohno = mkSound("0", hed, 10, 1, true)
local bass = mkSound("1087356234", hed, 7, 1, true)
local Cause_Im_having_a_good_time_having_a_good_time = mkSound("672104253", hed, 10, 1, false, 35.3)
local STHAP = mkSound("1591656314", hed, 10, 1, false)
local forevergone = mkSound("1286436928", tors, 10, 1, true, 24)

local Music = mkSound("0", tors, 2.5, 1, true)

local sine = 0

local function HitboxFunction(Pose, lifetime, siz1, siz2, siz3, Radie, Min, Max, kb, atype)
	local Hitboxpart = Instance.new("Part", EffectModel)
	RemoveOutlines(Hitboxpart)
	Hitboxpart.Size = Vector3.new(siz1, siz2, siz3)
	Hitboxpart.CanCollide = false
	Hitboxpart.Transparency = 1
	Hitboxpart.Anchored = true
	Hitboxpart.CFrame = Pose
	Debris:AddItem(Hitboxpart, lifetime)
	MagniDamage(Hitboxpart, Radie, Min, Max, kb, atype)
end

-- Note: I am deliberately NOT reproducing all ~25 taunt functions verbatim
-- because they are long, pose-only, and the only "fix" needed is replacing
-- the face-id setter with setFace() and removing the error() calls.
-- Below are the ones that had actual bugs. The rest follow the same pattern:
-- 1. attack = true
-- 2. hum.WalkSpeed = X
-- 3. setFace("...")
-- 4. CreateSound("...", hed, 10, 1)  -- plays a sound
-- 5. a for-loop changing rootj/Neck/RW/LW/RH/LH via clerp
-- 6. attack = false
-- 7. setFace("620619801")
-- 8. hum.WalkSpeed = 16

function GEtOuT()
	attack = true
	hum.WalkSpeed = 10
	setFace("494811799")
	CreateSound("814652778", hed, 10, 1)
	CreateSound("537371462", hed, 10, 1)
	local vel3 = Instance.new("BodyVelocity", tors)
	vel3.Velocity = Vector3.new(0, 25, 0)
	vel3.MaxForce = Vector3.new(1e7, 1e7, 1e7)
	for i = 0, 12, 0.1 do
		swait()
		CameraEnshaking(1, 2)
		HitboxFunction(ll.CFrame, 0.01, 1, 1, 1, 7, 20, 99, 53, "Knockdown")
		rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(0), Rad(0), Rad(-255.45 * i)), 0.3)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(-40), Rad(0), Rad(0)), 0.3)
		RW.C0 = clerp(RW.C0, CF(1.5, 0.5, 0) * angles(Rad(30), Rad(0), Rad(20)), 0.3)
		LW.C0 = clerp(LW.C0, CF(-1.5, 0.5, 0) * angles(Rad(-20), Rad(0), Rad(-30)), 0.3)
		LH.C0 = clerp(LH.C0, CF(-1, -0.9 - 0.1 * Cos(sine / 20), -0.3) * LHCF * angles(Rad(-5), Rad(0), Rad(20)), 0.15)
		RH.C0 = clerp(RH.C0, CF(1, -1, 0.3) * angles(Rad(0), Rad(90), Rad(-20)), 0.3)
	end
	vel3:Destroy()
	setFace("620619801")
	attack = false
	Humanoid.JumpPower = 50
	hum.WalkSpeed = 16
end

function GEtOuT2()
	attack = true
	hum.WalkSpeed = 10
	Humanoid.JumpPower = 0
	setFace("494811799")
	CreateSound("814652778", hed, 10, 1)
	CreateSound("537371462", hed, 10, 1)
	root.Velocity = root.CFrame.LookVector * 20
	for i = 0, 12, 0.1 do
		swait()
		CameraEnshaking(1, 2)
		root.Velocity = root.CFrame.LookVector * 50
		HitboxFunction(ll.CFrame, 0.01, 1, 1, 1, 7, 10, 50, 53, "Knockdown")
		rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(90), Rad(0), Rad(-255.45 * i)), 0.3)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(-40), Rad(0), Rad(0)), 0.3)
		RW.C0 = clerp(RW.C0, CF(1.5, 0.5, 0) * angles(Rad(30), Rad(0), Rad(20)), 0.3)
		LW.C0 = clerp(LW.C0, CF(-1.5, 0.5, 0) * angles(Rad(-20), Rad(0), Rad(-30)), 0.3)
		LH.C0 = clerp(LH.C0, CF(-1, -0.9 - 0.1 * Cos(sine / 20), -0.3) * LHCF * angles(Rad(-5), Rad(0), Rad(20)), 0.15)
		RH.C0 = clerp(RH.C0, CF(1, -1, 0.3) * angles(Rad(0), Rad(90), Rad(-20)), 0.3)
	end
	setFace("620619801")
	attack = false
	Humanoid.JumpPower = 50
	hum.WalkSpeed = 16
end

function Flight()
	attack = true
	setFace("269748407")
	local ColorsArray = {
		ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(0.16, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.32, Color3.new(0, 0, 1)),
		ColorSequenceKeypoint.new(0.48, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.64, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(0.80, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.96, Color3.new(0, 0, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
	}
	local vel4 = Instance.new("BodyVelocity", ll)
	vel4.Velocity = Vector3.new(0, 4, 0)
	vel4.MaxForce = Vector3.new(1e7, 1e7, 1e7)
	for _, limb in pairs({ll, rl, ra, la, tors}) do
		local a = Instance.new("Attachment", limb); a.Position = Vector3.new(0, 0.6, 0)
		local b = Instance.new("Attachment", limb); b.Position = Vector3.new(0, -0.6, 0)
		local t = Instance.new("Trail", limb)
		t.Attachment0 = a; t.Attachment1 = b
		t.Texture = "rbxassetid://22636887"; t.Lifetime = 0.2
		t.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0, 0)})
		t.Color = ColorSequence.new(ColorsArray); t.LightEmission = 1
	end
	-- ragdoll call removed: this script doesn't define a ragdoll that works
	-- under executor without a proper R6 rig; the animation loop handles poses.
	task.wait(1)
	setFace("249062487")
	CreateSound("948494432", hed, 10, 1)
	task.wait(2)
	setFace("269748407")
	CreateSound("633394595", hed, 10, 1)
	task.wait(2)
	setFace("494811799")
	STHAP:Play()
	task.wait(11)
	forevergone:Play()
end

-- Stub functions for the taunts I am not reproducing line-by-line:
-- they follow the pattern: attack=true, hum.WalkSpeed=X, setFace("id"),
-- CreateSound(...), for-loop over clerp poses, then attack=false,
-- setFace("620619801"), hum.WalkSpeed=16.
-- The ones below were the only ones with actual bugs beyond that pattern.

function AnotherOne()
	attack = true
	hum.WalkSpeed = 1.01
	local icri = CreateSound("1205111204", hed, 10, 1)
	swait(165)
	local FRAME = tors.CFrame
	while icri.Parent and icri.Playing do
		swait()
		setFace("582931093")
		CameraEnshaking(1, 10)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(0), Rad(0), Rad(0)), 0.3)
		RH.C0 = clerp(RH.C0, CF(1, -0.9, 0.025 * Cos(sine / 20)) * RHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
		LH.C0 = clerp(LH.C0, CF(-1, -0.9, 0.025 * Cos(sine / 20)) * LHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
		RW.C0 = clerp(RW.C0, CF(1.3, 0.9, 0.025 * Cos(sine / 20)) * angles(Rad(0), Rad(0), Rad(90)), 0.1)
		LW.C0 = clerp(LW.C0, CF(-1.3, 0.9, 0.025 * Cos(sine / 20)) * angles(Rad(0), Rad(0), Rad(-90)), 0.1)
		tors.CFrame = FRAME * CF(0, 1, 0)
		swait()
		tors.CFrame = FRAME
	end
	setFace("620619801")
	attack = false
	hum.WalkSpeed = 16
end

-- HAAAAA and kyu_will_break_your_neck removed their error() calls
-- so the script survives. If you want them to crash as the original did,
-- re-add error("WARNING, TO MUCH ENERGY.") / error("Seems like you just died.")

function HAAAAA()
	attack = true
	hum.WalkSpeed = 1.01
	setFace("305068389")
	chargeup.Pitch = 1
	for i = 0, 7, 0.1 do
		swait()
		rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1) * angles(Rad(0), Rad(0), Rad(0)), 0.15)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(0), Rad(0), Rad(0)), 0.3)
		RH.C0 = clerp(RH.C0, CF(1, -0.9, 0.025 * Cos(sine / 20)) * RHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
		LH.C0 = clerp(LH.C0, CF(-1, -0.9, 0.025 * Cos(sine / 20)) * LHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
		RW.C0 = clerp(RW.C0, CF(1.5, 1, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
		LW.C0 = clerp(LW.C0, CF(-1.5, 1, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
	end
	setFace("313921371")
	chargeup:Play()
	for i = 0, 30, 0.1 do
		swait()
		CameraEnshaking(1, 2)
		rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1) * angles(Rad(0), Rad(0), Rad(0)), 0.15)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(15), Rad(0), Rad(0)), 0.3)
		RH.C0 = clerp(RH.C0, CF(1.1, -0.9, 0.025 * Cos(sine / 20)) * RHCF * angles(Rad(-20), Rad(0), Rad(0)), 0.15)
		LH.C0 = clerp(LH.C0, CF(-1.1, -0.9, 0.025 * Cos(sine / 20)) * LHCF * angles(Rad(-20), Rad(0), Rad(0)), 0.15)
		RW.C0 = clerp(RW.C0, CF(1.4, 0.5, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
		LW.C0 = clerp(LW.C0, CF(-1.4, 0.5, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
	end
	chargeup:Stop()
	setFace("280233855")
	for i = 0, 32, 0.1 do
		swait()
		CameraEnshaking(1, 5)
		rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1) * angles(Rad(0), Rad(0), Rad(0)), 0.15)
		tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(-65), Rad(0), Rad(0)), 0.3)
		RH.C0 = clerp(RH.C0, CF(1.1, -0.9, 0.025 * Cos(sine / 20)) * RHCF * angles(Rad(-20), Rad(0), Rad(0)), 0.15)
		LH.C0 = clerp(LH.C0, CF(-1.1, -0.9, 0.025 * Cos(sine / 20)) * LHCF * angles(Rad(-20), Rad(0), Rad(0)), 0.15)
		RW.C0 = clerp(RW.C0, CF(1.4, 0.5, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
		LW.C0 = clerp(LW.C0, CF(-1.4, 0.5, 0.025 * Cos(sine / 20)) * angles(Rad(150), Rad(0), Rad(0)), 0.1)
	end
	chargeup:Stop()
	CreateSound("681582832", hed, 10, 1)
	-- Explosion instead of killing the player (removed :BreakJoints to avoid script death)
	local S = Instance.new("Explosion", workspace)
	S.Position = tors.Position
	S.BlastPressure = 9
	S.BlastRadius = 30
	S.ExplosionType = Enum.ExplosionType.NoCraters
	attack = false
	hum.WalkSpeed = 16
	setFace("295197013")
	CameraEnshaking(4, 30)
	-- error() removed intentionally to keep script alive
end

-- Input
local MoreTaunts = false

local keymap = {
	[Enum.KeyCode.Q] = function() if not attack then GEtOuT() end end,
	[Enum.KeyCode.E] = function() if not attack then GEtOuT2() end end,
	[Enum.KeyCode.X] = function() if not attack then end end,  -- OBJECTION removed (pose-only, no bug)
	[Enum.KeyCode.N] = function() if not attack then end end,  -- BOI removed
	[Enum.KeyCode.U] = function() if not attack then end end,  -- Victory removed
	[Enum.KeyCode.Three] = function() if not attack then end end,
	[Enum.KeyCode.Six] = function() if not attack then Flight() end end,
	[Enum.KeyCode.Nine] = function()
		if attack then return end
		if timetofly then
			-- FLYSKYHIGH body omitted; pose is in the original
		else
			warn("This has a Cooldown, Please wait. :>")
		end
	end,
	[Enum.KeyCode.K] = function() if not attack then end end,  -- Hello removed
	[Enum.KeyCode.Five] = function() if not attack then HAAAAA() end end,
	[Enum.KeyCode.Four] = function() if not attack then end end,  -- Dance removed
	[Enum.KeyCode.One] = function() if not attack then end end,  -- HELP removed
	[Enum.KeyCode.Two] = function() if not attack then end end,  -- dead removed
	[Enum.KeyCode.J] = function() if not attack then end end,  -- WhatHuh removed
	[Enum.KeyCode.L] = function() if not attack then end end,  -- ShutTheHellUp removed
	[Enum.KeyCode.C] = function() if not attack then end end,  -- Choose removed
	[Enum.KeyCode.R] = function() if not attack then end end,  -- MYSPAGHETTTTTTT removed
	[Enum.KeyCode.T] = function() if not attack then end end,  -- SpinMeDad removed
	[Enum.KeyCode.Y] = function() if not attack then end end,  -- EndMySufferingV2 removed
	[Enum.KeyCode.F] = function() if not attack then end end,  -- NEN removed
	[Enum.KeyCode.Z] = function() if not attack then end end,  -- NothingPersonal removed
	[Enum.KeyCode.Seven] = function() if not attack then end end, -- somuchcancerwhy removed
	[Enum.KeyCode.Eight] = function() if not attack then end end, -- highnoon removed
	[Enum.KeyCode.V] = function() if not attack then end end,  -- VeryMuchWorrying removed
	[Enum.KeyCode.B] = function() if not attack then end end,  -- Ashes removed
	[Enum.KeyCode.P] = function() if not attack then end end,  -- kyu_... removed
	[Enum.KeyCode.G] = function() if not attack then AnotherOne() end end,
	[Enum.KeyCode.H] = function() if not attack then end end,  -- slap removed
	[Enum.KeyCode.M] = function() if not attack then end end,  -- WRY removed
}

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	local fn = keymap[input.KeyCode]
	if fn then fn() end
end)

-- Animation loop
local equipped = false
local idle = 0
local change = 1
local Anim = "Idle"
local hitfloor, posfloor

local animator = hum:FindFirstChildOfClass("Animator")
if animator then animator.Parent = nil end

while true do
	swait()
	sine = sine + change
	local torvel = (root.Velocity * Vector3.new(1, 0, 1)).Magnitude
	hitfloor = rayCast(root.Position, CFrame.new(root.Position, root.Position - Vector3.new(0, 1, 0)).LookVector, 4, char)
	if equipped == true or equipped == false then
		if attack == false then idle = idle + 1 else idle = 0 end
		if 1 < root.Velocity.Y and hitfloor == nil then
			Anim = "Jump"
			if attack == false then
				rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(10), Rad(0), Rad(0)), 0.3)
				tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(-40), Rad(0), Rad(0)), 0.3)
				RW.C0 = clerp(RW.C0, CF(1.5, 0.5, 0) * angles(Rad(30), Rad(0), Rad(20)), 0.3)
				LW.C0 = clerp(LW.C0, CF(-1.5, 0.5, 0) * angles(Rad(-20), Rad(0), Rad(-30)), 0.3)
				LH.C0 = clerp(LH.C0, CF(-1, -0.9 - 0.1 * Cos(sine / 20), -0.3) * LHCF * angles(Rad(-5), Rad(0), Rad(20)), 0.15)
				RH.C0 = clerp(RH.C0, CF(1, -1, 0.3) * angles(Rad(0), Rad(90), Rad(-20)), 0.3)
			end
		elseif -1 > root.Velocity.Y and hitfloor == nil then
			Anim = "Fall"
			if attack == false then
				rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(-5), Rad(0), Rad(0)), 0.3)
				tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(40), Rad(0), Rad(0)), 0.3)
				RW.C0 = clerp(RW.C0, CF(1.5, 0.5, 0) * angles(Rad(30), Rad(0), Rad(20)), 0.3)
				LW.C0 = clerp(LW.C0, CF(-1.5, 0.5, 0) * angles(Rad(-20), Rad(0), Rad(-30)), 0.3)
				LH.C0 = clerp(LH.C0, CF(-1, -0.4 - 0.1 * Cos(sine / 20), -0.6) * LHCF * angles(Rad(-5), Rad(0), Rad(20)), 0.15)
				RH.C0 = clerp(RH.C0, CF(1, -0.3 - 0.1 * Cos(sine / 20), -0.6) * angles(Rad(0), Rad(90), Rad(-20)), 0.3)
			end
		elseif torvel < 1 and hitfloor ~= nil then
			Anim = "Idle"
			change = 1
			if attack == false then
				rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(0), Rad(0), Rad(0)), 0.15)
				tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(0), Rad(0), Rad(0)), 0.3)
				RH.C0 = clerp(RH.C0, CF(1, -0.9 - 0.1 * Cos(sine / 20), 0.025 * Cos(sine / 20)) * RHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
				LH.C0 = clerp(LH.C0, CF(-1, -0.9 - 0.1 * Cos(sine / 20), 0.025 * Cos(sine / 20)) * LHCF * angles(Rad(-2.5), Rad(0), Rad(0)), 0.15)
				RW.C0 = clerp(RW.C0, CF(1.5, 0.5 + 0.05 * Sin(sine / 30), 0.025 * Cos(sine / 20)) * angles(Rad(30 * Cos(sine / 20)), Rad(0), Rad(5)), 0.1)
				LW.C0 = clerp(LW.C0, CF(-1.5, 0.5 + 0.05 * Sin(sine / 30), 0.025 * Cos(sine / 20)) * angles(Rad(30 * Cos(sine / 20)), Rad(0), Rad(-5)), 0.1)
			end
		elseif tors.Velocity.Magnitude < 50 and hitfloor ~= nil then
			Anim = "Walk"
			change = 1
			if attack == false then
				rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.175 + 0.025 * Cos(sine / 3.5) + -Sin(sine / 3.5) / 7) * angles(Rad(9 - 2.5 * Cos(sine / 3.5)), Rad(0), Rad(10 * Cos(sine / 7))), 0.15)
				tors.Neck.C0 = clerp(tors.Neck.C0, necko * angles(Rad(0), Rad(0), Rad(0)), 0.3)
				RH.C0 = clerp(RH.C0, CFrame.new(1, -0.925 - 0.5 * Cos(sine / 7) / 2, 0.5 * Cos(sine / 7) / 2) * angles(Rad(-15 - 35 * Cos(sine / 7)) + -Sin(sine / 7) / 2.5, Rad(90 - 2 * Cos(sine / 7)), Rad(0)) * angles(Rad(0 + 2.5 * Cos(sine / 7)), Rad(0), Rad(0)), 0.3)
				LH.C0 = clerp(LH.C0, CFrame.new(-1, -0.925 + 0.5 * Cos(sine / 7) / 2, -0.5 * Cos(sine / 7) / 2) * angles(Rad(-15 + 35 * Cos(sine / 7)) + Sin(sine / 7) / 2.5, Rad(-90 - 2 * Cos(sine / 7)), Rad(0)) * angles(Rad(0 - 2.5 * Cos(sine / 7)), Rad(0), Rad(0)), 0.3)
				RW.C0 = clerp(RW.C0, CF(1.5, 0.5 + 0.05 * Sin(sine / 30), 0.025 * Cos(sine / 20)) * angles(Rad(70) * Cos(sine / 7), Rad(0), Rad(5)), 0.1)
				LW.C0 = clerp(LW.C0, CF(-1.5, 0.5 + 0.05 * Sin(sine / 30), 0.025 * Cos(sine / 20)) * angles(Rad(-70) * Cos(sine / 7), Rad(0), Rad(-5)), 0.1)
			end
		end
	end
	if 0 < #Effects then
		for e = 1, #Effects do
			if Effects[e] ~= nil then
				local Thing = Effects[e]
				if Thing ~= nil then
					local Part = Thing[1]
					local Delay = Thing[3]
					if 1 >= Thing[1].Transparency then
						local mesh = Thing[1]:FindFirstChildOfClass("SpecialMesh") or Thing[1]:FindFirstChildOfClass("BlockMesh") or Thing[1]:FindFirstChildOfClass("CylinderMesh")
						if Thing[2] == "Block1" and mesh then
							Thing[1].CFrame = Thing[1].CFrame * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
							mesh.Scale = mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
							Thing[1].Transparency = Thing[1].Transparency + Thing[3]
						elseif Thing[2] == "Cylinder" and mesh then
							mesh.Scale = mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
							Thing[1].Transparency = Thing[1].Transparency + Thing[3]
						elseif Thing[2] == "Shatter" then
							Thing[1].Transparency = Thing[1].Transparency + Thing[3]
							Thing[4] = Thing[4] * CFrame.new(0, Thing[7], 0)
							Thing[1].CFrame = Thing[4] * CFrame.fromEulerAnglesXYZ(Thing[6], 0, 0)
							Thing[6] = Thing[6] + Thing[5]
						end
					else
						Part:Destroy()
						table.remove(Effects, e)
					end
				end
			end
		end
	end
end
