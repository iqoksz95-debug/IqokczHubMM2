-- DRAG FOV (автозапуск)
local dragFovEnabled = false
local dragFovSize = 150
local circleColor = Color3.fromHSV(0, 1, 1)

-- Получаем сервисы
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Создаем круг FOV
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DragFovGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local dragFovCircle = Instance.new("Frame")
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
stroke.Color = circleColor
stroke.Parent = dragFovCircle

-- Анимация цвета
local hue = 0
RunService.RenderStepped:Connect(function()
    if not dragFovEnabled then return end
    
    hue = (hue + 0.01) % 1
    stroke.Color = Color3.fromHSV(hue, 1, 1)
end)

-- Переключение по клавише B (опционально)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.B and not gameProcessed then
        dragFovEnabled = not dragFovEnabled
        dragFovCircle.Visible = dragFovEnabled
    end
end)

print("Drag FOV активен! (Нажмите B для скрытия/показа)")
