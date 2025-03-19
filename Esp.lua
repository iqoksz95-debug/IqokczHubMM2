local espEnabled = true
local espColor = Color3.fromRGB(255, 255, 255)

-- Функция для проверки роли игрока
local function getPlayerRole(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return "Murder"
    elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return "Sherif"
    else
        return "Innocent"
    end
end

-- Функция для применения ESP с учетом роли
local function applyESP(character, player)
    if not character:FindFirstChild("ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.FillTransparency = 1
        highlight.OutlineColor = espColor
        highlight.Parent = character
    end
    
    if not character:FindFirstChild("ESPName") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = character

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = espColor
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 20
        nameLabel.Parent = billboard
    end

    -- Обновляем цвет в зависимости от роли
    local role = getPlayerRole(player)
    if role == "Murder" then
        character.ESP.OutlineColor = Color3.fromRGB(255, 0, 0)
        character.ESPName.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    elseif role == "Sherif" then
        character.ESP.OutlineColor = Color3.fromRGB(0, 0, 255)
        character.ESPName.TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
    else
        character.ESP.OutlineColor = Color3.fromRGB(255, 255, 255)
        character.ESPName.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Функция для удаления ESP
local function removeESP(character)
    if character then
        local esp = character:FindFirstChild("ESP")
        if esp then
            esp:Destroy()
        end
        local espName = character:FindFirstChild("ESPName")
        if espName then
            espName:Destroy()
        end
    end
end

-- Функция для обработки добавления персонажа
local function onCharacterAdded(character, player)
    if espEnabled then
        applyESP(character, player)
    end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            removeESP(character)
        end)
    end
end

-- Функция для создания ESP для игрока
local function createESP(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            onCharacterAdded(character, player)
        end)
        if player.Character then
            onCharacterAdded(player.Character, player)
        end
    end
end

-- Обработка добавления и удаления игроков
game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player.Character)
end)

-- Применение ESP для всех игроков при запуске
for _, player in ipairs(game.Players:GetPlayers()) do
    createESP(player)
end
