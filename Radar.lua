-- RADAR
local radarEnabled = false
local radarBind = "N"
local radarGui = nil
local lastRadarUpdate = 0

local function createRadar()
    if radarGui then radarGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RadarGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    radarGui = Instance.new("Frame")
    radarGui.Size = UDim2.new(0, 200, 0, 200)
    radarGui.Position = UDim2.new(0, 10, 0.5, -100)
    radarGui.BackgroundColor3 = Color3.new(0, 0, 0)
    radarGui.BackgroundTransparency = 0.5
    radarGui.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = radarGui
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = radarGui
    
    -- Центральные линии
    local xLine = Instance.new("Frame")
    xLine.Size = UDim2.new(1, 0, 0, 1)
    xLine.Position = UDim2.new(0, 0, 0.5, 0)
    xLine.BackgroundColor3 = Color3.new(1, 1, 1)
    xLine.Parent = radarGui
    
    local yLine = Instance.new("Frame")
    yLine.Size = UDim2.new(0, 1, 1, 0)
    yLine.Position = UDim2.new(0.5, 0, 0, 0)
    yLine.BackgroundColor3 = Color3.new(1, 1, 1)
    yLine.Parent = radarGui
    
    return radarGui
end

local function updateRadar()
    if not radarGui then return end
    
    -- Очищаем старые точки
    for _, child in ipairs(radarGui:GetChildren()) do
        if child.Name == "PlayerDot" then
            child:Destroy()
        end
    end
    
    local localPlayer = LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return end
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    -- Добавляем себя (синяя точка)
    local selfDot = Instance.new("Frame")
    selfDot.Name = "PlayerDot"
    selfDot.Size = UDim2.new(0, 6, 0, 6)
    selfDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    selfDot.BackgroundColor3 = Color3.new(0, 0, 1)
    selfDot.Parent = radarGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = selfDot
    
    -- Добавляем других игроков (красные точки)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local relativePos = root.Position - localRoot.Position
                    local x = relativePos.X / 50 -- масштабирование
                    local z = relativePos.Z / 50
                    
                    -- Ограничиваем точки границами радара
                    x = math.clamp(x, -90, 90)
                    z = math.clamp(z, -90, 90)
                    
                    local dot = Instance.new("Frame")
                    dot.Name = "PlayerDot"
                    dot.Size = UDim2.new(0, 6, 0, 6)
                    dot.Position = UDim2.new(0.5, x - 3, 0.5, z - 3)
                    dot.BackgroundColor3 = Color3.new(1, 0, 0)
                    dot.Parent = radarGui
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = dot
                end
            end
        end
    end
end

local radarToggle = createToggle(tabs[3], "Radar", false, function(state)
    radarEnabled = state
    if radarEnabled then
        createRadar()
    elseif radarGui then
        radarGui:Destroy()
        radarGui = nil
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode[radarBind:upper()] and not gameProcessed then
        radarEnabled = not radarEnabled
        if radarEnabled then
            createRadar()
        elseif radarGui then
            radarGui:Destroy()
            radarGui = nil
        end
        if radarToggle:FindFirstChildOfClass("TextButton") then
            radarToggle:FindFirstChildOfClass("TextButton").BackgroundColor3 = radarEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        end
    end
end)
