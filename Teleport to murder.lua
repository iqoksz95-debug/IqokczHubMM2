local Plr = game:GetService("Players").LocalPlayer

local function GetMurderer()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= Plr then
            if (v.Backpack:FindFirstChild("Knife")) or (v.Character and v.Character:FindFirstChild("Knife")) then
                return v.Character
            end
        end
    end
    return nil
end

local function TeleportToPlayer(player)
    if player and player:FindFirstChild("HumanoidRootPart") then
        Plr.Character.HumanoidRootPart.CFrame = player.HumanoidRootPart.CFrame
        print("Телепорт к игроку выполнен!")
    else
        warn("Игрок не найден или у него нет HumanoidRootPart.")
    end
end

local murderer = GetMurderer()
if murderer then
    TeleportToPlayer(murderer)
else
    warn("Убийца не найден.")
end
