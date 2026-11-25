wait(0.5)
math.randomseed(tick())
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local me = player.Character or player.CharacterAdded:Wait()
local usable = true
local active = false
local acting = false
local canClick = true
local stabbing = false
local hit = false

-- Knife Model
local obj1 = Instance.new("Model")
obj1.Name = "bitch ass knife"
obj1.Parent = game.Workspace

local obj2 = Instance.new("Part")
obj2.CFrame = CFrame.new(Vector3.new(20.4525032, 6.14501333, -134.399979)) * CFrame.Angles(-3.1415927410126, 0, -3.1415927410126)
obj2.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.Material = Enum.Material.Concrete
obj2.Size = Vector3.new(1, 0.25, 0.25)
obj2.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj2.Anchored = true
obj2.BrickColor = BrickColor.new("Black")
obj2.Friction = 0.30000001192093
obj2.Shape = Enum.PartType.Cylinder
obj2.Name = "Grab"
obj2.Parent = obj1

local obj3 = Instance.new("Part")
obj3.CFrame = CFrame.new(Vector3.new(19.9725456, 6.14502859, -134.399933)) * CFrame.Angles(0, 1.5707963705063, 0)
obj3.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.Material = Enum.Material.Concrete
obj3.Size = Vector3.new(0.349999994, 0.349999994, 0.349999994)
obj3.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj3.Anchored = true
obj3.BrickColor = BrickColor.new("Black")
obj3.Friction = 0.30000001192093
obj3.Shape = Enum.PartType.Ball
obj3.Name = "handletopcap"
obj3.Parent = obj1

local obj4 = Instance.new("Part")
obj4.CFrame = CFrame.new(Vector3.new(20.9725285, 6.14502859, -134.399918)) * CFrame.Angles(0, 1.5707963705063, 0)
obj4.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.Material = Enum.Material.Concrete
obj4.Size = Vector3.new(0.25, 0.25, 0.25)
obj4.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj4.Anchored = true
obj4.BrickColor = BrickColor.new("Black")
obj4.Friction = 0.30000001192093
obj4.Shape = Enum.PartType.Ball
obj4.Name = "handlebottomcap"
obj4.Parent = obj1

local obj5 = Instance.new("Part")
obj5.CFrame = CFrame.new(Vector3.new(19.9474983, 6.14502859, -134.399918)) * CFrame.Angles(0, 1.5707963705063, 0)
obj5.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.Material = Enum.Material.Concrete
obj5.Size = Vector3.new(0.349999994, 0.349999994, 0.100000001)
obj5.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj5.Anchored = true
obj5.BrickColor = BrickColor.new("Black")
obj5.Friction = 0.30000001192093
obj5.Shape = Enum.PartType.Block
obj5.Name = "handleguardmid"
obj5.Parent = obj1

local obj6 = Instance.new("Part")
obj6.CFrame = CFrame.new(Vector3.new(19.9474983, 6.32502794, -134.399918)) * CFrame.Angles(-3.1415927410126, 0, -3.1415927410126)
obj6.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.Material = Enum.Material.Concrete
obj6.Size = Vector3.new(0.100000001, 0.349999994, 0.349999994)
obj6.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj6.Anchored = true
obj6.BrickColor = BrickColor.new("Black")
obj6.Friction = 0.30000001192093
obj6.Shape = Enum.PartType.Cylinder
obj6.Name = "handleguardcap1"
obj6.Parent = obj1

local obj7 = Instance.new("Part")
obj7.CFrame = CFrame.new(Vector3.new(19.9474983, 5.97502899, -134.399918)) * CFrame.Angles(-3.1415927410126, 0, -3.1415927410126)
obj7.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.Material = Enum.Material.Concrete
obj7.Size = Vector3.new(0.100000009, 0.349999994, 0.349999994)
obj7.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj7.Anchored = true
obj7.BrickColor = BrickColor.new("Black")
obj7.Friction = 0.30000001192093
obj7.Shape = Enum.PartType.Cylinder
obj7.Name = "handleguardcap2"
obj7.Parent = obj1

local obj8 = Instance.new("Part")
obj8.CFrame = CFrame.new(Vector3.new(18.4375095, 6.14502859, -134.401321)) * CFrame.Angles(0, 1.5707963705063, 0)
obj8.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.Material = Enum.Material.Metal
obj8.Size = Vector3.new(0.0500000007, 0.280000001, 0.839999795)
obj8.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj8.Anchored = true
obj8.BrickColor = BrickColor.new("Lily white")
obj8.Friction = 0.30000001192093
obj8.Shape = Enum.PartType.Block
obj8.Name = "big ass knife"
obj8.Parent = obj1

local obj9 = Instance.new("BlockMesh")
obj9.Scale = Vector3.new(0.5, 1, 1)
obj9.Parent = obj8

local obj10 = Instance.new("Part")
obj10.CFrame = CFrame.new(Vector3.new(19.7425137, 6.14502859, -134.401321)) * CFrame.Angles(0, 1.5707963705063, 0)
obj10.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.Material = Enum.Material.Metal
obj10.Size = Vector3.new(0.0500000007, 0.280000001, 0.289999962)
obj10.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj10.Anchored = true
obj10.BrickColor = BrickColor.new("Lily white")
obj10.Friction = 0.30000001192093
obj10.Shape = Enum.PartType.Block
obj10.Name = "big ass knife"
obj10.Parent = obj1
local knife = obj10

local obj11 = Instance.new("BlockMesh")
obj11.Scale = Vector3.new(0.5, 1, 1)
obj11.Parent = obj10

local obj12 = Instance.new("Part")
obj12.CFrame = CFrame.new(Vector3.new(19.1075306, 6.08502865, -134.401321)) * CFrame.Angles(0, 1.5707963705063, 0)
obj12.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.Material = Enum.Material.Metal
obj12.Size = Vector3.new(0.0500000007, 0.159999996, 0.979999959)
obj12.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj12.Anchored = true
obj12.BrickColor = BrickColor.new("Lily white")
obj12.Friction = 0.30000001192093
obj12.Shape = Enum.PartType.Block
obj12.Name = "big ass knife"
obj12.Parent = obj1

local obj13 = Instance.new("BlockMesh")
obj13.Scale = Vector3.new(0.5, 1, 1)
obj13.Parent = obj12

-- Serrations
local function makeSerration(cf)
	local p = Instance.new("WedgePart")
	p.CFrame = cf
	p.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
	p.TopSurface = Enum.SurfaceType.SmoothNoOutlines
	p.RightSurface = Enum.SurfaceType.SmoothNoOutlines
	p.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
	p.Material = Enum.Material.Metal
	p.Size = Vector3.new(0.0500000007, 0.200000003, 0.200000003)
	p.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
	p.BackSurface = Enum.SurfaceType.SmoothNoOutlines
	p.Anchored = true
	p.BrickColor = BrickColor.new("Lily white")
	p.Friction = 0.30000001192093
	p.Name = "serration"
	p.Parent = obj1
	local m = Instance.new("BlockMesh")
	m.Scale = Vector3.new(0.5, 1, 1)
	m.Parent = p
end

makeSerration(CFrame.new(Vector3.new(19.4963322, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(19.2763138, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(19.3863068, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(19.5963173, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(19.1663074, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(18.9663048, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(18.8562984, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))
makeSerration(CFrame.new(Vector3.new(19.0663071, 6.15381575, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063))

local obj30 = Instance.new("WedgePart")
obj30.CFrame = CFrame.new(Vector3.new(18.0163059, 6.14381599, -134.400375)) * CFrame.Angles(1.5707963705063, -0.78539824485779, -1.5707963705063)
obj30.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.TopSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.RightSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.Material = Enum.Material.Metal
obj30.Size = Vector3.new(0.0500000007, 0.200000003, 0.200000003)
obj30.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.BackSurface = Enum.SurfaceType.SmoothNoOutlines
obj30.Anchored = true
obj30.BrickColor = BrickColor.new("Lily white")
obj30.Friction = 0.30000001192093
obj30.Name = "knifetip1"
obj30.Parent = obj1
local obj31 = Instance.new("BlockMesh")
obj31.Scale = Vector3.new(0.5, 1, 1)
obj31.Parent = obj30

-- Red accents
local function makeRed(cf, size, shape)
	local p = Instance.new("Part")
	p.CFrame = cf
	p.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
	p.TopSurface = Enum.SurfaceType.SmoothNoOutlines
	p.RightSurface = Enum.SurfaceType.SmoothNoOutlines
	p.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
	p.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
	p.Material = Enum.Material.SmoothPlastic
	p.Size = size
	p.BackSurface = Enum.SurfaceType.SmoothNoOutlines
	p.BrickColor = BrickColor.new("Institutional white")
	p.Friction = 0.30000001192093
	p.Shape = shape or Enum.PartType.Block
	p.Name = "redstuff"
	p.Anchored = true
	p.Parent = obj1
end

makeRed(CFrame.new(Vector3.new(19.9470005, 5.9749999, -134.399994)), Vector3.new(0.0500000007, 0.360000014, 0.360000014), Enum.PartType.Cylinder)
makeRed(CFrame.new(Vector3.new(18.9800053, 6.1400156, -134.404984)), Vector3.new(1.81999993, 0.100000001, 0.0500000007))
makeRed(CFrame.new(Vector3.new(19.9470005, 6.32499981, -134.399994)), Vector3.new(0.0500000007, 0.360000014, 0.360000014), Enum.PartType.Cylinder)
makeRed(CFrame.new(Vector3.new(19.8830166, 6.14501476, -134.399963)), Vector3.new(0.0500000007, 0.319999993, 0.319999993), Enum.PartType.Cylinder)
makeRed(CFrame.new(Vector3.new(20.9430103, 6.14501476, -134.399963)), Vector3.new(0.0500000007, 0.25999999, 0.25999999), Enum.PartType.Cylinder)
makeRed(CFrame.new(Vector3.new(20.1230125, 6.14501476, -134.399979)), Vector3.new(0.0500000007, 0.25999999, 0.25999999), Enum.PartType.Cylinder)

local audio = Instance.new('Sound',knife)
audio.Volume = 2

local audio2 = Instance.new('Sound',knife)
audio2.Volume = 2

-- Weld all knife parts together
local previous = nil
for i,v in pairs(obj1:GetChildren()) do
	if v:IsA('BasePart') then
		if previous then
			local weld = Instance.new('Weld',v)
			weld.Part0 = v
			weld.Part1 = previous
			weld.C0 = v.CFrame:inverse() * previous.CFrame
			previous.Anchored = false
			previous.CanCollide = false
			local vee = v
			weld.AncestryChanged:connect(function(mez,par)
				wait()
				weld.Parent = vee
			end)
		end
		previous = v
	end
end
previous.Anchored = false
previous.CanCollide = false

local knifeweld = Instance.new('Weld',me.Torso)
knifeweld.Part0 = me.Torso
knifeweld.Part1 = obj2
knifeweld.C1 = CFrame.Angles(0,math.rad(90),0) * CFrame.new(1, 0.8, 0.55)
knifeweld.AncestryChanged:connect(function(mez,par)
	if par ~= me.Torso then
		wait()
		knifeweld.Parent = me.Torso
	end
end)

local rightshoulderz = me.Torso["Right Shoulder"]:Clone()
local leftshoulderz = me.Torso["Left Shoulder"]:Clone()
local torsojoint = me.HumanoidRootPart["RootJoint"]:Clone()

function equip()
	local doit = coroutine.wrap(function()
		if me:FindFirstChild('Right Arm') and me:FindFirstChild('Torso') then
			acting = true
			local arm = me["Right Arm"]
			local arm2 = me["Left Arm"]
			local tors = me.Torso
			local weld = Instance.new('Weld',arm)
			weld.Part0 = arm
			weld.Part1 = tors
			weld.C0 = CFrame.new(-1.5,0,0)
			local weld2 = Instance.new("Weld", arm2)
			weld2.Part0 = arm2
			weld2.Part1 = tors
			weld2.C0 = CFrame.new(1.5, 0, 0)
			wait(0.001)
			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld == nil then return end
				weld.C0 = weld.C0:lerp(CFrame.new(-0.2,0.2,-0.5)*CFrame.Angles(0,-3.1,0.9),i)
				weld2.C0 = weld2.C0:lerp(CFrame.new(1.5, 0.6, 0) * CFrame.Angles(0,0,0.5),i)
				wait(0.001)
			end
			wait(0.15)
			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld == nil then return end
				weld.C0 = weld.C0:lerp(CFrame.new(-0.5,2,0)*CFrame.Angles(0,0,-1.55),i)
				weld2.C0 = weld2.C0:lerp(CFrame.new(1.5, 0, 0), i)
				wait(0.001)
			end
			wait(0.2)
			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld == nil then return end
				weld.C0 = weld.C0:lerp(CFrame.new(-1.5,0,0),i)
				wait(0.001)
			end
			weld:Destroy()
			weld2:Remove()
			if tors ~= nil then
				rightshoulderz:Clone().Parent = me.Torso
				leftshoulderz:Clone().Parent = me.Torso
			end
		end
		acting = false
	end)
	doit()
end

function unequip()
	local doit = coroutine.wrap(function()
		if me:FindFirstChild('Right Arm') and me:FindFirstChild('Torso') then
			acting = true
			local arm = me["Right Arm"]
			local arm2 = me["Left Arm"]
			local tors = me.Torso
			local weld = Instance.new('Weld',arm)
			weld.Part0 = arm
			weld.Part1 = tors
			weld.C0 = CFrame.new(-1.5,0,0)
			local weld2 = Instance.new("Weld", arm2)
			weld2.Part0 = arm2
			weld2.Part1 = tors
			weld2.C0 = CFrame.new(1.5, 0, 0)
			wait(0.001)
			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld == nil then return end
				weld.C0 = weld.C0:lerp(CFrame.new(-0.2,0.2,-0.5)*CFrame.Angles(0,-3.1,0.9),i)
				weld2.C0 = weld2.C0:lerp(CFrame.new(1.5, 0.6, 0) * CFrame.Angles(0,0,0.5),i)
				wait(0.001)
			end
			wait(0.25)
			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld == nil then return end
				weld.C0 = weld.C0:lerp(CFrame.new(-1.5,0,0),i)
				weld2.C0 = weld2.C0:lerp(CFrame.new(1.5, 0, 0), i)
				wait(0.01)
			end
			weld:Destroy()
			weld2:Remove()
			if tors ~= nil then
				rightshoulderz:Clone().Parent = me.Torso
				leftshoulderz:Clone().Parent = me.Torso
			end
			acting = false
		end
	end)
	doit()
end

-- Grab animation only (no damage)
function grabAnim()
	local doit = coroutine.wrap(function()
		if me:FindFirstChild('Right Arm') and me:FindFirstChild('Torso') and me:FindFirstChild('HumanoidRootPart') and me:FindFirstChild('Left Arm') then
			acting = true
			me:FindFirstChildOfClass('Humanoid').WalkSpeed = me:FindFirstChildOfClass('Humanoid').WalkSpeed + 3
			local arm = me["Right Arm"]
			local tors = me.Torso
			local arm2 = me["Left Arm"]
			local humanroot = me.HumanoidRootPart
			local weld = Instance.new('Weld',tors)
			weld.Part0 = tors
			weld.Part1 = humanroot
			weld.C0 = CFrame.new(0,0,0) * CFrame.Angles(0, 0, 0)
			local weld2 = Instance.new('Weld',arm)
			weld2.Part0 = arm
			weld2.Part1 = tors
			weld2.C0 = CFrame.new(-1.5,0,0) * CFrame.Angles(0, 0, 0)
			local weld3 = Instance.new('Weld',arm2)
			weld3.Part0 = arm2
			weld3.Part1 = tors
			weld3.C0 = CFrame.new(1.5,0,-0.3) * CFrame.Angles(0.3,0.1,0)

			-- Grab animation
			for i = 0,1,0.05 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld2 == nil or humanroot == nil then return end
				weld2.C0 = weld2.C0:lerp(CFrame.new(-1.2,1.3,0.4)*CFrame.Angles(0.5,0,-1.2),i)
				weld3.C0 = weld3.C0:lerp(CFrame.new(1.2,1.3,0)*CFrame.Angles(0,0,1.2),i)
				knifeweld.C1 = CFrame.fromEulerAnglesXYZ(1.55, math.rad(-90), -1.55) * CFrame.new(0, 0.95, 0)
				wait(0.01)
			end

			stabbing = true
			audio2.SoundId = 'rbxassetid://608537390'
			audio2:Play()

			for i = 0,1,0.10 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil or weld2 == nil or humanroot == nil then return end
				weld2.C0 = weld2.C0:lerp(CFrame.new(-0.9, 0.80, -1.1)* CFrame.Angles(-1.5, 0, -1.3), i)
				weld3.C0 = weld3.C0:lerp(CFrame.new(0.8, 1, -0.5)* CFrame.Angles(-1.5, 0, 1.1), i)
				wait(0.01)
			end

			wait(0.35)
			stabbing = false
			me:FindFirstChildOfClass('Humanoid').WalkSpeed = me:FindFirstChildOfClass('Humanoid').WalkSpeed - 3

			for i = 0,1,0.1 do
				if me:FindFirstChild('Right Arm') == nil or me:FindFirstChild('Torso') == nil then return end
				weld2.C0 = weld2.C0:lerp(CFrame.new(-1.5,0,0),i)
				weld3.C0 = weld3.C0:lerp(CFrame.new(1.5,0,0),i)
				knifeweld.C1 = CFrame.fromEulerAnglesXYZ(1.55, math.rad(-90), 1.55) * CFrame.new(0, 0.95, 0)
				wait(0.001)
			end

			weld:Destroy()
			weld2:Destroy()
			weld3:Destroy()
			torsojoint:Clone().Parent = humanroot
			rightshoulderz:Clone().Parent = me.Torso
			leftshoulderz:Clone().Parent = me.Torso
			canClick = true
			hit = false
			acting = false
		end
	end)
	doit()
end

mouse.KeyDown:connect(function(key)
	if usable == true then
		if key == "z" then
			if active == false and acting == false then
				active = true
				audio:Stop()
				audio.SoundId = 'rbxassetid://608618332'
				equip()
				wait(0.6)
				audio:Play()
				knifeweld.Part0 = me["Right Arm"]
				knifeweld.C1 = CFrame.fromEulerAnglesXYZ(1.55, math.rad(-90), 1.55) * CFrame.new(0, 0.95, 0)
			elseif acting == false then
				active = false
				audio:Stop()
				audio.SoundId = 'rbxassetid://608538233'
				unequip()
				wait(0.3)
				audio:Play()
				knifeweld.Part0 = me.Torso
				knifeweld.C1 = CFrame.Angles(0,math.rad(90),0) * CFrame.new(1, 0.8, 0.55)
				canClick = true
			end
		end
	end
end)

mouse.Button1Down:connect(function()
	if active == false or usable == false then return end
	if canClick == true and acting == false then
		canClick = false
		grabAnim()
	end
end)

-- Hit detection (sound only, no damage)
knife.Touched:connect(function(hitz)
	if hitz.Parent and hitz.Parent:FindFirstChildOfClass("Humanoid") and hitz.Parent:FindFirstChild('Torso') and acting == true then
		if stabbing == true and hit == false then
			hit = true
			local tone = math.random(1, 3)
			audio:Stop()
			if tone == 1 then audio.SoundId = "rbxassetid://220833967" end
			if tone == 2 then audio.SoundId = "rbxassetid://220833976" end
			if tone == 3 then audio.SoundId = "rbxassetid://220834000" end
			audio.PlaybackSpeed = 1
			audio:Play()
		end
	end
end)

player.CharacterAdded:connect(function()
	usable = false
end)
