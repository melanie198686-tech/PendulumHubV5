--// "WhAT ANOTHER ONE" mode-switcher (original by makhail07) -- fixed
--// Keys: click combo | 0 sprint | N toggle name tag
--//   Q Edgy   (R Decapitate, E Laugh)
--//   E Divinity (F Blast Of God, R beam placeholder)
--//   R Fighter (E Flying Kick, F Uppercut, T Spinning Kick)
--//   T Purity  (R Purity Slam)
--//   Y Destruction (R Diablo Explosion, F Hell From Above, T Spinning Below)
--//   U Insanity (R Painful Stomp, F Ending, T Ende der Weld)
--//   F Planetary
--// Fixed by ellernate.lol

local LOAD_REANIMATE = true -- true: loads the reanimate that builds workspace.non. false: you start your own first.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local ChatS = game:GetService("Chat")

if LOAD_REANIMATE then
	Bypass = "death"
	loadstring(game:GetObjects("rbxassetid://5325226148")[1].Source)()
end

local plr = Players.LocalPlayer
local char = workspace:WaitForChild("non", 15)
if not char then
	warn("workspace.non not found - run a reanimate first (or set LOAD_REANIMATE = true)")
	return
end
local realChar = plr.Character or plr.CharacterAdded:Wait()
local mouse = plr:GetMouse()

---------------------------------------------------------------- netless + fling
Bypass = "Death"
RunService.Heartbeat:Connect(function()
	local c = plr.Character
	if not c then return end
	for _, v in ipairs(c:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.AssemblyLinearVelocity = Vector3.new(0, 30, 0)
		end
	end
end)
warn("Netless Activated!")

local bullet = realChar:WaitForChild("HumanoidRootPart")
bullet.Transparency = 1
bullet.Massless = true
local bbv = Instance.new("BodyPosition", bullet)
bbv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bbv.Position = (realChar:FindFirstChild("Torso") or bullet).Position

local holding = false
mouse.Button1Down:Connect(function()
	holding = true
	local bbav = Instance.new("BodyAngularVelocity", bullet)
	bbav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bbav.P = math.huge
	bbav.AngularVelocity = Vector3.new(1e9, 1e9, 1e9)
	Debris:AddItem(bbav, 0.1)
	local t = mouse.Target
	if not t then return end
	local model = t:FindFirstAncestorOfClass("Model")
	if not model or model == realChar or model.Name == "non" then return end
	if not Players:GetPlayerFromCharacter(model) then return end
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	RunService.RenderStepped:Wait()
	bbv.Position = hrp.Position
	bullet.CFrame = CFrame.new(hrp.Position)
	task.wait(1)
end)
mouse.Button1Up:Connect(function() holding = false end)
RunService.Heartbeat:Connect(function()
	bullet.AssemblyLinearVelocity = Vector3.new(0, 26, 0)
	if holding and mouse.Target then bullet.CFrame = CFrame.new(mouse.Hit.Position) end
end)

local animate = realChar:FindFirstChild("Animate")
if animate then animate.Disabled = true end

---------------------------------------------------------------- rig
local hum = char:WaitForChild("Humanoid")
local ra, la = char["Right Arm"], char["Left Arm"]
local rl, ll = char["Right Leg"], char["Left Leg"]
local hed = char.Head
local root = char.HumanoidRootPart
local rootj = root.RootJoint
local tors = char.Torso

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)
local necko = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

CF, angles, Euler = CFrame.new, CFrame.Angles, CFrame.fromEulerAnglesXYZ
Rad, IT, BrickC = math.rad, Instance.new, BrickColor.new
Cos, Sin, Mrandom = math.cos, math.sin, math.random
local attack = false
local maincolor = BrickColor.new("Institutional white")

local RH, LH = tors["Right Hip"], tors["Left Hip"]
tors["Right Shoulder"].Parent = nil
tors["Left Shoulder"].Parent = nil
local RW, LW = Instance.new("Weld"), Instance.new("Weld")
RW.Name, RW.Part0, RW.C0, RW.C1, RW.Part1, RW.Parent = "RW", tors, CF(1.5, 0.5, 0), CF(0, 0.5, 0), ra, tors
LW.Name, LW.Part0, LW.C0, LW.C1, LW.Part1, LW.Parent = "LW", tors, CF(-1.5, 0.5, 0), CF(0, 0.5, 0), la, tors

---------------------------------------------------------------- core helpers
local sine = 0
function swait(num)
	if not num or num == 0 then
		RunService.Stepped:Wait()
	else
		for _ = 0, num do RunService.Stepped:Wait() end
	end
end
function clerp(a, b, t) return a:Lerp(b, t) end

local function C(k) return Cos(sine / k) end
local function Sn(k) return Sin(sine / k) end
local function loop(max, fn)
	for i = 0, max, 0.1 do
		swait()
		fn(i)
	end
end

function rayCast(Position, Direction, Range, Ignore)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = type(Ignore) == "table" and Ignore or { Ignore }
	local d = Direction.Unit * (Range or 999.999)
	local res = workspace:Raycast(Position, d, params)
	if res then return res.Instance, res.Position end
	return nil, Position + d
end

-- RbxUtility.Create replacement: Create("Class"){Prop = v, Parent = p}
local function Create(class)
	return function(props)
		local o = Instance.new(class)
		local parent
		for k, v in pairs(props) do
			if k == "Parent" then parent = v else pcall(function() o[k] = v end) end
		end
		if parent then o.Parent = parent end
		return o
	end
end

function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface = 10, 10, 10
	part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10
end

CFuncs = {
	Part = { Create = function(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
		local p = Create("Part"){ Parent = Parent, Reflectance = Reflectance, Transparency = Transparency, CanCollide = false,
			Locked = true, BrickColor = BrickColor.new(tostring(BColor)), Name = Name, Size = Size, Material = Material, Massless = true }
		RemoveOutlines(p)
		return p
	end },
	Mesh = { Create = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
		local ms = Create(Mesh){ Parent = Part, Offset = OffSet, Scale = Scale }
		if Mesh == "SpecialMesh" then
			ms.MeshType = MeshType
			if MeshId ~= "" then ms.MeshId = MeshId end
		end
		return ms
	end },
	Sound = { Create = function(id, par, vol, pit)
		task.spawn(function()
			local S = Create("Sound"){ Volume = vol, Pitch = pit or 1, SoundId = id, Parent = par or workspace }
			task.wait()
			S:Play()
			Debris:AddItem(S, 6)
		end)
	end },
}

function CreateSound(ID, PARENT, VOLUME, PITCH)
	task.spawn(function()
		local s = Instance.new("Sound", PARENT)
		s.Volume, s.Pitch, s.SoundId = VOLUME, PITCH, "http://www.roblox.com/asset/?id=" .. ID
		swait()
		s:Play()
		Debris:AddItem(s, 10)
	end)
end

---------------------------------------------------------------- effects
local EffectModel = Instance.new("Model", char)
Effects = {}
local function addEffect(kind, prt, delay, x3, y3, z3, msh)
	table.insert(Effects, { prt, kind, delay, x3, y3, z3, msh })
end
local function fx(meshKind, mat, meshType, meshId, mode)
	return function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
		local prt = CFuncs.Part.Create(EffectModel, mat, 0, 0, brickcolor, "Effect", Vector3.new())
		prt.Anchored = true
		prt.CFrame = cframe
		local msh = CFuncs.Mesh.Create(meshKind, prt, meshType or "", meshId or "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
		Debris:AddItem(prt, 10)
		local m = mode
		if m == "Block" then m = (Type == 2 and "Block2") or (Type == 3 and "Block3") or "Block1" end
		addEffect(m, prt, delay, x3, y3, z3, msh)
	end
end
local Ef = {
	Block = { Create = fx("BlockMesh", "SmoothPlastic", nil, nil, "Block") },
	Sphere = { Create = fx("SpecialMesh", "Neon", "Sphere", "", "Cylinder") },
	Cylinder = { Create = fx("CylinderMesh", "SmoothPlastic", nil, nil, "Cylinder") },
	Ring = { Create = fx("SpecialMesh", "SmoothPlastic", "FileMesh", "rbxassetid://3270017", "Cylinder") },
}
-- keep original call style Effects.Block.Create(...)
for k, v in pairs(Ef) do Effects[k] = v end

function BlockEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
	Ef.Block.Create(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
end

local function mkpart(parent, transp, brickcolor, size, cframe)
	local fp = Instance.new("Part")
	fp.Parent, fp.Transparency, fp.CanCollide, fp.Locked = parent, transp, false, true
	fp.BrickColor, fp.Size, fp.Massless = brickcolor, size, true
	if cframe then fp.CFrame = cframe end
	RemoveOutlines(fp)
	fp.Material = Enum.Material.SmoothPlastic
	return fp
end

function MagicShockTrailAlt2(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, rottype)
	local prt = mkpart(char, 0, brickcolor, Vector3.new(0.5, 0.5, 0.5), cframe)
	prt.Anchored, prt.Material = true, Enum.Material.Neon
	local msh = Instance.new("BlockMesh", prt)
	msh.Scale = Vector3.new(x1, y1, z1)
	Debris:AddItem(prt, 5)
	task.spawn(function()
		for i = 0, 1, delay do
			swait()
			if rottype == 1 then prt.CFrame = prt.CFrame * angles(0, 0, 0.1)
			elseif rottype == 2 then prt.CFrame = prt.CFrame * angles(0, 0, -0.1) end
			prt.Transparency = i
			msh.Scale = msh.Scale + Vector3.new(x3, y3, z3)
		end
		prt:Destroy()
	end)
end

function MagicBlock(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
	local prt = mkpart(char, 0, brickcolor, Vector3.new(0.5, 0.5, 0.5), cframe * Euler(Mrandom(-50, 50), Mrandom(-50, 50), Mrandom(-50, 50)))
	prt.Anchored, prt.Material = true, Enum.Material.Neon
	local msh = Instance.new("BlockMesh", prt)
	msh.Scale = Vector3.new(x1, y1, z1)
	Debris:AddItem(prt, 5)
	task.spawn(function()
		for i = 0, 1, delay do
			swait()
			prt.CFrame = prt.CFrame * Euler(Mrandom(-50, 50), Mrandom(-50, 50), Mrandom(-50, 50))
			prt.Transparency = i
			msh.Scale = msh.Scale + Vector3.new(x3, y3, z3)
		end
		prt:Destroy()
	end)
end

function MagicShockAlt(brickcolor, cframe, x1, y1, x3, y3, delay, rottype)
	local prt = mkpart(char, 0, brickcolor, Vector3.new(0.5, 0.5, 0.5), cframe)
	prt.Anchored, prt.Material = true, Enum.Material.Neon
	local msh = Instance.new("BlockMesh", prt)
	msh.Scale = Vector3.new(x1, y1, 0.01)
	Debris:AddItem(prt, 5)
	task.spawn(function()
		for i = 0, 1, delay do
			swait()
			if rottype == 1 then prt.CFrame = prt.CFrame * angles(0, 0, 0.1)
			elseif rottype == 2 then prt.CFrame = prt.CFrame * angles(0, 0, -0.1) end
			prt.Transparency = i
			msh.Scale = msh.Scale + Vector3.new(x3, y3, 0)
		end
		prt:Destroy()
	end)
end

---------------------------------------------------------------- damage
function ShowDamage(Pos, Text, Time, Color)
	Pos, Text, Time = Pos or Vector3.new(), tostring(Text or ""), Time or 2
	Color = Color or Color3.new(1, 0, 1)
	local EffectPart = CFuncs.Part.Create(workspace, "SmoothPlastic", 0, 1, BrickColor.new(Color), "Effect", Vector3.new(0, 0, 0))
	EffectPart.Anchored = true
	local bb = Create("BillboardGui"){ Size = UDim2.new(3, 0, 3, 0), Adornee = EffectPart, Parent = EffectPart }
	local tl = Create("TextLabel"){ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = Text, Font = Enum.Font.Highway,
		TextColor3 = Color, TextScaled = true, TextStrokeColor3 = Color3.new(0, 0, 0), Parent = bb }
	Debris:AddItem(EffectPart, Time)
	task.spawn(function()
		local Frames = Time * 30
		for Frame = 1, Frames do
			task.wait(1 / 30)
			local pct = Frame / Frames
			EffectPart.CFrame = CF(Pos) + Vector3.new(0, pct, 0)
			tl.TextTransparency = pct
		end
		EffectPart:Destroy()
	end)
end

-- NOTE: Damage = random(0,0) in the original, so hits only apply effects/knockback. Change it to random(minim, maxim) for real damage.
function Damage(Part, hit, minim, maxim, knockback, Type, Property, Delay, HitSound, HitPitch)
	if hit.Parent == nil then return end
	local h = hit.Parent:FindFirstChildOfClass("Humanoid")
	if h ~= nil and hit.Parent.Name ~= char.Name and hit.Parent:FindFirstChild("UpperTorso") ~= nil then
		local hd = hit.Parent:FindFirstChild("Head")
		if hd then hd:BreakJoints() end
	end
	if h ~= nil and hit.Parent.Name ~= char.Name and hit.Parent:FindFirstChild("Torso") ~= nil then
		if hit.Parent:FindFirstChild("DebounceHit") and hit.Parent.DebounceHit.Value == true then return end
		local c = Create("ObjectValue"){ Name = "creator", Value = plr, Parent = h }
		Debris:AddItem(c, .5)
		if HitSound and HitPitch then CFuncs.Sound.Create(HitSound, hit, 1, HitPitch) end
		local Dmg = math.random(0, 0)
		local blocked = false
		local block = hit.Parent:FindFirstChild("Block")
		if block and block.ClassName == "IntValue" and block.Value > 0 then
			blocked = true
			block.Value = block.Value - 1
		end
		h.Health = h.Health - (blocked and Dmg / 2 or Dmg)
		ShowDamage((Part.CFrame * CF(0, 0, Part.Size.Z / 2)).Position + Vector3.new(0, 1.5, 0), -Dmg, 1.5, maincolor.Color)
		local torso = hit.Parent.Torso
		if Type == "Knockdown" then
			h.PlatformStand = true
			task.delay(0.05, function() if h then h.PlatformStand = false end end)
			local angle = (hit.Position - Property.Position).Unit
			local bv = Create("BodyVelocity"){ Velocity = angle * knockback, P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit }
			local rv = Create("BodyAngularVelocity"){ P = 3000, MaxTorque = Vector3.new(1, 1, 1) * 2.5e19,
				AngularVelocity = Vector3.new(Mrandom(-10, 10), Mrandom(-10, 10), Mrandom(-10, 10)), Parent = hit }
			Debris:AddItem(bv, .5) Debris:AddItem(rv, .5)
		elseif Type == "Normal" then
			if knockback > 0 then
				local vp = Create("BodyVelocity"){ P = 500, MaxForce = Vector3.new(math.huge, 0, math.huge),
					Velocity = Property.CFrame.LookVector * knockback + Property.AssemblyLinearVelocity / 1.05, Parent = torso }
				Debris:AddItem(vp, .5)
			end
		elseif Type == "Up" then
			Debris:AddItem(Create("BodyVelocity"){ Velocity = Vector3.new(0, 20, 0), P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit }, .5)
		elseif Type == "DarkUp" then
			task.spawn(function()
				for i = 0, 1, 0.1 do
					swait()
					Ef.Block.Create(BrickColor.new("Black"), torso.CFrame, 5, 5, 5, 1, 1, 1, .08, 1)
				end
			end)
			Debris:AddItem(Create("BodyVelocity"){ Velocity = Vector3.new(0, 20, 0), P = 5000, MaxForce = Vector3.new(8e3, 8e3, 8e3), Parent = hit }, 1)
		elseif Type == "Snare" then
			Debris:AddItem(Create("BodyPosition"){ P = 2000, D = 100, MaxForce = Vector3.new(math.huge, math.huge, math.huge), Position = torso.Position, Parent = torso }, 1)
		elseif Type == "Freeze" then
			Debris:AddItem(Create("BodyPosition"){ P = 50000, D = 1000, MaxForce = Vector3.new(math.huge, math.huge, math.huge), Position = torso.Position, Parent = torso }, 3)
			Debris:AddItem(Create("BodyGyro"){ MaxTorque = Vector3.new(math.huge, math.huge, math.huge), P = 20e3, CFrame = torso.CFrame, Parent = torso }, 3)
			torso.Anchored = true
			task.delay(1.5, function() torso.Anchored = false end)
		end
		local deb = Create("BoolValue"){ Name = "DebounceHit", Parent = hit.Parent, Value = true }
		Debris:AddItem(deb, Delay)
	end
end

function MagniDamage(Part, magni, mindam, maxdam, knock, Type)
	for _, c in ipairs(workspace:GetChildren()) do
		local hm = c:FindFirstChildOfClass("Humanoid")
		local head = c:FindFirstChild("Head")
		if hm and head and c ~= char and c.Name ~= plr.Name then
			if (head.Position - Part.Position).Magnitude <= magni then
				Damage(head, head, mindam, maxdam, knock, Type, root, 0.1, "http://www.roblox.com/asset/?id=0", 1.2)
			end
		end
	end
end

function HitboxFunction(Pose, lifetime, siz1, siz2, siz3, Radie, Min, Max, kb, atype)
	local hb = Instance.new("Part", EffectModel)
	RemoveOutlines(hb)
	hb.Size, hb.CanCollide, hb.Transparency, hb.Anchored, hb.CFrame = Vector3.new(siz1, siz2, siz3), false, 1, true, Pose
	Debris:AddItem(hb, lifetime)
	MagniDamage(hb, Radie, Min, Max, kb, atype)
end

function FindNearestHead(Position, Distance)
	local List = {}
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Head") and v ~= char and v ~= realChar and v.Name ~= plr.Name
			and Distance >= (v.Head.Position - Position).Magnitude then
			table.insert(List, v)
		end
	end
	return List
end

function Eviscerate(dude)
	if dude == char or dude == realChar then return end
	local bgf = IT("BodyGyro", dude.Head)
	bgf.CFrame = bgf.CFrame * Euler(Rad(-90), 0, 0)
	task.spawn(function()
		dude:WaitForChild("Head"):BreakJoints()
		task.wait(0.5)
		for _, v in ipairs(dude:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Humanoid") or v:IsA("CharacterMesh") or v:IsA("Model") then
				v:Destroy()
			elseif v:IsA("Part") or v:IsA("MeshPart") then
				for _, o in ipairs(v:GetChildren()) do if o:IsA("Decal") then o:Destroy() end end
				task.spawn(function()
					v.Material = Enum.Material.Neon
					v.CanCollide = false
					local pe = IT("ParticleEmitter", v)
					pe.LightEmission, pe.Texture = 1, "rbxassetid://284205403"
					pe.Color, pe.Rate, pe.Lifetime = ColorSequence.new(maincolor.Color), 150, NumberRange.new(1)
					pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75, 0), NumberSequenceKeypoint.new(1, 0, 0) })
					pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0) })
					pe.Speed, pe.VelocitySpread = NumberRange.new(0, 0), 30000
					pe.Rotation, pe.RotSpeed = NumberRange.new(-500, 500), NumberRange.new(-500, 500)
					local bp = IT("BodyPosition", v)
					bp.P, bp.D, bp.MaxForce = 3000, 1000, Vector3.new(5e10, 5e10, 5e10)
					bp.Position = v.Position + Vector3.new(Mrandom(-15, 15), Mrandom(-15, 15), Mrandom(-15, 15))
					v.Color = maincolor.Color
					for i = 0, 49 do swait(1) v.Transparency = v.Transparency + 0.08 end
					task.wait(0.5)
					pe.Enabled = false
					task.wait(3)
					v:Destroy()
					dude:Destroy()
				end)
			end
		end
	end)
end

---------------------------------------------------------------- pose helpers
local function RJ(x, y, z, rx, ry, rz) return RootCF * CF(x, y, z) * angles(Rad(rx), Rad(ry), Rad(rz)) end
local function NK(rx, ry, rz) return necko * angles(Rad(rx), Rad(ry), Rad(rz)) end
local function SH(x, y, z, rx, ry, rz) return CF(x, y, z) * angles(Rad(rx), Rad(ry), Rad(rz)) end
local function RHP(x, y, z, rx, ry, rz) return CF(x, y, z) * RHCF * angles(Rad(rx), Rad(ry), Rad(rz)) end
local function LHP(x, y, z, rx, ry, rz) return CF(x, y, z) * LHCF * angles(Rad(rx), Rad(ry), Rad(rz)) end
local Neck = tors.Neck
-- alphas: {rj, neck, rw, lw, rh, lh}
local STD = { .15, .3, .1, .1, .15, .15 }
local CMB = { .3, .1, .1, .3, .3, .3 }
local function pose(a, rj, nk, rw, lw, rh, lh)
	local al = type(a) == "table" and a or { a, a, a, a, a, a }
	rootj.C0 = clerp(rootj.C0, rj, al[1])
	Neck.C0 = clerp(Neck.C0, nk, al[2])
	RW.C0 = clerp(RW.C0, rw, al[3])
	LW.C0 = clerp(LW.C0, lw, al[4])
	RH.C0 = clerp(RH.C0, rh, al[5])
	LH.C0 = clerp(LH.C0, lh, al[6])
end
-- shared body-bob shorthand for the "standing" attack poses
local function bobbed(rj, nk, rwR, lwR, rh, lh, bobY)
	pose(STD, rj, nk,
		SH(1.5, .5 + .05 * Sn(30), .025 * C(20), rwR[1], rwR[2], rwR[3]),
		SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), lwR[1], lwR[2], lwR[3]), rh, lh)
end

---------------------------------------------------------------- weapon (procedural rebuild of the baked "Gunty" model)
local Gunty = Instance.new("Model", char)
Gunty.Name = "Gunty"
local ArmourParts, ArmourParts2, NeonParts = {}, {}, {}
local Handle = Instance.new("Part", Gunty)
Handle.Name, Handle.BrickColor, Handle.Material = "Handle", BrickColor.new("Black"), Enum.Material.Metal
Handle.Size, Handle.CanCollide, Handle.Massless = Vector3.new(0.8, 0.98, 1), false, true
RemoveOutlines(Handle)
Instance.new("BlockMesh", Handle).Scale = Vector3.new(1.04, 1, 1.04)
local HW = Instance.new("Weld", char)
HW.Part0, HW.Part1, HW.C0 = ra, Handle, CF(-.1, -.51, 0)

local function gp(brick, mat, size, off, rx, rz, meshScale)
	local p = Instance.new("Part", Gunty)
	p.BrickColor, p.Material, p.Size = BrickColor.new(brick), mat, size
	p.CanCollide, p.Massless = false, true
	RemoveOutlines(p)
	if meshScale then Instance.new("BlockMesh", p).Scale = meshScale end
	local w = Instance.new("Weld", p)
	w.Part0, w.Part1 = Handle, p
	w.C0 = CF(off) * angles(Rad(rx or 0), 0, Rad(rz or 0))
	if brick == "Smoky grey" then table.insert(ArmourParts, p)
	elseif brick == "Fossil" then table.insert(ArmourParts2, p)
	elseif brick == "Institutional white" then table.insert(NeonParts, p) end
	return p
end
local M, N = Enum.Material.Metal, Enum.Material.Neon
local V = Vector3.new
gp("Institutional white", N, V(.45, .3, 1.01), V(.375, .43, -.005), 0, 0, V(1.15, .7, 1.05))
gp("Fossil", M, V(.4, .8, 1.44), V(.4, -.09, 0), 0, 0, V(1, 1, .85))
gp("Smoky grey", M, V(.51, 1.01, 1.38), V(.383, .005, .002), 0, 0, V(1, 1, .85))
gp("Smoky grey", M, V(.34, .18, 1.28), V(-.266, .333, 0), 0, 0, V(1, 1, .85))
gp("Smoky grey", M, V(.34, .24, 1.28), V(-.262, -.017, -.004), 0, 0, V(1, 1, .85))
gp("Smoky grey", M, V(.38, .24, 1.28), V(-.238, -.377, -.008), 0, 0, V(1, 1, .85))
gp("Institutional white", N, V(.08, .83, 1.24), V(-.112, -.059, -.001), 0, 0, V(1, 1, .85))
gp("Institutional white", N, V(.58, .21, 1.24), V(-.136, .328, 0), 0, 0, V(1, 1, .85))
gp("Institutional white", N, V(.58, .27, 1.24), V(-.133, -.022, -.003), 0, 0, V(1, 1, .85))
gp("Institutional white", N, V(.58, .25, 1.25), V(-.129, -.362, -.002), 0, 0, V(1, 1, .85))
gp("Black", M, V(.2, .6, .2), V(.447, .217, .6), 0, 14.4, V(.5, .9, .4))
gp("Black", M, V(.2, .6, .2), V(.437, .217, -.6), 0, 14.4, V(.5, .9, .4))
gp("Fossil", M, V(.2, .2, 1.4), V(.506, -.01, .001), 0, -45.6, V(.2, .2, .93))
gp("Smoky grey", M, V(.32, .92, 1.28), V(.088, -.044, -.001), 0, 0, V(1, 1, .85))
gp("Institutional white", N, V(.33, .27, .86), V(.491, -.126, .004), 0, 0, V(1, 1, .85))
gp("Fossil", M, V(.28, .39, 1.05), V(.506, -.135, -.001), 0, 0, V(1, 1, .85))
gp("Fossil", M, V(.25, .23, .06), V(.524, .263, -.449), 19, 0)
gp("Fossil", M, V(.25, .15, .06), V(.5235, .284, -.388), -7.8, 0)
gp("Fossil", M, V(.25, .17, .06), V(.523, .273, -.327), 32.7, 0)
gp("Fossil", M, V(.25, .23, .06), V(.523, .243, -.289), 6.2, 0)
gp("Fossil", M, V(.2, .2, 1.18), V(.106, .056, -.002), 0, -45.6, V(.2, .2, .93))

local function setTheme(armour, armour2, neon)
	for _, v in ipairs(ArmourParts) do v.BrickColor = BrickColor.new(armour) end
	for _, v in ipairs(ArmourParts2) do v.BrickColor = BrickColor.new(armour2) end
	for _, v in ipairs(NeonParts) do v.BrickColor = BrickColor.new(neon) end
end
local function randomTheme()
	for _, v in ipairs(ArmourParts) do v.BrickColor = BrickColor.random() end
	for _, v in ipairs(ArmourParts2) do v.BrickColor = BrickColor.random() end
	for _, v in ipairs(NeonParts) do v.BrickColor = BrickColor.random() end
	maincolor = BrickColor.random()
end

---------------------------------------------------------------- music + name tag
local Music = Instance.new("Sound", char)
Music.Volume, Music.SoundId, Music.Looped, Music.Pitch = 2.5, "rbxassetid://1117396305", true, 1
Music:Play()

local naeeym2 = Instance.new("BillboardGui", char)
naeeym2.AlwaysOnTop, naeeym2.Size, naeeym2.StudsOffset, naeeym2.Adornee, naeeym2.Name =
	true, UDim2.new(5, 35, 2, 35), Vector3.new(0, 2, 0), hed, "Name"
local tecks2 = Instance.new("TextLabel", naeeym2)
tecks2.BackgroundTransparency, tecks2.TextScaled, tecks2.BorderSizePixel = 1, true, 0
tecks2.Text, tecks2.Font, tecks2.TextStrokeTransparency = "Neutral", Enum.Font.Code, 0
tecks2.TextColor3, tecks2.TextStrokeColor3, tecks2.Size = Color3.new(0, 0, 0), Color3.new(0, 0, 0), UDim2.new(1, 0, 0.5, 0)

---------------------------------------------------------------- modes
local mode = "Neutral"
local MODES = {
	Edgy = { key = "q", text = "Edgy", tc = Color3.new(0, 0, 0), sc = Color3.fromRGB(98, 37, 209), a = "Black", a2 = "Really black", n = "Royal purple", main = "Royal purple", music = "1470848774" },
	Divinity = { key = "e", text = "Divinity", tc = Color3.new(1, 1, 1), sc = Color3.fromRGB(255, 255, 0), a = "Institutional white", a2 = "White", n = "New Yeller", main = "New Yeller", music = "595800581" },
	Fighter = { key = "r", text = "Fighter", tc = Color3.new(0, 0, 0), sc = Color3.fromRGB(255, 255, 255), a = "Black", a2 = "Really black", n = "Institutional white", main = "Institutional white", music = "493647101" },
	Purity = { key = "t", text = "Purity", tc = Color3.new(1, 1, 1), sc = Color3.fromRGB(0, 255, 255), a = "Institutional white", a2 = "Institutional white", n = "Toothpaste", main = "Toothpaste", music = "553751015" },
	Destruction = { key = "y", text = "Destruction", tc = Color3.new(0, 0, 0), sc = Color3.fromRGB(255, 0, 0), a = "Really black", a2 = "Black", n = "Really red", main = "Really red", music = "613361202" },
	Insanity = { key = "u", text = "iNsAnItY", music = "460874877", random = true },
	Planetary = { key = "f", text = "Planetary", tc = Color3.fromRGB(61, 21, 133), sc = Color3.fromRGB(61, 21, 133), a = "Dark indigo", a2 = "Dark indigo", n = "Dark indigo", main = "Dark indigo", music = "609934004" },
}
local function playMusic(id)
	Music.SoundId = "rbxassetid://" .. id
	Music:Play()
end
local function resetmode()
	mode = "Neutral"
	tecks2.Text, tecks2.TextColor3, tecks2.TextStrokeColor3 = "Neutral", Color3.new(0, 0, 0), Color3.new(0, 0, 0)
	setTheme("Smoky grey", "Fossil", "Institutional white")
	maincolor = BrickColor.new("Institutional white")
	playMusic("1117396305")
end
local function enterMode(name)
	local m = MODES[name]
	mode = name
	tecks2.Text = m.text
	if m.tc then tecks2.TextColor3, tecks2.TextStrokeColor3 = m.tc, m.sc end
	if m.a then
		setTheme(m.a, m.a2, m.n)
		maincolor = BrickColor.new(m.main)
	end
	playMusic(m.music)
end

---------------------------------------------------------------- combo
local wait2, combo = false, 1
mouse.Button1Down:Connect(function()
	if attack then return end
	attack = true
	hum.WalkSpeed = 3.01
	local function windup(rz, rw)
		loop(1.2, function()
			pose(CMB, RJ(0, -.5, 0, -5, 0, rz), NK(-10, 0, 0), SH(1.5, .5, .8, 90, 0, 20), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, -.2, -2.5, 0, 0), LHP(-1, -1, 0, -2.5, 15, -20))
		end)
	end
	local function swingRight(dmgMin, dmgMax)
		CreateSound("138097048", ra, 3, .8)
		HitboxFunction(ra.CFrame, 0.01, 1, 1, 1, 7, dmgMin, dmgMax, 3, "Normal")
	end
	if combo == 1 and not wait2 then
		wait2 = true
		windup(-35)
		swingRight(6, 9)
		loop(1.2, function()
			BlockEffect(maincolor, Handle.CFrame, 21, 41, 21, -2, -3, -2, 0.08, 2)
			pose(CMB, RJ(0, -.5, 0, 5, 0, 55), NK(10, 0, 0), SH(1.5, .5, -.8, 95, 0, 40), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, 0, -2.5, -25, -17), LHP(-1, -1, 0, -2.5, 0, 0))
		end)
		combo = 2
	end
	if combo == 2 and not wait2 then
		wait2 = true
		loop(1.2, function()
			pose(CMB, RJ(0, -.5, 0, -25, 10, -65), NK(10, 0, 0), SH(1.5, .5, 0, 0, 0, 10), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, 0, -2.5, -25, -25), LHP(-1, -1, 0, -2.5, 0, -20))
		end)
		CreateSound("138097048", rl, 3, 1)
		HitboxFunction(ll.CFrame, 0.01, 1, 1, 1, 7, 5, 10, 3, "Normal")
		loop(1.6, function(i)
			pose(CMB, RJ(0, -.5, 0, -15, 0, 65 + 255.45 * i), NK(10, 0, 0), SH(1.5, .5, 0, 54, 0, 35), SH(-1.5, .5, 0, -34, 0, -35), RHP(1, -1, 0, -2.5, -25, 95), LHP(-1, -1, 0, -4.5, -30, 0))
		end)
		combo = 3
	end
	if combo == 3 and not wait2 then
		windup(-35)
		swingRight(24, 36)
		loop(1.2, function()
			pose(CMB, RJ(0, -.5, 0, 5, 0, 35), NK(10, 0, 0), SH(1.5, .5, -.8, 96, 0, 10), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, 0, -2.5, -25, 0), LHP(-1, -1, 0, -2.5, 0, 0))
		end)
		Ef.Sphere.Create(maincolor, ra.CFrame * CF(0, -2, 0), 85, 85, 85, 0.1, 0.1, 0.1, 0.03)
		Ef.Ring.Create(maincolor, ra.CFrame * CF(0, -2, 0), 2, 2, 2, 0.1, 0.1, 0.1, 0.03)
		HitboxFunction(ra.CFrame, 0.01, 1, 1, 1, 7, 24, 36, 3, "Normal")
		loop(1.2, function()
			pose(CMB, RJ(0, -.5, 0, 5, 0, -35), NK(10, 0, 0), SH(1.5, .5, -.8, 25, 0, 10), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, 0, -2.5, -25, 0), LHP(-1, -1, 0, -2.5, 0, 0))
		end)
		combo = 1
	end
	hum.WalkSpeed = 8
	wait2 = false
	attack = false
end)

---------------------------------------------------------------- abilities
local function shake(a, b)
	task.spawn(function()
		for i = 0, a, 0.1 do swait() hum.CameraOffset = Vector3.new(Mrandom(-3, 3), Mrandom(-3, 3), Mrandom(-3, 3)) end
		for i = 0, b, 0.1 do swait() hum.CameraOffset = Vector3.new(0, 0, 0) end
	end)
end
local function mouseTarget()
	local t = mouse.Target
	if not t or not t.Parent then return end
	local m = t.Parent
	if m == char or m.Parent == char then return end
	local h = m:FindFirstChild("Humanoid")
	if h and h.PlatformStand == false then
		return m, h, m:FindFirstChild("Torso") or m:FindFirstChild("UpperTorso"), m:FindFirstChild("Head")
	end
end

function Decapitate()
	local model, target, targettorso, targethead = mouseTarget()
	if not (target and targettorso and targethead) then return end
	targettorso.Anchored = true
	attack = true
	hum.WalkSpeed = 0
	root.CFrame = targettorso.CFrame * CF(0, 0, 2.6)
	local function stand(rz, nz, rh, lh, rw, lw, lhLegY)
		pose(STD, RJ(0, 0, -.1 + .1 * C(20), 0, 0, rz), NK(0, 0, nz),
			SH(rw[1], .5 + .05 * Sn(30), .025 * C(20), rw[2], rw[3], rw[4]), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), lw[1], lw[2], lw[3]),
			RHP(1, -.9 - .1 * C(20), .025 * C(20), rh[1], rh[2], rh[3]), LHP(-1, lh[4] or (-.9 - .1 * C(20)), lh[5] or .025 * C(20), lh[1], lh[2], lh[3]))
	end
	loop(4.2, function() stand(-40, 40, { -9, 0, -10 }, { -8, 0, 10, -.6 - .1 * C(20), -.4 + .025 * C(20) }, { 1.5, 115, 0, 35 }, { 25, 0, -15 }) end)
	local ModelHead01 = Instance.new("Model", char)
	Instance.new("Humanoid", ModelHead01)
	local Head01 = targethead:Clone()
	targethead.Transparency = 1
	Head01.Parent = ModelHead01
	local face = targethead:FindFirstChild("face")
	if face then face:Destroy() end
	local weldHead01 = Instance.new("Weld", Head01)
	weldHead01.Part0 = ra
	weldHead01.Part1 = Head01
	weldHead01.C1 = CF(0, 0, 1.2) * angles(Rad(90), 0, 0)
	targettorso:BreakJoints()
	CreateSound("314390675", targettorso, 5, .7)
	loop(3.2, function() stand(90, -90, { -5, 0, 0 }, { -5, 0, 50 }, { 1.5, 115, 20, 90 }, { 25, 0, -15 }) end)
	loop(4.2, function() stand(-40, 40, { -5, 0, 0 }, { -5, 0, 0 }, { 1.4, 185, 0, 15 }, { 45, 0, -15 }) end)
	CreateSound("541909763", targettorso, 5, .8)
	weldHead01:Destroy()
	Head01.CanCollide = true
	local bv = Create("BodyVelocity"){ Velocity = Vector3.new(0, 10, 0) + root.CFrame.LookVector * 50, P = 5000, MaxForce = Vector3.new(8000, 8000, 8000), Parent = Head01 }
	Debris:AddItem(bv, 0.05)
	loop(6.2, function() stand(40, -40, { -5, 0, 0 }, { -5, 0, 0 }, { 1.4, 65, 0, -15 }, { 45, 0, -15 }) end)
	targettorso.Anchored = false
	attack = false
	hum.WalkSpeed = 8
	root.CFrame = targettorso.CFrame * CF(0, 0, 3.4)
end

function Laugh()
	attack = true
	hum.WalkSpeed = 0
	CreateSound("300208779", hed, 10, 1)
	loop(9, function()
		local s = Sn(2)
		pose(STD, RJ(0, 0, -.1 + .1 * C(2), -30, 0, 0), NK(-30 - 2.5 * s, 0, 0),
			SH(1.5, .5 + .05 * s, .025 * C(2), -35 - 7.5 * s, 0, 15 - 7.5 * s), SH(-1.5, .5 + .05 * s, .025 * C(2), -35 - 7.5 * s, 0, -15 - 7.5 * s),
			RHP(1, -1 - .1 * C(2), .025 * C(2), -4.5 - 7.5 * s, 0, -30), LHP(-1, -1 - .1 * C(2), .025 * C(2), -6.5 - 7.5 * s, 0, 30))
		if Mrandom(1, 15) == 1 then
			Neck.C0 = clerp(Neck.C0, necko * angles(Rad(Mrandom(-15, 15)), Rad(Mrandom(-15, 15)), Rad(Mrandom(-15, 15))), 1)
		end
	end)
	attack = false
	hum.WalkSpeed = 10
end

function Flying_Kick()
	attack = true
	hum.WalkSpeed = 0
	loop(2.7, function()
		pose(STD, RJ(0, 0, -.7 + .1 * C(20), 20, 0, 0), NK(-20, 0, 0), SH(1.5, .5 + .05 * Sn(30), .025 * C(20), -20, 0, 15), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), -20, 0, -15),
			RHP(1, -.3 - .1 * C(20), -.6 + .025 * C(20), -5, 0, 0), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -5, 0, 30))
	end)
	Debris:AddItem(Create("BodyVelocity"){ Velocity = root.CFrame.LookVector * 250, P = 5000, MaxForce = Vector3.new(math.huge, math.huge, math.huge), Parent = root }, 0.05)
	CreateSound("138097048", rl, 3, 1)
	loop(2.1, function()
		HitboxFunction(rl.CFrame, 0.01, 1, 1, 1, 7, 6, 8, 3, "Knockdown")
		pose(STD, RJ(0, 0, .6 + .1 * C(20), 0, 20, 90), NK(0, 0, -90), SH(1.5, .5 + .05 * Sn(30), .025 * C(20), 0, 0, 90), SH(-1.9, .8 + .05 * Sn(30), .025 * C(20), 0, 0, -215),
			RHP(.4, -.9 - .1 * C(20), .025 * C(20), -125, 0, 0), LHP(-1.3, -1.3 - .1 * C(20), .025 * C(20), 35, 0, 0))
	end)
	attack = false
	hum.WalkSpeed = 8
end

function UpperCut()
	attack = true
	hum.WalkSpeed = 0
	loop(2.3, function()
		pose(STD, RJ(0, 0, -.7 + .1 * C(20), 20, 0, 0), NK(20, 0, 0), SH(.8, .5 + .05 * Sn(30), -.8 + .025 * C(20), 165, 0, 0), SH(-1, .5 + .05 * Sn(30), -1 + .025 * C(20), 90, 0, 75),
			RHP(1, -.3 - .1 * C(20), -.6 + .025 * C(20), -5, 0, 0), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -5, 0, 30))
	end)
	CreateSound("138097048", ra, 3, .8)
	HitboxFunction(ra.CFrame, 0.01, 1, 1, 1, 7, 6, 8, 3, "Knockdown")
	loop(2.8, function()
		pose(STD, RJ(0, 0, -.1 + .1 * C(20), -35, 0, 10), NK(-20, 0, 0), SH(1.3, .8 + .05 * Sn(30), -.6 + .025 * C(20), 125, 0, 0), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), -40, 0, -10),
			RHP(1, -1.2 - .1 * C(20), .025 * C(20), -5, 0, -55), LHP(-1, -1.2 - .1 * C(20), .025 * C(20), -5, 0, 35))
	end)
	attack = false
	hum.WalkSpeed = 8
end

function Spinning_Kick()
	attack = true
	hum.WalkSpeed = 3.01
	loop(1.2, function()
		pose(CMB, RJ(0, -.5, 0, -25, 10, -65), NK(10, 0, 0), SH(1.5, .5, 0, 0, 0, 10), SH(-1.5, .5, 0, -25, 0, -10), RHP(1, -1, 0, -2.5, -25, -25), LHP(-1, -1, 0, -2.5, 0, -20))
	end)
	loop(4.6, function(i)
		CreateSound("138097048", rl, 3, 1)
		HitboxFunction(ll.CFrame, 0.01, 1, 1, 1, 7, 5, 10, 3, "Normal")
		pose(CMB, RJ(0, -.5, 0, -15, 0, 65 + 255.45 * i), NK(10, 0, 0), SH(1.5, .5, 0, -54, 0, 47), SH(-1.5, .5, 0, -34, 0, -47), RHP(1, -1, 0, -2.5, -25, 95), LHP(-1, -1, 0, -4.5, -30, 30))
	end)
	attack = false
	hum.WalkSpeed = 8
end

function Beam_Of_Light() end -- empty in the original

function Blast_Of_God()
	attack = true
	hum.WalkSpeed = 3.01
	loop(6.3, function()
		Ef.Sphere.Create(BrickC("New Yeller"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		local s = Sn(20)
		pose(STD, RJ(0, 0, 1.2 + .3 * C(20), 5, 0, 90), NK(-4.5 * Sn(30), 0, -90), SH(1.5, .5 + .05 * Sn(30), .025 * C(20), -3 * s, -10 * s, 90 - 2.5 * s), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), 4 * s, 10 * s, -13 + 2.5 * s),
			RHP(1, -.4 - .1 * C(20), -.4 + .025 * C(20), -2.5 + 3 * s, 0, -20 + 2.5 * s), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -2.5 + 3 * s, 0, 2.5 * s))
	end)
	for _, d in ipairs({ .05, .03, .05, .05, .05 }) do
		Ef.Block.Create(BrickC("New Yeller"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 11, 11, 11, d)
	end
	Ef.Ring.Create(BrickC("New Yeller"), ra.CFrame * angles(Rad(90), 0, 0) * CF(0, -1, 0), 2, 2, 2, 7.6, 7.6, 7.6, 0.03)
	CreateSound("142070127", tors, 10, 1)
	MagniDamage(ra, 12, 40, 60, 10, "Normal")
	loop(2.6, function()
		local s = Sn(20)
		pose(STD, RJ(0, 0, 1.2 + .3 * C(20), -25, 0, 90), NK(-4.5 * Sn(30), 0, -90), SH(1.5, .5 + .05 * Sn(30), .025 * C(20), -3 * s, -10 * s, 195 - 2.5 * s), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), 4 * s, 10 * s, -35 + 2.5 * s),
			RHP(1, -.4 - .1 * C(20), -.4 + .025 * C(20), -16 + 3 * s, 0, 20 + 2.5 * s), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -25 + 3 * s, 0, 2.5 * s))
	end)
	attack = false
	hum.WalkSpeed = 8
end

-- shared "hovering" stance used by the Destruction abilities
local function hover(rwR, lwR, rjRz, nkX, rhz, lhz, rwY, bothHands)
	local s = Sn(20)
	pose(STD, RJ(0, 0, 1.3 + .6 * C(20), 0, 0, rjRz or 0), NK(nkX, 0, 0),
		SH(rwR[1], rwY or (.5 + .05 * s), .025 * C(20), rwR[2], rwR[3], rwR[4]), SH(-1.5, .5 + .05 * s, .025 * C(20), lwR[1], lwR[2], lwR[3]),
		RHP(1, -.5 - .1 * C(20), -.4 + .025 * C(20), -4.5 + 3 * s, 0, rhz + 3 * s), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -6.5 + 3 * s, 0, lhz + 3 * s))
end

function Diablo_Explosion()
	attack = true
	hum.WalkSpeed = 3.01
	loop(6.3, function()
		Ef.Block.Create(BrickC("Really red"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		Ef.Block.Create(BrickC("Really red"), la.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		hover({ 1.5, 0, -10 * C(20), 90 - 2.5 * Sn(20) }, { 0, 10 * C(20), -90 + 2.5 * Sn(20) }, 0, -20 - 2.5 * Sn(20), 10, 20)
	end)
	for _, d in ipairs({ { 14, .05 }, { 11, .03 }, { 8, .05 }, { 6, .05 }, { 10.5, .05 } }) do
		Ef.Sphere.Create(BrickC("Really red"), root.CFrame * CF(0, 1, -4), 2, 2, 2, d[1], d[1], d[1], d[2])
	end
	Ef.Ring.Create(BrickC("Really red"), root.CFrame * CF(0, 0, -4), 2, 2, 2, 3.6, 3.6, 3.6, 0.03)
	CreateSound("142070127", tors, 10, 1)
	MagniDamage(tors, 12, 34, 54, 10, "DarkUp")
	loop(4.6, function()
		local s = Sn(20)
		pose(STD, RJ(0, 0, 1.3 + .6 * C(20), 0, 0, 0), NK(20 - 2.5 * s, 0, 0),
			SH(1, .5 + .05 * s, .025 * C(20), 90, -10 * C(20), -35 - 2.5 * s), SH(-1, .5 + .05 * s, .025 * C(20), 90, 10 * C(20), 35 + 2.5 * s),
			RHP(1, -.5 - .1 * C(20), -.4 + .025 * C(20), -4.5 + 3 * s, 0, 10 + 3 * s), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -6.5 + 3 * s, 0, -10 + 3 * s))
	end)
	task.wait(.6)
	attack = false
	hum.WalkSpeed = 8
end

function Hell_From_Above()
	local ref = Instance.new("Part", EffectModel)
	ref.Transparency, ref.Size, ref.CFrame, ref.Anchored, ref.CanCollide = 1, Vector3.new(.2, .2, .2), tors.CFrame, true, false
	attack = true
	hum.WalkSpeed = 3.01
	loop(6.3, function()
		Ef.Block.Create(BrickC("Really red"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		hover({ 1.5, 180, -10 * C(20), 15 - 2.5 * Sn(20) }, { 0, 10 * C(20), -15 + 2.5 * Sn(20) }, 0, -20 - 2.5 * Sn(20), 10, -10)
	end)
	CreateSound("142070127", tors, 10, 1)
	for _ = 1, 4 do Ef.Sphere.Create(BrickC("Really red"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 6, 6, 6, 0.05) end
	loop(3.8, function()
		hover({ 1.5, 180, -10 * C(20), 15 - 2.5 * Sn(20) }, { 0, 10 * C(20), -15 + 2.5 * Sn(20) }, 0, -20 - 2.5 * Sn(20), 10, -10, .2 + .05 * Sn(20))
	end)
	CreateSound("224339201", tors, 10, 0.5)
	for _ = 1, 3 do
		MagniDamage(ref, 12, 34, 54, 10, "DarkUp")
		ref.CFrame = mouse.Hit
		Ef.Cylinder.Create(BrickColor.new("Really red"), ref.CFrame, .5, 9999, .5, 10, 0, 10, 0.05)
		Ef.Block.Create(BrickColor.new("Really red"), ref.CFrame, 1, 1, 1, 10, 10, 10, 0.05)
	end
	ref:Destroy()
	attack = false
	hum.WalkSpeed = 8
end

function Spinning_Below()
	attack = true
	hum.WalkSpeed = 3.01
	CreateSound("649634100", tors, 10, 0.5)
	loop(6.3, function(i)
		Ef.Block.Create(BrickC("Really red"), ra.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		Ef.Block.Create(BrickC("Really red"), la.CFrame * CF(0, -1, 0), 2, 2, 2, 3, 3, 3, 0.05)
		local s = Sn(20)
		pose(STD, RJ(0, 0, 1.3 + .6 * C(20), 0, 0, 255.45 * i), NK(-20 - 2.5 * s, 0, 0),
			SH(1.5, .5 + .05 * s, .025 * C(20), 0, -10 * C(20), 90 - 2.5 * s), SH(-1.5, .5 + .05 * s, .025 * C(20), 0, 10 * C(20), -90 + 2.5 * s),
			RHP(1, -.7 - .1 * C(20), -.4 + .025 * C(20), -4.5 + 3 * s, 0, 10 + 3 * s), LHP(-1, -.9 - .1 * C(20), .025 * C(20), -6.5 + 3 * s, 0, -10 + 3 * s))
	end)
	attack = false
	hum.WalkSpeed = 8
end

function Purity_Slam()
	attack = true
	loop(5.2, function()
		pose(STD, RJ(0, 0, -.1 + .1 * C(20), -20, 0, 0), NK(-20 - 2.5 * Sn(20), 0, 0),
			SH(1.5, .5 + .05 * Sn(20), .025 * C(20), 200, 0, 25 - 2.5 * Sn(20)), SH(-1.5, .5 + .05 * Sn(20), .025 * C(20), 200, 0, -25 + 2.5 * Sn(20)),
			RHP(1, -.9 - .1 * C(20), .025 * C(20), -4.5, 0, -20), LHP(-1, -.9 - .1 * C(20), -.4 + .025 * C(20), -6.5, 5 * C(20), 25))
	end)
	CreateSound("331666100", tors, 10, 1)
	for _, d in ipairs({ { -2.7, 3.6 }, { -2.3, 5.6 }, { -1.7, 8.6 }, { -1.3, 10.6 } }) do
		Ef.Ring.Create(BrickC("Toothpaste"), root.CFrame * CF(0, d[1], 0) * angles(Rad(90), 0, 0), 2, 2, 2, d[2], d[2] == 10.6 and 10 or d[2], d[2] == 10.6 and 10 or d[2], 0.03)
	end
	MagniDamage(tors, 12, 40, 60, 10, "Normal")
	shake(1.8, 1.8)
	loop(4.7, function()
		pose(STD, RJ(0, 0, -1.4 + .1 * C(20), 45, 0, 0), NK(35, 0, 0),
			SH(1.5, .1 + .05 * Sn(30), -.4 + .025 * C(20), 65, 0, 25), SH(-1.5, .1 + .05 * Sn(30), -.4 + .025 * C(20), 65, 0, -25),
			RHP(1, .4 - .1 * C(20), -.6 + .025 * C(20), -5, 0, 45), LHP(-1, -.6 - .1 * C(20), .025 * C(20), -5, 0, 0))
	end)
	task.wait(.6)
	attack = false
end

function Painful_Stomp()
	attack = true
	loop(5.2, function()
		pose(STD, RJ(0, 0, -.1 + .1 * C(20), -20, 0, 0), NK(-20 - 2.5 * Sn(20), 0, 0),
			SH(1.5, .5 + .05 * Sn(20), .025 * C(20), 135, 0, -45 - 2.5 * Sn(20)), SH(-1.5, .5 + .05 * Sn(20), .025 * C(20), 135, 0, 45 + 2.5 * Sn(20)),
			RHP(1, -.9 - .1 * C(20), .025 * C(20), -4.5, 0, -20), LHP(-1, -.3 - .1 * C(20), -.4 + .025 * C(20), -6.5, 5 * C(20), 25))
	end)
	CreateSound("331666100", char, 10, 1)
	for _ = 1, 4 do Ef.Sphere.Create(BrickColor.Random(), root.CFrame * CF(0, -1, 0), 2, 2, 2, 10.6, 10.6, 10.6, 0.05) end
	Ef.Sphere.Create(BrickColor.Random(), root.CFrame * CF(0, -1, 0), 2, 2, 2, 10.6, 35.6, 10.6, 0.05)
	Ef.Sphere.Create(BrickColor.Random(), root.CFrame * CF(0, -3, 0), 2, 2, 2, 150.6, .4, 150.6, 0.05)
	Ef.Ring.Create(BrickColor.Random(), root.CFrame * CF(0, -1.7, 0) * angles(Rad(90), 0, 0), 2, 2, 2, 8.6, 8.6, 8.6, 0.03)
	for _, v in ipairs(FindNearestHead(tors.Position, 52.5)) do Eviscerate(v) end
	shake(2.8, 1.8)
	loop(3.7, function()
		pose(STD, RJ(0, 0, -.1 + .1 * C(20), 20, 0, 0), NK(20 - 2.5 * Sn(20), 0, 0),
			SH(1.5, .5 + .05 * Sn(20), .025 * C(20), -40, 0, 25 - 2.5 * Sn(20)), SH(-1.5, .5 + .05 * Sn(20), .025 * C(20), -40, 0, -25 + 2.5 * Sn(20)),
			RHP(1, -.9 - .1 * C(20), .025 * C(20), -4.5, 0, 20), LHP(-1, -.9 - .1 * C(20), -.4 + .025 * C(20), -6.5, 5 * C(20), -25))
	end)
	task.wait(.6)
	attack = false
end

local function endingPose(rz, nz, lhY, lhZ, lhRx, lhRz, rwR, rwRot)
	pose(STD, RJ(0, 0, -.1 + .1 * C(20), 0, 0, rz), NK(0, 0, nz),
		SH(1.5, .5 + .05 * Sn(30), .025 * C(20), rwR[1], rwR[2], rwR[3]), SH(-1.5, .5 + .05 * Sn(30), .025 * C(20), 25, 0, -15),
		RHP(1, -.9 - .1 * C(20), .025 * C(20), -9, 0, -10), LHP(-1, lhY, lhZ, lhRx, 0, lhRz))
end

function Ending()
	local model, target, targettorso = mouseTarget()
	if not (target and targettorso) then return end
	targettorso.Anchored = true
	attack = true
	hum.WalkSpeed = 0
	local originalpos = root.CFrame
	root.CFrame = targettorso.CFrame * CF(0, 0, 2.6)
	loop(1.8, function() endingPose(-65, 65, -.9 - .1 * C(20), -.2 + .025 * C(20), -8, 10, { 90, 0, 35 }) end)
	Eviscerate(model)
	CreateSound("331666100", ra, 4, 1)
	CreateSound("180083286", targettorso, 10, 1)
	shake(1.8, 1.8)
	loop(4.6, function() endingPose(90, -90, -.6 - .1 * C(20), -.4 + .025 * C(20), -8, 10, { 0, 0, 90 }) end)
	task.wait(.6)
	root.CFrame = originalpos
	attack = false
	hum.WalkSpeed = 8
end

-- credit in the original: nooby
function Ende_der_Weld()
	attack = true
	hum.WalkSpeed = 0
	loop(4.6, function() endingPose(90, -90, -.6 - .1 * C(20), -.4 + .025 * C(20), -8, 10, { 0, 0, 90 }) end)

	local a = Instance.new("Part", char)
	a.BrickColor, a.Name, a.Anchored, a.Material = BrickColor.random(), "Lazer", true, Enum.Material.Neon
	a.Transparency, a.CanCollide, a.Size = 1, false, Vector3.new(.1, .1, .1)
	local hitbox = Instance.new("Part", char)
	hitbox.Size, hitbox.CFrame, hitbox.Anchored, hitbox.Transparency, hitbox.CanCollide = Vector3.new(5, 5, 5), mouse.Hit, true, 1, false

	local _, position = rayCast(ra.Position, (mouse.Hit.Position - ra.Position), 500, { char, realChar })
	a.CFrame = CF(ra.Position, position)
	Debris:AddItem(a, 5)
	Debris:AddItem(hitbox, 1)
	Instance.new("BlockMesh", a)
	MagicBlock(BrickColor.Random(), ra.CFrame, 5, 5, 5, 0.25, 0.25, 0.25, 0.025)
	MagicShockAlt(BrickColor.Random(), a.CFrame, 5, 5, 1.5, 1.5, 0.015, 1)
	MagicShockAlt(BrickColor.Random(), a.CFrame, 5, 5, 1.25, 1.25, 0.015, 2)
	MagicShockAlt(BrickColor.Random(), a.CFrame, 5, 5, 1, 1, 0.015, 1)

	local lbs = Instance.new("Part", char)
	CreateSound("929619479", lbs, 10, 1)
	lbs.Material, lbs.Color, lbs.CanCollide, lbs.Shape = Enum.Material.Neon, BrickColor.Random().Color, false, Enum.PartType.Ball
	lbs.Transparency, lbs.Size, lbs.CFrame = 0, Vector3.new(20, 20, 20), a.CFrame
	Instance.new("SpecialMesh", lbs).MeshType = Enum.MeshType.Sphere
	local bvs = Instance.new("BodyVelocity", lbs)
	bvs.MaxForce, bvs.Velocity = Vector3.new(1e9, 1e9, 1e9), a.CFrame.LookVector * 75
	lbs.Touched:Connect(function(hit) MagniDamage(hit, 12, 40, 60, 10, "Normal") end)
	attack = false
	Debris:AddItem(lbs, 10)

	for x = 0, 4 do
		local m1, m2 = IT("Model", char), IT("Model", char)
		for z = 0, 24 do
			local function orb(parent, cfr)
				local lb = Instance.new("Part", parent)
				lb.Material, lb.Color, lb.CanCollide, lb.Anchored = Enum.Material.Neon, BrickColor.Random().Color, false, true
				lb.Size, lb.CFrame = Vector3.new(2, 2, 2), cfr
				local ms = Instance.new("SpecialMesh", lb)
				ms.MeshType, ms.Scale = Enum.MeshType.Sphere, Vector3.new(0.5, 0.5, 1.5)
				lb.Touched:Connect(function(hit) MagniDamage(hit, 12, 40, 60, 10, "Normal") end)
				return lb
			end
			local c1 = lbs.CFrame * angles(Rad(Mrandom(-360, 360)), Rad(Mrandom(-360, 360)), Rad(Mrandom(-360, 360)))
			c1 = c1 + c1.LookVector * 15
			local lb = orb(m1, c1)
			local c2 = lbs.CFrame * angles(Rad(Mrandom(-360, 360)), Rad(Mrandom(-360, 360)), Rad(Mrandom(-360, 360)))
			c2 = c2 + lb.CFrame.LookVector * 15
			orb(m2, c2).Color = lb.Color
		end
		MagicBlock(BrickColor.Random(), lbs.CFrame, 25, 25, 25, -0.1, -0.1, -0.1, 0.025)
		MagicBlock(BrickColor.Random(), lbs.CFrame, 25, 25, 25, 0.5, 0.5, 0.5, 0.025)
		CreateSound("925629856", lbs, 5, 1)
		Debris:AddItem(m1, 7)
		Debris:AddItem(m2, 7)
		for sign, mdl in ipairs({ m1, m2 }) do
			for _, v in ipairs(mdl:GetChildren()) do
				if v:IsA("Part") then
					v.Anchored = false
					MagicBlock(v.BrickColor, v.CFrame, 1, 1, 1, 0.25, 0.25, 0.25, 0.025)
					local bv = Instance.new("BodyVelocity", v)
					bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
					bv.Velocity = v.CFrame.LookVector * (sign == 1 and 25 or -25)
					Debris:AddItem(v, 5)
				end
			end
		end
		task.wait(1)
	end
	attack = false
	hum.WalkSpeed = 8
end

---------------------------------------------------------------- input
local ATTACKS = {
	Edgy = { r = Decapitate, e = Laugh },
	Divinity = { r = Beam_Of_Light, f = Blast_Of_God },
	Fighter = { e = Flying_Kick, f = UpperCut, t = Spinning_Kick },
	Purity = { r = Purity_Slam },
	Destruction = { r = Diablo_Explosion, f = Hell_From_Above, t = Spinning_Below },
	Insanity = { r = Painful_Stomp, f = Ending, t = Ende_der_Weld },
}
UIS.InputBegan:Connect(function(input, gp)
	if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local key = input.KeyCode.Name:lower()
	if key == "zero" then hum.WalkSpeed = 38.82 return end
	if key == "n" then
		local hidden = tecks2.TextTransparency == 1
		tecks2.TextTransparency = hidden and 0 or 1
		tecks2.TextStrokeTransparency = hidden and 0 or 1
		return
	end
	if attack then return end
	-- mode toggles
	for name, m in pairs(MODES) do
		if key == m.key then
			if mode == "Neutral" then enterMode(name) return
			elseif mode == name then resetmode() return end
		end
	end
	-- abilities
	local set = ATTACKS[mode]
	local fn = set and set[key]
	if fn then task.spawn(fn) end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name:lower() == "zero" then
		hum.WalkSpeed = 8
	end
end)

---------------------------------------------------------------- animation loop
hum.WalkSpeed = 8
local animator = hum:FindFirstChild("Animator")
if animator then animator.Parent = nil end
Music.Parent = char
local change = 1

local function R2(a) return Mrandom(-a, a) end
local function walkLegs(alpha)
	local c7 = C(7)
	return RHP(1, -.925 - .5 * c7 / 2, .5 * c7 / 2, 0, 0, 0), LHP(-1, -.925 + .5 * c7 / 2, -.5 * c7 / 2, 0, 0, 0)
end

while true do
	swait()
	if mode == "Insanity" then
		randomTheme()
		tecks2.TextColor3, tecks2.TextStrokeColor3 = maincolor.Color, maincolor.Color
		MagicShockTrailAlt2(maincolor, root.CFrame * CF(R2(15), -3, R2(15)) * angles(Rad(90 + R2(25)), 0, 0), 1, .5, .5, -0.01, -0.01, 7, 0.1, Mrandom(1, 2))
	elseif mode == "Planetary" then
		MagicShockTrailAlt2(maincolor, root.CFrame * CF(R2(25), -3, R2(25)) * angles(Rad(90 + R2(15)), 0, 0), 1, .5, .5, -0.01, -0.01, 7, 0.1, 2)
	end
	sine = sine + change
	local vel = root.AssemblyLinearVelocity
	local torvel = (vel * Vector3.new(1, 0, 1)).Magnitude
	local hitfloor = rayCast(root.Position, Vector3.new(0, -1, 0), 4, { char, realChar })
	local clampY = math.clamp(vel.Y / 100, -Rad(65), Rad(65))
	local c20, s20, s30, c7, s7 = C(20), Sn(20), Sn(30), C(7), Sn(7)
	local rotY, hRot = root.AssemblyAngularVelocity.Y, hed.AssemblyAngularVelocity.Y

	local function walkRH(amp)
		return CF(1, -.925 - .5 * c7 / 2, amp * c7 / 2) * angles(Rad(-15 - (amp == .5 and 5 or 35) * c7) - rl.AssemblyAngularVelocity.Y / 75 + -s7 / 2.5, Rad(90 - .1 * c7), 0) * angles(Rad(.1 * c7), 0, 0)
	end
	local function walkLH(amp)
		return CF(-1, -.925 + .5 * c7 / 2, -amp * c7 / 2) * angles(Rad(-15 + (amp == .5 and 5 or 35) * c7) + ll.AssemblyAngularVelocity.Y / 75 + s7 / 2.5, Rad(-90 - .1 * c7), 0) * angles(Rad(-.1 * c7), 0, 0)
	end
	local function twitchNeck(baseX, baseZ)
		Neck.C0 = clerp(Neck.C0, necko * angles(Rad(baseX + R2(4)), Rad(R2(4)), Rad(baseZ + R2(4))), 1)
	end

	if not attack then
		if vel.Y > 1 and hitfloor == nil then
			pose({ .3, .3, .3, .3, .15, .3 }, RootCF * angles(clampY, 0, 0), NK(-10, 0, 0), CF(1.5, .5, 0) * angles(clampY, 0, Rad(15)), CF(-1.5, .5, 0) * angles(clampY, 0, Rad(-15)),
				CF(1, -1 - .1 * c20, -.3) * angles(0, Rad(90), 0), CF(-1, -.4 - .1 * c20, -.6) * LHCF * angles(Rad(-5), 0, Rad(20)))
			change = 1
		elseif vel.Y < -1 and hitfloor == nil then
			pose({ .3, .3, .3, .3, .15, .3 }, RootCF * angles(clampY, 0, 0), NK(10, 0, 0), CF(1.5, .5, 0) * angles(clampY, 0, Rad(90)), CF(-1.5, .5, 0) * angles(clampY, 0, Rad(-90)),
				CF(1, -1 - .1 * c20, -.3) * angles(0, Rad(90), 0), CF(-1, -.4 - .1 * c20, -.6) * LHCF * angles(Rad(-5), 0, Rad(20)))
			change = 1
		elseif torvel < 1 and hitfloor ~= nil then
			change = 1
			if mode == "Neutral" then
				pose(STD, RJ(0, 0, -.1 + .1 * c20, 0, 0, 0), NK(-2.5 * s20, 0, 0), SH(1.5, .5 + .05 * s20, .025 * c20, 0, -10 * c20, 5 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, 0, 10 * c20, -5 + 2.5 * s20),
					RHP(1, -.9 - .1 * c20, .025 * c20, -4.5, 0, 0), LHP(-1, -.9 - .1 * c20, .025 * c20, -6.5, 0, 0))
			elseif mode == "Edgy" then
				pose(STD, RJ(0, 0, -.1 + .1 * c20, 10, 0, 0), NK(30 - 2.5 * s20, 0, 0), SH(.8, .5 + .05 * s20, -.4 + .025 * c20, 0, -20, 215), SH(-.8, .5 + .05 * s20, -.4 + .025 * c20, 0, 20, -215),
					RHP(1, -.9 - .1 * c20, .025 * c20, -4.5, 0, 10), LHP(-1, -.9 - .1 * c20, -.2 + .025 * c20, -6.5, 0, -10))
				if Mrandom(1, 15) == 1 then Neck.C0 = clerp(Neck.C0, necko * angles(Rad(R2(15)), Rad(R2(15)), Rad(R2(15))), 1) end
			elseif mode == "Divinity" then
				pose(STD, RJ(0, 0, 1.2 + .3 * c20, 5, 0, 10), NK(-4.5 * s30, 0, -10), SH(1.5, .5 + .05 * s30, .025 * c20, -3 * s20, -10 * s20, 13 - 2.5 * s20), SH(-1.5, .5 + .05 * s30, .025 * c20, 4 * s20, 10 * s20, -13 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -20 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 2.5 * s20))
			elseif mode == "Fighter" then
				pose(STD, RJ(0, 0, -.4 + .1 * c20, 10, 0, 85), NK(-7.5 * s20, 0, -85), SH(1.5, .5 + .05 * s20, .025 * c20, 0, 0, 90 + 2.5 * s20), SH(-1, .3 + .05 * s20, .4 + .025 * c20, 0, 10 * c20, 35 + 2.5 * s20),
					RHP(.6, -.9 - .1 * c20, .025 * c20, -70, 0, 0), LHP(-1, -.7 - .1 * c20, .025 * c20, -16.5, 0, 0))
			elseif mode == "Purity" then
				pose(STD, RJ(0, 0, -.1 + .1 * c20, 0, 0, 10), NK(20 - 2.5 * s20, 0, 0), SH(.8, .5 + .05 * s20, -.6 + .025 * c20, 21, 11, -90 - 2.5 * s20), SH(-.8, .3 + .05 * s20, -.6 + .025 * c20, 8, 5, 90 + 2.5 * s20),
					RHP(1, -.9 - .1 * c20, .025 * c20, -4.5, 0, -10), LHP(-1, -.9 - .1 * c20, -.4 + .025 * c20, -6.5, 5 * c20, 6))
			elseif mode == "Destruction" then
				pose(STD, RJ(0, 0, 1.3 + .6 * c20, 0, 0, 25), NK(20 - 2.5 * s20, 20, -15), SH(1.5, .5 + .05 * s20, .025 * c20, 0, -10 * c20, 65 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, 0, 10 * c20, -15 + 2.5 * s20),
					RHP(1, -.5 - .1 * c20, -.4 + .025 * c20, -4.5 + 3 * s20, 0, 10 + 3 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -6.5 + 3 * s20, 0, -10 + 3 * s20))
			elseif mode == "Insanity" then
				pose(STD, RJ(0, 0, -.1 + .1 * c7, 10 + R2(6), 0, R2(6)), NK(45, 0, -20), SH(1.5, .5 + .05 * s7, .025 * c7, 180 + R2(35), 35 + R2(35), -50 - 2.5 * s20 + R2(35)), SH(-1.5, .5 + .05 * s7, .025 * c7, 15 + R2(35), R2(35), -15 + 2.5 * s20 + R2(35)),
					RHP(1, -.9 - .1 * c7, -.2 + .025 * c7, -5 + R2(6), 0, 10 + R2(6)), LHP(-1, -.9 - .1 * c7, .025 * c7, -5 + R2(6), 0, -10 + R2(6)))
				twitchNeck(45, -20)
				RW.C0 = clerp(RW.C0, CF(1.5, .5 + .05 * s30, .025 * c20) * angles(Rad(180), Rad(20), Rad(-50)), .1)
				LW.C0 = clerp(LW.C0, CF(-1.5, .5 + .05 * s30, .025 * c20) * angles(Rad(25), 0, Rad(-15)), .1)
			elseif mode == "Planetary" then
				pose(STD, RJ(0, 0, 2 + .3 * c20, 5, 0, 10), NK(20 - 4.5 * s30, 0, -10), SH(.8, .5 + .05 * s20, -.6 + .025 * c20, -21, 0, -90 - 2.5 * s20), SH(-.8, .3 + .05 * s20, -.6 + .025 * c20, 8, 0, 90 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -20 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 20 + 2.5 * s20))
			end
		elseif torvel > 2 and torvel < 25 and hitfloor ~= nil then
			change = .6
			local walkRJ = RootCF * CF(0, 0, -.175 + .025 * C(3.5) + -Sn(3.5) / 7) * angles(Rad(4 - 2.5 * C(3.5)), -rotY / 75, Rad(5 * c7))
			local walkNK = necko * angles(Rad(-2.5 * s20), 0, -hRot / 15)
			local rhW, lhW = walkRH(.5), walkLH(.5)
			local rwW = CF(1.5, .5 + .05 * s7, .15 * c7) * angles(Rad(45) * c7, 0, Rad(5) - ra.AssemblyAngularVelocity.Y / 75)
			local lwW = CF(-1.5, .5 + .05 * s7, -.15 * c7) * angles(Rad(-45) * c7, 0, Rad(-5) + la.AssemblyAngularVelocity.Y / 75)
			if mode == "Divinity" then
				pose(STD, RJ(0, 0, 1.2 + .3 * c20, 25, 0, 0), NK(-5 - 4.5 * s30, 0, 0), SH(1.5, .5 + .05 * s30, .025 * c20, -25 - 3 * s20, -10 * s20, 14 - 2.5 * s20), SH(-1.5, .5 + .05 * s30, .025 * c20, -25 + 4 * s20, 10 * s20, -14 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -20 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 20 + 2.5 * s20))
			elseif mode == "Destruction" then
				pose(STD, RJ(0, 0, 1.3 + .6 * c20, 30, 0, 0), NK(-2.5 * s20, 0, 0), SH(1.5, .5 + .05 * s20, .025 * c20, -17, -10 * c20, 15 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, -17, 10 * c20, -15 + 2.5 * s20),
					RHP(1, -.5 - .1 * c20, -.4 + .025 * c20, -4.5 + 3 * s20, 0, -10 + 3 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -6.5 + 3 * s20, 0, 10 + 3 * s20))
			elseif mode == "Insanity" then
				pose(STD, RJ(0, 0, -.1 + .1 * c7, 10 + R2(6), 0, R2(6)), NK(45, 0, -20), rwW, lwW, rhW, lhW)
				twitchNeck(45, -20)
				RW.C0 = clerp(RW.C0, SH(1.5, .5 + .05 * Sn(7), .025 * c7, 180 + R2(35), 35 + R2(35), -50 - 2.5 * s20 + R2(35)), .1)
				LW.C0 = clerp(LW.C0, SH(-1.5, .5 + .05 * Sn(7), .025 * c7, 15 + R2(35), R2(35), -15 + 2.5 * s20 + R2(35)), .1)
				RH.C0 = clerp(RH.C0, RHP(1, -.9 - .1 * c7, -.2 + .025 * c7, -5, 0, 10), .15)
				LH.C0 = clerp(LH.C0, LHP(-1, -.9 - .1 * c7, .025 * c7, -5, 0, -10), .15)
			elseif mode == "Edgy" then
				pose({ .15, .3, .1, .1, .3, .3 }, walkRJ, NK(30 - 2.5 * s20, 0, 0), SH(.8, .5 + .05 * s20, -.4 + .025 * c20, 0, -20, 215), SH(-.8, .5 + .05 * s20, -.4 + .025 * c20, 0, 20, -215), rhW, lhW)
				if Mrandom(1, 15) == 1 then Neck.C0 = clerp(Neck.C0, necko * angles(Rad(R2(15)), Rad(R2(15)), Rad(R2(15))), 1) end
			elseif mode == "Planetary" then
				pose(STD, RJ(0, 0, 2 + .3 * c20, 35, 0, 0), NK(-20 - 4.5 * s30, 0, 0), SH(1.5, .5 + .05 * s20, .025 * c20, -21, 0, 25 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, -21, 0, -25 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -20 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 20 + 2.5 * s20))
			else
				pose({ .15, .3, .1, .1, .3, .3 }, walkRJ, walkNK, rwW, lwW, rhW, lhW)
			end
		elseif torvel >= 25 and hitfloor ~= nil then
			change = 1.35
			local sprRJ = RootCF * CF(0, 0, -.175 + .025 * C(3.5) + -Sn(3.5) / 7) * angles(Rad(26 - 4.5 * C(3.5)), -rotY / 75, Rad(15 * c7))
			local sprNK = necko * angles(Rad(-2.5 * s20), 0, -hRot / 15)
			local rwS = CF(1.5, .5 + .05 * s30, .34 * c7) * angles(Rad(110) * c7, 0, Rad(13) - ra.AssemblyAngularVelocity.Y / 75)
			local lwS = CF(-1.5, .5 + .05 * s30, -.34 * c7) * angles(Rad(-110) * c7, 0, Rad(-13) + la.AssemblyAngularVelocity.Y / 75)
			if mode == "Divinity" then
				pose(STD, RJ(0, 0, 1.2 + .3 * c20, 45, 0, 0), NK(-5 - 4.5 * s30, 0, 0), SH(1.5, .5 + .05 * s30, .025 * c20, -55 - 3 * s20, -10 * s20, 14 - 2.5 * s20), SH(-1.5, .5 + .05 * s30, .025 * c20, -55 + 4 * s20, 10 * s20, -14 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -34 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 34 + 2.5 * s20))
			elseif mode == "Destruction" then
				pose(STD, RJ(0, 0, 1.3 + .6 * c20, 65, 0, 0), NK(-25 - 2.5 * s20, 0, 0), SH(1.5, .5 + .05 * s20, .025 * c20, -35, -10 * c20, 25 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, -35, 10 * c20, -25 + 2.5 * s20),
					RHP(1, -.5 - .1 * c20, -.4 + .025 * c20, -14.5 + 3 * s20, 0, -35 + 3 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -16.5 + 3 * s20, 0, 35 + 3 * s20))
			elseif mode == "Insanity" then
				pose(STD, RJ(0, 0, -.1 + .1 * c20, R2(90), 0, R2(90)), NK(R2(25), R2(25), R2(25)), SH(1.5, .5 + .05 * s30, .025 * c20, R2(90), 0, R2(90)), SH(-1.5, .5 + .05 * s30, .025 * c20, R2(90), 0, R2(90)),
					RHP(1, -.9 - .1 * c20, .025 * c20, R2(90), 0, R2(90)), LHP(-1, -.9 - .1 * c20, .025 * c20, R2(90), 0, R2(90)))
				RH.C0 = clerp(RH.C0, RHP(1, -.9 - .1 * c20, .025 * c20, -5, 0, 10), .15)
				LH.C0 = clerp(LH.C0, LHP(-1, -.9 - .1 * c20, .025 * c20, -5, 0, 16), .15)
				RW.C0 = clerp(RW.C0, SH(1.5, .5 + .05 * s30, .025 * c20, 10, 10, 15), .1)
				LW.C0 = clerp(LW.C0, SH(-1.5, .5 + .05 * s30, .025 * c20, -10, 0, -15), .1)
			elseif mode == "Planetary" then
				pose(STD, RJ(0, 0, 2 + .3 * c20, 75, 0, 10), NK(-40 - 4.5 * s30, 0, -10), SH(1.5, .5 + .05 * s20, .025 * c20, -21, 0, -15 - 2.5 * s20), SH(-1.5, .5 + .05 * s20, .025 * c20, -21, 0, -35 + 2.5 * s20),
					RHP(1, -.4 - .1 * c20, -.4 + .025 * c20, -2.5 + 3 * s20, 0, -20 + 2.5 * s20), LHP(-1, -.9 - .1 * c20, .025 * c20, -2.5 + 3 * s20, 0, 20 + 2.5 * s20))
			else
				pose({ .15, .3, .15, .15, .3, .3 }, sprRJ, sprNK, rwS, lwS, walkRH(.7), walkLH(.7))
			end
		end
	end

	-- animated effect parts
	for e = #Effects, 1, -1 do
		local Thing = Effects[e]
		local Part, kind = Thing[1], Thing[2]
		if Part and Part.Parent and Part.Transparency <= 1 then
			local msh = Thing[7]
			if kind == "Block1" then
				Part.CFrame = Part.CFrame * Euler(Mrandom(-50, 50), Mrandom(-50, 50), Mrandom(-50, 50))
				msh.Scale = msh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
				Part.Transparency = Part.Transparency + Thing[3]
			elseif kind == "Block2" or kind == "Cylinder" then
				msh.Scale = msh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
				Part.Transparency = Part.Transparency + Thing[3]
			elseif kind == "Block3" then
				Part.CFrame = Part.CFrame * Euler(Mrandom(-50, 50), Mrandom(-50, 50), Mrandom(-50, 50)) + Vector3.new(0, 0.15, 0)
				msh.Scale = msh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
				Part.Transparency = Part.Transparency + Thing[3]
			elseif kind == "Disappear" then
				Part.Transparency = Part.Transparency + Thing[3]
			end
		else
			if Part then Part:Destroy() end
			table.remove(Effects, e)
		end
	end
end
