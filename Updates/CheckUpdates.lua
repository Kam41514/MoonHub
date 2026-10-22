
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

local Theme = {
    Background = Color3.fromRGB(15, 16, 19),
    Header = Color3.fromRGB(19, 20, 24),
    Panel = Color3.fromRGB(18, 19, 23),
    Card = Color3.fromRGB(24, 25, 30),
    CardHover = Color3.fromRGB(30, 31, 37),
    Border = Color3.fromRGB(47, 49, 57),
    Text = Color3.fromRGB(240, 241, 245),
    SubText = Color3.fromRGB(157, 160, 171),
    Muted = Color3.fromRGB(110, 113, 124),
    Accent = Color3.fromRGB(143, 118, 255),
    AccentSoft = Color3.fromRGB(47, 40, 75)
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateLabel(parent, properties)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Theme.Text
    label.TextSize = 13

    for property, value in pairs(properties) do
        label[property] = value
    end

    label.Parent = parent
    return label
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 440)
Main.Position = UDim2.new(0.5, -260, 0.5, -220)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

CreateCorner(Main, 9)
CreateStroke(Main, Theme.Border, 0.15, 1)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, -32, 0, 1)
HeaderDivider.Position = UDim2.new(0, 16, 1, -1)
HeaderDivider.BackgroundColor3 = Theme.Border
HeaderDivider.BackgroundTransparency = 0.2
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(0, 31, 0, 31)
Logo.Position = UDim2.new(0, 18, 0, 13)
Logo.BackgroundColor3 = Theme.AccentSoft
Logo.BorderSizePixel = 0
Logo.Parent = Header

CreateCorner(Logo, 8)

local LogoStroke = CreateStroke(Logo, Theme.Accent, 0.45, 1)

local LogoText = CreateLabel(Logo, {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "M",
    TextColor3 = Theme.Accent,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Title = CreateLabel(Header, {
    Name = "Title",
    Size = UDim2.new(0, 260, 0, 23),
    Position = UDim2.new(0, 59, 0, 10),
    Text = "MoonHub",
    TextSize = 15,
    Font = Enum.Font.GothamSemibold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Subtitle = CreateLabel(Header, {
    Size = UDim2.new(0, 260, 0, 17),
    Position = UDim2.new(0, 59, 0, 31),
    Text = "UPDATES  /  CHANGELOG",
    TextColor3 = Theme.Muted,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 29, 0, 29)
Close.Position = UDim2.new(1, -45, 0, 14)
Close.BackgroundColor3 = Theme.Card
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Theme.SubText
Close.TextSize = 20
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

CreateCorner(Close, 7)
CreateStroke(Close, Theme.Border, 0.35, 1)

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.12), {
        BackgroundColor3 = Color3.fromRGB(105, 48, 57),
        TextColor3 = Color3.fromRGB(255, 140, 150)
    }):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.12), {
        BackgroundColor3 = Theme.Card,
        TextColor3 = Theme.SubText
    }):Play()
end)

local Closing = false

Close.MouseButton1Click:Connect(function()
    if Closing then
        return
    end

    Closing = true

    TweenService:Create(Main, TweenInfo.new(
        0.15,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Size = UDim2.new(0, 500, 0, 420),
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.16)

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
Content.Size = UDim2.new(1, -32, 1, -139)
Content.Position = UDim2.new(0, 16, 0, 73)
Content.BackgroundTransparency = 1
Content.Parent = Main

local SectionHeader = Instance.new("Frame")
SectionHeader.Size = UDim2.new(1, 0, 0, 23)
SectionHeader.BackgroundTransparency = 1
SectionHeader.Parent = Content

local SectionTitle = CreateLabel(SectionHeader, {
    Size = UDim2.new(0.65, 0, 1, 0),
    Text = "Recent Changes",
    TextColor3 = Theme.Text,
    TextSize = 12,
    Font = Enum.Font.GothamSemibold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local ModuleCount = CreateLabel(SectionHeader, {
    Size = UDim2.new(0.35, 0, 1, 0),
    Position = UDim2.new(0.65, 0, 0, 0),
    Text = tostring(#Modules) .. " MODULES",
    TextColor3 = Theme.Muted,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Center
})

local ModulesPanel = Instance.new("ScrollingFrame")
ModulesPanel.Name = "ModulesPanel"
ModulesPanel.Size = UDim2.new(1, 0, 1, -31)
ModulesPanel.Position = UDim2.new(0, 0, 0, 31)
ModulesPanel.BackgroundColor3 = Theme.Panel
ModulesPanel.BorderSizePixel = 0
ModulesPanel.ScrollBarThickness = 3
ModulesPanel.ScrollBarImageColor3 = Theme.Accent
ModulesPanel.ScrollBarImageTransparency = 0.2
ModulesPanel.ScrollingDirection = Enum.ScrollingDirection.Y
ModulesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
ModulesPanel.AutomaticCanvasSize = Enum.AutomaticSize.None
ModulesPanel.Parent = Content

CreateCorner(ModulesPanel, 7)
CreateStroke(ModulesPanel, Theme.Border, 0.35, 1)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = ModulesPanel

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
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
        Text = Color3.fromRGB(113, 224, 157),
        Accent = Color3.fromRGB(78, 187, 121),
        Background = Color3.fromRGB(30, 57, 43)
    },

    Updated = {
        Text = Color3.fromRGB(130, 180, 255),
        Accent = Color3.fromRGB(87, 143, 230),
        Background = Color3.fromRGB(31, 45, 67)
    },

    Fixed = {
        Text = Color3.fromRGB(255, 205, 120),
        Accent = Color3.fromRGB(218, 162, 77),
        Background = Color3.fromRGB(61, 48, 30)
    },

    Removed = {
        Text = Color3.fromRGB(255, 133, 143),
        Accent = Color3.fromRGB(214, 91, 104),
        Background = Color3.fromRGB(61, 34, 39)
    },

    Beta = {
        Text = Color3.fromRGB(207, 166, 255),
        Accent = Color3.fromRGB(164, 115, 226),
        Background = Color3.fromRGB(49, 37, 66)
    }
}

for Index, module in ipairs(Modules) do
    local StatusName = tostring(module.Status or "Updated")
    local Colors = StatusColors[StatusName] or {
        Text = Theme.SubText,
        Accent = Theme.Muted,
        Background = Color3.fromRGB(38, 39, 45)
    }

    local Card = Instance.new("Frame")
    Card.Name = tostring(module.Name or ("Module_" .. Index))
    Card.Size = UDim2.new(1, 0, 0, 76)
    Card.BackgroundColor3 = Theme.Card
    Card.BorderSizePixel = 0
    Card.LayoutOrder = Index
    Card.Parent = ModulesPanel

    CreateCorner(Card, 6)
    local CardStroke = CreateStroke(Card, Theme.Border, 0.4, 1)

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 3, 0, 36)
    Accent.Position = UDim2.new(0, 0, 0.5, -18)
    Accent.BackgroundColor3 = Colors.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Card

    CreateCorner(Accent, 2)

    local ModuleName = CreateLabel(Card, {
        Name = "ModuleName",
        Size = UDim2.new(1, -145, 0, 23),
        Position = UDim2.new(0, 14, 0, 8),
        Text = tostring(module.Name or "Unknown"),
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local StatusBadge = Instance.new("Frame")
    StatusBadge.Name = "StatusBadge"
    StatusBadge.Size = UDim2.new(0, 100, 0, 23)
    StatusBadge.Position = UDim2.new(1, -112, 0, 8)
    StatusBadge.BackgroundColor3 = Colors.Background
    StatusBadge.BorderSizePixel = 0
    StatusBadge.Parent = Card

    CreateCorner(StatusBadge, 5)

    local StatusLabel = CreateLabel(StatusBadge, {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        Text = string.upper(StatusName),
        TextColor3 = Colors.Text,
        TextSize = 9,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local Description = CreateLabel(Card, {
        Name = "Description",
        Size = UDim2.new(1, -28, 0, 30),
        Position = UDim2.new(0, 14, 0, 36),
        Text = tostring(module.Description or ""),
        TextColor3 = Theme.SubText,
        TextSize = 12,
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
                BackgroundColor3 = Theme.CardHover
            }
        ):Play()

        TweenService:Create(
            CardStroke,
            TweenInfo.new(0.13),
            {
                Color = Colors.Accent,
                Transparency = 0.25
            }
        ):Play()
    end)

    Card.MouseLeave:Connect(function()
        TweenService:Create(
            Card,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = Theme.Card
            }
        ):Play()

        TweenService:Create(
            CardStroke,
            TweenInfo.new(0.13),
            {
                Color = Theme.Border,
                Transparency = 0.4
            }
        ):Play()
    end)
end

UpdateCanvas()

local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, -32, 0, 1)
FooterLine.Position = UDim2.new(0, 16, 1, -58)
FooterLine.BackgroundColor3 = Theme.Border
FooterLine.BackgroundTransparency = 0.2
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Main

local FooterIcon = CreateLabel(Main, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0, 18, 1, -47),
    Text = "↗",
    TextColor3 = Theme.Accent,
    TextSize = 15,
    Font = Enum.Font.GothamSemibold,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

local Footer = CreateLabel(Main, {
    Size = UDim2.new(1, -55, 0, 20),
    Position = UDim2.new(0, 41, 1, -47),
    Text = "Get the latest version using the MoonHub loader",
    TextColor3 = Theme.SubText,
    TextSize = 11,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center
})

local LastUpdateValue = Modules.LastUpdate

if LastUpdateValue == nil then
    LastUpdateValue = "Unknown"
end

local LastUpdate = CreateLabel(Main, {
    Size = UDim2.new(1, -32, 0, 17),
    Position = UDim2.new(0, 16, 1, -25),
    Text = "LAST UPDATE  ·  " .. tostring(LastUpdateValue),
    TextColor3 = Theme.Muted,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

local TargetSize = Main.Size
local TargetPosition = Main.Position

Main.Size = UDim2.new(0, 490, 0, 415)
Main.Position = UDim2.new(0.5, -245, 0.5, -207)
Main.BackgroundTransparency = 1

TweenService:Create(
    Main,
    TweenInfo.new(
        0.24,
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
