-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска шерифа
function GetSheriff()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= Plr then -- Исключаем себя из поиска
            if (v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun"))) then
                return v
            end
        end
    end
    return nil
end

-- Функция для телепортации к пистолету
local function TeleportToGun(gunDrop)
    if gunDrop and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        -- Телепортируем игрока к пистолету с небольшим смещением по оси Y
        Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        print("Телепортация к GunDrop выполнена!")
    else
        warn("GunDrop не найден или у игрока нет персонажа!")
    end
end

-- Обработчик события смерти шерифа
local function OnSheriffDeath(sheriff)
    -- Ждем некоторое время, чтобы GunDrop успел появиться
    wait(1)

    -- Ищем GunDrop в workspace
    local gunDrop = workspace:FindFirstChild("GunDrop")
    if gunDrop then
        TeleportToGun(gunDrop)
    else
        warn("GunDrop не найден после смерти шерифа!")
    end
end

-- Основная функция для отслеживания смерти шерифа
local function TrackSheriff()
    while true do
        local sheriff = GetSheriff()
        if sheriff and sheriff.Character then
            local humanoid = sheriff.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- Подключаемся к событию смерти шерифа
                humanoid.Died:Connect(function()
                    OnSheriffDeath(sheriff)
                end)
                break  -- Прерываем цикл, если шериф найден и событие подключено
            end
        end
        wait(1)  -- Проверяем наличие шерифа каждую секунду
    end
end

-- Запускаем отслеживание шерифа
TrackSheriff()
