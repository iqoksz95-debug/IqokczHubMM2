-- RADAR
local radarEnabled = true
local radarGui = nil
local radarScreenGui = nil
local dragging = false
local dragInput, dragStart, startPos

-- Переменные для отслеживания движения
local lastPlayerPosition = Vector3.new(0, 0, 0)
local positionChanged = false
local selfDot = nil

local function createRadar()
    if radarScreenGui then radarScreenGui:Destroy() end
    
    radarScreenGui = Instance.new("ScreenGui")
    radarScreenGui.Name = "RadarGui"
    radarScreenGui.ResetOnSpawn = false
    radarScreenGui.Parent = game:GetService("CoreGui")
    
    radarGui = Instance.new("Frame")
    radarGui.Size = UDim2.new(0, 200, 0, 200)
    radarGui.Position = UDim2.new(0, 10, 0.5, -100)
    radarGui.BackgroundColor3 = Color3.new(0, 0, 0)
    radarGui.BackgroundTransparency = 0.5
    radarGui.Parent = radarScreenGui
    
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
    
    -- Создаем синюю точку (игрока) один раз
    selfDot = Instance.new("Frame")
    selfDot.Name = "PlayerDot_Self"
    selfDot.Size = UDim2.new(0, 6, 0, 6)
    selfDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    selfDot.BackgroundColor3 = Color3.new(0, 0, 1)
    selfDot.ZIndex = 10
    selfDot.Parent = radarGui
    
    local selfCorner = Instance.new("UICorner")
    selfCorner.CornerRadius = UDim.new(1, 0)
    selfCorner.Parent = selfDot
    
    -- Функционал перемещения радара
    radarGui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = radarGui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    radarGui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            radarGui.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function updateRadar()
    if not radarGui then return end
    
    local localPlayer = game:GetService("Players").LocalPlayer
    if not localPlayer then return end
    
    local localCharacter = localPlayer.Character
    if not localCharacter then return end
    
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    -- Определяем изменение позиции игрока
    local currentPosition = localRoot.Position
    positionChanged = (currentPosition - lastPlayerPosition).Magnitude > 0.1
    lastPlayerPosition = currentPosition
    
    -- Обновляем только если позиция изменилась
    if positionChanged then
        -- Очищаем только красные точки
        for _, child in ipairs(radarGui:GetChildren()) do
            if child.Name == "PlayerDot" then
                child:Destroy()
            end
        end
        
        -- Обновляем красные точки
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local relativePos = root.Position - currentPosition
                        local x = relativePos.X / 50
                        local z = relativePos.Z / 50
                        
                        x = math.clamp(x, -90, 90)
                        z = math.clamp(z, -90, 90)
                        
                        local dot = Instance.new("Frame")
                        dot.Name = "PlayerDot"
                        dot.Size = UDim2.new(0, 6, 0, 6)
                        dot.Position = UDim2.new(0.5, x - 3, 0.5, z - 3)
                        dot.BackgroundColor3 = Color3.new(1, 0, 0)
                        dot.Parent = radarGui
                        
                        local dotCorner = Instance.new("UICorner")
                        dotCorner.CornerRadius = UDim.new(1, 0)
                        dotCorner.Parent = dot
                    end
                end
            end
        end
    end
end

-- Инициализация радара
createRadar()

-- Обновление радара с максимальной частотой
game:GetService("RunService").Heartbeat:Connect(function()
    updateRadar()
end)
