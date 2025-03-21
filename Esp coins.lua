local espEnabled = true
local espColor = Color3.fromRGB(255, 255, 255)  -- Белый цвет для подсветки монет

-- Список карт, на которых могут появляться монеты
local maps = {
    "Hospital3",
    "Office3",
    "PoliceStation",
    "Factory",
    "ResearchFacility",
    "Bank2",
    "Workplace",
    "House2",
    "Mansion2",
    "BioLab",
    "Hotel",
    "MilBase"
}

-- Функция для применения ESP к монетам
local function applyESP(coin)
    if not coin:FindFirstChild("ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.FillTransparency = 1
        highlight.OutlineColor = espColor
        highlight.Parent = coin
    end
end

-- Функция для удаления ESP
local function removeESP(coin)
    if coin then
        local esp = coin:FindFirstChild("ESP")
        if esp then
            esp:Destroy()
        end
    end
end

-- Функция для поиска и подсветки монет на карте
local function findAndHighlightCoins(map)
    local coinContainer = workspace:FindFirstChild(map)
    if coinContainer then
        local coinServer = coinContainer:FindFirstChild("Coincontainer")
        if coinServer then
            for _, coin in pairs(coinServer:GetChildren()) do
                if coin.Name == "Coin_Server" then
                    applyESP(coin)
                end
            end
        end
    end
end

-- Функция для обновления ESP на всех картах
local function updateESP()
    while espEnabled do
        for _, map in ipairs(maps) do
            findAndHighlightCoins(map)
        end
        wait(1)  -- Проверяем монеты каждую секунду
    end
end

-- Обработка смерти и возрождения игрока
local function handlePlayerDeath()
    local Plr = game:GetService("Players").LocalPlayer
    local humanoid = Plr.Character and Plr.Character:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid.Died:Connect(function()
            espEnabled = false  -- Отключаем ESP при смерти
            for _, map in ipairs(maps) do
                local coinContainer = workspace:FindFirstChild(map)
                if coinContainer then
                    local coinServer = coinContainer:FindFirstChild("Coincontainer")
                    if coinServer then
                        for _, coin in pairs(coinServer:GetChildren()) do
                            if coin.Name == "Coin_Server" then
                                removeESP(coin)
                            end
                        end
                    end
                end
            end
        end)
        
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health > 0 then
                espEnabled = true  -- Включаем ESP при возрождении
                updateESP()
            end
        end)
    end
end

-- Запуск ESP при старте
updateESP()

-- Обработка смерти игрока
handlePlayerDeath()
