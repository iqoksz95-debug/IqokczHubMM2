-- WALL HACK (PERMANENT)
local wallhackTransparency = 0.6 -- 60% прозрачность
local wallhackActive = true

-- Функция для установки прозрачности
local function setWallsTransparency()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = wallhackTransparency
        end
    end
end

-- Основной цикл обновления
local function wallhackLoop()
    while wallhackActive do
        setWallsTransparency()
        wait(1) -- Обновляем каждую секунду
    end
end

-- Обработка новых объектов
workspace.DescendantAdded:Connect(function(part)
    if part:IsA("BasePart") and wallhackActive then
        part.LocalTransparencyModifier = wallhackTransparency
    end
end)

-- Запускаем сразу
setWallsTransparency()
wallhackLoop()
