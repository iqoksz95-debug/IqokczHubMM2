-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для проверки, есть ли у игрока нож
function HasKnife(player)
    return player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife"))
end

-- Функция для проверки, жив ли игрок
function IsPlayerAlive(player)
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

-- Функция для убийства всех игроков
function KillAll()
    -- Проверяем, есть ли у игрока нож
    if not HasKnife(Plr) then
        return -- Если ножа нет, завершаем выполнение
    end

    -- Таблица для хранения убитых игроков
    local killedPlayers = {}

    -- Основной цикл для убийства всех игроков
    while true do
        -- Получаем список всех игроков
        local players = game:GetService("Players"):GetPlayers()
        local allDead = true  -- Флаг для проверки, все ли игроки мертвы

        -- Цикл по всем игрокам
        for _, player in ipairs(players) do
            -- Пропускаем себя, мертвых игроков и уже убитых
            if player ~= Plr and IsPlayerAlive(player) and not killedPlayers[player] then
                allDead = false  -- Если найден живой игрок, устанавливаем флаг в false

                -- Телепортируемся к игроку
                Plr.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame

                -- Убиваем игрока
                local knife = Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife")
                if knife then
                    knife.Parent = Plr.Character
                    knife:Activate()
                    firetouchinterest(player.Character.HumanoidRootPart, knife.Handle, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, knife.Handle, 1)
                end

                -- Помечаем игрока как убитого
                killedPlayers[player] = true

                -- Ждем 1 секунду перед следующим убийством
                task.wait(1)
            end
        end

        -- Если все игроки мертвы, выходим из цикла
        if allDead then
            break
        end
    end

    -- После завершения цикла уничтожаем скрипт
    script:Destroy()
end

-- Запуск функции KillAll
KillAll()
