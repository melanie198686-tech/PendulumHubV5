--[[
	Studio Dummy v3 (FULLY FIXED)
	Original by Vulnerali
	Converted by padero
	Fixed for modern executors & Studio compatibility
	Noclip fix: map no longer filtered from raycasts + horizontal wall check added
	Invisible fix: removed transparency hide in _weld + added dynamic transparency updates
]]

if not getgenv then getgenv = function() return _G end end

local ok, err = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/newnetlessreanimate.lua",true))()
end)
if not ok then warn("[Dummy] Failed to load reanimate script.") end
if getgenv()._reanimate then pcall(getgenv()._reanimate) end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris     = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace  = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Torso = Character:FindFirstChild("Torso")
if not Torso then warn("[Dummy] R6 character required (Torso missing)"); return end
local Head = Character:FindFirstChild("Head")
local LeftArm = Character:FindFirstChild("Left Arm")
local LeftLeg = Character:FindFirstChild("Left Leg")
local RightArm = Character:FindFirstChild("Right Arm")
local RightLeg = Character:FindFirstChild("Right Leg")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

-- Hide the real character so it doesn't overlap with the dummy
for _, v in ipairs(Character:GetDescendants()) do
	if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
		v.Transparency = 1
		v.CanCollide = false
	end
	if v:IsA("Decal") then
		v.Transparency = 1
	end
end

-- Asset Fallback
local folder
local success, fetched = pcall(function() return game:GetObjects('rbxassetid://10012397982')[1] end)
if not success or not fetched then
	warn("[Dummy] Failed to load asset. Creating fallback dummy parts...")
	folder = Instance.new("Folder")
	folder.Name = "DummyAsset"

	local function makePart(name, color)
		local p = Instance.new("Part", folder)
		p.Name = name
		p.Size = Vector3.new(1,1,1)
		p.Color = color or Color3.fromRGB(163,162,165)
		p.Transparency = 1
		p.CanCollide = false
		return p
	end

	makePart("t"); makePart("h"); makePart("limb"); makePart("gun"); makePart("shock")

	local chat = makePart("chat")
	local chattemplate = Instance.new("BillboardGui", folder)
	chattemplate.Name = "chattemplate"
	local frame = Instance.new("Frame", chattemplate)
	frame.Name = "chatbox"
	local input = Instance.new("TextBox", chattemplate)
	input.Name = "input"
else
	folder = fetched
end
folder.Parent = Character

local plrs, run, insert, debris, ws, ts, uis = Players, RunService, game:GetService("InsertService"), Debris, Workspace, TweenService, UserInputService
local cn, euler, rad, random, c3, v3, clamp, sin, cos = CFrame.new, CFrame.fromEulerAnglesYXZ, math.rad, math.random, Color3.fromRGB, Vector3.new, math.clamp, math.sin, math.cos
local localplayer, userid = LocalPlayer, LocalPlayer.UserId
local username, mouse, localuserid = localplayer.Name, localplayer:GetMouse(), localplayer.UserId

local c, r, h, t, la, ra, ll, rl, face, gun
local hc0, lac0, rac0, llc0, rlc0 = cn(0,1.5,0), cn(-1.5,0,0), cn(1.5,0,0), cn(-0.5,-2,0), cn(0.5,-2,0)
local sine, animspeed, attack, keys = 0, 1/4, false, {w=false,a=false,s=false,d=false,space=false}
local poscframe, ypos, yvelo = Torso.CFrame, 50, 0
local raycastparams, partexclusion, firstperson, moving, velocity = RaycastParams.new(), {}, false, false, v3()
local hoffset, toffset, laoffset, raoffset, lloffset, rloffset = hc0, cn(), lac0, rac0, llc0, rlc0
local gunoffset = cn(-0.125,-0.898999929,0.95400238)*euler(0,rad(90),rad(-172.5))

raycastparams.FilterType = Enum.RaycastFilterType.Blacklist
raycastparams.IgnoreWater = true

local cam = Workspace.CurrentCamera

function tween(instance, properties, duration, easingdirection, easingstyle)
	task.spawn(function()
		if easingstyle == nil then easingstyle = Enum.EasingStyle.Quad end
		ts:Create(instance, TweenInfo.new(duration, easingstyle, easingdirection), properties):Play()
	end)
end

function randomstring()
	local e = {}
	for i = 1, math.random(5,50) do table.insert(e, #e+1, utf8.char(math.random(10,100))) end
	return table.concat(e)
end

function change(instance, properties)
	for i, v in next, properties do instance[i] = v end
end

function create(class, properties)
	local instance = Instance.new(class)
	instance.Name = randomstring()
	change(instance, properties)
	return instance
end

local backups = {}
for i, v in next, folder:GetChildren() do
	if v:IsA("BasePart") or v:IsA("BillboardGui") then
		backups[v.Name] = v:Clone()
	end
end

if not backups.t then backups.t = create("Part", {Size=v3(2,2,1), Transparency=1, CanCollide=false}) end
if not backups.h then backups.h = create("Part", {Size=v3(2,1,1), Transparency=1, CanCollide=false}) end
if not backups.limb then backups.limb = create("Part", {Size=v3(1,2,1), Transparency=1, CanCollide=false}) end
if not backups.gun then backups.gun = create("Part", {Size=v3(2,1,2), Transparency=1, CanCollide=false, Material=Enum.Material.Neon}) end
if not backups.shock then backups.shock = create("Part", {Size=v3(1,1,1), Transparency=1, CanCollide=false, Material=Enum.Material.Neon}) end
if not backups.chat then backups.chat = create("Part", {Size=v3(8.625,5,0.125), Transparency=1, CanCollide=false}) end
if not backups.chattemplate then
	backups.chattemplate = create("BillboardGui", {Size=UDim2.new(10,0,10,0)})
end

function fix(instance, parent)
	if instance.Parent == parent then return true end
	local good = pcall(function() instance.Parent = parent end)
	return instance.Parent == parent
end

function checkpart(part,size,collisionfidelity,color,material,transparency,cancollide)
	return (not part or not fix(part,Character) or part.Parent ~= Character or part.Archivable or not part.Locked or part.CollisionGroupId ~= 0 or part.DoubleSided or part.LocalTransparencyModifier ~= 0)
end

function gettransparency(transparency)
	if firstperson then return 1 else return transparency end
end

-- Artificial Heartbeat
local hb = create("BindableEvent", {Name = "ArtificialHB"})
local frame = 1/120
local tf = 0
local allowframeloss = false
local tossremainder = false
local lastframe = tick()
hb:Fire()

local swaitcon = run.Heartbeat:Connect(function(s, p)
	tf += s
	if tf >= frame then
		if allowframeloss then
			hb:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do hb:Fire() end
			lastframe = tick()
		end
		if tossremainder then tf = 0 else tf = tf - frame * math.floor(tf / frame) end
	end
end)

function swait(j)
	if j == 0 or j == nil then
		for i = 1, 2 do hb.Event:Wait() end
	else
		for i = 1, j do hb.Event:Wait() end
	end
end

local chat, surfacegui
local chatting, chattext, chatinput, currentchatpos = false, "", nil, 0
local existingchatmsg = {}

function addtochat(name, msg)
	pcall(function()
		if not chatbox then return end
		local k = backups.chattemplate:Clone()
		k.Parent = chatbox
		if k:FindFirstChild("plrname") then k.plrname.Text = name end
		if k:FindFirstChild("txt") then k.txt.Text = msg end
		table.insert(existingchatmsg, {name, msg})
	end)
end

run:BindToRenderStep(username..userid.."partmaintain", Enum.RenderPriority.Camera.Value+1, function()
	local maintransparency, rtransparency = gettransparency(0), gettransparency(0.5)

	if checkpart(c, v3(1,1,1), Enum.CollisionFidelity.Box, c3(0,0,0), Enum.Material.SmoothPlastic, 1, false) then
		if table.find(partexclusion, c) then table.remove(partexclusion, table.find(partexclusion, c)) end
		debris:AddItem(c, 0)
		c = backups.t:Clone()
		c.Transparency = 1
		c.Color = c3(0,0,0)
		c.CanCollide = false
		c.Size = v3(1,1,1)
		c.Parent = Character
		c.Name = randomstring()
		c.Archivable = false
	end
	if not table.find(partexclusion, c) then table.insert(partexclusion, c) end

	if checkpart(r, v3(2,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, rtransparency, true) then
		if table.find(partexclusion, r) then table.remove(partexclusion, table.find(partexclusion, r)) end
		debris:AddItem(r, 0)
		r = backups.t:Clone()
		r.Transparency = 1
		r.Size = v3(2,2,1)
		r.Name = randomstring()
		r.Parent = Character
		r.Archivable = false
		r.CFrame = poscframe
		Character.Humanoid.Died:Connect(function() r:Destroy() end)
	end
	if not table.find(partexclusion, r) then table.insert(partexclusion, r) end

	if not h or not fix(h, Character) or h.Parent ~= Character or h.Archivable or not h.Locked then
		if table.find(partexclusion, h) then table.remove(partexclusion, table.find(partexclusion, h)) end
		debris:AddItem(h, 0)
		h = backups.h:Clone()
		h.Transparency = maintransparency
		h.Size = v3(2,1,1)
		h.Name = randomstring()
		h.Parent = Character
		h.CanCollide = false
		h.Archivable = false
	end
	if not table.find(partexclusion, h) then table.insert(partexclusion, h) end

	if checkpart(t, v3(2,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, maintransparency, true) then
		if table.find(partexclusion, t) then table.remove(partexclusion, table.find(partexclusion, t)) end
		debris:AddItem(t, 0)
		t = backups.t:Clone()
		t.Transparency = maintransparency
		t.Size = v3(2,2,1)
		t.Name = randomstring()
		t.Parent = Character
		t.Archivable = false
		t.CanCollide = false
	end
	if not table.find(partexclusion, t) then table.insert(partexclusion, t) end

	if checkpart(la, v3(1,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, maintransparency, true) then
		if table.find(partexclusion, la) then table.remove(partexclusion, table.find(partexclusion, la)) end
		debris:AddItem(la, 0)
		la = backups.limb:Clone()
		la.Transparency = maintransparency
		la.Size = v3(1,2,1)
		la.Name = randomstring()
		la.Parent = Character
		la.Archivable = false
		la.CanCollide = false
	end
	if not table.find(partexclusion, la) then table.insert(partexclusion, la) end

	if checkpart(ra, v3(1,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, maintransparency, true) then
		if table.find(partexclusion, ra) then table.remove(partexclusion, table.find(partexclusion, ra)) end
		debris:AddItem(ra, 0)
		ra = backups.limb:Clone()
		ra.Transparency = maintransparency
		ra.Size = v3(1,2,1)
		ra.Name = randomstring()
		ra.Parent = Character
		ra.Archivable = false
		ra.CanCollide = false
	end
	if not table.find(partexclusion, ra) then table.insert(partexclusion, ra) end

	if checkpart(ll, v3(1,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, maintransparency, true) then
		if table.find(partexclusion, ll) then table.remove(partexclusion, table.find(partexclusion, ll)) end
		debris:AddItem(ll, 0)
		ll = backups.limb:Clone()
		ll.Transparency = maintransparency
		ll.Size = v3(1,2,1)
		ll.Name = randomstring()
		ll.Parent = Character
		ll.Archivable = false
		ll.CanCollide = false
	end
	if not table.find(partexclusion, ll) then table.insert(partexclusion, ll) end

	if checkpart(rl, v3(1,2,1), Enum.CollisionFidelity.Box, c3(163,162,165), Enum.Material.SmoothPlastic, maintransparency, true) then
		if table.find(partexclusion, rl) then table.remove(partexclusion, table.find(partexclusion, rl)) end
		debris:AddItem(rl, 0)
		rl = backups.limb:Clone()
		rl.Transparency = maintransparency
		rl.Size = v3(1,2,1)
		rl.Name = randomstring()
		rl.Parent = Character
		rl.Archivable = false
		rl.CanCollide = false
	end
	if not table.find(partexclusion, rl) then table.insert(partexclusion, rl) end

	if checkpart(gun, v3(6.792,1.241,0.254), Enum.CollisionFidelity.PreciseConvexDecomposition, c3(163,162,165), Enum.Material.Neon, maintransparency, true) then
		if table.find(partexclusion, gun) then table.remove(partexclusion, table.find(partexclusion, gun)) end
		debris:AddItem(gun, 0)
		gun = backups.gun:Clone()
		gun.Transparency = maintransparency
		gun.Size = v3(6.792,1.241,0.254)
		gun.Name = randomstring()
		gun.Parent = Character
		gun.Archivable = false
		gun.CanCollide = false
	end
	if not table.find(partexclusion, gun) then table.insert(partexclusion, gun) end

	if checkpart(chat, v3(8.625,5,0.125), Enum.CollisionFidelity.Box, c3(), Enum.Material.SmoothPlastic, 0.5, false) then
		if table.find(partexclusion, chat) then table.remove(partexclusion, table.find(partexclusion, chat)) end
		debris:AddItem(chat, 0)
		chat = backups.t:Clone()
		chat.Color = c3()
		chat.Transparency = 0.5
		chat.Size = v3(8.625,5,0.125)
		chat.Name = randomstring()
		chat.Parent = Character
		chat.CanCollide = false
		chat.Archivable = false
		chat.CFrame = poscframe

		surfacegui = backups.chat:Clone()
		surfacegui.Parent = chat

		local foundInput = surfacegui:FindFirstChild("input")
		local foundBox = surfacegui:FindFirstChild("chatbox")
		chatinput = foundInput
		chatbox = foundBox

		if chatting and chatinput then
			chatinput.Text = chattext
			chatinput.Visible = true
			chatinput.Size = UDim2.new(1, -10,0, chatinput.TextBounds.Y)
		end
	end
	if not table.find(partexclusion, chat) then table.insert(partexclusion, chat) end
	
	-- FIX: Dynamically update transparency so parts stay visible and hide properly in first-person
	if h then h.Transparency = maintransparency end
	if t then t.Transparency = maintransparency end
	if la then la.Transparency = maintransparency end
	if ra then ra.Transparency = maintransparency end
	if ll then ll.Transparency = maintransparency end
	if rl then rl.Transparency = maintransparency end
	if gun then gun.Transparency = maintransparency end
	if chat then chat.Transparency = rtransparency end
	if c then c.Transparency = 1 end
	if r then r.Transparency = 1 end
end)

local attacks = {}
local ws_speed = 0.2

function attacks:refresh(pos)
	pcall(function()
		debris:AddItem(r,0); debris:AddItem(h,0); debris:AddItem(t,0); debris:AddItem(la,0)
		debris:AddItem(ra,0); debris:AddItem(ll,0); debris:AddItem(rl,0)
		debris:AddItem(chat,0); debris:AddItem(gun,0)
	end)
end

function attacks:hitbox(radius,pos)
	local hbPart = create("Part", {
		Parent = workspace, Anchored = true, CanCollide = false, Transparency = 1,
		Shape = Enum.PartType.Ball, Size = v3(radius*2, radius*2, radius*2), Position = pos
	})
	table.insert(partexclusion, hbPart)
	debris:AddItem(hbPart, 0.2)
end

function attacks:pew(pos)
	attack, ws_speed = true, 0.05
	for i = 1, 3, 0.15 do
		swait()
		laoffset = laoffset:Lerp(lac0*cn(0.0649986267,0,0.240997314)*euler(rad(-7.5),rad(15),0),animspeed)
		raoffset = raoffset:Lerp(rac0*cn(0.0480003357,0.375,-0.614997864)*euler(rad(90),rad(-22.5),0),animspeed)
		lloffset = lloffset:Lerp(llc0*euler(0,rad(15),0),animspeed)
		rloffset = rloffset:Lerp(rlc0,animspeed)
		toffset = toffset:Lerp(euler(0,rad(22.5),0),animspeed)
		hoffset = hoffset:Lerp(hc0*euler(0,rad(-22.5),0),animspeed)
		gunoffset = gunoffset:Lerp(cn(-0.25,-1.52400005,-0.2970047)*euler(0,rad(90),rad(-90)),animspeed)
	end

	local start = (gun.CFrame * cn(3.43700027,0.504000008,0.00199890137)).p
	debris:AddItem(create("Sound", {Parent = gun, SoundId = "rbxassetid://3723700663", Playing = true, Volume = 3}), 0)

	local bruurubu = create("Part", {
		Parent = workspace, Anchored = true, CanCollide = false, Material = Enum.Material.Neon,
		Size = v3(1.5,1.5,1.5), CFrame = cn(start) * euler(rad(random(0,360)),rad(random(0,360)),rad(random(0,360)))
	})
	table.insert(partexclusion, bruurubu)
	tween(bruurubu, {Transparency=1, Size=v3()}, 0.2, Enum.EasingDirection.In)
	debris:AddItem(bruurubu, 0.2)

	for i = 1, 5 do
		local function calcRay()
			raycastparams.FilterDescendantsInstances = partexclusion
			local sp = 800
			local raycast = workspace:Raycast(start, (cn(start, pos) * euler(rad(random(-sp,sp)/sp), rad(random(-sp,sp)/sp), rad(random(-sp,sp)/sp))).LookVector * 2048, raycastparams)
			if raycast then return raycast.Position end
			return (cn(start) * cn(start, pos) * cn(0,0,-2048)).p
		end

		local hitpos = calcRay()
		local length = clamp((start-hitpos).Magnitude, 0, 2048)

		local s = create("Part", {
			Parent = workspace, Anchored = true, CanCollide = false,
			Size = v3(0.5,0.5,length), Material = Enum.Material.Neon,
			Position = start, CFrame = cn(start, hitpos)
		})
		table.insert(partexclusion, s)
		s.CFrame = s.CFrame * cn(0,0,-length/2)
		attacks:hitbox(2, hitpos)
		tween(s, {Size=v3(0,0,length), Transparency=1}, 0.2, Enum.EasingDirection.In)
		debris:AddItem(s, 0.2)

		local hiteffect = create("Part", {
			Parent = workspace, Anchored = true, CanCollide = false, Material = Enum.Material.Neon,
			Size = v3(1.5,1.5,1.5), CFrame = cn(hitpos) * euler(rad(random(0,360)),rad(random(0,360)),rad(random(0,360)))
		})
		table.insert(partexclusion, hiteffect)
		tween(hiteffect, {Transparency=1, Size=v3()}, 0.2, Enum.EasingDirection.In)
		debris:AddItem(hiteffect, 0.2)
	end

	for i = 1, 3, 0.15 do
		swait()
		laoffset = laoffset:Lerp(lac0*cn(-0.0429992676,0.0380001068,-0.700996399)*euler(rad(60),rad(15),rad(-7.5)),animspeed)
		raoffset = raoffset:Lerp(rac0*cn(-0.39799881,0.246000051,-0.800003052)*euler(rad(75),rad(67.5),0),animspeed)
		lloffset = lloffset:Lerp(llc0*euler(0,rad(15),0),animspeed)
		rloffset = rloffset:Lerp(rlc0,animspeed)
		toffset = toffset:Lerp(euler(0,rad(22.5),0),animspeed)
		hoffset = hoffset:Lerp(hc0*cn(-0.016998291,-0.0170001984,-0.126998901)*euler(rad(-14.74),rad(15.39),rad(-2)),animspeed)
	end

	attack, ws_speed = false, 0.2
end

function attacks:ouch(pos)
	attack, ws_speed = true, 0.05
	for i = 1, 3, 0.2 do
		swait()
		raoffset = raoffset:Lerp(rac0*cn(0.301998138,0.25999999,-0.476997375)*euler(rad(75),0,rad(45)),animspeed)
	end
	attacks:hitbox(4, pos)
	debris:AddItem(create("Sound", {Parent = gun, SoundId = "rbxassetid://12222208", Volume = 2, Playing = true}), 0)

	for i = 1, 2, 0.15 do
		swait()
		raoffset = raoffset:Lerp(rac0*cn(-0.459999084,0.112999916,-1.02799988)*euler(rad(75),0,rad(-30)),animspeed*2)
	end
	attack, ws_speed = false, 0.2
end

function attacks:tp(pos)
	local oldpos = poscframe.p
	local _pos = {oldpos, pos}
	poscframe, ypos = cn(pos), pos.Y
	for i = 1, 2 do
		local b = create("Part", {Parent = workspace, Anchored = true, CanCollide = false, Material = Enum.Material.Neon, Position = _pos[i], Size = v3(7,7,7)})
		table.insert(partexclusion, b)
		tween(b, {Size=v3(), Transparency=1}, 0.3, Enum.EasingDirection.In)
		debris:AddItem(b, 0.3)
	end
	debris:AddItem(create("Sound", {Parent = r, SoundId = "rbxassetid://642890855", Pitch = 0.45, Playing = true}), 0)
end

for i, v in next, cam:GetChildren() do debris:AddItem(v, 0) end

local rotationvalue = nil
run:BindToRenderStep(userid.."movement", 4354543, function()
	if not r or not c then return end
	if not rotationvalue or rotationvalue.Parent ~= folder then
		debris:AddItem(rotationvalue, 0)
		rotationvalue = Instance.new("CFrameValue", folder)
		rotationvalue.Name = randomstring()
	end
	raycastparams.FilterDescendantsInstances = partexclusion

	uis.MouseIconEnabled, mouse.Icon = true, ""
	cam.CameraSubject, cam.CameraType, cam.FieldOfView = c, Enum.CameraType.Custom, 70
	localplayer.CameraMaxZoomDistance, localplayer.CameraMinZoomDistance = math.huge, 0
	localplayer.CameraMode, cam.FieldOfViewMode = Enum.CameraMode.Classic, Enum.FieldOfViewMode.Vertical

	local movedirection, lv, pos = v3(), cam.CFrame.LookVector, poscframe.p
	if keys.w then movedirection = movedirection + v3(0,0,-ws_speed) end
	if keys.a then movedirection = movedirection + v3(-ws_speed,0,0) end
	if keys.s then movedirection = movedirection + v3(0,0,ws_speed) end
	if keys.d then movedirection = movedirection + v3(ws_speed,0,0) end

	local xrot,yrot,zrot = cn(pos,v3(pos.X+lv.X,pos.Y,pos.Z+lv.Z)):ToOrientation()

	-- Horizontal wall check (stops noclip)
	local worldDir = v3()
	if movedirection.Magnitude > 0 then
		worldDir = (euler(0, yrot, 0) * cn(movedirection)).p
		local horizOrigin = pos + v3(0, 1, 0)
		local horizHit = workspace:Raycast(horizOrigin, worldDir.Unit * 1.5, raycastparams)
		if horizHit then
			movedirection = v3()
			worldDir = v3()
		end
	end

	local potentialposraycast = workspace:Raycast(pos + worldDir, v3(0,-3.5,0), raycastparams)
	local currentposraycast = workspace:Raycast(pos, v3(0,-3.5,0), raycastparams)

	if currentposraycast then
		if keys.space then
			yvelo, ypos = 1.5, ypos+1.5
		elseif potentialposraycast then
			ypos, yvelo = potentialposraycast.Position.Y + 3, 0
		end
	else
		yvelo = clamp(yvelo-0.06, -4, 1)
		ypos = ypos + yvelo
	end
	if ypos < workspace.FallenPartsDestroyHeight then
		ypos = 50
	end

	moving = movedirection ~= v3()
	local moveto = (cn(pos.X, ypos, pos.Z) * euler(0, yrot, 0) * cn(movedirection)).p

	if uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
		rotationvalue.Value = euler(0, yrot, 0)
	else
		if moving then
			local z = ts:Create(rotationvalue, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Value = cn(pos,moveto)})
			z:Play()
			task.delay(1/60, function() z:Cancel() end)
		end
	end

	firstperson = uis.MouseBehavior == Enum.MouseBehavior.LockCenter and (cam.CFrame.p - c.Position).Magnitude < 1
	local xrot3, yrot3, zrot3 = rotationvalue.Value:ToOrientation()
	velocity = (moveto-pos)*50
	poscframe = cn(moveto) * euler(0, yrot3, 0)
	r.CFrame = poscframe
	c.CFrame = r.CFrame * cn(0,1.5,0)
end)

local shiftdown = false
local uisthng = uis.InputBegan:Connect(function(a, gp)
	local key = string.lower(string.split(tostring(a.KeyCode),".")[3])
	if key == "leftshift" then shiftdown = true end

	if chatting then
		local newinput = key
		if shiftdown then newinput = string.upper(newinput) end
		if #newinput == 1 then
			chattext = chattext .. newinput
			if chatinput then chatinput.Text = chattext end
		end
		if key == "backspace" then
			chattext = string.sub(chattext, 1, #chattext-1)
			if chatinput then chatinput.Text = chattext end
		elseif key == "return" then
			local txt = chattext
			chattext = ""
			if chatinput then chatinput.Visible = false; chatinput.Text = "" end
			chatting = false
		end
	else
		if key == "slash" and not gp then
			chatting = true
			if chatinput then chatinput.Visible = true end
		end
	end
end)

local uisthng2 = uis.InputEnded:Connect(function(a)
	local key = string.lower(string.split(tostring(a.KeyCode),".")[3])
	if key == "leftshift" then shiftdown = false end
end)

local mthing = mouse.KeyDown:Connect(function(key)
	if not chatting then
		if key == "w" or key == "a" or key == "s" or key == "d" then
			keys[key] = true
		elseif key == " " then
			keys.space = true
		elseif key == "e" and not attack then
			attacks:ouch((r.CFrame * cn(0,-2,-2)).p)
		elseif key == "z" and not attack then
			attacks:tp(mouse.Hit.p + v3(0,3,0))
		end
	end
end)

local mthing2 = mouse.KeyUp:Connect(function(key)
	if key == "w" or key == "a" or key == "s" or key == "d" then
		keys[key] = false
	elseif key == " " then
		keys.space = false
	end
end)

local mthing3 = mouse.Button1Down:Connect(function()
	if mouse.Target ~= chat then
		chatting = false
		if chatinput then chatinput.Visible = false end
	end
	if not attack then
		attacks:pew(mouse.Hit.p)
	end
end)

local cameratilt = cn()
local animthng = run.RenderStepped:Connect(function()
	sine = workspace.DistributedGameTime * 60
	if not c or not r then return end
	c.CFrame = r.CFrame * cn(0,1.5,0)

	local _tilt = cn(r.CFrame:VectorToObjectSpace(velocity))
	local tilt = {X=clamp(_tilt.X,-7,7), Y=0, Z=clamp(_tilt.Z,-7,7)}

	if localuserid == userid and cam then
		cameratilt = cameratilt:Lerp(cn(-tilt.X*3, -yvelo/2, 0), 0.03)
		cam.CFrame = cam.CFrame * euler(rad(-cameratilt.Y/1.5), 0, rad(cameratilt.X/4))
	end

	if not attack then
		if yvelo > 0 then
			laoffset = laoffset:Lerp(lac0*cn(-0.325000763,0.187000036,0)*euler(0,0,rad(-30)),animspeed)
			raoffset = raoffset:Lerp(rac0*cn(0.325000763,0.187000036,0)*euler(0,0,rad(30)),animspeed)
			lloffset = lloffset:Lerp(llc0*cn(0,0.57099998,-0.45300293)*euler(rad(-7.5),0,0),animspeed)
			rloffset = rloffset:Lerp(rlc0,animspeed)
			toffset = toffset:Lerp(cn(),animspeed)
			hoffset = hoffset:Lerp(hc0,animspeed)
		elseif yvelo < 0 then
			laoffset = laoffset:Lerp(lac0*cn(-0.187999725,0.161999941,-0.46900177)*euler(rad(60),0,rad(-30)),animspeed)
			raoffset = raoffset:Lerp(rac0*cn(0.187999725,0.161999941,-0.46900177)*euler(rad(60),0,rad(30)),animspeed)
			lloffset = lloffset:Lerp(llc0,animspeed)
			rloffset = rloffset:Lerp(rlc0*cn(0,0.57099998,-0.45300293)*euler(rad(-7.5),0,0),animspeed)
			toffset = toffset:Lerp(euler(rad(-20),0,0),animspeed)
			hoffset = hoffset:Lerp(hc0*cn(0,-0.0170001984,-0.128997803)*euler(rad(-7.5),0,0),animspeed)
		elseif moving then
			laoffset = laoffset:Lerp(lac0*cn(-0.1,0,-sin(sine/10)/20*tilt.Z)*euler(rad(sin(sine/10)*3*tilt.Z),0,rad(-10)),animspeed)
			raoffset = raoffset:Lerp(rac0*cn(0.1,0,sin(sine/10)/20*tilt.Z)*euler(-rad(sin(sine/10)*3*tilt.Z),0,rad(10)),animspeed)
			lloffset = lloffset:Lerp(llc0*cn(sin(sine/10)/20*tilt.X,0,sin(sine/10)/20*tilt.Z)*euler(-rad(sin(sine/10)*3*tilt.Z),0,rad(sin(sine/10)*3*tilt.X)),animspeed)
			rloffset = rloffset:Lerp(rlc0*cn(-sin(sine/10)/20*tilt.X,0,-sin(sine/10)/20*tilt.Z)*euler(rad(sin(sine/10)*3*tilt.Z),0,-rad(sin(sine/10)*3*tilt.X)),animspeed)
			toffset = toffset:Lerp(cn(0,sin(sine/5)/10,0)*euler(rad(tilt.Z*2),0,rad(-tilt.X)),animspeed)
			hoffset = hoffset:Lerp(hc0*euler(0,-rad(tilt.X*5),0),animspeed)
			gunoffset = gunoffset:Lerp(cn(-0.125,-0.898999929-cos(sine/10)/70*tilt.Z,0.95400238)*euler(0,rad(90),rad(-172.5+cos(sine/10)*tilt.Z*1.5)),animspeed)
		else
			laoffset = laoffset:Lerp(lac0*cn(0.262001038-sin(sine/30)/10,-0.0739998817,-0.13999939)*euler(rad(7.44),0,rad(7.56-sin(sine/30)*7)),animspeed)
			raoffset = raoffset:Lerp(rac0*cn(-0.125,-0.125,0.217002869-sin(sine/30)/10)*euler(rad(-7.5+sin(sine/30)*7),rad(-30),0),animspeed)
			lloffset = lloffset:Lerp(llc0*euler(0,rad(15),0),animspeed)
			rloffset = rloffset:Lerp(rlc0*cn(0,0.0160000324,0.124000549)*euler(rad(-7.5),0,0),animspeed)
			toffset = toffset:Lerp(euler(rad(cos(sine/30)*2.5-2),rad(-15),0),animspeed)
			hoffset = hoffset:Lerp(cn(0,1,0)*euler(rad(cos(sine/30)*5),rad(15),rad(cos(sine/60)*10))*cn(0,0.5,0),animspeed)
			gunoffset = gunoffset:Lerp(cn(-0.6,-0.898999929+cos(sine/30)/5,0.95400238)*euler(0,rad(60),rad(-172.5-cos(sine/30)*10)),animspeed)
		end
	end

	if chat and t then
		tween(chat, {CFrame = r.CFrame * cn(3.13899994+sin(sine/30)/2, 3.16800022+sin(sine/20)/2, -1.19099998+sin(sine/40)/2) * euler(rad(-14.48+cos(sine/30)*10),rad(127+cos(sine/20)*10),rad(-3.97+cos(sine/40)*10))}, 0.5, Enum.EasingDirection.Out)
	end

	if t then t.CFrame = r.CFrame * toffset end
	if h and la and ra and ll and rl and t then
		h.CFrame, la.CFrame, ra.CFrame, ll.CFrame, rl.CFrame = t.CFrame*hoffset, t.CFrame*laoffset, t.CFrame*raoffset, t.CFrame*lloffset, t.CFrame*rloffset
	end
	if gun and ra then gun.CFrame = ra.CFrame * gunoffset end
end)

for i, v in next, Character:GetDescendants() do
	if v:IsA("BasePart") then table.insert(partexclusion, v) end
end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "studio dummy v3",
	Text = "fixed by feyz",
})

local animateScript = Character:FindFirstChild("Animate")
if animateScript then animateScript:Destroy() end
local animator = Humanoid:FindFirstChild("Animator")
if animator then animator:Destroy() end

for i, v in next, folder:GetChildren() do debris:AddItem(v, 0) end

local _chr = Character
local rh, rla, rra, rll, rrl, rt = Head, LeftArm, RightArm, LeftLeg, RightLeg, Torso

local function _weld(a, b)
	if not a or not b then return end
	local w = Instance.new('Weld')
	w.Part0 = a
	w.Part1 = b
	w.C0 = a.CFrame:inverse() * b.CFrame
	w.C1 = w.C0
	w.Parent = a
	local nc = Instance.new('NoCollisionConstraint')
	nc.Part0 = a
	nc.Part1 = b
end

_weld(h, rh); _weld(la, rla); _weld(ra, rra); _weld(ll, rll); _weld(rl, rrl); _weld(t, rt)
if h and h:FindFirstChild("face") then h.face.Transparency = 1 end

local gunHat = _chr:FindFirstChild('Meshes/archangelrifleAccessory')
if gunHat and gunHat:FindFirstChild("Handle") then
	local hat = gunHat.Handle
	hat:BreakJoints()
	local weld = Instance.new('Weld', hat)
	weld.Part1 = hat
	weld.Part0 = gun
	weld.C0 = CFrame.new(0.4,0,0) * CFrame.Angles(0,math.rad(180),0)
end

local chatHat = _chr:FindFirstChild('Noob MonitorAccessory')
if chatHat and chatHat:FindFirstChild("Handle") then
	local hat2 = chatHat.Handle
	hat2:BreakJoints()
	local weld2 = Instance.new('Weld', hat2)
	weld2.Part1 = hat2
	weld2.Part0 = chat
	weld2.C0 = CFrame.new(0,0,0) * CFrame.Angles(0,0,0)
end

Humanoid.Died:Connect(function()
	pcall(function() run:UnbindFromRenderStep(username..userid.."partmaintain") end)
	pcall(function() run:UnbindFromRenderStep(userid.."movement") end)
	pcall(function() swaitcon:Disconnect() end)
	pcall(function() animthng:Disconnect() end)
	pcall(function() mthing:Disconnect() end)
	pcall(function() mthing2:Disconnect() end)
	pcall(function() mthing3:Disconnect() end)
	pcall(function() uisthng:Disconnect() end)
	pcall(function() uisthng2:Disconnect() end)
	pcall(function() hb:Destroy() end)
	partexclusion = {}
end)
