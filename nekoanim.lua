--[[
	Neko v4 (FULLY FIXED)
	Original converted by padero#0001
    Fixed by feyz
]]

-- FIX: Mock getgenv if not in an executor
if not getgenv then getgenv = function() return _G end end

-- FIX: Safely load the reanimation script
local reanimateSuccess = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/newnetlessreanimate.lua",true))()
end)
if not reanimateSuccess then warn("[Neko] Failed to load reanimation script.") end

if getgenv()._reanimate then 
	pcall(getgenv()._reanimate) 
else
	-- Fallback mock if reanimation is missing
	getgenv()._reanimate = function() end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = getgenv().CloneRig or Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 5)
if not Humanoid then warn("[Neko] Humanoid missing!"); return end

local Torso = Character:FindFirstChild("Torso")
if not Torso then warn("[Neko] R6 character required (Torso missing)"); return end

local Head = Character:FindFirstChild("Head")
local LeftArm = Character:FindFirstChild("Left Arm")
local LeftLeg = Character:FindFirstChild("Left Leg")
local RightArm = Character:FindFirstChild("Right Arm")
local RightLeg = Character:FindFirstChild("Right Leg")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

-- Fallback for workspace.non
local non = workspace:FindFirstChild("non")
if not non then
	warn("[Neko] workspace.non missing! Creating a fallback dummy rig...")
	non = Character:Clone()
	non.Name = "non"
	for _, v in ipairs(non:GetDescendants()) do
		if v:IsA("BasePart") then v.Transparency = 1; v.CanCollide = false end
		if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
	end
	non.Parent = workspace
end

local nonPlayer = non:FindFirstChild(Player.Name)
if nonPlayer then
	local dec = nonPlayer:FindFirstChild("Head") and nonPlayer.Head:FindFirstChildWhichIsA('Decal')
	if dec then dec.Transparency = 1 end
	for _, v in ipairs(nonPlayer:GetChildren()) do
		if v:IsA('BasePart') then v.Transparency = 1 end
	end
end

local bleft, bright, bleftweld, brightweld = false, false, false, false

if non:FindFirstChild('International Fedora') and nonPlayer and nonPlayer:FindFirstChild('International Fedora') then
	local mesh1 = non['International Fedora'].Handle:FindFirstChild('SpecialMesh')
	if mesh1 then mesh1:Destroy() end
	local mesh2 = nonPlayer['International Fedora'].Handle:FindFirstChild('SpecialMesh')
	if mesh2 then mesh2:Destroy() end
	
	bleft = non['International Fedora'].Handle
	local aw = bleft:FindFirstChild('AccessoryWeld')
	if aw then aw:Destroy() end
	bleft.Parent = non.Torso
	bleft.Position = non.Torso.CFrame * Vector3.new(-0.5,0.5,0)
	bleftweld = Instance.new("WeldConstraint", non.Torso)
	bleftweld.Part0 = non.Torso
	bleftweld.Part1 = bleft
	local vis = Instance.new('SelectionBox', bleft)
	vis.LineThickness = 0.05
	vis.Adornee = bleft
end

if non:FindFirstChild('InternationalFedora') and nonPlayer and nonPlayer:FindFirstChild('InternationalFedora') then
	local mesh1 = non['InternationalFedora'].Handle:FindFirstChild('SpecialMesh')
	if mesh1 then mesh1:Destroy() end
	local mesh2 = nonPlayer['InternationalFedora'].Handle:FindFirstChild('SpecialMesh')
	if mesh2 then mesh2:Destroy() end

	bright = non['InternationalFedora'].Handle
	local aw = bright:FindFirstChild('AccessoryWeld')
	if aw then aw:Destroy() end
	bright.Parent = non.Torso
	local vis = Instance.new('SelectionBox', bright)
	vis.LineThickness = 0.05
	vis.Adornee = bright
	bright.Position = non.Torso.CFrame * Vector3.new(0.5,0.5,0)
	brightweld = Instance.new("WeldConstraint", non.Torso)
	brightweld.Part0 = non.Torso
	brightweld.Part1 = bright
end

local folder
local ok, err = pcall(function() folder = game:GetObjects('rbxassetid://9206254000')[1] end)
if not ok or not folder then
	warn("[Neko] Failed to load asset. Creating dummy.")
	folder = Instance.new("Folder")
	local noextras = Instance.new("Folder", folder)
	noextras.Name = "noextrasnono"
end
folder.Parent = non

local function weldModel(model)
	if not model or not model:FindFirstChildWhichIsA("BasePart") then return end
	local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if not primary then return end
	for _, part in ipairs(model:GetChildren()) do
		if part:IsA("BasePart") and part ~= primary then
			local w = Instance.new("Weld", primary)
			w.Part0 = primary
			w.Part1 = part
			w.C0 = primary.CFrame:toObjectSpace(part.CFrame)
		end
	end
end

for _, v in ipairs(folder:GetChildren()) do
	if v:IsA('Model') and v.Name ~= 'Armor' then
		local m = v:FindFirstChildWhichIsA('Model')
		if m then weldModel(m) end
	end
end

-- FIX: Hide the fake clone completely
for _, v in ipairs(non:GetChildren()) do
	if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then v.Transparency = 1 end
end

local Create
local ok, req = pcall(function() 
	local lib = game:GetObjects("rbxassetid://5209815302")[1]
	if lib then loadstring(lib.Source)() end
	return FELOADLIBRARY and FELOADLIBRARY.Create
end)
if ok and req then
	Create = req
else
	Create = function(class) return function(props)
		local inst = Instance.new(class)
		for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
		return inst
	end end
end

local EffectPack = folder:FindFirstChild("noextrasnono")
if EffectPack then
	EffectPack = EffectPack:Clone()
	folder.noextrasnono:Destroy()
else
	EffectPack = Instance.new("Folder")
end

local agresive = false
local Target = Vector3.new()
Torso.Transparency = 0
local Anim = "Idle"
local inairvel = 0
local WalkAnimStep = 0
local sine = 0
local change = 1
local pantdown = false
local shirtdown = false
local reap = false
local gpressed = false
local Animstep = 0
local WalkAnimMove = 0.05
local Combo = 0
local attack = false
local pant = false
local shirt = false
local mememode = false

local BoobaModel = nil
local BoobaCover = nil
local Model13 = nil
local Model0 = nil

local function getmousetarget()
	return Player:GetMouse().Target
end

local RJ = RootPart:FindFirstChild("RootJoint")
local Neck = Torso:FindFirstChild("Neck")

if not RJ or not Neck then warn("[Neko] Rig missing joints!"); return end

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14) 
local NeckCF = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

local forWFB = 0
local forWRL = 0

local Effects = Instance.new("Folder", Character)
Effects.Name = "Effects"

local it, vt, cf, euler, angles, cn = Instance.new, Vector3.new, CFrame.new, CFrame.fromEulerAnglesXYZ, CFrame.Angles, CFrame.new
local mr = math.rad
local IT, CF, VT, RAD = Instance.new, CFrame.new, Vector3.new, math.rad
local C3, UD2, BRICKC = Color3.new, UDim2.new, BrickColor.new
local ANGLES = CFrame.Angles
local MRANDOM = math.random

local lastid = "http://www.roblox.com/asset/?id=3852221223"
local s2 = it("Sound", Torso)
local CurId = 1
s2.EmitterSize = 30
local s2c = s2:Clone()
local playsong = true
local lastsongpos = 0

s2.SoundId = lastid
task.spawn(function()
	if playsong then
		task.wait(2)
		s2:Play()		
	else
		s2:Stop()			
	end
end)

local crosshair = Instance.new("BillboardGui", Character)
crosshair.Size = UDim2.new(10,0,10,0)
crosshair.Enabled = false
local imgl = Instance.new("ImageLabel", crosshair)
imgl.Position = UDim2.new(0,0,0,0)
imgl.Size = UDim2.new(1,0,1,0)
imgl.Image = "rbxassetid://578065407"
imgl.BackgroundTransparency = 1
imgl.ImageTransparency = 0.7
imgl.ImageColor3 = Color3.new(1,1,1)
crosshair.StudsOffset = Vector3.new(0,0,-1)

local function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10, 10, 10, 10
end

local CFuncs = {
	Sound = {Create = function(id, par, vol, pit)
		task.spawn(function()
			local S = Instance.new("Sound")
			S.Volume = vol
			S.Pitch = pit or 1
			S.SoundId = "http://www.roblox.com/asset/?id="..tostring(id)
			S.Parent = par or workspace
			task.wait()
			S:Play()
			Debris:AddItem(S, 6)
		end)
	end}
}

local function so(id, par, vol, pit)
	CFuncs.Sound.Create(id, par, vol, pit)
end

local face = Head:FindFirstChild("face")
if face then face.Texture = "rbxassetid://0" end
task.wait(0.1)

local eyes = Instance.new("Decal", Head)
eyes.Face = "Front"
eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

local mouth = Instance.new("Decal", Head)
mouth.Face = "Front"
mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"

local brows = Instance.new("Decal", Head)
brows.Face = "Front"
brows.Texture = "http://www.roblox.com/asset/?id=2801687635"

local blush = Instance.new("Decal", Head)
blush.Face = "Front"
blush.Texture = "http://www.roblox.com/asset/?id=0"

local extra = Instance.new("Decal", Head)
extra.Face = "Front"
extra.Texture = "http://www.roblox.com/asset/?id=0"

task.spawn(function()
	task.wait(0.5)
	for _, v in pairs(Character:GetChildren()) do
		if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("BodyColors") then
			v:Destroy()
		end
		if v:IsA("Accessory") or v:IsA('Hat') then
			if v:FindFirstChild('Handle') then v.Handle.Transparency = 1 end
		end
	end
	for _, v in pairs(Player.Character:GetDescendants()) do
		if v:IsA("Accessory") or v:IsA('Hat') then
			if v:FindFirstChild('Handle') then v.Handle.Transparency = 1 end
		end
	end

	local outfit = EffectPack:FindFirstChild("notoutfit")
	if outfit then
		outfit = outfit:Clone()
		for _, v in pairs(outfit:GetChildren()) do
			if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("CharacterMesh") then
				v.Parent = Character
			end
		end
	end
	
	local Part36 = Instance.new("Part")
	local Part38 = Instance.new("Part")
	local Weld37 = Instance.new("Weld")
	local Weld39 = Instance.new("Weld")

	Part36.Name = "Left"
	Part36.Parent = non
	Part36.Size = Vector3.new(1.04, 0.42, 1.06)
	Part36.BrickColor = BrickColor.new("Really black")
	Part36.CanCollide = false
	Part36.Material = Enum.Material.SmoothPlastic
	Weld37.Name = "Left Leg"
	Weld37.Parent = Part36
	Weld37.C0 = CFrame.new(0,-0.8,0)
	Weld37.Part0 = Part36
	Weld37.Part1 = LeftLeg

	Part38.Name = "Right"
	Part38.Parent = non
	Part38.Size = Vector3.new(1.04, 0.42, 1.06)
	Part38.BrickColor = BrickColor.new("Really black")
	Part38.CanCollide = false
	Part38.Material = Enum.Material.SmoothPlastic
	Weld39.Name = "Right Leg"
	Weld39.Parent = Part38
	Weld39.C0 = CFrame.new(0,-0.8,0)
	Weld39.Part0 = Part38
	Weld39.Part1 = RightLeg

	Model0 = Instance.new("Model")
	Model0.Name = "vag"
	Model0.Parent = Torso
	local p1 = Instance.new("Part", Model0)
	p1.Name = "mainskin"
	p1.Size = Vector3.new(0.9, 1.8, 0.9)
	p1.BrickColor = BrickColor.new("Pastel brown")
	p1.CanCollide = false
	Model0.PrimaryPart = p1
	local sm = Instance.new("SpecialMesh", p1)
	sm.Scale = Vector3.new(0.9,0.4,0.9)
	sm.MeshType = Enum.MeshType.Sphere
	local w1 = Instance.new("Weld", p1)
	w1.Part0, w1.Part1 = p1, Torso

	Model13 = Instance.new("Model")
	Model13.Name = "vagcover"
	Model13.Parent = Torso
	local p2 = Instance.new("Part", Model13)
	p2.Name = "mainskin"
	p2.Size = Vector3.new(0.9, 1.8, 0.9)
	p2.BrickColor = BrickColor.new("Really black")
	p2.CanCollide = false
	Model13.PrimaryPart = p2
	local sm2 = Instance.new("SpecialMesh", p2)
	sm2.Scale = Vector3.new(0.9,0.4,0.9)
	sm2.MeshType = Enum.MeshType.Sphere
	local w2 = Instance.new("Weld", p2)
	w2.Part0, w2.Part1 = p2, Torso
	
	Character:SetAttribute("HasBooba", true)
end)

local hbContainer = Instance.new("Folder", workspace)
hbContainer.Name = "_NekoHB_"..tostring(tick())
local ArtificialHB = Instance.new("BindableEvent", hbContainer)
local frame = 1/30
local tf, lastframe = 0, tick()
local allowframeloss, tossremainder = false, false

local art = RunService.Heartbeat:Connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			ArtificialHB:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do ArtificialHB:Fire() end
			lastframe = tick()
		end
		tf = tossremainder and 0 or (tf - frame * math.floor(tf / frame))
	end
end)

Humanoid.Died:Connect(function()
	art:Disconnect()
	ArtificialHB:Destroy()
end)

local function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:Wait()
	else
		for i = 1, NUMBER do ArtificialHB.Event:Wait() end
	end
end

local function weld(parent, part0, part1, c0)
	local w = Instance.new("Weld")
	w.Parent = parent
	w.Part0 = part0
	w.Part1 = part1
	w.C0 = c0
	return w
end

local function joint(parent, part0, part1, c0)
	local w = Instance.new("Motor6D")
	w.Parent, w.Part0, w.Part1, w.C0 = parent, part0, part1, c0
	return w
end

local function rayCast(Pos, Dir, Max, Ignore)
	return workspace:FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or 999.999)), Ignore)
end

local function SetTween(SPart, CFr, MoveStyle2, outorin2, AnimTime)
	if not SPart then return end
	local MoveStyle = Enum.EasingStyle[MoveStyle2]
	local outorin = Enum.EasingDirection[outorin2]
	local dahspeed = (attack and mememode) and 5 or 1
	if SPart.Name == "Bullet" then dahspeed = 1 end
	local tweenanim = TweenService:Create(SPart, TweenInfo.new(AnimTime/dahspeed, MoveStyle, outorin, 0, false, 0), CFr)
	tweenanim:Play()
end

local function GatherAllInstances(Parent, ig)
	local Instances = {}
	local function GatherInstances(P, Ignore)
		for _, v in pairs(P:GetChildren()) do
			if v ~= Ignore then
				GatherInstances(v, Ignore)
				table.insert(Instances, v)
			end
		end
	end
	GatherInstances(Parent, ig)
	return Instances
end

local RClaw = EffectPack:FindFirstChild("Part")
if RClaw then
	RClaw = RClaw:Clone()
	RClaw.Parent = Character
	RClaw.Name = "RightClaw"
	weld(RightArm, RightArm, RClaw, cf(0,0,0))
end
local LClaw = EffectPack:FindFirstChild("Part")
if LClaw then
	LClaw = LClaw:Clone()
	LClaw.Parent = Character
	LClaw.Name = "LeftClaw"
	weld(LeftArm, LeftArm, LClaw, cf(0,0,0))
end

local tailw, tailc0 = nil, nil
local tailPart = Torso:FindFirstChild("Tail")
if tailPart then
	tailw = tailPart:FindFirstChild("Weld")
	if tailw then tailc0 = tailw.C0 end
end

local RCW = Instance.new("Weld")
local LCW = Instance.new("Weld")
if Character:FindFirstChild("RightClaw") then RCW = weld(RightArm, RightArm, Character.RightClaw, cf(0,0,0)) end
if Character:FindFirstChild("LeftClaw") then LCW = weld(LeftArm, LeftArm, Character.LeftClaw, cf(0,0,0)) end

local function ShowDamage(Pos, Text, Time, Color)
	if not Pos then Pos = Vector3.new(0,0,0) end
	local EffectPart = Instance.new("Part")
	EffectPart.Anchored = true
	EffectPart.CanCollide = false
	EffectPart.Transparency = 1
	EffectPart.Size = Vector3.new(0,0,0)
	EffectPart.Parent = workspace
	local BBG = Instance.new("BillboardGui", EffectPart)
	BBG.Size = UDim2.new(2,0,2,0)
	local Txt = Instance.new("TextLabel", BBG)
	Txt.BackgroundTransparency = 1
	Txt.Size = UDim2.new(1,0,1,0)
	Txt.Text = "DMG: "..tostring(Text)
	Txt.TextColor3 = Color or Color3.new(1,0,1)
	Txt.TextScaled = true
	Txt.Font = Enum.Font.ArialBold
	Txt.TextTransparency = 1
	Debris:AddItem(EffectPart, Time + 0.1)
	
	task.spawn(function()
		local Frames = Time / 0.033333
		EffectPart.CFrame = CFrame.new(Pos)
		task.wait()
		Txt.TextTransparency = 0
		SetTween(Txt, {TextTransparency = 1}, "Quad", "In", Frames/60)
		SetTween(Txt, {Rotation = math.random(-25,25)}, "Elastic", "InOut", Frames/60)
		SetTween(Txt, {TextColor3 = Color3.new(1,0,0)}, "Elastic", "InOut", Frames/60)
		SetTween(EffectPart, {CFrame = CFrame.new(Pos + Vector3.new(math.random(-5,5), math.random(1,5), math.random(-5,5)))}, "Linear", "InOut", Frames/60)
		task.wait(Frames/60)
		if EffectPart and EffectPart.Parent then EffectPart:Destroy() end
	end)
end

local function Damagefunc(Part, hit, minim, maxim, knockback, Type, Property, Delay, HitSound, HitPitch)
	if hit.Parent == nil then return end
	local h = hit.Parent:FindFirstChildOfClass("Humanoid")
	if not h or h.Health < 0.001 then return end
	if hit.Parent:FindFirstChild("DebounceHit") and hit.Parent.DebounceHit.Value then return end
	
	local c = Instance.new("ObjectValue")
	c.Name = "creator"
	c.Value = Player
	c.Parent = h
	Debris:AddItem(c, 0.5)
	
	if HitSound and HitPitch then so(HitSound, hit, 1, HitPitch) end
	local Damage = math.random(minim, maxim)
	ShowDamage(Part.CFrame * CFrame.new(0,0,Part.Size.Z/2).p + Vector3.new(0,1.5,0), -Damage, 1.5, Color3.new(0,0,0))
	
	local debounce = Instance.new("BoolValue", hit.Parent)
	debounce.Name = "DebounceHit"
	debounce.Value = true
	Debris:AddItem(debounce, Delay or 0.1)
end

local function MagniDamage(Part, magni, mindam, maxdam, knock, Type2)
	local Type = mememode and "Instakill" or Type2
	for _, c in pairs(workspace:GetChildren()) do
		local hum = c:FindFirstChild("Humanoid")
		if hum and c.Name ~= Player.Name then
			local head = c:FindFirstChild("Head")
			if head and (head.Position - Part.Position).Magnitude <= magni then
				Damagefunc(Part, head, mindam, maxdam, knock, Type, RootPart, 0.1, "851453784", 1.2)
			end
		end
	end
end

local function CFMagniDamage(HTCF, magni, mindam, maxdam, knock, Type)
	local DGP = Instance.new("Part")
	DGP.Parent = Character
	DGP.Size = Vector3.new(0.05,0.05,0.05)
	DGP.Transparency = 1
	DGP.CanCollide = false
	DGP.Anchored = true
	DGP.CFrame = HTCF
	MagniDamage(DGP, magni, mindam, maxdam, knock, Type)
	Debris:AddItem(DGP, 0.05)
end

local RJW = weld(RJ.Parent, RJ.Part0, RJ.Part1, RJ.C0)
RJW.C1 = RJ.C1; RJW.Name = RJ.Name
local NeckW = weld(Neck.Parent, Neck.Part0, Neck.Part1, Neck.C0)
NeckW.C1 = Neck.C1; NeckW.Name = Neck.Name

local RW = weld(Torso, Torso, RightArm, cf(0,0,0))
local LW = weld(Torso, Torso, LeftArm, cf(0,0,0))
local RH = weld(Torso, Torso, RightLeg, cf(0,0,0))
local LH = weld(Torso, Torso, LeftLeg, cf(0,0,0))
RW.C1, LW.C1 = cn(0,0.5,0), cn(0,0.5,0)
RH.C1, LH.C1 = cn(0,1,0), cn(0,1,0)

SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)},"Quad","InOut",0.1)
SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Quad","InOut",0.1)
SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Quad","InOut",0.1)
SetTween(RH,{C0=CFrame.new(.5,-0.90,0)},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5,-0.90,0)},"Quad","InOut",0.1)

local function AT1()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(20),0,math.rad(-40))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(40))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(30),0,0)},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(30),0,0)},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-.6,-.4)*angles(math.rad(-20),0,0)},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(20),0,math.rad(20))},"Quad","InOut",0.2)
	task.wait(0.2)
	CFMagniDamage(RootPart.CFrame*CF(0,-1,-1),7,10,20,20,"Normal")
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(-40),0,math.rad(40))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(-40))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(-30),0,0)},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(-30),0,0)},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(120),0,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-60),0,math.rad(-20))},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT2()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(60))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(-60))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(90),0,0)},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-.5,-.4)*angles(math.rad(-20),0,0)},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-20),0,0)},"Quad","InOut",0.2)
	CFMagniDamage(RootPart.CFrame*CF(0,0,-1),9,10,15,0,"Normal")
	task.wait(0.2)
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(0,0,math.rad(-70))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(70))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,math.rad(-20),math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(20),0,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-20),0,0)},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT3()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(120))},"Quad","In",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(-80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(90),0,math.rad(20))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-20),0,0)},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-.8,0)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	task.wait(0.2)
	CFMagniDamage(RootPart.CFrame*CF(-2,-.25,-1),9,20,30,10,"Knockdown")
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),0,0)},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(0,0,math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(20),0,0)},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-40),0,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT4()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(-80))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),0,math.rad(80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(-20),math.rad(-70),math.rad(-90))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-.5,-.4)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	CFMagniDamage(RootPart.CFrame*CF(0,0,-1),9,30,45,0,"Normal")
	so("3051417237", LeftArm,3, math.random(100,155)/100)
	task.wait(0.2)
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),0,math.rad(45))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(-45))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,0,math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(20),0,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-10),0,0)},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT5()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(80))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),0,math.rad(-80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(-20),math.rad(70),math.rad(90))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,0,math.rad(-90))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-.5,-.4)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(20),0,0)},"Quad","InOut",0.2)
	CFMagniDamage(RootPart.CFrame*CF(0,0,-1),9,30,45,0,"Normal")
	so("3051417237", RightArm,3, math.random(100,155)/80)
	task.wait(0.2)
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),0,math.rad(-45))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,math.rad(45))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(0,0,math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-10),0,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(20),0,0)},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT6()
	attack = true
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,-.3)*angles(math.rad(45),0,0)},"Quad","Out",0.3)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),0,0)},"Quad","Out",0.3)
	SetTween(RW,{C0=CFrame.new(1.1,0.5,-.3)*angles(math.rad(20),math.rad(115),math.rad(90))},"Quad","In",0.15)
	SetTween(LW,{C0=CFrame.new(-1.1,0.5,-.3)*angles(math.rad(20),math.rad(-115),math.rad(-90))},"Quad","In",0.15)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-60),0,0)},"Quad","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(60),0,0)},"Quad","Out",0.3)
	so("3051417237", Torso,3,  math.random(140,185)/80)
	CFMagniDamage(RootPart.CFrame*CF(-1.4,0,-1),9,40,55,10,"Knockdown")
	CFMagniDamage(RootPart.CFrame*CF(1.4,0,-1),9,40,55,10,"Knockdown")
	task.wait(0.175)
	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1.7,-.4)*angles(math.rad(45),0,0)},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(0,0,math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,0,math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(65),0,0)},"Back","Out",0.2)
	task.wait(0.2)
	attack = false
end

local function AT7()
	attack = true
	so("3051417237", Torso,3, .8)
	task.spawn(function()	
		for i = 1,2 do 
			Swait(3)
			so("3051417087", RightArm,3, math.random(100,155)/100) 
		end
	end)
	for i = 1,10,1 do 
		SetTween(RJW,{C0=RootCF*CFrame.new(0,-1.7+.17*i,-.4)*angles(math.rad(25-5*i),0,math.rad(36*i))},"Quad","Out",0.1)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)},"Quad","Out",0.2)
		SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(180),0,math.rad(90))},"Quad","Out",0.2)
		SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,0,math.rad(-90))},"Quad","Out",0.2)
		SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-25),0,0)},"Quad","Out",0.2)
		SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(25),0,0)},"Quad","Out",0.2)
		CFMagniDamage(RootPart.CFrame*CF(1.4,0,-1+.17*i),9,10,15,10,"Knockdown")
		Swait()
	end
	attack = false
end

local function Attack1()
	attack = true
	Humanoid.JumpPower = 0	
	Humanoid.WalkSpeed = 0.1	
	so("299058146", RightArm,2,2.5)
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(20),0,math.rad(-20))},"Back","Out",0.6)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(20))},"Back","Out",0.6)
	SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(-10),0,math.rad(20))},"Back","Out",0.6)
	SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(0,0,math.rad(-20))},"Back","Out",0.6)
	SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-20),0,0)},"Back","Out",0.6)
	SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(20),0,0)},"Back","Out",0.6)
	Swait(6)

	local TheGunHandle = Instance.new("Part")
	TheGunHandle.Reflectance = 0
	TheGunHandle.Transparency = 1
	TheGunHandle.CanCollide = false
	TheGunHandle.Locked = true
	TheGunHandle.Anchored = false
	TheGunHandle.Name = "BHandle"
	TheGunHandle.Size = Vector3.new(2.5,1,2.5)
	TheGunHandle.Parent = Effects		
	TheGunHandle.CFrame = RootPart.CFrame	
	weld(TheGunHandle, RootPart, TheGunHandle, cf(0,0,-3))

	local IsHit = false
	TheGunHandle.Touched:Connect(function(HitPa)
		if IsHit then return end
		local c = HitPa.Parent
		local h = c:FindFirstChild("Humanoid")
		local victimTorso = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
		local victimHead = c:FindFirstChild("Head")
		
		if h and victimTorso and victimHead then
			IsHit = true
			TheGunHandle:Destroy()

			local TheFlyHandle = Instance.new("Part")
			TheFlyHandle.Transparency = 1
			TheFlyHandle.Anchored = true
			TheFlyHandle.Size = Vector3.new(1,1,1)
			TheFlyHandle.Parent = Effects		
			TheFlyHandle.CFrame = RootPart.CFrame	
			local thejoint = joint(TheFlyHandle, RootPart, TheFlyHandle, cf())

			so("231917750", Torso,2,0.9)
			for i = 1,10,0.4 do	
				SetTween(RJW,{C0=RootCF*CFrame.new(-0.5*math.sin(i),0.5*math.cos(i),0)*angles(math.rad(25-4.5*i),0,math.rad(36*i*2))},"Quad","InOut",0.05)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),0,math.rad(-80))},"Quad","InOut",0.15)
				SetTween(RW,{C0=CFrame.new(1.5,0.65,0)*angles(math.rad(160+2*i),0,math.rad(30-3*i))},"Quad","Out",0.15)
				SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Quad","Out",0.15)
				SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(0+6.5*i),0,0)},"Quad","InOut",0.15)
				SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(0-6.5*i),0,0)},"Quad","InOut",0.15)
				SetTween(thejoint,{C0=CFrame.new(0,-i*2,i/2)},"Quad","InOut",0.05)
				Swait()
			end	

			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-65),0,0)},"Back","Out",0.3)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(65),0,0)},"Back","Out",0.3)
			SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(90),0,math.rad(90))},"Back","Out",0.3)
			SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(90),0,math.rad(-90))},"Back","Out",0.3)
			SetTween(RH,{C0=CFrame.new(.5,-.7,-.2)*angles(math.rad(-40),0,0)},"Back","Out",0.3)
			SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-30),0,0)},"Back","Out",0.3)
			SetTween(thejoint,{C0=CFrame.new(0,-30,5)},"Back","Out",0.6)
			Swait(3)

			for i = 1,2.5,.225 do	
				SetTween(RJW,{C0=RootCF*CFrame.new(0,2+(-0.75*i),20-1.8*i)*angles(math.rad(15+30*i*2),0,0)},"Quad","Out",0.2)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-25),0,0)},"Quad","Out",0.3)
				SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(170),0,math.rad(90-(90/2.0)*i))},"Quad","Out",0.2)
				SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(170),0,math.rad(-90+(90/2.0)*i))},"Quad","Out",0.2)
				SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(40),0,0)},"Quad","Out",0.3)
				SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(40),0,0)},"Quad","Out",0.3)
				Swait()
				SetTween(thejoint,{C0=CFrame.new(0,-(20-1.8*i),13-1.2*i)},"Quad","Out",0.2)
			end
			
			SetTween(thejoint,{C0=CFrame.new(0,0,27)},"Quad","In",0.3)
			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-.5)*angles(math.rad(85),0,0)},"Quad","Out",0.2)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-65),0,0)},"Back","Out",0.2)
			SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(130),0,0)},"Back","Out",0.2)
			SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(130),0,0)},"Back","Out",0.2)
			SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(-25),0,0)},"Back","Out",0.2)
			SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-25),0,0)},"Back","Out",0.2)
			Swait(9)

			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)},"Quad","Out",0.25)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(35),0,0)},"Back","Out",0.25)
			SetTween(RW,{C0=CFrame.new(1.5,0.5,0)*angles(math.rad(30),0,math.rad(30))},"Back","Out",0.25)
			SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)*angles(math.rad(30),0,math.rad(-30))},"Back","Out",0.25)
			SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(10),0,0)},"Back","Out",0.25)
			SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(-10),0,0)},"Back","Out",0.25)
			Swait(7)
			TheFlyHandle:Destroy()		
			attack = false	
		end
	end)	
	Swait(15)
	if TheGunHandle.Parent == Effects then	
		TheGunHandle:Destroy()
		attack = false
	end
	while attack do Swait() end
	Humanoid.JumpPower = 60	
	Humanoid.WalkSpeed = 16	
end

local function ClickCombo()
	if Anim == "Fall" or Anim == "Jump" then return end
	if agresive == false then				
		if Combo == 0 then AT1(); Combo = 1
		elseif Combo == 1 then AT2(); Combo = 2	
		elseif Combo == 2 then AT3(); Combo = 0	
		elseif Combo == 3 then Combo = 0; ClickCombo() end
	else
		if Combo == 0 then AT4(); Combo = 1
		elseif Combo == 1 then AT5(); Combo = 2	
		elseif Combo == 2 then AT6(); Combo = 3	
		elseif Combo == 3 then AT7(); Combo = 0 end
	end
end

local Hold = false
local a, b, c

local function KeyDownF(key)
	if key == "n" and mememode == false then	
		CurId = CurId + 1
		if CurId > 6 then CurId = 1 end
		warn("now playing song Nr"..CurId)
		local songs = {
			[1]="http://www.roblox.com/asset/?id=617334987",
			[2]="http://www.roblox.com/asset/?id=3464477488",
			[3]="http://www.roblox.com/asset/?id=198665867",
			[4]="http://www.roblox.com/asset/?id=493674525",
			[5]="http://www.roblox.com/asset/?id=2984966954",
			[6]="http://www.roblox.com/asset/?id=3547074406",
		}
		lastid = songs[CurId]
		lastsongpos = 0
		if s2 then s2.TimePosition = 0 end
	end
end

local function Button1DownF()
	Hold = true
	while Hold do
		if not attack then ClickCombo() end
		Swait()
	end
end

local function Button1UpF()
	if Hold then Hold = false end
end

local stop = Instance.new('BindableEvent')
stop.Event:Connect(function() return end)

local function mainLoop()
	while true do
		sine = sine + change
		local hitfloor = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)
		if Character:FindFirstChild("Sound") and Character:FindFirstChild("Sound") ~= s2 then
			Character:FindFirstChild("Sound"):Destroy()	
		end
		local torvel = (Player.Character.Humanoid.MoveDirection * Vector3.new(1, 0, 1)).Magnitude
		local velderp = RootPart.Velocity.Y
		
		if velderp > 1 and hitfloor == nil then Anim = "Jump"
		elseif velderp < -1 and hitfloor == nil then Anim = "Fall"
		elseif Humanoid.Sit == true then Anim = "Sit"	
		elseif torvel < 0.5 and hitfloor ~= nil then Anim = "Idle"
		elseif torvel > 0.5 and hitfloor ~= nil then Anim = "Walk"
		else Anim = "" end 

		local Ccf = RootPart.CFrame
		local Walktest1 = Humanoid.MoveDirection * Ccf.LookVector
		local Walktest2 = Humanoid.MoveDirection * Ccf.RightVector
		forWFB = Walktest1.X + Walktest1.Z
		forWRL = Walktest2.X + Walktest2.Z

		task.spawn(function()
			if s2.Parent == nil then
				s2 = s2c:Clone()
				s2.Parent = Torso
				s2.Name = "BGMusic"
				s2.Pitch = 1
				s2.Volume = 1.5
				s2.Looped = true
				s2.Archivable = false
				s2.TimePosition = lastsongpos
				if playsong then s2:Play() else s2:Stop() end
			else
				lastsongpos = s2.TimePosition		
				s2.Pitch = 1
				s2.Volume = 1.5
				s2.Looped = true
				s2.SoundId = lastid
				s2.EmitterSize = 30
			end
		end)

		inairvel = torvel * 1
		if inairvel > 30 then inairvel = 30 end
		inairvel = inairvel / 50 * 2

		if not attack then
			if Anim == "Jump" then
				change = 1.2
				SetTween(RJW,{C0=RootCF*cn(0,0.01975*math.cos(sine/8),-0.1+0.0395*math.cos(sine/8))*angles(math.rad(-6.5-1.5*math.cos(sine/8))+(inairvel*forWFB)/2, -(inairvel*forWRL)/2, 0)},"Quad","Out",0.25)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-26.5+2.5*math.cos(sine/8)),0,0)},"Quad","Out",0.25)
				SetTween(RW,{C0=cf(1.45,0.5,0)*angles(math.rad(140-2*math.cos(sine/8)),math.rad(-5),math.rad(8+4*math.cos(sine/8)))},"Quad","Out",0.2)
				SetTween(LW,{C0=cf(-1.45,0.5,0)*angles(math.rad(140-2*math.cos(sine/8)),math.rad(5),math.rad(-8-4*math.cos(sine/8)))},"Quad","Out",0.2)
				SetTween(RH,{C0=CFrame.new(.5,-0.85+0.05*math.cos(sine/15),-.2)*CFrame.Angles(math.rad(-15-1*math.cos(sine/10)),0,0)},"Quad","InOut",0.075)
				SetTween(LH,{C0=CFrame.new(-.5,-0.35+0.05*math.cos(sine/15),-.4)*CFrame.Angles(math.rad(-25+1*math.cos(sine/10)),0,0)},"Quad","InOut",0.075)
			elseif Anim == "Fall" then 
				change = 1.2
				SetTween(RJW,{C0=RootCF*cn(0,0.01975*math.cos(sine/8),-0.5+0.0395*math.cos(sine/8))*angles(math.rad(5.5-1.5*math.cos(sine/8))-(inairvel*forWFB)/2,(inairvel*forWRL)/2,0)},"Quad","Out",0.35)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(26.5+2.5*math.cos(sine/8)),0,0)},"Quad","Out",0.25)
				SetTween(RW,{C0=cf(1.45,0.5,0)*angles(math.rad(105-2*math.cos(sine/8)),math.rad(-15),math.rad(80+4*math.cos(sine/8)))},"Quad","Out",0.2)
				SetTween(LW,{C0=cf(-1.45,0.5,0)*angles(math.rad(105-2*math.cos(sine/8)),math.rad(15),math.rad(-80-4*math.cos(sine/8)))},"Quad","Out",0.2)
				SetTween(RH,{C0=CFrame.new(.5,-0.15+0.05*math.cos(sine/15),-.4)*CFrame.Angles(math.rad(-15-1*math.cos(sine/10)),0,0)},"Quad","InOut",0.1)
				SetTween(LH,{C0=CFrame.new(-.5,-0.55+0.05*math.cos(sine/15),-.4)*CFrame.Angles(math.rad(1*math.cos(sine/10)),0,0)},"Quad","InOut",0.1)
			elseif Anim == "Idle" then
				local dahspeed = (attack and mememode) and 5 or 1
				change = (0.60*1.75)*dahspeed
				Humanoid.JumpPower, Humanoid.WalkSpeed = 60, 16	
				if not agresive then
					SetTween(RJW,{C0=RootCF*cn(0,0,-0.1+0.0395*math.cos(sine/8))*angles(math.rad(1.5-1*math.cos(sine/8)),0,math.rad(-20))},"Quad","InOut",0.1)
					SetTween(NeckW,{C0=NeckCF*angles(math.rad(6.5-3.5*math.sin(sine/8)),math.rad(2.5-5.5*math.cos(sine/16)),math.rad(20-6.5*math.cos(sine/15+0.4*math.cos(sine/10))))},"Quad","InOut",0.1)
					SetTween(RW,{C0=cf(1.45,0.5,0)*angles(math.rad(3*math.sin(sine/8)),math.rad(-5),math.rad(4+4*math.cos(sine/8)))},"Quad","Out",0.2)
					SetTween(LW,{C0=cf(-1.45,0.5,0)*angles(math.rad(3*math.sin(sine/8)),math.rad(5),math.rad(-4-4*math.cos(sine/8)))},"Quad","Out",0.2)
					SetTween(RH,{C0=CFrame.new(.5,-0.95-0.04*math.cos(sine/8),0)*CFrame.Angles(math.rad(1.5-1*math.cos(sine/8)),0,math.rad(2.5))},"Quad","InOut",0.1)
					SetTween(LH,{C0=CFrame.new(-.5,-0.95-0.04*math.cos(sine/8),0)*CFrame.Angles(math.rad(1.5-1*math.cos(sine/8)),math.rad(20),math.rad(-2.5))},"Quad","InOut",0.1)
				else
					SetTween(RJW,{C0=RootCF*cn(0,0,-0.1+0.0395*math.cos(sine/8))*angles(math.rad(10.5-1*math.cos(sine/8)),0,math.rad(-5))},"Quad","InOut",0.1)
					SetTween(NeckW,{C0=NeckCF*angles(math.rad(-6.5-3.5*math.sin(sine/8)),math.rad(2.5-5.5*math.cos(sine/16)),math.rad(5-6.5*math.cos(sine/15+0.4*math.cos(sine/10))))},"Quad","InOut",0.1)
					SetTween(RW,{C0=cf(1.45,0.5,0)*angles(math.rad(10+3*math.sin(sine/8)),math.rad(25),math.rad(40+4*math.cos(sine/8)))},"Quad","Out",0.2)
					SetTween(LW,{C0=cf(-1.45,0.5,0)*angles(math.rad(10+3*math.sin(sine/8)),math.rad(-25),math.rad(-40-4*math.cos(sine/8)))},"Quad","Out",0.2)
					SetTween(RH,{C0=CFrame.new(.5,-0.95-0.04*math.cos(sine/8),0)*CFrame.Angles(math.rad(20.5-1*math.cos(sine/8)),0,math.rad(2.5))},"Quad","InOut",0.1)
					SetTween(LH,{C0=CFrame.new(-.5,-0.95-0.04*math.cos(sine/8),0)*CFrame.Angles(math.rad(1.5-1*math.cos(sine/8)),math.rad(20),math.rad(-2.5))},"Quad","InOut",0.1)
				end
			elseif Anim == "Walk" then
				if not agresive then
					local speed = mememode and 4 or 1
					change = 2.4*speed
					Humanoid.JumpPower, Humanoid.WalkSpeed = 60*speed, 16*speed
					local RH2 = cf(-forWRL/7*math.cos(sine/8),0,forWFB/7*math.cos(sine/8))*angles(math.rad(-forWFB*30)*math.cos(sine/8),0,math.rad(-forWRL*30)*math.cos(sine/8))
					local LH2 = cf(forWRL/7*math.cos(sine/8),0,-forWFB/7*math.cos(sine/8))*angles(math.rad(forWFB*30)*math.cos(sine/8),0,math.rad(forWRL*30)*math.cos(sine/8))
					SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-0.05+0.055*math.cos(sine/4)-math.sin(sine/4)/8)*angles(math.rad((forWFB*2-forWFB*math.cos(sine/4))*7),math.rad((-forWRL*2-(-forWRL)*math.cos(sine/4))*5),math.rad(8*math.cos(sine/8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0.025*math.cos(sine/4))*angles(math.rad((-forWFB*1-(-forWFB)*math.cos(sine/4))*7),math.rad((forWRL*2-forWRL*math.cos(sine/4))*3.5),math.rad(-forWRL*45+-8*math.cos(sine/8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(RW,{C0=cf(1.45,0.5+forWRL/50*math.cos(sine/8),0)*angles(math.rad(forWFB*15*math.cos(sine/8)),0,math.rad(8+forWRL*5*math.cos(sine/8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(LW,{C0=cf(-1.45,0.5+forWRL/50*math.cos(sine/8),0)*angles(math.rad(-forWFB*15*math.cos(sine/8)),0,math.rad(-8-forWRL*5*math.cos(sine/8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(RH,{C0=CFrame.new(.5,-0.85+0.15*math.sin(sine/8),-.15+.15*math.cos(sine/8))*RH2*CFrame.Angles(math.rad(-5*math.cos(sine/8)),0,math.rad(2.5))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(LH,{C0=CFrame.new(-.5,-0.85-0.15*math.sin(sine/8),-.15-.15*math.cos(sine/8))*LH2*CFrame.Angles(math.rad(5*math.cos(sine/8)),0,math.rad(-2.5))},"Linear","InOut",WalkAnimMove/speed)
				else
					local speed = mememode and 4 or 1.6
					change = 2.5*speed
					Humanoid.JumpPower, Humanoid.WalkSpeed = 60*speed, 22*speed
					local RH2 = cf(-forWRL/7*math.cos(sine/8),0,forWFB/7*math.cos(sine/8))*angles(math.rad(forWFB*89)*math.cos(sine/8),mr(-forWRL*55/2*math.cos(sine/8)),math.rad(forWRL*55*math.cos(sine/8)))
					local LH2 = cf(forWRL/7*math.sin(sine/8),0,-forWFB/7*math.cos(sine/8))*angles(math.rad(forWFB*89)*math.cos(sine/8),mr(forWRL*55/2*math.sin(sine/8)),math.rad(-forWRL*55*math.sin(sine/8)))
					SetTween(RJW,{C0=RootCF*CFrame.new(forWRL*math.sin(sine/8),forWFB*math.sin(sine/8),-0.5-0.255*math.cos(sine/8)-math.sin(sine/8)/8)*angles(math.rad(85+(forWFB*math.cos(sine/8))*20),math.rad((-forWRL*math.cos(sine/4))*1),math.rad((-forWRL*math.cos(sine/8))*10))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0.025*math.cos(sine/4))*angles(math.rad(-20+(-forWFB*1-(-forWFB)*math.cos(sine/4))*5),math.rad((forWRL*2-forWRL*math.cos(sine/4))*3.5),math.rad(-forWRL*45+-8*math.cos(sine/8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(RW,{C0=cf(1.0,.5-forWFB*0.5*math.sin(sine/8),-.4)*angles(math.rad(95-forWFB*75*math.sin(sine/8)),0,math.rad(-8+(-forWRL*55*math.sin(sine/8))+10*math.cos(sine/8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(LW,{C0=cf(-1.0,.5-forWFB*0.5*math.sin(sine/8),-.4)*angles(math.rad(95-forWFB*75*math.sin(sine/8)),0,math.rad(8+(forWRL*55*math.cos(sine/8))-10*math.cos(sine/8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(RH,{C0=CFrame.new(.5,-0.85-0.25*math.sin(sine/8),-.15-.25*math.sin(sine/8))*RH2*CFrame.Angles(math.rad(60-5*math.cos(sine/8)),0,math.rad(-2.5))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(LH,{C0=CFrame.new(-.5,-0.85-0.25*math.sin(sine/8),-.15-.25*math.sin(sine/8))*LH2*CFrame.Angles(math.rad(60-5*math.sin(sine/8)),0,math.rad(2.5))},"Linear","InOut",WalkAnimMove/speed)
					if tailw then
						SetTween(tailw,{C0=CF(0,0,.3)*ANGLES(mr(90+10*math.cos(sine/8)),0,mr(20*math.cos(sine/16)))},"Linear","In",.1)
					end
				end
			elseif Anim == "Sit" then	
				SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)},"Quad","InOut",0.1)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)},"Quad","InOut",0.1)
				SetTween(RW,{C0=CFrame.new(1.5,0.5,0)},"Quad","Out",0.1)
				SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Quad","Out",0.1)
				SetTween(RH,{C0=CFrame.new(.5,-1,0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
				SetTween(LH,{C0=CFrame.new(-.5,-1,0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
			end
		end
		
		if not attack and not (agresive and Anim == "Walk") and tailw and tailc0 then
			SetTween(tailw,{C0=tailc0*CF(0,.2,0)*ANGLES(mr(4+2*math.cos(sine/8)),0,mr(20+20*math.cos(sine/16)))},"Linear","In",.1)
		end
		
		Swait(Animstep*30)
	end
end

task.spawn(mainLoop)

a = UserInputService.InputBegan:Connect(function(input, chatting)
	if chatting then return end
	local key = UserInputService:GetStringForKeyCode(input.KeyCode):lower()
	
	if key == "f" and not attack then
		if not pantdown then
			if not agresive then 
				if RCW and LCW then
					SetTween(RCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
					SetTween(LCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
				end
				agresive = true
				so("3051417649", RightArm,1.5, .8)
				so("3051417649", LeftArm,1.5, .8)
				eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801759987"
				brows.Texture = "http://www.roblox.com/asset/?id=2801696705"
				blush.Texture = "http://www.roblox.com/asset/?id=0"
				extra.Texture = "http://www.roblox.com/asset/?id=0"
			else
				if RCW and LCW then
					SetTween(RCW,{C0=CF(0,-0,0)},"Quad","In",.5)
					SetTween(LCW,{C0=CF(0,-0,0)},"Quad","In",.5)
				end
				agresive = false
				so("3051417791", RightArm,1.5, .8)
				so("3051417791", LeftArm,1.5, .8)
				eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"
				brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
				blush.Texture = "http://www.roblox.com/asset/?id=0"
				extra.Texture = "http://www.roblox.com/asset/?id=0"
			end
		else
			if not agresive then 
				if RCW and LCW then
					SetTween(RCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
					SetTween(LCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
				end
				agresive = true
				so("3051417649", RightArm,1.5, .8)
				so("3051417649", LeftArm,1.5, .8)
				eyes.Texture = "http://www.roblox.com/asset/?id=2801605125"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801751773"
				brows.Texture = "http://www.roblox.com/asset/?id=2801697005"
				blush.Texture = "http://www.roblox.com/asset/?id=2801785860"
				extra.Texture = "http://www.roblox.com/asset/?id=2801786177"
			else
				if RCW and LCW then
					SetTween(RCW,{C0=CF(0,-0,0)},"Quad","In",.5)
					SetTween(LCW,{C0=CF(0,-0,0)},"Quad","In",.5)
				end
				agresive = false
				so("3051417791", RightArm,1.5, .8)
				so("3051417791", LeftArm,1.5, .8)
				eyes.Texture = "http://www.roblox.com/asset/?id=2801594656"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801759987"
				brows.Texture = "http://www.roblox.com/asset/?id=2801716156"
				blush.Texture = "http://www.roblox.com/asset/?id=2801785860"
				extra.Texture = "http://www.roblox.com/asset/?id=0"
			end
		end
	end

	if key == "r" and not pantdown and not reap then
		attack = true 
		local laying = true
		while laying do
			eyes.Texture = "http://www.roblox.com/asset/?id=2801584953"
			mouth.Texture = "http://www.roblox.com/asset/?id=2801732538"
			brows.Texture = "http://www.roblox.com/asset/?id=0"
			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-2.20)*angles(math.rad(75),math.rad(5*math.cos(sine/8)),math.rad(5*math.cos(sine/8)))},"Linear","InOut",0.1)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-40),math.rad(15*math.sin(sine/8)),0)},"Linear","InOut",0.1)
			SetTween(RW,{C0=CFrame.new(1.0,0.5,-.4)*angles(math.rad(160),math.rad(5*math.cos(sine/8)),math.rad(-50+5*math.cos(sine/8)))},"Linear","Out",0.1)
			SetTween(LW,{C0=CFrame.new(-1.0,0.5,-.4)*angles(math.rad(160),math.rad(5*math.cos(sine/8)),math.rad(40+5*math.cos(sine/8)))},"Linear","Out",0.1)
			SetTween(RH,{C0=CFrame.new(.5,-.9-.1*math.cos(sine/8),-.4+.4*math.cos(sine/8))*angles(math.rad(-50+35*math.cos(sine/8)),math.rad(5*math.cos(sine/8)),math.rad(-15*math.cos(sine/8)))},"Linear","InOut",0.1)
			SetTween(LH,{C0=CFrame.new(-.5,-.9+.1*math.cos(sine/8),-.4-.4*math.cos(sine/8))*angles(math.rad(-50-35*math.cos(sine/8)),math.rad(5*math.cos(sine/8)),math.rad(-15*math.cos(sine/8)))},"Linear","InOut",0.1)
			if tailw then SetTween(tailw,{C0=CF(-.2*math.cos(sine/8),0,.30+.15*math.sin(sine/4))*ANGLES(mr(80+10*math.sin(sine/4)),mr(10*math.cos(sine/8)),mr(10-30*math.cos(sine/8)))},"Linear","In",.1) end
			Swait()
			if (Humanoid.MoveDirection * Vector3.new(1,0,1)).Magnitude > .5 then laying = false end
		end
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"
		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"
		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
		attack = false
	end

	if key == "r" and pantdown and not reap then
		attack = true 
		local laying = true
		while laying do
			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-1.8)*angles(math.rad(140),math.rad(5*math.cos(sine/8)),math.rad(5*math.cos(sine/8)))},"Linear","InOut",0.1)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-100),math.rad(15*math.sin(sine/8)),0)},"Linear","InOut",0.1)
			SetTween(RW,{C0=CFrame.new(1.0,1,0)*angles(math.rad(210),math.rad(5*math.cos(sine/8)),math.rad(40+5*math.cos(sine/8)))},"Linear","Out",0.1)
			SetTween(LW,{C0=CFrame.new(-1.0,1,0)*angles(math.rad(210),math.rad(5*math.cos(sine/8)),math.rad(-40+5*math.cos(sine/8)))},"Linear","Out",0.1)
			SetTween(RH,{C0=CFrame.new(.5,-0.7,0)*angles(math.rad(130+5*math.cos(sine/8)),math.rad(15*math.sin(sine/8)),math.rad(-15*math.cos(sine/8)))},"Linear","InOut",0.1)
			SetTween(LH,{C0=CFrame.new(-.5,-0.7,0)*angles(math.rad(130-5*math.cos(sine/8)),math.rad(-15*math.sin(sine/8)),math.rad(-15*math.cos(sine/8)))},"Linear","InOut",0.1)
			Swait()
			if (Humanoid.MoveDirection * Vector3.new(1,0,1)).Magnitude > .5 then laying = false end
		end
		attack = false
	end

	if key == "z" and not attack then Attack1() end
	
	if key == "t" and not attack then
		attack = true
		SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(0,0,math.rad(30))},"Back","Out",0.3)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(-30))},"Back","Out",0.3)
		SetTween(RW,{C0=CFrame.new(1.3,0.5,0)*angles(math.rad(120),0,math.rad(-40))},"Back","Out",0.3)
		SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Back","Out",0.3)
		SetTween(RH,{C0=CFrame.new(.5,-1,0)},"Back","Out",0.3)
		SetTween(LH,{C0=CFrame.new(-.5,-1,0)},"Back","Out",0.3)	
		Swait(9)	
		so("875978120", Torso, 4, .9)
		change = 4.3
		for i = 1,4,0.1 do 
			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-.1-.05*math.cos(sine/8))*angles(math.rad(1+1*math.cos(sine/8)),0,math.rad(30+1*math.cos(sine/8)))},"Quad","InOut",0.1)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(0,0,math.rad(-30+1*math.cos(sine/8)))},"Quad","InOut",0.1)
			SetTween(RW,{C0=CFrame.new(1.3,0.5,0)*angles(math.rad(120),0,math.rad(-40))},"Quad","InOut",0.1)
			SetTween(LW,{C0=CFrame.new(-1.5,0.5,0)},"Quad","InOut",0.1)
			SetTween(RH,{C0=CFrame.new(.5,-.95+.05*math.cos(sine/8),-.2+.05*math.cos(sine/8))*angles(math.rad(-10+1*math.cos(sine/8)),math.rad(25*math.cos(sine/16)),0)},"Quad","InOut",0.1)
			SetTween(LH,{C0=CFrame.new(-.5,-.95+.05*math.cos(sine/8),0)*angles(math.rad(1+1*math.cos(sine/8)),0,0)},"Quad","InOut",0.1)	
			Swait()	
		end
		attack = false
	end

	if key == "g" and gpressed and reap then
		gpressed = false
	end

	if key == "g" and not attack and not reap and pantdown then
		attack = true
		gpressed = true
		local target = getmousetarget()
		if target and target.Parent then
			local find = target.Parent:FindFirstChild("HumanoidRootPart") or target.Parent:FindFirstChild("Torso")
			local find2 = target.Parent:FindFirstChildOfClass("Humanoid")
			if find and find2 then
				local root = find
				local beforecframeroot = root.CFrame
				local beforecframe = RootPart.CFrame
				local hum = find2
				root.Anchored = true
				root.CFrame = root.CFrame * CFrame.new(0,-2.5,0) * angles(math.rad(90),0,0)
				
				local Poof = Instance.new("Part")
				Poof.Parent = Player.Character
				Poof.Transparency = 1
				Poof.Size = Vector3.new(5.5, 3.7, 4.0)
				Poof.CanCollide = false
				Poof.Anchored = true
				local ParticleEmitter1 = Instance.new("ParticleEmitter", Poof)
				ParticleEmitter1.Speed = NumberRange.new(0.5)
				ParticleEmitter1.Rotation = NumberRange.new(0, 360)
				ParticleEmitter1.Enabled = true
				ParticleEmitter1.Texture = "rbxassetid://244221440"
				ParticleEmitter1.Transparency = NumberSequence.new(0.9,0.9)
				ParticleEmitter1.Size = NumberSequence.new(3.72,3.72)
				ParticleEmitter1.Acceleration = Vector3.new(0,1,0)
				ParticleEmitter1.Lifetime = NumberRange.new(0.1,0.2)
				ParticleEmitter1.Rate = 20000
				ParticleEmitter1.SpreadAngle = Vector2.new(360,360)
				ParticleEmitter1.VelocitySpread = 360
				
				Poof.CFrame = root.CFrame * CFrame.Angles(0,0,math.rad(90)) * CFrame.new(0,0,-2)
				RootPart.Anchored = true
				RootPart.CFrame = root.CFrame * CFrame.new(0,-0.2,0) * angles(math.rad(-90),0,0)
				RootPart.CFrame = RootPart.CFrame * CFrame.new(0,1.5,0) * angles(0,math.rad(180),0)
				
				task.spawn(function()
					task.wait(0.3)
					ParticleEmitter1.Enabled = false
					Debris:AddItem(Poof, 2)
				end)
				
				local D = Instance.new("Model", target.Parent)
				local Part1 = Instance.new("Part", D)
				Part1.Size = Vector3.new(0.06,0.95,0.22)
				Part1.BrickColor = BrickColor.new("Terra Cotta")
				Part1.CanCollide = false
				local SM2 = Instance.new("SpecialMesh", Part1)
				SM2.Scale = Vector3.new(0.91,0.3,0.91)
				SM2.MeshType = Enum.MeshType.Sphere
				local W1 = Instance.new("Weld", Part1)
				W1.Part0, W1.Part1 = Part1, root

				local Part4 = Instance.new("Part", D)
				Part4.Size = Vector3.new(0.31,0.31,0.31)
				Part4.BrickColor = BrickColor.new("Salmon")
				Part4.Shape = Enum.PartType.Ball
				Part4.CanCollide = false
				local W2 = Instance.new("Weld", Part4)
				W2.Part0, W2.Part1 = Part4, root

				local Part6 = Instance.new("Part", D)
				Part6.Size = Vector3.new(0.79,0.31,0.31)
				Part6.BrickColor = BrickColor.new("Pastel brown")
				Part6.Shape = Enum.PartType.Cylinder
				Part6.CanCollide = false
				local W3 = Instance.new("Weld", Part6)
				W3.Part0, W3.Part1 = Part6, root
				
				task.wait(0.2)
				for i = 0,0.1,0.1 do SetTween(NeckW,{C0=NeckCF},"Quad","InOut",0.1) end
				local times = 0
				reap = true
				eyes.Texture = "http://www.roblox.com/asset/?id=2801605712"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801768094"
				brows.Texture = "http://www.roblox.com/asset/?id=2801716156"
				blush.Texture = "http://www.roblox.com/asset/?id=2801785860"
				extra.Texture = "http://www.roblox.com/asset/?id=2801786177"
				
				repeat
					times = times + 1
					for i = 0,0.8,0.1 do
						SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-2.9, 0, 3.14)},"Quad","InOut",0.1)
						SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(30),0,math.rad(-25))},"Quad","InOut",0.1)
						SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(30),0,math.rad(25))},"Quad","InOut",0.1)
						SetTween(LW,{C0=CFrame.new(-1.5, 0.4, -.0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
						SetTween(RW,{C0=CFrame.new(1.5, 0.4, -.0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
						Swait()
					end
					for i = 0,0.8,0.1 do
						SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-3.05, 0, 3.14)},"Quad","InOut",0.1)
						SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(45),0,math.rad(-25))},"Quad","InOut",0.1)
						SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(45),0,math.rad(25))},"Quad","InOut",0.1)
						SetTween(LW,{C0=CFrame.new(-1.5, 0.4, -.0)*angles(math.rad(100),0,0)},"Quad","InOut",0.1)
						SetTween(RW,{C0=CFrame.new(1.5, 0.4, -.0)*angles(math.rad(100),0,0)},"Quad","InOut",0.1)
						Swait()
					end
					local sound = s2c:Clone()
					sound.Parent = Torso
					sound.SoundId = "rbxassetid://836796971"
					sound.Volume = 10
					sound:Play()
					Debris:AddItem(sound, 2)
					task.wait(0.5)
				until times > 20 or gpressed == false
				
				eyes.Texture = "http://www.roblox.com/asset/?id=2801605473"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801778896"
				brows.Texture = "http://www.roblox.com/asset/?id=3523931787"
				blush.Texture = "http://www.roblox.com/asset/?id=3523974768"
				
				repeat
					times = times + 1
					for i = 0,0.5,0.1 do
						SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-2.9, 0, 3.14)},"Quad","InOut",0.1)
						SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(30),0,math.rad(-25))},"Quad","InOut",0.1)
						SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(30),0,math.rad(25))},"Quad","InOut",0.1)
						SetTween(LW,{C0=CFrame.new(-1.5, 0.4, -.0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
						SetTween(RW,{C0=CFrame.new(1.5, 0.4, -.0)*angles(math.rad(90),0,0)},"Quad","InOut",0.1)
						Swait()
					end
					local sound = s2c:Clone()
					sound.Parent = Torso
					sound.SoundId = "rbxassetid://836796971"
					sound.Volume = 10
					sound:Play()
					Debris:AddItem(sound, 2)
					for i = 0,0.5,0.1 do
						SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-3.05, 0, 3.14)},"Quad","InOut",0.1)
						SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(45),0,math.rad(-25))},"Quad","InOut",0.1)
						SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(45),0,math.rad(25))},"Quad","InOut",0.1)
						SetTween(LW,{C0=CFrame.new(-1.5, 0.4, -.0)*angles(math.rad(100),0,0)},"Quad","InOut",0.1)
						SetTween(RW,{C0=CFrame.new(1.5, 0.4, -.0)*angles(math.rad(100),0,0)},"Quad","InOut",0.1)
						Swait()
					end
					task.wait(0.2)
				until times > 35 or gpressed == false
				
				D:Destroy()
				root.CFrame = beforecframeroot
				root.Anchored = false
				RootPart.CFrame = beforecframe
				RootPart.Anchored = false
				reap = false
				attack = false
				eyes.Texture = "http://www.roblox.com/asset/?id=2801594656"
				mouth.Texture = "http://www.roblox.com/asset/?id=2801759987"
				brows.Texture = "http://www.roblox.com/asset/?id=2801716156"
				blush.Texture = "http://www.roblox.com/asset/?id=2801785860"
				extra.Texture = "http://www.roblox.com/asset/?id=0"
			end
		end
	end

	if key == "c" and not pant and not attack and not pantdown then
		attack = true
		RootPart.Anchored = true
		pant = true
		pantdown = true
		eyes.Texture = "http://www.roblox.com/asset/?id=2801585179"
		mouth.Texture = "http://www.roblox.com/asset/?id=2801731770"
		brows.Texture = "http://www.roblox.com/asset/?id=0"
		blush.Texture = "http://www.roblox.com/asset/?id=3523972935"
		
		if Model13 then
			for _,v in pairs(Model13:GetChildren()) do
				if v:IsA("BasePart") then v.Transparency = 1 end
			end
		end
		local pants = Character:FindFirstChild("Pants")
		if pants then pants.PantsTemplate = "rbxassetid://0" end
		
		attack = false
		pant = false
		RootPart.Anchored = false
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594656"
		mouth.Texture = "http://www.roblox.com/asset/?id=2801759987"
		brows.Texture = "http://www.roblox.com/asset/?id=2801716156"
		blush.Texture = "http://www.roblox.com/asset/?id=2801785860"
	elseif key == "c" and not attack and pantdown then
		pant = true
		pantdown = false
		eyes.Texture = "http://www.roblox.com/asset/?id=3523956852"
		mouth.Texture = "http://www.roblox.com/asset/?id=2801751305"
		brows.Texture = "http://www.roblox.com/asset/?id=2801697189"
		blush.Texture = "http://www.roblox.com/asset/?id=3523974768"
		
		if Model13 then
			for _,v in pairs(Model13:GetChildren()) do
				if v:IsA("BasePart") then v.Transparency = 0 end
			end
		end
		local pants = Character:FindFirstChild("Pants")
		if pants then pants.PantsTemplate = "rbxassetid://3109544120" end
		
		pant = false
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"
		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"
		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
		blush.Texture = "http://www.roblox.com/asset/?id=0"
	end
	
	if key == "v" and not attack then
		shirtdown = not shirtdown
		if shirtdown then
			if Model0 then
				for _,v in pairs(Model0:GetChildren()) do
					if v:IsA("BasePart") then v.Transparency = 1 end
				end
			end
		else
			if Model0 then
				for _,v in pairs(Model0:GetChildren()) do
					if v:IsA("BasePart") then v.Transparency = 0 end
				end
			end
		end
	end

	if key == "p" and not attack and Player.Name == "robloxGT25" then
		if not mememode then
			mememode = true
			lastid = "http://www.roblox.com/asset/?id=836590183"
			lastsongpos = 0
			if s2 then s2.TimePosition = 0 end
		else
			mememode = false
			CurId = CurId - 1
			KeyDownF("n")
		end
	end

	if key == "m" then	
		if playsong then
			playsong = false	
			if s2 then s2:Pause() end
		else
			playsong = true	
			if s2 then s2:Resume() end
		end
	end

	if key == "n" then	
		KeyDownF("n")
	end
end)

b = Player:GetMouse().Button1Down:Connect(Button1DownF)
c = Player:GetMouse().Button1Up:Connect(Button1UpF)

Humanoid.Died:Connect(function()
	stop:Fire()
	if a then a:Disconnect() end
	if b then b:Disconnect() end
	if c then c:Disconnect() end
end)

-- FINAL FIX: Force the entire fake clone to be invisible so it vanishes
for _,v in ipairs(non:GetDescendants()) do
	if v:IsA('BasePart') then
		v.Transparency = 1
		v.CanCollide = false
	end
end
