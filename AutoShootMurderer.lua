-- Получение сервисов
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Plr = Players.LocalPlayer

-- Настройки
local SHOTS_BEFORE_CHECK = 3  -- Количество выстрелов перед проверкой состояния убийцы
local SHOOT_DELAY = 3

-- Переменные
local AutoShootEnabled = false
local ShootingConnection = nil
local CurrentMurderer = nil
local ShotCounter = 0

-- Функция для поиска убийцы
function GetMurderer()
    for _, v in pairs(Players:GetPlayers()) do
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

-- Функция для проверки видимости головы убийцы
function IsMurdererHeadVisible(murderer)
    if not murderer or not murderer:FindFirstChild("Head") then return nil end
    
    local head = murderer.Head
    local camera = workspace.CurrentCamera
    local headPosition = head.Position
    
    -- Проверка видимости через raycast
    local rayOrigin = camera.CFrame.Position
    local rayDirection = (headPosition - rayOrigin).Unit * 1000
    local ray = Ray.new(rayOrigin, rayDirection)
    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {Plr.Character})
    
    if hit and hit:IsDescendantOf(murderer) then
        local screenPoint, visible = camera:WorldToScreenPoint(headPosition)
        if visible then
            return Vector2.new(screenPoint.X, screenPoint.Y)
        end
    end
    return nil
end

-- Функция для симуляции выстрела
function SimulateShoot(targetPosition)
    local touchInput = {
        UserInputType = Enum.UserInputType.Touch,
        Position = targetPosition,
        UserInputState = Enum.UserInputState.Begin
    }
    UserInputService:ProcessInput(touchInput)
    
    touchInput.UserInputState = Enum.UserInputState.End
    UserInputService:ProcessInput(touchInput)
end

-- Основная функция стрельбы
function ShootAtMurderer()
    -- Проверяем наличие оружия
    if not HasGun() then
        if AutoShootEnabled then
            print("Нет оружия! Ожидание...")
        end
        return false
    end

    -- Перемещаем пистолет в руку, если нужно
    if Plr.Backpack:FindFirstChild("Gun") then
        Plr.Backpack.Gun.Parent = Plr.Character
    end

    -- Проверяем текущего убийцу
    if not CurrentMurderer or not CurrentMurderer:FindFirstChild("Humanoid") or CurrentMurderer.Humanoid.Health <= 0 then
        CurrentMurderer = GetMurderer()
        if not CurrentMurderer then
            if AutoShootEnabled then
                print("Убийца не найден! Ожидание...")
            end
            return false
        end
        print("Обнаружен новый убийца!")
        ShotCounter = 0
    end

    -- Проверяем видимость каждые SHOTS_BEFORE_CHECK выстрелов
    if ShotCounter % SHOTS_BEFORE_CHECK == 0 then
        if not CurrentMurderer:FindFirstChild("Humanoid") or CurrentMurderer.Humanoid.Health <= 0 then
            CurrentMurderer = nil
            return false
        end
    end

    -- Получаем позицию головы
    local headPosition = IsMurdererHeadVisible(CurrentMurderer)
    if not headPosition then
        return false
    end

    -- Производим выстрел
    SimulateShoot(headPosition)
    ShotCounter = ShotCounter + 1
    
    if ShotCounter % SHOTS_BEFORE_CHECK == 0 then
        print(string.format("Произведено %d выстрелов по убийце", ShotCounter))
    end
    
    return true
end

-- Функция для переключения режима авто-стрельбы
function ToggleAutoShoot(state)
    AutoShootEnabled = state
    
    if ShootingConnection then
        ShootingConnection:Disconnect()
        ShootingConnection = nil
    end
    
    if AutoShootEnabled then
        ShootingConnection = RunService.Heartbeat:Connect(function()
            ShootAtMurderer()
            task.wait(SHOOT_DELAY)
        end)
        print("Авто-стрельба ВКЛЮЧЕНА")
    else
        print("Авто-стрельба ВЫКЛЮЧЕНА")
    end
end

-- Привязка к клавише J
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.J and not gameProcessed then
        ToggleAutoShoot(not AutoShootEnabled)
    end
end)

print("Скрипт загружен. Нажмите J для включения/выключения авто-стрельбы")
