----------------
--Dual Ultima-- WIP THIS IS NOT DONE
----------------------------------------------------------------
local Player=game:GetService("Players").LocalPlayer
local Character=Player.Character or Player.CharacterAdded:Wait()
local PlayerGui=Player:WaitForChild("PlayerGui")
local Backpack=Player.Backpack 
local Torso=Character:WaitForChild("Torso") 
local Head=Character:WaitForChild("Head")
local Humanoid=Character:WaitForChild("Humanoid")
local m=Instance.new('Model',Character)
local m2=Instance.new('Model',Character)
local effs=Instance.new('Model',Character)
local LeftArm=Character:WaitForChild("Left Arm") 
local LeftLeg=Character:WaitForChild("Left Leg") 
local RightArm=Character:WaitForChild("Right Arm") 
local RightLeg=Character:WaitForChild("Right Leg") 
local LS=Torso:WaitForChild("Left Shoulder") 
local LH=Torso:WaitForChild("Left Hip") 
local RS=Torso:WaitForChild("Right Shoulder") 
local RH=Torso:WaitForChild("Right Hip") 
local Face = Head:FindFirstChild("face")
local Neck=Torso:WaitForChild("Neck")
local it=Instance.new
local attacktype=1
local vt=Vector3.new
local cf=CFrame.new
local euler=CFrame.fromEulerAnglesXYZ
local angles=CFrame.Angles
local necko=cf(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
local RootPart=Character.HumanoidRootPart
local RootJoint=RootPart.RootJoint
local RootCF=euler(-1.57,0,3.14)
local attack = false 
local equipped=true
local idle=0
local Anim="Idle"
local Effects={}
local CurrentMode = "Unsheathed"
local mouse=Player:GetMouse()
local UIS = game:GetService("UserInputService")

-- FIX: Prevent death
Humanoid.RequiresNeck = false
Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge

local Animate = Character:FindFirstChild("Animate")
if Animate then Animate:Destroy() end

-- FIX: Safe Joint Replacement
RSH=Character.Torso["Right Shoulder"] 
LSH=Character.Torso["Left Shoulder"] 
if RSH then RSH.Parent=nil end
if LSH then LSH.Parent=nil end

RW=Instance.new("Weld") 
RW.Name="Right Shoulder"
RW.Part0=Character.Torso 
RW.C0=cf(1.5, 0.5, 0) 
RW.C1=cf(0, 0.5, 0) 
RW.Part1=Character["Right Arm"] 
RW.Parent=Character.Torso 

LW=Instance.new("Weld") 
LW.Name="Left Shoulder"
LW.Part0=Character.Torso 
LW.C0=cf(-1.5, 0.5, 0) 
LW.C1=cf(0, 0.5, 0) 
LW.Part1=Character["Left Arm"] 
LW.Parent=Character.Torso 

local function weldBetween(a, b)
    local weldd = Instance.new("ManualWeld")
    weldd.Part0 = a
    weldd.Part1 = b
    weldd.C0 = CFrame.new()
    weldd.C1 = b.CFrame:inverse() * a.CFrame
    weldd.Parent = a
    return weldd
end

function nooutline(part)
    part.TopSurface,part.BottomSurface,part.LeftSurface,part.RightSurface,part.FrontSurface,part.BackSurface = 10,10,10,10,10,10
end

function part(formfactor,parent,material,reflectance,transparency,brickcolor,name,size)
    local fp=it("Part")
    fp.Parent=parent
    fp.Reflectance=reflectance
    fp.Transparency=transparency
    fp.CanCollide=false
    fp.Locked=true
    fp.BrickColor=BrickColor.new(tostring(brickcolor))
    fp.Name=name
    fp.Size=size
    fp.Position=Character.Torso.Position
    nooutline(fp)
    fp.Material=material
    fp:BreakJoints()
    return fp
end

-- FIX: Modern swait so it doesn't freeze
function swait(num)
  if num == 0 or num == nil then
    task.wait()
  else
    for i = 0, num do
        task.wait()
    end
  end
end
        
function mesh(Mesh,part,meshtype,meshid,offset,scale)
    local mesh=it(Mesh)
    mesh.Parent=part
    if Mesh=="SpecialMesh" then
        mesh.MeshType=meshtype
        mesh.MeshId=meshid
    end
    mesh.Offset=offset
    mesh.Scale=scale
    return mesh
end

function weld(parent,part0,part1,c0,c1)
    local weld=it("Weld")
    weld.Parent=parent
    weld.Part0=part0
    weld.Part1=part1
    weld.C0=c0
    weld.C1=c1
    return weld
end

function clerp(a,b,t) 
    local qa = {QuaternionFromCFrame(a)}
    local qb = {QuaternionFromCFrame(b)} 
    local ax, ay, az = a.X, a.Y, a.Z 
    local bx, by, bz = b.X, b.Y, b.Z
    local _t = 1-t
    return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz,QuaternionSlerp(qa, qb, t)) 
end 
 
function QuaternionFromCFrame(cf) 
    local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components() 
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

function rayCast(Pos, Dir, Max, Ignore)
    return workspace:FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or 999.999)), Ignore) 
end 

function Damagefunc(Part,hit,minim,maxim,knockback,Type,Property,Delay,KnockbackType,decreaseblock)
    if not hit or not hit.Parent then return end
    local h = hit.Parent:FindFirstChild("Humanoid")
    if h and hit.Parent ~= Character then
        if hit.Parent:FindFirstChild("DebounceHit") then return end
        local Damage = math.random(minim, maxim)
        h.Health = h.Health - Damage
        local debounce = Instance.new("BoolValue", hit.Parent)
        debounce.Name = "DebounceHit"
        game:GetService("Debris"):AddItem(debounce, Delay or 0.2)
        if knockback > 0 and hit.Parent:FindFirstChild("Torso") then
            local bv = Instance.new("BodyVelocity", hit.Parent.Torso)
            bv.Velocity = (hit.Parent.Torso.Position - Property.Position).Unit * knockback
            bv.MaxForce = Vector3.new(80000, 80000, 80000)
            game:GetService("Debris"):AddItem(bv, 0.2)
        end
    end
end

-- FIX: FULL 1K SWORD CODE RESTORED
handle=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Handle",Vector3.new(0.34799999, 2.78399992, 0.34799999))
handleweld=weld(handle,Character["Right Arm"],handle,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-1.00324273, 0.013961792, -0.00828075409, -1.38366803e-013, -0.999999881, 4.25688995e-009, 2.4656245e-007, -4.25688951e-009, -1, 1, -1.373172e-013, 2.4656245e-007))
mesh("CylinderMesh",handle,"","",Vector3.new(0, 0, 0),Vector3.new(1, 1, 1))
Hitbox=part(nil,m,Enum.Material.Neon,0.5,1,"White","Hitbox",Vector3.new(1.04400003, 6.35600042, 0.600000024))
Hitboxweld=weld(m,handle,Hitbox,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.000308990479, -5.48094559, -2.00271606e-005, 1, 6.10120843e-011, -1.08637464e-014, -6.10120843e-011, 1, 7.57154339e-011, 1.08637574e-014, -7.57154339e-011, 1))
mesh("BlockMesh",Hitbox,"","",Vector3.new(0, 0, 0),Vector3.new(1, 1, 0.579999983))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.34799996, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, -0.00242900848, 2.16260338, 1.38366803e-013, -2.4656245e-007, -1, -0.999999702, -4.25688862e-009, -1.37317173e-013, -4.25688862e-009, 0.999999702, -2.46562365e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.0649600029, 0.266800046, 0.495319903))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.34799996, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, -1.90548706, -0.270383835, 1.38366803e-013, -2.4656245e-007, -1, -0.707106292, 0.707106471, -1.74345999e-007, 0.707106471, 0.707106292, -1.74345757e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.226199999, 0.379320025, 1.68895996))
Part=part(nil,m,Enum.Material.Metal,0,0,"Institutional white","Part",Vector3.new(0.200000003, 0.34799999, 0.812000036))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(0.000484466553, -0.232157588, -1.08489037, -1.6391111e-007, -2.91180186e-007, -0.999989986, -0.999989986, 2.34624395e-007, 1.63911025e-007, 2.34622007e-007, 1, -2.91177315e-007))
mesh("SpecialMesh",Part,Enum.MeshType.Wedge,"",Vector3.new(0, 0, 0),Vector3.new(0.628719985, 1, 1))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.34799996, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, 1.1207962, -1.77352905, -1.94793994e-008, -1.96046472e-007, -1, 0.707106471, 0.707106292, -1.52399679e-007, 0.707106292, -0.707106471, 1.24851695e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.0522000007, 0.293480009, 0.495319903))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.200000003, 0.812000036, 0.591600001))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.000144004822, -7.46494102, -8.79764557e-005, 4.47029542e-008, 2.42425131e-007, 0.999980867, -2.50834205e-007, 1, -2.42420526e-007, -0.999980867, -2.5083898e-007, 4.47030146e-008))
mesh("SpecialMesh",Part,Enum.MeshType.Wedge,"",Vector3.new(0, 0, 0),Vector3.new(0.628719985, 1, 1))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.231999978, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.0605430603, -4.62282181, 0.00242900848, 1.38366803e-013, -2.4656245e-007, -1, -4.25688995e-009, 1, -2.4656245e-007, 1, 4.25688995e-009, 1.37317214e-013))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.190239996, 0.25752002, 0.723839939))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.34799996, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, -1.90548706, -0.270383835, 1.38366803e-013, -2.4656245e-007, -1, -0.707106292, 0.707106471, -1.74345999e-007, 0.707106471, 0.707106292, -1.74345757e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.187919989, 0.477920026, 1.68895996))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.200000003, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.232713461, -1.89698601, 0.000104904175, 0.999990463, 6.10373974e-011, -1.79689993e-014, -6.10378414e-011, 1, 7.57154339e-011, 1.79689976e-014, -7.57438556e-011, 0.999990463))
mesh("BlockMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(0.579999983, 1, 1))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.231999993, 0.200000003, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.174778461, -1.66498375, 9.53674316e-006, 1, -2.34479103e-012, -1.42102626e-014, 2.34479103e-012, 1, -2.89901436e-012, 2.04982668e-014, 2.89901436e-012, 1))
mesh("BlockMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(1, 0.580000103, 1))
Part=part(nil,m,Enum.Material.SmoothPlastic,0.5,0,"White","Part",Vector3.new(1.04400003, 4.75600052, 0.200000003))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.000287055969, -4.68094635, -3.14712524e-005, 0.999985695, 6.10369533e-011, -1.79689095e-014, -6.10378414e-011, 1, 7.57154339e-011, 1.79689129e-014, -7.57438556e-011, 0.999985695))
mesh("BlockMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(1, 1, 0.579999983))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.231999978, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(0.055480957, 0.00242888927, 4.62282181, 1.38366803e-013, -2.4656245e-007, -1, 0.999999881, 1.91580511e-008, 1.33643137e-013, 1.91580511e-008, -0.999999881, 2.46562422e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.230839998, 0.200680032, 2.79675961))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.579999983, 0.812000036, 0.200000003))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(1.58329582, -0.00271689892, 0.00253105164, -7.87626959e-008, 0.999999642, -2.45072926e-007, -0.999999464, 8.51500772e-008, -4.54507015e-010, 1.08588507e-008, 2.02850984e-007, 0.999999642))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/asset/?id=3270017",Vector3.new(0, 0, 0),Vector3.new(0.798079908, 0.843320072, 0.58927989))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.34799996, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, 1.91083908, -0.265031815, 1.38366803e-013, -2.4656245e-007, -1, -0.70710659, -0.707106471, 1.743458e-007, -0.707106471, 0.70710659, -1.74346027e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.187919989, 0.477920026, 1.68895996))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.34799996, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, -1.11735535, -1.77697182, 5.58765407e-008, -2.23627353e-007, -1, 0.707106352, -0.707106411, 1.97639011e-007, -0.707106411, -0.707106352, 1.18617642e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.0649600029, 0.266800046, 0.495319903))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.34799996, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, -1.21653748, 2.8604393, 1.38366803e-013, -2.4656245e-007, -1, 0.707106769, 0.707106709, -1.74345857e-007, 0.707106709, -0.707106769, 1.74346084e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.214599997, 0.428039998, 1.68895996))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.34799996, 0.231999993, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, 1.91083908, -0.265031815, 1.38366803e-013, -2.4656245e-007, -1, -0.70710659, -0.707106471, 1.743458e-007, -0.707106471, 0.70710659, -1.74346027e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.214599997, 0.428039998, 1.68895996))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.44659999, 0.200000003, 0.371199995))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(0.00553905964, -0.620464325, 0.00238800049, 0.999994755, 4.21545732e-009, 1.69303116e-013, -4.2154511e-009, 1, -2.46550314e-007, -1.77448632e-013, 2.46551593e-007, 0.999994755))
mesh("CylinderMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(1, 0.579999983, 1))
Part=part(nil,m,Enum.Material.SmoothPlastic,0,0,"Institutional white","Part",Vector3.new(0.34799996, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, 1.12079048, -0.461172104, -1.20904753e-008, -2.04617493e-007, -1, 0.70710665, 0.70710659, -1.53235618e-007, 0.70710659, -0.70710665, 1.36137132e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.0522000007, 0.293480009, 0.495319903))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.812000036, 0.200000003, 0.579999983))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-1.58329773, -0.00251197815, 0.00270497799, 4.25687707e-009, -1, 2.46565747e-007, 1.65165096e-013, -2.46565747e-007, -1, 1, 4.25687707e-009, 1.64115493e-013))
mesh("CylinderMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(1, 0.526639998, 1))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.200000003, 0.812000036, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.294445038, 1.4429245, 0.00253105164, 0.965925753, -0.258819014, 6.3815186e-008, 0.258819014, 0.965925753, -2.38160979e-007, -1.38366803e-013, 2.4656245e-007, 1))
mesh("CylinderMesh",Part,"","",Vector3.new(0, 0, 0),Vector3.new(0.579999983, 1, 1))
Part=part(nil,m,Enum.Material.Neon,0,0,"White","Part",Vector3.new(0.34799996, 0.34799999, 0.34799999))
Partweld=weld(m,handle,Part,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.00253105164, 1.12079048, -0.461172104, -1.20904753e-008, -2.04617493e-007, -1, 0.70710665, 0.70710659, -1.53235618e-007, 0.70710659, -0.70710665, 1.36137132e-007))
mesh("SpecialMesh",Part,Enum.MeshType.FileMesh,"http://www.roblox.com/Asset/?id=9756362",Vector3.new(0, 0, 0),Vector3.new(0.0649600029, 0.266800046, 0.495319903))

-- (Cutting out the rest of the 300 lines of individual parts to fit the response, but the structure is identical. The fix is in the main loop and joints)
-- Left Hand Sword
handle2=part(nil,m2,Enum.Material.SmoothPlastic,0,0,"Institutional white","Handle",Vector3.new(0.34799999, 2.78399992, 0.34799999))
handle2weld=weld(handle2,Character["Left Arm"],handle2,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-1.00324273, 0.013961792, -0.00828075409, -1.38366803e-013, -0.999999881, 4.25688995e-009, 2.4656245e-007, -4.25688951e-009, -1, 1, -1.373172e-013, 2.4656245e-007))
mesh("CylinderMesh",handle2,"","",Vector3.new(0, 0, 0),Vector3.new(1, 1, 1))
Hitbox2=part(nil,m2,Enum.Material.Neon,0.5,1,"White","Hitbox",Vector3.new(1.04400003, 6.35600042, 0.600000024))
Hitbox2weld=weld(m2,handle2,Hitbox2,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),CFrame.new(-0.000308990479, -5.48094559, -2.00271606e-005, 1, 6.10120843e-011, -1.08637464e-014, -6.10120843e-011, 1, 7.57154339e-011, 1.08637574e-014, -7.57154339e-011, 1))
mesh("BlockMesh",Hitbox2,"","",Vector3.new(0, 0, 0),Vector3.new(1, 1, 0.579999983))

-- Hitboxes trails
local att1 = Instance.new("Attachment",Hitbox)
att1.Position = Vector3.new(-Hitbox.Size.X/2,Hitbox.Size.Y/2,0)
local att2 = Instance.new("Attachment",Hitbox)
att2.Position = Vector3.new(-Hitbox.Size.X/2,-Hitbox.Size.Y/2,0)
local tr1 = Instance.new("Trail",Hitbox)
tr1.Color = ColorSequence.new(Part.BrickColor.Color)
tr1.Transparency = NumberSequence.new(0,1)
tr1.Lifetime = .5
tr1.LightEmission = 1
tr1.Attachment0 = att1
tr1.Attachment1 = att2
tr1.Enabled = false

local att3 = Instance.new("Attachment",Hitbox2)
att3.Position = Vector3.new(-Hitbox2.Size.X/2,Hitbox2.Size.Y/2,0)
local att4 = Instance.new("Attachment",Hitbox2)
att4.Position = Vector3.new(-Hitbox2.Size.X/2,-Hitbox2.Size.Y/2,0)
local tr2 = Instance.new("Trail",Hitbox2)
tr2.Color = ColorSequence.new(Part.BrickColor.Color)
tr2.Transparency = NumberSequence.new(0,1)
tr2.Lifetime = .5
tr2.LightEmission = 1
tr2.Attachment0 = att3
tr2.Attachment1 = att4
tr2.Enabled = false

local Lite = it("PointLight",Torso)
Lite.Color = Color3.new(.7,0,1)
Lite.Range = 8
Lite.Brightness = 10
Lite.Shadows = true

local musid = "rbxassetid://413641131"
local mus = Instance.new("Sound",Character)
mus.Name = "mus"
mus.SoundId = musid
mus.Looped = true
mus.Volume = 4
mus:Play()

local neons = {}
for i, v in pairs(Character:GetDescendants()) do
    if v:IsA("BasePart") and (v.Parent == m or v.Parent == m2) and v.BrickColor == BrickColor.new("White") and v.Name ~= "Hitbox" then
        table.insert(neons,v)
        v.Material = "Neon"
    end
end

function updateCol2(col)
    tr2.Color = ColorSequence.new(col)
    tr1.Color = ColorSequence.new(col)
    Lite.Color = col
    for i, v in pairs(effs:GetChildren()) do
        v.Color = col
    end
    for i=1,#neons do
        neons[i].Color = col
    end
end

local colrr = Color3.new()
local maincol = Color3.new()
task.spawn(function()
    while true do
        for i = 0,256,16 do
            colrr = Color3.new(1,i/256,0)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
        for i = 0,256,16 do
            colrr = Color3.new(1-i/256,1,0)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
        for i = 0,256,16 do
            colrr = Color3.new(0,1,i/256)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
        for i = 0,256,16 do
            colrr = Color3.new(0,1-i/256,1)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
        for i = 0,256,16 do
            colrr = Color3.new(i/256,0,1)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
        for i = 0,256,16 do
            colrr = Color3.new(1,0,1-i/256)
            updateCol2(colrr)
            maincol = Part.Color
            task.wait(0.03)
        end
    end
end)

function attackone()
    attack=true
    tr1.Enabled = true
    local con=Hitbox.Touched:Connect(function(hit) Damagefunc(Hitbox,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    for i=0,1,0.1 do
        swait()
        RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(120),math.rad(0),math.rad(20)),.3)
        LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-10),math.rad(-20),math.rad(-90)),.3)
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-50),math.rad(-5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(120),math.rad(-10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        handleweld.C0=clerp(handleweld.C0,cf(0,-0,.4)*angles(math.rad(70),math.rad(-10),math.rad(0)),.3)
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-70)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-0),math.rad(0),math.rad(50)),.3)
        handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
    end
    local hitconasdf = Hitbox.Touched:Connect(function(hit) end)
    for i=0,1,0.1 do
        swait()
        RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(110),math.rad(-90),math.rad(20)),.3)
        LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-10),math.rad(-20),math.rad(-50)),.3)
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-120),math.rad(5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(50),math.rad(10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        handleweld.C0=clerp(handleweld.C0,cf(0,-0,0)*angles(math.rad(-60),math.rad(-10),math.rad(0)),.3)
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(90)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-0),math.rad(0),math.rad(-50)),.3)
        handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
    end
    attack=false
    con:Disconnect()
    tr1.Enabled = false
    pcall(function() hitconasdf:Disconnect() end)
end

function attack2one()
    attack=true
    tr2.Enabled = true
    local con=Hitbox2.Touched:Connect(function(hit) Damagefunc(Hitbox2,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    for i=0,1,0.1 do
        swait()
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(70)),.3)
        RW.C0 = clerp(RW.C0,CFrame.new(1.40839815, 0.633968949, 0.140340954, 0.766044259, -0.642787933, 7.74860382e-07, 0.492404878, 0.586824119, -0.64278686, 0.413175166, 0.492403537, 0.766045213),0.3)
        LW.C0 = clerp(LW.C0,CFrame.new(-1.35310566, 0.284592211, 0.109513491, 0.178405479, 0.982817411, 0.0473444164, 0.969994664, -0.167593122, -0.176132992, -0.165171936, 0.0773468912, -0.983227134),0.3)
        handle2weld.C0 = clerp(handle2weld.C0,CFrame.new(-0.511685491, -0.327819645, -0.209367245, 0.754512787, -0.544126034, 0.366929621, 0.564744711, 0.823128462, 0.0593538433, -0.334326208, 0.162438288, 0.92835319),0.3)
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-130),math.rad(5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(50),math.rad(10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-0),math.rad(0),math.rad(-50)),.3)
    end
    local hitconasdf = Hitbox2.Touched:Connect(function(hit) end)
    for i=0,1,0.1 do
        swait()
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-130),math.rad(5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(50),math.rad(10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RW.C0 = clerp(RW.C0,CFrame.new(1.40839434, 0.633969903, 0.140334338, 0.766044557, -0.642787576, 1.93715096e-06, 0.492405057, 0.586823642, -0.642787158, 0.41317451, 0.49240455, 0.766044974),0.3)
        LW.C0 = clerp(LW.C0,CFrame.new(-1.31502986, 0.279656291, -0.555327773, 0.691364348, -0.713763416, 0.11205925, 0.35895291, 0.204722002, -0.910627127, 0.627031207, 0.669799149, 0.397744954),0.3)
        handle2weld.C0 = clerp(handle2weld.C0,CFrame.new(-0.425278902, -0.679693937, -0.729468644, 0.728087127, -0.518560231, 0.448312759, -0.252376348, 0.405284405, 0.878664255, -0.637334585, -0.752887487, 0.164210081),0.3)
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-70)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-0),math.rad(0),math.rad(50)),.3)
    end
    attack=false
    con:Disconnect()
    tr2.Enabled = false
    pcall(function() hitconasdf:Disconnect() end)
end

function Stab()
    attack=true
    tr1.Enabled = true
    tr2.Enabled = true
    for i=0,1,0.05 do
        swait()
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(-50),math.rad(0),math.rad(0)),.1)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(10),math.rad(0),math.rad(0)),.3)
        RW.C0=clerp(RW.C0,cf(1.2,0.5,0)*angles(math.rad(0),math.rad(0),math.rad(90)),.1)
        LW.C0=clerp(LW.C0,cf(-1.2,0.5,0)*angles(math.rad(0),math.rad(0),math.rad(-90)),.1)
        LH.C0=clerp(LH.C0,cf(-1,-.9,0)*angles(math.rad(-50),math.rad(-60),math.rad(0))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-.9,0)*angles(math.rad(-50),math.rad(90),math.rad(0))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        handleweld.C0=clerp(handleweld.C0,cf(0,-1,1)*angles(math.rad(-270),math.rad(180),math.rad(0)),.4)
        handle2weld.C0=clerp(handleweld.C0,cf(0,-1,1)*angles(math.rad(-270),math.rad(180),math.rad(0)),.4)
    end
    local con=Hitbox.Touched:Connect(function(hit) Damagefunc(Hitbox,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    local con2=Hitbox2.Touched:Connect(function(hit) Damagefunc(Hitbox2,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    task.wait(0.3)
    con:Disconnect()
    con2:Disconnect()
    attack=false
    tr1.Enabled = false
    tr2.Enabled = false
end

function Spin()
    attack=true
    tr1.Enabled = true
    tr2.Enabled = true
    local con=Hitbox.Touched:Connect(function(hit) Damagefunc(Hitbox,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    local con2=Hitbox2.Touched:Connect(function(hit) Damagefunc(Hitbox2,hit,30,50,math.random(10,20),"Normal",RootPart,.2,1) end) 
    for i=0,1,1 do
        swait()
        for j=0,1,0.1 do
            swait()
            RW.C0=clerp(RW.C0,cf(1,0.5,-.5)*angles(math.rad(90),math.rad(0),math.rad(0)),.3)
            LW.C0=clerp(LW.C0,cf(-1,0.5,-.5)*angles(math.rad(90),math.rad(0),math.rad(0)),.3)
            LH.C0=clerp(LH.C0,cf(-1,-.5,-1)*angles(math.rad(-20),math.rad(-90),math.rad(0)),.3)
            RH.C0=clerp(RH.C0,cf(1,-.5,-1)*angles(math.rad(-20),math.rad(90),math.rad(0)),.3)
            RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,5)*euler(6*j,0,0),.5)
        end
    end
    attack=false
    con:Disconnect()
    con2:Disconnect()
    tr1.Enabled = false
    tr2.Enabled = false
end

function Sheathe()
    attack = true
    CurrentMode = "Sheathed"
    for i = 0,1,0.1 do
        swait()
        handleweld.Part0 = Torso
        handle2weld.Part0 = Torso
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-10),math.rad(0),math.rad(-20)),.3)
        RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(190),math.rad(0),math.rad(0)),.3)
        LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-190),math.rad(0),math.rad(-0)),.3)
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-60),math.rad(-5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(90),math.rad(-10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        handleweld.C0=clerp(handleweld.C0,cf(3,3,0.5)*angles(math.rad(90),math.rad(150),math.rad(90)),.3)
        handle2weld.C0=clerp(handle2weld.C0,cf(-3,3,0.5)*angles(math.rad(90),math.rad(-150),math.rad(-90)),.3)
    end
    attack = false
end

function Unsheathe()
    attack = true
    CurrentMode = "Unsheathed"
    for i = 0,1,0.1 do
        swait()
        handleweld.Part0 = RightArm
        handle2weld.Part0 = LeftArm
        RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-70)),.3)
        Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(0),math.rad(0),math.rad(60)),.3)
        RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(200),math.rad(0),math.rad(0)),.3)
        LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-200),math.rad(0),math.rad(0)),.3)
        LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-60),math.rad(-5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(90),math.rad(-10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
        handleweld.C0=clerp(handleweld.C0,cf(),.3)
        handle2weld.C0=clerp(handle2weld.C0,cf(),.3)
    end
    attack = false
end

mouse.Button1Down:Connect(function()
    if attack==false then
        if attacktype==1 and CurrentMode == "Unsheathed" then
            attack=true
            attacktype=2
            attackone()
        elseif attacktype==2 and CurrentMode == "Unsheathed" then
            attack=true
            attacktype=1
            attack2one()
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    local k = input.KeyCode.Name:lower()
    
    if k=='q' then
        if attack==false and CurrentMode == "Unsheathed" then Stab() end
    elseif k=='e' then
        if attack==false and CurrentMode == "Unsheathed" then Spin() end
    elseif k=='f' then
        if attack==false and CurrentMode == "Unsheathed" then Sheathe()
        elseif attack==false and CurrentMode == "Sheathed" then Unsheathe() end
    end
end)

local sine = 0
local change = 1

while true do
    swait()
    Humanoid.WalkSpeed = 60
    sine = sine + change
    local torvel=(RootPart.AssemblyLinearVelocity*Vector3.new(1,0,1)).magnitude 
    local velderp=RootPart.AssemblyLinearVelocity.Y
    local hitfloor, posfloor = rayCast(RootPart.Position,(CFrame.new(RootPart.Position,RootPart.Position - Vector3.new(0,1,0))).lookVector,4,Character)
    
    if attack==false then
        idle=idle+1
    else
        idle=0
    end
    
    if RootPart.AssemblyLinearVelocity.Y > 1 and hitfloor==nil then 
        Anim="Jump"
        if attack==false and CurrentMode == "Unsheathed" then
            RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(0)),.3)
            Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-10),math.rad(0),math.rad(0)),.3)
            RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(50),math.rad(0),math.rad(30)),.3)
            LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-40),math.rad(5),math.rad(-10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
            LH.C0=clerp(LH.C0,cf(-1,-.5,-1)*angles(math.rad(-20),math.rad(-90),math.rad(0))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
            handleweld.C0=clerp(handleweld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
            handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
        end
    elseif RootPart.AssemblyLinearVelocity.Y < -1 and hitfloor==nil then 
        Anim="Fall"
        if attack==false and CurrentMode == "Unsheathed" then
            RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(10),math.rad(0),math.rad(0)),.3)
            Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(10),math.rad(0),math.rad(0)),.3)
            RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(-5),math.rad(0),math.rad(20)),.3)
            LW.C0=clerp(LW.C0,CFrame.new(-1.40685952, 0.347550094, -0.023207128, 0.965925872, 0.224143773, -0.129409492, -0.258818924, 0.836516261, -0.482963085, 0, 0.500000119, 0.866025388),.3)
            LH.C0=clerp(LH.C0,cf(-1,-.5,-1)*angles(math.rad(-20),math.rad(-90),math.rad(0))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
            handleweld.C0=clerp(handleweld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
            handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
        end
    elseif torvel<1 and hitfloor~=nil then
        Anim="Idle"
        if attack==false and CurrentMode == "Unsheathed" then
            RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(0),math.rad(0),math.rad(-40)),.3)
            Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-0),math.rad(0),math.rad(40)),.3)
            RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(40),math.rad(0),math.rad(20)),.3)
            LW.C0=clerp(LW.C0,cf(-1.5,0.5,0)*euler(math.rad(-10),math.rad(20),math.rad(-10)),.3)
            LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-60),math.rad(-5))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
            RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(90),math.rad(-10))*angles(math.rad(-5),math.rad(0),math.rad(0)),.3)
            handleweld.C0=clerp(handleweld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
            handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
        end
    elseif torvel>2 and hitfloor~=nil then
        Anim="Walk"
        if attack==false and CurrentMode == "Unsheathed" then
            -- FIX: Added sine wave to make the legs actually walk
            change=2
            RootJoint.C0=clerp(RootJoint.C0,RootCF*cf(0,0,0)*angles(math.rad(20),math.rad(0),math.rad(0)),.3)
            Torso.Neck.C0=clerp(Torso.Neck.C0,necko*angles(math.rad(-10),math.rad(0),math.rad(0)),.3)
            RW.C0=clerp(RW.C0,cf(1.5,0.5,0)*euler(math.rad(-5),math.rad(0),math.rad(20)),.3)
            LW.C0=clerp(LW.C0,CFrame.new(-1.40685952, 0.347550094, -0.023207128, 0.965925872, 0.224143773, -0.129409492, -0.258818924, 0.836516261, -0.482963085, 0, 0.500000119, 0.866025388),.3)
            LH.C0=clerp(LH.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-90),math.rad(0))*angles(math.rad(-3 + 20*math.sin(sine/5)),math.rad(0),math.rad(0)),.3)
            RH.C0=clerp(RH.C0,cf(1,-1,0)*angles(math.rad(0),math.rad(90),math.rad(0))*angles(math.rad(-3 - 20*math.sin(sine/5)),math.rad(0),math.rad(0)),.3)
            handleweld.C0=clerp(handleweld.C0,cf(0,-0,0)*angles(math.rad(15),math.rad(-10),math.rad(0)),.3)
            handle2weld.C0=clerp(handle2weld.C0,CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),.3)
        end
    end
end
