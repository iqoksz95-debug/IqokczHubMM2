local AutoFarmEnabled = false
local coinsCollected = 0  -- Инициализация переменной для подсчета монет

-- Функция для поиска монет на карте
function FindCoins()
    local coins = {}
    for _, coin in pairs(workspace:GetChildren()) do
        if coin.Name == "Coin" and coin:IsA("BasePart") then
            table.insert(coins, coin)
        end
    end
    return coins
end

-- Функция для телепортации к монете и её сбора
function CollectCoin(coin)
    local Plr = game:GetService("Players").LocalPlayer
    if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") and coin then
        -- Телепортация к монете
        Plr.Character.HumanoidRootPart.CFrame = coin.CFrame
        task.wait(0.5)  -- Ожидание для сбора монеты

        -- Симуляция сбора монеты (если требуется)
        firetouchinterest(Plr.Character.HumanoidRootPart, coin, 0)
        firetouchinterest(Plr.Character.HumanoidRootPart, coin, 1)
    end
end

-- Функция для переключения Auto Farm
function ToggleAutoFarm(state)
    AutoFarmEnabled = state
    if state then
        coinsCollected = 0  -- Сброс счетчика монет при включении автофарма
        AutoFarmCoins()
    end
end

-- Основная функция для автоматического сбора монет
function AutoFarmCoins()
    while AutoFarmEnabled and coinsCollected < 40 do
        local coins = FindCoins()
        if #coins == 0 then
            warn("Монеты не найдены!")
            break
        end

        for _, coin in pairs(coins) do
            if not AutoFarmEnabled or coinsCollected >= 40 then
                break
            end

            if coin and coin.Parent then  -- Проверка, что монета существует
                CollectCoin(coin)
                coinsCollected = coinsCollected + 1
                print("Собрано монет: " .. coinsCollected)
                task.wait(1)  -- Ожидание перед сбором следующей монеты
            end
        end
    end

    if coinsCollected >= 40 then
        warn("Сбор монет завершен! Собрано: " .. coinsCollected)
    end
end

-- Пример использования:
ToggleAutoFarm(true)  -- Включить автофарм
