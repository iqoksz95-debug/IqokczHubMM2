local Plr = game:GetService("Players").LocalPlayer

local function GetSheriff()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= Plr then
            if (v.Backpack:FindFirstChild("Gun")) or (v.Character and v.Character:FindFirstChild("Gun")) then
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

local sheriff = GetSheriff()
if sheriff then
    TeleportToPlayer(sheriff)
else
    warn("Шериф не найден.")
end
