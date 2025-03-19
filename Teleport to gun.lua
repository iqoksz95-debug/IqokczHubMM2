local function TeleportToGun()
    local gunDrop = workspace:FindFirstChild("GunDrop")  -- Ищем пистолет на карте
    if gunDrop then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Телепортируем игрока к пистолету с небольшим смещением
            player.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
            print("Телепортация к пистолету выполнена!")
        else
            warn("У игрока нет персонажа или HumanoidRootPart!")
        end
    else
        warn("Пистолет не найден на карте!")
    end
end

-- Выполняем телепортацию один раз при запуске скрипта
TeleportToGun()
