--[[
Fixed by feyz
--]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Debris            = game:GetService("Debris")

local Player = Players.LocalPlayer
local Mouse  = Player:GetMouse()

--=====================================================================
-- Wait for a usable R6 character
--=====================================================================
local Character = Player.Character
if not (Character and Character:FindFirstChild("Torso")) then
	Character = Player.CharacterAdded:Wait()
end
repeat task.wait() until Character:FindFirstChildOfClass("Humanoid")
	and Character:FindFirstChild("HumanoidRootPart")
	and Character:FindFirstChild("Torso")

local Humanoid  = Character:FindFirstChildOfClass("Humanoid")
local Torso     = Character:FindFirstChild("Torso")
local Head      = Character:FindFirstChild("Head")
local Right_Arm = Character:FindFirstChild("Right Arm")
local Left_Arm  = Character:FindFirstChild("Left Arm")
local Right_Leg = Character:FindFirstChild("Right Leg")
local Left_Leg  = Character:FindFirstChild("Left Leg")
local rootPart  = Character:FindFirstChild("HumanoidRootPart")

if not (Torso and Head and Right_Arm and Left_Arm and Right_Leg and Left_Leg and rootPart) then
	warn("[anim] R6 character required.")
	return
end

local Face        = Head:FindFirstChild("face")
local currentFace = Face and Face.Texture or ""

-- Stop the default animation system from fighting our C0 animation
Humanoid:ClearAllChildren()
local animateScript = Character:FindFirstChild("Animate")
if animateScript then animateScript:Destroy() end

--=====================================================================
-- Grab the R6 Motor6Ds and set the rest pose (same numbers the old
-- welds used, but on the real joints so nothing fights)
--=====================================================================
local RA_Weld    = Torso:FindFirstChild("Right Shoulder")
local LA_Weld    = Torso:FindFirstChild("Left Shoulder")
local RL_Weld    = Torso:FindFirstChild("Right Hip")
local LL_Weld    = Torso:FindFirstChild("Left Hip")
local Head_Weld  = Torso:FindFirstChild("Neck")
local Torso_Weld = rootPart:FindFirstChild("RootJoint")

if not (RA_Weld and LA_Weld and RL_Weld and LL_Weld and Head_Weld and Torso_Weld) then
	warn("[anim] Missing R6 joints.")
	return
end

local c_new    = CFrame.new
local c_angles = CFrame.Angles
local i_new    = Instance.new

RA_Weld.C0    = c_new(1.5, 0.5, 0);   RA_Weld.C1    = c_new(0, 0.5, 0)
LA_Weld.C0    = c_new(-1.5, 0.5, 0);  LA_Weld.C1    = c_new(0, 0.5, 0)
RL_Weld.C0    = c_new(0.5, -1, 0);    RL_Weld.C1    = c_new(0, 1, 0)
LL_Weld.C0    = c_new(-0.5, -1, 0);   LL_Weld.C1    = c_new(0, 1, 0)
Torso_Weld.C0 = c_new(0, -1, 0);      Torso_Weld.C1 = c_new(0, -1, 0)
Head_Weld.C0  = c_new(0, 1.5, 0);     Head_Weld.C1  = c_new()

--=====================================================================
-- State
--=====================================================================
local Animations     = false
local followMouse    = false
local isSprinting    = false
local Angle          = 0
local angleSpeed     = 1
local currentAnim    = "Idling"
local Vaping         = false
local vapePower      = 2.5
local Release        = false
local movementLocked = false
local charging       = false
local gyro           = nil

--=====================================================================
-- Math helpers
--=====================================================================
local function math_pos(f) if f < 0 then return 0 end return f end
local function math_neg(f) if f > 0 then return 0 end return f end

--=====================================================================
-- Quaternion / CFrame interpolation
--=====================================================================
local function QuaternionFromCFrame(cf)
	local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
	else
		local i = 0
		if m11 > m00 then i = 1 end
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
	if cosTheta >= 0.0001 then
		if (1 - cosTheta) > 0.0001 then
			local theta = math.acos(cosTheta)
			local invSinTheta = 1 / math.sin(theta)
			startInterp  = math.sin((1 - t) * theta) * invSinTheta
			finishInterp = math.sin(t * theta) * invSinTheta
		else
			startInterp, finishInterp = 1 - t, t
		end
	else
		if (1 + cosTheta) > 0.0001 then
			local theta = math.acos(-cosTheta)
			local invSinTheta = 1 / math.sin(theta)
			startInterp  = math.sin((t - 1) * theta) * invSinTheta
			finishInterp = math.sin(t * theta) * invSinTheta
		else
			startInterp, finishInterp = t - 1, t
		end
	end
	return a[1]*startInterp + b[1]*finishInterp,
	       a[2]*startInterp + b[2]*finishInterp,
	       a[3]*startInterp + b[3]*finishInterp,
	       a[4]*startInterp + b[4]*finishInterp
end

local function clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.X, a.Y, a.Z
	local bx, by, bz = b.X, b.Y, b.Z
	local _t = 1 - t
	return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz,
		QuaternionSlerp(qa, qb, t))
end

--=====================================================================
-- Speed handling
--=====================================================================
local BASE_SPEED   = 16
local SPRINT_SPEED = 24

local function updateSpeed()
	if movementLocked then
		Humanoid.WalkSpeed = 0
		Humanoid.JumpPower = 0
	elseif isSprinting then
		Humanoid.WalkSpeed = SPRINT_SPEED
		Humanoid.JumpPower = 50
	else
		Humanoid.WalkSpeed = BASE_SPEED
		Humanoid.JumpPower = 50
	end
end

--=====================================================================
-- Vape
--=====================================================================
local function Vape()
	if vapePower <= 5 then
		Animations     = false
		Vaping         = false
		vapePower      = 2.5
		movementLocked = false
		updateSpeed()
		return
	end

	Vaping         = true
	movementLocked = true
	updateSpeed()

	local smoke = i_new("ParticleEmitter")
	smoke.Color = ColorSequence.new(Color3.new(1, 1, 1))
	smoke.Texture = "rbxassetid://382199579"
	smoke.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(0.161235, 0.25, 0),
		NumberSequenceKeypoint.new(0.197256, 1.25, 0),
		NumberSequenceKeypoint.new(0.221269, 1.5, 0),
		NumberSequenceKeypoint.new(0.25729, 1.5, 0),
		NumberSequenceKeypoint.new(0.284734, 2, 0),
		NumberSequenceKeypoint.new(0.512865, 2.5, 0),
		NumberSequenceKeypoint.new(0.548885, 3.5, 0),
		NumberSequenceKeypoint.new(0.595197, 4.5, 0),
		NumberSequenceKeypoint.new(0.632933, 6.5, 0),
		NumberSequenceKeypoint.new(0.6741, 9, 0),
		NumberSequenceKeypoint.new(1, 10, 0),
	})
	smoke.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1, 0),
		NumberSequenceKeypoint.new(0.0001, 0.999, 0),
		NumberSequenceKeypoint.new(0.154374, 0.89, 0),
		NumberSequenceKeypoint.new(0.310463, 0.79, 0),
		NumberSequenceKeypoint.new(0.504288, 0.69, 0),
		NumberSequenceKeypoint.new(0.638079, 0.79, 0),
		NumberSequenceKeypoint.new(0.765009, 0.999, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	smoke.Speed             = NumberRange.new(1.5)
	smoke.EmissionDirection = Enum.NormalId.Front   -- was the invalid "5"
	smoke.Acceleration      = Vector3.new(0, 0.075, 0)
	smoke.Lifetime          = NumberRange.new(vapePower / 0.5)
	smoke.Rate              = 15
	smoke.ZOffset           = 3
	smoke.RotSpeed          = NumberRange.new(100)
	smoke.Rotation          = NumberRange.new(100)
	smoke.Parent            = Head

	Animations = true
	for _ = 0, 3, 0.01 do
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5, 0.1) * c_angles(math.rad(20), 0, math.rad(20)), 0.01)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5, 0.1) * c_angles(math.rad(20), 0, math.rad(-20)), 0.01)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -1, 0) * c_angles(0, 0, math.rad(-5.5)), 0.005)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -1, 0) * c_angles(0, 0, math.rad(5.5)), 0.005)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1, 0) * c_angles(0, 0, 0), 0.01)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, 0) * c_angles(math.rad(-5), 0, 0), 0.005)
		if Face then
			Face.Texture = "rbxassetid://7317691"
		end
		task.wait()
	end

	task.wait(7.5)

	if Face then Face.Texture = currentFace end
	smoke.Enabled = false
	Debris:AddItem(smoke, 2)

	Animations     = false
	movementLocked = false
	updateSpeed()
	task.wait(1)
	Vaping    = false
	vapePower = 2.5
end

--=====================================================================
-- Mouse / keyboard input
--=====================================================================
Mouse.Button1Down:Connect(function()
	if charging or Vaping then return end

	charging       = true
	Vaping         = true
	Release        = false
	Animations     = true
	movementLocked = true
	vapePower      = 2.5
	updateSpeed()

	while not Release do
		vapePower = math.min(vapePower + 0.1, 10)

		RA_Weld.C0 = clerp(RA_Weld.C0,
			c_new(1.8, 1.4, -1) * c_angles(math.rad(60), math.rad(-25), math.rad(-80)) * c_angles(0, math.rad(150), 0), 0.1)
		LA_Weld.C0 = clerp(LA_Weld.C0,
			c_new(-1.5, 0.5, 0.1) * c_angles(math.rad(-12.5), math.rad(10), math.rad(-25)), 0.1)
		LL_Weld.C0 = clerp(LL_Weld.C0,
			c_new(-0.5, -1, 0) * c_angles(math.rad(-15), 0, math.rad(-5)), 0.01)
		RL_Weld.C0 = clerp(RL_Weld.C0,
			c_new(0.5, -1, 0) * c_angles(math.rad(-15), 0, math.rad(5)), 0.01)
		Head_Weld.C0 = clerp(Head_Weld.C0,
			c_new(0, 1.5, -0.05) * c_angles(math.rad(11.5), 0, 0), 0.05)
		Torso_Weld.C0 = clerp(Torso_Weld.C0,
			c_new(0, -1, 0) * c_angles(math.rad(15), 0, 0), 0.01)

		if Face and vapePower > 5 then
			Face.Texture = "rbxassetid://7317691"
		end
		task.wait()
	end

	charging   = false
	Animations = false
	Vape()
end)

Mouse.Button1Up:Connect(function()
	if charging then
		Release = true
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.Z then
		followMouse = not followMouse
		if followMouse then
			gyro = i_new("BodyGyro")
			gyro.P         = 1e7
			gyro.D         = 1e3
			gyro.MaxTorque = Vector3.new(0, 1e7, 0)
			gyro.Parent    = rootPart
		elseif gyro then
			gyro:Destroy()
			gyro = nil
		end
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		isSprinting = true
		if not movementLocked then updateSpeed() end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		isSprinting = false
		if not movementLocked then updateSpeed() end
	end
end)

-- Mouse-follow body gyro
task.spawn(function()
	while true do
		if followMouse and gyro and gyro.Parent then
			local dir = Mouse.Hit.Position - rootPart.Position
			if dir.Magnitude > 0.001 then
				gyro.CFrame = CFrame.lookAt(Vector3.zero, dir)
			end
		end
		task.wait()
	end
end)

--=====================================================================
-- Part / weld / mesh helpers for the Vepr model
--=====================================================================
local function part(_formFactor, parent, material, reflectance, transparency, brickColor, name, size)
	local fp = i_new("Part")
	fp.Parent       = parent
	fp.Reflectance  = reflectance
	fp.Transparency = transparency
	fp.CanCollide   = false
	fp.Locked       = true
	fp.BrickColor   = BrickColor.new(tostring(brickColor))
	fp.Name         = name
	fp.Size         = size
	fp.Material     = material
	fp.Position     = Torso.Position
	fp.TopSurface    = Enum.SurfaceType.SmoothNoOutlines
	fp.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
	fp.LeftSurface   = Enum.SurfaceType.SmoothNoOutlines
	fp.RightSurface  = Enum.SurfaceType.SmoothNoOutlines
	fp.FrontSurface  = Enum.SurfaceType.SmoothNoOutlines
	fp.BackSurface   = Enum.SurfaceType.SmoothNoOutlines
	return fp
end

local function mesh(meshName, parent, meshType, meshId, offset, scale)
	local m = i_new(meshName)
	if meshName == "SpecialMesh" then
		m.MeshType = meshType
		m.MeshId   = meshId
	end
	m.Offset = offset
	m.Scale  = scale
	m.Parent = parent
	return m
end

local function weld(parent, part0, part1, c0, c1)
	local w = i_new("Weld")
	w.Part0 = part0
	w.Part1 = part1
	w.C0    = c0
	w.C1    = c1
	w.Parent = parent
	return w
end

--=====================================================================
-- Vepr model (geometry untouched)
--=====================================================================
local Vepr = i_new("Model")
Vepr.Name   = "Vepr"
Vepr.Parent = Character

local Handle = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Handle", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Right_Arm, Handle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.677656174, -0.199986219, -0.745416641, 0.721854568, 0.692044795, -4.12490877e-008, 0, 5.96046377e-008, 1, 0.692044854, -0.721854508, 4.30258851e-008))
mesh("CylinderMesh", Handle, "", "", Vector3.new(0, 0, 0), Vector3.new(0.850000024, 1, 0.850000024))

local p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0770874023, 0.530002356, -0.00293064117, -0.707106829, 5.7016841e-008, 0.70710665, 8.64581722e-008, 1, 5.82424065e-009, -0.707106769, 6.52535093e-008, -0.707106948))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.530002356, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.649999976, 1.5, 0.649999976))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Dark stone grey", "ColoredPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0150222778, 0.0528726578, 0.580010891, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.075000003, 0.150000006, 0.075000003))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 1.12999749, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.349999994, 0.5, 0.349999994))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, -0.299999952, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(1.10000002, 0.25, 1.10000002))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0799965858, 0.530002356, 0.00411891937, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, -0.350000143, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.5, 1))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.39999938, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(1.10000002, 0.25, 1.10000002))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 1.20999694, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.25, 0.5, 0.25))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.SmoothPlastic, 0, 0, "Really black", "ColoredPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.06904175e-005, 1.26000762, 0.00412273407, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.300000012, 0.100000001, 0.300000012))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.00412368774, 0.39999938, 1, -9.83454888e-015, 8.94069672e-008, 8.94069672e-008, 1.02581704e-014, 1, 7.10542736e-015, -1, -7.10542736e-015))
mesh("SpecialMesh", p, Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.440000296, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.5, 1))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 1.25999618, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.349999994, 0.100000001, 0.349999994))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 1.06999803, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.649999976, 0.5, 0.649999976))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Dark stone grey", "ColoredPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.23977661e-005, 0.0528755188, 0.595012188, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.075000003, 0.150000006, 0.075000003))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Dark stone grey", "ColoredPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0149841309, 0.0528774261, 0.580010891, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.075000003, 0.150000006, 0.075000003))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Dark stone grey", "ColoredPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.23977661e-005, 0.0528755188, 0.565011501, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.075000003, 0.150000006, 0.075000003))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0829200745, 0.530002356, 0.00291061401, 0.707106769, 2.99547696e-016, 0.707106948, -7.10542736e-015, 1, 7.10542736e-015, -0.707106829, 1.42076978e-014, 0.70710665))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0800065994, 0.530002356, 0.00412559509, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0841331482, 0.530002356, -1.09672546e-005, 8.94069672e-008, 5.70167558e-008, 1, 6.52536016e-008, 1, -5.70167309e-008, -1, 6.52536229e-008, -8.94069672e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.759999275, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.649999976, 1, 0.649999976))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.66893005e-005, 0.0508747101, 0.580010891, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.300000012, 0.150000006, 0.300000012))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.082918644, 0.530002356, -0.00291919708, -0.707106829, 5.7016841e-008, 0.70710665, 8.64581722e-008, 1, 5.82424065e-009, -0.707106769, 6.52535093e-008, -0.707106948))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0770807266, 0.530002356, 0.0029168129, 0.707106769, 2.99547696e-016, 0.707106948, -7.10542736e-015, 1, 7.10542736e-015, -0.707106829, 1.42076978e-014, 0.70710665))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.100000001, 1.5, 0.100000001))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.SmoothPlastic, 0, 0.25, "Teal", "TransparentPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.93999958, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.400000006, 0.800000012, 0.400000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.710000038, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.5, 1))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.SmoothPlastic, 0, 0.5, "Really black", "TransparentPart", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.29153442e-006, 0.93999958, 0.00412368774, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.550000012, 0.800000012, 0.550000012))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.400000006, 0.200000003, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(7.62939453e-006, 0.0458641052, 0.580001354, 1, -9.83454888e-015, 8.94069672e-008, -8.94069672e-008, -5.96041154e-008, -1, -1.24344979e-014, 1, -5.96040941e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.349999994, 0.150000006, 0.349999994))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00204133987, 0, 0.0835571289, 0.86602515, -1.36460565e-014, -0.500000298, -7.10542736e-015, 1, 7.10542736e-015, 0.500000477, 3.96655577e-015, 0.866025209))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00356006622, 0, 0.0779504776, -0.500000477, -3.96655577e-015, -0.866025209, -7.10542736e-015, 1, 7.10542736e-015, 0.86602515, -1.36460565e-014, -0.500000298))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00355911255, 0, 0.0820550919, 0.499999642, -1.38011093e-014, -0.866025567, -7.10542736e-015, 1, 7.10542736e-015, 0.866025627, -3.38788869e-015, 0.499999791))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00206279755, 0, -0.0835399628, -0.866025627, 3.38788869e-015, -0.499999791, -7.10542736e-015, 1, 7.10542736e-015, 0.499999642, -1.38011093e-014, -0.866025567))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00206565857, 0, 0.0764513016, -0.866025627, 3.38788869e-015, -0.499999791, -7.10542736e-015, 1, 7.10542736e-015, 0.499999642, -1.38011093e-014, -0.866025567))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00410270691, 0, -0.0799913406, -2.68220901e-007, -1.02581687e-014, -1, -7.10542736e-015, 1, 7.10542736e-015, 1, -9.83455057e-015, -8.94069672e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00410270691, 0, 0.0800023079, -2.68220901e-007, -1.02581687e-014, -1, -7.10542736e-015, 1, 7.10542736e-015, 1, -9.83455057e-015, -8.94069672e-008))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(4.76837158e-006, 0, -0.0758914948, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0020403862, 0, -0.0764379501, 0.86602515, -1.36460565e-014, -0.500000298, -7.10542736e-015, 1, 7.10542736e-015, 0.500000477, 3.96655577e-015, 0.866025209))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00355911255, 0, -0.0820565224, -0.500000477, -3.96655577e-015, -0.866025209, -7.10542736e-015, 1, 7.10542736e-015, 0.86602515, -1.36460565e-014, -0.500000298))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(9.05990601e-006, 0, 0.0841112137, 1, -9.83454888e-015, 8.94069672e-008, -7.10542736e-015, 1, 7.10542736e-015, 8.94069672e-008, 1.02581704e-014, 1))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

p = part(Enum.FormFactor.Symmetric, Vepr, Enum.Material.Metal, 1, 0, "Really black", "Part", Vector3.new(0.200000003, 0.800000012, 0.200000003))
weld(Vepr, Handle, p, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0035533905, 0, -0.0779447556, 0.499999642, -1.38011093e-014, -0.866025567, -7.10542736e-015, 1, 7.10542736e-015, 0.866025627, -3.38788869e-015, 0.499999791))
mesh("CylinderMesh", p, "", "", Vector3.new(0, 0, 0), Vector3.new(0.150000006, 1, 0.150000006))

--=====================================================================
-- Main animation loop
--=====================================================================
RunService.Stepped:Connect(function()
	if not Character.Parent then return end

	Angle = (Angle % 100) + angleSpeed / 10

	local walkingMagnitude = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z).Magnitude
	local jumpVel          = Torso.Velocity.Y
	local freeFalling      = Humanoid:GetState() == Enum.HumanoidStateType.Freefall

	if Humanoid.Jump and jumpVel > 1 then
		currentAnim = "Jumping"
	elseif freeFalling then
		currentAnim = "Falling"
	elseif walkingMagnitude < 2 then
		currentAnim = "Idling"
	elseif isSprinting then
		currentAnim = "Sprinting"
	else
		currentAnim = "Walking"
	end

	if Animations then return end

	if currentAnim == "Jumping" then
		angleSpeed = 1
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5, -0.1) * c_angles(math.rad(-10), 0, math.rad(10)), 0.15)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5, -0.1) * c_angles(math.rad(-10), 0, math.rad(-10)), 0.15)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -1, 0) * c_angles(math.rad(-10), 0, math.rad(-10)), 0.15)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -1, 0) * c_angles(math.rad(-10), 0, math.rad(10)), 0.15)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1, 0) * c_angles(0, 0, rootPart.RotVelocity.Y / 55), 0.4)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, 0) * c_angles(math.rad(15), 0, 0), 0.15)

	elseif currentAnim == "Falling" then
		angleSpeed = 1
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5, -0.1) * c_angles(0, 0, math.rad(65)), 0.125)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5, -0.1) * c_angles(0, 0, math.rad(-65)), 0.125)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -0.4, -0.4) * c_angles(math.rad(-5), 0, math.rad(-2.5)), 0.125)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -0.4, -0.4) * c_angles(math.rad(-5), 0, math.rad(2.5)), 0.125)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1, 0) * c_angles(math.rad(-20), 0, 0), 0.05)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, 0) * c_angles(math.rad(-17.5), 0, 0), 0.125)

	elseif currentAnim == "Idling" then
		angleSpeed = 0.25
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5 + math.sin(Angle) * 0.075, 0.1) * c_angles(math.rad(15) + math.sin(Angle) * 0.075, 0, math.rad(10) + math.sin(Angle) * 0.075), 0.125)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5 + math.sin(Angle) * 0.075, 0.1) * c_angles(math.rad(-10) + math.sin(Angle) * 0.075, 0, math.rad(-10) - math.sin(Angle) * 0.075), 0.125)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -1.1 - math.sin(Angle) * 0.075, -0.25) * c_angles(math.rad(15), 0, math.rad(-7.5)), 0.125)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -1.1 - math.sin(Angle) * 0.075, -0.25) * c_angles(math.rad(-15), 0, math.rad(7.5)), 0.125)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1 + math.sin(Angle) * 0.075, 0) * c_angles(math.rad(-5), 0, 0), 0.3)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, -0.05) * c_angles(math.rad(-5) + math.sin(Angle) * 0.05, 0, 0), 0.125)

	elseif currentAnim == "Sprinting" then
		angleSpeed = 2
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5, 0) * c_angles(-math.sin(Angle) * 2, math.rad(5) + math.sin(Angle) * 0.1, math.rad(5) + rootPart.RotVelocity.Y / 35), 0.15)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5, 0) * c_angles(math.sin(Angle) * 2, math.rad(-5) + math.sin(Angle) * 0.1, math.rad(-5) + rootPart.RotVelocity.Y / 35), 0.15)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -1.15 + math_pos(-math.cos(Angle - 0.25) * 0.65), math_neg(math.asin(math.sin(Angle)) * 0.65)) * c_angles(-0.025 - math.asin(math.sin(Angle)), 0, -0.025 - math.asin(math.sin(Angle)) * 0.025 + rootPart.RotVelocity.Y / 25), 0.15)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -1.15 + math_pos(math.cos(Angle - 0.25) * 0.65), math_neg(-math.asin(math.sin(Angle)) * 0.65)) * c_angles(-0.025 + math.asin(math.sin(Angle)), 0, 0.025 - math.asin(math.sin(Angle)) * 0.025 + rootPart.RotVelocity.Y / 25), 0.15)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1 + math.abs(math.sin(Angle) * 0.25), 0) * c_angles(math.rad(-20) + math.abs(math.sin(Angle) * 0.05) + rootPart.RotVelocity.Y / 35, math.sin(Angle) * 0.015, rootPart.RotVelocity.Y / 55), 0.15)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, 0) * c_angles(math.abs(math.sin(Angle / 2) * 0.5 * 0.05), math.sin(Angle) * -0.05 + rootPart.RotVelocity.Y / 15, 0), 0.15)

	elseif currentAnim == "Walking" then
		angleSpeed = 1
		RA_Weld.C0    = clerp(RA_Weld.C0, c_new(1.5, 0.5, 0) * c_angles(-math.sin(Angle) * 0.6, math.rad(5) + math.sin(Angle) * 0.05, math.rad(5)), 0.15)
		LA_Weld.C0    = clerp(LA_Weld.C0, c_new(-1.5, 0.5, 0) * c_angles(math.sin(Angle) * 0.6, math.rad(-5) + math.sin(Angle) * 0.05, math.rad(-5)), 0.15)
		LL_Weld.C0    = clerp(LL_Weld.C0, c_new(-0.5, -1.05 + math_pos(-math.cos(Angle - 0.25) * 0.35), math_neg(math.asin(math.sin(Angle)) * 0.35)) * c_angles(-0.025 - math.asin(math.sin(Angle)) * 0.4, 0, -0.025 - math.asin(math.sin(Angle)) * 0.025 - rootPart.RotVelocity.Y / 65), 0.15)
		RL_Weld.C0    = clerp(RL_Weld.C0, c_new(0.5, -1.05 + math_pos(math.cos(Angle - 0.25) * 0.35), math_neg(-math.asin(math.sin(Angle)) * 0.35)) * c_angles(-0.025 + math.asin(math.sin(Angle)) * 0.4, 0, 0.025 - math.asin(math.sin(Angle)) * 0.025 - rootPart.RotVelocity.Y / 65), 0.15)
		Torso_Weld.C0 = clerp(Torso_Weld.C0, c_new(0, -1 + math.abs(math.sin(Angle) * 0.05), 0) * c_angles(math.rad(-12.5) + math.abs(math.sin(Angle) * 0.05), math.sin(Angle) * 0.015, rootPart.RotVelocity.Y / 55), 0.15)
		Head_Weld.C0  = clerp(Head_Weld.C0, c_new(0, 1.5, 0) * c_angles(math.abs(math.sin(Angle / 2) * 0.5 * 0.05), math.sin(Angle) * -0.05 + rootPart.RotVelocity.Y / 45, 0), 0.15)
	end
end)

updateSpeed()
