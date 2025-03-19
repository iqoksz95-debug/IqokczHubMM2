local function TeleportToGun()
    pcall(function()
        Plr.Character.HumanoidRootPart.CFrame = workspace.GunDrop.CFrame
    end)
end
