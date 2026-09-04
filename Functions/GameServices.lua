local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local service = game:GetService(serviceName)
        rawset(self, serviceName, service)
        return service
    end
})

Services.Camera = workspace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer
Services.Mouse = Services.LocalPlayer:GetMouse()
Services.Character = Services.Players.LocalPlayer.Character

Services.Character = Services.LocalPlayer.Character
    or Services.LocalPlayer.CharacterAdded:Wait()

Services.Humanoid = Services.Character:WaitForChild("Humanoid")

Services.PlayerScripts = Services.LocalPlayer:WaitForChild("PlayerScripts")

Services.PlayerModule = require(
    Services.PlayerScripts:WaitForChild("PlayerModule")
)

Services.ControlModule = Services.PlayerModule:GetControls()

Services.GameManager = require(
    Services.ReplicatedStorage:WaitForChild("GameManager")
)

local PlayerSettings = Services.ReplicatedStorage
    :WaitForChild("Settings")
    :WaitForChild(Services.LocalPlayer.Name)

Services.Blocking = PlayerSettings:WaitForChild("Blocking")
Services.Stunned = PlayerSettings:WaitForChild("Stunned")
Services.Jailed = PlayerSettings:WaitForChild("Jailed")
Services.Knocked = PlayerSettings:WaitForChild("Knocked")
Services.Gripping = PlayerSettings:WaitForChild("Gripping")
Services.Invincible = PlayerSettings:WaitForChild("Invincible")
Services.CanPerfectBlock = PlayerSettings:WaitForChild("canPerfectBlock")

Services.PlayerGuiForName = Services.LocalPlayer:WaitForChild("PlayerGui")

Services.LocalPlayer.CharacterAdded:Connect(function(Character)
    Services.Character = Character
    Services.Humanoid = Character:WaitForChild("Humanoid")
end)

return Services
