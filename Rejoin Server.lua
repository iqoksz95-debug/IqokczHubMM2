-- Функция для повторного присоединения к игре
local function RejoinServer()
    game:GetService('TeleportService'):Teleport(game.PlaceId, Plr)
end
