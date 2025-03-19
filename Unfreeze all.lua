local function UnfreezeAll()
    for i, v in game:GetService("Players"):GetChildren() do
        if v ~= Plr and not v.Backpack:FindFirstChild("Knife") or v.Character and not v.Character:FindFirstChild("Knife") then
            Plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            task.wait(.75)
        end
    end
end
