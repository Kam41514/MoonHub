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

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.fromScale(1, 1)
Background.Position = UDim2.fromScale(0, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0
Background.BorderSizePixel = 0
Background.ZIndex = 1
Background.Parent = ScreenGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 420)
Main.Position = UDim2.new(0.5, -260, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Main.BorderColor3 = Color3.fromRGB(3, 3, 4)
Main.BorderSizePixel = 2
Main.ZIndex = 2
Main.Parent = ScreenGui

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, -4, 0, 66)
Header.Position = UDim2.new(0, 2, 0, 2)
Header.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
Header.BorderColor3 = Color3.fromRGB(4, 4, 5)
Header.BorderSizePixel = 1
Header.ZIndex = 3
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -90, 0, 30)
Title.Position = UDim2.new(0, 45, 0, 9)
Title.BackgroundTransparency = 1
Title.Text = "Updates & Modules"
Title.TextColor3 = Color3.fromRGB(245, 245, 247)
Title.TextSize = 19
Title.Font = Enum.Font.GothamSemibold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 4
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(1, -90, 0, 18)
SubTitle.Position = UDim2.new(0, 45, 0, 38)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Latest changes and improvements"
SubTitle.TextColor3 = Color3.fromRGB(125, 125, 132)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Code
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4
SubTitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -42, 0, 17)
Close.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Close.BorderColor3 = Color3.fromRGB(3, 3, 4)
Close.BorderSizePixel = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(165, 165, 170)
Close.TextSize = 22
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = Header

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Close.TextColor3 = Color3.fromRGB(165, 165, 170)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(1, -20, 0, 1)
Separator.Position = UDim2.new(0, 10, 0, 67)
Separator.BackgroundColor3 = Color3.fromRGB(3, 3, 4)
Separator.BorderSizePixel = 0
Separator.ZIndex = 4
Separator.Parent = Main

local Container = Instance.new("ScrollingFrame")
Container.Name = "Modules"
Container.Size = UDim2.new(1, -24, 1, -135)
Container.Position = UDim2.new(0, 12, 0, 78)
Container.BackgroundColor3 = Color3.fromRGB(23, 23, 25)
Container.BorderColor3 = Color3.fromRGB(4, 4, 5)
Container.BorderSizePixel = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 80)
Container.ScrollBarImageTransparency = 0.1
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollingDirection = Enum.ScrollingDirection.Y
Container.ZIndex = 3
Container.Parent = Main

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
    Card.Size = UDim2.new(1, 0, 0, 78)
    Card.BackgroundColor3 = Color3.fromRGB(29, 29, 32)
    Card.BorderColor3 = Color3.fromRGB(5, 5, 6)
    Card.BorderSizePixel = 1
    Card.ZIndex = 4
    Card.LayoutOrder = Index
    Card.Parent = Container

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Name = "ModuleName"
    ModuleName.Size = UDim2.new(1, -145, 0, 27)
    ModuleName.Position = UDim2.new(0, 14, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(245, 245, 247)
    ModuleName.TextSize = 15
    ModuleName.Font = Enum.Font.GothamSemibold
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.ZIndex = 5
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(0, 115, 0, 22)
    Status.Position = UDim2.new(1, -128, 0, 10)
    Status.BackgroundTransparency = 1
    Status.Text = "[" .. string.upper(module.Status) .. "]"
    Status.TextSize = 11
    Status.Font = Enum.Font.Code
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.ZIndex = 5
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(100, 220, 135)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(105, 170, 255)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(240, 185, 75)
    else
        Status.TextColor3 = Color3.fromRGB(185, 185, 190)
    end

    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, -28, 0, 36)
    Description.Position = UDim2.new(0, 14, 0, 37)
    Description.BackgroundTransparency = 1
    Description.Text = "> " .. module.Description
    Description.TextColor3 = Color3.fromRGB(205, 205, 210)
    Description.TextSize = 12
    Description.Font = Enum.Font.Code
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.ZIndex = 5
    Description.Parent = Card
end

local FooterLine = Instance.new("Frame")
FooterLine.Name = "FooterLine"
FooterLine.Size = UDim2.new(1, -24, 0, 1)
FooterLine.Position = UDim2.new(0, 12, 1, -48)
FooterLine.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
FooterLine.BorderSizePixel = 0
FooterLine.ZIndex = 4
FooterLine.Parent = Main

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, -30, 0, 30)
Footer.Position = UDim2.new(0, 15, 1, -40)
Footer.BackgroundTransparency = 1
Footer.Text = "You can get latest version by using MoonHub loader"
Footer.TextColor3 = Color3.fromRGB(155, 155, 160)
Footer.TextSize = 11
Footer.Font = Enum.Font.Code
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextYAlignment = Enum.TextYAlignment.Center
Footer.ZIndex = 4
Footer.Parent = Main

return ScreenGui
