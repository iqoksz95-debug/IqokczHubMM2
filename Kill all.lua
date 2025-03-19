-- Функция для убийства всех игроков
local function KillAll()
    -- Получаем локального игрока
    local Plr = game:GetService("Players").LocalPlayer

    -- Проверяем, есть ли нож у игрока
    if not Plr.Backpack:FindFirstChild("Knife") and not Plr.Character:FindFirstChild("Knife") then
        warn("У вас нет ножа!")
        return
    end

    -- Перемещаем нож в руку, если он в рюкзаке
    if Plr.Backpack:FindFirstChild("Knife") then
        Plr.Backpack.Knife.Parent = Plr.Character
    end

    -- Проходим по всем игрокам
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        -- Пропускаем себя
        if v ~= Plr then
            -- Проверяем, есть ли персонаж у игрока
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                -- Телепортируемся к игроку
                Plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame

                -- Атакуем игрока
                local args = {
                    [1] = "Slash"
                }
                pcall(function()
                    Plr.Character.Knife:WaitForChild("Stab"):FireServer(unpack(args))
                end)

                -- Ждем перед следующей атакой
                task.wait(0.25)
            end
        end
    end
end
