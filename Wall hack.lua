-- WALL HACK
local wallhackTransparency = 0.6 -- 60% прозрачность

local function setWallsTransparency(transparency)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Делаем прозрачными все BasePart (стены, полы, платформы и т.д.)
            part.LocalTransparencyModifier = transparency
        end
    end
end

-- Включаем wallhack сразу при запуске скрипта
setWallsTransparency(wallhackTransparency)

-- Опционально: можно добавить автоматическое обновление для новых частей
workspace.DescendantAdded:Connect(function(part)
    if part:IsA("BasePart") then
        part.LocalTransparencyModifier = wallhackTransparency
    end
end)
