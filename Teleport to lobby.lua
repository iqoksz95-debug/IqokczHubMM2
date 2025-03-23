local Plr = game:GetService("Players").LocalPlayer

local function FindLobbySpawn()
    local lobbySpawn = workspace:FindFirstChild("Lobby")
    if lobbySpawn then
        local spawnPoint = lobbySpawn:FindFirstChild("Spawns")
        return spawnPoint and spawnPoint:FindFirstChild("Spawn")
    end
    return nil
end

local function TeleportToLobby()
    local spawnPoint = FindLobbySpawn()
    if spawnPoint then
        Plr.Character.HumanoidRootPart.CFrame = spawnPoint.CFrame
        print("Телепорт в лобби выполнен!")
    else
        warn("Точка спавна в лобби не найдена.")
    end
end

TeleportToLobby()
