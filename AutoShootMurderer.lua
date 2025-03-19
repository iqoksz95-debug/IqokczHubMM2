-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска убийцы
function GetMurderer()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Knife") or v.Character and v.Character:FindFirstChild("Knife")) and v ~= Plr then
            return v.Character
        end
    end
    return nil
end

-- Функция для автоматической стрельбы по убийце
function AutoShootMurderer()
    -- Проверяем, есть ли у игрока пистолет
    if Plr.Character and (Plr.Character:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Gun")) then
        -- Перемещаем пистолет в руку, если он в рюкзаке
        if Plr.Backpack:FindFirstChild("Gun") then
            Plr.Backpack.Gun.Parent = Plr.Character
        end

        -- Получаем убийцу
        local Murderer = GetMurderer()
        if Murderer then
            -- Получаем пистолет
            local Gun = Plr.Character:FindFirstChild("Gun")
            if Gun then
                -- Цикл стрельбы по убийце
                while Murderer and Murderer:FindFirstChild("Humanoid") and Murderer.Humanoid.Health > 0 do
                    -- Стреляем в убийцу
                    local args = {
                        [1] = 1, -- Количество выстрелов
                        [2] = Murderer.HumanoidRootPart.Position, -- Позиция убийцы
                        [3] = "AH" -- Тип выстрела (можно изменить в зависимости от игры)
                    }
                    Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
                    
                    -- Ждем перед следующим выстрелом
                    task.wait(0.5)
                    
                    -- Обновляем информацию об убийце
                    Murderer = GetMurderer()
                end
                
                -- Убийца убит, выключаем скрипт
                warn("Убийца убит! Скрипт выключен.")
                return
            end
        else
            warn("Убийца не найден! Скрипт выключен.")
        end
    else
        warn("У вас нет пистолета! Скрипт выключен.")
    end
end

-- Переключатель для автоматической стрельбы по убийце
local AutoShootEnabled = false

Toggle(Main, "Auto Shoot Murderer", false, function(state)
    AutoShootEnabled = state
    if AutoShootEnabled then
        AutoShootMurderer()
    end
end)
