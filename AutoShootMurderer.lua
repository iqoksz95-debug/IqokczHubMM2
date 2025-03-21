-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска убийцы
function GetMurderer()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife"))) and v ~= Plr then
            return v.Character
        end
    end
    return nil
end

-- Функция для проверки, есть ли у игрока пистолет
function HasGun()
    return Plr.Character and (Plr.Character:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Gun"))
end

-- Функция для проверки, находится ли убийца в зоне видимости
function IsMurdererInSight(murderer)
    if not murderer or not murderer:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local camera = workspace.CurrentCamera
    local murdererPosition = murderer.HumanoidRootPart.Position
    local cameraPosition = camera.CFrame.Position

    -- Проверяем, находится ли убийца в пределах видимости камеры
    local direction = (murdererPosition - cameraPosition).Unit
    local ray = Ray.new(cameraPosition, direction * 1000)
    local hit, position = workspace:FindPartOnRay(ray, Plr.Character)

    if hit and hit:IsDescendantOf(murderer) then
        return true
    end
    return false
end

-- Функция для автоматической стрельбы по убийце
function AutoShootMurderer()
    -- Проверяем, есть ли у игрока пистолет
    if not HasGun() then
        return
    end

    -- Перемещаем пистолет в руку, если он в рюкзаке
    if Plr.Backpack:FindFirstChild("Gun") then
        Plr.Backpack.Gun.Parent = Plr.Character
    end

    -- Получаем убийцу
    local Murderer = GetMurderer()
    if not Murderer then
        return
    end

    -- Получаем пистолет
    local Gun = Plr.Character:FindFirstChild("Gun")
    if not Gun then
        return
    end

    -- Цикл стрельбы по убийце
    while Murderer and Murderer:FindFirstChild("Humanoid") and Murderer.Humanoid.Health > 0 do
        -- Проверяем, находится ли убийца в зоне видимости
        if IsMurdererInSight(Murderer) then
            -- Стреляем в убийцу
            local args = {
                [1] = 1, -- Количество выстрелов
                [2] = Murderer.HumanoidRootPart.Position, -- Позиция убийцы
                [3] = "AH" -- Тип выстрела (можно изменить в зависимости от игры)
            }
            Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
        end

        -- Ждем перед следующим выстрелом
        task.wait(0.5)

        -- Обновляем информацию об убийце
        Murderer = GetMurderer()
    end
end

-- Переключатель для автоматической стрельбы по убийце
local AutoShootEnabled = false

Toggle(Main, "Auto Shoot Murderer", false, function(state)
    AutoShootEnabled = state
    if AutoShootEnabled then
        -- Запускаем автоматическую стрельбу
        while AutoShootEnabled do
            AutoShootMurderer()
            task.wait(1) -- Проверяем каждую секунду
        end
    end
end)
