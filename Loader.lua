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

local PURPLE = Color3.fromRGB(75, 35, 105)
local PURPLE_HOVER = Color3.fromRGB(135, 70, 190)

local BG = Color3.fromRGB(12, 12, 14)
local BUTTON_BG = Color3.fromRGB(19, 19, 22)
local BUTTON_HOVER = Color3.fromRGB(29, 26, 34)

local TEXT = Color3.fromRGB(245, 245, 248)
local TEXT_SECONDARY = Color3.fromRGB(175, 175, 183)
local TEXT_MUTED = Color3.fromRGB(125, 125, 135)

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 420, 0, 470)
frame.Position = UDim2.new(0.5, -210, 0.5, -235)
frame.BackgroundColor3 = BG
frame.BackgroundTransparency = 0.04
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = PURPLE
frameStroke.Thickness = 0.7
frameStroke.Transparency = 0.02
frameStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 0, 27)
title.Position = UDim2.new(0, 38, 0, 18)
title.BackgroundTransparency = 1
title.Text = "MoonHub"
title.TextColor3 = TEXT
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = frame

local beta = Instance.new("TextLabel")
beta.Size = UDim2.new(0, 44, 0, 19)
beta.Position = UDim2.new(0, 145, 0, 22)
beta.BackgroundColor3 = Color3.fromRGB(35, 27, 42)
beta.BackgroundTransparency = 0.1
beta.BorderSizePixel = 0
beta.Text = "BETA"
beta.TextColor3 = Color3.fromRGB(190, 150, 225)
beta.TextSize = 9
beta.Font = Enum.Font.GothamBold
beta.TextXAlignment = Enum.TextXAlignment.Center
beta.TextYAlignment = Enum.TextYAlignment.Center
beta.Parent = frame

local betaCorner = Instance.new("UICorner")
betaCorner.CornerRadius = UDim.new(0, 6)
betaCorner.Parent = beta

local betaStroke = Instance.new("UIStroke")
betaStroke.Color = Color3.fromRGB(65, 35, 90)
betaStroke.Thickness = 0.5
betaStroke.Transparency = 0.2
betaStroke.Parent = beta

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -45, 0, 17)
closeButton.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(175, 175, 182)
closeButton.TextSize = 21
closeButton.Font = Enum.Font.Gotham
closeButton.AutoButtonColor = false
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(60, 45, 70)
closeStroke.Thickness = 0.5
closeStroke.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	TweenService:Create(
		closeButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			BackgroundColor3 = Color3.fromRGB(50, 27, 32),
			TextColor3 = Color3.fromRGB(255, 110, 120)
		}
	):Play()
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(
		closeButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			BackgroundColor3 = Color3.fromRGB(22, 22, 25),
			TextColor3 = Color3.fromRGB(175, 175, 182)
		}
	):Play()
end)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -50, 0, 1)
divider.Position = UDim2.new(0, 25, 0, 61)
divider.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -50, 0, 24)
subtitle.Position = UDim2.new(0, 25, 0, 74)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Select a supported game to continue"
subtitle.TextColor3 = TEXT_SECONDARY
subtitle.TextSize = 13
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextYAlignment = Enum.TextYAlignment.Center
subtitle.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -50, 0, 20)
status.Position = UDim2.new(0, 25, 0, 101)
status.BackgroundTransparency = 1
status.Text = "● Ready"
status.TextColor3 = Color3.fromRGB(125, 205, 150)
status.TextSize = 11
status.Font = Enum.Font.GothamMedium
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Center
status.Parent = frame

local function createButton(text, subText, y, accent)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -50, 0, 58)
	button.Position = UDim2.new(0, 25, 0, y)
	button.BackgroundColor3 = BUTTON_BG
	button.BackgroundTransparency = 0.03
	button.BorderSizePixel = 0
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 48, 55)
	stroke.Thickness = 0.5
	stroke.Transparency = 0.12
	stroke.Parent = button

	local accentLine = Instance.new("Frame")
	accentLine.Size = UDim2.new(0, 3, 0, 30)
	accentLine.Position = UDim2.new(0, 12, 0.5, -15)
	accentLine.BackgroundColor3 = accent
	accentLine.BorderSizePixel = 0
	accentLine.Parent = button

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(1, 0)
	accentCorner.Parent = accentLine

	local gameTitle = Instance.new("TextLabel")
	gameTitle.Size = UDim2.new(1, -75, 0, 22)
	gameTitle.Position = UDim2.new(0, 27, 0, 8)
	gameTitle.BackgroundTransparency = 1
	gameTitle.Text = text
	gameTitle.TextColor3 = TEXT
	gameTitle.TextSize = 14
	gameTitle.Font = Enum.Font.GothamSemibold
	gameTitle.TextXAlignment = Enum.TextXAlignment.Left
	gameTitle.TextYAlignment = Enum.TextYAlignment.Center
	gameTitle.Parent = button

	local gameSub = Instance.new("TextLabel")
	gameSub.Size = UDim2.new(1, -75, 0, 17)
	gameSub.Position = UDim2.new(0, 27, 0, 31)
	gameSub.BackgroundTransparency = 1
	gameSub.Text = subText
	gameSub.TextColor3 = TEXT_MUTED
	gameSub.TextSize = 10
	gameSub.Font = Enum.Font.Gotham
	gameSub.TextXAlignment = Enum.TextXAlignment.Left
	gameSub.TextYAlignment = Enum.TextYAlignment.Center
	gameSub.Parent = button

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 25, 0, 30)
	arrow.Position = UDim2.new(1, -40, 0.5, -15)
	arrow.BackgroundTransparency = 1
	arrow.Text = "›"
	arrow.TextColor3 = Color3.fromRGB(105, 100, 110)
	arrow.TextSize = 23
	arrow.Font = Enum.Font.Gotham
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.TextYAlignment = Enum.TextYAlignment.Center
	arrow.Parent = button

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
				Transparency = 0,
				Thickness = 0.7
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
				Color = Color3.fromRGB(50, 48, 55),
				Transparency = 0.12,
				Thickness = 0.5
			}
		):Play()

		TweenService:Create(
			arrow,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				TextColor3 = Color3.fromRGB(105, 100, 110)
			}
		):Play()
	end)

	return button
end

local leftButton = createButton(
	"Bloodlines",
	"Launch Bloodlines loader",
	140,
	Color3.fromRGB(105, 55, 155)
)

local rightButton = createButton(
	"Murder Mystery 2",
	"Launch Murder Mystery 2 loader",
	208,
	Color3.fromRGB(115, 60, 165)
)

local universalButton = createButton(
	"Universal",
	"Launch Universal loader",
	276,
	Color3.fromRGB(125, 65, 175)
)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -50, 0, 18)
footer.Position = UDim2.new(0, 25, 1, -29)
footer.BackgroundTransparency = 1
footer.Text = "MoonHub • RightShift to toggle"
footer.TextColor3 = Color3.fromRGB(95, 92, 100)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.TextYAlignment = Enum.TextYAlignment.Center
footer.Parent = frame

local function showWarning(gameName)
	local notification = Instance.new("Frame")
	notification.Name = "Warning"
	notification.Size = UDim2.new(0, 330, 0, 56)
	notification.Position = UDim2.new(0, -350, 0, 20)
	notification.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
	notification.BackgroundTransparency = 0.02
	notification.BorderSizePixel = 0
	notification.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = notification

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(80, 52, 100)
	stroke.Thickness = 0.5
	stroke.Transparency = 0.1
	stroke.Parent = notification

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, -18)
	bar.Position = UDim2.new(0, 9, 0, 9)
	bar.BackgroundColor3 = Color3.fromRGB(245, 175, 65)
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
	icon.TextColor3 = Color3.fromRGB(255, 190, 80)
	icon.TextSize = 19
	icon.Font = Enum.Font.GothamBold
	icon.Parent = notification

	local warningText = Instance.new("TextLabel")
	warningText.Size = UDim2.new(1, -65, 1, -10)
	warningText.Position = UDim2.new(0, 58, 0, 5)
	warningText.BackgroundTransparency = 1
	warningText.Text = 'You are not on "' .. gameName .. '"'
	warningText.TextColor3 = TEXT
	warningText.TextSize = 12
	warningText.Font = Enum.Font.GothamMedium
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
				TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
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

local isOpen = true
local isDeleted = false
local isAnimating = false

local normalSize = UDim2.new(0, 420, 0, 470)
local closedSize = UDim2.new(0, 420, 0, 0)

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
		TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{
			Size = normalSize
		}
	)

	tween:Play()

	tween.Completed:Once(function()
		isAnimating = false
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
		TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
		{
			Size = closedSize
		}
	)

	tween:Play()

	tween.Completed:Once(function()
		if not isDeleted and frame and frame.Parent then
			frame.Visible = false
		end

		isAnimating = false
	end)
end

local function launchGame(placeId, gameName, url)
	if game.PlaceId ~= placeId then
		showWarning(gameName)
		return
	end

	status.Text = "●  Launching " .. gameName
	status.TextColor3 = PURPLE_HOVER

	closeGUI()

	task.delay(0.22, function()
		if isDeleted then
			return
		end

		local success, result = pcall(function()
			local source = game:HttpGet(url)
			local func = loadstring(source)

			if type(func) ~= "function" then
				error("loadstring returned nil or invalid function")
			end

			return func()
		end)

		if not success then
			warn("[MoonHub] Loader error:", result)

			if gui and gui.Parent then
				status.Text = "●  Loader failed"
				status.TextColor3 = Color3.fromRGB(255, 100, 115)

				task.delay(2, function()
					if gui and gui.Parent and not isDeleted then
						status.Text = "●  Ready"
						status.TextColor3 = Color3.fromRGB(125, 205, 150)
					end
				end)
			end
		end
	end)
end

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
	if isDeleted then
		return
	end

	status.Text = "●  Launching Universal"
	status.TextColor3 = PURPLE_HOVER

	closeGUI()

	task.delay(0.22, function()
		if isDeleted then
			return
		end

		local success, result = pcall(function()
			local source = game:HttpGet(
				"https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/Universal.lua"
			)

			local func = loadstring(source)

			if type(func) ~= "function" then
				error("loadstring returned nil or invalid function")
			end

			return func()
		end)

		if not success then
			warn("[MoonHub] Universal loader error:", result)

			if gui and gui.Parent then
				status.Text = "●  Universal failed"
				status.TextColor3 = Color3.fromRGB(255, 100, 115)

				task.delay(2, function()
					if gui and gui.Parent and not isDeleted then
						status.Text = "●  Ready"
						status.TextColor3 = Color3.fromRGB(125, 205, 150)
					end
				end)
			end
		end
	end)
end)

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

closeButton.MouseButton1Click:Connect(function()
	if isDeleted then
		return
	end

	isDeleted = true
	isOpen = false
	isAnimating = false

	ContextActionService:UnbindAction("ToggleMoonHubGUI")
	gui:Destroy()
end)

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
