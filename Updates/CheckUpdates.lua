local Modules = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Updates/Updates.lua"
))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local OldGui = PlayerGui:FindFirstChild("UpdatesGui")
if OldGui then
    OldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UpdatesGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 420)
Main.Position = UDim2.new(0.5, -260, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(3, 3, 4)
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 4)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 49)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.35
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, -2, 0, 70)
Header.Position = UDim2.new(0, 1, 0, 1)
Header.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 4)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 0, 30)
Title.Position = UDim2.new(0, 40, 0, 9)
Title.BackgroundTransparency = 1
Title.Text = "Updates & Modules"
Title.TextColor3 = Color3.fromRGB(238, 238, 240)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSans
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -80, 0, 20)
Subtitle.Position = UDim2.new(0, 40, 0, 39)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Latest changes and improvements"
Subtitle.TextColor3 = Color3.fromRGB(125, 125, 130)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.SourceSans
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 20)
Close.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Close.BorderSizePixel = 1
Close.BorderColor3 = Color3.fromRGB(5, 5, 6)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(145, 145, 150)
Close.TextSize = 21
Close.Font = Enum.Font.SourceSans
Close.AutoButtonColor = false
Close.Parent = Header

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    Close.TextColor3 = Color3.fromRGB(240, 240, 242)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Close.TextColor3 = Color3.fromRGB(145, 145, 150)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(1, -24, 0, 1)
Separator.Position = UDim2.new(0, 12, 0, 71)
Separator.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
Separator.BorderSizePixel = 0
Separator.Parent = Main

local Container = Instance.new("ScrollingFrame")
Container.Name = "Modules"
Container.Size = UDim2.new(1, -28, 1, -132)
Container.Position = UDim2.new(0, 14, 0, 82)
Container.BackgroundColor3 = Color3.fromRGB(23, 23, 25)
Container.BorderSizePixel = 1
Container.BorderColor3 = Color3.fromRGB(5, 5, 6)
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(85, 85, 90)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollingDirection = Enum.ScrollingDirection.Y
Container.Parent = Main

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 3)
ContainerCorner.Parent = Container

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = Container

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

for Index, module in ipairs(Modules) do

    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, 0, 0, 82)
    Card.BackgroundColor3 = Color3.fromRGB(29, 29, 32)
    Card.BorderSizePixel = 1
    Card.BorderColor3 = Color3.fromRGB(7, 7, 8)
    Card.LayoutOrder = Index
    Card.Parent = Container

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 3)
    CardCorner.Parent = Card

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Name = "ModuleName"
    ModuleName.Size = UDim2.new(1, -145, 0, 28)
    ModuleName.Position = UDim2.new(0, 14, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(235, 235, 238)
    ModuleName.TextSize = 16
    ModuleName.Font = Enum.Font.SourceSans
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(0, 115, 0, 22)
    Status.Position = UDim2.new(1, -128, 0, 11)
    Status.BackgroundTransparency = 1
    Status.Text = module.Status
    Status.TextSize = 12
    Status.Font = Enum.Font.SourceSans
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(100, 205, 135)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(105, 165, 235)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(225, 175, 80)
    else
        Status.TextColor3 = Color3.fromRGB(165, 165, 170)
    end

    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, -28, 0, 38)
    Description.Position = UDim2.new(0, 14, 0, 39)
    Description.BackgroundTransparency = 1
    Description.Text = module.Description
    Description.TextColor3 = Color3.fromRGB(190, 190, 195)
    Description.TextSize = 13
    Description.Font = Enum.Font.SourceSans
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card
end

local FooterLine = Instance.new("Frame")
FooterLine.Name = "FooterLine"
FooterLine.Size = UDim2.new(1, -28, 0, 1)
FooterLine.Position = UDim2.new(0, 14, 1, -48)
FooterLine.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Main

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, -30, 0, 30)
Footer.Position = UDim2.new(0, 15, 1, -40)
Footer.BackgroundTransparency = 1
Footer.Text = "You can get latest version by using MoonHub loader"
Footer.TextColor3 = Color3.fromRGB(140, 140, 145)
Footer.TextSize = 12
Footer.Font = Enum.Font.SourceSans
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextYAlignment = Enum.TextYAlignment.Center
Footer.Parent = Main

return ScreenGui
