-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска GunDrop в workspace
local function FindGunDrop()
    -- Ищем объект GunDrop в workspace
    local gunDrop = workspace:FindFirstChild("GunDrop")
    
    -- Если GunDrop не найден, выводим предупреждение
    if not gunDrop then
        warn("GunDrop не найден в workspace!")
        return nil
    end
    
    return gunDrop
end

-- Функция для телепортации к пистолету
local function TeleportToGun()
    -- Проверяем, есть ли у игрока персонаж и HumanoidRootPart
    if not Plr.Character or not Plr.Character:FindFirstChild("HumanoidRootPart") then
        warn("У игрока нет персонажа или HumanoidRootPart!")
        return
    end

    -- Ищем объект GunDrop
    local gunDrop = FindGunDrop()
    
    -- Если GunDrop найден, телепортируем игрока к нему
    if gunDrop then
        -- Телепортируем игрока к GunDrop с небольшим смещением по оси Y
        Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        print("Телепортация к GunDrop выполнена!")
    else
        warn("GunDrop не найден!")
    end
end
