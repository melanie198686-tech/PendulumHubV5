--3DG (Final Fix: Realistic swinging, No floating, Arm gear restored)

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
local head = char:WaitForChild("Head")
local ra = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
local la = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
local rootpart = char:WaitForChild("HumanoidRootPart")
local mouse = plr:GetMouse()
local RunService = game:GetService("RunService")

-- 1. Prevent Death
humanoid.MaxHealth = math.huge
humanoid.Health = math.huge
humanoid.BreakJointsOnDeath = false

-- 2. Build the Gear (Straps, Ropes, Gas Tanks)
local model = Instance.new('Model', char)
model.Name = '3DG'

local BasePart = Instance.new('Part')
BasePart.FormFactor = 'Custom'; BasePart.Material = 'Neon'
BasePart.CanCollide = false; BasePart.Locked = true
BasePart.TopSurface = 10; BasePart.BottomSurface = 10
BasePart.LeftSurface = 10; BasePart.RightSurface = 10
BasePart.FrontSurface = 10; BasePart.BackSurface = 10

local function Weld(part0, part1, c0, c1)
	local w = Instance.new("Weld")
	w.Part0 = part0; w.Part1 = part1
	w.C0 = c0 or CFrame.new(); w.C1 = c1 or CFrame.new()
	w.Parent = part0
	return w
end

for i = 1, 2 do
	local strap = BasePart:Clone(); strap.Size = Vector3.new(1.025, .2, 1.025); strap.Parent = model
	strap.BrickColor = BrickColor.new(); Weld(la, strap, CFrame.new(0, .1 - i/3, 0))
end
for i = 1, 2 do
	local strap = BasePart:Clone(); strap.Size = Vector3.new(1.025, .2, 1.025); strap.Parent = model
	strap.BrickColor = BrickColor.new(); Weld(ra, strap, CFrame.new(0, .1 - i/3, 0))
end

local ropeStart = BasePart:Clone(); ropeStart.Size = Vector3.new(.2, 1.75, .2); ropeStart.Parent = model
ropeStart.BrickColor = BrickColor.new(); Weld(ra, ropeStart, CFrame.new(-.45, -.5, 0))
local ropeStart2 = BasePart:Clone(); ropeStart2.Size = Vector3.new(.2, 1.75, .2); ropeStart2.Parent = model
ropeStart2.BrickColor = BrickColor.new(); Weld(la, ropeStart2, CFrame.new(.45, -.5, 0))

local ropeCont = BasePart:Clone(); ropeCont.Size = Vector3.new(.8, .2, .8); ropeCont.Parent = model
ropeCont.BrickColor = BrickColor.new(199); Instance.new('CylinderMesh', ropeCont)
Weld(la, ropeCont, CFrame.new(.5, .05, 0), CFrame.Angles(math.pi/2, math.pi/2, 0))
local ropeCont2 = BasePart:Clone(); ropeCont2.Size = Vector3.new(.8, .2, .8); ropeCont2.Parent = model
ropeCont2.BrickColor = BrickColor.new(199); Instance.new('CylinderMesh', ropeCont2)
Weld(ra, ropeCont2, CFrame.new(-.5, .05, 0), CFrame.Angles(math.pi/2, math.pi/2, 0))

local GasTank = BasePart:Clone(); GasTank.Size = Vector3.new(.8, 1.4, .8); GasTank.Parent = model
GasTank.BrickColor = BrickColor.new(194); Instance.new('SpecialMesh', GasTank)
Weld(ra, GasTank, CFrame.new(0, -.25, .5))
local GasTank2 = BasePart:Clone(); GasTank2.Size = Vector3.new(.8, 1.4, .8); GasTank2.Parent = model
GasTank2.BrickColor = BrickColor.new(194); Instance.new('SpecialMesh', GasTank2)
Weld(la, GasTank2, CFrame.new(0, -.25, .5))

-- 3. Grapple Hooks
local pa = BasePart:Clone(); pa.BrickColor = BrickColor.new(); pa.Anchored = true; pa.Size = Vector3.new(.5, 1, .5)
local special = Instance.new('SpecialMesh', pa); special.MeshId = "rbxassetid://1033714"; special.Scale = Vector3.new(.25, 2, .25)
local ropePA = BasePart:Clone(); ropePA.Parent = pa; ropePA.Anchored = true; ropePA.BrickColor = BrickColor.new'White'
Instance.new('CylinderMesh', ropePA).Scale = Vector3.new(.25, 1, .25)

local pa2 = BasePart:Clone(); pa2.BrickColor = BrickColor.new(); pa2.Anchored = true; pa2.Size = Vector3.new(.5, 1, .5)
local special2 = Instance.new('SpecialMesh', pa2); special2.MeshId = "rbxassetid://1033714"; special2.Scale = Vector3.new(.25, 2, .25)
local ropePA2 = BasePart:Clone(); ropePA2.Parent = pa2; ropePA2.Anchored = true; ropePA2.BrickColor = BrickColor.new'White'
Instance.new('CylinderMesh', ropePA2).Scale = Vector3.new(.25, 1, .25)

-- 4. UI
local SGui = Instance.new('ScreenGui', plr.PlayerGui)
local JumpButton = Instance.new('TextButton', SGui)
JumpButton.BackgroundColor = BrickColor.new('Dark stone grey')
JumpButton.Text = 'Thrust up when grappled'
JumpButton.Size = UDim2.new(0, 250, 0, 50)
JumpButton.Position = UDim2.new(1, -250, 1, -50)
local OnOff = Instance.new('Frame', JumpButton)
OnOff.BackgroundColor3 = Color3.new(); OnOff.Size = UDim2.new(.8, 0, 0, 5); OnOff.Position = UDim2.new(.1, 0, 1, -10)

local jumpmode = false
JumpButton.MouseButton1Down:Connect(function()
    jumpmode = not jumpmode
    OnOff.BackgroundColor3 = jumpmode and Color3.new(0,1,0) or Color3.new()
end)

-- 5. Physics Setup
local att1 = Instance.new("Attachment", rootpart)
local att2 = Instance.new("Attachment", torso)

local ap1 = Instance.new("AlignPosition", rootpart)
ap1.Attachment0 = att1
ap1.MaxForce = 50000
ap1.Responsiveness = 15
ap1.Enabled = false

local ao1 = Instance.new("AlignOrientation", rootpart)
ao1.Attachment0 = att1
ao1.MaxTorque = 30000
ao1.Responsiveness = 15
ao1.Enabled = false

local ap2 = Instance.new("AlignPosition", torso)
ap2.Attachment0 = att2
ap2.MaxForce = 50000
ap2.Responsiveness = 15
ap2.Enabled = false

local ao2 = Instance.new("AlignOrientation", torso)
ao2.Attachment0 = att2
ao2.MaxTorque = 30000
ao2.Responsiveness = 15
ao2.Enabled = false

-- 6. Grapple Logic
local Grapple1, Grapple2
local Gweld, Gweld2

local function fireHook(isLeft)
    local p = isLeft and pa or pa2
    local arm = isLeft and la or ra
    
    local sound = Instance.new('Sound', head)
    sound.SoundId = "rbxassetid://160248505"; sound.Pitch = 3+math.random()/3; sound.Volume = .8; sound:Play()
    game:GetService('Debris'):AddItem(sound, 4)
    
    p.CFrame = arm.CFrame
    local grapplepos = p.Position
    local grapplevelocity = (mouse.Hit.p - grapplepos).Unit * 50
    
    task.spawn(function()
        while task.wait() do
            local lastgrapplepos = grapplepos 
            grapplepos = grapplepos + grapplevelocity
            local RayCast = Ray.new(lastgrapplepos, (grapplepos - lastgrapplepos))
            local hit, hitpos = workspace:FindPartOnRay(RayCast, char)
            if (torso.Position - p.Position).Magnitude > 900 then
                p.Parent = nil; break
            end
            p.Anchored = true
            p.CFrame = CFrame.new(grapplepos, grapplepos + grapplevelocity) * CFrame.Angles(math.pi/2, 0, 0)
            p.Parent = char
            
            if hit then
                local rotX, rotY, rotZ = p.CFrame:ToEulerAnglesXYZ()
                local s2 = Instance.new('Sound', head)
                s2.SoundId = "rbxassetid://146466021"; s2.Volume = .25; s2:Play()
                game:GetService('Debris'):AddItem(s2, 4)
                
                p.CFrame = CFrame.new(hitpos.X, hitpos.Y, hitpos.Z) * CFrame.Angles(rotX, rotY, rotZ) * CFrame.Angles(math.pi, 0, 0)
                
                local hum = hit.Parent and hit.Parent:FindFirstChild('Humanoid')
                if hum then hum:TakeDamage(math.random(7, 11)) end
                local hum2 = hit.Parent and hit.Parent.Parent and hit.Parent.Parent:FindFirstChild('Humanoid')
                if hum2 then hum2:TakeDamage(math.random(7, 11)) end
                
                if jumpmode then humanoid.Jump = true end
                
                local gw = Instance.new("Weld", char)
                gw.C0 = hit.CFrame:ToObjectSpace(p.CFrame)
                gw.Part0 = hit; gw.Part1 = p
                p.Anchored = false
                
                local att = p:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", p)
                
                if isLeft then 
                    Gweld = gw; Grapple1 = true
                    ap1.Attachment1 = att; ao1.Attachment1 = att
                    ap1.Position = p.Position; ap1.Enabled = true
                    ao1.CFrame = CFrame.new(p.Position); ao1.Enabled = true
                else 
                    Gweld2 = gw; Grapple2 = true
                    ap2.Attachment1 = att; ao2.Attachment1 = att
                    ap2.Position = p.Position; ap2.Enabled = true
                    ao2.CFrame = CFrame.new(p.Position); ao2.Enabled = true
                end
                break
            end
        end
    end)
end

mouse.KeyDown:Connect(function(k)
    if k == "q" then fireHook(true)
    elseif k == "e" then fireHook(false) end
end)

mouse.KeyUp:Connect(function(k)
    if k == "q" then
        pcall(function() Gweld:Destroy() end)
        pa.Parent = nil; Grapple1 = false
        ap1.Enabled = false; ao1.Enabled = false
    elseif k == "e" then
        pcall(function() Gweld2:Destroy() end)
        pa2.Parent = nil; Grapple2 = false
        ap2.Enabled = false; ao2.Enabled = false
    end
end)

-- 7. Main Loop
RunService.Heartbeat:Connect(function()
    if humanoid.Health < math.huge then humanoid.Health = math.huge end

    if Grapple1 and pa then
        local size = (ropeStart2.Position - pa.Position).Magnitude
        ropePA.Size = Vector3.new(.2, size, .2) 
        ropePA.CFrame = CFrame.new(ropeStart2.Position, pa.Position) * CFrame.Angles(math.pi/2, 0, 0) * CFrame.new(0, -size/2, 0)
    end
    
    if Grapple2 and pa2 then
        local size = (ropeStart.Position - pa2.Position).Magnitude
        ropePA2.Size = Vector3.new(.2, size, .2) 
        ropePA2.CFrame = CFrame.new(ropeStart.Position, pa2.Position) * CFrame.Angles(math.pi/2, 0, 0) * CFrame.new(0, -size/2, 0)
    end
end)
