-- DRAG FOV
local dragFovEnabled = false
local dragFovBind = "B"
local dragFovCircle = nil
local dragFovSize = 150

local function createDragFov()
    if dragFovCircle then dragFovCircle:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DragFovGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    dragFovCircle = Instance.new("Frame")
    dragFovCircle.Size = UDim2.new(0, dragFovSize * 2, 0, dragFovSize * 2)
    dragFovCircle.Position = UDim2.new(0.59, -dragFovSize, 0.67, -dragFovSize)
    dragFovCircle.AnchorPoint = Vector2.new(0.59, 0.67)
    dragFovCircle.BackgroundTransparency = 1
    dragFovCircle.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dragFovCircle
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 0, 255)
    stroke.Parent = dragFovCircle
    
    -- Анимация цвета
    local hue = 0
    RunService.RenderStepped:Connect(function()
        if not dragFovEnabled or not dragFovCircle then return end
        hue = (hue + 0.01) % 1
        stroke.Color = Color3.fromHSV(hue, 1, 1)
    end)
end

local dragFovToggle = createToggle(tabs[2], "Drag Fov", false, function(state)
    dragFovEnabled = state
    if dragFovEnabled then
        createDragFov()
    elseif dragFovCircle then
        dragFovCircle:Destroy()
        dragFovCircle = nil
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode[dragFovBind:upper()] and not gameProcessed then
        dragFovEnabled = not dragFovEnabled
        if dragFovEnabled then
            createDragFov()
        elseif dragFovCircle then
            dragFovCircle:Destroy()
            dragFovCircle = nil
        end
        if dragFovToggle:FindFirstChildOfClass("TextButton") then
            dragFovToggle:FindFirstChildOfClass("TextButton").BackgroundColor3 = dragFovEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        end
    end
end)
