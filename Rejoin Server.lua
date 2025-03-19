-- Функция для повторного присоединения к игре
local function RejoinServer()
    task.wait(5)
    game:GetService('TeleportService'):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end
