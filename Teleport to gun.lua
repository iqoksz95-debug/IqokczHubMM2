local Plr = game:GetService("Players").LocalPlayer
local maps = {
    "Hospital3", "Office3", "PoliceStation", "Factory", "ResearchFacility", 
    "Bank2", "Workplace", "House2", "Mansion2", "BioLab", "Hotel", "MilBase"
}

local function FindGunDrop(mapName)
    local map = workspace:FindFirstChild(mapName)
    return map and map:FindFirstChild("GunDrop")
end

local function TeleportToGun(gunDrop)
    if gunDrop and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        Plr.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        print("Телепортация к GunDrop выполнена на карте " .. gunDrop.Parent.Name)
    else
        warn("GunDrop не найден или у игрока нет персонажа!")
    end
end

local function SearchForGunDrop()
    for _, mapName in ipairs(maps) do
        local gunDrop = FindGunDrop(mapName)
        if gunDrop then
            TeleportToGun(gunDrop)
            return
        end
    end
    warn("GunDrop не найден ни на одной из карт!")
end

SearchForGunDrop()
