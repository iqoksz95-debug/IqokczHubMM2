local AutoFarmEnabled = false

-- Функция для переключения Auto Farm
function ToggleAutoFarm(state)
    AutoFarmEnabled = state
    if state then
        AutoFarmCoins()
    end
end

-- Измененная функция AutoFarmCoins
function AutoFarmCoins()
    while AutoFarmEnabled and coinsCollected < 40 do
        local coins = FindCoins()
        if #coins == 0 then
            warn("Монеты не найдены!")
            break
        end

        for _, coin in pairs(coins) do
            if coinsCollected >= 40 then
                break
            end

            TeleportToCoin(coin)
            coinsCollected = coinsCollected + 1
            print("Собрано монет: " .. coinsCollected)
        end
    end

    if coinsCollected >= 40 then
        warn("Сбор монет завершен! Собрано: " .. coinsCollected)
    end
end

-- Пример создания переключателя в GUI
local win = DiscordLib:Window("Murder Mystery 2")
local serv = win:Server("ByteHub", "http://www.roblox.com/asset/?id=6031075938")
local Main = serv:Channel("Main")

Main:Toggle("Auto Farm Coins", false, ToggleAutoFarm)
