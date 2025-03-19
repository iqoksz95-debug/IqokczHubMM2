-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для проверки, есть ли у игрока нож
function HasKnife(player)
    return player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife"))
end

-- Функция для убийства всех игроков
function KillAll()
    -- Проверяем, есть ли у игрока нож
    if not HasKnife(Plr) then
        warn("У вас нет ножа!")
        return
    end

    -- Получаем список всех игроков
    local players = game:GetService("Players"):GetPlayers()

    -- Цикл по всем игрокам
    for _, player in ipairs(players) do
        -- Пропускаем себя и мертвых игроков
        if player ~= Plr and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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

            -- Ждем 0.25 секунд перед следующим убийством
            wait(0.25)
        end
    end

    -- После завершения цикла выключаем скрипт
    warn("Все игроки убиты. Скрипт завершен.")
end

-- Запуск функции KillAll
KillAll()
