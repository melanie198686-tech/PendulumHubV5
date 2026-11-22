--[[
 ts made by pandora on discord ellernate.lol

    Accesory
      Ears  MeshPart rbxassetid://1003673450  size 1.51,1.26,0.95   HatAttachment
      Fur   MeshPart rbxassetid://437432504   size 0.752,0.724,0.82 HatAttachment
      Hair  MeshPart rbxassetid://728936337   size 2.075,1.517,1.836 HairAttachment
      Tail  Part size 0.99,2.03,2.45 + SpecialMesh FileMesh 170939831 scale 1, own attachment at -0.2,-0.9,-2.3003
      Shirt rbxassetid://10248083, Pants rbxassetid://3109544120, BodyColors 255,204,153 on every part,
      CharacterMesh Head (BodyPart 1) MeshId 461333403.
      Fur color 248,248,248.  Not checked on a live game: whether MeshId can be set on your executor (falls back
      to a SpecialMesh at scale 1, which is uncalibrated and tunable with the size buttons).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local genv = (getgenv and getgenv()) or _G
if genv.__NekoHub then
	pcall(genv.__NekoHub.Destroy)
end

local CONFIG = {
	Ears = {
		Tune = 1, -- extra size multiplier for this part
		MeshId = "rbxassetid://1003673450",
		Size = Vector3.new(1.51, 1.26, 0.95),
		Slot = "HatAttachment",
		Own = CFrame.new(0, 0.1585, -0.05, 0.9998480677604675, 0, 0.01743638888001442, 0, 1, 0, -0.01743638888001442, 0, 0.9998480677604675),
	},
	Fur = {
		Tune = 1, -- extra size multiplier for this part
		MeshId = "rbxassetid://437432504",
		Size = Vector3.new(0.752, 0.724, 0.82),
		Slot = "HatAttachment",
		Own = CFrame.new(0, 0.1585, -0.05, 0.9998480677604675, 0, 0.01743638888001442, 0, 1, 0, -0.01743638888001442, 0, 0.9998480677604675),
	},
	Hair = {
		Tune = 1, -- extra size multiplier for this part
		MeshId = "rbxassetid://728936337",
		Size = Vector3.new(2.075, 1.517, 1.836),
		Slot = "HairAttachment",
		Own = CFrame.new(0, 0.583, 0.0653, -0.9998480081558228, 0, -0.017436381429433823, 0, 1, 0, 0.017436381429433823, 0, -0.9998480081558228),
	},
	Tail = {
		Tune = 1, -- extra size multiplier for this part
		MeshId = "http://www.roblox.com/asset/?id=170939831",
		Size = Vector3.new(0.99, 2.03, 2.45),
		Slot = "WaistFrontAttachment",
		Own = CFrame.new(-0.2, -0.9, -2.3003),
	},
	Face = {
		Eyes = "http://www.roblox.com/asset/?id=2801594973",
		Mouth = "http://www.roblox.com/asset/?id=2801759774",
		Brows = "http://www.roblox.com/asset/?id=2801687635",
	},
	Outfit = {
		Shirt = "rbxassetid://10248083",
		Pants = "rbxassetid://3109544120",
		Skin = Color3.fromRGB(255, 204, 153),
		HeadMeshId = 461333403,
	},
	AutoMusic = false, -- the original autoplays song 1; M and N still control it
	FurColors = {
		{ "Snow",     Color3.fromRGB(248, 248, 248) },
		{ "Peach",    Color3.fromRGB(255, 204, 153) },
		{ "Ginger",   Color3.fromRGB(226, 155, 64) },
		{ "Charcoal", Color3.fromRGB(70, 70, 78) },
		{ "Rose",     Color3.fromRGB(255, 176, 200) },
	},
	Music = {
		"617334987", "3464477488", "198665867", "493674525",
		"1407647013", "3959469093", "4236597955", "3852221223",
	},
	ScaleStep = 0.1, ScaleMin = 0.1, ScaleMax = 6,
}

local lp = Players.LocalPlayer
local state = {
	ears = true, tail = true, hair = true, face = true,
	furIndex = 1, scale = 1,
	anim = true, combo = true,
}

local conns = {}
local gui
local function track(c) conns[#conns + 1] = c; return c end
local function fur() return CONFIG.FurColors[state.furIndex][2] end

local function getParts()
	local char = lp.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not (head and head:IsA("BasePart") and torso and torso:IsA("BasePart") and hum) then return end
	return char, head, torso, hum.RigType == Enum.HumanoidRigType.R15
end

local FALLBACK_SLOT = {
	HatAttachment = CFrame.new(0, 0.6, 0),
	HairAttachment = CFrame.new(0, 0.6, 0),
	WaistFrontAttachment = CFrame.new(0, -1, -0.5),
}
local function slotCF(base, name)
	local a = base:FindFirstChild(name)
	if a and a:IsA("Attachment") then return a.CFrame end
	return FALLBACK_SLOT[name]
end

-- a runtime MeshPart snaps to the mesh's native size when the mesh finishes loading, so the target is enforced
local function lockSize(p, target)
	p:SetAttribute("NekoSize", target)
	p.Size = target
	p:GetPropertyChangedSignal("Size"):Connect(function()
		local want = p:GetAttribute("NekoSize")
		if want and (p.Size - want).Magnitude > 0.001 then p.Size = want end
	end)
end

-- MeshPart when MeshId is writable on this executor, otherwise Part + SpecialMesh (scale 1, uncalibrated)
local AssetService = game:GetService("AssetService")
local function meshContent(def)
	local id = tostring(def.MeshId):match("%d+")
	return "rbxassetid://" .. id
end

local function tryMeshPart(def)
	local content = meshContent(def)
	-- 1) engine-sized MeshPart (the mesh's native size is known to the engine)
	local ok, mp = pcall(function() return AssetService:CreateMeshPartAsync(content) end)
	if ok and typeof(mp) == "Instance" and mp:IsA("MeshPart") then return mp, "CreateMeshPartAsync" end
	-- 2) plain MeshPart with MeshId written normally
	ok, mp = pcall(function()
		local m = Instance.new("MeshPart")
		m.MeshId = content
		return m
	end)
	if ok and mp and mp.MeshId ~= "" then return mp, "MeshPart.MeshId" end
	-- 3) MeshPart with MeshId written through the executor's hidden-property setter
	if sethiddenproperty then
		ok, mp = pcall(function()
			local m = Instance.new("MeshPart")
			sethiddenproperty(m, "MeshId", content)
			return m
		end)
		if ok and mp and mp.MeshId ~= "" then return mp, "sethiddenproperty" end
	end
end

local function makeMesh(name, def, parent)
	local p, how = tryMeshPart(def)
	local usedFallback = false
	if not p then
		-- 4) SpecialMesh: renders at the mesh's native size times Scale, and the native size is not known
		usedFallback = true
		how = "SpecialMesh fallback (size is NOT fitted, use Tune)"
		p = Instance.new("Part")
		local sm = Instance.new("SpecialMesh")
		sm.MeshType = Enum.MeshType.FileMesh
		sm.MeshId = meshContent(def)
		sm.Scale = Vector3.new(state.scale * def.Tune, state.scale * def.Tune, state.scale * def.Tune)
		sm.Parent = p
	end
	print(("[NekoHub] %s: %s"):format(name, how))
	p.Name = name
	local target = def.Size * state.scale * def.Tune
	if p:IsA("MeshPart") then lockSize(p, target) else p.Size = target end
	p.Color = fur()
	p.Material = Enum.Material.SmoothPlastic
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	p.Parent = parent
	return p, usedFallback
end

local function removeTagged(name)
	local char = lp.Character
	if not char then return end
	local o = char:FindFirstChild(name)
	while o do o:Destroy(); o = char:FindFirstChild(name) end
end

local function weldOnto(part, base, c0, c1)
	local w = Instance.new("Weld")
	w.Name = "NekoWeld"
	w.Part0 = base
	w.Part1 = part
	w.C0 = c0
	w.C1 = c1
	w.Parent = part
	return w
end

local function applyHat(name, def, baseSelect)
	removeTagged(name)
	local char, head, torso = getParts()
	if not char then return end
	local base = baseSelect == "torso" and torso or head
	local p = makeMesh(name, def, char)
	return weldOnto(p, base, slotCF(base, def.Slot), def.Own)
end

local function applyEars() applyHat("NekoEars", CONFIG.Ears, "head"); applyHat("NekoFur", CONFIG.Fur, "head") end
local function clearEars() removeTagged("NekoEars"); removeTagged("NekoFur") end
local function applyHair() applyHat("NekoHair", CONFIG.Hair, "head") end
local function clearHair() removeTagged("NekoHair") end

-- tail: tailw / tailc0 are globals because the ported animation code writes tailw.C0 directly
local dummyTailWeld = Instance.new("Weld")
tailw = dummyTailWeld
tailc0 = CFrame.new()
local function applyTail()
	removeTagged("NekoTail")
	local char, _, torso = getParts()
	if not char then return end
	local p = makeMesh("NekoTail", CONFIG.Tail, char)
	local w = weldOnto(p, torso, slotCF(torso, CONFIG.Tail.Slot), CONFIG.Tail.Own)
	tailw, tailc0 = w, w.C0
end
local function clearTail()
	removeTagged("NekoTail")
	tailw, tailc0 = dummyTailWeld, CFrame.new()
end

-- face decals are always created (invisible when the face is off) because the ported moves write to them
local origFace = {}
local function ensureFace()
	local char, head = getParts()
	if not char then return end
	if eyes and eyes.Parent == head then return end
	local function mk(tex)
		local d = Instance.new("Decal")
		d.Name = "NekoFace"
		d.Face = Enum.NormalId.Front
		d.Texture = tex
		d.Transparency = 1
		d.Parent = head
		return d
	end
	eyes, mouth, brows = mk(CONFIG.Face.Eyes), mk(CONFIG.Face.Mouth), mk(CONFIG.Face.Brows)
	blush, extra = mk("rbxassetid://0"), mk("rbxassetid://0")
end
local function setFace(on)
	local char, head = getParts()
	if not char then return end
	ensureFace()
	for _, d in ipairs(head:GetChildren()) do
		if d:IsA("Decal") then
			if d.Name == "NekoFace" then
				d.Transparency = on and 0 or 1
			elseif on then
				if origFace[d] == nil then origFace[d] = d.Transparency end
				d.Transparency = 1
			elseif origFace[d] ~= nil then
				d.Transparency = origFace[d]; origFace[d] = nil
			end
		end
	end
end

local function recolor()
	local char = lp.Character
	if not char then return end
	for _, n in ipairs({ "NekoEars", "NekoFur", "NekoHair", "NekoTail" }) do
		local p = char:FindFirstChild(n)
		if p then p.Color = fur() end
	end
end

local function rescale()
	local char = lp.Character
	if not char then return end
	local map = { NekoEars = CONFIG.Ears, NekoFur = CONFIG.Fur, NekoHair = CONFIG.Hair, NekoTail = CONFIG.Tail }
	for n, def in pairs(map) do
		local p = char:FindFirstChild(n)
		if p then
			local target = def.Size * state.scale * def.Tune
			p:SetAttribute("NekoSize", target)
			p.Size = target
			local sm = p:FindFirstChildOfClass("SpecialMesh")
			if sm then sm.Scale = Vector3.new(state.scale * def.Tune, state.scale * def.Tune, state.scale * def.Tune) end
		end
	end
end


-- ============================== OUTFIT ==============================
local STRIP = { "Accessory", "Hat", "Shirt", "Pants", "ShirtGraphic", "CharacterMesh", "BodyColors" }
local removedItems = {}
local function isStripped(o)
	for _, c in ipairs(STRIP) do
		if o:IsA(c) then return true end
	end
	return false
end

local function stripOutfit()
	local char = lp.Character
	if not char then return end
	for _, o in ipairs(char:GetChildren()) do
		if isStripped(o) and not o.Name:find("^Neko") then
			table.insert(removedItems, o)
			o.Parent = nil
		end
	end
end

local function applyOutfit()
	local char = lp.Character
	if not char then return end
	removeTagged("NekoBodyColors"); removeTagged("NekoShirt"); removeTagged("NekoPants"); removeTagged("NekoHeadMesh")
	local bc = Instance.new("BodyColors")
	bc.Name = "NekoBodyColors"
	local skin = CONFIG.Outfit.Skin
	bc.HeadColor3, bc.TorsoColor3 = skin, skin
	bc.LeftArmColor3, bc.RightArmColor3 = skin, skin
	bc.LeftLegColor3, bc.RightLegColor3 = skin, skin
	bc.Parent = char
	local shirt = Instance.new("Shirt")
	shirt.Name = "NekoShirt"
	shirt.ShirtTemplate = CONFIG.Outfit.Shirt
	shirt.Parent = char
	local pants = Instance.new("Pants")
	pants.Name = "NekoPants"
	pants.PantsTemplate = CONFIG.Outfit.Pants
	pants.Parent = char
	local cm = Instance.new("CharacterMesh")
	cm.Name = "NekoHeadMesh"
	cm.BodyPart = Enum.BodyPart.Head
	cm.MeshId = CONFIG.Outfit.HeadMeshId
	cm.Parent = char
end

local function restoreOutfit()
	local char = lp.Character
	removeTagged("NekoBodyColors"); removeTagged("NekoShirt"); removeTagged("NekoPants"); removeTagged("NekoHeadMesh")
	for _, o in ipairs(removedItems) do
		if char and char.Parent then pcall(function() o.Parent = char end) end
	end
	table.clear(removedItems)
end

local watchConn
local function watchOutfit(char)
	if watchConn then watchConn:Disconnect() end
	-- keeps late-loading accessories and clothing off while the kit is running
	watchConn = char.ChildAdded:Connect(function(o)
		if isStripped(o) and not o.Name:find("^Neko") then
			task.defer(function()
				table.insert(removedItems, o)
				pcall(function() o.Parent = nil end)
			end)
		end
	end)
end

-- ============================== ANIMATION RIG (R6) ==============================
RUN = 0
Anim = "Idle"; inairvel = 0; sine = 0; change = 1; Animstep = 0; WalkAnimMove = 0.05
Combo = 0; attack = false; agresive = false; mememode = false
pantdown = false; shirtdown = false; reap = false; gpressed = false
playsong = false; CurId = 1; lastsongpos = 0
lastid = "http://www.roblox.com/asset/?id=" .. CONFIG.Music[1]
forWFB, forWRL = 0, 0
Hold = false
RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
NeckCF = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

it = Instance.new; vt = Vector3.new; cf = CFrame.new; cn = CFrame.new
euler = CFrame.fromEulerAnglesXYZ; angles = CFrame.Angles; mr = math.rad
IT = Instance.new; CF = CFrame.new; VT = Vector3.new; RAD = math.rad
ANGLES = CFrame.Angles; EULER = CFrame.fromEulerAnglesXYZ
COS, SIN, ABS, MRANDOM, FLOOR = math.cos, math.sin, math.abs, math.random, math.floor
TweenService = game:GetService("TweenService")

function so(id, par, vol, pit)
	task.spawn(function()
		local s = Instance.new("Sound")
		s.Volume = vol or 1
		s.Pitch = pit or 1
		s.SoundId = "http://www.roblox.com/asset/?id=" .. tostring(id)
		s.Parent = par or workspace
		task.wait()
		s:Play()
		game:GetService("Debris"):AddItem(s, 6)
	end)
end

function rayCast(Pos, Dir, Max, Ignore)
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	rp.FilterDescendantsInstances = { Ignore }
	local r = workspace:Raycast(Pos, Dir.Unit * (Max or 999.999), rp)
	return r and r.Instance
end

function SetTween(SPart, CFr, MoveStyle2, outorin2, AnimTime)
	if not SPart then return end
	local dahspeed = 1
	if attack == true and mememode == true then dahspeed = 5 end
	local info = TweenInfo.new(AnimTime / dahspeed, Enum.EasingStyle[MoveStyle2], Enum.EasingDirection[outorin2], 0, false, 0)
	pcall(function() TweenService:Create(SPart, info, CFr):Play() end)
end

-- damage needs the server; the client port keeps the swing visuals only
function CFMagniDamage() end

-- 30 Hz artificial heartbeat, same as the original script
local ArtificialHB = Instance.new("BindableEvent")
local hbAcc = 0
track(RunService.Heartbeat:Connect(function(dt)
	hbAcc += dt
	local step = 1 / 30
	while hbAcc >= step do
		hbAcc -= step
		ArtificialHB:Fire()
	end
end))
function Swait(n)
	if n == nil or n == 0 then
		ArtificialHB.Event:Wait()
	else
		for _ = 1, n do ArtificialHB.Event:Wait() end
	end
end

local savedRig -- what to undo when the rig stops

function Rig_Alive(run)
	return RUN == run and Humanoid and Humanoid.Parent and Humanoid.Health > 0.001
end

function Rig_Stop()
	RUN += 1
	attack, Hold, agresive, mememode = false, false, false, false
	if s2 then pcall(function() s2:Destroy() end); s2 = nil end
	if savedRig then
		for _, w in ipairs(savedRig.welds) do pcall(function() w:Destroy() end) end
		for _, m in ipairs(savedRig.motors) do pcall(function() m.Enabled = true end) end
		if savedRig.animate then pcall(function() savedRig.animate.Disabled = false end) end
		if Humanoid and Humanoid.Parent then
			pcall(function()
				Humanoid.WalkSpeed = savedRig.walk
				Humanoid.JumpPower = savedRig.jump
			end)
		end
		savedRig = nil
	end
end

function Rig_Start()
	Rig_Stop()
	local char = lp.Character
	if not char then return false, "no character" end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.RigType ~= Enum.HumanoidRigType.R6 then return false, "animations need an R6 character" end
	Character = char
	Humanoid = hum
	Torso = char:FindFirstChild("Torso")
	Head = char:FindFirstChild("Head")
	RootPart = char:FindFirstChild("HumanoidRootPart")
	LeftArm, RightArm = char:FindFirstChild("Left Arm"), char:FindFirstChild("Right Arm")
	LeftLeg, RightLeg = char:FindFirstChild("Left Leg"), char:FindFirstChild("Right Leg")
	local RJ = RootPart and RootPart:FindFirstChild("RootJoint")
	local Neck = Torso and Torso:FindFirstChild("Neck")
	local motors = { RJ, Neck,
		Torso and Torso:FindFirstChild("Right Shoulder"), Torso and Torso:FindFirstChild("Left Shoulder"),
		Torso and Torso:FindFirstChild("Right Hip"), Torso and Torso:FindFirstChild("Left Hip") }
	if not (Torso and Head and RootPart and LeftArm and RightArm and LeftLeg and RightLeg and RJ and Neck
		and motors[3] and motors[4] and motors[5] and motors[6]) then
		return false, "R6 joints not found"
	end

	savedRig = { welds = {}, motors = motors, walk = hum.WalkSpeed, jump = hum.JumpPower }
	local function mkWeld(parent, p0, p1, c0, c1, name)
		local w = Instance.new("Weld")
		w.Name = name or "NekoRigWeld"
		w.Part0, w.Part1, w.C0, w.C1 = p0, p1, c0, c1 or CFrame.new()
		w.Parent = parent
		table.insert(savedRig.welds, w)
		return w
	end
	local animate = char:FindFirstChild("Animate")
	if animate and animate:IsA("LuaSourceContainer") then
		animate.Disabled = true
		savedRig.animate = animate
	end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop(0) end

	-- weld values are captured before the motors are switched off
	RJW = mkWeld(RootPart, RJ.Part0, RJ.Part1, RJ.C0, RJ.C1, "NekoRJ")
	NeckW = mkWeld(Torso, Neck.Part0, Neck.Part1, Neck.C0, Neck.C1, "NekoNeck")
	for _, m in ipairs(motors) do m.Enabled = false end
	RW = mkWeld(Torso, Torso, RightArm, cf(1.5, 0.5, 0), cn(0, 0.5, 0), "NekoRS")
	LW = mkWeld(Torso, Torso, LeftArm, cf(-1.5, 0.5, 0), cn(0, 0.5, 0), "NekoLS")
	RH = mkWeld(Torso, Torso, RightLeg, cf(0.5, -0.9, 0), cn(0, 1, 0), "NekoRH")
	LH = mkWeld(Torso, Torso, LeftLeg, cf(-0.5, -0.9, 0), cn(0, 1, 0), "NekoLH")
	-- the claw armor is not ported; the claw tweens in the stance toggle go to these placeholders
	RCW, LCW = Instance.new("Weld"), Instance.new("Weld")
	Effects = Instance.new("Folder"); Effects.Name = "NekoEffects"; Effects.Parent = char
	table.insert(savedRig.welds, Effects)

	ensureFace()
	setFace(true); state.face = true

	s2 = Instance.new("Sound")
	s2.Name = "BGMusic"
	s2.EmitterSize = 30
	s2.Volume = 1.5
	s2.Looped = true
	s2.SoundId = lastid
	s2.Parent = Torso
	s2c = s2:Clone()
	if playsong then s2:Play() end

	attack, agresive, mememode, Combo, Hold = false, false, false, 0, false
	return true
end

function AT1()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(-40))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(40))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(30),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(30),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -.6, -.4)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(20),math.rad(0),math.rad(20))},"Quad","InOut",0.2)





	wait(.2/dahspeed)	

	--coroutine.resume(coroutine.create(function()	
	--	so("1428541279", RightArm,1.6, math.random(120,220)/100)


	CFMagniDamage(RootPart.CFrame*CF(0,-1,-1),7,10,20,20,"Normal")
	--end))

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(-40),math.rad(0),math.rad(40))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-40))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(-30),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(-30),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(120),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(-60),math.rad(0),math.rad(-20))},"Back","Out",0.2)





	wait(.2/dahspeed)	


	attack = false	
end




function AT2()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed

	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(60))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-60))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(90),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -.5, -.4)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)

	CFMagniDamage(RootPart.CFrame*CF(0,-0,-1),9,10,15,0,"Normal")

	wait(.2/dahspeed)	

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(0),math.rad(0),math.rad(-70))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(70))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(-20),math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Back","Out",0.2)


	wait(.2/dahspeed)	
	attack = false		
end

function AT3()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed
	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(120))},"Quad","In",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(90),math.rad(0),math.rad(20))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(20),math.rad(-0),math.rad(-0))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -0)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -.8, 0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)

	wait(.2/dahspeed)	
	CFMagniDamage(RootPart.CFrame*CF(-2,-.25,-1),9,20,30,10,"Knockdown")

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),math.rad(0),math.rad(-0))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(20),math.rad(-0),math.rad(-0))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -0)*angles(math.rad(-40),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	wait(.2/dahspeed)
	attack = false		
end



function AT4()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed

	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(-80))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(-20),math.rad(-70),math.rad(-90))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -.0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -.5, -0.4)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)

	CFMagniDamage(RootPart.CFrame*CF(0,-0,-1),9,30,45,0,"Normal")
	so("3051417237", LeftArm,3, math.random(100,155)/100)
	wait(0.2/dahspeed)	

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),math.rad(0),math.rad(45))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(-45))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(-0),math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(-10),math.rad(0),math.rad(0))},"Back","Out",0.2)


	wait(.2/dahspeed)	
	attack = false		
end





function AT5()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed

	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(80))},"Quad","InOut",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(-80))},"Quad","InOut",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(-20),math.rad(70),math.rad(90))},"Quad","InOut",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(-90))},"Quad","InOut",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -.5, -0.4)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, -0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.2)

	CFMagniDamage(RootPart.CFrame*CF(0,-0,-1),9,30,45,0,"Normal")
	so("3051417237", RightArm,3, math.random(100,155)/80)
	wait(0.2/dahspeed)	

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,0)*angles(math.rad(20),math.rad(0),math.rad(-45))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(45))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(-0),math.rad(0))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, -0)*angles(math.rad(-10),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(20),math.rad(0),math.rad(0))},"Back","Out",0.2)


	wait(.2/dahspeed)	
	attack = false		
end




function AT6()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed


	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1,-.3)*angles(math.rad(45),math.rad(0),math.rad(0))},"Quad","Out",0.3)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-20),math.rad(0),math.rad(0))},"Quad","Out",0.3)
	SetTween(RW,{C0=CFrame.new(1.1 , 0.5, -.3)*angles(math.rad(20),math.rad(115),math.rad(90))},"Quad","In",0.15)
	SetTween(LW,{C0=CFrame.new(-1.1, 0.5, -.3)*angles(math.rad(20),math.rad(-115),math.rad(-90))},"Quad","In",0.15)
	SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(-60),math.rad(0),math.rad(0))},"Quad","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(60),math.rad(0),math.rad(0))},"Quad","Out",0.3)

	so("3051417237", Torso,3,  math.random(140,185)/80)
	CFMagniDamage(RootPart.CFrame*CF(-1.4,-0,-1),9,40,55,10,"Knockdown")
	CFMagniDamage(RootPart.CFrame*CF(1.4,-0,-1),9,40,55,10,"Knockdown")

	wait(0.175/dahspeed)	

	SetTween(RJW,{C0=RootCF*CFrame.new(0,-1.7,-.4)*angles(math.rad(45),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(90))},"Back","Out",0.2)
	SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(-90))},"Back","Out",0.2)
	SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.2)
	SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(65),math.rad(0),math.rad(0))},"Back","Out",0.2)



	wait(.2/dahspeed)	
	attack = false		
end


function AT7()
	attack=true	
	local dahspeed=1
	if attack == true and mememode == true then
		dahspeed=5
	end --/dahspeed
	so("3051417237", Torso,3, .8)

	coroutine.resume(coroutine.create(function()	
		for i = 1,2 do Swait(3)
			so("3051417087", RightArm,3, math.random(100,155)/100) end
	end))
	for i =1,10,1 do 
		SetTween(RJW,{C0=RootCF*CFrame.new(0,-1.7+.17*i,-.4)*angles(math.rad(25-5*i),math.rad(0),math.rad(36*i))},"Quad","Out",0.1)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.2)
		SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(180),math.rad(0),math.rad(90))},"Quad","Out",0.2)
		SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(-90))},"Quad","Out",0.2)
		SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(-25),math.rad(0),math.rad(0))},"Quad","Out",0.2)
		SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(25),math.rad(0),math.rad(0))},"Quad","Out",0.2)
		CFMagniDamage(RootPart.CFrame*CF(1.4,-0,-1+.17*i),9,10,15,10,"Knockdown")
		Swait()
	end



	attack = false		
end
--[[
how to make an cat fly


	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(-20))},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(20))},"Quad","InOut",0.1)
SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.25)*angles(math.rad(0),math.rad(0),math.rad(40))},"Quad","Out",0.1)
SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.1)
SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
Swait(.1*30)
for i = 1,100,0.3 do	
	SetTween(RJW,{C0=RootCF*CFrame.new(-20.5*math.sin(i),20.5*math.cos(i),i/.5)*angles(math.rad(25-4.5*10*i),math.rad(0),math.rad(36*i*2))},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(-80))},"Quad","InOut",0.15)
SetTween(RW,{C0=CFrame.new(1.5 , 0.65, -.0)*angles(math.rad(160+2*i),math.rad(0),math.rad(30-3*i))},"Quad","Out",0.15)
SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.15)
SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(0+6.5*i),math.rad(0),math.rad(0))},"Quad","InOut",0.15)
SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0-6.5*i),math.rad(0),math.rad(0))},"Quad","InOut",0.15)
Swait() end	

	SetTween(RJW,{C0=RootCF*CFrame.new(0,0,20)*angles(math.rad(-20),math.rad(0),math.rad(-20))},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(20))},"Quad","InOut",0.1)
SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.1)
SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.1)
SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(90),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
Swait(1.1*30)


]]--

function ClickCombo()
	if Anim == "Fall" or Anim == "Jump" then
		if Combo == 0 then		
			--DownAT()	
		end
	else
		if agresive == false then				
			if Combo == 0 then
				AT1()	
				Combo = 1
			elseif Combo == 1 then
				AT2()	
				Combo = 2	
			elseif Combo == 2 then
				AT3()
				Combo = 0	
			elseif Combo == 3 then
				Combo = 0	
				ClickCombo()	
			end

		else
			if Combo == 0 then
				AT4()	
				Combo = 1
			elseif Combo == 1 then
				AT5()	
				Combo = 2	
			elseif Combo == 2 then
				AT6()
				Combo = 3	
			elseif Combo == 3 then
				AT7()
				Combo = 0	
			end

		end
	end
end





Hold = false


Button1DownF=function()

	Hold= true
	while Hold == true do
		if attack == false then
			ClickCombo()
		else

		end Swait()
	end








end





Button1UpF=function()

	if Hold==true then

		Hold = false

	end	

end


KeyDownF = function(key)
	if  key == "f"   and attack == false and pantdown == false then
		--Attack1()
		if agresive == false then 
			SetTween(RCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
			SetTween(LCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
			agresive= true
			so("3051417649", RightArm,1.5, .8)
			so("3051417649", LeftArm,1.5, .8)
			eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

			mouth.Texture = "http://www.roblox.com/asset/?id=2801759987"

			brows.Texture = "http://www.roblox.com/asset/?id=2801696705"

			blush.Texture = "http://www.roblox.com/asset/?id=0"

			extra.Texture = "http://www.roblox.com/asset/?id=0"
		else
			SetTween(RCW,{C0=CF(0,-0,0)},"Quad","In",.5)
			SetTween(LCW,{C0=CF(0,-0,0)},"Quad","In",.5)
			agresive= false
			so("3051417791", RightArm,1.5, .8)
			so("3051417791", LeftArm,1.5, .8)
			eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

			mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"

			brows.Texture = "http://www.roblox.com/asset/?id=2801687635"

			blush.Texture = "http://www.roblox.com/asset/?id=0"

			extra.Texture = "http://www.roblox.com/asset/?id=0"
		end

	end

	if  key == "u"   and attack == false then
		attack = true 
		local laying = true
		s2:pause()
		while laying == true do

			eyes.Texture = "http://www.roblox.com/asset/?id=2801585179"----DORMIR
			brows.Texture = "http://www.roblox.com/asset/?id=0"
			SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-1.57, 0, 2.8)*CFrame.new(0,0,-2)*angles(math.rad(85),math.rad(0),math.rad(-90))},"Quad","InOut",0.3)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(40),math.rad(0),math.rad(0))},"Back","Out",0.3)
			SetTween(LH,{C0=CFrame.new(-.6, -.95+.05,0)*angles(math.rad(30),0,math.rad(-6))},"Quad","InOut",0.3)
			SetTween(RH,{C0=CFrame.new(.6, -.95+.05,0)*angles(math.rad(40),0,math.rad(-25))},"Quad","InOut",0.3)
			SetTween(LW,{C0=CFrame.new(-1, 1.3, -0.2)*angles(math.rad(160),0,math.rad(10))},"Quad","InOut",0.3)
			SetTween(RW,{C0=CFrame.new(0.5, 0.1, -0.7)*angles(math.rad(90),0,math.rad(-66))},"Quad","InOut",0.3)	


			SetTween(tailw,{C0=CF(0,-0.8,0.2)*ANGLES(-.0* math.cos(sine / 34 ),0,-.5+.0* math.sin(sine / 22 ))*ANGLES(mr(125+0* math.sin(sine / 22 )),mr(0* math.cos(sine / 34 )),mr(0-0* math.cos(sine / 22 )))},"Linear","In",0.3)
			Swait()
			if (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).magnitude > .5 then
				laying = false	
			end
			eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"---DESPUES DE DORMIR
			brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
		end
		s2:resume()
		attack = false
	end
	if  key == "r"   and attack == false and pantdown == false then


		attack = true 
		local laying = true
		while laying == true do


			eyes.Texture = "http://www.roblox.com/asset/?id=2801584953"

			mouth.Texture = "http://www.roblox.com/asset/?id=2801732538"

			brows.Texture = "http://www.roblox.com/asset/?id=0"

			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-2.20)*angles(math.rad(75),math.rad(5* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )))},"Linear","InOut",0.1)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-40),math.rad(15* math.sin(sine / 8 )),math.rad(0))},"Linear","InOut",0.1)
			SetTween(RW,{C0=CFrame.new(1.0 , 0.5, -.4)*angles(math.rad(160),math.rad(5* math.cos(sine / 8 )),math.rad(-50+5* math.cos(sine / 8 )))},"Linear","Out",0.1)
			SetTween(LW,{C0=CFrame.new(-1.0, 0.5, -.4)*angles(math.rad(160),math.rad(5* math.cos(sine / 8 )),math.rad(40+5* math.cos(sine / 8 )))},"Linear","Out",0.1)
			SetTween(RH,{C0=CFrame.new(.5, -.9-.1* math.cos(sine / 8 ), -.4+.4* math.cos(sine / 8 ))*angles(math.rad(-50+35* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )),math.rad(-15* math.cos(sine / 8 )))},"Linear","InOut",0.1)
			SetTween(LH,{C0=CFrame.new(-.5, -.9+.1* math.cos(sine / 8 ), -.4-.4* math.cos(sine / 8 ))*angles(math.rad(-50-35* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )),math.rad(-15* math.cos(sine / 8 )))},"Linear","InOut",0.1)

			SetTween(tailw,{C0=CF(-.2* math.cos(sine / 8 ),0,.30+.15* math.sin(sine / 4 ))*ANGLES(mr(80+10* math.sin(sine / 4 )),mr(10* math.cos(sine / 8 )),mr(10-30* math.cos(sine / 8 )))},"Linear","In",.1)
			Swait()
			if (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).magnitude > .5 then
				laying = false	
			end
		end

		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774"

		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"

		attack = false

	end
	if  key == "t"   and attack == false then
		--Tuant()
		attack = true

		SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(30))},"Back","Out",0.3)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-30))},"Back","Out",0.3)
		SetTween(RW,{C0=CFrame.new(1.3 , 0.5, -.0)*angles(math.rad(120),math.rad(0),math.rad(-40))},"Back","Out",0.3)
		SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.3)
		SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.3)
		SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Back","Out",0.3)	
		Swait(.3*30)	

		so("875978120", Torso, 4, .9)
		change = 4.3
		for i = 1,4,0.1 do 

			SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-.1-.05* math.cos(sine / 8))*angles(math.rad(1+1* math.cos(sine / 8)),math.rad(0),math.rad(30+1* math.cos(sine / 8)))},"Quad","InOut",0.1)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-30+1* math.cos(sine / 8)))},"Quad","InOut",0.1)
			SetTween(RW,{C0=CFrame.new(1.3 , 0.5, -.0)*angles(math.rad(120),math.rad(0),math.rad(-40))},"Quad","InOut",0.1)
			SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
			SetTween(RH,{C0=CFrame.new(.5, -.95+.05* math.cos(sine / 8), -.2+.05* math.cos(sine / 8))*angles(math.rad(-10+1* math.cos(sine / 8)),math.rad(25* math.cos(sine / 16)),math.rad(0))},"Quad","InOut",0.1)
			SetTween(LH,{C0=CFrame.new(-.5, -.95+.05* math.cos(sine / 8), 0)*angles(math.rad(1+1* math.cos(sine / 8)),math.rad(0),math.rad(0))},"Quad","InOut",0.1)	
			Swait()	
		end
		attack = false
	end
	if  key == "j"   and attack == false then

		attack = true 
		local laying = true----RELAJARSE
		while laying == true do

			SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-1.57, 0, -6.3)*CFrame.new(0,0,-2.5)*angles(math.rad(85),math.rad(0),math.rad(-180))},"Quad","InOut",0.15)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(50),math.rad(0),math.rad(0))},"Back","Out",0.15)
			SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(5),0,math.rad(-15))},"Quad","InOut",0.15)
			SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(5),0,math.rad(15))},"Quad","InOut",0.15)
			SetTween(LW,{C0=CFrame.new(-1.3, 1.3, -0)*angles(math.rad(-190),0,math.rad(40))},"Quad","InOut",0.15)
			SetTween(RW,{C0=CFrame.new(1.3, 1.3, -0)*angles(math.rad(-190),0,math.rad(-40))},"Quad","InOut",0.15)	


			SetTween(tailw,{C0=CF(0,-0.8,0.2)*ANGLES(-.2* math.cos(sine / 999999 ),0,.0+.0* math.sin(sine / 999999 ))*ANGLES(mr(85+0* math.sin(sine / 9999999 )),mr(0* math.cos(sine / 99999 )),mr(0-0* math.cos(sine / 9999 )))},"Linear","In",.1)
			Swait()
			if (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).magnitude > .5 then
				laying = false	
			end

		end
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"
		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
		attack = false
	end
	if  key == "q"   and attack == false and agresive == false then
		attack = true
		RootPart.Anchored = true
		eyes.Texture = "http://www.roblox.com/asset/?id=2801584953"---NO
		brows.Texture = "http://www.roblox.com/asset/?id=0"

		SetTween(LW,{C0=CFrame.new(-1.3, 0.4, -0)*angles(-30,0,math.rad(40))},"Quad","InOut",0.3)
		SetTween(RW,{C0=CFrame.new(1.3, 0.4, -.0)*angles(-30,0,math.rad(-40))},"Quad","InOut",0.3)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(30),math.rad(0),math.rad(30))},"Back","Out",0.5)
		Swait()	
		wait(0.4)

		for i = 0.1,2,1 do 
			wait(0.4)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(30),math.rad(0),math.rad(-30))},"Back","Out",0.5)
			SetTween(LW,{C0=CFrame.new(-1.3, 0.4, -.0)*angles(-30,0,math.rad(1))},"Quad","InOut",0.3)
			SetTween(RW,{C0=CFrame.new(1.3, 0.4, -.0)*angles(-30,0,math.rad(-1))},"Quad","InOut",0.3)
			wait(0.4)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(30),math.rad(0),math.rad(30))},"Back","Out",0.5)
			SetTween(LW,{C0=CFrame.new(-1.3, 0.4, -.0)*angles(-30,0,math.rad(40))},"Quad","InOut",0.3)
			SetTween(RW,{C0=CFrame.new(1.3, 0.4, -.0)*angles(-30,0,math.rad(-40))},"Quad","InOut",0.3)
			wait(0.4)
		end
		attack = false
		RootPart.Anchored = false
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774" --DESPUES DE NO

		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
	end
	if  key == "e"   and attack == false and agresive == false then
		attack = true
		RootPart.Anchored = true
		eyes.Texture = "http://www.roblox.com/asset/?id=2801584953"----SI
		brows.Texture = "http://www.roblox.com/asset/?id=0"
		SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-1.57, 0, 2.8)*CFrame.new(0,0,-0.1)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.3)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(5),math.rad(0),math.rad(0))},"Back","Out",0.3)
		SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(-6),0,math.rad(10))},"Quad","InOut",0.3)
		SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(20),0,math.rad(5))},"Quad","InOut",0.3)
		SetTween(LW,{C0=CFrame.new(-1.1, 0.3, -.0)*angles(-0.4,0,math.rad(40))},"Quad","InOut",0.3)
		Swait()	
		wait(0.4)

		for i = 0.1,2,1 do 
			wait(0.4)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-10),math.rad(0),math.rad(0))},"Back","Out",0.5)

			wait(0.4)
			SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(5),math.rad(0),math.rad(0))},"Back","Out",0.5)

			wait(0.4)
		end
		attack = false
		RootPart.Anchored = false
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774" --DESPUEES DE SI

		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
	end
	if  key == "y"   and attack == false and agresive == false then
		attack = true
		RootPart.Anchored = true
		eyes.Texture = "http://www.roblox.com/asset/?id=2801584953"---HOLA
		brows.Texture = "http://www.roblox.com/asset/?id=0"

		SetTween(RJW,{C0=CFrame.fromEulerAnglesXYZ(-1.57, 0, 2.8)*CFrame.new(0,0,-0.1)*angles(math.rad(20),math.rad(0),math.rad(0))},"Quad","InOut",0.3)
		SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-10),math.rad(-5),math.rad(0))},"Back","Out",0.3)
		SetTween(LH,{C0=CFrame.new(-.5, -.95+.05,0)*angles(math.rad(-6),0,math.rad(10))},"Quad","InOut",0.3)
		SetTween(RH,{C0=CFrame.new(.5, -.95+.05,0)*angles(math.rad(20),0,math.rad(5))},"Quad","InOut",0.3)
		SetTween(LW,{C0=CFrame.new(-1.1, 0.3, -.0)*angles(-0.4,0,math.rad(40))},"Quad","InOut",0.3)
		Swait()	


		for i = 0.1,2,1 do 



			SetTween(RW,{C0=CFrame.new(1.3 , 0.5, 0)*angles(math.rad(210),math.rad(5* math.cos(sine / 80 )),math.rad(60-25* math.cos(sine / 80 )))},"Linear","Out",.2)
			wait(0.2)

			SetTween(RW,{C0=CFrame.new(1.3 , 0.5, 0)*angles(math.rad(210),math.rad(5* math.cos(sine / 80 )),math.rad(60+25* math.cos(sine / 80 )))},"Linear","Out",.2)
			wait(0.2)

			SetTween(RW,{C0=CFrame.new(1.3 , 0.5, 0)*angles(math.rad(210),math.rad(5* math.cos(sine / 80 )),math.rad(60+25* math.cos(sine / 80 )))},"Linear","Out",.2)
			wait(0.2)

			SetTween(RW,{C0=CFrame.new(1.3 , 0.5, 0)*angles(math.rad(210),math.rad(5* math.cos(sine / 80 )),math.rad(60-25* math.cos(sine / 80 )))},"Linear","Out",.2)
			wait(0.2)

		end
		attack = false
		RootPart.Anchored = false
		eyes.Texture = "http://www.roblox.com/asset/?id=2801594973"

		mouth.Texture = "http://www.roblox.com/asset/?id=2801759774" --DESPUES DE HOLA

		brows.Texture = "http://www.roblox.com/asset/?id=2801687635"
	end
	if  key == "p" and attack == false then
		if mememode == false then
			mememode=true

			so("1499015636", Character,3, 1)
			lastid= "http://www.roblox.com/asset/?id=836590183"











			lastsongpos = 0
			s2.TimePosition = lastsongpos


		else
			mememode=false
			CurId=CurId-1
			KeyDownF("n")

		end
	end
	if key == "m" then	

		if playsong == true then
			playsong = false	
			s2:pause()	
		elseif playsong == false then
			playsong = true	


			s2:resume()				
		end

	end


	if key == "n" and mememode == false then	






		CurId = CurId + 1

		if CurId > 8 then
			CurId = 1	

		end
		warn("now playing song Nr"..CurId)
		if CurId == 1 then
			lastid= "http://www.roblox.com/asset/?id=617334987"
		elseif CurId == 2 then
			lastid= "http://www.roblox.com/asset/?id=3464477488"
		elseif CurId == 3 then
			lastid= "http://www.roblox.com/asset/?id=198665867"
		elseif CurId == 4 then
			lastid= "http://www.roblox.com/asset/?id=493674525"
		elseif CurId == 5 then
			lastid= "http://www.roblox.com/asset/?id=1407647013"
		elseif CurId == 6 then
			lastid= "http://www.roblox.com/asset/?id=3959469093"
		elseif CurId == 7 then
			lastid= "http://www.roblox.com/asset/?id=4236597955"
		elseif CurId == 8 then
			lastid= "http://www.roblox.com/asset/?id=3852221223"




		end 


		lastsongpos = 0
		s2.TimePosition = lastsongpos


	end


end

function Rig_Loop(run)
	while Rig_Alive(run) do 
		sine = sine + change
		hitfloor = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)
		if Character:FindFirstChild("Sound") then
			Character:FindFirstChild("Sound"):Destroy()	
		end
		local torvel = (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).magnitude
		local velderp = RootPart.Velocity.y
		if RootPart.Velocity.y > 1 and hitfloor == nil then
			Anim = "Jump"

		elseif RootPart.Velocity.y < -1 and hitfloor == nil then
			Anim = "Fall"
		elseif Humanoid.Sit == true then
			Anim = "Sit"	
		elseif torvel < .5 and hitfloor ~= nil  then
			Anim = "Idle"
		elseif torvel > .5 and  hitfloor ~= nil  then

			Anim = "Walk"




		else
			Anim = ""

		end 


		local Ccf=RootPart.CFrame
		--warn(Humanoid.MoveDirection*RootPart.CFrame.lookVector)
		local Walktest1 = Humanoid.MoveDirection*Ccf.LookVector
		local Walktest2 = Humanoid.MoveDirection*Ccf.RightVector
		--warn(Walktest1.Z.."/"..Walktest1.X)
		--warn(Walktest2.Z.."/"..Walktest2.X)
		forWFB = Walktest1.X+Walktest1.Z
		forWRL = Walktest2.X+Walktest2.Z





		--print(Humanoid.MoveDirection)
		--warn(Torso.CFrame.lookVector)



		coroutine.resume(coroutine.create(function()


			if s2.Parent == nil or s2 == nil  then

				s2 = s2c:Clone()
				s2.Parent = Torso
				s2.Name = "BGMusic"
				--	s2.SoundId = lastid
				s2.Pitch = 1
				s2.Volume = 1.5
				s2.Looped = true
				s2.archivable = false
				s2.TimePosition = lastsongpos
				if playsong == true then
					s2:play()		
				elseif playsong == false then
					s2:stop()			
				end


			else
				lastsongpos=s2.TimePosition		
				s2.Pitch = 1

				s2.Volume = 1.5

				s2.Looped = true
				s2.SoundId = lastid
				s2.EmitterSize = 30
			end



		end))




		inairvel=torvel*1

		--forWRL
		if inairvel > 30 then
			inairvel=30	
		end
		inairvel=inairvel/50*2



		if attack == false then
			if Anim == "Jump" then
				change = 0.60*2
				SetTween(RJW,{C0=RootCF* cn(0, 0 + (0.0395/2) * math.cos(sine / 8), -0.1 + 0.0395 * math.cos(sine / 8)) * angles(math.rad(-6.5 - 1.5 * math.cos(sine / 8))+(inairvel*forWFB)/2, math.rad(0)-(inairvel*forWRL)/2, math.rad(0))},"Quad","Out",0.25)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-26.5 + 2.5 * math.cos(sine / 8)), math.rad(0), math.rad(-0))},"Quad","Out",0.25)
				SetTween(RW,{C0=cf(1.4 + .05 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(140 - 2 * math.cos(sine / 8 )), math.rad(-5), math.rad(8 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
				SetTween(LW,{C0=cf(-1.4 + .05 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(140 - 2 * math.cos(sine / 8 )), math.rad(5), math.rad(-8 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
				SetTween(RH,{C0=CFrame.new(.5, -0.85+ .05 * math.cos(sine / 15), -.2) * CFrame.Angles(math.rad(-15 -1* math.cos(sine / 10)),math.rad(0),math.rad(0))},"Quad","InOut",0.075)
				SetTween(LH,{C0=CFrame.new(-.5, -0.35+ .05 * math.cos(sine / 15), -.4) * CFrame.Angles(math.rad(-25 +1* math.cos(sine / 10)),math.rad(0),math.rad(0))},"Quad","InOut",0.075)



			elseif Anim == "Fall" then 
				change = 0.60*2
				SetTween(RJW,{C0=RootCF*cn(0, 0 + (0.0395/2) * math.cos(sine / 8), -0.5 + 0.0395 * math.cos(sine / 8)) * angles(math.rad(5.5 - 1.5 * math.cos(sine / 8))-(inairvel*forWFB)/2, math.rad(0)+(inairvel*forWRL)/2, math.rad(0))},"Quad","Out",0.35)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(26.5 + 2.5 * math.cos(sine / 8)), math.rad(0), math.rad(-0))},"Quad","Out",0.25)
				SetTween(RW,{C0=cf(1.4 + .05 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(105 - 2 * math.cos(sine / 8 )), math.rad(-15), math.rad(80 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
				SetTween(LW,{C0=cf(-1.4 + .05 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(105 - 2 * math.cos(sine / 8 )), math.rad(15), math.rad(-80 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
				SetTween(RH,{C0=CFrame.new(.5, -0.15+ .05 * math.cos(sine / 15), -.4) * CFrame.Angles(math.rad(-15 -1* math.cos(sine / 10)),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
				SetTween(LH,{C0=CFrame.new(-.5, -0.55+ .05 * math.cos(sine / 15), -.4) * CFrame.Angles(math.rad(-0 +1* math.cos(sine / 10)),math.rad(0),math.rad(0))},"Quad","InOut",0.1)



			elseif Anim == "Idle" then


				local dahspeed=1
				if attack == true and mememode == true then
					dahspeed=5
				end



				if agresive == false then

					change = (0.60*1.75)*dahspeed
					Humanoid.JumpPower = 60	
					Humanoid.WalkSpeed=16	



					local ADNum = 0	
					SetTween(RJW,{C0=RootCF*cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2))) * angles(math.rad(1.5 - 1 * math.cos(sine / 8)), math.rad((0 + 0* math.cos(sine / 8)/20)), math.rad(-20))},"Quad","InOut",0.1)
					SetTween(NeckW,{C0=NeckCF*angles(math.rad(6.5 - 3.5 * math.sin(sine / 8 +ADNum* math.cos(sine / 8*2))), math.rad(2.5-5.5 * math.cos(sine / 16)), math.rad(20 - 6.5 * math.cos(sine / 15 +.4* math.cos(sine / 10))))},"Quad","InOut",0.1)
					SetTween(RW,{C0=cf(1.45 + .0 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(-5), math.rad(4 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
					SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(5), math.rad(-4 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
					SetTween(RH,{C0=CFrame.new(.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(1.5 - 1 * math.cos(sine / 8)),math.rad(0),math.rad(2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
					SetTween(LH,{C0=CFrame.new(-.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(1.5 - 1 * math.cos(sine / 8)),math.rad(20),math.rad(-2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
				else


					change = (0.60*1.75)*dahspeed
					Humanoid.JumpPower = 60	
					Humanoid.WalkSpeed=16	



					local ADNum = 0	
					SetTween(RJW,{C0=RootCF*cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2))) * angles(math.rad(10.5 - 1 * math.cos(sine / 8)), math.rad((0 + 0* math.cos(sine / 8)/20)), math.rad(-5))},"Quad","InOut",0.1)
					SetTween(NeckW,{C0=NeckCF*angles(math.rad(-6.5 - 3.5 * math.sin(sine / 8 +ADNum* math.cos(sine / 8*2))), math.rad(2.5-5.5 * math.cos(sine / 16)), math.rad(5 - 6.5 * math.cos(sine / 15 +.4* math.cos(sine / 10))))},"Quad","InOut",0.1)
					SetTween(RW,{C0=cf(1.45 + .0 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(10 + 3 * math.sin(sine / 8 )), math.rad(25), math.rad(40 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
					SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), .0) * angles(math.rad(10 + 3 * math.sin(sine / 8 )), math.rad(-25), math.rad(-40 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
					SetTween(RH,{C0=CFrame.new(.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(20.5 - 1 * math.cos(sine / 8)),math.rad(0),math.rad(2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
					SetTween(LH,{C0=CFrame.new(-.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(1.5 - 1 * math.cos(sine / 8)),math.rad(20),math.rad(-2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)

				end







			elseif Anim == "Walk" then

				if agresive == false then

					local speed=1.0
					if mememode == true then
						speed=4
					end


					change = 2.4*speed
					Humanoid.JumpPower = 60*speed
					Humanoid.WalkSpeed=16*speed


					local RH2 = cf(-forWRL/7 * math.cos(sine / 8 ),0,forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(-forWFB*30) * math.cos(sine / 8 ),0,math.rad(-forWRL*30) * math.cos(sine / 8 ))
					local LH2 = cf(forWRL/7 * math.cos(sine / 8 ),0,-forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(forWFB*30) * math.cos(sine / 8 ),0,math.rad(forWRL*30) * math.cos(sine / 8 ))

					SetTween(RJW,{C0=RootCF*CFrame.new(0, 0 , -0.05 + 0.055 * math.cos(sine / 4) + -math.sin(sine / 4) / 8) * angles(math.rad((forWFB*2 - forWFB  * math.cos(sine / 4))*7), math.rad((-forWRL*2 - -forWRL  * math.cos(sine / 4))*5) , math.rad(8 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(NeckW,{C0=NeckCF*CFrame.new(0, 0, 0 + 0.025 * math.cos(sine / 4)) * angles(math.rad((-forWFB*1 - -forWFB  * math.cos(sine / 4))*7), math.rad((forWRL*2 - forWRL  * math.cos(sine / 4))*3.5), math.rad(-forWRL*45+-8 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(RW,{C0=cf(1.45 + .0 * math.cos(sine / 8) , 0.5 + forWRL/50* math.cos(sine / 8), 0)   * angles(math.rad(0 + forWFB*15 * math.cos(sine / 8 )), math.rad(0), math.rad(8 + forWRL*5 * math.cos(sine / 8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + forWRL/50  * math.cos(sine / 8), 0)  * angles(math.rad(0 - forWFB*15 * math.cos(sine / 8 )), math.rad(0), math.rad(-8 - forWRL*5 * math.cos(sine / 8 )))},"Linear","Out",WalkAnimMove/speed)
					SetTween(RH,{C0=CFrame.new(.5, -0.85+ .15 * math.sin(sine / 8 ), -.15+.15* math.cos(sine / 8 ))*RH2 * CFrame.Angles(math.rad(0 - 5 * math.cos(sine / 8)),math.rad(0),math.rad(2.5- 0.0 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(LH,{C0=CFrame.new(-.5, -0.85- .15 * math.sin(sine / 8 ), -.15-.15* math.cos(sine / 8 ))*LH2 * CFrame.Angles(math.rad(0 + 5 * math.cos(sine / 8)),math.rad(0),math.rad(-2.5- 0.0 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)


				else



					local speed=1.6
					if mememode == true then
						speed=4
					end


					change = 2.5*speed
					Humanoid.JumpPower = 60*speed
					Humanoid.WalkSpeed=22*speed


					local RH2 = cf(-forWRL/7 * math.cos(sine / 8 ),0,forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(forWFB*89) * math.cos(sine / 8 ),mr(-forWRL*55/2* math.cos(sine / 8 )),math.rad(forWRL*55/1 * math.cos(sine / 8 )))
					local LH2 = cf(forWRL/7 * math.sin(sine / 8 ),0,-forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(forWFB*89) * math.cos(sine / 8 ),mr(forWRL*55/2* math.sin(sine / 8 )),math.rad(-forWRL*55/1* math.sin(sine / 8 )) )

					SetTween(RJW,{C0=RootCF*CFrame.new(forWRL*1 * math.sin(sine / 8),  forWFB*1 * math.sin(sine / 8) , -0.5 - 0.255 * math.cos(sine / 8) + -math.sin(sine / 8) / 8) * angles(math.rad(85+( forWFB  * math.cos(sine / 8))*20), math.rad(( -forWRL  * math.cos(sine / 4))*1) , math.rad((-forWRL  * math.cos(sine / 8))*10))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(NeckW,{C0=NeckCF*CFrame.new(0, 0, 0 + 0.025 * math.cos(sine / 4)) * angles(math.rad(-20+(-forWFB*1 - -forWFB  * math.cos(sine / 4))*5), math.rad((forWRL*2 - forWRL  * math.cos(sine / 4))*3.5), math.rad(-forWRL*45+-8 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(RW,{C0=cf(1.0 + .0 * math.cos(sine / 8) , .5-forWFB*0.5* math.sin(sine / 8), -.4)   * angles(math.rad(95 - forWFB*75 * math.sin(sine / 8 )), math.rad(0), math.rad(-8+(-forWRL*55* math.sin(sine / 8 )) + 10 * math.cos(sine / 8)))},"Linear","Out",WalkAnimMove/speed)
					SetTween(LW,{C0=cf(-1.0 + .0 * math.cos(sine / 8), .5-forWFB*0.5* math.sin(sine / 8), -.4)  * angles(math.rad(95 - forWFB*75 * math.sin(sine / 8 )), math.rad(0), math.rad(8+(forWRL*55* math.cos(sine / 8 )) - 10 * math.cos(sine / 8 )))},"Linear","Out",WalkAnimMove/speed)
					SetTween(RH,{C0=CFrame.new(.5, -0.85- .25 * math.sin(sine / 8 ), -.15-.25* math.sin(sine / 8 ))*RH2 * CFrame.Angles(math.rad(60 - 5 * math.cos(sine / 8)),math.rad(0),math.rad(-2.5- 0.0 * math.cos(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)
					SetTween(LH,{C0=CFrame.new(-.5, -0.85- .25 * math.sin(sine / 8 ), -.15-.25* math.sin(sine / 8 ))*LH2 * CFrame.Angles(math.rad(60 - 5 * math.sin(sine / 8)),math.rad(0),math.rad(2.5- 0.0 * math.sin(sine / 8)))},"Linear","InOut",WalkAnimMove/speed)

					SetTween(tailw,{C0=CF(0,0,.3)*ANGLES(mr(90+10* math.cos(sine / 8 )),0,mr(20* math.cos(sine / 16 )))},"Linear","In",.1)


				end


			elseif Anim == "Sit" then	
				SetTween(RJW,{C0=RootCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
				SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
				SetTween(RW,{C0=CFrame.new(1.5 , 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.1)
				SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.1)
				SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(90),math.rad(0),math.rad(0))},"Quad","InOut",0.1)
				SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(90),math.rad(0),math.rad(0))},"Quad","InOut",0.1)

			end
		end
		if   attack == false and not (agresive==true and Anim == "Walk") then
			SetTween(tailw,{C0=tailc0*CF(0,.2,0)*ANGLES(mr(4+2* math.cos(sine / 8 )),0,mr(20+20* math.cos(sine / 16 )))},"Linear","In",.1)


		end
		Swait(Animstep*30)
	end
end

function Rig_Run()
	local ok, err = Rig_Start()
	if not ok then return false, err end
	local run = RUN
	task.spawn(Rig_Loop, run)
	return true
end

-- ============================== INPUT ==============================
track(UserInputService.InputBegan:Connect(function(i, gp)
	if gp or not state.anim or not savedRig then return end
	if i.UserInputType == Enum.UserInputType.Keyboard then
		task.spawn(function() pcall(KeyDownF, i.KeyCode.Name:lower()) end)
	elseif i.UserInputType == Enum.UserInputType.MouseButton1 and state.combo then
		task.spawn(function() pcall(Button1DownF) end)
	end
end))
track(UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then Hold = false end
end))

local started = false
local function reapplyAll()
	local char = lp.Character
	if not char then return end
	stripOutfit()
	applyOutfit()
	watchOutfit(char)
	if state.ears then applyEars() end
	if state.hair then applyHair() end
	if state.tail then applyTail() end
	ensureFace(); setFace(state.face)
	if state.anim then
		local ok, err = Rig_Run()
		if not ok then warn("[NekoHub] " .. tostring(err)) end
	end
	if CONFIG.AutoMusic and savedRig then
		playsong = true
		if s2 then s2:Play() end
	end
	started = true
end

local function boot(char)
	char:WaitForChild("Humanoid", 10)
	char:WaitForChild("Head", 10)
	char:WaitForChild("Torso", 10)
	task.wait(0.6)
	if genv.__NekoHub and genv.__NekoHub.Token == lp then reapplyAll() end
end

track(lp.CharacterAdded:Connect(function(char) task.spawn(boot, char) end))

local function Destroy()
	Rig_Stop()
	if watchConn then watchConn:Disconnect() end
	clearEars(); clearHair(); clearTail(); setFace(false)
	removeTagged("NekoFace")
	restoreOutfit()
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	table.clear(conns)
	genv.__NekoHub = nil
end

genv.__NekoHub = { Destroy = Destroy, Token = lp }
if lp.Character then task.spawn(boot, lp.Character) end
