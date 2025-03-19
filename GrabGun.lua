-- Функция для подбора оружия
local function GrabGun()
    pcall(function()
        Plr.Character.HumanoidRootPart.CFrame = workspace.GunDrop.CFrame
    end)
end
