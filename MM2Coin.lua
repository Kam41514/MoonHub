local repo = "https://raw.githubusercontent.com/Kam41514/Library/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()
local PathManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/Library/main/PathManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Services
local Services = {
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    TweenService = game:GetService("TweenService"),
}

Services.LocalPlayer = Services.Players.LocalPlayer
Services.PlayerScripts = Services.LocalPlayer:WaitForChild("PlayerScripts")
Services.PlayerModule = require(Services.PlayerScripts:WaitForChild("PlayerModule"))
Services.ControlModule = Services.PlayerModule:GetControls()

local Window = Library:CreateWindow({
    Title = "MoonHub | Beta",
    Footer = "Version: 1.0",
    NotifySide = "Left",
    Icon = 7743870134,
    ShowCustomCursor = true,
    Center = true,
})

local Tabs = {
    Combat = Window:AddTab("Combat", "hand-fist"),
    Player = Window:AddTab("Player", "user"),
    Visual = Window:AddTab("Visual", "eye"),
    Misc = Window:AddTab("Misc", "sparkles"),
    Exploits = Window:AddTab("Exploits", "terminal"),
    -- Automation = Window:AddTab("Automation", "play"),
    Botting = Window:AddTab("Botting", "bot"),
    Pathing = Window:AddTab("Pathing", "route"),
    -- Notifications = Window:AddTab("Notifications", "bell"),
    LibraryTab = Window:AddTab("Library", "monitor"),
    Config = Window:AddTab("Config", "settings"),
}

local Groupboxes = {}
local State = {} 
local funcs = {}
local MainConnections = {}

-- Connection Manager

function funcs.Connect(name, signal, callback)

    if MainConnections[name] then
        MainConnections[name]:Disconnect()
    end

    MainConnections[name] = signal:Connect(callback)

    return MainConnections[name]

end


function funcs.Disconnect(name)

    if MainConnections[name] then
        MainConnections[name]:Disconnect()
        MainConnections[name] = nil
    end

end


function funcs.DisconnectPrefix(prefix)

    for name in pairs(MainConnections) do

        if string.sub(name, 1, #prefix) == prefix then
            funcs.Disconnect(name)
        end

    end

end


function funcs.DisconnectAll()

    for name, connection in pairs(MainConnections) do

        if connection then
            connection:Disconnect()
        end

    end

    table.clear(MainConnections)

end


-- Combat

-- Player
Groupboxes.PlayerAirMovement = Tabs.Player:AddLeftGroupbox("Flight", "wind")
Groupboxes.PlayerGroundMovement = Tabs.Player:AddRightGroupbox("Speed", "wind")
Groupboxes.LocalPlayerScripts = Tabs.Player:AddLeftGroupbox("Local Player", "user")
Groupboxes.ExtraScripts = Tabs.Player:AddLeftGroupbox("Extras", "user")

State.AntiAFKEnabled = false

function funcs.StartAntiAFK()
    State.AntiAFKEnabled = true

    funcs.Connect(
        "AntiAFK_Idled",
        Services.Players.LocalPlayer.Idled,
        function()
            if not State.AntiAFKEnabled then
                return
            end

            local VirtualUser =
                game:GetService("VirtualUser")

            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(
                Vector2.new()
            )
        end
    )
end

function funcs.StopAntiAFK()
    State.AntiAFKEnabled = false

    funcs.Disconnect("AntiAFK_Idled")
end

Groupboxes.ExtraScripts:AddToggle(
    "AntiAFK",
    {
        Text = "Anti AFK",
        Default = false,

        Callback = function(Value)
            State.AntiAFKEnabled = Value

            if Value then
                funcs.StartAntiAFK()
            else
                funcs.StopAntiAFK()
            end
        end
    }
)

State.FlySpeed = 125
State.FlyEnabled = false
State.FlyBodyVelocity = nil
State.CurrentFlyKey = nil

function funcs.flyHack(state)

    State.FlyEnabled = state

    funcs.Disconnect("Fly_Stepped")

    if not state then

        if State.FlyBodyVelocity then
            State.FlyBodyVelocity:Destroy()
            State.FlyBodyVelocity = nil
        end

        return
    end

    local character =
        Services.LocalPlayer.Character

    if not character then
        return
    end

    local rootPart =
        character:FindFirstChild("HumanoidRootPart")

    if not rootPart then
        return
    end

    if State.FlyBodyVelocity then
        State.FlyBodyVelocity:Destroy()
    end

    State.FlyBodyVelocity =
        Instance.new("BodyVelocity")

    State.FlyBodyVelocity.Name =
        "BloodlinesFlyVelocity"

    State.FlyBodyVelocity.MaxForce =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    State.FlyBodyVelocity.Parent =
        rootPart


    funcs.Connect(
        "Fly_Stepped",
        Services.RunService.Stepped,
        function()

            if not State.FlyEnabled then
                return
            end

            local camera =
                Services.Workspace.CurrentCamera

            if not camera then
                return
            end

            local currentCharacter =
                Services.LocalPlayer.Character

            if not currentCharacter then
                return
            end

            local currentRoot =
                currentCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not currentRoot then
                return
            end


            if not State.FlyBodyVelocity
                or State.FlyBodyVelocity.Parent ~= currentRoot
            then

                if State.FlyBodyVelocity then
                    State.FlyBodyVelocity:Destroy()
                end

                State.FlyBodyVelocity =
                    Instance.new("BodyVelocity")

                State.FlyBodyVelocity.Name =
                    "BloodlinesFlyVelocity"

                State.FlyBodyVelocity.MaxForce =
                    Vector3.new(
                        math.huge,
                        math.huge,
                        math.huge
                    )

                State.FlyBodyVelocity.Parent =
                    currentRoot

            end


            local moveVector =
                Services.ControlModule:GetMoveVector()

            if not moveVector then
                return
            end


            local cameraMoveVector =
                camera.CFrame:VectorToWorldSpace(
                    moveVector
                )

            local speed =
                tonumber(State.FlySpeed) or 50


            State.FlyBodyVelocity.Velocity =
                cameraMoveVector * speed

        end
    )

end


State.NoclipEnabled = false
State.CurrentNoclipKey = nil
State.NoclipOriginalCollision = {}

function funcs.RestoreNoclipCollision()

    for part, originalValue in pairs(State.NoclipOriginalCollision) do

        if part and part.Parent then
            part.CanCollide = originalValue
        end

    end

    table.clear(State.NoclipOriginalCollision)

end


function funcs.noClip(state)

    State.NoclipEnabled = state

    if not state then

        funcs.Disconnect("NoClip_Stepped")
        funcs.RestoreNoclipCollision()

        return
    end


    funcs.Disconnect("NoClip_Stepped")

    local character = Services.LocalPlayer.Character

    if not character then
        return
    end


    for _, part in ipairs(character:GetDescendants()) do

        if part:IsA("BasePart") then

            if State.NoclipOriginalCollision[part] == nil then
                State.NoclipOriginalCollision[part] =
                    part.CanCollide
            end

            part.CanCollide = false

        end

    end


    funcs.Connect(
        "NoClip_Stepped",
        Services.RunService.Stepped,
        function()

            if not State.NoclipEnabled then
                return
            end

            local currentCharacter =
                Services.LocalPlayer.Character

            if not currentCharacter then
                return
            end


            for _, part in ipairs(
                currentCharacter:GetDescendants()
            ) do

                if part:IsA("BasePart") then

                    if State.NoclipOriginalCollision[part] == nil then
                        State.NoclipOriginalCollision[part] =
                            part.CanCollide
                    end

                    part.CanCollide = false

                end

            end

        end
    )

end


Toggles.FlyToggle = Groupboxes.PlayerAirMovement:AddToggle(
    "FlyToggle",
    {
        Text = "Flight",
        Default = false
    }
)

Toggles.FlyToggle:AddKeyPicker(
    "FlyKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentFlyKey = key
        end
    }
)

Toggles.NoclipToggle = Groupboxes.PlayerAirMovement:AddToggle(
    "NoclipToggle",
    {
        Text = "Noclip",
        Default = false
    }
)

Toggles.NoclipToggle:AddKeyPicker(
    "NoclipKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentNoclipKey = key
        end
    }
)

State.SpeedEnabled = false
State.SpeedValue = 100
State.DefaultSpeed = 16
State.CurrentSpeedToggleKey = nil

function funcs.ChangePlayerSpeed()

    if not State.SpeedEnabled then
        return
    end

    local character =
        Services.LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if humanoid.Health <= 0 then
        return
    end

    humanoid.WalkSpeed =
        tonumber(State.SpeedValue) or 16

end





Toggles.SpeedToggle = Groupboxes.PlayerGroundMovement:AddToggle(
    "SpeedToggle",
    {
        Text = "Speed",
        Default = false
    }
)

Toggles.SpeedToggle:AddKeyPicker(
    "SpeedToggleKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentSpeedToggleKey = key
        end
    }
)

Toggles.FlyToggle:OnChanged(function(Value)

    State.FlyEnabled = Value

    funcs.flyHack(Value)

end)



Toggles.NoclipToggle:OnChanged(function(Value)

    State.NoclipEnabled = Value

    funcs.noClip(Value)

end)

Groupboxes.PlayerAirMovement:AddSlider(
    "FlySpeed",
    {
        Text = "Fly Speed",
        Default = 125,
        Min = 10,
        Max = 750,
        Rounding = 0,
    }
):OnChanged(function(Value)

    State.FlySpeed = Value

end)


Toggles.SpeedToggle:OnChanged(function(Value)

    State.SpeedEnabled = Value

    if Value then
        funcs.ChangePlayerSpeed()
    else

        local character =
            Services.LocalPlayer.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed =
                State.DefaultSpeed
        end

    end

end)


Groupboxes.PlayerGroundMovement:AddSlider(
    "SpeedSlider",
    {
        Text = "Speed Value",
        Default = 100,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Compact = false
    }
):OnChanged(function(Value)

    State.SpeedValue = Value

    if not State.SpeedEnabled then
        return
    end

    local character =
        Services.LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = Value
    end

end)

Groupboxes.LocalPlayerScripts:AddButton({
    Text = "Reset Character",

    Func = function()

        local character =
            Services.LocalPlayer.Character

        if character then
            character:BreakJoints()
        end

    end
})

-- Movement Listener
funcs.Connect(
    "Movement_CharacterAdded",
    Services.LocalPlayer.CharacterAdded,
    function(NewCharacter)

        local humanoid =
            NewCharacter:WaitForChild(
                "Humanoid",
                10
            )

        if not humanoid then
            return
        end


        task.wait()


        -- Speed
        if State.SpeedEnabled then
            humanoid.WalkSpeed =
                State.SpeedValue
        else
            humanoid.WalkSpeed =
                State.DefaultSpeed
        end


        -- Fly
        if State.FlyEnabled then
            funcs.flyHack(true)
        end


        -- Noclip
        if State.NoclipEnabled then
            funcs.noClip(true)
        end

    end
)


-- Visual
Groupboxes.BaseVisualESP = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")
State.PlayerESPObjects = {}
State.PlayerESPEnabled = false
State.PlayerESPDistance = 2000
State.MurdererESPEnabled = false
State.MurdererESPConnection = nil
State.MurdererESPCharacterConnections = {}
State.lastKnifePlayer = nil

State.MurdererLastKnifeSeen = 0
State.MurdererKnifeTimeout = 20
State.SheriffESPEnabled = false
State.SheriffESPConnection = nil
State.SheriffESPCharacterConnections = {}
State.lastSheriffPlayer = nil

State.SheriffLastGunSeen = 0
State.SheriffGunTimeout = 20


function funcs.hasGun(player)

    local backpack =
        player:FindFirstChildOfClass("Backpack")

    local character =
        player.Character

    if backpack
        and backpack:FindFirstChild("Gun")
    then
        return true
    end

    if character
        and character:FindFirstChild("Gun")
    then
        return true
    end

    return false

end


function funcs.addSheriffLabel(player)

    if not State.SheriffESPEnabled then
        return
    end

    if not player
        or player == Services.LocalPlayer
    then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    if head:FindFirstChild("SheriffPlayerLabel") then
        return
    end


    local billboard =
        Instance.new("BillboardGui")

    billboard.Name =
        "SheriffPlayerLabel"

    billboard.Adornee =
        head

    billboard.Size =
        UDim2.fromOffset(160, 50)

    billboard.StudsOffset =
        Vector3.new(0, 5, 0)

    billboard.AlwaysOnTop =
        true

    billboard.MaxDistance =
        1000

    billboard.Parent =
        head


    local text =
        Instance.new("TextLabel")

    text.Name =
        "PlayerText"

    text.Size =
        UDim2.fromScale(1, 1)

    text.BackgroundTransparency =
        1

    text.Text =
        "Sheriff"

    text.TextColor3 =
        Color3.fromRGB(50, 150, 255)

    text.TextSize =
        26

    text.Font =
        Enum.Font.GothamBold

    text.TextStrokeColor3 =
        Color3.fromRGB(0, 30, 80)

    text.TextStrokeTransparency =
        0.15

    text.Parent =
        billboard

end


function funcs.removeSheriffLabel(player)

    if not player then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    local label =
        head:FindFirstChild("SheriffPlayerLabel")

    if label then
        label:Destroy()
    end

end


function funcs.removeAllSheriffLabels()

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then
            funcs.removeSheriffLabel(player)
        end

    end

end


function funcs.setSheriffPlayer(player)

    if not State.SheriffESPEnabled then
        return
    end

    if not player
        or player == Services.LocalPlayer
    then
        return
    end

    if State.lastSheriffPlayer ~= player then

        if State.lastSheriffPlayer then
            funcs.removeSheriffLabel(
                State.lastSheriffPlayer
            )
        end

        State.lastSheriffPlayer = player

    end

    funcs.addSheriffLabel(player)

end


function funcs.setupSheriffCharacter(player)

    if State.SheriffESPCharacterConnections[player] then

        State.SheriffESPCharacterConnections[player]:Disconnect()

        State.SheriffESPCharacterConnections[player] =
            nil

    end


    State.SheriffESPCharacterConnections[player] =
        player.CharacterAdded:Connect(
            function(character)

                local head =
                    character:WaitForChild(
                        "Head",
                        10
                    )

                if not head then
                    return
                end

                task.wait(0.5)

                if State.SheriffESPEnabled
                    and State.lastSheriffPlayer == player
                then

                    funcs.addSheriffLabel(player)

                end

            end
        )

end


function funcs.removeSheriffCharacterConnection(player)

    if State.SheriffESPCharacterConnections[player] then

        State.SheriffESPCharacterConnections[player]:Disconnect()

        State.SheriffESPCharacterConnections[player] =
            nil

    end

end


function funcs.checkSheriffPlayers()

    if not State.SheriffESPEnabled then
        return
    end

    local gunPlayer = nil

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer
            and funcs.hasGun(player)
        then

            gunPlayer = player
            break

        end

    end


    if gunPlayer then

        State.SheriffLastGunSeen =
            os.clock()

        funcs.setSheriffPlayer(gunPlayer)

        return

    end


    if State.lastSheriffPlayer
        and State.SheriffLastGunSeen > 0
    then

        local elapsed =
            os.clock()
            - State.SheriffLastGunSeen

        if elapsed >= State.SheriffGunTimeout then

            funcs.removeSheriffLabel(
                State.lastSheriffPlayer
            )

            State.lastSheriffPlayer =
                nil

            State.SheriffLastGunSeen =
                0

        end

    end

end



function funcs.setSheriffESPEnabled(Value)

    State.SheriffESPEnabled =
        Value


    if Value then

        for _, player in ipairs(
            Services.Players:GetPlayers()
        ) do

            if player ~= Services.LocalPlayer then

                funcs.setupSheriffCharacter(
                    player
                )

            end

        end


        if State.SheriffESPConnection then

            State.SheriffESPConnection:Disconnect()

            State.SheriffESPConnection =
                nil

        end


        State.SheriffESPConnection =
            Services.RunService.Heartbeat:Connect(
                function()

                    funcs.checkSheriffPlayers()

                end
            )


    else

        if State.SheriffESPConnection then

            State.SheriffESPConnection:Disconnect()

            State.SheriffESPConnection =
                nil

        end


        funcs.removeAllSheriffLabels()


        for player, connection in pairs(
            State.SheriffESPCharacterConnections
        ) do

            if connection then
                connection:Disconnect()
            end

            State.SheriffESPCharacterConnections[player] =
                nil

        end


        State.lastSheriffPlayer =
            nil

        State.SheriffLastGunSeen =
            0

    end

end



function funcs.SetupPlayerESPCharacter(plr, char)

    if not State.PlayerESPEnabled then
        return
    end

    if not plr or not char then
        return
    end

    local root = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:WaitForChild("Humanoid", 5)

    if not root or not humanoid then
        return
    end

    if State.PlayerESPObjects[plr] then

        local old = State.PlayerESPObjects[plr]

        if old.Connection then
            old.Connection:Disconnect()
        end

        if old.Highlight then
            old.Highlight:Destroy()
        end

        if old.Billboard then
            old.Billboard:Destroy()
        end

        State.PlayerESPObjects[plr] = nil

    end


    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char


    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESPText"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root


    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextStrokeTransparency = 0
    text.TextSize = 14
    text.Font = Enum.Font.SourceSansBold
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.Parent = billboard


    local connection

    connection = Services.RunService.RenderStepped:Connect(function()

        if not State.PlayerESPEnabled
            or not char.Parent
            or not root.Parent
            or humanoid.Health <= 0
        then

            if connection then
                connection:Disconnect()
            end

            if State.PlayerESPObjects[plr] then

                local data =
                    State.PlayerESPObjects[plr]

                if data.Highlight then
                    data.Highlight:Destroy()
                end

                if data.Billboard then
                    data.Billboard:Destroy()
                end

                State.PlayerESPObjects[plr] = nil

            end

            return
        end


        local distance = 0

        if Services.LocalPlayer.Character then

            local localRoot =
                Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if localRoot then

                distance = math.floor(
                    (localRoot.Position - root.Position).Magnitude
                )

            end

        end


        if distance > State.PlayerESPDistance then

            highlight.Enabled = false
            billboard.Enabled = false

        else

            highlight.Enabled = true
            billboard.Enabled = true

        end


        text.Text =
            plr.Name
            .. "\n❤ "
            .. math.floor(humanoid.Health)
            .. "/"
            .. math.floor(humanoid.MaxHealth)
            .. " | "
            .. distance
            .. " st"

    end)


    State.PlayerESPObjects[plr] = {
        Highlight = highlight,
        Billboard = billboard,
        Connection = connection
    }

end



function funcs.CreatePlayerESP(plr)

    if plr == Services.LocalPlayer then
        return
    end

    if State.PlayerESPObjects[plr] then
        return
    end


    if plr.Character then
        funcs.SetupPlayerESPCharacter(plr, plr.Character)
    end


    funcs.Connect(
        "PlayerESP_CharacterAdded_" .. plr.UserId,
        plr.CharacterAdded,
        function(char)

            if not State.PlayerESPEnabled then
                return
            end

            funcs.RemovePlayerESP(
                plr,
                true
            )

            task.wait(1)

            if not State.PlayerESPEnabled then
                return
            end

            funcs.SetupPlayerESPCharacter(
                plr,
                char
            )

        end
    )

end



function funcs.RemovePlayerESP(plr, KeepCharacterConnection)

    if plr then

        local data =
            State.PlayerESPObjects[plr]

        if data then

            if data.Connection then
                data.Connection:Disconnect()
            end

            if data.Highlight then
                data.Highlight:Destroy()
            end

            if data.Billboard then
                data.Billboard:Destroy()
            end

            State.PlayerESPObjects[plr] = nil

        end


        if not KeepCharacterConnection then
            funcs.Disconnect(
                "PlayerESP_CharacterAdded_" ..
                plr.UserId
            )
        end

        return
    end


    for player, data in pairs(
        State.PlayerESPObjects
    ) do

        if data.Connection then
            data.Connection:Disconnect()
        end

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end

        if not KeepCharacterConnection then
            funcs.Disconnect(
                "PlayerESP_CharacterAdded_" ..
                player.UserId
            )
        end

    end

    table.clear(
        State.PlayerESPObjects
    )

end



function funcs.SetPlayerESPEnabled(Value)

    State.PlayerESPEnabled = Value

    if Value then

        for _, plr in ipairs(Services.Players:GetPlayers()) do

            if plr ~= Services.LocalPlayer then
                funcs.CreatePlayerESP(plr)
            end

        end

    else

        funcs.RemovePlayerESP()

    end

end


function funcs.UnloadMurdererESP()

    State.MurdererESPEnabled = false

    if State.MurdererESPConnection then
        State.MurdererESPConnection:Disconnect()
        State.MurdererESPConnection = nil
    end

    for player, connection in pairs(
        State.MurdererESPCharacterConnections
    ) do

        if connection then
            connection:Disconnect()
        end

    end

    State.MurdererESPCharacterConnections = {}

    funcs.removeAllLabels()

    State.lastKnifePlayer = nil
    State.MurdererLastKnifeSeen = 0

end



function funcs.hasKnife(player)

    local backpack =
        player:FindFirstChildOfClass("Backpack")

    local character =
        player.Character

    if backpack
        and backpack:FindFirstChild("Knife", true)
    then
        return true
    end

    if character
        and character:FindFirstChild("Knife", true)
    then
        return true
    end

    return false

end



function funcs.addLabel(player)

    if not State.MurdererESPEnabled then
        return
    end

    if not player
        or player == Services.LocalPlayer
    then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    if head:FindFirstChild("KnifePlayerLabel") then
        return
    end


    local billboard =
        Instance.new("BillboardGui")

    billboard.Name =
        "KnifePlayerLabel"

    billboard.Adornee =
        head

    billboard.Size =
        UDim2.fromOffset(160, 50)

    billboard.StudsOffset =
        Vector3.new(0, 5, 0)

    billboard.AlwaysOnTop =
        true

    billboard.MaxDistance =
        1000

    billboard.Parent =
        head


    local text =
        Instance.new("TextLabel")

    text.Name =
        "PlayerText"

    text.Size =
        UDim2.fromScale(1, 1)

    text.BackgroundTransparency =
        1

    text.Text =
        "Murderer"

    text.TextColor3 =
        Color3.fromRGB(255, 45, 45)

    text.TextSize =
        26

    text.Font =
        Enum.Font.GothamBold

    text.TextStrokeColor3 =
        Color3.fromRGB(80, 0, 0)

    text.TextStrokeTransparency =
        0.15

    text.Parent =
        billboard

end



function funcs.removeLabel(player)

    if not player then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    local label =
        head:FindFirstChild("KnifePlayerLabel")

    if label then
        label:Destroy()
    end

end



function funcs.removeAllLabels()

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then
            funcs.removeLabel(player)
        end

    end

end



function funcs.setKnifePlayer(player)

    if not State.MurdererESPEnabled then
        return
    end

    if player == Services.LocalPlayer then
        return
    end

    State.MurdererLastKnifeSeen = time()

    if State.lastKnifePlayer == player then

        funcs.addLabel(player)

        return

    end


    if State.lastKnifePlayer then

        funcs.removeLabel(
            State.lastKnifePlayer
        )

    end


    State.lastKnifePlayer =
        player

    funcs.addLabel(player)

end



function funcs.setupCharacter(player)

    if State.MurdererESPCharacterConnections[player] then

        State.MurdererESPCharacterConnections[player]:Disconnect()

        State.MurdererESPCharacterConnections[player] =
            nil

    end


    State.MurdererESPCharacterConnections[player] =
        player.CharacterAdded:Connect(
            function(character)

                local head =
                    character:WaitForChild(
                        "Head",
                        10
                    )

                if not head then
                    return
                end

                task.wait(0.5)


                if State.MurdererESPEnabled
                    and State.lastKnifePlayer == player
                then

                    funcs.addLabel(player)

                end

            end
        )

end



function funcs.removeCharacterConnection(player)

    if State.MurdererESPCharacterConnections[player] then

        State.MurdererESPCharacterConnections[player]:Disconnect()

        State.MurdererESPCharacterConnections[player] =
            nil

    end

end



function funcs.checkPlayers()

    if not State.MurdererESPEnabled then
        return
    end

    local knifeFound = false

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer
            and funcs.hasKnife(player)
        then

            knifeFound = true

            State.MurdererLastKnifeSeen =
                time()

            funcs.setKnifePlayer(player)

            break

        end

    end


    if not knifeFound
        and State.lastKnifePlayer
        and State.MurdererLastKnifeSeen > 0
    then

        local elapsed =
            time() - State.MurdererLastKnifeSeen

        if elapsed >= State.MurdererKnifeTimeout then

            funcs.removeLabel(
                State.lastKnifePlayer
            )

            State.lastKnifePlayer = nil
            State.MurdererLastKnifeSeen = 0

        end

    end


    if State.lastKnifePlayer then

        funcs.addLabel(
            State.lastKnifePlayer
        )

    end

end



function funcs.setMurdererESPEnabled(Value)

    State.MurdererESPEnabled = Value

    if Value then

        for _, player in ipairs(
            Services.Players:GetPlayers()
        ) do

            if player ~= Services.LocalPlayer then
                funcs.setupCharacter(player)
            end

        end


        if State.MurdererESPConnection then

            State.MurdererESPConnection:Disconnect()

            State.MurdererESPConnection = nil

        end


        State.MurdererESPConnection =
            Services.RunService.Heartbeat:Connect(
                function()

                    funcs.checkPlayers()

                end
            )


    else

        if State.MurdererESPConnection then

            State.MurdererESPConnection:Disconnect()

            State.MurdererESPConnection = nil

        end


        funcs.removeAllLabels()


        for player, connection in pairs(
            State.MurdererESPCharacterConnections
        ) do

            if connection then
                connection:Disconnect()
            end

            State.MurdererESPCharacterConnections[player] =
                nil

        end


        State.lastKnifePlayer = nil
        State.MurdererLastKnifeSeen = 0

    end

end





Groupboxes.BaseVisualESP:AddToggle("PlayerESPToggle", {
    Text = "Player ESP",
    Default = false
}):OnChanged(function(Value)

    funcs.SetPlayerESPEnabled(Value)

end)


Groupboxes.BaseVisualESP:AddToggle(
    "MurdererESPToggle",
    {
        Text = "Show Murderer",
        Default = false
    }
):OnChanged(function(Value)

    funcs.setMurdererESPEnabled(Value)

end)

Groupboxes.BaseVisualESP:AddToggle(
    "SheriffESPToggle",
    {
        Text = "Show Sheriff",
        Default = false
    }
):OnChanged(function(Value)

    funcs.setSheriffESPEnabled(Value)

end)



Groupboxes.BaseVisualESP:AddSlider("PlayerESPDistance", {
    Text = "ESP Distance",
    Default = 2000,
    Min = 100,
    Max = 10000,
    Rounding = 0,
    Compact = false
}):OnChanged(function(Value)

    State.PlayerESPDistance = Value

end)




funcs.Connect(
    "PlayerESP_PlayerAdded",
    Services.Players.PlayerAdded,
    function(plr)

        if State.PlayerESPEnabled
        and plr ~= Services.LocalPlayer then

            funcs.CreatePlayerESP(plr)

        end

    end
)



funcs.Connect(
    "PlayerESP_PlayerRemoving",
    Services.Players.PlayerRemoving,
    function(plr)

        funcs.RemovePlayerESP(plr)

    end
)


funcs.Connect(
    "MurdererESP_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)

        if player == Services.LocalPlayer then
            return
        end

        if State.MurdererESPEnabled then

            funcs.setupCharacter(player)

        end

    end
)


funcs.Connect(
    "MurdererESP_PlayerRemoving",
    Services.Players.PlayerRemoving,
    function(player)

        funcs.removeLabel(player)

        funcs.removeCharacterConnection(
            player
        )

        if State.lastKnifePlayer == player then

            State.lastKnifePlayer =
                nil

        end

    end
)

funcs.Connect(
    "SheriffESP_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)

        if player == Services.LocalPlayer then
            return
        end

        if State.SheriffESPEnabled then

            funcs.setupSheriffCharacter(
                player
            )

        end

    end
)


funcs.Connect(
    "SheriffESP_PlayerRemoving",
    Services.Players.PlayerRemoving,
    function(player)

        funcs.removeSheriffLabel(player)

        funcs.removeSheriffCharacterConnection(
            player
        )

        if State.lastSheriffPlayer == player then

            State.lastSheriffPlayer =
                nil

            State.SheriffLastGunSeen =
                0

        end

    end
)








-- Misc
Groupboxes.ExecutableScripts = Tabs.Misc:AddLeftGroupbox("Executable Scripts", "code")

Groupboxes.ExecutableScripts:AddButton({
    Text = "Execute Infinite Yield",
    Func = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua"
        ))()
    end
})


Groupboxes.ExecutableScripts:AddButton({
    Text = "Execute Dex Explorer",
    Func = function()
        loadstring(game:HttpGet(
            "https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"
        ))()
    end
})

-- Exploits
Groupboxes.ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleport System", "user")

function funcs.UpdatePlayerList()

    local newList = {}

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        table.insert(
            newList,
            player.Name
        )

    end


    State.PlayerList = newList


    if Options.PlayerDropdown then
        Options.PlayerDropdown:SetValues(
            newList
        )
    end

end

Groupboxes.ExploitsLeftGroupBox:AddDropdown(
    "PlayerDropdown",
    {
        Values = State.PlayerList,
        Default = nil,
        Multi = false,
        Text = "Select Player",
    }
):OnChanged(function(Value)

    State.SelectedPlayer = Value
end)

Groupboxes.ExploitsLeftGroupBox:AddButton(
    "Teleport To Player",

    function()

        if not State.SelectedPlayer then
            return
        end

        local target =
            Services.Players:FindFirstChild(
                State.SelectedPlayer
            )

        if not target
            or not target.Character then
            return
        end

        local targetHRP =
            target.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local character =
            Services.LocalPlayer.Character

        local hrp =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )

        if targetHRP and hrp then
            hrp.CFrame =
                targetHRP.CFrame
                + Vector3.new(0, 3, 0)
        end
    end
)

funcs.UpdatePlayerList()
-- Botting
Groupboxes.Botting = Tabs.Botting:AddRightGroupbox("Bot Farms", "user")
State.CoinTeleportEnabled = false
State.CoinTeleportConnection = nil
State.CoinTeleportTween = nil
State.CoinTeleportCharacterConnection = nil
State.CoinTeleportMurdererAway = true


function funcs.StartCoinTeleport()

    if State.CoinTeleportConnection then
        task.cancel(State.CoinTeleportConnection)
        State.CoinTeleportConnection = nil
    end

    if State.CoinTeleportTween then
        State.CoinTeleportTween:Cancel()
        State.CoinTeleportTween = nil
    end

    State.CoinTeleportEnabled = true

    State.CoinTeleportConnection = task.spawn(function()

        local TweenService =
            game:GetService("TweenService")

        local containerPaths = {
            {"MilBase", "CoinContainer"},
            {"House2", "CoinContainer"},
            {"Mansion2", "CoinContainer"},
            {"Factory", "CoinContainer"},
            {"ResearchFacility", "CoinContainer"},
            {"Workplace", "CoinContainer"},
            {"Bank2", "CoinContainer"},
            {"Hotel", "CoinContainer"},
            {"Office3", "CoinContainer"},
            {"Hospital3", "CoinContainer"},
            {"PoliceStation", "CoinContainer"},
            {"BioLab", "CoinContainer"}
        }

        while State.CoinTeleportEnabled do

            local coins = {}

            for _, path in ipairs(containerPaths) do

                local parent =
                    workspace:FindFirstChild(path[1])

                if parent then

                    local container =
                        parent:FindFirstChild(path[2])

                    if container and container.Parent then

                        for _, coinServer in ipairs(
                            container:GetChildren()
                        ) do

                            if coinServer.Name == "Coin_Server" then

                                local target = nil

                                local coinVisual =
                                    coinServer:FindFirstChild("CoinVisual")

                                if coinVisual then

                                    local mainCoin =
                                        coinVisual:FindFirstChild("MainCoin")

                                    if mainCoin then
                                        target = mainCoin

                                    elseif coinVisual:IsA("BasePart") then
                                        target = coinVisual
                                    end

                                elseif coinServer:IsA("BasePart") then

                                    target = coinServer

                                end

                                if target then
                                    table.insert(coins, target)
                                end

                            end

                        end

                    end

                end

            end


            while State.CoinTeleportEnabled and #coins > 0 do

                local character =
                    Services.LocalPlayer.Character

                local root =
                    character
                    and character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not character
                    or not root
                    or not character.Parent
                    or not root.Parent
                then
                    break
                end


                local murdererRoot = nil

                if State.CoinTeleportMurdererAway then

                    for _, player in ipairs(
                        Services.Players:GetPlayers()
                    ) do

                        if player ~= Services.LocalPlayer
                            and funcs.hasKnife(player)
                        then

                            local murdererCharacter =
                                player.Character

                            if murdererCharacter then

                                murdererRoot =
                                    murdererCharacter:FindFirstChild(
                                        "HumanoidRootPart"
                                    )

                            end

                            if murdererRoot then
                                break
                            end

                        end

                    end

                end


                local selectedTarget = nil
                local selectedPlayerDistance = nil
                local selectedMurdererDistance = nil
                local selectedIndex = nil


                for index, target in ipairs(coins) do

                    if target and target.Parent then

                        local targetPosition = nil

                        if target:IsA("BasePart") then

                            targetPosition =
                                target.Position

                        elseif target:IsA("Model") then

                            targetPosition =
                                target:GetPivot().Position

                        end


                        if targetPosition then

                            local playerDistance =
                                (
                                    root.Position
                                    - targetPosition
                                ).Magnitude


                            local murdererDistance = math.huge

                            if murdererRoot then

                                murdererDistance =
                                    (
                                        murdererRoot.Position
                                        - targetPosition
                                    ).Magnitude

                            end


                            if playerDistance <= 5000 then

                                if not selectedTarget then

                                    selectedTarget =
                                        target

                                    selectedPlayerDistance =
                                        playerDistance

                                    selectedMurdererDistance =
                                        murdererDistance

                                    selectedIndex =
                                        index

                                else

                                    local shouldSelect = false

                                    if murdererRoot then

                                        if murdererDistance
                                            > selectedMurdererDistance
                                        then

                                            shouldSelect = true

                                        elseif murdererDistance
                                            == selectedMurdererDistance
                                            and playerDistance
                                            < selectedPlayerDistance
                                        then

                                            shouldSelect = true

                                        end

                                    elseif playerDistance
                                        < selectedPlayerDistance
                                    then

                                        shouldSelect = true

                                    end


                                    if shouldSelect then

                                        selectedTarget =
                                            target

                                        selectedPlayerDistance =
                                            playerDistance

                                        selectedMurdererDistance =
                                            murdererDistance

                                        selectedIndex =
                                            index

                                    end

                                end

                            end

                        end

                    end

                end


                if not selectedTarget then
                    break
                end


                table.remove(
                    coins,
                    selectedIndex
                )


                local targetCFrame

                if selectedTarget:IsA("BasePart") then

                    targetCFrame =
                        selectedTarget.CFrame
                        + Vector3.new(0, 3, 0)

                elseif selectedTarget:IsA("Model") then

                    targetCFrame =
                        selectedTarget:GetPivot()
                        + Vector3.new(0, 3, 0)

                end


                if targetCFrame
                    and selectedTarget.Parent
                then

                    local distance =
                        (
                            root.Position
                            - targetCFrame.Position
                        ).Magnitude

                    local duration =
                        math.max(
                            distance / 24,
                            0.3
                        )


                    State.CoinTeleportTween =
                        TweenService:Create(
                            root,
                            TweenInfo.new(
                                duration,
                                Enum.EasingStyle.Linear
                            ),
                            {
                                CFrame = targetCFrame
                            }
                        )


                    State.CoinTeleportTween:Play()


                    while
                        State.CoinTeleportEnabled
                        and character.Parent
                        and root.Parent
                        and selectedTarget.Parent
                        and State.CoinTeleportTween
                        and State.CoinTeleportTween.PlaybackState
                            == Enum.PlaybackState.Playing
                    do

                        task.wait()

                    end


                    if State.CoinTeleportTween then

                        State.CoinTeleportTween:Cancel()
                        State.CoinTeleportTween = nil

                    end


                    if not State.CoinTeleportEnabled then
                        break
                    end


                    task.wait(0.55)

                end

            end

            task.wait(0.1)

        end

    end)

end


function funcs.StopCoinTeleport()

    State.CoinTeleportEnabled = false

    if State.CoinTeleportTween then

        State.CoinTeleportTween:Cancel()
        State.CoinTeleportTween = nil

    end

    if State.CoinTeleportConnection then

        task.cancel(
            State.CoinTeleportConnection
        )

        State.CoinTeleportConnection = nil

    end

end


function funcs.SetupCoinTeleportCharacter()

    if State.CoinTeleportCharacterConnection then

        State.CoinTeleportCharacterConnection:Disconnect()
        State.CoinTeleportCharacterConnection = nil

    end


    State.CoinTeleportCharacterConnection =
        Services.LocalPlayer.CharacterAdded:Connect(
            function()

                if not State.CoinTeleportEnabled then
                    return
                end

                task.wait(0.5)

                if State.CoinTeleportEnabled then
                    funcs.StartCoinTeleport()
                end

            end
        )

end


funcs.SetupCoinTeleportCharacter()


Groupboxes.Botting:AddToggle(
    "CoinTeleportToggle",
    {
        Text = "Coin Bot",
        Default = true
    }
):OnChanged(function(Value)

    if Value then
        funcs.StartCoinTeleport()
    else
        funcs.StopCoinTeleport()
    end

end)

funcs.StartCoinTeleport()



function funcs.GetServers(order)
    local placeId = game.PlaceId
    local cursor = ""
    local selectedServer = nil
    local value = order == "Asc" and math.huge or -1

    for i = 1, 3 do

        local url =
            "https://games.roblox.com/v1/games/"
            .. placeId ..
            "/servers/Public?sortOrder="
            .. order ..
            "&limit=100"

        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end


        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if not success then
            Library:Notify("Could not fetch servers!", 3)
            return
        end


        local data = HttpService:JSONDecode(response)


        for _, server in ipairs(data.data) do

            if server.playing < server.maxPlayers then

                if order == "Asc" then
                    if server.playing < value then
                        value = server.playing
                        selectedServer = server
                    end
                else
                    if server.playing > value then
                        value = server.playing
                        selectedServer = server
                    end
                end

            end
        end


        cursor = data.nextPageCursor

        if not cursor then
            break
        end

        task.wait(1)
    end


    return selectedServer
end



function funcs.JoinSmallestServer()

    local server = funcs.GetServers("Asc")

    if server then

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            server.id,
            Players.LocalPlayer
        )

    else

        Library:Notify("Server Not Found!", 3)

    end
end


State.CoinServerHop = false

task.spawn(function()

    while true do

        task.wait(0.1)

        if State.CoinTeleportEnabled
            and not State.CoinServerHop
        then

            local playerGui =
                Services.LocalPlayer:FindFirstChild("PlayerGui")

            local mainGUI =
                playerGui
                and playerGui:FindFirstChild("MainGUI")

            local gameFrame =
                mainGUI
                and mainGUI:FindFirstChild("Game")

            local coinBags =
                gameFrame
                and gameFrame:FindFirstChild("CoinBags")

            local container =
                coinBags
                and coinBags:FindFirstChild("Container")

            local coin =
                container
                and container:FindFirstChild("Coin")

            local currencyFrame =
                coin
                and coin:FindFirstChild("CurrencyFrame")

            local icon =
                currencyFrame
                and currencyFrame:FindFirstChild("Icon")

            local coins =
                icon
                and icon:FindFirstChild("Coins")

            if coins then

                local value =
                    tonumber(coins.Text)

                if value and value >= 40 then

                    State.CoinServerHop = true

                    if queue_on_teleport then

                        queue_on_teleport([[
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/MM2Coin.lua"))()
                        ]])

                    end

                    funcs.JoinSmallestServer()

                end

            end

        end

    end

end)




-- Pathing 
Groupboxes.PathingSettings = Tabs.Pathing:AddLeftGroupbox("Pathing Settings", "settings")
Groupboxes.PathingToggles = Tabs.Pathing:AddRightGroupbox("Pathing", "route")
Groupboxes.PathManager = Tabs.Pathing:AddLeftGroupbox("Path Manager", "settings")

State.PathingObjects = {
    Character = nil,
    Humanoid = nil,
    RootPart = nil,

    PathRunning = false,
    WaitingForReset = false,
    ResetCycleActive = false,
    ForceSingleRun = false,
    CurrentIndex = 1,

    PathPoints = {},
    PointObjects = {},
    LineObjects = {},

    VisualizePoints = true,

    POINT_SIZE = 1.7,
    LINE_WIDTH = 0.11,

    BLACK = Color3.fromRGB(0, 0, 0),
    WHITE = Color3.fromRGB(255, 255, 255),
    RED = Color3.fromRGB(255, 35, 35),
}

State.PathingFolder = Instance.new("Folder")
State.PathingFolder.Name = "PathingVisuals"
State.PathingFolder.Parent = Services.Workspace

State.PathingUI = {
    PointCounterLabel = nil,
    CurrentPointLabel = nil,

    SavedPathDropdown = nil,
    PathNameInput = nil,
}

State.PathingInstances = {
    Part = nil,
    Highlight = nil,
    Billboard = nil,
    Label = nil,

    Part1 = nil,
    Part2 = nil,

    Attachment1 = nil,
    Attachment2 = nil,

    Beam = nil,
}

State.PathingTemp = {
    Data = nil,
    UI = nil,

    PointData = nil,
    WaitTime = 0,
    ResetTimer = 1,

    Name = "",
    Selected = nil,

    Success = false,
    Result = nil,
    LoadedData = nil,
    Names = {},
}

function funcs.SetupCharacter(CharacterObject)
    State.PathingObjects.Character = CharacterObject

    State.PathingObjects.Humanoid =
        CharacterObject:WaitForChild(
            "Humanoid",
            10
        )

    State.PathingObjects.RootPart =
        CharacterObject:WaitForChild(
            "HumanoidRootPart",
            10
        )
end

function funcs.Notify(Title, Description)
    pcall(function()
        Library:Notify({
            Title = Title,
            Description = Description,
            Time = 2
        })
    end)
end

function funcs.UpdatePointCounter()
    pcall(function()
        if State.PathingUI.PointCounterLabel then
            State.PathingUI.PointCounterLabel:SetText(
                "Points: " ..
                tostring(
                    #State.PathingObjects.PathPoints
                )
            )
        end

        if State.PathingUI.CurrentPointLabel then
            State.PathingUI.CurrentPointLabel:SetText(
                "Current Point: " ..
                tostring(
                    State.PathingObjects.CurrentIndex
                ) ..
                " / " ..
                tostring(
                    #State.PathingObjects.PathPoints
                )
            )
        end
    end)
end

function funcs.ClearVisuals()
    for _, Object in ipairs(
        State.PathingObjects.PointObjects
    ) do
        if Object and Object.Parent then
            Object:Destroy()
        end
    end

    for _, Object in ipairs(
        State.PathingObjects.LineObjects
    ) do
        if Object and Object.Parent then
            Object:Destroy()
        end
    end

    table.clear(
        State.PathingObjects.PointObjects
    )

    table.clear(
        State.PathingObjects.LineObjects
    )
end

function funcs.CreatePointVisual(
    Position,
    Index,
    IsResetPoint
)
    if not State.PathingObjects.VisualizePoints then
        return
    end

    local Part = Instance.new("Part")

    Part.Name =
        IsResetPoint and
        ("ResetPoint_" .. Index) or
        ("Point_" .. Index)

    Part.Shape = Enum.PartType.Ball

    Part.Size = Vector3.new(
        State.PathingObjects.POINT_SIZE,
        State.PathingObjects.POINT_SIZE,
        State.PathingObjects.POINT_SIZE
    )

    Part.Position = Position
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.Neon

    Part.Color =
        IsResetPoint and
        State.PathingObjects.RED or
        State.PathingObjects.BLACK

    Part.Parent = State.PathingFolder

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name = "Outline"
    Highlight.Adornee = Part
    Highlight.FillColor = Part.Color
    Highlight.FillTransparency = 0

    Highlight.OutlineColor =
        State.PathingObjects.WHITE

    Highlight.OutlineTransparency = 0

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.Parent = Part

    local Billboard =
        Instance.new("BillboardGui")

    Billboard.Name = "PointNumber"
    Billboard.Adornee = Part
    Billboard.Size =
        UDim2.fromOffset(34, 24)

    Billboard.StudsOffset =
        Vector3.new(0, 1.25, 0)

    Billboard.AlwaysOnTop = true
    Billboard.LightInfluence = 0
    Billboard.MaxDistance = 500
    Billboard.Parent = Part

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.fromScale(1, 1)

    Label.BackgroundTransparency = 1
    Label.Text = tostring(Index)

    Label.TextColor3 =
        State.PathingObjects.WHITE

    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold

    Label.TextStrokeColor3 =
        Color3.new(0, 0, 0)

    Label.TextStrokeTransparency = 0.35

    Label.TextXAlignment =
        Enum.TextXAlignment.Center

    Label.TextYAlignment =
        Enum.TextYAlignment.Center

    Label.Parent = Billboard

    table.insert(
        State.PathingObjects.PointObjects,
        Part
    )
end

function funcs.CreateLine(
    Position1,
    Position2,
    Index
)
    if not State.PathingObjects.VisualizePoints then
        return
    end

    local Part1 = Instance.new("Part")

    Part1.Name =
        "LineStart_" .. Index

    Part1.Size =
        Vector3.new(
            0.1,
            0.1,
            0.1
        )

    Part1.Position = Position1
    Part1.Transparency = 1
    Part1.Anchored = true
    Part1.CanCollide = false
    Part1.CanTouch = false
    Part1.CanQuery = false

    Part1.Parent =
        State.PathingFolder

    local Part2 = Instance.new("Part")

    Part2.Name =
        "LineEnd_" .. Index

    Part2.Size =
        Vector3.new(
            0.1,
            0.1,
            0.1
        )

    Part2.Position = Position2
    Part2.Transparency = 1
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false

    Part2.Parent =
        State.PathingFolder

    local Attachment1 =
        Instance.new("Attachment")

    Attachment1.Parent = Part1

    local Attachment2 =
        Instance.new("Attachment")

    Attachment2.Parent = Part2

    local Beam =
        Instance.new("Beam")

    Beam.Name =
        "PathLine_" .. Index

    Beam.Attachment0 =
        Attachment1

    Beam.Attachment1 =
        Attachment2

    Beam.Color =
        ColorSequence.new(
            State.PathingObjects.WHITE
        )

    Beam.Width0 =
        State.PathingObjects.LINE_WIDTH

    Beam.Width1 =
        State.PathingObjects.LINE_WIDTH

    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.LightInfluence = 0

    Beam.Transparency =
        NumberSequence.new(0)

    Beam.Parent =
        State.PathingFolder

    table.insert(
        State.PathingObjects.LineObjects,
        Part1
    )

    table.insert(
        State.PathingObjects.LineObjects,
        Part2
    )

    table.insert(
        State.PathingObjects.LineObjects,
        Beam
    )
end

function funcs.RedrawPath()
    funcs.ClearVisuals()

    if State.PathingObjects.VisualizePoints then
        for Index, PointData in ipairs(
            State.PathingObjects.PathPoints
        ) do

            funcs.CreatePointVisual(
                PointData.Position,
                Index,
                PointData.Reset
            )

            if Index > 1 then
                funcs.CreateLine(
                    State.PathingObjects.PathPoints[
                        Index - 1
                    ].Position,

                    PointData.Position,

                    Index
                )
            end
        end
    end

    funcs.UpdatePointCounter()
end

function funcs.AddPoint()
    if not State.PathingObjects.Character or
        State.PathingObjects.Character ~=
        Services.LocalPlayer.Character or
        not State.PathingObjects.Humanoid or
        not State.PathingObjects.RootPart
    then

        if Services.LocalPlayer.Character then
            funcs.SetupCharacter(
                Services.LocalPlayer.Character
            )
        end
    end

    if not State.PathingObjects.RootPart then
        funcs.Notify(
            "Pathing Error",
            "Character not found."
        )

        return
    end

    local WaitTime = 0

    pcall(function()
        WaitTime =
            Options.PointWait.Value
    end)

    table.insert(
        State.PathingObjects.PathPoints,
        {
            Position =
                State.PathingObjects.RootPart.Position,

            Reset = false,

            WaitTime =
                tonumber(WaitTime) or 0
        }
    )

    State.PathingObjects.CurrentIndex = 1

    funcs.RedrawPath()

    funcs.Notify(
        "Pathing Succesfull",
        "Point " ..
        #State.PathingObjects.PathPoints ..
        " created."
    )
end

function funcs.SetLastPointReset()
    if #State.PathingObjects.PathPoints == 0 then
        funcs.Notify(
            "Wait For Reset",
            "Create a point first."
        )

        return
    end

    State.PathingObjects.PathPoints[
        #State.PathingObjects.PathPoints
    ].Reset =
        not State.PathingObjects.PathPoints[
            #State.PathingObjects.PathPoints
        ].Reset

    funcs.RedrawPath()

    if State.PathingObjects.PathPoints[
        #State.PathingObjects.PathPoints
    ].Reset then

        funcs.Notify(
            "Pathing Successful",
            "Your last point is changed with a reset point."
        )
    else
        funcs.Notify(
            "Pathing Succesful",
            "Reset point removed."
        )
    end
end

function funcs.RemoveLastPoint()
    if #State.PathingObjects.PathPoints == 0 then
        funcs.Notify(
            "Pathing Error",
            "No path to remove"
        )

        return
    end

    table.remove(
        State.PathingObjects.PathPoints
    )

    State.PathingObjects.CurrentIndex =
        math.min(
            State.PathingObjects.CurrentIndex,
            math.max(
                #State.PathingObjects.PathPoints,
                1
            )
        )

    funcs.RedrawPath()
end

function funcs.StopPath()
    State.PathingObjects.PathRunning = false
    State.PathingObjects.WaitingForReset = false
    State.PathingObjects.ResetCycleActive = false
    State.PathingObjects.ForceSingleRun = false
    State.PathingObjects.CurrentIndex = 1

    pcall(function()
        if Toggles.StartPath and
            Toggles.StartPath.Value
        then
            Toggles.StartPath:SetValue(false)
        end
    end)

    funcs.UpdatePointCounter()
end

function funcs.ClearCurrentPath()
    funcs.StopPath()

    table.clear(
        State.PathingObjects.PathPoints
    )

    funcs.RedrawPath()
end

function funcs.MoveToPoint(Position)
    if not State.PathingObjects.Character or
        not State.PathingObjects.Humanoid or
        not State.PathingObjects.RootPart
    then
        return false
    end

    if State.PathingObjects.Humanoid.Health <= 0 then
        return false
    end

    State.PathingObjects.RootPart.CFrame =
        CFrame.new(Position)

    return true
end

function funcs.ResetCharacter()
    if not State.PathingObjects.Humanoid or
        State.PathingObjects.Humanoid.Health <= 0
    then
        return
    end

    State.PathingObjects.WaitingForReset = true
    State.PathingObjects.ResetCycleActive = true

    State.PathingObjects.Humanoid.Health = 0
end

function funcs.StartPath(OneShot)
    if State.PathingObjects.PathRunning then
        return
    end

    if #State.PathingObjects.PathPoints == 0 then
        funcs.Notify(
            "Pathing Error",
            "Create a point first."
        )

        pcall(function()
            if Toggles.StartPath then
                Toggles.StartPath:SetValue(false)
            end
        end)

        return
    end

    State.PathingObjects.PathRunning = true
    State.PathingObjects.WaitingForReset = false
    State.PathingObjects.ResetCycleActive = false

    State.PathingObjects.ForceSingleRun =
        OneShot == true

    State.PathingObjects.CurrentIndex = 1

    task.spawn(function()
        while State.PathingObjects.PathRunning and
            not Library.Unloaded
        do

            if not State.PathingObjects.Character or
                not State.PathingObjects.Humanoid or
                not State.PathingObjects.RootPart or
                State.PathingObjects.Humanoid.Health <= 0
            then
                task.wait(0.1)
                continue
            end

            if State.PathingObjects.WaitingForReset then
                task.wait(0.1)
                continue
            end

            local PointData =
                State.PathingObjects.PathPoints[
                    State.PathingObjects.CurrentIndex
                ]

            if not PointData then
                State.PathingObjects.CurrentIndex = 1

                PointData =
                    State.PathingObjects.PathPoints[1]
            end

            if not PointData then
                task.wait(0.1)
                continue
            end

            funcs.UpdatePointCounter()

            if not funcs.MoveToPoint(
                PointData.Position
            ) then
                task.wait(0.1)
                continue
            end

            local WaitTime =
                tonumber(
                    PointData.WaitTime
                ) or 0

            if WaitTime > 0 then
                task.wait(WaitTime)
            end

            if not State.PathingObjects.PathRunning then
                break
            end

            if PointData.Reset then
                local ResetTimer = 1

                pcall(function()
                    ResetTimer =
                        Options.ResetTimer.Value
                end)

                task.wait(ResetTimer)

                if not State.PathingObjects.PathRunning then
                    break
                end

                funcs.ResetCharacter()

                while State.PathingObjects.PathRunning and
                    State.PathingObjects.WaitingForReset
                do
                    task.wait(0.1)
                end
            else
                if State.PathingObjects.CurrentIndex <
                    #State.PathingObjects.PathPoints
                then

                    State.PathingObjects.CurrentIndex += 1

                elseif State.PathingObjects.ForceSingleRun then

                    State.PathingObjects.PathRunning = false
                    State.PathingObjects.ForceSingleRun = false
                    State.PathingObjects.CurrentIndex = 1

                    funcs.Notify(
                        "Test Path",
                        "Test path succesful."
                    )

                    break
                else
                    State.PathingObjects.CurrentIndex = 1
                end
            end

            task.wait()
        end

        funcs.UpdatePointCounter()
    end)
end

function funcs.GetPathName()
    local Name = ""

    pcall(function()
        if State.PathingUI.PathNameInput then
            Name =
                State.PathingUI.PathNameInput.Value
        end
    end)

    Name = tostring(Name or "")

    Name = Name:gsub("^%s+", "")
    Name = Name:gsub("%s+$", "")

    return Name
end

function funcs.SaveCurrentPath()
    local Name =
        funcs.GetPathName()

    if Name == "" then
        funcs.Notify(
            "PathManager Save Path Error",
            "Enter a name first."
        )

        return
    end

    if #State.PathingObjects.PathPoints == 0 then
        funcs.Notify(
            "PathManager Save Path Error",
            "No points to save."
        )

        return
    end

    local Success, Result =
        pcall(function()
            return PathManager.SavePath(
                Name,
                State.PathingObjects.PathPoints
            )
        end)

    if not Success or Result == false then
        funcs.Notify(
            "PathManager Save Path Error",
            "Path cannot save."
        )

        return
    end

    funcs.Notify(
        "PathManager Save Path Successful",
        "'" .. Name .. "' saved."
    )

    task.defer(function()
        if State.PathingUI.SavedPathDropdown then
            State.PathingUI.SavedPathDropdown:SetValues(
                PathManager.GetPaths()
            )
        end
    end)
end

function funcs.RefreshPaths()
    local Names = {}

    local Success, Result =
        pcall(function()
            return PathManager.GetPaths()
        end)

    if Success and type(Result) == "table" then
        Names = Result
    end

    if State.PathingUI.SavedPathDropdown then
        State.PathingUI.SavedPathDropdown:SetValues(
            Names
        )
    end

    funcs.Notify(
        "PathManager Refresh Paths",
        tostring(#Names) ..
        " saved paths found"
    )
end

function funcs.GetSelectedPath()
    if not State.PathingUI.SavedPathDropdown then
        return nil
    end

    local Selected

    pcall(function()
        Selected =
            State.PathingUI.SavedPathDropdown.Value
    end)

    if type(Selected) == "table" then
        Selected = Selected[1]
    end

    if type(Selected) ~= "string" then
        return nil
    end

    return Selected
end

function funcs.LoadSelectedPath()
    local Name =
        funcs.GetSelectedPath()

    if not Name then
        funcs.Notify(
            "PathManager Load Path Error",
            "Select a path first."
        )

        return
    end

    local Success, LoadedData =
        pcall(function()
            return PathManager.LoadPath(Name)
        end)

    if not Success or
        type(LoadedData) ~= "table" or
        type(LoadedData.Points) ~= "table"
    then
        funcs.Notify(
            "PathManager Load Path Error",
            "Path cannot load."
        )

        return
    end

    funcs.StopPath()

    table.clear(
        State.PathingObjects.PathPoints
    )

    for _, Point in ipairs(
        LoadedData.Points
    ) do

        table.insert(
            State.PathingObjects.PathPoints,
            {
                Position = Point.Position,
                Reset = Point.Reset == true,
                WaitTime =
                    tonumber(
                        Point.WaitTime
                    ) or 0
            }
        )
    end

    pcall(function()
        if State.PathingUI.PathNameInput then
            State.PathingUI.PathNameInput:SetValue(
                LoadedData.Name
            )
        end
    end)

    State.PathingObjects.CurrentIndex = 1

    funcs.RedrawPath()

    funcs.Notify(
        "PathManager Load Path Successful",
        "'" ..
        LoadedData.Name ..
        "' loaded."
    )
end

function funcs.RemoveSelectedPath()
    local Name =
        funcs.GetSelectedPath()

    if not Name then
        funcs.Notify(
            "PathManager Remove Path Error",
            "Select a path first."
        )

        return
    end

    local Success, Result =
        pcall(function()
            return PathManager.DeletePath(
                Name
            )
        end)

    if not Success or Result ~= true then
        funcs.Notify(
            "PathManager Remove Path Error",
            "Path cannot remove."
        )

        return
    end

    funcs.RefreshPaths()

    funcs.Notify(
        "PathManager Remove Path Successful",
        "'" .. Name .. "' removed."
    )
end

if Services.LocalPlayer.Character then
    funcs.SetupCharacter(
        Services.LocalPlayer.Character
    )
end

function funcs.UnloadPathing()

    State.PathingObjects.PathRunning = false
    State.PathingObjects.WaitingForReset = false
    State.PathingObjects.ResetCycleActive = false
    State.PathingObjects.ForceSingleRun = false
    State.PathingObjects.CurrentIndex = 1

    if State.PathingCharacterConnection then
        State.PathingCharacterConnection:Disconnect()
        State.PathingCharacterConnection = nil
    end

    pcall(function()
        funcs.ClearVisuals()
    end)

    table.clear(State.PathingObjects.PathPoints)
    table.clear(State.PathingObjects.PointObjects)
    table.clear(State.PathingObjects.LineObjects)

    if State.PathingFolder then
        State.PathingFolder:Destroy()
        State.PathingFolder = nil
    end

    State.PathingUI.PointCounterLabel = nil
    State.PathingUI.CurrentPointLabel = nil
    State.PathingUI.SavedPathDropdown = nil
    State.PathingUI.PathNameInput = nil

    State.PathingObjects.Character = nil
    State.PathingObjects.Humanoid = nil
    State.PathingObjects.RootPart = nil

end

State.PathingCharacterConnection =
    Services.LocalPlayer.CharacterAdded:Connect(
        function(NewCharacter)

            funcs.SetupCharacter(NewCharacter)

            if State.PathingObjects.ResetCycleActive and
                State.PathingObjects.PathRunning
            then
                task.spawn(function()

                    task.wait(2)

                    if not State.PathingObjects.PathRunning then
                        return
                    end

                    State.PathingObjects.WaitingForReset = false
                    State.PathingObjects.ResetCycleActive = false

                    if State.PathingObjects.ForceSingleRun then

                        State.PathingObjects.PathRunning = false
                        State.PathingObjects.ForceSingleRun = false
                        State.PathingObjects.CurrentIndex = 1

                        if Toggles.StartPath then
                            pcall(function()
                                Toggles.StartPath:SetValue(false)
                            end)
                        end

                        funcs.UpdatePointCounter()

                        return
                    end

                    State.PathingObjects.CurrentIndex = 1

                end)
            end

        end
    )



Groupboxes.PathingToggles:AddToggle(
    "StartPath",
    {
        Text = "Start Path",
        Default = false,

        Callback = function(Value)
            if Value then
                funcs.StartPath(false)
            else
                funcs.StopPath()
            end
        end
    }
)

Groupboxes.PathingToggles:AddButton({
    Text = "Test Path",

    Func = function()
        if State.PathingObjects.PathRunning then
            funcs.Notify(
                "Test Path",
                "Stop the running path first."
            )

            return
        end

        funcs.StartPath(true)
    end
})


Groupboxes.PathingToggles:AddDivider()

State.PathingUI.PointCounterLabel =
    Groupboxes.PathingToggles:AddLabel(
        "Points: 0"
    )

Groupboxes.PathingSettings:AddSlider(
    "PointWait",
    {
        Text = "Create Point Wait",
        Default = 0,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Suffix = " sec",
        Compact = false
    }
)

Groupboxes.PathingSettings:AddSlider(
    "ResetTimer",
    {
        Text = "Reset Timer",
        Default = 1,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Suffix = " sec",
        Compact = false
    }
)

Groupboxes.PathingSettings:AddButton({
    Text = "Create Point",

    Func = function()
        funcs.AddPoint()
    end
}):AddKeyPicker(
    "CreatePointKey",
    {
        Default = "None",
        Mode = "Press",
        Text = "Create Point Key",
        NoUI = false
    }
)

Groupboxes.PathingSettings:AddButton({
    Text = "Wait For Reset Point",

    Func = function()
        funcs.SetLastPointReset()
    end
}):AddKeyPicker(
    "WaitResetKey",
    {
        Default = "None",
        Mode = "Press",
        Text = "Wait For Reset Key",
        NoUI = false
    }
)

Groupboxes.PathingSettings:AddButton({
    Text = "Remove Last Point",

    Func = function()
        funcs.RemoveLastPoint()
    end
})

Groupboxes.PathingSettings:AddButton({
    Text = "Clear Path",

    Func = function()
        funcs.ClearCurrentPath()
    end
})

Groupboxes.PathingSettings:AddToggle(
    "VisualizePoints",
    {
        Text = "Visualize Points",
        Default = true,

        Tooltip =
            "Shows points, numbers and path lines."
    }
):OnChanged(function()
    State.PathingObjects.VisualizePoints =
        Toggles.VisualizePoints.Value

    funcs.RedrawPath()
end)


State.PathingUI.PathNameInput =
    Groupboxes.PathManager:AddInput(
        "PathName",
        {
            Text = "Path Name",
            Default = "",
            Placeholder = "Path name...",
            Numeric = false,
            Finished = false,
            ClearTextOnFocus = false
        }
    )

Groupboxes.PathManager:AddButton({
    Text = "Save Path",

    Func = function()
        funcs.SaveCurrentPath()
    end
})

Groupboxes.PathManager:AddButton({
    Text = "Create New Path",

    Func = function()
        funcs.ClearCurrentPath()

        if State.PathingUI.PathNameInput then
            pcall(function()
                State.PathingUI.PathNameInput:SetValue("")
            end)
        end

        funcs.Notify(
            "Path",
            "Create new path mode"
        )
    end
})

State.PathingUI.SavedPathDropdown =
    Groupboxes.PathManager:AddDropdown(
        "SavedPaths",
        {
            Values = PathManager.GetPaths(),
            Default = nil,
            Multi = false,
            Text = "Saved Paths",
            Tooltip = "Saved paths as a list."
        }
    )

Groupboxes.PathManager:AddButton({
    Text = "Refresh Paths",

    Func = function()
        funcs.RefreshPaths()
    end
})

Groupboxes.PathManager:AddButton({
    Text = "Load Path",

    Func = function()
        funcs.LoadSelectedPath()
    end
})

Groupboxes.PathManager:AddButton({
    Text = "Remove Path",

    Func = function()
        funcs.RemoveSelectedPath()
    end
})



State.PathingUI.CurrentPointLabel =
    Groupboxes.PathingSettings:AddLabel(
        "Current Point: 0 / 0"
)


funcs.RedrawPath()

-- Library
Groupboxes.LibrarySystem = Tabs.LibraryTab:AddLeftGroupbox("UI Settings", "monitor")

Groupboxes.LibrarySystem:AddButton("Unload", function()

    funcs.UnloadPathing()
    funcs.RemovePlayerESP()
    funcs.UnloadMurdererESP()
    funcs.removeAllLabels()
    funcs.DisconnectAll()
    funcs.StopCoinTeleport()
    Library:Unload()

end)

Groupboxes.LibrarySystem:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Toggle UI",
    })

Library.ToggleKeybind = Options.MenuKeybind


-- Config
Library:Notify({
    Title = "MoonHub | Beta",
    Description = "Script Succesfully Executed.",
    Duration = 3
})

print(SaveManager.BuildConfigSection)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Themes")
SaveManager:SetFolder("PermaDeathEnjoyer/Configs")
SaveManager:SetSubFolder("MurderMystery2")

SaveManager:BuildConfigSection(Tabs.Config)

ThemeManager:ApplyToTab(Tabs.Config)

SaveManager:LoadAutoloadConfig()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
