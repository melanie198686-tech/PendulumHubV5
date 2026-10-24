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
local ShowButton = Instance.new("TextButton")
local CornerShowButton = Instance.new("UICorner")

local CornerFrame = Instance.new("UICorner")
local CornerHeader = Instance.new("UICorner")

local StrokeFrame = Instance.new("UIStroke")

ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

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
TextDesc.Text = "Pendulum hub fling"
TextDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
TextDesc.TextSize = 12.000
TextDesc.TextXAlignment = Enum.TextXAlignment.Left
TextDesc.TextScaled = true
TextDesc.TextWrapped = true


TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 18, 0, 43)
TextButton.Size = UDim2.new(0, 121, 0, 35)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "FLING OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000

-- Always-visible bottom-left control for hiding/showing the main panel.
ShowButton.Name = "ShowButton"
ShowButton.Parent = ScreenGui
ShowButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
ShowButton.BorderSizePixel = 0
ShowButton.Position = UDim2.new(0, 12, 1, -46)
ShowButton.Size = UDim2.new(0, 78, 0, 34)
ShowButton.Font = Enum.Font.Sarpanch
ShowButton.Text = "HIDE"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 17
ShowButton.AutoButtonColor = true
ShowButton.ZIndex = 100

CornerShowButton.CornerRadius = UDim.new(0, 7)
CornerShowButton.Parent = ShowButton

ShowButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ShowButton.Text = Frame.Visible and "HIDE" or "SHOW"
end)




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
		toggleButton.Text = hiddenfling and "FLING ON" or "FLING OFF"
		if hiddenfling then coroutine.wrap(fling)() end
	end)
end
coroutine.wrap(IIMAWH_fake_script)()



-- Grey torso-sized follower with a semi-transparent rainbow fill.
-- Left-click and hold to move the marker toward the mouse; release to return it 7 studs below the torso.
-- Visual-only: deliberately does not apply fling forces to other players.
local function RAINBOW_FOLLOWER_script()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local mouse = lp:GetMouse()
    local enabled = true
    local isHolding = false
    local marker = nil
    local highlight = nil
    local xrayAdornment = nil
    local connection = nil
    local hue = 0

    local function getCharacterParts()
        local character = lp.Character
        if not character then return nil, nil, nil end
        local root = character:FindFirstChild("HumanoidRootPart")
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        return character, root, torso
    end

    local function removeMarker()
        if connection then connection:Disconnect(); connection = nil end
        if highlight then highlight:Destroy(); highlight = nil end
        if xrayAdornment then xrayAdornment:Destroy(); xrayAdornment = nil end
        if marker then marker:Destroy(); marker = nil end
    end

    local function makeMarker()
        removeMarker()
        local character, root, torso = getCharacterParts()
        if not character then return end

        marker = Instance.new("Part")
        marker.Name = "HighlightFlingPart"
        marker.Anchored = true
        marker.CanCollide = false
        marker.CanTouch = false
        marker.CanQuery = false
        marker.Color = Color3.fromRGB(163, 162, 165)
        marker.Material = Enum.Material.SmoothPlastic
        marker.Transparency = 0.5
        marker.CastShadow = false
        marker.Size = (torso and torso:IsA("BasePart")) and torso.Size or Vector3.new(2, 2, 1)
        marker.Parent = workspace

        highlight = Instance.new("Highlight")
        highlight.Name = "RainbowFollowerHighlight"
        highlight.Adornee = marker
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 1
        highlight.Enabled = true
        highlight.Parent = workspace

        -- X-ray box is a second, translucent through-walls visual fallback.
        xrayAdornment = Instance.new("BoxHandleAdornment")
        xrayAdornment.Name = "RainbowFollowerXRay"
        xrayAdornment.Adornee = marker
        xrayAdornment.Size = marker.Size
        xrayAdornment.Transparency = 0.5
        xrayAdornment.AlwaysOnTop = true
        xrayAdornment.ZIndex = 5
        xrayAdornment.Shading = Enum.AdornShading.XRay
        xrayAdornment.Parent = workspace

        connection = RunService.RenderStepped:Connect(function(dt)
            if not enabled or not marker or not marker.Parent then return end
            local currentCharacter, currentRoot, currentTorso = getCharacterParts()
            if not currentCharacter or not currentRoot then return end
            if currentTorso and currentTorso:IsA("BasePart") then
                marker.Size = currentTorso.Size
            end
            if isHolding and mouse and mouse.Hit then
                marker.CFrame = marker.CFrame:Lerp(CFrame.new(mouse.Hit.Position), 0.5)
            else
                local base = currentTorso or currentRoot
                marker.CFrame = base.CFrame * CFrame.new(0, -7, 0)
            end
            hue = (hue + dt * 0.18) % 1
            local rainbow = Color3.fromHSV(hue, 1, 1)
            marker.Color = Color3.fromRGB(163, 162, 165)
            if highlight then highlight.FillColor = rainbow end
            if xrayAdornment then
                xrayAdornment.Size = marker.Size
                xrayAdornment.Color3 = rainbow
            end
        end)
    end

    mouse.Button1Down:Connect(function() isHolding = true end)
    mouse.Button1Up:Connect(function() isHolding = false end)


    lp.CharacterAdded:Connect(function()
        if enabled then task.defer(makeMarker) end
    end)

    makeMarker()
end
coroutine.wrap(RAINBOW_FOLLOWER_script)()



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

