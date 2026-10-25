local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local ThemeManager = loadstring(
    game:HttpGet(repo .. "addons/ThemeManager.lua")
)()

local SaveManager = loadstring(
    game:HttpGet(repo .. "addons/SaveManager.lua")
)()

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
Groupboxes.InfiniteScripts = Tabs.Combat:AddLeftGroupbox("Player Scripts", "user")
Groupboxes.Blocking = Tabs.Combat:AddRightGroupbox("Better Blocking", "user")
Groupboxes.Aimbot = Tabs.Combat:AddRightGroupbox("Silent Aim", "crosshair")

-- Faking Stats

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

    local PlayerCharacter =
        Player.Character

    local LocalPlayerCharacter =
        Services.LocalPlayer.Character

    if not PlayerCharacter
        or not LocalPlayerCharacter then
        return false
    end

    local TargetPartName =
        Options.TargetPart.Value

    if TargetPartName == "Random" then
        TargetPartName = "HumanoidRootPart"
    end

    local PlayerRoot =
        SupportServices.FindFirstChild(
            PlayerCharacter,
            TargetPartName
        )
        or SupportServices.FindFirstChild(
            PlayerCharacter,
            "HumanoidRootPart"
        )

    if not PlayerRoot then
        return false
    end

    local CastPoints = {
        PlayerRoot.Position
    }

    local IgnoreList = {
        LocalPlayerCharacter,
        PlayerCharacter
    }

    local ObscuringObjects =
        #SupportServices.GetPartsObscuringTarget(
            Services.Camera,
            CastPoints,
            IgnoreList
        )

    return ObscuringObjects == 0
end


function funcs.getClosestPlayer()
    if not Options
        or not Options.TargetPart
        or Options.TargetPart.Value == nil then
        return nil
    end

    local closest = nil

    local radiusOption = Options.Radius
    local closestDistance = radiusOption
        and tonumber(radiusOption.Value)
        or 2000

    local mousePosition = funcs.getMousePosition()

    if not mousePosition then
        return nil
    end

    local targetPartOption = Options.TargetPart.Value

    local visibleCheck =
        Toggles
        and Toggles.VisibleCheck
        and Toggles.VisibleCheck.Value
        or false

    local players = SupportServices.GetPlayers(Services.Players)

    for _, player in ipairs(players) do
        if player == Services.LocalPlayer then
            continue
        end

        local character = player.Character

        if not character then
            continue
        end

        local humanoid = SupportServices.FindFirstChild(
            character,
            "Humanoid"
        )

        if not humanoid or humanoid.Health <= 0 then
            continue
        end

        local targetPartName = targetPartOption

        if targetPartName == "Random" then
            local validParts = State.ValidTargetParts

            if not validParts or #validParts == 0 then
                continue
            end

            targetPartName = validParts[
                math.random(1, #validParts)
            ]
        end

        local targetPart = SupportServices.FindFirstChild(
            character,
            targetPartName
        )

        if not targetPart or not targetPart:IsA("BasePart") then
            continue
        end

        local screenPosition, onScreen =
            funcs.getPositionOnScreen(targetPart.Position)

        if not onScreen or not screenPosition then
            continue
        end

        local distance = (
            mousePosition - screenPosition
        ).Magnitude

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


local oldIndex

oldIndex = hookmetamethod(
    game,
    "__index",
    newcclosure(function(self, Index)

        if self == Services.Mouse
            and not checkcaller()
            and Toggles.aim_Enabled
            and Toggles.aim_Enabled.Value then

            local HitPart =
                funcs.getClosestPlayer()

            if HitPart then

                if Index == "Target"
                    or Index == "target" then

                    return HitPart

                elseif Index == "Hit"
                    or Index == "hit" then

                    return HitPart.CFrame

                end
            end
        end

        return oldIndex(
            self,
            Index
        )
    end)
)


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
State.MaxJumpCount = nil
State.StaminaMode = "Infinite Value"
State.StaminaRegenDelay = 2
State.StaminaRegenElapsed = 0
State.LegitRegenMin = 4
State.LegitRegenMax = 7
State.LastJumpCount = nil
State.NextLegitRegen = nil

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
            State.MaxJumpCount = nil
            State.StaminaRegenElapsed = 0
            State.LastJumpCount = nil
            State.NextLegitRegen = nil
            return
        end

        BaseLocals.currentValue = State.JumpCounters.Value
        State.InitialJumpCount = math.max(BaseLocals.currentValue, 1)
        State.MaxJumpCount = State.InitialJumpCount
        State.LastJumpCount = State.JumpCounters.Value
        State.StaminaRegenElapsed = 0
        State.NextLegitRegen = math.random(
            State.LegitRegenMin,
            State.LegitRegenMax
        )

        if State.StaminaMode == "Infinite Value" then
            State.JumpCounters.Value = State.MaxJumpCount
        end

        ConnectionManager.Connect(
            "InfiniteStamina",
            Services.RunService.Heartbeat,
            function(deltaTime)

                if not Toggles.InfiniteStamina.Value then
                    ConnectionManager.Disconnect("InfiniteStamina")
                    return
                end

                if not State.JumpCounters then
                    return
                end

                local currentValue = State.JumpCounters.Value

                if State.StaminaMode == "Infinite Value" then
                    State.JumpCounters.Value = State.MaxJumpCount
                    State.LastJumpCount = State.MaxJumpCount
                    return
                end

                if State.StaminaMode == "Custom Stamina Regen" then
                    if State.LastJumpCount == nil then
                        State.LastJumpCount = currentValue
                    end

                    if currentValue < State.LastJumpCount then
                        State.StaminaRegenElapsed = 0
                    end

                    State.LastJumpCount = currentValue

                    if currentValue >= State.MaxJumpCount then
                        State.StaminaRegenElapsed = 0
                        return
                    end

                    State.StaminaRegenElapsed =
                        State.StaminaRegenElapsed + deltaTime

                    if State.StaminaRegenElapsed >= State.StaminaRegenDelay then
                        State.StaminaRegenElapsed =
                            State.StaminaRegenElapsed - State.StaminaRegenDelay

                        State.JumpCounters.Value = math.min(
                            currentValue + 1,
                            State.MaxJumpCount
                        )

                        State.LastJumpCount = State.JumpCounters.Value
                    end

                elseif State.StaminaMode == "Legit Value" then
                    if State.LastJumpCount == nil then
                        State.LastJumpCount = currentValue
                    end

                    if currentValue < State.LastJumpCount then
                        State.StaminaRegenElapsed = 0
                        State.NextLegitRegen = math.random(
                            State.LegitRegenMin,
                            State.LegitRegenMax
                        )
                    end

                    State.LastJumpCount = currentValue

                    if currentValue >= State.MaxJumpCount then
                        State.StaminaRegenElapsed = 0
                        return
                    end

                    State.StaminaRegenElapsed =
                        State.StaminaRegenElapsed + deltaTime

                    if State.StaminaRegenElapsed >= State.NextLegitRegen then
                        State.StaminaRegenElapsed = 0

                        State.JumpCounters.Value = math.min(
                            currentValue + 1,
                            State.MaxJumpCount
                        )

                        State.LastJumpCount = State.JumpCounters.Value

                        State.NextLegitRegen = math.random(
                            State.LegitRegenMin,
                            State.LegitRegenMax
                        )
                    end
                end

            end
        )

    end)

Modules.StaminaMode =
    Groupboxes.InfiniteScripts:AddDropdown(
        "StaminaMode",
        {
            Text = "Stamina Mode",
            Values = {
                "Infinite Value",
                "Custom Stamina Regen",
                "Legit Value"
            },
            Default = "Infinite Value",
        }
    ):OnChanged(function(value)

        State.StaminaMode = value

        if not Toggles.InfiniteStamina.Value then
            return
        end

        State.StaminaRegenElapsed = 0
        State.LastJumpCount = State.JumpCounters.Value
        State.NextLegitRegen = math.random(
            State.LegitRegenMin,
            State.LegitRegenMax
        )

        if value == "Infinite Value" then
            State.JumpCounters.Value = State.MaxJumpCount or 1
        end

    end)

Modules.StaminaRegenDelay =
    Groupboxes.InfiniteScripts:AddSlider(
        "StaminaRegenDelay",
        {
            Text = "Custom Regen Seconds",
            Default = 2,
            Min = 1,
            Max = 4,
            Rounding = 0,
        }
    ):OnChanged(function(value)
        State.StaminaRegenDelay = value
        State.StaminaRegenElapsed = 0
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

State.AntiAFKEnabled = false

function funcs.StartAntiAFK()
    State.AntiAFKEnabled = true

    ConnectionManager.Connect(
        "AntiAFK_Idled",
        Services.Players.LocalPlayer.Idled,
        function()
            if not State.AntiAFKEnabled then
                return
            end

            local VirtualUser = game:GetService("VirtualUser")

            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(
                Vector2.new()
            )
        end
    )
end

function funcs.StopAntiAFK()
    State.AntiAFKEnabled = false

    ConnectionManager.Disconnect("AntiAFK_Idled")
end

Groupboxes.WorldLeft:AddToggle(
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




-- Visual
Groupboxes.LeaderboardObserve = Tabs.Visual:AddRightGroupbox("Leaderboard Settings", "list")
Groupboxes.VisualWorld = Tabs.Visual:AddRightGroupbox("Lighting Settings", "lightbulb")
Groupboxes.PlayerESP = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")

State.ObserveEnabled = true
State.CurrentObserveTarget = nil

Services.Camera = workspace.CurrentCamera

function funcs.getPlayerList()

    local playerGui =
        Services.LocalPlayer:FindFirstChild("PlayerGui")

    if not playerGui then
        return nil
    end

    local clientGui =
        playerGui:FindFirstChild("ClientGui")

    if not clientGui then
        return nil
    end

    local mainframe =
        clientGui:FindFirstChild("Mainframe")

    if not mainframe then
        return nil
    end

    local playerList =
        mainframe:FindFirstChild("PlayerList")

    if not playerList then
        return nil
    end

    return playerList:FindFirstChild("List")
end


function funcs.resetCamera()

    State.CurrentObserveTarget = nil

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local character =
        Services.LocalPlayer.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        camera.CameraSubject = humanoid
    end
end


function funcs.clearObserveConnections()

    for name in pairs(ConnectionManager.MainConnections) do

        if string.sub(name, 1, 8) == "Observe_" then
            ConnectionManager.Disconnect(name)
        end

    end

end


function funcs.setupPlayerTemplate(template)

    if not template
        or template.Name ~= "PlayerTemplate" then
        return
    end

    local connectionName =
        "Observe_Template_" .. tostring(template:GetDebugId())

    ConnectionManager.Connect(
        connectionName,
        template.InputBegan,
        function(input)

            if not State.ObserveEnabled then
                return
            end

            if input.UserInputType
                ~= Enum.UserInputType.MouseButton2 then
                return
            end

            local playerNameObject =
                template:FindFirstChild("PlayerName")

            if not playerNameObject then
                return
            end

            local playerName =
                playerNameObject.Text

            if not playerName
                or playerName == "" then
                return
            end

            local target =
                Services.Players:FindFirstChild(playerName)

            if not target then
                return
            end

            local character =
                target.Character

            if not character then
                return
            end

            local humanoid =
                character:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                return
            end

            local camera =
                workspace.CurrentCamera

            if not camera then
                return
            end

            if State.CurrentObserveTarget == target then

                funcs.resetCamera()

            else

                State.CurrentObserveTarget =
                    target

                camera.CameraSubject =
                    humanoid

            end

        end
    )

end


function funcs.enableObserve()

    if not State.ObserveEnabled then
        return
    end

    funcs.clearObserveConnections()

    local list =
        funcs.getPlayerList()

    if not list then
        return
    end

    for _, template in ipairs(list:GetChildren()) do
        funcs.setupPlayerTemplate(template)
    end

    ConnectionManager.Connect(
        "Observe_PlayerListChildAdded",
        list.ChildAdded,
        function(child)

            if not State.ObserveEnabled then
                return
            end

            if child.Name ~= "PlayerTemplate" then
                return
            end

            task.defer(function()

                if State.ObserveEnabled
                    and child.Parent == list then

                    funcs.setupPlayerTemplate(child)

                end

            end)

        end
    )

end


Modules.ObserveToggle =
    Groupboxes.LeaderboardObserve:AddToggle(
        "ObserveToggle",
        {
            Text = "Leaderboard Observe",
            Default = true
        }
    )


Modules.ObserveToggle:OnChanged(function(value)

    State.ObserveEnabled = value

    if value then

        funcs.enableObserve()

    else

        funcs.clearObserveConnections()
        funcs.resetCamera()

    end

end)


ConnectionManager.Connect(
    "Observe_LocalCharacterAdded",
    Services.LocalPlayer.CharacterAdded,
    function(character)

        State.CurrentObserveTarget = nil

        local humanoid =
            character:WaitForChild(
                "Humanoid",
                10
            )

        if humanoid then

            local camera =
                workspace.CurrentCamera

            if camera then
                camera.CameraSubject = humanoid
            end

        end

        if State.ObserveEnabled then

            task.wait(1)

            if State.ObserveEnabled then
                funcs.enableObserve()
            end

        end

    end
)


local playerGui = Services.LocalPlayer:WaitForChild("PlayerGui")


ConnectionManager.Connect(
    "Observe_PlayerGuiChildAdded",
    playerGui.ChildAdded,
    function(child)

        if child.Name ~= "ClientGui" then
            return
        end

        if not State.ObserveEnabled then
            return
        end

        task.wait(0.5)

        if State.ObserveEnabled then
            funcs.enableObserve()
        end

    end
)


ConnectionManager.Connect(
    "Observe_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)

        ConnectionManager.Connect(
            "Observe_TargetCharacter_" .. player.UserId,
            player.CharacterAdded,
            function(character)

                if not State.ObserveEnabled then
                    return
                end

                if State.CurrentObserveTarget
                    ~= player then
                    return
                end

                local humanoid =
                    character:WaitForChild(
                        "Humanoid",
                        10
                    )

                if not humanoid then
                    return
                end

                local camera =
                    workspace.CurrentCamera

                if not camera then
                    return
                end

                if State.CurrentObserveTarget
                    == player then

                    camera.CameraSubject =
                        humanoid

                end

            end
        )

    end
)


ConnectionManager.Connect(
    "Observe_PlayerRemoving",
    Services.Players.PlayerRemoving,
    function(player)

        if State.CurrentObserveTarget
            == player then

            funcs.resetCamera()

        end

        ConnectionManager.Disconnect(
            "Observe_TargetCharacter_" ..
            player.UserId
        )

    end
)


for _, player in ipairs(
    Services.Players:GetPlayers()
) do

    ConnectionManager.Connect(
        "Observe_TargetCharacter_" .. player.UserId,
        player.CharacterAdded,
        function(character)

            if not State.ObserveEnabled then
                return
            end

            if State.CurrentObserveTarget
                ~= player then
                return
            end

            local humanoid =
                character:WaitForChild(
                    "Humanoid",
                    10
                )

            if not humanoid then
                return
            end

            local camera =
                workspace.CurrentCamera

            if camera then
                camera.CameraSubject =
                    humanoid
            end

        end
    )

end


if State.ObserveEnabled then
    task.defer(function()
        Modules.ObserveToggle:SetValue(true)
        funcs.enableObserve()
    end)
end

State.PlayerESPObjects = {}
State.PlayerESPEnabled = false
State.PlayerESPShowLocation = true
State.PlayerESPShowHealth = true
State.PlayerESPShowRange = true
State.PlayerESPShowRaces = true
State.PlayerESPShowChakra = true
State.PlayerESPShowLocationMode = "Show Closest Chakra Point"
State.PlayerESPMaxDistance = 2000
State.PlayerESPCheckInterval = 1

State.ChakraPointsFolder = workspace:WaitForChild("ChakraPoints")
State.LocationsFolder = workspace:WaitForChild("Locations")

function funcs.RemovePlayerESPFromPlayer(plr)
    local data = State.PlayerESPObjects[plr]
    if data then
        if data.RenderConnectionName then
            ConnectionManager.Disconnect(data.RenderConnectionName)
        end
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
        State.PlayerESPObjects[plr] = nil
    end
    ConnectionManager.Disconnect("PlayerESP_Character_" .. plr.UserId)
end

function funcs.SetupCharacter(plr, char)
    if not State.PlayerESPEnabled or not plr
        or plr == Services.LocalPlayer
        or not char or not char.Parent then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    local old = State.PlayerESPObjects[plr]
    if old then
        if old.RenderConnectionName then
            ConnectionManager.Disconnect(old.RenderConnectionName)
        end
        if old.Highlight then old.Highlight:Destroy() end
        if old.Billboard then old.Billboard:Destroy() end
        State.PlayerESPObjects[plr] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = char
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESPText"
    billboard.Size = UDim2.fromOffset(240, 90)
    billboard.StudsOffset = Vector3.new(0, 4.1, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = root
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Name = "ESPText"
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.TextSize = 14
    text.Font = Enum.Font.SourceSansBold
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Center
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.RichText = true
    text.Parent = billboard

    local renderName = "PlayerESP_Render_" .. plr.UserId

    ConnectionManager.Connect(
        renderName,
        Services.RunService.RenderStepped,
        function()
            if not State.PlayerESPEnabled then
                ConnectionManager.Disconnect(renderName)
                return
            end

            if not char.Parent or not root.Parent
                or not humanoid.Parent or humanoid.Health <= 0 then
                billboard.Enabled = false
                highlight.Enabled = false
                return
            end

            local localChar = Services.LocalPlayer.Character
            local localRoot = localChar
                and localChar:FindFirstChild("HumanoidRootPart")

            if not localRoot then
                billboard.Enabled = false
                highlight.Enabled = false
                return
            end

            local distance = math.floor(
                (localRoot.Position - root.Position).Magnitude
            )

            if distance > State.PlayerESPMaxDistance then
                billboard.Enabled = false
                highlight.Enabled = false
                return
            end

            billboard.Enabled = true
            highlight.Enabled = true

            local locationName = ""

            if State.PlayerESPShowLocation then
                if State.PlayerESPShowLocationMode == "Show Closest Chakra Point" then
                    local nearest
                    local nearestDistance = math.huge

                    for _, point in ipairs(State.ChakraPointsFolder:GetChildren()) do
                        if point.Name == "ChakraPoint" then
                            local part
                            if point:IsA("BasePart") then
                                part = point
                            elseif point:IsA("Model") then
                                part = point.PrimaryPart
                                    or point:FindFirstChildWhichIsA("BasePart", true)
                            end

                            if part then
                                local d = (root.Position - part.Position).Magnitude
                                if d < nearestDistance then
                                    nearestDistance = d
                                    nearest = point
                                end
                            end
                        end
                    end

                    if nearest then
                        local pointName = nearest:FindFirstChild("PointName", true)
                        if pointName and pointName:IsA("StringValue") then
                            locationName = pointName.Value
                        end
                    end
                else
                    local nearest
                    local nearestDistance = math.huge

                    for _, location in ipairs(State.LocationsFolder:GetChildren()) do
                        local part
                        if location:IsA("BasePart") then
                            part = location
                        elseif location:IsA("Model") then
                            part = location.PrimaryPart
                                or location:FindFirstChildWhichIsA("BasePart", true)
                        elseif location:IsA("Folder") then
                            part = location:FindFirstChildWhichIsA("BasePart", true)
                        end

                        if part then
                            local d = (root.Position - part.Position).Magnitude
                            if d < nearestDistance then
                                nearestDistance = d
                                nearest = location
                            end
                        end
                    end

                    if nearest then locationName = nearest.Name end
                end
            end

            local displayName = humanoid.DisplayName or ""
            local isGreen = string.find(displayName, "🌱", 1, true) ~= nil
            local displayColor = isGreen
                and Color3.fromRGB(0, 255, 0)
                or Color3.fromRGB(255, 0, 0)

            text.TextColor3 = displayColor
            highlight.OutlineColor = displayColor

            local lines = {}
            table.insert(lines, plr.Name)

            local healthValue = ""
            local chakraValue = ""

            if State.PlayerESPShowHealth then
                healthValue = "❤ "
                    .. math.floor(humanoid.Health)
                    .. "/" .. math.floor(humanoid.MaxHealth)
            end

            local backpack = plr:FindFirstChildOfClass("Backpack")
            local chakra = backpack and backpack:FindFirstChild("chakra")
            local maxChakra = backpack and backpack:FindFirstChild("maxChakra")

            chakra = chakra or char:FindFirstChild("chakra", true)
            maxChakra = maxChakra or char:FindFirstChild("maxChakra", true)

            if State.PlayerESPShowChakra and chakra and maxChakra
                and chakra:IsA("ValueBase")
                and maxChakra:IsA("ValueBase") then
                chakraValue = "🌀 "
                    .. math.floor(tonumber(chakra.Value) or 0)
                    .. "/" .. math.floor(tonumber(maxChakra.Value) or 0)
            end

            if healthValue ~= "" and chakraValue ~= "" then
                table.insert(lines,
                    '<font color="rgb(255,75,75)">' .. healthValue
                    .. '</font> / <font color="rgb(65,175,255)">'
                    .. chakraValue .. '</font>'
                )
            elseif healthValue ~= "" then
                table.insert(lines,
                    '<font color="rgb(255,75,75)">' .. healthValue .. '</font>'
                )
            elseif chakraValue ~= "" then
                table.insert(lines,
                    '<font color="rgb(65,175,255)">'
                    .. chakraValue .. '</font>'
                )
            end

            local locationLine = ""
            if State.PlayerESPShowLocation and locationName ~= "" then
                locationLine = "[" .. locationName .. "]"
            end

            if State.PlayerESPShowRange then
                local range = tostring(distance) .. " st"
                locationLine = locationLine ~= ""
                    and locationLine .. " / " .. range
                    or range
            end

            if locationLine ~= "" then
                table.insert(lines, locationLine)
            end

            local settings = Services.ReplicatedStorage:FindFirstChild("Settings")
            local playerSettings = settings and settings:FindFirstChild(plr.Name)
            local bloodline = playerSettings
                and playerSettings:FindFirstChild("Bloodline", true)

            if State.PlayerESPShowRaces and bloodline
                and bloodline:IsA("ValueBase")
                and tostring(bloodline.Value) ~= "" then
                table.insert(lines, "[" .. tostring(bloodline.Value) .. "]")
            end

            text.Text = table.concat(lines, "\n")
        end
    )

    State.PlayerESPObjects[plr] = {
        Highlight = highlight,
        Billboard = billboard,
        RenderConnectionName = renderName,
        Character = char,
        Root = root,
        Humanoid = humanoid
    }
end

function funcs.CreatePlayerESP(plr)
    if not plr or plr == Services.LocalPlayer
        or not State.PlayerESPEnabled then return end

    ConnectionManager.Connect(
        "PlayerESP_Character_" .. plr.UserId,
        plr.CharacterAdded,
        function(char)
            task.wait(1)
            if State.PlayerESPEnabled and plr.Parent then
                funcs.SetupCharacter(plr, char)
            end
        end
    )

    if plr.Character then
        funcs.SetupCharacter(plr, plr.Character)
    end
end

function funcs.CheckWorkspaceModels()
    if not State.PlayerESPEnabled then return end

    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if plr ~= Services.LocalPlayer then
            local model = workspace:FindFirstChild(plr.Name)
            local data = State.PlayerESPObjects[plr]

            if model and model:IsA("Model") then
                local root = model:FindFirstChild("HumanoidRootPart")
                local humanoid = model:FindFirstChildOfClass("Humanoid")

                if root and humanoid and (
                    not data
                    or data.Character ~= model
                    or data.Root ~= root
                    or data.Humanoid ~= humanoid
                    or not data.Highlight
                    or not data.Highlight.Parent
                    or not data.Billboard
                    or not data.Billboard.Parent
                ) then
                    funcs.SetupCharacter(plr, model)
                end
            elseif data then
                funcs.RemovePlayerESPFromPlayer(plr)
            end
        end
    end
end

function funcs.RemovePlayerESP()
    for plr in pairs(State.PlayerESPObjects) do
        funcs.RemovePlayerESPFromPlayer(plr)
    end

    ConnectionManager.DisconnectPrefix("PlayerESP_Character_")
    ConnectionManager.DisconnectPrefix("PlayerESP_Render_")
    ConnectionManager.Disconnect("PlayerESP_WorkspaceCheck")
end

Groupboxes.PlayerESP:AddToggle("PlayerESPToggle", {
    Text = "Player ESP",
    Default = false
}):OnChanged(function(Value)
    State.PlayerESPEnabled = Value

    if Value then
        for _, plr in ipairs(Services.Players:GetPlayers()) do
            if plr ~= Services.LocalPlayer then
                funcs.CreatePlayerESP(plr)
            end
        end

        ConnectionManager.Connect(
            "PlayerESP_PlayerAdded",
            Services.Players.PlayerAdded,
            function(plr)
                if plr ~= Services.LocalPlayer
                    and State.PlayerESPEnabled then
                    funcs.CreatePlayerESP(plr)
                end
            end
        )

        ConnectionManager.Connect(
            "PlayerESP_PlayerRemoving",
            Services.Players.PlayerRemoving,
            function(plr)
                funcs.RemovePlayerESPFromPlayer(plr)
            end
        )

        ConnectionManager.Connect(
            "PlayerESP_WorkspaceCheck",
            Services.RunService.Heartbeat,
            function()
                if not State.PlayerESPEnabled then return end

                if not State.PlayerESPNextCheck
                    or os.clock() >= State.PlayerESPNextCheck then
                    State.PlayerESPNextCheck =
                        os.clock() + State.PlayerESPCheckInterval

                    funcs.CheckWorkspaceModels()
                end
            end
        )
    else
        ConnectionManager.Disconnect("PlayerESP_PlayerAdded")
        ConnectionManager.Disconnect("PlayerESP_PlayerRemoving")

        State.PlayerESPNextCheck = nil
        funcs.RemovePlayerESP()
    end
end)

Groupboxes.PlayerESP:AddToggle("PlayerESPShowLocation", {
    Text = "Show Location",
    Default = true
}):OnChanged(function(Value)
    State.PlayerESPShowLocation = Value
end)

Groupboxes.PlayerESP:AddToggle("PlayerESPShowRaces", {
    Text = "Show Races",
    Default = true
}):OnChanged(function(Value)
    State.PlayerESPShowRaces = Value
end)

Groupboxes.PlayerESP:AddToggle("PlayerESPShowHealth", {
    Text = "Show Health",
    Default = true
}):OnChanged(function(Value)
    State.PlayerESPShowHealth = Value
end)

Groupboxes.PlayerESP:AddToggle("PlayerESPShowRange", {
    Text = "Show Range",
    Default = true
}):OnChanged(function(Value)
    State.PlayerESPShowRange = Value
end)

Groupboxes.PlayerESP:AddToggle("PlayerESPShowChakra", {
    Text = "Show Chakra",
    Default = true
}):OnChanged(function(Value)
    State.PlayerESPShowChakra = Value
end)

Groupboxes.PlayerESP:AddDropdown("PlayerESPShowLocationMode", {
    Text = "Location Type",
    Values = {
        "Show Closest Chakra Point",
        "Show Location Attribute (Buggy)"
    },
    Default = "Show Closest Chakra Point"
}):OnChanged(function(Value)
    State.PlayerESPShowLocationMode = Value
end)

Groupboxes.PlayerESP:AddSlider("PlayerESPDistance", {
    Text = "ESP Distance",
    Default = 2000,
    Min = 50,
    Max = 15000,
    Rounding = 0,
    Compact = true,
    Suffix = " st"
}):OnChanged(function(Value)
    State.PlayerESPMaxDistance = Value
end)

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

Modules.NoCloudsToggle = Groupboxes.VisualWorld:AddToggle("NoClouds", {
    Text = "No Clouds",
    Default = false
})

function funcs.noClouds(state)
    local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")

    if clouds then
        clouds.Enabled = not state
    end
end

Modules.NoCloudsToggle:OnChanged(function(Value)
    funcs.noClouds(Value)
end)

-- Misc
Groupboxes.ServerSystems = Tabs.Misc:AddLeftGroupbox("Server Systems", "server")
Groupboxes.LeftGroupBox = Tabs.Misc:AddLeftGroupbox("Executable Scripts", "code")
Groupboxes.RightGroupBox = Tabs.Misc:AddRightGroupbox("Player Systems", "user")

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

-- Auto Execute System
State.AutoExecute = true

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
            State.AutoExecute = Value

            if Value then
                funcs.QueueAutoExecute()
            else
                funcs.ClearAutoExecute()
            end
        end
    }
)

Groupboxes.LibraryTab:AddButton("Unload", function()

    Toggles.aim_Enabled.Value = false
    Toggles.InfiniteStamina:SetValue(false)

    ConnectionManager.Disconnect("InfiniteStamina")

    State.InitialJumpCount = nil
    State.MaxJumpCount = nil
    State.StaminaMode = "Infinite Value"
    State.StaminaRegenDelay = 2
    State.StaminaRegenElapsed = 0
    State.LegitRegenMin = 4
    State.LegitRegenMax = 7
    State.LastJumpCount = nil
    State.NextLegitRegen = nil

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

    local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
    if clouds then
        clouds.Enabled = true
    end

    State.AutoExecute = false

    -- Player ESP temizleme
    State.PlayerESPEnabled = false
    State.PlayerESPNextCheck = nil

    ConnectionManager.Disconnect("PlayerESP_PlayerAdded")
    ConnectionManager.Disconnect("PlayerESP_PlayerRemoving")
    ConnectionManager.Disconnect("PlayerESP_WorkspaceCheck")

    ConnectionManager.DisconnectPrefix("PlayerESP_Character_")
    ConnectionManager.DisconnectPrefix("PlayerESP_Render_")

    funcs.RemovePlayerESP()

    State.PlayerESPObjects = {}

    funcs.ClearAutoExecute()
    funcs.clearObserveConnections()
    funcs.StopAntiAFK()
    funcs.resetCamera()
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

            ConnectionManager.Connect(
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

print("BuildConfigSection:", SaveManager.BuildConfigSection)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Themes")
SaveManager:SetFolder("PermaDeathEnjoyer/Configs")
SaveManager:SetSubFolder("BloodlinesExternal")

SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)

SaveManager:LoadAutoloadConfig()
