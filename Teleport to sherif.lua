local function TeleportToSheriff()
    for i, v in game:GetService("Players"):GetChildren() do
        if v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then
            Plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            break
        end
    end
end
