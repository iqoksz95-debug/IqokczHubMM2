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

-- Телепорт к убийце
local murderer = GetMurderer()
if murderer then
    TeleportToPlayer(murderer)
else
    warn("Убийца не найден.")
end
