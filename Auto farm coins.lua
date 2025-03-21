-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

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

-- Переменная для хранения количества собранных монет
local coinsCollected = 0

-- Функция для поиска монет на текущей карте
function FindCoins()
    local currentMap = nil

    -- Определяем текущую карту
    for _, mapName in ipairs(maps) do
        if workspace:FindFirstChild(mapName) then
            currentMap = mapName
            break
        end
    end

    if not currentMap then
        return {}  -- Если карта не найдена, возвращаем пустой список
    end

    -- Ищем монеты на текущей карте
    local coinContainer = workspace[currentMap]:FindFirstChild("CoinContainer")
    if not coinContainer then
        return {}  -- Если контейнер с монетами не найден, возвращаем пустой список
    end

    local coins = {}
    for _, coin in pairs(coinContainer:GetChildren()) do
        if coin.Name == "Coin_Server" then
            table.insert(coins, coin)
        end
    end

    return coins
end

-- Функция для телепортации к монете и её сбора
function CollectCoin(coin)
    if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") and coin and coin.Parent then
        -- Телепортация к монете
        Plr.Character.HumanoidRootPart.CFrame = coin.CFrame
        task.wait(0.1)

        -- Симуляция сбора монеты
        firetouchinterest(Plr.Character.HumanoidRootPart, coin, 0)
        firetouchinterest(Plr.Character.HumanoidRootPart, coin, 1)
    end
end

-- Основная функция для автоматического сбора монет
function AutoFarmCoins()
    while coinsCollected < 39 do
        local coins = FindCoins()
        if #coins == 0 then
            break  -- Если монеты не найдены, завершаем цикл
        end

        for _, coin in pairs(coins) do
            if coinsCollected >= 39 then
                break  -- Если собрано 39 монет, завершаем цикл
            end

            if coin and coin.Parent then  -- Проверка, что монета существует
                CollectCoin(coin)
                coinsCollected = coinsCollected + 1
                task.wait(0.1)
            end
        end
    end

    -- После сбора 39 монет уничтожаем скрипт
    script:Destroy()
end

-- Запуск функции AutoFarmCoins
AutoFarmCoins()
