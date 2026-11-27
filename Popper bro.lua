--[[
Popper bro made by ellernate.lol
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local genv = (getgenv and getgenv()) or _G
if genv.__PopperHub then
	pcall(genv.__PopperHub.Destroy)
end

local CONFIG = {
	Music = true, -- the original autoplays one of three songs; M pauses it
	MusicIds = { 3225053934, 167079536, 2901691479 },
	MusicVolume = 1.5,
	StartWalkSpeed = 40, -- the original starts at 40 and drops to 32 after the first move
	MugStandIn = true,
	HideRealParts = false, -- hides the real head, torso and arms under the morph
}

local lp = Players.LocalPlayer
local conns = {}
local function track(c) conns[#conns + 1] = c; return c end

-- ============================== DATA (generated from the .rbxm) ==============================
local BODY = {
	["Right Arm"] = {
		{c="Part",n="MeshPart",sz=Vector3.new(1.05189,0.80608,1.04772),col=Color3.fromRGB(4,175,236),mat=1296,tr=0,sh=1,mesh="430080282",scale=Vector3.new(1.02991,0.40182,1.02991),rel=CFrame.new(0.00001,-0.62,0)},
		{c="Part",n="MeshPart",sz=Vector3.new(1.09297,0.26608,1.08864),col=Color3.fromRGB(202,203,209),mat=1296,tr=0,sh=1,mesh="430080282",scale=Vector3.new(1.07013,0.13264,1.07013),rel=CFrame.new(0.00001,-0.35,0)},
	},
	["Left Arm"] = {
		{c="Part",n="MeshPart",sz=Vector3.new(1.09297,0.26608,1.08864),col=Color3.fromRGB(202,203,209),mat=1296,tr=0,sh=1,mesh="430080282",scale=Vector3.new(1.07013,0.13264,1.07013),rel=CFrame.new(0.00001,-0.35,0)},
		{c="Part",n="MeshPart",sz=Vector3.new(1.05189,0.80608,1.04772),col=Color3.fromRGB(4,175,236),mat=1296,tr=0,sh=1,mesh="430080282",scale=Vector3.new(1.02991,0.40182,1.02991),rel=CFrame.new(0.00001,-0.62,0)},
	},
	["Head"] = {
		{c="Part",n="untitled",sz=Vector3.new(1.66144,1.73554,1.57814),col=Color3.fromRGB(163,162,165),mat=256,tr=0,sh=1,mesh="1090610",scale=Vector3.new(1.28668,1.28668,1.28578),tex="6127215723",rel=CFrame.new(0.00001,0.32155,0.02715,0,0,-1,-0.25882,0.96593,0,0.96593,0.25882,0)},
	},
	["Torso"] = {
		{c="Part",n="Blocky Torso",sz=Vector3.new(0.2338,2.11,1.055),col=Color3.fromRGB(27,42,53),mat=256,tr=0,sh=1,mesh="2027989253",scale=Vector3.new(0.1169,1.055,1.055),rel=CFrame.new(-0.69999,0,0)},
		{c="Part",n="Meshes/Bag",sz=Vector3.new(2.00965,2.46954,2.57898),col=Color3.fromRGB(9,137,207),mat=256,tr=0,sh=1,mesh="522744434",scale=Vector3.new(0.03278,0.06068,0.05634),rel=CFrame.new(-0.03499,0.00386,1.36703,0,0,-1,0.17365,0.98481,0,0.98481,-0.17365,0)},
		{c="Part",n="Meshes/Bag",sz=Vector3.new(1.99965,2.46954,2.57898),col=Color3.fromRGB(9,137,207),mat=256,tr=0,sh=1,mesh="522744434",scale=Vector3.new(0.03262,0.06068,0.05634),rel=CFrame.new(-0.03499,0.0082,1.39165,0,0,-1,0.17365,0.98481,0,0.98481,-0.17365,0)},
		{c="Part",n="Meshes/Bag",sz=Vector3.new(2.04965,2.46954,2.57898),col=Color3.fromRGB(9,137,207),mat=256,tr=0,sh=1,mesh="522744434",scale=Vector3.new(0.03343,0.06068,0.05634),rel=CFrame.new(-0.03499,0.00039,1.34734,0,0,-1,0.17365,0.98481,0,0.98481,-0.17365,0)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(0.67279,1.61656,1.6021,-0.41318,0.76604,0.4924,-0.76604,0,-0.64279,-0.4924,-0.64279,0.58682)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(-1.16459,1.83208,1.33144,0.85685,0.16318,-0.48906,-0.50334,0.05939,-0.86204,-0.11162,0.98481,0.13302)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(-1.64255,1.75961,1.415,0.69417,0.16318,0.70107,0.7024,0.05939,-0.7093,-0.15738,0.98481,-0.07339)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(-1.03802,1.71491,1.31753,0.56988,0.16318,-0.80536,-0.8205,0.05939,-0.56856,-0.04494,0.98481,0.16773)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(144,144,144),mat=880,tr=0,sh=2,rel=CFrame.new(-1.7359,1.60625,1.43972,0.33284,0.16318,0.92876,0.93635,0.05939,-0.346,-0.11162,0.98481,-0.13302)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(-1.31906,1.88363,1.35392,0.98326,0.16318,-0.08112,-0.09187,0.05939,-0.994,-0.15738,0.98481,0.07339)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(-1.49547,1.85651,1.38479,0.92542,0.16318,0.34202,0.33682,0.05939,-0.93969,-0.17365,0.98481,0)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(0.87028,1.75269,1.83745,-0.64279,0.76604,0,0,0,-1,-0.76604,-0.64279,0)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(0.75602,1.71784,1.70129,-0.58256,0.76604,0.27165,-0.42262,0,-0.90631,-0.69427,-0.64279,0.32374)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(144,144,144),mat=880,tr=0,sh=2,rel=CFrame.new(1.07361,1.59975,2.07978,-0.41318,0.76604,-0.4924,0.76604,0,-0.64279,-0.4924,-0.64279,-0.58682)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(0.62132,1.46317,1.54075,-0.16637,0.76604,0.62089,-0.96593,0,-0.25882,-0.19827,-0.64279,0.73994)},
		{c="Part",n="Flame",sz=Vector3.new(0.22057,0.18962,0.18962),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,rel=CFrame.new(0.98212,1.71194,1.97074,-0.58256,0.76604,-0.27165,0.42262,0,-0.90631,-0.69427,-0.64279,-0.32374)},
		{c="Part",n="Part",sz=Vector3.new(1.46765,1.46765,1.46765),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=0,rel=CFrame.new(0.39903,0.67101,1.29027,0.76604,0.27165,0.58256,0,0.90631,-0.42262,-0.64279,0.32374,0.69427)},
		{c="Part",n="Part",sz=Vector3.new(0.30094,0.8343,0.63367),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=2,rel=CFrame.new(0.57636,1.26265,1.50161,-0.27165,0.76604,0.58256,-0.90631,0,-0.42262,-0.32374,-0.64279,0.69427)},
		{c="Part",n="Part",sz=Vector3.new(1.46765,1.46765,1.46765),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=0,rel=CFrame.new(-0.4588,1.08273,1.25027,0.16318,-0.70107,-0.69417,0.05939,0.7093,-0.7024,0.98481,0.07339,0.15738)},
		{c="Part",n="Part",sz=Vector3.new(0.30094,0.8343,0.63367),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=2,rel=CFrame.new(-0.91646,1.54577,1.29817,0.70107,0.16318,-0.69417,-0.7093,0.05939,-0.7024,-0.07339,0.98481,0.15738)},
		{c="Part",n="Blocky Torso",sz=Vector3.new(0.2338,2.11,1.055),col=Color3.fromRGB(27,42,53),mat=256,tr=0,sh=1,mesh="2027989253",scale=Vector3.new(0.1169,1.055,1.055),rel=CFrame.new(0.70001,0,0)},
	},
}
local BODYCOLORS = { Head=Color3.new(0.96078,0.80392,0.18824), Torso=Color3.new(0.03529,0.53725,0.81176), LeftArm=Color3.new(0.96078,0.80392,0.18824), RightArm=Color3.new(0.96078,0.80392,0.18824), LeftLeg=Color3.new(0.47059,0.67451,0), RightLeg=Color3.new(0.47059,0.67451,0) }
local FX = {}
FX.Bomb = {c="Model",n="Bomb",id=96,k={{c="Part",n="Center",sz=Vector3.new(2.12925,2.12925,2.12925),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=0,id=97,cf=CFrame.new(-23.53488,-662.30298,8.88516),an=true,k={{c="Joint",p0=97,p1=106,c0=CFrame.new(0.01345,1.49761,-0.03428,0,1,0,-0.96593,0,-0.25882,-0.25882,0,0.96593),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=107,c0=CFrame.new(0.01345,1.86498,0.28623,0,1,0,-0.42262,0,-0.90631,-0.90631,0,0.42262),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=108,c0=CFrame.new(0.01345,1.71017,0.07388,0,1,0,-0.76604,0,-0.64279,-0.64279,0,0.76604),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=109,c0=CFrame.new(0.01345,1.85784,0.79593,0,1,0,0.42262,0,-0.90631,-0.90631,0,-0.42262),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=112,c0=CFrame.new(0.01345,1.24683,-0.04552,0,1,0,-0.98481,0,0.17365,0.17365,0,0.98481),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=113,c0=CFrame.new(0.01345,1.91808,0.53999,0,1,0,0,0,-1,-1,0,0),c1=CFrame.new(0,0,0)},{c="Joint",p0=97,p1=114,c0=CFrame.new(0,0.94708,0,0,1,0,-1,0,0,0,0,1),c1=CFrame.new(0,0,0)}}},{c="Model",n="Model",id=105,k={{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=106,cf=CFrame.new(-23.52142,-660.80536,8.85088,0,1,0,-0.96593,0,-0.25882,-0.25882,0,0.96593),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=107,cf=CFrame.new(-23.52142,-660.43799,9.17139,0,1,0,-0.42262,0,-0.90631,-0.90631,0,0.42262),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=108,cf=CFrame.new(-23.52142,-660.59283,8.95904,0,1,0,-0.76604,0,-0.64279,-0.64279,0,0.76604),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(248,248,248),mat=880,tr=0,sh=2,id=109,cf=CFrame.new(-23.52142,-660.44513,9.68109,0,1,0,0.42262,0,-0.90631,-0.90631,0,-0.42262),an=false,k={{c="Attachment",n="Attachment",cf=CFrame.new(0,0,0),k={{c="Emitter",n="ParticleEmitter",col=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0.01569)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0))}),size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.19325,0.52632),NumberSequenceKeypoint.new(0.71319,0.09868),NumberSequenceKeypoint.new(1,0)}),tr=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.7279,1),NumberSequenceKeypoint.new(1,1)}),life=NumberRange.new(0.5,0.5),speed=NumberRange.new(3,3),spread=Vector2.new(-5,5),rate=100,acc=Vector3.new(0,-5,0),dir=3,light=1,z=1,tex="31727915",en=true}}}}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=112,cf=CFrame.new(-23.52142,-661.05615,8.83963,0,1,0,-0.98481,0,0.17365,0.17365,0,0.98481),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=113,cf=CFrame.new(-23.52142,-660.38489,9.42515,0,1,0,0,0,-1,-1,0,0),an=false,k={}},{c="Part",n="Part",sz=Vector3.new(0.4366,1.21039,0.91932),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=2,id=114,cf=CFrame.new(-23.53488,-661.3559,8.88516,0,1,0,-1,0,0,0,0,1),an=false,k={}}}}}}
FX.FXBomb = {c="Model",n="FXBomb",id=118,k={{c="Model",n="Bomb",id=119,k={{c="Part",n="Center",sz=Vector3.new(2.12925,2.12925,2.12925),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=0,id=120,cf=CFrame.new(-4.97026,-662.17499,-9.07946,-0.99619,0,-0.08716,0,-1,0,-0.08716,0,0.99619),an=false,k={{c="Joint",p0=120,p1=129,c0=CFrame.new(0.01345,1.49761,-0.03428,0,1,0,-0.96593,0,-0.25882,-0.25882,0,0.96593),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=130,c0=CFrame.new(0.01345,1.86498,0.28623,0,1,0,-0.42262,0,-0.90631,-0.90631,0,0.42262),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=131,c0=CFrame.new(0.01345,1.71017,0.07388,0,1,0,-0.76604,0,-0.64279,-0.64279,0,0.76604),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=132,c0=CFrame.new(0.01345,1.85784,0.79593,0,1,0,0.42262,0,-0.90631,-0.90631,0,-0.42262),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=135,c0=CFrame.new(0.01345,1.24683,-0.04552,0,1,0,-0.98481,0,0.17365,0.17365,0,0.98481),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=136,c0=CFrame.new(0.01345,1.91808,0.53999,0,1,0,0,0,-1,-1,0,0),c1=CFrame.new(0,0,0)},{c="Joint",p0=120,p1=137,c0=CFrame.new(0,0.94708,0,0,1,0,-1,0,0,0,0,1),c1=CFrame.new(0,0,0)}}},{c="Model",n="Model",id=128,k={{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=129,cf=CFrame.new(-4.98068,-663.67261,-9.11478,0.02256,-0.99619,-0.08419,0.96593,0,0.25882,-0.25783,-0.08716,0.96225),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=130,cf=CFrame.new(-5.00862,-664.03998,-8.79549,0.07899,-0.99619,-0.03683,0.42262,0,0.90631,-0.90286,-0.08716,0.42101),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=131,cf=CFrame.new(-4.99011,-663.88513,-9.00704,0.05602,-0.99619,-0.06677,0.76604,0,0.64279,-0.64034,-0.08716,0.76313),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(248,248,248),mat=880,tr=0,sh=2,id=132,cf=CFrame.new(-5.05304,-664.03284,-8.28773,0.07899,-0.99619,0.03683,-0.42262,0,0.90631,-0.90286,-0.08716,-0.42101),an=false,k={{c="Attachment",n="Attachment",cf=CFrame.new(0,0,0),k={{c="Emitter",n="ParticleEmitter",col=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0.01569)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0))}),size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.19325,0.52632),NumberSequenceKeypoint.new(0.71319,0.09868),NumberSequenceKeypoint.new(1,0)}),tr=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.7279,1),NumberSequenceKeypoint.new(1,1)}),life=NumberRange.new(0.5,0.5),speed=NumberRange.new(3,3),spread=Vector2.new(-5,5),rate=100,acc=Vector3.new(0,-5,0),dir=3,light=1,z=1,tex="31727915",en=true}}}}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=135,cf=CFrame.new(-4.9797,-663.42181,-9.12599,-0.01513,-0.99619,-0.08583,0.98481,0,-0.17365,0.17299,-0.08716,0.98106),an=false,k={}},{c="Part",n="Flame",sz=Vector3.new(0.32,0.2751,0.2751),col=Color3.fromRGB(184,184,184),mat=880,tr=0,sh=2,id=136,cf=CFrame.new(-5.03073,-664.09308,-8.5427,0.08716,-0.99619,0,0,0,1,-0.99619,-0.08716,0),an=false,k={}},{c="Part",n="Part",sz=Vector3.new(0.4366,1.21039,0.91932),col=Color3.fromRGB(17,17,17),mat=832,tr=0,sh=2,id=137,cf=CFrame.new(-4.97026,-663.12207,-9.07946,0,-0.99619,-0.08716,1,0,0,0,-0.08716,0.99619),an=false,k={}}}}}},{c="Part",n="Right Arm",sz=Vector3.new(1,2,1),col=Color3.fromRGB(163,162,165),mat=256,tr=1,sh=1,id=138,cf=CFrame.new(-4.97026,-660.36761,-9.07946),an=false,k={{c="Attachment",n="RightShoulderAttachment",cf=CFrame.new(0,1,0),k={}},{c="Attachment",n="RightGripAttachment",cf=CFrame.new(0,-1,0),k={}},{c="Joint",p0=138,p1=120,c0=CFrame.new(0,-1.80736,-0.00001,-0.99619,0,-0.08716,0,-1,0,-0.08716,0,0.99619),c1=CFrame.new(0,0,0)}}}}}
FX.Icicle = {c="Model",n="Icicle",id=142,k={{c="Part",n="Damage",sz=Vector3.new(2.57619,7.24462,2.62508),col=Color3.fromRGB(152,194,219),mat=1568,tr=0.3,sh=1,mesh="4187812169",scale=Vector3.new(0.14489,0.14489,0.14489),id=143,cf=CFrame.new(12.72973,-659.78992,-19.77946),an=false,k={}},{c="Part",n="Meshes/icicle",sz=Vector3.new(2.47314,6.95484,2.52008),col=Color3.fromRGB(215,197,154),mat=288,tr=0,sh=1,mesh="4187812169",scale=Vector3.new(0.1391,0.1391,0.1391),id=144,cf=CFrame.new(12.72973,-659.93481,-19.77946),an=false,k={}},{c="Part",n="Bottom",sz=Vector3.new(0.07103,0.07103,0.07103),col=Color3.fromRGB(163,162,165),mat=256,tr=0,sh=1,id=145,cf=CFrame.new(12.72973,-663.48608,-19.77946),an=true,k={{c="Joint",p0=145,p1=143,c0=CFrame.new(0,3.69618,0),c1=CFrame.new(0,0,0)},{c="Joint",p0=145,p1=144,c0=CFrame.new(0,3.55128,0),c1=CFrame.new(0,0,0)}}}}}
FX.HeadFX = {c="Model",n="HeadFX",id=152,k={{c="Part",n="Lip",sz=Vector3.new(2,1,1),col=Color3.fromRGB(163,162,165),mat=256,tr=1,sh=1,id=153,cf=CFrame.new(-54.77027,-662.86761,-24.67945),an=false,k={{c="Mesh",mt=0,scale=Vector3.new(1.25,1.25,1.25),off=Vector3.new(0,0,0),mesh="",tex=""},{c="Joint",p0=153,p1=156,c0=CFrame.new(0,-0.08,-0.39001),c1=CFrame.new(0,0,0)}}},{c="Part",n="Cream",sz=Vector3.new(0.58,0.22,0.46),col=Color3.fromRGB(248,248,248),mat=256,tr=0,sh=1,id=156,cf=CFrame.new(-54.77026,-662.94763,-25.06946),an=false,k={{c="Mesh",mt=3,scale=Vector3.new(1,1,1),off=Vector3.new(0,0,0),mesh="",tex=""}}}}}
FX.IceRing = {c="Part",n="IceRing",sz=Vector3.new(3.26933,3.26019,0.65387),col=Color3.fromRGB(128,195,186),mat=288,tr=0,sh=1,mesh="2913878791",scale=Vector3.new(0.06539,0.06539,0.06539),id=116,cf=CFrame.new(25.36441,-661.73755,-16.45254),an=true,k={}}
FX.IceBreath = {c="Emitter",n="IceBreath",col=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.34902,1,0.83922)),ColorSequenceKeypoint.new(1,Color3.new(0.34902,1,0.83922))}),size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.06388,1.85792),NumberSequenceKeypoint.new(0.07019,3.38798),NumberSequenceKeypoint.new(0.14274,4.69945),NumberSequenceKeypoint.new(0.27208,0),NumberSequenceKeypoint.new(1,0)}),tr=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.01065,0.74375),NumberSequenceKeypoint.new(0.06012,0.49375),NumberSequenceKeypoint.new(0.13699,1),NumberSequenceKeypoint.new(1,1)}),life=NumberRange.new(5,5),speed=NumberRange.new(20,20),spread=Vector2.new(0,0),rate=0,acc=Vector3.new(0,0,0),dir=5,light=1,z=0,tex="241629053",en=true}

-- ============================== HELPERS ==============================
local matCache, normalCache, shapeCache, meshTypeCache = {}, {}, {}, {}
local function byValue(enum, cache, v, fallback)
	if next(cache) == nil then
		for _, item in ipairs(enum:GetEnumItems()) do cache[item.Value] = item end
	end
	return cache[v] or fallback
end
local function assetUrl(id) return "rbxassetid://" .. tostring(id) end

local function mkPart(s)
	local p = Instance.new("Part")
	p.Name = s.n
	p.Size = s.sz
	p.Color = s.col
	p.Material = byValue(Enum.Material, matCache, s.mat, Enum.Material.Plastic)
	p.Transparency = s.tr
	pcall(function() p.Shape = byValue(Enum.PartType, shapeCache, s.sh, Enum.PartType.Block) end)
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if s.mesh then
		local sm = Instance.new("SpecialMesh")
		sm.MeshType = Enum.MeshType.FileMesh
		sm.MeshId = assetUrl(s.mesh)
		sm.TextureId = s.tex and assetUrl(s.tex) or ""
		sm.Scale = s.scale
		sm.Parent = p
	end
	return p
end

local function mkEmitter(s)
	local e = Instance.new("ParticleEmitter")
	e.Name = s.n
	e.Color = s.col
	e.Size = s.size
	e.Transparency = s.tr
	e.Lifetime = s.life
	e.Speed = s.speed
	e.SpreadAngle = s.spread
	e.Rate = s.rate
	e.Acceleration = s.acc
	e.EmissionDirection = byValue(Enum.NormalId, normalCache, s.dir, Enum.NormalId.Top)
	e.LightEmission = s.light
	e.ZOffset = s.z
	e.Texture = s.tex ~= "" and assetUrl(s.tex) or ""
	e.Enabled = s.en
	return e
end

local function Build(s, map, joints)
	local c = s.c
	local inst
	if c == "Model" then
		inst = Instance.new("Model")
	elseif c == "Part" then
		inst = mkPart(s)
		if s.cf then inst.CFrame = s.cf end
		if s.an ~= nil then inst.Anchored = s.an end
	elseif c == "Mesh" then
		inst = Instance.new("SpecialMesh")
		inst.MeshType = byValue(Enum.MeshType, meshTypeCache, s.mt, Enum.MeshType.FileMesh)
		inst.Scale = s.scale
		inst.Offset = s.off
		if s.mesh ~= "" then inst.MeshId = assetUrl(s.mesh) end
		if s.tex ~= "" then inst.TextureId = assetUrl(s.tex) end
		return inst
	elseif c == "Attachment" then
		inst = Instance.new("Attachment")
		inst.CFrame = s.cf
	elseif c == "Emitter" then
		inst = mkEmitter(s)
		return inst
	elseif c == "Joint" then
		joints[#joints + 1] = s
		return nil
	end
	if s.n then inst.Name = s.n end
	if s.id then map[s.id] = inst end
	for _, k in ipairs(s.k or {}) do
		local ch = Build(k, map, joints)
		if ch then ch.Parent = inst end
	end
	return inst
end

local function BuildModel(spec)
	local map, joints = {}, {}
	local root = Build(spec, map, joints)
	for _, j in ipairs(joints) do
		local p0, p1 = map[j.p0], map[j.p1]
		if p0 and p1 then
			local w = Instance.new("Weld")
			w.Part0, w.Part1, w.C0, w.C1 = p0, p1, j.c0, j.c1
			w.Parent = p0
		end
	end
	return root, map
end

local function getParts()
	local char = lp.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local head, torso = char:FindFirstChild("Head"), char:FindFirstChild("Torso")
	if not (hum and head and torso and hum.RigType == Enum.HumanoidRigType.R6) then return end
	return char, hum
end

-- ============================== OUTFIT ==============================
local STRIP = { "Accessory", "Hat", "Shirt", "Pants", "ShirtGraphic", "CharacterMesh", "BodyColors" }
local removedItems, hiddenParts = {}, {}
local function isStripped(o)
	for _, c in ipairs(STRIP) do
		if o:IsA(c) then return true end
	end
	return false
end

local function stripOutfit(char)
	for _, o in ipairs(char:GetChildren()) do
		if isStripped(o) and not o.Name:find("^Popper") then
			table.insert(removedItems, o)
			o.Parent = nil
		end
	end
end

local function applyOutfit(char)
	local bc = Instance.new("BodyColors")
	bc.Name = "PopperBodyColors"
	bc.HeadColor3, bc.TorsoColor3 = BODYCOLORS.Head, BODYCOLORS.Torso
	bc.LeftArmColor3, bc.RightArmColor3 = BODYCOLORS.LeftArm, BODYCOLORS.RightArm
	bc.LeftLegColor3, bc.RightLegColor3 = BODYCOLORS.LeftLeg, BODYCOLORS.RightLeg
	bc.Parent = char
end

local function removeTagged(char, name)
	local o = char and char:FindFirstChild(name)
	while o do o:Destroy(); o = char:FindFirstChild(name) end
end

local function applyBody(char)
	removeTagged(char, "PopperBody")
	local folder = Instance.new("Folder")
	folder.Name = "PopperBody"
	folder.Parent = char
	for limbName, pieces in pairs(BODY) do
		local limb = char:FindFirstChild(limbName)
		if limb and limb:IsA("BasePart") then
			for idx, spec in ipairs(pieces) do
				local p = mkPart(spec)
				p.Name = limbName .. " " .. idx
				p.Parent = folder
				local w = Instance.new("Weld")
				w.Name = "PopperWeld"
				w.Part0, w.Part1, w.C0, w.C1 = limb, p, spec.rel, CFrame.new()
				w.Parent = p
			end
			if CONFIG.HideRealParts and limbName ~= "Left Leg" and limbName ~= "Right Leg" then
				hiddenParts[limb] = limb.Transparency
				limb.Transparency = 1
			end
		end
	end
	-- hidden parts must stay hidden when the game resets their transparency
	for limb in pairs(hiddenParts) do
		track(limb:GetPropertyChangedSignal("Transparency"):Connect(function()
			if CONFIG.HideRealParts and hiddenParts[limb] ~= nil and limb.Transparency ~= 1 then limb.Transparency = 1 end
		end))
	end
end

local function restoreOutfit(char)
	for limb, t in pairs(hiddenParts) do
		if limb.Parent then pcall(function() limb.Transparency = t end) end
	end
	table.clear(hiddenParts)
	removeTagged(char, "PopperBody")
	removeTagged(char, "PopperBodyColors")
	for _, o in ipairs(removedItems) do
		if char and char.Parent then pcall(function() o.Parent = char end) end
	end
	table.clear(removedItems)
end

local watchConn
local function watchOutfit(char)
	if watchConn then watchConn:Disconnect() end
	watchConn = char.ChildAdded:Connect(function(o)
		if isStripped(o) and not o.Name:find("^Popper") then
			task.defer(function()
				table.insert(removedItems, o)
				pcall(function() o.Parent = nil end)
			end)
		end
	end)
end

-- ============================== RIG, MOVES AND LOOP ==============================
local RUN = 0
local rigState = nil -- what to undo when the rig stops

local function Rig_Stop()
	RUN += 1
	local st = rigState
	rigState = nil
	if not st then return end
	for _, c in ipairs(st.cons) do pcall(function() c:Disconnect() end) end
	for _, o in ipairs(st.objects) do pcall(function() o:Destroy() end) end
	for _, m in ipairs(st.motors) do pcall(function() m.Enabled = true end) end
	if st.animate then pcall(function() st.animate.Disabled = false end) end
	pcall(function()
		st.hum.WalkSpeed = st.walk
		st.hum.CameraOffset = Vector3.new()
		st.root.Anchored = false
	end)
end

local function Rig_Start(char, hum)
	Rig_Stop()
	local torso, head, root = char:FindFirstChild("Torso"), char:FindFirstChild("Head"), char:FindFirstChild("HumanoidRootPart")
	local RArm, LArm = char:FindFirstChild("Right Arm"), char:FindFirstChild("Left Arm")
	local RLeg, LLeg = char:FindFirstChild("Right Leg"), char:FindFirstChild("Left Leg")
	local RJ0 = root and root:FindFirstChild("RootJoint")
	local motors = { RJ0, torso:FindFirstChild("Neck"), torso:FindFirstChild("Right Shoulder"), torso:FindFirstChild("Left Shoulder"),
		torso:FindFirstChild("Right Hip"), torso:FindFirstChild("Left Hip") }
	if not (head and root and RArm and LArm and RLeg and LLeg and motors[1] and motors[2] and motors[3] and motors[4] and motors[5] and motors[6]) then
		return false, "R6 joints not found"
	end
	local st = { cons = {}, objects = {}, motors = motors, walk = hum.WalkSpeed, hum = hum, root = root }
	rigState = st
	local run = RUN
	local function alive() return RUN == run and hum.Parent and hum.Health > 0.001 end

	local animate = char:FindFirstChild("Animate")
	if animate and animate:IsA("LuaSourceContainer") then
		animate.Disabled = true
		st.animate = animate
	end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop(0) end
	for _, m in ipairs(motors) do m.Enabled = false end

	-- original shortcuts, kept so the ported move code reads the same
	local S = setmetatable({}, { __index = function(_, i) return game:GetService(i) end })
	local CF = { N = CFrame.new, A = CFrame.Angles, fEA = CFrame.fromEulerAnglesXYZ }
	local V3 = { N = Vector3.new }
	local M = { C = math.cos, R = math.rad, S = math.sin, H = math.huge, RNG = function(a, b, int)
		return int and math.random(a, b) or (a + (b - a) * math.random()) end }
	local IN = Instance.new
	local Char, Hum, Head, Torso, Root = char, hum, head, torso, root
	local mouse = lp:GetMouse()
	local Mouse = mouse
	local NeutralAnims, Attack = true, false
	local WalkSpeed = CONFIG.StartWalkSpeed
	local Sine, Change = 0, 1
	local Movement, wsVal = 10, 6

	local function Joint(name, part0, part1, c0, c1)
		local j = Instance.new("Weld")
		j.Part0, j.Part1, j.C0, j.C1 = part0, part1, c0 or CFrame.new(), c1 or CFrame.new()
		j.Name = name
		j.Parent = part0
		table.insert(st.objects, j)
		return j
	end
	local RJ = Joint("RootJoint", Root, Torso)
	local NK = Joint("Neck", Torso, Head, CF.N(0, 1.5, 0), CF.N())
	local LS = Joint("Left Shoulder", Torso, LArm, CF.N(-1.5, 0.5, 0), CF.N(0, 0.5, 0))
	local RS = Joint("Right Shoulder", Torso, RArm, CF.N(1.5, 0.5, 0), CF.N(0, 0.5, 0))
	local LH = Joint("Left Hip", Torso, LLeg, CF.N(-0.5, -2, 0), CF.N(0, 0, 0))
	local RH = Joint("Right Hip", Torso, RLeg, CF.N(0.5, -2, 0), CF.N(0, 0, 0))

	local EffectFolder = Instance.new("Folder")
	EffectFolder.Name = "PopperEffects"
	EffectFolder.Parent = char
	table.insert(st.objects, EffectFolder)

	-- 60 Hz artificial heartbeat, same as the original
	local ArtificialHB = Instance.new("BindableEvent")
	table.insert(st.objects, ArtificialHB)
	local tf = 0
	table.insert(st.cons, RunService.Heartbeat:Connect(function(dt)
		tf += dt
		local frame = 1 / 60
		if tf >= frame then
			local n = math.floor(tf / frame)
			for _ = 1, n do ArtificialHB:Fire() end
			tf -= frame * n
		end
	end))
	local function swait(num)
		if num == 0 or num == nil then
			ArtificialHB.Event:Wait()
		else
			for _ = 0, num do ArtificialHB.Event:Wait() end
		end
	end

	local function Animate(joint, c0, alpha, style, dir)
		if style == "Lerp" then
			joint.C0 = joint.C0:Lerp(c0, alpha)
		else
			local info = TweenInfo.new(alpha or 1, style or Enum.EasingStyle.Linear, dir or Enum.EasingDirection.Out, 0, false, 0)
			local tween = TweenService:Create(joint, info, { C0 = c0 })
			tween:Play()
			return tween
		end
	end
	local function Tween(object, properties, time, style, dir, repeats, reverse, delay)
		local info = TweenInfo.new(time or 1, style or Enum.EasingStyle.Linear, dir or Enum.EasingDirection.Out, repeats or 0, reverse or false, delay or 0)
		local tween = TweenService:Create(object, info, properties)
		tween:Play()
		return tween
	end

	local baseSound = Instance.new("Sound")
	local function Sound(parent, id, pitch, volume, looped, effect, autoPlay)
		local snd = baseSound:Clone()
		snd.SoundId = assetUrl(id or 0)
		snd.Pitch = pitch or 1
		snd.Volume = volume or 1
		snd.Looped = looped or false
		if autoPlay then
			task.spawn(function()
				local t = os.clock()
				while not snd.IsLoaded and os.clock() - t < 5 and snd.Parent do task.wait() end
				if snd.Parent then snd.Playing = true end
			end)
		end
		if not looped and effect then
			snd.Stopped:Connect(function() snd.Volume = 0; snd:Destroy() end)
		end
		snd.Parent = parent or workspace
		return snd
	end
	local function SoundPart(id, pitch, volume, looped, effect, autoPlay, cf)
		local sp = Instance.new("Part")
		sp.Size = Vector3.new(0.05, 0.05, 0.05)
		sp.Transparency = 1
		sp.Anchored = true
		sp.CanCollide, sp.CanTouch, sp.CanQuery = false, false, false
		sp.CFrame = cf or CFrame.new()
		sp.Parent = EffectFolder
		local snd = Instance.new("Sound")
		snd.SoundId = assetUrl(id or 0)
		snd.Pitch = pitch or 1
		snd.Volume = volume or 1
		snd.Looped = looped or false
		snd.Parent = sp
		if autoPlay then
			task.spawn(function()
				local t = os.clock()
				while not snd.IsLoaded and os.clock() - t < 5 and snd.Parent do task.wait() end
				if snd.Parent then snd:Play() end
			end)
		end
		if not looped then
			snd.Ended:Connect(function() sp:Destroy() end)
			Debris:AddItem(sp, 20)
		end
		return snd
	end

	local function GetTorso(c)
		return c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("LowerTorso") or c:FindFirstChild("HumanoidRootPart")
	end
	local function CastRay(startPos, endPos, range, ignoreList)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = ignoreList or { Char }
		params.IgnoreWater = true
		local res = workspace:Raycast(startPos, (endPos - startPos).Unit * range, params)
		if res then return res.Instance, res.Position, res.Normal, (startPos - res.Position).Magnitude end
		return nil, startPos + (endPos - startPos).Unit * range, nil, nil
	end

	local function Camshake(s)
		local dur, inten = s.Duration or 0.5, s.Intensity or 5
		task.spawn(function()
			local t0 = os.clock()
			while alive() and os.clock() - t0 < dur do
				local a = (1 - (os.clock() - t0) / dur) * inten * 0.05
				Hum.CameraOffset = Vector3.new((math.random() - 0.5) * a, (math.random() - 0.5) * a, 0)
				task.wait()
			end
			Hum.CameraOffset = Vector3.new()
		end)
	end

	local function fromAxisAngle(x, y, z)
		local mag = (x * x + y * y + z * z) ^ 0.5
		if mag > 1e-5 then
			local si = math.sin(mag / 2) / mag
			return CFrame.new(0, 0, 0, si * x, si * y, si * z, math.cos(mag / 2))
		end
		return CFrame.new()
	end
	local function fakePhysics(elapsed, cframe, velocity, rotation, acceleration)
		local pos = cframe.Position
		local matrix = cframe - pos
		return fromAxisAngle((elapsed * rotation).X, (elapsed * rotation).Y, (elapsed * rotation).Z) * matrix + pos + elapsed * velocity + elapsed * elapsed * acceleration
	end

	local function Projectile(data)
		local Origin = data.Origin or CFrame.new()
		local Velocity = data.Velocity or Vector3.new(0, 100, 0)
		local Gravity = data.Gravity or workspace.Gravity
		local Lifetime = data.Lifetime or 1
		local Material = data.Material or Enum.Material.Glass
		local ignore = { Char }
		local HitFunc = data.Hit
		local drop = data.Projectile
		drop.Material = Material
		drop.Color = data.Color
		drop.CFrame = Origin
		local startTick = os.clock()
		local function kill()
			local par = drop.Parent
			if par and par:IsA("Model") then par:Destroy() else drop:Destroy() end
		end
		task.spawn(function()
			while alive() do
				local elapsed = os.clock() - startTick
				if elapsed > Lifetime then kill(); break end
				local newCF = fakePhysics(elapsed, Origin, Velocity, Vector3.new(), Vector3.new(0, -Gravity, 0))
				local dist = (drop.Position - newCF.Position).Magnitude
				local hit, pos, norm = nil, nil, nil
				if dist > 0.001 then hit, pos, norm = CastRay(drop.Position, newCF.Position, dist, ignore) end
				local doCollide = hit and (GetTorso(hit.Parent) or hit.CanCollide)
				if hit and not doCollide then table.insert(ignore, hit) end
				drop.CFrame = CFrame.new(newCF.Position) * CFrame.Angles(0, math.rad(180), 0)
				if doCollide then
					if HitFunc then HitFunc(hit, pos, norm, nil, drop) else kill() end
					break
				end
				if not drop.Parent then break end
				swait()
			end
		end)
	end

	-- effect templates (built once per rig start)
	local IceRing = BuildModel(FX.IceRing)
	local BombProjectile = BuildModel(FX.Bomb)
	local Crystal = BuildModel(FX.Icicle)
	local FXBomb = BuildModel(FX.FXBomb)
	local LipM = BuildModel(FX.HeadFX)
	local FreezeParticle = mkEmitter(FX.IceBreath)
	local ParticleAtch = Instance.new("Attachment")
	ParticleAtch.Position = Vector3.new(0, -0.3, -0.5)
	ParticleAtch.Parent = Head
	FreezeParticle.Parent = ParticleAtch
	table.insert(st.objects, ParticleAtch)
	do
		local w = Instance.new("Weld")
		w.Part0, w.Part1 = RArm, FXBomb["Right Arm"]
		w.C0, w.C1 = CFrame.Angles(0, math.rad(180), 0):Inverse(), CFrame.new()
		w.Parent = FXBomb["Right Arm"]
		FXBomb["Right Arm"].Anchored = false
		local jooj = Instance.new("Weld")
		jooj.Part0, jooj.Part1, jooj.C0, jooj.C1 = Head, LipM.Lip, CFrame.new(), CFrame.new()
		jooj.Parent = Head
		LipM.Lip.Anchored = false
		table.insert(st.objects, jooj)
	end
	local Moog = Instance.new("Model")
	Moog.Name = "Muge"
	do
		local handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(1, 2, 1)
		handle.Transparency = 1
		handle.CanCollide, handle.CanTouch, handle.CanQuery, handle.Massless = false, false, false, true
		handle.Parent = Moog
		local stuxnet = Instance.new("Weld")
		stuxnet.Part0, stuxnet.Part1 = RArm, handle
		stuxnet.Parent = RArm
		table.insert(st.objects, stuxnet)
		if CONFIG.MugStandIn then
			local mug = Instance.new("Part")
			mug.Name = "Moog"
			mug.Size = Vector3.new(1.017, 0.7997, 0.6777)
			mug.Color = Color3.fromRGB(124, 92, 70)
			mug.Material = Enum.Material.Glass
			mug.CanCollide, mug.CanTouch, mug.CanQuery, mug.Massless = false, false, false, true
			local w = Instance.new("Weld")
			w.Part0, w.Part1 = handle, mug
			w.C0 = CFrame.new(1.2, -0.01001, 0.09, -4.371e-08, 1, 0, 0, 0, -1, -1, 4.371e-08, 0):Inverse()
			w.C1 = CFrame.new()
			w.Parent = mug
			mug.Parent = Moog
		end
	end

	-- music
	local MusicId = CONFIG.MusicIds[math.random(1, #CONFIG.MusicIds)]
	local Music = Sound(Torso, MusicId, 1, CONFIG.MusicVolume, true, false, CONFIG.Music)
	Music.Name = "Music"
	table.insert(st.objects, Music)

	local function FroZone()
		Attack = true
		NeutralAnims = false
		WalkSpeed = 0
	
		Sound(Root,457859867,1,2,false,nil,true)
	
		local Alpha = 1.089
		Animate(NK,CF.N(0,1.25,0.43)*CF.A(M.R(60),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.5,-1.91,0.42)*CF.A(M.R(-25),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,-0.1,0.3)*CF.A(M.R(25),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.5,-1.91,0.42)*CF.A(M.R(-25),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Circular,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		local IceFX1 = IceRing:Clone()
		IceFX1.CFrame = Head.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
		IceFX1.Parent = Char
		local IceFX2 =IceFX1:Clone()
		IceFX2.Parent = Char
		IceFX2.Size = IceFX1.Size * 1.3
		IceFX2.Material = Enum.Material.Glass
		IceFX2.Transparency = .4
		Tween(IceFX1,{Transparency = 1,Size = IceFX1.Size * 5,CFrame = Head.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))},.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Tween(IceFX2,{Transparency = 1,Size = IceFX1.Size * 5,CFrame = Head.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))},.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)

	
		for i = 1,80 do
			swait()
			local Alpha = .1
			Animate(NK,CF.N(0,1.25,0.43)*CF.A(M.R(60 + 2 +  (.3*i) * math.cos(Sine)),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-40 + 4 +  (.3*i) * math.cos(Sine/2)),M.R(0),M.R(0 - (.3*i) + 4  * math.sin(Sine))),Alpha,'Lerp')
			Animate(LH,CF.N(-0.5,-1.91,0.42)*CF.A(M.R(-25),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(RJ,CF.N(0,-0.1,0.3)*CF.A(M.R(25),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(RH,CF.N(0.5,-1.91,0.42)*CF.A(M.R(-25),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-40 - 4 + (.3*i) * math.cos(Sine)),M.R(0),M.R(0 +  (.3*i) + 4 * math.sin(Sine))),Alpha,'Lerp')
		end
	
	
		local Alpha = .3
		Animate(NK,CF.N(0,1.38,0.32)*CF.A(M.R(40),M.R(45),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.5,-1.57,-0.82)*CF.A(M.R(55),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(-0.2,-0.4,-0.5)*CF.A(M.R(-55.4),M.R(5.7),M.R(8.2)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.5,-1.57,-0.82)*CF.A(M.R(55),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		FreezeParticle.Rate = 100
	
	
		-- (the original froze and anchored other players here; not ported)

		local Alpha = .6
		Animate(NK,CF.N(0,1.38,0.32)*CF.A(M.R(40),M.R(-45),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.5,-1.57,-0.82)*CF.A(M.R(55),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0.2,-0.4,-0.5)*CF.A(M.R(-55.4),M.R(-5.7),M.R(-8.2)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.5,-1.57,-0.82)*CF.A(M.R(55),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-40),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)	.Completed:Wait()
	
	
		FreezeParticle.Rate = 0
	
		WalkSpeed = 32
		NeutralAnims = true
		Attack = false
	end


	local function BombEmUp()
		WalkSpeed = 0
		Attack = true
		NeutralAnims = false
	
		task.spawn(function()
			Animate(RS,CF.N(1.48,1.19,0.19)*CF.A(M.R(-75.3),M.R(-2.6),M.R(-14.8)),.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
			Sound(RArm,3422592990,1,2,false,nil,true)
			Animate(RS,CF.N(1.48,0.48,0.13)*CF.A(M.R(159.1),M.R(13),M.R(7.6)),.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)	
		end)
	
		local Alpha = .30
		Animate(NK,CF.N(-0.02,1.45,-0.21)*CF.A(M.R(-25.5),M.R(24.9),M.R(2.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.43,0.64,0.2)*CF.A(M.R(-35),M.R(30),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.64,-1.93,0.36)*CF.A(M.R(-20),M.R(30),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(22.8),M.R(-28),M.R(11.2)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.5,-0.8,-0.7)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		Sound(Head,969679894,1,3,false,nil,true)
		Sound(RArm,608537390,1,2,false,nil,true)
	
		FXBomb.Parent = Char
		task.spawn(function()
			task.wait(.1)
			FXBomb.Parent = nil
			local Origin = FXBomb.Bomb.Center.CFrame
			local g = V3.N(0,-workspace.Gravity*2,0);
			local time = 0.3
			local vel = (Mouse.Hit.Position-Origin.Position-.5*g*time*time)/time;
			local BP = BombProjectile:Clone()
			BP.Center.CFrame = Origin
			BP.Parent = Char

			Projectile{
				Size=3;
				Origin=Origin;
				Velocity=vel;
				Projectile=BP.Center,
				Color=Color3.new(17/255, 17/255, 17/255);
				Gravity=workspace.Gravity,
				Material=Enum.Material.Granite;
				Lifetime=10;
				Hit=function(hit,pos,norm,obj,proj)
					Camshake{
						Duration=.5;
						FadeIn=.1;
						FadeOut=.5;
						Intensity=5;
						Roughness=10;
						ShakeStart=50;
						ShakeEnd=100;
						Rotation=V3.N(2,1,1);
						Position=V3.N(1,1,1);
						Origin=pos;

					}
					local Exp = Instance.new("Explosion",workspace)
					Exp.DestroyJointRadiusPercent = 0
					Exp.BlastRadius = 10
					Exp.BlastPressure = 0
					Exp.ExplosionType = Enum.ExplosionType.NoCraters
					Exp.Position = BP.Center.Position
					SoundPart(3154829820,1,7,false,nil,true,BP.Center.CFrame)
					BP:Destroy()
				end;
			}
		end)	
	
		local Alpha = .17
		Animate(NK,CF.N(0,1.35,0.35)*CF.A(M.R(45),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)
		Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-35),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)
		Animate(LH,CF.N(-0.5,-1.64,0.77)*CF.A(M.R(-50),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)
		Animate(RJ,CF.N(0,0,-0.96)*CF.A(M.R(-60),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)
		Animate(RH,CF.N(0.5,-1.51,-1.43)*CF.A(M.R(50),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)
		Animate(RS,CF.N(1.5,1.1,0)*CF.A(M.R(165),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0).Completed:Wait()

	
		NeutralAnims = true
		Attack = false
		WalkSpeed = 32
	end


	local function DanceOfDeath()
		WalkSpeed = 0
		Attack = true
		NeutralAnims = false
	
		local Alpha = .3
		Animate(NK,CF.N(0,1.43,0.25)*CF.A(M.R(30.2),M.R(-50.2),M.R(0.1)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.43,0.54,-0.25)*CF.A(M.R(-80.3),M.R(0.1),M.R(-30.1)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.8,-2.14,-0.06)*CF.A(M.R(-9.1),M.R(-23.5),M.R(-22)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,-0.3,0)*CF.A(M.R(-47.7),M.R(38.9),M.R(34.6)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.65,-1.1,-1.6)*CF.A(M.R(45.2),M.R(-45.1),M.R(0.1)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.48,0.63,0)*CF.A(M.R(-54.3),M.R(-12.3),M.R(8.7)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		local is = {}
		for i = 1,50 do
			is[8*i] = true
		end
		local is2 = {}
		for i = 1,50 do
			is2[i*2] = true
		end
	
		local RCF = Root.CFrame	
	
		for i = 0,100 do
			swait()
			local Alpha = .3
			if is2[i] then
				task.spawn(function()
					local CrystalFX = Crystal:Clone()
					CrystalFX.Parent = Char
					CrystalFX.Bottom.CFrame = RCF * CFrame.Angles(0,math.rad(8*-i),0) * CFrame.new(0,-8,5 + (.2*i)) * CFrame.Angles(math.rad(40),math.rad(0),0) 
					task.wait(.02 + .005 * i)
					Sound(CrystalFX.Bottom,4307130771,1,2,false,nil,true)
					Tween(CrystalFX.Bottom,{CFrame = RCF * CFrame.Angles(0,math.rad(8*-i),0) * CFrame.new(0,-8,5 + (.2*i)) * CFrame.Angles(math.rad(40),math.rad(0),0)  * CFrame.new(0,6,0)},.1,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
					task.wait(.1)
					-- (the original damaged players touching the crystal here; not ported)
					task.wait(.9)
					Tween(CrystalFX.Bottom,{CFrame = RCF * CFrame.Angles(0,math.rad(8*-i),0) * CFrame.new(0,-8,5 + (.2*i)) * CFrame.Angles(math.rad(40),math.rad(0),0) },.1,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0).Completed:Connect(function()
						CrystalFX:Destroy()
					end)
				end)
			end
			if is[i] then
				local j = Sound(Head,4255432837,1,3,false,nil,true)
				game:GetService("Debris"):AddItem(j,1)
			end
			Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(0),M.R(-10),M.R(-90)),Alpha,'Lerp')
			Animate(LH,CF.N(-0.5,-1.13,-0.39)*CF.A(M.R(-5),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(RJ,CF.N(0,0,0)*CF.A(M.R(-10),M.R(-i*25),M.R(0)),Alpha,'Lerp')
			Animate(RH,CF.N(0.5,-2.02,-0.02)*CF.A(M.R(-10),M.R(0),M.R(0)),Alpha,'Lerp')
			Animate(RS,CF.N(1.4,0.5,0)*CF.A(M.R(0),M.R(-10),M.R(90)),Alpha,'Lerp')
		end
	
		local Alpha = .4
		Animate(NK,CF.N(0.17,1.39,0.27)*CF.A(M.R(41.3),M.R(16.7),M.R(-20.7)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.7,0.18,-0.38)*CF.A(M.R(63.5),M.R(9.4),M.R(-20.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.54,-2,-0.22)*CF.A(M.R(0),M.R(25.4),M.R(0.4)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(-0.16,-0.79,-0.51)*CF.A(M.R(-55.7),M.R(-26.1),M.R(0.8)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.32,-1.54,-0.74)*CF.A(M.R(52.7),M.R(15.8),M.R(-19.7)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.4,0.53,0)*CF.A(M.R(-7.1),M.R(54.7),M.R(98.7)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
	
		task.wait(.7)
	
		Attack = false
		NeutralAnims =  true
		WalkSpeed = 32
	end


	local function Drimk()
		Attack = true
		NeutralAnims = false
		WalkSpeed = 0
		Moog.Parent = Char

	
		task.spawn(function()
			Animate(RS,CF.N(1.46,0.36,0.15)*CF.A(M.R(132.5),M.R(0),M.R(23.8)),.12,Enum.EasingStyle.Cubic,Enum.EasingDirection.In,0,false,0).Completed:Wait()
			Animate(RS,CF.N(2.04,1.13,-0.23)*CF.A(M.R(-143.1),M.R(28.6),M.R(-86.8)),.13,Enum.EasingStyle.Cubic,Enum.EasingDirection.In,0,false,0).Completed:Wait()
		end)

		local Alpha = .25
		Animate(NK,CF.N(-0.02,1.43,0.26)*CF.A(M.R(31.7),M.R(-7.3),M.R(1.8)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(LS,CF.N(-1.49,0.58,-0.06)*CF.A(M.R(-1.7),M.R(-6.2),M.R(-9)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(LH,CF.N(-0.54,-2,0.2)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(0),M.R(29.5),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(RH,CF.N(0.54,-2,-0.2)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0).Completed:Wait()
	
		task.spawn(function()
			local jkl = Sound(Head,2767339245,1,2,false,nil,true)
			task.wait(.75480)
			jkl:Destroy()
		end)
	
		local Alpha = 1.3
		Animate(NK,CF.N(-0.03,1.37,0.33)*CF.A(M.R(41.7),M.R(-6.9),M.R(3.1)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.49,0.58,-0.06)*CF.A(M.R(-1.7),M.R(-6.2),M.R(-9)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.62,-1.92,0.34)*CF.A(M.R(-10.8),M.R(-22.7),M.R(-5.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(10),M.R(29.5),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.45,-2.07,-0.03)*CF.A(M.R(-10.8),M.R(-22.7),M.R(-5.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(1.94,1.35,0.08)*CF.A(M.R(-131.7),M.R(28.7),M.R(-92.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		Hum.Health = Hum.Health + 35
	
		Sound(Head,1025003145,1,2,false,nil,true)
		LipM.Parent = Char
	
		local Alpha = .20
		Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(-25),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(LS,CF.N(-1.49,0.58,-0.06)*CF.A(M.R(-1.7),M.R(-6.2),M.R(-9)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(LH,CF.N(-0.53,-2,0.19)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(0),M.R(29.5),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(RH,CF.N(0.53,-1.98,-0.18)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
		Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0).Completed:Wait()
	
	
		Moog.Parent = nil

	
		local Alpha = .28
		Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(5.1),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LS,CF.N(-1.49,0.58,-0.06)*CF.A(M.R(-1.7),M.R(-6.2),M.R(-9)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(LH,CF.N(-0.53,-2,0.19)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(0),M.R(29.5),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RH,CF.N(0.53,-1.98,-0.18)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0)
		Animate(RS,CF.N(0.28,0.92,-1)*CF.A(M.R(86.2),M.R(-6.9),M.R(-101.3)),Alpha,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0).Completed:Wait()
	
		LipM.Parent = nil
	
		local Alpha = .17
		Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(-25),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0)
		Animate(LS,CF.N(-1.49,0.58,-0.06)*CF.A(M.R(-1.7),M.R(-6.2),M.R(-9)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0)
		Animate(LH,CF.N(-0.53,-2,0.19)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0)
		Animate(RJ,CF.N(0,0,0)*CF.A(M.R(0),M.R(29.5),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0)
		Animate(RH,CF.N(0.53,-1.98,-0.18)*CF.A(M.R(0),M.R(-23.2),M.R(0)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0)
		Animate(RS,CF.N(2.33,0.74,-0.17)*CF.A(M.R(86.1),M.R(-6.7),M.R(-66.1)),Alpha,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0).Completed:Wait()
	
	
		WalkSpeed = 32	
		NeutralAnims = true
		Attack = false
	end



	table.insert(st.cons, UserInputService.InputBegan:Connect(function(io, gpe)
		if gpe then return end
		if io.KeyCode == Enum.KeyCode.M then
			Music.Playing = not Music.Playing
			return
		end
		if Attack or Hum.Sit then return end
		if io.UserInputType == Enum.UserInputType.MouseButton1 then
			task.spawn(BombEmUp)
		elseif io.KeyCode == Enum.KeyCode.Z then
			task.spawn(FroZone)
		elseif io.KeyCode == Enum.KeyCode.X then
			task.spawn(DanceOfDeath)
		elseif io.KeyCode == Enum.KeyCode.T then
			task.spawn(Drimk)
		end
	end))

	task.spawn(function()
		while alive() do
			swait()
			Sine = Sine + Change
			local Hit,Pos = CastRay(Root.Position,Root.Position-V3.N(0,1,0),4)
			local Walking = Hum.MoveDirection.Magnitude>0
			local State = (not Hit and Root.Velocity.Y<-1 and 'Fall' or not Hit and Root.Velocity.Y>1 and 'Jump' or Walking and "Walk" or "Idle")
			if(not EffectFolder or EffectFolder.Parent~=Char)then
				EffectFolder=Instance.new("Folder")
				EffectFolder.Name='Effects'
				EffectFolder.Parent=Char
			end
	
			--I know this looks like jl's
			--It's more inspired by my old one which is a modified ver of Kyu's, but replacing Root.Velocity with Hum.MoveDirection and removing the clamp
			local FwdDir = (Walking and Hum.MoveDirection*Root.CFrame.LookVector or V3.N())
			local RigDir = (Walking and Hum.MoveDirection*Root.CFrame.RightVector or V3.N())
			local Vec = {
				X=RigDir.X+RigDir.Z,
				Z=FwdDir.X+FwdDir.Z
			};
			local Divide = 1
			if(Vec.Z<0)then
				Divide=math.clamp(-(1.25*Vec.Z),1,2)
			end
			Vec.Z = Vec.Z/Divide
			Vec.X = Vec.X/Divide
			Hum.WalkSpeed = WalkSpeed/Divide
			local Value = Movement/10


			if(NeutralAnims)then	
				if Hum.Sit then
					local Alpha = .2
					Animate(NK,CF.N(0,1.5,-0.04)*CF.A(M.R(-5 - 5.5 * math.sin(Sine/10)),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(LS,CF.N() * CF.A(M.R(0 + 4 * math.cos(Sine/10)),M.R(0),M.R(0)) * CF.N(-1.48,0.37,0.26)*CF.A(M.R(-19.4),M.R(-5.1),M.R(14.1)),Alpha,'Lerp')
					Animate(LH,CF.N(-0.5,-1.6,-1.08)*CF.A(M.R(25 + 30 * math.cos(Sine/10)),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RJ,CF.N(0,-.5,-0.29)*CF.A(M.R(0  - 5 * math.cos(Sine/10)),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RH,CF.N(0.5,-1.6,-1.08)*CF.A(M.R(25 - 30 * math.cos(Sine/10)),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RS,CF.N() * CF.A(M.R(0 + 4 * math.cos(Sine/10)),M.R(0),M.R(0))  * CF.N(1.48,0.37,0.26)*CF.A(M.R(-19.4),M.R(5.1),M.R(-14.1)),Alpha,'Lerp')
				elseif(State == 'Idle')then
					local Alpha = .2
					Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(0 -  5 * math.cos(Sine/10)),M.R(0 - 12.5 * math.sin(Sine/10))),Alpha,'Lerp')
					Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(0 - 40 * math.sin(Sine/10)),M.R(0),M.R(-10)),Alpha,'Lerp')
					Animate(LH,CF.N(0,0,0) * CF.A(M.R(0),M.R(0 - 5 * math.cos(Sine/10)),M.R(0)) * CF.N(-0.5,-2,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RJ,CF.N(0,0,0) * CF.A(M.R(0),M.R(0 + 5 * math.cos(Sine/10)),M.R(0)) * CF.N(0,0,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RH,CF.N(0,0,0) * CF.A(M.R(0),M.R(0 - 5 * math.cos(Sine/10)),M.R(0)) * CF.N(0.5,-2,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,'Lerp')
					Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(0 + 40 * math.sin(Sine/10)),M.R(0),M.R(10)),Alpha,'Lerp')
	
				elseif(State == 'Walk')then
					--[[Animate(RJ,CF.N(0,0,-.2)*CF.A(M.R(-10*Vec.Z),0,M.R(-10*Vec.X))*CF.N(0,-.1-.15*M.C(Sine/(wsVal/2)),0)*CF.A(0,M.R(0-15*M.S(Sine/wsVal)/2),0),.2,'Lerp')
					Animate(NK,NKC0,.2,'Lerp')
					Animate(RS,RSC0*CF.A(0,0,M.R(3))*CF.N(0,0,0+.5*M.C(Sine/wsVal)*Vec.Z)*CF.A(M.R(0-40*M.C(Sine/wsVal)+-M.S(Sine/wsVal))*Vec.Z,0,0),.2,'Lerp')
					Animate(LS,LSC0*CF.A(0,0,M.R(-3))*CF.N(0,0,0-.5*M.C(Sine/wsVal)*Vec.Z)*CF.A(M.R(0+40*M.C(Sine/wsVal)+-M.S(Sine/wsVal))*Vec.Z,0,0),.2,'Lerp')]]
						local Alpha = .2
						Animate(NK,CF.N(0,1.5,0)*CF.A(M.R(0),M.R(-10 * Vec.X),M.R(0)),Alpha,'Lerp')
						Animate(LS,CF.N(-1.5,0.5,0 + .4 * math.sin(Sine/4))*CF.A(M.R(0 - 85 * math.sin(Sine/4)),M.R(0),M.R(-5 * Vec.X  + -10 * math.sin(Sine/4))),Alpha,'Lerp')
						Animate(LH,CF.N(-0.5 - .17  * Vec.X,-1.7 + 1.1 * math.cos(Sine/4),0 -  2  * math.sin(Sine/4))*CF.A(M.R(-30 + 110 * math.sin(Sine/4)),M.R(0),M.R(-8 * Vec.X)),Alpha,'Lerp')
						Animate(RJ,CF.N(0,0 + .4 * math.cos(Sine/2),0)*CF.A(M.R(-7 - 6 * math.sin(Sine/2)),M.R(10 * Vec.X),M.R(0)),Alpha,'Lerp')
						Animate(RH,CF.N(0.5 + .17  * Vec.X,-1.7 - 1.1 * math.cos(Sine/4),0 + 2 * math.sin(Sine/4))*CF.A(M.R(-30 - 110 * math.sin(Sine/4)),M.R(0),M.R(8 * Vec.X)),Alpha,'Lerp')
						Animate(RS,CF.N(1.5,0.5,0 - .4 * math.sin(Sine/4))*CF.A(M.R(0  + 85 * math.sin(Sine/4)),M.R(0),M.R(5 * Vec.X - 10 * math.sin(Sine/4))),Alpha,'Lerp')

				elseif(State == 'Jump')then
						local Alpha = .2
						Animate(NK,CF.N(0,1.47,0.17)*CF.A(M.R(20),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-35),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(LH,CF.N(-0.5,-1.61,0.06)*CF.A(M.R(-15),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RJ,CF.N(0,0,0)*CF.A(M.R(0),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RH,CF.N(0.5,-1.94,0.34)*CF.A(M.R(-20),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-35),M.R(0),M.R(0)),Alpha,'Lerp')
	

				elseif(State == 'Fall')then
						local Alpha = .2
						Animate(NK,CF.N(0,1.35,-0.35)*CF.A(M.R(-45),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(LS,CF.N(-1.5,0.5,0)*CF.A(M.R(-35),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(LH,CF.N(-0.5,-1.62,-0.37)*CF.A(M.R(10),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RJ,CF.N(0,0,0)*CF.A(M.R(15),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RH,CF.N(0.5,-1.98,0.17)*CF.A(M.R(-10),M.R(0),M.R(0)),Alpha,'Lerp')
						Animate(RS,CF.N(1.5,0.5,0)*CF.A(M.R(-35),M.R(0),M.R(0)),Alpha,'Lerp')
				end
			end
		end
	end)
	return true
end

-- ============================== BOOT / RESPAWN / UNLOAD ==============================
local function reapplyAll()
	local char, hum = getParts()
	if not char then
		warn("[PopperHub] needs an R6 character")
		return
	end
	stripOutfit(char)
	applyOutfit(char)
	watchOutfit(char)
	applyBody(char)
	local ok, err = Rig_Start(char, hum)
	if not ok then warn("[PopperHub] " .. tostring(err)) end
end

local function boot(char)
	char:WaitForChild("Humanoid", 10)
	char:WaitForChild("Head", 10)
	char:WaitForChild("Torso", 10)
	task.wait(0.6)
	if genv.__PopperHub and genv.__PopperHub.Token == lp and lp.Character == char then reapplyAll() end
end

track(lp.CharacterAdded:Connect(function(char) task.spawn(boot, char) end))

local function Destroy()
	Rig_Stop()
	if watchConn then watchConn:Disconnect() end
	restoreOutfit(lp.Character)
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	table.clear(conns)
	genv.__PopperHub = nil
end

genv.__PopperHub = { Destroy = Destroy, Token = lp }
if lp.Character then task.spawn(boot, lp.Character) end
