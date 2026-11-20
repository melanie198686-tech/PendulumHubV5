local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer

local function getCharacter()
	return Player.Character or Player.CharacterAdded:Wait()
end

local Character = getCharacter()
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.WalkSpeed = 25

local mouse = Player:GetMouse()
local m = Instance.new("Model")
m.Name = "WeaponModel"
m.Parent = Character

local LeftArm = Character:WaitForChild("Left Arm")
local RightArm = Character:WaitForChild("Right Arm")
local LeftLeg = Character:WaitForChild("Left Leg")
local RightLeg = Character:WaitForChild("Right Leg")
local Head = Character:WaitForChild("Head")
local Torso = Character:WaitForChild("Torso")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local RootJoint = RootPart:WaitForChild("RootJoint")

local Effects = {}
local equipped = false
local attack = false
local Anim = "Idle"
local attacktype = 1
local Torsovelocity = (RootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
local velocity = RootPart.AssemblyLinearVelocity.Y
local sine = 0
local change = 1

local cn = CFrame.new
local mr = math.rad
local angles = CFrame.Angles

local NeckCF = cn(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)

local function clerp(a, b, t)
	return a:Lerp(b, t)
end

local function createInstance(className, props)
	local obj = Instance.new(className)
	local parent = props and props.Parent
	if props then
		for k, v in pairs(props) do
			if k ~= "Parent" then
				obj[k] = v
			end
		end
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local ArtificialHB = createInstance("BindableEvent", {
	Name = "Heartbeat",
	Parent = script,
})

local frame = 1 / 30
local tf = 0
local allowframeloss = false
local tossremainder = false
ArtificialHB:Fire()

RunService.Heartbeat:Connect(function(s)
	tf += s
	if tf >= frame then
		if allowframeloss then
			ArtificialHB:Fire()
		else
			for _ = 1, math.floor(tf / frame) do
				ArtificialHB:Fire()
			end
		end
		if tossremainder then
			tf = 0
		else
			tf -= frame * math.floor(tf / frame)
		end
	end
end)

local function swait(num)
	if num == 0 or num == nil then
		ArtificialHB.Event:Wait()
	else
		for _ = 0, num do
			ArtificialHB.Event:Wait()
		end
	end
end

local function toColor3(col)
	if typeof(col) == "Color3" then
		return col
	elseif typeof(col) == "BrickColor" then
		return col.Color
	elseif type(col) == "string" then
		return BrickColor.new(col).Color
	end
	return Color3.new(1, 1, 1)
end

local function toBrickColor(col)
	if typeof(col) == "BrickColor" then
		return col
	elseif type(col) == "string" then
		return BrickColor.new(col)
	elseif typeof(col) == "Color3" then
		return BrickColor.new(col)
	end
	return BrickColor.new("Medium stone grey")
end

local function RemoveOutlines(part)
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.LeftSurface = Enum.SurfaceType.Smooth
	part.RightSurface = Enum.SurfaceType.Smooth
	part.FrontSurface = Enum.SurfaceType.Smooth
	part.BackSurface = Enum.SurfaceType.Smooth
end

local function CreatePart(Parent, Material, Reflectance, Transparency, BColor, Name, Size)
	local mat = typeof(Material) == "EnumItem" and Material or Enum.Material[tostring(Material)]
	local Part = createInstance("Part", {
		Parent = Parent,
		Reflectance = Reflectance,
		Transparency = Transparency,
		CanCollide = false,
		Locked = true,
		Color = toColor3(BColor),
		Name = Name,
		Size = Size,
		Material = mat,
	})
	RemoveOutlines(Part)
	return Part
end

local function CreateMesh(Mesh, Part, MeshType, MeshId, OffSet, Scale)
	local props = {
		Parent = Part,
		Offset = OffSet,
		Scale = Scale,
	}
	if Mesh == "SpecialMesh" then
		props.MeshType = MeshType
		props.MeshId = MeshId
	end
	return createInstance(Mesh, props)
end

local function CreateWeld(Parent, Part0, Part1, C0, C1)
	return createInstance("Weld", {
		Parent = Parent,
		Part0 = Part0,
		Part1 = Part1,
		C0 = C0,
		C1 = C1,
	})
end

local function rayCast(Position, Direction, Range, Ignore)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignoreList = {}
	if typeof(Ignore) == "table" then
		for _, v in ipairs(Ignore) do
			table.insert(ignoreList, v)
		end
	elseif Ignore ~= nil then
		table.insert(ignoreList, Ignore)
	end
	params.FilterDescendantsInstances = ignoreList

	local result = workspace:Raycast(Position, Direction.Unit * (Range or 999.999), params)
	if result then
		return result.Instance, result.Position
	end
	return nil, Position + Direction.Unit * (Range or 999.999)
end

local function CreateSound(id, par, vol, pit)
	task.spawn(function()
		local S = createInstance("Sound", {
			Volume = vol,
			PlaybackSpeed = pit or 1,
			SoundId = tostring(id),
			Parent = par or workspace,
		})
		swait()
		S:Play()
		Debris:AddItem(S, 6)
	end)
end

local function Damage(hit, damage, cooldown, Color1, Color2, HSound, HPitch)
	if not hit then
		return
	end
	for _, v in ipairs(hit:GetChildren()) do
		if v:IsA("Humanoid") and hit.Name ~= Character.Name then
			if not v:FindFirstChild("DebounceHit") then
				local targetHead = v.Parent and v.Parent:FindFirstChild("Head")
				if targetHead then
					local BillG = createInstance("BillboardGui", {
						Parent = targetHead,
						Size = UDim2.new(1, 0, 1, 0),
						Adornee = targetHead,
						StudsOffset = Vector3.new(math.random(-3, 3), math.random(3, 5), math.random(-3, 3)),
					})
					createInstance("TextLabel", {
						Parent = BillG,
						Size = UDim2.new(3, 3, 3, 3),
						BackgroundTransparency = 1,
						Text = tostring(damage) .. "-",
						TextColor3 = toColor3(Color1),
						TextStrokeColor3 = toColor3(Color2),
						TextStrokeTransparency = 0,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextScaled = false,
						TextSize = 18,
						Font = Enum.Font.ArialBold,
					})
					task.spawn(function()
						swait(1)
						for _ = 0, 1, 0.1 do
							swait(0.1)
							if BillG.Parent then
								BillG.StudsOffset += Vector3.new(0, 0.1, 0)
							end
						end
						BillG:Destroy()
					end)
				end
				v.Health -= damage
				local bool = createInstance("BoolValue", {
					Parent = v,
					Name = "DebounceHit",
				})
				if HSound ~= nil and HPitch ~= nil then
					CreateSound(HSound, hit, 1, HPitch)
				end
				Debris:AddItem(bool, cooldown)
			end
		end
	end
end

local function MagnitudeDamage(Part, magni, mindam, maxdam, Color1, Color2, HSound, HPitch)
	for _, c in ipairs(workspace:GetChildren()) do
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum then
			local targetTorso = c:FindFirstChild("Torso")
			if targetTorso then
				local mag = (targetTorso.Position - Part.Position).Magnitude
				if mag <= magni and c.Name ~= Player.Name then
					Damage(targetTorso.Parent, math.random(mindam, maxdam), 0, Color1, Color2, HSound, HPitch)
				end
			end
		end
	end
end

local Handle = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "Handle", Vector3.new(3.20000005, 0.320000023, 0.200000003))
local HandleWeld = CreateWeld(m, Torso, Handle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-3.57640076, -0.105987549, -0.672006607, 0.866025388, 0.500000119, -8.94076351e-008, -0.500000119, 0.866025388, 1.49014454e-007, 1.51936518e-007, -8.43464605e-008, 1))
CreateMesh("BlockMesh", Handle, "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 0.800000072))

local FakeHandle = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "FakeHandle", Vector3.new(1.92000008, 0.320000023, 0.200000003))
local FakeHandleWeld = CreateWeld(m, Handle, FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0, 0, 0, 1.00000012, 0, 0, 0, 1.00000012, 0, 0, 0, 1))

local BladeHitbox = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "BladeHitbox", Vector3.new(6.87999964, 1.28000009, 0.320000023))
CreateWeld(m, FakeHandle, BladeHitbox, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(5.83992767, 7.62939453e-006, 0.00178432465, 1.00000012, 0, 1.78815313e-007, 0, -1.00000012, 2.0861782e-007, 1.78815299e-007, -2.0861782e-007, -1))

local BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "BladePrt", Vector3.new(6.71999979, 0.640000045, 0.200000003))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.75999451, 0.320018768, -9.53674316e-007, -1.00000012, 0, -6.70215812e-008, 0, -1.00000012, 3.87433118e-007, -6.70215812e-008, 3.87433118e-007, 1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.0104, 0.0104, 0.00800000038))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "BladePrt", Vector3.new(4.96000051, 0.320000023, 0.480000019))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.35999298, 0.176017761, -9.53674316e-007, -1.00000012, 0, -8.74827464e-008, 0, -1.00000012, 4.61938924e-007, -8.74827464e-008, 4.61938953e-007, 1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.00879999995, 0.00560000027, 0.0160000008))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "BladePrt", Vector3.new(6.71999979, 0.320000023, 0.200000003))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.75999451, 0.159992218, 9.53674316e-007, -1, 1.49011612e-007, -9.26303798e-008, 1.49011612e-007, 1, -4.17235356e-007, 9.26303159e-008, -4.17235412e-007, -1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.00960000046, 0.00520000001, 0.00960000046))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "BladePrt", Vector3.new(6.71999979, 0.320000023, 0.200000003))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.75999451, 0.160015106, 0, -1.00000012, 0, -8.7701622e-008, 0, -1.00000012, 3.87433118e-007, -8.7701622e-008, 3.87433118e-007, 1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.00960000046, 0.00520000001, 0.00960000046))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "BladePrt", Vector3.new(4.32000065, 0.200000003, 0.480000019))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.5599823, 0.0879821777, 0, -1.00000012, 0, -8.89660754e-008, 0, 1.00000012, -5.36444873e-007, 8.89660896e-008, -5.36444816e-007, -1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.0064000003, 0.00320000015, 0.0200000014))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "BladePrt", Vector3.new(4.96000004, 0.320000023, 0.480000019))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.36000061, 0.167987823, 9.53674316e-007, -1, 1.49011612e-007, -9.26303798e-008, 1.49011612e-007, 1, -4.17235356e-007, 9.26303159e-008, -4.17235412e-007, -1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.00879999995, 0.00560000027, 0.0160000008))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "BladePrt", Vector3.new(6.71999979, 0.640000045, 0.200000003))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-5.76000214, 0.319988251, -9.53674316e-007, -1.00000012, 2.68220901e-007, -1.42108547e-014, 2.68220901e-007, 1.00000012, -2.9802888e-007, -6.59472477e-014, -2.9802888e-007, -1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.0104, 0.0104, 0.00800000038))

BladePrt = CreatePart(m, Enum.Material.SmoothPlastic, 0, 1, "Really black", "BladePrt", Vector3.new(4.32000065, 0.200000003, 0.480000019))
CreateWeld(m, FakeHandle, BladePrt, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-4.5599823, 0.112014771, -9.53674316e-007, -1.00000012, 0, -8.74827464e-008, 0, -1.00000012, 4.61938924e-007, -8.74827464e-008, 4.61938953e-007, 1))
CreateMesh("SpecialMesh", BladePrt, Enum.MeshType.FileMesh, "rbxassetid://433431848", Vector3.new(0, 0, 0), Vector3.new(0.0064000003, 0.00320000015, 0.0200000014))

local function buildSubPart(parent, mat, ref, trans, col, name, size, weldPart0, c0, c1, meshClass, meshType, meshId, meshOffset, meshScale)
	local p = CreatePart(parent, mat, ref, trans, col, name, size)
	local w = CreateWeld(m, weldPart0, p, c0, c1)
	if meshClass then
		CreateMesh(meshClass, p, meshType, meshId, meshOffset, meshScale)
	end
	return p, w
end

buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.2, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-1.59932709, 0.159358978, 1.23977661e-005, 1.00000012, 0, 0, 0, -1.00000012, 0, 0, 0, -1), "SpecialMesh", Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(0.8, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.59998322, 0.0799942017, -9.53674316e-007, -1, 1.49011612e-007, -9.10118445e-007, 1.49011612e-007, 1, -5.66248389e-007, 9.10118445e-007, -5.66248559e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-1.59931946, -0.160633087, 1.23977661e-005, 1.00000012, 0, 0, 0, -1.00000012, 0, 0, 0, -1), "SpecialMesh", Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(0.8, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(3.2, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-7.62939453e-006, 0.079990387, 0, 1.00000012, 0, 0, 0, 1.00000012, 0, 0, 0, 1), "BlockMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.96, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.83992767, 1.14440918e-005, 0.00178432465, 1.00000012, 0, 1.78815313e-007, 0, -1.00000012, 2.0861782e-007, 1.78815299e-007, -2.0861782e-007, -1), "BlockMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(0.8, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.32, 3.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.160007477, 7.62939453e-006, 0, 0, -1.00000012, 0, -1.00000012, 0, 1.42108547e-014, -1.42108547e-014, 7.10542736e-015, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(3.2, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0, -0.0800018311, 0, 1.00000012, 0, 0, 0, 1.00000012, 0, 0, 0, 1), "BlockMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.320007324, 1.6799469, -1.90734863e-006, -5.66244125e-007, -1, 5.23353265e-007, 1, -5.66244125e-007, 7.59964848e-007, -7.59964678e-007, 5.23353719e-007, 1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.32, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.59998322, -0.0799980164, -9.53674316e-007, -1, 1.49011612e-007, -9.10118445e-007, 1.49011612e-007, 1, -5.66248389e-007, 9.10118445e-007, -5.66248559e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.319988251, 1.67993927, -1.90734863e-006, -5.66244125e-007, -1, 5.23353265e-007, 1, -5.66244125e-007, 7.59964848e-007, -7.59964678e-007, 5.23353719e-007, 1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 3.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.159992218, 1.52587891e-005, 0, 0, -1.00000012, 0, -1.00000012, 0, 1.42108547e-014, -1.42108547e-014, 7.10542736e-015, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.32, 0.32, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.480003357, -2.07992554, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.480003357, -1.8399353, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.32, 0.32, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.479980469, -2.07992554, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Part", Vector3.new(0.32, 0.96, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(2.07992554, 1.52587891e-005, 0.00178432465, 1.00000012, 0, 1.78815313e-007, 0, -1.00000012, 2.0861782e-007, 1.78815299e-007, -2.0861782e-007, -1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.480003357, -2.3199234, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.96, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(2.31991577, 1.14440918e-005, 0.00178432465, 1.00000012, 0, 1.78815313e-007, 0, -1.00000012, 2.0861782e-007, 1.78815299e-007, -2.0861782e-007, -1), "BlockMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(0.8, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.479984283, -1.8399353, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.32, 0.2, 0.32), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.479980469, -2.3199234, 0.00178527832, 3.87430191e-007, -1, 8.24703648e-007, -1, -3.87430191e-007, -7.15261194e-007, 7.15261535e-007, -8.2470342e-007, -1), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.64, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.67993164, 7.62939453e-006, 0, 1.00000012, 0, 1.78815313e-007, 0, -1.00000012, 2.0861782e-007, 1.78815299e-007, -2.0861782e-007, -1), "BlockMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(0.8, 1, 0.8))

buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.352, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, 1.41417694, 1.52728844, -8.94076351e-008, 1.49014454e-007, 1, 0.707107067, -0.70710665, 1.68589878e-007, 0.70710665, 0.707107067, -4.21484252e-008), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.352, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, -1.52731323, -1.41415596, -8.94076351e-008, 1.49014454e-007, 1, -0.707106829, 0.707106829, -1.68589878e-007, -0.707106829, -0.707106829, 4.2148379e-008), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(0.336, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, -2.15991974, 0.0800132751, -8.94076351e-008, 1.49014454e-007, 1, -1.00000012, 0, -8.94076351e-008, 0, -1.00000012, 1.49014454e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(0.336, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, -0.0800132751, -1.99993896, -8.94076351e-008, 1.49014454e-007, 1, 0, 1.00000012, -1.49014454e-007, -1.00000012, 0, -8.94076351e-008), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(0.336, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, -0.079990387, 2.15991974, -8.94076351e-008, 1.49014454e-007, 1, -1.49011612e-007, -1, 1.49014426e-007, 1, -1.49011612e-007, 8.94076493e-008), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(0.336, 0.2, 0.2), FakeHandle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00178337097, 1.99992371, 0.0799865723, -8.94076351e-008, 1.49014454e-007, 1, 1, -1.49011612e-007, 8.94076493e-008, 1.49011612e-007, 1, -1.49014426e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 0.8, 0.8))
CreateMesh("BlockMesh", FakeHandle, "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 0.800000072))

local HandleL = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "HandleL", Vector3.new(1, 2, 1.01999998))
CreateWeld(m, LeftArm, HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00849914551, 0.00999999046, 6.77108765e-005, 1, 0, 0, 0, 1, 0, 0, 0, 1))

buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0.3, "Really black", "EffectPrt1", Vector3.new(0.6, 0.6, 0.4), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.00999355316, -0.499996185, -0.509780884, 0, 0, 1, 0, 1, 0, -1, 0, 0), "SpecialMesh", Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.3, 0, "Mid gray", "EffectPrt2", Vector3.new(0.6, 0.6, 0.4), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0100440979, 0.499996185, 0.509773254, 4.06801701e-005, 8.90720813e-008, 1, 2.13165718e-014, -1, 8.90720813e-008, 1, -3.60215091e-012, -4.06801701e-005), "SpecialMesh", Enum.MeshType.FileMesh, "http://www.roblox.com/asset/?id=18430887", Vector3.new(0, 0, 0), Vector3.new(0.379999906, 0.399999678, 2.21999955))

local HitboxL = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "HitboxL", Vector3.new(1.2, 1.4, 1.01999998))
CreateWeld(m, HandleL, HitboxL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0999908447, 0.699999809, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1))

buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.75, 0.2, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.12071991, 0.312129974, -0.409996033, 0.965925872, 0.258819103, 0, -0.258819103, 0.965925872, 0, 0, 0, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.2, 1.01999998), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.354278564, 0.31212616, 0, 0.965925872, 0.258819103, 0, -0.258819103, 0.965925872, 0, 0, 0, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.6, 0.2, 1.01999998), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.200004578, 0.899998903, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.75, 0.2, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.12071991, 0.312129974, 0.410003662, 0.965925872, 0.258819103, 0, -0.258819103, 0.965925872, 0, 0, 0, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 1.2, 1.01), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.409751892, -0.412899256, 0.00154209137, -1, -5.71118512e-008, 0, -5.71118512e-008, 1, 1.6609139e-008, -9.48578645e-016, 1.6609139e-008, -1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0.2, "Really black", "Part", Vector3.new(0.4, 0.4, 0.4), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.0105276108, -0.491856098, -0.509765625, 0, 0, 1, 0, 1, 0, -1, 0, 0), "SpecialMesh", Enum.MeshType.Sphere, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "ThunderHoleL", Vector3.new(0.2, 1.05, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.699999809, -0.000227928162, 0.228645325, 0, -1, 0, 0, 0, -1, 1, 0, 0), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.8, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.21999836, 0.600001812, 0.62865448, 0, 0, -1, 0, 1, 0, 1, 0, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.6, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.232361794, 0.0286483765, 1.10000181, -5.96046448e-008, 1.07931243e-007, 1, 1, 5.49689858e-008, 5.96046412e-008, -5.49689787e-008, 1, -1.07931243e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.4, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.21999836, -0.528648376, 1.10000181, 0, 0, -1, -1, -5.96046377e-008, 0, -5.96046377e-008, 1, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.6, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.21999836, 0.0286483765, 1.10000181, -5.96046448e-008, 1.07931243e-007, 1, 1, 5.49689858e-008, 5.96046412e-008, -5.49689787e-008, 1, -1.07931243e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.01999998, 1.80999994, 0.619999945), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0, -0.104995966, -0.199783325, 0, 0, 1, 0, 1, 0, -1, 0, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.03999996, 1.00999999, 1.01999998), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0, 0.494999886, -0.018661499, 0, 0, 1, 0, 1, 0, -1, 0, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.8, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.232361794, 0.600001812, 0.62865448, 0, 0, -1, 0, 1, 0, 1, 0, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.4, 0.2), HandleL, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.232361794, -0.528648376, 1.10000181, 0, 0, -1, -1, -5.96046377e-008, 0, -5.96046377e-008, 1, 0), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))

local HandleR = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "HandleR", Vector3.new(1, 2, 1.01999998))
CreateWeld(m, RightArm, HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00468444824, 0.0100209713, -0.00353145599, -1, -5.71118512e-008, 0, -5.71118512e-008, 1, 1.6609139e-008, -9.48578645e-016, 1.6609139e-008, -1))

local Barrel1 = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "Barrel1", Vector3.new(0.6, 1.2, 0.4))
CreateWeld(m, HandleR, Barrel1, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.299865723, 0.599565029, 0.718658447, -1.49011612e-007, -6.73397207e-015, -1, 0, 1, -7.10542736e-015, 1, 0, -1.49011612e-007))
CreateMesh("SpecialMesh", Barrel1, Enum.MeshType.FileMesh, "rbxassetid://433397018", Vector3.new(0, 0, 0), Vector3.new(0.01, 0.01, 0.01))

local Barrel2 = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "Barrel2", Vector3.new(0.6, 1.2, 0.4))
CreateWeld(m, HandleR, Barrel2, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.300126076, 0.599565029, 0.718658447, -1.49011612e-007, -6.73397207e-015, -1, 0, 1, -7.10542736e-015, 1, 0, -1.49011612e-007))
CreateMesh("SpecialMesh", Barrel2, Enum.MeshType.FileMesh, "rbxassetid://433397018", Vector3.new(0, 0, 0), Vector3.new(0.01, 0.01, 0.01))

local Choke1 = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "Choke1", Vector3.new(0.6, 0.4, 0.4))
CreateWeld(m, HandleR, Choke1, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.297118187, 1.39956522, 0.718673706, -1.49011612e-007, -6.73397207e-015, -1, 0, 1, -7.10542736e-015, 1, 0, -1.49011612e-007))
CreateMesh("SpecialMesh", Choke1, Enum.MeshType.FileMesh, "rbxassetid://433397231", Vector3.new(0, 0, 0), Vector3.new(0.01, 0.01, 0.01))

local Choke2 = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "Choke2", Vector3.new(0.6, 0.4, 0.4))
CreateWeld(m, HandleR, Choke2, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.303283691, 1.3995651, 0.718673706, -1.49011612e-007, -6.73397207e-015, -1, 0, 1, -7.10542736e-015, 1, 0, -1.49011612e-007))
CreateMesh("SpecialMesh", Choke2, Enum.MeshType.FileMesh, "rbxassetid://433397231", Vector3.new(0, 0, 0), Vector3.new(0.01, 0.01, 0.01))

local HitboxR = CreatePart(m, Enum.Material.SmoothPlastic, 0.2, 1, "Mid gray", "HitboxR", Vector3.new(1.2, 1, 1.01999998))
CreateWeld(m, HandleR, HitboxR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.100006104, 0.700003862, 0, 1, 0, 0, 0, 1, 5.41750795e-023, 0, 5.41750795e-023, 1))

buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.75, 0.2, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.120735168, 0.312120438, 0.40998745, 0.965925872, 0.258819222, -5.53058896e-008, -0.258819222, 0.965925872, 3.094436e-008, 6.14303701e-008, -1.55757274e-008, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.4, 0.82, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.718658447, -0.4104321, -1.43051147e-005, 1, 0, 0, 0, 1, 5.41750795e-023, 0, 5.41750795e-023, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.6, 0.2, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.199996948, 0.900001049, 0, 1, 0, 0, 0, 1, 5.41750795e-023, 0, 5.41750795e-023, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.41, 2.02, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.313659668, -0.00999617577, 0, 1, 0, 0, 0, 1, 5.41750795e-023, 0, 5.41750795e-023, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.75, 0.2, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.120735168, 0.312120438, -0.410010338, 0.965925872, 0.258819222, -5.53058896e-008, -0.258819222, 0.965925872, 3.094436e-008, 6.14303701e-008, -1.55757274e-008, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.41, 0.2, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.0863342285, -0.919991493, -3.05175781e-005, 1, 0, 0, 0, 1, 5.41750795e-023, 0, 5.41750795e-023, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Part", Vector3.new(0.2, 0.2, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.354248047, 0.312124252, -1.43051147e-005, 0.965925872, 0.258819222, -5.53058896e-008, -0.258819222, 0.965925872, 3.094436e-008, 6.14303701e-008, -1.55757274e-008, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "ThunderHoleR", Vector3.new(0.2, 1.05, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.700005054, -0.000213623047, 0.228675842, -1.0658141e-014, -1, -1.0658141e-014, 9.48578222e-016, 1.0658141e-014, -1, 1, -1.0658141e-014, 9.48578116e-016), "CylinderMesh", "", "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.8, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.232376099, 0.600004911, 0.628646851, 9.48580657e-016, -3.19744231e-014, -1, 0, 1, -3.19744231e-014, 1, 0, 9.48580551e-016), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.6, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.219985962, 0.0286712646, 1.10000277, -3.12924385e-007, 1.07931264e-007, 1, 1, 5.49689787e-008, 3.12924385e-007, -5.49689467e-008, 1, -1.07931285e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.4, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0.232376099, -0.528656006, 1.100003, 9.48580657e-016, -3.19744231e-014, -1, -1, -5.9604659e-008, -9.48578539e-016, -5.9604659e-008, 1, -3.19744231e-014), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.01999998, 0.2, 0.4), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(1.43051147e-005, -0.920844555, 0.718658447, 9.48580657e-016, -3.19744231e-014, -1, 0, 1, -3.19744231e-014, 1, 0, 9.48580551e-016), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.03999996, 1.00999999, 1.01999998), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(0, 0.495002031, -0.0186691284, -9.48580657e-016, 3.19744231e-014, 1, 0, 1, -3.19744231e-014, -1, 0, -9.48580551e-016), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.6, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.232390404, 0.0286712646, 1.100003, -3.12924385e-007, 1.07931264e-007, 1, 1, 5.49689787e-008, 3.12924385e-007, -5.49689467e-008, 1, -1.07931285e-007), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.4, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.219985962, -0.528671265, 1.100003, 9.48580657e-016, -3.19744231e-014, -1, -1, -5.9604659e-008, -9.48578539e-016, -5.9604659e-008, 1, -3.19744231e-014), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.01999998, 0.2, 0.4), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-1.43051147e-005, -0.100847006, 0.718658447, 2.45555211e-015, -5.96046306e-008, 1, -1.42108547e-014, -1, -5.96046306e-008, 1, -1.42108547e-014, -2.45555296e-015), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0, 0, "Really black", "Wedge", Vector3.new(0.2, 0.8, 0.2), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.220002174, 0.600004911, 0.628662109, 9.48580657e-016, -3.19744231e-014, -1, 0, 1, -3.19744231e-014, 1, 0, 9.48580551e-016), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
buildSubPart(m, Enum.Material.SmoothPlastic, 0.2, 0, "Mid gray", "Wedge", Vector3.new(1.00999999, 0.41, 0.41), HandleR, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.00409030914, 0.623651981, 0.0869140625, 7.5121838e-016, 3.45568019e-009, -1, -5.9604659e-008, -1, -3.45568019e-009, -1, 5.9604659e-008, -5.45243684e-016), "SpecialMesh", Enum.MeshType.Wedge, "", Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))

local function BlockEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayStep, Type)
	local prt = CreatePart(workspace, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.zero)
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("BlockMesh", prt, "", "", Vector3.zero, Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, {
		prt,
		(Type == 2) and "Block2" or "Block1",
		delayStep,
		x3,
		y3,
		z3,
		msh,
	})
end

local function SphereEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayStep)
	local prt = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", Vector3.zero)
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.Sphere, "", Vector3.zero, Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, { prt, "Cylinder", delayStep, x3, y3, z3, msh })
end

local function RingEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayStep)
	local prt = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
	prt.Anchored = true
	prt.CFrame = cframe * CFrame.new(x1, y1, z1)
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.FileMesh, "rbxassetid://3270017", Vector3.zero, Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, { prt, "Cylinder", delayStep, x3, y3, z3, msh })
end

local function CylinderEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayStep)
	local prt = CreatePart(workspace, Enum.Material.Neon, 0, 0, brickcolor, "Effect", Vector3.zero)
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("CylinderMesh", prt, "", "", Vector3.zero, Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, { prt, "Cylinder", delayStep, x3, y3, z3, msh })
end

local function WaveEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delayStep)
	local prt = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 0, brickcolor, "Effect", Vector3.zero)
	prt.Anchored = true
	prt.CFrame = cframe
	local msh = CreateMesh("SpecialMesh", prt, Enum.MeshType.FileMesh, "rbxassetid://20329976", Vector3.zero, Vector3.new(x1, y1, z1))
	Debris:AddItem(prt, 10)
	table.insert(Effects, { prt, "Cylinder", delayStep, x3, y3, z3, msh })
end

local Mode = "Normal"
local RSH = Torso:WaitForChild("Right Shoulder")
local LSH = Torso:WaitForChild("Left Shoulder")
local RH = Torso:WaitForChild("Right Hip")
local LH = Torso:WaitForChild("Left Hip")
local Animate = Character:FindFirstChild("Animate")
local Animator = Humanoid:FindFirstChildOfClass("Animator")
local RW, LW

local function setAnimateEnabled(enabled)
	if Animate and Animate:IsA("ScriptBase") then
		Animate.Disabled = not enabled
	end
	if Animator then
		Animator.Parent = enabled and Humanoid or nil
	end
end

local function Equip()
	attack = true
	equipped = true
	RSH.Parent = nil
	LSH.Parent = nil
	setAnimateEnabled(false)
	change = 3
	RW = CreateWeld(Torso, Torso, RightArm, CFrame.new(1.5, 0.5, 0), CFrame.new(0, 0.5, 0))
	RW.Name = "Right Shoulder"
	LW = CreateWeld(Torso, Torso, LeftArm, CFrame.new(-1.5, 0.5, 0), CFrame.new(0, 0.5, 0))
	LW.Name = "Left Shoulder"

	CreateSound("http://roblox.com/asset/?id=346134880", Torso, 1, 1)
	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(5), 0, 0), 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), 0.2)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.3, -0.5) * angles(0, mr(170), mr(90)), 0.25)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.3, -0.7) * angles(0, mr(-170), mr(-110)), 0.25)
	end

	CreateSound("http://roblox.com/asset/?id=346134880", Torso, 1, 0.9)
	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(5), 0, 0), 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), 0.2)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.3, -0.5) * angles(0, mr(170), mr(95)), 0.34)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, -0.7) * angles(0, mr(-170), mr(-120)), 0.34)
	end

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(5), 0, 0), 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), 0.2)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.3, -0.7) * angles(0, mr(170), mr(110)), 0.25)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.3, -0.5) * angles(0, mr(-170), mr(-90)), 0.25)
	end

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(mr(5), 0, 0), 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, 0), 0.2)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, -0.7) * angles(0, mr(170), mr(120)), 0.34)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.2, 0.3, -0.7) * angles(0, mr(-180), mr(-95)), 0.34)
	end
	attack = false
end

local function Unequip()
	attack = true
	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.2)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF, 0.2)
		if RW and LW then
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0), 0.2)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0), 0.2)
		end
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF, 0.2)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF, 0.2)
	end
	equipped = false
	if RW then
		RW:Destroy()
		RW = nil
	end
	if LW then
		LW:Destroy()
		LW = nil
	end
	RSH.Parent = Torso
	LSH.Parent = Torso
	Torso.Neck.C0 = NeckCF
	RootJoint.C0 = RootCF
	setAnimateEnabled(true)
	attack = false
end

local function attackone()
	attack = true
	local Con1 = HitboxL.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.3) * angles(0, 0, mr(70)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-70)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0, -0.3) * angles(mr(180), mr(-20), mr(10)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.4, -0.7) * angles(0, mr(-150), mr(-90)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -0.8, 0) * RHCF * angles(mr(-4), mr(-40), 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-4), mr(-40), mr(30)), 0.3)
	end
	CreateSound("http://www.roblox.com/asset/?id=200632136", HitboxL, 1, 1)
	for _ = 0, 1, 0.12 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.3) * angles(mr(20), 0, mr(-80)), 0.54)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-10), mr(-10), mr(80)), 0.54)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0.3) * angles(mr(50), mr(20), 0), 0.54)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.7, -0.3) * angles(0, mr(-20), mr(-110)), 0.54)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-4), mr(40), mr(-10)), 0.54)
		LH.C0 = clerp(LH.C0, cn(-1, -0.7, 0) * LHCF * angles(mr(-4), mr(40), mr(-20)), 0.54)
	end
	Con1:Disconnect()
	attack = false
end

local function attacktwo()
	attack = true
	local Con1 = HitboxR.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.4) * angles(0, 0, mr(-80)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(80)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(mr(20), mr(-90), 0), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.5, -0.4) * angles(mr(120), 0, mr(10)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, mr(-40)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -0.7, 0) * LHCF * angles(mr(-5), 0, 0), 0.3)
	end
	CreateSound("http://www.roblox.com/asset/?id=200632136", HitboxR, 1, 1.1)
	for _ = 0, 1, 0.12 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(80)), 0.55)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-80)), 0.55)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.6, -0.3) * angles(mr(180), mr(-20), mr(10)), 0.55)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(20), 0, mr(10)), 0.55)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, 0), 0.55)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, 0), 0.55)
	end
	Con1:Disconnect()
	attack = false
end

local function attackthree()
	attack = true
	local Con1 = HitboxL.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	local Con2 = HitboxR.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(mr(-20), 0, 0), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(20), 0, 0), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0.5) * angles(mr(90), mr(50), 0), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0.5) * angles(mr(90), mr(-50), 0), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, mr(-20)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, mr(20)), 0.3)
	end
	CreateSound("http://www.roblox.com/asset/?id=200632136", Torso, 1, 0.8)
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(mr(20), 0, 0), 0.55)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-10), 0, 0), 0.55)
		RW.C0 = clerp(RW.C0, CFrame.new(0.8, 0.5, -0.8) * angles(mr(120), mr(60), 0), 0.55)
		LW.C0 = clerp(LW.C0, CFrame.new(-0.8, 0.5, -0.8) * angles(mr(120), mr(-60), 0), 0.55)
		RH.C0 = clerp(RH.C0, cn(1, -0.6, -0.2) * RHCF * angles(mr(-5), 0, mr(-20)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -0.8, -0.3) * LHCF * angles(mr(-5), 0, mr(10)), 0.3)
	end
	Con1:Disconnect()
	Con2:Disconnect()
	attack = false
end

local function attackfour()
	attack = true
	CreateSound("http://roblox.com/asset/?id=199145327", Torso, 1, 0.8)
	for i = 0, 1, 0.12 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(6 * i, 0, 0), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF, 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -0.5) * angles(mr(90), 0, mr(-40)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.5, -0.5) * angles(mr(90), 0, mr(40)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -0.2, -0.5) * RHCF * angles(0, 0, mr(-20)), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -0.1, -0.5) * LHCF * angles(0, 0, mr(20)), 0.3)
	end
	for i = 0, 1, 0.12 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(mr(10 * i), 0, 0), 0.5)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(20), 0, 0), 0.5)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(mr(-20), 0, mr(60)), 0.5)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(-20), 0, mr(-60)), 0.5)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(0, 0, mr(40)), 0.5)
		LH.C0 = clerp(LH.C0, cn(-1, 0, -0.5) * LHCF * angles(0, 0, mr(20)), 0.5)
	end

	local hit, pos = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 6, Character)
	if hit ~= nil then
		local refpart = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 1, "Really black", "Effect", Vector3.zero)
		refpart.Anchored = true
		refpart.CFrame = CFrame.new(pos)
		Debris:AddItem(refpart, 1)
		CreateSound("http://www.roblox.com/asset/?id=199145477", refpart, 0.8, 1)
		for _ = 1, 5 do
			local groundpart = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 0, hit.Color, "Ground", Vector3.new(math.random(50, 100) / 100, math.random(50, 100) / 100, math.random(50, 100) / 100))
			groundpart.Anchored = false
			groundpart.Material = hit.Material
			groundpart.CanCollide = true
			groundpart.AssemblyLinearVelocity = Vector3.new(math.random(-50, 50), math.random(25, 50), math.random(-50, 50))
			groundpart.CFrame = CFrame.new(pos) * CFrame.new(math.random(-250, 250) / 100, 0.5, math.random(-250, 250) / 100) * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
			Debris:AddItem(groundpart, 10)
		end
		for _ = 1, 6 do
			local actualgroundpart = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 0, hit.Color, "Ground", Vector3.new(math.random(100, 200) / 100, math.random(100, 200) / 100, math.random(100, 200) / 100))
			actualgroundpart.Anchored = true
			actualgroundpart.Material = hit.Material
			actualgroundpart.CanCollide = true
			actualgroundpart.CFrame = CFrame.new(pos) * CFrame.new(math.random(-500, 500) / 100, 0, math.random(-500, 500) / 100) * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
			Debris:AddItem(actualgroundpart, 10)
		end
		WaveEffect(hit.Color, refpart.CFrame, 0.2, 0.2, 0.2, 0.5, 0.5, 0.5, 0.04)
		SphereEffect(hit.Color, refpart.CFrame, 0.2, 0.2, 0.2, 3, 3, 3, 0.04)
		RingEffect(hit.Color, refpart.CFrame * CFrame.Angles(math.random(5, 6), math.random(2, 7), math.random(3, 6)), 0.2, 0.2, 0.2, 1, 1, 1, 0.05)
	end
	attack = false
end

local function ShootCannon(asd)
	local MainPos = asd.Position
	local MainPos2 = mouse.Hit.Position
	local MouseLook = CFrame.new((MainPos + MainPos2) / 2, MainPos2)
	local num = 100
	task.spawn(function()
		repeat
			swait()
			local hit, pos = rayCast(MainPos, MouseLook.LookVector, 10, Character)
			local mag = (MainPos - pos).Magnitude
			CylinderEffect(Color3.fromRGB(255, 255, 0), CFrame.new((MainPos + pos) / 2, pos) * CFrame.Angles(1.57, 0, 0), 3, mag * 5, 100, 0.1, 0, 1.5, 0.1)
			MainPos += MouseLook.LookVector * 10
			num -= 1
			if hit ~= nil then
				num = 0
				local ref = CreatePart(workspace, Enum.Material.SmoothPlastic, 0, 1, Color3.fromRGB(255, 255, 0), "Reference", Vector3.zero)
				ref.Anchored = true
				ref.CFrame = CFrame.new(pos)
				BlockEffect(Color3.fromRGB(255, 255, 0), CFrame.new(pos), 20, 20, 20, 5, 5, 5, 0.1)
				MagnitudeDamage(ref, 0, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
				Debris:AddItem(ref, 1)
			end
		until num <= 0
	end)
end

local gun = false
local shoot = false
local gunidle = false

local function GunStance()
	attack = true
	gun = true
	change = 3
	Barrel1.Transparency = 0
	Barrel2.Transparency = 0
	Choke1.Transparency = 0
	Choke2.Transparency = 0

	for _ = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(90)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-90)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(0, 0, mr(90)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, mr(-20)), 0.3)
		HandleWeld.C0 = clerp(HandleWeld.C0, CFrame.identity, 0.3)
	end

	gunidle = true
	while gun == true do
		swait()
		local hitPos = mouse.Hit.Position
		local offset = (Torso.Position.Y - hitPos.Y) / 60
		local mag = (Torso.Position - hitPos).Magnitude / 80
		if mag > 0.001 then
			offset /= mag
		end
		RW.C1 = clerp(RW.C1, cn(0, 0.5, 0) * CFrame.fromEulerAnglesXYZ(0, 0, offset), 0.5)
	end

	if shoot == true then
		gunidle = false
		CreateSound("rbxassetid://131632972", Torso, 1, 1.2)
		CreateSound("rbxassetid://131632972", Torso, 1, 1)
		CreateSound("rbxassetid://131632972", Torso, 1, 0.7)
		ShootCannon(Choke1)
		ShootCannon(Choke2)
		for _ = 0, 1, 0.15 do
			swait()
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(90)), 0.3)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-90)), 0.3)
			RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.7, 0) * angles(0, 0, mr(150)), 0.5)
			LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, mr(-20)), 0.3)
			HandleWeld.C0 = clerp(HandleWeld.C0, CFrame.identity, 0.3)
		end
	end

	RW.C1 = clerp(RW.C1, cn(0, 0.5, 0), 1)
	Barrel1.Transparency = 1
	Barrel2.Transparency = 1
	Choke1.Transparency = 1
	Choke2.Transparency = 1
	gun = false
	gunidle = false
	shoot = false
	attack = false
end

local function Disappear()
	for _, child in ipairs(m:GetChildren()) do
		if child.Name == "BladePrt" then
			local targetPart = child
			task.spawn(function()
				for step = 0, 1, 0.1 do
					swait()
					if targetPart.Parent then
						targetPart.Transparency = step
					end
				end
				if targetPart.Parent then
					targetPart.Transparency = 1
				end
			end)
		end
	end
end

local function Reappear()
	for _, child in ipairs(m:GetChildren()) do
		if child.Name == "BladePrt" then
			local targetPart = child
			task.spawn(function()
				for step = 0, 1, 0.1 do
					swait()
					if targetPart.Parent then
						targetPart.Transparency = step
					end
				end
				if targetPart.Parent then
					targetPart.Transparency = 0
				end
			end)
		end
	end
end

local function BladeEquip()
	attack = true
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF, 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.3, 0) * angles(mr(210), 0, mr(30)), 0.5)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(-20), 0, mr(-20)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, 0), 0.3)
	end
	CreateSound("http://roblox.com/asset/?id=199145327", FakeHandle, 0.6, 1)
	HandleWeld:Destroy()
	HandleWeld = CreateWeld(m, RightArm, Handle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.032043457, 0.996201754, -0.111961365, 8.94076351e-008, 1.1920929e-007, 1, -1.49014454e-007, 1, -1.19209275e-007, -1, -1.4901444e-007, 8.94076564e-008))
	for i = 0, 1, 0.1 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF, 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.5, 0) * angles(mr(80), 0, mr(70)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(-20), 0, mr(-20)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, 0), 0.3)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(mr(90), 0, -6 * i), 0.3)
	end
	Reappear()
	Mode = "Sword"
	attack = false
end

local function UnequipBlade()
	attack = true
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF, 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1.2, 0.3, 0) * angles(mr(210), 0, mr(30)), 0.5)
		LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(-20), 0, mr(-20)), 0.3)
		RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, 0), 0.3)
		LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, 0), 0.3)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(40), mr(-60)), 0.3)
	end
	Disappear()
	HandleWeld:Destroy()
	HandleWeld = CreateWeld(m, Torso, Handle, CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-3.57640076, -0.105987549, -0.672006607, 0.866025388, 0.500000119, -8.94076351e-008, -0.500000119, 0.866025388, 1.49014454e-007, 1.51936518e-007, -8.43464605e-008, 1))
	Mode = "Normal"
	attack = false
end

local function BladeAttackOne()
	attack = true
	local Con1 = BladeHitbox.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(60)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-60)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, -0.5) * angles(0, mr(150), mr(120)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.5, -0.7) * angles(0, mr(70), mr(90)), 0.3)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(-10), mr(30)), 0.3)
	end
	CreateSound("http://roblox.com/asset/?id=356430004", BladeHitbox, 1, 0.8)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1) * angles(mr(10), 0, mr(-60)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5), mr(-5), mr(60)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, 0) * angles(0, mr(70), mr(80)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-0.4, 0.5, -1) * angles(0, mr(20), mr(70)), 0.4)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, 0, mr(80)), 0.4)
	end
	Con1:Disconnect()
	attack = false
end

local function BladeAttackTwo()
	attack = true
	local Con1 = BladeHitbox.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(-60)), 0.3)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.3)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -0.7) * angles(0, mr(-70), mr(-90)), 0.3)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, -0.5) * angles(0, mr(-150), mr(-120)), 0.3)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(-10), mr(30)), 0.3)
	end
	CreateSound("http://roblox.com/asset/?id=356430004", BladeHitbox, 1, 1)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1) * angles(mr(10), 0, mr(60)), 0.4)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5), mr(5), mr(-60)), 0.4)
		RW.C0 = clerp(RW.C0, CFrame.new(0.4, 0.5, -1) * angles(0, mr(-20), mr(-70)), 0.4)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.1, 0) * angles(0, mr(-70), mr(-80)), 0.4)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(30), mr(80)), 0.4)
	end
	Con1:Disconnect()
	attack = false
end

local function BladeAttackThree()
	attack = true
	local Con1 = BladeHitbox.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 0, 1, 0.15 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(mr(-10), 0, 0), 0.34)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(10), 0, 0), 0.34)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 1, -0.5) * angles(mr(120), 0, mr(-40)), 0.34)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 1, -0.5) * angles(mr(120), 0, mr(40)), 0.34)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(mr(40), 0, 0), 0.4)
	end
	CreateSound("http://roblox.com/asset/?id=356430004", BladeHitbox, 1, 0.7)
	for _ = 0, 1, 0.13 do
		swait()
		RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.3), 0.5)
		Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(20), 0, 0), 0.5)
		RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, -0.3) * angles(mr(10), 0, mr(-40)), 0.5)
		LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, -0.3) * angles(mr(10), 0, mr(40)), 0.5)
		FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(mr(40), 0, mr(30)), 0.5)
	end
	Con1:Disconnect()
	attack = false
end

local function BladeAttackFour()
	attack = true
	local Con1 = BladeHitbox.Touched:Connect(function(hit)
		Damage(hit.Parent, 0, 0, "Really black", "Mid gray", "rbxassetid://199149186", 1)
	end)
	for _ = 1, 2 do
		for _ = 0, 1, 0.3 do
			swait()
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(60)), 0.5)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(-60)), 0.5)
			RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, -0.5) * angles(0, mr(150), mr(120)), 0.5)
			LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.5, -0.7) * angles(0, mr(70), mr(90)), 0.5)
			FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(-10), mr(30)), 0.5)
		end
		CreateSound("http://roblox.com/asset/?id=356430004", BladeHitbox, 1, 1)
		for _ = 0, 1, 0.3 do
			swait()
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1) * angles(mr(10), 0, mr(-60)), 0.4)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5), mr(-5), mr(60)), 0.4)
			RW.C0 = clerp(RW.C0, CFrame.new(1, 0.3, 0) * angles(0, mr(70), mr(80)), 0.4)
			LW.C0 = clerp(LW.C0, CFrame.new(-0.4, 0.5, -1) * angles(0, mr(20), mr(70)), 0.4)
			FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, 0, mr(80)), 0.4)
		end
		for _ = 0, 1, 0.3 do
			swait()
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * angles(0, 0, mr(-60)), 0.5)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(0, 0, mr(60)), 0.5)
			RW.C0 = clerp(RW.C0, CFrame.new(1, 0.5, -0.7) * angles(0, mr(-70), mr(-110)), 0.5)
			LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.3, -0.5) * angles(0, mr(-150), mr(-120)), 0.5)
			FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(-10), mr(30)), 0.5)
		end
		CreateSound("http://roblox.com/asset/?id=356430004", BladeHitbox, 1, 0.8)
		for _ = 0, 1, 0.3 do
			swait()
			RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1) * angles(mr(10), 0, mr(60)), 0.4)
			Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5), mr(5), mr(-60)), 0.4)
			RW.C0 = clerp(RW.C0, CFrame.new(0.4, 0.5, -1) * angles(0, mr(-20), mr(-70)), 0.4)
			LW.C0 = clerp(LW.C0, CFrame.new(-1, 0.1, 0) * angles(0, mr(-70), mr(-80)), 0.4)
			FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, mr(30), mr(80)), 0.4)
		end
	end
	Con1:Disconnect()
	attack = false
end

mouse.Button1Down:Connect(function()
	if attack == false and equipped == true and Mode == "Normal" then
		if attacktype == 1 then
			attacktype = 2
			attackone()
		elseif attacktype == 2 then
			attacktype = 3
			attacktwo()
		elseif attacktype == 3 then
			attacktype = 4
			attackthree()
		elseif attacktype == 4 then
			attacktype = 1
			attackfour()
		end
	elseif attack == false and equipped == true and Mode == "Sword" then
		if attacktype == 1 then
			attacktype = 2
			BladeAttackOne()
		elseif attacktype == 2 then
			attacktype = 3
			BladeAttackTwo()
		elseif attacktype == 3 then
			attacktype = 4
			BladeAttackThree()
		elseif attacktype == 4 then
			attacktype = 1
			BladeAttackFour()
		end
	end
	if gun == true and shoot == false and equipped == true then
		shoot = true
		gun = false
	end
end)

mouse.KeyDown:Connect(function(k)
	k = k:lower()
	if attack == false and equipped == false and k == "f" and Mode == "Normal" then
		Equip()
	elseif attack == false and equipped == true and k == "f" and Mode == "Normal" then
		Unequip()
	elseif attack == false and equipped == true and Mode == "Normal" and k == "g" then
		BladeEquip()
	elseif attack == false and equipped == true and Mode == "Sword" and k == "g" then
		UnequipBlade()
	elseif k == "e" and gun == false and shoot == false and Mode == "Normal" and attack == false and equipped == true then
		GunStance()
	elseif k == "e" and shoot == false and equipped == true and Mode == "Normal" and gun == true then
		gun = false
	end
end)

while true do
	swait()
	for _, v in ipairs(Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
		elseif v:IsA("Accessory") then
			local accHandle = v:FindFirstChild("Handle")
			if accHandle and accHandle:IsA("BasePart") then
				accHandle.Material = Enum.Material.SmoothPlastic
			end
		end
	end

	if gun == true then
		local aimPos = mouse.Hit.Position
		local direction = CFrame.lookAt(RootPart.Position, Vector3.new(aimPos.X, RootPart.Position.Y, aimPos.Z)).LookVector
		local headingA = math.deg(math.atan2(direction.X, direction.Z))
		Humanoid.AutoRotate = false
		RootPart.CFrame = CFrame.new(RootPart.Position) * angles(0, mr(headingA - 180), 0)
	else
		Humanoid.AutoRotate = true
	end

	Torsovelocity = (RootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
	velocity = RootPart.AssemblyLinearVelocity.Y
	sine += change
	local hit = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).LookVector, 4, Character)

	if equipped == true and RW and LW then
		if velocity > 1 and hit == nil then
			Anim = "Jump"
			if attack == false then
				RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-10), 0, 0), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(mr(-20), 0, mr(30)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(mr(-20), 0, mr(-30)), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(mr(-5), 0, mr(-20)), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-5), 0, mr(20)), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.identity, 0.3)
			end
		elseif velocity < -1 and hit == nil then
			Anim = "Fall"
			if attack == false then
				RootJoint.C0 = clerp(RootJoint.C0, RootCF, 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(30), 0, 0), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(0, 0, mr(50)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(0, 0, mr(-50)), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -0.8, 0) * RHCF * angles(mr(-2), 0, mr(20)), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(mr(-2), 0, mr(-20)), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.identity, 0.3)
			end
		elseif Torsovelocity < 1 and hit ~= nil then
			Anim = "Idle"
			if attack == false and Mode == "Normal" then
				change = 1
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.1 * math.sin(sine / 27)) * angles(0, 0, mr(30)), 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(5 + 3 * math.cos(sine / 23)), mr(-2 - 3 * math.cos(sine / 23)), mr(-30)), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.4, 0.6 + 0.07 * math.cos(sine / 23), -0.2) * angles(mr(110 + 2 * math.cos(sine / 24)), mr(35 + 3 * math.cos(sine / 23)), mr(-30)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.3, 0.6 + 0.07 * math.cos(sine / 23), -0.5) * angles(mr(120 + 2 * math.cos(sine / 24)), mr(-40 + 3 * math.cos(sine / 23)), mr(40)), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -0.9 - 0.1 * math.sin(sine / 27), 0) * RHCF * angles(mr(-4 + 1 * math.cos(sine / 23)), mr(-30), 0), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -0.9 - 0.1 * math.sin(sine / 27), 0) * LHCF * angles(mr(-4 + 1 * math.cos(sine / 23)), mr(-30), 0), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.identity, 0.3)
			elseif attack == false and Mode == "Sword" then
				change = 1
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.1 * math.sin(sine / 27)) * angles(0, 0, mr(-60)), 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(5 + 3 * math.cos(sine / 23)), mr(-2 + 3 * math.cos(sine / 23)), mr(60)), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.3, 0.6, 0) * angles(mr(150 + 3 * math.cos(sine / 23)), 0, mr(10)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.4, 0.5, 0) * angles(mr(10 + 2 * math.cos(sine / 23)), 0, mr(-20 - 5 * math.cos(sine / 23))), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -0.9 - 0.1 * math.sin(sine / 27), 0) * RHCF * angles(mr(-4 + 1 * math.cos(sine / 23)), mr(20), 0), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -0.9 - 0.1 * math.sin(sine / 27), 0) * LHCF * angles(mr(-4 + 1 * math.cos(sine / 23)), mr(20), 0), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, 0, mr(-60)), 0.3)
			end
		elseif Torsovelocity > 2 and hit ~= nil then
			Anim = "Walk"
			if attack == false and Mode == "Normal" then
				change = 3
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.2) * angles(mr(30), 0, mr(5 * math.cos(sine / 10) / 2)), 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-20), 0, mr(-5 * math.cos(sine / 10) / 2)), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.6 + 0.07 * math.cos(sine / 23), -0.2) * angles(mr(110), mr(40), mr(-40)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.6 + 0.07 * math.cos(sine / 23), -0.2) * angles(mr(110), mr(-40), mr(40)), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -0.8 - 0.3 * math.cos(sine / 8) / 2, -0.05 + math.sin(sine / 8) / 2) * RHCF * angles(mr(-4), 0, mr(10) - math.sin(sine / 8)), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -0.8 + 0.3 * math.cos(sine / 8) / 2, -0.05 - math.sin(sine / 8) / 2) * LHCF * angles(mr(-4), 0, mr(-10) - math.sin(sine / 8)), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.identity, 0.3)
			elseif attack == false and Mode == "Sword" then
				change = 3
				RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.1 * math.sin(sine / 27)) * angles(mr(15), 0, mr(-60 + 10 * math.cos(sine / 13))), 0.3)
				Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(mr(-5), mr(-5), mr(60 - 10 * math.cos(sine / 13))), 0.3)
				RW.C0 = clerp(RW.C0, CFrame.new(1.3, 0.5, -0.5) * angles(mr(150 + 3 * math.cos(sine / 23)), 0, mr(-20)), 0.3)
				LW.C0 = clerp(LW.C0, CFrame.new(-0.3, 0.7, -1) * angles(mr(150 + 2 * math.cos(sine / 23)), 0, mr(40)), 0.3)
				RH.C0 = clerp(RH.C0, cn(1, -1 - 0.3 * math.cos(sine / 8) / 2, -0.05 + math.sin(sine / 8) / 2) * RHCF * angles(mr(-4), mr(40), mr(10) - math.sin(sine / 8)), 0.3)
				LH.C0 = clerp(LH.C0, cn(-1, -0.8 + 0.3 * math.cos(sine / 8) / 2, -0.05 - math.sin(sine / 8) / 2) * LHCF * angles(mr(-4), mr(40), mr(-10) - math.sin(sine / 8)), 0.3)
				FakeHandleWeld.C0 = clerp(FakeHandleWeld.C0, CFrame.new(0, 0, 0) * angles(0, 0, mr(-60)), 0.3)
			end
		end
	end

	if #Effects > 0 then
		for e = #Effects, 1, -1 do
			local Thing = Effects[e]
			if Thing then
				local Part = Thing[1]
				local effMode = Thing[2]
				local Delay = Thing[3]
				local IncX = Thing[4]
				local IncY = Thing[5]
				local IncZ = Thing[6]
				local Mesh = Thing[7]
				if Part and Part.Parent and Part.Transparency <= 1 then
					if effMode == "Block1" then
						Part.CFrame *= CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
						if Mesh then
							Mesh.Scale += Vector3.new(IncX, IncY, IncZ)
						end
						Part.Transparency += Delay
					elseif effMode == "Block2" then
						if Mesh then
							Mesh.Scale += Vector3.new(IncX, IncY, IncZ)
						end
						Part.Transparency += Delay
					elseif effMode == "Cylinder" then
						if Mesh then
							Mesh.Scale += Vector3.new(IncX, IncY, IncZ)
						end
						Part.Transparency += Delay
					end
				else
					if Part then
						Part:Destroy()
					end
					table.remove(Effects, e)
				end
			end
		end
	end
end
