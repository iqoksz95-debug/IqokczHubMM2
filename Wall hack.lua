-- WALL HACK
local wallhackEnabled = false
local wallhackBind = "M"
local wallhackTransparency = 0.5

local function setWallsTransparency(transparency)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("wall") or part.Name:lower():find("part") or part.Name:lower():find("block")) then
            part.LocalTransparencyModifier = transparency
        end
    end
end

local wallhackToggle = createToggle(tabs[3], "Wall Hack", false, function(state)
    wallhackEnabled = state
    setWallsTransparency(wallhackEnabled and wallhackTransparency or 0)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode[wallhackBind:upper()] and not gameProcessed then
        wallhackEnabled = not wallhackEnabled
        setWallsTransparency(wallhackEnabled and wallhackTransparency or 0)
        if wallhackToggle:FindFirstChildOfClass("TextButton") then
            wallhackToggle:FindFirstChildOfClass("TextButton").BackgroundColor3 = wallhackEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        end
    end
end)
