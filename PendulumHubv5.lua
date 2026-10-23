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
	SettingsTab:NewButton("CLICK THIS TO GET FLING!", "Yesirrr finnally a flinggg", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Touchfling.lua"))()
	end)
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
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Sonic.lua"))()
	end)

	ScriptsTab:NewButton("Killbot V2", "The script kinda sucks lol.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Killbotv2.lua"))()
	end)

	ScriptsTab:NewButton("Joy", "I dont think it has keybinds.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Joy.lua"))()
	end)

	ScriptsTab:NewButton("Sniper", "Its kind of buggy lol.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Sniper.lua"))()
	end)

	ScriptsTab:NewButton("Bizzaro", "i dont even know what to put here.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Bizzaro.lua"))()
	end)

	ScriptsTab:NewButton("Chill", "You can get a lot of peoples attention with this.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Chill.lua"))()
	end)

	ScriptsTab:NewButton("Sans", "such a sigma.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/FESans.lua"))()
	end)

	ScriptsTab:NewButton("Killer", "RAH I WILL SAW OF YOUR PP.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Killer.lua"))()
	end)

	ScriptsTab:NewButton("Amythest Ninja", "So this one is rlly buggy i tried it okaay.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Amythest%20Ninja.lua"))()
	end)

	ScriptsTab:NewButton("Xester", "Card master.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/xester.lua"))()
	end)

	ScriptsTab:NewButton("Internal War WIP", "Card master.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Internal%20War%20WIP.lua"))()
	end)

	ScriptsTab:NewButton("Ether", "Yellow shootinggggg.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Amythest%20Ninja.lua"))()
	end)

	ScriptsTab:NewButton("Katarnist", "Gonna slice ur pp.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Katarnist.lua"))()
	end)

	ScriptsTab:NewButton("Pen", "U do need a hat sword but its boring anyways.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/FEPen.lua"))()
	end)

	ScriptsTab:NewButton("Baldi", "Hes gonna slap ur  booty checks.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Baldi.lua"))()
	end)

	ScriptsTab:NewButton("Drone", "U do need a hat sword but its boring anyways.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Drone.lua"))()
	end)

	ScriptsTab:NewButton("Echo banisher", "Bros such a demon.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Echo%20banisher.lua"))()
	end)

	ScriptsTab:NewButton("Video Powers", "I expected something better duh.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Video%20Powers.lua"))()
	end)

	ScriptsTab:NewButton("The Pacifist", "Pretty lame but its cool.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/The%20Pacifist.lua"))()
	end)

	ScriptsTab:NewButton("Sword Thing", "Hit people with a metal sword.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Swordthing.lua"))()
	end)

	ScriptsTab:NewButton("Crazy Rainbow Energy Blade", "wtf is  this shit.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Crazy%20Rainbow%20Energy%20Blade.lua"))()
	end)

	ScriptsTab:NewButton("Chara", "goofy ahhh.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Chara.lua"))()
	end)

	ScriptsTab:NewButton("Reaper", "tought it would be something with a sword but i guess...", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Reaper.lua"))()
	end)

	ScriptsTab:NewButton("Billie", "idk why  tf this is even a thing but okay.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/billie.lua"))()
	end)

	ScriptsTab:NewButton("Ban Sword", "its actually just ban hammer lol.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Ban%20Sword.lua"))()
	end)

	ScriptsTab:NewButton("Memeus v2.5", "all of them memes are dead boi that was like 10 years ago", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Memeus.lua"))()
	end)

	ScriptsTab:NewButton("Krystal dance", "Some nice dances. My favorite is U.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Krystal%20dance.lua"))()
	end)

	ScriptsTab:NewButton("Minigun", "Have fun spraying skids.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Minigun.lua"))()
	end)

	ScriptsTab:NewButton("Grappler", "So uh good to escape.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Grappler.lua"))()
	end)

	ScriptsTab:NewButton("Darth Vadar", "for the star wars fans.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/darthvadar.lua"))()
	end)

	ScriptsTab:NewButton("Nightmare sans", "left click to fling. time it with attacks to fling.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Nightmaresans.lua"))()
	end)

	ScriptsTab:NewButton("Sexy Staff Girl", "WITCHHHH.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Sexy%20staff%20girl.lua"))()
	end)

	ScriptsTab:NewButton("Studio Dummy", "shotgun paoww.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Studio%20dummy.lua"))()
	end)

	ScriptsTab:NewButton("Road Roudge", "vroom vroom vroom.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Notify.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Roadrogue.lua"))()
	end)

	ScriptsTab:NewButton("Chips", "Hit people with chips yea.", function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
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

		cwScriptsTab:NewButton('Neko V4', 'Uh little buggy animations', function()
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/nekov4.lua'))()
		end)
		
		cwScriptsTab:NewButton('Neko V5', 'v4 but  better animations', function()
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/nekov5'))()	
		end)	

		cwScriptsTab:NewButton('Road Rogue', 'vroom vroom', function()
		    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHub/refs/heads/main/Roadrogue.lua'))()	
		end)	

		cwScriptsTab:NewButton('Katarnist', 'Hes gonna slice ur pp', function()
		    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Katarnist.lua'))()	
		end)

		cwScriptsTab:NewButton('Studio dummy v3', 'ohhhh idk ', function()
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Notify%20Sound"))()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/melanie198686-tech/PendulumHubV5/refs/heads/main/Studio%20dummy.lua'))()	
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
