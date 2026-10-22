
local Modules = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Updates/Updates.lua"
))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local OldGui = PlayerGui:FindFirstChild("UpdatesGui")

if OldGui then
    OldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UpdatesGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local Colors = {
    Background = Color3.fromRGB(19, 19, 22),
    Header = Color3.fromRGB(15, 15, 18),
    Panel = Color3.fromRGB(22, 22, 26),
    Card = Color3.fromRGB(29, 29, 34),
    CardHover = Color3.fromRGB(37, 37, 43),
    Border = Color3.fromRGB(65, 65, 73),
    Text = Color3.fromRGB(245, 245, 248),
    Description = Color3.fromRGB(205, 205, 212),
    Muted = Color3.fromRGB(160, 160, 170),
    Accent = Color3.fromRGB(157, 130, 255)
}

local function Corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function Stroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function Label(parent, properties)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Colors.Text
    label.TextSize = 14

    for property, value in pairs(properties) do
        label[property] = value
    end

    label.Parent = parent
    return label
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 455)
Main.Position = UDim2.new(0.5, -280, 0.5, -227)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Corner(Main, 8)
Stroke(Main, Colors.Border, 0.12, 1)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Colors.Header
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Corner(Header, 8)

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = Colors.Header
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, -30, 0, 1)
HeaderLine.Position = UDim2.new(0, 15, 1, -1)
HeaderLine.BackgroundColor3 = Colors.Border
HeaderLine.BackgroundTransparency = 0.2
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0, 3, 0, 25)
AccentLine.Position = UDim2.new(0, 17, 0, 13)
AccentLine.BackgroundColor3 = Colors.Accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = Header

Corner(AccentLine, 2)

local Title = Label(Header, {
    Name = "Title",
    Size = UDim2.new(1, -110, 0, 25),
    Position = UDim2.new(0, 29, 0, 5),
    Text = "Updates & Modules",
    TextColor3 = Colors.Text,
    TextSize = 17,
    Font = Enum.Font.GothamSemibold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Subtitle = Label(Header, {
    Size = UDim2.new(1, -110, 0, 15),
    Position = UDim2.new(0, 30, 0, 29),
    Text = "MoonHub  •  Changelog",
    TextColor3 = Colors.Muted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 29, 0, 29)
Close.Position = UDim2.new(1, -43, 0, 11)
Close.BackgroundColor3 = Colors.Card
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Colors.Muted
Close.TextSize = 21
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

Corner(Close, 5)
Stroke(Close, Colors.Border, 0.25, 1)

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.12), {
        BackgroundColor3 = Color3.fromRGB(83, 39, 46),
        TextColor3 = Color3.fromRGB(255, 150, 158)
    }):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.12), {
        BackgroundColor3 = Colors.Card,
        TextColor3 = Colors.Muted
    }):Play()
end)

local Closing = false

Close.MouseButton1Click:Connect(function()
    if Closing then
        return
    end

    Closing = true

    TweenService:Create(Main, TweenInfo.new(
        0.16,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Size = UDim2.new(0, 540, 0, 435),
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.17)

    if ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end)

local Dragging = false
local DragStart
local StartPosition
local DragInput

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
        DragInput = Input
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

    if Input == DragInput
        or Input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -30, 1, -137)
Content.Position = UDim2.new(0, 15, 0, 64)
Content.BackgroundTransparency = 1
Content.Parent = Main

local SectionHeader = Instance.new("Frame")
SectionHeader.Size = UDim2.new(1, 0, 0, 26)
SectionHeader.BackgroundTransparency = 1
SectionHeader.Parent = Content

local SectionTitle = Label(SectionHeader, {
    Size = UDim2.new(0.6, 0, 1, 0),
    Text = "Recent Changes",
    TextColor3 = Colors.Text,
    TextSize = 14,
    Font = Enum.Font.GothamSemibold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local ModuleCount = Label(SectionHeader, {
    Size = UDim2.new(0.4, 0, 1, 0),
    Position = UDim2.new(0.6, 0, 0, 0),
    Text = tostring(#Modules) .. " modules",
    TextColor3 = Colors.Muted,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Center
})

local ModulesPanel = Instance.new("ScrollingFrame")
ModulesPanel.Name = "ModulesPanel"
ModulesPanel.Size = UDim2.new(1, 0, 1, -34)
ModulesPanel.Position = UDim2.new(0, 0, 0, 34)
ModulesPanel.BackgroundColor3 = Colors.Panel
ModulesPanel.BorderSizePixel = 0
ModulesPanel.ScrollBarThickness = 4
ModulesPanel.ScrollBarImageColor3 = Colors.Accent
ModulesPanel.ScrollBarImageTransparency = 0.15
ModulesPanel.ScrollingDirection = Enum.ScrollingDirection.Y
ModulesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
ModulesPanel.Parent = Content

Corner(ModulesPanel, 6)
Stroke(ModulesPanel, Colors.Border, 0.25, 1)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = ModulesPanel

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ModulesPanel

local function UpdateCanvas()
    ModulesPanel.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 20
    )
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

local StatusColors = {
    Added = {
        Text = Color3.fromRGB(126, 230, 157),
        Accent = Color3.fromRGB(77, 184, 111),
        Background = Color3.fromRGB(37, 65, 46)
    },

    Updated = {
        Text = Color3.fromRGB(137, 190, 255),
        Accent = Color3.fromRGB(83, 140, 222),
        Background = Color3.fromRGB(37, 53, 76)
    },

    Fixed = {
        Text = Color3.fromRGB(255, 207, 125),
        Accent = Color3.fromRGB(210, 158, 76),
        Background = Color3.fromRGB(68, 53, 34)
    },

    Removed = {
        Text = Color3.fromRGB(255, 139, 145),
        Accent = Color3.fromRGB(205, 82, 91),
        Background = Color3.fromRGB(68, 38, 42)
    },

    Beta = {
        Text = Color3.fromRGB(216, 171, 255),
        Accent = Color3.fromRGB(157, 108, 210),
        Background = Color3.fromRGB(57, 41, 73)
    }
}

for Index, module in ipairs(Modules) do
    local StatusName = tostring(module.Status or "Updated")

    local Status = StatusColors[StatusName] or {
        Text = Colors.Description,
        Accent = Colors.Muted,
        Background = Color3.fromRGB(43, 43, 49)
    }

    local Card = Instance.new("Frame")
    Card.Name = tostring(module.Name or ("Module_" .. Index))
    Card.Size = UDim2.new(1, 0, 0, 78)
    Card.BackgroundColor3 = Colors.Card
    Card.BorderSizePixel = 0
    Card.LayoutOrder = Index
    Card.Parent = ModulesPanel

    Corner(Card, 5)

    local CardStroke = Stroke(Card, Colors.Border, 0.25, 1)

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 3, 0, 42)
    Accent.Position = UDim2.new(0, 0, 0.5, -21)
    Accent.BackgroundColor3 = Status.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Card

    Corner(Accent, 2)

    local ModuleName = Label(Card, {
        Name = "ModuleName",
        Size = UDim2.new(1, -155, 0, 25),
        Position = UDim2.new(0, 15, 0, 7),
        Text = tostring(module.Name or "Unknown"),
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local StatusBadge = Instance.new("Frame")
    StatusBadge.Name = "StatusBadge"
    StatusBadge.Size = UDim2.new(0, 108, 0, 23)
    StatusBadge.Position = UDim2.new(1, -120, 0, 8)
    StatusBadge.BackgroundColor3 = Status.Background
    StatusBadge.BorderSizePixel = 0
    StatusBadge.Parent = Card

    Corner(StatusBadge, 4)

    local StatusLabel = Label(StatusBadge, {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        Text = string.upper(StatusName),
        TextColor3 = Status.Text,
        TextSize = 10,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local Description = Label(Card, {
        Name = "Description",
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.new(0, 15, 0, 38),
        Text = tostring(module.Description or ""),
        TextColor3 = Colors.Description,
        TextSize = 13,
        Font = Enum.Font.SourceSans,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    Card.MouseEnter:Connect(function()
        TweenService:Create(
            Card,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = Colors.CardHover
            }
        ):Play()

        TweenService:Create(
            CardStroke,
            TweenInfo.new(0.13),
            {
                Color = Status.Accent,
                Transparency = 0.15
            }
        ):Play()
    end)

    Card.MouseLeave:Connect(function()
        TweenService:Create(
            Card,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = Colors.Card
            }
        ):Play()

        TweenService:Create(
            CardStroke,
            TweenInfo.new(0.13),
            {
                Color = Colors.Border,
                Transparency = 0.25
            }
        ):Play()
    end)
end

UpdateCanvas()

local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, -30, 0, 1)
FooterLine.Position = UDim2.new(0, 15, 1, -59)
FooterLine.BackgroundColor3 = Colors.Border
FooterLine.BackgroundTransparency = 0.2
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Main

local Footer = Label(Main, {
    Size = UDim2.new(1, -30, 0, 22),
    Position = UDim2.new(0, 15, 1, -50),
    Text = "You can get the latest version using the MoonHub loader",
    TextColor3 = Colors.Description,
    TextSize = 12,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

local LastUpdateValue = Modules.LastUpdate

if LastUpdateValue == nil then
    LastUpdateValue = "Unknown"
end

local LastUpdate = Label(Main, {
    Size = UDim2.new(1, -30, 0, 18),
    Position = UDim2.new(0, 15, 1, -26),
    Text = "Last Update: " .. tostring(LastUpdateValue),
    TextColor3 = Colors.Muted,
    TextSize = 11,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

local TargetSize = Main.Size
local TargetPosition = Main.Position

Main.Size = UDim2.new(0, 540, 0, 435)
Main.Position = UDim2.new(0.5, -270, 0.5, -217)
Main.BackgroundTransparency = 1

TweenService:Create(
    Main,
    TweenInfo.new(
        0.22,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    {
        Size = TargetSize,
        Position = TargetPosition,
        BackgroundTransparency = 0
    }
):Play()

return ScreenGui
