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
Services.PlayerScripts = Services.LocalPlayer:WaitForChild("PlayerScripts")

Services.PlayerModule = require(Services.PlayerScripts:WaitForChild("PlayerModule"))
Services.ControlModule = Services.PlayerModule:GetControls()
Services.GameManager = require(Services.ReplicatedStorage:WaitForChild("GameManager"))

local PlayerSettings = Services.ReplicatedStorage
    :WaitForChild("Settings")
    :WaitForChild(Services.LocalPlayer.Name)

Services.Blocking = PlayerSettings:WaitForChild("Blocking")
Services.Stunned = PlayerSettings:WaitForChild("Stunned")
Services.Jailed = PlayerSettings:WaitForChild("Jailed")
Services.Knocked = PlayerSettings:WaitForChild("Knocked")
Services.Gripping = PlayerSettings:WaitForChild("Gripping")
Services.Invincible = PlayerSettings:WaitForChild("Invincible")

Services.PlayerGuiForName = Services.LocalPlayer:WaitForChild("PlayerGui")

return Services
