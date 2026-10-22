local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local oldGui = PlayerGui:FindFirstChild("TouchFlingRemakeGui")
if oldGui then
	oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TouchFlingRemakeGui"
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextDesc = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local TextButton2 = Instance.new("TextButton")
local ImageButton = Instance.new("ImageButton")
local Frame3 = Instance.new("CanvasGroup")
local Frame_4 = Instance.new("Frame")
local TextLabel3 = Instance.new("TextLabel")
local LogsLabel = Instance.new("TextLabel")
local HideButton = Instance.new("TextButton")

local CornerFrame = Instance.new("UICorner")
local CornerHeader = Instance.new("UICorner")
local CornerLogs = Instance.new("UICorner")
local CornerLogsHeader = Instance.new("UICorner")
local CornerHide = Instance.new("UICorner")

local StrokeFrame = Instance.new("UIStroke")
local StrokeFrame3 = Instance.new("UIStroke")

ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 160)

CornerFrame.CornerRadius = UDim.new(0, 8)
CornerFrame.Parent = Frame

StrokeFrame.Color = Color3.fromRGB(50, 50, 50)
StrokeFrame.Thickness = 1.5
StrokeFrame.Parent = Frame

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 30)

CornerHeader.CornerRadius = UDim.new(0, 8)
CornerHeader.Parent = Frame_2

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 5, 0, 1)
TextLabel.Size = UDim2.new(0, 120, 0, 15)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "the Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25.000
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextScaled = true

TextDesc.Parent = Frame_2
TextDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextDesc.BackgroundTransparency = 1.000
TextDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextDesc.BorderSizePixel = 0
TextDesc.Position = UDim2.new(0, 5, 0, 16)
TextDesc.Size = UDim2.new(0, 120, 0, 11)
TextDesc.Font = Enum.Font.SourceSans
TextDesc.Text = "deobfuscation by 118_W (6xow in discord)"
TextDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
TextDesc.TextSize = 12.000
TextDesc.TextXAlignment = Enum.TextXAlignment.Left
TextDesc.TextScaled = true
TextDesc.TextWrapped = true

ImageButton.Parent = Frame_2
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 1.000
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(1, -23, 0, 4)
ImageButton.Size = UDim2.new(0, 22, 0, 22)
ImageButton.Image = "rbxassetid://10709791437"

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.113924049, 0, 0.25, 0)
TextButton.Size = UDim2.new(0, 121, 0, 35)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "fling OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000

TextButton2.Parent = Frame
TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.BorderSizePixel = 0
TextButton2.Position = UDim2.new(0.113924049, 0, 0.58, 0)
TextButton2.Size = UDim2.new(0, 121, 0, 35)
TextButton2.Font = Enum.Font.SourceSansItalic
TextButton2.Text = "TP OFF"
TextButton2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton2.TextSize = 20.000

Frame3.Parent = Frame
Frame3.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame3.BorderSizePixel = 0
Frame3.Position = UDim2.new(1, 5, 0, 0)
Frame3.Size = UDim2.new(0, 158, 0, 160)
Frame3.Visible = false
Frame3.GroupTransparency = 1

CornerLogs.CornerRadius = UDim.new(0, 8)
CornerLogs.Parent = Frame3

StrokeFrame3.Color = Color3.fromRGB(50, 50, 50)
StrokeFrame3.Thickness = 1.5
StrokeFrame3.Parent = Frame3

Frame_4.Parent = Frame3
Frame_4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_4.BorderSizePixel = 0
Frame_4.Size = UDim2.new(0, 158, 0, 25)

CornerLogsHeader.CornerRadius = UDim.new(0, 8)
CornerLogsHeader.Parent = Frame_4

TextLabel3.Parent = Frame_4
TextLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.BackgroundTransparency = 1.000
TextLabel3.BorderSizePixel = 0
TextLabel3.Position = UDim2.new(0, 5, 0, 0)
TextLabel3.Size = UDim2.new(0, 148, 0, 25)
TextLabel3.Font = Enum.Font.Sarpanch
TextLabel3.Text = "Change logs"
TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.TextSize = 25.000
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.TextScaled = true

LogsLabel.Parent = Frame3
LogsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogsLabel.BackgroundTransparency = 1.000
LogsLabel.BorderSizePixel = 0
LogsLabel.Position = UDim2.new(0, 8, 0, 33)
LogsLabel.Size = UDim2.new(0, 142, 0, 117)
LogsLabel.Font = Enum.Font.SourceSans
LogsLabel.Text = "- Deobfuscation by 118_W (6xow in discord)"
LogsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogsLabel.TextSize = 14.000
LogsLabel.TextXAlignment = Enum.TextXAlignment.Left
LogsLabel.TextYAlignment = Enum.TextYAlignment.Top
LogsLabel.TextWrapped = true

HideButton.Parent = ScreenGui
HideButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
HideButton.BorderSizePixel = 0
HideButton.Position = UDim2.new(0, 15, 1, -50)
HideButton.Size = UDim2.new(0, 80, 0, 35)
HideButton.Font = Enum.Font.Sarpanch
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 18.000

CornerHide.CornerRadius = UDim.new(0, 6)
CornerHide.Parent = HideButton

local function IIMAWH_fake_script()
	local script = Instance.new('LocalScript', TextButton)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	
	local toggleButton = script.Parent
	local hiddenfling = false
	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end
	
	local function fling()
		local lp = Players.LocalPlayer
		while hiddenfling and toggleButton:IsDescendantOf(game) do
			RunService.Heartbeat:Wait()
			if not toggleButton:IsDescendantOf(game) then break end
			local c = lp.Character
			local hrp = c and c:FindFirstChild("HumanoidRootPart")
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= lp and player.Character then
					for _, part in ipairs(player.Character:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = false end
					end
				end
			end
			if hrp then
				local vel = hrp.Velocity
				hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
			end
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		hiddenfling = not hiddenfling
		toggleButton.Text = hiddenfling and "fling ON" or "fling OFF"
		if hiddenfling then coroutine.wrap(fling)() end
	end)
end
coroutine.wrap(IIMAWH_fake_script)()

local function TP_fake_script()
	local script = Instance.new('LocalScript', TextButton2)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local workspace = game:GetService("Workspace")
	local lp = Players.LocalPlayer
	local toggleButton = script.Parent
	local loopTP = false
	
	local currentTarget = nil
	local targetStartTime = 0
	local tpPart = nil
	local camera = workspace.CurrentCamera

	local function isRagdolled(humanoid)
		return humanoid.PlatformStand or humanoid:GetState() == Enum.HumanoidStateType.Physics
	end

	local function getClosestTarget(ignore)
		local closest = nil
		local dist = math.huge
		local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if not myHrp then return nil end

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and p ~= ignore and p.Character then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				if hum and hrp and hum.Health > 0 then
					local d = (hrp.Position - myHrp.Position).Magnitude
					if d < dist then
						dist = d
						closest = p
					end
				end
			end
		end
		return closest
	end

	local function doLoopTP()
		tpPart = Instance.new("Part")
		tpPart.Size = Vector3.new(1, 1, 1)
		tpPart.Transparency = 1
		tpPart.CanCollide = false
		tpPart.Anchored = true
		tpPart.Parent = workspace

		while loopTP and toggleButton:IsDescendantOf(game) do
			RunService.Heartbeat:Wait()
			if not toggleButton:IsDescendantOf(game) then
				loopTP = false
				break
			end
			
			local now = tick()
			local shouldSwitch = false
			
			if currentTarget then
				local hum = currentTarget.Character and currentTarget.Character:FindFirstChildOfClass("Humanoid")
				local hrp = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
				
				if not hum or not hrp or hum.Health <= 0 or isRagdolled(hum) then
					shouldSwitch = true
					currentTarget = nil
				else
					local speed = hrp.Velocity.Magnitude
					if speed > 35 or (now - targetStartTime > 1.45) then
						shouldSwitch = true
					end
				end
			else
				shouldSwitch = true
			end

			if shouldSwitch then
				local oldTarget = currentTarget
				currentTarget = getClosestTarget(oldTarget)
				if not currentTarget and oldTarget then
					local hum = oldTarget.Character and oldTarget.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 and not isRagdolled(hum) then
						currentTarget = oldTarget
					end
				end
				targetStartTime = tick()
			end

			if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
				local targetHrp = currentTarget.Character.HumanoidRootPart
				local targetHum = currentTarget.Character:FindFirstChildOfClass("Humanoid")
				local myChar = lp.Character
				local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
				local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
				
				if targetHum then
					camera.CameraSubject = targetHum
				end

				if myHrp and myHum then
					myHum.PlatformStand = true
					local angle = (tick() * 2880) % 360
					tpPart.CFrame = targetHrp.CFrame * CFrame.Angles(math.rad(angle), 0, 0) * CFrame.new(0, 0, 0.5)
					myHrp.CFrame = tpPart.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
				end
			else
				local myChar = lp.Character
				local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
				if myHum then
					camera.CameraSubject = myHum
				end
			end
		end
		
		if tpPart then
			tpPart:Destroy()
			tpPart = nil
		end

		local myChar = lp.Character
		local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
		if myHum then
			myHum.PlatformStand = false
			camera.CameraSubject = myHum
		end
	end

	toggleButton.MouseButton1Click:Connect(function()
		loopTP = not loopTP
		toggleButton.Text = loopTP and "TP ON" or "TP OFF"
		if loopTP then
			currentTarget = nil
			coroutine.wrap(doLoopTP)()
		else
			local myChar = lp.Character
			local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
			if myHum then
				camera.CameraSubject = myHum
			end
		end
	end)
end
coroutine.wrap(TP_fake_script)()

local function CHANGELOG_fake_script()
	local script = Instance.new('LocalScript', ImageButton)
	local TweenService = game:GetService("TweenService")
	local btn = script.Parent
	local open = false
	
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			btn.Image = "rbxassetid://10709791281"
			Frame3.Visible = true
			TweenService:Create(Frame3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
		else
			btn.Image = "rbxassetid://10709791437"
			local tween = TweenService:Create(Frame3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
			tween:Play()
			tween.Completed:Connect(function()
				if not open then
					Frame3.Visible = false
				end
			end)
		end
	end)
end
coroutine.wrap(CHANGELOG_fake_script)()

local function HIDE_fake_script()
	local script = Instance.new('LocalScript', HideButton)
	local btn = script.Parent
	
	btn.MouseButton1Click:Connect(function()
		Frame.Visible = not Frame.Visible
		if Frame.Visible then
			btn.Text = "Hide"
		else
			btn.Text = "Show"
		end
	end)
end
coroutine.wrap(HIDE_fake_script)()

local function QCJQJL_fake_script()
	local script = Instance.new('LocalScript', Frame)
	script.Parent.Active = true
	script.Parent.Draggable = true
end
coroutine.wrap(QCJQJL_fake_script)()

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local heartbeatConnection = nil
local stateConnection = nil

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "system anti fling loaded (The use of AI is definitely 😭💀)",
        Text = "anti fling has active (Deobfuscation by 118_W (6xow in discord)",
        Duration = 3.5
    })
end)

local function cleanup()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    if stateConnection then
        stateConnection:Disconnect()
        stateConnection = nil
    end
end
