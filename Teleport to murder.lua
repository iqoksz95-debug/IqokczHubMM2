-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска убийцы
function GetMurderer()
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife"))) then
            return v.Character
        end
    end
    return nil
end

-- Функция для телепорта к игроку
function TeleportToPlayer(player)
    if player and player:FindFirstChild("HumanoidRootPart") then
        Plr.Character.HumanoidRootPart.CFrame = player.HumanoidRootPart.CFrame
    else
        warn("Игрок не найден или у него нет HumanoidRootPart.")
    end
end

-- Телепорт к убийце
local murderer = GetMurderer()
if murderer then
    TeleportToPlayer(murderer)
else
    warn("Убийца не найден.")
end
