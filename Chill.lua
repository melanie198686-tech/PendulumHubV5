-- ============================================================
-- buggy as fuck boii
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer

-- Wait for a valid R6 character
local char
repeat task.wait() until Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Torso")
char = Player.Character

local Torso = char:WaitForChild("Torso")
local Head = char:WaitForChild("Head")
local Humanoid = char:WaitForChild("Humanoid")
local LeftArm = char:WaitForChild("Left Arm")
local LeftLeg = char:WaitForChild("Left Leg")
local RightArm = char:WaitForChild("Right Arm")
local RightLeg = char:WaitForChild("Right Leg")
local Face = Head:FindFirstChild("face")
local Neck = Torso:WaitForChild("Neck")
local RootPart = char:WaitForChild("HumanoidRootPart")
local RootJoint = RootPart:WaitForChild("RootJoint")

local it = Instance.new
local vt = Vector3.new
local cf = CFrame.new
local bc = BrickColor.new
local euler = CFrame.fromEulerAnglesXYZ
local angles = CFrame.Angles
local Rad = math.rad
local Cos, Sin = math.cos, math.sin

local necko = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local RootCF = euler(-1.57, 0, 3.14)

local attack = false
local equipped = false
local idle = 0
local Anim = "Idle"

--// rainbow helper (kept, though unused; harmless)
local function rainb(hue)
	local section = hue % 1 * 3
	local secondary = 0.5 * math.pi * (section % 1)
	if section < 1 then
		return Color3.new(1, 1 - math.cos(secondary), 1 - math.sin(secondary))
	elseif section < 2 then
		return Color3.new(1 - math.sin(secondary), 1, 1 - math.cos(secondary))
	else
		return Color3.new(1 - math.cos(secondary), 1 - math.sin(secondary), 1)
	end
end

--// Music
local Chillmusic = it("Sound", char)
Chillmusic.Name = "Chillmusic"
Chillmusic.Volume = 8
Chillmusic.SoundId = "rbxassetid://1221694420"
Chillmusic.Looped = true
Chillmusic:Play()

local Chillmusic2 = it("Sound", char)
Chillmusic2.Name = "Chillmusic2"
Chillmusic2.Volume = 8
Chillmusic2.SoundId = "rbxassetid://1221694420" -- fallback; original referenced this but never created it
Chillmusic2.Looped = true

--// Status Billboard
local txt = it("BillboardGui", char)
txt.Adornee = Head
txt.Name = "_status"
txt.Size = UDim2.new(2, 0, 1.2, 0)
txt.StudsOffset = Vector3.new(-9, 8, 0)
local text = it("TextLabel", txt)
text.Size = UDim2.new(10, 0, 7, 0)
text.TextScaled = true
text.TextTransparency = 0
text.BackgroundTransparency = 1
text.TextStrokeTransparency = 0
text.Font = Enum.Font.Arcade
text.TextStrokeColor3 = Color3.new(0, 0, 0)
text.TextColor3 = Color3.new(0, 100/255, 200/255)
text.Text = "~»Chill Af«~"

--// ColorBrick (visual anchor, invisible)
local v = it("Part", char)
v.Name = "ColorBrick"
v.Anchored = true
v.CanCollide = false
v.BottomSurface = Enum.SurfaceType.Smooth
v.TopSurface = Enum.SurfaceType.Smooth
v.Size = Vector3.new(10, 5, 3)
v.Transparency = 1
v.CFrame = Torso.CFrame
v.BrickColor = bc("Really black")

--// Colour tween loop
task.spawn(function()
	local Colours = {Color3.fromRGB(0,100,200), Color3.fromRGB(4,175,236)}
	local Int = 0
	while true do
		task.wait(2)
		Int = Int + 1
		if Int > #Colours then Int = 1 end
		TweenService:Create(text, TweenInfo.new(1), {TextColor3 = Colours[Int]}):Play()
	end
end)

--// Trails on each limb
local function makeTrail(limb)
	local trail = it("Trail", char)
	local a0 = it("Attachment", limb)
	a0.Name = "TrailAttachment0"
	a0.CFrame = CFrame.new(-0.25, -1, 0)
	local a1 = it("Attachment", limb)
	a1.Name = "TrailAttachment1"
	a1.CFrame = CFrame.new(0.25, -1, 0)
	trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
	trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.2, Color3.new(1,1,0)),
		ColorSequenceKeypoint.new(0.4, Color3.new(0,1,0)),
		ColorSequenceKeypoint.new(0.6, Color3.new(0,1,1)),
		ColorSequenceKeypoint.new(0.8, Color3.new(0,0,1)),
		ColorSequenceKeypoint.new(1, Color3.new(0,0,1)),
	})
	trail.Lifetime = 0.5
	trail.Attachment0 = a0
	trail.Attachment1 = a1
end
makeTrail(RightArm)
makeTrail(LeftArm)
makeTrail(RightLeg)
makeTrail(LeftLeg)

--// Math helpers
local function FindNearestTorso(Position, Distance, SinglePlayer)
	if SinglePlayer then
		return Distance > (SinglePlayer.Torso.CFrame.p - Position).Magnitude
	end
	local List = {}
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Torso") and v ~= char and Distance >= (v.Torso.Position - Position).Magnitude then
			table.insert(List, v)
		end
	end
	return List
end

local function lerp(a, b, t) return a + (b - a) * t end

local function slerp(a, b, t)
	local dot = a:Dot(b)
	if dot > 0.99999 or dot < -0.99999 then
		return t <= 0.5 and a or b
	else
		local r = math.acos(dot)
		return (a * math.sin((1 - t) * r) + b * math.sin(t * r)) / math.sin(r)
	end
end

local function clerp(a, b, t)
	local ax, ay, az = a.X, a.Y, a.Z
	local bx, by, bz = b.X, b.Y, b.Z
	local _t = 1 - t
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz, QuaternionSlerp(qa, qb, t))
end

function QuaternionFromCFrame(cf)
	local _,_,_, m00,m01,m02,m10,m11,m12,m20,m21,m22 = cf:components()
	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5
	else
		local i = 0
		if m00 < m11 then i = 1 end
		if m22 > (i == 0 and m00 or m11) then i = 2 end
		if i == 0 then
			local s = math.sqrt(m00-m11-m22+1)
			local recip = 0.5/s
			return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip
		elseif i == 1 then
			local s = math.sqrt(m11-m22-m00+1)
			local recip = 0.5/s
			return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip
		else
			local s = math.sqrt(m22-m00-m11+1)
			local recip = 0.5/s
			return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip
		end
	end
end

function QuaternionToCFrame(px, py, pz, x, y, z, w)
	local xs, ys, zs = x+x, y+y, z+z
	local wx, wy, wz = w*xs, w*ys, w*zs
	local xx, xy, xz = x*xs, x*ys, x*zs
	local yy, yz, zz = y*ys, y*zs, z*zs
	return CFrame.new(px, py, pz,
		1-(yy+zz), xy-wz, xz+wy,
		xy+wz, 1-(xx+zz), yz-wx,
		xz-wy, yz+wx, 1-(xx+yy))
end

function QuaternionSlerp(a, b, t)
	local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
	local startInterp, finishInterp
	if cosTheta >= 1e-4 then
		if 1 - cosTheta > 1e-4 then
			local theta = math.acos(cosTheta)
			local invSinTheta = 1 / math.sin(theta)
			startInterp = math.sin((1-t)*theta) * invSinTheta
			finishInterp = math.sin(t*theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	elseif 1 + cosTheta > 1e-4 then
		local theta = math.acos(-cosTheta)
		local invSinTheta = 1 / math.sin(theta)
		startInterp = math.sin((t-1)*theta) * invSinTheta
		finishInterp = math.sin(t*theta) * invSinTheta
	else
		startInterp = t - 1
		finishInterp = t
	end
	return a[1]*startInterp + b[1]*finishInterp,
	       a[2]*startInterp + b[2]*finishInterp,
	       a[3]*startInterp + b[3]*finishInterp,
	       a[4]*startInterp + b[4]*finishInterp
end

local function rayCast(Pos, Dir, Max, Ignore)
	return workspace:FindPartOnRay(Ray.new(Pos, Dir.Unit * (Max or 999.999)), Ignore)
end

--// Weld setup (shoulders)
local RSH = Torso:WaitForChild("Right Shoulder")
local LSH = Torso:WaitForChild("Left Shoulder")
RSH.Parent = nil
LSH.Parent = nil

local RW = it("Weld")
RW.Name = "Right Shoulder"
RW.Part0 = Torso
RW.C0 = cf(1.5, 0.5, 0)
RW.C1 = cf(0, 0.5, 0)
RW.Part1 = RightArm
RW.Parent = Torso

local LW = it("Weld")
LW.Name = "Left Shoulder"
LW.Part0 = Torso
LW.C0 = cf(-1.5, 0.5, 0)
LW.C1 = cf(0, 0.5, 0)
LW.Part1 = LeftArm
LW.Parent = Torso

local function newWeld(wp0, wp1, wc0x, wc0y, wc0z)
	local wld = it("Weld", wp1)
	wld.Part0 = wp0
	wld.Part1 = wp1
	wld.C0 = CFrame.new(wc0x, wc0y, wc0z)
	return wld
end
newWeld(RootPart, Torso, 0, -1, 0)
Torso.Weld.C1 = CFrame.new(0, -1, 0)
newWeld(Torso, LeftLeg, -0.5, -1, 0)
LeftLeg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(Torso, RightLeg, 0.5, -1, 0)
RightLeg.Weld.C1 = CFrame.new(0, 1, 0)

--// Disable default animator if present
local animator = Humanoid:FindFirstChildOfClass("Animator")
if animator then animator.Parent = nil end

--// Simple heartbeat replacement
local function swait(num)
	if num == 0 or num == nil then
		RunService.Stepped:Wait()
	else
		for i = 0, num do RunService.Stepped:Wait() end
	end
end

--// A ForceField (invisible) - note: ForceField has no Visible property
local ff = it("ForceField", char)

Humanoid.WalkSpeed = 4

--// Shift to sprint
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Humanoid.WalkSpeed = 40
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Humanoid.WalkSpeed = 4
	end
end)

--// Keybinds via UserInputService (replaces Mouse.KeyDown)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.C then
		-- fade chill music, play chillmusic2
		while Chillmusic.Volume > 0 do
			task.wait()
			Chillmusic.Volume = math.max(0, Chillmusic.Volume - 0.05)
		end
		Chillmusic:Stop()
		Chillmusic2:Play()
		Chillmusic.Volume = 1
	elseif key == Enum.KeyCode.V then
		while Chillmusic2.Volume > 0 do
			task.wait()
			Chillmusic2.Volume = math.max(0, Chillmusic2.Volume - 0.05)
		end
		Chillmusic2:Stop()
		Chillmusic:Play()
		Chillmusic2.Volume = 1
	elseif key == Enum.KeyCode.F then
		text.Text = "Guys why not just chill?"; task.wait(1)
		text.Text = "It's just the way life should be."; task.wait(1)
		text.Text = "Chill is life."; task.wait(1)
		text.Text = "Chill is love."; task.wait(1)
		text.Text = "Chill is for the best."; task.wait(1)
		text.Text = "Maybe if you were chill you wouldn't be a skid..."; task.wait(3)
		text.Text = "But some people cant handle the chill can they."; task.wait(3)
		text.Text = "Chill Af"
	elseif key == Enum.KeyCode.B then
		text.Text = "Be back scrubs."; task.wait(1)
		text.Text = "Afk nibba..."
	elseif key == Enum.KeyCode.N then
		text.Text = "K back you nubs's!"; task.wait(1)
		text.Text = "Chill Af"
	end
end)

--// Animation loop
local sine = 0
local change = 1
local hitfloor

task.spawn(function()
	while true do
		swait()
		sine = sine + change
		local torvel = (RootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude
		hitfloor = rayCast(RootPart.Position, cf(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 4, char)
		if attack == false then
			idle = idle + 1
			Humanoid.MaxHealth = math.huge
			Humanoid.Health = math.huge
		else
			idle = 0
		end

		if torvel < 1 and hitfloor ~= nil then
			Anim = "Chill"
			if attack == false then
				Humanoid.CameraOffset = Vector3.new(0, 10.25 - 5.45 * Cos(sine / 65), 0)
				Torso.Weld.C0 = clerp(Torso.Weld.C0, CFrame.new(0, 10.25 - 5.45 * Cos(sine / 65), 0) * CFrame.Angles(Rad(90 + 15 * Sin(sine / 60)), Rad(0), Rad(0)), 0.8)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(Rad(-20 + 20 * Cos(sine / 60)), Rad(0 + 4 * Sin(sine / 60)), Rad(0)), 0.2)
				RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(Rad(-90 + 25 * Cos(sine / 60)), Rad(0 + 20 * Sin(sine / 60)), Rad(0 + 55 * Sin(sine / 60))), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(Rad(-90 + 25 * Cos(sine / 60)), Rad(-20 - 20 * Sin(sine / 60)), Rad(0 - 55 * Sin(sine / 60))), 0.3)
				LeftLeg.Weld.C0 = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -0.86 + 0.03 * Cos(sine / 65), -0.4) * CFrame.Angles(Rad(15 - 45 * Cos(sine / 70)), Rad(3), Rad(-4)), 0.8)
				RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1 + 0.05 * Cos(sine / 65), -0.4) * CFrame.Angles(Rad(15 - 35 * Cos(sine / 65)), Rad(-3), Rad(4)), 0.8)
			end
		elseif torvel > 2 and torvel < 22 and hitfloor ~= nil then
			Anim = "Walk"
			if attack == false then
				Humanoid.CameraOffset = Vector3.new(0, 6 - 2.55 * Cos(sine / 48.5), 0)
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 0, 0) * angles(Rad(5), Rad(0), Rad(0)), 0.2)
				Torso.Weld.C0 = clerp(Torso.Weld.C0, CFrame.new(0, 6 - 2.55 * Cos(sine / 48.5), 0) * CFrame.Angles(Rad(-90 + 5 * Cos(sine / 45)), Rad(180 * Cos(sine / 48.5)), Rad(0)), 0.8)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(Rad(-4 + 2 * Sin(sine / 48)), Rad(0), Rad(0)), 0.2)
				RW.C0 = clerp(RW.C0, cf(1.5, 0.5 + 0.1 * Cos(sine / 45), 0) * angles(Rad(90), Rad(0), Rad(90 - 20.5 * Cos(sine / 45))), 0.3)
				LW.C0 = clerp(LW.C0, cf(-1.5, 0.5 + 0.1 * Cos(sine / 45), 0) * angles(Rad(90), Rad(0), Rad(-90 + 20.5 * Cos(sine / 45))), 0.3)
				LeftLeg.Weld.C0 = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -1 - 0.05 * Cos(sine / 45), 0) * CFrame.Angles(Rad(0), Rad(3), Rad(-4)), 0.8)
				RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1 + 0.05 * Cos(sine / 45), 0) * CFrame.Angles(Rad(0), Rad(-3), Rad(4)), 0.8)
			end
		elseif torvel >= 22 and hitfloor ~= nil then
			Anim = "Run"
			if attack == false then
				Humanoid.CameraOffset = Vector3.new(0, 6 - 1.55 * Cos(sine / 68.5), 0)
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cf(0, 6 - 1.55 * Cos(sine / 68.5), -0.2) * angles(Rad(50), Rad(0), Rad(0)), 0.2)
				Torso.Weld.C0 = clerp(Torso.Weld.C0, CFrame.new(0, 6 - 1.55 * Cos(sine / 68.5), 0) * CFrame.Angles(Rad(-40 + 20 * Sin(sine / 68.5)), 0, 0), 0.8)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, necko * angles(Rad(-12 + 17 * Cos(sine / 68.5)), Rad(0), Rad(0)), 0.2)
				RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(Rad(-90), Rad(0), Rad(40 - 20 * Cos(sine / 68.5))), 0.2)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(Rad(-90), Rad(0), Rad(-40 + 20 * Cos(sine / 68.5))), 0.2)
				LeftLeg.Weld.C0 = clerp(LeftLeg.Weld.C0, CFrame.new(-0.5, -0.87, -0.25) * CFrame.Angles(Rad(-45 - 10 * Cos(sine / 68.5)), Rad(0), Rad(0)), 0.8)
				RightLeg.Weld.C0 = clerp(RightLeg.Weld.C0, CFrame.new(0.5, -1, -0.1) * CFrame.Angles(Rad(-35 - 10 * Cos(sine / 68.5)), Rad(0), Rad(0)), 0.8)
			end
		end
	end
end)

-- ============================================================
-- GUI
-- ============================================================
local PlayerGui = Player:WaitForChild("PlayerGui")
local Chill_Gui_Bro = it("ScreenGui", PlayerGui)
Chill_Gui_Bro.Name = "Chill_Gui_Bro"

local Header = it("Frame", Chill_Gui_Bro)
Header.Name = "Header"
Header.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
Header.BorderSizePixel = 0
Header.Active = true
Header.Selectable = true
Header.Draggable = true
Header.Position = UDim2.new(0.469539374, 0, 0.147921771, 0)
Header.Size = UDim2.new(0, 250, 0, 45)

local BackGround = it("Frame", Header)
BackGround.Name = "BackGround"
BackGround.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
BackGround.BorderSizePixel = 0
BackGround.Draggable = true
BackGround.Position = UDim2.new(0, 0, 1, 0)
BackGround.Size = UDim2.new(0, 250, 0, 299)

local Chill_Gui_Label = it("TextLabel", Header)
Chill_Gui_Label.Name = "Chill_Gui_Label"
Chill_Gui_Label.BackgroundTransparency = 1
Chill_Gui_Label.BorderSizePixel = 0
Chill_Gui_Label.Draggable = true
Chill_Gui_Label.Size = UDim2.new(0, 250, 0, 45)
Chill_Gui_Label.Font = Enum.Font.Arcade
Chill_Gui_Label.Text = "~»Chill Gui«~"
Chill_Gui_Label.TextColor3 = Color3.new(1, 1, 1)
Chill_Gui_Label.TextScaled = true

local function makeButton(name, text, pos)
	local b = it("TextButton", Header)
	b.Name = name
	b.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
	b.BorderColor3 = Color3.new(0, 0, 0)
	b.BorderSizePixel = 0
	b.Position = pos
	b.Size = UDim2.new(0, 68, 0, 35)
	b.Font = Enum.Font.Arcade
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 20
	b.TextWrapped = true
	return b
end

local function makeBox(name, placeholder, pos, sizeX, sizeText)
	local t = it("TextBox", Header)
	t.Name = name
	t.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
	t.BorderColor3 = Color3.new(0, 0, 0)
	t.BorderSizePixel = 0
	t.Position = pos
	t.Size = UDim2.new(0, sizeX, 0, 35)
	t.Font = Enum.Font.Arcade
	t.Text = placeholder
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextSize = sizeText
	t.TextWrapped = true
	return t
end

local Play_ID_Button = makeButton("Play_ID_Button", "Play ID", UDim2.new(0.052, 0, 1.222, 0))
local ID_Box = makeBox("ID_Box", "ID here", UDim2.new(0.356, 0, 1.222, 0), 140, 35)
local Set_Vol_Button = makeButton("Set_Vol_Button", "Set Vol", UDim2.new(0.052, 0, 2.200, 0))
local Vol_Box = makeBox("Vol_Box", "Volume", UDim2.new(0.356, 0, 2.200, 0), 140, 35)
local Set_Tpos_Button = makeButton("Set_Tpos_Button", "Set Tpos", UDim2.new(0.052, 0, 3.244, 0))
local Tpos_Box = makeBox("Tpos_Box", "Time Position", UDim2.new(0.356, 0, 3.244, 0), 140, 20)
local Set_Text_Button = makeButton("Set_Text_Button", "Set Text", UDim2.new(0.060, 0, 4.222, 0))
local Text_Box = makeBox("Text_Box", "Text", UDim2.new(0.356, 0, 4.222, 0), 140, 20)
local Toggle_Chat_Button = it("TextButton", Header)
Toggle_Chat_Button.Name = "Toggle_Chat_Button"
Toggle_Chat_Button.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
Toggle_Chat_Button.BorderColor3 = Color3.new(0, 0, 0)
Toggle_Chat_Button.BorderSizePixel = 0
Toggle_Chat_Button.Position = UDim2.new(0.058, 0, 5.266, 0)
Toggle_Chat_Button.Size = UDim2.new(0, 97, 0, 35)
Toggle_Chat_Button.Font = Enum.Font.Arcade
Toggle_Chat_Button.Text = "Toggle Chat"
Toggle_Chat_Button.TextColor3 = Color3.new(1, 1, 1)
Toggle_Chat_Button.TextSize = 20

local Chat_Toggle_Label = it("TextLabel", Header)
Chat_Toggle_Label.Name = "Chat_Toggle_Label"
Chat_Toggle_Label.BackgroundColor3 = Color3.new(1, 1, 1)
Chat_Toggle_Label.BackgroundTransparency = 0.9
Chat_Toggle_Label.BorderColor3 = Color3.new(1, 1, 1)
Chat_Toggle_Label.Position = UDim2.new(0.540, 0, 5.266, 0)
Chat_Toggle_Label.Size = UDim2.new(0, 94, 0, 35)
Chat_Toggle_Label.Font = Enum.Font.Arcade
Chat_Toggle_Label.Text = "~»False«~"
Chat_Toggle_Label.TextColor3 = Color3.new(1, 1, 1)
Chat_Toggle_Label.TextScaled = true

local Current_Song_Label = it("TextLabel", Header)
Current_Song_Label.Name = "Current_Song_Label"
Current_Song_Label.BackgroundColor3 = Color3.new(1, 1, 1)
Current_Song_Label.BackgroundTransparency = 0.9
Current_Song_Label.BorderColor3 = Color3.new(1, 1, 1)
Current_Song_Label.Position = UDim2.new(0.052, 0, 6.644, 0)
Current_Song_Label.Size = UDim2.new(0, 225, 0, 35)
Current_Song_Label.Font = Enum.Font.Arcade
Current_Song_Label.Text = "~»Current Song: None«~"
Current_Song_Label.TextColor3 = Color3.new(1, 1, 1)
Current_Song_Label.TextScaled = true

Play_ID_Button.MouseButton1Down:Connect(function()
	local id = tonumber(ID_Box.Text)
	if id then
		Chillmusic:Stop()
		Chillmusic.SoundId = "rbxassetid://" .. id
		Chillmusic:Play()
		local ok, info = pcall(function() return MarketplaceService:GetProductInfo(id) end)
		if ok and info then
			text.Text = "~»Chill Af«~ Now Playing: " .. info.Name
			Current_Song_Label.Text = "~»Current Song: " .. info.Name .. "«~"
			task.wait(4)
			text.Text = "~»Fell Apart AF«~"
		end
	end
end)

Set_Vol_Button.MouseButton1Down:Connect(function()
	local v2 = tonumber(Vol_Box.Text)
	if v2 then Chillmusic.Volume = v2 end
end)

Set_Tpos_Button.MouseButton1Down:Connect(function()
	local v3 = tonumber(Tpos_Box.Text)
	if v3 then Chillmusic.TimePosition = v3 end
end)

Set_Text_Button.MouseButton1Down:Connect(function()
	text.Text = "~»" .. Text_Box.Text .. "«~"
end)

local ischatting = false
Toggle_Chat_Button.MouseButton1Down:Connect(function()
	ischatting = not ischatting
	Chat_Toggle_Label.Text = ischatting and "~»True«~" or "~»False«~"
end)

Player.Chatted:Connect(function(msg)
	if ischatting then
		task.spawn(function()
			for i = 0, msg:len() do
				text.Text = "~»" .. msg:sub(1, i) .. "«~"
				task.wait()
			end
			task.wait(3)
			text.Text = "~»Fell Apart AF«~"
		end)
	end
end)
