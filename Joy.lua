--==============================================================
-- FULLY FIXED VERSION (The Nightfall / Taunt Script)
--==============================================================
local Player = game:GetService("Players").LocalPlayer
local lplr = Player
local mouse = Player:GetMouse()
local char = Player.Character or Player.CharacterAdded:Wait()
local PlayerGui = Player.PlayerGui
local Cam = workspace.CurrentCamera
local Backpack = Player.Backpack
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local hum = char:WaitForChild("Humanoid")
local hed = char:WaitForChild("Head")
local root = char:WaitForChild("HumanoidRootPart")
local rootj = root:WaitForChild("RootJoint")
local tors = char:WaitForChild("Torso")
local ra = char:WaitForChild("Right Arm")
local la = char:WaitForChild("Left Arm")
local rl = char:WaitForChild("Right Leg")
local ll = char:WaitForChild("Left Leg")
local neck = tors:WaitForChild("Neck")

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)
local maincolor = BrickColor.new("Really black")

-- Disable default Roblox animations so they don't fight us
local Animate = char:FindFirstChild("Animate")
if Animate then Animate.Disabled = true end

-- Define missing variables
local insta = false
local rainbowmode = false
local attack = false
local sine = 0
local change = 1
local equipped = false
local Player_Size = 1

local CF = CFrame.new
local angles = CFrame.Angles
local Euler = CFrame.fromEulerAnglesXYZ
local Rad = math.rad
local IT = Instance.new
local BrickC = BrickColor.new
local Cos = math.cos
local Acos = math.acos
local Sin = math.sin
local Asin = math.asin
local Abs = math.abs
local Mrandom = math.random
local Floor = math.floor
local Vt = Vector3.new

local necko = CF(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

-- Custom Weld Setup (Replaces Reanimation.lua)
-- We safely set the existing joints to the correct offsets
rootj.C0 = RootCF * CF(0, 0, 0)
rootj.C1 = RootCF * CF(0, 0, 0)
neck.C0 = necko * CF(0, 0, 0)
neck.C1 = CF(0, -0.5, 0) * angles(Rad(-90), 0, Rad(180))
tors["Right Shoulder"].C1 = CF(0, 0.5, 0)
tors["Left Shoulder"].C1 = CF(0, 0.5, 0)
tors["Right Hip"].C0 = CF(1, -1, 0) * angles(0, Rad(90), 0)
tors["Left Hip"].C0 = CF(-1, -1, 0) * angles(0, Rad(-90), 0)
tors["Right Hip"].C1 = CF(0.5, 1, 0) * angles(0, Rad(90), 0)
tors["Left Hip"].C1 = CF(-0.5, 1, 0) * angles(0, Rad(-90), 0)

local Effects = {}

local function swait(num)
	if num == 0 or num == nil then
		RunService.Stepped:Wait()
	else
		for i = 0, num do
			RunService.Stepped:Wait()
		end
	end
end

local function thread(f)
	task.spawn(f)
end

local function clerp(a, b, t)
	local qa = { QuaternionFromCFrame(a) }
	local qb = { QuaternionFromCFrame(b) }
	local ax, ay, az = a.X, a.Y, a.Z
	local bx, by, bz = b.X, b.Y, b.Z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
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
	return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end

function QuaternionSlerp(a, b, t)
	local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
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
	return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end

local function rayCast(Position, Direction, Range, Ignore)
	return workspace:FindPartOnRay(Ray.new(Position, Direction.Unit * (Range or 999.999)), Ignore)
end

local function Create(className)
    return function(props)
        local obj = IT(className)
        for k, v in pairs(props) do
            local success = pcall(function() obj[k] = v end)
            if not success then
                local cap = k:sub(1,1):upper() .. k:sub(2)
                pcall(function() obj[cap] = v end)
            end
        end
        if props.Parent then obj.Parent = props.Parent end
        return obj
    end
end

CFuncs = {
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
				Material = Material
			})
			RemoveOutlines(Part)
			return Part
		end
	},
	Mesh = {
		Create = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
			local Msh = Create(Mesh)({
				Parent = Part,
				Offset = OffSet,
				Scale = Scale
			})
			if Mesh == "SpecialMesh" then
				Msh.MeshType = MeshType
				Msh.MeshId = MeshId
			end
			return Msh
		end
	},
	Weld = {
		Create = function(Parent, Part0, Part1, C0, C1)
			local Weld = Create("Weld")({
				Parent = Parent,
				Part0 = Part0,
				Part1 = Part1,
				C0 = C0,
				C1 = C1
			})
			return Weld
		end
	},
	Sound = {
		Create = function(id, par, vol, pit)
			task.spawn(function()
				local S = Create("Sound")({
					Volume = vol,
					Pitch = pit or 1,
					SoundId = id,
					Parent = par or workspace
				})
				task.wait()
				S:Play()
				Debris:AddItem(S, 6)
			end)
		end
	}
}

function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10, 10, 10, 10
end

EffectModel = IT("Model", char)
Effects = {
  Block = {
    Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
      local prt = CFuncs.Part.Create(EffectModel, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
      prt.Anchored = true
      prt.CFrame = cframe
      local msh = CFuncs.Mesh.Create("BlockMesh", prt, "", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
      Debris:AddItem(prt, 10)
      if Type == 1 or Type == nil then
        table.insert(Effects, { prt, "Block1", delay, x3, y3, z3, msh })
      elseif Type == 2 then
        table.insert(Effects, { prt, "Block2", delay, x3, y3, z3, msh })
      else
        table.insert(Effects, { prt, "Block3", delay, x3, y3, z3, msh })
      end
    end
  },
  Sphere = {
    Create = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
      local prt = CFuncs.Part.Create(EffectModel, "Neon", 0, 0, brickcolor, "Effect", Vector3.new())
      prt.Anchored = true
      prt.CFrame = cframe
      local msh = CFuncs.Mesh.Create("SpecialMesh", prt, "Sphere", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
      Debris:AddItem(prt, 10)
      table.insert(Effects, { prt, "Cylinder", delay, x3, y3, z3, msh })
    end
  }
}

function part(formfactor, parent, reflectance, transparency, brickcolor, name, size)
	local fp = IT("Part")
	fp.Reflectance = reflectance
	fp.Parent = parent
	fp.Transparency = transparency
	fp.CanCollide = false 
	fp.Locked = true
	fp.BrickColor = brickcolor
	fp.Name = name
	fp.Size = size
	fp.Position = tors.Position 
	RemoveOutlines(fp)
	fp.Material = "SmoothPlastic"
	fp:BreakJoints()
	return fp 
end 

function mesh(Mesh, part, meshtype, meshid, offset, scale)
	local mesh = IT(Mesh) 
	mesh.Parent = part
	if Mesh == "SpecialMesh" then
		mesh.MeshType = meshtype
		if meshid ~= "nil" then
			mesh.MeshId = "http://www.roblox.com/asset/?id="..meshid
		end
	end
	mesh.Offset = offset
	mesh.Scale = scale
	return mesh
end

function Magic(bonuspeed, type, pos, scale, value, color, MType)
	local rng = IT("Part", char)
	rng.Anchored = true
	rng.BrickColor = color
	rng.CanCollide = false
	rng.Name = "Ring"
	rng.Material = "Neon"
	rng.Size = Vector3.new(1, 1, 1)
	rng.Transparency = 0
	rng.TopSurface = 0
	rng.BottomSurface = 0
	rng.CFrame = pos
	local rngm = IT("SpecialMesh", rng)
	rngm.MeshType = MType
	rngm.Scale = scale
	local scaler2 = 1
	if type == "Add" then scaler2 = 1 * value elseif type == "Divide" then scaler2 = 1 / value end
	task.spawn(function()
		for i = 0, 10 / bonuspeed, 0.1 do
			swait()
			if type == "Add" then scaler2 = scaler2 - 0.01 * value / bonusspeed
			elseif type == "Divide" then scaler2 = scaler2 - 0.01 / value * bonusspeed end
			rng.Transparency = rng.Transparency + 0.01 * bonusspeed
			rngm.Scale = rngm.Scale + Vector3.new(scaler2 * bonusspeed, scaler2 * bonusspeed, scaler2 * bonusspeed)
		end
		rng:Destroy()
	end)
end

function Aura(bonuspeed, FastSpeed, type, pos, x1, y1, z1, value, color, outerpos, MType)
	local rng = IT("Part", char)
	rng.Anchored = true
	rng.BrickColor = color
	rng.CanCollide = false
	rng.Name = "Ring"
	rng.Material = "Neon"
	rng.Size = Vector3.new(1, 1, 1)
	rng.Transparency = 0
	rng.TopSurface = 0
	rng.BottomSurface = 0
	rng.CFrame = pos + pos.LookVector * outerpos
	local rngm = IT("SpecialMesh", rng)
	rngm.MeshType = MType
	rngm.Scale = Vector3.new(x1, y1, z1)
	local scaler2 = 1
	local speeder = FastSpeed
	if type == "Add" then scaler2 = 1 * value elseif type == "Divide" then scaler2 = 1 / value end
	task.spawn(function()
		for i = 0, 10 / bonuspeed, 0.1 do
			swait()
			if type == "Add" then scaler2 = scaler2 - 0.01 * value / bonusspeed
			elseif type == "Divide" then scaler2 = scaler2 - 0.01 / value * bonusspeed end
			speeder = speeder - 0.01 * FastSpeed * bonusspeed
			rng.CFrame = rng.CFrame + rng.CFrame.LookVector * speeder * bonusspeed
			rng.Transparency = rng.Transparency + 0.01 * bonusspeed
			rngm.Scale = rngm.Scale + Vector3.new(scaler2 * bonusspeed, scaler2 * bonusspeed, 0)
		end
		rng:Destroy()
	end)
end

-- Visuals & Text
local BTAUNT2 = IT("Sound", hed)
BTAUNT2.SoundId = "rbxassetid://957602352"
BTAUNT2.Volume = 5
BTAUNT2.Looped = true
BTAUNT2:Play()

local BTAUNT4 = IT("Sound", hed)
BTAUNT4.SoundId = "rbxassetid://2658538628"
BTAUNT4.Volume = 10
BTAUNT4.Looped = false

local BTAUNT5 = IT("Sound", hed)
BTAUNT5.SoundId = "rbxassetid://468944969"
BTAUNT5.Volume = 3.5
BTAUNT5.Looped = false

local BTAUNT6 = IT("Sound", hed)
BTAUNT6.SoundId = "rbxassetid://2675983782"
BTAUNT6.Volume = 10
BTAUNT6.Looped = false

local BTAUNT7 = IT("Sound", hed)
BTAUNT7.SoundId = "rbxassetid://2770017501"
BTAUNT7.Volume = 1.5
BTAUNT7.Looped = false

local naeeym2 = IT("BillboardGui", char)
naeeym2.AlwaysOnTop = true
naeeym2.Size = UDim2.new(5, 35, 2, 35)
naeeym2.StudsOffset = Vector3.new(0, 2, 0)
naeeym2.Adornee = hed

local tecks2 = IT("TextLabel", naeeym2)
tecks2.BackgroundTransparency = 1
tecks2.TextScaled = true
tecks2.BorderSizePixel = 0
tecks2.Font = Enum.Font.Cartoon
tecks2.TextSize = 30
tecks2.TextStrokeTransparency = 0
tecks2.TextColor3 = BrickColor.new('Institutional white').Color
tecks2.TextStrokeColor3 = BrickColor.new('Really black').Color
tecks2.Size = UDim2.new(1, 0, 0.5, 0)
tecks2.Text = ":joy:"

task.spawn(function()
    while tecks2 and tecks2.Parent do
        swait()
        tecks2.Position = UDim2.new(math.random(-0.2, 0.2), math.random(-3, 9), .05, math.random(-10, 10))
        tecks2.Rotation = math.random(-1.8, 1.8)
    end
end)

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE)
	local NEWPART = IT("Part")
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.BrickColor = BrickC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = tors.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

function MakeForm(PART, TYPE)
	local MSH = nil
	if TYPE == "Cyl" then MSH = IT("CylinderMesh", PART)
	elseif TYPE == "Ball" then MSH = IT("SpecialMesh", PART) MSH.MeshType = "Sphere"
	elseif TYPE == "Wedge" then MSH = IT("SpecialMesh", PART) MSH.MeshType = "Wedge"
	elseif TYPE == "Block" then MSH = IT("SpecialMesh", PART) MSH.MeshType = "Brick" end
	return MSH
end

function Cso(ID, PARENT, VOLUME, PITCH)
	local NSound = nil
	task.spawn(function()
		NSound = IT("Sound", PARENT)
		NSound.Volume = VOLUME
		NSound.Pitch = PITCH
		NSound.SoundId = "http://www.roblox.com/asset/?id="..ID
		swait()
		NSound:Play()
		Debris:AddItem(NSound, 50)
	end)
end

function muda()
    for i = 0, 0.1, 0.1 do
        swait()
        neck.C0 = clerp(neck.C0, necko* CF(0, 0, 0) * angles(Rad(0), Rad(0), Rad(20)), 1)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 7) * angles(Rad(70), Rad(0), Rad(-60)), 0.6)
        tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1, 0) * angles(Rad(0), Rad(90), Rad(-70)), 1)
        tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1, 0) * angles(Rad(0), Rad(-90), Rad(70)), 1)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55, 3) * angles(Rad(90), Rad(0), Rad(0)), 0.6)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55, -3) * angles(Rad(90), Rad(0), Rad(0)), 0.6)
    end
    for i = 0, 0.1, 0.1 do
        swait()
        neck.C0 = clerp(neck.C0, necko* CF(0, 0, 0) * angles(Rad(0), Rad(0), Rad(-20)), 1)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 7) * angles(Rad(70), Rad(0), Rad(60)), 0.6)
        tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1, 0) * angles(Rad(0), Rad(90), Rad(-70)), 1)
        tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1, 0) * angles(Rad(0), Rad(-90), Rad(70)), 1)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55, -3) * angles(Rad(90), Rad(0), Rad(0)), 0.6)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55, 3) * angles(Rad(90), Rad(0), Rad(0)), 0.6)
    end
end

function roadroller()
    attack = true
    BTAUNT2:Stop()
    BTAUNT7:Play()
    local Container = IT("Part", char)
    Container.Name = "Blob"
    Container.CanCollide = false
    Container.BrickColor = BrickColor.new("Deep orange")
    Container.Transparency = 0
    Container.Material = "Neon"
    Container.Size = Vector3.new(1, 1, 2)
    
    local aWeld = IT("Weld", Container)
    aWeld.Part0 = tors
    aWeld.Part1 = Container
    aWeld.C1 = CF(0, 10, 0)
    aWeld.C0 = angles(Rad(0), 0, 0)
    
    local M2 = IT("SpecialMesh", Container)
    M2.MeshId = "rbxassetid://489989415"
    M2.TextureId = "rbxassetid://489989506"
    
    for i = 0, 67, 0.1 do
        swait()
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 220) * angles(Rad(0), Rad(0), Rad(0)), 0.6)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55, 0) * angles(Rad(0), Rad(0), Rad(0)), 1)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55, 0) * angles(Rad(0), Rad(0), Rad(0)), 1)
    end
    for i = 0, 40, 0.1 do
        swait()
        aWeld.C1 = clerp(aWeld.C1, CF(0, -6, 0) * angles(Rad(90), Rad(0), Rad(0)), 1)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 7) * angles(Rad(90), Rad(0), Rad(0)), 0.15)
    end
    for i = 0, 46, 0.1 do
        swait()
        root.Anchored = true
        aWeld.Part0 = root
        aWeld.C1 = clerp(aWeld.C1, CF(0, 0.6, 0) * angles(Rad(0), Rad(0), Rad(0)), 1)
        Container.Size = Vector3.new(15, 5, 5)
    end
    Container.CanCollide = true
    for i = 0, 20, 0.1 do
        swait()
        root.Anchored = false
        aWeld.C1 = clerp(aWeld.C1, CF(0, 0.5, 0) * angles(Rad(0), Rad(0), Rad(0)), 1)
    end
    
    -- Damage logic
    for i, v in pairs(workspace:GetChildren()) do
        if v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
            if (v.Head.Position - Container.Position).Magnitude < 19.5 then
                v.Humanoid.Health = 0
                Cso("1744093986", v, 10, 1)
            end
        end
    end
    
    for i = 0, 9 do
        Magic(0.5, "Add", Container.CFrame, Vector3.new(60, 80, 50), 2, BrickC("Deep orange"), "Sphere")
        Magic(2, "Add", Container.CFrame, Vector3.new(60, 80, 50), 2, BrickC("Dark orange"), "Sphere")
        Aura(3, 5.5, "Add", Container.CFrame * angles(Rad(math.random(-360, 360)), Rad(math.random(-360, 360)), Rad(math.random(-360, 360))), 5, 5, 50, -0.05, BrickC("Deep orange"), 0, "Sphere")
    end
    
    BTAUNT7:Stop()
    BTAUNT2:Play()
    Container:Destroy()
    attack = false
end

function bruhmoment()
    attack = true
    BTAUNT3:Play()
    while BTAUNT3.Playing do
        tecks2.Text = "He spittin facts"
        for i = 0, 7, 0.1 do
            swait()
            neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(Rad(90 * Sin(sine / 5)), 0, 0), 1)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0.5 * Sin(sine / 1.2), 0.3 * Sin(sine / 1.2), 0.3 * Sin(sine / 1.2)) * angles(0, 0, 0), 1)
        end
    end
    tecks2.Text = ":joy:"
    attack = false
end

function when()
    attack = true
    BTAUNT5:Play()
    while BTAUNT5.Playing do
        for i = 0, 0.5, 0.1 do
            swait()
            neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(Rad(40), 0, 0), 1)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0.2 * Sin(sine / 3.5), 0) * angles(Rad(30), 0, 0), 1)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55, 0) * angles(Rad(10), 0, Rad(-20)), 1)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55, 0) * angles(Rad(120), 0, 0), 1)
        end
        for i = 0, 0.5, 0.1 do
            swait()
            neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(Rad(-40), 0, 0), 1)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0.2 * Sin(sine / 3.5), 0) * angles(Rad(-30), 0, 0), 1)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55, 0) * angles(Rad(10), 0, Rad(-20)), 1)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55, 0) * angles(Rad(120), 0, 0), 1)
        end
    end
    BTAUNT5:Stop()
    tecks2.Text = "Touture Dance"
    attack = false
end

function isthatajojoreference()
    attack = true
    BTAUNT2:Stop()
    BTAUNT6:Play()
    
    for i = 0, 7.5, 0.1 do
        swait()
        neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(0, 0, Rad(30)), 0.5)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0.4, -0.5) * angles(0, 0, 0), 0.6)
        tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1, -0.75) * angles(0, Rad(85), 0) * angles(Rad(-3), 0, 0), 0.5)
        tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1, -0.75) * angles(0, Rad(-85), 0) * angles(Rad(-3), 0, 0), 0.5)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.45, -0.5) * angles(Rad(120), 0, 0), 0.6)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.45, -0.5) * angles(Rad(120), 0, 0), 0.6)
    end
    
    while BTAUNT6.Playing do
        for i = 0, 2.5, 0.1 do
            swait()
            neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(0, 0, Rad(30)), 0.5)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 0) * angles(0, 0, 0), 0.1)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1, 0) * angles(0, Rad(75), 0), 0.5)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1, 0) * angles(0, Rad(-75), 0), 0.5)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, -0.1, 0) * angles(Rad(10), 0, Rad(130)), 0.5)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.4, 0.25, 0) * angles(Rad(10), 0, Rad(40)), 0.5)
        end
        for i = 0, 0.5, 0.1 do
            swait()
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0.5, 0, 0) * angles(0, 0, 0), 0.6)
        end
        for i = 0, 2.7, 0.1 do
            swait()
            neck.C0 = clerp(neck.C0, necko * CF(0, 0, 0) * angles(Rad(10), 0, Rad(60)), 0.5)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(-1, -1, -0.2) * angles(Rad(10), 0, 0), 0.1)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1, -0.5) * angles(0, Rad(97), Rad(10)), 0.5)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1, -0.5) * angles(0, Rad(-97), Rad(-10)), 0.5)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0, 0) * angles(Rad(10), 0, Rad(170)), 0.5)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.8, 0.25, 0) * angles(Rad(10), 0, Rad(40)), 0.5)
        end
    end
    
    BTAUNT2:Play()
    attack = false
end

function discord()
    attack = true
    BTAUNT2:Stop()
    tecks2.Text = "car noises"
    hum.WalkSpeed = 100
    BTAUNT4:Play()
    la.Transparency = 1
    ra.Transparency = 1
    for i = 0, 17, 0.1 do
        swait()
        neck.C0 = clerp(neck.C0, necko * CF(0, -0.6, -1.5) * angles(Rad(90), 0, 0), 1)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, -2.6, -2) * angles(Rad(-90), Rad(10 * Cos(sine / 1.5)), 0), 1)
        tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1.8, -1, 0.7) * angles(0, Rad(90), Rad(-180)), 1)
        tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1.8, -1, 0.7) * angles(0, Rad(-90), Rad(180)), 1)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(0, -1.55, -0.7) * angles(Rad(90), 0, 0), 1)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(0, -2.55, -0.7) * angles(Rad(90), 0, 0), 1)
    end
    for i = 0, 97, 0.05 do
        swait()
        neck.C0 = clerp(neck.C0, necko * CF(0, -0.6, -1.5) * angles(Rad(90), 0, 0), 1)
        rootj.C0 = clerp(rootj.C0, RootCF * CF(0, -2.6, -2) * angles(Rad(-90), Rad(10 * Cos(sine / 1.5)), 0), 1)
        tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1.8, -1, 0.7) * angles(0, Rad(90), Rad(-180)), 1)
        tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1.8, -1, 0.7) * angles(0, Rad(-90), Rad(180)), 1)
        tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(0, -1.55, -0.7) * angles(Rad(90), 0, 0), 1)
        tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(0, -2.55, -0.7) * angles(Rad(90), 0, 0), 1)
    end
    BTAUNT4:Stop()
    hum.WalkSpeed = 20
    la.Transparency = 0
    ra.Transparency = 0
    tecks2.Text = ":joy:"
    BTAUNT2:Play()
    attack = false
end

-- Input Handler
UIS.InputBegan:Connect(function(input, processed)
    if processed or attack then return end
    local key = input.KeyCode.Name:lower()
    if key == "z" then
        bruhmoment()
    elseif key == "r" then
        roadroller()
    elseif key == "c" then
        discord()
    elseif key == "v" then
        when()
    elseif key == "f" then
        isthatajojoreference()
    end
end)

-- Main Animation Loop
while char.Parent do
    swait()
    sine = sine + change
    
    if not attack then
        local torvel = (root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
        local hitfloor = rayCast(root.Position, Vector3.new(0, -1, 0), 4, char)
        
        if root.AssemblyLinearVelocity.Y > 1 and not hitfloor then
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 0.9 + 0.5 * Cos(sine / -15)) * angles(0, 0, 0), 0.17)
            neck.C0 = clerp(neck.C0, necko * angles(Rad(10 - 2.5 * Sin(sine / 30)), 0, 0), 0.3)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -0.2 - 0.1 * Cos(sine / 20), -0.3) * RHCF * angles(Rad(-2.5), 0, 0), 0.15)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -0.9 - 0.1 * Cos(sine / 20), -0.5) * LHCF * angles(Rad(-2.5), 0, 0), 0.15)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.5 + 0.02 * Sin(sine / 20), 0) * angles(Rad(25), Rad(-0.6), Rad(13 + 4.5 * Sin(sine / 20))), 0.1)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.5 + 0.02 * Sin(sine / 20), 0) * angles(Rad(25), Rad(-0.6), Rad(-13 - 4.5 * Sin(sine / 20))), 0.1)
            
        elseif root.AssemblyLinearVelocity.Y < -1 and not hitfloor then
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.1 * Cos(sine / 20)) * angles(Rad(24), 0, 0), 0.15)
            neck.C0 = clerp(neck.C0, necko * angles(Rad(10 - 2.5 * Sin(sine / 30)), 0, 0), 0.3)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1 - 0.1 * Cos(sine / 20), -0.3) * RHCF * angles(Rad(-3.5), 0, 0), 0.15)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -0.8 - 0.1 * Cos(sine / 20), -0.3) * LHCF * angles(Rad(-3.5), 0, 0), 0.15)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.5 + 0.02 * Sin(sine / 20), 0) * angles(Rad(65), Rad(-0.6), Rad(45 + 4.5 * Sin(sine / 20))), 0.1)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.5 + 0.02 * Sin(sine / 20), 0) * angles(Rad(55), Rad(-0.6), Rad(-45 - 4.5 * Sin(sine / 20))), 0.1)
            
        elseif torvel < 1 and hitfloor then
            change = 1.75
            neck.C0 = clerp(neck.C0, necko * angles(Rad(-10 + 12.5 * Sin(sine / 12)), 0, 0), 0.3)
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, -0.1 + 0.3 * Sin(sine / 12)) * angles(Rad(0), Rad(0), 0), 0.35)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -1 - 0.3 * Sin(sine / 12), -0.5) * angles(0, Rad(76), Rad(-10)) * angles(Rad(-13 + 7 * Cos(sine / 12)), 0, 0), 0.35)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -1 - 0.3 * Sin(sine / 12), -0.5) * angles(0, Rad(-76), Rad(10)) * angles(Rad(-13 + 7 * Cos(sine / 12)), 0, 0), 0.35)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.55 - 0.15 * Cos(sine / 12), 0) * angles(Rad(10 * Cos(sine / 12)), 0, Rad(10 - 12.5 * Cos(sine / 12))), 0.12)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.55 - 0.15 * Cos(sine / 12), 0) * angles(Rad(10 * Cos(sine / 12)), 0, Rad(-10 + 12.5 * Cos(sine / 12))), 0.12)
            
        elseif torvel > 2 and torvel < 25 and hitfloor then
            change = 1.3
            rootj.C0 = clerp(rootj.C0, RootCF * CF(0, 0, 0.375 - 0.73 * Sin(sine / 3.5)) * angles(Rad(-3 - 32.5 * Cos(sine / 3.5)), Rad(0) - root.RotVelocity.Y / 75, Rad(1 * Cos(sine / 7))), 0.15)
            neck.C0 = clerp(neck.C0, necko * angles(Rad(30 * Sin(sine / 3.5)), 0, Rad(0) - hed.RotVelocity.Y / 15), 0.3)
            tors["Right Hip"].C0 = clerp(tors["Right Hip"].C0, CF(1, -0.8 - 1 * Cos(sine / 7) / 2, 0.8 * Cos(sine / 7) / 0.7) * angles(Rad(-10 - 25 * Cos(sine / 7)) - rl.RotVelocity.Y / 75 + -Sin(sine / 7) / 2, Rad(90 - 15 * Cos(sine / 7)), 0) * angles(Rad(0 + 2 * Cos(sine / 7)), 0, 0), 0.3)
            tors["Left Hip"].C0 = clerp(tors["Left Hip"].C0, CF(-1, -0.8 + 1 * Cos(sine / 7) / 2, -0.8 * Cos(sine / 7) / 0.7) * angles(Rad(-10 + 25 * Cos(sine / 7)) + ll.RotVelocity.Y / 75 + Sin(sine / 7) / 2, Rad(-90 - 15 * Cos(sine / 7)), 0) * angles(Rad(0 - 2 * Cos(sine / 7)), 0, 0), 0.3)
            tors["Right Shoulder"].C0 = clerp(tors["Right Shoulder"].C0, CF(1.5, 0.5 + 0.05 * Sin(sine / 7), 0) * angles(Rad(137 * Cos(sine / 7)), Rad(10 * Cos(sine / 7)), Rad(0) - ra.RotVelocity.Y / 75), 0.1)
            tors["Left Shoulder"].C0 = clerp(tors["Left Shoulder"].C0, CF(-1.5, 0.5 + 0.05 * Sin(sine / 7), 0) * angles(Rad(-137 * Cos(sine / 7)), Rad(10 * Cos(sine / 7)), Rad(0) + la.RotVelocity.Y / 75), 0.1)
        end
    end
    
    -- Effects Loop
    if #Effects > 0 then
        for e = #Effects, 1, -1 do
            local Thing = Effects[e]
            if Thing and Thing[1] and Thing[1].Transparency <= 1 then
                local Part = Thing[1]
                local Mode, Delay = Thing[2], Thing[3]
                local Mesh = Part:FindFirstChildWhichIsA("DataModelMesh")
                if Mode == "Block1" and Mesh then
                    Part.CFrame = Part.CFrame * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                    Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
                    Part.Transparency = Part.Transparency + Delay
                elseif Mode == "Cylinder" and Mesh then
                    Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
                    Part.Transparency = Part.Transparency + Delay
                end
            elseif Thing and Thing[1] then
                Thing[1]:Destroy()
                table.remove(Effects, e)
            end
        end
    end
end
