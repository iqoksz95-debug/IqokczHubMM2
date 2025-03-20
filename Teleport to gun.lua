-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Список карт для проверки
local maps = {
    "Hospital3",
    "Office3",
    "PoliceStation",
    "Factory",
    "ResearchFacility",
    "Bank2",
    "Workplace",
    "House2",
    "Mansion2",
    "BioLab",
    "Hotel",
    "MilBase"
}

-- Функция для поиска GunDrop на карте
local function FindGunDrop(mapName)
    local map = workspace:FindFirstChild(mapName)
    if map then
        local gunDrop = map:FindFirstChild("GunDrop")
        if gunDrop then
            return gunDrop
        end
    end
    return nil
end

-- Функция для телепортации к GunDrop
local function TeleportToGun(gunDrop)
    if gunDrop and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        -- Телепортируем игрока к GunDrop с небольшим смещением по оси Y
        Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        print("Телепортация к GunDrop выполнена на карте " .. gunDrop.Parent.Name)
    else
        warn("GunDrop не найден или у игрока нет персонажа!")
    end
end

-- Основная функция для поиска GunDrop на всех картах
local function SearchForGunDrop()
    for _, mapName in ipairs(maps) do
        local gunDrop = FindGunDrop(mapName)
        if gunDrop then
            TeleportToGun(gunDrop)
            return  -- Завершаем выполнение после нахождения GunDrop
        end
    end
    warn("GunDrop не найден ни на одной из карт!")
end

-- Запускаем поиск GunDrop
SearchForGunDrop()
