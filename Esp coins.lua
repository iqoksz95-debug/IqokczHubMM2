local espEnabled = true
local espColor = Color3.fromRGB(255, 255, 255)  -- Белый цвет для подсветки монет

-- Подключаем CollectionService для поиска объектов по тегам
local CollectionService = game:GetService("CollectionService")

-- Функция для применения ESP к монетам
local function applyESP(coin)
    if not coin:FindFirstChild("ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.FillTransparency = 0.5  -- Полупрозрачная заливка
        highlight.OutlineColor = espColor
        highlight.OutlineTransparency = 0
        highlight.Parent = coin
        print("Подсветка применена к монете:", coin.Name)
    end
end

-- Функция для удаления ESP
local function removeESP(coin)
    if coin and coin:FindFirstChild("ESP") then
        coin.ESP:Destroy()
        print("Подсветка удалена с монеты:", coin.Name)
    end
end

-- Функция для поиска и подсветки монет
local function findAndHighlightCoins()
    while espEnabled do
        -- Ищем все объекты с тегом "Coin" (или другим, если он используется)
        for _, coin in ipairs(CollectionService:GetTagged("Coin")) do
            if coin:IsA("BasePart") then
                applyESP(coin)
            end
        end
        task.wait(1)  -- Проверяем монеты каждую секунду
    end
end

-- Функция для включения/выключения ESP
local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        print("ESP включен")
        coroutine.wrap(findAndHighlightCoins)()  -- Запускаем в отдельном потоке
    else
        print("ESP выключен")
        -- Удаляем ESP со всех монет
        for _, coin in ipairs(CollectionService:GetTagged("Coin")) do
            if coin:IsA("BasePart") then
                removeESP(coin)
            end
        end
    end
end

-- Обработка добавления новых монет
CollectionService:GetInstanceAddedSignal("Coin"):Connect(function(coin)
    if espEnabled and coin:IsA("BasePart") then
        applyESP(coin)
    end
end)

-- Обработка удаления монет
CollectionService:GetInstanceRemovedSignal("Coin"):Connect(function(coin)
    if coin:IsA("BasePart") then
        removeESP(coin)
    end
end)

-- Запуск ESP при старте
toggleESP(true)
