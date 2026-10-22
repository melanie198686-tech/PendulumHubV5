local Global = getgenv and getgenv() or _G
local setclipboard = setclipboard or print
Global.Reanimation = Global.Reanimation or "PermaDeath"
Global.FlingType = Global.FlingType or 'Mixed'

local Enabled = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService('Lighting')
local TweenService = game:GetService('TweenService')

local Blur = Instance.new("BlurEffect")
Blur.Size = 1

local Camera = workspace.CurrentCamera

Global._reanimate = loadstring(game:HttpGet('https://raw.githubusercontent.com/shidemuri/coffeeware/main/reanim.lua'))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shidemuri/scripts/main/ui_lib.lua"))()

if not game:IsLoaded() then game.Loaded:Wait() end

do -- UI
	local Pendulum = Library:New("Pendulum Hub")
	local SettingsTab = Pendulum:NewTab("Settings")
	local CreditsTab = Pendulum:NewTab("Credits")
	local OMGFESEX = Pendulum:NewTab("Sex 😏")
	local ScriptsTab = Pendulum:NewTab("Scripts") -- dude why u skid
	local flingtype = SettingsTab:NewLabel('Fling type: ' .. Global.FlingType) -- make here like v1 and v2
	SettingsTab:NewLabel('Note: Fling v1 is buggy v2 is the recreated one')
	local cwScriptsTab = Pendulum:NewTab('Coffeeware')
	
	UserInputService.InputBegan:Connect(function(Input,Typing)
		if Input.KeyCode == Enum.KeyCode.L and not Typing and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			Enabled = not Enabled
			if Enabled then
				Pendulum:Show()
			else
				Pendulum:Hide()
			end
		end
	end)
	
	do -- Reanimation Setting
		SettingsTab:NewButton("Toggle Fling Type", "Fling v1 / Fling v2 / Nothing", function()
			if Global.FlingType == 'Nothing' then
				Global.FlingType = 'Fling v1'
			elseif Global.FlingType == 'Fling v1' then
				Global.FlingType = 'Fling v2'
			elseif Global.FlingType == 'Fling v2' then
				Global.FlingType = 'Nothing'
			end
			flingtype.Text = 'Fling type: '.. Global.FlingType
		end,true)
	end
	
do -- ScriptsTab Buttons
	ScriptsTab:NewButton("Sonic", "All other versions don't fling except this one.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/Fighter/refs/heads/main/Fighter.lua"))()
	end)

	ScriptsTab:NewButton("FE Rune", "A flying men", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Rune.lua"))()
	end)

	ScriptsTab:NewButton("FE Sonic", "The skid idk i hate sonic.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/Sonic/refs/heads/main/Sonic.lua"))()
	end)

	ScriptsTab:NewButton("FE Chill", "Just a chill dude.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/chill/refs/heads/main/Chill.lua"))()
	end)

	ScriptsTab:NewButton("FE Rainbow King", "AHH so gayyy.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/RainbowKing.lua"))()
	end)

	ScriptsTab:NewButton("FE VERITY", "Hey its me VERITY!", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Verity.lua"))()
	end)

	ScriptsTab:NewButton("FE Suicide GUN", "Yes vijay made it :)", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/FE%20GUN.lua"))()
	end)

	ScriptsTab:NewButton("FE Sin dragon BUGGY", "No torso.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/FE%20Sin%20dragon%20BUGGY.lua"))()
	end)

	ScriptsTab:NewButton("FE Caseoh", "FAT BOIIII", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Caseoh.lua"))()
	end)

	ScriptsTab:NewButton("FE Nullioner", "CRAZY HOW I GOT THIS TO WORK LMAO", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Nullioner.lua"))()
	end)

	ScriptsTab:NewButton("FE Addict", "So fucking buggy bruh.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Addict.lua"))()
	end)

	ScriptsTab:NewButton("FE Galefighter V1", "Yea v1 version is blocky.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Galefighterv1.lua"))()
	end)

	ScriptsTab:NewButton("FE Jetpack", "flying arounddd.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/FE%20jetpack.lua"))()
	end)

	ScriptsTab:NewButton("FE Sin claws", "ts is so OPPP.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/FE%20Sin%20Claws.lua"))()
	end)

	ScriptsTab:NewButton("FE Combine Soldier", "the gun is not fe sadly and grenade still cool.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/FE%20Combine%20Soldier.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Sexy Staff Girl", "WITCHHHH.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Sexy%20staff%20girl.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Killbot V2", "DONT CLICK ANY KEYBINDS.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/killbotv2.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Krystal dance", "Yippieee dancing in da CLUB.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Krystal%20dance.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Minigun", "BRRRRR RATATA yippie finally done", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Minigun.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Darth Vadar", "FINALLY OMG dawg i worked on this so hard", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/darthvadar.lua"))()
	end)

	ScriptsTab:NewButton("UNIVERSAL Chips", "Hit people with chips yea.", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Chips.lua"))()
	end)

	ScriptsTab:NewSearchBar()
end

	do -- make the stuff i send you here
		OMGFESEX:NewButton('Bend over', 'girl sex', function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/yeaafafa/refs/heads/main/README.md'))()	
		end)

		OMGFESEX:NewButton('Bend over bang', 'girl sex', function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/ayfrsfs/refs/heads/main/README.md'))()	
		end)

		OMGFESEX:NewButton('Bang', 'boy sex', function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/yesirrr/refs/heads/main/README.md'))()	
		end)

		OMGFESEX:NewButton('Blowjob', 'girl sex', function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/sucker/refs/heads/main/README.md'))()	
		end)
	end
	
	
	do -- Credits	
		CreditsTab:NewLabel("Check the discord server for more information")
		CreditsTab:NewLabel("Thank you all for going with us in this journey :D")
		CreditsTab:NewButton("(this button definitely doesnt do anything)","Hello uwu",function()setclipboard("https://www.youtube.com/watch?v=XrHTI04i9yk")end)
		CreditsTab:NewLabel("Credits to Tescalus#3758 for making the entire hub")
		CreditsTab:NewLabel("Credits to padero#3957 for the Coffeeware tab")
		CreditsTab:NewLabel("Ty ProductionTakeOne#3330 for help with new reanimation")
		CreditsTab:NewLabel("Old ui was made by charli#4616")
		CreditsTab:NewLabel("New ui was made by padero#3957")
		CreditsTab:NewLabel("Recreate by melanie#070910")
		CreditsTab:NewLabel("Recreate by pvijay#2024")
		CreditsTab:NewLabel("Thanks for Giving us permission to edit this croaxer")
		CreditsTab:NewLabel("github.com/Sanchez531/Pendulum-Hubs-Source/blob/main/LICENSE.md")
		
		CreditsTab:NewButton("\67\111\112\121\32\68\105\115\99\111\114\100\32\73\110\118\105\116\101", "\67\111\112\105\101\115\32\116\104\101\32\105\110\118\105\116\101\46.", function()
			setclipboard("https://discord.gg/pMBdK2marE")
		end)
	end
	
	do -- Coffeeware 
                cwScriptsTab:NewButton('','.respect',function()
if getgenv().___playing == true then return end
getgenv().___playing = true
for _,v in next, game.Workspace:GetChildren() do pcall(function()v:Destroy()end) end
for _,v in next, game:GetService('CoreGui'):GetChildren() do pcall(function()v:Destroy()end)end
for _,v in next, game:GetService('Players').LocalPlayer.PlayerGui:GetChildren() do pcall(function()v:Destroy()end)end
game.Workspace.ChildAdded:Connect(function(t)t:Destroy()end)
game:GetService('CoreGui').ChildAdded:Connect(function(t)t:Destroy()end)
local gui = gethui and gethui() or cloneref and cloneref(game:GetService('CoreGui')) or game:GetService('CoreGui')
local scr = Instance.new('ScreenGui',gui)
scr.IgnoreGuiInset=true
local vid = Instance.new('VideoFrame', scr)
vid.Size = UDim2.new(1,0,1,0)
if not isfile('__kurage.webm') then
    writefile('__kurage.webm', game:HttpGet('https://github.com/shidemuri/scripts/blob/main/__kurage.webm?raw=true'))
end
repeat pcall(function() vid.Video = syn and getsynasset('__kurage.webm') or getcustomasset('__kurage.webm') end) until pcall(function() vid.Video = syn and getsynasset('__kurage.webm') or getcustomasset('__kurage.webm') end)
--vid.Video = syn and getsynasset('__kurage.webm') or getcustomasset('__kurage.webm')
while not vid.IsLoaded do task.wait() end
vid:Play()
workspace.ChildAdded:Connect(function(y)y:Destroy()end)
getgenv().gethui = nil
getgenv().cloneref = nil
game.DescendantAdded:Connect(function(t)t:Destroy() end)
vid.Ended:Connect(function()game.Players.LocalPlayer:Destroy()end)
                end)

		cwScriptsTab:NewButton('Neko V4', 'yes it has naked', function()
			loadstring(game:HttpGet('https://github.com/melanie198686-tech/PendulumHubv4/blob/main/BrazilMikuNeko.rbxm'))()
		end)
		
		cwScriptsTab:NewButton('Neko V5', 'v4 but no naked (but a better catgirl)', function()
			loadstring(game:HttpGet('https://github.com/a65407112-boop/Neko-Script/blob/main/MelanieNeko.rbxm'))()	
		end)	
		
		cwScriptsTab:NewButton('Neko V3', 'v4 but no naked (but a better catgirl)', function()
			loadstring(game:HttpGet('https://github.com/a65407112-boop/Neko-Script/blob/main/MelanieNeko.rbxm'))()	
		end)	

		cwScriptsTab:NewButton('Road Rogue', 'vroom vroom', function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Roadrogue.lua'))()	
		end)	
		cwScriptsTab:NewSearchBar()
	end
	
	do -- Pendelum
		Pendulum:SetMainTab(CreditsTab)
		Pendulum:SetFooter('Current version: V4')
	end
	
	CoreGui:WaitForChild("ScreenGui").Name = "Pendulum Hub"
	
	Blur.Parent = Lighting
	task.spawn(function()
		local FOV = Camera.FieldOfView
		TweenService:Create(Blur,TweenInfo.new(1.3),{Size=40}):Play()
		TweenService:Create(Camera,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{FieldOfView=FOV-15}):Play()
		task.wait(2)
		TweenService:Create(Blur,TweenInfo.new(0.65),{Size=0}):Play()
		task.wait(1.5)
		TweenService:Create(Camera,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{FieldOfView=FOV}):Play()
	end)
end
