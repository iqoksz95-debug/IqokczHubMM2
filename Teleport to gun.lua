local function TeleportToGun()
    local gunDrop = workspace:FindFirstChild("GunDrop")
    if gunDrop then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)  -- Добавляем небольшое смещение, чтобы игрок не застрял в пистолете
        end
    else
        warn("Пистолет не найден на карте!")
    end
end
