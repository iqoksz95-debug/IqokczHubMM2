local function FreezeAll()
    for i, v in game:GetService("Players"):GetChildren() do
        if v ~= Plr and not v.Backpack:FindFirstChild("Knife") or v.Character and not v.Character:FindFirstChild("Knife") then
            if Plr.Backpack:FindFirstChild("Knife") then 
                Plr.Backpack.Knife.Parent = Plr.Character 
            end
            Plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            local args = {
                [1] = "Slash"
            }
            Plr.Character.Knife:WaitForChild("Stab"):FireServer(unpack(args))
            task.wait(.25)
        end
    end
end
