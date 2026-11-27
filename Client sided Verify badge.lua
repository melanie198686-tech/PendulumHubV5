-- Ai made ts 
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local BADGE_EMOJI = ""


if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	TextChatService.OnIncomingMessage = function(message: TextChatMessage)
		local source = message.TextSource
		if source and source.UserId == LocalPlayer.UserId then
			local props = Instance.new("TextChatMessageProperties")
			local currentText = message.Text or ""
			if not string.find(currentText, BADGE_EMOJI, 1, true) then
				props.Text = BADGE_EMOJI .. " " .. currentText
			end
			return props
		end
		return nil
	end
end


local function matchesPlayerName(text: string): boolean
	local trimmed = string.match(text, "^%s*(.-)%s*$") or ""
	if trimmed == "" then
		return false
	end

	if trimmed == LocalPlayer.Name or trimmed == LocalPlayer.DisplayName then
		return true
	end

	if string.sub(trimmed, 1, #LocalPlayer.Name) == LocalPlayer.Name then
		return true
	end

	if string.sub(trimmed, 1, #LocalPlayer.DisplayName) == LocalPlayer.DisplayName then
		return true
	end

	return false
end

local function appendBadgeAfterName(obj: Instance)
	if not obj:IsA("TextLabel") then
		return
	end

	local currentText = obj.Text
	if type(currentText) ~= "string" or currentText == "" then
		return
	end

	if string.find(currentText, BADGE_EMOJI, 1, true) then
		return
	end

	if matchesPlayerName(currentText) then
		obj.Text = currentText .. " " .. BADGE_EMOJI
	end
end

local function scanUiContainer(container: Instance)
	for _, desc in ipairs(container:GetDescendants()) do
		appendBadgeAfterName(desc)
	end
end

task.spawn(function()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	playerGui.DescendantAdded:Connect(function(desc)
		task.defer(appendBadgeAfterName, desc)
	end)

	while true do
		scanUiContainer(playerGui)
		task.wait(1)
	end
end)
