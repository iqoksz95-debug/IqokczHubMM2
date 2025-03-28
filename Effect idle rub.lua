local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Усиленные настройки эффектов
local FOOTPRINT_LIFETIME = 12
local FOOTPRINT_COLOR = Color3.fromRGB(30, 30, 30) -- Ещё темнее
local FOOTPRINT_SIZE = Vector3.new(3, 0.15, 3) -- Увеличенный размер
local STEP_DISTANCE = 2.5 -- Более частые следы
local Y_OFFSET = 0.08 -- Выше над поверхностью
local IDLE_TIME_TO_STOP = 2

-- Таблица для хранения эффектов
local activeEffects = {}

local function createEnhancedFootprint()
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -10, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if not raycastResult then return end
    
    local hitPosition = raycastResult.Position + Vector3.new(0, Y_OFFSET, 0)
    local surfaceNormal = raycastResult.Normal

    -- Увеличенный контейнер для эффектов
    local effectHolder = Instance.new("Part")
    effectHolder.Anchored = true
    effectHolder.CanCollide = false
    effectHolder.Size = Vector3.new(0.1, 0.1, 0.1)
    effectHolder.Transparency = 1
    effectHolder.CFrame = CFrame.new(hitPosition, hitPosition + surfaceNormal) * CFrame.Angles(math.pi/2, 0, 0)
    effectHolder.Parent = workspace

    -- 1. Усиленная декаль (на 30% больше)
    local decal = Instance.new("Decal")
    decal.Texture = "rbxassetid://748871152"
    decal.Color3 = FOOTPRINT_COLOR
    decal.Transparency = 0.25 -- Менее прозрачная
    decal.Face = Enum.NormalId.Top
    decal.Parent = effectHolder

    -- 2. Увеличенный дым (в 1.5 раза больше)
    local smoke = Instance.new("ParticleEmitter")
    smoke.Texture = "rbxassetid://243664672"
    smoke.Color = ColorSequence.new(FOOTPRINT_COLOR)
    smoke.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.2), -- Стартовый размер увеличен
        NumberSequenceKeypoint.new(1, 3) -- Конечный размер увеличен
    })
    smoke.LightEmission = 0.7 -- Ярче
    smoke.Lifetime = NumberRange.new(2, 4) -- Дольше живут
    smoke.Speed = NumberRange.new(0.5, 1.5) -- Быстрее
    smoke.Rate = 35 -- Больше частиц
    smoke.Rotation = NumberRange.new(0, 360)
    smoke.Parent = effectHolder

    -- 3. Увеличенные пузыри
    local bubbles = Instance.new("ParticleEmitter")
    bubbles.Texture = "rbxassetid://242487999"
    bubbles.Color = ColorSequence.new(Color3.new(0.25, 0.25, 0.25)) -- Темнее
    bubbles.Size = NumberSequence.new(0.6) -- Крупнее
    bubbles.LightEmission = 0.4 -- Ярче
    bubbles.Lifetime = NumberRange.new(1.5) -- Дольше
    bubbles.Speed = NumberRange.new(0.7) -- Быстрее
    bubbles.Rate = 20 -- Больше
    bubbles.Parent = effectHolder

    -- 4. Усиленное мерцание
    local glow = Instance.new("ParticleEmitter")
    glow.Texture = "rbxassetid://296874871"
    glow.Color = ColorSequence.new(Color3.new(0.8, 0.8, 0.8)) -- Ярче
    glow.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5), -- Крупнее
        NumberSequenceKeypoint.new(1, 1)
    })
    glow.LightEmission = 1.2 -- Сильнее свечение
    glow.Lifetime = NumberRange.new(0.7, 1.3) -- Дольше
    glow.Speed = NumberRange.new(0.15) -- Медленнее
    glow.Rate = 25 -- Больше
    glow.Parent = effectHolder

    table.insert(activeEffects, {
        Holder = effectHolder,
        Emitters = {smoke, bubbles, glow}
    })

    Debris:AddItem(effectHolder, FOOTPRINT_LIFETIME)
end

-- Функция управления видимостью эффектов
local function toggleEffects(state)
    for _, effect in ipairs(activeEffects) do
        if effect.Holder and effect.Holder.Parent then
            for _, emitter in ipairs(effect.Emitters) do
                emitter.Enabled = state
            end
        end
    end
end

-- Отслеживание движения с улучшенной логикой
local lastPosition = rootPart.Position
local lastMoveTime = os.clock()
local isMoving = false

RunService.Heartbeat:Connect(function()
    local currentPosition = rootPart.Position
    local distance = (currentPosition - lastPosition).Magnitude

    if distance > 0.1 then
        lastMoveTime = os.clock()
        if not isMoving then
            isMoving = true
            toggleEffects(true)
        end

        if distance > STEP_DISTANCE then
            createEnhancedFootprint()
            lastPosition = currentPosition
        end
    elseif isMoving and (os.clock() - lastMoveTime) > IDLE_TIME_TO_STOP then
        isMoving = false
        toggleEffects(false)
    end
end)

-- Улучшенная очистка
player.CharacterRemoving:Connect(function()
    for _, effect in ipairs(activeEffects) do
        if effect.Holder then
            effect.Holder:Destroy()
        end
    end
    activeEffects = {}
end)
