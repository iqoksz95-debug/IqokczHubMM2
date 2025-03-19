-- Функция для телепортации к убийце
local function TeleportToMurderer()
    Plr.Character.HumanoidRootPart.CFrame = GetMurderer() ~= nil and GetMurderer().HumanoidRootPart.CFrame or Plr.Character.HumanoidRootPart.CFrame
end
