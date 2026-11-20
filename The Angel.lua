-- Created by Nebula_Zorua --
-- The Angel --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local RArm = Char:FindFirstChild("Right Arm") or Char:FindFirstChild("RightUpperArm")
local LArm = Char:FindFirstChild("Left Arm") or Char:FindFirstChild("LeftUpperArm")
local RLeg = Char:FindFirstChild("Right Leg") or Char:FindFirstChild("RightUpperLeg")
local LLeg = Char:FindFirstChild("Left Leg") or Char:FindFirstChild("LeftUpperLeg")
local Root = Char:FindFirstChild("HumanoidRootPart")
local Torso = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
local Head = Char:FindFirstChild("Head")

if not (Hum and Root and Torso and Head and RArm and LArm and RLeg and LLeg) then
	warn("Character is missing required R6/body parts.")
	return
end

local NeutralAnims = true
local Attack = false
local Effects = {}
local Debounces = { Debounces = {} }
local Mouse = Plr:GetMouse()
local Hit = {}
local Sine = 0
local Change = 1
local PulseTime = 0
local Rooted = false

--// Debounce System \\--
function Debounces:New(name, cooldown)
	local obj = {
		Usable = true,
		Cooldown = cooldown or 2,
		CoolingDown = false,
		LastUse = 0,
	}
	setmetatable(obj, { __index = Debounces })
	Debounces.Debounces[name] = obj
	return obj
end

function Debounces:Use(overrideUsable)
	assert(self.Usable ~= nil and self.LastUse ~= nil and self.CoolingDown ~= nil, "Expected ':' not '.' calling member function Use")
	if self.Usable or overrideUsable then
		self.Usable = false
		self.CoolingDown = true
		local lastUse = time()
		self.LastUse = lastUse
		task.delay(self.Cooldown or 2, function()
			if self.LastUse == lastUse then
				self.CoolingDown = false
				self.Usable = true
			end
		end)
	end
end

function Debounces:Get(name)
	assert(typeof(name) == "string", ("bad argument #1 to 'get' (string expected, got %s)"):format(typeof(name)))
	return Debounces.Debounces[name]
end

function Debounces:GetProgressPercentage()
	if not self.Usable then
		return math.clamp(math.floor(((time() - self.LastUse) / (self.Cooldown or 2)) * 100), 0, 100)
	end
	return 100
end

--// Shortcut Variables \\--
local CF = {
	N = CFrame.new,
	A = CFrame.Angles,
	fEA = CFrame.fromEulerAnglesXYZ,
}
local C3 = {
	N = Color3.new,
	RGB = Color3.fromRGB,
	HSV = Color3.fromHSV,
	tHSV = Color3.toHSV,
}
local V3 = {
	N = Vector3.new,
	FNI = Vector3.FromNormalId,
	A = Vector3.FromAxis,
}
local M = {
	C = math.cos,
	R = math.rad,
	S = math.sin,
	P = math.pi,
	RNG = function(min, max, div)
		return math.random(min, max) / (div or 1)
	end,
	MRS = math.randomseed,
	H = math.huge,
	RRNG = function(min, max, div)
		return math.rad(math.random(min, max) / (div or 1))
	end,
}
local R3 = { N = Region3.new }
local WS = workspace
local IN = Instance.new

--// Instance Creation Functions \\--
local function Sound(parent, id, pitch, volume, looped, effect, autoPlay)
	local s = IN("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id or 0)
	s.Pitch = pitch or 1
	s.Volume = volume or 1
	s.Looped = looped or false
	if autoPlay then
		task.spawn(function()
			if not s.IsLoaded then
				s.Loaded:Wait()
			end
			s.Playing = true
		end)
	end
	if not looped and effect then
		s.Stopped:Connect(function()
			s.Volume = 0
			s:Destroy()
		end)
	elseif effect then
		warn("Sound can't be looped and a sound effect!")
	end
	s.Parent = parent or Torso
	return s
end

local function Part(parent, color, material, size, cframe, anchored, cancollide)
	local part = IN("Part")
	if typeof(color) == "BrickColor" then
		part.BrickColor = color
	else
		part.Color = color or C3.N(0, 0, 0)
	end
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Size = size or V3.N(1, 1, 1)
	part.CFrame = cframe or CF.N(0, 0, 0)
	part.Anchored = (anchored == nil) and true or anchored
	part.CanCollide = cancollide or false
	part.Parent = parent or Char
	return part
end

local function Mesh(parent, meshtype, meshid, textid, scale, offset)
	local class = (meshtype == Enum.MeshType.Brick) and "BlockMesh" or "SpecialMesh"
	local m = IN(class)
	if class == "SpecialMesh" then
		m.MeshId = meshid or ""
		m.TextureId = textid or ""
		m.MeshType = meshtype or Enum.MeshType.Sphere
	end
	m.Scale = scale or V3.N(1, 1, 1)
	m.Offset = offset or V3.N(0, 0, 0)
	m.Parent = parent
	return m
end

local function NewInstance(instance, parent, properties)
	local inst = IN(instance)
	if properties then
		for k, v in pairs(properties) do
			pcall(function()
				inst[k] = v
			end)
		end
	end
	inst.Parent = parent
	return inst
end

local function ClearChildrenOfClass(where, class, recursive)
	local list = recursive and where:GetDescendants() or where:GetChildren()
	for _, v in ipairs(list) do
		if v:IsA(class) then
			v:Destroy()
		end
	end
end

--// Customization \\--
local Frame_Speed = 75
local Remove_Hats = false
local Remove_Clothing = false
local PlayerSize = 1
local DamageColor = BrickColor.new("New Yeller")
local MusicID = 835120625

if Remove_Hats then
	ClearChildrenOfClass(Char, "Accessory", true)
end
if Remove_Clothing then
	ClearChildrenOfClass(Char, "Clothing", true)
	ClearChildrenOfClass(Char, "ShirtGraphic", true)
end
ClearChildrenOfClass(Char, "Decal", true)

local EffectsFolder = IN("Folder")
EffectsFolder.Name = "Effects"
EffectsFolder.Parent = Char

local Halo = IN("Model")
Halo.Name = "Halo"
Halo.Parent = Char

local Wings = IN("Model")
Wings.Name = "Wings"
Wings.Parent = Char

Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

local naeeym2 = IN("BillboardGui")
naeeym2.AlwaysOnTop = true
naeeym2.Size = UDim2.new(5, 35, 2, 15)
naeeym2.StudsOffset = V3.N(0, 2.5, 0)
naeeym2.Adornee = Head
naeeym2.Name = "NameTag"
naeeym2.PlayerToHideFrom = Plr
naeeym2.Parent = Char

local tecks2 = IN("TextLabel")
tecks2.BackgroundTransparency = 1
tecks2.TextScaled = true
tecks2.BorderSizePixel = 0
tecks2.Text = "The Angel"
tecks2.Font = Enum.Font.Bodoni
tecks2.TextSize = 30
tecks2.TextStrokeTransparency = 0
tecks2.TextColor3 = C3.N(0, 0, 0)
tecks2.TextStrokeColor3 = C3.N(1, 1, 0)
tecks2.Size = UDim2.new(1, 0, 0.5, 0)
tecks2.Parent = naeeym2

pcall(function()
	if Char:FindFirstChild("LeftWing") then
		Char.LeftWing:Destroy()
	end
	if Char:FindFirstChild("ReaperShadowHead") then
		Char.ReaperShadowHead:Destroy()
	end
end)

for _, v in ipairs(Char:GetChildren()) do
	if v:IsA("BasePart") and v.Transparency < 1 and v ~= Head then
		NewInstance("SelectionBox", v, { Adornee = v, LineThickness = 0.01, Color3 = C3.N(1, 1, 0) })
		if v ~= Head and not v:FindFirstChildOfClass("BlockMesh") then
			IN("BlockMesh").Parent = v
		end
	end
end

local HaloHandle = NewInstance("Part", Halo, {
	Size = V3.N(0.05, 0.05, 0.05),
	Transparency = 1,
	CanCollide = false,
	Anchored = false,
	Locked = true,
	Massless = true,
})

local WingHandle = NewInstance("Part", Wings, {
	Size = V3.N(0.05, 0.05, 0.05),
	Transparency = 1,
	CanCollide = false,
	Anchored = false,
	Locked = true,
	Massless = true,
})

for i = 1, 360, 5 do
	local part = NewInstance("Part", Halo, {
		BrickColor = BrickColor.new("New Yeller"),
		Material = Enum.Material.Neon,
		Size = V3.N(0.69, 0.1, 0.3),
		Anchored = false,
		CanCollide = false,
		Locked = true,
		Transparency = 0.6,
		Massless = true,
	})
	NewInstance("Weld", part, {
		Part0 = HaloHandle,
		Part1 = part,
		C0 = CF.A(0, M.R(i), 0) * CF.N(0, 0, -0.6),
	})
end

if PlayerSize ~= 1 then
	for _, v in ipairs(Char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Size = v.Size * PlayerSize
		end
	end
end

local Music = Sound(Char, MusicID, 1, 3, true, false, true)
Music.Name = "Music"

-- Wing Creation
local FeatherWelds = { {}, {} }
local inc = 1
for aa = 1, 4 do
	local lastFeather
	FeatherWelds[1][aa] = {}
	for _ = 1, 4 + inc do
		local feather = NewInstance("Part", Wings, {
			CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0),
			Size = V3.N(2, 0.5, 0.75),
			CanCollide = false,
			Color = C3.N(1, 1, 1),
			Massless = true,
		})
		NewInstance("SpecialMesh", feather, { MeshType = Enum.MeshType.Sphere })
		if lastFeather then
			table.insert(FeatherWelds[1][aa], NewInstance("Weld", feather, {
				Part0 = lastFeather,
				Part1 = feather,
				C0 = CF.N(0.5, 0.25, 0) * CF.A(0, 0, M.R(-5)),
			}))
		else
			table.insert(FeatherWelds[1][aa], NewInstance("Weld", feather, {
				Part0 = WingHandle,
				Part1 = feather,
				C0 = CF.N(-2, aa / 4, 0) * CF.A(0, 0, M.R(-5)),
			}))
		end
		lastFeather = feather
	end
	inc += 1
end

inc = 1
for aa = 1, 4 do
	local lastFeather
	FeatherWelds[2][aa] = {}
	for _ = 1, 4 + inc do
		local feather = NewInstance("Part", Wings, {
			CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0),
			Size = V3.N(2, 0.5, 0.75),
			CanCollide = false,
			Color = C3.N(1, 1, 1),
			Massless = true,
		})
		NewInstance("SpecialMesh", feather, { MeshType = Enum.MeshType.Sphere })
		if lastFeather then
			table.insert(FeatherWelds[2][aa], NewInstance("Weld", feather, {
				Part0 = lastFeather,
				Part1 = feather,
				C0 = CF.N(-0.5, 0.25, 0) * CF.A(0, 0, M.R(5)),
			}))
		else
			table.insert(FeatherWelds[2][aa], NewInstance("Weld", feather, {
				Part0 = WingHandle,
				Part1 = feather,
				C0 = CF.N(2, aa / 4, 0) * CF.A(0, 0, M.R(5)),
			}))
		end
		lastFeather = feather
	end
	inc += 1
end

--// Stop animations & setup Motor6Ds \\--
for _, v in ipairs(Hum:GetPlayingAnimationTracks()) do
	v:Stop()
end
pcall(game.Destroy, Char:FindFirstChild("Animate"))
pcall(game.Destroy, Hum:FindFirstChild("Animator"))

for _, joint in ipairs(Char:GetDescendants()) do
	if joint:IsA("JointInstance") then
		joint:Destroy()
	end
end

local function makeJoint(name, part0, part1, c0, c1)
	local m = IN("Motor6D")
	m.Name = name
	m.Part0 = part0
	m.Part1 = part1
	m.C0 = c0 or CF.N()
	m.C1 = c1 or CF.N()
	m.Parent = Torso
	return m
end

local LS = makeJoint("LeftShoulder", Torso, LArm, CF.N(-1.5 * PlayerSize, 0.5 * PlayerSize, 0), CF.N(0, 0.5 * PlayerSize, 0))
local RS = makeJoint("RightShoulder", Torso, RArm, CF.N(1.5 * PlayerSize, 0.5 * PlayerSize, 0), CF.N(0, 0.5 * PlayerSize, 0))
local NK = makeJoint("Neck", Torso, Head, CF.N(0, 1.5 * PlayerSize, 0), CF.N())
local LH = makeJoint("LeftHip", Torso, LLeg, CF.N(-0.5 * PlayerSize, -1 * PlayerSize, 0), CF.N(0, 1 * PlayerSize, 0))
local RH = makeJoint("RightHip", Torso, RLeg, CF.N(0.5 * PlayerSize, -1 * PlayerSize, 0), CF.N(0, 1 * PlayerSize, 0))
local RJ = IN("Motor6D")
RJ.Name = "RootJoint"
RJ.Part0 = Root
RJ.Part1 = Torso
RJ.Parent = Root

local HW = makeJoint("HaloWeld", Head, HaloHandle, CF.N(0, 2, 0), CF.N())
local WW = makeJoint("WingWeld", Torso, WingHandle, CF.N(0, 1.5, 1.5), CF.N())

--// Artificial HB \\--
local ArtificialHB = IN("BindableEvent")
ArtificialHB.Name = "Heartbeat"
ArtificialHB.Parent = Char

local tf = 0
local frame = 1 / Frame_Speed

RunService.Heartbeat:Connect(function(s)
	tf += s
	if tf >= frame then
		for _ = 1, math.floor(tf / frame) do
			ArtificialHB:Fire()
		end
		tf -= frame * math.floor(tf / frame)
	end
end)

local function swait(num)
	local count = (num == nil or num == 0) and 1 or num
	for _ = 1, count do
		ArtificialHB.Event:Wait()
	end
end

--// Effect & Helper Functions \\--
local function Chat2(text)
	task.spawn(function()
		if Char:FindFirstChild("ChatGUI") then
			Char.ChatGUI:Destroy()
		end
		local BBG = NewInstance("BillboardGui", Char, {
			Name = "ChatGUI",
			Size = UDim2.new(0, #text * 28, 0, 40),
			StudsOffset = V3.N(0, 3, 0),
			Adornee = Head,
		})
		local offset = 0
		for i = 1, #text do
			task.delay(i / 25, function()
				if not BBG.Parent then
					return
				end
				local Txt = NewInstance("TextLabel", BBG, {
					Text = text:sub(i, i),
					Position = UDim2.new(0, offset, 0, 0),
					BackgroundTransparency = 1,
					TextColor3 = C3.N(1, 1, 0),
					BorderSizePixel = 0,
					Font = Enum.Font.Garamond,
					TextSize = 36,
					TextStrokeTransparency = 0,
					Size = UDim2.new(0, 28, 1, 0),
				})
				offset += 28
				while Txt and Txt.Parent do
					Txt.Rotation = M.RNG(-15, 15)
					swait()
				end
			end)
		end
		task.delay((#text / 25) + 3, function()
			if BBG and BBG.Parent then
				BBG:Destroy()
			end
		end)
	end)
end

local function Transparency(trans)
	for _, v in ipairs(Char:GetChildren()) do
		if v:IsA("BasePart") and v ~= Root and v ~= HaloHandle and v ~= WingHandle then
			v.Transparency = trans
			local sbox = v:FindFirstChildOfClass("SelectionBox")
			if sbox then
				sbox.Transparency = trans
			end
		elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
			v.Handle.Transparency = trans
		end
	end
	for _, v in ipairs(Wings:GetChildren()) do
		if v:IsA("BasePart") and v ~= WingHandle then
			v.Transparency = trans
		end
	end
	for _, v in ipairs(Halo:GetChildren()) do
		if v:IsA("BasePart") and v ~= HaloHandle then
			v.Transparency = trans
		end
	end
end

local FXTable = {}

local function Bezier(startpos, pos2, pos3, endpos, t)
	local A = startpos:Lerp(pos2, t)
	local B = pos2:Lerp(pos3, t)
	local C = pos3:Lerp(endpos, t)
	return A:Lerp(B, t):Lerp(B:Lerp(C, t), t)
end

task.spawn(function()
	while true do
		for i = #FXTable, 1, -1 do
			local data = FXTable[i]
			if data then
				local FX = data.Effect or "ResizeAndFade"
				local Frames = data.Frames or 45
				local CFra = data.CFrame or Torso.CFrame
				local MoveDir = data.MoveDirection
				local Settings = data.FXSettings or {}
				local Prt, Msh = data.Part, data.Mesh
				local grow = data.Grow

				if Prt and Prt.Parent then
					if FX ~= "Arc" then
						local Frame = (data.Frame or 0) + 1
						if FX == "Fade" then
							Prt.Transparency = Frame / Frames
						elseif FX == "Resize" or FX == "ResizeAndFade" then
							local endSize = Settings.EndSize or V3.N(0, 0, 0)
							if Settings.EndIsIncrement then
								if Msh then
									Msh.Scale += endSize
								else
									Prt.Size += endSize
								end
							elseif grow then
								if Msh then
									Msh.Scale -= grow / Frames
								else
									Prt.Size -= grow / Frames
								end
							end
							if FX == "ResizeAndFade" then
								Prt.Transparency = Frame / Frames
							end
						end
						if Settings.RandomizeCFrame then
							Prt.CFrame *= CF.A(M.RRNG(-360, 360), M.RRNG(-360, 360), M.RRNG(-360, 360))
						end
						if MoveDir then
							local moveSpeed = (CFra.Position - MoveDir).Magnitude / Frames
							Prt.CFrame = CF.N(Prt.Position, MoveDir) * CF.N(0, 0, -moveSpeed)
						end
						data.Frame = Frame
						if Prt.Transparency >= 1 or Frame >= Frames then
							Prt:Destroy()
							table.remove(FXTable, i)
						end
					else
						local startCF = Settings.Start
						local endP = Settings.End or (Settings.Home and Settings.Home.CFrame)
						local t = math.clamp((data.Frame or 0) + (Settings.Speed or 0.03), 0, 1)
						if startCF and endP then
							local q1 = Settings.Third or startCF:Lerp(endP, 0.25) * CF.N(M.RNG(-15, 15), M.RNG(0, 15), M.RNG(-15, 15))
							local q2 = Settings.Fourth or startCF:Lerp(endP, 0.75) * CF.N(M.RNG(-15, 15), M.RNG(0, 15), M.RNG(-15, 15))
							Prt.CFrame = Bezier(startCF, q1, q2, endP, t)
							data.Frame = t
							if t >= 1 then
								if Settings.RemoveOnGoal then
									Prt:Destroy()
								end
								table.remove(FXTable, i)
							end
						else
							table.remove(FXTable, i)
						end
					end
				else
					table.remove(FXTable, i)
				end
			end
		end
		swait()
	end
end)

local function Effect(data)
	local FX = data.Effect or "ResizeAndFade"
	local Parent = data.Parent or EffectsFolder
	local Color = data.Color or C3.N(0, 0, 0)
	local Size = data.Size or V3.N(1, 1, 1)
	local Frames = data.Frames or 45
	local Manual = data.Manual
	local Material = data.Material
	local CFra = data.CFrame or Torso.CFrame
	local Settings = data.FXSettings or {}
	local Shape = data.Shape or Enum.PartType.Block

	local Prt, Msh
	if Manual and typeof(Manual) == "Instance" and Manual:IsA("BasePart") then
		Prt = Manual
	else
		Prt = Part(Parent, Color, Material, Size, CFra, true, false)
		Prt.Shape = Shape
	end

	local MeshData = data.Mesh
	if typeof(MeshData) == "table" then
		Msh = Mesh(Prt, MeshData.MeshType, MeshData.MeshId, MeshData.TextureId, MeshData.Scale, MeshData.Offset)
	elseif typeof(MeshData) == "Instance" then
		Msh = MeshData:Clone()
		Msh.Parent = Prt
	elseif Shape == Enum.PartType.Block then
		Msh = Mesh(Prt, Enum.MeshType.Brick)
	end

	local baseSize = Msh and Msh.Scale or Size
	data.Part = Prt
	data.Mesh = Msh
	data.Frame = 0
	data.Grow = baseSize - (Settings.EndSize or baseSize / 2)
	table.insert(FXTable, data)
	return Prt, Msh
end

local function Zap(data)
	local sCF, eCF = data.StartCFrame, data.EndCFrame
	if not sCF or not eCF then
		return
	end
	local parts = data.PartCount or 15
	local zapRot = data.ZapRotation or { -5, 5 }
	local startThick = data.StartSize or 3
	local endThick = data.EndSize or startThick / 2
	local color = data.Color or BrickColor.new("Electric blue")
	local delayFrames = data.Delay or 20
	local delayInc = data.DelayInc or 0
	local lastLightning
	local magZ = (sCF.Position - eCF.Position).Magnitude
	local thick = startThick
	local inc = (startThick - endThick) / parts

	for i = 1, parts do
		local pos = sCF.Position
		if lastLightning then
			pos = (lastLightning.CFrame * CF.N(0, 0, magZ / parts / 2)).Position
		end
		delayFrames += delayInc
		local zapPart = Part(EffectsFolder, color, Enum.Material.Neon, V3.N(thick, thick, magZ / parts), CF.N(pos), true, false)
		if i == parts then
			local remMag = (pos - eCF.Position).Magnitude
			zapPart.Size = V3.N(endThick, endThick, remMag)
			zapPart.CFrame = CF.N(pos, eCF.Position) * CF.N(0, 0, -remMag / 2)
			Effect({
				Effect = "ResizeAndFade",
				Size = V3.N(thick, thick, thick),
				CFrame = eCF * CF.A(M.RRNG(-180, 180), M.RRNG(-180, 180), M.RRNG(-180, 180)),
				Color = color,
				Frames = math.max(10, delayFrames * 2),
				FXSettings = { EndSize = V3.N(thick * 6, thick * 6, thick * 6) },
			})
		else
			local posie = (CF.N(pos, eCF.Position) * CF.N(0, 0, magZ / parts)).Position
				+ V3.N(M.RNG(zapRot[1], zapRot[2]), M.RNG(zapRot[1], zapRot[2]), M.RNG(zapRot[1], zapRot[2]))
			zapPart.CFrame = CF.N(pos, posie) * CF.N(0, 0, magZ / parts / 2)
		end
		lastLightning = zapPart
		Effect({ Effect = "Fade", Manual = zapPart, Frames = math.max(5, delayFrames) })
		thick -= inc
	end
end

local function CastRay(startPos, endPos, range, ignoreList)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignoreList or { Char }
	local dir = (endPos - startPos)
	local dist = math.min(range or 1000, dir.Magnitude)
	if dir.Magnitude > 0 then
		local res = WS:Raycast(startPos, dir.Unit * dist, params)
		if res then
			return res.Instance, res.Position, res.Normal, res.Distance
		end
	end
	return nil, startPos + (dir.Magnitude > 0 and dir.Unit * dist or V3.N(0, -1, 0) * dist), V3.N(0, 1, 0), dist
end

local function WingFlutter(Alpha)
	Alpha = Alpha or 0.1
	for x = 1, 4 do
		if FeatherWelds[1][x][1] then
			FeatherWelds[1][x][1].C0 = FeatherWelds[1][x][1].C0:Lerp(CF.N(-2 - 0.5 * M.C(Sine / 24), x / 4, -0.2 * -M.S(Sine / 24)), Alpha)
		end
		for i = 2, #FeatherWelds[1][x] do
			FeatherWelds[1][x][i].C0 = FeatherWelds[1][x][i].C0:Lerp(CF.N(0.5, 0.25, 0) * CF.A(0, 0, M.R(-5 + 2 * M.C(Sine / 12))), Alpha)
		end
	end
	for x = 1, 4 do
		if FeatherWelds[2][x][1] then
			FeatherWelds[2][x][1].C0 = FeatherWelds[2][x][1].C0:Lerp(CF.N(2 + 0.5 * M.C(Sine / 24), x / 4, -0.4 * M.S(Sine / 24)), Alpha)
		end
		for i = 2, #FeatherWelds[2][x] do
			FeatherWelds[2][x][i].C0 = FeatherWelds[2][x][i].C0:Lerp(CF.N(-0.5, 0.25, 0) * CF.A(0, 0, M.R(5 - 2 * M.C(Sine / 12))), Alpha)
		end
	end
end

local function clerp(startCF, endCF, alpha)
	return startCF:Lerp(endCF, alpha)
end

local function GetTorso(charModel)
	return charModel:FindFirstChild("Torso")
		or charModel:FindFirstChild("UpperTorso")
		or charModel:FindFirstChild("LowerTorso")
		or charModel:FindFirstChild("HumanoidRootPart")
end

local function ShowDamage(Pos, Text, Time, Color)
	local rate = 1 / 30
	local duration = Time or 1.5
	local textColor = Color or C3.N(1, 0, 1)
	local EffectPart = Part(WS, textColor, Enum.Material.SmoothPlastic, V3.N(0.1, 0.1, 0.1), CF.N(Pos), true, false)
	EffectPart.Transparency = 1
	EffectPart.Name = "Effect"

	local BBG = NewInstance("BillboardGui", EffectPart, {
		Size = UDim2.new(2, 0, 1, 0),
		Adornee = EffectPart,
		AlwaysOnTop = true,
	})
	NewInstance("TextLabel", BBG, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = tostring(Text),
		Font = Enum.Font.ArialBold,
		TextColor3 = textColor,
		TextStrokeColor3 = C3.N(0, 0, 0),
		TextStrokeTransparency = 0,
		TextScaled = true,
	})
	Debris:AddItem(EffectPart, duration + 0.1)

	task.spawn(function()
		local frames = math.max(1, math.floor(duration / rate))
		for frameIdx = 1, frames do
			task.wait(rate)
			if not EffectPart.Parent then
				break
			end
			local pct = frameIdx / frames
			EffectPart.CFrame = CF.N(Pos) + V3.N(0, pct * 1.5, 0)
		end
		if EffectPart and EffectPart.Parent then
			EffectPart:Destroy()
		end
	end)
end

local function DealDamage(who, minDam, maxDam, Knock, Type, critChance, critMult)
	if not who or who == Char then
		return
	end
	local hum = who:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then
		return
	end

	for i = #Hit, 1, -1 do
		local entry = Hit[i]
		if entry[1] == hum then
			if (time() - entry[2]) < 0.1 then
				return
			end
			table.remove(Hit, i)
		end
	end
	table.insert(Hit, { hum, time() })

	local baseDmg = math.random(minDam or 10, maxDam or 25)
	local isCrit = (M.RNG(1, 100) <= (critChance or 0)) and ((critMult or 1) > 1)
	local finalDmg = isCrit and (baseDmg * (critMult or 2)) or baseDmg

	local targetHead = who:FindFirstChild("Head")
	if targetHead then
		ShowDamage(targetHead.Position + V3.N(0, 1.5, 0), isCrit and ("[CRIT] " .. finalDmg) or tostring(finalDmg), 1.5, DamageColor.Color)
	end
	hum:TakeDamage(finalDmg)

	local targetTorso = GetTorso(who)
	if targetTorso and Type == "Knockback" and Knock then
		local bv = NewInstance("BodyVelocity", targetTorso, {
			P = 500,
			MaxForce = V3.N(math.huge, 0, math.huge),
			Velocity = Root.CFrame.LookVector * Knock,
		})
		Debris:AddItem(bv, 0.35)
	elseif targetTorso and Type == "Knockdown" and Knock then
		local dir = (targetTorso.Position - Root.Position)
		if dir.Magnitude > 0.01 then
			targetTorso.AssemblyLinearVelocity = dir.Unit * Knock + V3.N(0, 20, 0)
		end
	end
end

local function AOEDamage(where, range, minDam, maxDam, Knock, Type, critChance, critMult)
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { Char }
	local seenModels = {}
	for _, part in ipairs(WS:GetPartBoundsInBox(CF.N(where), V3.N(range, range, range), params)) do
		local model = part:FindFirstAncestorOfClass("Model")
		if model and not seenModels[model] and model:FindFirstChildOfClass("Humanoid") then
			seenModels[model] = true
			DealDamage(model, minDam, maxDam, Knock, Type, critChance, critMult)
		end
	end
end

--// Attack Functions \\--
local function Smite()
	local hitPos = Mouse.Hit.Position
	Zap({
		StartCFrame = CF.N(hitPos) * CF.N(0, 250, 0),
		EndCFrame = CF.N(hitPos),
		ZapRotation = { -5, 5 },
		StartSize = 4,
		EndSize = 1,
		Delay = 8,
		DelayInc = 1,
	})
	AOEDamage(hitPos, 8, 15, 35, 20, "Electric", 75, 1.5)
end

local function LightningStorm()
	Attack = true
	Rooted = true
	NeutralAnims = false
	Hum.AutoRotate = false
	while UserInputService:IsKeyDown(Enum.KeyCode.C) do
		swait()
		Root.CFrame = Root.CFrame:Lerp(CF.N(Root.Position, V3.N(Mouse.Hit.X, Root.Position.Y, Mouse.Hit.Z)), 0.15)
		RJ.C0 = clerp(RJ.C0, CF.N(0, 0.25 * M.C(Sine / 12), 0) * CF.A(-M.R(5 + 5 * M.S(Sine / 12)), 0, 0), 0.3)
		RS.C0 = clerp(RS.C0, CF.N(1.5, 0.7, 0) * CF.A(M.R(-120), 0, M.R(15)), 0.3)
		LS.C0 = clerp(LS.C0, CF.N(-1.5, 0.5, 0) * CF.A(M.R(-30), 0, M.R(-15)), 0.3)
		WingFlutter()
	end
	local where = Mouse.Hit.Position
	for _ = 1, 25 do
		pcall(function()
			Sound(Torso, 481719045, 1, 1, false, true, true)
		end)
		local pos = CF.N(where) * CF.N(M.RNG(-35, 35), 0, M.RNG(-35, 35))
		local _, rayPos = CastRay((pos * CF.N(0, 200, 0)).Position, pos.Position, 300)
		Zap({
			StartCFrame = pos * CF.N(0, 200, 0),
			EndCFrame = CF.N(rayPos),
			ZapRotation = { -5, 5 },
			StartSize = 1.2,
			EndSize = 0.5,
			Delay = 8,
			DelayInc = 1,
		})
		AOEDamage(rayPos, 8, 25, 45, 15, "Electric", 25, 2)
		swait(2)
		WingFlutter()
	end
	Hum.AutoRotate = true
	Attack = false
	NeutralAnims = true
	Rooted = false
end

local function HolyBomb()
	Attack = true
	Chat2("jajajajaja ez nooby")
	swait(20)
	Rooted = true
	NeutralAnims = false
	for _ = 1, 25 do
		swait()
		Zap({
			StartCFrame = CF.N(Root.Position) * CF.N(0, 120, 0),
			EndCFrame = CF.N(Root.Position),
			ZapRotation = { -10, 10 },
			Color = BrickColor.new("New Yeller"),
			StartSize = 1,
			EndSize = 1,
			Delay = 6,
		})
		RS.C0 = clerp(RS.C0, CF.N(1.5, 0.8, 0) * CF.A(M.R(-150), 0, M.R(20)), 0.25)
		LS.C0 = clerp(LS.C0, CF.N(-1.5, 0.8, 0) * CF.A(M.R(-150), 0, M.R(-20)), 0.25)
		WingFlutter()
	end
	local burstPos = Root.Position
	pcall(function()
		Sound(Char, 579687077, 0.7, 2, false, true, true)
	end)
	for _ = 1, 35 do
		AOEDamage(burstPos, 45, 50, 90, 45, "Knockdown", 50, 2)
		Effect({
			Effect = "ResizeAndFade",
			Mesh = { MeshType = Enum.MeshType.Sphere },
			Color = C3.N(1, 1, 0),
			Material = Enum.Material.Neon,
			CFrame = CF.N(burstPos) * CF.N(M.RNG(-25, 25), M.RNG(-10, 25), M.RNG(-25, 25)),
			Frames = 35,
			FXSettings = { EndIsIncrement = true, EndSize = V3.N(0.6, 0.6, 0.6) },
		})
		swait(1)
	end
	NeutralAnims = true
	Rooted = false
	Attack = false
end

local function Lazor()
	Rooted = true
	Attack = true
	Hum.AutoRotate = false
	NeutralAnims = false
	Chat2("idot die jajajajaja")
	local snd = Sound(Torso, 705787045, 1, 1.5, true, false, true)
	for _ = 1, 60 do
		swait()
		Root.CFrame = Root.CFrame:Lerp(CF.N(Root.Position, V3.N(Mouse.Hit.X, Root.Position.Y, Mouse.Hit.Z)), 0.2)
		RS.C0 = clerp(RS.C0, CF.N(1.5, 0.5, 0) * CF.A(M.R(-90), 0, 0), 0.25)
		local origin = (RArm.CFrame * CF.N(0, -1, 0)).Position
		local targetPos = Mouse.Hit.Position
		Zap({
			StartCFrame = CF.N(origin),
			EndCFrame = CF.N(targetPos),
			ZapRotation = { -4, 4 },
			PartCount = 10,
			StartSize = 0.8,
			EndSize = 0.6,
			Color = BrickColor.new("New Yeller"),
			Delay = 5,
		})
		AOEDamage(targetPos, 6, 10, 18, 10, "Electric", 25, 2)
		WingFlutter()
	end
	if snd then
		snd:Stop()
		snd:Destroy()
	end
	Rooted = false
	Attack = false
	Hum.AutoRotate = true
	NeutralAnims = true
end

local function Teleport()
	Rooted = true
	Attack = true
	Hum.AutoRotate = false
	NeutralAnims = false
	while UserInputService:IsKeyDown(Enum.KeyCode.Q) do
		swait()
		Root.CFrame = Root.CFrame:Lerp(CF.N(Root.Position, V3.N(Mouse.Hit.X, Root.Position.Y, Mouse.Hit.Z)), 0.15)
		WingFlutter()
	end
	local dest = CF.N(Mouse.Hit.Position + V3.N(0, 4, 0))
	Transparency(0.85)
	Zap({
		StartCFrame = Root.CFrame,
		EndCFrame = dest,
		ZapRotation = { -4, 4 },
		PartCount = 10,
		StartSize = 2.5,
		EndSize = 0.5,
		Color = BrickColor.new("New Yeller"),
		Delay = 10,
	})
	Root.CFrame = dest
	Transparency(0)
	Hum.AutoRotate = true
	Rooted = false
	Attack = false
	NeutralAnims = true
end

Mouse.KeyDown:Connect(function(k)
	if Attack then
		return
	end
	local key = string.lower(k)
	if key == "q" then
		Teleport()
	elseif key == "z" then
		Lazor()
	elseif key == "x" then
		Smite()
	elseif key == "v" then
		HolyBomb()
	elseif key == "c" then
		LightningStorm()
	end
end)

--// Main Loop \\--
while true do
	swait()
	Sine += Change

	if not Music or not Music.Parent then
		Music = Sound(Char, MusicID, 1, 3, true, false, true)
		Music.Name = "Music"
	end
	Music.Playing = true

	Torso.Color = C3.N(0, 0, 0)
	RArm.Color = C3.N(0, 0, 0)
	LArm.Color = C3.N(0, 0, 0)
	RLeg.Color = C3.N(0, 0, 0)
	LLeg.Color = C3.N(0, 0, 0)
	Head.Color = C3.N(0, 0, 0)
	Hum.HipHeight = 2

	local hitfloor, posfloor = CastRay(Root.Position, Root.Position - V3.N(0, 1, 0), 100, { Char })
	local Walking = Vector3.new(Root.AssemblyLinearVelocity.X, 0, Root.AssemblyLinearVelocity.Z).Magnitude > 1.5
	local State = Hum.PlatformStand and "Paralyzed" or (Hum.Sit and "Sit" or (Walking and "Walk" or "Idle"))

	if (time() - PulseTime) > 0.08 then
		PulseTime = time()
		if hitfloor then
			local ang = CF.A(M.RRNG(-15, 15), M.RRNG(-45, 45), M.RRNG(-45, 45))
			Effect({
				Effect = "ResizeAndFade",
				Color = hitfloor.Color,
				Material = hitfloor.Material,
				Frames = 40,
				Mesh = { MeshType = Enum.MeshType.FileMesh, MeshId = "rbxassetid://662586858", Scale = V3.N(0.01, 0.01, 0.01) },
				CFrame = CF.N(posfloor) * ang,
				MoveDirection = (CF.N(posfloor) * ang * CF.N(0, 6, 0)).Position,
				FXSettings = { EndSize = V3.N(0.001, 0.001, 0.001), EndIsIncrement = true },
			})
		end
	end

	Hum.MaxHealth = 1e6
	Hum.Health = 1e6

	if Rooted then
		Hum.WalkSpeed = 0
		Hum.JumpPower = 0
	else
		Hum.WalkSpeed = 32
		Hum.JumpPower = 75
	end

	if not EffectsFolder or not EffectsFolder.Parent then
		EffectsFolder = IN("Folder")
		EffectsFolder.Name = "Effects"
		EffectsFolder.Parent = Char
	end

	if NeutralAnims then
		if State == "Idle" then
			Change = 0.5
			RJ.C0 = clerp(RJ.C0, CF.N(0, 0.25 * M.C(Sine / 12), 0) * CF.A(-M.R(3 + 5 * M.S(Sine / 12)), 0, 0), 0.1)
			NK.C0 = clerp(NK.C0, CF.N(0, 1.5, 0) * CF.A(0, M.R(5 * M.C(Sine / 24)), 0), 0.1)
			RS.C0 = clerp(RS.C0, CF.N(1.5, 0.5 + 0.1 * M.C(Sine / 12), 0) * CF.A(M.R(-10), 0, M.R(8 + 4 * M.S(Sine / 12))), 0.1)
			LS.C0 = clerp(LS.C0, CF.N(-1.5, 0.5 + 0.1 * M.C(Sine / 12), 0) * CF.A(M.R(-10), 0, M.R(-8 - 4 * M.S(Sine / 12))), 0.1)
			RH.C0 = clerp(RH.C0, CF.N(0.5, -1, 0) * CF.A(M.R(-5), 0, M.R(3)), 0.1)
			LH.C0 = clerp(LH.C0, CF.N(-0.5, -1, 0) * CF.A(M.R(12), 0, M.R(-3)), 0.1)
			HW.C0 = HW.C0:Lerp(CF.N(0, 2, 0) * CF.A(M.R(10 * M.C(Sine / 36)), 0, M.R(10 * M.S(Sine / 36))), 0.1)
			WW.C0 = WW.C0:Lerp(CF.N(0, 1.5 + 0.3 * M.C(Sine / 12), 1.5), 0.1)
			WingFlutter()
		elseif State == "Walk" then
			Change = 1.2
			local stride = M.S(Sine / 6)
			RJ.C0 = clerp(RJ.C0, CF.N(0, 0.2 + 0.15 * math.abs(stride), 0) * CF.A(-M.R(12), M.R(6 * stride), 0), 0.15)
			NK.C0 = clerp(NK.C0, CF.N(0, 1.5, 0) * CF.A(M.R(8), -M.R(6 * stride), 0), 0.15)
			RS.C0 = clerp(RS.C0, CF.N(1.5, 0.5, 0) * CF.A(M.R(-35 * stride), 0, M.R(5)), 0.15)
			LS.C0 = clerp(LS.C0, CF.N(-1.5, 0.5, 0) * CF.A(M.R(35 * stride), 0, M.R(-5)), 0.15)
			RH.C0 = clerp(RH.C0, CF.N(0.5, -1, 0) * CF.A(M.R(40 * stride), 0, 0), 0.15)
			LH.C0 = clerp(LH.C0, CF.N(-0.5, -1, 0) * CF.A(M.R(-40 * stride), 0, 0), 0.15)
			HW.C0 = HW.C0:Lerp(CF.N(0, 2, 0) * CF.A(M.R(12 * M.C(Sine / 24)), 0, M.R(12 * M.S(Sine / 24))), 0.15)
			WW.C0 = WW.C0:Lerp(CF.N(0, 1.5 + 0.3 * M.C(Sine / 12), 1.5), 0.15)
			WingFlutter()
		end
	end
end
