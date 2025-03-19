-- Функция для автоматической стрельбы по убийце
local function AutoShootMurderer()
    if ASM and Plr.Character and GetMurderer() and Plr.Character:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Gun") then
        if Plr.Backpack:FindFirstChild("Gun") then 
            Plr.Backpack.Gun.Parent = Plr.Character 
        end
        local Murd = GetMurderer()
        Plr.Character.HumanoidRootPart.CFrame = Murd.HumanoidRootPart.CFrame - Murd.Head.CFrame.LookVector*10
        Plr.Character.Gun.KnifeServer.ShootGun:InvokeServer(1, Murd.HumanoidRootPart.Position, "AH")
    end
    task.wait(.5)
end
