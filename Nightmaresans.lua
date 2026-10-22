Player = game:GetService("Players").LocalPlayer
PlayerGui = Player.PlayerGui
Cam = workspace.CurrentCamera
Backpack = Player.Backpack
Character = Player.Character or Player.CharacterAdded:Wait()
char = Character
Humanoid = Character:WaitForChild("Humanoid")
Mouse = Player:GetMouse()
RootPart = Character:WaitForChild("HumanoidRootPart")
Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
Head = Character:WaitForChild("Head")
RightArm = Character:FindFirstChild("Right Arm")
LeftArm = Character:FindFirstChild("Left Arm")
RightLeg = Character:FindFirstChild("Right Leg")
LeftLeg = Character:FindFirstChild("Left Leg")

local Orin = "http://www.roblox.com/asset/?id=7074786"
if Head:FindFirstChild("face") then Head.face.Texture = Orin end

local function weld(a, b, acf)
	local w = Instance.new("Weld", a)
	w.Part0 = a
	w.Part1 = b
	if acf then w.C0 = acf end
end

local reye = Instance.new("Part", char)
reye.CanCollide = false
reye.BrickColor = BrickColor.new("Toothpaste")
reye.Material = "Neon"
reye.Size = Vector3.new(.25,.35,.15)
weld(reye, Head, CFrame.new(0.15,-0.2,0.55))
local m1 = Instance.new("SpecialMesh", reye)
m1.MeshType = "Sphere"
m1.Scale = Vector3.new(0.9,0.9,0.9)
reye.Locked = true
reye.Name = "re"

local p = Player
local mouse = p:GetMouse()
local larm = char:WaitForChild("Left Arm")
local rarm = char:WaitForChild("Right Arm")
local lleg = char:WaitForChild("Left Leg")
local rleg = char:WaitForChild("Right Leg")
local hed = char:WaitForChild("Head")
local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local debris = game:GetService("Debris")
local run = game:GetService("RunService")
local rs = run.RenderStepped
local cam = workspace.CurrentCamera
local movement = 4
local change = 0.4
local DebrisModel = Instance.new("Model", char)
local debounce = false

themeid = 175635113
themepitch = 1.4
main = {r = 0; g = 100; b = 255; v = 1}
main_color = Color3.fromRGB(main.r, main.g, main.b)
explosionid = {262562442,144699494,539294959,1388740053}

no_anim = false
attack = false
attacking = false
canjump = true
aiming_anim = false
animid = math.random(0,1)
timer = 0
bg = Instance.new("BodyGyro", root)
bg.P = 100000
bg.D = 100

function rswait(value)
  if value ~= nil and value ~= 0 then
    for i=1,value do rs:wait() end
  else
    rs:wait()
  end
end

max = 0
function music(id, pitch)
  max = 0
  if id == "Stop" then
    if not torso:FindFirstChild("MusicRuin") then
      soundz = Instance.new("Sound", torso)
    end
    soundz:Stop()
  else
    if not torso:FindFirstChild("MusicRuin") then
      soundz = Instance.new("Sound", torso)
    end
    soundz.MaxDistance = 150*5
    soundz.EmitterSize = 150/5
    soundz.Volume = 10
    soundz.Name = "MusicRuin"
    soundz.Looped = true
    soundz.PlaybackSpeed = pitch
    soundz.SoundId = "rbxassetid://"..id
    soundz:Stop()
    soundz:Play()
  end
end

function lerp(a, b, t)
  return a + (b - a)*t
end

function Lerp(c1, c2, al)
  local com1 = {c1.X, c1.Y, c1.Z, c1:toEulerAnglesXYZ()}
  local com2 = {c2.X, c2.Y, c2.Z, c2:toEulerAnglesXYZ()}
  for i, v in pairs(com1) do
    com1[i] = v + (com2[i]-v)*al
  end
  return CFrame.new(com1[1],com1[2],com1[3]) * CFrame.Angles(select(4,unpack(com1)))
end

function slerp(a, b, t)
  dot = a:Dot(b)
  if dot > 0.99999 or dot < -0.99999 then
    return t <= 0.5 and a or b
  else
    r = math.acos(dot)
    return (a*math.sin((1-t)*r) + b*math.sin(t*r)) / math.sin(r)
  end
end

function clerp(c1, c2, al)
  local com1 = {c1.X, c1.Y, c1.Z, c1:toEulerAnglesXYZ()}
  local com2 = {c2.X, c2.Y, c2.Z, c2:toEulerAnglesXYZ()}
  for i, v in pairs(com1) do
    com1[i] = lerp(v, com2[i], al)
  end
  return CFrame.new(com1[1],com1[2],com1[3]) * CFrame.Angles(select(4,unpack(com1)))
end

function computeDirection(vec)
  local lenSquared = vec.magnitude * vec.magnitude
  local invSqrt = 1 / math.sqrt(lenSquared)
  return Vector3.new(vec.x * invSqrt, vec.y * invSqrt, vec.z * invSqrt)
end

function newWeld(wp0, wp1, wc0x, wc0y, wc0z)
  local wld = Instance.new("Weld", wp1)
  wld.Part0 = wp0
  wld.Part1 = wp1
  wld.C0 = CFrame.new(wc0x, wc0y, wc0z)
  return wld
end

function weldModel(model)
	local parts, last = {}
	local function scan(parent)
		for _, v in pairs(parent:GetChildren()) do
			if v:IsA("BasePart") then
				if last then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0, w.Part1 = last, v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts, v)
			end
			scan(v)
		end
	end
	scan(model)
	for _, v in pairs(parts) do
		v.Anchored = false
		v.Locked = true
	end
end

function sound(id, position, vol, pitch, dist, start, finish)
  coroutine.resume(coroutine.create(function()
    local part = Instance.new("Part", DebrisModel)
    part.Anchored = true
    part.Position = position
    part.Size = Vector3.new(0,0,0)
    part.CanCollide = false
    part.Transparency = 1
    local soundasd = Instance.new("Sound", part)
    soundasd.SoundId = "rbxassetid://"..id
    if vol ~= nil then soundasd.Volume = vol end
    if pitch ~= nil then soundasd.PlaybackSpeed = pitch end
    if dist ~= nil then
      soundasd.MaxDistance = dist*5
      soundasd.EmitterSize = dist/5
    end
    delay(0.5, function() debris:AddItem(part, soundasd.TimeLength+3) end)
    soundasd:Play()
  end))
end

local HBill = Instance.new("BillboardGui", hed)
local HMain = Instance.new("Frame", HBill)
HBill.Size = UDim2.new(15,0,2.2,0)
HBill.StudsOffset = Vector3.new(3.675,1.2,0)
HBill.AlwaysOnTop = true
HBill.Enabled = true
HMain.BackgroundTransparency = 1
HMain.Size = UDim2.new(.5,0,.2,0)
local HName = Instance.new("TextLabel", HMain)
HName.BackgroundTransparency = 1
HName.Size = UDim2.new(1,0,.75,0)
HName.Font = "Code"
HName.Text = [[( Dream!Tale )]]
HName.TextScaled = true
HName.TextColor3 = Color3.new(244,255,25)
HName.TextStrokeColor3 = Color3.new(0.1,0.1,0.1)
HName.TextStrokeTransparency = 0
HName.TextYAlignment = "Bottom"

local HBill2 = Instance.new("BillboardGui", hed)
local HMain2 = Instance.new("Frame", HBill2)
HBill2.Size = UDim2.new(15,0,2.2,0)
HBill2.StudsOffset = Vector3.new(3.675,2,0)
HBill2.AlwaysOnTop = true
HBill2.Enabled = true
HMain2.BackgroundTransparency = 1
HMain2.Size = UDim2.new(.5,0,.5,0)
local HName2 = Instance.new("TextLabel", HMain2)
HName2.BackgroundTransparency = 1
HName2.Size = UDim2.new(1,0,.75,0)
HName2.Font = "Antique"
HName2.Text = [[Nightmare!Sans]]
HName2.TextScaled = true
HName2.TextColor3 = Color3.new(0,0,0)
HName2.TextStrokeColor3 = Color3.new(0,0,0)
HName2.TextStrokeTransparency = 0
HName2.TextYAlignment = "Bottom"

-- VISUAL-ONLY explosion projectile: spawns effects, damages nothing.
function bigboomrektxd()
  coroutine.resume(coroutine.create(function()
    local Position
    if animid == 0 then Position = larm.Position else Position = rarm.Position end
    sound(440145223, Position, 10, math.random(10,12)/10, 50)

    local Part1 = Instance.new("Part")
    local mesh2 = Instance.new("SpecialMesh", Part1)
    mesh2.MeshId = "rbxassetid://559831844"
    mesh2.Scale = Vector3.new(0,0,0.4)
    Part1.Material = Enum.Material.Neon
    Part1.CanCollide = false
    Part1.Color = Color3.fromHSV(0,0,main.v)
    Part1.Parent = DebrisModel
    Part1.Size = Vector3.new(0,0,0)
    Part1.Anchored = true
    Part1.CFrame = CFrame.new(Position, mouse.Hit.p)
    Part1.Name = "EXPLOSION2"

    local Part0 = Instance.new("Part", DebrisModel)
    local PointLight2 = Instance.new("PointLight")
    Part0.Name = "Bullet"
    Part0.Material = Enum.Material.Neon
    Part0.Color = Color3.fromHSV(0,0,main.v)
    Part0.Anchored = false
    Part0.Size = Vector3.new(5, 5, 5)
    local mesh = Instance.new("SpecialMesh", Part0)
    mesh.MeshType = Enum.MeshType.Sphere
    local bforce = Instance.new("BodyForce", Part0)
    bforce.force = Vector3.new(0, ((bforce.Parent:getMass())*workspace.Gravity), 0)
    Part0.CanCollide = false
    PointLight2.Parent = Part0
    PointLight2.Color = Part0.Color
    local Target = mouse.Hit.p
    local direction = computeDirection(Target - Position)
    local pos = Position + (direction * 2)
    Part0.CFrame = CFrame.new(pos, pos + direction) * CFrame.Angles((math.pi/2)+math.rad(180), 0, 0)
    Part0.Velocity = direction * 60

    local loop = nil
    delay(5, function() Part0:Destroy() if loop then loop:disconnect() end end)
    loop = rs:connect(function()
      local asdf = math.random(500,1000)/1000
      local smoke = Instance.new("Part")
      local m = Instance.new("SpecialMesh", smoke)
      m.MeshType = Enum.MeshType.Sphere
      smoke.Material = Enum.Material.Neon
      smoke.CanCollide = false
      smoke.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
      smoke.Parent = DebrisModel
      smoke.Size = Part0.Size + Vector3.new(asdf,asdf,asdf)
      smoke.Anchored = true
      smoke.CFrame = CFrame.new(Part0.Position + Vector3.new(math.random(-1000,1000)/750, math.random(-1000,1000)/750, math.random(-1000,1000)/750))
      smoke.Name = "SMOKE"
    end)

    -- On contact: burst visuals only. No damage, no knockback on other players.
    Part0.Touched:connect(function(ht)
      if ht.CanCollide ~= true then return end
      if ht:IsDescendantOf(char) then return end
      loop:disconnect()
      local hitpos = Part0.Position
      Part0:Destroy()
      sound(explosionid[math.random(1,#explosionid)], hitpos, 10, math.random(6,9)/10, 200)
      for i=1,14,2 do for x=1,math.random(0,1) do rs:wait() end
        for z=1,math.random(2,3) do
          local asdf = math.random(-5,5)*10-(i/20)*8
          local e = Instance.new("Part")
          local m = Instance.new("SpecialMesh", e)
          m.MeshType = Enum.MeshType.Sphere
          m.Scale = Vector3.new(0,0,0)
          e.Material = Enum.Material.Neon
          e.CanCollide = false
          e.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
          e.Parent = DebrisModel
          e.Size = Vector3.new(asdf,asdf,asdf)
          e.Anchored = true
          local a = i*0.5
          e.CFrame = CFrame.new(hitpos + Vector3.new(math.random(-2,2)*a, math.random(-10,10), math.random(-2,2)*a))
          e.Name = "EXPLOSION"
        end
      end
    end)
  end))
end

holdclick = false
mouse.Button1Down:connect(function()
  if debounce then return end
  animid = (animid == 0) and 1 or 0
  debounce = true
  holdclick = true
  aiming_anim = true
  wait(0.2)
  repeat rs:wait() timer = 150 until holdclick == false
  bigboomrektxd()
  local direction = computeDirection(root.Position - mouse.Hit.p)
  root.Velocity = direction * 150
  aiming_anim = false
  delay(0.3, function() debounce = false end)
end)
mouse.Button1Up:connect(function() holdclick = false end)

function dashasdf()
  debounce = true
  canjump = false
  attack = true
  for _, v in pairs(char:GetChildren()) do
    if v ~= root then
      if v:IsA("Part") then v.Transparency = 1
      elseif v:IsA("Accoutrement") and v:FindFirstChildOfClass("Part") then v:FindFirstChildOfClass("Part").Transparency = 1 end
    end
  end
  local tempattachment = Instance.new("Attachment", root)
  tempattachment.Position = Vector3.new(0,0,-4)
  for i=1,20 do rs:wait()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = CFrame.new(tempattachment.WorldPosition) * CFrame.Angles(math.rad(root.Orientation.X), math.rad(root.Orientation.Y), math.rad(root.Orientation.Z))
    local asdf = math.random(500,1000)/100
    local s = Instance.new("Part")
    local m = Instance.new("SpecialMesh", s)
    m.MeshType = Enum.MeshType.Sphere
    s.Material = Enum.Material.Neon
    s.CanCollide = false
    s.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
    s.Parent = DebrisModel
    s.Size = Vector3.new(asdf,asdf,asdf)
    s.Anchored = true
    s.CFrame = CFrame.new(root.Position + Vector3.new(math.random(-1000,1000)/500, math.random(-1000,1000)/500, math.random(-1000,1000)/500))
    s.Name = "SMOKE"
  end
  tempattachment:Destroy()
  for _, v in pairs(char:GetChildren()) do
    if v ~= root then
      if v:IsA("Part") then v.Transparency = 0
      elseif v:IsA("Accoutrement") and v:FindFirstChildOfClass("Part") then v:FindFirstChildOfClass("Part").Transparency = 0 end
    end
  end
  canjump = true
  attack = false
  delay(0.1, function() debounce = false end)
end

-- VISUAL-ONLY beam: draws the laser, damages nothing.
function laz0r()
  local Position
  if animid == 0 then Position = larm.Position else Position = rarm.Position end

  local Part1 = Instance.new("Part")
  local mesh2 = Instance.new("SpecialMesh", Part1)
  mesh2.MeshId = "rbxassetid://559831844"
  mesh2.Scale = Vector3.new(0,0,0.4)
  Part1.Material = Enum.Material.Neon
  Part1.CanCollide = false
  Part1.Color = Color3.fromHSV(0,0,main.v)
  Part1.Parent = DebrisModel
  Part1.Size = Vector3.new(0,0,0)
  Part1.Anchored = true
  Part1.CFrame = CFrame.new(Position, mouse.Hit.p)
  Part1.Name = "EXPLOSION3"

  local Part0 = Instance.new("Part", DebrisModel)
  Part0.Name = "Bullet"
  Part0.Material = Enum.Material.Neon
  Part0.Color = Color3.fromHSV(0,0,main.v)
  Part0.Anchored = true
  local mesh = Instance.new("SpecialMesh", Part0)
  mesh.MeshType = Enum.MeshType.Sphere
  Part0.CanCollide = false

  local Target = mouse.Hit.p
  local ray = Ray.new(Position, (Target-Position).unit*1048)
  local part, endPoint = workspace:FindPartOnRay(ray, char)
  Part0.Size = Vector3.new(5,1,5)
  mesh.Scale = Vector3.new(1,(Position-endPoint).magnitude,1)
  local direction = computeDirection(Target - Position)
  local pos = Position + (direction * (mesh.Scale.Y/2))
  Part0.CFrame = CFrame.new(pos, pos + direction) * CFrame.Angles((math.pi/2)+math.rad(180), 0, 0)

  sound(1177475476, Position, 10, math.random(5,6)/10, 300)

  local z = 10
  for i = 1,100 do rs:wait()
    if animid == 0 then Position = larm.Position else Position = rarm.Position end
    local T2 = mouse.Hit.p
    local dir2 = computeDirection(T2 - Position)
    local ray2 = Ray.new(Position, (T2-Position).unit*1048)
    local part2, endPoint2 = workspace:FindPartOnRay(ray2, char)
    Part0.Size = Vector3.new(5-((i/100)*5),1,5-((i/100)*5))
    mesh.Scale = Vector3.new(1,(Position-endPoint2).magnitude,1)
    mesh.Offset = Vector3.new(math.random(-10000,10000)/20000, math.random(-10000,10000)/20000, 0)
    local pos2 = Position + (dir2 * (mesh.Scale.Y/2))
    Part0.CFrame = CFrame.new(pos2, pos2 + dir2) * CFrame.Angles((math.pi/2)+math.rad(180), 0, 0)

    local dir3 = computeDirection(root.Position - T2)
    root.Velocity = dir3 * 5

    if i >= z then z = i + 10 sound(explosionid[math.random(1,#explosionid)], endPoint2, 10, math.random(6,9)/10, 200) end

    local clone = Part0:Clone()
    clone.Parent = DebrisModel
    clone.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
    clone.Name = "SMOKE2"

    -- Visual sparkle at impact point (no damage)
    local asdf = math.random(0,5)*10
    local e = Instance.new("Part")
    local m = Instance.new("SpecialMesh", e)
    m.MeshType = Enum.MeshType.Sphere
    m.Scale = Vector3.new(0,0,0)
    e.Material = Enum.Material.Neon
    e.CanCollide = false
    e.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
    e.Parent = DebrisModel
    e.Size = Vector3.new(asdf,asdf,asdf)
    e.Anchored = true
    local a = 1.5
    e.CFrame = CFrame.new(endPoint2 + Vector3.new(math.random(-2,2)*a, math.random(-4,4), math.random(-2,2)*a))
    e.Name = "EXPLOSION"
  end
  Part0:Destroy()
  wait(0.3)
  aiming_anim = false
  delay(0.3, function() debounce = false end)
end

-- VISUAL-ONLY big projectile: same as bigboomrektxd but larger/slower.
function nukewelpo()
  coroutine.resume(coroutine.create(function()
    local Position
    if animid == 0 then Position = larm.Position else Position = rarm.Position end
    sound(440145223, Position, 10, math.random(4,5)/10, 100)

    local Part1 = Instance.new("Part")
    local mesh2 = Instance.new("SpecialMesh", Part1)
    mesh2.MeshId = "rbxassetid://559831844"
    mesh2.Scale = Vector3.new(0,0,0.4)
    Part1.Material = Enum.Material.Neon
    Part1.CanCollide = false
    Part1.Color = Color3.fromHSV(0,0,main.v)
    Part1.Parent = DebrisModel
    Part1.Size = Vector3.new(0,0,0)
    Part1.Anchored = true
    Part1.CFrame = CFrame.new(Position, mouse.Hit.p)
    Part1.Name = "EXPLOSION3"

    local Part0 = Instance.new("Part", DebrisModel)
    local PointLight2 = Instance.new("PointLight")
    Part0.Name = "Bullet"
    Part0.Material = Enum.Material.Neon
    Part0.Color = Color3.fromHSV(0,0,main.v)
    Part0.Anchored = false
    Part0.Size = Vector3.new(5, 5, 5)
    local mesh = Instance.new("SpecialMesh", Part0)
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(3,3,3)
    local bforce = Instance.new("BodyForce", Part0)
    bforce.force = Vector3.new(0, ((bforce.Parent:getMass())*workspace.Gravity), 0)
    Part0.CanCollide = false
    PointLight2.Parent = Part0
    PointLight2.Color = Part0.Color

    local Target = mouse.Hit.p
    local direction = computeDirection(Target - Position)
    local pos = Position + (direction * 2)
    Part0.CFrame = CFrame.new(pos, pos + direction) * CFrame.Angles((math.pi/2)+math.rad(180), 0, 0)
    Part0.Velocity = direction * 150

    local loop = nil
    delay(5, function() Part0:Destroy() if loop then loop:disconnect() end end)
    loop = rs:connect(function()
      local asdf = math.random(500,1000)/1000
      local smoke = Instance.new("Part")
      local m = Instance.new("SpecialMesh", smoke)
      m.MeshType = Enum.MeshType.Sphere
      smoke.Material = Enum.Material.Neon
      smoke.CanCollide = false
      smoke.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
      smoke.Parent = DebrisModel
      smoke.Size = (Part0.Size*3) + Vector3.new(asdf,asdf,asdf)
      smoke.Anchored = true
      smoke.CFrame = CFrame.new(Part0.Position + Vector3.new(math.random(-3000,3000)/750, math.random(-3000,3000)/750, math.random(-3000,3000)/750))
      smoke.Name = "SMOKE"
    end)

    Part0.Touched:connect(function(ht)
      if ht.CanCollide ~= true then return end
      if ht:IsDescendantOf(char) then return end
      loop:disconnect()
      local hitpos = Part0.Position
      Part0:Destroy()
      sound(explosionid[math.random(1,#explosionid)], hitpos, 10, math.random(3,5)/10, 500)
      for i=1,10,0.5 do for x=1,math.random(0,1) do rs:wait() end
        for z=1,math.random(2,3) do
          local asdf = math.random(-5,5)*10-(i/20)*12
          local e = Instance.new("Part")
          local m = Instance.new("SpecialMesh", e)
          m.MeshType = Enum.MeshType.Sphere
          m.Scale = Vector3.new(0,0,0)
          e.Material = Enum.Material.Neon
          e.CanCollide = false
          e.Color = Color3.fromHSV(Color3.toHSV(main_color), math.random(0,10000)/10000, main.v)
          e.Parent = DebrisModel
          e.Size = Vector3.new(asdf,asdf,asdf)
          e.Anchored = true
          local a = i*5
          e.CFrame = CFrame.new(hitpos + Vector3.new(math.random(-2,2)*a, math.random(-30,30), math.random(-2,2)*a))
          e.Name = "EXPLOSION4"
        end
      end
    end)
  end))
end

holdq = false
holdr = false
cooldownult = false

mouse.KeyDown:connect(function(key)
  if debounce then return end
  key = key:lower()
  if key == "e" then
    dashasdf()
  elseif key == "r" and not cooldownult then
    cooldownult = true
    animid = (animid == 0) and 1 or 0
    debounce = true
    holdr = true
    aiming_anim = true
    wait(0.2)
    repeat rs:wait() timer = 150 until holdr == false
    nukewelpo()
    root.Velocity = computeDirection(root.Position - mouse.Hit.p) * 300
    aiming_anim = false
    delay(5, function() cooldownult = false end)
    delay(1, function() debounce = false end)
  elseif key == "q" then
    debounce = true
    animid = (animid == 0) and 1 or 0
    holdq = true
    attack = true
    aiming_anim = true
    repeat rs:wait() timer = 150 until holdq == false
    laz0r()
    attack = false
  end
end)
mouse.KeyUp:connect(function(key)
  key = key:lower()
  if key == "q" then holdq = false
  elseif key == "r" then holdr = false end
end)

music(themeid, themepitch)

velocityYFall=0; velocityYFall2=0; velocityYFall3=0; velocityYFall4=0
neckrotY=0; neckrotY2=0; torsorotY=0; torsorotY2=0; torsoY=0; torsoY2=0
sine = 0
newWeld(torso, larm, -1.5, 0.5, 0); larm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, rarm, 1.5, 0.5, 0); rarm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, hed, 0, 1.5, 0)
newWeld(torso, lleg, -0.5, -1, 0); lleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(torso, rleg, 0.5, -1, 0); rleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(root, torso, 0, -1, 0); torso.Weld.C1 = CFrame.new(0, -1, 0)

rs:connect(function()
  bg.MaxTorque = Vector3.new(0,0,0)
  for i,v in pairs(DebrisModel:GetChildren()) do
    if v.Name == "EXPLOSION" then
      local ch = 0.04-(v.Transparency*0.02)
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      if vm then vm.Scale = vm.Scale + Vector3.new(ch,ch,ch) end
      v.Transparency = v.Transparency + 0.02
      if v.Transparency >= 1 then v:Destroy() end
    elseif v.Name == "EXPLOSION2" then
      local ch = 0.04-(v.Transparency*0.04)
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      if vm then vm.Scale = vm.Scale + Vector3.new(ch,ch,0) end
      v.Transparency = v.Transparency + 0.025
      if v.Transparency >= 1 then v:Destroy() end
    elseif v.Name == "EXPLOSION3" then
      local ch = 0.5-(v.Transparency*0.5)
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      if vm then vm.Scale = vm.Scale + Vector3.new(ch,ch,0) end
      v.Transparency = v.Transparency + 0.1
      if v.Transparency >= 1 then v:Destroy() end
    elseif v.Name == "EXPLOSION4" then
      local ch = 0.15-(v.Transparency*0.125)
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      if vm then vm.Scale = vm.Scale + Vector3.new(ch,ch,ch) end
      v.Transparency = v.Transparency + 0.01
      if v.Transparency >= 1 then v:Destroy() end
    elseif v.Name == "SMOKE" then
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      if vm then
        vm.Scale = vm.Scale - Vector3.new(0.075,0.075,0.075)
        if vm.Scale.X <= 0 then v:Destroy() end
      end
    elseif v.Name == "SMOKE2" then
      local ch = 2-(v.Transparency*2)
      local vm = v:FindFirstChildOfClass("SpecialMesh")
      local Position
      if animid == 0 then Position = larm.Position else Position = rarm.Position end
      local Target = mouse.Hit.p
      local direction = computeDirection(Target - Position)
      local ray = Ray.new(Position, (Target-Position).unit*1048)
      local part, endPoint = workspace:FindPartOnRay(ray, char)
      if vm then
        vm.Scale = Vector3.new(vm.Scale.X,(Position-endPoint).magnitude,vm.Scale.Z) + Vector3.new(ch,0,ch)
      end
      local pos = Position + (direction * ((vm and vm.Scale.Y or 1)/2))
      v.CFrame = CFrame.new(pos, pos + direction) * CFrame.Angles((math.pi/2)+math.rad(180), 0, 0)
      if vm then vm.Offset = Vector3.new(math.random(-10000,10000)/10000, math.random(-10000,10000)/10000, 0) end
      v.Transparency = v.Transparency + 0.1
      if v.Transparency >= 1 then v:Destroy() end
    end
  end

  if -root.Velocity.Y/1.5 > 0 and -root.Velocity.Y/1.5 < 160 then velocityYFall = root.Velocity.Y/1.5 end
  if -root.Velocity.Y/180 > 0 and -root.Velocity.Y/180 < 1.2 then velocityYFall2 = root.Velocity.Y/180 end
  if -root.Velocity.Y/1.5 > -5 and -root.Velocity.Y/1.5 < 50 then velocityYFall3 = root.Velocity.Y/1.5 end
  if -root.Velocity.Y/1.5 > -50 and -root.Velocity.Y/1.5 < 20 then velocityYFall4 = root.Velocity.Y/1.5 end
  if root.RotVelocity.Y/6 < 1 and root.RotVelocity.Y/6 > -1 then neckrotY = root.RotVelocity.Y/6 end
  if root.RotVelocity.Y/8 < 0.6 and root.RotVelocity.Y/8 > -0.6 then neckrotY2 = root.RotVelocity.Y/8 end
  if root.RotVelocity.Y/6 < 0.2 and root.RotVelocity.Y/6 > -0.2 then torsorotY = root.RotVelocity.Y/6 end
  if root.RotVelocity.Y/8 < 0.2 and root.RotVelocity.Y/8 > -0.2 then torsorotY2 = root.RotVelocity.Y/8 end
  torsoY = -(torso.Velocity*Vector3.new(1, 0, 1)).magnitude/20
  torsoY2 = -(torso.Velocity*Vector3.new(1, 0, 1)).magnitude/36

  hum.WalkSpeed = attack and 1 or 20
  hum.JumpPower = canjump and 50 or 0

  local jumped = false
  local r1 = workspace:FindPartOnRay(Ray.new(root.Position+Vector3.new(1,0,0),Vector3.new(0, -6, 0)), char)
  local r2 = workspace:FindPartOnRay(Ray.new(root.Position-Vector3.new(1,0,0),Vector3.new(0, -6, 0)), char)
  local r3 = workspace:FindPartOnRay(Ray.new(root.Position+Vector3.new(0,0,0.5),Vector3.new(0, -6, 0)), char)
  local r4 = workspace:FindPartOnRay(Ray.new(root.Position-Vector3.new(0,0,0.5),Vector3.new(0, -6, 0)), char)
  if not (r1 or r2 or r3 or r4) then jumped = true end

  local rlegray = Ray.new(rleg.Position+Vector3.new(0,0.5,0),Vector3.new(0, -1.75, 0))
  local rlegpart, rlegendPoint = workspace:FindPartOnRay(rlegray, char)
  local llegray = Ray.new(lleg.Position+Vector3.new(0,0.5,0),Vector3.new(0, -1.75, 0))
  local llegpart, llegendPoint = workspace:FindPartOnRay(llegray, char)

  if no_anim == false and hum.Health > 0 then
    if (torso.Velocity*Vector3.new(1, 0, 1)).magnitude >= 5 and not jumped then
      hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0,1.5,-.2)*CFrame.Angles(math.rad(-18),math.rad(0+math.rad(0+2*math.cos(sine/2))),0), 0.1)
      hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(math.rad(-10),0,0),0.1)
      rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.62-(movement/30)*math.cos(sine/4)/2,(movement/50)*math.cos(sine/4))*CFrame.Angles(math.rad(-5-(movement*2)*math.cos(sine/4))+ -(movement/10)*math.sin(sine/4),math.rad(0-(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
      larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.62+(movement/30)*math.cos(sine/4)/2,-(movement/50)*math.cos(sine/4))*CFrame.Angles(math.rad(-5+(movement*2)*math.cos(sine/4))+ (movement/10)*math.sin(sine/4),math.rad(0-(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
      torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1+(movement/20)*math.cos(sine/2), 0) * CFrame.Angles(math.rad(-(change*20)-4*math.cos(sine/2)), torsorotY2+math.rad(0-4*math.cos(sine/4)), torsorotY2+math.rad(0-1*math.cos(sine/4))), 0.1)
      lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5,-0.85-(movement/10)*math.cos(sine/4)/2,-0.1+(movement/15)*math.cos(sine/4))*CFrame.Angles(math.rad(-10+(change*5)-movement*math.cos(sine/4))+ -(movement/10)*math.sin(sine/4),math.rad(0+(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
      rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0.5,-0.85+(movement/10)*math.cos(sine/4)/2,-0.1-(movement/15)*math.cos(sine/4))*CFrame.Angles(math.rad(-10+(change*5)+movement*math.cos(sine/4))+ (movement/10)*math.sin(sine/4),math.rad(0+(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
    elseif jumped then
      hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0,1.5,-.2)*CFrame.Angles(math.rad(-18),math.rad(0+math.rad(0+2*math.cos(sine/2))),0), 0.1)
      hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0,0,0),0.1)
      larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,1-0.1*math.cos(sine/16)/2,0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(0-1*math.cos(sine/16)),math.rad(-50-1*math.cos(sine/8))), 0.2)
      rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,1-0.1*math.cos(sine/16)/2,0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(0-1*math.cos(sine/16)),math.rad(50+1*math.cos(sine/8))), 0.2)
      torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1-0.1*math.cos(sine/16), 0) * CFrame.Angles(math.rad(0-2*math.cos(sine/16)),math.rad(0), math.rad(0-1*math.cos(sine/32))), 0.1)
      lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5,-0.925+0.1*math.cos(sine/16),0)*CFrame.Angles(math.rad(-35-1*math.cos(sine/16)),math.rad(0-1*math.cos(sine/16)),math.rad(-2-0.5*math.cos(sine/8))), 0.2)
      rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0.5,0+0.1*math.cos(sine/16),-0.8)*CFrame.Angles(math.rad(-25+1*math.cos(sine/16)),math.rad(0-1*math.cos(sine/16)),math.rad(2+0.5*math.cos(sine/8))), 0.2)
    else
      hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0,1.5,-.1)*CFrame.Angles(math.rad(-18),math.rad(0+math.rad(0+2*math.cos(sine/2))),0), 0.1)
      hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(math.rad(-15),0,0),0.1)
      larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.55-0.1*math.cos(sine/16)/2,-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(0-1*math.cos(sine/16)),math.rad(-5-1*math.cos(sine/8))), 0.2)
      rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.55-0.1*math.cos(sine/16)/2,-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(0-1*math.cos(sine/16)),math.rad(5+1*math.cos(sine/8))), 0.2)
      torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1.1-0.1*math.cos(sine/16), 0) * CFrame.Angles(math.rad(0-2*math.cos(sine/16)),math.rad(0), math.rad(0-1*math.cos(sine/32))), 0.1)
      lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(0,llegendPoint.Y-lleg.Position.Y,0)*CFrame.new(-0.5,0+0.1*math.cos(sine/16),0)*CFrame.Angles(math.rad(0-1*math.cos(sine/16)),math.rad(0-1*math.cos(sine/16)),math.rad(-2-0.5*math.cos(sine/8))), 0.2)
      rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0,rlegendPoint.Y-rleg.Position.Y,0)*CFrame.new(0.5,0+0.1*math.cos(sine/16),0)*CFrame.Angles(math.rad(0+1*math.cos(sine/16)),math.rad(0-1*math.cos(sine/16)),math.rad(2+0.5*math.cos(sine/8))), 0.2)
    end
    for i=1,5 do
      if aiming_anim then
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        if not jumped then
          bg.CFrame = CFrame.new(root.Position, Vector3.new(mouse.Hit.x, root.Position.Y, mouse.Hit.z))
        else
          bg.CFrame = CFrame.new(root.Position, mouse.Hit.p)
        end
        if animid == 0 then
          hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0,math.rad(-80),0), 0.4)
          torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1.1-0.1*math.cos(sine/16), 0) * CFrame.Angles(math.rad(0-2*math.cos(sine/16)),math.rad(-80), math.rad(0-1*math.cos(sine/32))), 0.2)
          larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.55-0.1*math.cos(sine/16)/2,-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(-10-1*math.cos(sine/16)),math.rad(-90-1*math.cos(sine/8))), 0.4)
        else
          hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0,math.rad(80),0), 0.4)
          torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1.1-0.1*math.cos(sine/16), 0) * CFrame.Angles(math.rad(0-2*math.cos(sine/16)),math.rad(80), math.rad(0-1*math.cos(sine/32))), 0.2)
          rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.55-0.1*math.cos(sine/16)/2,-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(0),math.rad(10-1*math.cos(sine/16)),math.rad(90+1*math.cos(sine/8))), 0.4)
        end
      else
        if timer <= 0 then animid = math.random(0,1) else timer = timer - 1 end
      end
    end
  end
  main_color = Color3.fromRGB(main.r, main.g, main.b)
  HName.TextStrokeColor3 = Color3.fromHSV(Color3.toHSV(main_color),1,main.v/2)
  HName.TextColor3 = Color3.fromHSV(Color3.toHSV(main_color),1,main.v)
  sine = sine + change
  if hum.Health <= 0 then debounce = true end
end)

-- Intro chatter (local, visual only)
local talksound = Instance.new("Sound", torso)
talksound.SoundId = "rbxassetid://928210219"
talksound.Volume = 4

local function chatfunc(text)
  coroutine.wrap(function()
    if char:FindFirstChild("TalkingBillBoard") then char:FindFirstChild("TalkingBillBoard"):Destroy() end
    local bb = Instance.new("BillboardGui", char)
    bb.Size = UDim2.new(0,100,0,40)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.Adornee = hed
    bb.Name = "TalkingBillBoard"
    local t2 = Instance.new("TextLabel", bb)
    t2.BackgroundTransparency = 1
    t2.BorderSizePixel = 0
    t2.Font = "Fantasy"
    t2.TextSize = 30
    t2.TextStrokeTransparency = 0
    t2.TextColor3 = Color3.new(.6,0,0)
    t2.TextStrokeColor3 = Color3.new(0,0,0)
    t2.Size = UDim2.new(1,0,0.5,0)
    local t3 = Instance.new("TextLabel", bb)
    t3.BackgroundTransparency = 1
    t3.BorderSizePixel = 0
    t3.Font = "Fantasy"
    t3.TextSize = 30
    t3.TextStrokeTransparency = 0
    t3.TextColor3 = Color3.new(0,0,0)
    t3.TextStrokeColor3 = Color3.new(1,1,1)
    t3.Size = UDim2.new(1,0,0.5,0)
    for i = 1, string.len(text), 1 do
      t2.Text = string.sub(text,1,i)
      t3.Text = string.sub(text,1,i)
      talksound:Play()
      wait(0.01)
    end
    wait(2)
    for i = 1, 50 do
      rs:wait()
      t2.Position = t2.Position - UDim2.new(math.random(-.4,.4),math.random(-5,5),.05,math.random(-5,5))
      t2.Rotation = t2.Rotation - .8
      t2.TextStrokeTransparency = t2.TextStrokeTransparency + .04
      t2.TextTransparency = t2.TextTransparency + .04
      t3.Position = t2.Position - UDim2.new(math.random(-.4,.4),math.random(-5,5),.05,math.random(-5,5))
      t3.Rotation = t2.Rotation + .8
      t3.TextStrokeTransparency = t2.TextStrokeTransparency + .04
      t3.TextTransparency = t2.TextTransparency + .04
    end
    bb:Destroy()
  end)()
end

wait(2) chatfunc("It's a beautiful night in void..")
wait(2) chatfunc("Black is rising...")
wait(2) chatfunc("Dream!Sans is dying....")
wait(2) chatfunc("On days like these... Chara like you...")
wait(2) chatfunc("Should be erasing in hell.")
