local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

Effects = {}
local Player = Players.LocalPlayer
local Character = Workspace:FindFirstChild("non") or Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local mouse = Player:GetMouse()

local m = Instance.new("Model")
m.Name = "WeaponModel"
m.Parent = Character

local rearRotor = Instance.new("Model")
rearRotor.Name = "RearRotor"
rearRotor.Parent = Character

local rail = Instance.new("Model")
rail.Name = "Rail"
rail.Parent = Character

local shield = Instance.new("Model")
shield.Name = "Shield"
shield.Parent = Character

local LeftArm = Character:WaitForChild("Left Arm")
local RightArm = Character:WaitForChild("Right Arm")
local LeftLeg = Character:WaitForChild("Left Leg")
local RightLeg = Character:WaitForChild("Right Leg")
local Head = Character:WaitForChild("Head")
local Torso = Character:WaitForChild("Torso")
local cam = Workspace.CurrentCamera
local RootPart = Character:WaitForChild("HumanoidRootPart")
local RootJoint = RootPart:WaitForChild("RootJoint")

local equipped = false
local attack = false
local aim = false
local vHold = false
local Blocking = false
local Anim = "Idle"
local idle = 0
local attacktype = 1
local Torsovelocity = 0
local velocity = RootPart.AssemblyLinearVelocity.Y
local sine = 0
local change = 1
local lapse = 0
local grabbed = false
local cn = CFrame.new
local mr = math.rad
local angles = CFrame.Angles
local euler = CFrame.fromEulerAnglesXYZ
local ud = UDim2.new
local c3 = Color3.new
local donum = 0
local donum2 = 0
local NeckCF = cn(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

if Humanoid:FindFirstChild("Animator") then
	Humanoid.Animator:Destroy()
end
if Character:FindFirstChild("Animate") then
	Character.Animate:Destroy()
end

local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)

local RW = Instance.new("Weld")
local LW = Instance.new("Weld")
local RH = Torso:WaitForChild("Right Hip")
local LH = Torso:WaitForChild("Left Hip")
local RSH = Torso:FindFirstChild("Right Shoulder")
local LSH = Torso:FindFirstChild("Left Shoulder")
if RSH then
	RSH.Parent = nil
end
if LSH then
	LSH.Parent = nil
end

RW.Name = "RW"
RW.Part0 = Torso
RW.C0 = cn(1.5, 0.5, 0)
RW.C1 = cn(0, 0.5, 0)
RW.Part1 = RightArm
RW.Parent = Torso

LW.Name = "LW"
LW.Part0 = Torso
LW.C0 = cn(-1.5, 0.5, 0)
LW.C1 = cn(0, 0.5, 0)
LW.Part1 = LeftArm
LW.Parent = Torso

local co1 = 2
local co2 = 2
local co3 = 2
local co4 = 2
local cooldown1 = 0
local cooldown2 = 0
local cooldown3 = 0
local cooldown4 = 0
local maxMana = 100
local Mana = 100
local skill1stam = 0
local skill2stam = 0
local skill3stam = 0
local skill4stam = 0
local skill4absorbrate = 2
local blockDrainRate = 0.5
local recovermana = 100
local skillcolorscheme = Color3.new(1, 1, 1)

local scrn = Instance.new("ScreenGui")
scrn.Name = "BenchCombatGui"
scrn.ResetOnSpawn = false
scrn.Parent = Player:WaitForChild("PlayerGui")

local function resolveColor(color)
	if typeof(color) == "Color3" then
		return color
	elseif typeof(color) == "BrickColor" then
		return color.Color
	elseif typeof(color) == "string" then
		return BrickColor.new(color).Color
	end
	return Color3.new(1, 1, 1)
end

makeframe = function(par, trans, pos, size, color)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = trans
	frame.BorderSizePixel = 0
	frame.Position = pos
	frame.Size = size
	frame.BackgroundColor3 = resolveColor(color)
	frame.Parent = par
	return frame
end

makelabel = function(par, text)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.SourceSansBold
	label.BorderSizePixel = 0
	label.TextScaled = true
	label.Text = text
	label.Parent = par
	return label
end

local colorscheme2 = Torso.BrickColor.Color
framesk1 = makeframe(scrn, 0.5, UDim2.new(0.23, 0, 0.93, 0), UDim2.new(0.26, 0, 0.06, 0), colorscheme2)
framesk2 = makeframe(scrn, 0.5, UDim2.new(0.5, 0, 0.93, 0), UDim2.new(0.26, 0, 0.06, 0), colorscheme2)
framesk3 = makeframe(scrn, 0.5, UDim2.new(0.5, 0, 0.86, 0), UDim2.new(0.26, 0, 0.06, 0), colorscheme2)
framesk4 = makeframe(scrn, 0.5, UDim2.new(0.23, 0, 0.86, 0), UDim2.new(0.26, 0, 0.06, 0), colorscheme2)
bar1 = makeframe(framesk1, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), skillcolorscheme)
bar2 = makeframe(framesk2, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), skillcolorscheme)
bar3 = makeframe(framesk3, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), skillcolorscheme)
bar4 = makeframe(framesk4, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), skillcolorscheme)
text1 = makelabel(framesk1, "[C] Rail Dominator")
text2 = makelabel(framesk2, "[V + HOLD] Gluon Drive")
text3 = makelabel(framesk3, "[X] Arcus Surge")
text4 = makelabel(framesk4, "[Z] Ground Breaker")
Manabar = makeframe(scrn, 0.5, UDim2.new(0.23, 0, 0.82, 0), UDim2.new(0.26, 0, 0.03, 0), BrickColor.new("Really black").Color)
Manacover = makeframe(Manabar, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), BrickColor.new("Cyan").Color)
Manatext = makelabel(Manabar, "Energy")
healthbar = makeframe(scrn, 0.5, UDim2.new(0.5, 0, 0.82, 0), UDim2.new(0.26, 0, 0.03, 0), BrickColor.new("Really black").Color)
healthcover = makeframe(healthbar, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), BrickColor.new("Lime green").Color)
healthtext = makelabel(healthbar, "Health")

local stats = Instance.new("Folder")
stats.Name = "Stats"
stats.Parent = Character

local block = Instance.new("BoolValue")
block.Name = "Block"
block.Value = false
block.Parent = stats

local stun = Instance.new("BoolValue")
stun.Name = "Stun"
stun.Value = false
stun.Parent = stats

local defense = Instance.new("NumberValue")
defense.Name = "Defence"
defense.Value = 1.2
defense.Parent = stats

local speed = Instance.new("NumberValue")
speed.Name = "Speed"
speed.Value = 0.7
speed.Parent = stats

local damagea = Instance.new("NumberValue")
damagea.Name = "Damage"
damagea.Value = 0
damagea.Parent = stats

clerp = function(a, b, t)
	return a:Lerp(b, t)
end

local function Create(className)
	return function(props)
		local inst = Instance.new(className)
		local parent = props and props.Parent
		if props then
			for k, v in pairs(props) do
				if k ~= "Parent" and k ~= "formFactor" then
					inst[k] = v
				end
			end
		end
		if parent then
			inst.Parent = parent
		end
		return inst
	end
end

ArtificialHB = Instance.new("BindableEvent")
ArtificialHB.Name = "Heartbeat"
ArtificialHB.Parent = script

frame = 1 / 30
tf = 0
allowframeloss = false
tossremainder = false
lastframe = tick()

RunService.Heartbeat:Connect(function(s)
	tf = tf + s
	if frame <= tf then
		if allowframeloss then
			ArtificialHB:Fire()
			lastframe = tick()
		else
			for _ = 1, math.floor(tf / frame) do
				ArtificialHB:Fire()
			end
			lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

swait = function(num)
	if num == 0 or num == nil then
		ArtificialHB.Event:Wait()
	else
		for _ = 0, num do
			ArtificialHB.Event:Wait()
		end
	end
end

RemoveOutlines = function(part)
	part.TopSurface = Enum.SurfaceType.Smooth
end

CreateWeaponPart = function(_, parent, material, reflectance, transparency, brickcolor, name, size)
	local fp = Create("Part")({
		Parent = parent,
		Reflectance = reflectance,
		Transparency = transparency,
		CanCollide = false,
		Locked = true,
		BrickColor = BrickColor.new(tostring(brickcolor)),
		Name = name,
		Size = size,
		Material = material,
	})
	RemoveOutlines(fp)
	return fp
end

CreatePart = function(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
	local Part = Create("Part")({
		Parent = Parent,
		Reflectance = Reflectance,
		Transparency = Transparency,
		CanCollide = false,
		Locked = true,
		BrickColor = BrickColor.new(tostring(BColor)),
		Name = Name,
		Size = Size,
		Material = Material,
	})
	RemoveOutlines(Part)
	return Part
end

CreateMesh = function(Mesh, Part, MeshType, MeshId, OffSet, Scale)
	local Msh = Create(Mesh)({
		Parent = Part,
		Offset = OffSet,
		Scale = Scale,
	})
	if Mesh == "SpecialMesh" then
		if MeshType and MeshType ~= "" then
			Msh.MeshType = MeshType
		end
		if MeshId and MeshId ~= "" then
			Msh.MeshId = MeshId
		end
	end
	return Msh
end

CreateWeld = function(Parent, Part0, Part1, C0, C1)
	return Create("Weld")({
		Parent = Parent,
		Part0 = Part0,
		Part1 = Part1,
		C0 = C0,
		C1 = C1,
	})
end

rayCast = function(Position, Direction, Range, Ignore)
	local dist = Range or 999.999
	local dir = (Direction.Magnitude > 0 and Direction.Unit or Vector3.new(0, -1, 0)) * dist
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignoreList = {}
	if typeof(Ignore) == "Instance" then
		table.insert(ignoreList, Ignore)
	elseif typeof(Ignore) == "table" then
		for _, item in ipairs(Ignore) do
			table.insert(ignoreList, item)
		end
	end
	table.insert(ignoreList, Character)
	params.FilterDescendantsInstances = ignoreList

	local result = Workspace:Raycast(Position, dir, params)
	if result then
		return result.Instance, result.Position
	end
	return nil, Position + dir
end

CreateSound = function(id, par, vol, pit, looped)
	local sou = Instance.new("Sound")
	sou.Parent = par or Character
	sou.Volume = vol
	sou.Pitch = pit or 1
	sou.SoundId = tostring(id)
	sou.Looped = looped or false
	task.spawn(function()
		swait()
		sou:Play()
		if not looped then
			Debris:AddItem(sou, 6)
		end
	end)
	return sou
end

local function findHumanoidFromHit(hit)
	if not hit or not hit.Parent then
		return nil
	end
	local model = hit:FindFirstAncestorOfClass("Model")
	if model then
		return model:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

getclosest = function(obj, distance)
	local last, lastx = distance + 1, nil
	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Model") and v ~= Character then
			local hum = v:FindFirstChildOfClass("Humanoid")
			local t = v:FindFirstChild("Torso") or v:FindFirstChild("HumanoidRootPart")
			if hum and t and hum.Health > 0 then
				local dist = (t.Position - obj.Position).Magnitude
				if dist <= distance and dist < last then
					last = dist
					lastx = v
				end
			end
		end
	end
	return lastx
end

local crit = false
makegui = function(cframe, text)
	local c = Instance.new("Part")
	c.Transparency = 1
	c.Size = Vector3.new(0.2, 0.2, 0.2)
	c.CanCollide = false
	c.CFrame = cn(cframe.Position + Vector3.new(0, 1.5, 0))
	c.Parent = Character

	local bg = Instance.new("BillboardGui")
	bg.Adornee = c
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.StudsOffset = Vector3.new(0, 0, 0)
	bg.AlwaysOnTop = false
	bg.Parent = c

	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.Text = tostring(text)
	tl.Font = Enum.Font.SourceSansBold
	tl.TextColor3 = crit and Color3.new(0.70588235294118, 0, 0) or Color3.new(1, 0.70588235294118, 0.2)
	tl.TextStrokeTransparency = 0
	tl.TextScaled = true
	tl.TextWrapped = true
	tl.Parent = bg

	Debris:AddItem(c, 6.5)
	task.spawn(function()
		task.wait(2)
		for _ = 1, 10 do
			swait()
			tl.TextTransparency = math.min(1, tl.TextTransparency + 0.1)
		end
	end)
end

Damagefunc = function(Part, hit, minim, maxim, knockback, Type, Property, DelayTime, KnockbackType, decreaseblock, blockreduction)
	if not hit or not hit.Parent or hit.Name == "Laser" or hit.Name == "Reference" then
		return
	end
	local h = findHumanoidFromHit(hit)
	local targetModel = hit:FindFirstAncestorOfClass("Model")
	if not h or not targetModel or targetModel == Character then
		return
	end
	if targetModel:FindFirstChild("DebounceHit") and targetModel.DebounceHit.Value == true then
		return
	end

	local c = Instance.new("ObjectValue")
	c.Name = "creator"
	c.Value = Player
	c.Parent = h
	Debris:AddItem(c, 0.5)

	local Damage = math.random(minim or 1, maxim or 1)
	local blocked = false
	local targetStats = targetModel:FindFirstChild("Stats")
	local targetBlock = targetStats and targetStats:FindFirstChild("Block")
	local reduction = blockreduction or 3

	if targetBlock then
		if targetBlock:IsA("NumberValue") and targetBlock.Value > 0 then
			blocked = true
			if decreaseblock == nil then
				targetBlock.Value = targetBlock.Value - 1
			end
		elseif targetBlock:IsA("BoolValue") and targetBlock.Value == true then
			blocked = true
			local torsoPart = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("HumanoidRootPart")
			if torsoPart and (knockback or 0) > 0 and Property then
				local vp = Instance.new("BodyVelocity")
				vp.P = 500
				vp.MaxForce = Vector3.new(1e7, 0, 1e7)
				if KnockbackType == 1 then
					vp.Velocity = (Property.CFrame.LookVector * knockback + Property.AssemblyLinearVelocity / 1.05) / reduction
				elseif KnockbackType == 2 then
					vp.Velocity = Property.CFrame.LookVector * knockback / reduction
				end
				vp.Parent = torsoPart
				Debris:AddItem(vp, 0.5)
			end
		elseif targetBlock:IsA("IntValue") and targetBlock.Value > 0 then
			blocked = true
			if decreaseblock ~= nil then
				targetBlock.Value = targetBlock.Value - 1
			end
		end
	end

	local popupPos = Part.CFrame * cn(0, 0, Part.Size.Z / 2).Position + Vector3.new(0, 1.5, 0)
	if not blocked then
		h.Health = h.Health - Damage
		ShowDamage(popupPos, -Damage, 1.5, Hitbox and Hitbox.BrickColor.Color or Color3.new(1, 0, 0))
	else
		h.Health = h.Health - (Damage / reduction)
		ShowDamage(popupPos, math.floor(-Damage / reduction) + 0.5, 1.5, BrickColor.new("Bright blue").Color)
	end

	if Type == "Knockdown" and not blocked then
		h.PlatformStand = true
		task.spawn(function(HHumanoid)
			swait(1)
			if HHumanoid then
				HHumanoid.PlatformStand = false
			end
		end, h)
		local originPos = Property and Property.Position or Part.Position
		local dir = hit.Position - originPos
		local angle = dir.Magnitude > 0 and dir.Unit or Vector3.new(0, 0, 1)
		local bodvol = Instance.new("BodyVelocity")
		bodvol.Velocity = angle * (knockback or 0)
		bodvol.P = 5000
		bodvol.MaxForce = Vector3.new(8000, 8000, 8000)
		bodvol.Parent = hit
		local rl = Instance.new("BodyAngularVelocity")
		rl.P = 3000
		rl.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
		rl.AngularVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
		rl.Parent = hit
		Debris:AddItem(bodvol, 0.5)
		Debris:AddItem(rl, 0.5)
	elseif Type == "Normal" and not blocked then
		local torsoPart = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("HumanoidRootPart")
		if torsoPart and (knockback or 0) > 0 and Property then
			local vp = Instance.new("BodyVelocity")
			vp.P = 500
			vp.MaxForce = Vector3.new(1e7, 0, 1e7)
			if KnockbackType == 1 then
				vp.Velocity = Property.CFrame.LookVector * knockback + Property.AssemblyLinearVelocity / 1.05
			elseif KnockbackType == 2 then
				vp.Velocity = Property.CFrame.LookVector * knockback
			end
			vp.Parent = torsoPart
			Debris:AddItem(vp, 0.5)
		end
	elseif Type == "Up" and not blocked then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, 60, 0)
		bodyVelocity.P = 5000
		bodyVelocity.MaxForce = Vector3.new(8000, 8000, 8000)
		bodyVelocity.Parent = hit
		local rl = Instance.new("BodyAngularVelocity")
		rl.P = 3000
		rl.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
		rl.AngularVelocity = Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
		rl.Parent = hit
		Debris:AddItem(bodyVelocity, 1)
		Debris:AddItem(rl, 0.5)
	elseif Type == "Snare" and not blocked then
		local torsoPart = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("HumanoidRootPart")
		if torsoPart then
			local bp = Instance.new("BodyPosition")
			bp.P = 2000
			bp.D = 100
			bp.MaxForce = Vector3.new(1e7, 1e7, 1e7)
			bp.Position = torsoPart.Position
			bp.Parent = torsoPart
			Debris:AddItem(bp, 1)
		end
	elseif Type == "Target" and not blocked then
		local zTarget = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("HumanoidRootPart")
		if zTarget then
			task.spawn(function(p)
				CreateSound("http://www.roblox.com/asset/?id=15666462", p, 1, 1.5)
				swait(5)
				CreateSound("http://www.roblox.com/asset/?id=15666462", p, 1, 1.5)
			end, zTarget)
			local targetgui = Instance.new("BillboardGui")
			targetgui.Adornee = zTarget
			targetgui.Size = UDim2.new(10, 100, 10, 100)
			targetgui.Parent = zTarget
			local targ = Instance.new("ImageLabel")
			targ.BackgroundTransparency = 1
			targ.Image = "rbxassetid://4834067"
			targ.Size = UDim2.new(1, 0, 1, 0)
			targ.Parent = targetgui
			cam.CameraType = Enum.CameraType.Scriptable
			local steps = tonumber(Property) or 30
			for _ = 1, steps do
				if Humanoid.Health <= 0 or Character.Parent == nil or h.Health <= 0 or h.Parent == nil then
					break
				end
				swait()
				cam.CFrame = cn(Head.Position, zTarget.Position) * cn(0, 5, 10) * euler(-0.3, 0, 0)
			end
			targetgui:Destroy()
			cam.CameraType = Enum.CameraType.Custom
		end
	end

	local debounce = Instance.new("BoolValue")
	debounce.Name = "DebounceHit"
	debounce.Value = true
	debounce.Parent = targetModel
	Debris:AddItem(debounce, DelayTime or 0.2)
end

ShowDamage = function(Pos, Text, Time, Color)
	local Rate = 1 / 30
	local displayPos = Pos or Vector3.new(0, 0, 0)
	local displayText = Text or ""
	local duration = Time or 2
	local textColor = resolveColor(Color or Color3.new(1, 0, 0))

	local EffectPart = CreateWeaponPart(Enum.PartType.Block, Character, Enum.Material.SmoothPlastic, 0, 1, BrickColor.new(textColor), "Effect", Vector3.new(0.2, 0.2, 0.2))
	EffectPart.Anchored = true
	EffectPart.CFrame = cn(displayPos)

	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Size = UDim2.new(3, 0, 3, 0)
	BillboardGui.Adornee = EffectPart
	BillboardGui.Parent = EffectPart

	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Text = tostring(displayText)
	TextLabel.TextColor3 = textColor
	TextLabel.TextScaled = true
	TextLabel.Font = Enum.Font.ArialBold
	TextLabel.Parent = BillboardGui

	Debris:AddItem(EffectPart, duration + 0.1)
	task.spawn(function()
		local frames = math.max(1, math.floor(duration / Rate))
		for f = 1, frames do
			task.wait(Rate)
			if not EffectPart or not EffectPart.Parent then
				return
			end
			local percent = f / frames
			EffectPart.CFrame = cn(displayPos) + Vector3.new(0, percent, 0)
			TextLabel.TextTransparency = percent
		end
		if EffectPart and EffectPart.Parent then
			EffectPart:Destroy()
		end
	end)
end

MagniDamage = function(Part, magni, mindam, maxdam, knock, Type)
	for _, c in ipairs(Workspace:GetChildren()) do
		if c:IsA("Model") and c ~= Character then
			local hum = c:FindFirstChildOfClass("Humanoid")
			local head = c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart")
			if hum and head and hum.Health > 0 then
				local mag = (head.Position - Part.Position).Magnitude
				if mag <= magni then
					Damagefunc(Part, head, mindam, maxdam, knock, Type, RootPart, 0.2, 1)
				end
			end
		end
	end
end

LeftHandle = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
LeftHandleweld = CreateWeld(m, LeftArm, LeftHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.0481894873, 0.0176233053, 1.05672896, 7.91948478e-005, -0.0114456406, -0.999934554, -1, -0.000125397128, -7.77646856e-005, -0.000124498867, 0.999934435, -0.0114456518))
CreateMesh("SpecialMesh", LeftHandle, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.79999995, 1.79999995, 2))

SMnrgRng = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 1, "Toothpaste", "nrgRng", Vector3.new(0.200000003, 0.200000003, 0.200000003))
SMnrgRngweld = CreateWeld(m, LeftHandle, SMnrgRng, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0150001682, 0.0078753233, 1.20272875, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", SMnrgRng, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.79999995, 1.79999995, 2))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Part", Vector3.new(1.79999995, 0.300000012, 0.300000012))
Partweld = CreateWeld(m, LeftHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0289917998, -0.0111817122, -0.157007813, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", Part, Enum.MeshType.Cylinder, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
Partweld = CreateWeld(m, LeftHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(1.39512122e-005, 4.9829483e-005, -0.400003552, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", Part, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.79999995, 1.79999995, 2))

LGnrgRng = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 1, "Toothpaste", "nrgRng", Vector3.new(1, 1, 0.200000003))
LGnrgRngweld = CreateWeld(m, LeftHandle, LGnrgRng, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0596184209, 0.00756621361, 3.90246272, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", LGnrgRng, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(3, 3, 1))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0, 0, "Toothpaste", "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
Partweld = CreateWeld(m, LeftHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0022751987, 2.46763229e-005, -0.20001471, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", Part, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(2.0999999, 2.0999999, 1.20000005))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
Partweld = CreateWeld(m, LeftHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0022752136, 2.46763229e-005, -0.20001328, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))
CreateMesh("SpecialMesh", Part, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.79999995, 1.79999995, 2))

Hitbox = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Plastic, 0, 1, "Really black", "Hitbox", Vector3.new(2.48000002, 1.44999993, 2.5999999))
Hitboxweld = CreateWeld(m, LeftHandle, Hitbox, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.0208437443, 0.118899107, -0.0742249787, 7.91661951e-005, -0.99999994, -0.000124600119, -0.0114456592, -0.000125502178, 0.999934554, -0.999934494, -7.7734876e-005, -0.0114456508))

RightHandle = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Plastic, 0, 1, "Pastel brown", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
RightHandleweld = CreateWeld(m, RightArm, RightHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0, 5.96046448e-008, 0, 1, 0, 0, 0, 0.999999881, 0, 0, 0, 1))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Part", Vector3.new(0.200000003, 0.210000008, 0.200000003))
Partweld = CreateWeld(m, RightHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.00615789229, -0.00749695301, -0.713596702, 0.00343851582, -0.0130101992, 0.99990952, 0.999908209, 0.0131466873, -0.00326745468, -0.0131029878, 0.999828994, 0.0130542098))
CreateMesh("SpecialMesh", Part, Enum.MeshType.Brick, "", Vector3.new(0, 0, 0), Vector3.new(5.19999981, 5, 3))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, "Institutional white", "Part", Vector3.new(0.200000003, 0.200000003, 0.26000002))
Partweld = CreateWeld(m, RightHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.00633427128, -0.00812423229, 0.316169471, 0.00343851, -0.0130097354, 0.99990952, 0.999983072, -0.00467376411, -0.00349957286, 0.00471886946, 0.999904513, 0.0129934428))
CreateMesh("SpecialMesh", Part, Enum.MeshType.Brick, "", Vector3.new(0, 0, 0), Vector3.new(5.19999981, 5.0999999, 3))

Part = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0, 0, "Toothpaste", "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
Partweld = CreateWeld(m, RightHandle, Part, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.00592672965, -0.512394786, 0.348286837, 0.00343851582, -0.0130101992, 0.99990952, 0.999908209, 0.0131466873, -0.00326745468, -0.0131029878, 0.999828994, 0.0130542098))
CreateMesh("SpecialMesh", Part, Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0, 0, 0), Vector3.new(0.5, 0.5, 0.5))

RotorHandle = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 1, "Institutional white", "RotorHandle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
RotorHandleweld = CreateWeld(m, LeftHandle, RotorHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.0022752136, 2.46763229e-005, -0.20001328, 1.00000012, 0, 0, 0, 1, -3.97903932e-013, 0, -3.97903932e-013, 1.00000012))

local rotorSpecs = {
	{Vector3.new(0.200000003, 1.38300407, 0.455274403), cn(0.0708336234, -1.50832129, 0.498044372, 0.707035065, 0.707131386, 0.0081796376, -0.547542334, 0.540074348, 0.639153421, 0.447547853, -0.456382543, 0.769035935), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.28300405, 0.465274394), cn(0.0788677931, 1.42347693, -0.449401736, 0.707083941, -0.707084417, 0.00800593756, -0.554244578, -0.561204016, -0.614705682, 0.43914175, 0.430211216, -0.788716078), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(-0.0787920952, -0.413565874, 1.75803661, -0.707136631, 0.707032025, -0.00797253475, 0.311199784, 0.301081628, -0.901390433, -0.634911597, -0.639887214, -0.432934046), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.171932191, 2.06318712, 0.343864322), "Toothpaste"},
	{Vector3.new(0.200000003, 1.51300383, 0.687728643), cn(-0.0787450075, -1.02296484, 1.68831527, -0.707139432, 0.707029164, -0.00797644071, 0.464936852, 0.456450999, -0.758608103, -0.532717288, -0.540150166, -0.651498377), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(0.0789119005, -2.71741366, 1.07279229, 0.707086623, -0.707081854, 0.00799725484, 0.394271672, 0.403612196, 0.82561934, -0.587008238, -0.580631137, 0.564171076), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(0.0788670778, -2.44238925, 0.834575415, 0.707086623, -0.707081854, 0.00799725484, 0.394271672, 0.403612196, 0.82561934, -0.587008238, -0.580631137, 0.564171076), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.38300407, 0.455274403), cn(0.0788627863, -1.51101875, 0.500322938, 0.707086146, -0.707082272, 0.00800287351, 0.532733202, 0.540109992, 0.651518703, -0.464999825, -0.456416398, 0.75859046), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.28300405, 0.465274394), cn(-0.128174901, 1.40868759, -0.438068837, -0.707084, 0.707084417, -0.0080038365, 0.568168223, 0.561356604, -0.601717353, -0.42097193, -0.430012137, -0.7986691), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(0.128249526, -0.4056243, 1.74116552, 0.707135856, -0.707032025, 0.00803845003, -0.290484756, -0.300854653, -0.90835309, 0.644653141, 0.639993906, -0.418127179), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.171932191, 2.06318712, 0.343864322), "Toothpaste"},
	{Vector3.new(0.200000003, 1.51300383, 0.687728643), cn(0.128296375, -1.01092637, 1.67407274, 0.707138777, -0.707029164, 0.00803461019, -0.447449356, -0.456259429, -0.769166112, 0.547488809, 0.540312052, -0.638998449), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(-0.12812984, -2.70677805, 1.05749547, -0.707086444, 0.707081854, -0.00801257882, -0.413065463, -0.403818071, 0.816277027, 0.573939025, 0.580487967, 0.577605367), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(-0.12817502, -2.43175316, 0.819277644, -0.707086444, 0.707081854, -0.00801257882, -0.413065463, -0.403818071, 0.816277027, 0.573939025, 0.580487967, 0.577605367), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.38300407, 0.455274403), cn(-0.128179669, -1.4967854, 0.488298923, -0.707086086, 0.707082272, -0.00800695177, -0.5475052, -0.540271878, 0.639018416, 0.447512656, 0.456224799, 0.76914984), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.28300405, 0.465274394), cn(-0.120145082, 1.41149151, -0.440217525, -0.70703721, -0.70712924, -0.00818065181, -0.554282606, 0.561320245, -0.614565372, 0.439169079, -0.429986089, -0.788823605), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(0.120219231, -0.407127917, 1.74436224, 0.706984401, 0.707181513, 0.00821406581, 0.311306417, -0.300748885, -0.901464701, -0.63502878, 0.639878511, -0.432774931), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.171932191, 2.06318712, 0.343864322), "Toothpaste"},
	{Vector3.new(0.200000003, 1.51300383, 0.687728643), cn(0.120266378, -1.0132066, 1.67677212, 0.706981599, 0.707184374, 0.00821016077, 0.465069741, -0.456127822, -0.758721054, -0.532810807, 0.540220141, -0.651364028), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(-0.120099187, -2.70879459, 1.060395, -0.707034528, -0.707131803, -0.00818933453, 0.394292414, -0.403798521, 0.82551837, -0.587057054, 0.580440879, 0.564316154), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(-0.120144725, -2.43376923, 0.82217741, -0.707034528, -0.707131803, -0.00818933453, 0.394292414, -0.403798521, 0.82551837, -0.587057054, 0.580440879, 0.564316154), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.38300407, 0.455274403), cn(-0.120149255, -1.49948359, 0.490578234, -0.707035005, -0.707131386, -0.00818371587, 0.532770336, -0.540236235, 0.651383698, -0.465034902, 0.456190914, 0.758704364), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 1.28300405, 0.465274394), cn(0.0708386302, 1.42067397, -0.447253823, 0.707037151, 0.70712924, 0.00818275195, 0.568206251, -0.561167657, -0.601857662, -0.420999259, 0.430185169, -0.798561573), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(-0.0707631111, -0.412062526, 1.75484037, -0.706985176, -0.707181513, -0.00814815145, -0.290591359, 0.300975889, -0.908278823, 0.644770324, -0.639771819, -0.418286294), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.171932191, 2.06318712, 0.343864322), "Toothpaste"},
	{Vector3.new(0.200000003, 1.51300383, 0.687728643), cn(-0.0707163811, -1.02068484, 1.68561661, -0.706982255, -0.707184374, -0.00815199129, -0.447582245, 0.456319392, -0.769053161, 0.547582328, -0.540058255, -0.639132917), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(0.0708848238, -2.71539783, 1.06989348, 0.707034707, 0.707131803, 0.00817401055, -0.413086206, 0.403592646, 0.816377997, 0.573987842, -0.580584049, 0.577460289), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.88846183, 0.687728643), cn(0.0708384514, -2.44037342, 0.831676602, 0.707034707, 0.707131803, 0.00817401055, -0.413086206, 0.403592646, 0.816377997, 0.573987842, -0.580584049, 0.577460289), Enum.MeshType.Wedge, "", Vector3.new(0.687728763, 1, 1), "Institutional white"},
}

for _, spec in ipairs(rotorSpecs) do
	local p = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.SmoothPlastic, 0, 0, spec[6], "Part", spec[1])
	CreateWeld(m, RotorHandle, p, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), spec[2])
	CreateMesh("SpecialMesh", p, spec[3], spec[4], Vector3.new(0, 0, 0), spec[5])
end

RearRotorHandle = CreateWeaponPart(Enum.PartType.Block, rearRotor, Enum.Material.Plastic, 0, 1, "Medium stone grey", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
RearRotorHandleweld = CreateWeld(rearRotor, LeftArm, RearRotorHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.000138282776, -0.763178706, 0.0102877412, 1, 0, 0, 0, 0.999999881, 0, 0, 0, 1))

local rearRotorSpecs = {
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(-0.152360201, -0.7086851, 2.94673538, -1, 9.55974247e-005, 4.89801168e-005, -9.55983123e-005, -0.999999762, -1.76297326e-005, 4.89784325e-005, -1.76344111e-005, 1), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.25, 3, 0.5), "Toothpaste"},
	{Vector3.new(0.200000003, 2.20000005, 1.20000005), cn(-0.0879260302, -2.49646044, 1.15150487, 3.2633543e-005, 1.7081331e-005, -1, -0.96591121, 0.258873641, -2.7099195e-005, 0.258873731, 0.965911031, 2.49470213e-005), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(-0.0877985284, -3.83579588, 1.5019176, 8.10176134e-005, 6.36921541e-005, -1, -0.865989804, 0.500061631, -3.83104125e-005, 0.50006175, 0.865989625, 9.56705771e-005), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(-0.0876546949, -4.2356863, 1.84832323, 8.10176134e-005, 6.36921541e-005, -1, -0.865989804, 0.500061631, -3.83104125e-005, 0.50006175, 0.865989625, 9.56705771e-005), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.19999981, 1), cn(0.0881010816, -1.6923486, 2.80422521, 2.66134703e-005, -1.39818931e-005, 1, -0.258923441, -0.96589762, -6.61423292e-006, 0.965897858, -0.258923382, -2.93261346e-005), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(0.0880328566, -0.708874345, 2.94670677, 5.02169132e-006, 6.38468555e-005, 1, -9.67959641e-005, -0.999999762, 6.38473575e-005, 1, -9.67962624e-005, -5.01551131e-006), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.25, 3, 0.5), "Toothpaste"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(0.0882927999, -3.83751416, 1.49840403, -7.78734611e-005, 8.45296672e-005, 1, 0.866055846, 0.499947369, 2.51823622e-005, -0.499947459, 0.866055608, -0.000112140064), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.20000005, 1.20000005), cn(0.0883924663, -2.49747229, 1.14758539, -0.000127851948, 8.4142237e-005, 1, 0.965971649, 0.258648068, 0.000101738129, -0.258648127, 0.96597147, -0.000114347713), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.19999981, 1), cn(-0.0882568434, -1.69534659, 2.80337143, 4.76986097e-005, -7.78390458e-005, -1, 0.258832425, -0.965922058, 8.75324404e-005, -0.965922296, -0.258832365, -2.59258759e-005), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(0.0883531645, -4.23755169, 1.8447659, -7.78734611e-005, 8.45296672e-005, 1, 0.866055846, 0.499947369, 2.51823622e-005, -0.499947459, 0.866055608, -0.000112140064), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(0.0881102905, -0.711688459, -2.94676971, 5.02169132e-006, 6.38468555e-005, 1, -9.67959641e-005, -0.999999762, 6.38473575e-005, 1, -9.67962624e-005, -5.01551131e-006), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.25, 3, 0.5), "Toothpaste"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(-0.152352452, -3.83745646, 1.49872386, -1, 2.19111753e-005, -5.33312559e-005, -3.52297939e-005, 0.500015736, 0.866016209, 4.56419148e-005, 0.86601609, -0.500015855), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.20000005, 1.20000005), cn(-0.152505159, -2.49745202, 1.14781475, -1, 4.78689872e-005, 3.06963921e-006, 1.53502097e-005, 0.258728802, 0.965950012, 4.544486e-005, 0.965949833, -0.258728862), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.19999981, 1), cn(0.15264535, -1.69557297, 2.80329514, 1, -8.55391263e-005, -6.28978087e-005, -6.63380342e-005, -0.965902925, 0.25890404, -8.28996126e-005, -0.25890395, -0.965903103), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(-0.152270079, -4.23744345, 1.84510767, -1, 2.19111753e-005, -5.33312559e-005, -3.52297939e-005, 0.500015736, 0.866016209, 4.56419148e-005, 0.86601609, -0.500015855), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 0.200000003, 0.200000003), cn(-0.152536869, -0.7119295, -2.94669724, -1, 9.55974247e-005, 4.89801168e-005, -9.55983123e-005, -0.999999762, -1.76297326e-005, 4.89784325e-005, -1.76344111e-005, 1), Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0.25, 3, 0.5), "Toothpaste"},
	{Vector3.new(0.200000003, 2.20000005, 1.20000005), cn(0.15265131, -2.49634123, 1.15168691, 1, -1.49821371e-005, 2.75075436e-005, 3.04488494e-005, 0.258942276, -0.965892792, 7.34827427e-006, 0.965892553, 0.258942336), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(0.152612925, -3.83569002, 1.50197709, 1, -2.76630253e-005, 2.7552247e-005, 3.76933967e-005, 0.500079393, -0.865979493, 1.01773057e-005, 0.865979373, 0.500079513), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 4.19999981, 1), cn(0.15270555, -4.23561811, 1.84841764, 1, -2.76630253e-005, 2.7552247e-005, 3.76933967e-005, 0.500079393, -0.865979493, 1.01773057e-005, 0.865979373, 0.500079513), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
	{Vector3.new(0.200000003, 2.19999981, 1), cn(-0.152220964, -1.69214988, 2.80436611, -1, 0.000166705737, 5.29289318e-005, -0.000174724628, -0.965919554, -0.258841753, 7.97468692e-006, -0.258841693, 0.965919793), Enum.MeshType.Wedge, "", Vector3.new(1, 1, 1), "Institutional white"},
}

for _, spec in ipairs(rearRotorSpecs) do
	local p = CreateWeaponPart(Enum.PartType.Block, rearRotor, Enum.Material.SmoothPlastic, 0, 1, spec[6], "Part", spec[1])
	CreateWeld(rearRotor, RearRotorHandle, p, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), spec[2])
	CreateMesh("SpecialMesh", p, spec[3], spec[4], Vector3.new(0, 0, 0), spec[5])
end

ShieldHandle = CreateWeaponPart(Enum.PartType.Block, shield, Enum.Material.Plastic, 0, 1, "Toothpaste", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
handleweld = CreateWeld(shield, RightArm, ShieldHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.238033935, -0.224113405, -0.75435853, 2.45124138e-005, 0.707114398, 0.70709914, 7.06314813e-006, -0.70709908, 0.707114458, 1, -1.23387335e-005, -2.232716e-005))

local shieldSpecs = {
	{cn(0, 0, 0, 0.707103133, 0.707110465, 4.77082322e-005, -0.707110465, 0.707103133, -3.04873265e-005, -5.52925521e-005, -1.21773119e-005, 1), Vector3.new(1, 5.5999999, 0.400000006), "Toothpaste"},
	{cn(0, 0, 0, 1, 0, 0, 0, 1, -1.8189894e-012, 0, -1.8189894e-012, 1), Vector3.new(0.800000012, 5.5999999, 0.200000003), "Cyan"},
	{cn(0, 0, 0, 0.707103133, 0.707110465, 4.77082322e-005, -0.707110465, 0.707103133, -3.04873265e-005, -5.52925521e-005, -1.21773119e-005, 1), Vector3.new(1.20000005, 6, 0.200000003), "Cyan"},
	{cn(0, 0, 0, 5.66244125e-007, 1, -5.63711073e-005, -1, 5.66244125e-007, -0.000140726566, -0.000140726537, 5.63711837e-005, 1), Vector3.new(0.600000024, 5.19999981, 0.400000006), "Toothpaste"},
	{cn(0, 0, 0, 0.707094014, -0.707119584, 0.000157117916, 0.707119584, 0.707094014, -1.47577284e-005, -0.000100661651, 0.000121536257, 1), Vector3.new(1, 5.5999999, 0.400000006), "Toothpaste"},
	{cn(0, 0, 0, 5.66244125e-007, 1, -5.63711073e-005, -1, 5.66244125e-007, -0.000140726566, -0.000140726537, 5.63711837e-005, 1), Vector3.new(0.800000012, 5.5999999, 0.200000003), "Cyan"},
	{cn(0, 0, 0, 0.707094014, -0.707119584, 0.000157117916, 0.707119584, 0.707094014, -1.47577284e-005, -0.000100661651, 0.000121536257, 1), Vector3.new(1.20000005, 6, 0.200000003), "Cyan"},
	{cn(0, 0, 0, 1, 0, 0, 0, 1, -1.8189894e-012, 0, -1.8189894e-012, 1), Vector3.new(0.600000024, 5.19999981, 0.400000006), "Toothpaste"},
}

for _, spec in ipairs(shieldSpecs) do
	local p = CreateWeaponPart(Enum.PartType.Block, shield, Enum.Material.Plastic, 0.5, 1, spec[3], "Part", Vector3.new(0.200000003, 0.200000003, 0.200000003))
	CreateWeld(shield, ShieldHandle, p, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), spec[1])
	CreateMesh("SpecialMesh", p, Enum.MeshType.FileMesh, "http://www.roblox.com/Asset/?id=9756362", Vector3.new(0, 0, 0), spec[2])
end

Blocker = CreateWeaponPart(Enum.PartType.Block, shield, Enum.Material.Plastic, 0, 1, "Medium stone grey", "Blocker", Vector3.new(0.200000003, 5.76000023, 6.46999979))
Blockerweld = CreateWeld(shield, ShieldHandle, Blocker, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.000354290009, -0.399796933, 0.0251437165, 2.45124138e-005, 7.06314813e-006, 1, 0.707114458, -0.70709914, -1.23387354e-005, 0.70709914, 0.707114458, -2.232716e-005))

LRingsHandle = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Plastic, 0, 1, "Medium stone grey", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
LRingsHandleWeld = CreateWeld(m, LeftArm, LRingsHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0, 5.96046448e-008, 0, 1, 0, 0, 0, 0.999999881, 0, 0, 0, 1))

LRingShoulder = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0, 0.5, "Toothpaste", "LRingShoulder", Vector3.new(0.2, 0.2, 0.2))
CreateMesh("SpecialMesh", LRingShoulder, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.5, 1.5, 0.4))
LRingShoulderWeld = CreateWeld(m, LRingsHandle, LRingShoulder, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.590000212, -6.36577606e-005, -6.8128109e-005, -0.000151079468, 0.999999762, 4.60445881e-005, 0.865981996, 0.000107806307, 0.500075221, 0.500075221, 0.000115424853, -0.865981996))

LRingMiddle = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0, 0.5, "Toothpaste", "LRingMiddle", Vector3.new(0.2, 0.2, 0.2))
CreateMesh("SpecialMesh", LRingMiddle, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.2, 1.2, 0.4))
LRingMiddleWeld = CreateWeld(m, LRingsHandle, LRingMiddle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(-0.130000055, -4.79730807e-006, -1.28746033e-005, -9.91046691e-005, 0.999999762, -3.68952788e-005, 7.15851929e-005, 3.69023655e-005, 1, 1, 9.91020061e-005, -7.15888527e-005))

LRingHand = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0, 0.5, "Toothpaste", "LRingHand", Vector3.new(0.2, 0.2, 0.2))
CreateMesh("SpecialMesh", LRingHand, Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=3270017", Vector3.new(0, 0, 0), Vector3.new(1.0, 1.0, 0.4))
LRingHandWeld = CreateWeld(m, LRingsHandle, LRingHand, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.309999973, 2.86102295e-006, -2.70605087e-005, 5.17578083e-005, 0.999999762, 7.09593296e-005, -0.86608696, 9.35464323e-006, 0.499893606, 0.499893546, -8.73303215e-005, 0.866086841))

generateRail = function()
	local RailHandle = CreateWeaponPart(Enum.PartType.Block, rail, Enum.Material.Plastic, 0, 1, "Medium stone grey", "Handle", Vector3.new(0.200000003, 0.200000003, 0.200000003))
	CreateWeld(m, LeftArm, RailHandle, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0, 4, 0, 1, 0, 0, 0, 0.999999881, 0, 0, 0, 1))
end

BaseLaser = CreateWeaponPart(Enum.PartType.Block, m, Enum.Material.Neon, 0.10000000149012, 1, "Toothpaste", "Handle", Vector3.new(1, 0.800000012, 1))
BaseLaserweld = CreateWeld(m, LeftArm, BaseLaser, cn(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), cn(0.800000072, 3.57627869e-007, -1.43051352e-007, 4.68747942e-007, 0.999999881, 1.78813934e-007, -1, 4.68747771e-007, 5.66653569e-007, 5.66653512e-007, -1.78814176e-007, 1))
CreateMesh("CylinderMesh", BaseLaser, "", "", Vector3.new(0, 0, 0), Vector3.new(0.200000003, 0.800000012, 0.200000003))

for _, v in ipairs(Character:GetChildren()) do
	if v:IsA("Model") then
		for _, c in ipairs(v:GetChildren()) do
			if c:IsA("BasePart") then
				c.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0.001, 0.001, 0.001, 0.001)
			end
		end
	end
end

BlockEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime, Type)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.2, 0.2, 0.2))
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = Create("BlockMesh")({Parent = prt, Offset = Vector3.new(0, 0, 0), Scale = Vector3.new(x1, y1, z1)})
	Debris:AddItem(prt, 10)
	if Type == 1 or Type == nil then
		table.insert(Effects, {prt, "Block1", delayTime, x3, y3, z3, msh})
	elseif Type == 2 then
		table.insert(Effects, {prt, "Block2", delayTime, x3, y3, z3, msh})
	end
	return prt
end

SphereEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.2, 0.2, 0.2))
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Cylinder", delayTime, x3, y3, z3, msh})
	return prt
end

RingEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
	prt.Anchored = true
	prt.CFrame = cframe * cn(x1, y1, z1)
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.FileMesh, "rbxassetid://3270017", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Cylinder", delayTime, x3, y3, z3, msh})
	return prt
end

CylinderEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.2, 0.2, 0.2))
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = Create("CylinderMesh")({Parent = prt, Offset = Vector3.new(0, 0, 0), Scale = Vector3.new(x1, y1, z1)})
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Cylinder", delayTime, x3, y3, z3, msh})
	return prt
end

WaveEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.2, 0.2, 0.2))
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.FileMesh, "rbxassetid://20329976", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Cylinder", delayTime, x3, y3, z3, msh})
	return prt
end

SpecialEffect = function(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayTime)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.2, 0.2, 0.2))
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.FileMesh, "rbxassetid://24388358", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Cylinder", delayTime, x3, y3, z3, msh})
	return prt
end

BreakEffect = function(brickcolor, cframe, x1, y1, z1)
	local prt = CreatePart(Character, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
	prt.Anchored = true
	prt.CFrame = cframe * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
	local num = math.random(10, 50) / 1000
	Debris:AddItem(prt, 10)
	table.insert(Effects, {prt, "Shatter", num, prt.CFrame, math.random() - math.random(), 0, math.random(50, 100) / 100})
	return prt
end

ChargeEffect = function(part, x1, y1, z1, x2, y2, z2, x3, y3, z3, color)
	local S = Create("Part")({
		Name = "Effect",
		Size = Vector3.new(x1, y1, z1),
		BrickColor = color,
		Reflectance = 0,
		TopSurface = Enum.SurfaceType.Smooth,
		BottomSurface = Enum.SurfaceType.Smooth,
		Transparency = 0,
		Anchored = false,
		CanCollide = false,
		Material = Enum.Material.Neon,
		CFrame = part.CFrame * cn(x2, y2, z2) * euler(x3, y3, z3),
		Parent = m,
	})
	Create("SpecialMesh")({Scale = Vector3.new(0.5, 0.5, 0.5), MeshType = Enum.MeshType.Sphere, Parent = S})
	task.spawn(function(ePart)
		local f = Instance.new("BodyPosition")
		f.P = 800
		f.D = 100
		f.MaxForce = Vector3.new(1e7, 1e7, 1e7)
		f.Position = part.Position
		f.Parent = ePart
		for _ = 0, 1, 0.1 do
			task.wait()
			if not ePart or not ePart.Parent then
				return
			end
			ePart.Transparency = math.min(1, ePart.Transparency + 0.1)
		end
		if ePart and ePart.Parent then
			ePart:Destroy()
		end
	end, S)
end

local function updateIdleRings()
	LRingShoulderWeld.C0 = clerp(LRingShoulderWeld.C0, cn(0, 0, 0) * angles(0, mr(30) - donum / 0.08, 0), 0.3)
	LRingMiddleWeld.C0 = clerp(LRingMiddleWeld.C0, cn(0, 0, 0) * angles(0, mr(30) + donum / 0.05, 0), 0.3)
	LRingHandWeld.C0 = clerp(LRingHandWeld.C0, cn(0, 0, 0) * angles(0, mr(30) - donum / 0.03, 0), 0.3)
end

attackone = function()
	attack = true
	CreateSound("http://www.roblox.com/asset/?id=442069814", LeftArm, 0.5, 1)
	local con = Hitbox.Touched:Connect(function(hit)
		Damagefunc(Hitbox, hit, 2, 4, 1, "Normal", RootPart, 0.2, 1)
	end)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-15)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(15)), 0.33)
		RW.C0 = clerp(RW.C0, cn(0.5, 0.4, -0.5) * angles(mr(83), 0, mr(-40)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.4, 0.2, -0.4) * angles(mr(88), 0, 0), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), mr(12), 0), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), mr(10), 0), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-60)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(30), 0, mr(20)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.1) * angles(mr(85), 0, mr(-60)), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), mr(40), 0), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), mr(40), 0), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, -1.5) * angles(0, 0, 0), 0.33)
	end
	CreateSound("http://www.roblox.com/asset/?id=356425259", LeftArm, 1, 2)
	CreateSound("http://www.roblox.com/asset/?id=412756170", LeftArm, 1, 0.8)
	for i = 0, 1, 0.05 do
		swait()
		SMnrgRng.Transparency = math.max(0.5, 1 - i)
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-60)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(30), 0, mr(20)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.1) * angles(mr(85), 0, mr(-60)), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), mr(40), 0), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), mr(40), 0), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.005), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.005), 0.33)
	end
	SMnrgRng.Transparency = 1
	con:Disconnect()
	attack = false
end

attacktwo = function()
	attack = true
	local con = Hitbox.Touched:Connect(function(hit)
		Damagefunc(Hitbox, hit, 3, 7, math.random(2, 3), "Normal", RootPart, 0.2, 1)
	end)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-60)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, -0.1) * angles(mr(20), 0, mr(10)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.7) * angles(mr(85), mr(-20), mr(15)), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), mr(30), 0), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), mr(30), 0), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	CreateSound("http://www.roblox.com/asset/?id=356215636", LeftArm, 1, 1)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(80)), 0.35)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(5), 0, mr(-80)), 0.35)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(90), 0, mr(40)), 0.35)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.1) * angles(mr(20), mr(-20), mr(-80)), 0.35)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-10), mr(-30), 0), 0.35)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-10), mr(-30), 0), 0.35)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	con:Disconnect()
	attack = false
end

attackthree = function()
	attack = true
	CreateSound("http://www.roblox.com/asset/?id=356425259", SMnrgRng, 1, 1)
	for i = 0, 1, 0.03 do
		swait()
		for _, v in ipairs(rearRotor:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "Handle" then
				v.Transparency = math.clamp(1 - i - 0.2, 0, 1)
			end
		end
		LGnrgRng.Transparency = math.max(0.5, 1 - i)
		SMnrgRng.Transparency = math.max(0.5, 1 - i)
		BlockEffect("Toothpaste", LeftArm.CFrame * cn(0, -1, 0), 0.5, 0.5, 0.5, 0.8, 0.8, 0.8, 0.05, 1)
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-60)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(30), 0, mr(20)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.1) * angles(mr(85), 0, mr(-60)), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), mr(40), 0), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), mr(40), 0), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.03), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -5, 0) * angles(0, mr(30) + donum / 0.05, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	CreateSound("http://roblox.com/asset/?id=315744661", LGnrgRng, 1, 1)
	CreateSound("http://www.roblox.com/asset/?id=300916014", LGnrgRng, 1, 1)
	RootPart.AssemblyLinearVelocity = RootPart.CFrame.LookVector * -70
	SphereEffect("Toothpaste", LeftArm.CFrame * cn(0, -3, 0), 0.5, 0.5, 0.5, 0.8, 0.8, 0.8, 0.05)
	MagniDamage(LGnrgRng, 8, 6, 16, 100, "Normal")
	for _ = 1, 10 do
		BreakEffect("Toothpaste", LeftArm.CFrame * cn(0, -1, 0), 1, 3, 2)
	end
	for i = 0, 1, 0.13 do
		swait()
		for _, v in ipairs(rearRotor:GetChildren()) do
			if v:IsA("BasePart") then
				v.Transparency = i
			end
		end
		LGnrgRng.Transparency = i
		SMnrgRng.Transparency = i
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(-4), 0, mr(40)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(5), mr(-5), mr(-40)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(50), 0, mr(30)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, -0.1) * angles(mr(120), 0, mr(30)), 0.33)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-10), mr(-40), mr(5)), 0.33)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-10), mr(-40), mr(-5)), 0.33)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	for _, v in ipairs(rearRotor:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end
	LGnrgRng.Transparency = 1
	SMnrgRng.Transparency = 1
	attack = false
end

Block = function()
	attack = true
	block.Value = true
	Humanoid.WalkSpeed = math.max(0, Humanoid.WalkSpeed - 6)
	task.spawn(function()
		for i = 1, 0, -0.05 do
			task.wait()
			if attack ~= false then
				for _, v in ipairs(shield:GetChildren()) do
					if v:IsA("BasePart") and v.Name ~= "Handle" and v.Name ~= "Blocker" then
						v.Transparency = math.clamp(i - 0.05, 0, 1)
					end
				end
			else
				for _, v in ipairs(shield:GetChildren()) do
					if v:IsA("BasePart") and v.Name ~= "Handle" and v.Name ~= "Blocker" then
						v.Transparency = 1
					end
				end
				break
			end
		end
	end)
	task.spawn(function()
		task.wait(0.3)
		if block.Value then
			Blocker.CanCollide = true
		end
	end)
	task.spawn(function()
		while Blocking == true do
			swait(2)
			subtractMana(blockDrainRate)
			if Mana <= blockDrainRate then
				Blocking = false
			end
		end
	end)
	while Blocking == true do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(50)), 0.33)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-50)), 0.33)
		RW.C0 = clerp(RW.C0, cn(1, 0.3, -0.4) * angles(mr(90), 0, mr(-32)), 0.33)
		LW.C0 = clerp(LW.C0, cn(-1.4, 0.5, 0) * angles(mr(20), mr(15), mr(-70)), 0.3)
		if Torsovelocity > 2 then
			RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-2), mr(-30), mr(20 * math.cos(sine / 4))), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), mr(-30), mr(20 * math.cos(sine / 4))), 0.3)
		elseif Torsovelocity < 1 then
			RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-2), mr(-30), 0), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), mr(-30), 0), 0.3)
		end
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	for _, v in ipairs(shield:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "Handle" then
			v.Transparency = 1
		end
	end
	Humanoid.WalkSpeed = Humanoid.WalkSpeed + 6
	block.Value = false
	Blocker.CanCollide = false
	attack = false
end

groundBreaker = function()
	attack = true
	Humanoid.WalkSpeed = 0
	local AntiJump = Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		Humanoid.Jump = false
	end)
	CreateSound("http://www.roblox.com/asset/?id=412756170", LeftArm, 1, 0.8)
	for _ = 0, 1, 0.05 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.8) * angles(mr(40), 0, mr(-10)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(15), 0, mr(18)), 0.3)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(30), 0, mr(8)), 0.3)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.2, 0.3) * angles(mr(40), 0, mr(-10)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -0.2, -0.3) * RHCF * angles(mr(-3), 0, mr(30)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -0.6, -0.25) * LHCF * angles(mr(-3), 0, mr(10)), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.2) * angles(0, 0, mr(30) - donum / 0.005), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	MagniDamage(Torso, 10, 20, 30, 70, "Knockdown")
	for _ = 1, 10 do
		BreakEffect("Toothpaste", LeftArm.CFrame * cn(0, -1, 0), 1, 3, 2)
	end
	local hitfloor = nil
	local floorTimeout = 0
	while hitfloor == nil and floorTimeout < 120 do
		floorTimeout = floorTimeout + 1
		swait()
		hitfloor = rayCast(RootPart.Position, cn(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 6, Character)
	end
	local hit, pos = rayCast(Hitbox.Position, cn(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 4, Character)
	if hit ~= nil then
		local refpart = CreatePart(Character, Enum.Material.SmoothPlastic, 0, 1, "Really black", "Effect", Vector3.new(0.2, 0.2, 0.2))
		refpart.Anchored = true
		refpart.CFrame = cn(pos)
		Debris:AddItem(refpart, 1)
		CreateSound("http://www.roblox.com/asset/?id=199145477", refpart, 0.8, 0.75)
		CreateSound("http://www.roblox.com/asset/?id=142070127", refpart, 0.7, 0.9)
		for _ = 1, 10 do
			local groundpart = CreatePart(Character, Enum.Material.SmoothPlastic, 0, 0, hit.BrickColor, "Ground", Vector3.new(math.random(50, 100) / 100, math.random(50, 100) / 100, math.random(50, 100) / 100))
			groundpart.Anchored = false
			groundpart.Material = hit.Material
			groundpart.CanCollide = true
			groundpart.CustomPhysicalProperties = PhysicalProperties.new(1, 0.1, 0.5)
			groundpart.AssemblyLinearVelocity = Vector3.new(math.random(-50, 50), math.random(25, 50), math.random(-50, 50))
			groundpart.CFrame = cn(pos) * cn(math.random(-250, 250) / 100, 0.5, math.random(-250, 250) / 100) * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
			Debris:AddItem(groundpart, 10)
		end
		for _ = 1, 10 do
			local actualgroundpart = CreatePart(Character, Enum.Material.SmoothPlastic, 0, 0, hit.BrickColor, "Ground", Vector3.new(math.random(100, 200) / 100, math.random(100, 200) / 100, math.random(100, 200) / 100))
			actualgroundpart.Anchored = true
			actualgroundpart.Material = hit.Material
			actualgroundpart.CFrame = cn(pos) * cn(math.random(-500, 500) / 100, 0, math.random(-500, 500) / 100) * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
			Debris:AddItem(actualgroundpart, 10)
		end
		WaveEffect(hit.BrickColor, refpart.CFrame, 0.2, 0.2, 0.2, 0.5, 0.5, 0.5, 0.04)
		SphereEffect(hit.BrickColor, refpart.CFrame, 0.2, 0.2, 0.2, 3, 3, 3, 0.04)
		RingEffect(hit.BrickColor, refpart.CFrame * CFrame.Angles(math.random(5, 6), math.random(2, 7), math.random(3, 6)), 0.2, 0.2, 0.2, 1, 1, 1, 0.05)
	end
	for _ = 0, 1, 0.05 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.65) * angles(mr(25), 0, 0), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(15), 0, mr(30)), 0.3)
		RW.C0 = clerp(RW.C0, cn(1.6, 0.4, 0) * angles(mr(-15), 0, mr(30)), 0.3)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(20), mr(-30), mr(-30)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -0.2, -0.3) * RHCF * angles(mr(-3), 0, mr(30)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -0.6, -0.25) * LHCF * angles(mr(-3), 0, mr(3)), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	Humanoid.WalkSpeed = 16
	AntiJump:Disconnect()
	attack = false
end

LaunchRail = function()
	attack = true
	local blocked = false
	CreateSound("http://www.roblox.com/asset/?id=298660207", LeftArm, 1, 1)
	Aim()
	CreateSound("http://www.roblox.com/asset/?id=188590169", LeftArm, 1, 1)
	local MainPos = LeftArm.Position
	local MainPos2 = mouse.Hit.Position
	local MouseLook = cn((MainPos + MainPos2) / 2, MainPos2)
	local num = 60
	task.spawn(function()
		repeat
			task.wait()
			local hit, pos = rayCast(MainPos, MouseLook.LookVector, 10, Character)
			local mag = (MainPos - pos).Magnitude
			CylinderEffect("Toothpaste", cn((MainPos + pos) / 2, pos) * angles(1.57, 0, 0), 3, mag * 5, 3, 0.5, 0, 1.5, 0.1)
			MainPos = MainPos + MouseLook.LookVector * 10
			num = num - 1
			local originRef = (LeftArm.CFrame * cn(0, 0.25, -1.7)).Position
			local diff = pos - originRef
			local fakevec = diff.Magnitude > 0 and diff.Unit or MouseLook.LookVector
			if hit ~= nil and not hit:IsDescendantOf(rail) then
				num = 0
				local ref = CreateWeaponPart(Enum.PartType.Block, Character, Enum.Material.Neon, 0, 1, BrickColor.new("Institutional white"), "Reference", Vector3.new(0.2, 0.2, 0.2))
				ref.Anchored = true
				ref.CFrame = cn(pos)
				Debris:AddItem(ref, 5)
				local h = findHumanoidFromHit(hit)
				if h ~= nil and h.Health > 0 then
					if hit.Name == "Blocker" and hit.CanCollide == true then
						blocked = true
						CreateSound("http://www.roblox.com/asset/?id=199148947", hit, 1, 1)
					else
						h.WalkSpeed = math.max(0, h.WalkSpeed - 5)
						task.spawn(function()
							for _ = 1, 10 do
								if h and h.Parent and h.Health > 0 then
									task.wait(1)
								end
							end
							if h and h.Parent then
								h.WalkSpeed = h.WalkSpeed + 5
							end
						end)
					end
				end
				if not blocked then
					if hit.Name == "Blocker" and hit.CanCollide == true then
						CreateSound("http://www.roblox.com/asset/?id=199148947", hit, 1, 1)
					elseif not hit.Anchored then
						hit.CFrame = hit.CFrame + Vector3.new(0, 0.1, 0)
						hit.AssemblyLinearVelocity = hit.AssemblyLinearVelocity + fakevec * 50
					end
				end
			end
		until num <= 0
	end)
	for i = 0, 1, 0.05 do
		for _, v in ipairs(rearRotor:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "Handle" then
				v.Transparency = i
			end
		end
		LGnrgRng.Transparency = math.clamp(i + 0.05, 0, 1)
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-50)), 0.5)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(50)), 0.5)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(-10), 0, mr(20)), 0.5)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(90), 0, mr(-50)), 0.5)
		RH.C0 = clerp(RH.C0, cn(0.5, -1, -0.2) * RHCF * angles(mr(-2), mr(85), 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-0.5, -1, 0.2) * LHCF * angles(mr(-2), mr(85), 0), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.045), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -2.5, 0) * angles(0, mr(30) + donum / 0.07, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	Humanoid.WalkSpeed = Humanoid.WalkSpeed + 10
	SMnrgRng.Transparency = 1
	LGnrgRng.Transparency = 1
	for _, v in ipairs(rearRotor:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "Handle" then
			v.Transparency = 1
		end
	end
	cooldown3 = 0
	attack = false
end

Pulse = function()
	attack = true
	local con = Hitbox.Touched:Connect(function(hit)
		Damagefunc(Hitbox, hit, 1, 3, 1, "Normal", RootPart, 0.2, 1)
	end)
	CreateSound("http://www.roblox.com/asset/?id=412756170", LeftArm, 1, 0.8)
	for i = 0, 1, 0.05 do
		swait()
		SMnrgRng.Transparency = math.max(0.5, 1 - i)
		BlockEffect("Toothpaste", LeftArm.CFrame * cn(0, -1, 0), 0.5, 0.5, 0.5, 0.8, 0.8, 0.8, 0.05, 1)
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(15), 0, mr(-50)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-10), 0, mr(40)), 0.3)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(80), mr(20), mr(-20)), 0.3)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(100), 0, mr(-40)), 0.3)
		RH.C0 = clerp(RH.C0, cn(0.7, -1, -0.7) * RHCF * angles(mr(-4), mr(40), mr(10)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-0.7, -1, 0.7) * LHCF * angles(mr(-4), mr(40), mr(20)), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.005), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, -1.5) * angles(0, 0, 0), 0.33)
	end
	con:Disconnect()
	local vel2 = Instance.new("BodyVelocity")
	vel2.MaxForce = Vector3.new(400000, 400000, 400000)
	vel2.Velocity = RootPart.CFrame.LookVector * -90
	vel2.Parent = Torso
	Humanoid.Jump = true

	local prt = CreatePart(Character, Enum.Material.SmoothPlastic, 0, 1, "Toothpaste", "Part", Vector3.new(5, 5, 5))
	prt.Position = SMnrgRng.Position
	prt.Anchored = true
	CreateSound("http://www.roblox.com/asset/?id=300916105", prt, 1, 1)
	WaveEffect("Toothpaste", prt.CFrame, 0.2, 0.2, 0.2, 0.5, 0.5, 0.5, 0.06)
	SphereEffect("Toothpaste", prt.CFrame, 0.2, 0.2, 0.2, 3, 3, 3, 0.06)
	RingEffect("Toothpaste", prt.CFrame * CFrame.Angles(math.random(5, 6), math.random(2, 7), math.random(3, 6)), 0.2, 0.2, 0.2, 1, 1, 1, 0.07)
	MagniDamage(prt, 13, 17, 23, 13, "Knockdown")

	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-50)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(40)), 0.3)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(80), mr(20), mr(-20)), 0.3)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(150), mr(-60), mr(-50)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-4), mr(10), mr(10)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-4), mr(10), mr(20)), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	vel2:Destroy()
	SMnrgRng.Transparency = 1
	prt:Destroy()
	attack = false
end

AimLaserMethod = function()
	attack = true
	CreateSound("http://www.roblox.com/asset/?id=445796756", LeftArm, 1, 1)
	Humanoid.WalkSpeed = math.max(0, Humanoid.WalkSpeed - 10)
	local Beam = BaseLaser:Clone()
	Beam.Name = "Laser"
	Beam.Anchored = true
	Beam.Parent = m
	local beamMesh = Beam:FindFirstChildOfClass("SpecialMesh") or Beam:FindFirstChildOfClass("CylinderMesh")
	if beamMesh then
		beamMesh.Scale = Vector3.new(1, 1, 1)
	end

	RootJoint.C0 = RootCF * cn(0, 0, 0) * euler(0, 0, -0.7005)
	local gyro = Create("BodyGyro")({Parent = RootPart, MaxTorque = Vector3.new(1e7, 1e7, 1e7), P = 2500, CFrame = RootPart.CFrame})

	task.spawn(function()
		for _ = 1, 10, 0.1 do
			swait()
			ChargeEffect(SMnrgRng, 2, 2, 2, math.random(-10, 10), math.random(-10, 10), math.random(-10, 10), 0, 0, 0, BrickColor.new("Toothpaste"))
		end
	end)

	for i = 0, 1, 0.008 do
		swait()
		local hitPos = mouse.Hit.Position
		local gunpos = Vector3.new(hitPos.X, Head.Position.Y, hitPos.Z)
		gyro.CFrame = cn(Head.Position, gunpos)
		for _, v in ipairs(rearRotor:GetChildren()) do
			if v.Name ~= "Handle" and v:IsA("BasePart") then
				v.Transparency = math.clamp(1 - i - 0.2, 0, 1)
			end
		end
		if i <= 0.4 then
			SMnrgRng.Transparency = 0.5
			LGnrgRng.Transparency = 0.5
		else
			SMnrgRng.Transparency = 1 - i
			LGnrgRng.Transparency = 1 - i
		end
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-40)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(40)), 0.3)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.6, 0.4) * angles(mr(-15), mr(-50), mr(20)), 0.3)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(90), 0, mr(-40)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-4), mr(20), 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-4), mr(20), 0), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.025), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -5, 0) * angles(0, mr(30) + donum / 0.05, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end

	local dV = 1
	local offset = 0
	lapse = 0
	local hitRef = CreatePart(Character, Enum.Material.Neon, 0, 0.4, "Toothpaste", "Reference", Vector3.new(0.2, 0.2, 0.2))
	CreateMesh("SpecialMesh", hitRef, Enum.MeshType.Sphere, "", Vector3.new(), Vector3.new(8, 8, 8))
	hitRef.Anchored = true
	local laserLoop = CreateSound("http://www.roblox.com/asset/?id=445796828", LeftArm, 1, 1, true)

	task.spawn(function()
		while vHold == true do
			swait(3)
			subtractMana(skill4absorbrate)
			if Mana <= skill4absorbrate then
				vHold = false
			end
		end
	end)

	while vHold == true do
		swait()
		dV = dV + 10
		local StartPos = LeftArm.CFrame * cn(0, -1, 0)
		local MainPos = LeftArm.Position
		local MainPos2 = mouse.Hit.Position
		local MouseLook = cn((MainPos + MainPos2) / 2, MainPos2)
		local hit, pos = rayCast(MainPos, MouseLook.LookVector, dV, Character)
		local mag = (MainPos - pos).Magnitude

		if hit and hit:IsA("Terrain") then
			pcall(function()
				hit:FillBall(pos + Vector3.new(0, 2, 0), 4, Enum.Material.Air)
			end)
		end

		hitRef.CFrame = StartPos * cn(0, -mag + 1, 0) * angles(0, 0, mr(90))
		local vary = math.random(5, 10) / 100
		SphereEffect("Toothpaste", hitRef.CFrame, 8, 8, 8, 1, 1, 1, vary)
		BlockEffect("Toothpaste", hitRef.CFrame, 8, 8, 8, 0.8, 0.8, 0.8, vary, 1)

		if hit ~= nil then
			local h = findHumanoidFromHit(hit)
			local sounds = {445796485, 445796549, 445796638}
			local rnd = math.random(1, #sounds)
			CreateSound("http://www.roblox.com/asset/?id=" .. sounds[rnd], hitRef, 1, 1)
			if h and h.Health > 0 then
				Damagefunc(hitRef, hit, 2, 4, 0.7, "Normal", RootPart, 0.2, 1, nil, 2)
			end
			if not hit.Anchored then
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
				bv.Velocity = Head.CFrame.LookVector * 100 + Vector3.new(0, -2, 0)
				bv.Parent = hit
				task.delay(0.1, function()
					if bv and bv.Parent then
						bv:Destroy()
					end
				end)
			end
		end

		Beam.Transparency = 0.4
		lapse = lapse + 1
		if beamMesh then
			beamMesh.Scale = Vector3.new(mag + 9, 2, 2)
		end
		Beam.CFrame = StartPos * cn(0, -mag / 2 - 4.5, 0) * angles(0, 0, mr(90))

		local hitPos = mouse.Hit.Position
		local gunpos = Vector3.new(hitPos.X, Head.Position.Y, hitPos.Z)
		offset = (Torso.Position.Y - hitPos.Y) / 40
		local mag2 = math.max(0.01, (Torso.Position - hitPos).Magnitude / 80)
		offset = offset / mag2
		gyro.CFrame = cn(Head.Position, gunpos)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * euler(0, 0, 0.75), 0.3)
		LW.C1 = clerp(LW.C1, cn(0, 0.5, 0) * euler(offset, 0, 0), 0.5)
		if Torsovelocity > 2 then
			RH.C0 = clerp(RH.C0, cn(1, -1, -0.2) * RHCF * angles(mr(-2), mr(20), mr(15 * math.cos(sine / 6))), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), mr(20), mr(15 * math.cos(sine / 6))), 0.3)
		elseif Torsovelocity < 1 then
			RH.C0 = clerp(RH.C0, cn(1, -1, -0.2) * RHCF * angles(mr(-2), mr(20), 0), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), mr(20), 0), 0.3)
		end
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.005), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -5, 0) * angles(0, mr(30) + donum / 0.01, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end

	laserLoop:Stop()
	laserLoop:Destroy()
	CreateSound("http://www.roblox.com/asset/?id=445796907", LeftArm, 1, 1)
	for i = 0, 1, 0.05 do
		for _, v in ipairs(rearRotor:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "Handle" then
				v.Transparency = (i >= 0.9) and 1 or i
			end
		end
		if lapse > 1 then
			Beam.Transparency = i
			hitRef.Transparency = i
		end
		LGnrgRng.Transparency = math.clamp(i + 0.05, 0, 1)
		SMnrgRng.Transparency = math.clamp(i + 0.05, 0, 1)
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-50)), 0.5)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(50)), 0.5)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(-10), 0, mr(20)), 0.5)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(90), 0, mr(-50)), 0.5)
		RH.C0 = clerp(RH.C0, cn(1, -1, -0.2) * RHCF * angles(mr(-2), mr(20), 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), mr(20), 0), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) + donum / 0.045), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -5, 0) * angles(0, mr(30) - donum / 0.07, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	Beam:Destroy()
	hitRef:Destroy()
	Humanoid.WalkSpeed = Humanoid.WalkSpeed + 10
	gyro:Destroy()
	LW.C1 = clerp(LW.C1, cn(0, 0.5, 0) * euler(0, 0, 0), 0.5)
	LGnrgRng.Transparency = 1
	SMnrgRng.Transparency = 1
	cooldown4 = 0
	attack = false
end

Aim = function()
	Humanoid.WalkSpeed = math.max(0, Humanoid.WalkSpeed - 10)
	for _ = 0, 1, 0.2 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(0, 0, mr(-90)), 0.5)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(90)), 0.5)
		RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(-10), 0, mr(20)), 0.5)
		LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(90), 0, mr(-90)), 0.5)
		RH.C0 = clerp(RH.C0, cn(0.5, -1, -0.2) * RHCF * angles(mr(-2), mr(85), 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-0.5, -1, 0.2) * LHCF * angles(mr(-2), mr(85), 0), 0.3)
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, 0), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	aim = true
	RootJoint.C0 = RootCF * cn(0, 0, 0) * euler(0, 0, -1.57)
	local gyro = Create("BodyGyro")({Parent = RootPart, MaxTorque = Vector3.new(1e7, 1e7, 1e7), P = 20000, CFrame = RootPart.CFrame})
	local offset = 0

	task.spawn(function()
		for i = 1, 0.5, -0.1 do
			SMnrgRng.Transparency = i
			LGnrgRng.Transparency = i
			swait()
		end
	end)

	task.spawn(function()
		for i = 1, 0, -0.05 do
			task.wait()
			if attack ~= false then
				for _, v in ipairs(rearRotor:GetChildren()) do
					if v:IsA("BasePart") and v.Name ~= "Handle" then
						v.Transparency = math.clamp(i - 0.05, 0, 1)
					end
				end
			else
				for _, v in ipairs(rearRotor:GetChildren()) do
					if v:IsA("BasePart") and v.Name ~= "Handle" then
						v.Transparency = 1
					end
				end
				break
			end
		end
	end)

	local aimLoop = CreateSound("http://www.roblox.com/asset/?id=141268701", LeftArm, 1, 1, true)
	while aim == true do
		swait()
		local hitPos = mouse.Hit.Position
		local gunpos = Vector3.new(hitPos.X, Head.Position.Y, hitPos.Z)
		offset = (Torso.Position.Y - hitPos.Y) / 40
		local mag = math.max(0.01, (Torso.Position - hitPos).Magnitude / 80)
		offset = offset / mag
		gyro.CFrame = cn(Head.Position, gunpos)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * euler(0, 0, 1.57), 0.3)
		LW.C1 = clerp(LW.C1, cn(0, 0.5, 0) * euler(offset, 0, 0), 0.5)
		if Torsovelocity > 2 then
			RH.C0 = clerp(RH.C0, cn(0.5, -1, -0.2) * RHCF * angles(mr(-2), mr(85), mr(15 * math.cos(sine / 6))), 0.3)
			LH.C0 = clerp(LH.C0, cn(-0.5, -1, 0.2) * LHCF * angles(mr(-2), mr(85), mr(15 * math.cos(sine / 6))), 0.3)
		elseif Torsovelocity < 1 then
			RH.C0 = clerp(RH.C0, cn(0.5, -1, -0.2) * RHCF * angles(mr(-2), mr(85), 0), 0.3)
			LH.C0 = clerp(LH.C0, cn(-0.5, -1, 0.2) * LHCF * angles(mr(-2), mr(85), 0), 0.3)
		end
		updateIdleRings()
		RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, -1.5) * angles(0, 0, mr(30) - donum / 0.025), 0.33)
		RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, -5, 0) * angles(0, mr(30) + donum / 0.05, 0), 0.33)
		Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
	end
	aimLoop:Stop()
	LW.C1 = clerp(LW.C1, cn(0, 0.5, 0) * euler(0, 0, 0), 0.5)
	gyro:Destroy()
	rail:ClearAllChildren()
	aimLoop:Destroy()
end

subtractMana = function(k)
	if k <= Mana then
		Mana = Mana - k
	end
end

combo = 0
mouse1d = function()
	if attack == true and aim == false then
		return
	end
	if attack == true and aim == true then
		aim = false
		return
	end
	hold = true
	if combo == 0 then
		combo = 1
		attackone()
	elseif combo == 1 then
		combo = 2
		attacktwo()
	elseif combo == 2 then
		combo = 0
		attackthree()
	end
	task.spawn(function()
		for _ = 1, 20 do
			if attack == false or block.Value == true then
				swait()
			end
		end
		if attack == false or block.Value == true then
			combo = 0
		end
	end)
end

mouse1u = function()
	hold = false
end

buttonhold = false
mouse.KeyDown:Connect(function(k)
	k = k:lower()
	if attack == false and k == "z" and co1 <= cooldown1 and skill1stam <= Mana then
		cooldown1 = 0
		subtractMana(skill1stam)
		groundBreaker()
	elseif attack == false and k == "x" and co2 <= cooldown2 and skill2stam <= Mana then
		cooldown2 = 0
		subtractMana(skill2stam)
		Pulse()
	elseif attack == false and k == "e" then
		Blocking = true
		Block()
	elseif attack == false and k == "c" and co3 <= cooldown3 and skill3stam <= Mana then
		cooldown3 = 0
		subtractMana(skill3stam)
		LaunchRail()
	elseif attack == false and k == "v" and co4 <= cooldown4 and skill4stam <= Mana then
		cooldown4 = 0
		subtractMana(skill4stam)
		vHold = true
		AimLaserMethod()
	end
end)

mouse.KeyUp:Connect(function(k)
	k = k:lower()
	if attack == true and k == "e" and Blocking == true then
		Blocking = false
	end
	if attack == true and k == "v" and vHold == true then
		vHold = false
	end
end)

mouse.Button1Down:Connect(function()
	mouse1d(mouse)
end)

mouse.Button1Up:Connect(function()
	mouse1u(mouse)
end)

numbb = 0
datnumb = 0
local Blink = 0
local BlinkEff = false

updateskills = function()
	if cooldown1 <= co1 then
		cooldown1 = cooldown1 + 1 / 30
	end
	if cooldown2 <= co2 then
		cooldown2 = cooldown2 + 1 / 30
	end
	if cooldown3 <= co3 then
		cooldown3 = cooldown3 + 1 / 30
	end
	if cooldown4 <= co4 then
		cooldown4 = cooldown4 + 1 / 30
	end

	local dimColor = Color3.new(0.4078431372549, 0.4078431372549, 0.4078431372549)
	bar4.BackgroundColor3 = (Mana <= skill1stam) and dimColor or skillcolorscheme
	bar3.BackgroundColor3 = (Mana <= skill2stam) and dimColor or skillcolorscheme
	bar1.BackgroundColor3 = (Mana <= skill3stam) and dimColor or skillcolorscheme
	bar2.BackgroundColor3 = (Mana <= skill4stam) and dimColor or skillcolorscheme

	if Mana <= maxMana then
		Mana = math.min(maxMana, Mana + recovermana / 30)
	end
end

while true do
	swait()
	for _, v in ipairs(Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
		elseif v:IsA("Accoutrement") and v:FindFirstChild("Handle") then
			v.Handle.Material = Enum.Material.SmoothPlastic
		end
	end

	updateskills()
	local hpRatio = math.clamp(Humanoid.Health / math.max(1, Humanoid.MaxHealth), 0, 1)
	healthcover:TweenSize(UDim2.new(hpRatio, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
	Manacover:TweenSize(UDim2.new(math.clamp(Mana / math.max(1, maxMana), 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
	bar4:TweenSize(UDim2.new(math.clamp(cooldown1 / math.max(0.01, co1), 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
	bar3:TweenSize(UDim2.new(math.clamp(cooldown2 / math.max(0.01, co2), 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
	bar1:TweenSize(UDim2.new(math.clamp(cooldown3 / math.max(0.01, co3), 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
	bar2:TweenSize(UDim2.new(math.clamp(cooldown4 / math.max(0.01, co4), 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)

	Blink = Blink + 0.55
	if 15 - 5 * (Humanoid.WalkSpeed / 16) <= Blink then
		Blink = 0
		BlinkEff = not BlinkEff
	end

	Torsovelocity = (RootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
	velocity = RootPart.AssemblyLinearVelocity.Y
	sine = sine + change
	local hit = rayCast(RootPart.Position, cn(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 4, Character)

	if 0.5 <= donum2 then
		handidle = true
	elseif donum2 <= 0 then
		handidle = false
	end
	if handidle == false then
		donum2 = donum2 + 0.003
	else
		donum2 = donum2 - 0.003
	end
	donum = donum + 0.003

	if RootPart.AssemblyLinearVelocity.Y > 1 and hit == nil then
		Anim = "Jump"
		if attack == false then
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * CFrame.Angles(0, 0, 0), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * CFrame.Angles(mr(-20), 0, 0), 0.3)
			RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * CFrame.Angles(mr(10), 0, mr(20)), 0.3)
			LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * CFrame.Angles(mr(-10), 0, mr(-10)), 0.3)
			RH.C0 = clerp(RH.C0, cn(1, -0.5, -0.3) * RHCF * CFrame.Angles(mr(-3), 0, mr(-20)), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * CFrame.Angles(0, 0, mr(20)), 0.3)
			updateIdleRings()
			RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		end
	elseif RootPart.AssemblyLinearVelocity.Y < -1 and hit == nil then
		Anim = "Fall"
		if attack == false then
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * CFrame.Angles(0, 0, 0), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * CFrame.Angles(mr(20), 0, 0), 0.3)
			RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * CFrame.Angles(mr(20), 0, mr(20)), 0.3)
			LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * CFrame.Angles(mr(-20), 0, mr(-30)), 0.3)
			RH.C0 = clerp(RH.C0, cn(1, -0.8, 0) * RHCF * CFrame.Angles(0, 0, mr(10)), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * CFrame.Angles(0, 0, mr(10)), 0.3)
			updateIdleRings()
			RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		end
	elseif Torsovelocity < 1 and hit ~= nil then
		Anim = "Idle"
		if attack == false then
			change = 1
			Jumping = false
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.15 + 0.1 * math.cos(sine / 15)) * angles(0, 0, mr(-10)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(10)), 0.3)
			RW.C0 = clerp(RW.C0, cn(1.5, 0.5, 0) * angles(mr(-11), mr(-10), mr(15 + 5 * math.cos(sine / 15))), 0.3)
			LW.C0 = clerp(LW.C0, cn(-1.5, 0.5, 0) * angles(mr(25 - 3 * math.cos(sine / 15)), mr(-20), mr(-45 - 3 * math.cos(sine / 15))), 0.3)
			RH.C0 = clerp(RH.C0, cn(1.05, -0.8 - 0.1 * math.cos(sine / 15), 0) * RHCF * angles(mr(-4 - 1 * math.cos(sine / 35)), mr(15), 0), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1.05, -0.8 - 0.1 * math.cos(sine / 15), 0) * LHCF * angles(mr(-4 - 1 * math.cos(sine / 35)), mr(15), 0), 0.3)
			updateIdleRings()
			RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		end
	elseif Torsovelocity > 2 and hit ~= nil then
		Anim = "Walk"
		if attack == false then
			change = 3
			Jumping = false
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(10 + 1 * math.cos(sine / 15)), 0, mr(3 * math.cos(sine / 15))), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5 - 1 * math.cos(sine / 15)), 0, mr(-1 * math.cos(sine / 15))), 0.3)
			RW.C0 = clerp(RW.C0, cn(1.45 + 0.1 * math.cos(sine / 13), 0.5, -0.1 * math.cos(sine / 13)) * angles(math.sin(40) * math.cos(sine / 13), 0, mr(10 + 1 * math.cos(sine / 13))), 0.3)
			LW.C0 = clerp(LW.C0, cn(-1.4, 0.5, 0) * angles(mr(10 + 1 * math.cos(sine / 14)), 0, mr(-45 + 3 * math.cos(sine / 14))), 0.3)
			RH.C0 = clerp(RH.C0, cn(1, -1, -0.5 * math.cos(sine / 15) / 2) * RHCF * angles(mr(-4), 0, mr(40 * math.cos(sine / 15))), 0.3)
			LH.C0 = clerp(LH.C0, cn(-1, -1, 0.5 * math.cos(sine / 15) / 2) * LHCF * angles(mr(-4), 0, mr(40 * math.cos(sine / 15))), 0.3)
			updateIdleRings()
			RotorHandleweld.C0 = clerp(RotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			RearRotorHandleweld.C0 = clerp(RearRotorHandleweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
			Hitboxweld.C0 = clerp(Hitboxweld.C0, cn(0, 0, 0) * angles(0, 0, 0), 0.33)
		end
	end

	for e = #Effects, 1, -1 do
		local Thing = Effects[e]
		if Thing then
			local ePart = Thing[1]
			local Mode = Thing[2]
			if ePart and ePart.Parent and ePart.Transparency <= 1 then
				if Mode == "Block1" then
					ePart.CFrame = ePart.CFrame * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
					local Mesh = ePart:FindFirstChildOfClass("BlockMesh") or Thing[7]
					if Mesh then
						Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
					end
					ePart.Transparency = ePart.Transparency + Thing[3]
				elseif Mode == "Block2" then
					local Mesh = Thing[7]
					if Mesh then
						Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
					end
					ePart.Transparency = ePart.Transparency + Thing[3]
				elseif Mode == "Cylinder" then
					local Mesh = ePart:FindFirstChildOfClass("SpecialMesh") or ePart:FindFirstChildOfClass("CylinderMesh") or Thing[7]
					if Mesh then
						Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
					end
					ePart.Transparency = ePart.Transparency + Thing[3]
				elseif Mode == "Shatter" then
					ePart.Transparency = ePart.Transparency + Thing[3]
					Thing[4] = Thing[4] * cn(0, Thing[7], 0)
					ePart.CFrame = Thing[4] * CFrame.fromEulerAnglesXYZ(Thing[6], 0, 0)
					Thing[6] = Thing[6] + Thing[5]
				end
			else
				if ePart and ePart.Parent then
					ePart:Destroy()
				end
				table.remove(Effects, e)
			end
		end
	end

	datnumb = 0
	BaseNumb = 6.28
	if attack == false then
		Blocker.CanCollide = false
	end
end
