local Modules = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Updates/Updates.lua"
))()

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
Main.BackgroundColor3 = Color3.fromRGB(19, 19, 21)
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(2, 2, 3)
MainStroke.Thickness = 2
MainStroke.Transparency = 0
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 68)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 0, 27)
Title.Position = UDim2.new(0, 40, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "UPDATES"
Title.TextColor3 = Color3.fromRGB(245, 245, 247)
Title.TextSize = 18
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

local ModulesTitle = Instance.new("TextLabel")
ModulesTitle.Name = "ModulesTitle"
ModulesTitle.Size = UDim2.new(1, -80, 0, 18)
ModulesTitle.Position = UDim2.new(0, 40, 0, 35)
ModulesTitle.BackgroundTransparency = 1
ModulesTitle.Text = "MODULES"
ModulesTitle.TextColor3 = Color3.fromRGB(120, 120, 126)
ModulesTitle.TextSize = 10
ModulesTitle.Font = Enum.Font.Code
ModulesTitle.TextXAlignment = Enum.TextXAlignment.Center
ModulesTitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -41, 0, 18)
Close.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(170, 170, 175)
Close.TextSize = 22
Close.Font = Enum.Font.Code
Close.AutoButtonColor = false
Close.Parent = Header

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(2, 2, 3)
CloseStroke.Thickness = 1
CloseStroke.Parent = Close

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
    Close.TextColor3 = Color3.fromRGB(170, 170, 175)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(1, -20, 0, 2)
Separator.Position = UDim2.new(0, 10, 0, 68)
Separator.BackgroundColor3 = Color3.fromRGB(2, 2, 3)
Separator.BorderSizePixel = 0
Separator.Parent = Main

local UpdatesContainer = Instance.new("ScrollingFrame")
UpdatesContainer.Name = "UpdatesContainer"
UpdatesContainer.Size = UDim2.new(1, -20, 1, -84)
UpdatesContainer.Position = UDim2.new(0, 10, 0, 78)
UpdatesContainer.BackgroundColor3 = Color3.fromRGB(23, 23, 26)
UpdatesContainer.BorderSizePixel = 0
UpdatesContainer.ScrollBarThickness = 3
UpdatesContainer.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 70)
UpdatesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
UpdatesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
UpdatesContainer.Parent = Main

local ContainerStroke = Instance.new("UIStroke")
ContainerStroke.Color = Color3.fromRGB(3, 3, 4)
ContainerStroke.Thickness = 1
ContainerStroke.Parent = UpdatesContainer

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = UpdatesContainer

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = UpdatesContainer

for _, module in ipairs(Modules) do

    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, 0, 0, 76)
    Card.BackgroundColor3 = Color3.fromRGB(28, 28, 31)
    Card.BorderSizePixel = 0
    Card.Parent = UpdatesContainer

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(4, 4, 5)
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Size = UDim2.new(1, -130, 0, 24)
    ModuleName.Position = UDim2.new(0, 14, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(245, 245, 247)
    ModuleName.TextSize = 14
    ModuleName.Font = Enum.Font.Code
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 105, 0, 20)
    Status.Position = UDim2.new(1, -118, 0, 9)
    Status.BackgroundTransparency = 1
    Status.Text = "[" .. string.upper(module.Status) .. "]"
    Status.TextSize = 10
    Status.Font = Enum.Font.Code
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(100, 220, 135)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(100, 165, 255)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(240, 185, 75)
    else
        Status.TextColor3 = Color3.fromRGB(180, 180, 185)
    end

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -28, 0, 36)
    Description.Position = UDim2.new(0, 14, 0, 35)
    Description.BackgroundTransparency = 1
    Description.Text = "> " .. module.Description
    Description.TextColor3 = Color3.fromRGB(205, 205, 210)
    Description.TextSize = 11
    Description.Font = Enum.Font.Code
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card
end

return ScreenGui
