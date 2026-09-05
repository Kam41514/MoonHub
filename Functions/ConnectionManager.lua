local MainConnections = {}
local funcs = {}

funcs.MainConnections = MainConnections

function funcs.Connect(name, signal, callback)
    if MainConnections[name] then
        MainConnections[name]:Disconnect()
        MainConnections[name] = nil
    end

    MainConnections[name] = signal:Connect(callback)

    return MainConnections[name]
end

function funcs.Disconnect(name)
    local connection = MainConnections[name]

    if connection then
        connection:Disconnect()
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

        MainConnections[name] = nil
    end
end

return funcs
