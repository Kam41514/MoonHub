local repo = "https://raw.githubusercontent.com/Kam41514/Library/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "MoonHub | Beta",
    Footer = "Version: 1.0",
    NotifySide = "Left",
    Icon = 7743870134,
    ShowCustomCursor = true,
    Center = true,
})

-- Tabs
local Tabs = {
    Combat = Window:AddTab("Combat", "hand-fist"),
    Player = Window:AddTab("Player", "user"),
    World = Window:AddTab("World", "globe"),
    Visual = Window:AddTab("Visual", "eye"),
    Misc = Window:AddTab("Misc", "sparkles"),
    Exploits = Window:AddTab("Exploits", "terminal"),
    Notifications = Window:AddTab("Notifications", "bell"),
    LibraryTab = Window:AddTab("Library", "monitor"),
    Config = Window:AddTab("Config", "settings"),
}

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Imports
local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Functions/GameServices.lua"))()
local ConnectionManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Functions/ConnectionManager.lua"))()
local EventManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Functions/EventsManager.lua"))()
local GameFiles = {
    Debris = workspace:WaitForChild("Debris"),
    Ailments = Services.ReplicatedStorage:WaitForChild("Ailments"),
}

GameFiles.PlayerAilments = GameFiles.Ailments:FindFirstChild(Services.Players.LocalPlayer.Name)

local State = {}
local Modules = {}
local Groupboxes = {}
local funcs = {}
local BaseLocals = {}
local SupportServices = {}
local UI = {}

State.PlayerList = {}
function funcs.UpdatePlayerList()
    local newList = {}

    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= Services.Players.LocalPlayer then
            table.insert(newList, player.Name)
        end
    end

    State.PlayerList = newList
end



-- Combat Tab

Groupboxes.MouseControlling = Tabs.Combat:AddLeftGroupbox("Auto Clicking (Fixing)", "mouse")
Groupboxes.InfiniteScripts = Tabs.Combat:AddLeftGroupbox("Player Scripts", "user")
Groupboxes.Blocking = Tabs.Combat:AddRightGroupbox("Better Blocking", "user")
Groupboxes.Aimbot = Tabs.Combat:AddRightGroupbox("Silent Aim", "crosshair")

-- Blocking
State.AlwaysPb = false

function funcs.isPlayerAbleToBlock()
    if Services.Character and Services.Character:FindFirstChild("ragdolled") then
        return true
    end

    if Services.Stunned.Value == true then
        return true
    end

    if Services.Jailed.Value == true then
        return true
    end

    if Services.Knocked.Value == true then
        return true
    end

    if Services.Gripping.Value == true then
        return true
    end

    if Services.Invincible.Value == true then
        return true
    end

    return false
end

function funcs.updatePerfectBlock()
    if State.AlwaysPb and Services.Blocking.Value then
        Services.CanPerfectBlock.Value = true
    end
end

Groupboxes.Blocking:AddToggle("PerfectBlockToggle", {
    Text = "Always Perfect Block",
    Default = false,
    Tooltip = "Easier blocking (Press F to Parry)",

    Callback = function(Value)
        State.AlwaysPb = Value

        ConnectionManager.Disconnect("PerfectBlock")
        ConnectionManager.Disconnect("CanPerfectBlock")

        if Value then
            ConnectionManager.Connect(
                "PerfectBlock",
                Services.Blocking:GetPropertyChangedSignal("Value"),
                funcs.updatePerfectBlock
            )

            ConnectionManager.Connect(
                "CanPerfectBlock",
                Services.CanPerfectBlock:GetPropertyChangedSignal("Value"),
                funcs.updatePerfectBlock
            )

            funcs.updatePerfectBlock()
        end
    end,
})

-- Silent Aim

State.SilentAimSettings = {
    Enabled = false,
    ClassName = "Silent Aim",
    ToggleKey = "LeftAlt",

    VisibleCheck = false, 
    TargetPart = "HumanoidRootPart",
    
    FOVRadius = 130,
    FOVVisible = false,
    ShowSilentAimTarget = false, 
    
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100
}
local SilentAimGui = {}

SupportServices.GetChildren = game.GetChildren
SupportServices.GetPlayers = Services.Players.GetPlayers
SupportServices.WorldToScreen = Services.Camera.WorldToScreenPoint
SupportServices.WorldToViewportPoint = Services.Camera.WorldToViewportPoint
SupportServices.GetPartsObscuringTarget = Services.Camera.GetPartsObscuringTarget
SupportServices.FindFirstChild = game.FindFirstChild
SupportServices.RenderStepped = Services.RunService.RenderStepped
SupportServices.GuiInset = Services.GuiService.GetGuiInset
SupportServices.GetMouseLocation = Services.UserInputService.GetMouseLocation

State.ValidTargetParts = {"Head", "HumanoidRootPart"}
State.PredictionAmount = 1

SilentAimGui.fov_circle = Drawing.new("Circle")
SilentAimGui.fov_circle.Thickness = 1
SilentAimGui.fov_circle.NumSides = 100
SilentAimGui.fov_circle.Radius = 180
SilentAimGui.fov_circle.Filled = false
SilentAimGui.fov_circle.Visible = false
SilentAimGui.fov_circle.ZIndex = 999
SilentAimGui.fov_circle.Transparency = 1
SilentAimGui.fov_circle.Color = Color3.fromRGB(54, 57, 241)


function funcs.getPositionOnScreen(Vector)
    local Vec3, OnScreen = SupportServices.WorldToScreen(Services.Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

function funcs.getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

function funcs.getMousePosition()
    return SupportServices.GetMouseLocation(Services.UserInputService)
end

function funcs.IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = Services.LocalPlayer.Character
    
    if not (PlayerCharacter or LocalPlayerCharacter) then return end 
    
    local PlayerRoot = SupportServices.FindFirstChild(PlayerCharacter, Options.TargetPart.Value) or SupportServices.FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #SupportServices.GetPartsObscuringTarget(Services.Camera, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

function funcs.getClosestPlayer()
    if not Options.TargetPart.Value then
        return nil
    end

    local closest
    local closestDistance = Options.Radius.Value or 2000
    local mousePosition = funcs.getMousePosition()
    local targetPartOption = Options.TargetPart.Value
    local visibleCheck = Toggles.VisibleCheck.Value

    for _, player in next, SupportServices.GetPlayers(Services.Players) do
        if player == Services.LocalPlayer then
            continue
        end


        local character = player.Character
        if not character then
            continue
        end

        local humanoid = SupportServices.FindFirstChild(character, "Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            continue
        end

        local targetPartName = targetPartOption

        if targetPartName == "Random" then
            targetPartName = State.ValidTargetParts[
                math.random(1, #State.ValidTargetParts)
            ]
        end

        local targetPart = SupportServices.FindFirstChild(character, targetPartName)
        if not targetPart then
            continue
        end

        local screenPosition, onScreen =
            funcs.getPositionOnScreen(targetPart.Position)

        if not onScreen then
            continue
        end

        local distance = (mousePosition - screenPosition).Magnitude

        if distance < closestDistance then
            if not visibleCheck or funcs.IsPlayerVisible(player) then
                closest = targetPart
                closestDistance = distance
            end
        end
    end

    return closest
end


Groupboxes.Aimbot:AddToggle("aim_Enabled", {
    Text = "Silent Aim",
    Default = State.SilentAimSettings.Enabled
}):AddKeyPicker("aim_Enabled_KeyPicker", {
    Default = "LeftAlt",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Enabled",
    NoUI = false
})

Toggles.aim_Enabled:OnChanged(function()
    State.SilentAimSettings.Enabled = Toggles.aim_Enabled.Value
end)


Groupboxes.Aimbot:AddToggle("VisibleCheck", {
    Text = "Visible Check",
    Default = State.SilentAimSettings.VisibleCheck
})

Toggles.VisibleCheck:OnChanged(function()
    State.SilentAimSettings.VisibleCheck = Toggles.VisibleCheck.Value
end)

Groupboxes.Aimbot:AddDropdown("TargetPart", {
    AllowNull = true,
    Text = "Target Part",
    Default = State.SilentAimSettings.TargetPart,
    Values = {"Head", "HumanoidRootPart", "Random"}
})

Options.TargetPart:OnChanged(function()
    State.SilentAimSettings.TargetPart = Options.TargetPart.Value
end)

    
    Groupboxes.Aimbot:AddToggle("Visible", {
        Text = "Show FOV Circle",
        Default = State.SilentAimSettings.FOVVisible
    }):AddColorPicker("Color", {
        Default = Color3.fromRGB(54, 57, 241)
    })

    Toggles.Visible:OnChanged(function()
        SilentAimGui.fov_circle.Visible = Toggles.Visible.Value
        State.SilentAimSettings.FOVVisible = Toggles.Visible.Value
    end)

    Options.Color:OnChanged(function()
         SilentAimGui.fov_circle.Color = Options.Color.Value
    end)

    Groupboxes.Aimbot:AddSlider("Radius", {
        Text = "FOV Circle Radius",
        Min = 0,
        Max = 480,
        Default = State.SilentAimSettings.FOVRadius,
        Rounding = 0
    })

    Options.Radius:OnChanged(function()
        SilentAimGui.fov_circle.Radius = Options.Radius.Value
        State.SilentAimSettings.FOVRadius = Options.Radius.Value
    end)



ConnectionManager.Connect("SilentAim.RenderStepped", SupportServices.RenderStepped, function()
    local AimToggle = Toggles.aim_Enabled
    local VisibleToggle = Toggles.Visible

    if not AimToggle then
        return
    elseif AimToggle.Value then
        local Target = funcs.getClosestPlayer()

        if Target then
            local Root = Target.Parent.PrimaryPart or Target
            local RootToViewportPoint, IsOnScreen =
                SupportServices.WorldToViewportPoint(
                    Services.Camera,
                    Root.Position
                )

            if IsOnScreen then
                local Position = Vector2.new(
                    RootToViewportPoint.X,
                    RootToViewportPoint.Y
                )
            end
        end
    end

    if not VisibleToggle or not VisibleToggle.Value then
        SilentAimGui.fov_circle.Visible = false
        return
    end

    SilentAimGui.fov_circle.Visible = true
    SilentAimGui.fov_circle.Color = Options.Color.Value
    SilentAimGui.fov_circle.Position = funcs.getMousePosition()
end)






local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if self == Services.Mouse and not checkcaller() and Toggles.aim_Enabled.Value and funcs.getClosestPlayer() then
        local HitPart = funcs.getClosestPlayer()
         
        if Index == "Target" or Index == "target" then 
            return HitPart
        elseif Index == "Hit" or Index == "hit" then 
            return HitPart.CFrame
        elseif Index == "X" or Index == "x" then 
            return self.X 
        elseif Index == "Y" or Index == "y" then 
            return self.Y 
        elseif Index == "UnitRay" then 
            return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
        end
    end

    return oldIndex(self, Index)
end))



-- No Stun
State.OriginSpeed = 16
State.NoSlowdownSpeed = 8
State.NoStunEnabled = false
State.NoSlowdownEnabled = false

function funcs.NoStun()
    ConnectionManager.Connect("NoStun", game:GetService("RunService").Heartbeat, function()
        if State.NoStunEnabled and Services.Stunned.Value then
            Services.Stunned.Value = false
        end
    end)
end

function funcs.GetPlayerSpeed()
    if not Services.Humanoid then
        return nil
    end

    return Services.Humanoid.WalkSpeed
end

function funcs.NoSlowdown()
    ConnectionManager.Connect("NoSlowdown", Services.RunService.Heartbeat, function()
        if not Services.Humanoid or not Services.Humanoid.RootPart then
            return
        end

        local RootPart = Services.Humanoid.RootPart
        local Velocity = RootPart:FindFirstChild("NoSlowdownVelocity")
        local Attachment = RootPart:FindFirstChild("NoSlowdownAttachment")

        if not State.NoSlowdownEnabled then
            if Velocity then
                Velocity:Destroy()
            end

            if Attachment then
                Attachment:Destroy()
            end

            return
        end

        if Services.Humanoid.WalkSpeed >= State.NoSlowdownSpeed then
            if Velocity then
                Velocity:Destroy()
            end

            if Attachment then
                Attachment:Destroy()
            end

            return
        end

        if not Attachment then
            Attachment = Instance.new("Attachment")
            Attachment.Name = "NoSlowdownAttachment"
            Attachment.Parent = RootPart
        end

        if not Velocity then
            Velocity = Instance.new("LinearVelocity")
            Velocity.Name = "NoSlowdownVelocity"
            Velocity.Attachment0 = Attachment
            Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
            Velocity.ForceLimitsEnabled = true
            Velocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            Velocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
            Velocity.Parent = RootPart
        end

        local Direction = Services.Humanoid.MoveDirection

        Velocity.VectorVelocity = Vector3.new(
            Direction.X * State.NoSlowdownSpeed,
            0,
            Direction.Z * State.NoSlowdownSpeed
        )
    end)
end


function funcs.RemoveAttachments(attachment)
    if not Services.Humanoid or not Services.Humanoid.RootPart then
        return
    end

    local Object = Services.Humanoid.RootPart:FindFirstChild(attachment)

    if Object then
        Object:Destroy()
    end
end

Groupboxes.InfiniteScripts:AddToggle("NoStunToggle", {
    Text = "No Stun",
    Default = false,

    Callback = function(Value)
        State.NoStunEnabled = Value

        if Value then
            funcs.NoStun()
        else
            ConnectionManager.Disconnect("NoStun")
        end
    end,
})

Modules.SpeedSlider = Groupboxes.InfiniteScripts:AddSlider("SpeedSlider", {
    Text = "No Slowdown Speed",
    Default = 8,
    Min = 2,
    Max = 16,
    Rounding = 0,

    Callback = function(Value)
        State.NoSlowdownSpeed = Value
    end
})


Groupboxes.InfiniteScripts:AddToggle("NoStunToggle", {
    Text = "No Slowdown",
    Default = false,

    Callback = function(Value)
        State.NoSlowdownEnabled = Value

        if Value then
            funcs.NoSlowdown()
        else
            ConnectionManager.Disconnect("NoSlowdown")

            if Services.Humanoid and Services.Humanoid.RootPart then
                local Velocity = Services.Humanoid.RootPart:FindFirstChild("NoSlowdownVelocity")
                local Attachment = Services.Humanoid.RootPart:FindFirstChild("NoSlowdownAttachment")

                if Velocity then
                    Velocity:Destroy()
                end

                if Attachment then
                    Attachment:Destroy()
                end
            end
        end
    end,
})

-- No Fire

State.NoFireEnabled = false


function funcs.CheckAilmentFire(child)
    if not State.NoFireEnabled then
        return
    end

    if not child then
        return
    end

    if child.Name ~= "Fire" then
        return
    end

    EventManager:FireServer("RemoveFireAilment")
end


function funcs.SetupAilmentFireListener()
    ConnectionManager.Disconnect("AilmentFire_Added")

    if not State.NoFireEnabled then
        return
    end

    local Player = Services.Players.LocalPlayer

    -- PlayerAilments yoksa tekrar bul
    if not GameFiles.PlayerAilments
        or not GameFiles.PlayerAilments.Parent then

        GameFiles.PlayerAilments =
            GameFiles.Ailments:FindFirstChild(Player.Name)
    end

    if not GameFiles.PlayerAilments then
        return
    end

    local PlayerAilments = GameFiles.PlayerAilments

    -- Listener açıldığında zaten Fire varsa
    local Fire = PlayerAilments:FindFirstChild("Fire")

    if Fire then
        funcs.CheckAilmentFire(Fire)
    end

    ConnectionManager.Connect(
        "AilmentFire_Added",
        PlayerAilments.ChildAdded,
        function(child)
            if not State.NoFireEnabled then
                return
            end

            funcs.CheckAilmentFire(child)
        end
    )
end


function funcs.StartBurnListener()
    ConnectionManager.Disconnect("AilmentFire_Added")
    ConnectionManager.Disconnect("AilmentFire_CharacterAdded")

    State.NoFireEnabled = true

    GameFiles.PlayerAilments =
        GameFiles.Ailments:FindFirstChild(
            Services.Players.LocalPlayer.Name
        )

    funcs.SetupAilmentFireListener()

    ConnectionManager.Connect(
        "AilmentFire_CharacterAdded",
        Services.Players.LocalPlayer.CharacterAdded,
        function()
            if not State.NoFireEnabled then
                return
            end

            task.wait(0.1)

            if not State.NoFireEnabled then
                return
            end

            GameFiles.PlayerAilments =
                GameFiles.Ailments:FindFirstChild(
                    Services.Players.LocalPlayer.Name
                )

            funcs.SetupAilmentFireListener()
        end
    )
end


function funcs.StopBurnListener()
    ConnectionManager.Disconnect("AilmentFire_Added")
    ConnectionManager.Disconnect("AilmentFire_CharacterAdded")

    State.NoFireEnabled = false
end


Groupboxes.InfiniteScripts:AddToggle(
    "NoFirePlayer",
    {
        Text = "No Fire",
        Default = false,

        Callback = function(Value)
            State.NoFireEnabled = Value

            if Value then
                funcs.StartBurnListener()
            else
                funcs.StopBurnListener()
            end
        end
    }
)

State.InitialJumpCount = nil
State.JumpCounters = Services.ReplicatedStorage.Settings[Services.Players.LocalPlayer.Name].JumpCounters

Modules.InfiniteStamina =
    Groupboxes.InfiniteScripts:AddToggle(
        "InfiniteStamina",
        {
            Text = "Infinite Stamina",
            Default = false,
        }
    ):OnChanged(function()

        ConnectionManager.Disconnect("InfiniteStamina")

        if not Toggles.InfiniteStamina.Value then
            State.InitialJumpCount = nil
            return
        end

        BaseLocals.currentValue = State.JumpCounters.Value

        if BaseLocals.currentValue <= 0 then
            State.InitialJumpCount = 1
        else
            State.InitialJumpCount = BaseLocals.currentValue
        end

        ConnectionManager.Connect(
            "InfiniteStamina",
            Services.RunService.Heartbeat,
            function()

                if not Toggles.InfiniteStamina.Value then
                    ConnectionManager.Disconnect("InfiniteStamina")
                    State.InitialJumpCount = nil
                    return
                end

                if State.JumpCounters then
                    State.JumpCounters.Value =
                        State.InitialJumpCount
                end

            end
        )

    end)

-- Player
Groupboxes.IdentitySpoofer = Tabs.Player:AddLeftGroupbox("Identity Spoofer", "scan-face")
Groupboxes.ProximityDetector = Tabs.Player:AddRightGroupbox("Proximity Detector", "bot")
Groupboxes.ExtrasPlayer = Tabs.Player:AddRightGroupbox("Extras", "user")

-- Scripts For Player Tab
State.HUDPlayerName =
    Services.Players.LocalPlayer
        :WaitForChild("PlayerGui")
        :WaitForChild("ClientGui")
        :WaitForChild("Mainframe")
        :WaitForChild("Loadout")
        :WaitForChild("HUD")
        :WaitForChild("PlayerName")

State.HUDPlayerNameOriginal =
    State.HUDPlayerName.Text

State.HUDPlayerNameCustom =
    State.HUDPlayerNameOriginal

State.HairParts = {}
State.HairHidden = false

State.IconLabelOriginalTexts = {}
State.CustomIconNameEnabled = false
State.IconNameInput = nil


--// Master Toggle
Groupboxes.IdentitySpoofer:AddToggle("IdentitySpooferMaster", {
    Text = "Identity Spoofer",
    Default = false,
})


--// HUD Player Name Input
Groupboxes.IdentitySpoofer:AddInput("HUDPlayerNameInput", {
    Default = "",
    Text = "HUD Player Name",
    Placeholder = "Custom Name",
})


--// HUD Player Name Toggle
Groupboxes.IdentitySpoofer:AddToggle("HUDPlayerNameToggle", {
    Text = "Custom HUD Name",
    Default = false,
})


--// Icon Label Functions
function funcs.UpdateIconLabels(Text)
    local PlayerGui =
        Services.Players.LocalPlayer:WaitForChild("PlayerGui")

    for _, object in ipairs(PlayerGui:GetDescendants()) do
        if object.Name == "IconLabel"
            and object:IsA("TextLabel")
        then
            if State.IconLabelOriginalTexts[object] == nil then
                State.IconLabelOriginalTexts[object] =
                    object.Text
            end

            object.Text = Text
        end
    end
end


function funcs.RestoreIconLabels()
    for object, OriginalText in pairs(
        State.IconLabelOriginalTexts
    ) do
        if object and object.Parent then
            object.Text = OriginalText
        end
    end

    table.clear(State.IconLabelOriginalTexts)
end


--// Custom Icon Text
State.IconNameInput =
    Groupboxes.IdentitySpoofer:AddInput("IconNameInput", {
        Text = "Custom Topbar Text",
        Default = "",
        Placeholder = "Custom Topbar Text",

        Callback = function(Value)
            if not Toggles.IdentitySpooferMaster.Value then
                return
            end

            if State.CustomIconNameEnabled then
                funcs.UpdateIconLabels(Value)
            end
        end,
    })


--// Custom Icon Text Toggle
Groupboxes.IdentitySpoofer:AddToggle("CustomIconNameToggle", {
    Text = "Custom Topbar Text",
    Default = false,

    Tooltip =
        "Changes the top left LocalPlayer | LocalPlayer ID text.",

    Callback = function(Value)
        State.CustomIconNameEnabled = Value

        if Value then
            if Toggles.IdentitySpooferMaster.Value then
                funcs.UpdateIconLabels(
                    State.IconNameInput.Value
                )
            end
        else
            funcs.RestoreIconLabels()
        end
    end,
})


--// Hide Hair
Groupboxes.IdentitySpoofer:AddToggle("HideHair", {
    Text = "Hide Hair",
    Default = false,
})


function funcs.FindHairObjects()

    if not Services.Character then
        return {}
    end

    local hairs = {}

    for _, object in ipairs(
        Services.Character:GetDescendants()
    ) do

        if object.Name:match("^Hair%d+$")
            and object:IsA("BasePart")
        then
            table.insert(hairs, object)
        end

    end

    return hairs
end


function funcs.SetHairVisibility(hidden)

    if hidden then

        for _, hair in ipairs(
            funcs.FindHairObjects()
        ) do

            if State.HairParts[hair] == nil then
                State.HairParts[hair] =
                    hair.LocalTransparencyModifier
            end

            hair.LocalTransparencyModifier = 1
        end

    else

        for object, transparency in pairs(
            State.HairParts
        ) do

            if object and object.Parent then
                object.LocalTransparencyModifier =
                    transparency
            end

        end

        table.clear(State.HairParts)
    end
end


--// Unload
funcs.UnloadIdentitySpoofer = function()

    ConnectionManager.Disconnect("HUDPlayerNameHeartbeat")
    ConnectionManager.Disconnect("HideHairHeartbeat")

    if State.HUDPlayerName
        and State.HUDPlayerName.Parent
    then
        State.HUDPlayerName.Text =
            State.HUDPlayerNameOriginal
    end

    funcs.RestoreIconLabels()

    if State.HairParts then

        for object, transparency in pairs(
            State.HairParts
        ) do

            if object and object.Parent then
                object.LocalTransparencyModifier =
                    transparency
            end

        end

        table.clear(State.HairParts)
    end

    State.HairHidden = false
    State.CustomIconNameEnabled = false
end


--// HUD Name Input Changed
Options.HUDPlayerNameInput:OnChanged(function()

    State.HUDPlayerNameCustom =
        Options.HUDPlayerNameInput.Value

    if Toggles.IdentitySpooferMaster.Value
        and Toggles.HUDPlayerNameToggle.Value
    then

        if State.HUDPlayerName
            and State.HUDPlayerName.Parent
        then
            State.HUDPlayerName.Text =
                State.HUDPlayerNameCustom
        end

    end
end)


--// HUD Name Toggle Changed
Toggles.HUDPlayerNameToggle:OnChanged(function()

    ConnectionManager.Disconnect("HUDPlayerNameHeartbeat")

    if Toggles.IdentitySpooferMaster.Value
        and Toggles.HUDPlayerNameToggle.Value
    then

        if State.HUDPlayerName
            and State.HUDPlayerName.Parent
        then
            State.HUDPlayerName.Text =
                State.HUDPlayerNameCustom
        end

        ConnectionManager.Connect(
            "HUDPlayerNameHeartbeat",
            Services.RunService.Heartbeat,

            function()

                if not Toggles.IdentitySpooferMaster.Value
                    or not Toggles.HUDPlayerNameToggle.Value
                then
                    return
                end

                if State.HUDPlayerName
                    and State.HUDPlayerName.Parent
                then

                    if State.HUDPlayerName.Text
                        ~= State.HUDPlayerNameCustom
                    then
                        State.HUDPlayerName.Text =
                            State.HUDPlayerNameCustom
                    end

                end

            end
        )

    else

        if State.HUDPlayerName
            and State.HUDPlayerName.Parent
        then
            State.HUDPlayerName.Text =
                State.HUDPlayerNameOriginal
        end

    end
end)


--// Hide Hair Toggle Changed
Toggles.HideHair:OnChanged(function()

    ConnectionManager.Disconnect("HideHairHeartbeat")

    if Toggles.IdentitySpooferMaster.Value
        and Toggles.HideHair.Value
    then

        State.HairHidden = true

        funcs.SetHairVisibility(true)

        ConnectionManager.Connect(
            "HideHairHeartbeat",
            Services.RunService.Heartbeat,

            function()

                if not Toggles.IdentitySpooferMaster.Value
                    or not Toggles.HideHair.Value
                then
                    return
                end

                for _, hair in ipairs(
                    funcs.FindHairObjects()
                ) do

                    if State.HairParts[hair] == nil then
                        State.HairParts[hair] =
                            hair.LocalTransparencyModifier
                    end

                    if hair.LocalTransparencyModifier ~= 1 then
                        hair.LocalTransparencyModifier = 1
                    end

                end

            end
        )

    else

        State.HairHidden = false

        funcs.SetHairVisibility(false)

    end
end)


--// Master Toggle Changed
Toggles.IdentitySpooferMaster:OnChanged(function()

    if not Toggles.IdentitySpooferMaster.Value then

        ConnectionManager.Disconnect("HUDPlayerNameHeartbeat")
        ConnectionManager.Disconnect("HideHairHeartbeat")

        if State.HUDPlayerName
            and State.HUDPlayerName.Parent
        then
            State.HUDPlayerName.Text =
                State.HUDPlayerNameOriginal
        end

        State.HairHidden = false

        funcs.SetHairVisibility(false)

        funcs.RestoreIconLabels()

        return
    end


    -- HUD Player Name
    if Toggles.HUDPlayerNameToggle.Value then

        if State.HUDPlayerName
            and State.HUDPlayerName.Parent
        then
            State.HUDPlayerName.Text =
                State.HUDPlayerNameCustom
        end

        ConnectionManager.Disconnect("HUDPlayerNameHeartbeat")

        ConnectionManager.Connect(
            "HUDPlayerNameHeartbeat",
            Services.RunService.Heartbeat,

            function()

                if not Toggles.IdentitySpooferMaster.Value
                    or not Toggles.HUDPlayerNameToggle.Value
                then
                    return
                end

                if State.HUDPlayerName
                    and State.HUDPlayerName.Parent
                then

                    if State.HUDPlayerName.Text
                        ~= State.HUDPlayerNameCustom
                    then
                        State.HUDPlayerName.Text =
                            State.HUDPlayerNameCustom
                    end

                end

            end
        )

    end


    -- Custom Icon Text
    if Toggles.CustomIconNameToggle.Value then

        State.CustomIconNameEnabled = true

        funcs.UpdateIconLabels(
            State.IconNameInput.Value
        )

    end


    -- Hide Hair
    if Toggles.HideHair.Value then

        State.HairHidden = true

        funcs.SetHairVisibility(true)

        ConnectionManager.Disconnect("HideHairHeartbeat")

        ConnectionManager.Connect(
            "HideHairHeartbeat",
            Services.RunService.Heartbeat,

            function()

                if not Toggles.IdentitySpooferMaster.Value
                    or not Toggles.HideHair.Value
                then
                    return
                end

                for _, hair in ipairs(
                    funcs.FindHairObjects()
                ) do

                    if State.HairParts[hair] == nil then
                        State.HairParts[hair] =
                            hair.LocalTransparencyModifier
                    end

                    if hair.LocalTransparencyModifier ~= 1 then
                        hair.LocalTransparencyModifier = 1
                    end

                end

            end
        )

    end
end)

function funcs.AutoLogKick(Player, Distance)

    if not State.AutoLog then
        return
    end

    Library:Notify({
        Title = "Auto Log",
        Description = Player.Name
            .. " detected at ["
            .. math.floor(Distance)
            .. "]",
        Time = 2
    })

    task.wait(0.1)

    Services.LocalPlayer:Kick(
        "Auto Log: "
        .. Player.Name
        .. " detected within "
        .. math.floor(Distance)
        .. " studs."
    )
end

State.ProximityCheck = false
State.ProximityDistance = 375
Groupboxes.ProximityDetector:AddSlider(
    "ProximityDistance",
    {
        Text = "Proximity Check Distance",
        Default = 375,
        Min = 100,
        Max = 2000,
        Rounding = 0,

        Callback = function(Value)
            State.ProximityDistance = Value
        end
    }
)

Toggles.ProximityCheck = Groupboxes.ProximityDetector:AddToggle(
    "ProximityCheck",
    {
        Text = "Proximity Check",
        Default = false,

        Callback = function(Value)
            State.ProximityCheck = Value

            if ProximityLabel then
                ProximityLabel.Visible = false
            end
        end
    }
)

Toggles.AutoLogToggle = Groupboxes.ProximityDetector:AddToggle(
    "AutoLogToggle",
    {
        Text = "Auto Log",
        Default = false,

        Callback = function(Value)
            State.AutoLog = Value
        end
    }
)


UI.ProximityGui = nil
UI.ProximityLabel = nil

State.LastAutoLog = 0
State.AutoLogCooldown = 3


function funcs.CreateProximityUI()

    if UI.ProximityGui then
        return
    end

    UI.ProximityGui = Instance.new("ScreenGui")
    UI.ProximityGui.Name = "ProximityStatus"
    UI.ProximityGui.ResetOnSpawn = false
    UI.ProximityGui.IgnoreGuiInset = true
    UI.ProximityGui.Parent =
        Services.LocalPlayer:WaitForChild("PlayerGui")


    UI.ProximityLabel = Instance.new("TextLabel")
    UI.ProximityLabel.Name = "ProximityLabel"

    UI.ProximityLabel.AnchorPoint =
        Vector2.new(0.5, 0)

    UI.ProximityLabel.Position =
        UDim2.new(0.5, 0, 0, 110)

    UI.ProximityLabel.Size =
        UDim2.new(0, 400, 0, 70)

    UI.ProximityLabel.BackgroundTransparency = 1

    UI.ProximityLabel.Font =
        Enum.Font.GothamBold

    UI.ProximityLabel.TextSize = 30

    UI.ProximityLabel.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    UI.ProximityLabel.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    UI.ProximityLabel.TextStrokeTransparency = 0

    UI.ProximityLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    UI.ProximityLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    UI.ProximityLabel.Visible = false

    UI.ProximityLabel.Parent =
        UI.ProximityGui
end


funcs.CreateProximityUI()


ConnectionManager.Connect(
    "Proximity_Heartbeat",
    Services.RunService.Heartbeat,
    function()

        local Character =
            Services.LocalPlayer.Character

        if not Character then

            if UI.ProximityLabel then
                UI.ProximityLabel.Visible = false
            end

            return
        end


        local MyRoot = Character:FindFirstChild("HumanoidRootPart")

        if not MyRoot then

            if UI.ProximityLabel then
                UI.ProximityLabel.Visible = false
            end

            return
        end


        local closestPlayer = nil
        local closestDistance = math.huge


        for _, Player in ipairs(
            Services.Players:GetPlayers()
        ) do

            if Player ~= Services.LocalPlayer
                and Player.Character then

                local TheirRoot =
                    Player.Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if TheirRoot then

                    local Distance =
                        (
                            MyRoot.Position
                            - TheirRoot.Position
                        ).Magnitude

                    if Distance <= State.ProximityDistance
                        and Distance < closestDistance then

                        closestDistance = Distance
                        closestPlayer = Player

                    end
                end
            end
        end

        if State.ProximityCheck
            and closestPlayer
            and UI.ProximityLabel then

            UI.ProximityLabel.Text =
                closestPlayer.Name
                .. " On Distance ["
                .. math.floor(closestDistance)
                .. "]"

            UI.ProximityLabel.Visible = true

        elseif UI.ProximityLabel then

            UI.ProximityLabel.Visible = false

        end


        if State.AutoLog
            and closestPlayer then

            local currentTime = tick()

            if currentTime - State.LastAutoLog
                >= State.AutoLogCooldown then

                State.LastAutoLog = currentTime

                funcs.AutoLogKick(
                    closestPlayer,
                    closestDistance
                )
            end
        end
    end
)

Groupboxes.ExtrasPlayer:AddButton({
    Text = "Reset Character",

    Func = function()

        if Services.Character then
            Services.Character:BreakJoints()
        end

    end
})

Groupboxes.ExtrasPlayer:AddButton({
    Text = "Kick Yourself",
    Func = function()
        Services.Players.LocalPlayer:Kick(
            "MoonHub\nYou have been kicked from the game."
        )
    end,
    Tooltip = "Kick yourself from the current game.",
    Confirm = true,
})


-- World
Groupboxes.WorldRight = Tabs.World:AddRightGroupbox("Transparency Settings", "eye")
Groupboxes.WorldLeft = Tabs.World:AddLeftGroupbox("World Settings", "globe")

getgenv().NewNoFallEnabled = false

if not getgenv().NewNoFallHookInstalled then

    local oldNamecall

    oldNamecall = hookmetamethod(
        game,
        "__namecall",
        function(self, ...)

            local method =
                getnamecallmethod()

            if method == "FindFirstChild"
                and getgenv().NewNoFallEnabled then

                local args = {...}

                if args[1] == "NegateFall" then
                    return true
                end
            end

            return oldNamecall(
                self,
                ...
            )
        end
    )

    getgenv().NewNoFallOldNamecall =
        oldNamecall

    getgenv().NewNoFallHookInstalled =
        true
end


Modules.NewNoFallToggle =
    Groupboxes.WorldLeft:AddToggle(
        "NewNoFallToggle",
        {
            Text = "No Fall Damage",
            Default = false,

            Callback = function(Value)

                getgenv().NewNoFallEnabled =
                    Value

            end
        }
    )




-- Visual
Groupboxes.VisualWorld = Tabs.Visual:AddRightGroupbox("Lighting Settings", "lightbulb")
State.BrightnessLevel = State.BrightnessLevel or 2
State.FullBrightEnabled = State.FullBrightEnabled or false
State.FullBrightConnection = nil
State.OldBrightness = nil

Groupboxes.VisualWorld:AddSlider("BrightnessLevel", {
    Text = "Brightness",
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,

    Callback = function(Value)
        State.BrightnessLevel = Value

        if State.FullBrightEnabled then
            Services.Lighting.Brightness = Value
        end
    end
})


function funcs.fullBright(state)

    State.FullBrightEnabled = state

    if State.FullBrightConnection then
        State.FullBrightConnection:Disconnect()
        State.FullBrightConnection = nil
    end

    if state then

        State.OldBrightness = Services.Lighting.Brightness

        Services.Lighting.Brightness = State.BrightnessLevel

        State.FullBrightConnection =
            Services.RunService.RenderStepped:Connect(function()

                if not State.FullBrightEnabled then
                    return
                end

                Services.Lighting.Brightness = State.BrightnessLevel

            end)

    else

        if State.OldBrightness ~= nil then
            Services.Lighting.Brightness = State.OldBrightness
            State.OldBrightness = nil
        end

    end
end

funcs.noRain = function(state)
	if not state then
		if BaseLocals.noRainLoop then
			task.cancel(BaseLocals.noRainLoop)
			BaseLocals.noRainLoop = nil
		end

		return
	end

	BaseLocals.noRainLoop = task.spawn(function()
		while true do
			Services.ReplicatedStorage.Raining.Value = ""
			task.wait()
		end
	end)
end


Groupboxes.VisualWorld:AddToggle(
    "FullBright",
    {
        Text = "Full Bright",
        Default = false,
    }
):OnChanged(function()
    funcs.fullBright(Toggles.FullBright.Value)
end)

State.noFogConnection = nil
State.oldFogEnd = nil

Groupboxes.VisualWorld:AddToggle("NoFog", {
	Text = "No Fog",
	Default = false,

	Callback = function(state)
		ConnectionManager.DisconnectPrefix("NoFog.")

		if state then
			State.oldFogEnd = Services.Lighting.FogEnd

			Services.Lighting.FogEnd = 9999999999

			ConnectionManager.Connect("NoFog.FogEnd",
				Services.Lighting:GetPropertyChangedSignal("FogEnd"),
				function()
					Services.Lighting.FogEnd = 9999999999
				end
			)

			ConnectionManager.Connect("NoFog.PointBlur",
				game:GetService("RunService").Heartbeat,
				function()
					if Services.Lighting:FindFirstChild("PointBlur") then
						Services.Lighting.PointBlur.Enabled = false
					end
				end
			)

		else
			if State.oldFogEnd ~= nil then
				Services.Lighting.FogEnd = State.oldFogEnd
				State.oldFogEnd = nil
			end
		end
	end
})




Modules.NoRainToggle = Groupboxes.VisualWorld:AddToggle("NoRain", {
	Text = "No Rain",
	Default = false
})

Modules.NoRainToggle:OnChanged(function(Value)
	funcs.noRain(Value)
end)

-- Misc
Groupboxes.ServerSystems = Tabs.Misc:AddLeftGroupbox("Server Systems", "server")
Groupboxes.LeftGroupBox = Tabs.Misc:AddLeftGroupbox("Executable Scripts", "code")
Groupboxes.RightGroupBox = Tabs.Misc:AddRightGroupbox("Player Systems", "user")

State.ServerFilter = {
    ServerName = "",
    MaxPlayers = 20,
    Regions = {}
}

State.AttemptedServers = {}
State.PlayerList = State.PlayerList or {}
State.SelectedPlayer = State.SelectedPlayer or ""

State.ServerList =
    Services.LocalPlayer.PlayerGui.ClientGui.Mainframe.Rest.ServerList.BackDrop.List


Modules.ServerNameInput =
    Groupboxes.ServerSystems:AddInput(
        "ServerNameInput",
        {
            Text = "Server Name",
            Description = "Server Name",
            Default = "",
            Placeholder = "Server Name",
            Numeric = false,
            Finished = false,

            Callback = function(Value)
                State.ServerFilter.ServerName =
                    tostring(Value or ""):lower()
            end
        }
    )


Modules.MaxPlayersSlider =
    Groupboxes.ServerSystems:AddSlider(
        "MaxPlayersSlider",
        {
            Text = "Max Players",
            Description = "Select the max player value to hop server",
            Default = 20,
            Min = 1,
            Max = 20,
            Rounding = 0,

            Callback = function(Value)
                State.ServerFilter.MaxPlayers =
                    tonumber(Value) or 20
            end
        }
    )


Modules.RegionDropdown =
    Groupboxes.ServerSystems:AddDropdown(
        "RegionDropdown",
        {
            Text = "Server Region",
            Description = "You can select multiple regions.",
            Values = {
                "Netherlands",
                "Germany",
                "Singapore",
                "United States",
                "Brazil",
                "Poland",
                "South Africa"
            },
            Multi = true,
            Default = {},

            Callback = function(Value)
                State.ServerFilter.Regions =
                    Value or {}
            end
        }
    )


function funcs.GetText(Object)
    if not Object then
        return ""
    end

    if Object:IsA("TextLabel")
        or Object:IsA("TextButton")
        or Object:IsA("TextBox")
    then
        return tostring(Object.Text or "")
    end

    return ""
end


function funcs.GetServerKey(serverTemplate)
    if not serverTemplate then
        return ""
    end

    local serverName =
        funcs.GetText(
            serverTemplate:FindFirstChild("ServerName")
        )

    local serverRegion =
        funcs.GetText(
            serverTemplate:FindFirstChild("ServerRegion")
        )

    local players =
        funcs.GetText(
            serverTemplate:FindFirstChild("Players")
        )

    return (
        serverName
        .. "|"
        .. serverRegion
        .. "|"
        .. players
    ):lower()
end


function funcs.RegionMatches(serverTemplate)
    if not serverTemplate then
        return false
    end

    local playersLabel =
        serverTemplate:FindFirstChild("Players")

    local regionLabel =
        serverTemplate:FindFirstChild("ServerRegion")

    local playerText =
        funcs.GetText(playersLabel)

    local currentPlayers =
        tonumber(
            playerText:match("%d+")
        )

    if currentPlayers
        and currentPlayers > State.ServerFilter.MaxPlayers
    then
        return false
    end

    local selectedRegions =
        State.ServerFilter.Regions or {}

    local hasRegionFilter = false

    for _, enabled in pairs(selectedRegions) do
        if enabled then
            hasRegionFilter = true
            break
        end
    end

    if hasRegionFilter then
        local currentRegion =
            funcs.GetText(regionLabel):lower()

        local regionAllowed = false

        for region, enabled in pairs(selectedRegions) do
            if enabled then
                local regionValue =
                    tostring(region):lower()

                if string.find(
                    currentRegion,
                    regionValue,
                    1,
                    true
                ) then
                    regionAllowed = true
                    break
                end
            end
        end

        if not regionAllowed then
            return false
        end
    end

    return true
end


function funcs.ServerNameMatches(serverTemplate)
    if not serverTemplate then
        return false
    end

    local serverName =
        serverTemplate:FindFirstChild("ServerName")

    local wantedName =
        State.ServerFilter.ServerName or ""

    if wantedName == "" then
        return false
    end

    local currentName =
        funcs.GetText(serverName):lower()

    return string.find(
        currentName,
        wantedName,
        1,
        true
    ) ~= nil
end


function funcs.TryJoinServer(
    serverTemplate,
    useServerName
)
    if not serverTemplate
        or serverTemplate.Name ~= "ServerTemplate"
    then
        return false
    end

    local serverKey =
        funcs.GetServerKey(serverTemplate)

    if serverKey == ""
        or State.AttemptedServers[serverKey]
    then
        return false
    end

    if useServerName then
        if not funcs.ServerNameMatches(serverTemplate) then
            return false
        end
    else
        if not funcs.RegionMatches(serverTemplate) then
            return false
        end
    end

    local joinButton =
        serverTemplate:FindFirstChild("JoinButton")

    if not joinButton
        or not joinButton:IsA("TextButton")
    then
        return false
    end

    local success, connections =
        pcall(function()
            return getconnections(
                joinButton.MouseButton1Click
            )
        end)

    if not success or not connections then
        return false
    end

    for _, connection in ipairs(connections) do
        if connection.Function then
            State.AttemptedServers[serverKey] = true

            local serverName =
                funcs.GetText(
                    serverTemplate:FindFirstChild("ServerName")
                )

            local players =
                funcs.GetText(
                    serverTemplate:FindFirstChild("Players")
                )

            local region =
                funcs.GetText(
                    serverTemplate:FindFirstChild("ServerRegion")
                )

            print(
                "[ServerSystems] Joining:",
                serverName,
                players,
                region
            )

            Library:Notify({
                Title = "Server Systems",
                Description =
                    "Joining: "
                    .. serverName
                    .. " | "
                    .. players
                    .. " | "
                    .. region,
                Time = 3
            })

            task.spawn(function()
                pcall(function()
                    connection.Function()
                end)
            end)

            return true
        end
    end

    return false
end


Modules.ServerHopButton =
    Groupboxes.ServerSystems:AddButton(
        {
            Text = "Server Hop",

            Func = function()
                State.AttemptedServers = {}

                if not State.ServerList
                    or not State.ServerList.Parent
                then
                    return
                end

                for _, serverTemplate in ipairs(
                    State.ServerList:GetChildren()
                ) do
                    if serverTemplate.Name == "ServerTemplate" then
                        if funcs.TryJoinServer(
                            serverTemplate,
                            false
                        ) then
                            break
                        end
                    end
                end
            end
        }
    )


Modules.JoinWithNameButton =
    Groupboxes.ServerSystems:AddButton(
        {
            Text = "Join With Server Name",
            Description = "It's still on beta it can be buggy.",

            Func = function()
                if State.ServerFilter.ServerName == "" then
                    return
                end

                State.AttemptedServers = {}

                if not State.ServerList
                    or not State.ServerList.Parent
                then
                    return
                end

                for _, serverTemplate in ipairs(
                    State.ServerList:GetChildren()
                ) do
                    if serverTemplate.Name == "ServerTemplate" then
                        if funcs.TryJoinServer(
                            serverTemplate,
                            true
                        ) then
                            break
                        end
                    end
                end
            end
        }
    )


State.ServerHopEnabled = false
State.ServerHopRunning = false

Modules.ServerHopToggle =
    Groupboxes.ServerSystems:AddToggle(
        "ServerHopToggle",
        {
            Text = "Auto Server Hop",
            Description = "Automatically tries all available servers.",
            Default = false,

            Callback = function(Value)
                State.ServerHopEnabled = Value

                if not Value
                    or State.ServerHopRunning
                then
                    return
                end

                State.ServerHopRunning = true
                State.AttemptedServers = {}

                task.spawn(function()
                    while State.ServerHopEnabled do
                        local attemptedThisCycle = false

                        if State.ServerList
                            and State.ServerList.Parent
                        then
                            for _, serverTemplate in ipairs(
                                State.ServerList:GetChildren()
                            ) do
                                if not State.ServerHopEnabled then
                                    break
                                end

                                if serverTemplate.Name == "ServerTemplate" then
                                    local serverKey =
                                        funcs.GetServerKey(
                                            serverTemplate
                                        )

                                    if not State.AttemptedServers[serverKey]
                                        and funcs.RegionMatches(serverTemplate)
                                    then
                                        attemptedThisCycle = true

                                        if funcs.TryJoinServer(
                                            serverTemplate,
                                            false
                                        ) then
                                            task.wait(1)
                                            break
                                        end
                                    end
                                end
                            end
                        end

                        if not attemptedThisCycle then
                            State.AttemptedServers = {}
                            task.wait(1)
                        else
                            task.wait(0.5)
                        end
                    end

                    State.ServerHopRunning = false
                end)
            end
        }
    )


Services.TeleportService.TeleportInitFailed:Connect(
    function(Player, TeleportResult, ErrorMessage)
        if Player ~= Services.LocalPlayer then
            return
        end

        warn(
            "[ServerSystems] Teleport failed:",
            TeleportResult,
            ErrorMessage
        )

        if State.ServerHopEnabled then
            task.wait(1)
        end
    end
)


Groupboxes.LeftGroupBox:AddButton({
    Text = "Execute Infinite Yield",

    Func = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua"
            )
        )()
    end
})


Groupboxes.LeftGroupBox:AddButton({
    Text = "Execute Dex Explorer",

    Func = function()
        loadstring(
            game:HttpGet(
                "https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"
            )
        )()
    end
})


for _, player in ipairs(
    Services.Players:GetPlayers()
) do
    if not table.find(
        State.PlayerList,
        player.Name
    ) then
        table.insert(
            State.PlayerList,
            player.Name
        )
    end
end


Modules.PlayerDropdown =
    Groupboxes.RightGroupBox:AddDropdown(
        "PlayerDropdown",
        {
            Values = State.PlayerList,
            Default = 1,
            Multi = false,
            Text = "Select Player",
            Tooltip = "Choose a player"
        }
    )


Modules.PlayerDropdown:OnChanged(
    function(Value)
        State.SelectedPlayer = Value or ""
    end
)


if funcs.UpdatePlayerList then
    funcs.UpdatePlayerList()
end


Groupboxes.RightGroupBox:AddButton({
    Text = "Copy Profile Link",

    Func = function()
        if not State.SelectedPlayer
            or State.SelectedPlayer == ""
        then
            Library:Notify(
                "Select a player first!",
                2
            )
            return
        end

        local player =
            Services.Players:FindFirstChild(
                State.SelectedPlayer
            )

        if not player then
            Library:Notify(
                "Player not found!",
                3
            )
            return
        end

        local ProfileLink =
            "https://www.roblox.com/users/"
            .. tostring(player.UserId)
            .. "/profile"

        if setclipboard then
            setclipboard(ProfileLink)

            Library:Notify(
                "Profile Link Copied!",
                2
            )
        else
            Library:Notify(
                "Clipboard not supported!",
                2
            )
        end
    end
})



-- Library

Groupboxes.LibraryTab = Tabs.LibraryTab:AddRightGroupbox("UI Settings", "monitor")
Groupboxes.LibraryFuncs = Tabs.LibraryTab:AddLeftGroupbox("UI Extras", "monitor")
Groupboxes.LibraryModules = Tabs.LibraryTab:AddRightGroupbox("Modules and Updates", "list")

Modules.UpdatesButton = Groupboxes.LibraryModules:AddButton({
    Text = "Check MoonHub Updates",
    Callback = function()

        Library:Toggle(false)

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/Updates/CheckUpdates.lua"
        ))()

    end
})

Groupboxes.LibraryFuncs:AddButton({
    Text = "Check Roblox Version",

    Callback = function()

        if type(version) ~= "function" then
            Library:Notify({
                Title = "Version Check",
                Description = "Your executor does not support version()!",
                Time = 10
            })
            return
        end

        local versionSuccess, current = pcall(version)

        if not versionSuccess or type(current) ~= "string" then
            Library:Notify({
                Title = "Version Check",
                Description = "Failed to get your Roblox version!",
                Time = 10
            })
            return
        end

        local success, response = pcall(function()
            return game:HttpGet(
                "https://rbxoffsets.com/api/v1/windows/version"
            )
        end)

        if not success then
            Library:Notify({
                Title = "Version Check",
                Description = "Failed to get latest Roblox version!",
                Time = 10
            })
            return
        end

        local decodeSuccess, data = pcall(function()
            return Services.HttpService:JSONDecode(response)
        end)

        if not decodeSuccess
            or type(data) ~= "table"
            or type(data.displayVersion) ~= "string"
        then
            Library:Notify({
                Title = "Version Check",
                Description = "Invalid version data received!",
                Time = 10
            })
            return
        end

        local latest = data.displayVersion

        if current == latest then

            Library:Notify({
                Title = "Version Check",
                Description =
                    "You are using the latest Roblox version!",
                Time = 10
            })

        else

            Library:Notify({
                Title = "Version Check",
                Description =
                    "You are using downgraded Roblox version!",
                Time = 10
            })

        end
    end
})

Groupboxes.LibraryFuncs:AddButton({
    Text = "Check Executor Status",

    Callback = function()

        -- Check identifyexecutor support
        if type(identifyexecutor) ~= "function" then
            Library:Notify({
                Title = "Executor Check",
                Description = "Your executor does not support identifyexecutor()!",
                Time = 10
            })
            return
        end

        -- Get executor name
        local executorSuccess, executorName = pcall(function()
            return identifyexecutor()
        end)

        if not executorSuccess
            or type(executorName) ~= "string"
            or executorName == ""
        then
            Library:Notify({
                Title = "Executor Check",
                Description = "Failed to detect your executor!",
                Time = 10
            })
            return
        end

        -- Get WEAO executor statuses
        local requestSuccess, response = pcall(function()
            return game:HttpGet(
                "https://weao.xyz/api/status/exploits"
            )
        end)

        if not requestSuccess then
            Library:Notify({
                Title = "Executor Check",
                Description = "Failed to connect to WEAO!",
                Time = 10
            })
            return
        end

        -- Decode response
        local decodeSuccess, data = pcall(function()
            return Services.HttpService:JSONDecode(response)
        end)

        if not decodeSuccess or type(data) ~= "table" then
            Library:Notify({
                Title = "Executor Check",
                Description = "Invalid response received from WEAO!",
                Time = 10
            })
            return
        end

        -- Find executor
        local executorData = nil

        for _, exploit in ipairs(data) do
            if type(exploit) == "table"
                and type(exploit.title) == "string"
            then
                if exploit.title:lower() == executorName:lower() then
                    executorData = exploit
                    break
                end
            end
        end

        if not executorData then
            Library:Notify({
                Title = "Executor Check",
                Description =
                    "Executor: " .. executorName
                    .. "\nExecutor was not found on WEAO!",
                Time = 10
            })
            return
        end

        -- Check update status
        local updateStatus = executorData.updateStatus

        if updateStatus == true
            or tostring(updateStatus):lower() == "updated"
        then

            Library:Notify({
                Title = "Executor Check",
                Description =
                    "Executor: " .. executorName
                    .. "\nYour executor is updated!",
                Time = 10
            })

        else

            Library:Notify({
                Title = "Executor Check",
                Description =
                    "Executor: " .. executorName
                    .. "\nYour executor is not updated to latest roblox version!",
                Time = 10
            })

        end
    end
})




-- WaterMark 
State.RegionLabel =
    game:GetService("Players").LocalPlayer.PlayerGui
        .ClientGui.Mainframe.Loadout.TopFrame.Region

State.FPS = 0
State.Frames = 0
State.LastUpdate = tick()

BaseLocals.LibraryWM = Library:AddDraggableLabel("")

BaseLocals.LibraryWM.Label.AnchorPoint = Vector2.new(0.5, 0)
BaseLocals.LibraryWM.Label.Position = UDim2.new(0.5, 0, 0, -55)
BaseLocals.LibraryWM.Label.Size = UDim2.new(0, 300, 0, 25)
BaseLocals.LibraryWM.Label.TextXAlignment = Enum.TextXAlignment.Center
BaseLocals.LibraryWM.Label.RichText = true

BaseLocals.LibraryWM:SetVisible(true)

function funcs.UpdateWatermark()

    Services.PlayerCount = #Services.Players:GetPlayers()
    Services.MaxPlayers = Services.Players.MaxPlayers

    State.Ping = 0

    pcall(function()
        State.Ping = math.floor(
            Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )
    end)

    State.ServerName = "Unknown"

    pcall(function()
        local ServerNameLabel =
            Services.Players.LocalPlayer.PlayerGui
                .ClientGui.Mainframe.Rest.MainMenuFrame.ServerName

        local Text = tostring(ServerNameLabel.Text)

        State.ServerName =
            Text:gsub("^%s*Server Name%s*:%s*", ""):gsub("%s+$", "")

        if State.ServerName == "" then
            State.ServerName = "Unknown"
        end
    end)

    State.Region = "Unknown"

    pcall(function()
        local Text = tostring(State.RegionLabel.Text)

        State.Region =
            Text:gsub("^%s*Server Region%s*:%s*", ""):gsub("%s+$", "")

        if State.Region == "" then
            State.Region = "Unknown"
        end
    end)

    State.Time = os.date("%H:%M")

    BaseLocals.LibraryWM:SetText(
        '<font color="#FFFFFF">MoonHub</font> ' ..
        '<font color="#808080">|</font> ' ..
        '<font color="#00FF00">FPS: ' .. State.FPS .. '</font> ' ..
        '<font color="#808080">|</font> ' ..
        '<font color="#00BFFF">Ping: ' .. State.Ping .. 'ms</font> ' ..
        '<font color="#808080">|</font> ' ..
        '<font color="#FFD700">Players: ' .. Services.PlayerCount .. '/' .. Services.MaxPlayers .. '</font> ' ..
        '<font color="#808080">|</font> ' ..
        '<font color="#A020F0">Server: ' .. State.ServerName .. ' - ' .. State.Region .. '</font> ' ..
        '<font color="#808080">|</font> ' ..
        '<font color="#FF69B4">' .. State.Time .. '</font>'
    )
end

function funcs.StartWatermarkFPS()

    ConnectionManager.Connect(
        "WatermarkFPS",
        game:GetService("RunService").RenderStepped,
        function()

            State.Frames += 1

            local now = tick()

            if now - State.LastUpdate >= 1 then

                State.FPS = State.Frames
                State.Frames = 0
                State.LastUpdate = now

                funcs.UpdateWatermark()
            end
        end
    )
end

function funcs.StopWatermarkFPS()

    ConnectionManager.Disconnect("WatermarkFPS")

    State.FPS = 0
    State.Frames = 0
    State.LastUpdate = tick()
end

Groupboxes.LibraryTab:AddButton("Unload", function()

        Toggles.aim_Enabled.Value = false

        if SilentAimGui.fov_circle then
            SilentAimGui.fov_circle:Remove()
            SilentAimGui.fov_circle = nil
        end

        if oldIndex then
            hookmetamethod(game, "__index", oldIndex)
            oldIndex = nil
        end

        getgenv().NewNoFallEnabled = false

    if State.noFogConnection then
        State.noFogConnection:Disconnect()
        State.noFogConnection = nil
    end

    if State.oldFogEnd ~= nil then
        Services.Lighting.FogEnd = State.oldFogEnd
        State.oldFogEnd = nil
    end

    if BaseLocals.noRainLoop then
        task.cancel(BaseLocals.noRainLoop)
        BaseLocals.noRainLoop = nil
    end

    if State.FullBrightConnection then
        State.FullBrightConnection:Disconnect()
        State.FullBrightConnection = nil
    end



        funcs.RemoveAttachments("NoSlowdownVelocity")
        funcs.RemoveAttachments("NoSlowdownAttachment")
        ConnectionManager.DisconnectPrefix("SilentAim.")
        funcs.StopBurnListener()
        funcs.StopWatermarkFPS()
        funcs.UnloadIdentitySpoofer()
        ConnectionManager.DisconnectAll()
        Library:Unload()
end)

Groupboxes.LibraryTab:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Toggle UI",
    })

Library.ToggleKeybind = Options.MenuKeybind

Groupboxes.LibraryTab:AddToggle("WatermarkToggle", {
    Text = "Show Watermark",
    Default = true,

    Callback = function(Value)
        if Value then
            BaseLocals.LibraryWM:SetVisible(true)
            funcs.StartWatermarkFPS()
            funcs.UpdateWatermark()
        else
            BaseLocals.LibraryWM:SetVisible(false)
            funcs.StopWatermarkFPS()
        end
    end,
})

funcs.StartWatermarkFPS()
funcs.UpdateWatermark()

-- Auto Execute System
getgenv().State = getgenv().State or {}
getgenv().State.AutoExecute = true

function funcs.QueueAutoExecute()
    if type(queue_on_teleport) ~= "function" then
        return
    end

    queue_on_teleport([[
        repeat
            task.wait()
        until game:IsLoaded()

        if game.PlaceId == 10266164381 then
            local Source = game:HttpGet(
                "https://raw.githubusercontent.com/Kam41514/MoonHub/refs/heads/main/10266164381.lua"
            )

            local Script, Error = loadstring(Source)

            if Script then
                Script()
            else
                warn("[AutoExecute] Loadstring Error:", Error)
            end
        end
    ]])

    print("[AutoExecute] Queue Added")
end

function funcs.ClearAutoExecute()
    if type(clearqueueonteleport) == "function" then
        clearqueueonteleport()
        print("[AutoExecute] Queue Cleared")
    end
end

Groupboxes.LibraryTab:AddToggle(
    "AutoExecute",
    {
        Text = "Auto Execute on Teleport",
        Default = true,

        Callback = function(Value)
            getgenv().State.AutoExecute = Value

            if Value then
                funcs.QueueAutoExecute()
            else
                funcs.ClearAutoExecute()
            end
        end
    }
)

Toggles.AutoExecute:SetValue(true)


Services.Players.PlayerAdded:Connect(function()
    task.wait(1)
    funcs.UpdatePlayerList()
end)

Services.Players.PlayerRemoving:Connect(function()
    task.wait(1)
    funcs.UpdatePlayerList()
end)

function funcs.CheckModerator(player)
    task.spawn(function()

        local success, rank = pcall(function()
            return player:GetRankInGroup(7450839)
        end)

        if not success then
            return
        end

        if rank ~= 0 then

            Library:Notify({
                Title = "🔴 Mod Detected",
                Description = player.Name .. " is a moderator!",
                Time = 120
            })

            Connect(
                "Moderator_Destroying_" .. player.UserId,
                player.Destroying,
                function()

                    Library:Notify({
                        Title = "🔴 Mod Left",
                        Description = player.Name .. " left the server.",
                        Time = 120
                    })

                end
            )
        end
    end)
end


for _, player in ipairs(Services.Players:GetPlayers()) do

    if player ~= Services.LocalPlayer then
        funcs.CheckModerator(player)
    end

end


ConnectionManager.Connect(
    "Moderator_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)
        funcs.CheckModerator(player)
    end
)

Library:Notify({
    Title = "MoonHub | Beta",
    Description = "Script Succesfully Executed.",
    Time = 5
})

print(SaveManager.BuildConfigSection)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Themes")
SaveManager:SetFolder("PermaDeathEnjoyer/Configs")
SaveManager:SetSubFolder("BloodlinesExternal")

-- Config System

SaveManager:BuildConfigSection(Tabs.Config)

ThemeManager:ApplyToTab(Tabs.Config)

SaveManager:LoadAutoloadConfig()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
