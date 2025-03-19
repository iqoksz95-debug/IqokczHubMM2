-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для поиска убийцы
function GetMurderer()
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife"))) then
            return v.Character
        end
    end
    return nil
end

-- Функция для телепортации к убийце
local function TeleportToMurderer()
    Plr.Character.HumanoidRootPart.CFrame = GetMurderer() ~= nil and GetMurderer().HumanoidRootPart.CFrame or Plr.Character.HumanoidRootPart.CFrame
end
