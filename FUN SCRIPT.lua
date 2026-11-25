-- uh yea

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local RealChar = Player.Character or Player.CharacterAdded:Wait()
local RealHum = RealChar:WaitForChild("Humanoid")

-- kill real character animations / movement
for _, v in ipairs(RealHum:GetPlayingAnimationTracks()) do v:Stop(0) end
RealHum.WalkSpeed = 0
RealHum.JumpPower = 0
RealHum.JumpHeight = 0
RealHum.PlatformStand = true

-- create fake rig (workspace.non)
local Fake = Instance.new("Model")
Fake.Name = "non"
Fake.Parent = workspace

local function clonePart(name, size, color)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color or Color3.fromRGB(163, 162, 165)
	p.Material = Enum.Material.Plastic
	p.Anchored = false
	p.CanCollide = false
	p.Massless = true
	p.Parent = Fake
	return p
end

local Root = clonePart("HumanoidRootPart", Vector3.new(2, 2, 1), Color3.new(1,1,1))
Root.Transparency = 1
local Torso = clonePart("Torso", Vector3.new(2, 2, 1))
local Head = clonePart("Head", Vector3.new(1.2, 1.2, 1.2))
local RArm = clonePart("Right Arm", Vector3.new(1, 2, 1))
local LArm = clonePart("Left Arm", Vector3.new(1, 2, 1))
local RLeg = clonePart("Right Leg", Vector3.new(1, 2, 1))
local LLeg = clonePart("Left Leg", Vector3.new(1, 2, 1))

local Hum = Instance.new("Humanoid")
Hum.RigType = Enum.HumanoidRigType.R6
Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
Hum.Parent = Fake

-- basic welds
local function weld(p0, p1, c0, c1)
	local w = Instance.new("Weld")
	w.Part0 = p0
	w.Part1 = p1
	w.C0 = c0 or CFrame.new()
	w.C1 = c1 or CFrame.new()
	w.Parent = p0
	return w
end

local RJ = weld(Root, Torso)
local NK = weld(Torso, Head, CFrame.new(0, 1.5, 0))
local RS = weld(Torso, RArm, CFrame.new(1.5, 0.5, 0), CFrame.new(0, 0.5, 0))
local LS = weld(Torso, LArm, CFrame.new(-1.5, 0.5, 0), CFrame.new(0, 0.5, 0))
local RH = weld(Torso, RLeg, CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))
local LH = weld(Torso, LLeg, CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))

-- place fake at real character
Root.CFrame = RealChar.HumanoidRootPart.CFrame
Root.Anchored = true

-- Victim model (the second body)
local folder = game:GetObjects("rbxassetid://9206853840")[1]
folder.Parent = Fake
local Victim = folder.Victim
Victim.Parent = Fake

local Head2 = Victim:WaitForChild("Head")
local Torso2 = Victim:WaitForChild("Torso")
local LArm2 = Victim:WaitForChild("Left Arm")
local RArm2 = Victim:WaitForChild("Right Arm")
local LLeg2 = Victim:WaitForChild("Left Leg")
local RLeg2 = Victim:WaitForChild("Right Leg")
local Root2 = Victim:WaitForChild("HumanoidRootPart")

local function newMotor(P0, P1, C0, C1)
	local w = Instance.new("Weld")
	w.Part0 = P0
	w.Part1 = P1
	w.C0 = C0 or CFrame.new()
	w.C1 = C1 or CFrame.new()
	w.Parent = P0
	return w
end

local NK2 = newMotor(Torso2, Head2, CFrame.new(0, 1.5, 0))
local RJ2 = newMotor(Root2, Torso2)
local RH2 = newMotor(Torso2, RLeg2, CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))
local RS2 = newMotor(Torso2, RArm2, CFrame.new(1.5, 0.5, 0), CFrame.new(0, 0.5, 0))
local LH2 = newMotor(Torso2, LLeg2, CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))
local LS2 = newMotor(Torso2, LArm2, CFrame.new(-1.5, 0.5, 0), CFrame.new(0, 0.5, 0))

-- position controller
local PositionVal = Instance.new("StringValue")
PositionVal.Name = "Position2"
PositionVal.Value = "Doggy Style"
PositionVal.Parent = Fake

local PositionPart = folder:FindFirstChild("Position")
if PositionPart then
	PositionPart.Parent = Fake
end

-- state
local CF = {N = CFrame.new, A = CFrame.Angles}
local Attack = false
local NeutralAnims = true
local legAnims = true
local DoggoLoop, BJLoop, CowgirlLoop, GayLoop = false, false, false, false
local Position = "Doggy Style"
local Change = 1
local Sine = 0

-- artificial wait
local HB = Instance.new("BindableEvent")
local tf = 0
local frame = 1/60
RunService.Stepped:Connect(function(_, dt)
	tf = tf + dt
	if tf >= frame then
		HB:Fire()
		tf = 0
	end
end)
local function swait(n)
	if not n or n == 0 then HB.Event:Wait()
	else for _ = 0, n do HB.Event:Wait() end end
end

local function Sound(parent, id, pitch, vol)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Pitch = pitch or 1
	s.Volume = vol or 1
	s.Parent = parent
	s:Play()
	Debris:AddItem(s, 10)
	return s
end

-------------------------------------------------
-- POSITION LOOPS
-------------------------------------------------

function LoopDoggyStyle()
	NeutralAnims = false; legAnims = false; Attack = true
	local Countt = 1
	local zConn = UIS.InputBegan:Connect(function(io, gpe)
		if not gpe and io.KeyCode == Enum.KeyCode.Z then DoggoLoop = false end
	end)

	repeat
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, -0.2, -0.6) * CF.A(math.rad(10), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.3, 0.1, -0.5) * CF.A(math.rad(35), 0, math.rad(15)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0, -0.5) * CF.A(math.rad(35), 0, math.rad(-10)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0) * CF.A(math.rad(5), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -0.9, 0) * CF.A(math.rad(-25), 0, 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -0.9, 0) * CF.A(math.rad(-25), 0, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.7, -0.5) * CF.A(math.rad(-125), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.9, 1.3, -0.1) * CF.A(math.rad(-170), 0, math.rad(40)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1, 1.5, 0) * CF.A(math.rad(-160), 0, math.rad(-25)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.2, 0.7) * CF.A(math.rad(90.3), math.rad(-19.9), math.rad(1.8)), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.8, -0.1) * CF.A(math.rad(85), 0, math.rad(-5)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.7, -0.8, -0.1) * CF.A(math.rad(85), 0, math.rad(5)), A)
		end
		Sound(Torso2, 3099459397, math.random(10, 18)/10, 1.1).TimePosition = 4
		Countt += 1
		if Countt == 4 then
			Countt = 1
			local ids = {2440889605, 2440891382, 2440889869, 2440888376}
			Sound(Head2, ids[math.random(1, 4)], 1, 1)
		end
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, -0.1, -0.7) * CF.A(math.rad(-20), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.3, 0.2, -0.3) * CF.A(math.rad(65), 0, math.rad(15)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0.2, -0.4) * CF.A(math.rad(65), 0, math.rad(-10)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0) * CF.A(math.rad(-10), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -0.9, 0.1) * CF.A(math.rad(20), 0, 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, 0.1) * CF.A(math.rad(20), 0, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.7, -0.1) * CF.A(math.rad(-125), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.9, 1.3, -0.1) * CF.A(math.rad(-170), 0, math.rad(35)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1, 1.5, 0) * CF.A(math.rad(-160), 0, math.rad(-20)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.2, 0.7) * CF.A(math.rad(85), math.rad(-20), 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.8, 0) * CF.A(math.rad(110), 0, math.rad(-5)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.7, -0.9, 0) * CF.A(math.rad(110), 0, math.rad(5)), A)
		end
	until not DoggoLoop
	zConn:Disconnect()
	Attack = false; legAnims = true; NeutralAnims = true
end

function LoopBlowJob()
	NeutralAnims = false; legAnims = false; Attack = true
	local zConn = UIS.InputBegan:Connect(function(io, gpe)
		if not gpe and io.KeyCode == Enum.KeyCode.Z then BJLoop = false end
	end)
	repeat
		for i = 0, 20 do
			swait()
			local A = 0.1
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.4, 0.4, -0.4) * CF.A(math.rad(70.3), math.rad(-1.7), math.rad(19.9)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0.4, -0.4) * CF.A(math.rad(65.6), math.rad(3.4), math.rad(-19.7)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-20), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0) * CF.A(0, math.rad(10), 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.1, 0) * CF.A(math.rad(-160), 0, math.rad(-180)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.3, 0.8, -0.2) * CF.A(math.rad(114.4), math.rad(5.1), math.rad(14.1)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.3, 0.8, -0.3) * CF.A(math.rad(118.7), math.rad(-8.3), math.rad(-18.3)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.5, -1.1, -1) * CF.A(math.rad(-70), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.5, -1.1, -1) * CF.A(math.rad(-70), 0, math.rad(10)), A)
		end
		Sound(Torso2, 2767339245, math.random(10, 20)/10, 1.1).TimePosition = 8.4
		for i = 0, 20 do
			swait()
			local A = 0.1
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.4, 0.3, -0.5) * CF.A(math.rad(55.3), math.rad(-1.7), math.rad(19.9)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0.3, -0.5) * CF.A(math.rad(50.6), math.rad(3.4), math.rad(-19.7)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-25), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0) * CF.A(0, math.rad(10), 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.2, 0.1) * CF.A(math.rad(-150), 0, math.rad(-180)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.3, 0.4, 0) * CF.A(math.rad(119.4), math.rad(5.1), math.rad(14.1)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.3, 0.4, 0) * CF.A(math.rad(123.7), math.rad(-8.3), math.rad(-18.3)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, 0) * CF.A(math.rad(-10), 0, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.5, -0.8, -1.1) * CF.A(math.rad(-60), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.5, -0.8, -1.1) * CF.A(math.rad(-60), 0, math.rad(10)), A)
		end
	until not BJLoop
	zConn:Disconnect()
	Attack = false; legAnims = true; NeutralAnims = true
end

function LoopCowGirl()
	NeutralAnims = false; legAnims = false; Attack = true
	local Countt = 1
	local zConn = UIS.InputBegan:Connect(function(io, gpe)
		if not gpe and io.KeyCode == Enum.KeyCode.Z then CowgirlLoop = false end
	end)
	repeat
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, -2.2, -0.1) * CF.A(math.rad(70), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-0.8, 0.6, 0.5) * CF.A(math.rad(-162.9), 0, math.rad(45.2)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.2, 0.6, 0.6) * CF.A(math.rad(14.9), math.rad(-1.3), math.rad(-164.8)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0) * CF.A(math.rad(-5), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, -0.1) * CF.A(math.rad(15), 0, math.rad(-10)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, -0.1) * CF.A(math.rad(15), 0, math.rad(5)), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -0.7, 0.8) * CF.A(math.rad(-5), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.3, -0.1, 0) * CF.A(math.rad(-15), 0, math.rad(10)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.3, -0.1, 0) * CF.A(math.rad(-15), 0, math.rad(-10)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, -0.3) * CF.A(math.rad(-15), 0, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.7, -0.4, -0.8) * CF.A(math.rad(20), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.6, -0.5, -0.8) * CF.A(math.rad(20), 0, math.rad(10)), A)
		end
		Sound(Torso2, 3099459397, math.random(10, 18)/10, 1.1).TimePosition = 4
		Countt += 1
		if Countt == 4 then
			Countt = 1
			local ids = {2440889605, 2440891382, 2440889869, 2440888376}
			Sound(Head2, ids[math.random(1, 4)], 1, 1)
		end
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, -2.3, -0.1) * CF.A(math.rad(70), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-0.8, 0.6, 0.4) * CF.A(math.rad(-162.9), 0, math.rad(45.2)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.2, 0.6, 0.5) * CF.A(math.rad(14.9), math.rad(-1.3), math.rad(-164.8)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, -0.1) * CF.A(math.rad(20), 0, math.rad(-10)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, -0.1) * CF.A(math.rad(20), 0, math.rad(5)), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1, 0.8) * CF.A(math.rad(-5), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.3, 0.2, 0.1) * CF.A(math.rad(-30), 0, math.rad(10)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.3, 0.2, 0.1) * CF.A(math.rad(-30), 0, math.rad(-10)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(-0.1, 1.6, -0.3) * CF.A(math.rad(-30), 0, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.7, -0.2, -0.6) * CF.A(math.rad(30), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.6, -0.2, -0.6) * CF.A(math.rad(30), 0, math.rad(10)), A)
		end
	until not CowgirlLoop
	zConn:Disconnect()
	Attack = false; legAnims = true; NeutralAnims = true
end

function LoopGay()
	NeutralAnims = false; legAnims = false; Attack = true
	local Countt = 1
	local zConn = UIS.InputBegan:Connect(function(io, gpe)
		if not gpe and io.KeyCode == Enum.KeyCode.Z then GayLoop = false end
	end)
	repeat
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, -1.3) * CF.A(math.rad(15), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.2, 0.1, -0.5) * CF.A(math.rad(40), 0, math.rad(25)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.3, 0.1, -0.4) * CF.A(math.rad(50), 0, math.rad(-25)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-20), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0.1) * CF.A(math.rad(-35), 0, math.rad(-5)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.6, -1, 0.1) * CF.A(math.rad(-35), 0, math.rad(5)), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -2, -0.8) * CF.A(0, math.rad(-89.8), math.rad(90)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.8, 1.2, 0.1) * CF.A(math.rad(85), math.rad(0.9), math.rad(-4.9)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(0.1, 0.5, -0.8) * CF.A(math.rad(116.2), math.rad(3.2), math.rad(-39.9)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, -0.2) * CF.A(math.rad(-10.3), math.rad(-14.8), math.rad(-2.7)), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.9, -0.1) * CF.A(math.rad(15), 0, 0), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.8, -0.8, 0) * CF.A(math.rad(-12.4), math.rad(8.5), math.rad(85.9)), A)
		end
		Sound(Torso2, 3099459397, math.random(10, 18)/10, 1.1).TimePosition = 4
		Countt += 1
		if Countt == 4 then
			Countt = 1
			local ids = {2440889605, 2440891382, 2440889869, 2440888376}
			Sound(Head2, ids[math.random(1, 4)], 1, 1)
		end
		for i = 0, 10 do
			swait()
			local A = 0.3
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, -0.8), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.2, 0.3, -0.6) * CF.A(math.rad(55), 0, math.rad(25)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.3, 0.2, -0.5) * CF.A(math.rad(65), 0, math.rad(-25)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-20), 0, 0), A)
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0) * CF.A(0, 0, math.rad(-5)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.6, -1, 0) * CF.A(0, 0, math.rad(5)), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -2, -1.5) * CF.A(0, math.rad(-89.8), math.rad(90)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.8, 1.1, 0.1) * CF.A(math.rad(95), 0, math.rad(-5)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(0.1, 0.4, -0.8) * CF.A(math.rad(120), 0, math.rad(-40)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, -0.2) * CF.A(math.rad(-10.3), math.rad(-14.8), math.rad(-2.7)), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.9, -0.1) * CF.A(math.rad(15), 0, 0), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.9, -0.9, 0) * CF.A(math.rad(-12.4), math.rad(8.5), math.rad(55.9)), A)
		end
	until not GayLoop
	zConn:Disconnect()
	Attack = false; legAnims = true; NeutralAnims = true
end

-------------------------------------------------
-- INPUT
-------------------------------------------------

UIS.InputBegan:Connect(function(io, gpe)
	if gpe or Attack then return end
	if io.KeyCode == Enum.KeyCode.Z then
		if Position == "Doggy Style" then DoggoLoop = true; LoopDoggyStyle()
		elseif Position == "Blowjob" then BJLoop = true; LoopBlowJob()
		elseif Position == "Cowgirl" then CowgirlLoop = true; LoopCowGirl()
		elseif Position == "FuckMeSidewaysAndCallMeGay" then GayLoop = true; LoopGay() end
	elseif io.KeyCode == Enum.KeyCode.One then PositionVal.Value = "Doggy Style"
	elseif io.KeyCode == Enum.KeyCode.Two then PositionVal.Value = "Blowjob"
	elseif io.KeyCode == Enum.KeyCode.Three then PositionVal.Value = "Cowgirl"
	elseif io.KeyCode == Enum.KeyCode.Four then PositionVal.Value = "FuckMeSidewaysAndCallMeGay" end
end)

-------------------------------------------------
-- IDLE RENDER
-------------------------------------------------

RunService.Heartbeat:Connect(function()
	if not Fake.Parent then return end
	Sine += Change
	Position = PositionVal.Value
	local A = 0.3

	-- keep victim near
	if PositionPart and PositionPart:FindFirstChild("NewTorsoPos") then
		Root2.CFrame = PositionPart.NewTorsoPos.CFrame
	else
		Root2.CFrame = Root.CFrame * CFrame.new(0, 0, -1.5)
	end

	if Position == "Doggy Style" then
		if NeutralAnims then
			RJ.C0 = RJ.C0:lerp(CF.N(0, -0.1, -0.7) * CF.A(math.rad(-20), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.3, 0.2, -0.3) * CF.A(math.rad(65), 0, math.rad(15)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0.2, -0.4) * CF.A(math.rad(65), 0, math.rad(-10)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0) * CF.A(math.rad(-10), 0, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.7, -0.1) * CF.A(math.rad(-125), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.9, 1.3, -0.1) * CF.A(math.rad(-170), 0, math.rad(35)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1, 1.5, 0) * CF.A(math.rad(-160), 0, math.rad(-20)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.2, 0.7) * CF.A(math.rad(85), math.rad(-20), 0), A)
		end
		if legAnims then
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -0.9, 0.1) * CF.A(math.rad(20), 0, 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, 0.1) * CF.A(math.rad(20), 0, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.8, 0) * CF.A(math.rad(110), 0, math.rad(-5)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.7, -0.9, 0) * CF.A(math.rad(110), 0, math.rad(5)), A)
		end
	elseif Position == "Blowjob" then
		if NeutralAnims then
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.4, 0.4, -0.4) * CF.A(math.rad(70.3), math.rad(-1.7), math.rad(19.9)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.4, 0.4, -0.4) * CF.A(math.rad(65.6), math.rad(3.4), math.rad(-19.7)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-20), 0, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1.1, 0) * CF.A(math.rad(-160), 0, math.rad(-180)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.4, 0.4, -0.4) * CF.A(math.rad(70.3), math.rad(-1.7), math.rad(19.9)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.4, 0.4, -0.4) * CF.A(math.rad(65.6), math.rad(3.4), math.rad(-19.7)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, 0), A)
		end
		if legAnims then
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0) * CF.A(0, math.rad(10), 0), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, 0), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.5, -1.1, -1) * CF.A(math.rad(-70), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.5, -1.1, -1) * CF.A(math.rad(-70), 0, math.rad(10)), A)
		end
	elseif Position == "Cowgirl" then
		if NeutralAnims then
			RJ.C0 = RJ.C0:lerp(CF.N(0, -2.3, -0.1) * CF.A(math.rad(70), 0, 0), A)
			LS.C0 = LS.C0:lerp(CF.N(-0.8, 0.6, 0.4) * CF.A(math.rad(-162.9), 0, math.rad(45.2)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.2, 0.6, 0.5) * CF.A(math.rad(14.9), math.rad(-1.3), math.rad(-164.8)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -1, 0.8) * CF.A(math.rad(-5), 0, 0), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-1.3, 0.2, 0.1) * CF.A(math.rad(-30), 0, math.rad(10)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(1.3, 0.2, 0.1) * CF.A(math.rad(-30), 0, math.rad(-10)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(-0.1, 1.6, -0.3) * CF.A(math.rad(-30), 0, 0), A)
		end
		if legAnims then
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, -0.1) * CF.A(math.rad(20), 0, math.rad(-10)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.5, -1, -0.1) * CF.A(math.rad(20), 0, math.rad(5)), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.7, -0.2, -0.6) * CF.A(math.rad(30), 0, math.rad(-10)), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.6, -0.2, -0.6) * CF.A(math.rad(30), 0, math.rad(10)), A)
		end
	elseif Position == "FuckMeSidewaysAndCallMeGay" then
		if NeutralAnims then
			RJ.C0 = RJ.C0:lerp(CF.N(0, 0, -0.8), A)
			LS.C0 = LS.C0:lerp(CF.N(-1.2, 0.3, -0.6) * CF.A(math.rad(55), 0, math.rad(25)), A)
			RS.C0 = RS.C0:lerp(CF.N(1.3, 0.2, -0.5) * CF.A(math.rad(65), 0, math.rad(-25)), A)
			NK.C0 = NK.C0:lerp(CF.N(0, 1.5, -0.1) * CF.A(math.rad(-20), 0, 0), A)
			RJ2.C0 = RJ2.C0:lerp(CF.N(0, -2, -1.5) * CF.A(0, math.rad(-89.8), math.rad(90)), A)
			LS2.C0 = LS2.C0:lerp(CF.N(-0.8, 1.1, 0.1) * CF.A(math.rad(95), 0, math.rad(-5)), A)
			RS2.C0 = RS2.C0:lerp(CF.N(0.1, 0.4, -0.8) * CF.A(math.rad(120), 0, math.rad(-40)), A)
			NK2.C0 = NK2.C0:lerp(CF.N(0, 1.5, -0.2) * CF.A(math.rad(-10.3), math.rad(-14.8), math.rad(-2.7)), A)
		end
		if legAnims then
			LH.C0 = LH.C0:lerp(CF.N(-0.5, -1, 0) * CF.A(0, 0, math.rad(-5)), A)
			RH.C0 = RH.C0:lerp(CF.N(0.6, -1, 0) * CF.A(0, 0, math.rad(5)), A)
			LH2.C0 = LH2.C0:lerp(CF.N(-0.6, -0.9, -0.1) * CF.A(math.rad(15), 0, 0), A)
			RH2.C0 = RH2.C0:lerp(CF.N(0.9, -0.9, 0) * CF.A(math.rad(-12.4), math.rad(8.5), math.rad(55.9)), A)
		end
	end
end)

print("[Breadcrumb] ready — 1/2/3/4 change position, Z to start/stop")
