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
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 400)
Main.Position = UDim2.new(0.5, -250, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Main.BorderColor3 = Color3.fromRGB(2, 2, 3)
Main.BorderSizePixel = 2
Main.Parent = ScreenGui

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, -4, 0, 65)
Header.Position = UDim2.new(0, 2, 0, 2)
Header.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
Header.BorderColor3 = Color3.fromRGB(4, 4, 5)
Header.BorderSizePixel = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 0, 28)
Title.Position = UDim2.new(0, 40, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Updates & Modules"
Title.TextColor3 = Color3.fromRGB(245, 245, 247)
Title.TextSize = 18
Title.Font = Enum.Font.GothamSemibold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(0, 70, 0, 2)
TitleLine.Position = UDim2.new(0.5, -35, 1, -14)
TitleLine.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -39, 0, 17)
Close.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Close.BorderColor3 = Color3.fromRGB(3, 3, 4)
Close.BorderSizePixel = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(155, 155, 160)
Close.TextSize = 20
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Close.TextColor3 = Color3.fromRGB(155, 155, 160)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Container = Instance.new("ScrollingFrame")
Container.Name = "Modules"
Container.Size = UDim2.new(1, -24, 1, -125)
Container.Position = UDim2.new(0, 12, 0, 77)
Container.BackgroundColor3 = Color3.fromRGB(21, 21, 24)
Container.BorderColor3 = Color3.fromRGB(4, 4, 5)
Container.BorderSizePixel = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
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

for _, module in ipairs(Modules) do

    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, 0, 0, 72)
    Card.BackgroundColor3 = Color3.fromRGB(27, 27, 30)
    Card.BorderColor3 = Color3.fromRGB(5, 5, 6)
    Card.BorderSizePixel = 1
    Card.Parent = Container

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Size = UDim2.new(1, -130, 0, 24)
    ModuleName.Position = UDim2.new(0, 12, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(245, 245, 247)
    ModuleName.TextSize = 14
    ModuleName.Font = Enum.Font.GothamSemibold
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 105, 0, 20)
    Status.Position = UDim2.new(1, -117, 0, 9)
    Status.BackgroundTransparency = 1
    Status.Text = string.upper(module.Status)
    Status.TextSize = 10
    Status.Font = Enum.Font.GothamBold
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(90, 205, 125)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(100, 160, 245)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(225, 175, 70)
    else
        Status.TextColor3 = Color3.fromRGB(170, 170, 175)
    end

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -24, 0, 30)
    Description.Position = UDim2.new(0, 12, 0, 35)
    Description.BackgroundTransparency = 1
    Description.Text = module.Description
    Description.TextColor3 = Color3.fromRGB(190, 190, 195)
    Description.TextSize = 11
    Description.Font = Enum.Font.Gotham
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card
end

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, -30, 0, 35)
Footer.Position = UDim2.new(0, 15, 1, -48)
Footer.BackgroundTransparency = 1
Footer.Text = "You can get latest version by using MoonHub loader"
Footer.TextColor3 = Color3.fromRGB(125, 125, 132)
Footer.TextSize = 11
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextYAlignment = Enum.TextYAlignment.Center
Footer.Parent = Main

return ScreenGui
