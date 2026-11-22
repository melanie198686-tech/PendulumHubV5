--[[
little bit buggy but ts made by uh ellernate.lol
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local genv = (getgenv and getgenv()) or _G
if genv.__NekoHub then
	pcall(genv.__NekoHub.Destroy)
end

local CONFIG = {
	Outfit = {
		Shirt = "http://www.roblox.com/asset/?id=3930744148",
		Pants = nil, -- V5 pants texture is 3930758998; it showed as white legs under the socks, so it is not worn
		Skin = Color3.fromRGB(234, 184, 146), -- the limb mesh color in the model; its BodyColors value (215,197,154) looked off
		TorsoColor = Color3.fromRGB(221, 221, 225), -- sleeve color from the model, under the knit texture
		HeadMeshId = 461333403,
	},
	TorsoKnit = { Texture = "http://www.roblox.com/asset/?id=187645444", Tile = 2 },
	Face = "http://www.roblox.com/asset/?id=388056855",
	AutoMusic = false,
	Music = { "876316256", "148453883", "2899621215", "256006025", "396979089" },
	Pieces = {
		{ Name = "Ears", Base = "Head", Mesh = "rbxassetid://1003673450", Tex = "rbxassetid://4669974668", Scale = Vector3.new(0.00887, 0.02387, 0.019), Tune = 1,
		  Size = Vector3.new(1.51, 1.26, 0.95), Color = Color3.fromRGB(248, 248, 248),
		  Rel = CFrame.new(-0.0413, 0.5217, -0.1249, 1, -0.0076, -0.0003, 0.0076, 1, -0.0004, 0.0003, 0.0004, 1), },
		{ Name = "EarFur", Base = "Head", Mesh = "rbxassetid://437432504", Tex = nil, Scale = Vector3.new(0.00869, 0.0059, 0.00692), Tune = 1,
		  Size = Vector3.new(0.7518, 0.6239, 0.8004), Color = Color3.fromRGB(248, 248, 248),
		  Rel = CFrame.new(0.3887, 0.6907, -0.2073, -0.4221, -0.6682, 0.6127, 0.0801, 0.6457, 0.7594, -0.903, 0.3696, -0.219), },
		{ Name = "Hair2", Base = "Head", Mesh = "rbxassetid://728936337", Tex = "rbxassetid://4669974668", Scale = Vector3.new(1.75996, 1.76657, 1.76505), Tune = 1,
		  Size = Vector3.new(2.2436, 1.8844, 1.8646), Color = Color3.fromRGB(255, 255, 255),
		  Rel = CFrame.new(-0.0748, 0.0407, 0.1266, -1, 0, 0, 0, 1, 0, 0, 0, -1), },
		{ Name = "NeckPiece", Base = "Head", Mesh = "rbxassetid://4342469442", Tex = nil, Scale = Vector3.new(0.99202, 1.35359, 1.21194), Tune = 1,
		  Size = Vector3.new(1.2936, 0.4678, 1.5022), Color = Color3.fromRGB(221, 221, 225),
		  Rel = CFrame.new(-0.0147, -0.3371, -0.0105, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "Hair", Base = "Head", Mesh = "rbxassetid://6934860396", Tex = "rbxassetid://4669974668", Scale = Vector3.new(1.0336, 0.9637, 1.0631), Tune = 1,
		  Size = Vector3.new(1.0333, 0.9637, 1.0631), Color = Color3.fromRGB(202, 203, 209),
		  Rel = CFrame.new(-0.002, -0.6027, 0.1548, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "HairB", Base = "Head", Mesh = "rbxassetid://6865395798", Tex = "rbxassetid://4669974668", Scale = Vector3.new(0.8868, 0.7507, 1.0215), Tune = 1,
		  Size = Vector3.new(1.6379, 1.49, 1.7192), Color = Color3.fromRGB(202, 203, 209),
		  Rel = CFrame.new(-0.0294, 0.0936, 0.1172, 1, -0.0076, -0.0003, 0.0076, 1, -0.0004, 0.0003, 0.0004, 1), },
		{ Name = "HairC", Base = "Head", Mesh = "rbxassetid://6519506432", Tex = "rbxassetid://4669974668", Scale = Vector3.new(1.0077, 0.9981, 1.025), Tune = 1,
		  Size = Vector3.new(1.0077, 0.9981, 1.107), Color = Color3.fromRGB(202, 203, 209),
		  Rel = CFrame.new(-0.0076, -0.0973, 0.069, 1, -0.0076, -0.0003, 0.0076, 1, -0.0004, 0.0003, 0.0004, 1), },
		{ Name = "Glasses", Base = "Head", Mesh = "rbxassetid://4505098015", Tex = "http://www.roblox.com/asset/?id=5066659337", Scale = Vector3.new(1, 0.7314, 1.0359), Tune = 1,
		  Size = Vector3.new(1, 0.73, 1.0359), Color = Color3.fromRGB(163, 162, 165),
		  Rel = CFrame.new(-0.0258, 0.1953, -0.2294, 1, -0.0076, -0.0003, 0.0076, 1, -0.0004, 0.0003, 0.0004, 1), },
		{ Name = "Bow", Base = "Head", Mesh = "rbxassetid://6007909472", Tex = "rbxassetid://6053228896", Scale = Vector3.new(1, 1.2314, 1.0884), Tune = 1,
		  Size = Vector3.new(2, 2.4629, 1.0884), Color = Color3.fromRGB(163, 162, 165),
		  Rel = CFrame.new(0.0065, -0.4878, 1.2869, -1, 0, 0, 0, 0.9848, -0.1737, 0, -0.1737, -0.9848), },
		{ Name = "Collar", Base = "Head", Mesh = "rbxassetid://4487737814", Tex = "http://www.roblox.com/asset/?id=4503276365", Scale = Vector3.new(1.3282, 1.0538, 1.1941), Tune = 1,
		  Size = Vector3.new(1.3282, 1.0538, 1.1941), Color = Color3.fromRGB(163, 162, 165),
		  Rel = CFrame.new(0.0046, -0.5786, -0.1082, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "ArmL", Base = "LeftArm", Mesh = "rbxassetid://2027988282", Tex = nil, Scale = Vector3.new(1, 1, 1), Tune = 1,
		  Size = Vector3.new(1, 2, 1), Color = Color3.fromRGB(234, 184, 146),
		  Rel = CFrame.new(-0.0004, 0.024, -0.001, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "ArmR", Base = "RightArm", Mesh = "rbxassetid://2027988282", Tex = nil, Scale = Vector3.new(1, 1, 1), Tune = 1,
		  Size = Vector3.new(1, 2, 1), Color = Color3.fromRGB(234, 184, 146),
		  Rel = CFrame.new(-0.0002, 0.024, -0.001, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "SleeveL", Base = "LeftArm", Mesh = "rbxassetid://6866262171", Tex = nil, Scale = Vector3.new(1, 0.9653, 1), Tune = 1,
		  Size = Vector3.new(1.0963, 1.8748, 1.0963), Color = Color3.fromRGB(221, 221, 225),
		  Rel = CFrame.new(0.0037, 0.1021, 0.0067, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		  Surface = { Texture = "http://www.roblox.com/asset/?id=187645444", Faces = { 5, 0, 4, 1, 2, 3 }, Tile = 2 }, },
		{ Name = "SleeveR", Base = "RightArm", Mesh = "rbxassetid://6866262171", Tex = nil, Scale = Vector3.new(1.00502, 0.97148, 1), Tune = 1,
		  Size = Vector3.new(1.1018, 1.8868, 1.0963), Color = Color3.fromRGB(221, 221, 225),
		  Rel = CFrame.new(0.0046, 0.0969, 0.0067, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		  Surface = { Texture = "http://www.roblox.com/asset/?id=187645444", Faces = { 5, 0, 4, 1, 2, 3 }, Tile = 2 }, },
		{ Name = "LegL", Base = "LeftLeg", Mesh = "rbxassetid://4450773061", Tex = nil,   Scale = Vector3.new(1.13526, 0.95009, 0.92987), Tune = 1,
  Size = Vector3.new(1.16375, 2.109, 1.0925), Tune = 1,
		  Size = Vector3.new(1.16375, 2.109, 1.0925), Color = Color3.fromRGB(234, 184, 146),
		  Rel = CFrame.new(-0.0367, 0.1293, -0.0012, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "LegR", Base = "RightLeg", Mesh = "rbxassetid://4450771439", Tex = nil, Scale = Vector3.new(1.19501, 1.00009, 0.97881), Tune = 1,
		  Size = Vector3.new(1.225, 2.22, 1.15), Color = Color3.fromRGB(234, 184, 146),
		  Rel = CFrame.new(0.0529, 0.1239, -0.0012, 1, 0, 0, 0, 1, 0, 0, 0, 1), },
		{ Name = "SockL", Base = "LeftLeg", Mesh = "rbxassetid://6721513769", Tex = nil, Scale = Vector3.new(1.06099, 1.09129, 1.03657), Tune = 1,
		  Size = Vector3.new(1.27, 1.75, 1.27), Color = Color3.fromRGB(84, 84, 84),
		  Rel = CFrame.new(-0.0429, -0.2629, -0.0137, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		  Decal = { Texture = "http://www.roblox.com/asset/?id=8131038954", Faces = { 2, 0, 5, 3 } }, },
		{ Name = "SockR", Base = "RightLeg", Mesh = "rbxassetid://6721517477", Tex = nil, Scale = Vector3.new(1.06037, 1.09123, 1.03767), Tune = 1,
		  Size = Vector3.new(1.27, 1.75, 1.27), Color = Color3.fromRGB(84, 84, 84),
		  Rel = CFrame.new(0.0519, -0.26455, -0.0068, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		  Decal = { Texture = "http://www.roblox.com/asset/?id=8131038954", Faces = { 2, 0, 5, 3 } }, },
		{ Name = "Tail", Base = "Torso", Mesh = "rbxassetid://4666737376", Tex = "http://www.roblox.com/asset/?id=4669974668", Scale = Vector3.new(1, 1.1231, 1.049), Tune = 1,
		  Size = Vector3.new(2, 2.2462, 3.1469), Color = Color3.fromRGB(202, 203, 209),
		  Rel = CFrame.new(0.0151, -0.1709, 2.1798, -1, 0, 0, 0, 0.7071, -0.7071, 0, -0.7071, -0.7071), },
	},
}

local lp = Players.LocalPlayer
local state = { anim = true, combo = true }
local conns = {}
local function track(c) conns[#conns + 1] = c; return c end

local function getParts()
	local char = lp.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("Torso")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not (head and head:IsA("BasePart") and torso and torso:IsA("BasePart") and hum) then return end
	return char, head, torso, hum.RigType == Enum.HumanoidRigType.R15
end

local function removeTagged(name)
	local char = lp.Character
	if not char then return end
	local o = char:FindFirstChild(name)
	while o do o:Destroy(); o = char:FindFirstChild(name) end
end

-- ============================== COSMETICS ==============================
local dummyTailWeld = Instance.new("Weld")
tailw = dummyTailWeld
tailc0 = CFrame.new()

local hiddenLimbs = {} -- real arms are hidden while the custom arm meshes are on; legs stay visible under the socks
local BASE_PART = { Head = "Head", Torso = "Torso", LeftArm = "Left Arm", RightArm = "Right Arm", LeftLeg = "Left Leg", RightLeg = "Right Leg" }

local function clearCosmetics()
	local char0 = lp.Character
	local t0 = char0 and char0:FindFirstChild("Torso")
	if t0 then
		for _, o in ipairs(t0:GetChildren()) do
			if o.Name == "NekoKnit" then o:Destroy() end
		end
	end
	for _, def in ipairs(CONFIG.Pieces) do removeTagged("Neko" .. def.Name) end
	tailw, tailc0 = dummyTailWeld, CFrame.new()
	for part, tr in pairs(hiddenLimbs) do
		if part and part.Parent then part.Transparency = tr end
	end
	table.clear(hiddenLimbs)
end

-- a MeshPart is only needed for pieces that carry Texture / Decal children
local AssetService = game:GetService("AssetService")
local function lockSize(p, target)
	p:SetAttribute("NekoSize", target)
	p.Size = target
	p:GetPropertyChangedSignal("Size"):Connect(function()
		local want = p:GetAttribute("NekoSize")
		if want and (p.Size - want).Magnitude > 0.001 then p.Size = want end
	end)
end

local function tryMeshPart(def)
	local content = def.Mesh
	local ok, mp = pcall(function() return AssetService:CreateMeshPartAsync(content) end)
	if ok and typeof(mp) == "Instance" and mp:IsA("MeshPart") then return mp, "CreateMeshPartAsync" end
	ok, mp = pcall(function()
		local m = Instance.new("MeshPart")
		m.MeshId = content
		return m
	end)
	if ok and mp and mp.MeshId ~= "" then return mp, "MeshPart.MeshId" end
	if sethiddenproperty then
		ok, mp = pcall(function()
			local m = Instance.new("MeshPart")
			sethiddenproperty(m, "MeshId", content)
			return m
		end)
		if ok and mp and mp.MeshId ~= "" then return mp, "sethiddenproperty" end
	end
end

local function applyCosmetics()
	clearCosmetics()
	local char, _, torsoPart = getParts()
	if not char then return end
	for face = 0, 5 do
		local t = Instance.new("Texture")
		t.Name = "NekoKnit"
		t.Texture = CONFIG.TorsoKnit.Texture
		t.Face = Enum.NormalId:FromValue(face)
		t.StudsPerTileU, t.StudsPerTileV = CONFIG.TorsoKnit.Tile, CONFIG.TorsoKnit.Tile
		t.Parent = torsoPart
	end
	for _, def in ipairs(CONFIG.Pieces) do
		local base = char:FindFirstChild(BASE_PART[def.Base])
		if base and base:IsA("BasePart") then
			if (def.Base == "LeftArm" or def.Base == "RightArm") and hiddenLimbs[base] == nil then
				hiddenLimbs[base] = base.Transparency
				base.Transparency = 1
			end
			local p, how
			if def.Surface or def.Decal then
				p, how = tryMeshPart(def)
			end
			if p then
				lockSize(p, def.Size * (def.Tune or 1))
			else
				how = "SpecialMesh (no surface textures)"
				p = Instance.new("Part")
				p.Size = def.Size
				local sm = Instance.new("SpecialMesh")
				sm.MeshType = Enum.MeshType.FileMesh
				sm.MeshId = def.Mesh
				sm.TextureId = def.Tex or ""
				sm.Scale = def.Scale * (def.Tune or 1)
				sm.Parent = p
			end
			if def.Surface or def.Decal then print(("[NekoHub] %s: %s"):format(def.Name, how)) end
			p.Name = "Neko" .. def.Name
			p.Color = def.Color
			p.Material = Enum.Material.SmoothPlastic
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.Massless = true
			if p:IsA("MeshPart") then
				if def.Surface then
					for _, face in ipairs(def.Surface.Faces) do
						local t = Instance.new("Texture")
						t.Texture = def.Surface.Texture
						t.Face = Enum.NormalId:FromValue(face)
						t.StudsPerTileU, t.StudsPerTileV = def.Surface.Tile, def.Surface.Tile
						t.Parent = p
					end
				end
				if def.Decal then
					for _, face in ipairs(def.Decal.Faces) do
						local d = Instance.new("Decal")
						d.Texture = def.Decal.Texture
						d.Face = Enum.NormalId:FromValue(face)
						d.Parent = p
					end
				end
			end
			p.Parent = char
			local w = Instance.new("Weld")
			w.Name = "NekoWeld"
			w.Part0 = base
			w.Part1 = p
			w.C0 = def.Rel
			w.Parent = p
			if def.Name == "Tail" then tailw, tailc0 = w, w.C0 end
		end
	end
end

-- one decal for the eyes; the original face decal is hidden while it is on
local origFace = {}
local function setFace(on)
	local char, head = getParts()
	if not char then return end
	local d = head:FindFirstChild("NekoFace")
	if on and not d then
		d = Instance.new("Decal")
		d.Name = "NekoFace"
		d.Face = Enum.NormalId.Front
		d.Texture = CONFIG.Face
		d.Parent = head
	end
	if d then d.Transparency = on and 0 or 1 end
	for _, o in ipairs(head:GetChildren()) do
		if o:IsA("Decal") and o.Name ~= "NekoFace" then
			if on then
				if origFace[o] == nil then origFace[o] = o.Transparency end
				o.Transparency = 1
			elseif origFace[o] ~= nil then
				o.Transparency = origFace[o]; origFace[o] = nil
			end
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
	bc.HeadColor3 = skin
	bc.LeftArmColor3, bc.RightArmColor3 = skin, skin
	bc.LeftLegColor3, bc.RightLegColor3 = skin, skin
	bc.TorsoColor3 = CONFIG.Outfit.TorsoColor
	bc.Parent = char
	local shirt = Instance.new("Shirt")
	shirt.Name = "NekoShirt"
	shirt.ShirtTemplate = CONFIG.Outfit.Shirt
	shirt.Parent = char
	if CONFIG.Outfit.Pants then
		local pants = Instance.new("Pants")
		pants.Name = "NekoPants"
		pants.PantsTemplate = CONFIG.Outfit.Pants
		pants.Parent = char
	end
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
function chatfunc() end

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

	setFace(true)

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

function joke()
attack = true
for i = 1,100,0.1 do	
	SetTween(RJW,{C0=RootCF*CFrame.new(-150.5*(i/10)*math.sin(i),150.5*(i/10)*math.cos(i),10*i*(i/10))*angles(math.rad(25-4.5*10*i),math.rad(0),math.rad(36*i*2))},"Quad","InOut",0.05)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(-80))},"Quad","InOut",0.15)
SetTween(RW,{C0=CFrame.new(1.5 , 0.65, -.0)*angles(math.rad(160+2*i),math.rad(0),math.rad(30-3*i))},"Quad","Out",0.15)
SetTween(LW,{C0=CFrame.new(-1.5, 0.5, -.0)*angles(math.rad(0),math.rad(0),math.rad(0))},"Quad","Out",0.15)
SetTween(RH,{C0=CFrame.new(.5, -1, 0)*angles(math.rad(0+6.5*i),math.rad(0),math.rad(0))},"Quad","InOut",0.15)
SetTween(LH,{C0=CFrame.new(-.5, -1, 0)*angles(math.rad(0-6.5*i),math.rad(0),math.rad(0))},"Quad","InOut",0.15)
Swait() end	
attack = false	
end
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
if  key == "f"   and attack == false then
--Attack1()
if agresive == false then 
SetTween(RCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
SetTween(LCW,{C0=CF(0,-.75,0)},"Quad","Out",.5)
agresive= true
so("3051417649", RightArm,1.5, .8)
so("3051417649", LeftArm,1.5, .8)
so("418252437", Head,5, math.random(20,32)/35)
chatfunc("Claws: ON")
lastid= "http://www.roblox.com/asset/?id=1228696343"
else
	SetTween(RCW,{C0=CF(0,-0,0)},"Quad","In",.5)
SetTween(LCW,{C0=CF(0,-0,0)},"Quad","In",.5)
agresive= false
so("3051417791", RightArm,1.5, .8)
so("3051417791", LeftArm,1.5, .8)
chatfunc("Claws: OFF")
lastid= "http://www.roblox.com/asset/?id=876542935"
end

end
if  key == "r"   and attack == false then


attack = true 
local laying = true
while laying == true do
	

SetTween(RJW,{C0=RootCF*CFrame.new(0,0,-2.20)*angles(math.rad(75),math.rad(5* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )))},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0,0,0)*angles(math.rad(-60),math.rad(15* math.sin(sine / 8 )),math.rad(0))},"Quad","InOut",0.1)
SetTween(RW,{C0=CFrame.new(1 , 1.2, -.9)*angles(math.rad(250),math.rad(5* math.cos(sine / 8 )),math.rad(-15+5* math.cos(sine / 8 )))},"Quad","Out",0.1)
SetTween(LW,{C0=CFrame.new(-1, 1.2, -.9)*angles(math.rad(250),math.rad(5* math.cos(sine / 8 )),math.rad(15+5* math.cos(sine / 8 )))},"Quad","Out",0.1)
SetTween(RH,{C0=CFrame.new(.5, -.9-.1* math.cos(sine / 8 ), -.4+.4* math.cos(sine / 8 ))*angles(math.rad(-50+35* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )),math.rad(-15* math.cos(sine / 8 )))},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5, -.9+.1* math.cos(sine / 8 ), -.4-.4* math.cos(sine / 8 ))*angles(math.rad(-50-35* math.cos(sine / 8 )),math.rad(5* math.cos(sine / 8 )),math.rad(-15* math.cos(sine / 8 )))},"Quad","InOut",0.1)

	SetTween(tailw,{C0=CF(-.2* math.cos(sine / 8 ),0,.30+.15* math.sin(sine / 4 ))*ANGLES(mr(80+10* math.sin(sine / 4 )),mr(10* math.cos(sine / 8 )),mr(10-30* math.cos(sine / 8 )))},"Quad","In",.1)
	Swait()
	if (Humanoid.MoveDirection * Vector3.new(1, 0, 1)).magnitude > .5 then
	laying = false	
	end
end


attack = false


end
if key == "y" and attack == false then
	joke()
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

chatfunc("^v^")
so("3051419970", Character,4, .9)
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
	if key == "m" then	
	
	if playsong == true then
playsong = false	
	s2:stop()	
	elseif playsong == false then
playsong = true	

	
	s2:play()				
	end
					
	end
	if key == "n" and mememode == false then	






CurId = CurId + 1
		
if CurId > 5 then
CurId = 1	

end
chatfunc("now playing song Nr"..CurId)
if CurId == 1 then
lastid= "http://www.roblox.com/asset/?id=876316256"
elseif CurId == 2 then
lastid= "http://www.roblox.com/asset/?id=148453883"
elseif CurId == 3 then
lastid= "http://www.roblox.com/asset/?id=2899621215"
elseif CurId == 4 then
lastid= "http://www.roblox.com/asset/?id=256006025"
elseif CurId == 5 then
lastid= "http://www.roblox.com/asset/?id=396979089"

elseif CurId == 6 then
lastid= "http://www.roblox.com/asset/?id=968322964"



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
SetTween(RW,{C0=cf(1 + .0 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), 0.5) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(-5), math.rad(-15 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
SetTween(LW,{C0=cf(-1 + .0 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), 0.5) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(5), math.rad(15 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
SetTween(RH,{C0=CFrame.new(.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(0 - 1 * math.cos(sine / 8)),math.rad(0),math.rad(-9- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(0 - 1 * math.cos(sine / 8)),math.rad(20),math.rad(9- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
else


				change = (0.60*1.75)*dahspeed
	Humanoid.JumpPower = 60	
	Humanoid.WalkSpeed=16	
	
	
		
local ADNum = 0	
SetTween(RJW,{C0=RootCF*cn(0, 0, -0.1 + 0.0395 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2))) * angles(math.rad(1.5 - 1 * math.cos(sine / 8)), math.rad((0 + 0* math.cos(sine / 8)/20)), math.rad(0))},"Quad","InOut",0.1)
SetTween(NeckW,{C0=NeckCF*angles(math.rad(6.5 - 3.5 * math.sin(sine / 8 +ADNum* math.cos(sine / 8*2))), math.rad(2.5-5.5 * math.cos(sine / 16)), math.rad(20 - 6.5 * math.cos(sine / 15 +.4* math.cos(sine / 10))))},"Quad","InOut",0.1)
SetTween(RW,{C0=cf(1.45 + .0 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), 0) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(-5), math.rad(15 + 4 * math.cos(sine / 8)))},"Quad","Out",0.2)
SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + .05 * math.cos(sine / 8), 0) * angles(math.rad(0 + 3 * math.sin(sine / 8 )), math.rad(5), math.rad(-15 - 4 * math.cos(sine / 8 )))},"Quad","Out",0.2)
SetTween(RH,{C0=CFrame.new(.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(0 - 1 * math.cos(sine / 8)),math.rad(0),math.rad(-9- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)
SetTween(LH,{C0=CFrame.new(-.5, -0.95- .04 * math.cos(sine / 8 +ADNum* math.cos(sine / 8*2)), 0) * CFrame.Angles(math.rad(0 - 1 * math.cos(sine / 8)),math.rad(0),math.rad(9- 0.0 * math.cos(sine / 8)))},"Quad","InOut",0.1)

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

SetTween(RJW,{C0=RootCF*CFrame.new(0, 0 , -0.05 + 0.055 * math.cos(sine / 4) + -math.sin(sine / 4) / 8) * angles(math.rad((forWFB*2 - forWFB  * math.cos(sine / 4))*7), math.rad((-forWRL*2 - -forWRL  * math.cos(sine / 4))*5) , math.rad(8 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0, 0, 0 + 0.025 * math.cos(sine / 4)) * angles(math.rad((-forWFB*1 - -forWFB  * math.cos(sine / 4))*7), math.rad((forWRL*2 - forWRL  * math.cos(sine / 4))*3.5), math.rad(-forWRL*45+-8 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(RW,{C0=cf(1.45 + .0 * math.cos(sine / 8) , 0.5 + forWRL/50* math.cos(sine / 8), 0)   * angles(math.rad(0 + forWFB*15 * math.cos(sine / 8 )), math.rad(0), math.rad(8 + forWRL*5 * math.cos(sine / 8)))},"Quad","Out",WalkAnimMove/speed)
SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + forWRL/50  * math.cos(sine / 8), 0)  * angles(math.rad(0 - forWFB*15 * math.cos(sine / 8 )), math.rad(0), math.rad(-8 - forWRL*5 * math.cos(sine / 8 )))},"Quad","Out",WalkAnimMove/speed)
SetTween(RH,{C0=CFrame.new(.5, -0.85+ .15 * math.sin(sine / 8 ), -.15+.15* math.cos(sine / 8 ))*RH2 * CFrame.Angles(math.rad(0 - 5 * math.cos(sine / 8)),math.rad(0),math.rad(2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(LH,{C0=CFrame.new(-.5, -0.85- .15 * math.sin(sine / 8 ), -.15-.15* math.cos(sine / 8 ))*LH2 * CFrame.Angles(math.rad(0 + 5 * math.cos(sine / 8)),math.rad(0),math.rad(-2.5- 0.0 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)

	
	else
	
	
	
	local speed=1.6
if mememode == true then
	speed=4
end


	change = 2.5*speed
	Humanoid.JumpPower = 60*speed
	Humanoid.WalkSpeed=22*speed


	local RH2 = cf(-forWRL/9 * math.cos(sine / 8 ),0,forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(-forWFB*60) * math.cos(sine / 8 ),0,math.rad(-forWRL*25) * math.cos(sine / 8 ))
	local LH2 = cf(forWRL/9 * math.cos(sine / 8 ),0,-forWFB/7 * math.cos(sine / 8 ))*angles(math.rad(forWFB*60) * math.cos(sine / 8 ),0,math.rad(forWRL*25) * math.cos(sine / 8 ))

SetTween(RJW,{C0=RootCF*CFrame.new(0, 0 , -0.05 - 0.1 * math.cos(sine / 4) + -math.sin(sine / 4) / 8) * angles(math.rad(forWFB*25 - -forWFB), math.rad((-forWRL*2 - -forWRL  * math.cos(sine / 4))*0) , math.rad(8 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(NeckW,{C0=NeckCF*CFrame.new(0, 0, 0 + 0.025 * math.cos(sine / 4)) * angles(math.rad(0), math.rad((forWRL*2 - forWRL  * math.cos(sine / 4))*3.5), math.rad(-forWRL*45+-8 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(RW,{C0=cf(1.5 + .0 * math.cos(sine / 8) , 0.5 + .05 * math.cos(sine / 8), 0) * angles(math.rad(forWFB*-65 - -forWFB), math.rad(-5), math.rad(6 - 6 * math.cos(sine / 8)))},"Quad","Out",0.2)
SetTween(LW,{C0=cf(-1.45 + .0 * math.cos(sine / 8), 0.5 + .05  * math.cos(sine / 8), 0)  * angles(math.rad(forWFB*-65 - -forWFB), math.rad(5), math.rad(-6 +6 * math.cos(sine / 8 )))},"Quad","Out",0.2)
SetTween(RH,{C0=CFrame.new(.5, -0.95+ .25 * math.sin(sine / 8 ), -.1+.25* math.cos(sine / 8 ))*RH2 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0- 0.0 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)
SetTween(LH,{C0=CFrame.new(-.5, -0.95- .25 * math.sin(sine / 8 ), -.1-.25* math.cos(sine / 8 ))*LH2 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0- 0.0 * math.cos(sine / 8)))},"Quad","InOut",WalkAnimMove/speed)

		
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
		SetTween(tailw,{C0=tailc0*CF(0,.2,0)*ANGLES(mr(4+2* math.cos(sine / 8 )),0,mr(20+20* math.cos(sine / 16 )))},"Quad","In",.1)
	
		
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

local function reapplyAll()
	local char = lp.Character
	if not char then return end
	stripOutfit()
	applyOutfit()
	watchOutfit(char)
	applyCosmetics()
	setFace(true)
	if state.anim then
		local ok, err = Rig_Run()
		if not ok then warn("[NekoHub] " .. tostring(err)) end
	end
	if CONFIG.AutoMusic and savedRig then
		playsong = true
		if s2 then s2:Play() end
	end
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
	clearCosmetics()
	setFace(false)
	removeTagged("NekoFace")
	restoreOutfit()
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	table.clear(conns)
	genv.__NekoHub = nil
end

genv.__NekoHub = { Destroy = Destroy, Token = lp }
if lp.Character then task.spawn(boot, lp.Character) end
