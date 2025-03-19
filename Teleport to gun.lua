-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска сброшенного пистолета
function FindGunDrop()
    -- Ищем объект "GunDrop" в рабочем пространстве
    local gunDrop = workspace:FindFirstChild("GunDrop")
    if gunDrop then
        return gunDrop
    else
        return nil
    end
end

-- Функция для телепорта к сброшенному пистолету
function TeleportToGunDrop()
    local gunDrop = FindGunDrop()
    if gunDrop then
        -- Телепортируем игрока к позиции пистолета
        Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        print("Телепорт к сброшенному пистолету выполнен!")
    else
        warn("Сброшенный пистолет не найден.")
    end
end

-- Вызов функции для телепорта
TeleportToGunDrop()
