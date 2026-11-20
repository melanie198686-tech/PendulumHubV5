_G.loop = true
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = Workspace:FindFirstChild("non") or player.Character or player.CharacterAdded:Wait()

local Align = function(Part0, Part1, Mesh)
	local Aligns = {
		AlignOrientation = Instance.new("AlignOrientation"),
		AlignPosition = Instance.new("AlignPosition")
	}
	Aligns.AlignOrientation.Parent = Part0
	Aligns.AlignPosition.Parent = Part0

	local Attachments = {
		Attach0 = Instance.new("Attachment"),
		Attach1 = Instance.new("Attachment")
	}
	Attachments.Attach0.Parent = Part0
	Attachments.Attach1.Parent = Part1

	local m = Part0:FindFirstChildOfClass("SpecialMesh")
	if Mesh and m then
		m:Destroy()
	end
	Part0:BreakJoints()

	Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
	Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
	Aligns.AlignOrientation.Responsiveness = 200
	Aligns.AlignOrientation.RigidityEnabled = true

	Aligns.AlignPosition.Attachment0 = Attachments.Attach0
	Aligns.AlignPosition.Attachment1 = Attachments.Attach1
	Aligns.AlignPosition.Responsiveness = 200
	Aligns.AlignPosition.RigidityEnabled = true
	Aligns.AlignPosition.MaxForce = 9e9

	task.spawn(function()
		while _G.loop and Part0 and Part0.Parent and Part1 and Part1.Parent do
			local mag = (Part0.Position - (Part1.CFrame * Attachments.Attach0.CFrame:Inverse()).Position).Magnitude
			if mag >= 5 then
				Part0.CFrame = Part1.CFrame * Attachments.Attach0.CFrame:Inverse()
			end
			Part0.AssemblyLinearVelocity = Vector3.new(0, 35, 0)
			RunService.Heartbeat:Wait()
		end
	end)

	return {Attachments.Attach0, Attachments, Aligns}
end

local accessory = char:FindFirstChildWhichIsA("Accessory")
local accHandle = accessory and accessory:FindFirstChild("Handle")
local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
if accHandle and rightArm then
	local hat = Align(accHandle, rightArm, false)
	local cfOffset = rightArm.CFrame * CFrame.new(0, -0.75, -2.5) * CFrame.Angles(math.rad(45), math.rad(-90), 0)
	hat[1].CFrame = cfOffset:Inverse() * rightArm.CFrame
end

task.spawn(function()
	char.AncestryChanged:Wait()
	_G.loop = false
end)

Player = player
Character = char
PlayerGui = Player:WaitForChild("PlayerGui")
Backpack = Player:WaitForChild("Backpack")
Torso = Character:WaitForChild("Torso")
Head = Character:WaitForChild("Head")
Humanoid = Character:WaitForChild("Humanoid")
LeftArm = Character:WaitForChild("Left Arm")
LeftLeg = Character:WaitForChild("Left Leg")
RightArm = Character:WaitForChild("Right Arm")
RightLeg = Character:WaitForChild("Right Leg")
LS = Torso:WaitForChild("Left Shoulder")
LH = Torso:WaitForChild("Left Hip")
RS = Torso:WaitForChild("Right Shoulder")
RH = Torso:WaitForChild("Right Hip")
Face = Head:FindFirstChild("face")
Neck = Torso:WaitForChild("Neck")

it = Instance.new
attacktype = 1
vt = Vector3.new
cf = CFrame.new
euler = CFrame.fromEulerAnglesXYZ
angles = CFrame.Angles
cloaked = false
necko = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
necko2 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
LHC0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
LHC1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
RHC0 = cf(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
RHC1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
RootPart = Character:WaitForChild("HumanoidRootPart")
RootJoint = RootPart:WaitForChild("RootJoint")
RootCF = euler(-1.57, 0, 3.14)

attack = false
attackdebounce = false
deb = false
equipped = true
hand = false
combo = 0
mana = 0
trispeed = 0.2
attackmode = "none"
local idle = 0
local Anim = "Idle"
local Effects = {}
local gun = false
local shoot = false
Mouse = Player:GetMouse()

RSH, LSH = nil, nil
RW, LW = Instance.new("Weld"), Instance.new("Weld")
RW.Name = "Right Shoulder"
LW.Name = "Left Shoulder"
TorsoColor = Torso.BrickColor

function NoOutline(Part)
	Part.TopSurface, Part.BottomSurface, Part.LeftSurface, Part.RightSurface, Part.FrontSurface, Part.BackSurface = 10, 10, 10, 10, 10, 10
end

ch = Character
RSH = ch.Torso:FindFirstChild("Right Shoulder")
LSH = ch.Torso:FindFirstChild("Left Shoulder")
if RSH then
	RSH.Parent = nil
end
if LSH then
	LSH.Parent = nil
end

RW.Name = "Right Shoulder"
RW.Part0 = ch.Torso
RW.C0 = cf(1.5, 0.5, 0)
RW.C1 = cf(0, 0.5, 0)
RW.Part1 = ch["Right Arm"]
RW.Parent = ch.Torso

LW.Name = "Left Shoulder"
LW.Part0 = ch.Torso
LW.C0 = cf(-1.5, 0.5, 0)
LW.C1 = cf(0, 0.5, 0)
LW.Part1 = ch["Left Arm"]
LW.Parent = ch.Torso

local function weldBetween(a, b)
	local weldd = Instance.new("ManualWeld")
	weldd.Part0 = a
	weldd.Part1 = b
	weldd.C0 = CFrame.new()
	weldd.C1 = b.CFrame:inverse() * a.CFrame
	weldd.Parent = a
	return weldd
end

function swait(num)
	if num == 0 or num == nil then
		RunService.Heartbeat:Wait()
	else
		for i = 0, num do
			RunService.Heartbeat:Wait()
		end
	end
end

a = Instance.new("ScreenGui")
a.Name = "CooldownGUI"
a.ResetOnSpawn = false
a.Parent = PlayerGui

b = Instance.new("Frame")
b.Parent = a
b.Visible = true
b.BackgroundTransparency = 0.3
b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
b.BorderColor3 = Color3.fromRGB(255, 255, 255)
b.BorderSizePixel = 3
b.Position = UDim2.new(0.7, 0, 0.75, 0)
b.Size = UDim2.new(0, 200, 0, 100)

c = Instance.new("Frame")
c.Parent = a
c.Visible = true
c.BackgroundTransparency = 0.3
c.BorderColor3 = Color3.fromRGB(255, 255, 255)
c.BorderSizePixel = 3
c.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
c.Position = UDim2.new(0.875, 0, 0.75, 0)
c.Size = UDim2.new(0, 200, 0, 100)

d = Instance.new("Frame")
d.Parent = a
d.Visible = true
d.BackgroundTransparency = 0.3
d.BorderColor3 = Color3.fromRGB(255, 255, 255)
d.BorderSizePixel = 3
d.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
d.Position = UDim2.new(0.875, 0, 0.95, 0)
d.Size = UDim2.new(0, 200, 0, 100)

e = Instance.new("Frame")
e.Parent = a
e.Visible = true
e.BackgroundTransparency = 0.3
e.BorderColor3 = Color3.fromRGB(255, 255, 255)
e.BorderSizePixel = 3
e.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
e.Position = UDim2.new(0.7, 0, 0.95, 0)
e.Size = UDim2.new(0, 200, 0, 100)

f = Instance.new("Frame")
f.Parent = a
f.Visible = true
f.BackgroundTransparency = 0.3
f.BorderColor3 = Color3.fromRGB(255, 255, 255)
f.BorderSizePixel = 3
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.Position = UDim2.new(0.875, 0, 0.55, 0)
f.Size = UDim2.new(0, 200, 0, 100)

g = Instance.new("Frame")
g.Parent = a
g.Visible = true
g.BackgroundTransparency = 0.3
g.BorderColor3 = Color3.fromRGB(255, 255, 255)
g.BorderSizePixel = 3
g.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
g.Position = UDim2.new(0.7, 0, 0.55, 0)
g.Size = UDim2.new(0, 200, 0, 100)

b2 = Instance.new("TextLabel")
b2.Parent = a
b2.BackgroundTransparency = 1
b2.BorderColor3 = Color3.fromRGB(139, 139, 139)
b2.BorderSizePixel = 3
b2.Position = b.Position
b2.Size = UDim2.new(0, 200, 0, 100)
b2.Visible = true
b2.ZIndex = 3
b2.Font = "SourceSansItalic"
b2.FontSize = "Size32"
b2.TextColor3 = Color3.fromRGB(255, 255, 255)
b2.TextScaled = false
b2.TextStrokeColor3 = Color3.fromRGB(139, 139, 139)
b2.TextTransparency = 0
b2.Text = "Shock\n(Z)"

c2 = Instance.new("TextLabel")
c2.Parent = a
c2.BackgroundTransparency = 1
c2.BorderColor3 = Color3.fromRGB(139, 139, 139)
c2.BorderSizePixel = 3
c2.Position = c.Position
c2.Size = UDim2.new(0, 200, 0, 100)
c2.Visible = true
c2.ZIndex = 3
c2.Font = "SourceSansItalic"
c2.FontSize = "Size32"
c2.TextColor3 = Color3.fromRGB(255, 255, 255)
c2.TextScaled = false
c2.TextStrokeColor3 = Color3.fromRGB(139, 139, 139)
c2.TextTransparency = 0
c2.Text = "Dominator\n(X)"

d2 = Instance.new("TextLabel")
d2.Parent = a
d2.BackgroundTransparency = 1
d2.BorderColor3 = Color3.fromRGB(139, 139, 139)
d2.BorderSizePixel = 3
d2.Position = d.Position
d2.Size = UDim2.new(0, 200, 0, 100)
d2.Visible = true
d2.ZIndex = 3
d2.Font = "SourceSansItalic"
d2.FontSize = "Size32"
d2.TextColor3 = Color3.fromRGB(255, 255, 255)
d2.TextScaled = false
d2.TextStrokeColor3 = Color3.fromRGB(139, 139, 139)
d2.TextTransparency = 0
d2.Text = "Eliminator\n(V)"

e2 = Instance.new("TextLabel")
e2.Parent = a
e2.BackgroundTransparency = 1
e2.BorderColor3 = Color3.fromRGB(139, 139, 139)
e2.BorderSizePixel = 3
e2.Position = e.Position
e2.Size = UDim2.new(0, 200, 0, 100)
e2.Visible = true
e2.ZIndex = 3
e2.Font = "SourceSansItalic"
e2.FontSize = "Size32"
e2.TextColor3 = Color3.fromRGB(255, 255, 255)
e2.TextScaled = false
e2.TextStrokeColor3 = Color3.fromRGB(139, 139, 139)
e2.TextTransparency = 0
e2.Text = "Obliteration\n(C)"

function part(formfactor, parent, reflectance, transparency, brickcolor, name, size, material)
	local fp = it("Part")
	fp.formFactor = formfactor
	fp.Parent = parent
	fp.Reflectance = reflectance
	fp.Transparency = transparency
	fp.CanCollide = false
	fp.Locked = true
	fp.BrickColor = brickcolor
	fp.Name = name
	fp.Size = size
	fp.Position = Torso.Position
	NoOutline(fp)
	fp.Material = material
	fp:BreakJoints()
	return fp
end

function mesh(Mesh, part, meshtype, meshid, offset, scale)
	local meshObj = it(Mesh)
	meshObj.Parent = part
	if Mesh == "SpecialMesh" then
		meshObj.MeshType = meshtype
		meshObj.MeshId = meshid
	end
	meshObj.Offset = offset
	meshObj.Scale = scale
	return meshObj
end

function weld(parent, part0, part1, c0)
	local weldObj = it("Weld")
	weldObj.Parent = parent
	weldObj.Part0 = part0
	weldObj.Part1 = part1
	weldObj.C0 = c0
	return weldObj
end

local function CFrameFromTopBack(at, top, back)
	local right = top:Cross(back)
	return CFrame.new(
		at.x, at.y, at.z,
		right.x, top.x, back.x,
		right.y, top.y, back.y,
		right.z, top.z, back.z
	)
end

function Triangle(aPt, bPt, cPt)
	local edg1 = (cPt - aPt):Dot((bPt - aPt).unit)
	local edg2 = (aPt - bPt):Dot((cPt - bPt).unit)
	local edg3 = (bPt - cPt):Dot((aPt - cPt).unit)
	if edg1 <= (bPt - aPt).magnitude and edg1 >= 0 then
		aPt, bPt, cPt = aPt, bPt, cPt
	elseif edg2 <= (cPt - bPt).magnitude and edg2 >= 0 then
		aPt, bPt, cPt = bPt, cPt, aPt
	elseif edg3 <= (aPt - cPt).magnitude and edg3 >= 0 then
		aPt, bPt, cPt = cPt, aPt, bPt
	else
		assert(false, "unreachable")
	end

	local len1 = (cPt - aPt):Dot((bPt - aPt).unit)
	local len2 = (bPt - aPt).magnitude - len1
	local width = (aPt + (bPt - aPt).unit * len1 - cPt).magnitude
	local maincf = CFrameFromTopBack(aPt, (bPt - aPt):Cross(cPt - bPt).unit, -(bPt - aPt).unit)
	local list = {}

	if len1 > 0.01 then
		local w1 = Instance.new("WedgePart")
		Debris:AddItem(w1, 5)
		w1.BrickColor = BrickColor.new("Really black")
		w1.Transparency = 0.7
		w1.Reflectance = 0
		w1.Material = Enum.Material.SmoothPlastic
		w1.CanCollide = false
		NoOutline(w1)
		local sz = Vector3.new(0.2, width, len1)
		w1.Size = sz
		local sp = Instance.new("SpecialMesh", w1)
		sp.MeshType = Enum.MeshType.Wedge
		sp.Scale = Vector3.new(0, 1, 1) * sz / w1.Size
		w1:BreakJoints()
		w1.Anchored = true
		w1.Parent = Workspace
		w1.CFrame = maincf * CFrame.Angles(math.pi, 0, math.pi / 2) * CFrame.new(0, width / 2, len1 / 2)
		table.insert(list, w1)
	end

	if len2 > 0.01 then
		local w2 = Instance.new("WedgePart")
		Debris:AddItem(w2, 5)
		w2.BrickColor = BrickColor.new("Really red")
		w2.Transparency = 0.7
		w2.Reflectance = 0
		w2.Material = Enum.Material.SmoothPlastic
		w2.CanCollide = false
		NoOutline(w2)
		local sz = Vector3.new(0.2, width, len2)
		w2.Size = sz
		local sp = Instance.new("SpecialMesh", w2)
		sp.MeshType = Enum.MeshType.Wedge
		sp.Scale = Vector3.new(0, 1, 1) * sz / w2.Size
		w2:BreakJoints()
		w2.Anchored = true
		w2.Parent = Workspace
		w2.CFrame = maincf * CFrame.Angles(math.pi, math.pi, -math.pi / 2) * CFrame.new(0, width / 2, -len1 - len2 / 2)
		table.insert(list, w2)
	end

	return table.unpack(list)
end

so = function(id, par, vol, pit)
	coroutine.resume(coroutine.create(function()
		local sou = Instance.new("Sound")
		sou.Parent = par or Workspace
		sou.Volume = vol
		sou.Pitch = pit or 1
		sou.SoundId = tostring(id)
		swait()
		sou:Play()
		Debris:AddItem(sou, 6)
	end))
end

function clerp(aPt, bPt, t)
	local qa = {QuaternionFromCFrame(aPt)}
	local qb = {QuaternionFromCFrame(bPt)}
	local ax, ay, az = aPt.x, aPt.y, aPt.z
	local bx, by, bz = bPt.x, bPt.y, bPt.z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end

function QuaternionFromCFrame(cfVal)
	local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cfVal:components()
	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
	else
		local i = 0
		if m11 > m00 then
			i = 1
		end
		if m22 > (i == 0 and m00 or m11) then
			i = 2
		end
		if i == 0 then
			local s = math.sqrt(m00 - m11 - m22 + 1)
			local recip = 0.5 / s
			return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
		elseif i == 1 then
			local s = math.sqrt(m11 - m22 - m00 + 1)
			local recip = 0.5 / s
			return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
		elseif i == 2 then
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
	return CFrame.new(
		px, py, pz,
		1 - (yy + zz), xy - wz, xz + wy,
		xy + wz, 1 - (xx + zz), yz - wx,
		xz - wy, yz + wx, 1 - (xx + yy)
	)
end

function QuaternionSlerp(aPt, bPt, t)
	local cosTheta = aPt[1] * bPt[1] + aPt[2] * bPt[2] + aPt[3] * bPt[3] + aPt[4] * bPt[4]
	local startInterp, finishInterp
	if cosTheta >= 0.0001 then
		if (1 - cosTheta) > 0.0001 then
			local theta = math.acos(cosTheta)
			local invSinTheta = 1 / math.sin(theta)
			startInterp = math.sin((1 - t) * theta) * invSinTheta
			finishInterp = math.sin(t * theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	else
		if (1 + cosTheta) > 0.0001 then
			local theta = math.acos(-cosTheta)
			local invSinTheta = 1 / math.sin(theta)
			startInterp = math.sin((t - 1) * theta) * invSinTheta
			finishInterp = math.sin(t * theta) * invSinTheta
		else
			startInterp = t - 1
			finishInterp = t
		end
	end
	return aPt[1] * startInterp + bPt[1] * finishInterp,
		aPt[2] * startInterp + bPt[2] * finishInterp,
		aPt[3] * startInterp + bPt[3] * finishInterp,
		aPt[4] * startInterp + bPt[4] * finishInterp
end

function rayCast(Pos, Dir, Max, Ignore)
	return Workspace:FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or 999.999)), Ignore)
end

Damagefunc = function(Part, hit, minim, maxim, knockback, Type, Property, Delay, KnockbackType, decreaseblock)
	if hit == nil or hit.Parent == nil then
		return
	end
	local h = hit.Parent:FindFirstChildOfClass("Humanoid")
	if hit.Parent.Parent and hit.Parent.Parent:FindFirstChild("Torso") then
		h = hit.Parent.Parent:FindFirstChildOfClass("Humanoid")
	end
	if hit.Parent.Name == "Accessory" or hit.Parent:IsA("Accessory") then
		hit = hit.Parent.Parent and hit.Parent.Parent:FindFirstChild("Head") or hit
	end
	if h ~= nil and hit.Parent.Name ~= Character.Name and hit.Parent:FindFirstChild("Torso") ~= nil then
		if hit.Parent:FindFirstChild("DebounceHit") ~= nil and hit.Parent.DebounceHit.Value == true then
			return
		end
		local cObj = Instance.new("ObjectValue")
		cObj.Name = "creator"
		cObj.Value = Player
		cObj.Parent = h
		Debris:AddItem(cObj, 0.5)

		local Damage = math.random(minim or 5, maxim or 15)
		local blocked = false
		local block = hit.Parent:FindFirstChild("Block")
		if block ~= nil then
			if block:IsA("NumberValue") or block:IsA("IntValue") then
				if block.Value > 0 then
					blocked = true
					if decreaseblock == nil then
						block.Value = block.Value - 1
					end
				end
			end
		end

		if blocked == false then
			h:TakeDamage(Damage)
			ShowDamage((Part.CFrame * CFrame.new(0, 0, Part.Size.Z / 2).p + Vector3.new(0, 1.5, 0)), Damage, 1.5, Part.BrickColor.Color)
		else
			h:TakeDamage(Damage / 2)
			ShowDamage((Part.CFrame * CFrame.new(0, 0, Part.Size.Z / 2).p + Vector3.new(0, 1.5, 0)), Damage / 2, 1.5, BrickColor.new("Bright blue").Color)
		end

		if Type == "Knockdown" then
			local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.PlatformStand = true
				coroutine.resume(coroutine.create(function(HHumanoid)
					swait(1)
					if HHumanoid and HHumanoid.Parent then
						HHumanoid.PlatformStand = false
					end
				end), hum)
			end
			local angle = (hit.Position - (Property.Position + Vector3.new(0, 0, 0))).unit
			local bodvol = Instance.new("BodyVelocity")
			bodvol.velocity = angle * knockback
			bodvol.P = 5000
			bodvol.maxForce = Vector3.new(8e3, 8e3, 8e3)
			bodvol.Parent = hit
			local rl = Instance.new("BodyAngularVelocity")
			rl.P = 3000
			rl.maxTorque = Vector3.new(5e5, 5e5, 5e5)
			rl.angularvelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
			rl.Parent = hit
			Debris:AddItem(bodvol, 0.5)
			Debris:AddItem(rl, 0.5)
		elseif Type == "Normal" then
			local vp = Instance.new("BodyVelocity")
			vp.P = 500
			vp.maxForce = Vector3.new(math.huge, 0, math.huge)
			if KnockbackType == 1 then
				vp.velocity = Property.CFrame.lookVector * knockback + Property.Velocity / 1.05
			elseif KnockbackType == 2 then
				vp.velocity = Property.CFrame.lookVector * knockback
			else
				vp.velocity = Property.CFrame.lookVector * knockback
			end
			if knockback > 0 then
				vp.Parent = hit.Parent.Torso
			end
			Debris:AddItem(vp, 0.5)
		elseif Type == "Up" then
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.velocity = vt(0, 60, 0)
			bodyVelocity.P = 5000
			bodyVelocity.maxForce = Vector3.new(8e3, 8e3, 8e3)
			bodyVelocity.Parent = hit
			Debris:AddItem(bodyVelocity, 1)
			local rl = Instance.new("BodyAngularVelocity")
			rl.P = 3000
			rl.maxTorque = Vector3.new(5e5, 5e5, 5e5)
			rl.angularvelocity = Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
			rl.Parent = hit
			Debris:AddItem(rl, 0.5)
		elseif Type == "Snare" then
			local bp = Instance.new("BodyPosition")
			bp.P = 2000
			bp.D = 100
			bp.maxForce = Vector3.new(math.huge, math.huge, math.huge)
			bp.position = hit.Parent.Torso.Position
			bp.Parent = hit.Parent.Torso
			Debris:AddItem(bp, 1)
		end

		local debounce = Instance.new("BoolValue")
		debounce.Name = "DebounceHit"
		debounce.Parent = hit.Parent
		debounce.Value = true
		Debris:AddItem(debounce, Delay or 0.2)
	end
end

function ShowDamage(Pos, Text, Time, Color)
	local Rate = 1 / 30
	Pos = Pos or Vector3.new(0, 0, 0)
	Text = tostring(Text or "")
	Time = Time or 2
	Color = Color or Color3.new(1, 0, 0)
	local EffectPart = part(1, Workspace, 0, 0, BrickColor.new("Really black"), "Effect", vt(0.1, 0.1, 0.1), Enum.Material.Granite)
	EffectPart.Anchored = true
	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Size = UDim2.new(3, 0, 3, 0)
	BillboardGui.Adornee = EffectPart
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Text = Text
	TextLabel.TextColor3 = Color
	TextLabel.TextScaled = true
	TextLabel.Font = Enum.Font.ArialBold
	TextLabel.Parent = BillboardGui
	BillboardGui.Parent = EffectPart
	Debris:AddItem(EffectPart, Time + 0.1)

	task.delay(0, function()
		local Frames = Time / Rate
		for Frame = 1, Frames do
			task.wait(Rate)
			local Percent = Frame / Frames
			if EffectPart and EffectPart.Parent then
				EffectPart.CFrame = CFrame.new(Pos) + Vector3.new(0, Percent * 2, 0)
			end
			TextLabel.TextTransparency = Percent
		end
		if EffectPart and EffectPart.Parent then
			EffectPart:Destroy()
		end
	end)
end

function MagniDamage(Hit, Part, magni, mindam, maxdam, knock, Type)
	for _, cObj in pairs(Workspace:GetChildren()) do
		local hum = cObj:FindFirstChildOfClass("Humanoid")
		if hum ~= nil then
			local head = cObj:FindFirstChild("Torso")
			if head ~= nil then
				local targ = head.Position - Part.Position
				local mag = targ.magnitude
				if mag <= magni and cObj.Name ~= Player.Name then
					Damagefunc(Hit, head, mindam, maxdam, knock, Type, RootPart, 0.2, 1, 3)
				end
			end
		end
	end
end

mod3 = Instance.new("Model")
mod3.Name = "StompEffects"
mod3.Parent = RightLeg

function Stomp()
	local function fpart(formfactor, parent, reflectance, transparency, brickcolor, name, size, material)
		local fp = it("Part")
		fp.formFactor = formfactor
		fp.Parent = parent
		fp.Reflectance = reflectance
		fp.Transparency = transparency
		fp.CanCollide = false
		fp.Locked = true
		fp.BrickColor = brickcolor
		fp.Name = name
		fp.Size = size
		fp.Position = Torso.Position
		NoOutline(fp)
		fp.Material = material
		fp:BreakJoints()
		return fp
	end
	local function fmesh(Mesh, part, meshtype, meshid, offset, scale)
		local meshObj = it(Mesh)
		meshObj.Parent = part
		if Mesh == "SpecialMesh" then
			meshObj.MeshType = meshtype
			meshObj.MeshId = meshid
		end
		meshObj.Offset = offset
		meshObj.Scale = scale
		return meshObj
	end

	local p1 = fpart("Custom", mod3, 0, 0.7, BrickColor.new("Crimson"), "Wave", vt(0.2, 0.2, 0.2), Enum.Material.Neon)
	p1.Anchored = true
	p1.CFrame = RightLeg.CFrame * CFrame.new(0, -3, 0)
	local m1 = fmesh("SpecialMesh", p1, "FileMesh", "rbxassetid://3270017", vt(0, 0, 0), vt(25, 25, 25))

	local p2 = fpart("Custom", mod3, 0, 0.7, BrickColor.new("Crimson"), "Wave", vt(0.2, 0.2, 0.2), Enum.Material.Neon)
	p2.Anchored = true
	p2.CFrame = RightLeg.CFrame * CFrame.new(0, -3, 0)
	local m2 = fmesh("SpecialMesh", p2, "FileMesh", "rbxassetid://3270017", vt(0, 0, 0), vt(15, 15, 15))

	local p3 = fpart("Custom", mod3, 0, 0.7, BrickColor.new("Crimson"), "Wave", vt(0.2, 0.2, 0.2), Enum.Material.Neon)
	p3.CFrame = RightLeg.CFrame * CFrame.new(0, -3, 0)
	p3.Anchored = true
	local m3 = fmesh("SpecialMesh", p3, "FileMesh", "rbxassetid://20329976", vt(0, 0, 0), vt(12, 12, 12))

	MagniDamage(p1, p1, 30, 10, 15, math.random(10, 20), "Knockdown")
	coroutine.resume(coroutine.create(function()
		for i = 0, 1, 0.05 do
			task.wait()
			p1.Transparency = i
			m1.Scale = m1.Scale + Vector3.new(2.8, 2.8, 2.8)
			p2.Transparency = i
			m2.Scale = m2.Scale + Vector3.new(1, 1, 1)
			p3.Transparency = i
			m3.Scale = m3.Scale + Vector3.new(1.5, 1.5, 1.5)
		end
		p1:Destroy()
		p2:Destroy()
		p3:Destroy()
	end))
end

model = Instance.new("Model")
model.Name = "Realm"
model.Parent = Character

local handle = part(1, model, 0, 0, BrickColor.new("Really black"), "Handle", vt(0.2, 1.5, 0.2), Enum.Material.Granite)
local prt1 = part(1, model, 0, 0, BrickColor.new("Really black"), "Part1", vt(1.22, 7.2, 0.22), Enum.Material.Granite)
local prt2 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part2", vt(0.22, 2.4, 0.22), Enum.Material.Neon)
local prt3 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part3", vt(0.42, 0.85, 1.05), Enum.Material.Neon)
local prt4 = part(1, model, 0, 0, BrickColor.new("Really black"), "Part4", vt(0.22, 1.5, 0.22), Enum.Material.Granite)
local prt5 = part(1, model, 0, 0, BrickColor.new("Really black"), "Part5", vt(0.44, 0.6, 0.8), Enum.Material.Granite)
local prt6 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part6", vt(1.6, 1.4, 0.2), Enum.Material.Neon)
local prt7 = part(0, model, 0, 0, BrickColor.new("Really black"), "Part7", vt(0.4, 0.4, 0.4), Enum.Material.Granite)
local prt8 = part(1, model, 0, 0, BrickColor.new("Really black"), "Part8", vt(0.4, 0.3, 0.22), Enum.Material.Granite)
local prt9 = part(1, model, 0, 0, BrickColor.new("Really black"), "Part9", vt(0.4, 1.3, 1.5), Enum.Material.Granite)
local prt10 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part10", vt(0.3, 1.5, 1.7), Enum.Material.Neon)
local prt11 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part11", vt(0.4, 1.4, 0.22), Enum.Material.Neon)
local prt13 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part13", vt(1.3, 7.3, 0.2), Enum.Material.Neon)
local prt15 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part15", vt(1, 0.5, 0.22), Enum.Material.Neon)
local prt16 = part(1, model, 0, 0, BrickColor.new("Maroon"), "Part16", vt(1, 0.5, 0.22), Enum.Material.Neon)

mesh("SpecialMesh", handle, "FileMesh", "rbxassetid://1033714", vt(0, 0, 0), vt(0.2, 5, 0.2))
mesh("SpecialMesh", prt2, "FileMesh", "rbxassetid://1033714", vt(0, 0, 0), vt(0.2, 5, 0.2))
mesh("SpecialMesh", prt3, "Cylinder", "", vt(0, 0, 0), vt(1, 1, 2))
mesh("SpecialMesh", prt4, "FileMesh", "rbxassetid://1033714", vt(0, 0, 0), vt(0.2, 5, 0.2))
mesh("SpecialMesh", prt5, "Cylinder", "", vt(0, 0, 0), vt(1, 1, 1))
mesh("SpecialMesh", prt6, "Sphere", "", vt(0, 0, 0), vt(1, 1, 1))
mesh("SpecialMesh", prt8, "FileMesh", "rbxassetid://192551369", vt(0, 0, 0), vt(0.5, 0.5, 0.2))
mesh("SpecialMesh", prt9, "Cylinder", "", vt(0, 0, 0), vt(1, 1, 2))
mesh("SpecialMesh", prt10, "Cylinder", "", vt(0, 0, 0), vt(1, 1, 2))

weld(handle, handle, RightArm, euler(89.75, 0, 0) * cf(0, 1, 0))
weld(prt1, prt1, handle, euler(0, 80.1, 0) * cf(0, 4.95, -0.02))
weld(prt2, prt2, handle, euler(0, 80.1, 0) * cf(0.005, 0.15, -0.005))
weld(prt3, prt3, handle, euler(0, 12.5, 0) * cf(0, 1.303, -0.028))
weld(prt4, prt4, handle, euler(0, 80.1, 0) * cf(0.005, 0.4, -0.005))
weld(prt5, prt5, handle, euler(0, 12.5, 0) * cf(0, 1.303, -0.028))
weld(prt6, prt6, handle, euler(0, 80.1, 0) * cf(0, 8.8, -0.02))
weld(prt7, prt7, handle, euler(0, 80.1, 0) * cf(0.005, -1.8, -0.005))
weld(prt8, prt8, handle, euler(0, -80.1, 0) * cf(0, 1.6, -0.02))
weld(prt9, prt9, handle, euler(0, 12.5, 0) * cf(0, 1.303, -0.028))
weld(prt10, prt10, handle, euler(0, 12.5, 0) * cf(0, 1.303, -0.028))
weld(prt11, prt11, handle, euler(0, 80.1, 0) * cf(-0.113, 8.501, -0.01))
weld(prt13, prt13, handle, euler(0, 80.1, 0) * cf(0, 4.95, -0.02))
weld(prt15, prt15, handle, euler(0, 80.1, 0) * cf(-0.011, 3.903, 0))
weld(prt16, prt16, handle, euler(0, 80.1, 0) * cf(-0.011, 5.903, 0))

local bounce = false
local scfr = nil

function attackone()
	attack = true
	local hitsounds = {"199149137", "199149186", "199149221", "199149235", "199149269", "199149297"}
	local con = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 5, 13, 5, "Normal", RootPart, 0.2, 1, 3)
	end)
	local fx = prt1.Touched:Connect(function(hitPart)
		local human = hitPart.Parent and hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if human ~= nil and bounce == false then
			bounce = true
			local rndm = math.random(1, #hitsounds)
			so("rbxassetid://" .. hitsounds[rndm], hitPart.Parent, 1, 1)
		end
	end)
	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(-50)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(0), math.rad(0), math.rad(50)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(0), math.rad(10), math.rad(100)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-60)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(120), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(0), math.rad(0)), 0.4)
	end
	so("rbxassetid://199145841", handle, 1, 0.9)
	for _ = 0, 1, 0.1 do
		swait()
		local blcf = prt1.CFrame * CFrame.new(0, 0.5, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 10
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(80)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(10), math.rad(-10), math.rad(-80)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(0), math.rad(120), math.rad(90)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-30)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(50), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0)), 0.4)
	end
	attack = false
	bounce = false
	scfr = nil
	fx:Disconnect()
	con:Disconnect()
end

function attacktwo()
	attack = true
	local hitsounds = {"199149137", "199149186", "199149221", "199149235", "199149269", "199149297"}
	local con = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 5, 15, 5, "Normal", RootPart, 0.2, 1, 3)
	end)
	local fx = prt1.Touched:Connect(function(hitPart)
		local human = hitPart.Parent and hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if human ~= nil and bounce == false then
			bounce = true
			local rndm = math.random(1, #hitsounds)
			so("rbxassetid://" .. hitsounds[rndm], hitPart.Parent, 1, 1)
		end
	end)
	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(70)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(10), math.rad(-10), math.rad(-70)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(0), math.rad(120), math.rad(90)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-30)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(40), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-140), math.rad(-10)), 0.4)
	end
	so("rbxassetid://199145887", handle, 1, 1)
	for _ = 0, 1, 0.1 do
		swait()
		local blcf = prt1.CFrame * CFrame.new(0, 0.5, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 10
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(-80)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(10), math.rad(0), math.rad(80)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(0), math.rad(10), math.rad(90)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-90)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(140), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-40), math.rad(-10)), 0.4)
	end
	scfr = nil
	attack = false
	bounce = false
	con:Disconnect()
	fx:Disconnect()
end

function Wave()
	local function wpart(formfactor, parent, material, reflectance, transparency, brickcolor, name, size)
		local fp = it("Part")
		fp.formFactor = formfactor
		fp.Parent = parent
		fp.Reflectance = reflectance
		fp.Transparency = transparency
		fp.CanCollide = false
		fp.Locked = true
		fp.BrickColor = BrickColor.new(tostring(brickcolor))
		fp.Name = name
		fp.Size = size
		fp.Position = Character.Torso.Position
		NoOutline(fp)
		fp.Material = material
		fp:BreakJoints()
		return fp
	end

	attack = true
	local hitsounds = {"199149137", "199149186", "199149221", "199149235", "199149269", "199149297"}
	local con = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 4, 31, 5, "Normal", RootPart, 0.2, 1, 3)
	end)
	local fx = prt1.Touched:Connect(function(hitPart)
		local human = hitPart.Parent and hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if human ~= nil and bounce == false then
			bounce = true
			local rndm = math.random(1, #hitsounds)
			so("rbxassetid://" .. hitsounds[rndm], hitPart.Parent, 1, 1)
		end
	end)

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(-30)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(0), math.rad(0), math.rad(30)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(170), math.rad(0), math.rad(20)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(25), math.rad(0), math.rad(-30)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(105), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-75), math.rad(-10)), 0.4)
	end

	so("rbxassetid://199145913", handle, 1, 0.9)
	local hit, pos = rayCast(prt1.Position, (CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0))).lookVector, 100, Character)
	if hit ~= nil then
		local ref = wpart(3, Workspace, Enum.Material.SmoothPlastic, 0, 1, BrickColor.new("Black"), "Effect", vt(0.1, 0.1, 0.1))
		ref.Anchored = true
		ref.CFrame = cf(pos)
		Debris:AddItem(ref, 3)

		local function BlastEffect(brickcolor, cframe, x1, y1, z1, x2, y2, z2)
			local p = wpart(3, Workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", vt(0.5, 0.5, 0.5))
			p.Anchored = true
			p.CFrame = cframe
			local m = mesh("SpecialMesh", p, "FileMesh", "rbxassetid://20329976", vt(0, 0, 0), vt(x1, y1, z1))
			coroutine.resume(coroutine.create(function()
				for i = 0, 1, 0.05 do
					task.wait()
					p.Transparency = i
					m.Scale = m.Scale + vt(x2, y2, z2)
				end
				p:Destroy()
			end))
		end

		local function MagicCircle(brickcolor, cframe, x1, y1, z1, x3, y3, z3, stepDelay)
			local p = wpart(3, Workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", vt(0.1, 0.1, 0.1))
			p.Anchored = true
			p.CFrame = cframe
			local m = mesh("SpecialMesh", p, "Sphere", "", vt(0, 0, 0), vt(x1, y1, z1))
			Debris:AddItem(p, 2)
			coroutine.resume(coroutine.create(function(PartObj, MeshObj)
				for i = 0, 1, stepDelay do
					task.wait()
					PartObj.Transparency = i
					MeshObj.Scale = MeshObj.Scale + vt(x3, y3, z3)
				end
				PartObj:Destroy()
			end), p, m)
		end

		for _ = 5, 1, -1 do
			BlastEffect(BrickColor.new("Maroon"), cf(pos), 1, 1, 1, 1, 1, 1)
			MagicCircle(BrickColor.new("Maroon"), cf(pos), 3, 3, 3, 5, 5, 5, 0.05)
			swait()
		end
		MagniDamage(ref, ref, 13, 15, 25, math.random(10, 20), "Knockdown")
	end

	for _ = 0, 1, 0.1 do
		swait()
		local blcf = prt1.CFrame * CFrame.new(0, 0.5, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 5
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(50)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(10), math.rad(0), math.rad(-50)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(20), math.rad(0), math.rad(-10)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-10)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(80), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-100), math.rad(-10)), 0.4)
	end
	attack = false
	bounce = false
	scfr = nil
	con:Disconnect()
	fx:Disconnect()
end

function Charge()
	attack = true
	local hitsounds = {"199149137", "199149186", "199149221", "199149235", "199149269", "199149297"}
	local con = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 10, 40, 50, "Normal", RootPart, 0.2, 1, 3)
	end)
	local fx = prt1.Touched:Connect(function(hitPart)
		local human = hitPart.Parent and hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if human ~= nil and bounce == false then
			bounce = true
			local rndm = math.random(1, #hitsounds)
			so("rbxassetid://" .. hitsounds[rndm], hitPart.Parent, 1, 1)
		end
	end)

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(10), math.rad(-5), math.rad(-60)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(-10), math.rad(0), math.rad(60)), 0.3)
		RW.C0 = clerp(RW.C0, cf(1.5, 0.8, 0.2) * angles(math.rad(5), math.rad(-15), math.rad(112)), 0.3)
		LW.C0 = clerp(LW.C0, cf(-1.5, 0.5, 0) * angles(math.rad(30), math.rad(0), math.rad(-20)), 0.3)
		RH.C0 = clerp(RH.C0, cf(1.1, -1, 0) * angles(math.rad(-5), math.rad(120), math.rad(-8)), 0.3)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(5), math.rad(-60), math.rad(0)), 0.3)
	end

	so("rbxassetid://199145433", prt1, 1, 1.1)
	local v = it("BodyVelocity")
	v.Parent = Torso
	v.maxForce = Vector3.new(4e5, 4e5, 4e5)
	v.velocity = RootPart.CFrame.lookVector * 100

	local function ppart(formfactor, parent, material, reflectance, transparency, brickcolor, name, size)
		local fp = it("Part")
		fp.formFactor = formfactor
		fp.Parent = parent
		fp.Reflectance = reflectance
		fp.Transparency = transparency
		fp.CanCollide = false
		fp.Locked = true
		fp.BrickColor = BrickColor.new(tostring(brickcolor))
		fp.Name = name
		fp.Size = size
		fp.Position = Character.Torso.Position
		NoOutline(fp)
		fp.Material = material
		fp:BreakJoints()
		return fp
	end

	for _ = 5, 1, -1 do
		for _ = 1, 4 do
			local p = ppart(3, Workspace, Enum.Material.SmoothPlastic, 0, 0, "Maroon", "Effect", vt(0.5, 0.5, 0.5))
			p.Anchored = true
			p.Position = prt1.Position
			local m = mesh("SpecialMesh", p, "FileMesh", "rbxassetid://3270017", vt(0, 0, 0), vt(1, 1, 1))
			coroutine.resume(coroutine.create(function(PartObj, MeshObj)
				for i = 0, 1, 0.03 do
					task.wait()
					PartObj.Transparency = i
					MeshObj.Scale = MeshObj.Scale + vt(1, 1, 1)
				end
				PartObj:Destroy()
			end), p, m)
			MagniDamage(p, p, 15, 5, 15, -10, "Normal")
		end
		swait(3)
	end

	for _ = 0, 1, 0.1 do
		swait()
		local blcf = prt1.CFrame * cf(0, 0, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 5
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(5), math.rad(60)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(0), math.rad(0), math.rad(-60)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-10), math.rad(60), math.rad(100)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-30), math.rad(0), math.rad(-15)), 0.3)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(90), math.rad(0)), 0.3)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0)), 0.3)
	end

	v:Destroy()
	scfr = nil
	attack = false
	bounce = false
	con:Disconnect()
	fx:Disconnect()
end

function Execution()
	attack = true
	local con1 = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 12, 25, 100, "Normal", RootPart, 0.2, 1)
	end)
	for _ = 0, 1, 0.03 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(60)), 0.1)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(5), math.rad(0), math.rad(-60)), 0.1)
		RW.C0 = clerp(RW.C0, cf(1.5, 0.5, 0) * euler(math.rad(0), math.rad(90), math.rad(120)), 0.1)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(100), math.rad(0), math.rad(0)), 0.1)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(90), math.rad(-10)), 0.1)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0)), 0.2)
	end

	so("rbxassetid://92597369", prt1, 1, 0.5)
	so("rbxassetid://28144425", Torso, 1, 0.5)
	local hitconasdf
	hitconasdf = prt1.Touched:Connect(function(hit)
		local hum12 = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
		if hum12 and not hum12:IsDescendantOf(Character) then
			so("rbxassetid://154965973", prt1, 1, 0.8)
			if hitconasdf then
				hitconasdf:Disconnect()
			end
		end
	end)

	for _ = 0, 1, 0.03 do
		swait()
		local blcf = prt1.CFrame * CFrame.new(0, 0.5, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 5
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(-90)), 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(5), math.rad(0), math.rad(60)), 0.2)
		RW.C0 = clerp(RW.C0, cf(1.5, 0.5, 0) * euler(math.rad(0), math.rad(-20), math.rad(70)), 0.2)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-40)), 0.2)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(90), math.rad(-10)), 0.2)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0)), 0.2)
	end

	attack = false
	con1:Disconnect()
	scfr = nil
	if hitconasdf then
		hitconasdf:Disconnect()
	end
end

function Destroyer()
	attack = true
	local hitsounds = {"199149137", "199149186", "199149221", "199149235", "199149269", "199149297"}
	local con = prt1.Touched:Connect(function(hit)
		Damagefunc(prt1, hit, 4, 31, 5, "Normal", RootPart, 0.2, 1, 3)
	end)
	local fx = prt1.Touched:Connect(function(hitPart)
		local human = hitPart.Parent and hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if human ~= nil and bounce == false then
			bounce = true
			local rndm = math.random(1, #hitsounds)
			so("rbxassetid://" .. hitsounds[rndm], hitPart.Parent, 1, 1)
		end
	end)

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(-30)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(0), math.rad(0), math.rad(30)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(170), math.rad(0), math.rad(20)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(25), math.rad(0), math.rad(-30)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(105), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-75), math.rad(-10)), 0.4)
	end

	Stomp()
	for _ = 0, 1, 0.1 do
		swait()
		local blcf = prt1.CFrame * CFrame.new(0, 0.5, 0)
		if scfr and (prt1.Position - scfr.p).magnitude > 0.1 then
			local h = 5
			local aPt, bPt = Triangle((scfr * CFrame.new(0, h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p, (blcf * CFrame.new(0, h / 2, 0)).p)
			if aPt then Debris:AddItem(aPt, 1) end
			if bPt then Debris:AddItem(bPt, 1) end
			local aPt2, bPt2 = Triangle((blcf * CFrame.new(0, h / 2, 0)).p, (blcf * CFrame.new(0, -h / 2, 0)).p, (scfr * CFrame.new(0, -h / 2, 0)).p)
			if aPt2 then Debris:AddItem(aPt2, 1) end
			if bPt2 then Debris:AddItem(bPt2, 1) end
			scfr = blcf
		elseif not scfr then
			scfr = blcf
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(50)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(10), math.rad(0), math.rad(-50)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(20), math.rad(0), math.rad(-10)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-10)), 0.4)
		RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(80), math.rad(0)), 0.4)
		LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-100), math.rad(-10)), 0.4)
	end

	attack = false
	bounce = false
	scfr = nil
	con:Disconnect()
	fx:Disconnect()
end

Mouse.Button1Down:Connect(function()
	if attack == false then
		if attacktype == 1 then
			attack = true
			attacktype = 2
			attackone()
		elseif attacktype == 2 then
			attack = true
			attacktype = 1
			attacktwo()
		end
	end
end)

skillattack1 = false
skillattack2 = false
skillattack3 = false
skillattack4 = false

Mouse.KeyDown:Connect(function(k)
	k = k:lower()
	if skillattack1 == false and attack == false and k == "z" then
		b.Size = UDim2.new(0, 0, 0, 100)
		Wave()
		for _ = 1, 50 do
			skillattack1 = true
			b.Size = b.Size + UDim2.new(0, 4, 0, 0)
			task.wait()
		end
		skillattack1 = false
	elseif skillattack2 == false and attack == false and k == "v" then
		d.Size = UDim2.new(0, 0, 0, 100)
		Execution()
		for _ = 1, 200 do
			skillattack2 = true
			d.Size = d.Size + UDim2.new(0, 1, 0, 0)
			task.wait()
		end
		skillattack2 = false
	elseif skillattack3 == false and attack == false and k == "c" then
		e.Size = UDim2.new(0, 0, 0, 100)
		Charge()
		for _ = 1, 50 do
			skillattack3 = true
			e.Size = e.Size + UDim2.new(0, 4, 0, 0)
			task.wait()
		end
		skillattack3 = false
	elseif skillattack4 == false and attack == false and k == "x" then
		c.Size = UDim2.new(0, 0, 0, 100)
		Destroyer()
		for _ = 1, 100 do
			skillattack4 = true
			c.Size = c.Size + UDim2.new(0, 2, 0, 0)
			task.wait()
		end
		skillattack4 = false
	end
end)

local sine = 0
local change = 1

while true do
	swait()
	sine = sine + change
	local torvel = (RootPart.Velocity * Vector3.new(1, 0, 1)).magnitude
	local hitfloor = rayCast(RootPart.Position, (CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0))).lookVector, 4, Character)

	if RootPart.Velocity.y > 1 and hitfloor == nil then
		Anim = "Jump"
		if attack == false then
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(0)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(-1.5), math.rad(0), math.rad(0)), 0.3)
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-15), math.rad(0), math.rad(15)), 0.3)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-15), math.rad(0), math.rad(-15)), 0.3)
			RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(20), math.rad(90), math.rad(-20)), 0.3)
			LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(-20), math.rad(-90), math.rad(20)), 0.3)
		end
	elseif RootPart.Velocity.y < -1 and hitfloor == nil then
		Anim = "Fall"
		if attack == false then
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(0)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(20), math.rad(0), math.rad(0)), 0.3)
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-15), math.rad(0), math.rad(25)), 0.3)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-15), math.rad(0), math.rad(-25)), 0.3)
			RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(10), math.rad(90), math.rad(20)), 0.3)
			LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(-10), math.rad(-90), math.rad(-20)), 0.3)
		end
	elseif torvel < 1 and hitfloor ~= nil then
		Anim = "Idle"
		if attack == false then
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(15), math.rad(0), math.rad(-10)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(0), math.rad(0), math.rad(0)), 0.3)
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(40), math.rad(10), math.rad(-10)), 0.3)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(5), math.rad(0), math.rad(-5)), 0.3)
			RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(80), math.rad(10)), 0.3)
			LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-70), math.rad(-20)), 0.3)
		end
	elseif torvel > 2 and hitfloor ~= nil then
		Anim = "Walk"
		if attack == false then
			change = 3
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(math.rad(20), math.rad(0), math.rad(0)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(math.rad(-10), math.rad(0), math.rad(0)), 0.3)
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-30), math.rad(0), math.rad(20)), 0.3)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(10), math.rad(0), math.rad(-10)), 0.3)
			RH.C0 = clerp(RH.C0, cf(1, -1, 0) * angles(math.rad(0), math.rad(90), math.rad(10)), 0.3)
			LH.C0 = clerp(LH.C0, cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(-10)), 0.3)
		end
	end
end
