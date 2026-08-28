local Modules = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Updates/Updates.lua"))()

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UpdatesGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 400)
Main.Position = UDim2.new(0.5, -250, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 60)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Header.BackgroundTransparency = 0.05
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Updates"
Title.TextColor3 = Color3.fromRGB(235, 235, 238)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -46, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
Close.BackgroundTransparency = 0.15
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(190, 190, 195)
Close.TextSize = 26
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(65, 65, 70)
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0.2
CloseStroke.Parent = Close

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(60, 60, 64)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    Close.TextColor3 = Color3.fromRGB(190, 190, 195)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, -30, 0, 1)
Separator.Position = UDim2.new(0, 15, 0, 55)
Separator.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
Separator.BackgroundTransparency = 0.25
Separator.BorderSizePixel = 0
Separator.Parent = Main

local UpdatesContainer = Instance.new("ScrollingFrame")
UpdatesContainer.Name = "UpdatesContainer"
UpdatesContainer.Size = UDim2.new(1, -24, 1, -75)
UpdatesContainer.Position = UDim2.new(0, 12, 0, 66)
UpdatesContainer.BackgroundTransparency = 1
UpdatesContainer.BorderSizePixel = 0
UpdatesContainer.ScrollBarThickness = 3
UpdatesContainer.ScrollBarImageColor3 = Color3.fromRGB(85, 85, 90)
UpdatesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
UpdatesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
UpdatesContainer.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 4)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 3)
Padding.PaddingRight = UDim.new(0, 3)
Padding.Parent = UpdatesContainer

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = UpdatesContainer

for _, module in ipairs(Modules) do

    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, -6, 0, 78)
    Card.BackgroundColor3 = Color3.fromRGB(38, 38, 41)
    Card.BackgroundTransparency = 0.12
    Card.BorderSizePixel = 0
    Card.Parent = UpdatesContainer

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 6)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(58, 58, 63)
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.25
    CardStroke.Parent = Card

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Size = UDim2.new(1, -115, 0, 25)
    ModuleName.Position = UDim2.new(0, 12, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(235, 235, 238)
    ModuleName.TextSize = 15
    ModuleName.Font = Enum.Font.GothamBold
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 90, 0, 22)
    Status.Position = UDim2.new(1, -102, 0, 8)
    Status.BackgroundTransparency = 1
    Status.Text = module.Status
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamSemibold
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(90, 205, 130)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(90, 165, 255)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(255, 190, 80)
    else
        Status.TextColor3 = Color3.fromRGB(180, 180, 185)
    end

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -24, 0, 36)
    Description.Position = UDim2.new(0, 12, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = module.Description
    Description.TextColor3 = Color3.fromRGB(175, 175, 180)
    Description.TextSize = 12
    Description.Font = Enum.Font.Gotham
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card
end
