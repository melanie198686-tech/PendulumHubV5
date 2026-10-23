-- Created by Nebula_Zorua --
-- Sans Curse (A Curse of Light) -- FIXED VERSION

local S = setmetatable({},{__index = function(s,i) return game:GetService(i) end})
local CF = {N=CFrame.new,A=CFrame.Angles,fEA=CFrame.fromEulerAnglesXYZ}
local C3 = {N=Color3.new,RGB=Color3.fromRGB,HSV=Color3.fromHSV,tHSV=Color3.toHSV}
local V3 = {N=Vector3.new,FNI=Vector3.FromNormalId,A=Vector3.FromAxis}
local M = {C=math.cos,R=math.rad,S=math.sin,P=math.pi,RNG=math.random,MRS=math.randomseed,H=math.huge,RRNG = function(min,max,div) return math.rad(math.random(min,max)/(div or 1)) end}
local R3 = {N=Region3.new}
local De = S.Debris
local WS = workspace
local Lght = S.Lighting
local RepS = S.ReplicatedStorage
local IN = Instance.new
local Plrs = S.Players
local UIS = S.UserInputService

--// Initializing \\--
local Plr = Plrs.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local RArm = Char:WaitForChild("Right Arm")
local LArm = Char:WaitForChild("Left Arm")
local RLeg = Char:WaitForChild("Right Leg")
local LLeg = Char:WaitForChild("Left Leg")	
local Root = Char:WaitForChild("HumanoidRootPart")
local Torso = Char:WaitForChild("Torso")
local Head = Char:WaitForChild("Head")
local NeutralAnims = true
local Attack = false
local Debounces = {Debounces={}}
local Mouse = Plr:GetMouse()
local Hit = {}
local Sine = 0
local Change = 1

local Effects = IN("Folder",Char)
Effects.Name = "Effects"

--// Stop default animations & prevent death \\--
Hum.RequiresNeck = false
for _, v in pairs(Char:GetDescendants()) do
    if v:IsA("Motor6D") and v.Name ~= "Neck" and v.Name ~= "RootJoint" then
        v:Destroy() -- Destroy limb joints to use Welds instead
    end
    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
        v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1) -- Prevent joint snapping
    end
end
pcall(function() Char.Animate:Destroy() end)

--// Setup Custom Welds (Replaces Motor6Ds) \\--
local LS = IN("Weld", Torso); LS.Part0 = Torso; LS.Part1 = LArm; LS.C0 = CF.N(-1.5, 0.5, 0); LS.C1 = CF.N(0, 0.5, 0)
local RS = IN("Weld", Torso); RS.Part0 = Torso; RS.Part1 = RArm; RS.C0 = CF.N(1.5, 0.5, 0); RS.C1 = CF.N(0, 0.5, 0)
local LH = IN("Weld", Torso); LH.Part0 = Torso; LH.Part1 = LLeg; LH.C0 = CF.N(-0.5, -1, 0); LH.C1 = CF.N(0, 1, 0)
local RH = IN("Weld", Torso); RH.Part0 = Torso; RH.Part1 = RLeg; RH.C0 = CF.N(0.5, -1, 0); RH.C1 = CF.N(0, 1, 0)

-- Use Motor6D for Neck and RootJoint
local NK = Torso:WaitForChild("Neck")
local RJ = Root:WaitForChild("RootJoint")

NK.C0 = CF.N(0, 1, 0); NK.C1 = CF.N(0, -0.5, 0)
RJ.C0 = CF.N(0, 0, 0); RJ.C1 = CF.N(0, 0, 0)

local LSC0 = LS.C0
local RSC0 = RS.C0
local NKC0 = NK.C0
local LHC0 = LH.C0
local RHC0 = RH.C0
local RJC0 = RJ.C0

--// Frame & Swait \\--
local Frame_Speed = 60
function swait(num)
	if num == 0 or num == nil then
		S.RunService.Stepped:Wait()
	else
		for i = 0, num do
			S.RunService.Stepped:Wait()
		end
	end
end

--// Effect Functions \\--
local function NumSeq(...)
	local tab = {...}
	local Sequence = {}
	for _,v in next, tab do
		table.insert(Sequence,NumberSequenceKeypoint.new(unpack(v)))
	end
	if(tab[#tab][1] ~= 1)then
		local final = tab[#tab]
		table.insert(Sequence,NumberSequenceKeypoint.new(1,final[2],final[3]))
	end
	return NumberSequence.new(Sequence)
end

local DefaultRingParticle = IN("ParticleEmitter")
DefaultRingParticle.Name = 'RingEmit'
DefaultRingParticle.LightEmission = 1
DefaultRingParticle.Size = NumSeq({0,0},{.7,6.28},{.8,5.03},{1,2.9})
DefaultRingParticle.Texture = "rbxassetid://313951123"
DefaultRingParticle.Transparency = NumberSequence.new(0,1)
DefaultRingParticle.ZOffset = 1
DefaultRingParticle.Drag = 0
DefaultRingParticle.Acceleration = V3.N()
DefaultRingParticle.LockedToPart = true
DefaultRingParticle.Enabled = false
DefaultRingParticle.Lifetime = NumberRange.new(.6,.6)
DefaultRingParticle.Rate = 5
DefaultRingParticle.Rotation = NumberRange.new(0,0)
DefaultRingParticle.RotSpeed = NumberRange.new(0,0)
DefaultRingParticle.Speed = NumberRange.new(0,0)
DefaultRingParticle.SpreadAngle = Vector2.new(0,0)

local MagicCircles = {
	Default = {Color=C3.N(1,1,1),Texture1=0,Texture2=0},
	GasterBlaster = {Color=C3.N(1,1,1),Texture1=331948662,Texture2=331948662}
}

local MagicVariant = MagicCircles.GasterBlaster

local function Sound(parent,id,pitch,volume,looped,effect,autoPlay)
	local Sound = IN("Sound")
	Sound.SoundId = "rbxassetid://".. tostring(id or 0)
	Sound.Pitch = pitch or 1
	Sound.Volume = volume or 1
	Sound.Looped = looped or false
	if(autoPlay)then
		task.spawn(function()
			local timeout = tick() + 2
			repeat task.wait() until (Sound.IsLoaded) or (tick() > timeout)
			Sound:Play()
		end)
	end
	if(not looped and effect)then
		Sound.Stopped:Connect(function()
			Sound.Volume = 0
			Sound:Destroy()
		end)
	end
	Sound.Parent = parent or Torso
	return Sound
end

local function Part(parent,color,material,size,cframe,anchored,cancollide)
	local part = IN("Part")
	part.Parent = parent or Char
	part[typeof(color) == 'BrickColor' and 'BrickColor' or 'Color'] = color or C3.N(0,0,0)
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface,part.BottomSurface = 10,10
	part.Size = size or V3.N(1,1,1)
	part.CFrame = cframe or CF.N(0,0,0)
	part.CanCollide = cancollide or false
	part.Anchored = anchored or false
	return part
end

local function Weld(part0,part1,c0,c1)
	local weld = IN("Weld")
	weld.Parent = part0
	weld.Part0 = part0
	weld.Part1 = part1
	weld.C0 = c0 or CF.N()
	weld.C1 = c1 or CF.N()
	return weld
end

local function Mesh(parent,meshtype,meshid,textid,scale,offset)
	local part = IN("SpecialMesh")
	part.MeshId = meshid or ""
	part.TextureId = textid or ""
	part.Scale = scale or V3.N(1,1,1)
	part.Offset = offset or V3.N(0,0,0)
	part.MeshType = meshtype or Enum.MeshType.Sphere
	part.Parent = parent
	return part
end

local function NewInstance(instance,parent,properties)
	local inst = IN(instance)
	inst.Parent = parent
	if(properties)then
		for i,v in next, properties do
			pcall(function() inst[i] = v end)
		end	
	end
	return inst;
end

function MagicCircle(Data)
	local Variant = Data.Variant or MagicCircles.Default;
	local Size = Data.Size or 10;
	local Pos = Data.Pos*CF.A(M.R(-90),M.R(-90),0) or Torso.CFrame*CF.A(M.R(-90),M.R(-90),0);
	local GrowTime = Data.Time or 1;
	local WeldData = Data.Weld or false;
	
	local Circle = Part(Effects,BrickColor.new'Maroon',Enum.Material.SmoothPlastic,V3.N(.05,.05,.05),Pos,true,false)
	local CircleM = NewInstance("BlockMesh",Circle,{Scale=V3.N()})
	
	local Emitter = DefaultRingParticle:Clone();
	Emitter.Parent = Circle
	Emitter.Color = ColorSequence.new(Variant.Color)
	
	local Top = IN("Decal",Circle)
	Top.Texture = "rbxassetid://"..Variant.Texture1
	Top.Face = Enum.NormalId.Top
	
	local Btm = IN("Decal",Circle)
	Btm.Texture = "rbxassetid://"..Variant.Texture2
	Btm.Face = Enum.NormalId.Bottom
	
	if(WeldData)then
		Circle.Anchored = false
		Weld(WeldData,Circle,Pos,CF.N())
	end
	local GrowFrames = GrowTime * Frame_Speed
	Circle.Transparency = 1
	local GrownEvent = IN("BindableEvent",Circle)
	
	task.spawn(function()
		Emitter:Emit(5)
		local End = Size*20
		local grow = End/GrowFrames
		for i = 1, GrowFrames+1 do
			local aa = math.min(CircleM.Scale.x + grow,End)
			if(aa >= End)then break end
			CircleM.Scale = V3.N(aa,0,aa)
			swait()
		end
		CircleM.Scale = V3.N(End,0,End)
		GrownEvent:Fire()
	end)
	
	return {
		Circle = Circle,
		Mesh = CircleM,
		Grow = function(size)
			CircleM.Scale = CircleM.Scale + V3.N(size*20,0,size*20)
		end,
		Destroy = function(timer)
			task.spawn(function()
				if(not timer)then timer = 1 end
				Tween(CircleM,{Scale=V3.N(0,0,0)},timer,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
				Tween(Top,{Transparency=1},timer,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
				Tween(Btm,{Transparency=1},timer,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
				De:AddItem(Circle,timer+1)
			end)
		end,
		Grown = GrownEvent.Event
	}
end

function Tween(obj,props,time,easing,direction,repeats,backwards)
	local info = TweenInfo.new(time or .5, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out, repeats or 0, backwards or false)
	S.TweenService:Create(obj, info, props):Play()
end

function Bezier(startpos, pos2, pos3, endpos, t)
	local A = startpos:Lerp(pos2, t)
	local B  = pos2:Lerp(pos3, t)
	local C = pos3:Lerp(endpos, t)
	local lerp1 = A:Lerp(B, t)
	local lerp2 = B:Lerp(C, t)
	return lerp1:Lerp(lerp2, t)
end

function Effect(data)
	local FX = data.Effect or 'ResizeAndFade'
	local Parent = data.Parent or Effects
	local Color = data.Color or C3.N(0,0,0)
	local Size = data.Size or V3.N(1,1,1)
	local MoveDir = data.MoveDirection or nil
	local MeshData = data.Mesh or nil
	local SndData = data.Sound or nil
	local Frames = data.Frames or 45
	local Manual = data.Manual or nil
	local Material = data.Material or Enum.Material.Neon
	local CFra = data.CFrame or Torso.CFrame
	local Settings = data.FXSettings or {}
	local Shape = data.Shape or Enum.PartType.Block
	local Snd,Prt,Msh;
	
	task.spawn(function()
		if(Manual and typeof(Manual) == 'Instance' and Manual:IsA'BasePart')then
			Prt = Manual
		else
			Prt = Part(Parent,Color,Material,Size,CFra,true,false)
			Prt.Shape = Shape
		end
		if(typeof(MeshData) == 'table')then
			Msh = Mesh(Prt,MeshData.MeshType,MeshData.MeshId,MeshData.TextureId,MeshData.Scale,MeshData.Offset)
		elseif(typeof(MeshData) == 'Instance')then
			Msh = MeshData:Clone()
			Msh.Parent = Prt
		elseif(Shape == Enum.PartType.Block)then
			Msh = Mesh(Prt,Enum.MeshType.Brick)
		end
		if(typeof(SndData) == 'table')then
			Snd = Sound(Prt,SndData.SoundId,SndData.Pitch,SndData.Volume,false,false,true)
		elseif(typeof(SndData) == 'Instance')then
			Snd = SndData
		end
		if(Snd)then
			local timeout = tick() + 2
			repeat swait() until (Snd.Playing and Snd.IsLoaded and Snd.TimeLength > 0) or (tick() > timeout)
			if Snd.TimeLength > 0 then
				Frames = Snd.TimeLength * Frame_Speed/Snd.Pitch
			end
		end
		Size = (Msh and Msh.Scale or Size)
		local grow = Size-(Settings.EndSize or (Msh and Msh.Scale or Size)/2)
		
		local MoveSpeed = nil;
		if(MoveDir)then
			MoveSpeed = (CFra.p - MoveDir).Magnitude/Frames
		end
		if(FX ~= 'Arc')then
			for Frame = 1, Frames do
				if(FX == "Fade")then
					Prt.Transparency  = (Frame/Frames)
				elseif(FX == "Resize")then
					if(not Settings.EndSize)then Settings.EndSize = V3.N(0,0,0) end
					if(Settings.EndIsIncrement)then
						if(Msh)then Msh.Scale = Msh.Scale + Settings.EndSize
						else Prt.Size = Prt.Size + Settings.EndSize end					
					else
						if(Msh)then Msh.Scale = Msh.Scale - grow/Frames
						else Prt.Size = Prt.Size - grow/Frames end
					end 
				elseif(FX == "ResizeAndFade")then
					if(not Settings.EndSize)then Settings.EndSize = V3.N(0,0,0) end
					if(Settings.EndIsIncrement)then
						if(Msh)then Msh.Scale = Msh.Scale + Settings.EndSize
						else Prt.Size = Prt.Size + Settings.EndSize end					
					else
						if(Msh)then Msh.Scale = Msh.Scale - grow/Frames
						else Prt.Size = Prt.Size - grow/Frames end
					end 
					Prt.Transparency = (Frame/Frames)
				end
				if(Settings.RandomizeCFrame)then
					Prt.CFrame = Prt.CFrame * CF.A(M.RRNG(-360,360),M.RRNG(-360,360),M.RRNG(-360,360))
				end
				if(MoveDir and MoveSpeed)then
					local Orientation = Prt.Orientation
					Prt.CFrame = CF.N(Prt.Position,MoveDir)*CF.N(0,0,-MoveSpeed)
					Prt.Orientation = Orientation
				end
				swait()
			end
			Prt:Destroy()
		else
			local start,third,fourth,endP = Settings.Start,Settings.Third,Settings.Fourth,Settings.End
			if(not Settings.End and Settings.Home)then endP = Settings.Home.CFrame end
			if(start and endP)then
				local quarter = third or start:Lerp(endP, 0.25) * CF.N(M.RNG(-25,25),M.RNG(0,25),M.RNG(-25,25))
				local threequarter = fourth or start:Lerp(endP, 0.75) * CF.N(M.RNG(-25,25),M.RNG(0,25),M.RNG(-25,25))
				for Frame = 0, 1, (Settings.Speed or 0.01) do
					if(Settings.Home)then endP = Settings.Home.CFrame end
					Prt.CFrame = Bezier(start, quarter, threequarter, endP, Frame)
				end
				if(Settings.RemoveOnGoal)then Prt:Destroy() end
			else
				Prt:Destroy()
			end
		end
	end)()
	return Prt,Msh,Snd
end

--// Damage Systems \\--
local DamageColor = BrickColor.new'White'

function CastRay(startPos,endPos,range,ignoreList)
	local ray = Ray.new(startPos,(endPos-startPos).Unit*range)
	local part,pos,norm = workspace:FindPartOnRayWithIgnoreList(ray,ignoreList or {Char},false,true)
	return part,pos,norm,(pos and (startPos-pos).Magnitude)
end

function getRegion(point,range,ignore)
    return workspace:FindPartsInRegion3WithIgnoreList(R3.N(point-V3.N(1,1,1)*range/2,point+V3.N(1,1,1)*range/2),ignore,100)
end

function DealDamage(who,minDam,maxDam,Knock,Type,critChance,critMult)
	if(who and who ~= Char)then 
		local hum = who:FindFirstChildOfClass'Humanoid'
		local Damage = M.RNG(minDam,maxDam)
		local canHit = true
		if(hum)then
			for _, p in pairs(Hit) do
				if p[1] == hum then
					if(tick() - p[2] < 0.01) then canHit = false end
				end
			end
			if(canHit)then
				table.insert(Hit,{hum,tick()})
				if(hum.Health >= math.huge)then
					who:BreakJoints()
				else
					if(M.RNG(1,100) <= (critChance or 0) and critMult > 1)then
						hum.Health = hum.Health - Damage*(critMult or 2)
					else
						hum.Health = hum.Health - Damage
					end
					
					if(Type == 'Knockback' and who:FindFirstChild'Torso')then
						local body = NewInstance('BodyVelocity',who.Torso,{
							P = 500,
							maxForce = V3.N(math.huge,0,math.huge),
							velocity = Root.CFrame.LookVector * Knock + Root.Velocity / 1.05
						})
						De:AddItem(body,.5)
					elseif(Type == 'Knockdown' and who:FindFirstChild'Torso')then
						hum.PlatformStand = true
						task.delay(1,function() hum.PlatformStand = false end)
						local angle = (who.Torso.Position - (Root.Position + Vector3.new(0, 0, 0))).Unit
						local bodvol = NewInstance("BodyVelocity",who.Torso,{
							velocity = angle * Knock,
							P = 5000,
							maxForce = Vector3.new(8e+003, 8e+003, 8e+003),
						})
						local rl = NewInstance("BodyAngularVelocity",who.Torso,{
							P = 3000,
							maxTorque = Vector3.new(500000, 500000, 500000) * 50000000000000,
							angularvelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)),
						})
						De:AddItem(bodvol, .5)
						De:AddItem(rl, .5)
					end
				end
			end
		end
	end
end

function AOEDamage(where,range,minDam,maxDam,Knock,Type,critChance,critMult)
	for _,v in next, getRegion(where,range,{Char}) do
		if(v.Parent and v.Parent ~= Char and v.Parent:FindFirstChildOfClass'Humanoid')then
			task.spawn(function() DealDamage(v.Parent,minDam,maxDam,Knock,Type,critChance,critMult) end)
		end
	end
end

--// Shooting Functions \\--
function ShootBullet(data)
	local Size = data.Size or V3.N(2,2,2)
	local Color = data.Color or MagicVariant.EffectColor or MagicVariant.Color
	local StudsPerFrame = data.Speed or 10
	local Shape = data.Shape or 'Ball'
	local Frames = data.Frames or 160
	local Pos = data.Origin or Torso.CFrame
	local Direction = data.Direction or Mouse.Hit
	local Material = data.Material or Enum.Material.Neon
	local OnHit = data.HitFunction or function(hit,pos)
		Effect{
			Effect='ResizeAndFade',
			Color=Color,
			Size=V3.N(10,10,10),
			Mesh={MeshType=Enum.MeshType.Sphere},
			CFrame=CF.N(pos),
			FXSettings={ EndSize=V3.N(.05,.05,.05), EndIsIncrement=true }
		}
		AOEDamage(pos,10,15,30,0,'Normal',10,4)
	end	
	
	local Bullet = Part(Effects,Color,Material,Size,Pos,true,false)
	local BMesh = Mesh(Bullet,Enum.MeshType.Brick,"","",V3.N(1,1,1),V3.N())
	if(Shape == 'Ball')then BMesh.MeshType = Enum.MeshType.Sphere
	elseif(Shape == 'Head')then BMesh.MeshType = Enum.MeshType.Head
	elseif(Shape == 'Cylinder')then BMesh.MeshType = Enum.MeshType.Cylinder end
	
	task.spawn(function()
		for i = 1, Frames+1 do
			local hit,pos,norm,dist = CastRay(Bullet.CFrame.p,CF.N(Bullet.CFrame.p,Direction.p)*CF.N(0,0,-StudsPerFrame).p,StudsPerFrame)
			if(hit)then
				OnHit(hit,pos,norm,dist)
				break;
			else
				Bullet.CFrame = CF.N(Bullet.CFrame.p,Direction.p)*CF.N(0,0,-StudsPerFrame)
			end
			swait()
		end
		Bullet:Destroy()
	end)
end

function Laser(key)
	NeutralAnims = false
	Attack = true
	Root.Anchored = true
	local data = MagicCircle{Weld=Torso,Pos=CF.N(0,0,-4),Size=5,Variant=MagicVariant,Time=.5}
	local IsGrown = false
	data.Grown:Connect(function() IsGrown = true end)
	repeat swait() 
		local Alpha = .1
		LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(125),0,0),Alpha)
		RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(125),0,0),Alpha)
		RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
		NK.C0 = NK.C0:Lerp(NKC0,Alpha)
		LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
		RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p) 
	until IsGrown
	
	if(UIS:IsKeyDown(key))then
		local grown = 0
		repeat 
			local Alpha = .1
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(125),0,0),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(125),0,0),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
			Root.CFrame = CF.N(Root.Position,Mouse.Hit.p)
			if(grown < 250)then
				data.Grow(.05)
				grown = grown + 1
			end
			swait()
		until not UIS:IsKeyDown(key)
	end
	
	Sound(data.Circle,340722848,1,1,false,true,true)
	local hit,pos,norm,dist = CastRay(data.Circle.CFrame.p,Mouse.Hit.p,1024)
	local part = Part(Effects,MagicVariant.EffectColor or MagicVariant.Color,Enum.Material.Neon,V3.N(dist,data.Mesh.Scale.x/40,data.Mesh.Scale.x/40),CF.N(data.Circle.CFrame.p,pos)*CF.N(0,0,-dist/2)*CF.A(0,M.P/2,0),true,false)
	Mesh(part,Enum.MeshType.Cylinder)
	Tween(part,{Color=C3.N(1,1,1)},1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false)
	
	Effect{
		Effect='ResizeAndFade',
		Color=MagicVariant.Color,
		Size=V3.N(data.Mesh.Scale.X/20,data.Mesh.Scale.X/20,data.Mesh.Scale.X/20),
		Mesh={MeshType=Enum.MeshType.Sphere},
		CFrame=CF.N(pos),
		FXSettings={ EndSize=V3.N(.05,.05,.05), EndIsIncrement=true }
	}
	
	AOEDamage(pos,data.Mesh.Scale.X/20,15,45,0,'Normal',10,4)
	task.spawn(function()
		for i = 1, 30 do
			part.Transparency = (i/30)
			swait()
		end
		part:Destroy()
	end)
	Attack = false
	NeutralAnims = true
	Root.Anchored = false
	data.Destroy()
end

function DLaser(key)
	NeutralAnims = false
	Attack = true
	Root.Anchored = true
	local data1 = MagicCircle{Weld=Torso,Pos=CF.N(-4,0,-4),Size=5,Variant=MagicVariant,Time=.5}
	local data2 = MagicCircle{Weld=Torso,Pos=CF.N(4,0,-4),Size=5,Variant=MagicVariant,Time=.5}
	local IsGrown = false
	data1.Grown:Connect(function() IsGrown = true end)
	repeat swait() 
		local Alpha = .1
		local idk = M.R(25)
		LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
		RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
		RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
		NK.C0 = NK.C0:Lerp(NKC0,Alpha)
		LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
		RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p) 
	until IsGrown
	if(UIS:IsKeyDown(key))then
		local grown = 0
		repeat 
			local Alpha = .1
			local idk = M.R(25)
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
			Root.CFrame = CF.N(Root.Position,Mouse.Hit.p)
			if(grown < 250)then
				data1.Grow(.05)
				data2.Grow(.05)
				grown = grown + 1
			end
			swait()
		until not UIS:IsKeyDown(key)
	end
	Sound(data1.Circle,340722848,1,1,false,true,true)
	Sound(data2.Circle,340722848,1,1,false,true,true)
	local hit,pos,norm,dist = CastRay(data1.Circle.CFrame.p,Mouse.Hit.p,1024)
	local part1 = Part(Effects,MagicVariant.EffectColor or MagicVariant.Color,Enum.Material.Neon,V3.N(dist,data1.Mesh.Scale.x/40,data1.Mesh.Scale.x/40),CF.N(data1.Circle.CFrame.p,pos)*CF.N(0,0,-dist/2)*CF.A(0,M.P/2,0),true,false)
	Mesh(part1,Enum.MeshType.Cylinder)
	
	local part2 = Part(Effects,MagicVariant.EffectColor or MagicVariant.Color,Enum.Material.Neon,V3.N(dist,data2.Mesh.Scale.x/40,data2.Mesh.Scale.x/40),CF.N(data2.Circle.CFrame.p,pos)*CF.N(0,0,-dist/2)*CF.A(0,M.P/2,0),true,false)
	Mesh(part2,Enum.MeshType.Cylinder)
	Tween(part1,{Color=C3.N(1,1,1)},1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false)
	Tween(part2,{Color=C3.N(1,1,1)},1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false)
	Effect{
		Effect='ResizeAndFade',
		Color=MagicVariant.Color,
		Size=V3.N(data1.Mesh.Scale.X/20,data1.Mesh.Scale.X/20,data1.Mesh.Scale.X/20),
		Mesh={MeshType=Enum.MeshType.Sphere},
		CFrame=CF.N(pos),
		FXSettings={ EndSize=V3.N(.05,.05,.05), EndIsIncrement=true }
	}
	AOEDamage(pos,data1.Mesh.Scale.X/20,15,45,0,'Normal',10,4)
	AOEDamage(pos,data2.Mesh.Scale.X/20,15,45,0,'Normal',10,4)
	task.spawn(function()
		for i = 1, 30 do
			part1.Transparency = (i/30)
			part2.Transparency = (i/30)
			swait()
		end
		part1:Destroy()
		part2:Destroy()
	end)
	Attack = false
	NeutralAnims = true
	Root.Anchored = false
	data1.Destroy()
	data2.Destroy()
end

function BLaser(key)
	NeutralAnims = false
	Attack = true
	Root.Anchored = true
	local data = MagicCircle{Weld=Torso,Pos=CF.N(0,0,-1),Size=15,Variant=MagicVariant,Time=.75}
	local IsGrown = false
	data.Grown:Connect(function() IsGrown = true end)
	repeat swait() 
		local Alpha = .1
		local idk = M.R(25)
		LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
		RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
		RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
		NK.C0 = NK.C0:Lerp(NKC0,Alpha)
		LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
		RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p) 
	until IsGrown
	if(UIS:IsKeyDown(key))then
		local grown = 0
		repeat 
			local Alpha = .1
			local idk = M.R(25)
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
			Root.CFrame = CF.N(Root.Position,Mouse.Hit.p)
			swait()
		until not UIS:IsKeyDown(key)
	end
	
	local hit,pos,norm,dist = CastRay(data.Circle.CFrame.p,Mouse.Hit.p,1024)
	local part = Part(Effects,MagicVariant.EffectColor or MagicVariant.Color,Enum.Material.Neon,V3.N(dist,data.Mesh.Scale.x/40,data.Mesh.Scale.x/40),CF.N(data.Circle.CFrame.p,pos)*CF.N(0,0,-dist/2)*CF.A(0,M.P/2,0),true,false)
	Mesh(part,Enum.MeshType.Cylinder)
	Tween(part,{Color=C3.N(1,1,1)},1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false)
	local aa = data.Circle:Clone();
	aa.Parent = Effects
	aa.Anchored = true
	local blast = Sound(aa,334702766,1,5,false,true,true)
	data.Circle:Destroy()
	
	Effect{
		Effect='ResizeAndFade',
		Color=MagicVariant.Color,
		Size=V3.N(data.Mesh.Scale.X/20,data.Mesh.Scale.X/20,data.Mesh.Scale.X/20),
		Mesh={MeshType=Enum.MeshType.Sphere},
		CFrame=CF.N(pos),
		Sound=blast,
		FXSettings={ EndSize=V3.N(.05,.05,.05), EndIsIncrement=true }
	}
	AOEDamage(pos,data.Mesh.Scale.X/20,45,75,0,'Normal',10,4)
	task.spawn(function()
		local time = (blast.TimeLength > 0 and blast.TimeLength or 2) * Frame_Speed
		for i = 1, time do
			part.Transparency = (i/time)
			for _,v in next, aa:children() do if v:IsA'Decal' then v.Transparency = (i/time) end end
			swait()
		end
		aa:Destroy()
		part:Destroy()
	end)
	
	Attack = false
	NeutralAnims = true
	Root.Anchored = false
	Root.Velocity = Mouse.Hit.lookVector*-125
end

function Balls(key)
	NeutralAnims = false
	Attack = true
	Root.Anchored = true
	local data = MagicCircle{Weld=Torso,Pos=CF.N(0,0,-1),Size=5,Variant=MagicVariant,Time=.5}
	local IsGrown = false
	data.Grown:Connect(function() IsGrown = true end)
	repeat swait() 
		local Alpha = .1
		local idk = M.R(25)
		LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
		RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
		RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
		NK.C0 = NK.C0:Lerp(NKC0,Alpha)
		LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
		RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p) 
	until IsGrown
	local projectiles = 5
	if(UIS:IsKeyDown(key))then
		local grown = 0
		repeat 
			local Alpha = .1
			local idk = M.R(25)
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0,Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
			Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p)
			if(grown < 250)then
				data.Grow(.05)
				grown = grown + 1
				projectiles = projectiles + .05
			end
			swait()
		until not UIS:IsKeyDown(key)
	end
	for i = 1, math.floor(projectiles) do
		data.Grow(-math.floor(projectiles)/20)
		Torso.CFrame = CF.N(Root.Position,Mouse.Hit.p)
		ShootBullet{Shape='Ball',Frames=160,Origin=data.Circle.CFrame,Speed=10}
		swait(1)
	end
	
	Attack = false
	NeutralAnims = true
	Root.Anchored = false
	data.Destroy()
end

--// Input \\--
UIS.InputBegan:Connect(function(input, processed)
	if(processed or Attack)then return end
	local k = input.KeyCode.Name:lower()
	if(k == 'q')then Laser(Enum.KeyCode.Q) end
	if(k == 'z')then DLaser(Enum.KeyCode.Z) end
	if(k == 'x')then BLaser(Enum.KeyCode.X) end
	if(k == 'c')then Balls(Enum.KeyCode.C) end
end)

--// Main Loop \\--
local WalkSpeed = 16
while Char.Parent do
	swait()
	Sine = Sine + Change
	local hitfloor = workspace:FindPartOnRay(Ray.new(Root.CFrame.p,(CFrame.new(Root.Position,Root.Position - Vector3.new(0,1,0))).LookVector * 4), Char)
	local Walking = (math.abs(Root.Velocity.X) > 1 or math.abs(Root.Velocity.Z) > 1)
	local State = (Hum.PlatformStand and 'Paralyzed' or Hum.Sit and 'Sit' or not hitfloor and Root.Velocity.Y < -1 and "Fall" or not hitfloor and Root.Velocity.Y > 1 and "Jump" or hitfloor and Walking and (Hum.WalkSpeed > 24 and "Run" or "Walk") or hitfloor and "Idle")
	
	if(not Effects or not Effects.Parent)then
		Effects = IN("Folder",Char)
		Effects.Name = "Effects"
	end																																																																																																				
	if(State == 'Run')then
		local wsVal = 20 / (Hum.WalkSpeed/16)
		local Alpha = math.min(.2 * (Hum.WalkSpeed/16),1)
		Change = 3
		RH.C1 = RH.C1:Lerp(CF.N(0,1,0)*CF.N(0,0-.2*M.C(Sine/wsVal),0+.4*M.C(Sine/wsVal))*CF.A(M.R(15+25*M.C(Sine/wsVal))+-M.S(Sine/wsVal),0,0),Alpha)
		LH.C1 = LH.C1:Lerp(CF.N(0,1,0)*CF.N(0,0+.2*M.C(Sine/wsVal),0-.4*M.C(Sine/wsVal))*CF.A(M.R(15-25*M.C(Sine/wsVal))+M.S(Sine/wsVal),0,0),Alpha)	
	elseif(State == 'Walk')then
		local wsVal = 20 / (Hum.WalkSpeed/16)
		local Alpha = math.min(.3 * (Hum.WalkSpeed/8),1)
		Change = 3
		RH.C1 = RH.C1:Lerp(CF.N(0,1,0)*CF.N(0,0-.5*M.C(Sine/wsVal)/2,0+.6*M.C(Sine/wsVal)/2)*CF.A(M.R(15-2*M.C(Sine/wsVal))+-M.S(Sine/wsVal)/2.5,0,0),Alpha)
		LH.C1 = LH.C1:Lerp(CF.N(0,1,0)*CF.N(0,0+.5*M.C(Sine/wsVal)/2,0-.6*M.C(Sine/wsVal)/2)*CF.A(M.R(15+2*M.C(Sine/wsVal))+M.S(Sine/wsVal)/2.5,0,0),Alpha)	
	else
		RH.C1 = RH.C1:Lerp(CF.N(0,1,0),.2)
		LH.C1 = LH.C1:Lerp(CF.N(0,1,0),.2)
	end	

	Hum.WalkSpeed = WalkSpeed
	
	if(NeutralAnims)then	
		if(State == 'Idle')then
			local Alpha = .1
			Change = .75
			RJ.C0 = RJ.C0:Lerp(RJC0*CF.N(0+.2*M.C(Sine/12),.2*M.C(Sine/6),0)*CF.A(M.R(-5+5*M.C(Sine/12)),0,0),Alpha)
			NK.C0 = NK.C0:Lerp(NKC0*CF.A(M.R(-5+5*M.C(Sine/12)),0,0),Alpha)
			LS.C0 = LS.C0:Lerp(LSC0*CF.N(.25,0,0)*CF.A(M.R(-45),0,M.R(45+5*M.C(Sine/12))),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.N(-.25,0,0)*CF.A(M.R(-45),0,M.R(-45-5*M.C(Sine/12))),Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.N(0-.2*M.C(Sine/12),-.2*M.C(Sine/6),0)*CF.A(M.R(5-5*M.C(Sine/12)),M.R(10),0),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0-.2*M.C(Sine/12),-.2*M.C(Sine/6),0)*CF.A(M.R(5-5*M.C(Sine/12)),M.R(-10),0),Alpha)
		elseif(State == 'Run')then
			local wsVal = 20 / (Hum.WalkSpeed/16)
			local Alpha = math.min(.2 * (Hum.WalkSpeed/16),1)
			RJ.C0 = RJ.C0:Lerp(CF.N(0,0-.1*M.C(Sine/(wsVal/2)),0)*CF.A(M.R(-15+2.5*M.C(Sine/(wsVal/2))),M.R(8*M.C(Sine/wsVal)),0),Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LS.C0 = LS.C0:Lerp(LSC0*CF.N(0,0,0-.3*M.S(Sine/wsVal))*CF.A(M.R(0+45*M.S(Sine/wsVal)),0,M.R(-5)),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.N(0,0,0+.3*M.S(Sine/wsVal))*CF.A(M.R(0-45*M.S(Sine/wsVal)),0,M.R(5)),Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.N(0,0+.1*M.C(Sine/(wsVal/2)),0)*CF.A(0,-M.R(4*M.C(Sine/wsVal)),0),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,0+.1*M.C(Sine/(wsVal/2)),0)*CF.A(0,-M.R(4*M.C(Sine/wsVal)),0),Alpha)
		elseif(State == 'Walk')then
			local wsVal = 20 / (Hum.WalkSpeed/16)
			local Alpha = math.min(.3 * (Hum.WalkSpeed/16),1)
			RJ.C0 = RJ.C0:Lerp(CF.N(0,0-.1*M.C(Sine/(wsVal/2)),0)*CF.A(M.R(-5-2.5*M.C(Sine/(wsVal/2))),M.R(8*M.C(Sine/wsVal)),0),Alpha)
			NK.C0 = NK.C0:Lerp(NKC0,Alpha)
			LS.C0 = LS.C0:Lerp(LSC0*CF.N(0,0,-.22*M.C(Sine/wsVal))*CF.A(M.R(37*M.C(Sine/wsVal)),0,M.R(-5)),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.N(0,0,.22*M.C(Sine/wsVal))*CF.A(M.R(-37*M.C(Sine/wsVal)),0,M.R(5)),Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.N(0,0+.1*M.C(Sine/(wsVal/2)),0)*CF.A(0,-M.R(4*M.C(Sine/wsVal)),0),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,0+.1*M.C(Sine/(wsVal/2)),0)*CF.A(0,-M.R(4*M.C(Sine/wsVal)),0),Alpha)
		elseif(State == 'Jump')then
			local Alpha = .1
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(45)),M.R(45)),0,0),Alpha)
			NK.C0 = NK.C0:Lerp(NKC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(45)),M.R(45)),0,0),Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		elseif(State == 'Fall')then
			local Alpha = .1
			local idk = math.min(math.max(Root.Velocity.Y/50,-M.R(90)),M.R(90))
			LS.C0 = LS.C0:Lerp(LSC0*CF.A(M.R(-5),0,M.R(-90)+idk),Alpha)
			RS.C0 = RS.C0:Lerp(RSC0*CF.A(M.R(-5),0,M.R(90)-idk),Alpha)
			RJ.C0 = RJ.C0:Lerp(RJC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(45)),M.R(45)),0,0),Alpha)
			NK.C0 = NK.C0:Lerp(NKC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(45)),M.R(45)),0,0),Alpha)
			LH.C0 = LH.C0:Lerp(LHC0*CF.A(0,0,M.R(-5)),Alpha)
			RH.C0 = RH.C0:Lerp(RHC0*CF.N(0,1,-1)*CF.A(M.R(-5),0,M.R(5)),Alpha)
		end
	end
end
