local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui


-- Colors
local BG = Color3.fromRGB(15, 15, 17)
local BG_SECONDARY = Color3.fromRGB(19, 19, 21)

local BUTTON_BG = Color3.fromRGB(25, 25, 28)
local BUTTON_HOVER = Color3.fromRGB(31, 31, 34)

local BORDER = Color3.fromRGB(7, 7, 8)
local BORDER_LIGHT = Color3.fromRGB(48, 48, 53)

local PURPLE = Color3.fromRGB(125, 78, 165)
local PURPLE_HOVER = Color3.fromRGB(160, 105, 205)

local TEXT = Color3.fromRGB(242, 242, 245)
local TEXT_SECONDARY = Color3.fromRGB(195, 195, 200)
local TEXT_MUTED = Color3.fromRGB(145, 145, 152)


-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 430, 0, 480)
frame.Position = UDim2.new(0.5, -215, 0.5, -240)
frame.BackgroundColor3 = BG
frame.BackgroundTransparency = 0.015
frame.BorderSizePixel = 1
frame.BorderColor3 = BORDER
frame.ClipsDescendants = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 7)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = BORDER_LIGHT
frameStroke.Thickness = 1
frameStroke.Transparency = 0.45
frameStroke.Parent = frame


-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 105, 0, 27)
title.Position = UDim2.new(0, 40, 0, 18)
title.BackgroundTransparency = 1
title.Text = "MoonHub"
title.TextColor3 = TEXT
title.TextSize = 19
title.Font = Enum.Font.Gotham
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = frame


-- Beta
local beta = Instance.new("TextLabel")
beta.Size = UDim2.new(0, 44, 0, 19)
beta.Position = UDim2.new(0, 150, 0, 22)
beta.BackgroundColor3 = Color3.fromRGB(29, 24, 33)
beta.BackgroundTransparency = 0
beta.BorderSizePixel = 1
beta.BorderColor3 = Color3.fromRGB(58, 40, 70)
beta.Text = "BETA"
beta.TextColor3 = Color3.fromRGB(195, 155, 220)
beta.TextSize = 9
beta.Font = Enum.Font.GothamMedium
beta.TextXAlignment = Enum.TextXAlignment.Center
beta.TextYAlignment = Enum.TextYAlignment.Center
beta.Parent = frame

local betaCorner = Instance.new("UICorner")
betaCorner.CornerRadius = UDim.new(0, 4)
betaCorner.Parent = beta


-- Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 29, 0, 29)
closeButton.Position = UDim2.new(1, -45, 0, 17)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = Color3.fromRGB(8, 8, 9)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(165, 165, 172)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.Gotham
closeButton.AutoButtonColor = false
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(50, 50, 54)
closeStroke.Thickness = 1
closeStroke.Transparency = 0.45
closeStroke.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	TweenService:Create(
		closeButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			BackgroundColor3 = Color3.fromRGB(38, 25, 29),
			TextColor3 = Color3.fromRGB(255, 120, 125)
		}
	):Play()
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(
		closeButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 22),
			TextColor3 = Color3.fromRGB(165, 165, 172)
		}
	):Play()
end)


-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -50, 0, 1)
divider.Position = UDim2.new(0, 25, 0, 61)
divider.BackgroundColor3 = Color3.fromRGB(48, 48, 53)
divider.BackgroundTransparency = 0.35
divider.BorderSizePixel = 0
divider.Parent = frame


-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -50, 0, 24)
subtitle.Position = UDim2.new(0, 25, 0, 74)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Select a supported game to continue"
subtitle.TextColor3 = TEXT_SECONDARY
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextYAlignment = Enum.TextYAlignment.Center
subtitle.Parent = frame


-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -50, 0, 20)
status.Position = UDim2.new(0, 25, 0, 101)
status.BackgroundTransparency = 1
status.Text = "● Ready"
status.TextColor3 = Color3.fromRGB(105, 195, 130)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Center
status.Parent = frame


-- Game Button
local function createButton(text, subText, y, accent)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -50, 0, 58)
	button.Position = UDim2.new(0, 25, 0, y)
	button.BackgroundColor3 = BUTTON_BG
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 1
	button.BorderColor3 = BORDER
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = BORDER_LIGHT
	stroke.Thickness = 1
	stroke.Transparency = 0.45
	stroke.Parent = button


	-- Accent
	local accentLine = Instance.new("Frame")
	accentLine.Size = UDim2.new(0, 2, 0, 32)
	accentLine.Position = UDim2.new(0, 11, 0.5, -16)
	accentLine.BackgroundColor3 = accent
	accentLine.BorderSizePixel = 0
	accentLine.Parent = button

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(1, 0)
	accentCorner.Parent = accentLine


	-- Game title
	local gameTitle = Instance.new("TextLabel")
	gameTitle.Size = UDim2.new(1, -75, 0, 22)
	gameTitle.Position = UDim2.new(0, 25, 0, 8)
	gameTitle.BackgroundTransparency = 1
	gameTitle.Text = text
	gameTitle.TextColor3 = TEXT
	gameTitle.TextSize = 14
	gameTitle.Font = Enum.Font.Gotham
	gameTitle.TextXAlignment = Enum.TextXAlignment.Left
	gameTitle.TextYAlignment = Enum.TextYAlignment.Center
	gameTitle.Parent = button


	-- Description
	local gameSub = Instance.new("TextLabel")
	gameSub.Size = UDim2.new(1, -75, 0, 17)
	gameSub.Position = UDim2.new(0, 25, 0, 31)
	gameSub.BackgroundTransparency = 1
	gameSub.Text = subText
	gameSub.TextColor3 = TEXT_MUTED
	gameSub.TextSize = 10
	gameSub.Font = Enum.Font.Gotham
	gameSub.TextXAlignment = Enum.TextXAlignment.Left
	gameSub.TextYAlignment = Enum.TextYAlignment.Center
	gameSub.Parent = button


	-- Arrow
	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 25, 0, 30)
	arrow.Position = UDim2.new(1, -40, 0.5, -15)
	arrow.BackgroundTransparency = 1
	arrow.Text = "›"
	arrow.TextColor3 = Color3.fromRGB(105, 105, 112)
	arrow.TextSize = 22
	arrow.Font = Enum.Font.Gotham
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.TextYAlignment = Enum.TextYAlignment.Center
	arrow.Parent = button


	-- Hover
	button.MouseEnter:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = BUTTON_HOVER
			}
		):Play()

		TweenService:Create(
			stroke,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Color = accent,
				Transparency = 0.15
			}
		):Play()

		TweenService:Create(
			arrow,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				TextColor3 = accent
			}
		):Play()

	end)


	button.MouseLeave:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = BUTTON_BG
			}
		):Play()

		TweenService:Create(
			stroke,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Color = BORDER_LIGHT,
				Transparency = 0.45
			}
		):Play()

		TweenService:Create(
			arrow,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				TextColor3 = Color3.fromRGB(105, 105, 112)
			}
		):Play()

	end)

	return button
end


-- Buttons
local leftButton = createButton(
	"Bloodlines",
	"Launch Bloodlines loader",
	140,
	Color3.fromRGB(120, 75, 160)
)

local rightButton = createButton(
	"Murder Mystery 2",
	"Launch Murder Mystery 2 loader",
	208,
	Color3.fromRGB(130, 80, 170)
)

local universalButton = createButton(
	"Universal",
	"Launch Universal loader",
	276,
	Color3.fromRGB(140, 85, 180)
)


-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -50, 0, 18)
footer.Position = UDim2.new(0, 25, 1, -29)
footer.BackgroundTransparency = 1
footer.Text = "MoonHub  •  RightShift to toggle"
footer.TextColor3 = Color3.fromRGB(125, 125, 132)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.TextYAlignment = Enum.TextYAlignment.Center
footer.Parent = frame


-- Warning Notification
local function showWarning(gameName)

	local notification = Instance.new("Frame")
	notification.Name = "Warning"
	notification.Size = UDim2.new(0, 330, 0, 56)
	notification.Position = UDim2.new(0, -350, 0, 20)
	notification.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
	notification.BackgroundTransparency = 0
	notification.BorderSizePixel = 1
	notification.BorderColor3 = Color3.fromRGB(8, 8, 9)
	notification.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = notification

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(48, 48, 53)
	stroke.Thickness = 1
	stroke.Transparency = 0.35
	stroke.Parent = notification

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 2, 1, -18)
	bar.Position = UDim2.new(0, 9, 0, 9)
	bar.BackgroundColor3 = Color3.fromRGB(220, 165, 70)
	bar.BorderSizePixel = 0
	bar.Parent = notification

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 30, 0, 30)
	icon.Position = UDim2.new(0, 22, 0.5, -15)
	icon.BackgroundTransparency = 1
	icon.Text = "!"
	icon.TextColor3 = Color3.fromRGB(235, 180, 80)
	icon.TextSize = 18
	icon.Font = Enum.Font.Gotham
	icon.Parent = notification

	local warningText = Instance.new("TextLabel")
	warningText.Size = UDim2.new(1, -65, 1, -10)
	warningText.Position = UDim2.new(0, 58, 0, 5)
	warningText.BackgroundTransparency = 1
	warningText.Text = 'You are not on "' .. gameName .. '"'
	warningText.TextColor3 = TEXT
	warningText.TextSize = 12
	warningText.Font = Enum.Font.Gotham
	warningText.TextXAlignment = Enum.TextXAlignment.Left
	warningText.TextYAlignment = Enum.TextYAlignment.Center
	warningText.Parent = notification


	TweenService:Create(
		notification,
		TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0, 20, 0, 20)
		}
	):Play()


	task.delay(2.5, function()

		if notification and notification.Parent then

			local tween = TweenService:Create(
				notification,
				TweenInfo.new(
					0.25,
					Enum.EasingStyle.Quart,
					Enum.EasingDirection.In
				),
				{
					Position = UDim2.new(0, -350, 0, 20)
				}
			)

			tween:Play()

			tween.Completed:Once(function()

				if notification and notification.Parent then
					notification:Destroy()
				end

			end)

		end

	end)

end


-- GUI State
local isOpen = true
local isDeleted = false
local isAnimating = false

local normalSize = UDim2.new(0, 430, 0, 480)
local closedSize = UDim2.new(0, 430, 0, 0)


local function destroyGUI()

	if isDeleted then
		return
	end

	isDeleted = true
	isOpen = false
	isAnimating = false

	ContextActionService:UnbindAction("ToggleMoonHubGUI")

	if gui and gui.Parent then
		gui:Destroy()
	end

end


local function openGUI()

	if isDeleted or isOpen or isAnimating then
		return
	end

	isAnimating = true
	isOpen = true
	frame.Visible = true
	frame.Size = closedSize

	local tween = TweenService:Create(
		frame,
		TweenInfo.new(
			0.24,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.Out
		),
		{
			Size = normalSize
		}
	)

	tween:Play()

	tween.Completed:Once(function()

		if not isDeleted then
			isAnimating = false
		end

	end)

end


local function closeGUI()

	if isDeleted or not isOpen or isAnimating then
		return
	end

	isAnimating = true
	isOpen = false

	local tween = TweenService:Create(
		frame,
		TweenInfo.new(
			0.20,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.In
		),
		{
			Size = closedSize
		}
	)

	tween:Play()

	tween.Completed:Once(function()

		if not isDeleted and frame and frame.Parent then
			frame.Visible = false
		end

		if not isDeleted then
			isAnimating = false
		end

	end)

end


local function executeLoader(gameName, url)

	if isDeleted then
		return
	end

	status.Text = "● Launching " .. gameName
	status.TextColor3 = PURPLE_HOVER

	destroyGUI()

	task.defer(function()

		local success, result = pcall(function()

			local source = game:HttpGet(url)
			local func = loadstring(source)

			if type(func) ~= "function" then
				error("loadstring returned nil or invalid function")
			end

			return func()

		end)

		if not success then
			warn("[MoonHub] " .. gameName .. " loader error:", result)
		end

	end)

end


local function launchGame(placeId, gameName, url)

	if game.PlaceId ~= placeId then
		showWarning(gameName)
		return
	end

	executeLoader(gameName, url)

end


-- Buttons
leftButton.MouseButton1Click:Connect(function()

	launchGame(
		10266164381,
		"Bloodlines",
		"https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/scriptbeta.lua"
	)

end)


rightButton.MouseButton1Click:Connect(function()

	launchGame(
		142823291,
		"Murder Mystery 2",
		"https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/MurderMystery2.lua"
	)

end)


universalButton.MouseButton1Click:Connect(function()

	executeLoader(
		"Universal",
		"https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/Universal.lua"
	)

end)


-- RightShift
local function rightShiftAction(_, inputState)

	if inputState ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	if isDeleted then
		return Enum.ContextActionResult.Sink
	end

	if isOpen then
		closeGUI()
	else
		openGUI()
	end

	return Enum.ContextActionResult.Sink

end


ContextActionService:BindAction(
	"ToggleMoonHubGUI",
	rightShiftAction,
	false,
	Enum.KeyCode.RightShift
)


-- Close
closeButton.MouseButton1Click:Connect(function()
	destroyGUI()
end)


-- Dragging
local dragging = false
local dragStart
local startPosition

frame.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = frame.Position

	end

end)


frame.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end

end)


UserInputService.InputChanged:Connect(function(input)

	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end

end)
