local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local SongID = "http://www.roblox.com/asset/?id=198665867"

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Character = getCharacter()
local head = Character:WaitForChild("Head")
local tors = Character:WaitForChild("Torso")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.DisplayName = " "
Humanoid.JumpPower = 80

local function makesound(soundid, speed, volume, parent)
	local sound = Instance.new("Sound")
	sound.SoundId = soundid
	sound.RollOffMaxDistance = 100
	sound.PlaybackSpeed = speed
	sound.Volume = volume
	sound.Parent = parent
	return sound
end

local function swait()
	RunService.Stepped:Wait()
end

local CF = CFrame.new
local CFA = CFrame.Angles

local neck = Instance.new("Weld")
neck.Part0 = tors
neck.Part1 = head
neck.C0 = CF(0, 1.5, 0)
neck.Parent = tors
local nek = neck.C1
neck.Enabled = true

local root = RootPart:WaitForChild("RootJoint").C0
local rs = tors:WaitForChild("Right Shoulder").C0
local ls = tors:WaitForChild("Left Shoulder").C0
local rh = tors:WaitForChild("Right Hip").C0
local lh = tors:WaitForChild("Left Hip").C0

local Attacking = false

local function rayCast(Pos, Dir, Max)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { Character }
	local result = workspace:Raycast(Pos, Dir.Unit * (Max or 999.999), params)
	return result and result.Instance or nil
end

local Tail = Character:FindFirstChild("Tail")
local TailWeld
if Tail ~= nil and Tail:FindFirstChild("AccessoryWeld") then
	TailWeld = Tail.AccessoryWeld
else
	TailWeld = Instance.new("Weld")
	TailWeld.Parent = tors
end
local TC0 = TailWeld.C0 * CF(0, 0, 0.4)

local Song = Instance.new("Sound")
Song.SoundId = SongID
Song.Looped = true
Song.Parent = RootPart
Song:Play()

local Running = false

local function LerpStyle(lerpmagnet, easingstyle, easingdirection)
	return TweenService:GetValue(lerpmagnet, easingstyle, easingdirection)
end

local function SpinKick()
	if Attacking == false then
		Attacking = true
		for _ = 0, 60, 1 do
			swait()
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(30), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, 0, math.rad(-20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(-30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
		end

		for i = 0, 60, 1 do
			swait()
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(-20 + -36 * i), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, math.rad(30), math.rad(40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, math.rad(-30), math.rad(-40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(50)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
		end
		Attacking = false
	end
end

local ComboCont = 1
local function Attack()
	if Attacking == false then
		Attacking = true
		if ComboCont == 1 then
			for _ = 0, 10, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(-30), 0, math.rad(80)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0.5, 0, -1.2) * CFA(0, math.rad(90), math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end

			for _ = 0, 15, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0) * CFA(0, 0, 0), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0.5, 0, 0) * CFA(0, math.rad(-85), math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(20)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(40)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end
			ComboCont = 2

		elseif ComboCont == 2 then
			for _ = 0, 10, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, math.rad(90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(-30), 0, math.rad(90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, 0, math.rad(-12)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end

			for _ = 0, 10, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, math.rad(-90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0) * CFA(0, 0, math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, 0, math.rad(-12)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0.5) * CFA(0, math.rad(90), math.rad(-90)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(10)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(30)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end
			ComboCont = 3

		elseif ComboCont == 3 then
			for _ = 0, 10, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(10), 0, math.rad(-50)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, 0, math.rad(-5)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(8)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, math.rad(-50), math.rad(-98)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, math.rad(20), 0), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end

			for _ = 0, 15, 1 do
				swait()
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, math.rad(90), 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -3, 0) * CFA(math.rad(-40), 0, math.rad(90)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, 0, math.rad(-5)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, 0, math.rad(8)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, math.rad(90), math.rad(-50)), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, math.rad(-90), 0), LerpStyle(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end
			ComboCont = 1
		end
		Attacking = false
	end
end

local Mouse = LocalPlayer:GetMouse()
local B1Hold = false

Mouse.Button1Down:Connect(function()
	B1Hold = true
	while B1Hold do
		task.wait()
		Attack()
	end
end)

Mouse.Button1Up:Connect(function()
	B1Hold = false
end)

Mouse.KeyDown:Connect(function(key)
	if key == "z" then
		SpinKick()
	elseif key == "t" and Attacking == false then
		Attacking = true
		makesound("rbxassetid://6433451653", 1, 1, tors):Play()
		for _ = 0, 100 do
			swait()
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(math.rad(-15 + math.rad(math.sin(time() * 16) * 15)), 0, 0), LerpStyle(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(-10 + math.sin(time() * 16) * 10), 0, 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0.4 + math.sin(time() * 17) * 0.4, 0) * CFA(0, math.rad(90), math.rad(123)), LerpStyle(0.07, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(math.rad(10), 0, math.rad(-90)), LerpStyle(0.07, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, math.rad(-30 + math.sin(time() * 17) * 20), math.rad(-10 + math.sin(time() * 16) * 10)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(10 + math.sin(time() * 16) * -10)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-20 + math.sin(-time() * 3.83) * -20), math.rad(-math.sin(time() * 3.83 / 2) * 24), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
		end
		Attacking = false
	elseif key == "r" and Attacking == false then
		Attacking = true
		while Humanoid.MoveDirection.Magnitude < 0.1 do
			swait()
			neck.C1 = neck.C1:Lerp(nek * CF(0, -0.4, 0) * CFA(math.rad(-90), math.rad(-math.cos(time() * 3) * 30), 0), LerpStyle(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, -2.5) * CFA(math.rad(78), math.rad(math.sin(time() * 3) * 12), math.rad(math.rad(math.sin(time() * 3) * 40))), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0.3, 0.8 + math.sin(time() * 3) * 0.2, -0.6 + math.sin(time() * 3) * 0.2) * CFA(math.rad(-45) + math.rad(math.sin(time() * 3) * 12), 0, math.rad(170 + math.cos(time() * 3) * 5)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(-0.3, 0.8 - math.sin(time() * 3) * 0.2, -0.6 + math.sin(time() * 3) * 0.2) * CFA(math.rad(-45) - math.rad(math.sin(time() * 3) * 12), 0, math.rad(-170 + math.cos(time() * 3) * 5)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(math.rad(-math.sin(time() * 3) * 12), math.rad(math.sin(time() * 3) * 30), math.rad(-62 + math.cos(time() * 3) * 30)), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(math.rad(-math.sin(time() * 3) * 12), math.rad(math.sin(time() * 3) * 30), math.rad(62 + math.cos(time() * 3) * 30)), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(0, 0, math.rad(math.cos(time() * 3) * 40)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
		end
		Attacking = false
	elseif key == "f" then
		Running = not Running
		Humanoid.WalkSpeed = Running and 40 or 20
	elseif key == "x" and Attacking == false then
		local targetPart = Mouse.Target
		local Target = targetPart and targetPart.Parent
		local targetHum = Target and Target:FindFirstChildWhichIsA("Humanoid")
		local targetHrp = Target and Target:FindFirstChild("HumanoidRootPart")
		if targetHum and targetHrp then
			Attacking = true
			local Camera = workspace.CurrentCamera
			local prevType = Camera.CameraType
			Camera.CameraType = Enum.CameraType.Scriptable

			for _ = 0, 200, 1 do
				swait()
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((head.CFrame * CFrame.new(0, 0, -5)).Position, head.CFrame.Position), 1)
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(math.rad(20), 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(20), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, -0.5, 0) * CFA(math.rad(-25), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, -0.5, 0) * CFA(math.rad(-25), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end

			for _ = 0, 20, 1 do
				swait()
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((head.CFrame * CFrame.new(0, 0, -3)).Position, head.CFrame.Position), 1)
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(20), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, -0.5, 0) * CFA(math.rad(-40), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, -0.5, 0) * CFA(math.rad(-40), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end

			for _ = 0, 100, 1 do
				swait()
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new((head.CFrame * CFrame.new(-3, 0, 0)).Position, targetHrp.CFrame.Position), 0.2)
				neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(math.rad(20), 0, 0), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, -0.5, 0) * CFA(math.rad(-80), 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, -0.5, 0) * CFA(math.rad(-80), 0, math.rad(20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, 0, 0) * CFA(0, 0, math.rad(-20)), LerpStyle(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
				tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, 0, 0) * CFA(0, 0, math.rad(-24)), LerpStyle(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end
			Attacking = false
			Camera.CameraType = prevType
		end
	end
end)

local RLA = CFrame.new(0, 0, 0)
local LLA = CFrame.new(0, 0, 0)
local RAA = CFrame.new(0, 0, 0)
local LAA = CFrame.new(0, 0, 0)
local Anim = "Idle"

Humanoid.WalkSpeed = 20

while true do
	swait()
	local moveDir = Humanoid.MoveDirection
	local hitfloor = rayCast(RootPart.Position, CF(RootPart.Position, RootPart.Position - Vector3.new(0, 0.5, 0)).LookVector, 4)
	local torvel = (moveDir * Vector3.new(1, 0, 1)).Magnitude

	if RootPart.AssemblyLinearVelocity.Y > 0 and hitfloor == nil then
		Anim = "Jumping"
	elseif RootPart.AssemblyLinearVelocity.Y < 0 and hitfloor == nil then
		Anim = "Falling"
	elseif torvel < 0.5 and hitfloor ~= nil then
		Anim = "Idle"
	elseif torvel > 0.5 and hitfloor ~= nil then
		Anim = "Walking"
	end

	local W1 = moveDir * RootPart.CFrame.LookVector
	local W2 = moveDir * RootPart.CFrame.RightVector
	local WVA = W1.X + W1.Z
	local RLV = W2.X + W2.Z
	local rotY = RootPart.AssemblyAngularVelocity.Y

	if Attacking == false then
		if Anim == "Falling" then
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0.3) * CFA(math.rad(20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(math.rad(-40), 0, math.rad(5)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(math.rad(-40), 0, math.rad(-5)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0.4, 0.8, 0) * CFA(0, 0, math.rad(10)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0.4, 0.5, 0) * CFA(0, 0, math.rad(50)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
		elseif Anim == "Jumping" then
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0.3) * CFA(math.rad(-20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, 0) * CFA(0, 0, 0), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0, 0, 0) * CFA(0, math.rad(-40), math.rad(-20)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0, 0, 0) * CFA(0, math.rad(40), math.rad(20)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0.4, 0.8, 0) * CFA(0, 0, math.rad(-10)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0.4, 0.5, 0) * CFA(0, 0, math.rad(-50)), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
		elseif Anim == "Idle" then
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(math.rad(7 + math.cos(time() * 3.83) * -5 + (-6 + math.sin(time() * 3.83) * 6)), math.rad(-24) + math.rad(math.sin((time() * 3.83) / 2) * 10), math.rad(-math.cos((time() * 3.83) / 2) * 13)), LerpStyle(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, 0, math.cos((time() * 3.83)) / 10) * CFA(0, 0, 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(-0.1, math.cos((time() * 3.83)) / 10, 0) * CFA(math.rad(-5) - -math.sin((-time() * 3.83)) / 8.7, 0, math.rad(5) + math.cos((-time() * 3.83)) / 8.7), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(0.1, math.cos((time() * 3.83)) / 10, 0) * CFA(math.rad(-5) - -math.sin((-time() * 3.83)) / 8.7, 0, math.rad(-5) - math.cos((-time() * 3.83)) / 8.7), LerpStyle(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, -math.cos((time() * 3.83)) / 8, 0) * CFA(math.rad(-4), math.rad(-12), math.rad(8)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, -math.cos((time() * 3.83)) / 8, 0) * CFA(math.rad(-1), math.rad(7), math.rad(2)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-20 + math.sin(-time() * 3.83) * -20), math.rad(-math.sin(time() * 3.83 / 2) * 24), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
		elseif Anim == "Walking" and Running == false then
			RLA = CF((math.sin((time() * 8)) / 1) * 0.5 * WVA, 0.3 * (1 - WVA), (math.sin((time() * 8)) / 1) * 0.5 * RLV) * CFA((-math.sin((time() * 8)) / 1.5) * RLV, 0, (math.sin((time() * 8)) / 1.2) * WVA)
			LLA = RLA
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(math.rad(7), math.clamp(math.cos((time() * 8)) * 0.2 + math.rad(-rotY * 8), math.rad(-85), math.rad(85)), math.rad(-rotY * 0.4)), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF(0, -math.sin((time() * 8 * 2)) / 3.2, -math.sin((time() * 8 * 2)) / 3) * CFA(math.rad(-5 + WVA * 15) + -math.rad(math.sin(time() * 16) * 10), math.clamp(-(-rotY / 50), math.rad(-20), math.rad(20)), math.cos((time() * 8)) * 0.2), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(-math.sin((time() * 8)) / 4.5, 0, 0) * CFA(math.rad(-5), -math.sin((time() * 8)) * 0.1 + math.rad(rotY * 3), -math.sin((time() * 8)) * 0.4), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(-math.sin((time() * 8)) / 4.5, 0, 0) * CFA(math.rad(-5), -math.sin((time() * 8)) * 0.1 + math.rad(rotY * 3), -math.sin((time() * 8)) * 0.4), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0, math.cos((time() * 8)) / 8, 0) * RLA * CFA(0, (-math.sin((time() * 8)) * 0.5) * WVA, math.rad(-5 + WVA * 15) + -math.rad(math.sin(time() * 16) * 10)), LerpStyle(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(0, -math.cos((time() * 8)) / 8, 0) * LLA * CFA(0, (-math.sin((time() * 8)) * 0.5) * WVA, -math.rad(-5 + WVA * 15) + math.rad(math.sin(time() * 16) * 10)), LerpStyle(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFA(math.rad(-30 + math.sin(-time() * 8) * -20), 0, -math.rad(-math.sin(time() * 8 / 2) * 20 + RLV * 2)), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
		elseif Anim == "Walking" and Running == true then
			RLA = CF(0, (0.5 + math.cos(time() * 15) * 0.5) * WVA + 0.2, (0.5 - math.cos(time() * 15) * 0.5) * RLV + 0.2) * CFA(0, -math.rad(math.sin(time() * 15) * 80) * RLV, math.rad(math.sin(time() * 15) * 80) * WVA)
			LLA = CF(0, (0.5 + math.cos(time() * 15) * 0.5) * WVA - 0.2, (-0.5 + math.cos(time() * 15) * 0.5) * RLV - 0.2) * CFA(0, -math.rad(math.sin(time() * 15) * 80) * RLV, math.rad(-math.sin(time() * 15) * 80) * WVA)
			RAA = CF(0, 0.8 + math.sin(time() * 15) * 0.9 * WVA, math.sin(time() * 15) * 0.9 * RLV) * CFA(0, math.rad(-math.cos(time() * 15) * 85) * RLV, math.rad(math.cos(time() * 15) * 85) * WVA)
			LAA = CF(0, 0.8 + math.sin(time() * 15) * 0.9 * WVA, math.sin(time() * 15) * 0.9 * -RLV) * CFA(0, math.rad(-math.cos(time() * 15) * 85) * RLV, math.rad(-math.cos(time() * 15) * 85) * WVA)
			neck.C1 = neck.C1:Lerp(nek * CF(0, 0, 0) * CFA(0, math.rad(-rotY * 5), 0), LerpStyle(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			RootPart.RootJoint.C0 = RootPart.RootJoint.C0:Lerp(root * CF((-1 - math.sin(time() * 15) * 2) * RLV, (-1 - math.sin(time() * 15) * 2) * WVA, -0.5 - math.sin(time() * 15) * 0.8) * CFA(math.rad(80 - math.cos(time() * 15) * 20), 0, 0), LerpStyle(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Shoulder"].C0 = tors["Right Shoulder"].C0:Lerp(rs * CF(0.6 + math.sin(time() * 15), 0, -0.6) * RAA * CFA(math.rad(-10 - -math.cos(time() * 30) * 10), 0, math.rad(80)), LerpStyle(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Left Shoulder"].C0 = tors["Left Shoulder"].C0:Lerp(ls * CF(-0.6 + -math.sin(time() * 15), 0, -0.6) * LAA * CFA(math.rad(-10 - -math.cos(time() * 30) * 10), 0, math.rad(-80)), LerpStyle(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
			tors["Right Hip"].C0 = tors["Right Hip"].C0:Lerp(rh * CF(0.4 + -math.cos(time() * 15) * 0.9, 0, 0) * RLA * CFA(0, 0, math.rad(50)), LerpStyle(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			tors["Left Hip"].C0 = tors["Left Hip"].C0:Lerp(lh * CF(-0.4 + math.cos(time() * 15) * 0.9, 0, 0) * LLA * CFA(0, 0, math.rad(-80)), LerpStyle(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
			TailWeld.C0 = TailWeld.C0:Lerp(TC0 * CFrame.new(0, 0.7, 0.3) * CFrame.Angles(math.rad(-110 + math.sin(-time() * 15) * -20), -math.rad(RLV * 30), 0), LerpStyle(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut))
		end
	end
end
