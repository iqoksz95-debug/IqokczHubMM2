local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Настройки эффектов ХОДЬБЫ
local FOOTPRINT_LIFETIME = 10
local FOOTPRINT_COLOR = Color3.fromRGB(40, 40, 40)
local FOOTPRINT_SIZE = Vector3.new(3, 0.1, 3)
local STEP_DISTANCE = 3
local Y_OFFSET = 0.05

-- Настройки эффектов ПРЫЖКА
local JUMP_CLOUD_LIFETIME = 5
local JUMP_CLOUD_COLOR = Color3.fromRGB(200, 200, 200) -- Бело-серый
local JUMP_CLOUD_SIZE = Vector3.new(4, 2, 4)
local JUMP_EFFECT_HEIGHT = 5 -- Высота, с которой начинается падение

-- Общие переменные
local activeEffects = {}
local lastPosition = rootPart.Position
local isJumping = false
local jumpStartHeight = 0

-- Функция создания облака при падении
local function createJumpCloud(position)
    local cloud = Instance.new("Part")
    cloud.Anchored = true
    cloud.CanCollide = false
    cloud.Size = JUMP_CLOUD_SIZE
    cloud.Transparency = 1
    cloud.Position = position
    cloud.Parent = workspace

    -- Основное облако
    local cloudParticle = Instance.new("ParticleEmitter")
    cloudParticle.Texture = "rbxassetid://243664672" -- Дымовая текстура
    cloudParticle.Color = ColorSequence.new(JUMP_CLOUD_COLOR)
    cloudParticle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 5)
    })
    cloudParticle.LightEmission = 0.8
    cloudParticle.Lifetime = NumberRange.new(1.5, 3)
    cloudParticle.Speed = NumberRange.new(0.5)
    cloudParticle.Rate = 30
    cloudParticle.Parent = cloud

    -- Дополнительный туман
    local fogParticle = Instance.new("ParticleEmitter")
    fogParticle.Texture = "rbxassetid://296874871" -- Мягкая текстура
    fogParticle.Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9))
    fogParticle.Size = NumberSequence.new(3)
    fogParticle.LightEmission = 1
    fogParticle.Lifetime = NumberRange.new(2)
    fogParticle.Speed = NumberRange.new(0.2)
    fogParticle.Rate = 20
    fogParticle.Parent = cloud

    Debris:AddItem(cloud, JUMP_CLOUD_LIFETIME)
end

-- Отслеживание прыжка
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping then
        isJumping = true
        jumpStartHeight = rootPart.Position.Y
    elseif newState == Enum.HumanoidStateType.Freefall then
        -- Создаём облако при начале падения
        createJumpCloud(rootPart.Position + Vector3.new(0, -2, 0))
    elseif newState == Enum.HumanoidStateType.Landed then
        isJumping = false
    end
end)
