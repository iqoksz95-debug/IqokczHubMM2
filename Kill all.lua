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

-- Функция для отключения управления персонажем
local function DisableControls()
    Plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    Plr.Character.HumanoidRootPart.Anchored = true
end

-- Функция для включения управления персонажем
local function EnableControls()
    Plr.Character.HumanoidRootPart.Anchored = false
    Plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

-- Функция для телепортации за спину игрока и фиксации на спине
local function TeleportBehindTarget(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        -- Отключаем управление
        DisableControls()

        -- Вычисляем позицию за спиной целевого игрока
        local targetCFrame = target.HumanoidRootPart.CFrame
        local offset = targetCFrame.LookVector * -3  -- Смещение на 3 единицы за спину
        local newPosition = targetCFrame.Position + offset

        -- Телепортируемся за спину
        Plr.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition, target.HumanoidRootPart.Position)

        -- Фиксируем персонажа на спине целевого игрока с помощью BodyPosition
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = newPosition
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Parent = Plr.Character.HumanoidRootPart

        -- Ждем завершения телепортации
        task.wait(0.2)

        -- Возвращаем управление
        EnableControls()

        -- Удаляем BodyPosition после завершения
        bodyPosition:Destroy()
    end
end

-- Функция для убийства игрока ножом
local function KillPlayer(target)
    local knife = Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife")
    if knife then
        knife.Parent = Plr.Character
        knife:Activate()

        -- Задержка для нанесения урона
        task.wait(0.2)

        -- Симулируем касание ножом
        firetouchinterest(target.HumanoidRootPart, knife.Handle, 0)
        firetouchinterest(target.HumanoidRootPart, knife.Handle, 1)
    end
end

-- Функция для убийства всех игроков
function KillAll()
    -- Проверяем, есть ли у игрока нож
    if not HasKnife(Plr) then
        warn("Нож не найден!")
        return
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

                -- Телепортируемся за спину игрока
                TeleportBehindTarget(player.Character)

                -- Убиваем игрока
                KillPlayer(player.Character)

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
