-- FIXED VERSION
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local RootPart = Character:WaitForChild("HumanoidRootPart")
local Torso = Character:WaitForChild("Torso")
local Head = Character:WaitForChild("Head")
local RightArm = Character:WaitForChild("Right Arm")
local LeftArm = Character:WaitForChild("Left Arm")
local RightLeg = Character:WaitForChild("Right Leg")
local LeftLeg = Character:WaitForChild("Left Leg")
local RootJoint = RootPart:WaitForChild("RootJoint")
local Neck = Torso:WaitForChild("Neck")
local RightShoulder = Torso:WaitForChild("Right Shoulder")
local LeftShoulder = Torso:WaitForChild("Left Shoulder")
local RightHip = Torso:WaitForChild("Right Hip")
local LeftHip = Torso:WaitForChild("Left Hip")

-- FIX: Prevent death and disable default animations
local Animate = Character:FindFirstChild("Animate")
if Animate then Animate:Destroy() end
Humanoid.RequiresNeck = false
Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge

-- FIX: Set default R6 C1 joints so animations don't flip the character
RightShoulder.C1 = CFrame.new(0.5, 0.5, 0) * CFrame.Angles(0, math.pi/2, 0)
LeftShoulder.C1 = CFrame.new(-0.5, 0.5, 0) * CFrame.Angles(0, -math.pi/2, 0)
RightHip.C1 = CFrame.new(0.5, 1, 0) * CFrame.Angles(0, math.pi/2, 0)
LeftHip.C1 = CFrame.new(-0.5, 1, 0) * CFrame.Angles(0, -math.pi/2, 0)
RootJoint.C1 = CFrame.new(0, 0, 0) * CFrame.Angles(-math.pi/2, 0, math.pi)
Neck.C1 = CFrame.new(0, -0.5, 0) * CFrame.Angles(-math.pi/2, 0, math.pi)

local sick = Instance.new("Sound",Character)
sick.SoundId = "rbxassetid://1110421128"
sick.Looped = true
sick.Pitch = 1
sick.Volume = 3
sick:Play()

local target = nil
local boop = nil

local IT = Instance.new
local CF = CFrame.new
local VT = Vector3.new
local RAD = math.rad
local C3 = Color3.new
local UD2 = UDim2.new
local BRICKC = BrickColor.new
local ANGLES = CFrame.Angles
local EULER = CFrame.fromEulerAnglesXYZ

local Player_Size = 1
local Animation_Speed = 1
local Frame_Speed = 1 / 60
local Speed = 75
local Effects2 = {}

local ROOTC0 = CF(0, 0, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local NECKC0 = CF(0, 1, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local RIGHTSHOULDERC0 = CF(-0.5, 0, 0) * ANGLES(RAD(0), RAD(90), RAD(0))
local LEFTSHOULDERC0 = CF(0.5, 0, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))

local ANIM = "Idle"
local ATTACK = false
local Rooted = false
local SINE = 0
local CHANGE = 2 / Animation_Speed
local DISABLEJUMPING = false

local Weapon = IT("Model")
Weapon.Name = "Add-ons"
local Effects = IT("Folder", Weapon)
Effects.Name = "Effects"

local function weldBetween(a, b)
    local weldd = Instance.new("ManualWeld")
    weldd.Part0 = a
    weldd.Part1 = b
    weldd.C0 = CFrame.new()
    weldd.C1 = b.CFrame:inverse() * a.CFrame
    weldd.Parent = a
    return weldd
end

function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local NEWMESH = IT(MESH)
	if MESH == "SpecialMesh" then
		NEWMESH.MeshType = MESHTYPE
		if MESHID ~= "nil" and MESHID ~= "" then NEWMESH.MeshId = "http://www.roblox.com/asset/?id="..MESHID end
		if TEXTUREID ~= "nil" and TEXTUREID ~= "" then NEWMESH.TextureId = "http://www.roblox.com/asset/?id="..TEXTUREID end
	end
	NEWMESH.Offset = OFFSET or VT(0, 0, 0)
	NEWMESH.Scale = SCALE
	NEWMESH.Parent = PARENT
	return NEWMESH
end

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE)
	local NEWPART = IT("Part")
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.BrickColor = BRICKC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = Torso.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

ArtificialHB = IT("BindableEvent")
ArtificialHB.Name = "ArtificialHB"
frame = Frame_Speed
tf = 0

RunService.Heartbeat:Connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		for i = 1, math.floor(tf / frame) do ArtificialHB:Fire() end
		tf = tf - frame * math.floor(tf / frame)
	end
end)

function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:Wait()
	else
		for i = 1, NUMBER do ArtificialHB.Event:Wait() end
	end
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
		elseif i == 2 then
			local s = math.sqrt(m22 - m00 - m11 + 1)
			local recip = 0.5 / s return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
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
	local startInterp, finishInterp;
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
	return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end

function Clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end

function CreateSound(ID, PARENT, VOLUME, PITCH)
	task.spawn(function()
		local NEWSOUND = IT("Sound", PARENT)
		NEWSOUND.Volume = VOLUME
		NEWSOUND.Pitch = PITCH
		NEWSOUND.SoundId = "http://www.roblox.com/asset/?id="..ID
		Swait()
		NEWSOUND:Play()
		Debris:AddItem(NEWSOUND, 10)
	end)
end

--//=================================\\
--||	     DAMAGE FUNCTIONS
--\\=================================//
function dealdamage(hit,min,max,maxstrength,beserk,critrate,critmultiplier)
	local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
	if hum and hit.Parent ~= Character then
		hum.Health = hum.Health - math.random(min, max)
	end
end

function killnearest(position,range,maxstrength)
	for _, v in pairs(workspace:GetChildren()) do
		if v ~= Character and v:FindFirstChildOfClass("Humanoid") then
			local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
			if torso and (torso.Position - position).Magnitude <= range then
				v:BreakJoints()
			end
		end
	end
end

function choosetarget()
	if Mouse.Target and Mouse.Target.Parent ~= Character and Mouse.Target.Parent:FindFirstChild("Humanoid") ~= nil then
		target = Mouse.Target.Parent
		if boop ~= nil then boop:Destroy() end
		local targettorso = target:FindFirstChild("Torso") or target:FindFirstChild("UpperTorso")
		if targettorso ~= nil then
			boop = IT("Part", Effects)
			boop.Size = VT(0,0,0)
			boop.CanCollide = false
			boop.Transparency = 1
			boop.CFrame = targettorso.CFrame * CF(0,-0.75,0.8)
			weldBetween(targettorso, boop)
		else
			target = nil
		end
	end
end

function assgrab()
	if target ~= nil then
		local targettorso = target:FindFirstChild("Torso") or target:FindFirstChild("UpperTorso")
		if targettorso ~= nil then
			ATTACK = true
			targettorso.Anchored = true
			Rooted = true
			CreateSound("889222890", Head, 10, 1)
			RootPart.CFrame = targettorso.CFrame * CF(0,0,3)
			Swait(100)
			if target ~= nil and targettorso ~= nil then
				for i = 1, 3 do
					CreateSound("948494432", targettorso, 10, 1)
					Swait(5)
				end
				if target ~= nil and targettorso ~= nil then
					Swait(15)
					RootPart.CFrame = targettorso.CFrame * CF(0,0,1.5)
					Swait(20)
					RootPart.CFrame = targettorso.CFrame * CF(0,0,3)
					ATTACK = false
					Rooted = false
					targettorso.Anchored = false
					local bomb = IT("Part",target)
					bomb.Size = VT(0,0,0)
					bomb.CFrame = boop.CFrame
					bomb.CanCollide = false
					local mesh = IT("SpecialMesh",bomb)
					mesh.MeshType = "FileMesh"
					mesh.MeshId = "rbxasset://fonts/timebomb.mesh"
					mesh.TextureId = "rbxasset://textures/bombtex.png"
					weldBetween(targettorso,bomb)
					CreateSound("138931042", targettorso, 10, 4)
					Swait(150)
					target:BreakJoints()
					local boom = Instance.new("Explosion",workspace)
					boom.Position = targettorso.Position
					CreateSound("691216625", targettorso, 50, 1)
					target = nil
				else
					Rooted = false
					ATTACK = false
				end
			else
				Rooted = false
				ATTACK = false
			end
		end
	end
end

function slash()
	ATTACK = true
	Rooted = true
	for i=0, 0.5, 0.1 / Animation_Speed do
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 * Player_Size, 0 * Player_Size, -0.2 * Player_Size) * ANGLES(RAD(10), RAD(0), RAD(0)), 0.4 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0 * Player_Size, 0 * Player_Size, 0 + ((1 * Player_Size) - 1)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(90), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(0)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1 * Player_Size, -0.3 * Player_Size, -1 * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(-20)), 0.2 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1 * Player_Size, -1 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(10)), 0.2 / Animation_Speed)
	end
	local bomb = IT("Part",Effects)
	bomb.Size = VT(0,0,0)
	bomb.CFrame = RightArm.CFrame * CF(1.6,-1.2,0) * ANGLES(RAD(-90),RAD(0),RAD(-90))
	bomb.CanCollide = false
	bomb.Color = C3(123/255, 0, 123/255)
	local mesh = IT("SpecialMesh",bomb)
	mesh.MeshType = "FileMesh"
	mesh.Scale = VT(2,2,2)
	mesh.MeshId = "http://www.roblox.com/asset?id=156092238"
	weldBetween(RightArm,bomb)
	Swait(10)
	CreateSound("615910787", Torso, 5, math.random(7, 12) / 10)
	Swait(5)
	for i = 1, 15 do
		killnearest(bomb.Position,6,150)
		RootPart.CFrame = RootPart.CFrame * CF(0,0,-3)
	end
	killnearest(bomb.Position,6,150)
	for i=0, 1, 0.1 / Animation_Speed do
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 * Player_Size, 0 * Player_Size, -0.2 * Player_Size) * ANGLES(RAD(10), RAD(0), RAD(25)), 0.4 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0 * Player_Size, 0 * Player_Size, 0 + ((1 * Player_Size) - 1)) * ANGLES(RAD(0), RAD(0), RAD(-25)), 0.2 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.25 * Player_Size, 0.5 * Player_Size, -0.5 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(-70)) * ANGLES(RAD(20), RAD(90), RAD(0)) * RIGHTSHOULDERC0, 0.4 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(-25), RAD(0), RAD(-45)) * LEFTSHOULDERC0, 0.4 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1 * Player_Size, -0.3 * Player_Size, -1 * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(-20)), 0.2 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1 * Player_Size, -1 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(10)), 0.2 / Animation_Speed)
	end
	Swait(25)
	bomb:Destroy()
	ATTACK = false
	Rooted = false
end

function hurr()
	if target ~= nil then
		local targettorso = target:FindFirstChild("Torso") or target:FindFirstChild("UpperTorso")
		if targettorso ~= nil then
			Rooted = true
			ATTACK = true
			RootPart.CFrame = targettorso.CFrame * CF(0,0,3)
			for i = 1, 15 do
				Swait(3)
				RootPart.CFrame = targettorso.CFrame * CF(0,0,1)
				Swait(3)
				RootPart.CFrame = targettorso.CFrame * CF(0,0,3)
			end
			CreateSound("173137001", Head, 5, 1)
			target:BreakJoints()
			target = nil
			Rooted = false
			ATTACK = false
		end
	end
end

function beam(from,size)
	local sphere = Instance.new("Part",Effects)
	sphere.Size = VT(size*2,size*2,size*2)
	sphere.Material = "Neon"
	sphere.Shape = "Ball"
	sphere.Name = "Waft"
	sphere.Anchored = true
	sphere.Color = C3(80/255, 109/255, 84/255)
	sphere.CFrame = RootPart.CFrame * CF(0,0.5,-from)
	sphere.CanCollide = false
	sphere.Touched:Connect(function(hit) 
		dealdamage(hit,0,0,0,true,0,0)
	end)
	table.insert(Effects2,{sphere,"Disappear",0.01,0.03,0,0.03,1})
end

function turnto(position)
	RootPart.CFrame = CFrame.new(RootPart.CFrame.p, VT(position.X, RootPart.Position.Y, position.Z))
end

function FARTLAZOR()
	Rooted = true
	ATTACK = true
	for i=0, 2, 0.1 / Animation_Speed do
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 * Player_Size, 0 * Player_Size, 0 * Player_Size + 0) * ANGLES(RAD(0), RAD(0), RAD(180)), 0.15 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0 * Player_Size, 0 * Player_Size, 0 + ((1 * Player_Size) - 1)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(-90)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1 * Player_Size, -0.8 * Player_Size - 0 * Player_Size, -0.01 * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1 * Player_Size, -0.8 * Player_Size - 0 * Player_Size, -0.01 * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
	end
	for i = 1, 25 do
		Swait()
		turnto(Mouse.Hit.p)
	end
	CreateSound("131314452", Effects, 10, 1)
	beam(50,50)
	Swait(50)
	ATTACK = false
	Rooted = false
end

--//=================================\\
--||	  ASSIGN THINGS TO KEYS
--\\=================================//

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	local Key = input.KeyCode.Name:lower()
	
	if Key == "e" and ATTACK == false then assgrab() end
	if Key == "g" and ATTACK == false then slash() end
	if Key == "x" and ATTACK == false then FARTLAZOR() end
	if Key == "f" and ATTACK == false then hurr() end
end)

Mouse.Button1Down:Connect(function()
	if ATTACK == false then choosetarget() end
end)

--//=================================\\
--||	WRAP THE WHOLE SCRIPT UP
--\\=================================//

while true do
	Swait()
	SINE = SINE + CHANGE
	if ATTACK == false then
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 * Player_Size, 0 * Player_Size, 0 * Player_Size + 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0 * Player_Size, 0 * Player_Size, 0 + ((1 * Player_Size) - 1)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5 * Player_Size, 0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(0), RAD(-90)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1 * Player_Size, -0.8 * Player_Size - 0 * Player_Size, -0.01 * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1 * Player_Size, -0.8 * Player_Size - 0 * Player_Size, -0.01 * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
	end
	
	for e = #Effects2, 1, -1 do
		local Thing = Effects2[e]
		if Thing and Thing[1] and Thing[1].Transparency <= 1 then
			local Part = Thing[1]
			local Mode = Thing[2]
			local Delay = Thing[3]
			if Mode == "Disappear" then
				Part.Transparency = Part.Transparency + Delay
			end
		elseif Thing and Thing[1] then
			Thing[1]:Destroy()
			table.remove(Effects2, e)
		end
	end
	
	Humanoid.MaxHealth = math.huge
	Humanoid.Health = math.huge
	
	if Rooted == false then
		Humanoid.WalkSpeed = Speed
	elseif Rooted == true then
		Humanoid.WalkSpeed = 0
	end
end
