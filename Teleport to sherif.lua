-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска шерифа
function GetSheriff()
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun"))) then
            return v.Character
        end
    end
    return nil
end

-- Телепорт к шерифу
local sheriff = GetSheriff()
if sheriff then
    TeleportToPlayer(sheriff)
else
    warn("Шериф не найден.")
end
