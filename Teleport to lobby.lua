-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска точки спавна в лобби
function FindLobbySpawn()
    -- Ищем объект спавна в лобби
    local lobbySpawn = workspace:FindFirstChild("Lobby")
    if lobbySpawn then
        local spawnPoint = lobbySpawn:FindFirstChild("Spawns")
        if spawnPoint then
            return spawnPoint:FindFirstChild("Spawn")
        end
    end
    return nil
end

-- Функция для телепорта в лобби
function TeleportToLobby()
    local spawnPoint = FindLobbySpawn()
    if spawnPoint then
        -- Телепортируем игрока к точке спавна в лобби
        Plr.Character.HumanoidRootPart.CFrame = spawnPoint.CFrame
        print("Телепорт в лобби выполнен!")
    else
        warn("Точка спавна в лобби не найдена.")
    end
end

-- Вызов функции для телепорта
TeleportToLobby()
