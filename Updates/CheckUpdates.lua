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
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Main.BackgroundTransparency = 0.06
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 7)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(3, 3, 4)
MainStroke.Thickness = 2
MainStroke.Transparency = 0
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
Header.BackgroundTransparency = 0.02
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 7)
HeaderCorner.Parent = Header

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Size = UDim2.new(1, 0, 0, 8)
HeaderBottom.Position = UDim2.new(0, 0, 1, -8)
HeaderBottom.BackgroundColor3 = Color3.fromRGB(17, 17, 19)
HeaderBottom.BorderSizePixel = 0
HeaderBottom.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 0, 27)
Title.Position = UDim2.new(0, 17, 0, 7)
Title.BackgroundTransparency = 1
Title.Text = "Updates"
Title.TextColor3 = Color3.fromRGB(238, 238, 241)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -80, 0, 18)
Subtitle.Position = UDim2.new(0, 18, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Latest changes and improvements"
Subtitle.TextColor3 = Color3.fromRGB(105, 105, 112)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -44, 0, 11)
Close.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Close.BackgroundTransparency = 0
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(125, 125, 132)
Close.TextSize = 23
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(5, 5, 6)
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0
CloseStroke.Parent = Close

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(38, 38, 41)
    Close.TextColor3 = Color3.fromRGB(240, 240, 243)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Close.TextColor3 = Color3.fromRGB(125, 125, 132)
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(1, -24, 0, 1)
Separator.Position = UDim2.new(0, 12, 0, 58)
Separator.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
Separator.BackgroundTransparency = 0
Separator.BorderSizePixel = 0
Separator.Parent = Main

local UpdatesContainer = Instance.new("ScrollingFrame")
UpdatesContainer.Name = "UpdatesContainer"
UpdatesContainer.Size = UDim2.new(1, -22, 1, -72)
UpdatesContainer.Position = UDim2.new(0, 11, 0, 66)
UpdatesContainer.BackgroundTransparency = 1
UpdatesContainer.BorderSizePixel = 0
UpdatesContainer.ScrollBarThickness = 3
UpdatesContainer.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 60)
UpdatesContainer.ScrollBarImageTransparency = 0.15
UpdatesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
UpdatesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
UpdatesContainer.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 3)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 2)
Padding.PaddingRight = UDim.new(0, 2)
Padding.Parent = UpdatesContainer

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = UpdatesContainer

for _, module in ipairs(Modules) do

    local Card = Instance.new("Frame")
    Card.Name = module.Name
    Card.Size = UDim2.new(1, -4, 0, 76)
    Card.BackgroundColor3 = Color3.fromRGB(27, 27, 30)
    Card.BackgroundTransparency = 0.08
    Card.BorderSizePixel = 0
    Card.Parent = UpdatesContainer

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 5)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(7, 7, 8)
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0
    CardStroke.Parent = Card

    local ModuleName = Instance.new("TextLabel")
    ModuleName.Size = UDim2.new(1, -115, 0, 24)
    ModuleName.Position = UDim2.new(0, 13, 0, 8)
    ModuleName.BackgroundTransparency = 1
    ModuleName.Text = module.Name
    ModuleName.TextColor3 = Color3.fromRGB(235, 235, 238)
    ModuleName.TextSize = 14
    ModuleName.Font = Enum.Font.GothamSemibold
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 90, 0, 20)
    Status.Position = UDim2.new(1, -103, 0, 9)
    Status.BackgroundTransparency = 1
    Status.Text = string.upper(module.Status)
    Status.TextSize = 9
    Status.Font = Enum.Font.GothamBold
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Card

    if module.Status == "Added" then
        Status.TextColor3 = Color3.fromRGB(70, 185, 105)
    elseif module.Status == "Updated" then
        Status.TextColor3 = Color3.fromRGB(75, 135, 225)
    elseif module.Status == "Fixed" then
        Status.TextColor3 = Color3.fromRGB(215, 160, 55)
    else
        Status.TextColor3 = Color3.fromRGB(125, 125, 132)
    end

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -26, 0, 34)
    Description.Position = UDim2.new(0, 13, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = module.Description
    Description.TextColor3 = Color3.fromRGB(145, 145, 152)
    Description.TextSize = 11
    Description.Font = Enum.Font.Gotham
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = Card
end

return ScreenGui
