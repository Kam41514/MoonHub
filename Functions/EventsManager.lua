local Services = {
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Stats = game:GetService("Stats"),
    GuiService = game:GetService("GuiService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
}

local funcs = {}

local DataEvent = Services.ReplicatedStorage.Events:WaitForChild("DataEvent")
local DataFunction = Services.ReplicatedStorage.Events:WaitForChild("DataFunction")

function funcs.FireServer(prompt)
    DataEvent:FireServer(prompt)
end

function funcs.InvokeServer(prompt)
    return DataFunction:InvokeServer(prompt)
end

return funcs
