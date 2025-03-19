-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска шерифа
function GetSheriff()
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun"))) then
            return v.Character
        end
    end
    return nil
end

-- Телепорт к шерифу
local function TeleportToSheriff()
    for i, v in game:GetService("Players"):GetChildren() do
        if v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then
            Plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            break
        end
    end
end
