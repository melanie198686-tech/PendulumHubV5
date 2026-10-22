--[[ Pacifist Class - Fixed leg animations, physics, and parsing errors ]]

Player=game:GetService("Players").LocalPlayer
Character=Player.Character or Player.CharacterAdded:Wait()
PlayerGui=Player.PlayerGui
Backpack=Player.Backpack 

-- Wait for character to fully load
repeat task.wait() until Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Humanoid")

local isR15 = Character:FindFirstChild("UpperTorso") ~= nil

Torso = isR15 and Character.UpperTorso or Character.Torso
Head = Character.Head 
Humanoid = Character.Humanoid
LeftArm = isR15 and Character.LeftUpperArm or Character["Left Arm"]
LeftLeg = isR15 and Character.LeftUpperLeg or Character["Left Leg"]
RightArm = isR15 and Character.RightUpperArm or Character["Right Arm"]
RightLeg = isR15 and Character.RightUpperLeg or Character["Right Leg"]
RootPart = Character.HumanoidRootPart
RootJoint = isR15 and RootPart:FindFirstChild("Root") or RootPart:FindFirstChild("RootJoint")
Neck = Torso:FindFirstChild("Neck")

-- Prevent the game's default animations from fighting us
if Character:FindFirstChild("Animate") then
    Character.Animate.Disabled = true
end
if Humanoid:FindFirstChild("Animator") then
    Humanoid.Animator:Destroy()
end

-- Remove the default shoulder motors safely
for _, name in ipairs({"Right Shoulder", "Left Shoulder", "RightShoulder", "LeftShoulder"}) do
    local m = Torso:FindFirstChild(name)
    if m then m.Parent = nil end
end

-- Ensure legs stay attached and grab their motors
local RH = Torso:FindFirstChild("Right Hip") or Torso:FindFirstChild("RightHip")
local LH = Torso:FindFirstChild("Left Hip") or Torso:FindFirstChild("LeftHip")

-- If they are broken, recreate them
if not RH then
    RH = Instance.new("Motor")
    RH.Name = "Right Hip"
    RH.Part0 = Torso
    RH.Part1 = RightLeg
    RH.C0 = cf(1, -1, 0) * angles(math.rad(0), math.rad(90), math.rad(0))
    RH.C1 = cf(0.5, 1, 0) * angles(math.rad(0), math.rad(90), math.rad(0))
    RH.Parent = Torso
end
if not LH then
    LH = Instance.new("Motor")
    LH.Name = "Left Hip"
    LH.Part0 = Torso
    LH.Part1 = LeftLeg
    LH.C0 = cf(-1, -1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0))
    LH.C1 = cf(-0.5, 1, 0) * angles(math.rad(0), math.rad(-90), math.rad(0))
    LH.Parent = Torso
end

attacktype=1
vt=Vector3.new
cf=CFrame.new
euler=CFrame.fromEulerAnglesXYZ
angles=CFrame.Angles
necko=cf(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
RootCF=euler(-1.57,0,3.14)

attack = false 
equipped = true
local idle = 0
local Anim = "Idle"

Humanoid.WalkSpeed = 10

mouse=Player:GetMouse()

-- Create our custom shoulder welds
RW=Instance.new("Motor") 
LW=Instance.new("Motor") 
RW.Name="Right Shoulder"
LW.Name="Left Shoulder"

RW.Part0=Torso 
RW.C0=cf(1.5, 0.5, 0) 
RW.C1=cf(0, 0.5, 0) 
RW.Part1=RightArm 
RW.Parent=Torso 

LW.Part0=Torso 
LW.C0=cf(-1.5, 0.5, 0) 
LW.C1=cf(0, 0.5, 0) 
LW.Part1=LeftArm 
LW.Parent=Torso 

function rayCast(Pos, Dir, Max, Ignore)
return game:GetService("Workspace"):FindPartOnRay(Ray.new(Pos, Dir.Unit * (Max or 999.999)), Ignore) 
end 
	
function clerp(a,b,t) 
local qa = {QuaternionFromCFrame(a)}
local qb = {QuaternionFromCFrame(b)} 
local ax, ay, az = a.x, a.y, a.z 
local bx, by, bz = b.x, b.y, b.z
local _t = 1-t
return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz,QuaternionSlerp(qa, qb, t)) 
end
 
function QuaternionFromCFrame(cf_) 
local _,_,_,m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf_:components() 
local trace = m00 + m11 + m22 
if trace > 0 then 
local s = math.sqrt(1 + trace) 
local recip = 0.5/s 
return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5 
else 
local i = 0 
if m11 > m00 then i = 1 end
if m22 > (i == 0 and m00 or m11) then i = 2 end 
if i == 0 then 
local s = math.sqrt(m00-m11-m22+1) 
local recip = 0.5/s 
return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip 
elseif i == 1 then 
local s = math.sqrt(m11-m22-m00+1) 
local recip = 0.5/s 
return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip 
elseif i == 2 then 
local s = math.sqrt(m22-m00-m11+1) 
local recip = 0.5/s return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip 
end 
end 
end
 
function QuaternionToCFrame(px, py, pz, x, y, z, w) 
local xs, ys, zs = x + x, y + y, z + z 
local wx, wy, wz = w*xs, w*ys, w*zs 
local xx = x*xs 
local xy = x*ys 
local xz = x*zs 
local yy = y*ys 
local yz = y*zs 
local zz = z*zs 
return CFrame.new(px, py, pz,1-(yy+zz), xy - wz, xz + wy,xy + wz, 1-(xx+zz), yz - wx, xz - wy, yz + wx, 1-(xx+yy)) 
end
 
function QuaternionSlerp(a, b, t) 
local cosTheta = a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4] 
local startInterp, finishInterp; 
if cosTheta >= 0.0001 then 
if (1 - cosTheta) > 0.0001 then 
local theta = math.acos(cosTheta) 
local invSinTheta = 1/math.sin(theta) 
startInterp = math.sin((1-t)*theta)*invSinTheta 
finishInterp = math.sin(t*theta)*invSinTheta  
else 
startInterp = 1-t 
finishInterp = t 
end 
else 
if (1+cosTheta) > 0.0001 then 
local theta = math.acos(-cosTheta) 
local invSinTheta = 1/math.sin(theta) 
startInterp = math.sin((t-1)*theta)*invSinTheta 
finishInterp = math.sin(t*theta)*invSinTheta 
else 
startInterp = t-1 
finishInterp = t 
end 
end 
return a[1]*startInterp + b[1]*finishInterp, a[2]*startInterp + b[2]*finishInterp, a[3]*startInterp + b[3]*finishInterp, a[4]*startInterp + b[4]*finishInterp 
end

sitting=false
resting=false
meditating=false
sprint=false

local function safePose(fn)
    pcall(fn)
end

mouse.KeyDown:Connect(function(k)
	k=k:lower()
	if k=='z' and not attack and not resting and not sprint and not meditating then
        attack=true
        sitting = not sitting
        Humanoid.WalkSpeed = sitting and 0 or 10
        task.spawn(function()
            for _=0,1,0.04 do
                task.wait()
                safePose(function()
                    RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-1.25)*angles(math.rad(0),math.rad(15),math.rad(0)),0.15)
                    Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(30)),0.15)
                    RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(0),math.rad(0),math.rad(20)),0.15)
                    LW.C0=clerp(LW.C0,cf(-1.5,0.3,0)*angles(math.rad(15),math.rad(0),math.rad(-25)),0.15)
                end)
            end
        end)
        attack=false
	elseif k=='x' and not attack and not sitting and not sprint and not meditating then
        attack=true
        resting = not resting
        Humanoid.WalkSpeed = resting and 0 or 10
        task.spawn(function()
            for _=0,1,0.04 do
                task.wait()
                safePose(function()
                    RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-1.05)*angles(math.rad(0),math.rad(15),math.rad(0)),0.15)
                    Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(30)),0.15)
                    RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(0),math.rad(0),math.rad(20)),0.15)
                    LW.C0=clerp(LW.C0,cf(-1.5,0.1,0)*angles(math.rad(15),math.rad(0),math.rad(-25)),0.15)
                end)
            end
        end)
        attack=false
	elseif k=='c' and not attack and not sitting and not resting and not sprint then
        attack=true
        meditating = not meditating
        Humanoid.WalkSpeed = meditating and 0 or 10
        task.spawn(function()
            for _=0,1,0.04 do
                task.wait()
                safePose(function()
                    RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-1.05)*angles(math.rad(0),math.rad(15),math.rad(0)),0.15)
                    Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(30)),0.15)
                    RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(0),math.rad(0),math.rad(20)),0.15)
                    LW.C0=clerp(LW.C0,cf(-1.5,0.1,0)*angles(math.rad(15),math.rad(0),math.rad(-25)),0.15)
                end)
            end
        end)
        attack=false
	elseif k=='e' and not attack and not resting and not sitting and not meditating and not sprint then
        sprint=true
        Humanoid.WalkSpeed = 16
	end
end)

mouse.KeyUp:Connect(function(k)
    k=k:lower()
    if k=='e' and sprint then
        sprint=false
        Humanoid.WalkSpeed = 10
    end
end)

local sine = 0
local change = 1

game:GetService("RunService").Heartbeat:Connect(function()
    sine = sine + change
    
    if not RootPart or not RootPart.Parent then return end
    
    local torvel = (RootPart.Velocity*Vector3.new(1,0,1)).magnitude 
    local hitfloor = rayCast(RootPart.Position,(cf(RootPart.Position,RootPart.Position - Vector3.new(0,1,0))).lookVector,4,Character)
    
    if not attack then idle = idle + 1 else idle = 0 end

    if RootPart.Velocity.y > 1 and hitfloor==nil then 
        Anim="Jump"
        if not attack then
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(-5),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(-10),math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(-20),math.rad(0),math.rad(20)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*angles(math.rad(-20),math.rad(0),math.rad(-20)),0.15)
                -- Legs bend in air
                if RH then RH.C0=clerp(RH.C0,cf(1,-0.7,0)*angles(math.rad(-15),math.rad(90),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(-25),math.rad(-90),math.rad(0)),0.15) end
            end)
        end
    elseif RootPart.Velocity.y < -1 and hitfloor==nil then 
        Anim="Fall"
        if not attack then
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(5),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(10),math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(10),math.rad(0),math.rad(10)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*angles(math.rad(10),math.rad(0),math.rad(-10)),0.15)
                -- Legs extend out in air
                if RH then RH.C0=clerp(RH.C0,cf(1,-0.9,0)*angles(math.rad(10),math.rad(90),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-0.9,0)*angles(math.rad(10),math.rad(-90),math.rad(0)),0.15) end
            end)
        end
    elseif torvel<1 and hitfloor~=nil then
        if not attack and not sitting and not resting and not meditating then
            Anim="Idle"
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-0.1+0.1*math.cos(sine/30))*angles(math.rad(-2.5*math.cos(sine/30)),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(-5*math.cos(sine/30))+ -math.sin(sine/30)/15,math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.55+0.05*math.cos(sine/30)+ -math.sin(sine/30)/40,0)*angles(math.rad(5-2.5*math.cos(sine/30)),math.rad(0),math.rad(10+5*math.cos(sine/30))+ math.sin(sine/30)/20),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.55+0.05*math.cos(sine/30)+ -math.sin(sine/30)/40,0)*angles(math.rad(5-2.5*math.cos(sine/30)),math.rad(0),math.rad(-10-5*math.cos(sine/30))+ -math.sin(sine/30)/20),0.15)
                -- Legs steady breathing motion
                if RH then RH.C0=clerp(RH.C0,cf(1,-0.9-0.1*math.cos(sine/30),0.025*math.cos(sine/30))*angles(math.rad(-2.5*math.cos(sine/30)),math.rad(90),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-0.9-0.1*math.cos(sine/30),0.025*math.cos(sine/30))*angles(math.rad(-2.5*math.cos(sine/30)),math.rad(-90),math.rad(0)),0.15) end
            end)
        elseif not attack and sitting then
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-1.9)*angles(math.rad(-45-2.5*math.cos(sine/30)),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(-5*math.cos(sine/30))+ -math.sin(sine/30)/15,math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.45,0)*angles(math.rad(-45-2.5*math.cos(sine/30)),math.rad(0),math.rad(10)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.45,0)*angles(math.rad(-45-2.5*math.cos(sine/30)),math.rad(0),math.rad(-10)),0.15)
                -- Legs folded
                if RH then RH.C0=clerp(RH.C0,cf(1,-1,0.025*math.cos(sine/30))*angles(math.rad(45-2.5*math.cos(sine/30)),math.rad(90),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-1,0.025*math.cos(sine/30))*angles(math.rad(45-2.5*math.cos(sine/30)),math.rad(-90),math.rad(0)),0.15) end
            end)
        elseif not attack and resting then
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-2.3)*angles(math.rad(-80-1*math.cos(sine/30)),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(5-1*math.cos(sine/30))+ -math.sin(sine/30)/15,math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1,0.75,0.1)*angles(math.rad(215-1*math.cos(sine/30)),math.rad(0),math.rad(-45)),0.15)
                LW.C0=clerp(LW.C0,cf(-1,0.75,0.1)*angles(math.rad(200-1*math.cos(sine/30)),math.rad(0),math.rad(45)),0.15)
                -- Legs flat
                if RH then RH.C0=clerp(RH.C0,cf(1,-1,0.025*math.cos(sine/30))*angles(math.rad(25-1*math.cos(sine/30)),math.rad(90),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-1,0.025*math.cos(sine/30))*angles(math.rad(10-1*math.cos(sine/30)),math.rad(-90),math.rad(0)),0.15) end
            end)
        elseif not attack and meditating then
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-1.9)*angles(math.rad(10-1*math.cos(sine/30)),math.rad(0),math.rad(0)),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0)*angles(math.rad(10-1*math.cos(sine/30))+ -math.sin(sine/30)/15,math.rad(0),math.rad(0)),0.15)
                RW.C0=clerp(RW.C0,cf(1.25,0.5,-0.5)*angles(math.rad(0),math.rad(165),math.rad(90)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.25,0.5,-0.5)*angles(math.rad(0),math.rad(-165),math.rad(-90)),0.15)
                -- Legs crossed
                if RH then RH.C0=clerp(RH.C0,cf(1,-1,0.1)*angles(math.rad(-30),math.rad(75),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-1,0.1)*angles(math.rad(-30),math.rad(-75),math.rad(0)),0.15) end
            end)
        end
    elseif torvel>2 and torvel<22 and hitfloor~=nil then
        if not attack and not sprint then
            Anim="Walk"
            change=0.5
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-0.175+0.025*math.cos(sine/3.5)+ -math.sin(sine/3.5)/7)*angles(math.rad(5-2.5*math.cos(sine/3.5)),math.rad(0),math.rad(10*math.cos(sine/7))),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0+0.025*math.cos(sine/3.5))*angles(math.rad(0-2.5*math.cos(sine/3.5)),math.rad(1.5*math.cos(sine/7)),math.rad(-7.5*math.cos(sine/7))),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(30*math.cos(sine/7))+ math.sin(sine/7)/2.5,math.rad(0),math.rad(10)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*angles(math.rad(-30*math.cos(sine/7))+ -math.sin(sine/7)/2.5,math.rad(0),math.rad(-10)),0.15)
                -- Legs walking (opposite arm swing)
                if RH then RH.C0=clerp(RH.C0,cf(1,-0.925-0.5*math.cos(sine/7)/2,0.5*math.cos(sine/7)/2)*angles(math.rad(-15-15*math.cos(sine/7))+ -math.sin(sine/7)/2.5,math.rad(90-10*math.cos(sine/7)),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-0.925+0.5*math.cos(sine/7)/2,-0.5*math.cos(sine/7)/2)*angles(math.rad(-15+15*math.cos(sine/7))+ math.sin(sine/7)/2.5,math.rad(-90-10*math.cos(sine/7)),math.rad(0)),0.15) end
            end)
        elseif not attack and sprint then
            Anim="Sprint"
            change=1
            safePose(function()
                RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,-0.1+0.1*math.cos(sine/3.5)+ -math.sin(sine/3.5)/7)*angles(math.rad(5-2.5*math.cos(sine/3.5)),math.rad(0),math.rad(10*math.cos(sine/7))),0.15)
                Neck.C0=clerp(Neck.C0,necko*cf(0,0,0+0.025*math.cos(sine/3.5))*angles(math.rad(0-2.5*math.cos(sine/3.5)),math.rad(1.5*math.cos(sine/7)),math.rad(-7.5*math.cos(sine/7))),0.15)
                RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*angles(math.rad(45*math.cos(sine/7))+ math.sin(sine/7)/2.5,math.rad(0),math.rad(10)),0.15)
                LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*angles(math.rad(-45*math.cos(sine/7))+ -math.sin(sine/7)/2.5,math.rad(0),math.rad(-10)),0.15)
                -- Legs sprinting (faster, higher lift)
                if RH then RH.C0=clerp(RH.C0,cf(1,-0.9-0.25*math.cos(sine/7)/2,0.5*math.cos(sine/7)/2)*angles(math.rad(-15-45*math.cos(sine/7))+ -math.sin(sine/7)/2.5,math.rad(90-10*math.cos(sine/7)),math.rad(0)),0.15) end
                if LH then LH.C0=clerp(LH.C0,cf(-1,-0.9+0.25*math.cos(sine/7)/2,-0.5*math.cos(sine/7)/2)*angles(math.rad(-15+45*math.cos(sine/7))+ math.sin(sine/7)/2.5,math.rad(-90-10*math.cos(sine/7)),math.rad(0)),0.15) end
            end)
        end
    end
end)

print("Only instinct left is survival.")
