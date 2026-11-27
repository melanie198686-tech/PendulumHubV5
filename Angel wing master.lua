-----------------------
--XEvent Chara (fixed)--
-----------------------
--Original: makhail07 and KillerDarkness0105
-- Muhahahah ellernate.lol fixed ts 

Bypass = "death"
loadstring(game:GetObjects("rbxassetid://5325226148")[1].Source)()
-- FILL: if asset 5325226148 no longer loads, swap in a live reanimate that creates workspace.non

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local ChatService = game:GetService("Chat")
local rs = RunService.RenderStepped

local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()
local cam = workspace.CurrentCamera
local cf, v3, c3, it = CFrame.new, Vector3.new, Color3.new, Instance.new
local angles, rad, ran, huge = CFrame.Angles, math.rad, math.random, math.huge

---------------------------------------------------------------- netless
RunService.Heartbeat:Connect(function()
	local c = plr.Character
	if not c then return end
	for _, v in ipairs(c:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.AssemblyLinearVelocity = v3(0, 30, 0)
		end
	end
end)
warn("Netless Activated!")

---------------------------------------------------------------- input helper (replaces Mouse.KeyDown)
local keyHandlers, keysDown = {}, {}
UIS.InputBegan:Connect(function(i, gp)
	if gp or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local k = i.KeyCode.Name:lower()
	keysDown[k] = true
	for _, f in ipairs(keyHandlers[k] or {}) do task.spawn(f) end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Keyboard then keysDown[i.KeyCode.Name:lower()] = nil end
end)
local function onKey(k, f)
	keyHandlers[k] = keyHandlers[k] or {}
	table.insert(keyHandlers[k], f)
end

---------------------------------------------------------------- fling
Bypass = "Death"
local realChar = plr.Character or plr.CharacterAdded:Wait()
local bullet = realChar:WaitForChild("HumanoidRootPart")
bullet.Transparency = 1
bullet.Massless = true
local dead = false

local bbv = it("BodyPosition", bullet)
bbv.MaxForce = v3(huge, huge, huge)
bbv.Position = (realChar:FindFirstChild("Torso") or bullet).Position

local holding = false
Mouse.Button1Down:Connect(function()
	holding = true
	if dead then return end
	local bbav = it("BodyAngularVelocity", bullet)
	bbav.MaxTorque = v3(huge, huge, huge)
	bbav.P = huge
	bbav.AngularVelocity = v3(1e9, 1e9, 1e9)
	Debris:AddItem(bbav, 0.1)

	local t = Mouse.Target
	if not t then return end
	local model = t:FindFirstAncestorOfClass("Model")
	if not model or model == realChar or model.Name == "non" then return end
	if not Players:GetPlayerFromCharacter(model) then return end
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	rs:Wait()
	bbv.Position = hrp.Position
	bullet.CFrame = cf(hrp.Position)
	task.wait(1)
end)
Mouse.Button1Up:Connect(function() holding = false end)
RunService.Heartbeat:Connect(function()
	bullet.AssemblyLinearVelocity = v3(0, 26, 0)
	if holding and Mouse.Target then bullet.CFrame = cf(Mouse.Hit.Position) end
end)

---------------------------------------------------------------- rig
local animate = realChar:FindFirstChild("Animate")
if animate then animate.Disabled = true end
task.wait()

local Char = workspace:WaitForChild("non")
local char = Char
local Human = Char:WaitForChild("Humanoid")
local hum = Human
local LArm, RArm = Char["Left Arm"], Char["Right Arm"]
local LLeg, RLeg = Char["Left Leg"], Char["Right Leg"]
local larm, rarm, lleg, rleg = LArm, RArm, LLeg, RLeg
local Torso = Char.Torso
local torso = Torso
local RS, LS = Torso["Right Shoulder"], Torso["Left Shoulder"]
local RH, LH = Torso["Right Hip"], Torso["Left Hip"]
local Head = Char.Head
local hed = Head
local Neck = Torso.Neck
local RootPart = Char.HumanoidRootPart
local root = RootPart
local RootJoint = RootPart.RootJoint
local Player = plr

local CurrentEffects, CurrentDamages = {}, {}
local attacking, attacktype, Portalling = false, 1, false
local r = rs
local clerp = function(a, b, t) return a:Lerp(b, t) end

local necko = cf(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
local LHC0 = cf(-1, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
local LSC0 = cf(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
local RHC0 = cf(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
local RSC0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
local ROOTC0 = cf(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

local Debounces = { NoIdl = false }

local function newWeld(p0, p1, x, y, z)
	local w = it("Weld", p1)
	w.Part0, w.Part1 = p0, p1
	w.C0 = cf(x, y, z)
	return w
end

newWeld(torso, larm, -1.5, 0.5, 0).C1 = cf(0, 0.5, 0)
newWeld(torso, rarm, 1.5, 0.5, 0).C1 = cf(0, 0.5, 0)
newWeld(torso, hed, 0, 1.5, 0)
newWeld(torso, lleg, -0.5, -1, 0).C1 = cf(0, 1, 0)
newWeld(torso, rleg, 0.5, -1, 0).C1 = cf(0, 1, 0)
newWeld(root, torso, 0, -1, 0).C1 = cf(0, -1, 0)

---------------------------------------------------------------- helpers
local function say(msg)
	pcall(function() ChatService:Chat(Char.Head, msg, "Green") end)
end

local function part(parent, anchored, cancollide, size, cframe, col3, material, trans)
	local p = it("Part", parent)
	p.Anchored, p.CanCollide, p.Size, p.CFrame = anchored, cancollide, size, cframe
	p.Color, p.Material, p.Transparency = col3, material, trans
	p.Locked = true
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	return p
end
local function mesh(parent, ttype, scale)
	local m = it("SpecialMesh", parent)
	m.MeshType, m.Scale = ttype, scale
	return m
end
local function spmesh(parent, id, scale)
	local m = it("SpecialMesh", parent)
	m.MeshType = Enum.MeshType.FileMesh
	m.MeshId, m.Scale = id, scale
	return m
end
local function smoothNO(p)
	p.TopSurface, p.BottomSurface, p.BackSurface = 10, 10, 10
	p.FrontSurface, p.LeftSurface, p.RightSurface = 10, 10, 10
	return p
end
local function sound(parent, id, vol, looped, pitch)
	local s = it("Sound", parent)
	s.SoundId, s.Volume, s.Looped, s.Pitch = id, vol, looped, pitch or 1
	return s
end
local function randRot() return angles(ran(-10, 10), ran(-10, 10), ran(-10, 10)) end

local function ClearEffects()
	for i = #CurrentEffects, 1, -1 do
		local v = CurrentEffects[i]
		if v then pcall(function() v:Destroy() end) end
		table.remove(CurrentEffects, i)
	end
end

local function PEE(p0, size, col3, Lemission, trans, accel, ltp, edirection, enabled, lifetime, rate, rotation, rotspeed, speed, velspread, name, text)
	local p = it("ParticleEmitter", p0)
	p.Size, p.Texture, p.Color, p.LightEmission, p.Transparency = size, text, col3, Lemission, trans
	p.Acceleration, p.LockedToPart, p.EmissionDirection, p.Enabled = accel, ltp, edirection, enabled
	p.Lifetime, p.Rate, p.Rotation, p.RotSpeed, p.Speed = lifetime, rate, rotation, rotspeed, speed
	p.VelocitySpread, p.Name = velspread, name
	return p
end

local function gui(GuiType, parent, text, backtrans, backcol, pos, size)
	local g = it(GuiType)
	g.Parent = parent
	g.Text = text
	g.BackgroundTransparency, g.BackgroundColor3 = backtrans, backcol
	g.Position, g.Size = pos, size
	g.Font = Enum.Font.SourceSans
	g.TextSize = 60
	g.TextWrapped = false
	g.TextStrokeTransparency = 0
	g.TextColor3 = c3(0, 1, 0)
	return g
end

-- damage text + health loss on non-player humanoids
local function RealDamage(p0, min, max, radius)
	task.spawn(function()
		for _, v in ipairs(workspace:GetChildren()) do
			local h, t = v:FindFirstChild("Humanoid"), v:FindFirstChild("Torso")
			if h and t and v.Name ~= plr.Name and v ~= Char and (t.Position - p0.Position).Magnitude <= radius then
				local hpdmg = ran(min, max)
				h.Health = h.Health - hpdmg
				local Dbil = it("BillboardGui", t)
				Dbil.Adornee, Dbil.Size, Dbil.AlwaysOnTop = t, UDim2.new(0, 500, 0, 500), true
				Dbil.ExtentsOffset = v3(ran(-3, 3), ran(-3, 3), ran(-3, 3))
				local goo = gui("TextLabel", Dbil, tostring(hpdmg), 1, c3(0, 0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0))
				for i = 1, 10 do task.wait() goo.TextTransparency = i / 10 end
				Dbil:Destroy()
			end
		end
	end)
end

---------------------------------------------------------------- cframe tween helpers (crater)
local function toAxisAngle(CFr)
	local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CFr:GetComponents()
	local Angle = math.acos(math.clamp((R00 + R11 + R22 - 1) / 2, -1, 1))
	local A = (R21 - R12) ^ 2 + (R02 - R20) ^ 2 + (R10 - R01) ^ 2
	if A == 0 then A = 0.00001 end
	local d = math.sqrt(A)
	return v3((R21 - R12) / d, (R02 - R20) / d, (R10 - R01) / d), Angle
end
local function ApplyTrig(Num, Func)
	local Min, Max = Func(0), Func(1)
	return (Func(Num) - Min) / (Max - Min)
end
local function LerpCFrame(c1, c2, Num)
	local Vec, Ang = toAxisAngle(c1:Inverse() * c2)
	return c1 * CFrame.fromAxisAngle(Vec, Ang * Num) + (c2.Position - c1.Position) * Num
end

local function Crater(T, Radius)
	task.spawn(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		local ignore = { Char, realChar }
		for _, v in ipairs(Players:GetPlayers()) do
			if v.Character then table.insert(ignore, v.Character) end
		end
		params.FilterDescendantsInstances = ignore
		local res = workspace:Raycast(T.Position, v3(0, -10, 0), params)
		if not res then return end
		local Hit, Pos, SurfaceNorm = res.Instance, res.Position, res.Normal
		local base = cf(Pos, Pos + SurfaceNorm) * angles(rad(90), 0, 0)
		local Parts = {}
		for i = 1, 360, 10 do
			local P = it("Part", T.Parent)
			P.Anchored, P.BrickColor, P.Material = true, BrickColor.new("Lime green"), Enum.Material.Granite
			P.TopSurface, P.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
			P.Size = v3(5, 10, 10) * (ran(80, 100) / 100)
			P.CFrame = (base - v3(0, 7, 0)) * angles(rad(ran(-50, 50)), rad(ran(-50, 50)), rad(ran(-50, 50)))
			Parts[#Parts + 1] = { P, P.CFrame, (base - v3(0, 1, 0)) * angles(0, rad(i), 0) * cf(0, 0, -Radius) * angles(rad(ran(-50, -20)), rad(ran(-15, 15)), rad(ran(-15, 15))), P.Size }
			if ran(0, 5) == 0 then
				local R = it("Part", T.Parent)
				R.Anchored, R.BrickColor, R.Material = true, BrickColor.new("Lime green"), Hit.Material
				R.TopSurface, R.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
				R.Size = v3(5, 5, 5) * (ran(80, 100) / 100)
				R.CFrame = (base - v3(0, 2.5, 0)) * angles(rad(ran(-50, 50)), rad(ran(-50, 50)), rad(ran(-50, 50)))
				Parts[#Parts + 1] = { R, R.CFrame, base * angles(0, rad(i), 0) * cf(0, 0, -Radius - 8) * angles(rad(ran(-90, 90)), rad(ran(-90, 90)), rad(ran(-90, 90))), R.Size }
			end
		end
		for i = 0, 1, 0.05 do
			for _, v in ipairs(Parts) do v[1].CFrame = LerpCFrame(v[2], v[3], ApplyTrig(i, math.cos)) end
			task.wait(0.02)
		end
		for _, v in ipairs(Parts) do
			if v[1].Size.X > 2.1 then v[1].CFrame = v[1].CFrame + v3(0, 2, 0) end
			v[1].Anchored = false
		end
		for i = 0, 1, 0.05 do
			for _, v in ipairs(Parts) do
				v[1].Transparency = i
				if i >= 0.25 then v[1].CanCollide = false end
			end
			task.wait(0.02)
		end
		for _, v in ipairs(Parts) do v[1]:Destroy() end
	end)
end

---------------------------------------------------------------- transformation intro
local Transforming = true
Human.WalkSpeed = 0
local TorsoColor = BrickColor.new("Lime green")
local wit, wit2 = TorsoColor.Color, c3(0, 1, 0)

local fx = it("Part", Torso)
fx.Anchored, fx.CanCollide, fx.Locked, fx.Transparency = true, false, true, 1
fx.Material, fx.Size, fx.BrickColor = Enum.Material.Neon, v3(1, 1, 1), BrickColor.new("Really black")
local fxm = mesh(fx, Enum.MeshType.Sphere, v3(1, 1, 1))

local function burst(parent, col, size, speed)
	local e = it("ParticleEmitter", parent)
	e.LightEmission, e.Texture, e.Color = 1, "rbxassetid://284205403", ColorSequence.new(col)
	e.Size, e.Speed, e.LockedToPart = NumberSequence.new(size), NumberRange.new(25, speed), false
	e.Transparency, e.RotSpeed = NumberSequence.new(0.75), NumberRange.new(-2000, 2000)
	e.Lifetime, e.Rate, e.VelocitySpread = NumberRange.new(1), 2000, 9001
	return e
end
local glowz, glowz2 = burst(fx, wit, 5, 50), burst(fx, wit2, 5, 50)

sound(Torso, "rbxassetid://93724183", 5, false, 0.5):Play()
do
	local value = 1
	for i = 1, 20 do
		rs:Wait()
		value = value - 0.05
		fx.Transparency = fx.Transparency - (1 / 20)
		fx.CFrame = Torso.CFrame
		fxm.Scale = fxm.Scale + v3(value, value, value)
	end
end

local function GroundWave()
	if not Transforming then return end
	sound(Torso, "rbxassetid://393621716", 10, false):Play()
	local wave = part(Torso, true, false, v3(1, 1, 1), fx.CFrame, c3(0, 0, 0), Enum.Material.Neon, 0.35)
	local e1, e2 = burst(wave, wit, 30, 100), burst(wave, wit, 30, 100)
	local wm = mesh(wave, Enum.MeshType.Sphere, v3(1, 1, 1))
	local wave2 = part(Torso, true, false, v3(1, 1, 1), fx.CFrame, TorsoColor.Color, Enum.Material.Neon, 0.35)
	local wm2 = spmesh(wave2, "http://www.roblox.com/asset/?id=3270017", v3(1, 1, 1))
	local wave3 = part(Torso, true, false, v3(1, 1, 1), fx.CFrame, c3(0, 0, 0), Enum.Material.Neon, 0.35)
	local wm3 = spmesh(wave3, "http://www.roblox.com/asset/?id=3270017", v3(1, 1, 1))
	task.spawn(function()
		local value, value2, value3 = 5, 10, 20
		for i = 1, 18 do
			value = value - 0.5
			value2 = value2 - 0.75 * 1.5
			value3 = value3 - 0.475 * 1.5
			wm.Scale = wm.Scale + v3(value * 3.5, value * 3.5, value * 3.5)
			wm2.Scale = wm.Scale + v3(value2 * 3.5, value2 * 3.5, 0.5)
			wm3.Scale = wm.Scale + v3(value3 * 3.5, value3 * 3.5, 0.25)
			wave.CFrame = fx.CFrame
			wave2.CFrame = fx.CFrame * angles(rad(90), 0, 0)
			wave3.CFrame = fx.CFrame * angles(rad(90), 0, 0)
			wave.Transparency, wave2.Transparency, wave3.Transparency = i / 14, i / 14, i / 14
			e1.Rate, e2.Rate = 0, 0
			task.wait()
		end
		wave:Destroy() wave2:Destroy() wave3:Destroy()
	end)
end

for i = 1, 100 do rs:Wait() fx.CFrame = Torso.CFrame end
task.spawn(function()
	while Transforming do
		GroundWave()
		task.wait(1)
	end
end)
task.wait(4)
Transforming = false

do
	local value2 = 1
	for i = 1, 20 do
		rs:Wait()
		value2 = value2 - 0.05
		glowz.Rate, glowz2.Rate = 0, 0
		fx.Transparency = fx.Transparency + (1 / 20)
		fx.CFrame = torso.CFrame
		fxm.Scale = fxm.Scale + v3(value2, value2, value2)
	end
	glowz:Destroy() glowz2:Destroy()
end

do
	local HandCF = cf(root.Position - v3(0, 3, 0)) * angles(rad(90), 0, 0)
	sound(torso, "rbxassetid://130972023", 5, false):Play()
	sound(torso, "rbxassetid://153274423", 5, false):Play()
	local Mus = sound(torso, "rbxassetid://397952612", 6, true)
	Mus:Play()
	Crater(torso, 67)
	local function ring(col)
		local w = part(torso, true, false, v3(1, 1, 1), HandCF, col, Enum.Material.Plastic, 0.35)
		return w, spmesh(w, "rbxassetid://3270017", v3(1, 1, 1))
	end
	local wave, wm = ring(TorsoColor.Color)
	local wave2, wm2 = ring(c3(0, 0, 0))
	local wave3, wm3 = ring(TorsoColor.Color)
	task.spawn(function()
		local valuer, valuer2, valuer3 = 5, 10, 15
		for i = 1, 14 do
			valuer = valuer - 0.35
			valuer2 = valuer - 0.45
			valuer3 = valuer3 - 0.475
			wm.Scale = wm.Scale + v3(valuer * 2.5, valuer * 2.5, 1 + i * 200)
			wm2.Scale = wm2.Scale + v3(valuer2 * 2.5, valuer2 * 2.5, i * 10)
			wm3.Scale = wm3.Scale + v3(valuer3 * 2.5, valuer3 * 2.5, 1)
			for _, w in ipairs({ wave, wave2, wave3 }) do
				w.CFrame = HandCF
				w.Transparency = i / 14
			end
			task.wait()
		end
		wave:Destroy() wave2:Destroy() wave3:Destroy()
	end)
end
hum.WalkSpeed = 16

---------------------------------------------------------------- name tag + look
local txt = it("BillboardGui", Char)
txt.Adornee, txt.Name, txt.Size = Char.Head, "_status", UDim2.new(2, 0, 1.2, 0)
txt.StudsOffset = v3(-9, 8, 0)
local text = it("TextLabel", txt)
text.Size = UDim2.new(10, 0, 7, 0)
text.TextScaled, text.BackgroundTransparency = true, 1
text.TextTransparency, text.TextStrokeTransparency = 0, 0
text.Font = Enum.Font.Antique
text.TextStrokeColor3 = c3(0, 1, 0)
text.TextColor3 = c3(0, 0, 0)
text.Text = Char.Name

local cb = part(realChar, true, false, v3(10, 5, 3), Char.Torso.CFrame, BrickColor.new("Pastel blue").Color, Enum.Material.Plastic, 1)
cb.Name = "ColorBrick"

plr:ClearCharacterAppearance()
task.wait(0.1)
for _, n in ipairs({ "Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg" }) do
	local p = realChar:FindFirstChild(n)
	if p then p.BrickColor = BrickColor.new("Really black") end
end

for _, p in ipairs({ Torso, Char["Right Arm"], Char["Right Leg"], Char["Left Arm"], Char["Left Leg"] }) do
	local sb = it("SelectionBox", p)
	sb.Adornee, sb.Color3, sb.LineThickness, sb.Transparency = p, c3(0, 1, 0), 0.01, 0
end
local LightOnBody = it("PointLight", Head)
LightOnBody.Brightness, LightOnBody.Range, LightOnBody.Color = 20, 20, c3(0, 1, 0)

---------------------------------------------------------------- wings (procedural rebuild of the baked-CFrame model)
do
	local m2 = it("Model")
	m2.Name = "Wings"
	local anchor = it("Part", m2)
	anchor.Name, anchor.Transparency, anchor.Size = "TorsoPart", 1, v3(4, 4, 2)
	anchor.CanCollide, anchor.Massless = false, true
	local wa = it("Weld", anchor)
	wa.Part0, wa.Part1 = torso, anchor
	wa.C0 = cf(0, 0.7, 0.8) * angles(rad(10), 0, 0)
	m2.PrimaryPart = anchor
	-- spar length, angle above horizontal (deg)
	local spars = { { 3.09, -50 }, { 7.33, -5 }, { 7.33, 25 }, { 8.04, 50 }, { 3.09, 80 } }
	for _, s in ipairs({ 1, -1 }) do
		for _, sp in ipairs(spars) do
			local L, a = sp[1], rad(sp[2])
			local dir = v3(s * math.cos(a), math.sin(a), 0.35).Unit
			local base = v3(s * 1.1, 0.4, 0.6)
			local mid = base + dir * (L / 2)
			local bar = it("Part", m2)
			bar.Color, bar.Material = c3(0, 1, 0), Enum.Material.Neon
			bar.Size = v3(0.61, L, 0.22)
			bar.CanCollide, bar.Massless = false, true
			bar.TopSurface, bar.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
			mesh(bar, Enum.MeshType.Sphere, v3(1, 1, 1))
			local wb = it("Weld", bar)
			wb.Part0, wb.Part1 = anchor, bar
			wb.C0 = cf(mid, mid + dir) * angles(rad(-90), 0, 0)
			-- feather beads along the spar
			for k = 1, math.floor(L / 1.2) do
				local bead = it("Part", m2)
				bead.Color, bead.Material, bead.Reflectance = c3(0, 1, 0), Enum.Material.SmoothPlastic, 0.3
				bead.Size = v3(0.58, 0.58, 0.58)
				bead.CanCollide, bead.Massless = false, true
				mesh(bead, Enum.MeshType.Sphere, v3(1, 1, 0.6))
				local wd = it("Weld", bead)
				wd.Part0, wd.Part1 = anchor, bead
				wd.C0 = cf(base + dir * (k * 1.2) + v3(0, -0.6, 0.15))
			end
		end
	end
	m2.Parent = Char
end

---------------------------------------------------------------- fly
local flySpeed, MAX_FLY_SPEED = 0, 150
local canFly, flyToggled = false, false
local forward, side, lastForward, lastSide = 0, 0, 0, 0
local stanceToggle

local floatBP = it("BodyPosition")
floatBP.MaxForce = v3(0, huge, 0)
local flyBV = it("BodyVelocity")
flyBV.MaxForce = v3(9e9, 9e9, 9e9)
local turnBG = it("BodyGyro")
turnBG.MaxTorque = v3(huge, huge, huge)

onKey("f", function()
	flyToggled = not flyToggled
	if not flyToggled then
		stanceToggle = "Normal"
		floatBP.Parent, flyBV.Parent, turnBG.Parent = nil, nil, nil
		root.AssemblyLinearVelocity = v3()
		Human.PlatformStand = false
	end
end)

local function updateFly()
	if not flyToggled then return end
	lastForward, lastSide = forward, side
	forward, side = 0, 0
	if keysDown.w then forward += 1 end
	if keysDown.s then forward -= 1 end
	if keysDown.a then side -= 1 end
	if keysDown.d then side += 1 end
	canFly = (forward ~= 0 or side ~= 0)
	if canFly then
		stanceToggle = "Floating"
		turnBG.Parent, floatBP.Parent, flyBV.Parent = root, nil, root
		flySpeed = math.min(flySpeed + 1 + (flySpeed / MAX_FLY_SPEED), MAX_FLY_SPEED)
	else
		floatBP.Position = root.Position
		floatBP.Parent = root
		flySpeed = math.max(flySpeed - 1, 0)
	end
	local camCF = cam.CFrame
	local inF = canFly and forward or lastForward
	local inS = canFly and side or lastSide
	flyBV.Velocity = ((camCF.LookVector * inF) + (camCF * cf(inS, inF * 0.2, 0)).Position - camCF.Position) * flySpeed
	turnBG.CFrame = camCF * angles(-rad(forward * (flySpeed / MAX_FLY_SPEED)), 0, 0)
end
RunService.RenderStepped:Connect(function()
	if flyToggled then Human.PlatformStand = true end
	updateFly()
end)

---------------------------------------------------------------- lighting
Lighting.Brightness = 0
Lighting.OutdoorAmbient = c3(0, 1, 0)
Lighting.ClockTime = 0
Lighting.Ambient = c3(0, 0, 0)
Lighting.FogColor = c3(0, 0, 0)
Lighting.FogStart, Lighting.FogEnd = 0, 500
Lighting.GlobalShadows = true

Human.WalkSpeed = 26

---------------------------------------------------------------- poses
local function defpos()
	Neck.C0, LH.C0, LS.C0, RH.C0, RS.C0, RootJoint.C0 = necko, LHC0, LSC0, RHC0, RSC0, ROOTC0
end
local function newpos()
	defpos()
	RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(-50), 0, 0), .3)
	LS.C0 = clerp(LS.C0, LS.C0 * angles(rad(-50), 0, 0), .3)
	RH.C0 = clerp(RH.C0, RH.C0 * angles(rad(-25), 0, 0), .3)
	LH.C0 = clerp(LH.C0, LH.C0 * angles(rad(-25), 0, 0), .3)
	RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * cf(0, 0, 1), 1)
end

---------------------------------------------------------------- eye + rising effects
local EyePart = part(Char, false, false, v3(.3, .3, .3), Torso.CFrame, c3(0, 1, 0), Enum.Material.Neon, 0)
EyePart.Name, EyePart.Shape, EyePart.Massless = "EyePart", Enum.PartType.Ball, true
local EyeWeld = it("Weld", Char)
EyeWeld.Part0, EyeWeld.Part1 = EyePart, Head
EyeWeld.C0 = EyeWeld.C0 * cf(.2, -.25, .578)

local EyeTrans = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0) })
do
	local PE = it("ParticleEmitter", EyePart)
	PE.LightEmission, PE.LockedToPart = .4, true
	PE.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, .4, 0), NumberSequenceKeypoint.new(1, 0, 0) })
	PE.Transparency, PE.Acceleration = EyeTrans, v3(2, 0, 0)
	PE.Lifetime, PE.Rate, PE.Speed = NumberRange.new(2), 70, NumberRange.new(4)
	PE.Texture = "rbxassetid://300899374"
end

task.spawn(function()
	while true do
		local p = part(Char, true, false, v3(.5, .5, .5), Torso.CFrame * cf(ran(-2, 2), -3, ran(-2, 2)),
			({ c3(0, 1, 0), c3(0, 0, 0) })[ran(1, 2)], Enum.Material.Neon, 0)
		for i = 1, 30 do
			p.CFrame = p.CFrame * angles(.5, .5, .5) + v3(0, .2, 0)
			p.Transparency = i / 30
			rs:Wait()
		end
		p:Destroy()
	end
end)

task.spawn(function()
	while true do
		local MCir = part(Char, false, false, v3(0, 0, 0), Torso.CFrame, c3(0, 0, 0), Enum.Material.Neon, 1)
		MCir.Massless = true
		local CirM = mesh(MCir, Enum.MeshType.Cylinder, v3(1.3, 3.3, 3.3))
		local CirDec = it("Decal", MCir)
		CirDec.Texture, CirDec.Face, CirDec.Transparency = "rbxassetid://687708091", Enum.NormalId.Right, .5
		local MagicWeld = it("Weld", Char)
		MagicWeld.Part0, MagicWeld.Part1 = EyePart, MCir
		MagicWeld.C0 = MagicWeld.C0 * angles(0, rad(90), 0) * cf(.05, 0, 0)
		for i = 1, 40 do
			MagicWeld.C0 = MagicWeld.C0 * angles(rad(6), 0, 0)
			CirM.Scale = CirM.Scale + v3(0, .4, .4)
			CirDec.Transparency = i / 40
			rs:Wait()
		end
		MCir:Destroy() MagicWeld:Destroy()
	end
end)

---------------------------------------------------------------- attacks
local function attackone()
	if attacking then return end
	attacking = true
	say("Hmph.")
	local Hbox = part(Char, false, false, v3(1.5, 2, 1.5), Torso.CFrame, c3(0, 0, 0), Enum.Material.Plastic, 1)
	Hbox.Massless = true
	RealDamage(Hbox, 7, 16, 5)
	local w = it("Weld", Char)
	w.Part0, w.Part1 = Hbox, LArm
	w.C0 = w.C0 * cf(0, 1, 0)
	for i = 1, 10 do
		LS.C0 = clerp(LS.C0, LS.C0 * angles(0, rad(-65), rad(-150)), .06)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(90)), .06)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(0, 0, rad(-90)), .06)
		rs:Wait()
	end
	for i = 1, 10 do
		LS.C0 = clerp(LS.C0, LS.C0 * angles(rad(-9), 0, 0), 1)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(-12)), 1)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(0, 0, rad(12)), 1)
		rs:Wait()
	end
	task.wait(.8)
	newpos()
	Hbox:Destroy() w:Destroy()
	attacking = false
end

local function attacktwo()
	if attacking then return end
	attacking = true
	say("Die!")
	local ETorso = Torso:Clone()
	ETorso.Transparency, ETorso.Anchored, ETorso.CanCollide = 1, true, false
	ETorso.CFrame = Torso.CFrame
	for i = 1, 10 do
		RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(-7), 0, 0) * cf(0, -.05, 0), 1)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(9)), 1)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(0, 0, rad(-9)), 1)
		rs:Wait()
	end
	for i = 1, 30 do
		local p = part(Char, true, false, v3(1, 1, 1), ETorso.CFrame * cf(0, 0, -i) * randRot(), c3(0, 1, 0), Enum.Material.Plastic, 0)
		local m = spmesh(p, "rbxassetid://3270017", v3(4, 4, 4))
		task.spawn(function()
			for ii = 1, 20 do
				rs:Wait()
				m.Scale = m.Scale + v3(.5, .5, .5)
				p.Transparency = ii / 20
			end
			p:Destroy()
		end)
		rs:Wait()
	end
	local urmum = part(Char, true, false, v3(1, 1, 1), ETorso.CFrame * cf(0, 0, -30), c3(0, 1, 0), Enum.Material.Plastic, 0)
	smoothNO(urmum)
	local HBox = part(Char, true, false, v3(2, 2, 2), urmum.CFrame, c3(0, 1, 0), Enum.Material.Plastic, 1)
	HBox.Shape = Enum.PartType.Ball
	RealDamage(HBox, 10, 25, 20)
	local urmesh = mesh(urmum, Enum.MeshType.Sphere, v3(2, 2, 2))
	task.spawn(function()
		for i = 1, 40 do
			urmum.Transparency = i / 40
			urmesh.Scale = urmesh.Scale + v3(1.5, 1.5, 1.5)
			HBox.CFrame = urmum.CFrame
			HBox.Size = HBox.Size + v3(1, 1, 1)
			rs:Wait()
		end
		urmum:Destroy()
	end)
	for a = 1, 2 do
		for i = 1, 20 do
			task.spawn(function()
				local rann = part(Char, true, false, v3(0, 0, 0), ETorso.CFrame * cf(0, 0, -30) * cf(ran(-30, 30), ran(30), ran(-30, 30)), c3(0, 1, 0), Enum.Material.Neon, 1)
				local p = part(Char, false, false, v3(0, 0, 0), ETorso.CFrame * cf(0, 0, -30), c3(0, 1, 0), Enum.Material.Neon, 0)
				it("BlockMesh", p).Scale = v3(6, 6, 6)
				local bp = it("BodyPosition", p)
				bp.MaxForce, bp.Position = v3(huge, huge, huge), rann.Position
				for k = 1, 16 do rs:Wait() p.Transparency = k / 16 end
				p:Destroy() rann:Destroy()
			end)
		end
	end
	ETorso:Destroy()
	task.delay(1, function() HBox:Destroy() end)
	attacking = false
	newpos()
end

local function attackthree()
	if attacking then return end
	attacking = true
	say("Get Ready..")
	for i = 1, 10 do
		RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(-33), 0, rad(-10)) * cf(0, -.25, 0), .4)
		LS.C0 = clerp(LS.C0, LS.C0 * angles(0, rad(20), 0), .06)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(-6)), 1)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(0, 0, rad(6)), 1)
		rs:Wait()
	end
	local ball = part(Char, false, false, v3(1, 1, 1), Head.CFrame, c3(0, 0, 0), Enum.Material.Plastic, .8)
	local ball2 = part(Char, false, false, v3(1, 1, 1), Head.CFrame, c3(0, 1, 0), Enum.Material.Neon, .2)
	local w = it("Weld", Char)
	w.Part0, w.Part1 = ball, RArm
	w.C0 = w.C0 * cf(0, 20, 0)
	local w2 = it("Weld", Char)
	w2.Part0, w2.Part1 = ball2, ball
	local m = mesh(ball, Enum.MeshType.Sphere, v3(.1, .1, .1))
	local m2 = mesh(ball2, Enum.MeshType.Sphere, v3(.01, .01, .01))
	local PE = it("ParticleEmitter", ball)
	PE.LightEmission, PE.LockedToPart = .4, false
	PE.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 5, 0), NumberSequenceKeypoint.new(1, 0, 0) })
	PE.Transparency, PE.Lifetime = EyeTrans, NumberRange.new(4)
	PE.Rate, PE.Speed, PE.Texture = 500, NumberRange.new(0), "rbxassetid://300899374"
	task.spawn(function()
		for i = 1, 30 do
			task.spawn(function()
				local rng = part(Char, true, false, v3(1, 1, 1), ball.CFrame * randRot(), c3(0, 1, 0), Enum.Material.Plastic, .5)
				local rm = spmesh(rng, "rbxassetid://3270017", v3(60, 60, 60))
				for ii = 1, 10 do rm.Scale = rm.Scale - v3(6, 6, 6) rs:Wait() end
				rng:Destroy()
			end)
			task.wait()
		end
	end)
	local p1 = part(Char, true, false, v3(1, 1, 1), ball.CFrame, c3(0, 1, 0), Enum.Material.Neon, .5)
	mesh(p1, Enum.MeshType.Brick, v3(5, 5, 5))
	for i = 1, 20 do
		m.Scale = m.Scale + v3(.5, .5, .5)
		m2.Scale = m2.Scale + v3(.3, .3, .3)
		p1.Transparency = (i / 20) ^ 2
		rs:Wait()
	end
	p1:Destroy()
	task.wait(.5)
	w.Parent = nil
	local placeholder = part(Char, true, false, v3(1, 1, 1), Head.CFrame * cf(0, -5, -30), c3(0, 1, 0), Enum.Material.Neon, 1)
	local BV = it("BodyVelocity", ball)
	BV.MaxForce = v3(huge, huge, huge)
	BV.Velocity = (placeholder.Position - ball.Position).Unit * 100
	local hit = false
	ball.Touched:Connect(function(h)
		if hit or h == ball2 or h:IsDescendantOf(Char) or h:IsDescendantOf(realChar) then return end
		hit = true
		ball.Anchored, PE.Enabled, ball.Transparency, ball2.Transparency = true, false, 1, 1
		local xpl = part(Char, true, false, v3(1, 1, 1), ball.CFrame * randRot(), c3(0, 1, 0), Enum.Material.Neon, .75)
		local xm = spmesh(xpl, "rbxassetid://9982590", v3(4, 4, 4))
		local xpl2 = part(Char, true, false, v3(4, 4, 4), ball.CFrame, c3(0, 1, 0), Enum.Material.Neon, 1)
		task.spawn(function()
			for i = 1, 80 do
				xpl.Transparency = math.min(.75 + i / 80, 1)
				xm.Scale = xm.Scale + v3(.6, .6, .6)
				task.wait()
			end
		end)
		RealDamage(xpl2, 15, 30, 7)
		for i = 1, 50 do
			xpl2.Size = xpl2.Size + v3(.3, .3, .3)
			xpl2.CFrame = ball.CFrame
			rs:Wait()
		end
		xpl:Destroy() xpl2:Destroy()
	end)
	task.spawn(function()
		task.wait(1.5)
		BV:Destroy() placeholder:Destroy() PE.Enabled = false ball2:Destroy()
		task.wait(7)
		ball:Destroy()
	end)
	for i = 1, 10 do
		RS.C0 = clerp(RS.C0, RS.C0 * angles(0, rad(20), rad(30)), .4)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(12)), 1)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(0, 0, rad(-12)), 1)
		task.wait()
	end
	say("Falling Star!")
	task.wait(2)
	attacking = false
	attacktype = 1
	newpos()
end

Mouse.Button1Down:Connect(function()
	if attacking then return end
	if attacktype == 1 then attacktype = 2 attackone()
	elseif attacktype == 2 then attacktype = 3 attacktwo()
	elseif attacktype == 3 then attacktype = 1 attackthree() end
end)

---------------------------------------------------------------- big explosion (shared by G and P)
local function Explosion(doDamage)
	local T = Torso.CFrame
	local function P(col, trans, rot) return part(Char, true, false, v3(1, 1, 1), rot and T * randRot() or T, col, Enum.Material.Neon, trans) end
	local G, B = c3(0, 1, 0), c3(0, 0, 0)
	local b1, b2, b3 = P(G, .5), P(B, .6), P(G, .7)
	local r1, r2 = P(B, .6, true), P(B, .6, true)
	local bb = P(B, .7)
	local gr, gr2 = P(G, .7, true), P(G, .7, true)
	local sw, sw2 = P(G, .7), P(G, .7)
	local bm1 = spmesh(b1, "rbxassetid://9982590", v3(8, 8, 8))
	local bm2 = mesh(b2, Enum.MeshType.Sphere, v3(40, 40, 40))
	local bm3 = mesh(b3, Enum.MeshType.Sphere, v3(42, 42, 42))
	local rm1 = spmesh(r1, "rbxassetid://3270017", v3(50, 50, 30))
	local rm2 = spmesh(r2, "rbxassetid://3270017", v3(50, 50, 30))
	local bbm = mesh(bb, Enum.MeshType.Sphere, v3(60, 60, 60))
	local grm1 = spmesh(gr, "rbxassetid://3270017", v3(80, 80, 50))
	local grm2 = spmesh(gr2, "rbxassetid://3270017", v3(80, 80, 50))
	local ss1 = spmesh(sw, "rbxassetid://20329976", v3(40, 15, 40))
	local ss2 = spmesh(sw2, "rbxassetid://20329976", v3(48, 5, 48))
	smoothNO(b1) smoothNO(b2) smoothNO(bb)
	if doDamage then RealDamage(Torso, 70, 200, 70) end
	local function spin(p, a, k) p.CFrame = p.CFrame:Lerp(p.CFrame * angles(rad(ran(1, 30)), rad(ran(1, 30)), rad(ran(1, 30))), a) end
	for i = 1, 400 do
		rs:Wait()
		b1.CFrame = b1.CFrame:Lerp(b1.CFrame * angles(rad(3), 0, rad(3)), .4)
		spin(r1, .3) spin(r2, .3) spin(gr, .1) spin(gr2, .1)
		sw.CFrame = sw.CFrame:Lerp(sw.CFrame * angles(0, rad(5), 0), .4)
		sw2.CFrame = sw2.CFrame:Lerp(sw2.CFrame * angles(0, rad(-5), 0), .4)
		bm1.Scale = bm1.Scale:Lerp(bm1.Scale + v3(1.8, 1.8, 1.8), .069)
		bm2.Scale = bm2.Scale:Lerp(bm2.Scale + v3(6, 6, 6), .1)
		bm3.Scale = bm3.Scale:Lerp(bm3.Scale + v3(6, 6, 6), .1)
		rm1.Scale = rm1.Scale:Lerp(rm1.Scale + v3(7, 7, 7), .1)
		rm2.Scale = rm2.Scale:Lerp(rm2.Scale + v3(7, 7, 7), .1)
		bbm.Scale = bbm.Scale:Lerp(bbm.Scale + v3(8, 8, 8), .1)
		grm1.Scale = grm1.Scale:Lerp(grm1.Scale + v3(7, 7, 7), .1)
		grm2.Scale = grm2.Scale:Lerp(grm2.Scale + v3(7, 7, 7), .1)
		ss1.Scale = ss1.Scale:Lerp(ss1.Scale + v3(7, 3, 7), .1)
		ss2.Scale = ss2.Scale:Lerp(ss2.Scale + v3(7, 2, 7), .1)
		local t = math.min(.7 + i / 400, 1)
		for _, p in ipairs({ b1, b2, b3, r1, r2, bb, gr, gr2, sw, sw2 }) do p.Transparency = t end
	end
	for _, p in ipairs({ b1, b2, b3, r1, r2, bb, gr, gr2, sw, sw2 }) do p:Destroy() end
end

---------------------------------------------------------------- G: Hades Gate
local Ging = false
onKey("g", function()
	if Ging or attacking then return end
	attacking, Torso.Anchored = true, true
	local Clear, REKING = {}, true
	say("By The Power Bestowed Upon Me Within The Demon's Eye..")
	for i = 1, 20 do
		RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(4.5), rad(-2), rad(8.5)) * cf(0.02, 0, 0), 1)
		RootJoint.C0 = clerp(RootJoint.C0, RootJoint.C0 * angles(0, 0, rad(1)), 1)
		Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(rad(-1), 0, rad(-2)), 1)
		rs:Wait()
	end
	local ball = part(Char, false, false, v3(0, 0, 0), Torso.CFrame, c3(0, 1, 0), Enum.Material.Neon, 0)
	local ball2 = part(Char, false, false, v3(.3, .3, .3), Torso.CFrame, c3(0, 0, 0), Enum.Material.Plastic, .8)
	ball.Massless, ball2.Massless = true, true
	local bm = mesh(ball, Enum.MeshType.Sphere, v3(0, 0, 0))
	local bm2 = mesh(ball2, Enum.MeshType.Sphere, v3(.3, .3, .3))
	smoothNO(ball2)
	for _, b in ipairs({ ball, ball2 }) do
		local w = it("Weld", Char)
		w.Part0, w.Part1 = b, RArm
		w.C0 = w.C0 * cf(0, 1.6, 0)
	end
	for i = 1, 60 do
		rs:Wait()
		bm.Scale = bm.Scale:Lerp(bm.Scale + v3(.23, .23, .23), .3)
		bm2.Scale = bm2.Scale:Lerp(bm2.Scale + v3(.3, .3, .3), .3)
	end
	local Ring = part(Char, true, false, v3(0, 0, 0), ball.CFrame, c3(0, 0, 0), Enum.Material.Neon, .5)
	local Ring2 = Ring:Clone()
	Ring2.Parent = Char
	spmesh(Ring, "rbxassetid://3270017", v3(1.7, 1.7, .5))
	spmesh(Ring2, "rbxassetid://3270017", v3(1.7, 1.7, .5))
	Ring.CFrame = ball.CFrame * randRot()
	Ring2.CFrame = ball.CFrame * randRot()
	Ging = true
	task.spawn(function()
		while Ging do
			rs:Wait()
			for _, rg in ipairs({ Ring, Ring2 }) do
				rg.CFrame = rg.CFrame:Lerp(rg.CFrame * angles(rad(ran(1, 30)), rad(ran(1, 30)), rad(ran(1, 30))), .3)
			end
		end
	end)

	local cols = { c3(0, 1, 0), c3(0, 0, 0) }
	local function fromground()
		local main = part(Char, true, false, v3(1, .2, 1), Torso.CFrame * cf(0, -3, 0), cols[ran(#cols)], Enum.Material.Neon, 0)
		main.CFrame = main.CFrame * cf(ran(-30, 30), 0, ran(-30, 30)) * angles(rad(90), 0, 0)
		local one = mesh(main, Enum.MeshType.Sphere, v3(.3, .3, .3))
		for i = 0, 10, .1 do
			one.Scale = one.Scale + v3(.1, .1, 4)
			main.Transparency = math.min(i, 1)
			task.wait()
		end
		main:Destroy()
	end
	task.spawn(function()
		while Ging do
			task.spawn(fromground)
			task.wait(.1)
		end
	end)

	task.spawn(function()
		for i = 1, 17 do
			rs:Wait()
			local Cir = part(Char, true, false, v3(0, 0, 0), Torso.CFrame * cf(0, -2.8, 0) * angles(0, 0, rad(90)), c3(0, 0, 0), Enum.Material.Neon, 1)
			local Cirm = mesh(Cir, Enum.MeshType.Cylinder, v3(0, 1, 1))
			local CirDec = it("Decal", Cir)
			CirDec.Texture, CirDec.Face = "rbxassetid://687708091", Enum.NormalId.Right
			table.insert(Clear, Cir)
			task.spawn(function()
				for ii = 1, 100 do
					rs:Wait()
					Cir.CFrame = Cir.CFrame * angles(rad(i * 1.5), 0, 0)
					Cirm.Scale = Cirm.Scale:Lerp(Cirm.Scale + v3(0, 6, 6), .4)
					CirDec.Transparency = ii / 100
				end
			end)
		end
	end)

	local Bright = {}
	for i = 1, 10 do table.insert(Bright, 1 - (i - 1) * .1) end
	table.insert(Bright, 0)
	task.spawn(function()
		for i = 1, #Bright do Lighting.Brightness = Bright[i] task.wait(.1) end
	end)
	local C1 = part(Char, true, false, v3(1, 1, 1), Torso.CFrame * cf(0, 155, 0), c3(90 / 255, 97 / 255, 99 / 255), Enum.Material.Plastic, 1)
	spmesh(C1, "rbxassetid://1095708", v3(1000, 50, 1000))
	for i = 1, #Bright do C1.Transparency = Bright[i] task.wait(.1) end

	say("Open! Hades Gate!")
	Portalling = true
	local TransPoints = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(.51, 0, 0), NumberSequenceKeypoint.new(.517, .0123, 0),
		NumberSequenceKeypoint.new(.767, .0926, 0), NumberSequenceKeypoint.new(.88, .395, 0), NumberSequenceKeypoint.new(1, 1, 0) })
	local SizePoints = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 4.56, 0), NumberSequenceKeypoint.new(.046, 4.44, 0), NumberSequenceKeypoint.new(.144, 4.25, 0),
		NumberSequenceKeypoint.new(.521, 4, 0), NumberSequenceKeypoint.new(1, 3.75, 0) })
	local PCol = ColorSequence.new(c3(1, 1, 1), c3(0, 1, 1))
	for n = 1, 2 do
		local Spoke1 = part(Char, true, false, v3(1, 1, 1), Torso.CFrame, c3(0, 1, 1), Enum.Material.Plastic, 1)
		local pp = {}
		for k = 1, 4 do pp[k] = part(Char, false, false, v3(2, 2, 2), Torso.CFrame, c3(0, 1, 1), Enum.Material.Plastic, 1) pp[k].Massless = true end
		local POS = part(Char, false, false, v3(2, 2, 2), Torso.CFrame * angles(rad(90), 0, 0) * cf(0, 0, -140), c3(0, 1, 1), Enum.Material.Plastic, 1)
		POS.Massless = true
		local wel0 = it("Weld", Char) wel0.Part0, wel0.Part1 = Spoke1, POS
		local offs = { cf(0, 60, 0), cf(0, -60, 0), cf(-60, 0, 0), cf(60, 0, 0) }
		local dirs = { "Bottom", "Top", "Right", "Left" }
		for k = 1, 4 do
			local wl = it("Weld", Char)
			wl.Part0, wl.Part1 = POS, pp[k]
			wl.C0 = wl.C0 * offs[k]
			PEE(pp[k], SizePoints, PCol, .6, TransPoints, v3(0, 0, 0), false, dirs[k], true, NumberRange.new(6), 20,
				NumberRange.new(0), NumberRange.new(0), NumberRange.new(6), 0, "SpinningPortalEffect" .. k, "rbxassetid://300899374")
		end
		task.spawn(function()
			while Portalling do
				task.wait()
				POS.CFrame = POS.CFrame * angles(0, 0, rad(3))
			end
			POS:Destroy()
			for _, p in ipairs(pp) do p:Destroy() end
			Spoke1:Destroy()
		end)
		task.wait(.5)
	end
	task.wait(5)
	newpos()
	say("Now, You Will Know What It's Like To Burn.")
	Ging = false
	Ring:Destroy() Ring2:Destroy() ball:Destroy() ball2:Destroy()
	for _, v in ipairs(Clear) do v:Destroy() end
	task.wait(3)
	say("DIE!!!!!")
	defpos()
	RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(-30), 0, 0), 1)
	LS.C0 = clerp(LS.C0, LS.C0 * angles(rad(-30), 0, 0), 1)
	RH.C0 = clerp(RH.C0, RH.C0 * angles(rad(-10), 0, 0), 1)
	LH.C0 = clerp(LH.C0, LH.C0 * angles(rad(-10), 0, 0), 1)
	Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(rad(-35), 0, 0), 1)
	local cylp = part(Char, true, false, v3(1, 1, 1), Torso.CFrame * angles(0, 0, rad(90)), c3(0, 1, 0), Enum.Material.Neon, .5)
	mesh(cylp, Enum.MeshType.Cylinder, v3(5000, 60, 40))
	smoothNO(cylp)
	task.spawn(function()
		while REKING do
			rs:Wait()
			cylp.CFrame = Torso.CFrame * angles(0, 0, rad(90)) * cf(ran(-2, 2), 0, ran(-2, 2))
		end
	end)
	for i = 1, 30 do
		rs:Wait()
		task.spawn(Explosion, true)
		task.wait(.89)
	end
	REKING = false
	for i = 0, 9 do Lighting.Brightness = i * .1 task.wait(.1) end
	Lighting.Brightness = 1
	Portalling = false
	for i = 1, 10 do
		task.wait()
		C1.Transparency = math.min(i / 10, 1)
		cylp.Transparency = math.min(.5 + i / 10, 1)
	end
	C1:Destroy() cylp:Destroy()
	Torso.Anchored = false
	newpos()
	attacking = false
end)

---------------------------------------------------------------- P: single explosion
onKey("p", function()
	if attacking then return end
	attacking = true
	say("URAGH!")
	Torso.Anchored = true
	RS.C0 = clerp(RS.C0, RS.C0 * angles(rad(-30), 0, 0), 1)
	LS.C0 = clerp(LS.C0, LS.C0 * angles(rad(-30), 0, 0), 1)
	RH.C0 = clerp(RH.C0, RH.C0 * angles(rad(-10), 0, 0), 1)
	LH.C0 = clerp(LH.C0, LH.C0 * angles(rad(-10), 0, 0), 1)
	Neck.C0 = clerp(Neck.C0, Neck.C0 * angles(rad(-35), 0, 0), 1)
	task.spawn(Explosion, false)
	task.wait(2)
	Torso.Anchored = false
	newpos()
	attacking = false
end)

---------------------------------------------------------------- L / M
onKey("l", function()
	local poop = part(Char, true, false, v3(1, 1, 1), Torso.CFrame, c3(0, 1, 0), Enum.Material.Neon, .7)
	local cyl = mesh(poop, Enum.MeshType.Cylinder, v3(1, 1, 1))
	for i = 1, 60, .2 do
		rs:Wait()
		cyl.Scale = v3(i * 2, i * 2, 4)
		poop.CFrame = Torso.CFrame * cf(0, 0, -i) * angles(0, rad(90), 0)
	end
	poop:Destroy()
end)
onKey("m", function()
	local poop = part(Char, true, false, v3(1, 1, 1), Torso.CFrame * cf(ran(3, 10), ran(0, 10), ran(3, 10)), c3(0, 1, 0), Enum.Material.Neon, .7)
	Debris:AddItem(poop, 3)
end)

---------------------------------------------------------------- idle / walk / run animation
local animpose, lastanimpose = "Idle", "Idle"
local sine, change = 0, 1
local ffing, jumpn = false, false
Human.FreeFalling:Connect(function(f) ffing = f end)

RunService.RenderStepped:Connect(function()
	sine += change
	local speed = (torso.AssemblyLinearVelocity * v3(1, 0, 1)).Magnitude
	if jumpn then animpose = "Jumping"
	elseif ffing then animpose = "Freefalling"
	elseif speed < 2 then animpose = "Idle"
	elseif speed < 20 then animpose = "Walking"
	else animpose = "Running" end

	if animpose ~= lastanimpose then
		sine = 0
		if not Debounces.NoIdl then
			if animpose == "Idle" then
				rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .62, 0) * angles(rad(-6), rad(-6), rad(8)), .4)
				larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.5, .62, 0) * angles(rad(-6), rad(6), rad(-8)), .4)
				hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, -.2) * angles(rad(-14), 0, 0), .4)
				torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, 0, 0), .4)
				lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, -1, 0) * angles(0, 0, rad(-8)), .4)
				rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1, 0) * angles(0, 0, rad(8)), .4)
			elseif animpose == "Walking" then
				rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .55, 0) * angles(rad(-16), rad(-12), rad(10 + 2 * math.cos(sine / 14))), .2)
				larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.5, .55, 0) * angles(rad(-16), rad(12), rad(-10 - 2 * math.cos(sine / 14))), .2)
				hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, -.2) * angles(rad(-14), 0, 0), .4)
				torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, 0, 0) * angles(rad(-10), 0, 0), .05)
				lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, -1, 0) * angles(rad(-8), 0, rad(-8)), .4)
				rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1, 0) * angles(rad(-8), 0, rad(8)), .4)
			elseif animpose == "Running" then
				rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .55, 0) * angles(rad(-20), rad(-14), rad(8 + 2 * math.cos(sine / 14))), .2)
				larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.5, .55, 0) * angles(rad(-20), rad(14), rad(-8 - 2 * math.cos(sine / 14))), .2)
				hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, -.2) * angles(rad(-10), 0, 0), .4)
				torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, 0, 0) * angles(rad(-20), 0, 0), .4)
				lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, -1, 0) * angles(rad(-12), 0, rad(-7)), .4)
				rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1, 0) * angles(rad(-12), 0, rad(7)), .4)
			end
		end
	end
	lastanimpose = animpose

	if not Debounces.NoIdl then
		if animpose == "Idle" then
			change = .5
			rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .62 + .1 * math.cos(sine / 10), 0) * angles(rad(-10), rad(-10), rad(14 + 2 * math.cos(sine / 10))), .4)
			larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.5, .62 + .1 * math.cos(sine / 10), 0) * angles(rad(-20), rad(6), rad(-10 - 2 * math.cos(sine / 10))), .4)
			hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, -.2) * angles(rad(-14 + math.cos(sine / 10)), rad(20), 0), .2)
			hed.Weld.C1 = clerp(hed.Weld.C1, cf(0, 0, 0), .2)
			torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, 1 - .16 * math.cos(sine / 10), 0) * angles(0, rad(-20), 0), .05)
			lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, -.1 * math.cos(sine / 10), -.55) * angles(rad(-10 + math.cos(sine / 10)), rad(10), rad(-2 * math.cos(sine / 10))), .4)
			rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1 - .1 * math.cos(sine / 10), 0) * angles(0, rad(-10), rad(2 * math.cos(sine / 10))), .4)
		elseif animpose == "Walking" then
			change = 1
			rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .55, 0) * angles(rad(-16), rad(-12), rad(10 + 2 * math.cos(sine / 14))), .2)
			larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.5, .55, 0) * angles(rad(-16), rad(12), rad(-10 - 2 * math.cos(sine / 14))), .2)
			hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, -.2) * angles(rad(-14), 0, 0), .4)
			torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, -.1 * math.cos(sine / 14), 0) * angles(rad(-10), 0, 0), .05)
			lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, -1, 0) * angles(rad(-8), 0, rad(-8)), .4)
			rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1, 0) * angles(rad(-8), 0, rad(8)), .4)
		elseif animpose == "Running" then
			change = 1
			rarm.Weld.C0 = clerp(rarm.Weld.C0, cf(1.5, .35, .4) * angles(rad(-30), rad(14), rad(-30 + 2 * math.cos(sine / 14))), .2)
			larm.Weld.C0 = clerp(larm.Weld.C0, cf(-1.2, .55, -.4) * angles(rad(110), 0, rad(40 - 2 * math.cos(sine / 14))), .2)
			hed.Weld.C0 = clerp(hed.Weld.C0, cf(0, 1.5, .2) * angles(rad(20), rad(10), 0), .4)
			torso.Weld.C0 = clerp(torso.Weld.C0, cf(0, -.1 * math.cos(sine / 14), 0) * angles(rad(-40), rad(-10), 0), .2)
			lleg.Weld.C0 = clerp(lleg.Weld.C0, cf(-.5, 0, -1.2) * angles(rad(-20), rad(10), 0), .4)
			rleg.Weld.C0 = clerp(rleg.Weld.C0, cf(.5, -1, 0) * angles(rad(-12), rad(10), 0), .4)
		end
	end
end)

---------------------------------------------------------------- health + ambient wave
hum.MaxHealth = huge
task.wait(3)
hum.Health = huge

local function GroundWave3()
	local HandCF = cf(root.Position - v3(0, 3, 0)) * angles(rad(90), 0, 0)
	local wave = part(Torso, true, false, v3(1, 1, 1), HandCF, c3(0, 1, 0), Enum.Material.Plastic, .35)
	local wm = spmesh(wave, "rbxassetid://3270017", v3(1, 1, 1))
	task.spawn(function()
		for i = 1, 14 do
			wm.Scale = v3(1 + i * 1.1, 1 + i * 1.1, 1)
			wave.CFrame = HandCF
			wave.Transparency = i / 14
			task.wait()
		end
		wave:Destroy()
	end)
end
task.spawn(function()
	while task.wait(2) do GroundWave3() end
end)
