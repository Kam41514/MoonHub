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


-- Main

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 455)
Main.Position = UDim2.new(0.5, -280, 0.5, -227)
Main.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
Main.BackgroundTransparency = 0.015
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(4, 4, 5)
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(52, 52, 57)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.35
MainStroke.Parent = Main


-- Header

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -2, 0, 44)
Header.Position = UDim2.new(0, 1, 0, 1)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 5)
HeaderCorner.Parent = Header


-- Title

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Updates & Modules"
Title.TextColor3 = Color3.fromRGB(242, 242, 245)
Title.TextSize = 17
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Parent = Header


-- Close

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 27, 0, 27)
Close.Position = UDim2.new(1, -38, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
Close.BorderSizePixel = 1
Close.BorderColor3 = Color3.fromRGB(8, 8, 10)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(170, 170, 175)
Close.TextSize = 18
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = Close

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    Close.TextColor3 = Color3.fromRGB(170, 170, 175)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)


-- Header line

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, -28, 0, 1)
HeaderLine.Position = UDim2.new(0, 14, 1, -1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header


-- Dragging

local Dragging = false
local DragStart
local StartPosition

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

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end

end)


-- Content

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -145)
Content.Position = UDim2.new(0, 15, 0, 58)
Content.BackgroundTransparency = 1
Content.Parent = Main


-- Modules panel

local ModulesPanel = Instance.new("ScrollingFrame")
ModulesPanel.Size = UDim2.new(1, 0, 1, 0)
ModulesPanel.BackgroundColor3 = Color3.fromRGB(21, 21, 24)
ModulesPanel.BackgroundTransparency = 0
ModulesPanel.BorderSizePixel = 1
ModulesPanel.BorderColor3 = Color3.fromRGB(7, 7, 8)
ModulesPanel.ScrollBarThickness = 3
ModulesPanel.ScrollBarImageColor3 = Color3.fromRGB(95, 95, 102)
ModulesPanel.ScrollBarImageTransparency = 0.15
ModulesPanel.ScrollingDirection = Enum.ScrollingDirection.Y
ModulesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
ModulesPanel.Parent = Content

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 5)
PanelCorner.Parent = ModulesPanel


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

Layout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(UpdateCanvas)


-- Status colors

local StatusColors = {

    Added = {
        Text = Color3.fromRGB(105, 220, 135),
        Accent = Color3.fromRGB(70, 170, 100)
    },

    Updated = {
        Text = Color3.fromRGB(110, 175, 255),
        Accent = Color3.fromRGB(75, 130, 205)
    },

    Fixed = {
        Text = Color3.fromRGB(255, 195, 85),
        Accent = Color3.fromRGB(195, 145, 55)
    },

    Removed = {
        Text = Color3.fromRGB(255, 105, 105),
        Accent = Color3.fromRGB(190, 65, 65)
    },

    Beta = {
        Text = Color3.fromRGB(205, 145, 255),
        Accent = Color3.fromRGB(145, 90, 195)
    }

}


-- Cards

for Index, module in ipairs(Modules) do

    local Colors = StatusColors[module.Status] or {
        Text = Color3.fromRGB(190, 190, 195),
        Accent = Color3.fromRGB(100, 100, 105)
    }


    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, 0, 0, 78)
    Card.BackgroundColor3 = Color3.fromRGB(29, 29, 33)
    Card.BorderSizePixel = 1
    Card.BorderColor3 = Color3.fromRGB(10, 10, 12)
    Card.LayoutOrder = Index
    Card.Parent = ModulesPanel


    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 4)
    CardCorner.Parent = Card


    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(58, 58, 64)
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.65
    CardStroke.Parent = Card


    -- Accent

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 2, 0, 38)
    Accent.Position = UDim2.new(0, 0, 0.5, -19)
    Accent.BackgroundColor3 = Colors.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Card


    -- Module name

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Size = UDim2.new(1, -160, 0, 25)
    ModuleName.Position = UDim2.new(0, 15, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(245, 245, 247)
    ModuleName.TextSize = 16
    ModuleName.Font = Enum.Font.Gotham
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.TextYAlignment = Enum.TextYAlignment.Center
    ModuleName.Parent = Card


    -- Status

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 115, 0, 22)
    Status.Position = UDim2.new(1, -128, 0, 9)
    Status.BackgroundTransparency = 1
    Status.Text = string.upper(module.Status)
    Status.TextColor3 = Colors.Text
    Status.TextSize = 11
    Status.Font = Enum.Font.GothamMedium
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.TextYAlignment = Enum.TextYAlignment.Center
    Status.Parent = Card


    -- Description

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -30, 0, 30)
    Description.Position = UDim2.new(0, 15, 0, 38)
    Description.BackgroundTransparency = 1
    Description.Text = module.Description
    Description.TextColor3 = Color3.fromRGB(195, 195, 200)
    Description.TextSize = 13
    Description.Font = Enum.Font.SourceSans
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card


    -- Hover

    Card.MouseEnter:Connect(function()

        TweenService:Create(
            Card,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = Color3.fromRGB(34, 34, 38)
            }
        ):Play()

    end)


    Card.MouseLeave:Connect(function()

        TweenService:Create(
            Card,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = Color3.fromRGB(29, 29, 33)
            }
        ):Play()

    end)

end

UpdateCanvas()


-- Footer line

local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, -30, 0, 1)
FooterLine.Position = UDim2.new(0, 15, 1, -66)
FooterLine.BackgroundColor3 = Color3.fromRGB(50, 50, 54)
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Main


-- Footer

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -30, 0, 22)
Footer.Position = UDim2.new(0, 15, 1, -61)
Footer.BackgroundTransparency = 1
Footer.Text = "You can get latest version by using MoonHub loader"
Footer.TextColor3 = Color3.fromRGB(185, 185, 191)
Footer.TextSize = 13
Footer.Font = Enum.Font.SourceSans
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextYAlignment = Enum.TextYAlignment.Center
Footer.Parent = Main


-- Last Update

local LastUpdate = Instance.new("TextLabel")
LastUpdate.Size = UDim2.new(1, -30, 0, 24)
LastUpdate.Position = UDim2.new(0, 15, 1, -34)
LastUpdate.BackgroundTransparency = 1

local LastUpdateValue = Modules.LastUpdate

if LastUpdateValue == nil then
    LastUpdateValue = "Unknown"
end

LastUpdate.Text = "Last Update: " .. tostring(LastUpdateValue)
LastUpdate.TextColor3 = Color3.fromRGB(145, 145, 152)
LastUpdate.TextSize = 13
LastUpdate.Font = Enum.Font.SourceSans
LastUpdate.TextXAlignment = Enum.TextXAlignment.Center
LastUpdate.TextYAlignment = Enum.TextYAlignment.Center
LastUpdate.Parent = Main


-- Open animation

local TargetSize = Main.Size
local TargetPosition = Main.Position

Main.Size = UDim2.new(0, 540, 0, 430)
Main.Position = UDim2.new(0.5, -270, 0.5, -215)
Main.BackgroundTransparency = 1

TweenService:Create(
    Main,
    TweenInfo.new(
        0.2,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    {
        Size = TargetSize,
        Position = TargetPosition,
        BackgroundTransparency = 0.015
    }
):Play()

return ScreenGui
