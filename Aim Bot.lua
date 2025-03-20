-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска убийцы
function GetMurderer()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife")) then
            return v.Character
        end
    end
    return nil
end

-- Функция для проверки, есть ли у игрока пистолет
function HasGun(player)
    return player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun"))
end

-- Функция для проверки, жив ли локальный игрок
function IsPlayerAlive()
    if not Plr.Character then
        return false
    end
    local humanoid = Plr.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- Функция для проверки, идет ли раунд
function IsRoundActive()
    -- Проверяем, есть ли убийца или шериф
    local murdererFound = GetMurderer() ~= nil
    local sheriffFound = false

    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if HasGun(v) then
            sheriffFound = true
            break
        end
    end

    -- Если нет убийцы или шерифа, раунд, скорее всего, завершен
    return murdererFound or sheriffFound
end

-- Основная функция Aim Bot
function AimBot()
    -- Проверяем, идет ли раунд
    if not IsRoundActive() then
        warn("Раунд завершен, аимбот отключен!")
        return
    end

    -- Проверяем, жив ли локальный игрок
    if not IsPlayerAlive() then
        warn("Локальный игрок мертв, аимбот отключен!")
        return
    end

    -- Проверяем, есть ли у игрока пистолет
    if not HasGun(Plr) then
        warn("У вас нет пистолета!")
        return
    end

    -- Получаем персонажа убийцы
    local Murderer = GetMurderer()
    if not Murderer then
        warn("Убийца не найден!")
        return
    end

    -- Получаем туловище убийцы
    local Torso = Murderer:FindFirstChild("UpperTorso") or Murderer:FindFirstChild("Torso")
    if not Torso then
        warn("Туловище убийцы не найдено!")
        return
    end

    -- Наводим камеру на туловище убийцы
    local Camera = workspace.CurrentCamera
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Torso.Position)
end

-- Подключение функции AimBot к Heartbeat
game:GetService("RunService").Heartbeat:Connect(AimBot)
