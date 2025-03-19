-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска GunDrop в workspace (включая вложенные части)
local function FindGunDrop()
    -- Рекурсивно ищем GunDrop в workspace
    local function searchInModel(model)
        for _, child in pairs(model:GetChildren()) do
            if child.Name == "GunDrop" then
                return child
            elseif child:IsA("Model") or child:IsA("Folder") then
                local found = searchInModel(child)
                if found then
                    return found
                end
            end
        end
        return nil
    end

    -- Начинаем поиск с workspace
    return searchInModel(workspace)
end

-- Функция для телепортации к пистолету
local function TeleportToGun()
    -- Ищем объект GunDrop
    local gunDrop = FindGunDrop()
    
    -- Проверяем, существует ли GunDrop
    if gunDrop then
        -- Проверяем, есть ли у игрока персонаж и HumanoidRootPart
        if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Телепортируем игрока к пистолету с небольшим смещением по оси Y
            Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
            print("Телепортация к GunDrop выполнена!")
        else
            warn("У игрока нет персонажа или HumanoidRootPart!")
        end
    else
        warn("GunDrop не найден!")
    end
end
